Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D24954B78FD
	for <lists+stable@lfdr.de>; Tue, 15 Feb 2022 21:53:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229945AbiBOSUL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Feb 2022 13:20:11 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:36498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243013AbiBOSUK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Feb 2022 13:20:10 -0500
Received: from mail-lj1-x235.google.com (mail-lj1-x235.google.com [IPv6:2a00:1450:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04D7E119F15
        for <stable@vger.kernel.org>; Tue, 15 Feb 2022 10:19:59 -0800 (PST)
Received: by mail-lj1-x235.google.com with SMTP id n24so25280110ljj.10
        for <stable@vger.kernel.org>; Tue, 15 Feb 2022 10:19:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hVpoK7dzemOp1es3usLChh0bGBN1t8oLA6/5fjtbVnw=;
        b=B8BLigDeMR7ajTJxRLIFsEkEnl+C4wQDUZGM7sP7xaAVt4tLdKLvaJg1b3ezozOdir
         /jUPT3PXcQdLuSdoX6/HVIuvv0lGpN3j0N8MqYPEMz/gZk+eMuLgIh+k/BXYRwVKHiki
         5FIt03enowuzMhpVuOXhvDYag3atweKFOITaQ6lRwLPvgoP0iDLSRSS3Onn+7ye8ebjd
         /yvDf8OI9AD0TW9QuPguQHWt3K0CvgY90JFzsuKGJIw9/NHRghjZkrv0eeeULz29vp7c
         qZdFBQ1M4donJb1tOxnQWP/G32jQPXGPx3tFNHdCBcLS0cc/P2Ytbxu0eLXc8X81xb5U
         47Yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hVpoK7dzemOp1es3usLChh0bGBN1t8oLA6/5fjtbVnw=;
        b=rzlMWxYsUjWy6swTLCti0ApJjLOyRUcoa63N4ApucRl+AX5nqr72K+ovHKg2bLQtVf
         jDTJis4Vu6U//IZY0ZAc0UkyNxsLt2EgCsEYLbaTES83KOpJxwtWrcspOAW2rzYICkzV
         2m23Es29ZEpwu5MsTXgVy6tB93GnbEOJe4DVg7zQ+QMTWeIIw1M9CCpd4lSk79Stoqf+
         IcJQ6BrViwj1zsvglRpNSZhq8MiI0ZTd9uAXkUnPKehRDZ6euoEBMa/A07Pps09kEMCO
         Hk5Leh9gyq1k/VKPtCbmC7MKTdUM/tYkMYLNeKpuwg+1HsI9txobWORjP1mcLYdV+rIw
         Xe3g==
X-Gm-Message-State: AOAM532uD30Mala7ljXZJ2ysVZa0ySnB2s8TyxNu9qSMUZc2qavKC3GJ
        q5gGkmQZpnNQ4rYlbWuU3abI4gmgFZQXPY5iH71jhg==
X-Google-Smtp-Source: ABdhPJyLAyJv+JwxJC/XjyLxT/Cc5yJvIpHYdCXasDlAT3dDrMvTqLFsGG1O7hG+4r+06tO+ySTVVyDr6Te3PMf2W9o=
X-Received: by 2002:a2e:a80e:: with SMTP id l14mr166273ljq.381.1644949197196;
 Tue, 15 Feb 2022 10:19:57 -0800 (PST)
MIME-Version: 1.0
References: <8c4a69eca4d0591f30c112df59c5098c24923bd3.1644543449.git.darren@os.amperecomputing.com>
 <ec9be4eb7a0548178191edd51ddd309f@hisilicon.com> <20220215163858.GA8458@willie-the-truck>
 <YgvYZy5xv1g+u5wp@fedora> <20220215164639.GC8458@willie-the-truck>
 <CAKfTPtAFsL+uqQiGcuh+JJZB=rPrez0=kotq76CVRcBQhcPefg@mail.gmail.com> <YgvjtsOZuxzbgBBl@fedora>
In-Reply-To: <YgvjtsOZuxzbgBBl@fedora>
From:   Vincent Guittot <vincent.guittot@linaro.org>
Date:   Tue, 15 Feb 2022 19:19:45 +0100
Message-ID: <CAKfTPtCHrZCp1Uth4odyT721wE8zoNVY3Mh+DSyuTkqPafm0Hg@mail.gmail.com>
Subject: Re: [PATCH] arm64: smp: Skip MC domain for SoCs without shared cache
To:     Darren Hart <darren@os.amperecomputing.com>
Cc:     Will Deacon <will@kernel.org>,
        "Song Bao Hua (Barry Song)" <song.bao.hua@hisilicon.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Arm <linux-arm-kernel@lists.infradead.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Valentin Schneider <Valentin.Schneider@arm.com>,
        "D . Scott Phillips" <scott@os.amperecomputing.com>,
        Ilkka Koskinen <ilkka@os.amperecomputing.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
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

On Tue, 15 Feb 2022 at 18:32, Darren Hart <darren@os.amperecomputing.com> wrote:
>
> On Tue, Feb 15, 2022 at 06:09:08PM +0100, Vincent Guittot wrote:
> > On Tue, 15 Feb 2022 at 17:46, Will Deacon <will@kernel.org> wrote:
> > >
> > > On Tue, Feb 15, 2022 at 08:44:23AM -0800, Darren Hart wrote:
> > > > On Tue, Feb 15, 2022 at 04:38:59PM +0000, Will Decon wrote:
> > > > > On Fri, Feb 11, 2022 at 03:20:51AM +0000, Song Bao Hua (Barry Song) wrote:
> > > > > >
> > > > > >
> > > > > > > -----Original Message-----
> > > > > > > From: Darren Hart [mailto:darren@os.amperecomputing.com]
> > > > > > > Sent: Friday, February 11, 2022 2:43 PM
> > > > > > > To: LKML <linux-kernel@vger.kernel.org>; Linux Arm
> > > > > > > <linux-arm-kernel@lists.infradead.org>
> > > > > > > Cc: Catalin Marinas <catalin.marinas@arm.com>; Will Deacon <will@kernel.org>;
> > > > > > > Peter Zijlstra <peterz@infradead.org>; Vincent Guittot
> > > > > > > <vincent.guittot@linaro.org>; Song Bao Hua (Barry Song)
> > > > > > > <song.bao.hua@hisilicon.com>; Valentin Schneider
> > > > > > > <valentin.schneider@arm.com>; D . Scott Phillips
> > > > > > > <scott@os.amperecomputing.com>; Ilkka Koskinen
> > > > > > > <ilkka@os.amperecomputing.com>; stable@vger.kernel.org
> > > > > > > Subject: [PATCH] arm64: smp: Skip MC domain for SoCs without shared cache
> > > > > > >
> > > > > > > SoCs such as the Ampere Altra define clusters but have no shared
> > > > > > > processor-side cache. As of v5.16 with CONFIG_SCHED_CLUSTER and
> > > > > > > CONFIG_SCHED_MC, build_sched_domain() will BUG() with:
> > > > > > >
> > > > > > > BUG: arch topology borken
> > > > > > >      the CLS domain not a subset of the MC domain
> > > > > > >
> > > > > > > for each CPU (160 times for a 2 socket 80 core Altra system). The MC
> > > > > > > level cpu mask is then extended to that of the CLS child, and is later
> > > > > > > removed entirely as redundant.
> > > > > > >
> > > > > > > This change detects when all cpu_coregroup_mask weights=1 and uses an
> > > > > > > alternative sched_domain_topology equivalent to the default if
> > > > > > > CONFIG_SCHED_MC were disabled.
> > > > > > >
> > > > > > > The final resulting sched domain topology is unchanged with or without
> > > > > > > CONFIG_SCHED_CLUSTER, and the BUG is avoided:
> > > > > > >
> > > > > > > For CPU0:
> > > > > > >
> > > > > > > With CLS:
> > > > > > > CLS  [0-1]
> > > > > > > DIE  [0-79]
> > > > > > > NUMA [0-159]
> > > > > > >
> > > > > > > Without CLS:
> > > > > > > DIE  [0-79]
> > > > > > > NUMA [0-159]
> > > > > > >
> > > > > > > Cc: Catalin Marinas <catalin.marinas@arm.com>
> > > > > > > Cc: Will Deacon <will@kernel.org>
> > > > > > > Cc: Peter Zijlstra <peterz@infradead.org>
> > > > > > > Cc: Vincent Guittot <vincent.guittot@linaro.org>
> > > > > > > Cc: Barry Song <song.bao.hua@hisilicon.com>
> > > > > > > Cc: Valentin Schneider <valentin.schneider@arm.com>
> > > > > > > Cc: D. Scott Phillips <scott@os.amperecomputing.com>
> > > > > > > Cc: Ilkka Koskinen <ilkka@os.amperecomputing.com>
> > > > > > > Cc: <stable@vger.kernel.org> # 5.16.x
> > > > > > > Signed-off-by: Darren Hart <darren@os.amperecomputing.com>
> > > > > >
> > > > > > Hi Darrent,
> > > > > > What kind of resources are clusters sharing on Ampere Altra?
> > > > > > So on Altra, cpus are not sharing LLC? Each LLC is separate
> > > > > > for each cpu?
> > > > > >
> > > > > > > ---
> > > > > > >  arch/arm64/kernel/smp.c | 32 ++++++++++++++++++++++++++++++++
> > > > > > >  1 file changed, 32 insertions(+)
> > > > > > >
> > > > > > > diff --git a/arch/arm64/kernel/smp.c b/arch/arm64/kernel/smp.c
> > > > > > > index 27df5c1e6baa..0a78ac5c8830 100644
> > > > > > > --- a/arch/arm64/kernel/smp.c
> > > > > > > +++ b/arch/arm64/kernel/smp.c
> > > > > > > @@ -715,9 +715,22 @@ void __init smp_init_cpus(void)
> > > > > > >         }
> > > > > > >  }
> > > > > > >
> > > > > > > +static struct sched_domain_topology_level arm64_no_mc_topology[] = {
> > > > > > > +#ifdef CONFIG_SCHED_SMT
> > > > > > > +       { cpu_smt_mask, cpu_smt_flags, SD_INIT_NAME(SMT) },
> > > > > > > +#endif
> > > > > > > +
> > > > > > > +#ifdef CONFIG_SCHED_CLUSTER
> > > > > > > +       { cpu_clustergroup_mask, cpu_cluster_flags, SD_INIT_NAME(CLS) },
> > > > > > > +#endif
> > > > > > > +       { cpu_cpu_mask, SD_INIT_NAME(DIE) },
> > > > > > > +       { NULL, },
> > > > > > > +};
> > > > > > > +
> > > > > > >  void __init smp_prepare_cpus(unsigned int max_cpus)
> > > > > > >  {
> > > > > > >         const struct cpu_operations *ops;
> > > > > > > +       bool use_no_mc_topology = true;
> > > > > > >         int err;
> > > > > > >         unsigned int cpu;
> > > > > > >         unsigned int this_cpu;
> > > > > > > @@ -758,6 +771,25 @@ void __init smp_prepare_cpus(unsigned int max_cpus)
> > > > > > >
> > > > > > >                 set_cpu_present(cpu, true);
> > > > > > >                 numa_store_cpu_info(cpu);
> > > > > > > +
> > > > > > > +               /*
> > > > > > > +                * Only use no_mc topology if all cpu_coregroup_mask weights=1
> > > > > > > +                */
> > > > > > > +               if (cpumask_weight(cpu_coregroup_mask(cpu)) > 1)
> > > > > > > +                       use_no_mc_topology = false;
> > > > > >
> > > > > > This seems to be wrong? If you have 5 cpus,
> > > > > > Cpu0 has cpu_coregroup_mask(cpu)== 1, cpu1-4
> > > > > > has cpu_coregroup_mask(cpu)== 4, for cpu0, you still
> > > > > > need to remove MC, but for cpu1-4, you will need
> > > > > > CLS and MC both?
> > > > >
> > > > > What is the *current* behaviour on such a system?
> > > > >
> > > >
> > > > As I understand it, any system that uses the default topology which has
> > > > a cpus_coregroup weight of 1 and a child (cluster, smt, ...) weight > 1
> > > > will behave as described above by printing the following for each CPU
> > > > matching this criteria:
> > > >
> > > >   BUG: arch topology borken
> > > >         the [CLS,SMT,...] domain not a subset of the MC domain
> > > >
> > > > And then extend the MC domain cpumask to match that of the child and continue
> > > > on.
> > > >
> > > > That would still be the behavior for this type of system after this
> > > > patch is applied.
> > >
> > > That's what I thought, but in that case applying your patch is a net
> > > improvement: systems either get current or better behaviour.
> >
> > CLUSTER level is normally defined as a intermediate group of the MC
> > level and both levels have the scheduler flag SD_SHARE_PKG_RESOURCES
> > flag
> >
> > In the case of Ampere altra, they consider that CPUA have a CLUSTER
> > level which SD_SHARE_PKG_RESOURCES with another CPUB but the next and
> > larger MC level then says that CPUA doesn't SD_SHARE_PKG_RESOURCES
> > with CPUB which seems to be odd because the SD_SHARE_PKG_RESOURCES has
> > not disappeared Looks like there is a mismatch in topology description
>
> Hi Vincent,
>
> Agree. Where do you think this mismatch exists?

I think that the problem comes from that the default topology order is
assumed to be :
SMT
CLUSTER shares pkg resources i.e. cache
MC
DIE
NUMA

but in your case, you want a topology order like :
SMT
MC
CLUSTER shares SCU
DIE
NUMA

IIUC, the cluster is defined as the 2nd (no SMT) or 3rd (SMT) level in
the PPTT table whereas the MC level is defined as the number of cache
levels. So i would say that you should compare the level to know the
ordering

Then, there is another point:
In your case, CLUSTER level still has the flag SD_SHARE_PKG_RESOURCES
which is used to define some scheduler internal variable like
sd_llc(sched domain last level of cache) which allows fast task
migration between this cpus in this level at wakeup. In your case the
sd_llc should not be the cluster but the MC with only one CPU. But I
would not be surprised that most of perf improvement comes from this
sd_llc wrongly set to cluster instead of the single CPU


>
> I'd describe this as a mismatch between the default assumptions of
> the sched domains construction code (that SD_SHARE_PKG_RESOURCES implies
> a shared cpu-side cache) and SoCs without a shared cpu-side cache. This
> is encoded in properties of the MC level and the requirement that child
> domains be a subset of the parent domain cpumask.
>
> The MC-less topology addresses this in a consistent way with other
> architectures using the provided API for non-default topologies without
> changing these fundamental assumptions and without changing the final
> resulting topology which is correct and matches the topology supplied in
> the ACPI PPTT.


>
> --
> Darren Hart
> Ampere Computing / OS and Kernel
