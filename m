Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 319FD2FBDE
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 15:01:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726045AbfE3NBh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 09:01:37 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:40164 "EHLO
        out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725919AbfE3NBg (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 May 2019 09:01:36 -0400
Received: from in02.mta.xmission.com ([166.70.13.52])
        by out03.mta.xmission.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.87)
        (envelope-from <ebiederm@xmission.com>)
        id 1hWKgW-0001VT-Vy; Thu, 30 May 2019 07:01:33 -0600
Received: from ip72-206-97-68.om.om.cox.net ([72.206.97.68] helo=x220.xmission.com)
        by in02.mta.xmission.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.87)
        (envelope-from <ebiederm@xmission.com>)
        id 1hWKgV-0005o4-Oj; Thu, 30 May 2019 07:01:32 -0600
From:   ebiederm@xmission.com (Eric W. Biederman)
To:     Oleg Nesterov <oleg@redhat.com>
Cc:     Deepa Dinamani <deepa.kernel@gmail.com>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        arnd@arndb.de, dbueso@suse.de, axboe@kernel.dk, dave@stgolabs.net,
        e@80x24.org, jbaron@akamai.com, linux-fsdevel@vger.kernel.org,
        linux-aio@kvack.org, omar.kilani@gmail.com, tglx@linutronix.de,
        stable@vger.kernel.org
References: <20190522032144.10995-1-deepa.kernel@gmail.com>
        <20190529161157.GA27659@redhat.com>
Date:   Thu, 30 May 2019 08:01:25 -0500
In-Reply-To: <20190529161157.GA27659@redhat.com> (Oleg Nesterov's message of
        "Wed, 29 May 2019 18:11:57 +0200")
Message-ID: <87woi8rt96.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/25.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1hWKgV-0005o4-Oj;;;mid=<87woi8rt96.fsf@xmission.com>;;;hst=in02.mta.xmission.com;;;ip=72.206.97.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/AE6XpNpv8e3x+m7YvtCeClDoiez0lSSg=
X-SA-Exim-Connect-IP: 72.206.97.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on sa07.xmission.com
X-Spam-Level: **
X-Spam-Status: No, score=2.0 required=8.0 tests=ALL_TRUSTED,BAYES_50,
        DCC_CHECK_NEGATIVE,T_TM2_M_HEADER_IN_MSG,T_XMDrugObfuBody_08,
        T_XMDrugObfuBody_12,T_XMDrugObfuBody_14 autolearn=disabled
        version=3.4.2
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        *  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
        * -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
        *      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
        *  0.2 T_XMDrugObfuBody_14 obfuscated drug references
        *  1.0 T_XMDrugObfuBody_12 obfuscated drug references
        *  1.0 T_XMDrugObfuBody_08 obfuscated drug references
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: **;Oleg Nesterov <oleg@redhat.com>
X-Spam-Relay-Country: 
X-Spam-Timing: total 818 ms - load_scoreonly_sql: 0.13 (0.0%),
        signal_user_changed: 3.6 (0.4%), b_tie_ro: 2.0 (0.2%), parse: 1.95
        (0.2%), extract_message_metadata: 15 (1.8%), get_uri_detail_list: 3.1
        (0.4%), tests_pri_-1000: 8 (1.0%), tests_pri_-950: 2.0 (0.2%),
        tests_pri_-900: 1.11 (0.1%), tests_pri_-90: 32 (3.9%), check_bayes: 30
        (3.7%), b_tokenize: 10 (1.3%), b_tok_get_all: 10 (1.2%), b_comp_prob:
        3.2 (0.4%), b_tok_touch_all: 3.2 (0.4%), b_finish: 0.61 (0.1%),
        tests_pri_0: 679 (83.0%), check_dkim_signature: 0.74 (0.1%),
        check_dkim_adsp: 2.1 (0.3%), poll_dns_idle: 0.36 (0.0%), tests_pri_10:
        2.4 (0.3%), tests_pri_500: 68 (8.3%), rewrite_mail: 0.00 (0.0%)
Subject: Re: pselect/etc semantics
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Thu, 05 May 2016 13:38:54 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Oleg Nesterov <oleg@redhat.com> writes:

