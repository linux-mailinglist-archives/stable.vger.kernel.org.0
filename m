Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE48475F5D
	for <lists+stable@lfdr.de>; Fri, 26 Jul 2019 08:57:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725945AbfGZG5o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jul 2019 02:57:44 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:44898 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725944AbfGZG5o (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 26 Jul 2019 02:57:44 -0400
Received: by mail-pl1-f195.google.com with SMTP id t14so24359345plr.11
        for <stable@vger.kernel.org>; Thu, 25 Jul 2019 23:57:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=bzQNKaZKw8eToFqDsQXbuB2yvZDO2AGHnxOmbSadekg=;
        b=D7jepyajIBROtTtVBRHO30NiYXAeVmjGCJbHSHXTuzjnSS8FsQ3UuvfORc1nANBoCV
         4CKKsTIM5dtsEO607omtllGtCE8qOnJmQCgTbR1fYXDggum829aLmyTii5PkS6fd34od
         T2cNSa8CjGv9SEDMGaCU33ritC8YGOBNMhBoWe3ZRvwB41GWr9XjgqkBMvZ0QDrcWs4L
         irdsOPL2P9Fg1+oEAAw1PUVDBjx6voLdFWjdrEsONJ55F1XS6VlJs1SEpAek+1so9BNd
         NTazoekjIgNqSPfCw/ZOVTRebwGFq8baCu0Xq8yDDvZLf6hFmjfiL7BxVK25Jti7ffq1
         bx+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=bzQNKaZKw8eToFqDsQXbuB2yvZDO2AGHnxOmbSadekg=;
        b=gWn/SEH/N+Iy4TS936ET48PaolGgz1NzN2Hc6ClyUOM+P1wRE44T95ArNMrRnL0kSj
         d2VlkJiiNHry2BeApNq48i5g11CW6QnJhXlSsp+0wRpunYA30UaVteMXKYfRK4Od7zvq
         eqvgU/0F3X9PwJPSPmBA3hRNQiWpfL2wYkgRg0a7tPFyNDUAvOnPqSetHFGiPsM30IYV
         ZthRBKKztuHkM15hAYDBjQkYoBr0H5pcYPliQ40aoMoVNmf2/FonjpCRyhopiRojlt+p
         wE0en5tVGbpAiAa9mCiHTSLqEv3mskkj4MJ+CYN69EIGvAYcqBlXbZf0z3HLrC55u4ML
         I/7g==
X-Gm-Message-State: APjAAAWphGLqSAPPHhZI8WcKMFtMCVs4Pe9QSNVSNBDQo8QDhtqjiCs6
        K3Far4wQZtoin40/Hme6uLS26w==
X-Google-Smtp-Source: APXvYqzzo+ODsFIczIG4j/cy5XNrUcZj88VBcx5YjQ+nwxEcwhFoGe3xWYa2zhp/yiPSVfhcKjKEfw==
X-Received: by 2002:a17:902:ff11:: with SMTP id f17mr96645555plj.121.1564124263268;
        Thu, 25 Jul 2019 23:57:43 -0700 (PDT)
Received: from localhost ([122.172.28.117])
        by smtp.gmail.com with ESMTPSA id o24sm7949706pgn.93.2019.07.25.23.57.41
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 25 Jul 2019 23:57:41 -0700 (PDT)
Date:   Fri, 26 Jul 2019 12:27:39 +0530
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
Message-ID: <20190726065739.xjvyvqpkb3o6m4ty@vireshk-i7>
References: <1563431200-3042-1-git-send-email-dsmythies@telus.net>
 <8091ef83f264feb2feaa827fbeefe08348bcd05d.1563778071.git.viresh.kumar@linaro.org>
 <001201d54125$a6a82350$f3f869f0$@net>
 <20190723091551.nchopfpqlmdmzvge@vireshk-i7>
 <CAJZ5v0ji+ksapJ4kc2m5UM_O+AShAvJWmYhTQHiXiHnpTq+xRg@mail.gmail.com>
 <20190724114327.apmx35c7a4tv3qt5@vireshk-i7>
 <000c01d542fc$703ff850$50bfe8f0$@net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000c01d542fc$703ff850$50bfe8f0$@net>
User-Agent: NeoMutt/20180716-391-311a52
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 25-07-19, 08:20, Doug Smythies wrote:
> I tried the patch ("patch2"). It did not fix the issue.
> 
> To summarize, all kernel 5.2 based, all intel_cpufreq driver and schedutil governor:
> 
> Test: Does a busy system respond to maximum CPU clock frequency reduction?
> 
> stock, unaltered: No.
> revert ecd2884291261e3fddbc7651ee11a20d596bb514: Yes
> viresh patch: No.
> fast_switch edit: No.
> viresh patch2: No.

Hmm, so I tried to reproduce your setup on my ARM board.
- booted only with CPU0 so I hit the sugov_update_single() routine
- And applied below diff to make CPU look permanently busy:

-------------------------8<-------------------------
diff --git a/kernel/sched/cpufreq_schedutil.c b/kernel/sched/cpufreq_schedutil.c
index 2f382b0959e5..afb47490e5dc 100644
--- a/kernel/sched/cpufreq_schedutil.c
+++ b/kernel/sched/cpufreq_schedutil.c
@@ -121,6 +121,7 @@ static void sugov_fast_switch(struct sugov_policy *sg_policy, u64 time,
        if (!sugov_update_next_freq(sg_policy, time, next_freq))
                return;
 
+       pr_info("%s: %d: %u\n", __func__, __LINE__, freq);
        next_freq = cpufreq_driver_fast_switch(policy, next_freq);
        if (!next_freq)
                return;
@@ -424,14 +425,10 @@ static unsigned long sugov_iowait_apply(struct sugov_cpu *sg_cpu, u64 time,
 #ifdef CONFIG_NO_HZ_COMMON
 static bool sugov_cpu_is_busy(struct sugov_cpu *sg_cpu)
 {
-       unsigned long idle_calls = tick_nohz_get_idle_calls_cpu(sg_cpu->cpu);
-       bool ret = idle_calls == sg_cpu->saved_idle_calls;
-
-       sg_cpu->saved_idle_calls = idle_calls;
-       return ret;
+       return true;
 }
 #else
-static inline bool sugov_cpu_is_busy(struct sugov_cpu *sg_cpu) { return false; }
+static inline bool sugov_cpu_is_busy(struct sugov_cpu *sg_cpu) { return true; }
 #endif /* CONFIG_NO_HZ_COMMON */
 
 /*
@@ -565,6 +562,7 @@ static void sugov_work(struct kthread_work *work)
        sg_policy->work_in_progress = false;
        raw_spin_unlock_irqrestore(&sg_policy->update_lock, flags);
 
+       pr_info("%s: %d: %u\n", __func__, __LINE__, freq);
        mutex_lock(&sg_policy->work_lock);
        __cpufreq_driver_target(sg_policy->policy, freq, CPUFREQ_RELATION_L);
        mutex_unlock(&sg_policy->work_lock);

-------------------------8<-------------------------

Now, the frequency never gets down and so gets set to the maximum
possible after a bit.

- Then I did:

echo <any-low-freq-value> > /sys/devices/system/cpu/cpufreq/policy0/scaling_max_freq

Without my patch applied:
        The print never gets printed and so frequency doesn't go down.

With my patch applied:
        The print gets printed immediately from sugov_work() and so
        the frequency reduces.

Can you try with this diff along with my Patch2 ? I suspect there may
be something wrong with the intel_cpufreq driver as the patch fixes
the only path we have in the schedutil governor which takes busyness
of a CPU into account.

-- 
viresh
