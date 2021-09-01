Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5FE63FDDC9
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 16:25:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244902AbhIAO0z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 10:26:55 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:41750 "EHLO
        out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236539AbhIAO0y (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Sep 2021 10:26:54 -0400
Received: from in01.mta.xmission.com ([166.70.13.51]:59342)
        by out03.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1mLRBd-0005s9-1h; Wed, 01 Sep 2021 08:25:57 -0600
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95]:44984 helo=email.xmission.com)
        by in01.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1mLRBa-00D7Uh-Kn; Wed, 01 Sep 2021 08:25:56 -0600
From:   ebiederm@xmission.com (Eric W. Biederman)
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        syzbot+01985d7909f9468f013c@syzkaller.appspotmail.com,
        Alexey Gladkov <legion@kernel.org>,
        Sasha Levin <sashal@kernel.org>
References: <20210901122300.503008474@linuxfoundation.org>
        <20210901122301.773759848@linuxfoundation.org>
Date:   Wed, 01 Sep 2021 09:25:25 -0500
In-Reply-To: <20210901122301.773759848@linuxfoundation.org> (Greg
        Kroah-Hartman's message of "Wed, 1 Sep 2021 14:27:46 +0200")
Message-ID: <87v93k4bl6.fsf@disp2133>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1mLRBa-00D7Uh-Kn;;;mid=<87v93k4bl6.fsf@disp2133>;;;hst=in01.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19QIAuZJddGFdPEK0hgriK6CNXn2W6bA5A=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on sa06.xmission.com
X-Spam-Level: ****
X-Spam-Status: No, score=4.6 required=8.0 tests=ALL_TRUSTED,BAYES_50,
        DCC_CHECK_NEGATIVE,FVGT_m_MULTI_ODD,LotsOfNums_01,
        T_TM2_M_HEADER_IN_MSG,T_TooManySym_01,XMNoVowels,XMSubLong,
        XM_Sft_Co_L33T autolearn=disabled version=3.4.2
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        *  1.5 XMNoVowels Alpha-numberic number with no vowels
        *  0.7 XMSubLong Long Subject
        *  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
        *  1.2 LotsOfNums_01 BODY: Lots of long strings of numbers
        * -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
        *      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
        *  1.0 XM_Sft_Co_L33T No description available.
        *  0.0 T_TooManySym_01 4+ unique symbols in subject
        *  0.4 FVGT_m_MULTI_ODD Contains multiple odd letter combinations
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ****;Greg Kroah-Hartman <gregkh@linuxfoundation.org>
X-Spam-Relay-Country: 
X-Spam-Timing: total 1573 ms - load_scoreonly_sql: 0.07 (0.0%),
        signal_user_changed: 10 (0.6%), b_tie_ro: 9 (0.6%), parse: 0.96 (0.1%),
         extract_message_metadata: 19 (1.2%), get_uri_detail_list: 3.3 (0.2%),
        tests_pri_-1000: 33 (2.1%), tests_pri_-950: 1.21 (0.1%),
        tests_pri_-900: 1.01 (0.1%), tests_pri_-90: 135 (8.6%), check_bayes:
        132 (8.4%), b_tokenize: 12 (0.7%), b_tok_get_all: 12 (0.8%),
        b_comp_prob: 2.9 (0.2%), b_tok_touch_all: 101 (6.4%), b_finish: 0.93
        (0.1%), tests_pri_0: 443 (28.1%), check_dkim_signature: 0.81 (0.1%),
        check_dkim_adsp: 3.2 (0.2%), poll_dns_idle: 910 (57.9%), tests_pri_10:
        3.7 (0.2%), tests_pri_500: 923 (58.7%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCH 5.10 036/103] ucounts: Increase ucounts reference counter before the security hook
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Greg Kroah-Hartman <gregkh@linuxfoundation.org> writes:

> From: Alexey Gladkov <legion@kernel.org>
>
> [ Upstream commit bbb6d0f3e1feb43d663af089c7dedb23be6a04fb ]
>
> We need to increment the ucounts reference counter befor security_prepare_creds()
> because this function may fail and abort_creds() will try to decrement
> this reference.

Has the conversion of the rlimits to ucounts been backported?

Semantically the code is an improvement but I don't know of any cases
where it makes enough of a real-world difference to make it worth
backporting the code.

Certainly the ucount/rlimit conversions do not meet the historical
criteria for backports.  AKA simple obviously correct patches.

The fact we have been applying fixes for the entire v5.14 stabilization
period is a testament to the code not quite being obviously correct.

Without backports the code only affects v5.14 so I have not been
including a Cc stable on any of the commits.

So color me very puzzled about what is going on here.

Eric


> [   96.465056][ T8641] FAULT_INJECTION: forcing a failure.
> [   96.465056][ T8641] name fail_page_alloc, interval 1, probability 0, space 0, times 0
> [   96.478453][ T8641] CPU: 1 PID: 8641 Comm: syz-executor668 Not tainted 5.14.0-rc6-syzkaller #0
> [   96.487215][ T8641] Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> [   96.497254][ T8641] Call Trace:
> [   96.500517][ T8641]  dump_stack_lvl+0x1d3/0x29f
> [   96.505758][ T8641]  ? show_regs_print_info+0x12/0x12
> [   96.510944][ T8641]  ? log_buf_vmcoreinfo_setup+0x498/0x498
> [   96.516652][ T8641]  should_fail+0x384/0x4b0
> [   96.521141][ T8641]  prepare_alloc_pages+0x1d1/0x5a0
> [   96.526236][ T8641]  __alloc_pages+0x14d/0x5f0
> [   96.530808][ T8641]  ? __rmqueue_pcplist+0x2030/0x2030
> [   96.536073][ T8641]  ? lockdep_hardirqs_on_prepare+0x3e2/0x750
> [   96.542056][ T8641]  ? alloc_pages+0x3f3/0x500
> [   96.546635][ T8641]  allocate_slab+0xf1/0x540
> [   96.551120][ T8641]  ___slab_alloc+0x1cf/0x350
> [   96.555689][ T8641]  ? kzalloc+0x1d/0x30
> [   96.559740][ T8641]  __kmalloc+0x2e7/0x390
> [   96.563980][ T8641]  ? kzalloc+0x1d/0x30
> [   96.568029][ T8641]  kzalloc+0x1d/0x30
> [   96.571903][ T8641]  security_prepare_creds+0x46/0x220
> [   96.577174][ T8641]  prepare_creds+0x411/0x640
> [   96.581747][ T8641]  __sys_setfsuid+0xe2/0x3a0
> [   96.586333][ T8641]  do_syscall_64+0x3d/0xb0
> [   96.590739][ T8641]  entry_SYSCALL_64_after_hwframe+0x44/0xae
> [   96.596611][ T8641] RIP: 0033:0x445a69
> [   96.600483][ T8641] Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 11 15 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
> [   96.620152][ T8641] RSP: 002b:00007f1054173318 EFLAGS: 00000246 ORIG_RAX: 000000000000007a
> [   96.628543][ T8641] RAX: ffffffffffffffda RBX: 00000000004ca4c8 RCX: 0000000000445a69
> [   96.636600][ T8641] RDX: 0000000000000010 RSI: 00007f10541732f0 RDI: 0000000000000000
> [   96.644550][ T8641] RBP: 00000000004ca4c0 R08: 0000000000000001 R09: 0000000000000000
> [   96.652500][ T8641] R10: 0000000000000000 R11: 0000000000000246 R12: 00000000004ca4cc
> [   96.660631][ T8641] R13: 00007fffffe0b62f R14: 00007f1054173400 R15: 0000000000022000
>
> Fixes: 905ae01c4ae2 ("Add a reference to ucounts for each cred")
> Reported-by: syzbot+01985d7909f9468f013c@syzkaller.appspotmail.com
> Signed-off-by: Alexey Gladkov <legion@kernel.org>
> Link: https://lkml.kernel.org/r/97433b1742c3331f02ad92de5a4f07d673c90613.1629735352.git.legion@kernel.org
> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  kernel/cred.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
>
> diff --git a/kernel/cred.c b/kernel/cred.c
> index 098213d4a39c..8c0983fa794a 100644
> --- a/kernel/cred.c
> +++ b/kernel/cred.c
> @@ -286,13 +286,13 @@ struct cred *prepare_creds(void)
>  	new->security = NULL;
>  #endif
>  
> -	if (security_prepare_creds(new, old, GFP_KERNEL_ACCOUNT) < 0)
> -		goto error;
> -
>  	new->ucounts = get_ucounts(new->ucounts);
>  	if (!new->ucounts)
>  		goto error;
>  
> +	if (security_prepare_creds(new, old, GFP_KERNEL_ACCOUNT) < 0)
> +		goto error;
> +
>  	validate_creds(new);
>  	return new;
>  
> @@ -753,13 +753,13 @@ struct cred *prepare_kernel_cred(struct task_struct *daemon)
>  #ifdef CONFIG_SECURITY
>  	new->security = NULL;
>  #endif
> -	if (security_prepare_creds(new, old, GFP_KERNEL_ACCOUNT) < 0)
> -		goto error;
> -
>  	new->ucounts = get_ucounts(new->ucounts);
>  	if (!new->ucounts)
>  		goto error;
>  
> +	if (security_prepare_creds(new, old, GFP_KERNEL_ACCOUNT) < 0)
> +		goto error;
> +
>  	put_cred(old);
>  	validate_creds(new);
>  	return new;
