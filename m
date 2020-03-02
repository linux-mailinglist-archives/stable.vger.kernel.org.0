Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E72A3175F09
	for <lists+stable@lfdr.de>; Mon,  2 Mar 2020 17:00:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727092AbgCBQAA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Mar 2020 11:00:00 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:38722 "EHLO
        out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727084AbgCBQAA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Mar 2020 11:00:00 -0500
Received: from in01.mta.xmission.com ([166.70.13.51])
        by out03.mta.xmission.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.90_1)
        (envelope-from <ebiederm@xmission.com>)
        id 1j8nTw-0002Lm-9d; Mon, 02 Mar 2020 08:59:48 -0700
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95] helo=x220.xmission.com)
        by in01.mta.xmission.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.87)
        (envelope-from <ebiederm@xmission.com>)
        id 1j8nTv-0005zV-Cp; Mon, 02 Mar 2020 08:59:48 -0700
From:   ebiederm@xmission.com (Eric W. Biederman)
To:     Bernd Edlinger <bernd.edlinger@hotmail.de>
Cc:     Jann Horn <jannh@google.com>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Jonathan Corbet <corbet@lwn.net>,
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
        Kees Cook <keescook@chromium.org>,
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
        "stable\@vger.kernel.org" <stable@vger.kernel.org>
References: <AM6PR03MB5170B06F3A2B75EFB98D071AE4E60@AM6PR03MB5170.eurprd03.prod.outlook.com>
        <CAG48ez3QHVpMJ9Rb_Q4LEE6uAqQJeS1Myu82U=fgvUfoeiscgw@mail.gmail.com>
        <20200301185244.zkofjus6xtgkx4s3@wittgenstein>
        <CAG48ez3mnYc84iFCA25-rbJdSBi3jh9hkp569XZTbFc_9WYbZw@mail.gmail.com>
        <AM6PR03MB5170EB4427BF5C67EE98FF09E4E60@AM6PR03MB5170.eurprd03.prod.outlook.com>
        <87a74zmfc9.fsf@x220.int.ebiederm.org>
        <AM6PR03MB517071DEF894C3D72D2B4AE2E4E70@AM6PR03MB5170.eurprd03.prod.outlook.com>
Date:   Mon, 02 Mar 2020 09:57:36 -0600
In-Reply-To: <AM6PR03MB517071DEF894C3D72D2B4AE2E4E70@AM6PR03MB5170.eurprd03.prod.outlook.com>
        (Bernd Edlinger's message of "Mon, 2 Mar 2020 15:43:24 +0000")
Message-ID: <87k142lpfz.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1j8nTv-0005zV-Cp;;;mid=<87k142lpfz.fsf@x220.int.ebiederm.org>;;;hst=in01.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/lt4on91tMaQ1/pOt4zAqlZlKm4+95UyU=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on sa07.xmission.com
X-Spam-Level: 
X-Spam-Status: No, score=-0.2 required=8.0 tests=ALL_TRUSTED,BAYES_50,
        DCC_CHECK_NEGATIVE,T_TM2_M_HEADER_IN_MSG autolearn=disabled
        version=3.4.2
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.4692]
        *  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
        * -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
        *      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Bernd Edlinger <bernd.edlinger@hotmail.de>
X-Spam-Relay-Country: 
X-Spam-Timing: total 406 ms - load_scoreonly_sql: 0.05 (0.0%),
        signal_user_changed: 2.5 (0.6%), b_tie_ro: 1.68 (0.4%), parse: 1.35
        (0.3%), extract_message_metadata: 15 (3.8%), get_uri_detail_list: 1.57
        (0.4%), tests_pri_-1000: 22 (5.5%), tests_pri_-950: 1.57 (0.4%),
        tests_pri_-900: 1.38 (0.3%), tests_pri_-90: 36 (8.8%), check_bayes: 34
        (8.4%), b_tokenize: 16 (4.0%), b_tok_get_all: 8 (1.9%), b_comp_prob:
        3.3 (0.8%), b_tok_touch_all: 4.3 (1.1%), b_finish: 0.61 (0.2%),
        tests_pri_0: 311 (76.6%), check_dkim_signature: 1.08 (0.3%),
        check_dkim_adsp: 4.3 (1.1%), poll_dns_idle: 0.25 (0.1%), tests_pri_10:
        3.0 (0.7%), tests_pri_500: 8 (1.9%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCHv2] exec: Fix a deadlock in ptrace
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Thu, 05 May 2016 13:38:54 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Bernd Edlinger <bernd.edlinger@hotmail.de> writes:

>
> I tried this with s/EACCESS/EACCES/.
>
> The test case in this patch is not fixed, but strace does not freeze,
> at least with my setup where it did freeze repeatable.

Thanks, That is what I was aiming at.

So we have one method we can pursue to fix this in practice.

> That is
> obviously because it bypasses the cred_guard_mutex.  But all other
> process that access this file still freeze, and cannot be
> interrupted except with kill -9.
>
> However that smells like a denial of service, that this
> simple test case which can be executed by guest, creates a /proc/$pid/mem
> that freezes any process, even root, when it looks at it.
> I mean: "ln -s README /proc/$pid/mem" would be a nice bomb.

Yes.  Your the test case in your patch a variant of the original
problem.


I have been staring at this trying to understand the fundamentals of the
original deeper problem.

The current scope of cred_guard_mutex in exec is because being ptraced
causes suid exec to act differently.  So we need to know early if we are
ptraced.

If that case did not exist we could reduce the scope of the
cred_guard_mutex in exec to where your patch puts the cred_change_mutex.

I am starting to think reworking how we deal with ptrace and exec is the
way to solve this problem.

Eric
