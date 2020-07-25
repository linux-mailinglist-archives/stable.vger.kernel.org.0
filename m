Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A60822D59C
	for <lists+stable@lfdr.de>; Sat, 25 Jul 2020 08:57:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725941AbgGYG5n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 Jul 2020 02:57:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725874AbgGYG5n (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 25 Jul 2020 02:57:43 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47884C0619D3;
        Fri, 24 Jul 2020 23:57:43 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id l17so12024512iok.7;
        Fri, 24 Jul 2020 23:57:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3V9vpkLWNlErLykQqMYqwQw+ge/Dm2MZ96607z9IAIg=;
        b=bApFupClLIS6Vhb0QZwSZErPrNlgc8f8UnTfh0YQG1V86uYDnOMqLpdxexKielz4F2
         OR6BtLMGZuVwfqIk7XKaP3xNROh+aRs3WQ/5nqPooSzvU0Tn0oduhoZI37A2bSL8sPYH
         y4JbwtOmZxq5aye0CHkgaU+pP0DUWE9dV6plgVj6CyRjE10+WyaEKg0gukVINbr+h5kj
         2kpF+Ed0yAGPmXo1su8bN5oMp7cmOV1/F8RoJrbP1Zul2yoGaoq5Pqztzmo8dr9xm+cb
         NTKXXaU7FpMmzAzQnwWQe7mEMLncK1lH97P+EManqBCd19MdjGUYsjCxhjcsEM/du1fU
         +7+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3V9vpkLWNlErLykQqMYqwQw+ge/Dm2MZ96607z9IAIg=;
        b=apHjcWAK5TfkBE5W5kN7aP/kNeCsnrxFuJjzxDcw9EyYMCV38W2yvSJyCoFT6ktz88
         /CAUa+eq25kGSAEPls0Rz/bdbwdGt8T7FPhaAxc30eHUgI5Y2sGEnWjlXqhiA+TqLzjg
         zy1bSN6zNwGZY/HBpvWbGHbGZFqGwrKd2OZqi5Ju8agnRwW+hUjZGdvDhbr03TLvUx+m
         0SqEQWcPecDEgsZFwIl+Q+aBeKlZgn3rf+rGzQnsU9aSckRiNweLbj0kERaLHSfPZc7O
         ORhCxN+kXnIO2G9iMNjfj2IV7n68KVqMcZAYJ5t044JF1Dz+GE06YRNjQSjHZOVc6weW
         4H/g==
X-Gm-Message-State: AOAM531VmypaYqAnHyAoU/KkiM7xA1l3DzZZQ/vDn40R6+mLLw0Jvg+g
        ua2DVpCuXFl8jYLzhot8a0o3W33mDYCmLvUawrw=
X-Google-Smtp-Source: ABdhPJzrxJ7otZTQHcqd/zF/EsvReTkdt3Uk1Rpd3em6uw17KyIZgcFq5/yVJQGe84j6JE8dkJrfAK3WG4tuF8xEBNY=
X-Received: by 2002:a6b:ea0d:: with SMTP id m13mr4742623ioc.196.1595660262513;
 Fri, 24 Jul 2020 23:57:42 -0700 (PDT)
MIME-Version: 1.0
References: <1594896024-16624-1-git-send-email-chenhc@lemote.com>
 <CAAhV-H4QH-cyabcfYyNJv89LpOdpsXN+dpZBYy0gNKmSnsUsKA@mail.gmail.com> <20200725064923.GA1059787@kroah.com>
In-Reply-To: <20200725064923.GA1059787@kroah.com>
From:   Huacai Chen <chenhuacai@gmail.com>
Date:   Sat, 25 Jul 2020 14:57:31 +0800
Message-ID: <CAAhV-H7WgGy=NKZ-YwDTQ1HtNT--qp2J8m25RmxpsdUBbmm8oQ@mail.gmail.com>
Subject: Re: [PATCH V2] MIPS: CPU#0 is not hotpluggable
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        "open list:MIPS" <linux-mips@vger.kernel.org>,
        Fuxin Zhang <zhangfx@lemote.com>,
        Zhangjin Wu <wuzhangjin@gmail.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Sat, Jul 25, 2020 at 2:49 PM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Sat, Jul 25, 2020 at 02:37:52PM +0800, Huacai Chen wrote:
> > Hi, Thomas,
> >
> > What do you think about this patch? Other archs also do the same thing
> > except those support hotplug CPU#0.
> >
> > grep hotpluggable arch -rwI
> > arch/riscv/kernel/setup.c:        cpu->hotpluggable = cpu_has_hotplug(i);
> > arch/powerpc/kernel/sysfs.c:    BUG_ON(!c->hotpluggable);
> > arch/powerpc/kernel/sysfs.c:            c->hotpluggable = 1;
> > arch/powerpc/kernel/sysfs.c:        if (cpu_online(cpu) || c->hotpluggable) {
> > arch/arm/kernel/setup.c:        cpuinfo->cpu.hotpluggable =
> > platform_can_hotplug_cpu(cpu);
> > arch/sh/kernel/topology.c:        c->hotpluggable = 1;
> > arch/ia64/kernel/topology.c:     * CPEI target, then it is hotpluggable
> > arch/ia64/kernel/topology.c:        sysfs_cpus[num].cpu.hotpluggable = 1;
> > arch/xtensa/kernel/setup.c:        cpu->hotpluggable = !!i;
> > arch/s390/kernel/smp.c:    c->hotpluggable = 1;
> > arch/mips/kernel/topology.c:        c->hotpluggable = 1;
> > arch/arm64/kernel/cpuinfo.c: * In case the boot CPU is hotpluggable,
> > we record its initial state and
> > arch/arm64/kernel/setup.c:        cpu->hotpluggable = cpu_can_disable(i);
> > arch/x86/kernel/topology.c:        per_cpu(cpu_devices,
> > num).cpu.hotpluggable = 1;
> >
> > On Thu, Jul 16, 2020 at 6:38 PM Huacai Chen <chenhc@lemote.com> wrote:
> > >
> > > Now CPU#0 is not hotpluggable on MIPS, so prevent to create /sys/devices
> > > /system/cpu/cpu0/online which confuses some user-space tools.
>
> What userspace tools are confused by this?  They should be able to
> handle a cpu not being able to be removed, right?
It causes ltp's "hotplug" test fails, and ltp considers CPUs with a
"online" node be hotpluggable.

>
>
> > >
> > > Cc: stable@vger.kernel.org
> > > Signed-off-by: Huacai Chen <chenhc@lemote.com>
> > > ---
> > >  arch/mips/kernel/topology.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > >
> > > diff --git a/arch/mips/kernel/topology.c b/arch/mips/kernel/topology.c
> > > index cd3e1f8..08ad637 100644
> > > --- a/arch/mips/kernel/topology.c
> > > +++ b/arch/mips/kernel/topology.c
> > > @@ -20,7 +20,7 @@ static int __init topology_init(void)
> > >         for_each_present_cpu(i) {
> > >                 struct cpu *c = &per_cpu(cpu_devices, i);
> > >
> > > -               c->hotpluggable = 1;
> > > +               c->hotpluggable = !!i;
>
> Seems to be the same as what xtensa did, so it's probably not a big
> deal.
>
> thanks,
>
> greg k-h
