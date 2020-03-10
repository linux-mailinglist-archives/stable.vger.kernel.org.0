Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88BBB180A0A
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 22:11:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726426AbgCJVL3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 17:11:29 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:44262 "EHLO
        out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726100AbgCJVL3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Mar 2020 17:11:29 -0400
Received: from in02.mta.xmission.com ([166.70.13.52])
        by out03.mta.xmission.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.90_1)
        (envelope-from <ebiederm@xmission.com>)
        id 1jBm9u-0000b5-VI; Tue, 10 Mar 2020 15:11:27 -0600
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95] helo=x220.xmission.com)
        by in02.mta.xmission.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.87)
        (envelope-from <ebiederm@xmission.com>)
        id 1jBm9u-0007sT-8M; Tue, 10 Mar 2020 15:11:26 -0600
From:   ebiederm@xmission.com (Eric W. Biederman)
To:     Kees Cook <keescook@chromium.org>
Cc:     Bernd Edlinger <bernd.edlinger@hotmail.de>,
        Christian Brauner <christian.brauner@ubuntu.com>,
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
References: <87v9nlii0b.fsf@x220.int.ebiederm.org>
        <AM6PR03MB5170609D44967E044FD1BE40E4E40@AM6PR03MB5170.eurprd03.prod.outlook.com>
        <87a74xi4kz.fsf@x220.int.ebiederm.org>
        <AM6PR03MB51705AA3009B4986BB6EF92FE4E50@AM6PR03MB5170.eurprd03.prod.outlook.com>
        <87r1y8dqqz.fsf@x220.int.ebiederm.org>
        <AM6PR03MB517053AED7DC89F7C0704B7DE4E50@AM6PR03MB5170.eurprd03.prod.outlook.com>
        <AM6PR03MB51703B44170EAB4626C9B2CAE4E20@AM6PR03MB5170.eurprd03.prod.outlook.com>
        <87tv32cxmf.fsf_-_@x220.int.ebiederm.org>
        <87v9ne5y4y.fsf_-_@x220.int.ebiederm.org>
        <875zfe5xzb.fsf_-_@x220.int.ebiederm.org>
        <202003101344.8777D43A44@keescook>
Date:   Tue, 10 Mar 2020 16:09:07 -0500
In-Reply-To: <202003101344.8777D43A44@keescook> (Kees Cook's message of "Tue,
        10 Mar 2020 13:47:51 -0700")
Message-ID: <87r1xzrk7g.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1jBm9u-0007sT-8M;;;mid=<87r1xzrk7g.fsf@x220.int.ebiederm.org>;;;hst=in02.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1869cHHJ7TMyCuGI2yA9NNHqGaU0S/DZQI=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on sa07.xmission.com
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=8.0 tests=ALL_TRUSTED,BAYES_50,
        DCC_CHECK_NEGATIVE,T_TM2_M_HEADER_IN_MSG,T_TooManySym_01,XMSubLong
        autolearn=disabled version=3.4.2
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.4777]
        *  0.7 XMSubLong Long Subject
        *  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
        * -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
        *      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
        *  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Kees Cook <keescook@chromium.org>
X-Spam-Relay-Country: 
X-Spam-Timing: total 298 ms - load_scoreonly_sql: 0.03 (0.0%),
        signal_user_changed: 2.7 (0.9%), b_tie_ro: 1.93 (0.6%), parse: 0.95
        (0.3%), extract_message_metadata: 10 (3.4%), get_uri_detail_list: 0.83
        (0.3%), tests_pri_-1000: 16 (5.5%), tests_pri_-950: 1.28 (0.4%),
        tests_pri_-900: 1.07 (0.4%), tests_pri_-90: 27 (9.1%), check_bayes: 26
        (8.6%), b_tokenize: 10 (3.4%), b_tok_get_all: 7 (2.5%), b_comp_prob:
        2.2 (0.8%), b_tok_touch_all: 3.4 (1.1%), b_finish: 0.69 (0.2%),
        tests_pri_0: 219 (73.6%), check_dkim_signature: 0.50 (0.2%),
        check_dkim_adsp: 3.2 (1.1%), poll_dns_idle: 0.35 (0.1%), tests_pri_10:
        3.3 (1.1%), tests_pri_500: 12 (4.2%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCH v2 4/5] exec: Move exec_mmap right after de_thread in flush_old_exec
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Thu, 05 May 2016 13:38:54 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Kees Cook <keescook@chromium.org> writes:

> On Sun, Mar 08, 2020 at 04:38:00PM -0500, Eric W. Biederman wrote:
>> Futher this consolidates all of the possible indefinite waits for
>> userspace together at the top of flush_old_exec.  The possible wait
>> for a ptracer on PTRACE_EVENT_EXIT, the possible wait for a page fault
>> to be resolved in clear_child_tid, and the possible wait for a page
>> fault in exit_robust_list.
>
> I forgot to mention, just as a point of clarity, there are lots of
> other page faults possible, but they're _before_ flush_old_exec()
> (i.e. all the copy_strings() calls). Is it worth clarifying this to
> "before or at the top of flush_old_exec()" or do you mean something
> else? (And as always: perhaps expand flush_old_exec()'s comment to
> describe the newly intended state.)

Yes.  Before or at the start of flush_old_exec where the mutex
is taken.  That is the point.  I will see if I can come up with
and appropriate comment.

Eric



