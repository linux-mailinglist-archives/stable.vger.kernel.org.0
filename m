Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C02D6574141
	for <lists+stable@lfdr.de>; Thu, 14 Jul 2022 04:07:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232165AbiGNCH0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Jul 2022 22:07:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230201AbiGNCHZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Jul 2022 22:07:25 -0400
Received: from mail-ua1-x92b.google.com (mail-ua1-x92b.google.com [IPv6:2607:f8b0:4864:20::92b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5ACD12314C;
        Wed, 13 Jul 2022 19:07:24 -0700 (PDT)
Received: by mail-ua1-x92b.google.com with SMTP id r25so152474uap.7;
        Wed, 13 Jul 2022 19:07:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NpLH38IQjk7redhO9PrQcXlLl1raddOqHif56KP33pc=;
        b=gJ/Poz6fnHmy6tw3/ekjOTdZC6WAanr/z9pOUQdssMiy7McyExvpdd2WUfWAj5C8de
         TncoEwlo8JJLiUN9u6ikmdNggPa0I8xHqcrzSFyA8+4axrtQt1keJ3CngNjRaLncRycp
         qQwcp767wZ15QiyGPZzbaIaVB7YDgBsPq6aKOkidU3/YYJI9s6YTbbDDpyvbGvociREx
         d54hnyqMsAqBySNzMiQPlt7aNjoilHYVamiweBh9OT8UgjMxk8qBjyBkfRVI/cBrDttl
         e0diMOgIGJYy6CfzH7aYgBRsDb70meGOSPVAWYLpYBJ5O+5isELaxkVSWBkr3TqqsNUZ
         J84g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NpLH38IQjk7redhO9PrQcXlLl1raddOqHif56KP33pc=;
        b=jCF6pb9FI9vjZJAtgwyzs5AOiQOz6a/I/wZWuv0AJKR3VsIYY0S+v3TCBwiZsTUSuv
         f1Fz3EhLzOVq/NpoylO/A2hSRIKfnzULMDgIR7bg46cRoVGQZuz2iZTT4Z0ai4h2mRJe
         OvUcW77drccSqX9FJGpl+JyqW7peFvzmv3VpZcI/gEwtphmxd5/Go9hSa5bJoEUuUieq
         gj+3uByVAisBkNTlP0b0O6nDwmSiancaLgkK+T+QjU4rhZLZ5xjNGupXc6D8PSdHgsga
         9qpH/tsfluFOQv+/rUi5+/HNwYIzlmMs4RnOlpvyxw+k2JKOApQFopnU2L+zdaGmIpuL
         FwRQ==
X-Gm-Message-State: AJIora9t/UrodRBa0g4JVBuNKvgw4xT5tW0ch4RoHgM0s6X6lKVQuf3V
        K1gHAG3YYhARqQ+X/arqzP1ILHIKjVVp5zCZCDiy77J1gzhANwDD
X-Google-Smtp-Source: AGRyM1vFQyB5NO+1tpFvYvLDE44n1imGoxyRKDVxoA97HOyDWY4NrzjwmwdLmSMIFxgFLR+iBY3k18fU4R1SCofoqMw=
X-Received: by 2002:ab0:6798:0:b0:382:d9f4:8d0 with SMTP id
 v24-20020ab06798000000b00382d9f408d0mr2611303uar.63.1657764443460; Wed, 13
 Jul 2022 19:07:23 -0700 (PDT)
MIME-Version: 1.0
References: <20220712075255.1345991-1-chenhuacai@loongson.cn>
 <20220712075255.1345991-3-chenhuacai@loongson.cn> <CAMuHMdUazqHLbc80vpZ+Msg9A3j5aPJ3fx+CdCG3kuWDSf8WSw@mail.gmail.com>
 <CAAhV-H775jXMbcR9j=oLBuHo1PfFziZSUQWttJAEw20sUt+GAA@mail.gmail.com>
 <CAMuHMdUHbepd974u5iox3BcOyo_Q2ZgT-znruk+WCt+HMQ_Lgw@mail.gmail.com>
 <CAAhV-H78Fi0aE-h5MOgRa5L+Jt7D0wG0nLcYzx45jVney8T1BQ@mail.gmail.com>
 <CAMuHMdVXFmKR4LuXHYRrSk3Q0VRqATGbsM512DxayWCPCE-wvg@mail.gmail.com> <c8c959fa-f17d-f0dd-6a8d-e0b0ce622f3a@xen0n.name>
In-Reply-To: <c8c959fa-f17d-f0dd-6a8d-e0b0ce622f3a@xen0n.name>
From:   Huacai Chen <chenhuacai@gmail.com>
Date:   Thu, 14 Jul 2022 10:07:10 +0800
Message-ID: <CAAhV-H6g5nLGJMz0ZsZqC5-73VSGffVdc6r0=3HHBo3Z8PQOBg@mail.gmail.com>
Subject: Re: [PATCH 3/6] M68K: cpuinfo: Fix a warning for CONFIG_CPUMASK_OFFSTACK
To:     WANG Xuerui <kernel@xen0n.name>
Cc:     Geert Uytterhoeven <geert@linux-m68k.org>,
        Huacai Chen <chenhuacai@loongson.cn>,
        Arnd Bergmann <arnd@arndb.de>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Michal Simek <monstr@monstr.eu>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Rich Felker <dalias@libc.org>, Jeff Dike <jdike@addtoit.com>,
        Richard Weinberger <richard@nod.at>,
        Anton Ivanov <anton.ivanov@cambridgegreys.com>,
        loongarch@lists.linux.dev, Linux-Arch <linux-arch@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Guo Ren <guoren@kernel.org>,
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
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi, all,

On Tue, Jul 12, 2022 at 6:15 PM WANG Xuerui <kernel@xen0n.name> wrote:
>
> Hi Geert and Huacai,
>
> On 2022/7/12 17:13, Geert Uytterhoeven wrote:
> > Hi Huacai,
> >
> > On Tue, Jul 12, 2022 at 11:08 AM Huacai Chen <chenhuacai@gmail.com> wrote:
> >> On Tue, Jul 12, 2022 at 5:01 PM Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> >>> On Tue, Jul 12, 2022 at 10:53 AM Huacai Chen <chenhuacai@gmail.com> wrote:
> >>>> On Tue, Jul 12, 2022 at 4:33 PM Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> >>>>> On Tue, Jul 12, 2022 at 9:53 AM Huacai Chen <chenhuacai@loongson.cn> wrote:
> >>>>>> When CONFIG_CPUMASK_OFFSTACK and CONFIG_DEBUG_PER_CPU_MAPS is selected,
> >>>>> DEBUG_PER_CPU_MAPS depends on SMP, which is not supported on m68k,
> >>>>> and thus cannot be enabled.
> >>>> This patch is derived from MIPS and LoongArch, I search all
> >>>> architectures and change those that look the same as MIPS and
> >>>> LoongArch.
> >>>> And the warning message below is also a copy-paste from LoongArch, sorry.
> >>>>
> >>>> Since M68K doesn't support SMP, then this patch seems to make no
> >>>> difference, but does it make sense to keep consistency across all
> >>>> architectures?
> >>> Yes, having consistency is good.  But that should be mentioned in the
> >>> patch description, instead of a scary warning CCed to stable ;-)
> >>>
> >>> BTW, you probably want to update the other copy of c_start() in
> >>> arch/m68k/kernel/setup_mm.c, too.
> >> For no-SMP architectures, it seems c_start() in
> >> arch/m68k/kernel/setup_mm.c is more reasonable (just use 1, neither
> >> NR_CPUS, nor nr_cpu_ids)?
> > The advantage of using nr_cpu_ids() is that this is one place less
> > to update when adding SMP support later...
>
> Hmm, so I've been watching m68k development lately (although not as
> closely as I'd like to, due to lack of vintage hardware at hand), given
> the current amazing  momentum all the hobbyists/developers have been
> contributing to, SMP is well within reach...
>
> But judging from the intent of this patch series (fixing WARNs on
> certain configs), and that the triggering condition is currently
> impossible on m68k (and other non-SMP) platforms, I think cleanups for
> such arches could come as a separate patch series later. I think the
> m68k refactoring is reasonable after all, due to my observation above,
> but for the other non-SMP arches we may want to wait for the respective
> maintainers' opinions.
It seems that the best solution is only fix architectures with SMP
support and leave others (m68k, microblaze, um) as is. :)

Huacai
>
