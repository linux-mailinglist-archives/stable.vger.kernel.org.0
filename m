Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30E696C2C25
	for <lists+stable@lfdr.de>; Tue, 21 Mar 2023 09:19:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230172AbjCUITu convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Tue, 21 Mar 2023 04:19:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230467AbjCUITj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Mar 2023 04:19:39 -0400
Received: from mail-qv1-f49.google.com (mail-qv1-f49.google.com [209.85.219.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD16428E72;
        Tue, 21 Mar 2023 01:19:34 -0700 (PDT)
Received: by mail-qv1-f49.google.com with SMTP id cu4so9458438qvb.3;
        Tue, 21 Mar 2023 01:19:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679386773;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BLYBY14fxJt6FY/MeI8nPbCwVTivGXxeHh+OOnFgd74=;
        b=JZy0onuHt9T0eOWU6wALbp73ghCbttBClMnL3H3/CJ4/1Q+lrV1FtHSpK7ZWN+p5eO
         +CFd2loeb/fwv0xefCw0BbzSEkaSxYpcVI/QI0dDyaZ0/duXhtaf+ocLBKr1wFdadgKx
         J1ouQZQN96JUF00U6KqjEFpMZflS7ch7JuDfYgxtbjhAuSypYp70rm19p44TZodii7Jp
         RAePUMPp5LXgSyKviHocEeg4rE7KtM3O84RYSsg3gqE+t8vVNFZynXWJED2nVrWcmRAo
         rxGTppsg7v8zNXCBl1BAGU2ctPwK/eaBdCh8rh+hmZCBwlbPuC/JuxML+hixFa7LAapN
         MiZQ==
X-Gm-Message-State: AO0yUKViGmYD+w++rH6bELjBkg70phFMhGBbrT37vwI2GsdEwxRrt5cv
        tiO5FkDXgKrNI2KZTAAd+su2NZJ4s1fNiA==
X-Google-Smtp-Source: AK7set9rY80YthljlUWSFbysxefnum79s2ghsLO5yQL3+Mn812W0wmSfT9syK96m9bAFxV+HuU8zAw==
X-Received: by 2002:a05:6214:20aa:b0:571:13c:6806 with SMTP id 10-20020a05621420aa00b00571013c6806mr2277855qvd.33.1679386773041;
        Tue, 21 Mar 2023 01:19:33 -0700 (PDT)
Received: from mail-yw1-f169.google.com (mail-yw1-f169.google.com. [209.85.128.169])
        by smtp.gmail.com with ESMTPSA id j13-20020a37ef0d000000b00729b7d71ac7sm8893467qkk.33.2023.03.21.01.19.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Mar 2023 01:19:32 -0700 (PDT)
Received: by mail-yw1-f169.google.com with SMTP id 00721157ae682-544b959a971so233442437b3.3;
        Tue, 21 Mar 2023 01:19:32 -0700 (PDT)
X-Received: by 2002:a81:b2ca:0:b0:544:8bc1:a179 with SMTP id
 q193-20020a81b2ca000000b005448bc1a179mr572433ywh.4.1679386772120; Tue, 21 Mar
 2023 01:19:32 -0700 (PDT)
MIME-Version: 1.0
References: <20230320231310.28841-1-rdunlap@infradead.org> <CAMuHMdXnbRvCjtgpbMnUVoRbHSk407t7Sr4XPpoiaE7M1h+4Ng@mail.gmail.com>
 <ad2234ad155d51c142e59adcf2981bce23d69aa4.camel@physik.fu-berlin.de>
In-Reply-To: <ad2234ad155d51c142e59adcf2981bce23d69aa4.camel@physik.fu-berlin.de>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Tue, 21 Mar 2023 09:19:20 +0100
X-Gmail-Original-Message-ID: <CAMuHMdWyoQ--kc4-JDvcmNeWGZvT+w9UYSW5c7KeGB-bTQjLXg@mail.gmail.com>
Message-ID: <CAMuHMdWyoQ--kc4-JDvcmNeWGZvT+w9UYSW5c7KeGB-bTQjLXg@mail.gmail.com>
Subject: Re: [PATCH 6/7 v5] sh: fix Kconfig entry for NUMA => SMP
To:     John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc:     Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Rich Felker <dalias@libc.org>,
        Kuninori Morimoto <morimoto.kuninori@renesas.com>,
        linux-sh@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Adrian,

On Tue, Mar 21, 2023 at 9:10 AM John Paul Adrian Glaubitz
<glaubitz@physik.fu-berlin.de> wrote:
> On Tue, 2023-03-21 at 08:55 +0100, Geert Uytterhoeven wrote:
> > On Tue, Mar 21, 2023 at 12:13 AM Randy Dunlap <rdunlap@infradead.org> wrote:
> > > Fix SUPERH builds that select SYS_SUPPORTS_NUMA but do not select
> > > SYS_SUPPORTS_SMP and SMP.
> >
> > Perhaps because these SoCs do not support SMP?
>
> Well, there is actually a dual-core 7786 board available, see:
>
> > https://www.apnet.co.jp/product/superh/ap-sh4ad-0a.html
>
> Quoting:
>
> »The SH7786 is equipped with a dual-core SH-4A and has interfaces such as
>  DDR3 SDRAM, PCI Express, USB, and display unit.«
>
> I seem to remember that Oleg Endo had such a dual-core SH4A board.
>
> Also, the Sega Saturn had two SH-2 CPUs:
>
> > https://en.wikipedia.org/wiki/Sega_Saturn#Technical_specifications

But these are not the Kconfig entries changed by Randy's patch.

> > > kernel/sched/topology.c is only built for CONFIG_SMP and then the NUMA
> > > code + data inside topology.c is only built when CONFIG_NUMA is
> > > set/enabled, so these arch/sh/ configs need to select SMP and
> > > SYS_SUPPORTS_SMP to build the NUMA support.
> > >
> > > Fixes this build error in multiple SUPERH configs:
> > >
> > > mm/page_alloc.o: In function `get_page_from_freelist':
> > > page_alloc.c:(.text+0x2ca8): undefined reference to `node_reclaim_distance'
> > >
> > > Fixes: 357d59469c11 ("sh: Tidy up dependencies for SH-2 build.")
> > > Fixes: 9109a30e5a54 ("sh: add support for sh7366 processor")
> > > Fixes: 55ba99eb211a ("sh: Add support for SH7786 CPU subtype.")
> > > Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> >
> > > --- a/arch/sh/Kconfig
> > > +++ b/arch/sh/Kconfig
> > > @@ -442,6 +442,8 @@ config CPU_SUBTYPE_SH7785
> > >         select CPU_SHX2
> > >         select ARCH_SPARSEMEM_ENABLE
> > >         select SYS_SUPPORTS_NUMA
> > > +       select SYS_SUPPORTS_SMP
> > > +       select SMP
> >
> > SH7785 is single-core.
> >
> > >         select PINCTRL
> > >
> > >  config CPU_SUBTYPE_SH7786
> > > @@ -476,6 +478,8 @@ config CPU_SUBTYPE_SH7722
> > >         select CPU_SHX2
> > >         select ARCH_SHMOBILE
> > >         select ARCH_SPARSEMEM_ENABLE
> > > +       select SYS_SUPPORTS_SMP
> > > +       select SMP
> >
> > SH7722 is single-core.
> >
> > >         select SYS_SUPPORTS_NUMA
> > >         select SYS_SUPPORTS_SH_CMT
> > >         select PINCTRL
> > > @@ -486,6 +490,8 @@ config CPU_SUBTYPE_SH7366
> > >         select CPU_SHX2
> > >         select ARCH_SHMOBILE
> > >         select ARCH_SPARSEMEM_ENABLE
> > > +       select SYS_SUPPORTS_SMP
> > > +       select SMP
> >
> > Dunno about this one (no public info available).
> >
> > >         select SYS_SUPPORTS_NUMA
> > >         select SYS_SUPPORTS_SH_CMT
> >
> > Wasn't this fixed by commit 61bb6cd2f765b90c ("mm: move
> > node_reclaim_distance to fix NUMA without SMP") in v5.16?
> >
> > It is not sufficient, after that you run into:
> >
> >     mm/slab.c: In function ‘slab_memory_callback’:
> >     mm/slab.c:1127:23: error: implicit declaration of function
> > ‘init_cache_node_node’; did you mean ‘drain_cache_node_node’?
> > [-Werror=implicit-function-declaration]
> >      1127 |                 ret = init_cache_node_node(nid);
> >
> > which you reported before in
> > https://lore.kernel.org/all/b5bdea22-ed2f-3187-6efe-0c72330270a4@infradead.org/
>
> Without the patch, I am getting:
>
>   CC      fs/fat/nfs.o
> mm/slab.c: In function 'slab_memory_callback':
> mm/slab.c:1127:23: error: implicit declaration of function 'init_cache_node_node'; did you mean 'drain_cache_node_node'? [-Werror=implicit-function-declaration]
>  1127 |                 ret = init_cache_node_node(nid);
>       |                       ^~~~~~~~~~~~~~~~~~~~
>       |                       drain_cache_node_node

Which is a different error than in this patch description?
I am preparing a fix...

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
