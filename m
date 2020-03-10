Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC80218079A
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 20:03:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727112AbgCJTDo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 15:03:44 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:60596 "EHLO
        out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726464AbgCJTDo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Mar 2020 15:03:44 -0400
Received: from in01.mta.xmission.com ([166.70.13.51])
        by out03.mta.xmission.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.90_1)
        (envelope-from <ebiederm@xmission.com>)
        id 1jBkAI-0002Hx-MC; Tue, 10 Mar 2020 13:03:42 -0600
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95] helo=x220.xmission.com)
        by in01.mta.xmission.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.87)
        (envelope-from <ebiederm@xmission.com>)
        id 1jBkA9-0004jE-TO; Tue, 10 Mar 2020 13:03:42 -0600
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
        <875zfcxlwy.fsf@x220.int.ebiederm.org>
        <AM6PR03MB517057A2269C3A4FB287B76EE4FF0@AM6PR03MB5170.eurprd03.prod.outlook.com>
Date:   Tue, 10 Mar 2020 14:01:15 -0500
In-Reply-To: <AM6PR03MB517057A2269C3A4FB287B76EE4FF0@AM6PR03MB5170.eurprd03.prod.outlook.com>
        (Bernd Edlinger's message of "Tue, 10 Mar 2020 18:45:11 +0100")
Message-ID: <87k13svxtw.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1jBkA9-0004jE-TO;;;mid=<87k13svxtw.fsf@x220.int.ebiederm.org>;;;hst=in01.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX184oAtGUl9ErG2CEbQO/LXGywzplo5o8Mo=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on sa01.xmission.com
X-Spam-Level: **
X-Spam-Status: No, score=2.0 required=8.0 tests=ALL_TRUSTED,BAYES_50,
        DCC_CHECK_NEGATIVE,NO_DNS_FOR_FROM,T_TM2_M_HEADER_IN_MSG,
        T_TooManySym_01,XMNoVowels,XMSubLong autolearn=disabled version=3.4.2
X-Spam-Virus: No
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.4990]
        *  1.5 XMNoVowels Alpha-numberic number with no vowels
        *  0.7 XMSubLong Long Subject
        *  0.0 NO_DNS_FOR_FROM DNS: Envelope sender has no MX or A DNS records
        *  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
        * -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
        *      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
        *  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: **;Bernd Edlinger <bernd.edlinger@hotmail.de>
X-Spam-Relay-Country: 
X-Spam-Timing: total 3721 ms - load_scoreonly_sql: 0.11 (0.0%),
        signal_user_changed: 22 (0.6%), b_tie_ro: 16 (0.4%), parse: 1.39
        (0.0%), extract_message_metadata: 17 (0.5%), get_uri_detail_list: 1.15
        (0.0%), tests_pri_-1000: 8 (0.2%), compile_eval: 32 (0.9%),
        tests_pri_-950: 2.2 (0.1%), tests_pri_-900: 1.56 (0.0%),
        tests_pri_-90: 29 (0.8%), check_bayes: 26 (0.7%), b_tokenize: 10
        (0.3%), b_tok_get_all: 7 (0.2%), b_comp_prob: 1.80 (0.0%),
        b_tok_touch_all: 3.8 (0.1%), b_finish: 0.91 (0.0%), tests_pri_0: 3623
        (97.4%), check_dkim_signature: 1.01 (0.0%), check_dkim_adsp: 3336
        (89.7%), poll_dns_idle: 3331 (89.5%), tests_pri_10: 2.5 (0.1%),
        tests_pri_500: 9 (0.2%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCH 1/4] kernel/kcmp.c: Use new infrastructure to fix deadlocks in execve
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Thu, 05 May 2016 13:38:54 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Bernd Edlinger <bernd.edlinger@hotmail.de> writes:

> This changes kcmp_epoll_target to use the new exec_update_mutex
> instead of cred_guard_mutex.
>
> This should be safe, as the credentials are only used for reading,
> and furthermore ->mm and ->sighand are updated on execve,
> but only under the new exec_update_mutex.
>

Can you add a comment that the exec_update_mutex is not needed for
KCMP_FILE?  As both sets of credentials during exec are valid
for accessing the files so exec_update_mutex does not matter.

I don't think exec_update_mutex is needed for KCMP_SYSVSEM
or KCMP_EPOLL_TFD either.  As I don't think exec changes either
one of those.

Eric


> Signed-off-by: Bernd Edlinger <bernd.edlinger@hotmail.de>
> ---
>  kernel/kcmp.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/kernel/kcmp.c b/kernel/kcmp.c
> index a0e3d7a..b3ff928 100644
> --- a/kernel/kcmp.c
> +++ b/kernel/kcmp.c
> @@ -173,8 +173,8 @@ static int kcmp_epoll_target(struct task_struct *task1,
>  	/*
>  	 * One should have enough rights to inspect task details.
>  	 */
> -	ret = kcmp_lock(&task1->signal->cred_guard_mutex,
> -			&task2->signal->cred_guard_mutex);
> +	ret = kcmp_lock(&task1->signal->exec_update_mutex,
> +			&task2->signal->exec_update_mutex);
>  	if (ret)
>  		goto err;
>  	if (!ptrace_may_access(task1, PTRACE_MODE_READ_REALCREDS) ||
> @@ -229,8 +229,8 @@ static int kcmp_epoll_target(struct task_struct *task1,
>  	}
>  
>  err_unlock:
> -	kcmp_unlock(&task1->signal->cred_guard_mutex,
> -		    &task2->signal->cred_guard_mutex);
> +	kcmp_unlock(&task1->signal->exec_update_mutex,
> +		    &task2->signal->exec_update_mutex);
>  err:
>  	put_task_struct(task1);
>  	put_task_struct(task2);
