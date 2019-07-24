Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EAA7072429
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 04:02:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728820AbfGXCCa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jul 2019 22:02:30 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:42091 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728776AbfGXCCa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Jul 2019 22:02:30 -0400
Received: by mail-pl1-f196.google.com with SMTP id ay6so21353942plb.9;
        Tue, 23 Jul 2019 19:02:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=utzeHdlKnJ8Jsg5KiD3HvsIOK8aNJAUqQomKEkAT0jw=;
        b=Frn1fSzU7Hs6HFsPjqPEd7iPDyz3Ynjesxlx/brBizTjGTVtSx98hbgnFJg/vcdeJ3
         U0lKUt11tN9HFrNybfTgt0AvCNUDtP60bWNSRaWyNhAZ2Gq0utpFyf5N1OimCOT5qJ0T
         i3xvLAM7f8H++QOSmLUmIVGQ8O4vMRW2XvN5WxlNmK2FBIs59D6/HoWZ/cC71JYWHtsk
         NWEyxTbqMmixzi10djjAmf7drv+oSSjFblR/QL2TzexRmysBxFULMpjEtnF7RXzJW73v
         +/ODKm6LGGvaKElgXcQj6mtS8mvr8furUMK2L0zOm7y6XSdPeSSPDwh3sjpjNcuWSR9V
         JFPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=utzeHdlKnJ8Jsg5KiD3HvsIOK8aNJAUqQomKEkAT0jw=;
        b=mFmK+3ocSxBFQU6IAXiCtCkvgrLbxMzPugjLEnBohaLibfllybvfNe47YfIoXv5qbS
         dZ13GqEueO6uuGxqQNDgyChh3rpxx8MGnxCbVIpQI0dK93Ngqf9eXuV2EJMseablBbQ0
         WBl3Rc08uYaX2Wk9O87DEV548Mrwng/PNwNjYhjAPzF33J6/0A+Ra2WLuk1V2l/cdScb
         XnmgBIqRgWUgwXx90Nj8PY6UJqKLTGMcESAPjs0R5+od3qQdUhwh+Qi8tKYYfQ3D6twT
         3bEyYpygi+dDs+CPdWWfFUHUTJyjbyF4lLyeKAmdyi5Ya44dvY6UTAU055m+J9aFjzfi
         /VeA==
X-Gm-Message-State: APjAAAXRnHdeQUNvwrCwrUQtf4gOajbPaleIcS0oF6eYMMnXj5MZj2aq
        M8ycVqKb1/W3h/aus16zy0cEESiEU4gOTuiuNoY=
X-Google-Smtp-Source: APXvYqyTlL7iex/bgjSHKUXZkR5Q0EHQ0AscX9+V6owz2Wmr2wofhrW2X6+UwfLnyoBVAyomr1SOlaLp7luO+pvX4ew=
X-Received: by 2002:a17:902:2a68:: with SMTP id i95mr84858089plb.167.1563933749237;
 Tue, 23 Jul 2019 19:02:29 -0700 (PDT)
MIME-Version: 1.0
References: <20190715134655.4076-1-sashal@kernel.org> <20190715134655.4076-39-sashal@kernel.org>
 <CAN05THSdj8m5g-xG5abYAZ=_PE2xT-RwLtVhKrtxPevJGCSxag@mail.gmail.com>
 <CAH2r5mu9ncYa1WTHuuMEk3=4TU5-RBH6nBKME4Bm+dntOtORTQ@mail.gmail.com> <87v9vs43pq.fsf@xmission.com>
In-Reply-To: <87v9vs43pq.fsf@xmission.com>
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 23 Jul 2019 21:02:18 -0500
Message-ID: <CAH2r5mtB=KO+9fxSYQHbjD+0K+5rGL6Q8TSU0_wsHUdqHy1rSw@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 5.2 039/249] signal/cifs: Fix cifs_put_tcp_session
 to call send_sig instead of force_sig
To:     "Eric W. Biederman" <ebiederm@xmission.com>
Cc:     ronnie sahlberg <ronniesahlberg@gmail.com>,
        Sasha Levin <sashal@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Stable <stable@vger.kernel.org>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Jeff Layton <jlayton@primarydata.com>,
        linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 23, 2019 at 8:32 PM Eric W. Biederman <ebiederm@xmission.com> wrote:
