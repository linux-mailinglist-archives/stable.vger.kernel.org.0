Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2846F7256D
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 05:35:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726352AbfGXDfS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jul 2019 23:35:18 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:45071 "EHLO
        out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725827AbfGXDfR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Jul 2019 23:35:17 -0400
X-Greylist: delayed 7353 seconds by postgrey-1.27 at vger.kernel.org; Tue, 23 Jul 2019 23:35:15 EDT
Received: from in01.mta.xmission.com ([166.70.13.51])
        by out02.mta.xmission.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.87)
        (envelope-from <ebiederm@xmission.com>)
        id 1hq83d-0005OI-8R; Tue, 23 Jul 2019 21:35:13 -0600
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95] helo=x220.xmission.com)
        by in01.mta.xmission.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.87)
        (envelope-from <ebiederm@xmission.com>)
        id 1hq83c-0007ZL-12; Tue, 23 Jul 2019 21:35:13 -0600
From:   ebiederm@xmission.com (Eric W. Biederman)
To:     Steve French <smfrench@gmail.com>
Cc:     ronnie sahlberg <ronniesahlberg@gmail.com>,
        Sasha Levin <sashal@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Stable <stable@vger.kernel.org>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Jeff Layton <jlayton@primarydata.com>,
        linux-cifs <linux-cifs@vger.kernel.org>
References: <20190715134655.4076-1-sashal@kernel.org>
        <20190715134655.4076-39-sashal@kernel.org>
        <CAN05THSdj8m5g-xG5abYAZ=_PE2xT-RwLtVhKrtxPevJGCSxag@mail.gmail.com>
        <CAH2r5mu9ncYa1WTHuuMEk3=4TU5-RBH6nBKME4Bm+dntOtORTQ@mail.gmail.com>
        <87v9vs43pq.fsf@xmission.com>
        <CAH2r5mtB=KO+9fxSYQHbjD+0K+5rGL6Q8TSU0_wsHUdqHy1rSw@mail.gmail.com>
        <CAH2r5mvF-E6_3YLV02Mj0uSaKgHigV6wwU9LsGC-zFs7JnKa-Q@mail.gmail.com>
        <CAH2r5mupXphkH0c6LVSgBAK1PQihX+h6UruMfPoood9PT+0RrA@mail.gmail.com>
