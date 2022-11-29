Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98D8F63C1E4
	for <lists+stable@lfdr.de>; Tue, 29 Nov 2022 15:08:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234975AbiK2OIj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Nov 2022 09:08:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234493AbiK2OIa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Nov 2022 09:08:30 -0500
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4DBA59FF9;
        Tue, 29 Nov 2022 06:08:29 -0800 (PST)
Received: by mail-ej1-x636.google.com with SMTP id bj12so33990305ejb.13;
        Tue, 29 Nov 2022 06:08:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=1kqCc7yU1YkarXWZbMyGs9nckGPiC+C/WANzHraoYew=;
        b=L66GG3cxZiSHXPmfY77KORxMTN1uCF6q3lbtM9pAaMe+veBDm7pHAq8kd3mnoierSQ
         RgzFwPPoHnbd8LmV7OO7DtUDXBcL4tiyEv2u6O2wJuGmpqZhu8+aYdXRw3Xl0G2ZznhC
         /ymb2knTVCb+Dtu772Hn/LHymQgc31ywaCPXRcxPEUpCmeXBfBKIbov9VWn3j5Jkw2EQ
         KpOMff6u0/wyDak6fp30xxL4DdQ/5t439H/5Kxy9wriGC/yhmAKalgWVEncwGRAU0GQI
         1xFEtZU1ZslzqWLTlNMRM7rbMMP7HE6VyLppjBXdrMe3ODLXQl7J1XwtvG6OvUwAheDA
         WHQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1kqCc7yU1YkarXWZbMyGs9nckGPiC+C/WANzHraoYew=;
        b=uCVt6YUWkGD7xEeYOhq3F26Lf+ExJq8AsX2wH4W21ahKiwCzAwOWbl8FnnORECdSSS
         8AZ2xpeomoPOihzlWe9Pa3dIyO33pIGlkIrYwh/8JDx6IcFFS+xfVqxCnnRXvwpp5q1s
         BIg/FBcRW1T0Y0jfIHwVvFcTynZ50uev8ZRNMJHsEAFI/l3VeGZvlbqzU5qi0v6j5Jxx
         3dHZsMuvF3b4uHxuAjcSjOhUvUAJlqWeiOw7hMUgWzLScLrm1FvPy1024g7jp21/77V9
         03Ev50adG6dzLmaaEmpgtIFP6VAJ1FOG/hlqFidXX4Tagh4OXDxaOIEmCRFM/10TUqMY
         NeHQ==
X-Gm-Message-State: ANoB5pnqlReyXr8W6XyPyXa+rnUNbtvaP9fX8P1FJZMev8+cwJ4fmtCA
        AOMHXsNRi1en9IyWZxtjuIxGhHL4sAyRCDG/NOvmxQkKc7U=
X-Google-Smtp-Source: AA0mqf5socxeRVchDmD7ZKtmihUqV4WcGcBPOuTgcMmdtKmCPPnyt2pjxU4UV7a3cLG5SsszYuYfPi4zUfnj6j/dY28=
X-Received: by 2002:a17:906:298c:b0:7c0:7d08:bfc with SMTP id
 x12-20020a170906298c00b007c07d080bfcmr6512317eje.72.1669730908013; Tue, 29
 Nov 2022 06:08:28 -0800 (PST)
MIME-Version: 1.0
References: <20220714084136.570176-1-chenhuacai@loongson.cn>
 <20220714084136.570176-3-chenhuacai@loongson.cn> <CAAhV-H7uF85UHfbS+-sMcXbB=q3UO0Z8rO=poNQbEtaipi4PHQ@mail.gmail.com>
 <CAJF2gTT82uNmjfDcMrSodssZWsMSrN_476s03QCv__kmQH-6GQ@mail.gmail.com>
In-Reply-To: <CAJF2gTT82uNmjfDcMrSodssZWsMSrN_476s03QCv__kmQH-6GQ@mail.gmail.com>
From:   Huacai Chen <chenhuacai@gmail.com>
Date:   Tue, 29 Nov 2022 22:08:16 +0800
Message-ID: <CAAhV-H6siOtVkZpkS4aABejgZCqTwp3TihA0+0HGZ1+mU3XAVA@mail.gmail.com>
Subject: Re: [PATCH V2 3/3] SH: cpuinfo: Fix a warning for CONFIG_CPUMASK_OFFSTACK
To:     Guo Ren <guoren@kernel.org>,
        John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc:     Huacai Chen <chenhuacai@loongson.cn>,
        Arnd Bergmann <arnd@arndb.de>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Rich Felker <dalias@libc.org>, loongarch@lists.linux.dev,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        Xuerui Wang <kernel@xen0n.name>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        linux-mips@vger.kernel.org, linux-sh@vger.kernel.org,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 28, 2022 at 4:18 PM Guo Ren <guoren@kernel.org> wrote:
>
> On Mon, Nov 28, 2022 at 2:25 PM Huacai Chen <chenhuacai@gmail.com> wrote:
> >
> > ping?
> Who can test?
John said he can test. :)

Huacai
>
> >
> > On Thu, Jul 14, 2022 at 4:42 PM Huacai Chen <chenhuacai@loongson.cn> wrote:
> > >
> > > When CONFIG_CPUMASK_OFFSTACK and CONFIG_DEBUG_PER_CPU_MAPS is selected,
> > > cpu_max_bits_warn() generates a runtime warning similar as below while
> > > we show /proc/cpuinfo. Fix this by using nr_cpu_ids (the runtime limit)
> > > instead of NR_CPUS to iterate CPUs.
> > >
> > > [    3.052463] ------------[ cut here ]------------
> > > [    3.059679] WARNING: CPU: 3 PID: 1 at include/linux/cpumask.h:108 show_cpuinfo+0x5e8/0x5f0
> > > [    3.070072] Modules linked in: efivarfs autofs4
> > > [    3.076257] CPU: 0 PID: 1 Comm: systemd Not tainted 5.19-rc5+ #1052
> > > [    3.099465] Stack : 9000000100157b08 9000000000f18530 9000000000cf846c 9000000100154000
> > > [    3.109127]         9000000100157a50 0000000000000000 9000000100157a58 9000000000ef7430
> > > [    3.118774]         90000001001578e8 0000000000000040 0000000000000020 ffffffffffffffff
> > > [    3.128412]         0000000000aaaaaa 1ab25f00eec96a37 900000010021de80 900000000101c890
> > > [    3.138056]         0000000000000000 0000000000000000 0000000000000000 0000000000aaaaaa
> > > [    3.147711]         ffff8000339dc220 0000000000000001 0000000006ab4000 0000000000000000
> > > [    3.157364]         900000000101c998 0000000000000004 9000000000ef7430 0000000000000000
> > > [    3.167012]         0000000000000009 000000000000006c 0000000000000000 0000000000000000
> > > [    3.176641]         9000000000d3de08 9000000001639390 90000000002086d8 00007ffff0080286
> > > [    3.186260]         00000000000000b0 0000000000000004 0000000000000000 0000000000071c1c
> > > [    3.195868]         ...
> > > [    3.199917] Call Trace:
> > > [    3.203941] [<90000000002086d8>] show_stack+0x38/0x14c
> > > [    3.210666] [<9000000000cf846c>] dump_stack_lvl+0x60/0x88
> > > [    3.217625] [<900000000023d268>] __warn+0xd0/0x100
> > > [    3.223958] [<9000000000cf3c90>] warn_slowpath_fmt+0x7c/0xcc
> > > [    3.231150] [<9000000000210220>] show_cpuinfo+0x5e8/0x5f0
> > > [    3.238080] [<90000000004f578c>] seq_read_iter+0x354/0x4b4
> > > [    3.245098] [<90000000004c2e90>] new_sync_read+0x17c/0x1c4
> > > [    3.252114] [<90000000004c5174>] vfs_read+0x138/0x1d0
> > > [    3.258694] [<90000000004c55f8>] ksys_read+0x70/0x100
> > > [    3.265265] [<9000000000cfde9c>] do_syscall+0x7c/0x94
> > > [    3.271820] [<9000000000202fe4>] handle_syscall+0xc4/0x160
> > > [    3.281824] ---[ end trace 8b484262b4b8c24c ]---
> > >
> > > Cc: stable@vger.kernel.org
> > > Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
> > > ---
> > >  arch/sh/kernel/cpu/proc.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > >
> > > diff --git a/arch/sh/kernel/cpu/proc.c b/arch/sh/kernel/cpu/proc.c
> > > index a306bcd6b341..5f6d0e827bae 100644
> > > --- a/arch/sh/kernel/cpu/proc.c
> > > +++ b/arch/sh/kernel/cpu/proc.c
> > > @@ -132,7 +132,7 @@ static int show_cpuinfo(struct seq_file *m, void *v)
> > >
> > >  static void *c_start(struct seq_file *m, loff_t *pos)
> > >  {
> > > -       return *pos < NR_CPUS ? cpu_data + *pos : NULL;
> > > +       return *pos < nr_cpu_ids ? cpu_data + *pos : NULL;
> > >  }
> > >  static void *c_next(struct seq_file *m, void *v, loff_t *pos)
> > >  {
> > > --
> > > 2.31.1
> > >
>
>
>
> --
> Best Regards
>  Guo Ren
