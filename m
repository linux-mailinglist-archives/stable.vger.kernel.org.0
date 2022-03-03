Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 806F74CC843
	for <lists+stable@lfdr.de>; Thu,  3 Mar 2022 22:43:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232063AbiCCVoJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Mar 2022 16:44:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231588AbiCCVoI (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Mar 2022 16:44:08 -0500
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CB695A0AE;
        Thu,  3 Mar 2022 13:43:22 -0800 (PST)
Received: by mail-yb1-xb2a.google.com with SMTP id e186so12991248ybc.7;
        Thu, 03 Mar 2022 13:43:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=alAS49M9IRP4AVwNreiMTohBa8qBDLlQBp//VKlKCss=;
        b=jJCWoqgV0kqRT7taMz/mLizzdflWrTyKe1pNngeCdYKz48iA0RtWgZKgmHbJZpELj5
         wnn3IcV7Y4TiBc20nI/hRk4bfXxdZNPE+zOlB8uUX5YMi4PiY2GsOS5CrFD82Nu7YmbP
         CE0bc3kKYsKQpJFUJ7sPgFi0nl1UBHelsjIGhQTRQH60WRNZFbbfKhb9Hn3G3yEc1Cp2
         lP7IMfyEvRClU1zlZWNx93T4S/Uozxh8Zhnk81UQiUnmsYNROMCLqmzuBH7V+8bUmM5y
         ZEme2hnXKcuUYIIWTuCVW7CkrKufWIzf9o3hzxVijHteNPb/zG6kj4PnqhBq+y86DAs2
         rJ6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=alAS49M9IRP4AVwNreiMTohBa8qBDLlQBp//VKlKCss=;
        b=z0SAVaUEtWY1rY1mprElkNmL9FPXsF4If3Ce89QIFGdhqEdzyDp6BMZAnbN1iD51HD
         r+CtIbDtYl/xiV3IVAAKtDtqUN1Tqdh9GmjUfZBxbEgHG88c4AzJS5cdFtflyo71XyO9
         KXPyr87goIIXGgcfwW4yRJoXlEnMRdcyJb86vrtLCy7RrdC17WFikcFUZsnmDm5eGtrR
         Jj7SUQ/56kmCqV6qpuKZqmewCnpzOivQCTVs45Kr0hvlOgwbb3OOAhTlphzoRSMg5TsR
         5ulvbW6IJKK6T0JKiMk7P4nUM7q3BqbCQJr5WwspJsqi8DZIDohXT7Mqomb/NQuWXXE4
         YO0w==
X-Gm-Message-State: AOAM530MY13HKd2BLa2O5WQeXpAQBo4uQpfRpJjxOGgyxcNsEQFchNs4
        hVwLln3Mee5lF/DySGgQYKZlCXcctL6r0PheZfo=
X-Google-Smtp-Source: ABdhPJzinWRrWp8BJfseoIriNmrf7OuVtCRoDAx6g82NirD6O+oISNi+1/pk+D2QF41GMtTN7mDpuGLNIjYf8b63y/I=
X-Received: by 2002:a25:d9c7:0:b0:628:be42:b671 with SMTP id
 q190-20020a25d9c7000000b00628be42b671mr5804434ybg.387.1646343801441; Thu, 03
 Mar 2022 13:43:21 -0800 (PST)
MIME-Version: 1.0
References: <cover.1646094455.git.darren@os.amperecomputing.com>
 <84e7cb911936f032318b6b376cf88009c90d93d5.1646094455.git.darren@os.amperecomputing.com>
 <CAKfTPtAQwJYy4UDAgF3Va_MJTDj+UpxuU3UqTWZ5gjwmcTf5wA@mail.gmail.com>
 <YiAlfGuRXWVnOmyF@fedora> <CAGsJ_4y8MkQhAZ9c9yz_UHee7MCZrtv3aui=Luq-ZOBeAsGbGQ@mail.gmail.com>
 <YiDuV8YkaWGNgky7@fedora>
In-Reply-To: <YiDuV8YkaWGNgky7@fedora>
From:   Barry Song <21cnbao@gmail.com>
Date:   Fri, 4 Mar 2022 10:43:10 +1300
Message-ID: <CAGsJ_4xB3aq71c062QHC2TG-aYvC6N2fbx1W9UgMDz8HQg9p5Q@mail.gmail.com>
Subject: Re: [PATCH 1/1] arm64: smp: Skip MC sched domain on SoCs with no LLC
To:     Darren Hart <darren@os.amperecomputing.com>
Cc:     Sudeep Holla <sudeep.holla@arm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Arm <linux-arm-kernel@lists.infradead.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Barry Song <song.bao.hua@hisilicon.com>,
        Valentin Schneider <Valentin.Schneider@arm.com>,
        "D . Scott Phillips" <scott@os.amperecomputing.com>,
        Ilkka Koskinen <ilkka@os.amperecomputing.com>,
        stable@vger.kernel.org
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

On Fri, Mar 4, 2022 at 5:35 AM Darren Hart
<darren@os.amperecomputing.com> wrote:
>
> On Thu, Mar 03, 2022 at 06:36:30PM +1300, Barry Song wrote:
> > On Thu, Mar 3, 2022 at 3:22 PM Darren Hart
> > <darren@os.amperecomputing.com> wrote:
> > >
> > > On Wed, Mar 02, 2022 at 10:32:06AM +0100, Vincent Guittot wrote:
> > > > On Tue, 1 Mar 2022 at 01:35, Darren Hart <darren@os.amperecomputing.com> wrote:
> > > > >
> > > > > Ampere Altra defines CPU clusters in the ACPI PPTT. They share a Snoop
> > > > > Control Unit, but have no shared CPU-side last level cache.
> > > > >
> > > > > cpu_coregroup_mask() will return a cpumask with weight 1, while
> > > > > cpu_clustergroup_mask() will return a cpumask with weight 2.
> > > > >
> > > > > As a result, build_sched_domain() will BUG() once per CPU with:
> > > > >
> > > > > BUG: arch topology borken
> > > > >      the CLS domain not a subset of the MC domain
> > > > >
> > > > > The MC level cpumask is then extended to that of the CLS child, and is
> > > > > later removed entirely as redundant. This sched domain topology is an
> > > > > improvement over previous topologies, or those built without
> > > > > SCHED_CLUSTER, particularly for certain latency sensitive workloads.
> > > > > With the current scheduler model and heuristics, this is a desirable
> > > > > default topology for Ampere Altra and Altra Max system.
> > > > >
> > > > > Introduce an alternate sched domain topology for arm64 without the MC
> > > > > level and test for llc_sibling weight 1 across all CPUs to enable it.
> > > > >
> > > > > Do this in arch/arm64/kernel/smp.c (as opposed to
> > > > > arch/arm64/kernel/topology.c) as all the CPU sibling maps are now
> > > > > populated and we avoid needing to extend the drivers/acpi/pptt.c API to
> > > > > detect the cluster level being above the cpu llc level. This is
> > > > > consistent with other architectures and provides a readily extensible
> > > > > mechanism for other alternate topologies.
> > > > >
> > > > > The final sched domain topology for a 2 socket Ampere Altra system is
> > > > > unchanged with or without CONFIG_SCHED_CLUSTER, and the BUG is avoided:
> > > > >
> > > > > For CPU0:
> > > > >
> > > > > CONFIG_SCHED_CLUSTER=y
> > > > > CLS  [0-1]
> > > > > DIE  [0-79]
> > > > > NUMA [0-159]
> > > > >
> > > > > CONFIG_SCHED_CLUSTER is not set
> > > > > DIE  [0-79]
> > > > > NUMA [0-159]
> > > > >
> > > > > Cc: Catalin Marinas <catalin.marinas@arm.com>
> > > > > Cc: Will Deacon <will@kernel.org>
> > > > > Cc: Peter Zijlstra <peterz@infradead.org>
> > > > > Cc: Vincent Guittot <vincent.guittot@linaro.org>
> > > > > Cc: Barry Song <song.bao.hua@hisilicon.com>
> > > > > Cc: Valentin Schneider <valentin.schneider@arm.com>
> > > > > Cc: D. Scott Phillips <scott@os.amperecomputing.com>
> > > > > Cc: Ilkka Koskinen <ilkka@os.amperecomputing.com>
> > > > > Cc: <stable@vger.kernel.org> # 5.16.x
> > > > > Signed-off-by: Darren Hart <darren@os.amperecomputing.com>
> > > > > ---
> > > > >  arch/arm64/kernel/smp.c | 28 ++++++++++++++++++++++++++++
> > > > >  1 file changed, 28 insertions(+)
> > > > >
> > > > > diff --git a/arch/arm64/kernel/smp.c b/arch/arm64/kernel/smp.c
> > > > > index 27df5c1e6baa..3597e75645e1 100644
> > > > > --- a/arch/arm64/kernel/smp.c
> > > > > +++ b/arch/arm64/kernel/smp.c
> > > > > @@ -433,6 +433,33 @@ static void __init hyp_mode_check(void)
> > > > >         }
> > > > >  }
> > > > >
> > > > > +static struct sched_domain_topology_level arm64_no_mc_topology[] = {
> > > > > +#ifdef CONFIG_SCHED_SMT
> > > > > +       { cpu_smt_mask, cpu_smt_flags, SD_INIT_NAME(SMT) },
> > > > > +#endif
> > > > > +
> > > > > +#ifdef CONFIG_SCHED_CLUSTER
> > > > > +       { cpu_clustergroup_mask, cpu_cluster_flags, SD_INIT_NAME(CLS) },
> > > > > +#endif
> > > > > +
> > > > > +       { cpu_cpu_mask, SD_INIT_NAME(DIE) },
> > > > > +       { NULL, },
> > > > > +};
> > > > > +
> > > > > +static void __init update_sched_domain_topology(void)
> > > > > +{
> > > > > +       int cpu;
> > > > > +
> > > > > +       for_each_possible_cpu(cpu) {
> > > > > +               if (cpu_topology[cpu].llc_id != -1 &&
> > > >
> > > > Have you tested it with a non-acpi system ? AFAICT, llc_id is only set
> > > > by ACPI system and  llc_id == -1 for others like DT based system
> > > >
> > > > > +                   cpumask_weight(&cpu_topology[cpu].llc_sibling) > 1)
> > > > > +                       return;
> > > > > +       }
> > >
> > > Hi Vincent,
> > >
> > > I did not have a non-acpi system to test, no. You're right of course,
> > > llc_id is only set by ACPI systems on arm64. We could wrap this in a
> > > CONFIG_ACPI ifdef (or IS_ENABLED), but I think this would be preferable:
> > >
> > > +       for_each_possible_cpu(cpu) {
> > > +               if (cpu_topology[cpu].llc_id == -1 ||
> > > +                   cpumask_weight(&cpu_topology[cpu].llc_sibling) > 1)
> > > +                       return;
> > > +       }
> > >
> > > Quickly tested on Altra successfully. Would appreciate anyone with non-acpi
> > > arm64 systems who can test and verify this behaves as intended. I will ask
> > > around tomorrow as well to see what I may have access to.
> >
> > I wonder if we can fix it by this
> >
> > diff --git a/drivers/base/arch_topology.c b/drivers/base/arch_topology.c
> > index 976154140f0b..551655ccd0eb 100644
> > --- a/drivers/base/arch_topology.c
> > +++ b/drivers/base/arch_topology.c
> > @@ -627,6 +627,13 @@ const struct cpumask *cpu_coregroup_mask(int cpu)
> >                 if (cpumask_subset(&cpu_topology[cpu].llc_sibling, core_mask))
> >                         core_mask = &cpu_topology[cpu].llc_sibling;
> >         }
> > +       /*
> > +        * Some machines have no LLC but have clusters, we let MC = CLUSTER
> > +        * as MC should always be after CLUSTER. But anyway, the MC domain
> > +        * will be removed
> > +        */
> > +       if (cpumask_subset(core_mask, &cpu_topology[cpu].cluster_sibling))
> > +               core_mask = &cpu_topology[cpu].cluster_sibling;
> >
> >         return core_mask;
> >  }
> >
> > as it can make all kinds of topologies happy -  symmetric and asymmetric.
> >
>
> Hah. Full circle. Yes, this works, and it's basically what we'd started
> with internally. I ended up exploring various paths here to avoid a
> "band aid" and to target the fix and minimize impact. That said, after
> digging through the acpi, topology, smp, and sched domains code... I
> don't think this approach is a band aid and it's a very minimal
> solution. The only downside I can think of is masking a potential
> topology bug and not catching it in the scheduler - that seems very
> unlikely. I'm perfectly happy with this solution as well.
>
> Will D, would you prefer this approach?
>
> +Sudeep, Greg, and Rafael,
>
> Are you OK with this approach?
>
> If so, we can drop my arm64 specific new topology patch and I can send a
> version of this one out (suggested-by Barry of course), unless you'd
> prefer to send it Barry?

