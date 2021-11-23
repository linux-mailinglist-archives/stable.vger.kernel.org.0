Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B677145AE8E
	for <lists+stable@lfdr.de>; Tue, 23 Nov 2021 22:42:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237757AbhKWVpe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Nov 2021 16:45:34 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:39844 "EHLO
        out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229586AbhKWVpd (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Nov 2021 16:45:33 -0500
Received: from in01.mta.xmission.com ([166.70.13.51]:55066)
        by out01.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1mpdYU-004rjG-0p; Tue, 23 Nov 2021 14:42:22 -0700
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95]:53994 helo=email.froward.int.ebiederm.org.xmission.com)
        by in01.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1mpdYR-00GhmA-2Q; Tue, 23 Nov 2021 14:42:21 -0700
From:   ebiederm@xmission.com (Eric W. Biederman)
To:     Thomas Backlund <tmb@iki.fi>
Cc:     Greg KH <gregkh@linuxfoundation.org>, keescook@chromium.org,
        khuey@kylehuey.com, me@kylehuey.com, oliver.sang@intel.com,
        torvalds@linux-foundation.org, stable@vger.kernel.org
References: <163758427225348@kroah.com>
        <c83d6b54-d02f-c23b-d1cc-76c1993031d5@iki.fi>
        <YZ0vAK6QJJFP3jY5@kroah.com>
        <aGPtF092eTtTol3Vfasn4-kVySgX_vBRkK7e4jX97omisSwgyJR7vHltUrS1bwNE9pYuB2N2nSas1HWLQxUBNg==@protonmail.internalid>
        <877dcyllom.fsf@email.froward.int.ebiederm.org>
        <d0eca47c-73f8-3d7f-3eb8-4ee7722022f8@iki.fi>
Date:   Tue, 23 Nov 2021 15:41:56 -0600
In-Reply-To: <d0eca47c-73f8-3d7f-3eb8-4ee7722022f8@iki.fi> (Thomas Backlund's
        message of "Tue, 23 Nov 2021 22:00:49 +0200")
Message-ID: <87k0gyim6z.fsf@email.froward.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1mpdYR-00GhmA-2Q;;;mid=<87k0gyim6z.fsf@email.froward.int.ebiederm.org>;;;hst=in01.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19dSXjku1sskthyWjBw7gQSC7r+TGrSMBk=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on sa07.xmission.com
X-Spam-Level: *
X-Spam-Status: No, score=1.7 required=8.0 tests=ALL_TRUSTED,BAYES_50,
        DCC_CHECK_NEGATIVE,LotsOfNums_01,T_TM2_M_HEADER_IN_MSG,T_TooManySym_01,
        T_TooManySym_02,T_TooManySym_03,XMSubLong autolearn=disabled
        version=3.4.2
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.4101]
        *  0.7 XMSubLong Long Subject
        *  1.2 LotsOfNums_01 BODY: Lots of long strings of numbers
        *  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
        * -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
        *      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
        *  0.0 T_TooManySym_02 5+ unique symbols in subject
        *  0.0 T_TooManySym_03 6+ unique symbols in subject
        *  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *;Thomas Backlund <tmb@iki.fi>
X-Spam-Relay-Country: 
X-Spam-Timing: total 1657 ms - load_scoreonly_sql: 0.04 (0.0%),
        signal_user_changed: 12 (0.7%), b_tie_ro: 10 (0.6%), parse: 1.41
        (0.1%), extract_message_metadata: 20 (1.2%), get_uri_detail_list: 6
        (0.4%), tests_pri_-1000: 23 (1.4%), tests_pri_-950: 1.24 (0.1%),
        tests_pri_-900: 1.00 (0.1%), tests_pri_-90: 96 (5.8%), check_bayes: 94
        (5.6%), b_tokenize: 14 (0.8%), b_tok_get_all: 11 (0.7%), b_comp_prob:
        3.4 (0.2%), b_tok_touch_all: 61 (3.7%), b_finish: 0.86 (0.1%),
        tests_pri_0: 1486 (89.7%), check_dkim_signature: 0.61 (0.0%),
        check_dkim_adsp: 2.7 (0.2%), poll_dns_idle: 0.46 (0.0%), tests_pri_10:
        3.1 (0.2%), tests_pri_500: 10 (0.6%), rewrite_mail: 0.00 (0.0%)
