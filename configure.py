#!/usr/bin/env python
import logging, os
import shutil

COPYLIST_FILE='copylist.txt'

def copyFiles(copyList, destDir):
	answerAll = False
	for e in copyList:
		dest = os.path.join(destDir, e[1])
		if os.path.exists(dest):
			if not answerAll:
				ans = None
				while 1:
					ans = raw_input('%s already exists overwrite (yes/no/all) ? [y/n/a]' % dest)
					if ans and ans[0] in ('y', 'n', 'a'):
						break
					print 'Please respond y, n  or a!'
				if ans and ans[0] == 'n':
					continue
				if ans and ans[0] == 'a':
					answerAll = True

		print 'copying %s to %s' % (e[0], dest)
		if os.path.isdir(e[0]):
			shutil.copytree(e[0], dest)
		elif os.path.isfile(e[0]):
			shutil.copy(e[0], dest)
		else:
			logging.warn('entry %s is neither file nor directory' % e[0])
	pass

def main():
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

	homeDir = os.getenv('HOME')
	logging.info('HOME is %s' % homeDir)
	copyFiles(copyList, homeDir)

if __name__ == '__main__':
	main()