Date:   Tue, 23 Jul 2019 22:35:07 -0500
In-Reply-To: <CAH2r5mupXphkH0c6LVSgBAK1PQihX+h6UruMfPoood9PT+0RrA@mail.gmail.com>
        (Steve French's message of "Tue, 23 Jul 2019 21:28:31 -0500")
Message-ID: <87blxk3y1g.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/25.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1hq83c-0007ZL-12;;;mid=<87blxk3y1g.fsf@xmission.com>;;;hst=in01.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+9lgk1YztBX2M0RyG6u/ajVR0q2Y5VVmw=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on sa02.xmission.com
X-Spam-Level: *
X-Spam-Status: No, score=1.0 required=8.0 tests=ALL_TRUSTED,BAYES_50,
        DCC_CHECK_NEGATIVE,T_TM2_M_HEADER_IN_MSG,T_TooManySym_01,
        T_TooManySym_02,XMGappySubj_01,XMSubLong autolearn=disabled
        version=3.4.2
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        *  0.7 XMSubLong Long Subject
        *  0.5 XMGappySubj_01 Very gappy subject
        *  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
        * -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
        *      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
        *  0.0 T_TooManySym_02 5+ unique symbols in subject
        *  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *;Steve French <smfrench@gmail.com>
X-Spam-Relay-Country: 
X-Spam-Timing: total 642 ms - load_scoreonly_sql: 0.05 (0.0%),
        signal_user_changed: 2.9 (0.5%), b_tie_ro: 2.1 (0.3%), parse: 1.22
        (0.2%), extract_message_metadata: 15 (2.3%), get_uri_detail_list: 6
        (0.9%), tests_pri_-1000: 10 (1.6%), tests_pri_-950: 1.14 (0.2%),
        tests_pri_-900: 0.85 (0.1%), tests_pri_-90: 32 (5.0%), check_bayes: 31
        (4.8%), b_tokenize: 12 (1.9%), b_tok_get_all: 10 (1.6%), b_comp_prob:
        2.3 (0.4%), b_tok_touch_all: 3.8 (0.6%), b_finish: 0.68 (0.1%),
        tests_pri_0: 566 (88.1%), check_dkim_signature: 0.46 (0.1%),
        check_dkim_adsp: 2.3 (0.4%), poll_dns_idle: 1.01 (0.2%), tests_pri_10:
        2.9 (0.5%), tests_pri_500: 7 (1.1%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCH AUTOSEL 5.2 039/249] signal/cifs: Fix cifs_put_tcp_session to call send_sig instead of force_sig
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Thu, 05 May 2016 13:38:54 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Steve French <smfrench@gmail.com> writes:

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

Yes.  I just discovered that kthreadd calls a function named
ignore_signals that set all signals to SIG_IGN.  Which becomes
the default for all kernel threads.  So something like allow_signal
to change the signal handler is necessary.  The blocking of SIGKILL is
also concerning but apparently that is not the issue here.

Ideally I think cifs should use kthread_stop, instead of signals for
this purpose.  The logic is convoluted enough that reading through the
cifs code quickly I don't see how sending SIGKILL to the daemon causes
it to stop.

Eric


> On Tue, Jul 23, 2019 at 9:19 PM Steve French <smfrench@gmail.com> wrote:
>>
>> Pavel noticed I missed a line from the attempt to do a similar patch
>> to Eric's suggestion
>> (it still didn't work though - although "allow_signal" does albeit is
>> possibly dangerous as user space can kill cifsd)
>>
>> # git diff -a
>> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
>> index a4830ced0f98..8758dff18c15 100644
>> --- a/fs/cifs/connect.c
>> +++ b/fs/cifs/connect.c
>> @@ -1104,6 +1104,7 @@ cifs_demultiplex_thread(void *p)
>>         struct task_struct *task_to_wake = NULL;
>>         struct mid_q_entry *mids[MAX_COMPOUND];
>>         char *bufs[MAX_COMPOUND];
>> +       sigset_t mask, oldmask;
>>
>>         current->flags |= PF_MEMALLOC;
>>         cifs_dbg(FYI, "Demultiplex PID: %d\n", task_pid_nr(current));
>> @@ -1113,6 +1114,9 @@ cifs_demultiplex_thread(void *p)
>>                 mempool_resize(cifs_req_poolp, length + cifs_min_rcv);
>>
>>         set_freezable();
>> +       sigfillset(&mask);
>> +       sigdelset(&mask, SIGKILL);
>> +       sigprocmask(SIG_BLOCK, &mask, &oldmask);
>>         while (server->tcpStatus != CifsExiting) {
>>                 if (try_to_freeze())
>>                         continue;
>>
>> On Tue, Jul 23, 2019 at 9:02 PM Steve French <smfrench@gmail.com> wrote:
>> >
>> > On Tue, Jul 23, 2019 at 8:32 PM Eric W. Biederman <ebiederm@xmission.com> wrote:
>> > >
>> > > Steve French <smfrench@gmail.com> writes:
>> > >
>> > > > Very easy to see what caused the regression with this global change:
>> > > >
>> > > > mount (which launches "cifsd" thread to read the socket)
>> > > > umount (which kills the "cifsd" thread)
>> > > > rmmod   (rmmod now fails since "cifsd" thread is still active)
>> > > >
>> > > > mount launches a thread to read from the socket ("cifsd")
>> > > > umount is supposed to kill that thread (but with the patch
>> > > > "signal/cifs: Fix cifs_put_tcp_session to call send_sig instead of
>> > > > force_sig" that no longer works).  So the regression is that after
>> > > > unmount you still see the "cifsd" thread, and the reason that cifsd
>> > > > thread is still around is that that patch no longer force kills the
>> > > > process (see line 2652 of fs/cifs/connect.c) which regresses module
>> > > > removal.
>> > > >
>> > > > -               force_sig(SIGKILL, task);
>> > > > +               send_sig(SIGKILL, task, 1);
>> > > >
>> > > > The comment in the changeset indicates "The signal SIGKILL can not be
>> > > > ignored" but obviously it can be ignored - at least on 5.3-rc1 it is
>> > > > being ignored.
>> > > >
>> > > > If send_sig(SIGKILL ...) doesn't work and if force_sig(SIGKILL, task)
>> > > > is removed and no longer possible - how do we kill a helper process
>> > > > ...
>> > >
>> > > I think I see what is happening.  It looks like as well as misuinsg
>> > > force_sig, cifs is also violating the invariant that keeps SIGKILL out
>> > > of the blocked signal set.
>> > >
>> > > For that force_sig will act differently.  I did not consider it because
>> > > that is never supposed to happen.
>> > >
>> > > Can someone test this code below and confirm the issue goes away?
>> > >
>> > > diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
>> > > index 5d6d44bfe10a..2a782ebc7b65 100644
>> > > --- a/fs/cifs/transport.c
>> > > +++ b/fs/cifs/transport.c
>> > > @@ -347,6 +347,7 @@ __smb_send_rqst(struct TCP_Server_Info *server, int num_rqst,
>> > >          */
>> > >
>> > >         sigfillset(&mask);
>> > > +       sigdelset(&mask, SIGKILL);
>> > >         sigprocmask(SIG_BLOCK, &mask, &oldmask);
>> > >
>> > >         /* Generate a rfc1002 marker for SMB2+ */
>> > >
>> > >
>> > > Eric
>> >
>> > I just tried your suggestion and it didn't work.   I also tried doing
>> > a similar thing on the thread we are trying to kills ("cifsd" - ie
>> > which is blocked in the function cifs_demultiplex_thread waiting to
>> > read from the socket)
>> > # git diff -a
>> > diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
>> > index a4830ced0f98..b73062520a17 100644
>> > --- a/fs/cifs/connect.c
>> > +++ b/fs/cifs/connect.c
>> > @@ -1104,6 +1104,7 @@ cifs_demultiplex_thread(void *p)
>> >         struct task_struct *task_to_wake = NULL;
>> >         struct mid_q_entry *mids[MAX_COMPOUND];
>> >         char *bufs[MAX_COMPOUND];
>> > +       sigset_t mask;
>> >
>> >         current->flags |= PF_MEMALLOC;
>> >         cifs_dbg(FYI, "Demultiplex PID: %d\n", task_pid_nr(current));
>> > @@ -1113,6 +1114,8 @@ cifs_demultiplex_thread(void *p)
>> >                 mempool_resize(cifs_req_poolp, length + cifs_min_rcv);
>> >
>> >         set_freezable();
>> > +       sigfillset(&mask);
>> > +       sigdelset(&mask, SIGKILL);
>> >         while (server->tcpStatus != CifsExiting) {
>> >                 if (try_to_freeze())
>> >                         continue;
>> >
>> >
>> > That also didn't work.     The only thing I have been able to find
>> > which worked was:
>> >
>> > diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
>> > index a4830ced0f98..e74f04163fc9 100644
>> > --- a/fs/cifs/connect.c
>> > +++ b/fs/cifs/connect.c
>> > @@ -1113,6 +1113,7 @@ cifs_demultiplex_thread(void *p)
>> >                 mempool_resize(cifs_req_poolp, length + cifs_min_rcv);
>> >
>> >         set_freezable();
>> > +      allow_signal(SIGKILL);
>> >         while (server->tcpStatus != CifsExiting) {
>> >                 if (try_to_freeze())
>> >                         continue;
>> >
>> >
>> > That fixes the problem ... but ... as Ronnie and others have noted it
>> > would allow a userspace process to make the mount unusable (all you
>> > would have to do would be to do a kill -9 of the "cifsd" process from
>> > some userspace process like bash and the mount would be unusable - so
>> > this sounds dangerous.
>> >
>> > Is there an alternative that, in the process doing the unmount in
>> > kernel, would allow us to do the equivalent of:
>> >       "allow_signal(SIGKILL, <the id of the cifsd process>"
>> > In otherwords, to minimize the risk of some userspace process killing
>> > cifsd, could we delay enabling allow_signal(SIGKILL) till the unmount
>> > begins by doing it for a different process (have the unmount process
>> > enable signals for the cifsd process).   Otherwise is there a way to
>> > force kill a process from the kernel as we used to do - without
>> > running the risk of a user space process killing cifsd (which is bad).
>> >
>> > --
>> > Thanks,
>> >
>> > Steve
>>
>>
>>
>> --
>> Thanks,
>>
>> Steve
