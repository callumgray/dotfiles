#!/usr/bin/env python2
#-*- coding: utf-8 -*-
#
# .anowplaying.py
#
#  Connects to dbus and retrieves
#  information about the currently
#  playing track in clementine.
#

import dbus, optparse, shutil, commands, os

if __name__ == '__main__':
    '''Check if clementine is running'''
    output = commands.getoutput('ps -A')
    if 'clementine' not in output:
        raise SystemExit

    '''Get system bus'''
    bus = dbus.SessionBus()
    clem = bus.get_object('org.mpris.clementine', '/Player', 'org.freedesktop.MediaPlayer')
    clemdict = clem.GetMetadata()

    '''Set up the command line parser'''
    usage = 'usage: %prog [options]'
    parser = optparse.OptionParser(usage=usage)
    parser.add_option('-a',  '--artist',  action='store_true', help='artist name')
    parser.add_option('-t',  '--title',   action='store_true', help='title of the track')
    parser.add_option('-l',  '--album',   action='store_true', help='album name')
    parser.add_option('-g',  '--genre',   action='store_true', help='genre of the current track')
    parser.add_option('-y',  '--year',    action='store_true', help='year of the track')
    parser.add_option('-m',  '--mtime',    action='store_true', help='time of the track')
    parser.add_option('-r',  '--rtime',    action='store_true', help='remaining time for the track')
    parser.add_option('-e',  '--etime',    action='store_true', help='elapsed time for the track')
    parser.add_option('-p',  '--progress',    action='store_true', help='progress of the track')
    parser.add_option('-n',  '--track',   action='store_true', help='track number')
    parser.add_option('-b',  '--bitrate', action='store_true', help='bitrate of the track')
    parser.add_option('-s',  '--sample',  action='store_true', help='sample rate of the track')
    parser.add_option('-c',  '--cover',   metavar='filename',  help='copy cover art to destination file')
    
    '''Get the parser options printed'''
    (opts, args) = parser.parse_args()
    if opts.artist and clemdict.has_key('artist') :
        print clemdict['artist'].encode('utf-8')
    if opts.title and clemdict.has_key('title'):
        print clemdict['title'].encode('utf-8')
    if opts.album and clemdict.has_key('album'):
        print clemdict['album'].encode('utf-8')
    if opts.genre and clemdict.has_key('genre'):
        print clemdict['genre']
    if opts.year and clemdict.has_key('year'):
        print clemdict['year']
    if opts.track and clemdict.has_key('tracknumber'):
        print clemdict['tracknumber']
    if opts.bitrate and clemdict.has_key('audio-bitrate'):
        print clemdict['audio-bitrate']
    if opts.sample :
        print clemdict['audio-samplerate']

    '''Manage time stuff'''
    cpos = mt = mtime = etime = rtime = progress = None
    if (opts.etime or opts.rtime or opts.mtime or opts.progress) and clemdict.has_key('mtime'):
        cpos    = clem.PositionGet()/1000
        mt      = clemdict['mtime']/1000
        mtime   = str(mt/60)+":"+str(mt%60) if mt%60>9 else str(mt/60)+":0"+str(mt%60)
        etime   = str(cpos/60)+":"+str(cpos%60) if cpos%60>9 else  str(cpos/60)+":0"+str(cpos%60)
        rtime   = str((mt-cpos)/60)+":"+str((mt-cpos)%60) if (mt-cpos)%60>9 else str((mt-cpos)/60)+":0"+str((mt-cpos)%60)
        progress= float(cpos)/float(mt)*100
    if opts.etime and etime is not None:
        print etime
    if opts.rtime and rtime is not None:
        print rtime
    if opts.mtime and mtime is not None:
        print mtime
    if opts.progress and progress is not None:
        print progress

    if opts.cover :
        cover = clemdict['arturl']
        if cover != "" :
            try :
                shutil.copyfile(str(cover.replace('file://', '')), opts.cover)
                print ""
            except Exception, e:
                print e
                print ""
        else :
            print ""