#!/usr/bin/env python
import logging, os, sys
import shutil, time

COPYLIST_FILE='copylist'
homeDirectory = ''

def backupPath(base, relPath):
  error = 0
  d = os.path.join(homeDirectory, '.sweet-home')
  if not os.path.exists(d):
    os.mkdir(d)
  tm = time.localtime()
  d = os.path.join(homeDirectory, '.sweet-home', "backup-%04d%02d%02d%02d%02d" % (tm.tm_year, tm.tm_mon, tm.tm_mday, tm.tm_hour, tm.tm_min))
  if not os.path.exists(d):
    os.mkdir(d)
  dest = os.path.join(d, relPath)
  src = os.path.join(base, relPath)
  if os.path.isdir(src):
    shutil.copytree(src, dest, True)
  elif os.path.isfile(src):
    # make sure path exists
    if not os.path.exists(os.path.dirname(dest)):
      os.makedirs(os.path.dirname(dest))
    shutil.copy(src, dest)
  return True

def copyFiles(copyList, destDir):
  overwriteAll = False
  for e in copyList:
    dest = os.path.join(destDir, e[1])
    if os.path.exists(dest):
      ans = None
      if not overwriteAll:
        while 1:
          ans = raw_input('%s already exists overwrite (yes/no) ? [y/n/a]' % dest)
          if ans and ans[0] in ('y', 'n', 'a'):
            break
          print 'Please respond y, n!'
        if ans and ans[0] == 'n':
          continue
        if ans and ans[0] == 'a':
          overwriteAll = True
      backupPath(destDir, e[1])
      if os.path.isdir(dest):
        shutil.rmtree(dest)
      elif os.path.isfile(dest):
        os.remove(dest)

    logging.info('copying %s to %s' % (e[0], dest))
    if os.path.isdir(e[0]):
      shutil.copytree(e[0], dest, True)
    elif os.path.isfile(e[0]):
      pathOnly = os.path.dirname(dest)
      if pathOnly and not os.path.exists(pathOnly):
        os.makedirs(pathOnly)
      shutil.copy2(e[0], dest)
    else:
      logging.warn('entry %s is neither file nor directory' % e[0])
  pass

def loadCopyList():
  f = open(COPYLIST_FILE)
  copyList = []
  for l in f:
    if not l.strip():
      continue # skip empty lines
    t = l.strip()
    if t.find('\t') >= 0:
      arr = t.split('\t')
      if not (arr[0].strip() and arr[1].strip()):
        logging.warn("Empty entries '%s' and '%s'" % (arr[0], arr[1]))
        continue
      copyList.append( (arr[0], arr[1]) )
    else:
      if not t.strip():
        logging.warn("Empty entry '%s'" % t)
        continue
      copyList.append( (t, t) )
  f.close()
  return copyList

def verifyCopyList(copyList):
  copyListFiles = [x[0] for x in copyList]
  entries = os.listdir('.')
  entries.sort()
  for e in entries:
    if e in ('.', '..', '.git', 'configure.py', COPYLIST_FILE):
      continue
    if e not in copyListFiles:
      logging.warn('%s not mentioned in %s' % (e, COPYLIST_FILE))

def main():
  global homeDirectory
  FORMAT = "%(levelname)s: %(message)s"
  logging.basicConfig(format=FORMAT, level=logging.DEBUG)
  copyList = loadCopyList()
  verifyCopyList(copyList)
  homeDirectory = os.getenv('HOME')
  logging.info('HOME is %s' % homeDirectory)

  if sys.argv[1:]:
    lst = [x for x in copyList if x[0] in sys.argv[1:]]
    print 'copyFiles for', lst
    copyFiles(lst, homeDirectory)
  else:
    copyFiles(copyList, homeDirectory)

if __name__ == '__main__':
	main()
