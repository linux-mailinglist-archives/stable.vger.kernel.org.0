Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA5F617E98D
	for <lists+stable@lfdr.de>; Mon,  9 Mar 2020 21:01:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726269AbgCIUAu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Mar 2020 16:00:50 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:36954 "EHLO
        out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725992AbgCIUAu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Mar 2020 16:00:50 -0400
Received: from in02.mta.xmission.com ([166.70.13.52])
        by out01.mta.xmission.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.90_1)
        (envelope-from <ebiederm@xmission.com>)
        id 1jBOa0-00020A-Nl; Mon, 09 Mar 2020 14:00:48 -0600
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95] helo=x220.xmission.com)
        by in02.mta.xmission.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.87)
        (envelope-from <ebiederm@xmission.com>)
        id 1jBOZz-000704-Uf; Mon, 09 Mar 2020 14:00:48 -0600
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
        <202003021531.C77EF10@keescook>
        <20200303085802.eqn6jbhwxtmz4j2x@wittgenstein>
        <AM6PR03MB5170285B336790D3450E2644E4E40@AM6PR03MB5170.eurprd03.prod.outlook.com>
        <87v9nlii0b.fsf@x220.int.ebiederm.org>
        <AM6PR03MB5170609D44967E044FD1BE40E4E40@AM6PR03MB5170.eurprd03.prod.outlook.com>
        <87a74xi4kz.fsf@x220.int.ebiederm.org>
        <AM6PR03MB51705AA3009B4986BB6EF92FE4E50@AM6PR03MB5170.eurprd03.prod.outlook.com>
        <87r1y8dqqz.fsf@x220.int.ebiederm.org>
        <AM6PR03MB517053AED7DC89F7C0704B7DE4E50@AM6PR03MB5170.eurprd03.prod.outlook.com>
        <AM6PR03MB51703B44170EAB4626C9B2CAE4E20@AM6PR03MB5170.eurprd03.prod.outlook.com>
        <87tv32cxmf.fsf_-_@x220.int.ebiederm.org>
        <87v9ne5y4y.fsf_-_@x220.int.ebiederm.org>
        <875zfe5xzb.fsf_-_@x220.int.ebiederm.org>
        <AM6PR03MB5170C3A4319BA6A057C3CCACE4FE0@AM6PR03MB5170.eurprd03.prod.outlook.com>
        <87tv2xz510.fsf@x220.int.ebiederm.org>
        <AM6PR03MB51709D441EE6830DC8CE3090E4FE0@AM6PR03MB5170.eurprd03.prod.outlook.com>
Date:   Mon, 09 Mar 2020 14:58:30 -0500
In-Reply-To: <AM6PR03MB51709D441EE6830DC8CE3090E4FE0@AM6PR03MB5170.eurprd03.prod.outlook.com>
        (Bernd Edlinger's message of "Mon, 9 Mar 2020 19:52:38 +0000")
Message-ID: <87mu8pz4ex.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1jBOZz-000704-Uf;;;mid=<87mu8pz4ex.fsf@x220.int.ebiederm.org>;;;hst=in02.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+ucALiSAok3l44Xl1kyMX8rcnnV7uxymg=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on sa05.xmission.com
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=8.0 tests=ALL_TRUSTED,BAYES_50,
        DCC_CHECK_NEGATIVE,T_TM2_M_HEADER_IN_MSG,T_TooManySym_01,XMSubLong
        autolearn=disabled version=3.4.2
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.4981]
        *  0.7 XMSubLong Long Subject
        *  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
        * -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
        *      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
        *  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Bernd Edlinger <bernd.edlinger@hotmail.de>
X-Spam-Relay-Country: 
X-Spam-Timing: total 274 ms - load_scoreonly_sql: 0.05 (0.0%),
        signal_user_changed: 2.5 (0.9%), b_tie_ro: 1.72 (0.6%), parse: 0.87
        (0.3%), extract_message_metadata: 11 (4.2%), get_uri_detail_list: 0.90
        (0.3%), tests_pri_-1000: 22 (8.1%), tests_pri_-950: 1.13 (0.4%),
        tests_pri_-900: 0.82 (0.3%), tests_pri_-90: 25 (9.1%), check_bayes: 24
        (8.7%), b_tokenize: 9 (3.2%), b_tok_get_all: 7 (2.7%), b_comp_prob:
        1.89 (0.7%), b_tok_touch_all: 3.9 (1.4%), b_finish: 0.67 (0.2%),
        tests_pri_0: 197 (72.2%), check_dkim_signature: 0.50 (0.2%),
        check_dkim_adsp: 1.95 (0.7%), poll_dns_idle: 0.60 (0.2%),
        tests_pri_10: 1.94 (0.7%), tests_pri_500: 8 (2.8%), rewrite_mail: 0.00
        (0.0%)
Subject: Re: [PATCH v2 4/5] exec: Move exec_mmap right after de_thread in flush_old_exec
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Thu, 05 May 2016 13:38:54 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Ok.  I think this has it sorted:

    exec: Move exec_mmap right after de_thread in flush_old_exec
    
    I have read through the code in exec_mmap and I do not see anything
    that depends on sighand or the sighand lock, or on signals in anyway
    so this should be safe.
    
    This rearrangement of code has two significant benefits.  It makes
    the determination of passing the point of no return by testing bprm->mm
    accurate.  All failures prior to that point in flush_old_exec are
    either truly recoverable or they are fatal.
    
    Further this consolidates all of the possible indefinite waits for
    userspace together at the top of flush_old_exec.  The possible wait
    for a ptracer on PTRACE_EVENT_EXIT, the possible wait for a page fault
    to be resolved in clear_child_tid, and the possible wait for a page
    fault in exit_robust_list.
    
    This consolidation allows the creation of a mutex to replace
    cred_guard_mutex that is not held over possible indefinite userspace
    waits.  Which will allow removing deadlock scenarios from the kernel.
    
    Reviewed-by: Bernd Edlinger <bernd.edlinger@hotmail.de>
    Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>


I don't think I usually have this many typos.  Sigh.

Eric
