Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D91B64B90C5
	for <lists+stable@lfdr.de>; Wed, 16 Feb 2022 19:56:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234825AbiBPS4Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Feb 2022 13:56:25 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:45932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233352AbiBPS4Y (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Feb 2022 13:56:24 -0500
Received: from mail-yw1-x1129.google.com (mail-yw1-x1129.google.com [IPv6:2607:f8b0:4864:20::1129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52B292B0B35;
        Wed, 16 Feb 2022 10:56:11 -0800 (PST)
Received: by mail-yw1-x1129.google.com with SMTP id 00721157ae682-2d646fffcc2so9003277b3.4;
        Wed, 16 Feb 2022 10:56:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Vk36aod0FuaMpPlJAG4bXGrtjGi+8N3zZwitdLcGJCE=;
        b=GsNiDyjU7vKeeHiMElextmRDv+7zBHEh161NyRhRlumr3EUCVwxaOgMeBEfkHnlFI9
         0al7J0ktpigyKvcFf14d9iQ8R8J3iyIBrKdvnToJvxgOFuksaENxRa8I3AHpcN3gy3ze
         CBUisPu3cdEMafv/mKB9S6vISg6RNM0DL8vGnPzi/cakT3dtH+Wy6EfGajg7+9PC3bWW
         cn6Zv0i3F35PArXGuWKlWiza6QC1GntOzYsZ36/vgXQa4jTlR6GdSvt5ZHZgteYmwyNX
         p25URqgfih+oy9ejyWc2RdRSgVsK1LXLKnDJnWLwfTBu9wyxpVUvjgV+PlNocyKJJK7v
         zhhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Vk36aod0FuaMpPlJAG4bXGrtjGi+8N3zZwitdLcGJCE=;
        b=8FZve7GRJgLOfWymqScR2qHgsHbV5L0pTtG+RrJmmsLiVpK21ZidyMfxWju/YTZY1C
         3h6u3QI0c7KnDQRB9Hq7R2OSWKPzf0BBwBwPD5PLkVMf1OLUDAXw8mX9ealkR5V6nq8x
         Y7nXcSQYle5ler1XfpP19IbDR2pW0iKLXiFjVLa2w2tOeoFsYGiHjTNM+rl2hnwG47wo
         l7ePsTiRwqB6yxwX/Nm92zZj9nZJyvCq7uHXWM/Q1gFOLTgrEPiK37nr1i43/sPB/cn9
         eyqckXMYf2iGk9zGWWHIGWW5/ekTYKbO5kL0FClUE2ZNS/OgiR0D7oorQzGqQyQ+jGRy
         N5xw==
X-Gm-Message-State: AOAM530w5Xo5I3sRDDeqOPHsYz5mbeNd7jSm7x+/cxlWlUtYzJ4ZHrHW
        kd7hB2kOhiBLFvhVH0uI05S9AY9SdzAjzqzdCGc=
X-Google-Smtp-Source: ABdhPJxhNdDQrZuw2YKgJX48LftVX7TGt5W+q53tlWGDCJ5jFMYi7Mhq8pHXArMmRhOUlzax/nRBUIdh9SV8JNhPuks=
X-Received: by 2002:a0d:d4d7:0:b0:2ca:287c:6cea with SMTP id
 w206-20020a0dd4d7000000b002ca287c6ceamr3717631ywd.399.1645037770419; Wed, 16
 Feb 2022 10:56:10 -0800 (PST)
MIME-Version: 1.0
References: <8c4a69eca4d0591f30c112df59c5098c24923bd3.1644543449.git.darren@os.amperecomputing.com>
 <ec9be4eb7a0548178191edd51ddd309f@hisilicon.com> <20220215163858.GA8458@willie-the-truck>
 <YgvYZy5xv1g+u5wp@fedora> <20220215164639.GC8458@willie-the-truck>
 <CAKfTPtAFsL+uqQiGcuh+JJZB=rPrez0=kotq76CVRcBQhcPefg@mail.gmail.com>
 <YgvjtsOZuxzbgBBl@fedora> <CAKfTPtCHrZCp1Uth4odyT721wE8zoNVY3Mh+DSyuTkqPafm0Hg@mail.gmail.com>
 <CAGsJ_4yB-FOPoPjCn+T4m76tvzA6ATaz24KYM9NjBeB54nWxLA@mail.gmail.com> <Yg0bu53iACDscIC6@fedora>
In-Reply-To: <Yg0bu53iACDscIC6@fedora>
From:   Barry Song <21cnbao@gmail.com>
Date:   Thu, 17 Feb 2022 07:56:00 +1300
Message-ID: <CAGsJ_4w2r8Hp3BNOrcQYDT6JgsFWWAgVruAOXpeXrhjskJMV7w@mail.gmail.com>
Subject: Re: [PATCH] arm64: smp: Skip MC domain for SoCs without shared cache
To:     Darren Hart <darren@os.amperecomputing.com>
Cc:     Vincent Guittot <vincent.guittot@linaro.org>,
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
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 17, 2022 at 4:44 AM Darren Hart
<darren@os.amperecomputing.com> wrote:
>
> On Wed, Feb 16, 2022 at 08:03:40PM +1300, Barry Song wrote:
> > On Wed, Feb 16, 2022 at 7:30 PM Vincent Guittot
> > <vincent.guittot@linaro.org> wrote:
> > >
> > > On Tue, 15 Feb 2022 at 18:32, Darren Hart <darren@os.amperecomputing.com> wrote:
> > > >
> > > > On Tue, Feb 15, 2022 at 06:09:08PM +0100, Vincent Guittot wrote:
> > > > > On Tue, 15 Feb 2022 at 17:46, Will Deacon <will@kernel.org> wrote:
> > > > > >
> > > > > > On Tue, Feb 15, 2022 at 08:44:23AM -0800, Darren Hart wrote:
> > > > > > > On Tue, Feb 15, 2022 at 04:38:59PM +0000, Will Decon wrote:
> > > > > > > > On Fri, Feb 11, 2022 at 03:20:51AM +0000, Song Bao Hua (Barry Song) wrote:
> > > > > > > > >
> > > > > > > > >
> > > > > > > > > > -----Original Message-----
> > > > > > > > > > From: Darren Hart [mailto:darren@os.amperecomputing.com]
> > > > > > > > > > Sent: Friday, February 11, 2022 2:43 PM
> > > > > > > > > > To: LKML <linux-kernel@vger.kernel.org>; Linux Arm
> > > > > > > > > > <linux-arm-kernel@lists.infradead.org>
> > > > > > > > > > Cc: Catalin Marinas <catalin.marinas@arm.com>; Will Deacon <will@kernel.org>;
> > > > > > > > > > Peter Zijlstra <peterz@infradead.org>; Vincent Guittot
> > > > > > > > > > <vincent.guittot@linaro.org>; Song Bao Hua (Barry Song)
> > > > > > > > > > <song.bao.hua@hisilicon.com>; Valentin Schneider
> > > > > > > > > > <valentin.schneider@arm.com>; D . Scott Phillips
> > > > > > > > > > <scott@os.amperecomputing.com>; Ilkka Koskinen
> > > > > > > > > > <ilkka@os.amperecomputing.com>; stable@vger.kernel.org
> > > > > > > > > > Subject: [PATCH] arm64: smp: Skip MC domain for SoCs without shared cache
> > > > > > > > > >
> > > > > > > > > > SoCs such as the Ampere Altra define clusters but have no shared
> > > > > > > > > > processor-side cache. As of v5.16 with CONFIG_SCHED_CLUSTER and
> > > > > > > > > > CONFIG_SCHED_MC, build_sched_domain() will BUG() with:
> > > > > > > > > >
> > > > > > > > > > BUG: arch topology borken
> > > > > > > > > >      the CLS domain not a subset of the MC domain
> > > > > > > > > >
> > > > > > > > > > for each CPU (160 times for a 2 socket 80 core Altra system). The MC
> > > > > > > > > > level cpu mask is then extended to that of the CLS child, and is later
> > > > > > > > > > removed entirely as redundant.
> > > > > > > > > >
> > > > > > > > > > This change detects when all cpu_coregroup_mask weights=1 and uses an
> > > > > > > > > > alternative sched_domain_topology equivalent to the default if
> > > > > > > > > > CONFIG_SCHED_MC were disabled.
> > > > > > > > > >
> > > > > > > > > > The final resulting sched domain topology is unchanged with or without
> > > > > > > > > > CONFIG_SCHED_CLUSTER, and the BUG is avoided:
> > > > > > > > > >
> > > > > > > > > > For CPU0:
> > > > > > > > > >
> > > > > > > > > > With CLS:
> > > > > > > > > > CLS  [0-1]
> > > > > > > > > > DIE  [0-79]
> > > > > > > > > > NUMA [0-159]
> > > > > > > > > >
> > > > > > > > > > Without CLS:
> > > > > > > > > > DIE  [0-79]
> > > > > > > > > > NUMA [0-159]
> > > > > > > > > >
> > > > > > > > > > Cc: Catalin Marinas <catalin.marinas@arm.com>
> > > > > > > > > > Cc: Will Deacon <will@kernel.org>
> > > > > > > > > > Cc: Peter Zijlstra <peterz@infradead.org>
> > > > > > > > > > Cc: Vincent Guittot <vincent.guittot@linaro.org>
> > > > > > > > > > Cc: Barry Song <song.bao.hua@hisilicon.com>
> > > > > > > > > > Cc: Valentin Schneider <valentin.schneider@arm.com>
> > > > > > > > > > Cc: D. Scott Phillips <scott@os.amperecomputing.com>
> > > > > > > > > > Cc: Ilkka Koskinen <ilkka@os.amperecomputing.com>
> > > > > > > > > > Cc: <stable@vger.kernel.org> # 5.16.x
> > > > > > > > > > Signed-off-by: Darren Hart <darren@os.amperecomputing.com>
> > > > > > > > >
> > > > > > > > > Hi Darrent,
> > > > > > > > > What kind of resources are clusters sharing on Ampere Altra?
> > > > > > > > > So on Altra, cpus are not sharing LLC? Each LLC is separate
> > > > > > > > > for each cpu?
> > > > > > > > >
> > > > > > > > > > ---
> > > > > > > > > >  arch/arm64/kernel/smp.c | 32 ++++++++++++++++++++++++++++++++
> > > > > > > > > >  1 file changed, 32 insertions(+)
> > > > > > > > > >
> > > > > > > > > > diff --git a/arch/arm64/kernel/smp.c b/arch/arm64/kernel/smp.c
> > > > > > > > > > index 27df5c1e6baa..0a78ac5c8830 100644
> > > > > > > > > > --- a/arch/arm64/kernel/smp.c
> > > > > > > > > > +++ b/arch/arm64/kernel/smp.c
> > > > > > > > > > @@ -715,9 +715,22 @@ void __init smp_init_cpus(void)
> > > > > > > > > >         }
> > > > > > > > > >  }
> > > > > > > > > >
> > > > > > > > > > +static struct sched_domain_topology_level arm64_no_mc_topology[] = {
> > > > > > > > > > +#ifdef CONFIG_SCHED_SMT
> > > > > > > > > > +       { cpu_smt_mask, cpu_smt_flags, SD_INIT_NAME(SMT) },
> > > > > > > > > > +#endif
> > > > > > > > > > +
> > > > > > > > > > +#ifdef CONFIG_SCHED_CLUSTER
> > > > > > > > > > +       { cpu_clustergroup_mask, cpu_cluster_flags, SD_INIT_NAME(CLS) },
> > > > > > > > > > +#endif
> > > > > > > > > > +       { cpu_cpu_mask, SD_INIT_NAME(DIE) },
> > > > > > > > > > +       { NULL, },
> > > > > > > > > > +};
> > > > > > > > > > +
> > > > > > > > > >  void __init smp_prepare_cpus(unsigned int max_cpus)
> > > > > > > > > >  {
> > > > > > > > > >         const struct cpu_operations *ops;
> > > > > > > > > > +       bool use_no_mc_topology = true;
> > > > > > > > > >         int err;
> > > > > > > > > >         unsigned int cpu;
> > > > > > > > > >         unsigned int this_cpu;
> > > > > > > > > > @@ -758,6 +771,25 @@ void __init smp_prepare_cpus(unsigned int max_cpus)
> > > > > > > > > >
> > > > > > > > > >                 set_cpu_present(cpu, true);
> > > > > > > > > >                 numa_store_cpu_info(cpu);
> > > > > > > > > > +
> > > > > > > > > > +               /*
> > > > > > > > > > +                * Only use no_mc topology if all cpu_coregroup_mask weights=1
> > > > > > > > > > +                */
> > > > > > > > > > +               if (cpumask_weight(cpu_coregroup_mask(cpu)) > 1)
> > > > > > > > > > +                       use_no_mc_topology = false;
> > > > > > > > >
> > > > > > > > > This seems to be wrong? If you have 5 cpus,
> > > > > > > > > Cpu0 has cpu_coregroup_mask(cpu)== 1, cpu1-4
> > > > > > > > > has cpu_coregroup_mask(cpu)== 4, for cpu0, you still
> > > > > > > > > need to remove MC, but for cpu1-4, you will need
> > > > > > > > > CLS and MC both?
> > > > > > > >
> > > > > > > > What is the *current* behaviour on such a system?
> > > > > > > >
> > > > > > >
> > > > > > > As I understand it, any system that uses the default topology which has
> > > > > > > a cpus_coregroup weight of 1 and a child (cluster, smt, ...) weight > 1
> > > > > > > will behave as described above by printing the following for each CPU
> > > > > > > matching this criteria:
> > > > > > >
> > > > > > >   BUG: arch topology borken
> > > > > > >         the [CLS,SMT,...] domain not a subset of the MC domain
> > > > > > >
> > > > > > > And then extend the MC domain cpumask to match that of the child and continue
> > > > > > > on.
> > > > > > >
> > > > > > > That would still be the behavior for this type of system after this
> > > > > > > patch is applied.
> > > > > >
> > > > > > That's what I thought, but in that case applying your patch is a net
> > > > > > improvement: systems either get current or better behaviour.
> > > > >
> > > > > CLUSTER level is normally defined as a intermediate group of the MC
> > > > > level and both levels have the scheduler flag SD_SHARE_PKG_RESOURCES
> > > > > flag
> > > > >
> > > > > In the case of Ampere altra, they consider that CPUA have a CLUSTER
> > > > > level which SD_SHARE_PKG_RESOURCES with another CPUB but the next and
> > > > > larger MC level then says that CPUA doesn't SD_SHARE_PKG_RESOURCES
> > > > > with CPUB which seems to be odd because the SD_SHARE_PKG_RESOURCES has
> > > > > not disappeared Looks like there is a mismatch in topology description
> > > >
> > > > Hi Vincent,
> > > >
> > > > Agree. Where do you think this mismatch exists?
> > >
> > > I think that the problem comes from that the default topology order is
> > > assumed to be :
> > > SMT
> > > CLUSTER shares pkg resources i.e. cache
> > > MC
> > > DIE
> > > NUMA
> > >
> > > but in your case, you want a topology order like :
> > > SMT
> > > MC
> > > CLUSTER shares SCU
> > > DIE
> > > NUMA
> > >
> > > IIUC, the cluster is defined as the 2nd (no SMT) or 3rd (SMT) level in
> > > the PPTT table whereas the MC level is defined as the number of cache
> > > levels. So i would say that you should compare the level to know the
> > > ordering
> > >
> > > Then, there is another point:
> > > In your case, CLUSTER level still has the flag SD_SHARE_PKG_RESOURCES
> > > which is used to define some scheduler internal variable like
> > > sd_llc(sched domain last level of cache) which allows fast task
> > > migration between this cpus in this level at wakeup. In your case the
> > > sd_llc should not be the cluster but the MC with only one CPU. But I
> > > would not be surprised that most of perf improvement comes from this
> > > sd_llc wrongly set to cluster instead of the single CPU
> >
> > I assume this "mistake" is actually what Ampere altra needs while it
> > is wrong but getting
> > right result? Ampere altra has already got both:
>
> Hi Barry,
>
> Generally yes - although I do think we're placing too much emphasis on
> the "right" or "wrong" of a heuristic which are more fluid in
> definition over time. (e.g. I expect this will look different in a year
> based on what we learn from this and other non current default topologies).
>
> > 1. Load Balance between clusters
> > 2. wake_affine by select sibling cpu which is sharing SCU
> >
> > I am not sure how much 1 and 2 are helping Darren's workloads respectively.
>
> We definitely see improvements with load balancing between clusters.
> We're running some tests with the wake_affine patchset you pointed me to
> (thanks for that). My initial tbench runs resulted in higher average and
> max latencies reported. I need to collect more results and see the
> impact to other benchmarks of interest before I have more to share on
> that.

Hi Darren,
if you read Vincent's comments carefully, you will find it is
pointless for you to
test the wake_affine patchset as you have already got it. in your
case, sd_llc_id
is set to sd_cluster level due to PKG_RESOURCES sharing. So with my new
patchset for wake_affine, it is completely redundant for your machine
as it works
with the assumption cluster-> llc. but for your case, llc=cluster, so
it works in
cluster->cluster. please read:

static void update_top_cache_domain(int cpu)
{
struct sched_domain_shared *sds = NULL;
struct sched_domain *sd;
int id = cpu;
int size = 1;

sd = highest_flag_domain(cpu, SD_SHARE_PKG_RESOURCES);
if (sd) {
id = cpumask_first(sched_domain_span(sd));
size = cpumask_weight(sched_domain_span(sd));
sds = sd->shared;
}

rcu_assign_pointer(per_cpu(sd_llc, cpu), sd);
per_cpu(sd_llc_size, cpu) = size;
per_cpu(sd_llc_id, cpu) = id;
rcu_assign_pointer(per_cpu(sd_llc_shared, cpu), sds);

...
}

this is also the content of Vincent's last comment:
"
My concern is that there are some ongoing discussion to make more
usage of the CLUSTER level than what is currently done and it assumes
that we have a valid LLC level after the CLUSTER one which is not your
case and I'm afraid that it will be suboptimal for you because CLUSTER
and LLC are wrongly the same for your case and then you will come back
to add more exception in the generic scheduler code to cover this
first exception"

so it is incorrect for you to say you gain performance only by LB :-)

>
> Thanks,
>
> --
> Darren Hart
> Ampere Computing / OS and Kernel

Thanks
Barry