> Al, Linus, Eric, please help.
>
> The previous discussion was very confusing, we simply can not understand each
> other.
>
> To me everything looks very simple and clear, but perhaps I missed something
> obvious? Please correct me.

If I have read this thread correctly the core issue is that ther is a
program that used to work and that fails now.  The question is why.

There are two ways the semantics for a sigmask changing system call
can be defined.  The naive way and by reading posix.  I will pick
on pselect.

The naive way:
int pselect(int nfds, fd_set *readfds, fd_set *writefds,
            fd_set *exceptfds, const struct timespec *timeout,
            const sigset_t *sigmask)
{
        sigset_t oldmask;
	int ret;

        if (sigmask)
		sigprocmask(SIG_SETMASK, sigmask, &oldmask);

	ret = select(nfds, readfds, writefds, exceptfds, timeout);

	if (sigmask)
		sigprocmask(SIG_SETMASK, &oldmask, NULL);

        return ret;
}

The standard for pselect behavior at
https://pubs.opengroup.org/onlinepubs/009695399/functions/pselect.html
says:
> If sigmask is not a null pointer, then the pselect() function shall
> replace the signal mask of the caller by the set of signals pointed to
> by sigmask before examining the descriptors, and shall restore the
> signal mask of the calling thread before returning.

...

> On failure, the objects pointed to by the readfds, writefds, and
> errorfds arguments shall not be modified. If the timeout interval
> expires without the specified condition being true for any of the
> specified file descriptors, the objects pointed to by the readfds,
> writefds, and errorfds arguments shall have all bits set to 0.


So the standard specified behavior is if the return value is -EINTR you
know you were interrupted by a signal, for any other return value you
don't know.

An error value just indicates that the file descriptor sets have not
been updated.


That is what the standard and reasonable people will expect from the
system call.  Looking at set_user_sigmask and restore_user_sigmask
I believe we are don't violate those semantics today.

Which means I believe we have a semantically valid change in behavior
that is causing a regression.

From my inspection of the code the change in behavior is from these
two pieces of code:

From the v4.18 epoll_pwait.

	/*
	 * If we changed the signal mask, we need to restore the original one.
	 * In case we've got a signal while waiting, we do not restore the
	 * signal mask yet, and we allow do_signal() to deliver the signal on
	 * the way back to userspace, before the signal mask is restored.
	 */
	if (sigmask) {
		if (error == -EINTR) {
			memcpy(&current->saved_sigmask, &sigsaved,
			       sizeof(sigsaved));
			set_restore_sigmask();
		} else
			set_current_blocked(&sigsaved);
	}

/*
 * restore_user_sigmask:
 * usigmask: sigmask passed in from userland.
 * sigsaved: saved sigmask when the syscall started and changed the sigmask to
 *           usigmask.
 *
 * This is useful for syscalls such as ppoll, pselect, io_pgetevents and
 * epoll_pwait where a new sigmask is passed in from userland for the syscalls.
 */
void restore_user_sigmask(const void __user *usigmask, sigset_t *sigsaved)
{

	if (!usigmask)
		return;
	/*
	 * When signals are pending, do not restore them here.
	 * Restoring sigmask here can lead to delivering signals that the above
	 * syscalls are intended to block because of the sigmask passed in.
	 */
	if (signal_pending(current)) {
		current->saved_sigmask = *sigsaved;
		set_restore_sigmask();
		return;
	}

	/*
	 * This is needed because the fast syscall return path does not restore
	 * saved_sigmask when signals are not pending.
	 */
	set_current_blocked(sigsaved);
}

Which has been reported results in a return value of 0, and a signal
delivered, where previously that did not happen.

They only way I can see that happening is that set_current_blocked in
__set_task_blocked clears pending signals (that will be blocked) and
calls retarget_shared_pending.

Frankly the only reason this appears to be worth touching is that we
have a userspace regression.  Otherwise I would call the current
behavior more correct and desirable than ignoring the signal longer.

If I am reading sitaution properly I suggest we go back to resoring the
sigmask by hand in epoll_pwait, and put in a big fat comment about a
silly userspace program depending on that behavior.

That will be easier to backport and it will just fix the regression and
not overfix the problem for reasonable applications.

Oleg your cleanup also seems reasonable.  But I would like to make
certain we understand and fix the regression first.  We seem to be
talking very small windows for both cases.

Eric