>
> Steve French <smfrench@gmail.com> writes:
>
> > Very easy to see what caused the regression with this global change:
> >
> > mount (which launches "cifsd" thread to read the socket)
> > umount (which kills the "cifsd" thread)
> > rmmod   (rmmod now fails since "cifsd" thread is still active)
> >
> > mount launches a thread to read from the socket ("cifsd")
> > umount is supposed to kill that thread (but with the patch
> > "signal/cifs: Fix cifs_put_tcp_session to call send_sig instead of
> > force_sig" that no longer works).  So the regression is that after
> > unmount you still see the "cifsd" thread, and the reason that cifsd
> > thread is still around is that that patch no longer force kills the
> > process (see line 2652 of fs/cifs/connect.c) which regresses module
> > removal.
> >
> > -               force_sig(SIGKILL, task);
> > +               send_sig(SIGKILL, task, 1);
> >
> > The comment in the changeset indicates "The signal SIGKILL can not be
> > ignored" but obviously it can be ignored - at least on 5.3-rc1 it is
> > being ignored.
> >
> > If send_sig(SIGKILL ...) doesn't work and if force_sig(SIGKILL, task)
> > is removed and no longer possible - how do we kill a helper process
> > ...
>
> I think I see what is happening.  It looks like as well as misuinsg
> force_sig, cifs is also violating the invariant that keeps SIGKILL out
> of the blocked signal set.
>
> For that force_sig will act differently.  I did not consider it because
> that is never supposed to happen.
>
> Can someone test this code below and confirm the issue goes away?
>
> diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
> index 5d6d44bfe10a..2a782ebc7b65 100644
> --- a/fs/cifs/transport.c
> +++ b/fs/cifs/transport.c
> @@ -347,6 +347,7 @@ __smb_send_rqst(struct TCP_Server_Info *server, int num_rqst,
>          */
>
>         sigfillset(&mask);
> +       sigdelset(&mask, SIGKILL);
>         sigprocmask(SIG_BLOCK, &mask, &oldmask);
>
>         /* Generate a rfc1002 marker for SMB2+ */
>
>
> Eric

I just tried your suggestion and it didn't work.   I also tried doing
a similar thing on the thread we are trying to kills ("cifsd" - ie
which is blocked in the function cifs_demultiplex_thread waiting to
read from the socket)
# git diff -a
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index a4830ced0f98..b73062520a17 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -1104,6 +1104,7 @@ cifs_demultiplex_thread(void *p)
        struct task_struct *task_to_wake = NULL;
        struct mid_q_entry *mids[MAX_COMPOUND];
        char *bufs[MAX_COMPOUND];
+       sigset_t mask;

        current->flags |= PF_MEMALLOC;
        cifs_dbg(FYI, "Demultiplex PID: %d\n", task_pid_nr(current));
@@ -1113,6 +1114,8 @@ cifs_demultiplex_thread(void *p)
                mempool_resize(cifs_req_poolp, length + cifs_min_rcv);

        set_freezable();
+       sigfillset(&mask);
+       sigdelset(&mask, SIGKILL);
        while (server->tcpStatus != CifsExiting) {
                if (try_to_freeze())
                        continue;


That also didn't work.     The only thing I have been able to find
which worked was:

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index a4830ced0f98..e74f04163fc9 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -1113,6 +1113,7 @@ cifs_demultiplex_thread(void *p)
                mempool_resize(cifs_req_poolp, length + cifs_min_rcv);

        set_freezable();
+      allow_signal(SIGKILL);
        while (server->tcpStatus != CifsExiting) {
                if (try_to_freeze())
                        continue;


That fixes the problem ... but ... as Ronnie and others have noted it
would allow a userspace process to make the mount unusable (all you
would have to do would be to do a kill -9 of the "cifsd" process from
some userspace process like bash and the mount would be unusable - so
this sounds dangerous.

Is there an alternative that, in the process doing the unmount in
kernel, would allow us to do the equivalent of:
      "allow_signal(SIGKILL, <the id of the cifsd process>"
In otherwords, to minimize the risk of some userspace process killing
cifsd, could we delay enabling allow_signal(SIGKILL) till the unmount
begins by doing it for a different process (have the unmount process
enable signals for the cifsd process).   Otherwise is there a way to
force kill a process from the kernel as we used to do - without
running the risk of a user space process killing cifsd (which is bad).

-- 
Thanks,

Steve
