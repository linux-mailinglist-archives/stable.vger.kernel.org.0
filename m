Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B334C17E756
	for <lists+stable@lfdr.de>; Mon,  9 Mar 2020 19:38:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727335AbgCISim (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Mar 2020 14:38:42 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:37496 "EHLO
        out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726661AbgCISim (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Mar 2020 14:38:42 -0400
Received: from in02.mta.xmission.com ([166.70.13.52])
        by out01.mta.xmission.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.90_1)
        (envelope-from <ebiederm@xmission.com>)
        id 1jBNIV-0000rV-6s; Mon, 09 Mar 2020 12:38:39 -0600
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95] helo=x220.xmission.com)
        by in02.mta.xmission.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.87)
        (envelope-from <ebiederm@xmission.com>)
        id 1jBNIU-0005Pe-BL; Mon, 09 Mar 2020 12:38:38 -0600
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
        <87zhcq4jdj.fsf_-_@x220.int.ebiederm.org>
        <AM6PR03MB5170BC58D90BAD80CDEF3F8BE4FE0@AM6PR03MB5170.eurprd03.prod.outlook.com>
        <878sk94eay.fsf@x220.int.ebiederm.org>
        <AM6PR03MB517086003BD2C32E199690A3E4FE0@AM6PR03MB5170.eurprd03.prod.outlook.com>
        <87r1y12yc7.fsf@x220.int.ebiederm.org>
        <87k13t2xpd.fsf@x220.int.ebiederm.org>
Date:   Mon, 09 Mar 2020 13:36:20 -0500
In-Reply-To: <87k13t2xpd.fsf@x220.int.ebiederm.org> (Eric W. Biederman's
        message of "Mon, 09 Mar 2020 13:24:30 -0500")
Message-ID: <87d09l2x5n.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1jBNIU-0005Pe-BL;;;mid=<87d09l2x5n.fsf@x220.int.ebiederm.org>;;;hst=in02.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/fZjeW/NriwHgNNjscJbvec1XcCRYAn24=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on sa04.xmission.com
X-Spam-Level: *
X-Spam-Status: No, score=1.7 required=8.0 tests=ALL_TRUSTED,BAYES_50,
        DCC_CHECK_NEGATIVE,LotsOfNums_01,T_TM2_M_HEADER_IN_MSG,T_TooManySym_01,
        XMSubLong autolearn=disabled version=3.4.2
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        *  0.7 XMSubLong Long Subject
        *  1.2 LotsOfNums_01 BODY: Lots of long strings of numbers
        *  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
        * -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
        *      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
        *  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *;Bernd Edlinger <bernd.edlinger@hotmail.de>
X-Spam-Relay-Country: 
X-Spam-Timing: total 349 ms - load_scoreonly_sql: 0.03 (0.0%),
        signal_user_changed: 6 (1.8%), b_tie_ro: 4.2 (1.2%), parse: 1.02
        (0.3%), extract_message_metadata: 11 (3.2%), get_uri_detail_list: 2.1
        (0.6%), tests_pri_-1000: 16 (4.7%), tests_pri_-950: 1.15 (0.3%),
        tests_pri_-900: 1.01 (0.3%), tests_pri_-90: 36 (10.3%), check_bayes:
        35 (9.9%), b_tokenize: 12 (3.4%), b_tok_get_all: 11 (3.2%),
        b_comp_prob: 2.4 (0.7%), b_tok_touch_all: 7 (1.9%), b_finish: 0.60
        (0.2%), tests_pri_0: 266 (76.1%), check_dkim_signature: 1.10 (0.3%),
        check_dkim_adsp: 3.3 (0.9%), poll_dns_idle: 0.72 (0.2%), tests_pri_10:
        2.0 (0.6%), tests_pri_500: 6 (1.6%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCH v2 5/5] exec: Add a exec_update_mutex to replace cred_guard_mutex
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Thu, 05 May 2016 13:38:54 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


My rewritten change description reads as follows:

    exec: Add a exec_update_mutex to replace cred_guard_mutex
    
    The cred_guard_mutex is problematic as it is held over possibly
    indefinite waits for userspace.  The possilbe indefinite waits for
    userspace that I have identified are: The cred_guard_mutex is held in
    PTRACE_EVENT_EXIT waiting for the tracer.  The cred_guard_mutex is
    held over "put_user(0, tsk->clear_child_tid)" in exit_mm().  The
    cred_guard_mutex is held over "get_user(futex_offset, ...")  in
    exit_robust_list.  The cred_guard_mutex held over copy_strings.
    
    The functions get_user and put_user can trigger a page fault which can
    potentially wait indefinitely in the case of userfaultfd or if
    userspace implements part of the page fault path.
    
    In any of those cases the userspace process that the kernel is waiting
    for might userspace might make a different system call that winds up
    taking the cred_guard_mutex and result in deadlock.
    
    Holding a mutex over any of those possibly indefinite waits for
    userspace does not appear necessary.  Add exec_update_mutex that will
    just cover updating the process during exec where the permissions and
    the objects pointed to by the task struct may be out of sync.
    
    The plan is to switch the users of cred_guard_mutex to
    exec_udpate_mutex one by one.  This lets us move forward while still
    being careful and not introducing any regressions.
    
    Link: https://lore.kernel.org/lkml/20160921152946.GA24210@dhcp22.suse.cz/
    Link: https://lore.kernel.org/lkml/AM6PR03MB5170B06F3A2B75EFB98D071AE4E60@AM6PR03MB5170.eurprd03.prod.outlook.com/
    Link: https://lore.kernel.org/linux-fsdevel/20161102181806.GB1112@redhat.com/
    Link: https://lore.kernel.org/lkml/20160923095031.GA14923@redhat.com/
    Link: https://lore.kernel.org/lkml/20170213141452.GA30203@redhat.com/
    Ref: 45c1a159b85b ("Add PTRACE_O_TRACEVFORKDONE and PTRACE_O_TRACEEXIT facilities.")
    Ref: 456f17cd1a28 ("[PATCH] user-vm-unlock-2.5.31-A2")
    Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>

Does that sound better?

Eric
