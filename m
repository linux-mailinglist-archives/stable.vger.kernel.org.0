Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24C134DC810
	for <lists+stable@lfdr.de>; Thu, 17 Mar 2022 14:58:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234768AbiCQN7w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Mar 2022 09:59:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233208AbiCQN7v (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Mar 2022 09:59:51 -0400
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D900989322
        for <stable@vger.kernel.org>; Thu, 17 Mar 2022 06:58:33 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id h14so9122071lfk.11
        for <stable@vger.kernel.org>; Thu, 17 Mar 2022 06:58:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=telus.net; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vtfU7ZmSyzu0aIBlObVJRVKPE0I4koFlCCs17r3YyMg=;
        b=DDSztKNogamfDkI/8FN/2Q7CWAH/YpMKFlMSmdPCvL5xSGqxZnFXMG9h6eZzuZlQ1Q
         kMBPFLEXq0ZlD+UWe1D0x50yC67tAV4cbypxlEj2/KsTqCqmvyEXqFBWFfgz6r4lpDJk
         SDFZrc15uvgJypei0HBIxFI+IF7t4SRzKb/2wRLCq9R9cvy/iClxahc3KfWppKYpPwyG
         ZbPjGaeZoXjv0JSq/nx4Se6XSufJWDy3qlDsXojULbJFHsY2EL6Z1l1ETpHEaQQMEdcq
         fWZcRkogTVIrkdjQE4ZVunEIyVa94x3+4uxM2hJcSboirfjkK3NKI38jF6OPyFiRR7qv
         9pAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vtfU7ZmSyzu0aIBlObVJRVKPE0I4koFlCCs17r3YyMg=;
        b=OUJa5H4mNmr132aB8dxNHBND0qUcXt1fteS1DhIsc3khuaE6XtkpaURwOcNV8apm0/
         KloLS7PXFrtivTWuSIuAmQihkg9rL9MXJdCBPb3/S0cm5QBrFiIrAMkySkRvVqTU/D7n
         3Jux929hU3QDmf0NpaE/ef6egGPdjibISv+UcTUTLXQtcXy8oCgJwqG72oz1fw2kCDHi
         wkwsubLk6rpmC6R4LzE+Goeywp0MJiYRGLDHuWkDIgwEH6w0TxWHcyv4kawXHWL1zI7j
         oKxCoDFNjYvTcPqOFJleKjqpFtUeOa9vpqjHcP0bQ0fESay0VMik9X/KgCkzEM9Wa2VL
         unbw==
X-Gm-Message-State: AOAM53106iY22bh4V5L4WI/kEogzrbMopeP4MhfjaTHGR8Vt1zkEktrC
        m04MD/AQu6F+7HiagXyfDMMPZ44dM2iLFj3EAdwVcA==
X-Google-Smtp-Source: ABdhPJxwM07ramt53nvtfTEItNjtOoMd+PViBjYZslXdZDbaTdxFE81LFojy8Y/m0ML35fiGgPCh1OOWQSncpXwBOkg=
X-Received: by 2002:a05:6512:10d4:b0:448:9691:435e with SMTP id
 k20-20020a05651210d400b004489691435emr2857526lfg.465.1647525512185; Thu, 17
 Mar 2022 06:58:32 -0700 (PDT)
MIME-Version: 1.0
References: <CAAYoRsXkyWf0vmEE2HvjF6pzCC4utxTF=7AFx1PJv4Evh=C+Ow@mail.gmail.com>
 <CAAYoRsW4LqNvSZ3Et5fqeFcHQ9j9-0u9Y-LN9DmpCS3wG3+NWg@mail.gmail.com>
 <20220228041228.GH4548@shbuild999.sh.intel.com> <11956019.O9o76ZdvQC@kreacher>
 <20220301055255.GI4548@shbuild999.sh.intel.com> <CAJZ5v0jWUR__zn0=SDDecFct86z-=Y6v5fi37mMyW+zOBi7oWw@mail.gmail.com>
 <CAAYoRsVLOcww0z4mp9TtGCKdrgeEiL_=FgrUO=rwkZAok4sQdg@mail.gmail.com>
 <CAJZ5v0hK4zoOtgNQNFkJHC0XOiGsPGUPphHU5og44e_K4kGU9g@mail.gmail.com>
 <CAAYoRsWN-h+fBAoocGmUFHDkOv2PL+6U59_ASBYH74j0orHaCQ@mail.gmail.com>
 <CAJZ5v0iOOmRY3uC1-ZGQ30VysMuAjGum=Lt4tkqNUjop+ikqZw@mail.gmail.com>
 <CAAYoRsVs_CB-dBGShksmXATRP3oGnD6uU-xQdSPjkRER+j6fTQ@mail.gmail.com>
 <CAAYoRsVnPa-aiKCju7Nz+cznyOo2sbioFks+gU7W7dqWyO8JJw@mail.gmail.com>
 <CAAYoRsU=SjE2zpQPjxrE6aDzEk6+AZy9DUAJ4Vv2qimbiJ2ySQ@mail.gmail.com> <CAJZ5v0hTOD8Y-ft0jo8KO+RW33ow7_Lm+6gAWA0BpM7o-u4vyQ@mail.gmail.com>
In-Reply-To: <CAJZ5v0hTOD8Y-ft0jo8KO+RW33ow7_Lm+6gAWA0BpM7o-u4vyQ@mail.gmail.com>
From:   Doug Smythies <dsmythies@telus.net>
Date:   Thu, 17 Mar 2022 06:58:25 -0700
Message-ID: <CAAYoRsU-e70mDpKrO_dqdPJTRrPMD8cKmFnyHVoXGEVTFotvUQ@mail.gmail.com>
Subject: Re: CPU excessively long times between frequency scaling driver calls
 - bisected
To:     "Rafael J. Wysocki" <rafael@kernel.org>
Cc:     "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "Zhang, Rui" <rui.zhang@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "paulmck@kernel.org" <paulmck@kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        srinivas pandruvada <srinivas.pandruvada@linux.intel.com>,
        Feng Tang <feng.tang@intel.com>,
        dsmythies <dsmythies@telus.net>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 17, 2022 at 5:30 AM Rafael J. Wysocki <rafael@kernel.org> wrote:
> On Wed, Mar 16, 2022 at 4:55 PM Doug Smythies <dsmythies@telus.net> wrote:
> >
> > Readers: So that graphs and large attachments could be used, I have
> > been on an off-list branch of this thread with Srinivas, and copied a
> > couple of others. While now returning to this on-list thread, I'll
> > only take up Rafael's proposed patch.
> >
> > Hi Rafael,
> >
> > So far all work has been done with: HWP disabled; intel_pstate; powersave.
> > The reason was that it is, by far, the best way to obtain good trace data
> > using the intel_pstate_tracer.py utility.
> >
> > I always intended to try/test: HWP disabled; intel_cpufreq; schedutil.
> > There is an issue with the proposed patch and schedutil.
> >
> > If any CPU ever requests a pstate > the max non turbo pstate
> > then it will stay at that request forever. Ultimately the idle
> > power goes to about 5.7 watts (verses 1.4 watts expected).
> > IRQs go very high, as the tick never turns off.
> > Actually, one knows how many CPUs are stuck requesting a high
> > pstate just by looking at IRQs.
>
> That may be because INTEL_CPUFREQ_TRANSITION_DELAY is too small.
>
> Please try to increase
> /sys/devices/system/cpu/cpufreq/schedutil/rate_limit_us to 10000 and
> see what difference this makes.

Changing rate_limit_us to 10000, or even 20000, makes no difference.

see a slight clarification to yesterday's email in-line below.

> > Trace is useless because it virtually never gets called.
> > So I have been reading the IA32_PERF_CTL MSR
> > directly.
> >
> > Example:
> >
> > Processor: Intel(R) Core(TM) i5-10600K CPU @ 4.10GHz
> > 6 cores, 12 CPUs
> > min pstate 8
> > max non-turbo pstate 41
> > max turbo pstate 48
> > The system is idle.
> >
> > doug@s19:~$ sudo
> > /home/doug/kernel/linux/tools/power/x86/turbostat/turbostat --Summary
> > --quiet --show Busy%,Bzy_MHz,IRQ,PkgWatt --interval 10
> > Busy%   Bzy_MHz IRQ     PkgWatt
> > 0.11    800     844     1.33
> > 0.01    800     231     1.33
> > 0.11    800     723     1.33 <<< Powersave governor
> > 0.03    889     440     1.33
> > 0.17    4418    21511   4.31 <<< Schedutil governor
> > 0.12    4101    30153   4.48 <<< 3 CPUs are > pstate 41
> > 0.22    4347    34226   4.75
> > 0.17    4101    43554   4.78
> > 0.29    4300    50565   4.94
> > 0.21    4098    50297   4.76 <<< 5 CPUs are > pstate 41
> > 0.29    4298    50532   4.84
> > 0.20    4101    50126   4.63
> > 0.20    4101    50149   4.62
> > 0.29    4297    50623   4.76
> > 0.20    4101    50203   4.72
> > 0.29    4295    50642   4.78
> > 0.20    4101    50223   4.68
> > 0.29    4292    50597   4.88
> > 0.20    4101    50208   4.73
> > 0.29    4296    50519   4.84
> > 0.20    4101    50167   4.80
> > 0.20    4101    50242   4.76
> > 0.29    4302    50625   4.94
> > 0.20    4101    50233   4.73
> > 0.29    4296    50613   4.78
> > 0.20    4101    50231   4.70
> > 0.29    4292    50802   4.93
> > 1.46    4669    65610   8.36
> > 0.41    4225    80701   5.48
> > 0.33    4101    80219   5.36 <<< 8 CPUs are > ptstate 41
> > 0.34    4098    80313   5.38
> > 0.41    4228    80689   5.56
> > 0.33    4101    80252   5.46
> >
> > And the related MSR reads:
> >
> > 3 CPUs are > pstate 41:
> > root@s19:/home/doug# c/msr-decoder | grep IA32_PERF_CTL
> > 9.) 0x199: IA32_PERF_CTL        : CPU 0-11 :  30 :   8 :   8 :  48 :
> > 48 :  48 :   8 :  30 :  31 :   8 :   8 :   8 :
> >
> > 5 CPUs are > psate 41:
> > root@s19:/home/doug# c/msr-decoder | grep IA32_PERF_CTL
> > 9.) 0x199: IA32_PERF_CTL        : CPU 0-11 :  44 :  30 :  31 :  48 :
> > 48 :  48 :   8 :   8 :   8 :   8 :  48 :   8 :
> >
> > 8 CPUs are > pstate 41:
> > root@s19:/home/doug# c/msr-decoder | grep IA32_PERF_CTL
> > 9.) 0x199: IA32_PERF_CTL        : CPU 0-11 :  45 :  48 :  48 :  48 :
> > 48 :  48 :   8 :  30 :   8 :   8 :  48 :  42 :
> >
> > This issue is independent of the original patch or the suggested modification:

Actually, the issue threshold is as defined by the greater than condition below.

> >
> > > diff --git a/drivers/cpufreq/intel_pstate.c b/drivers/cpufreq/intel_pstate.c
> > > index f878a4545eee..94018ac0b59b 100644
> > > --- a/drivers/cpufreq/intel_pstate.c
> > > +++ b/drivers/cpufreq/intel_pstate.c
> > > @@ -1980,7 +1980,7 @@ static void intel_pstate_update_perf_ctl(struct
> > > cpudata *cpu)
> > >          * P-states to prevent them from getting back to the high frequency
> > >          * right away after getting out of deep idle.
> > >          */
> > > -       cpuidle_update_retain_tick(pstate > cpu->pstate.max_pstate);

For the above kernel the threshold is pstate 42.

> > > +       cpuidle_update_retain_tick(pstate > ((cpu->pstate.max_pstate +
> > > cpu->pstate.min_pstate)/2));

For the above kernel the threshold is pstate 25.

> > >         wrmsrl(MSR_IA32_PERF_CTL, pstate_funcs.get_val(cpu, pstate));
> > >  }
> >
> > ... Doug
