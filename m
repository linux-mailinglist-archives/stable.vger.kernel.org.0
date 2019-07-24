Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3BCA77236F
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 02:29:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727779AbfGXA3W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jul 2019 20:29:22 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:39689 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726653AbfGXA3W (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Jul 2019 20:29:22 -0400
Received: by mail-pg1-f194.google.com with SMTP id u17so20235352pgi.6;
        Tue, 23 Jul 2019 17:29:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1TLM1fWUqcrER2t0L87ummZEyYbWAV1rtKQafeYpooE=;
        b=nJf9WxRXe75IWmsHazxJD31sAxuaGmT72oW49mQaFmQnfetT6QxwEa6S9pxLuHr1Gf
         PoLK131lVhFIt4+Y2sAufi2CTpIMLqgYywub9CBNi3b25JSrDv6ts3rwCWvgGh93AS5O
         Y9iJtluwN1fN5NeKMtZ/yCnyDJwUozGLTJLQyX2XkKQ2cAAMPXKXXI7EESN5Yyh92DIw
         35kR0SyvLkXJOKoVoFfvcT6s6JXZ74O34pU3LoYeFeazQktES98ycalR6TaaAhCUIBWC
         qfMbpKxpsf5c6uEJLqVc5vz5eHcB8EVKrpIJDVkYZP6fqvTuoqz0Pl3w6j+NK63tSPVw
         mA/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1TLM1fWUqcrER2t0L87ummZEyYbWAV1rtKQafeYpooE=;
        b=em/jOG4IPk+ry3Ddyg88Hs5lFJVXkT8R8TCiuG5KsPbNb8OO+UHvjlzo5dcKQZCX8j
         GXMDiDPjAPrE73PYP48dpi3PFhDq7BxTnlEXVmcENJwEqgepShh4ftkng90YfecEzqiL
         O2t7cWgd/n2cc/rFz1Zx9/1oGRyDF4uwxJeIWcEArnjyBJtJkO93C2PWkGAdz1sm0EzU
         fBVpZLhncmej1QrPQKVfU17+1/La0u6xK1AnOeWLphsv3GDlQzuDxLRX7unzfWxKWi66
         X9r+8F36+UMwZw9m7pwq4k38bb1QpR+8bdSaZ8Y84QZaxZbVtdluodgsGT1UJ3/+mNul
         D2tg==
X-Gm-Message-State: APjAAAUnNkINFlIatKFqCC/d7BER+10Y1MLCP+mXEhy32OHLp6VSbj8k
        IPRrYHbVWDxh/k3bd8Lwz/l+PvUUt7IAkt5ITnI=
X-Google-Smtp-Source: APXvYqze1HnNxhdvGGARt1p/RrBlC0fk9XciTNllhwnZU0qPGCW/TQ9g4CTjC5rh+RqP6BFSS8jRuHxoltmvv2nE9FI=
X-Received: by 2002:a17:90a:360c:: with SMTP id s12mr86039886pjb.30.1563928161588;
 Tue, 23 Jul 2019 17:29:21 -0700 (PDT)
MIME-Version: 1.0
References: <20190715134655.4076-1-sashal@kernel.org> <20190715134655.4076-39-sashal@kernel.org>
 <CAN05THSdj8m5g-xG5abYAZ=_PE2xT-RwLtVhKrtxPevJGCSxag@mail.gmail.com>
In-Reply-To: <CAN05THSdj8m5g-xG5abYAZ=_PE2xT-RwLtVhKrtxPevJGCSxag@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 23 Jul 2019 19:29:10 -0500
Message-ID: <CAH2r5mu9ncYa1WTHuuMEk3=4TU5-RBH6nBKME4Bm+dntOtORTQ@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 5.2 039/249] signal/cifs: Fix cifs_put_tcp_session
 to call send_sig instead of force_sig
To:     ronnie sahlberg <ronniesahlberg@gmail.com>
Cc:     Sasha Levin <sashal@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Stable <stable@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Jeff Layton <jlayton@primarydata.com>,
        linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Very easy to see what caused the regression with this global change:

mount (which launches "cifsd" thread to read the socket)
umount (which kills the "cifsd" thread)
rmmod   (rmmod now fails since "cifsd" thread is still active)

mount launches a thread to read from the socket ("cifsd")
umount is supposed to kill that thread (but with the patch
"signal/cifs: Fix cifs_put_tcp_session to call send_sig instead of
force_sig" that no longer works).  So the regression is that after
unmount you still see the "cifsd" thread, and the reason that cifsd
thread is still around is that that patch no longer force kills the
process (see line 2652 of fs/cifs/connect.c) which regresses module
removal.

-               force_sig(SIGKILL, task);
+               send_sig(SIGKILL, task, 1);

The comment in the changeset indicates "The signal SIGKILL can not be
ignored" but obviously it can be ignored - at least on 5.3-rc1 it is
being ignored.

If send_sig(SIGKILL ...) doesn't work and if force_sig(SIGKILL, task)
is removed and no longer possible - how do we kill a helper process
...

On Tue, Jul 23, 2019 at 6:20 PM ronnie sahlberg
<ronniesahlberg@gmail.com> wrote:
>
> On Tue, Jul 16, 2019 at 1:15 AM Sasha Levin <sashal@kernel.org> wrote:
> >
> > From: "Eric W. Biederman" <ebiederm@xmission.com>
> >
> > [ Upstream commit 72abe3bcf0911d69b46c1e8bdb5612675e0ac42c ]
> >
> > The locking in force_sig_info is not prepared to deal with a task that
> > exits or execs (as sighand may change).  The is not a locking problem
> > in force_sig as force_sig is only built to handle synchronous
> > exceptions.
> >
> > Further the function force_sig_info changes the signal state if the
> > signal is ignored, or blocked or if SIGNAL_UNKILLABLE will prevent the
> > delivery of the signal.  The signal SIGKILL can not be ignored and can
> > not be blocked and SIGNAL_UNKILLABLE won't prevent it from being
> > delivered.
> >
> > So using force_sig rather than send_sig for SIGKILL is confusing
> > and pointless.
> >
> > Because it won't impact the sending of the signal and and because
> > using force_sig is wrong, replace force_sig with send_sig.
>
> I think this patch broke the cifs module.
> The issue is that the use count is now not updated properly and thus
> it is no longer possible to
> rmmod the module.
>
>
> >
> > Cc: Namjae Jeon <namjae.jeon@samsung.com>
> > Cc: Jeff Layton <jlayton@primarydata.com>
> > Cc: Steve French <smfrench@gmail.com>
> > Fixes: a5c3e1c725af ("Revert "cifs: No need to send SIGKILL to demux_thread during umount"")
> > Fixes: e7ddee9037e7 ("cifs: disable sharing session and tcon and add new TCP sharing code")
> > Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > ---
> >  fs/cifs/connect.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> > index 8dd6637a3cbb..714a359c7c8d 100644
> > --- a/fs/cifs/connect.c
> > +++ b/fs/cifs/connect.c
> > @@ -2631,7 +2631,7 @@ cifs_put_tcp_session(struct TCP_Server_Info *server, int from_reconnect)
> >
> >         task = xchg(&server->tsk, NULL);
> >         if (task)
> > -               force_sig(SIGKILL, task);
> > +               send_sig(SIGKILL, task, 1);
> >  }
> >
> >  static struct TCP_Server_Info *
> > --
> > 2.20.1
> >



-- 
Thanks,

Steve
