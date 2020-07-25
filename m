Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B133122D615
	for <lists+stable@lfdr.de>; Sat, 25 Jul 2020 10:29:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726593AbgGYI3l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 Jul 2020 04:29:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725944AbgGYI3l (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 25 Jul 2020 04:29:41 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C41AFC0619D3;
        Sat, 25 Jul 2020 01:29:39 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id l17so12139929iok.7;
        Sat, 25 Jul 2020 01:29:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nsq2mouYo2Qa6KpYYFHJMPjIbTYGOrQ5W18o/uQeM6A=;
        b=T6TISXoQxAUjexqoor6ZAZ+iN0vbhxzfDuUGAsGHp72/04zQENUUzoIgfCYobj8K+c
         7RXzxPzfST5YjA8fZC92ABxGODj0c0CapTkhwjXU+LxILSv2BIc1shq1q1Cf0cBLUMOR
         UUDOZhZlktrD6Dxva0a1vesy0geP8/spXmSy/xoDkFBBMAjOVmDUB0qcK5kwJZn7aWWL
         yltZLGvQh2FXflv7xRdSAFEMD0kbwl3W80sj2iGUiRdz50IEjQSq5QC54eo2irk1YTa4
         qmPoxAR7asQi3cC1rScKs7t+aGd+1MY+yaFU5wDsR4eGXpBE2q328hdKXmmmkzhtIWog
         I83Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nsq2mouYo2Qa6KpYYFHJMPjIbTYGOrQ5W18o/uQeM6A=;
        b=FXT3LwQU1IFLilr1Wo1ViLMBAHKn5bLprTa3AHGYc6tNv4g1d5Qb00I29RABoJmtbO
         wNsEiTEe4bNni4j9O4oHiSEHSxGJNMIl688yGpAo5270s6SYHvL+qgOG7hY5OBhOhVnL
         Z0J6e8pIHkAxZBKu459Bp233ceC1j5BaQT8ePW7xk+k9mxH80ZUdsX5y2LVUQrpBxBlY
         PeFFE5SYAdA6T6SQ/XoqOn3hqJAL/y+D4xB67VEvqrIuq9hk2+PuGadEKDW1rA4zf7++
         pJpQq6R59TL7vQueGp7XVwW4+bGDLRc4CI9A1hUvDx7BfivpB87p030IuYuojE8IeyeX
         tI9A==
X-Gm-Message-State: AOAM530OGLk/PecYSupT7JMve8QLu2sErEk8pGmsduiLz1GHHHcOQ8PL
        Dvhhbv3jaoW9iEuXboOX5gBDhlng2CxQBre+PKg=
X-Google-Smtp-Source: ABdhPJzs5K9SICKVuBRIjbiXDSPeUvru4hIhoput3CnWLWH3MeY7NfdcYI+n+DQFg1VeNjC6tYv4M+2I8pC46hmsTCw=
X-Received: by 2002:a02:5803:: with SMTP id f3mr2622531jab.126.1595665779010;
 Sat, 25 Jul 2020 01:29:39 -0700 (PDT)
MIME-Version: 1.0
References: <1594896024-16624-1-git-send-email-chenhc@lemote.com>
 <CAAhV-H4QH-cyabcfYyNJv89LpOdpsXN+dpZBYy0gNKmSnsUsKA@mail.gmail.com>
 <20200725064923.GA1059787@kroah.com> <CAAhV-H7WgGy=NKZ-YwDTQ1HtNT--qp2J8m25RmxpsdUBbmm8oQ@mail.gmail.com>
 <20200725074521.GA347597@kroah.com>
In-Reply-To: <20200725074521.GA347597@kroah.com>
From:   Huacai Chen <chenhuacai@gmail.com>
Date:   Sat, 25 Jul 2020 16:29:28 +0800
Message-ID: <CAAhV-H7C3-uro-UD6voeamcECQHo1PYNBiyGyHLPDyEAJUm98w@mail.gmail.com>
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

Hi, Greg,

On Sat, Jul 25, 2020 at 3:45 PM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Sat, Jul 25, 2020 at 02:57:31PM +0800, Huacai Chen wrote:
> > Hi Greg,
> >
> > On Sat, Jul 25, 2020 at 2:49 PM Greg KH <gregkh@linuxfoundation.org> wrote:
> > >
> > > On Sat, Jul 25, 2020 at 02:37:52PM +0800, Huacai Chen wrote:
> > > > Hi, Thomas,
> > > >
> > > > What do you think about this patch? Other archs also do the same thing
> > > > except those support hotplug CPU#0.
> > > >
> > > > grep hotpluggable arch -rwI
> > > > arch/riscv/kernel/setup.c:        cpu->hotpluggable = cpu_has_hotplug(i);
> > > > arch/powerpc/kernel/sysfs.c:    BUG_ON(!c->hotpluggable);
> > > > arch/powerpc/kernel/sysfs.c:            c->hotpluggable = 1;
> > > > arch/powerpc/kernel/sysfs.c:        if (cpu_online(cpu) || c->hotpluggable) {
> > > > arch/arm/kernel/setup.c:        cpuinfo->cpu.hotpluggable =
> > > > platform_can_hotplug_cpu(cpu);
> > > > arch/sh/kernel/topology.c:        c->hotpluggable = 1;
> > > > arch/ia64/kernel/topology.c:     * CPEI target, then it is hotpluggable
> > > > arch/ia64/kernel/topology.c:        sysfs_cpus[num].cpu.hotpluggable = 1;
> > > > arch/xtensa/kernel/setup.c:        cpu->hotpluggable = !!i;
> > > > arch/s390/kernel/smp.c:    c->hotpluggable = 1;
> > > > arch/mips/kernel/topology.c:        c->hotpluggable = 1;
> > > > arch/arm64/kernel/cpuinfo.c: * In case the boot CPU is hotpluggable,
> > > > we record its initial state and
> > > > arch/arm64/kernel/setup.c:        cpu->hotpluggable = cpu_can_disable(i);
> > > > arch/x86/kernel/topology.c:        per_cpu(cpu_devices,
> > > > num).cpu.hotpluggable = 1;
> > > >
> > > > On Thu, Jul 16, 2020 at 6:38 PM Huacai Chen <chenhc@lemote.com> wrote:
> > > > >
> > > > > Now CPU#0 is not hotpluggable on MIPS, so prevent to create /sys/devices
> > > > > /system/cpu/cpu0/online which confuses some user-space tools.
> > >
> > > What userspace tools are confused by this?  They should be able to
> > > handle a cpu not being able to be removed, right?
> > It causes ltp's "hotplug" test fails, and ltp considers CPUs with a
> > "online" node be hotpluggable.
>
> Is that always true?
Yes, someone who meet the same problem report a bug to LTP, and LTP
maintainer said that this should be fixed in kernel.

Huacai
