Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C9A717E8F8
	for <lists+stable@lfdr.de>; Mon,  9 Mar 2020 20:45:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726169AbgCITor (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Mar 2020 15:44:47 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:60524 "EHLO
        out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726168AbgCITor (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Mar 2020 15:44:47 -0400
Received: from in01.mta.xmission.com ([166.70.13.51])
        by out01.mta.xmission.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.90_1)
        (envelope-from <ebiederm@xmission.com>)
        id 1jBOKT-0000LK-LE; Mon, 09 Mar 2020 13:44:45 -0600
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95] helo=x220.xmission.com)
        by in01.mta.xmission.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.87)
        (envelope-from <ebiederm@xmission.com>)
        id 1jBOKS-0006B0-CQ; Mon, 09 Mar 2020 13:44:45 -0600
From:   ebiederm@xmission.com (Eric W. Biederman)
To:     "Dmitry V. Levin" <ldv@altlinux.org>
Cc:     Bernd Edlinger <bernd.edlinger@hotmail.de>,
        Christian Brauner <christian.brauner@ubuntu.com>,
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
        "linux-doc\@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel\@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-mm\@kvack.org" <linux-mm@kvack.org>,
        "stable\@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-api\@vger.kernel.org" <linux-api@vger.kernel.org>
References: <87v9ne5y4y.fsf_-_@x220.int.ebiederm.org>
        <87zhcq4jdj.fsf_-_@x220.int.ebiederm.org>
        <AM6PR03MB5170BC58D90BAD80CDEF3F8BE4FE0@AM6PR03MB5170.eurprd03.prod.outlook.com>
        <878sk94eay.fsf@x220.int.ebiederm.org>
        <AM6PR03MB517086003BD2C32E199690A3E4FE0@AM6PR03MB5170.eurprd03.prod.outlook.com>
        <87r1y12yc7.fsf@x220.int.ebiederm.org>
        <87k13t2xpd.fsf@x220.int.ebiederm.org>
        <87d09l2x5n.fsf@x220.int.ebiederm.org>
        <AM6PR03MB5170F0F9DC18F5EA77C9A857E4FE0@AM6PR03MB5170.eurprd03.prod.outlook.com>
        <871rq12vxu.fsf@x220.int.ebiederm.org>
        <20200309193332.GA13534@altlinux.org>
Date:   Mon, 09 Mar 2020 14:42:26 -0500
In-Reply-To: <20200309193332.GA13534@altlinux.org> (Dmitry V. Levin's message
        of "Mon, 9 Mar 2020 22:33:33 +0300")
Message-ID: <871rq11fj1.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1jBOKS-0006B0-CQ;;;mid=<871rq11fj1.fsf@x220.int.ebiederm.org>;;;hst=in01.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19p24kmlglnsW31glyAX+zom+2dc6zCzvk=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on sa06.xmission.com
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=8.0 tests=ALL_TRUSTED,BAYES_50,
        DCC_CHECK_NEGATIVE,T_TM2_M_HEADER_IN_MSG,T_TooManySym_01,XMSubLong
        autolearn=disabled version=3.4.2
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.4912]
        *  0.7 XMSubLong Long Subject
        *  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
        * -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
        *      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
        *  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;"Dmitry V. Levin" <ldv@altlinux.org>
X-Spam-Relay-Country: 
X-Spam-Timing: total 532 ms - load_scoreonly_sql: 0.04 (0.0%),
        signal_user_changed: 2.9 (0.5%), b_tie_ro: 2.0 (0.4%), parse: 0.91
        (0.2%), extract_message_metadata: 14 (2.5%), get_uri_detail_list: 0.75
        (0.1%), tests_pri_-1000: 24 (4.5%), tests_pri_-950: 1.48 (0.3%),
        tests_pri_-900: 1.29 (0.2%), tests_pri_-90: 28 (5.3%), check_bayes: 27
        (5.0%), b_tokenize: 11 (2.1%), b_tok_get_all: 7 (1.3%), b_comp_prob:
        2.4 (0.4%), b_tok_touch_all: 3.6 (0.7%), b_finish: 0.65 (0.1%),
        tests_pri_0: 445 (83.7%), check_dkim_signature: 0.64 (0.1%),
        check_dkim_adsp: 2.7 (0.5%), poll_dns_idle: 0.98 (0.2%), tests_pri_10:
        1.98 (0.4%), tests_pri_500: 9 (1.7%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCH v2 5/5] exec: Add a exec_update_mutex to replace cred_guard_mutex
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Thu, 05 May 2016 13:38:54 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

"Dmitry V. Levin" <ldv@altlinux.org> writes:

> On Mon, Mar 09, 2020 at 02:02:37PM -0500, Eric W. Biederman wrote:
>> Bernd Edlinger <bernd.edlinger@hotmail.de> writes:
>> 
>> > On 3/9/20 7:36 PM, Eric W. Biederman wrote:
>> >> 
>> >> 
>> >> Does that sound better?
>> >> 
>> >
>> > almost done.
>> 
>> I think this text is finally clean.
>> 
>>     exec: Add exec_update_mutex to replace cred_guard_mutex
>>     
>>     The cred_guard_mutex is problematic as it is held over possibly
>>     indefinite waits for userspace.  The possilbe indefinite waits for
>
> -------------------------------------------^^^^^^^^ possible?


Yes.  Thank you.  Fixed.

Eric
