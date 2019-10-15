Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD0BBD7370
	for <lists+stable@lfdr.de>; Tue, 15 Oct 2019 12:40:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730864AbfJOKkR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Oct 2019 06:40:17 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:50545 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730847AbfJOKkR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Oct 2019 06:40:17 -0400
Received: by mail-wm1-f66.google.com with SMTP id 5so20314208wmg.0
        for <stable@vger.kernel.org>; Tue, 15 Oct 2019 03:40:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=HrnoeVNslwR6lG8sahw49jWvv99yrTs7Gkvp5r1I1Ig=;
        b=nwHTtgBgxD5BbNMb2oS/YdUtYvrpLGmimm+pnZqERwzKtX1ysuTm9XF4x+Gs9SGIFq
         puREMS6c3JJCE73NCWJ+kiTAaBHv45bHiVPg5rag31heSvIUsQLetQ7fMW04/ADfDxL5
         7JtPtkN4umPOMRlCiPWjAO+gQAeFAKwBe6CQJephFv1k3MMmcU9QJOJpHGoNcBoIdxp9
         F3TrewDbQOY2LWHxKtZtrqoggvr6CcdajD9M6PfyXeKwCjZO2jKu4Hxowu1jEUhJ3lzY
         adpj6wbdMThEp0GzipjkNaFbJrnd3PE1lfXZx/y4CBugKL2JL7HKNW7laCrRWagQlabz
         37WA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=HrnoeVNslwR6lG8sahw49jWvv99yrTs7Gkvp5r1I1Ig=;
        b=uHP4eWv4Gu0pdm0OKDKFnOmo9/ulUFko7/JGipn3Ky4EHcdejPL/hnMyRzwH7Qs62C
         kIcX8EvP8MYdrCIHwFX0LjNTAcOZF72ItzEGBa6RS6Oftsp7hseoSe0qsOh/Rop8Hqf5
         jZOtI7TsiUof9twoJbU6of8ZhO+7eXuAm/NUKkugILUjK38RZp0qKO8/TJWlxJkyPsGY
         /Oa73VIaTwGcCKrhTdoWomtrRdFtDk+3qlSChdhd3SkFfMeVxNm0zLqTvHqrWunZMeMf
         mq/Q+K1tkzi5Aj5eXHCMgr/lC/AAQ9lufg+ke9m9OTSwRbSDIfdu5S6B4rPLtt+zZ4XL
         M1Sg==
X-Gm-Message-State: APjAAAV5iIfQs2dSmzWb4c7+eSrxkgGYdXLUDrZtDlHmX1MziOsKub7L
        08Gb50/Olcvf3+945Gw9M3RBSA==
X-Google-Smtp-Source: APXvYqxEVOWSN5i939RuKdXOBKtldyqEU+iIrvEiCoAgfnmfyGg4RVxDbSyxU5reH2bBjACogG2WBQ==
X-Received: by 2002:a7b:cc01:: with SMTP id f1mr19930049wmh.113.1571136014621;
        Tue, 15 Oct 2019 03:40:14 -0700 (PDT)
Received: from google.com ([2a00:79e0:d:210:7687:11a4:4657:121d])
        by smtp.gmail.com with ESMTPSA id p12sm10465077wrm.62.2019.10.15.03.40.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Oct 2019 03:40:13 -0700 (PDT)
Date:   Tue, 15 Oct 2019 11:40:10 +0100
From:   Quentin Perret <qperret@google.com>
To:     Valentin Schneider <valentin.schneider@arm.com>
Cc:     linux-kernel@vger.kernel.org, mingo@kernel.org,
        peterz@infradead.org, vincent.guittot@linaro.org,
        Dietmar.Eggemann@arm.com, morten.rasmussen@arm.com,
        stable@vger.kernel.org
Subject: Re: [PATCH v2] sched/topology: Allow sched_asym_cpucapacity to be
 disabled
Message-ID: <20191015104010.GA242992@google.com>
References: <20191015102956.20133-1-valentin.schneider@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191015102956.20133-1-valentin.schneider@arm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tuesday 15 Oct 2019 at 11:29:56 (+0100), Valentin Schneider wrote:
> While the static key is correctly initialized as being disabled, it will
> remain forever enabled once turned on. This means that if we start with an
> asymmetric system and hotplug out enough CPUs to end up with an SMP system,
> the static key will remain set - which is obviously wrong. We should detect
> this and turn off things like misfit migration and capacity aware wakeups.
> 
> As Quentin pointed out, having separate root domains makes this slightly
> trickier. We could have exclusive cpusets that create an SMP island - IOW,
> the domains within this root domain will not see any asymmetry. This means
> we need to count how many asymmetric root domains we have.
> 
> Change the simple key enablement to an increment, and decrement the key
> counter when destroying domains that cover asymmetric CPUs.
> 
> Cc: <stable@vger.kernel.org>
> Fixes: df054e8445a4 ("sched/topology: Add static_key for asymmetric CPU capacity optimizations")
> Signed-off-by: Valentin Schneider <valentin.schneider@arm.com>
> ---
> Changes since v1:
> 
> Use static_branch_{inc,dec} rather than enable/disable
> ---
>  kernel/sched/topology.c | 11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/sched/topology.c b/kernel/sched/topology.c
> index b5667a273bf6..79944e969bcf 100644
> --- a/kernel/sched/topology.c
> +++ b/kernel/sched/topology.c
> @@ -2026,7 +2026,7 @@ build_sched_domains(const struct cpumask *cpu_map, struct sched_domain_attr *att
>  	rcu_read_unlock();
>  
>  	if (has_asym)
> -		static_branch_enable_cpuslocked(&sched_asym_cpucapacity);
> +		static_branch_inc_cpuslocked(&sched_asym_cpucapacity);
>  
>  	if (rq && sched_debug_enabled) {
>  		pr_info("root domain span: %*pbl (max cpu_capacity = %lu)\n",
> @@ -2124,8 +2124,17 @@ static void detach_destroy_domains(const struct cpumask *cpu_map)
>  	int i;
>  
>  	rcu_read_lock();
> +
> +	if (static_key_enabled(&sched_asym_cpucapacity)) {
> +		unsigned int cpu = cpumask_any(cpu_map);
> +
> +		if (rcu_dereference(per_cpu(sd_asym_cpucapacity, cpu)))
> +			static_branch_dec_cpuslocked(&sched_asym_cpucapacity);

Lockdep should scream for this :)
> +	}
> +
>  	for_each_cpu(i, cpu_map)
>  		cpu_attach_domain(NULL, &def_root_domain, i);
> +
>  	rcu_read_unlock();
>  }
>  
> -- 
> 2.22.0
> 