Subject: Re: FAILED: patch "[PATCH] signal: Don't always set SA_IMMUTABLE for forced signals" failed to apply to 5.15-stable tree
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Thomas Backlund <tmb@iki.fi> writes:

> Den 2021-11-23 kl. 21:24, skrev ebiederm@xmission.com:
>> Greg KH <gregkh@linuxfoundation.org> writes:
>>
>>> On Tue, Nov 23, 2021 at 07:29:43PM +0200, Thomas Backlund wrote:
>>>> Den 2021-11-22 kl. 14:31, skrev gregkh@linuxfoundation.org:
>>>>> The patch below does not apply to the 5.15-stable tree.
>>>>> If someone wants it applied there, or to any other stable or longterm
>>>>> tree, then please email the backport, including the original git commit
>>>>> id to <stable@vger.kernel.org>.
>>>>>
>>>>> thanks,
>>>>>
>>>>> greg k-h
>>>>
>>>> It will apply if you add this one first:
>>>>
>>>>  From 26d5badbccddcc063dc5174a2baffd13a23322aa Mon Sep 17 00:00:00 2001
>>>> From: "Eric W. Biederman" <ebiederm@xmission.com>
>>>> Date: Wed, 20 Oct 2021 12:43:59 -0500
>>>> Subject: [PATCH] signal: Implement force_fatal_sig
>>>>
>>>>
>>>>
>>>>
>>>> and if the other patch for signal that has similar description should land
>>>> in 5.15:
>>>>
>>>>  From fcb116bc43c8c37c052530ead79872f8b2615711 Mon Sep 17 00:00:00 2001
>>>> From: "Eric W. Biederman" <ebiederm@xmission.com>
>>>> Date: Thu, 18 Nov 2021 14:23:21 -0600
>>>> Subject: [PATCH] signal: Replace force_fatal_sig with force_exit_sig when in
>>>> doubt
>>>>
>>>>
>>>>
>>>> then the list is looks something like:
>>>>
>>>>
>>>>  From 941edc5bf174b67f94db19817cbeab0a93e0c32a Mon Sep 17 00:00:00 2001
>>>> From: "Eric W. Biederman" <ebiederm@xmission.com>
>>>> Date: Wed, 20 Oct 2021 12:44:00 -0500
>>>> Subject: [PATCH] exit/syscall_user_dispatch: Send ordinary signals on
>>>> failure
>>>>
>>>>  From 83a1f27ad773b1d8f0460d3a676114c7651918cc Mon Sep 17 00:00:00 2001
>>>> From: "Eric W. Biederman" <ebiederm@xmission.com>
>>>> Date: Wed, 20 Oct 2021 12:43:53 -0500
>>>> Subject: [PATCH] signal/powerpc: On swapcontext failure force SIGSEGV
>>>>
>>>>  From 9bc508cf0791c8e5a37696de1a046d746fcbd9d8 Mon Sep 17 00:00:00 2001
>>>> From: "Eric W. Biederman" <ebiederm@xmission.com>
>>>> Date: Wed, 20 Oct 2021 12:43:57 -0500
>>>> Subject: [PATCH] signal/s390: Use force_sigsegv in default_trap_handler
>>>>
>>>>  From c317d306d55079525c9610267fdaf3a8a6d2f08b Mon Sep 17 00:00:00 2001
>>>> From: "Eric W. Biederman" <ebiederm@xmission.com>
>>>> Date: Wed, 20 Oct 2021 12:44:01 -0500
>>>> Subject: [PATCH] signal/sparc32: Exit with a fatal signal when
>>>>   try_to_clear_window_buffer fails
>>>>
>>>>  From 086ec444f86660e103de8945d0dcae9b67132ac9 Mon Sep 17 00:00:00 2001
>>>> From: "Eric W. Biederman" <ebiederm@xmission.com>
>>>> Date: Wed, 20 Oct 2021 12:44:02 -0500
>>>> Subject: [PATCH] signal/sparc32: In setup_rt_frame and setup_fram use
>>>>   force_fatal_sig
>>>>
>>>>  From 1fbd60df8a852d9c55de8cd3621899cf4c72a5b7 Mon Sep 17 00:00:00 2001
>>>> From: "Eric W. Biederman" <ebiederm@xmission.com>
>>>> Date: Wed, 20 Oct 2021 12:43:56 -0500
>>>> Subject: [PATCH] signal/vm86_32: Properly send SIGSEGV when the vm86 state
>>>> cannot be saved.
>>>>
>>>>  From 695dd0d634df8903e5ead8aa08d326f63b23368a Mon Sep 17 00:00:00 2001
>>>> From: "Eric W. Biederman" <ebiederm@xmission.com>
>>>> Date: Wed, 20 Oct 2021 12:44:03 -0500
>>>> Subject: [PATCH] signal/x86: In emulate_vsyscall force a signal instead of
>>>> calling do_exit
>>>>
>>>>  From 26d5badbccddcc063dc5174a2baffd13a23322aa Mon Sep 17 00:00:00 2001
>>>> From: "Eric W. Biederman" <ebiederm@xmission.com>
>>>> Date: Wed, 20 Oct 2021 12:43:59 -0500
>>>> Subject: [PATCH] signal: Implement force_fatal_sig
>>>>
>>>>  From e21294a7aaae32c5d7154b187113a04db5852e37 Mon Sep 17 00:00:00 2001
>>>> From: "Eric W. Biederman" <ebiederm@xmission.com>
>>>> Date: Mon, 25 Oct 2021 10:50:57 -0500
>>>> Subject: [PATCH] signal: Replace force_sigsegv(SIGSEGV) with
>>>>   force_fatal_sig(SIGSEGV)
>>>>
>>>>  From e349d945fac76bddc78ae1cb92a0145b427a87ce Mon Sep 17 00:00:00 2001
>>>> From: "Eric W. Biederman" <ebiederm@xmission.com>
>>>> Date: Thu, 18 Nov 2021 11:11:13 -0600
>>>> Subject: [PATCH] signal: Don't always set SA_IMMUTABLE for forced signals
>>>>
>>>>  From fcb116bc43c8c37c052530ead79872f8b2615711 Mon Sep 17 00:00:00 2001
>>>> From: "Eric W. Biederman" <ebiederm@xmission.com>
>>>> Date: Thu, 18 Nov 2021 14:23:21 -0600
>>>> Subject: [PATCH] signal: Replace force_fatal_sig with force_exit_sig when in
>>>> doubt
>>>>
>>>>
>>>>
>>>> Applying them in listed order on top of 5.14.4 and builds/runs on i586,
>>>> x86_64, armv7hl, aarch64
>>> That series list is crazy, let me go try it and see what blows up! :)
>> Maybe I am wrong but I think "Don't always set SA_IMMUTABLE for forced
>> signals" will apply if you drop the hunk modifying force_fatal_sig.
>> Then you don't need to backport all of the cleanups just the fix.
>>
>> I will take a quick look and verify that.
>
>
> that's why i wrote: "if the other patch for signal that has similar
> description should land"

