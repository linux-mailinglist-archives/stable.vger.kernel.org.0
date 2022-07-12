Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83BE457155E
	for <lists+stable@lfdr.de>; Tue, 12 Jul 2022 11:09:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232609AbiGLJJG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jul 2022 05:09:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232579AbiGLJJB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jul 2022 05:09:01 -0400
Received: from mail-vk1-xa2d.google.com (mail-vk1-xa2d.google.com [IPv6:2607:f8b0:4864:20::a2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B43BF1A83C;
        Tue, 12 Jul 2022 02:08:55 -0700 (PDT)
Received: by mail-vk1-xa2d.google.com with SMTP id 7so2180665vkq.0;
        Tue, 12 Jul 2022 02:08:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8LCnmqawoxVB9pxtCcgy2mIAwh3oOWcQhV+5PBd2TbI=;
        b=enqrt2lHLNU6D6nQ9VF2kaC4miDYEOanWmFv4N80cBCOxeLlgW1IG5ADsfmSM5q3lf
         0QjRDockErrhscAvix2Fh0/eUqtaRlN5yWHn+IHyMpVj1si1Abebe1hz2XxOkC0CAY1j
         ozgSgxHnaBfna3vODMxnR+FAS6neU1lDjdCAwxkuHyiTILTOqEc9QJTDRjYXEpuE2JGG
         TjPhsRBx4eWZrMvrLROpp7s4Jdj0xkImd0p5Cbog3ZuDle4ohPluXh1uMAog2lNjD/7b
         x7PiNsVOWg1reZIIFLxjuOoan0BcjjZhmQ//s9hvDElOGabvrza0p+EOivVVJJsdwUW/
         7mjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8LCnmqawoxVB9pxtCcgy2mIAwh3oOWcQhV+5PBd2TbI=;
        b=yMqnfEVxcfaYiHk6DjGwUp4udUPLkUTLvFEDwnO6mIWWuxjEc+QAsvihArnSgR68s1
         42UhMPTzn/HhfYtU9AqtoKyfxgMYG/NXBB558WpIXuLlADi3z/1QNv4j9QmFuw138+4v
         8r6IBo6OyuVnZf9oCHYoxApdpI2Stmi+efgVRovfMw3jXgfFChIo7FaYIjdQCELtNfnu
         p+Q4mSG0Xpzh9i7gi+ziuJ47WiBCVROLGUDObhQYzKYp2iWdfQRtG2CZTB+Wf6sPWhxH
         lTeKEKvRmxpHk/GUMlGEc49LuQ8S2lD+7cquR75dpNsUbxAh5DTPz7efXUIrHP/ivjkP
         9Fnw==
X-Gm-Message-State: AJIora90gFdsEsrb9bVMiPMm21ezrKOY490mfy+qcwIDHFCiLDI/ZNrb
        7CVLkW1U409DyVa+Sbu9cBVzq6sRNn7OGBs29lwgNFVMfyuRgZWGWPw=
X-Google-Smtp-Source: AGRyM1s7DoUrXJ3UCbxk29LSvgF6KCyVjntLOc/ifHlk282ATGGUjKAX0if60sD5fn1JEfua2KT0kPziS6VKLLaH3a8=
X-Received: by 2002:a1f:340f:0:b0:374:7b8a:378 with SMTP id
 b15-20020a1f340f000000b003747b8a0378mr6995690vka.37.1657616934836; Tue, 12
 Jul 2022 02:08:54 -0700 (PDT)
MIME-Version: 1.0
References: <20220712075255.1345991-1-chenhuacai@loongson.cn>
 <20220712075255.1345991-3-chenhuacai@loongson.cn> <CAMuHMdUazqHLbc80vpZ+Msg9A3j5aPJ3fx+CdCG3kuWDSf8WSw@mail.gmail.com>
 <CAAhV-H775jXMbcR9j=oLBuHo1PfFziZSUQWttJAEw20sUt+GAA@mail.gmail.com> <CAMuHMdUHbepd974u5iox3BcOyo_Q2ZgT-znruk+WCt+HMQ_Lgw@mail.gmail.com>
In-Reply-To: <CAMuHMdUHbepd974u5iox3BcOyo_Q2ZgT-znruk+WCt+HMQ_Lgw@mail.gmail.com>
From:   Huacai Chen <chenhuacai@gmail.com>
Date:   Tue, 12 Jul 2022 17:08:42 +0800
Message-ID: <CAAhV-H78Fi0aE-h5MOgRa5L+Jt7D0wG0nLcYzx45jVney8T1BQ@mail.gmail.com>
Subject: Re: [PATCH 3/6] M68K: cpuinfo: Fix a warning for CONFIG_CPUMASK_OFFSTACK
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     Huacai Chen <chenhuacai@loongson.cn>,
        Arnd Bergmann <arnd@arndb.de>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Michal Simek <monstr@monstr.eu>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Rich Felker <dalias@libc.org>, Jeff Dike <jdike@addtoit.com>,
        Richard Weinberger <richard@nod.at>,
        Anton Ivanov <anton.ivanov@cambridgegreys.com>,
        loongarch@lists.linux.dev, Linux-Arch <linux-arch@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Guo Ren <guoren@kernel.org>, Xuerui Wang <kernel@xen0n.name>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        "open list:BROADCOM NVRAM DRIVER" <linux-mips@vger.kernel.org>,
        linux-m68k <linux-m68k@lists.linux-m68k.org>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        linux-um <linux-um@lists.infradead.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi, Geert,

On Tue, Jul 12, 2022 at 5:01 PM Geert Uytterhoeven <geert@linux-m68k.org> wrote:
>
> Hi Huacai,
>
> On Tue, Jul 12, 2022 at 10:53 AM Huacai Chen <chenhuacai@gmail.com> wrote:
> > On Tue, Jul 12, 2022 at 4:33 PM Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> > > On Tue, Jul 12, 2022 at 9:53 AM Huacai Chen <chenhuacai@loongson.cn> wrote:
> > > > When CONFIG_CPUMASK_OFFSTACK and CONFIG_DEBUG_PER_CPU_MAPS is selected,
> > >
> > > DEBUG_PER_CPU_MAPS depends on SMP, which is not supported on m68k,
> > > and thus cannot be enabled.
> > This patch is derived from MIPS and LoongArch, I search all
> > architectures and change those that look the same as MIPS and
> > LoongArch.
> > And the warning message below is also a copy-paste from LoongArch, sorry.
> >
> > Since M68K doesn't support SMP, then this patch seems to make no
> > difference, but does it make sense to keep consistency across all
> > architectures?
>
> Yes, having consistency is good.  But that should be mentioned in the
> patch description, instead of a scary warning CCed to stable ;-)
>
> BTW, you probably want to update the other copy of c_start() in
> arch/m68k/kernel/setup_mm.c, too.
For no-SMP architectures, it seems c_start() in
arch/m68k/kernel/setup_mm.c is more reasonable (just use 1, neither
NR_CPUS, nor nr_cpu_ids)?

Huacai
>
> Thanks!
>
> Gr{oetje,eeting}s,
>
>                         Geert
>
> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org
>
> In personal conversations with technical people, I call myself a hacker. But
> when I'm talking to journalists I just say "programmer" or something like that.
>                                 -- Linus Torvalds
