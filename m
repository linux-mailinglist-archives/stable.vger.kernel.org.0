Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD62B72557
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 05:24:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725878AbfGXDWk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jul 2019 23:22:40 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:45785 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725837AbfGXDWk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Jul 2019 23:22:40 -0400
Received: by mail-pf1-f193.google.com with SMTP id r1so20149891pfq.12;
        Tue, 23 Jul 2019 20:22:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JncQclGuKJgkDE8+Ru/a7lDAGkLb2eFvcUaGQ4XqB8Q=;
        b=UTeey+XQYXm1p528GibWFi4sNEohlInS2JCVHsmnqOys+T/8KVMZ+tB15l86UjdyXl
         oXwwGb7JLkzOxBObkOHDNxO90vKo20/LOfI/+K44N3SriWcAdWqBaI3F9a3msb7rydgP
         XoO4s+ybjziBvMGOUen4coNMCdhy6FDXcBvFFoklrgkjeMgegFeaB73t65DRgBNjaKyM
         Xo1HJN/e2YmDrFrO7rkbBmXPKo7nNXpOyCXvzYWONVAnumgtwQT40OdPvwx5P/ceScM9
         vjXuHVdxNrIPtUWngtfkOaknT26IkS3XSbIUlKvs7M4bUEoCttxSHLFgV4qv4FEusEha
         wSXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JncQclGuKJgkDE8+Ru/a7lDAGkLb2eFvcUaGQ4XqB8Q=;
        b=b4obZ5+90xhJK/8oNg18vGS0a5BN5kNGSlM+U3H9nwOX+mCyVjPaKLp+0GPAbBoT6J
         ERF/tnDYXtJbn3McMSXodMaTl+ifPFOeGmadcbqDDwt7M9VnO05l4S6QOSzvctF2M4IS
         8ITl4ygBjhVEjsFKVGcU+a14qdoyCdUllKnhzV5WBPLsvpSnkAdSGw538GT6gcuzniAD
         drQjMaagc4OvWd4ZnAPl4ATvWjFK+ki1tmxeRMRE0blvWhPIGaXTVM1TLS4pyHXYGliC
         JFIL5069y7Xqbt0Ldf6IliF7seAxP2nVJnRyseOL6Tx/tn3sD47dMTf3cYmgA/mnZixm
         3wwQ==
X-Gm-Message-State: APjAAAUBJPVCTy5Vad8+/KDrm1m18cVH979J9AtS7MOBBeuD0fGlU5Aw
        3HeeLg0pqtbMdkbp0+z3ZiP4zJgeeu7PYnISx6M=
X-Google-Smtp-Source: APXvYqz4j4yEl1gCpOsPJ+++gVvxNvJJO0oQkYA99yqn/NsdA9Ld4lEP+lnwCEpW+SkNYT08HdpaSv5ZxA4+E9WfxIs=
X-Received: by 2002:a63:7245:: with SMTP id c5mr65543039pgn.11.1563938559079;
 Tue, 23 Jul 2019 20:22:39 -0700 (PDT)
MIME-Version: 1.0
References: <20190715134655.4076-1-sashal@kernel.org> <20190715134655.4076-39-sashal@kernel.org>
 <CAN05THSdj8m5g-xG5abYAZ=_PE2xT-RwLtVhKrtxPevJGCSxag@mail.gmail.com>
 <CAH2r5mu9ncYa1WTHuuMEk3=4TU5-RBH6nBKME4Bm+dntOtORTQ@mail.gmail.com>
 <87v9vs43pq.fsf@xmission.com> <CAH2r5mtB=KO+9fxSYQHbjD+0K+5rGL6Q8TSU0_wsHUdqHy1rSw@mail.gmail.com>
 <CAH2r5mvF-E6_3YLV02Mj0uSaKgHigV6wwU9LsGC-zFs7JnKa-Q@mail.gmail.com> <CAH2r5mupXphkH0c6LVSgBAK1PQihX+h6UruMfPoood9PT+0RrA@mail.gmail.com>
In-Reply-To: <CAH2r5mupXphkH0c6LVSgBAK1PQihX+h6UruMfPoood9PT+0RrA@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 23 Jul 2019 22:22:27 -0500
Message-ID: <CAH2r5mvu50ufcRxWOzbtMd01mQfsufJzgWOqFHi9stqjdnbVUw@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 5.2 039/249] signal/cifs: Fix cifs_put_tcp_session
 to call send_sig instead of force_sig
