Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E4B322D58C
	for <lists+stable@lfdr.de>; Sat, 25 Jul 2020 08:38:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726273AbgGYGiS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 Jul 2020 02:38:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725941AbgGYGiR (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 25 Jul 2020 02:38:17 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AD99C0619D3;
        Fri, 24 Jul 2020 23:38:16 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id l1so11982507ioh.5;
        Fri, 24 Jul 2020 23:38:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=b67K2e0Y5dToW3EVzzyFy6c/ZgBGS96NL2NdfK6mZtw=;
        b=tJ5xsDoW4PUzFtNZqDhB0WPHq5/F4E2INMVfk9DvHhEv6TP39pIvVwiQ/iehqWQDfn
         Ts+NvkXuZKk6HjJstXe+UucLuY6kTgBmvf9++HaW69gDDs8jkEh1sF5vUfnaC0Eeajk2
         xf+MWhAZegVuIQhcN3AklESUcL+ag8SjBHkM3FoTmWHX7mpgkAj7nVfcJkXjlFMNuNCx
         +LvQpzpR+Hov6G3dioIWJKqrRGLMR9boPQMD6YVmnIoJfbJ/5dDBSnTb+E0xhl8btnaR
         hHehO3fk+O6bDvBrvPsy1qzLhgzTmoU6e10gtZbisQwabHiV0u5YfK8OuF8gqtZRe4K6
         4qTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=b67K2e0Y5dToW3EVzzyFy6c/ZgBGS96NL2NdfK6mZtw=;
        b=NXGcUy6B2u3/2ZuY3qeV1C9wRd8jlcQT1FGRh7QKD4lUD2A4ly2xnl8vFqZwvlFNMk
         Tow+SFMw+at4qiCi4C0Pw8awJfFwZ0sJIVqrCkpj3twkbJfGcb2Ng97fuIIlB7Lz0BYT
         EPnOngh0zfXchbbwjlC52cYDPeW/SwFHP0fsxgiwxKJaUSjVUf20cEF8C8XhvqiPVF0A
         Llug3y7C+LX897UESJpduqPEIoxzLulV2/7E+bI/PYNS2IhKvze0gF7QhdzIBc55J3VQ
         QyL/h17Eht/iDVi3PeLpP5J/bQB0QIp7FrjnvdCCzBkIJygkjuvmVfKRJWo4q7BrFBcV
         GhWg==
X-Gm-Message-State: AOAM531IKF2oT1intosNSlnQ6SxWl9JvXJhcWZ2u5wsCggVrFa2U8lVI
        PUZIiTJRZ8Zaar5Pgkx1CFainQtNC6ndDgjgv5PC9F7uvzTmtQ==
X-Google-Smtp-Source: ABdhPJwn08RlGtecKEm1Lv7crJTWeP4hLGBovlA63tFvTHNSLtGgoGEjvCM36mQDChbzFbWdJ5AMtbvZmwowmzDrLzc=
X-Received: by 2002:a05:6638:2411:: with SMTP id z17mr14466514jat.50.1595659095871;
 Fri, 24 Jul 2020 23:38:15 -0700 (PDT)
MIME-Version: 1.0
References: <1594896024-16624-1-git-send-email-chenhc@lemote.com>
In-Reply-To: <1594896024-16624-1-git-send-email-chenhc@lemote.com>
From:   Huacai Chen <chenhuacai@gmail.com>
Date:   Sat, 25 Jul 2020 14:37:52 +0800
Message-ID: <CAAhV-H4QH-cyabcfYyNJv89LpOdpsXN+dpZBYy0gNKmSnsUsKA@mail.gmail.com>
Subject: Re: [PATCH V2] MIPS: CPU#0 is not hotpluggable
To:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc:     "open list:MIPS" <linux-mips@vger.kernel.org>,
        Fuxin Zhang <zhangfx@lemote.com>,
        Zhangjin Wu <wuzhangjin@gmail.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi, Thomas,

What do you think about this patch? Other archs also do the same thing
except those support hotplug CPU#0.

grep hotpluggable arch -rwI
arch/riscv/kernel/setup.c:        cpu->hotpluggable = cpu_has_hotplug(i);
arch/powerpc/kernel/sysfs.c:    BUG_ON(!c->hotpluggable);
arch/powerpc/kernel/sysfs.c:            c->hotpluggable = 1;
arch/powerpc/kernel/sysfs.c:        if (cpu_online(cpu) || c->hotpluggable) {
arch/arm/kernel/setup.c:        cpuinfo->cpu.hotpluggable =
platform_can_hotplug_cpu(cpu);
arch/sh/kernel/topology.c:        c->hotpluggable = 1;
arch/ia64/kernel/topology.c:     * CPEI target, then it is hotpluggable
arch/ia64/kernel/topology.c:        sysfs_cpus[num].cpu.hotpluggable = 1;
arch/xtensa/kernel/setup.c:        cpu->hotpluggable = !!i;
arch/s390/kernel/smp.c:    c->hotpluggable = 1;
arch/mips/kernel/topology.c:        c->hotpluggable = 1;
arch/arm64/kernel/cpuinfo.c: * In case the boot CPU is hotpluggable,
we record its initial state and
arch/arm64/kernel/setup.c:        cpu->hotpluggable = cpu_can_disable(i);
arch/x86/kernel/topology.c:        per_cpu(cpu_devices,
num).cpu.hotpluggable = 1;

On Thu, Jul 16, 2020 at 6:38 PM Huacai Chen <chenhc@lemote.com> wrote:
>
> Now CPU#0 is not hotpluggable on MIPS, so prevent to create /sys/devices
> /system/cpu/cpu0/online which confuses some user-space tools.
>
> Cc: stable@vger.kernel.org
> Signed-off-by: Huacai Chen <chenhc@lemote.com>
> ---
>  arch/mips/kernel/topology.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/mips/kernel/topology.c b/arch/mips/kernel/topology.c
> index cd3e1f8..08ad637 100644
> --- a/arch/mips/kernel/topology.c
> +++ b/arch/mips/kernel/topology.c
> @@ -20,7 +20,7 @@ static int __init topology_init(void)
>         for_each_present_cpu(i) {
>                 struct cpu *c = &per_cpu(cpu_devices, i);
>
> -               c->hotpluggable = 1;
> +               c->hotpluggable = !!i;
>                 ret = register_cpu(c, i);
>                 if (ret)
>                         printk(KERN_WARNING "topology_init: register_cpu %d "
> --
> 2.7.0
>
