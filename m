Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 579DA7D55C
	for <lists+stable@lfdr.de>; Thu,  1 Aug 2019 08:17:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728372AbfHAGRG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Aug 2019 02:17:06 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:45411 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729345AbfHAGRF (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Aug 2019 02:17:05 -0400
Received: by mail-pg1-f196.google.com with SMTP id o13so33489412pgp.12
        for <stable@vger.kernel.org>; Wed, 31 Jul 2019 23:17:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=zJU4/vqQd2lede9CTG0BdiKFL0gqtq+BwHXXmJrB8fQ=;
        b=fFvaKlbb5E4jj3yRMeAa/ZW2S/ppRG+OpK/AhwwWbKQcC/4YfViMmxDe/oGKJ66NRF
         K8thAb112yJhn+r+ZQtUURJp9BcOe402p/EwC6mCYdgu4rvs2WoYBTdA8C5y16FywXAH
         bhuH6FxKpsZMXibxq9/PjGG21VlC/cdnL5nVItDVgyWk+bGnYW4x5H0ZiaPUrotg2ilQ
         H/SarItReeLth6sEtc1grq6xLZVkcK+y8O38Pu2XR0ZYffXCvu29lxs2wh/Ro+HSVHMA
         AvVqKOCYi3AzLDu2GyTxx5OyYqTInBA23MyIiAOrZ0TkEASBSV7+kthSaqWk7Woo+HYa
         7dAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=zJU4/vqQd2lede9CTG0BdiKFL0gqtq+BwHXXmJrB8fQ=;
        b=GL28M1Tc1u5ZEmAEBDkI3pNmrM2CyfvTNgzVmTjfxQXjj6dVHFrILaMLpqlBthLaJn
         +3A4wjoZPXdkpg8az7qpczNLv6GoEK2ljZYY0eygpOVL4q3J3W6yJ63r8kmtT4/EY21O
         E4aHGmLJ1kd0na+ppIgNt0/1qnNzKN6G3U/JFVqdVSphcokaedQvgZ0TZleyGh4S0YzX
         xlbvQmyKHYNQ97IZ9n0pvaGWk2y8KD4XelLbEXPNvjLYeK4Kd+k4l8GCOI5HizEA2HSi
         8etwz5H1KsFImCowa6CV1j8oBNdEyU6Gpm6qSG1b98USSL84F2uQfN/ZN+/bv660sA1A
         c6HA==
X-Gm-Message-State: APjAAAV39TW0fxuafVR9beGM0EyujfyQ6pZCRSkkL7EtX/b8hevsaFfE
        +L+xxMHFps+BB79URmYdKjKQ5g==
X-Google-Smtp-Source: APXvYqwvXsV+CZfOZxkl9ZRmoZj1nVH1f4aWphFWwvwgP5gQl8Oe8LfcDsG+LKw/lWVEjOXZvljO8g==
X-Received: by 2002:a17:90a:a008:: with SMTP id q8mr6784770pjp.114.1564640224089;
        Wed, 31 Jul 2019 23:17:04 -0700 (PDT)
Received: from localhost ([122.172.28.117])
        by smtp.gmail.com with ESMTPSA id 81sm112707819pfx.111.2019.07.31.23.17.02
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 31 Jul 2019 23:17:02 -0700 (PDT)
Date:   Thu, 1 Aug 2019 11:47:00 +0530
From:   Viresh Kumar <viresh.kumar@linaro.org>
To:     Doug Smythies <dsmythies@telus.net>
Cc:     "'Rafael J. Wysocki'" <rafael@kernel.org>,
        'Rafael Wysocki' <rjw@rjwysocki.net>,
        'Ingo Molnar' <mingo@redhat.com>,
        'Peter Zijlstra' <peterz@infradead.org>,
        'Linux PM' <linux-pm@vger.kernel.org>,
        'Vincent Guittot' <vincent.guittot@linaro.org>,
        'Joel Fernandes' <joel@joelfernandes.org>,
        "'v4 . 18+'" <stable@vger.kernel.org>,
        'Linux Kernel Mailing List' <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cpufreq: schedutil: Don't skip freq update when limits
 change
Message-ID: <20190801061700.dl33rtilvg44obzu@vireshk-i7>
References: <001201d54125$a6a82350$f3f869f0$@net>
 <20190723091551.nchopfpqlmdmzvge@vireshk-i7>
 <CAJZ5v0ji+ksapJ4kc2m5UM_O+AShAvJWmYhTQHiXiHnpTq+xRg@mail.gmail.com>
 <20190724114327.apmx35c7a4tv3qt5@vireshk-i7>
 <000c01d542fc$703ff850$50bfe8f0$@net>
 <20190726065739.xjvyvqpkb3o6m4ty@vireshk-i7>
 <000001d545e3$047d9750$0d78c5f0$@net>
 <20190729083219.fe4xxq4ugmetzntm@vireshk-i7>
 <CAJZ5v0gaW=ujtsDmewrVXL7V8K0YZysNqwu=qKLw+kPC86ydqA@mail.gmail.com>
 <000b01d547fe$e7b51fd0$b71f5f70$@net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000b01d547fe$e7b51fd0$b71f5f70$@net>
User-Agent: NeoMutt/20180716-391-311a52
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 31-07-19, 17:20, Doug Smythies wrote:
> Hi Viresh,
> 
> Summary:
> 
> The old way, using UINT_MAX had two purposes: first,
> as a "need to do a frequency update" flag; but also second, to
> force any subsequent old/new frequency comparison to NOT be "the same,
> so why bother actually updating" (see: sugov_update_next_freq). All
> patches so far have been dealing with the flag, but only partially
> the comparisons. In a busy system, and when schedutil.c doesn't actually
> know the currently set system limits, the new frequency is dominated by
> values the same as the old frequency. So, when sugov_fast_switch calls 
> sugov_update_next_freq, false is usually returned.

And finally we know "Why" :)

