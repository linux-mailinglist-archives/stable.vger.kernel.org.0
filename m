Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7DAB0786C5
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 09:55:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727163AbfG2Hzq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 03:55:46 -0400
Received: from cmta16.telus.net ([209.171.16.89]:54876 "EHLO cmta16.telus.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726717AbfG2Hzp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 03:55:45 -0400
Received: from dougxps ([173.180.45.4])
        by cmsmtp with SMTP
        id s0VQht9oNJEJss0VRh6Lj3; Mon, 29 Jul 2019 01:55:43 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=telus.net; s=neo;
        t=1564386943; bh=GYX2p8Fr0OGn/XyiBM/DJqUex7myFNsaTyuHy1EFU8E=;
        h=From:To:Cc:References:In-Reply-To:Subject:Date;
        b=tfxv4tuf9N6DreMSwZ6cpLR3Hf+32nLtS9UZwndEKZQax0JnWvzMm/Q/SE3AeJ15a
         /1eQq9NaVnNRJGXUGyR2vMTglH4R+BJXe+O7w8jZWxPSPQbJmR0HUBlgbJzHkXCUs7
         9N3D70autuKqdPZQhCniptdIFTF53WhXE0kQASGnqaXsx6/2UE91GDLsPcfu+nGfDB
         we7dt2lTfAmm3Jl3MpfN11Ldxv2Qg2DPKRqGw/yx9aBg0Wkm8UBIPTs9Nq+tLygIB9
         ONjKDNDEaMDOagHXl1KjYiA1MIpaM7N+wrCVi1RITLsPekK5l6Zc5HHPefxtRA1aKJ
         lscbMyD9SeB9Q==
X-Telus-Authed: none
X-Authority-Analysis: v=2.3 cv=S/CnP7kP c=1 sm=1 tr=0
 a=zJWegnE7BH9C0Gl4FFgQyA==:117 a=zJWegnE7BH9C0Gl4FFgQyA==:17
 a=Pyq9K9CWowscuQLKlpiwfMBGOR0=:19 a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19
 a=kj9zAlcOel0A:10 a=cRXgKqRiuchQe480gGkA:9 a=CjuIK1q_8ugA:10
From:   "Doug Smythies" <dsmythies@telus.net>
To:     "'Viresh Kumar'" <viresh.kumar@linaro.org>
Cc:     "'Rafael J. Wysocki'" <rafael@kernel.org>,
        "'Rafael Wysocki'" <rjw@rjwysocki.net>,
        "'Ingo Molnar'" <mingo@redhat.com>,
        "'Peter Zijlstra'" <peterz@infradead.org>,
        "'Linux PM'" <linux-pm@vger.kernel.org>,
        "'Vincent Guittot'" <vincent.guittot@linaro.org>,
        "'Joel Fernandes'" <joel@joelfernandes.org>,
        "'v4 . 18+'" <stable@vger.kernel.org>,
        "'Linux Kernel Mailing List'" <linux-kernel@vger.kernel.org>
References: <1563431200-3042-1-git-send-email-dsmythies@telus.net> <8091ef83f264feb2feaa827fbeefe08348bcd05d.1563778071.git.viresh.kumar@linaro.org> <001201d54125$a6a82350$f3f869f0$@net> <20190723091551.nchopfpqlmdmzvge@vireshk-i7> <CAJZ5v0ji+ksapJ4kc2m5UM_O+AShAvJWmYhTQHiXiHnpTq+xRg@mail.gmail.com> <20190724114327.apmx35c7a4tv3qt5@vireshk-i7> <000c01d542fc$703ff850$50bfe8f0$@net> <20190726065739.xjvyvqpkb3o6m4ty@vireshk-i7>
In-Reply-To: <20190726065739.xjvyvqpkb3o6m4ty@vireshk-i7>
Subject: RE: [PATCH] cpufreq: schedutil: Don't skip freq update when limits change
Date:   Mon, 29 Jul 2019 00:55:37 -0700
Message-ID: <000001d545e3$047d9750$0d78c5f0$@net>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: AdVDf23WWg3I21oIRx+B4OA3YdQqkgCV+ggg
Content-Language: en-ca
X-CMAE-Envelope: MS4wfDS911wo2ee/bgBIVUB73KpSWF+74QZKIitCa86dUdiDZZHzvgv8fA2Ct1Gu8/z5AKNBZ7YaNSAYpBKp5xieSOC0m/ki5wj6L66OVmt7rzsYXs9SPUzD
 47wZR3LV+deGHUeZBuKJeaAJ32vV513luLKd+6Hy6faYpuTZxcDYoRcmMsSbPuhCQwD1AYea6nVLaZ7hMSPNb8W90/T6/62fyCDUhhUgDQsSjjxWTsBpuDjG
 RYfFPin/dm9o1Bu+EeMxHLD1FuNaJS0mMHOXcMMXImgsPwffGb9UgxMqaYMuXTrYziDrsYN2Ao/I+9IPFDdyCe1216DLQnkaZ8XFSX1Vj7nfJyM9D6aOUqwZ
 K2A/j1/uN1ohm/8N64w6i40Rf3BGYyYJ28w9KCtU8mHnR1rRlOBeq4YZ05JADjHJDNuwzGSsNpHSzfSxwu0KPFkgH/C54Z9TB0Dn4jl5c7bD6POr6Ds=
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2019.07.25 23:58 Viresh Kumar wrote:
> On 25-07-19, 08:20, Doug Smythies wrote:
>> I tried the patch ("patch2"). It did not fix the issue.
>> 
>> To summarize, all kernel 5.2 based, all intel_cpufreq driver and schedutil governor:
>> 
>> Test: Does a busy system respond to maximum CPU clock frequency reduction?
>> 
>> stock, unaltered: No.
>> revert ecd2884291261e3fddbc7651ee11a20d596bb514: Yes
>> viresh patch: No.
>> fast_switch edit: No.
>> viresh patch2: No.
>
> Hmm, so I tried to reproduce your setup on my ARM board.
> - booted only with CPU0 so I hit the sugov_update_single() routine
> - And applied below diff to make CPU look permanently busy:
>
> -------------------------8<-------------------------
>diff --git a/kernel/sched/cpufreq_schedutil.c b/kernel/sched/cpufreq_schedutil.c
> index 2f382b0959e5..afb47490e5dc 100644
> --- a/kernel/sched/cpufreq_schedutil.c
> +++ b/kernel/sched/cpufreq_schedutil.c
> @@ -121,6 +121,7 @@ static void sugov_fast_switch(struct sugov_policy *sg_policy, u64 time,
>         if (!sugov_update_next_freq(sg_policy, time, next_freq))
>                return;
> 
> +       pr_info("%s: %d: %u\n", __func__, __LINE__, freq);

?? there is no "freq" variable here, and so this doesn't compile. However this works:

+       pr_info("%s: %d: %u\n", __func__, __LINE__, next_freq);

>         next_freq = cpufreq_driver_fast_switch(policy, next_freq);
>        if (!next_freq)
>                return;
> @@ -424,14 +425,10 @@ static unsigned long sugov_iowait_apply(struct sugov_cpu *sg_cpu, u64 time,
> #ifdef CONFIG_NO_HZ_COMMON
> static bool sugov_cpu_is_busy(struct sugov_cpu *sg_cpu)
> {
> -       unsigned long idle_calls = tick_nohz_get_idle_calls_cpu(sg_cpu->cpu);
> -       bool ret = idle_calls == sg_cpu->saved_idle_calls;
> -
> -       sg_cpu->saved_idle_calls = idle_calls;
> -       return ret;
> +       return true;
>  }
>  #else
> -static inline bool sugov_cpu_is_busy(struct sugov_cpu *sg_cpu) { return false; }
> +static inline bool sugov_cpu_is_busy(struct sugov_cpu *sg_cpu) { return true; }
> #endif /* CONFIG_NO_HZ_COMMON */
> 
>  /*
> @@ -565,6 +562,7 @@ static void sugov_work(struct kthread_work *work)
>         sg_policy->work_in_progress = false;
>         raw_spin_unlock_irqrestore(&sg_policy->update_lock, flags);
> 
> +       pr_info("%s: %d: %u\n", __func__, __LINE__, freq);
>         mutex_lock(&sg_policy->work_lock);
>         __cpufreq_driver_target(sg_policy->policy, freq, CPUFREQ_RELATION_L);
>         mutex_unlock(&sg_policy->work_lock);
> 
> -------------------------8<-------------------------
>
> Now, the frequency never gets down and so gets set to the maximum
> possible after a bit.
>
> - Then I did:
>
> echo <any-low-freq-value> > /sys/devices/system/cpu/cpufreq/policy0/scaling_max_freq
>
> Without my patch applied:
>        The print never gets printed and so frequency doesn't go down.
>
> With my patch applied:
>        The print gets printed immediately from sugov_work() and so
>        the frequency reduces.
> 
> Can you try with this diff along with my Patch2 ? I suspect there may
> be something wrong with the intel_cpufreq driver as the patch fixes
> the only path we have in the schedutil governor which takes busyness
> of a CPU into account.

With this diff along with your patch2 There is never a print message
from sugov_work. There are from sugov_fast_switch.

Note that for the intel_cpufreq CPU scaling driver and the schedutil
governor I adjust the maximum clock frequency this way:

echo <any-low-percent> > /sys/devices/system/cpu/intel_pstate/max_perf_pct

I also applied the pr_info messages to the reverted kernel, and re-did
my tests (where everything works as expected). There is never a print
message from sugov_work. There are from sugov_fast_switch.

Notes:

I do not know if:
/sys/devices/system/cpu/cpufreq/policy*/scaling_max_freq
/sys/devices/system/cpu/cpufreq/policy*/scaling_min_freq
Need to be accurate when using the intel_pstate driver in passive mode.
They are not.
The commit comment for 9083e4986124389e2a7c0ffca95630a4983887f0
suggests that they might need to be representative.
I wonder if something similar to that commit is needed
for other global changes, such as max_perf_pct and min_perf_pct?

intel_cpufreq/ondemand doesn't work properly on the reverted kernel.
(just discovered, not investigated)
I don't know about other governors.

... Doug


