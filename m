Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51B364429C
	for <lists+stable@lfdr.de>; Thu, 13 Jun 2019 18:24:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727650AbfFMQYD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 12:24:03 -0400
Received: from mail-yb1-f196.google.com ([209.85.219.196]:44042 "EHLO
        mail-yb1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731006AbfFMIh2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Jun 2019 04:37:28 -0400
Received: by mail-yb1-f196.google.com with SMTP id x187so7486998ybc.11
        for <stable@vger.kernel.org>; Thu, 13 Jun 2019 01:37:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Jt8gwpSgGmEBqY3kuALG8Z/2pn3kbQ8yLGHBD//9Zr8=;
        b=bWb+JIHpMkpCkNYeoPhQvNX1kAb4lxRaLe+lScQkkZeFjthSq7Jj01tOO3VJITY/KB
         1Z1r12KTt7Z6jcaNT/fGRkNUrWjVEqUpM4rwZ4D2LJYm2osXLTaSezouV0QNkrGTdF+H
         19zd7bJWwZtynnVsSpJ33iCssIkqb0hiANg2Ts0WLjBTW9j0cRCeiXjfw6QGCOqf/pDD
         2ZjiXEQws2DmIBFF6HiqpyXd0SopGqFH3Go+Mu7h6LJ+5XozQPT6RPuaC3gwMXD8uegH
         Vsd4CckrgL5TooyLQzvarVKJmCVYc7ZGRoYRTRX7Pi9hTiYv5yMVlFOYPboPpbzlMl5i
         SvOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Jt8gwpSgGmEBqY3kuALG8Z/2pn3kbQ8yLGHBD//9Zr8=;
        b=KoBpuRnXGij0OvjAdWfG8pOa0JGp/BLc8jH/QhaOXesjudAidu4aEZ6vwhY5pK36wz
         KK5oTVrTTT3lGL+NI8eG8kIsv16A/Vxks1R/pCcDRUX2eeCb7Em8P69AV/90HzVcpj9T
         ybeAj+rk1rfRejlE4HoXBXYHXYgSE3UuvTQefXAVvn15lonyhknUx00nsQE6J1KqDEiH
         MOCW5kCZgFnaGYuDfVieBukxZjMrt2oyWpxQpQ0KTXn22L1x5qqyDYNBF1n89Rjdhe79
         13FUwUH0nRsm3NlogaP/7VlEKXi+hkuVvo+WXCzFRDHQHgHop207rLhtg3BIqAiMvMv4
         ixnw==
X-Gm-Message-State: APjAAAXHrSfam1FEs+x8/a4B2RYyxzGw8rxOIh2PTKRfePTElDRZf5gB
        /MfrRyhYcRTwYDih9wrijvR6mGmuMBXxg2hKzA8=
X-Google-Smtp-Source: APXvYqxvK7E2VCEOlolHjd6fO3AROrzE/j5U5g5c1aso9yPU1oLBoqLXALa9+VzjLup09ZIYYzE/RT/73ll6tJhOdac=
X-Received: by 2002:a25:8109:: with SMTP id o9mr38575853ybk.132.1560415047416;
 Thu, 13 Jun 2019 01:37:27 -0700 (PDT)
MIME-Version: 1.0
References: <1558603746191117@kroah.com> <CAOQ4uxip8H45S-UmWhNowv9sQUTYzcDMVCZxw=6AvFN-4c1Uvw@mail.gmail.com>
 <20190523195741.GA4436@kroah.com> <CAOQ4uxjKKJduAkomNHxo=T1i4-FVUJ_JABkXfpjz2qt=DAHTZA@mail.gmail.com>
 <20190613074854.GC19685@kroah.com>
In-Reply-To: <20190613074854.GC19685@kroah.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Thu, 13 Jun 2019 11:37:15 +0300
Message-ID: <CAOQ4uxghRTP_bWYjikADGB0zTC83ThA=UK4a_thd_BdyMouf0A@mail.gmail.com>
Subject: Re: Patch "ovl: fix missing upper fs freeze protection on copy up for
 ioctl" has been added to the 4.19-stable tree
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Miklos Szeredi <mszeredi@redhat.com>,
        Vivek Goyal <vgoyal@redhat.com>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jun 13, 2019 at 10:48 AM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Mon, Jun 10, 2019 at 11:28:46PM +0300, Amir Goldstein wrote:
> > > > This patch is fine for stable, but I have a process question.
> > > > All these patches from overlayfs 5.2-rc1 are also v4.9 stable candidates:
> > > >
> > > > 1. acf3062a7e1c - ovl: relax WARN_ON() for overlapping layers use case
> > > > 2. 98487de318a6 - ovl: check the capability before cred overridden
> > > > 3. d989903058a8 - ovl: do not generate duplicate fsnotify events for "fake" path
> > > > 4. 9e46b840c705 - ovl: support stacked SEEK_HOLE/SEEK_DATA
> > > >
> > > > #2 wasn't properly marked for stable, but the other are marked with
> > > > Fixes: and Reported-by:
> > > >
> > > > Are those marks not sufficient to get selected for stable trees these days?
> > >
> > > Not by default, no.  Sometimes they might get picked up if we get bored,
> > > or the auto-bot notices them.
> > >
> > > > I must admit that #1 in borderline stable. Not sure if eliminating an unjust
> > > > WARN_ON qualified, but syzbot did report a bug..
> > >
> > > syzbot things are good to fix in stable kernels, so that syzbot can
> > > continue to find real things in stable kernels.  So yes, that is fine to
> > > backport.
> > >
> > > > Just asking in order to improve the process, but in any case,
> > > > please pick those patches for v4.9+ (unless anyone objects?)
> > > > They all already have LTP/xfstests/syzkaller tests that cover them.
> > >
> > > I'll queue them up for the next round after this, thanks.
> > >
> >
> > Hi Greg,
> >
> > I forgot to follow up on those patches.
> > Now I look at linux-4.19.y, I only see patch #1 (ovl: relax WARN_ON()..)
> > and not the 3 other patches I listed as stable candidates.
> > Was there any issue with those patches?
>
> Sorry, didn't get to them.
>
> I did now, and they all do not apply to all kernel versions.  Most of
> them do not go back to 4.14 or 4.9 as the code just isn't there.
>
> So, after this next round of kernel releases, can you send backported
> versions of any missing patches so that we are sure to apply them
> correctly?
>

Is happens to be that all those patches you picked since 4.19
most of the, whether tagged properly or not are:
Fixes: d1d04ef8572b ("ovl: stack file ops")
Cc: <stable@vger.kernel.org> # v4.19

There was a very big change in v4.19 ("ovl: stack file ops")
removing lots of "VFS hacks" and resulting in more than
one behavior change. Things that used to work pre-4.19
with the "VFS hacks" that do not work with "ovl: stack file ops".

There have been very few overlayfs patches since v4.20,
only a trickle of v4.19 stable fixes.

Also, the code has changes quite considerably since 4.14, so
overlayfs patches that could be easily backported, even if
applicable to 4.14 are rare these days.

Thanks!
Amir.
