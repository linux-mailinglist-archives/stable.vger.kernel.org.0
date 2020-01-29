Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2282814D261
	for <lists+stable@lfdr.de>; Wed, 29 Jan 2020 22:20:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726251AbgA2VUD convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Wed, 29 Jan 2020 16:20:03 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:37942 "EHLO
        out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726171AbgA2VUC (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Jan 2020 16:20:02 -0500
Received: from in02.mta.xmission.com ([166.70.13.52])
        by out02.mta.xmission.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.90_1)
        (envelope-from <ebiederm@xmission.com>)
        id 1iwuki-0007iu-Cc; Wed, 29 Jan 2020 14:20:00 -0700
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95] helo=x220.xmission.com)
        by in02.mta.xmission.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.87)
        (envelope-from <ebiederm@xmission.com>)
        id 1iwukg-0008Hi-II; Wed, 29 Jan 2020 14:20:00 -0700
From:   ebiederm@xmission.com (Eric W. Biederman)
To:     Sasha Levin <sashal@kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thomas Voegtle <tv@lio96.de>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, ronnie sahlberg <ronniesahlberg@gmail.com>,
        Christoph =?utf-8?Q?B=C3=B6?= =?utf-8?Q?hmwalder?= 
        <christoph.boehmwalder@linbit.com>,
        Steve French <smfrench@gmail.com>,
        Philipp Reisner <philipp.reisner@linbit.com>,
        David Laight <David.Laight@aculab.com>
References: <20200128135852.449088278@linuxfoundation.org>
        <20200128135906.176803329@linuxfoundation.org>
        <alpine.LSU.2.21.2001291201030.14408@er-systems.de>
        <20200129113643.GB5277@kroah.com> <20200129191203.GA2896@sasha-vm>