i prefer this solution as anyway, cpu_coregroup_mask() is a combination
of a couple of masks. we are just putting cluster_mask into consideration.

const struct cpumask *cpu_coregroup_mask(int cpu)
{
        const cpumask_t *core_mask = cpumask_of_node(cpu_to_node(cpu));

        /* Find the smaller of NUMA, core or LLC siblings */
        if (cpumask_subset(&cpu_topology[cpu].core_sibling, core_mask)) {
                /* not numa in package, lets use the package siblings */
                core_mask = &cpu_topology[cpu].core_sibling;
        }
        if (cpu_topology[cpu].llc_id != -1) {
                if (cpumask_subset(&cpu_topology[cpu].llc_sibling, core_mask))
                        core_mask = &cpu_topology[cpu].llc_sibling;
        }

        return core_mask;
}

we are also making this machine happy:

CPU0-CPU1 have cluster but have no LLC.
CPU2-CPU3 have both cluster and LLC.

for cpu0 and cpu1, they are getting cluster level only, mc will be dropped.
for cpu2 and cpu3, they are getting both cluster and mc.

Please feel free to send, Darren. And i feel wake_affine series will
finally have to handle your exception.

>
> Thanks,
>
> > >
> > > Thanks,
> > >
> > > > > +
> > > > > +       pr_info("No LLC siblings, using No MC sched domains topology\n");
> > > > > +       set_sched_topology(arm64_no_mc_topology);
> > > > > +}
> > > > > +
> > > > >  void __init smp_cpus_done(unsigned int max_cpus)
> > > > >  {
> > > > >         pr_info("SMP: Total of %d processors activated.\n", num_online_cpus());
> > > > > @@ -440,6 +467,7 @@ void __init smp_cpus_done(unsigned int max_cpus)
> > > > >         hyp_mode_check();
> > > > >         apply_alternatives_all();
> > > > >         mark_linear_text_alias_ro();
> > > > > +       update_sched_domain_topology();
> > > > >  }
> > > > >
> > > > >  void __init smp_prepare_boot_cpu(void)
> > > > > --
> > > > > 2.31.1
> > > > >
> > >
> > > --
> > > Darren Hart
> > > Ampere Computing / OS and Kernel
> >
> > Thanks
> > Barry
>
> --
> Darren Hart
> Ampere Computing / OS and Kernel

Thanks
Barry
