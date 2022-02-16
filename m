Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 134E14B8128
	for <lists+stable@lfdr.de>; Wed, 16 Feb 2022 08:15:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229785AbiBPHOQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Feb 2022 02:14:16 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:46120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229651AbiBPHOQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Feb 2022 02:14:16 -0500
Received: from mail-oi1-x234.google.com (mail-oi1-x234.google.com [IPv6:2607:f8b0:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 320062656B;
        Tue, 15 Feb 2022 23:13:54 -0800 (PST)
Received: by mail-oi1-x234.google.com with SMTP id r19so1543592oic.5;
        Tue, 15 Feb 2022 23:13:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3nsjvHbUhzQrkJZSIA7HdnaLKHsFmXXh8Gl3E95muZA=;
        b=DbB71rnk3S81ppfURfwcnqYNOG1Il07v0zl0j8s1/hbWZkwZf/mASAKyIoq/E9gyuD
         C2WRoyOcB7I9DnLIDs+Wj9oYLUid0pgwvkCAOqiyWQWLiQ6sfFTLT6aYrQkYTR18ilzq
         F8I+FWhULtfhlvgRVlDZPkuHKosfyc/vzVyWyNS93Yh3kVld8qsGeWHffyoi1v9nWrHW
         Qph+RlVs0E5TgQTcYMuwkXIoUHPUXqXaD0rVhzxHGJL+3I4sx9Gk841O1wFwJSrXdkDK
         sILhv1bpFZghhjg7yVG/5JtDEetvZuh3T7qOQ8VgeKF9Zj1Uz28BLIAsQ/+QcpcWNI75
         UubA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3nsjvHbUhzQrkJZSIA7HdnaLKHsFmXXh8Gl3E95muZA=;
        b=5DSeVEWYjAPFH9NTTzLyBEK6tyRIMkvZrZS0qhQ0ZvQbsyA80A+TEMbTw5TkHxNzAi
         pjXPNs+aOIND2xUvoF3GGqbe3beqSo/QdnqzOO1/hlcihS3cZtaDalYUEhj7ZOwOnPwM
         YnZRx1eI7QjiOEeZTNoJa4TrI82g6gOAkdfaOlxFA9aff+QjslzRThIY13DkSYDvi38B
         MRmTe/Zue9nu0+aIA1QOBVvHqbQBgzu2mymju0Jj0Dx6vkd6IlRuAVojiUMWlj5MjqIR
         c+8zg8r3JvJ8QpjeJDooiq5JduoNx4Nwu1wQvX8IY/uComGiSs7sQO8Bioyo0Iv+XRtl
         4X/Q==
X-Gm-Message-State: AOAM531mJ5vYRKOxJzvIJxVyiWLEcB8VjBCQxHsbvhNnyFDBE3PqQoa1
        62IAdEas8qV3Ye81uj+b9w4QegJ4f1Q5qBP9xjZTHrHJ9Bs=
X-Google-Smtp-Source: ABdhPJyhba7XRcnzngBAPhetSbXftpCg/0KoOKM05QYYwo/WLiVl7FybUs7uwUH8aSVhkmUtX4KO6qiuH3+rinkrXCU=
X-Received: by 2002:a05:6870:772e:b0:d2:8c2a:7c75 with SMTP id
 dw46-20020a056870772e00b000d28c2a7c75mr52453oab.202.1644995031771; Tue, 15
 Feb 2022 23:03:51 -0800 (PST)
MIME-Version: 1.0
References: <8c4a69eca4d0591f30c112df59c5098c24923bd3.1644543449.git.darren@os.amperecomputing.com>
 <ec9be4eb7a0548178191edd51ddd309f@hisilicon.com> <20220215163858.GA8458@willie-the-truck>
 <YgvYZy5xv1g+u5wp@fedora> <20220215164639.GC8458@willie-the-truck>
 <CAKfTPtAFsL+uqQiGcuh+JJZB=rPrez0=kotq76CVRcBQhcPefg@mail.gmail.com>
 <YgvjtsOZuxzbgBBl@fedora> <CAKfTPtCHrZCp1Uth4odyT721wE8zoNVY3Mh+DSyuTkqPafm0Hg@mail.gmail.com>
In-Reply-To: <CAKfTPtCHrZCp1Uth4odyT721wE8zoNVY3Mh+DSyuTkqPafm0Hg@mail.gmail.com>
From:   Barry Song <21cnbao@gmail.com>
Date:   Wed, 16 Feb 2022 20:03:40 +1300
Message-ID: <CAGsJ_4yB-FOPoPjCn+T4m76tvzA6ATaz24KYM9NjBeB54nWxLA@mail.gmail.com>
Subject: Re: [PATCH] arm64: smp: Skip MC domain for SoCs without shared cache
To:     Vincent Guittot <vincent.guittot@linaro.org>
Cc:     Darren Hart <darren@os.amperecomputing.com>,
        Will Deacon <will@kernel.org>,
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
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 16, 2022 at 7:30 PM Vincent Guittot
<vincent.guittot@linaro.org> wrote:
>
> On Tue, 15 Feb 2022 at 18:32, Darren Hart <darren@os.amperecomputing.com> wrote:
> >
> > On Tue, Feb 15, 2022 at 06:09:08PM +0100, Vincent Guittot wrote:
> > > On Tue, 15 Feb 2022 at 17:46, Will Deacon <will@kernel.org> wrote:
> > > >
> > > > On Tue, Feb 15, 2022 at 08:44:23AM -0800, Darren Hart wrote:
> > > > > On Tue, Feb 15, 2022 at 04:38:59PM +0000, Will Decon wrote:
> > > > > > On Fri, Feb 11, 2022 at 03:20:51AM +0000, Song Bao Hua (Barry Song) wrote:
> > > > > > >
> > > > > > >
> > > > > > > > -----Original Message-----
> > > > > > > > From: Darren Hart [mailto:darren@os.amperecomputing.com]
> > > > > > > > Sent: Friday, February 11, 2022 2:43 PM
> > > > > > > > To: LKML <linux-kernel@vger.kernel.org>; Linux Arm
> > > > > > > > <linux-arm-kernel@lists.infradead.org>
> > > > > > > > Cc: Catalin Marinas <catalin.marinas@arm.com>; Will Deacon <will@kernel.org>;
> > > > > > > > Peter Zijlstra <peterz@infradead.org>; Vincent Guittot
> > > > > > > > <vincent.guittot@linaro.org>; Song Bao Hua (Barry Song)
> > > > > > > > <song.bao.hua@hisilicon.com>; Valentin Schneider
> > > > > > > > <valentin.schneider@arm.com>; D . Scott Phillips
> > > > > > > > <scott@os.amperecomputing.com>; Ilkka Koskinen
> > > > > > > > <ilkka@os.amperecomputing.com>; stable@vger.kernel.org
> > > > > > > > Subject: [PATCH] arm64: smp: Skip MC domain for SoCs without shared cache
> > > > > > > >
> > > > > > > > SoCs such as the Ampere Altra define clusters but have no shared
> > > > > > > > processor-side cache. As of v5.16 with CONFIG_SCHED_CLUSTER and
> > > > > > > > CONFIG_SCHED_MC, build_sched_domain() will BUG() with:
> > > > > > > >
> > > > > > > > BUG: arch topology borken
> > > > > > > >      the CLS domain not a subset of the MC domain
> > > > > > > >
> > > > > > > > for each CPU (160 times for a 2 socket 80 core Altra system). The MC
> > > > > > > > level cpu mask is then extended to that of the CLS child, and is later
> > > > > > > > removed entirely as redundant.
> > > > > > > >
> > > > > > > > This change detects when all cpu_coregroup_mask weights=1 and uses an
> > > > > > > > alternative sched_domain_topology equivalent to the default if
> > > > > > > > CONFIG_SCHED_MC were disabled.
> > > > > > > >
> > > > > > > > The final resulting sched domain topology is unchanged with or without
> > > > > > > > CONFIG_SCHED_CLUSTER, and the BUG is avoided:
> > > > > > > >
> > > > > > > > For CPU0:
> > > > > > > >
> > > > > > > > With CLS:
> > > > > > > > CLS  [0-1]
> > > > > > > > DIE  [0-79]
> > > > > > > > NUMA [0-159]
> > > > > > > >
> > > > > > > > Without CLS:
> > > > > > > > DIE  [0-79]
> > > > > > > > NUMA [0-159]
> > > > > > > >
> > > > > > > > Cc: Catalin Marinas <catalin.marinas@arm.com>
> > > > > > > > Cc: Will Deacon <will@kernel.org>
> > > > > > > > Cc: Peter Zijlstra <peterz@infradead.org>
> > > > > > > > Cc: Vincent Guittot <vincent.guittot@linaro.org>
> > > > > > > > Cc: Barry Song <song.bao.hua@hisilicon.com>
> > > > > > > > Cc: Valentin Schneider <valentin.schneider@arm.com>
> > > > > > > > Cc: D. Scott Phillips <scott@os.amperecomputing.com>
> > > > > > > > Cc: Ilkka Koskinen <ilkka@os.amperecomputing.com>
> > > > > > > > Cc: <stable@vger.kernel.org> # 5.16.x
> > > > > > > > Signed-off-by: Darren Hart <darren@os.amperecomputing.com>
> > > > > > >
> > > > > > > Hi Darrent,
> > > > > > > What kind of resources are clusters sharing on Ampere Altra?
> > > > > > > So on Altra, cpus are not sharing LLC? Each LLC is separate
> > > > > > > for each cpu?
> > > > > > >
> > > > > > > > ---
> > > > > > > >  arch/arm64/kernel/smp.c | 32 ++++++++++++++++++++++++++++++++
> > > > > > > >  1 file changed, 32 insertions(+)
> > > > > > > >
> > > > > > > > diff --git a/arch/arm64/kernel/smp.c b/arch/arm64/kernel/smp.c
> > > > > > > > index 27df5c1e6baa..0a78ac5c8830 100644
> > > > > > > > --- a/arch/arm64/kernel/smp.c
> > > > > > > > +++ b/arch/arm64/kernel/smp.c
> > > > > > > > @@ -715,9 +715,22 @@ void __init smp_init_cpus(void)
> > > > > > > >         }
> > > > > > > >  }
> > > > > > > >
> > > > > > > > +static struct sched_domain_topology_level arm64_no_mc_topology[] = {
> > > > > > > > +#ifdef CONFIG_SCHED_SMT
> > > > > > > > +       { cpu_smt_mask, cpu_smt_flags, SD_INIT_NAME(SMT) },
> > > > > > > > +#endif
> > > > > > > > +
> > > > > > > > +#ifdef CONFIG_SCHED_CLUSTER
> > > > > > > > +       { cpu_clustergroup_mask, cpu_cluster_flags, SD_INIT_NAME(CLS) },
> > > > > > > > +#endif
> > > > > > > > +       { cpu_cpu_mask, SD_INIT_NAME(DIE) },
> > > > > > > > +       { NULL, },
> > > > > > > > +};
> > > > > > > > +
> > > > > > > >  void __init smp_prepare_cpus(unsigned int max_cpus)
> > > > > > > >  {
> > > > > > > >         const struct cpu_operations *ops;
> > > > > > > > +       bool use_no_mc_topology = true;
> > > > > > > >         int err;
> > > > > > > >         unsigned int cpu;
> > > > > > > >         unsigned int this_cpu;
> > > > > > > > @@ -758,6 +771,25 @@ void __init smp_prepare_cpus(unsigned int max_cpus)
> > > > > > > >
> > > > > > > >                 set_cpu_present(cpu, true);
> > > > > > > >                 numa_store_cpu_info(cpu);
> > > > > > > > +
> > > > > > > > +               /*
> > > > > > > > +                * Only use no_mc topology if all cpu_coregroup_mask weights=1
> > > > > > > > +                */
> > > > > > > > +               if (cpumask_weight(cpu_coregroup_mask(cpu)) > 1)
> > > > > > > > +                       use_no_mc_topology = false;
> > > > > > >
> > > > > > > This seems to be wrong? If you have 5 cpus,
> > > > > > > Cpu0 has cpu_coregroup_mask(cpu)== 1, cpu1-4
> > > > > > > has cpu_coregroup_mask(cpu)== 4, for cpu0, you still
> > > > > > > need to remove MC, but for cpu1-4, you will need
> > > > > > > CLS and MC both?
> > > > > >
> > > > > > What is the *current* behaviour on such a system?
> > > > > >
> > > > >
> > > > > As I understand it, any system that uses the default topology which has
> > > > > a cpus_coregroup weight of 1 and a child (cluster, smt, ...) weight > 1
> > > > > will behave as described above by printing the following for each CPU
> > > > > matching this criteria:
> > > > >
> > > > >   BUG: arch topology borken
> > > > >         the [CLS,SMT,...] domain not a subset of the MC domain
> > > > >
> > > > > And then extend the MC domain cpumask to match that of the child and continue
> > > > > on.
> > > > >
> > > > > That would still be the behavior for this type of system after this
> > > > > patch is applied.
> > > >
> > > > That's what I thought, but in that case applying your patch is a net
> > > > improvement: systems either get current or better behaviour.
> > >
> > > CLUSTER level is normally defined as a intermediate group of the MC
> > > level and both levels have the scheduler flag SD_SHARE_PKG_RESOURCES
> > > flag
> > >
> > > In the case of Ampere altra, they consider that CPUA have a CLUSTER
> > > level which SD_SHARE_PKG_RESOURCES with another CPUB but the next and
> > > larger MC level then says that CPUA doesn't SD_SHARE_PKG_RESOURCES
> > > with CPUB which seems to be odd because the SD_SHARE_PKG_RESOURCES has
> > > not disappeared Looks like there is a mismatch in topology description
> >
> > Hi Vincent,
> >
> > Agree. Where do you think this mismatch exists?
>
> I think that the problem comes from that the default topology order is
> assumed to be :
> SMT
> CLUSTER shares pkg resources i.e. cache
> MC
> DIE
> NUMA
>
> but in your case, you want a topology order like :
> SMT
> MC
> CLUSTER shares SCU
> DIE
> NUMA
>
> IIUC, the cluster is defined as the 2nd (no SMT) or 3rd (SMT) level in
> the PPTT table whereas the MC level is defined as the number of cache
> levels. So i would say that you should compare the level to know the
> ordering
>
> Then, there is another point:
> In your case, CLUSTER level still has the flag SD_SHARE_PKG_RESOURCES
> which is used to define some scheduler internal variable like
> sd_llc(sched domain last level of cache) which allows fast task
> migration between this cpus in this level at wakeup. In your case the
> sd_llc should not be the cluster but the MC with only one CPU. But I
> would not be surprised that most of perf improvement comes from this
> sd_llc wrongly set to cluster instead of the single CPU

I assume this "mistake" is actually what Ampere altra needs while it
is wrong but getting
right result? Ampere altra has already got both:
1. Load Balance between clusters
2. wake_affine by select sibling cpu which is sharing SCU

I am not sure how much 1 and 2 are helping Darren's workloads respectively.

>
>
> >
> > I'd describe this as a mismatch between the default assumptions of
> > the sched domains construction code (that SD_SHARE_PKG_RESOURCES implies
> > a shared cpu-side cache) and SoCs without a shared cpu-side cache. This
> > is encoded in properties of the MC level and the requirement that child
> > domains be a subset of the parent domain cpumask.
> >
> > The MC-less topology addresses this in a consistent way with other
> > architectures using the provided API for non-default topologies without
> > changing these fundamental assumptions and without changing the final
> > resulting topology which is correct and matches the topology supplied in
> > the ACPI PPTT.
>
>
> >
> > --
> > Darren Hart
> > Ampere Computing / OS and Kernel

Thanks
Barry