Apologies for not responding to that bit, I was reading quickly
and I missed that bit.

The second patch does not need to land in 5.15.

> (meaning "signal: Replace force_fatal_sig with force_exit_sig when in
> doubt")
>
> as thats the one needing the whole patch series...
>
>
> since going by patch descriptions for:
>
> "signal: Don't always set SA_IMMUTABLE for forced signals"
>
> "signal: Replace force_fatal_sig with force_exit_sig when in doubt"
>
>
> both has the info:
>
> "Unfortunately this broke debuggers[1][2] which reasonably expect
> to be able to trap synchronous SIGTRAP and SIGSEGV even when
> the target process is not configured to handle those signals."
>
> and the second even has:
> "This avoids userspace regressions as older kernels exited with do_exit
> which debuggers also can not intercept."
>
>
> or is the patch description on the second patch somewhat misleading ?

It is the same problem.  But it only applies to code that was merged
post 5.15.

For 5.15 on force_sig_seccomp is really affected.

For 5.16 there were many calls to do_exit that I turned into signals.
Some of the properly should be oridinary signals and some of them
for correctness purposes can't allow debuggers or userspace to intercept
them.

The second patch went through and modified everything that was
non-interceptible before 5.16 to be non-interceptible in 5.16.  Where
that is not necessary we can relax things later.

But for 5.15 only the one patch needs to be applied.

Eric
