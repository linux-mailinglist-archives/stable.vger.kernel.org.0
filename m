Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 929F2180200
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 16:38:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726526AbgCJPiF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 11:38:05 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:44554 "EHLO
        out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726380AbgCJPiF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Mar 2020 11:38:05 -0400
Received: from in01.mta.xmission.com ([166.70.13.51])
        by out03.mta.xmission.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.90_1)
        (envelope-from <ebiederm@xmission.com>)
        id 1jBgxE-0001AS-RF; Tue, 10 Mar 2020 09:38:00 -0600
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95] helo=x220.xmission.com)
        by in01.mta.xmission.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.87)
        (envelope-from <ebiederm@xmission.com>)
        id 1jBgxD-0000sr-Jr; Tue, 10 Mar 2020 09:38:00 -0600
From:   ebiederm@xmission.com (Eric W. Biederman)
To:     Bernd Edlinger <bernd.edlinger@hotmail.de>
Cc:     Christian Brauner <christian.brauner@ubuntu.com>,
        Kees Cook <keescook@chromium.org>,
        Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Oleg Nesterov <oleg@redhat.com>,
        Frederic Weisbecker <frederic@kernel.org>,
        Andrei Vagin <avagin@gmail.com>,
        Ingo Molnar <mingo@kernel.org>,
        "Peter Zijlstra \(Intel\)" <peterz@infradead.org>,
        Yuyang Du <duyuyang@gmail.com>,
        David Hildenbrand <david@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        David Howells <dhowells@redhat.com>,
        James Morris <jamorris@linux.microsoft.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Shakeel Butt <shakeelb@google.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Christian Kellner <christian@kellner.me>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Aleksa Sarai <cyphar@cyphar.com>,
        "Dmitry V. Levin" <ldv@altlinux.org>,
        "linux-doc\@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel\@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-mm\@kvack.org" <linux-mm@kvack.org>,
        "stable\@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-api\@vger.kernel.org" <linux-api@vger.kernel.org>
References: <AM6PR03MB5170EB4427BF5C67EE98FF09E4E60@AM6PR03MB5170.eurprd03.prod.outlook.com>
        <87r1y8dqqz.fsf@x220.int.ebiederm.org>
        <AM6PR03MB517053AED7DC89F7C0704B7DE4E50@AM6PR03MB5170.eurprd03.prod.outlook.com>
        <AM6PR03MB51703B44170EAB4626C9B2CAE4E20@AM6PR03MB5170.eurprd03.prod.outlook.com>
        <87tv32cxmf.fsf_-_@x220.int.ebiederm.org>
        <87v9ne5y4y.fsf_-_@x220.int.ebiederm.org>
        <87zhcq4jdj.fsf_-_@x220.int.ebiederm.org>
        <AM6PR03MB5170BC58D90BAD80CDEF3F8BE4FE0@AM6PR03MB5170.eurprd03.prod.outlook.com>
        <878sk94eay.fsf@x220.int.ebiederm.org>
        <AM6PR03MB517086003BD2C32E199690A3E4FE0@AM6PR03MB5170.eurprd03.prod.outlook.com>
        <87r1y12yc7.fsf@x220.int.ebiederm.org>
        <87k13t2xpd.fsf@x220.int.ebiederm.org>
        <87d09l2x5n.fsf@x220.int.ebiederm.org>
        <AM6PR03MB5170F0F9DC18F5EA77C9A857E4FE0@AM6PR03MB5170.eurprd03.prod.outlook.com>
        <871rq12vxu.fsf@x220.int.ebiederm.org>
        <AM6PR03MB5170DF45E3245F55B95CCD91E4FE0@AM6PR03MB5170.eurprd03.prod.outlook.com>
        <877dzt1fnf.fsf@x220.int.ebiederm.org>
        <AM6PR03MB51701C6F60699F99C5C67E0BE4FF0@AM6PR03MB5170.eurprd03.prod.outlook.com>
Date:   Tue, 10 Mar 2020 10:35:41 -0500
In-Reply-To: <AM6PR03MB51701C6F60699F99C5C67E0BE4FF0@AM6PR03MB5170.eurprd03.prod.outlook.com>
        (Bernd Edlinger's message of "Tue, 10 Mar 2020 14:43:21 +0100")
Message-ID: <875zfcxlwy.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1jBgxD-0000sr-Jr;;;mid=<875zfcxlwy.fsf@x220.int.ebiederm.org>;;;hst=in01.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18NOUXxtLcovq85kyfc0MbvMJLCG3mnAmU=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on sa07.xmission.com
X-Spam-Level: **
X-Spam-Status: No, score=2.0 required=8.0 tests=ALL_TRUSTED,BAYES_50,
        DCC_CHECK_NEGATIVE,T_TM2_M_HEADER_IN_MSG,XMNoVowels,XMSubLong
        autolearn=disabled version=3.4.2
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.4887]
        *  1.5 XMNoVowels Alpha-numberic number with no vowels
        *  0.7 XMSubLong Long Subject
        *  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
        * -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
        *      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: **;Bernd Edlinger <bernd.edlinger@hotmail.de>
X-Spam-Relay-Country: 
X-Spam-Timing: total 698 ms - load_scoreonly_sql: 0.05 (0.0%),
        signal_user_changed: 6 (0.8%), b_tie_ro: 3.6 (0.5%), parse: 0.98
        (0.1%), extract_message_metadata: 11 (1.5%), get_uri_detail_list: 0.89
        (0.1%), tests_pri_-1000: 8 (1.2%), tests_pri_-950: 1.24 (0.2%),
        tests_pri_-900: 1.05 (0.2%), tests_pri_-90: 32 (4.5%), check_bayes: 30
        (4.2%), b_tokenize: 12 (1.7%), b_tok_get_all: 8 (1.1%), b_comp_prob:
        3.6 (0.5%), b_tok_touch_all: 3.8 (0.5%), b_finish: 0.66 (0.1%),
        tests_pri_0: 627 (89.8%), check_dkim_signature: 0.50 (0.1%),
        check_dkim_adsp: 2.1 (0.3%), poll_dns_idle: 0.30 (0.0%), tests_pri_10:
        2.0 (0.3%), tests_pri_500: 6 (0.8%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCH 0/4] Use new infrastructure to fix deadlocks in execve
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Thu, 05 May 2016 13:38:54 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Bernd Edlinger <bernd.edlinger@hotmail.de> writes:

> This is a follow up on Eric's patch series to
> fix the deadlocks observed with ptracing when execve
> in multi-threaded applications.
>
> This fixes the simple and most important case where
> the cred_guard_mutex causes strace to deadlock.
>
> This also adds a test case (which is only partially
> fixed so far, the rest of the fixes will follow
> soon).
>
> Two trivial comment fixes are also included.
>
> Bernd Edlinger (4):
>   exec: Fix a deadlock in ptrace
>   selftests/ptrace: add test cases for dead-locks
>   mm: docs: Fix a comment in process_vm_rw_core
>   kernel: doc: remove outdated comment in prepare_kernel_cred
>
>  kernel/cred.c                             |  2 -
>  kernel/fork.c                             |  4 +-
>  mm/process_vm_access.c                    |  2 +-
>  tools/testing/selftests/ptrace/Makefile   |  4 +-
>  tools/testing/selftests/ptrace/vmaccess.c | 86 +++++++++++++++++++++++++++++++
>  5 files changed, 91 insertions(+), 7 deletions(-)
>  create mode 100644 tools/testing/selftests/ptrace/vmaccess.c

Applied.

Thank you,
Eric

