Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52D13571595
	for <lists+stable@lfdr.de>; Tue, 12 Jul 2022 11:20:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232667AbiGLJUG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jul 2022 05:20:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232048AbiGLJUF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jul 2022 05:20:05 -0400
Received: from mail-oa1-f41.google.com (mail-oa1-f41.google.com [209.85.160.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1512BE2F;
        Tue, 12 Jul 2022 02:20:03 -0700 (PDT)
Received: by mail-oa1-f41.google.com with SMTP id 586e51a60fabf-10bf634bc50so9660505fac.3;
        Tue, 12 Jul 2022 02:20:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qbAwHtAb/u/Ek/RuPM5JbYjzEl/C/Q4rkrYxQHQ2tOE=;
        b=jzL8pEXmIaNigELpv13jFQoRdnl5jvC+7liaZoKXorq01whFlA73w5TkuJqBDrXAOd
         YtffKTe8me0qwTOVTYbwvm80jRuh/iWnEF9Ylpgs/mAIpCIKs/xgA9ieCcH6mqxKRAsZ
         FbMTxKprK59hdaYkNppVcnz/Lr3azde0VaprEO7/np7A4MYo72lZWfOm4OTrPgOMUsg0
         Zj0UscHxR6Uror+XPx3sfRb2tY8ioILSn6CVbGsjMNNseBVUUmAc4BRokamElU4/0AaZ
         tlJYrBnBI6cRIs+nS4ovGCDWvi2ftQmOXVTIJgBcLhj/dUjwwyyOpwNbAstHMz6/ZnXR
         GZHw==
X-Gm-Message-State: AJIora/fNlLmmh1txePH8WHHw8zMS91S7CarB1CJ/bBnhJJW3o2v6uFy
        Qes9GKn61pUcfPn9D2PctwLfKppwoGYZgw==
X-Google-Smtp-Source: AGRyM1uS5x/fAIYWz4HGbPagTi1+iCdO4MKFJkXB68BJswORCJqSsPVPLYSfVEoVZKNaCehI7+2a1g==
X-Received: by 2002:a05:6871:612:b0:10c:a467:a78c with SMTP id w18-20020a056871061200b0010ca467a78cmr1212688oan.36.1657617603055;
        Tue, 12 Jul 2022 02:20:03 -0700 (PDT)
Received: from mail-ot1-f53.google.com (mail-ot1-f53.google.com. [209.85.210.53])
        by smtp.gmail.com with ESMTPSA id n22-20020a05680803b600b0033a09f381c6sm1368510oie.47.2022.07.12.02.20.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Jul 2022 02:20:02 -0700 (PDT)
Received: by mail-ot1-f53.google.com with SMTP id n12-20020a9d64cc000000b00616ebd87fc4so5712936otl.7;
        Tue, 12 Jul 2022 02:20:02 -0700 (PDT)
X-Received: by 2002:a25:2b48:0:b0:668:3b7d:326c with SMTP id
 r69-20020a252b48000000b006683b7d326cmr20912003ybr.380.1657617216068; Tue, 12
 Jul 2022 02:13:36 -0700 (PDT)
MIME-Version: 1.0
References: <20220712075255.1345991-1-chenhuacai@loongson.cn>
 <20220712075255.1345991-3-chenhuacai@loongson.cn> <CAMuHMdUazqHLbc80vpZ+Msg9A3j5aPJ3fx+CdCG3kuWDSf8WSw@mail.gmail.com>
 <CAAhV-H775jXMbcR9j=oLBuHo1PfFziZSUQWttJAEw20sUt+GAA@mail.gmail.com>
 <CAMuHMdUHbepd974u5iox3BcOyo_Q2ZgT-znruk+WCt+HMQ_Lgw@mail.gmail.com> <CAAhV-H78Fi0aE-h5MOgRa5L+Jt7D0wG0nLcYzx45jVney8T1BQ@mail.gmail.com>
In-Reply-To: <CAAhV-H78Fi0aE-h5MOgRa5L+Jt7D0wG0nLcYzx45jVney8T1BQ@mail.gmail.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Tue, 12 Jul 2022 11:13:24 +0200
X-Gmail-Original-Message-ID: <CAMuHMdVXFmKR4LuXHYRrSk3Q0VRqATGbsM512DxayWCPCE-wvg@mail.gmail.com>
Message-ID: <CAMuHMdVXFmKR4LuXHYRrSk3Q0VRqATGbsM512DxayWCPCE-wvg@mail.gmail.com>
Subject: Re: [PATCH 3/6] M68K: cpuinfo: Fix a warning for CONFIG_CPUMASK_OFFSTACK
To:     Huacai Chen <chenhuacai@gmail.com>
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
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Huacai,

On Tue, Jul 12, 2022 at 11:08 AM Huacai Chen <chenhuacai@gmail.com> wrote:
> On Tue, Jul 12, 2022 at 5:01 PM Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> > On Tue, Jul 12, 2022 at 10:53 AM Huacai Chen <chenhuacai@gmail.com> wrote:
> > > On Tue, Jul 12, 2022 at 4:33 PM Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> > > > On Tue, Jul 12, 2022 at 9:53 AM Huacai Chen <chenhuacai@loongson.cn> wrote:
> > > > > When CONFIG_CPUMASK_OFFSTACK and CONFIG_DEBUG_PER_CPU_MAPS is selected,
> > > >
> > > > DEBUG_PER_CPU_MAPS depends on SMP, which is not supported on m68k,
> > > > and thus cannot be enabled.
> > > This patch is derived from MIPS and LoongArch, I search all
> > > architectures and change those that look the same as MIPS and
> > > LoongArch.
> > > And the warning message below is also a copy-paste from LoongArch, sorry.
> > >
> > > Since M68K doesn't support SMP, then this patch seems to make no
> > > difference, but does it make sense to keep consistency across all
> > > architectures?
> >
> > Yes, having consistency is good.  But that should be mentioned in the
> > patch description, instead of a scary warning CCed to stable ;-)
> >
> > BTW, you probably want to update the other copy of c_start() in
> > arch/m68k/kernel/setup_mm.c, too.
> For no-SMP architectures, it seems c_start() in
> arch/m68k/kernel/setup_mm.c is more reasonable (just use 1, neither
> NR_CPUS, nor nr_cpu_ids)?

The advantage of using nr_cpu_ids() is that this is one place less
to update when adding SMP support later...

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
