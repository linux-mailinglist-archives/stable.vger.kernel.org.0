Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E33BDA70F8
	for <lists+stable@lfdr.de>; Tue,  3 Sep 2019 18:49:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728576AbfICQtd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Sep 2019 12:49:33 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:51492 "EHLO
        out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727624AbfICQtc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Sep 2019 12:49:32 -0400
Received: from in02.mta.xmission.com ([166.70.13.52])
        by out03.mta.xmission.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.87)
        (envelope-from <ebiederm@xmission.com>)
        id 1i5Bzn-0000Wr-Nx; Tue, 03 Sep 2019 10:49:31 -0600
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95] helo=x220.xmission.com)
        by in02.mta.xmission.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.87)
        (envelope-from <ebiederm@xmission.com>)
        id 1i5Bzm-0004Pi-UU; Tue, 03 Sep 2019 10:49:31 -0600
From:   ebiederm@xmission.com (Eric W. Biederman)
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Vineet Gupta <vgupta@synopsys.com>,
        linux-snps-arc@lists.infradead.org
References: <20190903162519.7136-1-sashal@kernel.org>
        <20190903162519.7136-111-sashal@kernel.org>
Date:   Tue, 03 Sep 2019 11:49:16 -0500
In-Reply-To: <20190903162519.7136-111-sashal@kernel.org> (Sasha Levin's
        message of "Tue, 3 Sep 2019 12:24:23 -0400")
Message-ID: <87ef0xqq9f.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1i5Bzm-0004Pi-UU;;;mid=<87ef0xqq9f.fsf@x220.int.ebiederm.org>;;;hst=in02.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/8C8aNV+b5wpsSiXnS9u4Q5EGxnuEWRB8=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on sa07.xmission.com
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=8.0 tests=ALL_TRUSTED,BAYES_50,
        DCC_CHECK_NEGATIVE,T_TM2_M_HEADER_IN_MSG,T_TooManySym_01,
        T_TooManySym_02,XMSubLong autolearn=disabled version=3.4.2
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        *  0.7 XMSubLong Long Subject
        *  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
        * -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
        *      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
        *  0.0 T_TooManySym_01 4+ unique symbols in subject
        *  0.0 T_TooManySym_02 5+ unique symbols in subject
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Sasha Levin <sashal@kernel.org>
X-Spam-Relay-Country: 
X-Spam-Timing: total 370 ms - load_scoreonly_sql: 0.04 (0.0%),
        signal_user_changed: 2.7 (0.7%), b_tie_ro: 1.94 (0.5%), parse: 0.82
        (0.2%), extract_message_metadata: 15 (3.9%), get_uri_detail_list: 2.0
        (0.5%), tests_pri_-1000: 13 (3.6%), tests_pri_-950: 1.31 (0.4%),
        tests_pri_-900: 1.05 (0.3%), tests_pri_-90: 25 (6.7%), check_bayes: 23
        (6.3%), b_tokenize: 8 (2.2%), b_tok_get_all: 7 (2.0%), b_comp_prob:
        2.3 (0.6%), b_tok_touch_all: 3.5 (0.9%), b_finish: 0.63 (0.2%),
        tests_pri_0: 300 (81.1%), check_dkim_signature: 0.53 (0.1%),
        check_dkim_adsp: 2.5 (0.7%), poll_dns_idle: 0.68 (0.2%), tests_pri_10:
        2.1 (0.6%), tests_pri_500: 6 (1.7%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCH AUTOSEL 4.19 111/167] signal/arc: Use force_sig_fault where appropriate
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Thu, 05 May 2016 13:38:54 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Sasha Levin <sashal@kernel.org> writes:

> From: "Eric W. Biederman" <ebiederm@xmission.com>
>
> [ Upstream commit 15773ae938d8d93d982461990bebad6e1d7a1830 ]

To the best of my knowledge this is just a clean up, no changes in
behavior are present.

The only reason I can see to backport this is so that later fixes could
be applied cleanly.

So while I have no objections to this patch being backported I don't see
why you would want to either.

> Acked-by: Vineet Gupta <vgupta@synopsys.com>
> Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  arch/arc/mm/fault.c | 20 +++++---------------
>  1 file changed, 5 insertions(+), 15 deletions(-)
>
> diff --git a/arch/arc/mm/fault.c b/arch/arc/mm/fault.c
> index f28db0b112a30..a0366f9dca051 100644
> --- a/arch/arc/mm/fault.c
> +++ b/arch/arc/mm/fault.c
> @@ -66,14 +66,12 @@ void do_page_fault(unsigned long address, struct pt_regs *regs)
>  	struct vm_area_struct *vma = NULL;
>  	struct task_struct *tsk = current;
>  	struct mm_struct *mm = tsk->mm;
> -	siginfo_t info;
> +	int si_code;
>  	int ret;
>  	vm_fault_t fault;
>  	int write = regs->ecr_cause & ECR_C_PROTV_STORE;  /* ST/EX */
>  	unsigned int flags = FAULT_FLAG_ALLOW_RETRY | FAULT_FLAG_KILLABLE;
>  
> -	clear_siginfo(&info);
> -
>  	/*
>  	 * We fault-in kernel-space virtual memory on-demand. The
>  	 * 'reference' page table is init_mm.pgd.
> @@ -91,7 +89,7 @@ void do_page_fault(unsigned long address, struct pt_regs *regs)
>  			return;
>  	}
>  
> -	info.si_code = SEGV_MAPERR;
> +	si_code = SEGV_MAPERR;
>  
>  	/*
>  	 * If we're in an interrupt or have no user
> @@ -119,7 +117,7 @@ void do_page_fault(unsigned long address, struct pt_regs *regs)
>  	 * we can handle it..
>  	 */
>  good_area:
> -	info.si_code = SEGV_ACCERR;
> +	si_code = SEGV_ACCERR;
>  
>  	/* Handle protection violation, execute on heap or stack */
>  
> @@ -204,11 +202,7 @@ void do_page_fault(unsigned long address, struct pt_regs *regs)
>  	/* User mode accesses just cause a SIGSEGV */
>  	if (user_mode(regs)) {
>  		tsk->thread.fault_address = address;
> -		info.si_signo = SIGSEGV;
> -		info.si_errno = 0;
> -		/* info.si_code has been set above */
> -		info.si_addr = (void __user *)address;
> -		force_sig_info(SIGSEGV, &info, tsk);
> +		force_sig_fault(SIGSEGV, si_code, (void __user *)address, tsk);
>  		return;
>  	}
>  
> @@ -243,9 +237,5 @@ void do_page_fault(unsigned long address, struct pt_regs *regs)
>  		goto no_context;
>  
>  	tsk->thread.fault_address = address;
> -	info.si_signo = SIGBUS;
> -	info.si_errno = 0;
> -	info.si_code = BUS_ADRERR;
> -	info.si_addr = (void __user *)address;
> -	force_sig_info(SIGBUS, &info, tsk);
> +	force_sig_fault(SIGBUS, BUS_ADRERR, (void __user *)address, tsk);
>  }