Date:   Wed, 29 Jan 2020 15:18:18 -0600
In-Reply-To: <20200129191203.GA2896@sasha-vm> (Sasha Levin's message of "Wed,
        29 Jan 2020 14:12:03 -0500")
Message-ID: <87o8um0xnp.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-XM-SPF: eid=1iwukg-0008Hi-II;;;mid=<87o8um0xnp.fsf@x220.int.ebiederm.org>;;;hst=in02.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18bLNmd2EtwKNWhj6tf4CYqtX5mGBaw4Ds=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on sa06.xmission.com
X-Spam-Level: *
X-Spam-Status: No, score=1.2 required=8.0 tests=ALL_TRUSTED,BAYES_40,
        DCC_CHECK_NEGATIVE,T_TM2_M_HEADER_IN_MSG,T_TooManySym_01,XMNoVowels,
        XMSubLong,XM_B_Unicode autolearn=disabled version=3.4.2
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
        * -0.0 BAYES_40 BODY: Bayes spam probability is 20 to 40%
        *      [score: 0.2534]
        *  1.5 XMNoVowels Alpha-numberic number with no vowels
        *  0.7 XMSubLong Long Subject
        *  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
        *  0.0 XM_B_Unicode BODY: Testing for specific types of unicode
        * -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
        *      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
        *  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *;Sasha Levin <sashal@kernel.org>
X-Spam-Relay-Country: 
X-Spam-Timing: total 1260 ms - load_scoreonly_sql: 0.05 (0.0%),
        signal_user_changed: 2.9 (0.2%), b_tie_ro: 2.0 (0.2%), parse: 1.09
        (0.1%), extract_message_metadata: 17 (1.3%), get_uri_detail_list: 2.7
        (0.2%), tests_pri_-1000: 14 (1.1%), tests_pri_-950: 1.12 (0.1%),
        tests_pri_-900: 0.99 (0.1%), tests_pri_-90: 33 (2.7%), check_bayes: 32
        (2.6%), b_tokenize: 9 (0.7%), b_tok_get_all: 12 (0.9%), b_comp_prob:
        2.8 (0.2%), b_tok_touch_all: 4.8 (0.4%), b_finish: 0.68 (0.1%),
        tests_pri_0: 403 (32.0%), check_dkim_signature: 0.62 (0.0%),
        check_dkim_adsp: 2.1 (0.2%), poll_dns_idle: 773 (61.3%), tests_pri_10:
        2.2 (0.2%), tests_pri_500: 781 (62.0%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCH 4.9 183/271] signal: Allow cifs and drbd to receive their terminating signals
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Thu, 05 May 2016 13:38:54 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Sasha Levin <sashal@kernel.org> writes:

> On Wed, Jan 29, 2020 at 12:36:43PM +0100, Greg Kroah-Hartman wrote:
>>On Wed, Jan 29, 2020 at 12:10:47PM +0100, Thomas Voegtle wrote:
>>> On Tue, 28 Jan 2020, Greg Kroah-Hartman wrote:
>>>
>>> > From: Eric W. Biederman <ebiederm@xmission.com>
>>> >
>>> > [ Upstream commit 33da8e7c814f77310250bb54a9db36a44c5de784 ]
>>> >
>>> > My recent to change to only use force_sig for a synchronous events
>>> > wound up breaking signal reception cifs and drbd.  I had overlooked
>>> > the fact that by default kthreads start out with all signals set to
>>> > SIG_IGN.  So a change I thought was safe turned out to have made it
>>> > impossible for those kernel thread to catch their signals.
>>> >
>>> > Reverting the work on force_sig is a bad idea because what the code
>>> > was doing was very much a misuse of force_sig.  As the way force_sig
>>> > ultimately allowed the signal to happen was to change the signal
>>> > handler to SIG_DFL.  Which after the first signal will allow userspace
>>> > to send signals to these kernel threads.  At least for
>>> > wake_ack_receiver in drbd that does not appear actively wrong.
>>> >
>>> > So correct this problem by adding allow_kernel_signal that will allow
>>> > signals whose siginfo reports they were sent by the kernel through,
>>> > but will not allow userspace generated signals, and update cifs and
>>> > drbd to call allow_kernel_signal in an appropriate place so that their
>>> > thread can receive this signal.
>>> >
>>> > Fixing things this way ensures that userspace won't be able to send
>>> > signals and cause problems, that it is clear which signals the
>>> > threads are expecting to receive, and it guarantees that nothing
>>> > else in the system will be affected.
>>> >
>>> > This change was partly inspired by similar cifs and drbd patches that
>>> > added allow_signal.
>>> >
>>> > Reported-by: ronnie sahlberg <ronniesahlberg@gmail.com>
>>> > Reported-by: Christoph Böhmwalder <christoph.boehmwalder@linbit.com>
>>> > Tested-by: Christoph Böhmwalder <christoph.boehmwalder@linbit.com>
>>> > Cc: Steve French <smfrench@gmail.com>
>>> > Cc: Philipp Reisner <philipp.reisner@linbit.com>
>>> > Cc: David Laight <David.Laight@ACULAB.COM>
>>> > Fixes: 247bc9470b1e ("cifs: fix rmmod regression in cifs.ko caused by force_sig changes")
>>> > Fixes: 72abe3bcf091 ("signal/cifs: Fix cifs_put_tcp_session to call send_sig instead of force_sig")
>>>
>>> These two commits come with that release, but...
>>>
>>> > Fixes: fee109901f39 ("signal/drbd: Use send_sig not force_sig")
>>> > Fixes: 3cf5d076fb4d ("signal: Remove task parameter from force_sig")
>>>
>>> ...these two commits not and were never added to 4.9.y.
>>>
>>> Are these both really not needed?
>>
>>I don't think so, do you feel otherwise?
>
> Both of those commits read as a cleanup to me. I've actually slightly
> modified to patch to not need those commits (they were less than trivial
> to backport as is).

All of these changes were cleanup.  Which is why I didn't tag any of
them for stable.

Not to say that there weren't real problems using force_sig instead
of send_sig.  force_sig does nothing to ensure the task it is sending
signals to won't, and hasn't gone away.  Which is why it is a bad
idea to use force_sig on anything but current.  As I recall drbd used
force_sig on a kernel_thread which didn't go away.

When fixing the force_sig vs send_sig confusion I didn't realize that
some places were using force_sig because they had not enabled receiving
the signals they depended on.  Which is where allow_kernel_signal comes
from.  But while using force_sig allow_kernel_signal is not necessary.

Eric

