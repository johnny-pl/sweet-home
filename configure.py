#!/usr/bin/env python
import logging, os
import shutil, time

COPYLIST_FILE='copylist.txt'
homeDirectory = ''

def backupPath(path):
	try:
		error = 0
		d = os.path.join(homeDirectory, '.sweet-home')
		if not os.path.exists(d):
			os.mkdir(d)
		tm = time.localtime()
		d = os.path.join(homeDirectory, '.sweet-home', "backup-%04d%02d%02d%02d%02d" % (tm.tm_year, tm.tm_mon, tm.tm_mday, tm.tm_hour, tm.tm_min))
		if not os.path.exists(d):
			os.mkdir(d)
		_, tail = os.path.split(path)
		destPath = os.path.join(d, tail)
		if os.path.isdir(path):
			shutil.copytree(path, destPath)
		elif os.path.isfile(path):
			shutil.copy(path, destPath)
	except:
		return False
	return True

def copyFiles(copyList, destDir):
	for e in copyList:
		dest = os.path.join(destDir, e[1])
		if os.path.exists(dest):
			ans = None
			while 1:
				ans = raw_input('%s already exists overwrite (yes/no) ? [y/n]' % dest)
				if ans and ans[0] in ('y', 'n'):
					break
				print 'Please respond y, n!'
			if ans and ans[0] == 'n':
				continue
			backupPath(dest)
			shutil.rmtree(dest)

		print 'copying %s to %s' % (e[0], dest)
		if os.path.isdir(e[0]):
			shutil.copytree(e[0], dest)
		elif os.path.isfile(e[0]):
			shutil.copy(e[0], dest)
		else:
			logging.warn('entry %s is neither file nor directory' % e[0])
	pass

def main():
	global homeDirectory
	FORMAT = "%(levelname)s: %(message)s"
	logging.basicConfig(format=FORMAT, level=logging.DEBUG)
	f = open(COPYLIST_FILE)
	copyList = []
	for l in f:
		t = l.strip()
		if t.find('\t') >= 0:
			arr = t.split('\t')
			copyList.append( (arr[0], arr[1]) )
		else:
			copyList.append( (t, t) )
	f.close()
	entries = os.listdir('.')
	entries.sort()
	copyListFiles = [x[0] for x in copyList]
	for e in entries:
		if e in ('.', '..', '.git', 'configure.py', COPYLIST_FILE):
			continue
		if e not in copyListFiles:
			logging.warn('%s not mentioned in %s' % (e, COPYLIST_FILE))

	homeDirectory = os.getenv('HOME')
	logging.info('HOME is %s' % homeDirectory)
	copyFiles(copyList, homeDirectory)

if __name__ == '__main__':
	main()
