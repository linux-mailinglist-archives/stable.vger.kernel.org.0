Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38DDA4C19DD
	for <lists+stable@lfdr.de>; Wed, 23 Feb 2022 18:24:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231589AbiBWRYd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Feb 2022 12:24:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240178AbiBWRYd (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Feb 2022 12:24:33 -0500
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1F984F9F4
        for <stable@vger.kernel.org>; Wed, 23 Feb 2022 09:24:04 -0800 (PST)
Received: by mail-lf1-x132.google.com with SMTP id j15so32341313lfe.11
        for <stable@vger.kernel.org>; Wed, 23 Feb 2022 09:24:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=txwRzy7T4FJEAmlc/vFopAVCAIZ4Qfp20yRwWgSyO3s=;
        b=j0cHyeokrvGSdSOMVvUffbMZ1PNzlDlia9sNhuaqCCffwEs4uuUPeA4tln6yQKf5UU
         TwEPXkBYzXuv5OZkVcZOBC//bdZ9WKy0Lg+GeNAwawqAoIZYbC0Q0HSdetImJLx5OiQz
         OPAHCG1vtpEQ2V7W4jViq4cVJVMcl64ANPvSBq1CyrI9QFNlA837toKKfgOb+9ol4jPj
         OVArJ3ubVIcqtadb9uoLRXBqOrnQzFoSVvrxt9sJHOuOFvA6OgDkomZ1J+Ixagd4pJsp
         BPLOhaifK42WxAK6MSYTrzS0QI0L7Qw5Jhu1oI/aENqOqcrAo2YkOq7OqEuH39X+HqMe
         b/9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=txwRzy7T4FJEAmlc/vFopAVCAIZ4Qfp20yRwWgSyO3s=;
        b=u/A94jH8WT0efSSVSnSHalJVeRzxmyiTPyhINTkNxYPi/cAIroWuXK/LfssnDuI2/d
         xEp/Ki4g//S44YRzhm/vcxiFAEgNxio1Wye2Yq/ykkSQ7iX/jzncunXGWmuWWIH0e8Xn
         nHaVnsSq4M1n+7TN29x+qnNMSv+no/Ht9/HZr9Rag3GWaXGPTBRFU+8sEzZOPXBnBYUa
         bBiOWcnTL0u4SyesABCt2aWIgbjc9av8vcHQvTinz+QT3kXzhPu+KH+ssEXEstM72fHs
         rF9gOqStK1Q4mvNa5KP+FczIh3yWVOlJMbz3TIytzC6svx2SQ9OrOPKxXRRF3r9NYiSI
         hYZw==
X-Gm-Message-State: AOAM533W6Ap501wl0qQduK7hQMZ/YtQDBclCxUBekD3FeeApVmF22bK1
        NuymJsWqdFElwqcFRHIcpAKGMw3G9AqNJBmVr7Ma9g==
X-Google-Smtp-Source: ABdhPJz6Ft5ggj6z3GeCxFAGa08kB+UKwIacB3HCcKP7sJlAxWYUgPkx2I7L61KOPHu+zQqMFjuWKaiaVw6/Lilzik0=
X-Received: by 2002:a05:6512:36c5:b0:437:93ad:8725 with SMTP id
 e5-20020a05651236c500b0043793ad8725mr457794lfs.645.1645637042994; Wed, 23 Feb
 2022 09:24:02 -0800 (PST)
MIME-Version: 1.0
References: <20220215164639.GC8458@willie-the-truck> <CAKfTPtAFsL+uqQiGcuh+JJZB=rPrez0=kotq76CVRcBQhcPefg@mail.gmail.com>
 <YgvjtsOZuxzbgBBl@fedora> <CAKfTPtCHrZCp1Uth4odyT721wE8zoNVY3Mh+DSyuTkqPafm0Hg@mail.gmail.com>
 <YgwHhxy/uGafQsak@fedora> <CAKfTPtAR2+bY8QpyaCCJfezsVkB62n8XZjL9c5_mPO3iyDnp4w@mail.gmail.com>
 <Yg0lULy5TmHKIHFv@fedora> <CAKfTPtB1Vt75ciX_V=8T3e5fgW-X7ybRk6VZvy4uXzjazjx9ZA@mail.gmail.com>
 <YhWlDUzFeG0d7z6C@fedora> <CAKfTPtAjnRGc9c1Ni0ru6Xz9wKLPoBY4wdPkN0uFBzR-_iurPg@mail.gmail.com>
 <YhZjPviteu4v8Fdf@fedora>
In-Reply-To: <YhZjPviteu4v8Fdf@fedora>
From:   Vincent Guittot <vincent.guittot@linaro.org>
Date:   Wed, 23 Feb 2022 18:23:51 +0100
Message-ID: <CAKfTPtD9Tb97iKkqP-R7Qhy4vSAxmCqidAEm=5qQdOfLJe5GPg@mail.gmail.com>
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

On Wed, 23 Feb 2022 at 17:39, Darren Hart <darren@os.amperecomputing.com> wrote:
>
> On Wed, Feb 23, 2022 at 09:19:17AM +0100, Vincent Guittot wrote:
>
> ...
>
> > > > AFAICT, this CLUSTER level is only supported by ACPI. In
> > > > parse_acpi_topology() you should be able to know if cluster level is
> > > > above or below the level returned by acpi_find_last_cache_level() and
> > > > set the correct topology table accordingly
> > > >
> > >
> > > Thanks Vincent,
> > >
> > > This made sense as a place to start to me. The more I dug into the ACPI PPTT
> > > code, I kept running into conflicts with the API which would require extending
> > > it in ways that seems contrary to its intent. e.g. the exposed API uses Kernel
> > > logical CPUs rather than the topology ids (needed for working with processor
> > > containers). The cpu_topology masks haven't been populated yet, and
> > > acpi_find_last_cache_level is decoupled from the CPU topology level. So what
> > > we're really testing for is if the cluster cpumask is a subset of the coregroup
> > > cpumask or not, and it made the most sense to me to keep that in smp.c after the
> > > cpumasks have been updated and stored.
> >
> > I'm not sure why you want to compare cpumask when you can directly
> > compare topology level which is exactly what we are looking for in
> > order to correctly order the scheduler topology. I was expecting
> > something like the below to be enough. acpi_find_cluster_level() needs
> > to be created and should be similar to
> > find_acpi_cpu_topology_cluster() but return level instead of id. The
> > main advantage is that everything is contained in topology.c which
> > makes sense as we are playing with topology
>
> Hi Vincent,
>
> This was my thinking as well before I dug into the acpi pptt interfaces.
>
> The cpu topology levels and the cache levels are independent and assuming I've
> not misunderstood the implementation, acpi_find_cache_level() returns the
> highest *cache* level described in the PPTT for a given CPU.
>
> For the Ampere Altra, for example:
>
> CPU Topo  1       System
>  Level    2         Package
>    |      3           Cluster
>    |      4             Processor --- L1 I Cache \____ L2 U Cache -x
>   \/                              --- L1 D Cache /
>
>           4             Processor --- L1 I Cache \____ L2 U Cache -x
>                                   --- L1 D Cache /
>
>                   Cache Level ---->    1                2
>
> acpi_find_cache_level() returns "2" for any logical cpu, but this doesn't tell
> us anything about the CPU topology level across which this cache is shared.

yeah, I have wrongly assumed that we can directly compare cache level
with cluster level because find_acpi_cpu_cache_topology() returns a
cpu node id but find_acpi_cpu_cache_topology walks the cpu topo to
find the cpu node which maps the cache level. This means that we would
have to walk the cpu topology until we find either cluster node id or
cache node id to know which one belongs to the other

>
> This is what drove me out of topology.c and up into smp.c after the various
> topologies are populated and comparing masks. I'll spend a bit more time before
> sending a cpumask implementation to see if there is a better point to do this
> where the cpu topology level with shared cache is more readily available.
>
> >
> > diff --git a/arch/arm64/kernel/topology.c b/arch/arm64/kernel/topology.c
> > index 9ab78ad826e2..4dac0491b7e3 100644
> > --- a/arch/arm64/kernel/topology.c
> > +++ b/arch/arm64/kernel/topology.c
> > @@ -84,6 +84,7 @@ static bool __init acpi_cpu_is_threaded(int cpu)
> >  int __init parse_acpi_topology(void)
> >  {
> >         int cpu, topology_id;
> > +       bool default_cluster_topology = true;
> >
> >         if (acpi_disabled)
> >                 return 0;
> > @@ -119,8 +120,16 @@ int __init parse_acpi_topology(void)
> >                         if (cache_id > 0)
> >                                 cpu_topology[cpu].llc_id = cache_id;
> >                 }
> > +
> > +               if (default_cluster_topology &&
> > +                   (i < acpi_find_cluster_level(cpu))) {
>
> Per above, from what I understand, this is comparing cpu topology levels with
> cache levels, which are independent from each other.
>
> > +                       default_cluster_topology = false;
> > +               }
> >         }
> >
> > +       if (!default_cluster_topology)
> > +               set_sched_topology(arm64_no_mc_topology);
> > +
> >         return 0;
> >  }
>
> Thanks,
>
> --
> Darren Hart
> Ampere Computing / OS and Kernel
