Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F15806C2BC3
	for <lists+stable@lfdr.de>; Tue, 21 Mar 2023 08:55:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230450AbjCUHzh convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Tue, 21 Mar 2023 03:55:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230285AbjCUHzg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Mar 2023 03:55:36 -0400
Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com [209.85.219.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D7BE18AA2;
        Tue, 21 Mar 2023 00:55:35 -0700 (PDT)
Received: by mail-qv1-f51.google.com with SMTP id 31so1427814qvc.1;
        Tue, 21 Mar 2023 00:55:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679385333;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aAJ52VlFJHeAiC/ScNh14/AnDk6oLXAbKeiEG12Lh9A=;
        b=XZqS0AR13TbRVaQdXJwy6MnAydrTdql96entjbmJDf6o5yDSZWDGSD29Rwx+ZetaZC
         X2LFghLVmcv4f8MvAj5xHnlsws5Y64kKrrZLS8iQdydW5/PhzRhFnuugO9iAcbNB172z
         3lTpoxN2nl8jPR5GFF1EaYxq88bS4A01DrXm78bGkGaHhIEZEhNrAGyr6pB60bHpDG9R
         AR+b0z0TqzGmACaQ8NydVadYskwy+sAS0/mN7hRbdy0RC7lexuHNMKmn00IUzevRa4vJ
         LAWVoalNerByhwubLzpICbGevEiNU/vW47CFDsRLC8xDVuC6h1n54JjJteLqTBPqwzfW
         1u8g==
X-Gm-Message-State: AO0yUKUfy7g4S+Jp9s6d8mnaqlA5oihWlkUnqYdQ5qGR1tkTJDuIRcqO
        d4uSHPuA26iYJTlLOlPEWJ5LoIdyyCSGcw==
X-Google-Smtp-Source: AK7set9+ExVxKk/nPWrrUDapMUJhL/VgAARa5OCrGnwe6afIhMvMCe4UOPFLUa2mlRFOOY304DWvoA==
X-Received: by 2002:a05:6214:d46:b0:56b:fb58:c350 with SMTP id 6-20020a0562140d4600b0056bfb58c350mr2162157qvr.26.1679385333160;
        Tue, 21 Mar 2023 00:55:33 -0700 (PDT)
Received: from mail-yw1-f176.google.com (mail-yw1-f176.google.com. [209.85.128.176])
        by smtp.gmail.com with ESMTPSA id r9-20020a37a809000000b007463509f94asm5063777qke.55.2023.03.21.00.55.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Mar 2023 00:55:32 -0700 (PDT)
Received: by mail-yw1-f176.google.com with SMTP id 00721157ae682-5418d54d77bso266162037b3.12;
        Tue, 21 Mar 2023 00:55:32 -0700 (PDT)
X-Received: by 2002:a81:b65e:0:b0:533:9252:32fa with SMTP id
 h30-20020a81b65e000000b00533925232famr491636ywk.4.1679385332320; Tue, 21 Mar
 2023 00:55:32 -0700 (PDT)
MIME-Version: 1.0
References: <20230320231310.28841-1-rdunlap@infradead.org>
In-Reply-To: <20230320231310.28841-1-rdunlap@infradead.org>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Tue, 21 Mar 2023 08:55:21 +0100
X-Gmail-Original-Message-ID: <CAMuHMdXnbRvCjtgpbMnUVoRbHSk407t7Sr4XPpoiaE7M1h+4Ng@mail.gmail.com>
Message-ID: <CAMuHMdXnbRvCjtgpbMnUVoRbHSk407t7Sr4XPpoiaE7M1h+4Ng@mail.gmail.com>
Subject: Re: [PATCH 6/7 v5] sh: fix Kconfig entry for NUMA => SMP
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     linux-kernel@vger.kernel.org,
        John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Rich Felker <dalias@libc.org>,
        Kuninori Morimoto <morimoto.kuninori@renesas.com>,
        linux-sh@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Randy,

Thanks for your patch!

On Tue, Mar 21, 2023 at 12:13 AM Randy Dunlap <rdunlap@infradead.org> wrote:
> Fix SUPERH builds that select SYS_SUPPORTS_NUMA but do not select
> SYS_SUPPORTS_SMP and SMP.

Perhaps because these SoCs do not support SMP?

> kernel/sched/topology.c is only built for CONFIG_SMP and then the NUMA
> code + data inside topology.c is only built when CONFIG_NUMA is
> set/enabled, so these arch/sh/ configs need to select SMP and
> SYS_SUPPORTS_SMP to build the NUMA support.
>
> Fixes this build error in multiple SUPERH configs:
>
> mm/page_alloc.o: In function `get_page_from_freelist':
> page_alloc.c:(.text+0x2ca8): undefined reference to `node_reclaim_distance'
>
> Fixes: 357d59469c11 ("sh: Tidy up dependencies for SH-2 build.")
> Fixes: 9109a30e5a54 ("sh: add support for sh7366 processor")
> Fixes: 55ba99eb211a ("sh: Add support for SH7786 CPU subtype.")
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>

> --- a/arch/sh/Kconfig
> +++ b/arch/sh/Kconfig
> @@ -442,6 +442,8 @@ config CPU_SUBTYPE_SH7785
>         select CPU_SHX2
>         select ARCH_SPARSEMEM_ENABLE
>         select SYS_SUPPORTS_NUMA
> +       select SYS_SUPPORTS_SMP
> +       select SMP

SH7785 is single-core.

>         select PINCTRL
>
>  config CPU_SUBTYPE_SH7786
> @@ -476,6 +478,8 @@ config CPU_SUBTYPE_SH7722
>         select CPU_SHX2
>         select ARCH_SHMOBILE
>         select ARCH_SPARSEMEM_ENABLE
> +       select SYS_SUPPORTS_SMP
> +       select SMP

SH7722 is single-core.

>         select SYS_SUPPORTS_NUMA
>         select SYS_SUPPORTS_SH_CMT
>         select PINCTRL
> @@ -486,6 +490,8 @@ config CPU_SUBTYPE_SH7366
>         select CPU_SHX2
>         select ARCH_SHMOBILE
>         select ARCH_SPARSEMEM_ENABLE
> +       select SYS_SUPPORTS_SMP
> +       select SMP

Dunno about this one (no public info available).

>         select SYS_SUPPORTS_NUMA
>         select SYS_SUPPORTS_SH_CMT

Wasn't this fixed by commit 61bb6cd2f765b90c ("mm: move
node_reclaim_distance to fix NUMA without SMP") in v5.16?

It is not sufficient, after that you run into:

    mm/slab.c: In function ‘slab_memory_callback’:
    mm/slab.c:1127:23: error: implicit declaration of function
‘init_cache_node_node’; did you mean ‘drain_cache_node_node’?
[-Werror=implicit-function-declaration]
     1127 |                 ret = init_cache_node_node(nid);

which you reported before in
https://lore.kernel.org/all/b5bdea22-ed2f-3187-6efe-0c72330270a4@infradead.org/

Gr{oetje,eeting}s,

                        Geert


--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
