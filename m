Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81E4E483A2
	for <lists+stable@lfdr.de>; Mon, 17 Jun 2019 15:14:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726362AbfFQNOU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jun 2019 09:14:20 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:55183 "EHLO
        out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725884AbfFQNOU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jun 2019 09:14:20 -0400
Received: from in01.mta.xmission.com ([166.70.13.51])
        by out01.mta.xmission.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.87)
        (envelope-from <ebiederm@xmission.com>)
        id 1hcrSl-0007yz-J5; Mon, 17 Jun 2019 07:14:19 -0600
Received: from ip72-206-97-68.om.om.cox.net ([72.206.97.68] helo=x220.xmission.com)
        by in01.mta.xmission.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.87)
        (envelope-from <ebiederm@xmission.com>)
        id 1hcrSk-0001FO-Gv; Mon, 17 Jun 2019 07:14:19 -0600
From:   ebiederm@xmission.com (Eric W. Biederman)
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     avagin@gmail.com, linux- stable <stable@vger.kernel.org>,
        lkft-triage@lists.linaro.org,
        "open list\:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        Naresh Kamboju <naresh.kamboju@linaro.org>
References: <CA+G9fYsFL5AH6dkdN2Qd6UP=wdiXRDR_ioQFPSCq=uUBcmtHXw@mail.gmail.com>
Date:   Mon, 17 Jun 2019 08:13:56 -0500
In-Reply-To: <CA+G9fYsFL5AH6dkdN2Qd6UP=wdiXRDR_ioQFPSCq=uUBcmtHXw@mail.gmail.com>
        (Naresh Kamboju's message of "Mon, 17 Jun 2019 13:45:32 +0530")
Message-ID: <87lfy0pd63.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/25.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1hcrSk-0001FO-Gv;;;mid=<87lfy0pd63.fsf@xmission.com>;;;hst=in01.mta.xmission.com;;;ip=72.206.97.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19zUOHX1EtF3RkCCzZZMbH5Xciw+14zHdQ=
X-SA-Exim-Connect-IP: 72.206.97.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on sa07.xmission.com
X-Spam-Level: *
X-Spam-Status: No, score=1.7 required=8.0 tests=ALL_TRUSTED,BAYES_50,
        DCC_CHECK_NEGATIVE,LotsOfNums_01,T_TM2_M_HEADER_IN_MSG,XMSubLong
        autolearn=disabled version=3.4.2
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        *  0.7 XMSubLong Long Subject
        *  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
        *  1.2 LotsOfNums_01 BODY: Lots of long strings of numbers
        * -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
        *      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *;Greg Kroah-Hartman <gregkh@linuxfoundation.org>
X-Spam-Relay-Country: 
X-Spam-Timing: total 546 ms - load_scoreonly_sql: 0.06 (0.0%),
        signal_user_changed: 2.6 (0.5%), b_tie_ro: 1.76 (0.3%), parse: 1.37
        (0.3%), extract_message_metadata: 35 (6.3%), get_uri_detail_list: 5
        (0.9%), tests_pri_-1000: 47 (8.6%), tests_pri_-950: 1.37 (0.3%),
        tests_pri_-900: 1.14 (0.2%), tests_pri_-90: 30 (5.4%), check_bayes: 28
        (5.1%), b_tokenize: 9 (1.7%), b_tok_get_all: 10 (1.9%), b_comp_prob:
        2.8 (0.5%), b_tok_touch_all: 3.4 (0.6%), b_finish: 0.57 (0.1%),
        tests_pri_0: 413 (75.5%), check_dkim_signature: 0.71 (0.1%),
        check_dkim_adsp: 2.5 (0.5%), poll_dns_idle: 0.54 (0.1%), tests_pri_10:
        2.4 (0.4%), tests_pri_500: 10 (1.8%), rewrite_mail: 0.00 (0.0%)
Subject: Re: stable-rc: ptrace: peeksiginfo failed on 4.19, 4.14, 4.9 and 4.4
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Thu, 05 May 2016 13:38:54 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Naresh Kamboju <naresh.kamboju@linaro.org> writes:

> selftests: ptrace: peeksiginfo failed on x86_64, i386, arm64 and arm.
> FAILED on stable rc branches 4.19, 4.14, 4.9 and 4.4.
> PASS on mainline, next and 5.1 stable rc branch.

Greg.

Looking in my email it appears 4.19, 4.14, 4.9, and 4.4 patches are
missing the "found=1" line from the original change.   This explains
the test failure.

Can you handle this?

Thanks,
Eric


> Test output:
> ------------------
> cd /opt/kselftests/mainline/ptrace
> ./peeksiginfo
> Error (peeksiginfo.c:143): Only 0 signals were read
>
> The git bisect show that below commit caused this test to fail.
>
>  git bisect bad
> 5b6b0eac235ef1f915f24eda6d501a754022cbf0 is the first bad commit
> commit 5b6b0eac235ef1f915f24eda6d501a754022cbf0
> Author: Eric W. Biederman <ebiederm@xmission.com>
> Date:   Tue May 28 18:46:37 2019 -0500
>
>     signal/ptrace: Don't leak unitialized kernel memory with PTRACE_PEEK_SIGINFO
>
>     commit f6e2aa91a46d2bc79fce9b93a988dbe7655c90c0 upstream.
>
>     Recently syzbot in conjunction with KMSAN reported that
>     ptrace_peek_siginfo can copy an uninitialized siginfo to userspace.
>     Inspecting ptrace_peek_siginfo confirms this.
>
>     The problem is that off when initialized from args.off can be
>     initialized to a negaive value.  At which point the "if (off >= 0)"
>     test to see if off became negative fails because off started off
>     negative.
>
>     Prevent the core problem by adding a variable found that is only true
>     if a siginfo is found and copied to a temporary in preparation for
>     being copied to userspace.
>
>     Prevent args.off from being truncated when being assigned to off by
>     testing that off is <= the maximum possible value of off.  Convert off
>     to an unsigned long so that we should not have to truncate args.off,
>     we have well defined overflow behavior so if we add another check we
>     won't risk fighting undefined compiler behavior, and so that we have a
>     type whose maximum value is easy to test for.
>
>     Cc: Andrei Vagin <avagin@gmail.com>
>     Cc: stable@vger.kernel.org
>     Reported-by: syzbot+0d602a1b0d8c95bdf299@syzkaller.appspotmail.com
>     Fixes: 84c751bd4aeb ("ptrace: add ability to retrieve signals
> without removing from a queue (v4)")
>     Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
>     Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>
> :040000 040000 ff9f3109f210274d0b87851d226c35e7305ce44a
> b36de2c855fe2a0b332f145f0966dc1a0304d4bd M kernel
>
> Test case link,
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/tools/testing/selftests/ptrace/peeksiginfo.c#n143
>
> Test output log link,
> https://lkft.validation.linaro.org/scheduler/job/777223#L1084
>
> Test results comparison on different branches,
> https://qa-reports.linaro.org/_/comparetest/?project=22&project=6&project=58&project=135&project=40&project=23&project=167&suite=kselftest&test=ptrace_peeksiginfo
>
> Best regards
> Naresh Kamboju