To:     "Eric W. Biederman" <ebiederm@xmission.com>
Cc:     ronnie sahlberg <ronniesahlberg@gmail.com>,
        Sasha Levin <sashal@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Stable <stable@vger.kernel.org>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        linux-cifs <linux-cifs@vger.kernel.org>,
        Jeff Layton <jlayton@poochiereds.net>
Content-Type: multipart/mixed; boundary="00000000000043dc5e058e64d2f2"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--00000000000043dc5e058e64d2f2
Content-Type: text/plain; charset="UTF-8"

Patch attached - tests out ok.


On Tue, Jul 23, 2019 at 9:28 PM Steve French <smfrench@gmail.com> wrote:
>
> I did some additional testing and it looks like the "allow_signal"
> change may be safe enough
>
> # git diff -a
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index a4830ced0f98..a15a6e738eb5 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -1113,6 +1113,7 @@ cifs_demultiplex_thread(void *p)
>                 mempool_resize(cifs_req_poolp, length + cifs_min_rcv);
>
>         set_freezable();
> +       allow_signal(SIGKILL);
>         while (server->tcpStatus != CifsExiting) {
>                 if (try_to_freeze())
>                         continue;
>
> See below:
> root@smf-Thinkpad-P51:~/cifs-2.6/fs/cifs# insmod ./cifs.ko
> root@smf-Thinkpad-P51:~/cifs-2.6/fs/cifs# mount -t cifs
> //localhost/scratch /mnt -o username=sfrench
> Password for sfrench@//localhost/scratch:  ************
> root@smf-Thinkpad-P51:~/cifs-2.6/fs/cifs# ps -A | grep cifsd
>  5176 ?        00:00:00 cifsd
> root@smf-Thinkpad-P51:~/cifs-2.6/fs/cifs# kill -9 5176
> root@smf-Thinkpad-P51:~/cifs-2.6/fs/cifs# ls /mnt
> 0444  dir0750  dir0754  newfile
> root@smf-Thinkpad-P51:~/cifs-2.6/fs/cifs# umount /mnt
> root@smf-Thinkpad-P51:~/cifs-2.6/fs/cifs# ps -A | grep cifsd
> root@smf-Thinkpad-P51:~/cifs-2.6/fs/cifs# rmmod cifs
>
> On Tue, Jul 23, 2019 at 9:19 PM Steve French <smfrench@gmail.com> wrote:
> >
> > Pavel noticed I missed a line from the attempt to do a similar patch
> > to Eric's suggestion
> > (it still didn't work though - although "allow_signal" does albeit is
> > possibly dangerous as user space can kill cifsd)
> >
> > # git diff -a
> > diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> > index a4830ced0f98..8758dff18c15 100644
> > --- a/fs/cifs/connect.c
> > +++ b/fs/cifs/connect.c
> > @@ -1104,6 +1104,7 @@ cifs_demultiplex_thread(void *p)
> >         struct task_struct *task_to_wake = NULL;
> >         struct mid_q_entry *mids[MAX_COMPOUND];
> >         char *bufs[MAX_COMPOUND];
> > +       sigset_t mask, oldmask;
> >
> >         current->flags |= PF_MEMALLOC;
> >         cifs_dbg(FYI, "Demultiplex PID: %d\n", task_pid_nr(current));
> > @@ -1113,6 +1114,9 @@ cifs_demultiplex_thread(void *p)
> >                 mempool_resize(cifs_req_poolp, length + cifs_min_rcv);
> >
> >         set_freezable();
> > +       sigfillset(&mask);
> > +       sigdelset(&mask, SIGKILL);
> > +       sigprocmask(SIG_BLOCK, &mask, &oldmask);
> >         while (server->tcpStatus != CifsExiting) {
> >                 if (try_to_freeze())
> >                         continue;
> >
> > On Tue, Jul 23, 2019 at 9:02 PM Steve French <smfrench@gmail.com> wrote:
> > >
> > > On Tue, Jul 23, 2019 at 8:32 PM Eric W. Biederman <ebiederm@xmission.com> wrote:
> > > >
> > > > Steve French <smfrench@gmail.com> writes:
> > > >
> > > > > Very easy to see what caused the regression with this global change:
> > > > >
> > > > > mount (which launches "cifsd" thread to read the socket)
> > > > > umount (which kills the "cifsd" thread)
> > > > > rmmod   (rmmod now fails since "cifsd" thread is still active)
> > > > >
> > > > > mount launches a thread to read from the socket ("cifsd")
> > > > > umount is supposed to kill that thread (but with the patch
> > > > > "signal/cifs: Fix cifs_put_tcp_session to call send_sig instead of
> > > > > force_sig" that no longer works).  So the regression is that after
> > > > > unmount you still see the "cifsd" thread, and the reason that cifsd
> > > > > thread is still around is that that patch no longer force kills the
> > > > > process (see line 2652 of fs/cifs/connect.c) which regresses module
> > > > > removal.
> > > > >
> > > > > -               force_sig(SIGKILL, task);
> > > > > +               send_sig(SIGKILL, task, 1);
> > > > >
> > > > > The comment in the changeset indicates "The signal SIGKILL can not be
> > > > > ignored" but obviously it can be ignored - at least on 5.3-rc1 it is
> > > > > being ignored.
> > > > >
> > > > > If send_sig(SIGKILL ...) doesn't work and if force_sig(SIGKILL, task)
> > > > > is removed and no longer possible - how do we kill a helper process
> > > > > ...
> > > >
> > > > I think I see what is happening.  It looks like as well as misuinsg
> > > > force_sig, cifs is also violating the invariant that keeps SIGKILL out
> > > > of the blocked signal set.
> > > >
> > > > For that force_sig will act differently.  I did not consider it because
> > > > that is never supposed to happen.
> > > >
> > > > Can someone test this code below and confirm the issue goes away?
> > > >
> > > > diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
> > > > index 5d6d44bfe10a..2a782ebc7b65 100644
> > > > --- a/fs/cifs/transport.c
> > > > +++ b/fs/cifs/transport.c
> > > > @@ -347,6 +347,7 @@ __smb_send_rqst(struct TCP_Server_Info *server, int num_rqst,
> > > >          */
> > > >
> > > >         sigfillset(&mask);
> > > > +       sigdelset(&mask, SIGKILL);
> > > >         sigprocmask(SIG_BLOCK, &mask, &oldmask);
> > > >
> > > >         /* Generate a rfc1002 marker for SMB2+ */
> > > >
> > > >
> > > > Eric
> > >
> > > I just tried your suggestion and it didn't work.   I also tried doing
> > > a similar thing on the thread we are trying to kills ("cifsd" - ie
> > > which is blocked in the function cifs_demultiplex_thread waiting to
> > > read from the socket)
> > > # git diff -a
> > > diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> > > index a4830ced0f98..b73062520a17 100644
> > > --- a/fs/cifs/connect.c
> > > +++ b/fs/cifs/connect.c
> > > @@ -1104,6 +1104,7 @@ cifs_demultiplex_thread(void *p)
> > >         struct task_struct *task_to_wake = NULL;
> > >         struct mid_q_entry *mids[MAX_COMPOUND];
> > >         char *bufs[MAX_COMPOUND];
> > > +       sigset_t mask;
> > >
> > >         current->flags |= PF_MEMALLOC;
> > >         cifs_dbg(FYI, "Demultiplex PID: %d\n", task_pid_nr(current));
> > > @@ -1113,6 +1114,8 @@ cifs_demultiplex_thread(void *p)
> > >                 mempool_resize(cifs_req_poolp, length + cifs_min_rcv);
> > >
> > >         set_freezable();
> > > +       sigfillset(&mask);
> > > +       sigdelset(&mask, SIGKILL);
> > >         while (server->tcpStatus != CifsExiting) {
> > >                 if (try_to_freeze())
> > >                         continue;
> > >
> > >
> > > That also didn't work.     The only thing I have been able to find
> > > which worked was:
> > >
> > > diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> > > index a4830ced0f98..e74f04163fc9 100644
> > > --- a/fs/cifs/connect.c
> > > +++ b/fs/cifs/connect.c
> > > @@ -1113,6 +1113,7 @@ cifs_demultiplex_thread(void *p)
> > >                 mempool_resize(cifs_req_poolp, length + cifs_min_rcv);
> > >
> > >         set_freezable();
> > > +      allow_signal(SIGKILL);
> > >         while (server->tcpStatus != CifsExiting) {
> > >                 if (try_to_freeze())
> > >                         continue;
> > >
> > >
> > > That fixes the problem ... but ... as Ronnie and others have noted it
> > > would allow a userspace process to make the mount unusable (all you
> > > would have to do would be to do a kill -9 of the "cifsd" process from
> > > some userspace process like bash and the mount would be unusable - so
> > > this sounds dangerous.
> > >
> > > Is there an alternative that, in the process doing the unmount in
> > > kernel, would allow us to do the equivalent of:
> > >       "allow_signal(SIGKILL, <the id of the cifsd process>"
> > > In otherwords, to minimize the risk of some userspace process killing
> > > cifsd, could we delay enabling allow_signal(SIGKILL) till the unmount
> > > begins by doing it for a different process (have the unmount process
> > > enable signals for the cifsd process).   Otherwise is there a way to
> > > force kill a process from the kernel as we used to do - without
> > > running the risk of a user space process killing cifsd (which is bad).
> > >
> > > --
> > > Thanks,
> > >
> > > Steve
> >
> >
> >
> > --
> > Thanks,
> >
> > Steve
>
>
>
> --
> Thanks,
>
> Steve



-- 
Thanks,

Steve

--00000000000043dc5e058e64d2f2
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-cifs-fix-rmmod-regression-in-cifs.ko-caused-by-force.patch"
Content-Disposition: attachment; 
	filename="0001-cifs-fix-rmmod-regression-in-cifs.ko-caused-by-force.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_jygomo030>
X-Attachment-Id: f_jygomo030

RnJvbSA2OTY2YWY1YTE3N2JlN2ZkYWIyOWNkNmU4NzFjMjg1MGMwNzgzODVjIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFR1ZSwgMjMgSnVsIDIwMTkgMjI6MTQ6MjkgLTA1MDAKU3ViamVjdDogW1BBVENIXSBj
aWZzOiBmaXggcm1tb2QgcmVncmVzc2lvbiBpbiBjaWZzLmtvIGNhdXNlZCBieSBmb3JjZV9zaWcK
IGNoYW5nZXMKCkZpeGVzOiA3MmFiZTNiY2YwOTEgKCJzaWduYWwvY2lmczogRml4IGNpZnNfcHV0
X3RjcF9zZXNzaW9uIHRvIGNhbGwgc2VuZF9zaWcgaW5zdGVhZCBvZiBmb3JjZV9zaWciKQoKVGhl
IGdsb2JhbCBjaGFuZ2UgZnJvbSBmb3JjZV9zaWcgY2F1c2VkIG1vZHVsZSB1bmxvYWRpbmcgb2Yg
Y2lmcy5rbwp0byBmYWlsIChzaW5jZSB0aGUgY2lmc2QgcHJvY2VzcyBjb3VsZCBub3QgYmUga2ls
bGVkLCAicm1tb2QgY2lmcyIKbm93IHdvdWxkIGFsd2F5cyBmYWlsKQoKU2lnbmVkLW9mZi1ieTog
U3RldmUgRnJlbmNoIDxzdGZyZW5jaEBtaWNyb3NvZnQuY29tPgpSZXZpZXdlZC1ieTogUm9ubmll
IFNhaGxiZXJnIDxsc2FobGJlckByZWRoYXQuY29tPgpDQzogRXJpYyBXLiBCaWVkZXJtYW4gPGVi
aWVkZXJtQHhtaXNzaW9uLmNvbT4KLS0tCiBmcy9jaWZzL2Nvbm5lY3QuYyB8IDEgKwogMSBmaWxl
IGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspCgpkaWZmIC0tZ2l0IGEvZnMvY2lmcy9jb25uZWN0LmMg
Yi9mcy9jaWZzL2Nvbm5lY3QuYwppbmRleCBhNDgzMGNlZDBmOTguLmExNWE2ZTczOGViNSAxMDA2
NDQKLS0tIGEvZnMvY2lmcy9jb25uZWN0LmMKKysrIGIvZnMvY2lmcy9jb25uZWN0LmMKQEAgLTEx
MTMsNiArMTExMyw3IEBAIGNpZnNfZGVtdWx0aXBsZXhfdGhyZWFkKHZvaWQgKnApCiAJCW1lbXBv
b2xfcmVzaXplKGNpZnNfcmVxX3Bvb2xwLCBsZW5ndGggKyBjaWZzX21pbl9yY3YpOwogCiAJc2V0
X2ZyZWV6YWJsZSgpOworCWFsbG93X3NpZ25hbChTSUdLSUxMKTsKIAl3aGlsZSAoc2VydmVyLT50
Y3BTdGF0dXMgIT0gQ2lmc0V4aXRpbmcpIHsKIAkJaWYgKHRyeV90b19mcmVlemUoKSkKIAkJCWNv
bnRpbnVlOwotLSAKMi4yMC4xCgo=
--00000000000043dc5e058e64d2f2--