Good work Doug. Thanks for taking it to the end.

> However, if we move the resetting of the flag and add another condition
> to the "no need to actually update" decision, then perhaps this patch
> version 1 will be O.K. It seems to be. (see way later in this e-mail).

> With all this new knowledge, how about going back to
> version 1 of this patch, and then adding this:
> 
> diff --git a/kernel/sched/cpufreq_schedutil.c b/kernel/sched/cpufreq_schedutil.c
> index 808d32b..f9156db 100644
> --- a/kernel/sched/cpufreq_schedutil.c
> +++ b/kernel/sched/cpufreq_schedutil.c
> @@ -100,7 +100,12 @@ static bool sugov_should_update_freq(struct sugov_policy *sg_policy, u64 time)
>  static bool sugov_update_next_freq(struct sugov_policy *sg_policy, u64 time,
>                                    unsigned int next_freq)
>  {
> -       if (sg_policy->next_freq == next_freq)
> +       /*
> +        * Always force an update if the flag is set, regardless.
> +        * In some implementations (intel_cpufreq) the frequency is clamped
> +        * further downstream, and might not actually be different here.
> +        */
> +       if (sg_policy->next_freq == next_freq && !sg_policy->need_freq_update)
>                 return false;

This is not correct because this is an optimization we have in place
to make things more efficient. And it was working by luck earlier and
my patch broke it for good :)

Things need to get a bit more synchronized and something like this may
help (completely untested):

diff --git a/drivers/cpufreq/intel_pstate.c b/drivers/cpufreq/intel_pstate.c
index cc27d4c59dca..2d84361fbebc 100644
--- a/drivers/cpufreq/intel_pstate.c
+++ b/drivers/cpufreq/intel_pstate.c
@@ -2314,6 +2314,18 @@ static int intel_cpufreq_target(struct cpufreq_policy *policy,
        return 0;
 }
 
+static unsigned int intel_cpufreq_resolve_freq(struct cpufreq_policy *policy,
+                                              unsigned int target_freq)
+{
+       struct cpudata *cpu = all_cpu_data[policy->cpu];
+       int target_pstate;
+
+       target_pstate = DIV_ROUND_UP(target_freq, cpu->pstate.scaling);
+       target_pstate = intel_pstate_prepare_request(cpu, target_pstate);
+
+       return target_pstate * cpu->pstate.scaling;
+}
+
 static unsigned int intel_cpufreq_fast_switch(struct cpufreq_policy *policy,
                                              unsigned int target_freq)
 {
@@ -2350,6 +2362,7 @@ static struct cpufreq_driver intel_cpufreq = {
        .verify         = intel_cpufreq_verify_policy,
        .target         = intel_cpufreq_target,
        .fast_switch    = intel_cpufreq_fast_switch,
+       .resolve_freq   = intel_cpufreq_resolve_freq,
        .init           = intel_cpufreq_cpu_init,
        .exit           = intel_pstate_cpu_exit,
        .stop_cpu       = intel_cpufreq_stop_cpu,

-------------------------8<-------------------------

Please try this with my patch 2. We need patch 2 instead of 1 because
of another race condition Rafael noticed.

cpufreq_schedutil calls driver specific resolve_freq() to find the new
target frequency and this is where the limits should get applied IMO.

Rafael can help with reviewing this diff but it would be great if you
can give this a try Doug.

Thanks.

-- 
viresh
