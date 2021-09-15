Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C41240C694
	for <lists+stable@lfdr.de>; Wed, 15 Sep 2021 15:45:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233698AbhIONrH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Sep 2021 09:47:07 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:59352 "EHLO
        out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233395AbhIONrG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Sep 2021 09:47:06 -0400
Received: from in01.mta.xmission.com ([166.70.13.51]:37058)
        by out01.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1mQVEQ-001Gjm-C7; Wed, 15 Sep 2021 07:45:46 -0600
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95]:48038 helo=email.xmission.com)
        by in01.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1mQVEO-00AL6P-AQ; Wed, 15 Sep 2021 07:45:45 -0600
From:   ebiederm@xmission.com (Eric W. Biederman)
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Ohhoon Kwon <ohoono.kwon@samsung.com>,
        Ingo Molnar <mingo@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org
References: <20210913223339.435347-1-sashal@kernel.org>
        <20210913223339.435347-19-sashal@kernel.org>
Date:   Wed, 15 Sep 2021 08:45:37 -0500
In-Reply-To: <20210913223339.435347-19-sashal@kernel.org> (Sasha Levin's
        message of "Mon, 13 Sep 2021 18:33:33 -0400")
Message-ID: <87v932ar5q.fsf@disp2133>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1mQVEO-00AL6P-AQ;;;mid=<87v932ar5q.fsf@disp2133>;;;hst=in01.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19qhAbvPIGFi9CV+a16T7+aUe76EzEZfR4=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on sa06.xmission.com
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=8.0 tests=ALL_TRUSTED,BAYES_50,
        DCC_CHECK_NEGATIVE,T_TM2_M_HEADER_IN_MSG,T_TooManySym_01,XMSubLong
        autolearn=disabled version=3.4.2
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        *  0.7 XMSubLong Long Subject
        *  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
        * -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
        *      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
        *  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Sasha Levin <sashal@kernel.org>
X-Spam-Relay-Country: 
X-Spam-Timing: total 508 ms - load_scoreonly_sql: 0.07 (0.0%),
        signal_user_changed: 10 (2.0%), b_tie_ro: 9 (1.7%), parse: 0.96 (0.2%),
         extract_message_metadata: 26 (5.2%), get_uri_detail_list: 2.4 (0.5%),
        tests_pri_-1000: 31 (6.1%), tests_pri_-950: 1.35 (0.3%),
        tests_pri_-900: 1.12 (0.2%), tests_pri_-90: 96 (19.0%), check_bayes:
        85 (16.7%), b_tokenize: 9 (1.7%), b_tok_get_all: 8 (1.6%),
        b_comp_prob: 2.4 (0.5%), b_tok_touch_all: 62 (12.3%), b_finish: 0.96
        (0.2%), tests_pri_0: 328 (64.7%), check_dkim_signature: 0.62 (0.1%),
        check_dkim_adsp: 13 (2.7%), poll_dns_idle: 0.54 (0.1%), tests_pri_10:
        2.1 (0.4%), tests_pri_500: 7 (1.3%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCH AUTOSEL 5.14 19/25] connector: send event on write to /proc/[pid]/comm
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Sasha Levin <sashal@kernel.org> writes:

> From: Ohhoon Kwon <ohoono.kwon@samsung.com>
>
> [ Upstream commit c2f273ebd89a79ed87ef1025753343e327b99ac9 ]
>
> While comm change event via prctl has been reported to proc connector by
> 'commit f786ecba4158 ("connector: add comm change event report to proc
> connector")', connector listeners were missing comm changes by explicit
> writes on /proc/[pid]/comm.
>
> Let explicit writes on /proc/[pid]/comm report to proc connector.

This is a potential userspace ABI breakage?  Why backport it?

Especially if there is no one asking for the behavior change in
userspace?

Eric


>
> Link: https://lkml.kernel.org/r/20210701133458epcms1p68e9eb9bd0eee8903ba26679a37d9d960@epcms1p6
> Signed-off-by: Ohhoon Kwon <ohoono.kwon@samsung.com>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: Christian Brauner <christian.brauner@ubuntu.com>
> Cc: Eric W. Biederman <ebiederm@xmission.com>
> Cc: Alexey Dobriyan <adobriyan@gmail.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  fs/proc/base.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/fs/proc/base.c b/fs/proc/base.c
> index e5b5f7709d48..533d5836eb9a 100644
> --- a/fs/proc/base.c
> +++ b/fs/proc/base.c
> @@ -95,6 +95,7 @@
>  #include <linux/posix-timers.h>
>  #include <linux/time_namespace.h>
>  #include <linux/resctrl.h>
> +#include <linux/cn_proc.h>
>  #include <trace/events/oom.h>
>  #include "internal.h"
>  #include "fd.h"
> @@ -1674,8 +1675,10 @@ static ssize_t comm_write(struct file *file, const char __user *buf,
>  	if (!p)
>  		return -ESRCH;
>  
> -	if (same_thread_group(current, p))
> +	if (same_thread_group(current, p)) {
>  		set_task_comm(p, buffer);
> +		proc_comm_connector(p);
> +	}
>  	else
>  		count = -EINVAL;
