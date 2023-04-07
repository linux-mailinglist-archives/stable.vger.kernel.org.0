Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 800266DAAAC
	for <lists+stable@lfdr.de>; Fri,  7 Apr 2023 11:10:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232023AbjDGJKi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Apr 2023 05:10:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231652AbjDGJKh (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 Apr 2023 05:10:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF7C8E9;
        Fri,  7 Apr 2023 02:10:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 794BE64DCC;
        Fri,  7 Apr 2023 09:10:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2B41C433EF;
        Fri,  7 Apr 2023 09:10:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680858635;
        bh=dywClRW4j4O7p5Ksngwq5/7eKvi5yJ/JMWGVgSMfKrg=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=SmhaHTMKberTU3jKu/cfFjAJAG4UHco3QrSttH7hJZqRCRyIcVo3F80q0nz6JkUvP
         vX7lMtkivLpN3WBMUTJ/kkpjy4fs7hbX5LX9uJDNFaMYlFnTc+EBZZtKnGT7hjSYUA
         W37a6TvPdIkIzB7uq7PgjTGyGqwPvFYU0JRzitIAQMywYcxpe/AJw8tmL+bIP83asE
         /BNe2ylBj+xj9lLo1/v1AnYPcyptpEts2o+V3b0T0qdviAbFEDBAoztYWwx0vsNuWz
         33hwVAjpZNl0ZULCEw6Z6b0qRQJA7xc4px5V4LhwO28FNP3yD2G2kJ94dmr1UKTMiZ
         ZFjCeqObG6xSg==
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-9341434fe3cso188299566b.1;
        Fri, 07 Apr 2023 02:10:35 -0700 (PDT)
X-Gm-Message-State: AAQBX9cZqEdfuaZZTmXE6nuPcNq3PZBW8ho1/c6HxZfYCq4CifaGRHCt
        BFLPQDn6VB+KU7PKavswXDnKD9pCCwIf1Fd5INQ=
X-Google-Smtp-Source: AKy350Ysf2bvaTDCE0nhTKwRJBgdESkqgUVFGtmCYhNIxwm561HQuPCCCZq00XDF/RWNan1UbPnBpWVe5WNIueNg+jo=
X-Received: by 2002:a05:6402:14d5:b0:501:e26e:502b with SMTP id
 f21-20020a05640214d500b00501e26e502bmr1687603edx.29.1680858634187; Fri, 07
 Apr 2023 02:10:34 -0700 (PDT)
MIME-Version: 1.0
References: <20230406025036.3022894-1-chenhuacai@loongson.cn>
In-Reply-To: <20230406025036.3022894-1-chenhuacai@loongson.cn>
From:   Guo Ren <guoren@kernel.org>
Date:   Fri, 7 Apr 2023 17:10:22 +0800
X-Gmail-Original-Message-ID: <CAJF2gTRjYra4yhWq0UYMmLYfSZ84fHJjC9JcCVpS4NQho7rvGw@mail.gmail.com>
Message-ID: <CAJF2gTRjYra4yhWq0UYMmLYfSZ84fHJjC9JcCVpS4NQho7rvGw@mail.gmail.com>
Subject: Re: [PATCH] LoongArch: module: set section addresses to 0x0
To:     Huacai Chen <chenhuacai@loongson.cn>
Cc:     Huacai Chen <chenhuacai@kernel.org>, loongarch@lists.linux.dev,
        Xuefeng Li <lixuefeng@loongson.cn>,
        Xuerui Wang <kernel@xen0n.name>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        linux-kernel@vger.kernel.org, loongson-kernel@lists.loongnix.cn,
        stable@vger.kernel.org, Chong Qiao <qiaochong@loongson.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Apr 6, 2023 at 10:51=E2=80=AFAM Huacai Chen <chenhuacai@loongson.cn=
> wrote:
>
> These got*, plt* and .text.ftrace_trampoline sections specified for
> LoongArch have non-zero addressses. Non-zero section addresses in a
> relocatable ELF would confuse GDB when it tries to compute the section
> offsets and it ends up printing wrong symbol addresses. Therefore, set
> them to zero, which mirrors the change in commit 5d8591bc0fbaeb6ded
> ("arm64 module: set plt* section addresses to 0x0").
Good point, maybe I would check RISC-V!

Thx.

Reviewed-by: Guo Ren <guoren@kernel.org>

>
> Cc: stable@vger.kernel.org
> Signed-off-by: Chong Qiao <qiaochong@loongson.cn>
> Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
> ---
>  arch/loongarch/include/asm/module.lds.h | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/arch/loongarch/include/asm/module.lds.h b/arch/loongarch/inc=
lude/asm/module.lds.h
> index 438f09d4ccf4..88554f92e010 100644
> --- a/arch/loongarch/include/asm/module.lds.h
> +++ b/arch/loongarch/include/asm/module.lds.h
> @@ -2,8 +2,8 @@
>  /* Copyright (C) 2020-2022 Loongson Technology Corporation Limited */
>  SECTIONS {
>         . =3D ALIGN(4);
> -       .got : { BYTE(0) }
> -       .plt : { BYTE(0) }
> -       .plt.idx : { BYTE(0) }
> -       .ftrace_trampoline : { BYTE(0) }
> +       .got 0 : { BYTE(0) }
> +       .plt 0 : { BYTE(0) }
> +       .plt.idx 0 : { BYTE(0) }
> +       .ftrace_trampoline 0 : { BYTE(0) }
>  }
> --
> 2.39.1
>


--=20
Best Regards
 Guo Ren
