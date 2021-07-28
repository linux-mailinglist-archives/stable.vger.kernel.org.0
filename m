Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F2373D998D
	for <lists+stable@lfdr.de>; Thu, 29 Jul 2021 01:38:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232798AbhG1XiN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Jul 2021 19:38:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:55202 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232750AbhG1XiM (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 28 Jul 2021 19:38:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AC4096103E;
        Wed, 28 Jul 2021 23:38:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627515490;
        bh=+ykELLiF6X+PUZtIhfZ1cCVPe03Ud8NIS6XNdXYc0TA=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=PmpA2mB52OiIyb3+GakS+uJW0NXlswSVLSeF2mKFCeVp0R3XiMt1giNDbkfualLlK
         C0TEHMdXRAs1K66Vi6cdhS3RbqKXvgV+l/E2UMpRcMvxYOo/KJsJxGRN+tU7jxGkXn
         EEqk8C9Q7ubxoGwoxXAFfnFSJg16DTFaJ0I+4PpAA3BeIbtYBjK18Xaedt/Gp5DDni
         G1K/3j1AXs1fw5lyaoggIGZ0xIaU7kieoZGCM/UmyuPBKH7NdRgE1/qgG2FFkMXUgE
         GIMtmq9E/JeUeeFUXjWbsAbhGZqfB9LVgg1SWdURy7+PGyBVJTfAFVyjF5f8F1Jr+D
         y4d8+t9xbxF2g==
Received: by mail-ej1-f44.google.com with SMTP id nd39so7333236ejc.5;
        Wed, 28 Jul 2021 16:38:10 -0700 (PDT)
X-Gm-Message-State: AOAM531BSXrXms7gbeqABv8QWzYBwj4HH9dSNuqMY3Fz+3rZLcVYczCB
        MxJ1+w47vkweRku9q2+ruRH8DtcSjRwZPHgs3g==
X-Google-Smtp-Source: ABdhPJwcLdRnPcxmu95eAJbchsY+qbUNYbfWCcds3WuxJ7T8dxpZvGyfPkjlXfDdmftw1JKBIB1a8DbFI2N4UEko5VU=
X-Received: by 2002:a17:906:3707:: with SMTP id d7mr1816670ejc.127.1627515489228;
 Wed, 28 Jul 2021 16:38:09 -0700 (PDT)
MIME-Version: 1.0
References: <20210727174025.10552-1-linux@fw-web.de>
In-Reply-To: <20210727174025.10552-1-linux@fw-web.de>
From:   Chun-Kuang Hu <chunkuang.hu@kernel.org>
Date:   Thu, 29 Jul 2021 07:37:57 +0800
X-Gmail-Original-Message-ID: <CAAOTY_-mjUhNJ6=q2wGROYCftegESuC8mU1QC2ve6Fm5yiBTgw@mail.gmail.com>
Message-ID: <CAAOTY_-mjUhNJ6=q2wGROYCftegESuC8mU1QC2ve6Fm5yiBTgw@mail.gmail.com>
Subject: Re: [PATCH] soc: mmsys: mediatek: add mask to mmsys routes
To:     Frank Wunderlich <linux@fw-web.de>
Cc:     "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>, CK Hu <ck.hu@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Enric Balletbo i Serra <enric.balletbo@collabora.com>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Frank Wunderlich <frank-w@public-files.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi, Frank:

Frank Wunderlich <linux@fw-web.de> =E6=96=BC 2021=E5=B9=B47=E6=9C=8828=E6=
=97=A5 =E9=80=B1=E4=B8=89 =E4=B8=8A=E5=8D=881:41=E5=AF=AB=E9=81=93=EF=BC=9A
>
> From: CK Hu <ck.hu@mediatek.com>
>
> SOUT has many bits and need to be cleared before set new value.
> Write only could do the clear, but for MOUT, it clears bits that
> should not be cleared. So use a mask to reset only the needed bits.

Reviewed-by: Chun-Kuang Hu <chunkuang.hu@kernel.org>

>
> this fixes HDMI issues on MT7623/BPI-R2 since 5.13
>
> Cc: stable@vger.kernel.org
> Fixes: 440147639ac7 ("soc: mediatek: mmsys: Use an array for setting the =
routing registers")
> Signed-off-by: Frank Wunderlich <frank-w@public-files.de>
> Signed-off-by: CK Hu <ck.hu@mediatek.com>
> ---
> code is taken from here (upstreamed without mask part)
> https://chromium-review.googlesource.com/c/chromiumos/third_party/kernel/=
+/2345186/5
> basicly CK Hu's code so i set him as author
> ---
>  drivers/soc/mediatek/mtk-mmsys.c |   7 +-
>  drivers/soc/mediatek/mtk-mmsys.h | 133 +++++++++++++++++++++----------
>  2 files changed, 98 insertions(+), 42 deletions(-)
>
> diff --git a/drivers/soc/mediatek/mtk-mmsys.c b/drivers/soc/mediatek/mtk-=
mmsys.c
> index 080660ef11bf..0f949896fd06 100644
> --- a/drivers/soc/mediatek/mtk-mmsys.c
> +++ b/drivers/soc/mediatek/mtk-mmsys.c
> @@ -68,7 +68,9 @@ void mtk_mmsys_ddp_connect(struct device *dev,
>
>         for (i =3D 0; i < mmsys->data->num_routes; i++)
>                 if (cur =3D=3D routes[i].from_comp && next =3D=3D routes[=
i].to_comp) {
> -                       reg =3D readl_relaxed(mmsys->regs + routes[i].add=
r) | routes[i].val;
> +                       reg =3D readl_relaxed(mmsys->regs + routes[i].add=
r);
> +                       reg &=3D ~routes[i].mask;
> +                       reg |=3D routes[i].val;
>                         writel_relaxed(reg, mmsys->regs + routes[i].addr)=
;
>                 }
>  }
> @@ -85,7 +87,8 @@ void mtk_mmsys_ddp_disconnect(struct device *dev,
>
>         for (i =3D 0; i < mmsys->data->num_routes; i++)
>                 if (cur =3D=3D routes[i].from_comp && next =3D=3D routes[=
i].to_comp) {
> -                       reg =3D readl_relaxed(mmsys->regs + routes[i].add=
r) & ~routes[i].val;
> +                       reg =3D readl_relaxed(mmsys->regs + routes[i].add=
r);
> +                       reg &=3D ~routes[i].mask;
>                         writel_relaxed(reg, mmsys->regs + routes[i].addr)=
;
>                 }
>  }
> diff --git a/drivers/soc/mediatek/mtk-mmsys.h b/drivers/soc/mediatek/mtk-=
mmsys.h
> index a760a34e6eca..5f3e2bf0c40b 100644
> --- a/drivers/soc/mediatek/mtk-mmsys.h
> +++ b/drivers/soc/mediatek/mtk-mmsys.h
> @@ -35,41 +35,54 @@
>  #define RDMA0_SOUT_DSI1                                0x1
>  #define RDMA0_SOUT_DSI2                                0x4
>  #define RDMA0_SOUT_DSI3                                0x5
> +#define RDMA0_SOUT_MASK                                0x7
>  #define RDMA1_SOUT_DPI0                                0x2
>  #define RDMA1_SOUT_DPI1                                0x3
>  #define RDMA1_SOUT_DSI1                                0x1
>  #define RDMA1_SOUT_DSI2                                0x4
>  #define RDMA1_SOUT_DSI3                                0x5
> +#define RDMA1_SOUT_MASK                                0x7
>  #define RDMA2_SOUT_DPI0                                0x2
>  #define RDMA2_SOUT_DPI1                                0x3
>  #define RDMA2_SOUT_DSI1                                0x1
>  #define RDMA2_SOUT_DSI2                                0x4
>  #define RDMA2_SOUT_DSI3                                0x5
> +#define RDMA2_SOUT_MASK                                0x7
>  #define DPI0_SEL_IN_RDMA1                      0x1
>  #define DPI0_SEL_IN_RDMA2                      0x3
> +#define DPI0_SEL_IN_MASK                       0x3
>  #define DPI1_SEL_IN_RDMA1                      (0x1 << 8)
>  #define DPI1_SEL_IN_RDMA2                      (0x3 << 8)
> +#define DPI1_SEL_IN_MASK                       (0x3 << 8)
>  #define DSI0_SEL_IN_RDMA1                      0x1
>  #define DSI0_SEL_IN_RDMA2                      0x4
> +#define DSI0_SEL_IN_MASK                       0x7
>  #define DSI1_SEL_IN_RDMA1                      0x1
>  #define DSI1_SEL_IN_RDMA2                      0x4
> +#define DSI1_SEL_IN_MASK                       0x7
>  #define DSI2_SEL_IN_RDMA1                      (0x1 << 16)
>  #define DSI2_SEL_IN_RDMA2                      (0x4 << 16)
> +#define DSI2_SEL_IN_MASK                       (0x7 << 16)
>  #define DSI3_SEL_IN_RDMA1                      (0x1 << 16)
>  #define DSI3_SEL_IN_RDMA2                      (0x4 << 16)
> +#define DSI3_SEL_IN_MASK                       (0x7 << 16)
>  #define COLOR1_SEL_IN_OVL1                     0x1
>
>  #define OVL_MOUT_EN_RDMA                       0x1
>  #define BLS_TO_DSI_RDMA1_TO_DPI1               0x8
>  #define BLS_TO_DPI_RDMA1_TO_DSI                        0x2
> +#define BLS_RDMA1_DSI_DPI_MASK                 0xf
>  #define DSI_SEL_IN_BLS                         0x0
>  #define DPI_SEL_IN_BLS                         0x0
> +#define DPI_SEL_IN_MASK                                0x1
>  #define DSI_SEL_IN_RDMA                                0x1
> +#define DSI_SEL_IN_MASK                                0x1
>
>  struct mtk_mmsys_routes {
>         u32 from_comp;
>         u32 to_comp;
>         u32 addr;
> +       u32 mask;
>         u32 val;
>  };
>
> @@ -91,124 +104,164 @@ struct mtk_mmsys_driver_data {
>  static const struct mtk_mmsys_routes mmsys_default_routing_table[] =3D {
>         {
>                 DDP_COMPONENT_BLS, DDP_COMPONENT_DSI0,
> -               DISP_REG_CONFIG_OUT_SEL, BLS_TO_DSI_RDMA1_TO_DPI1
> +               DISP_REG_CONFIG_OUT_SEL, BLS_RDMA1_DSI_DPI_MASK,
> +               BLS_TO_DSI_RDMA1_TO_DPI1
>         }, {
>                 DDP_COMPONENT_BLS, DDP_COMPONENT_DSI0,
> -               DISP_REG_CONFIG_DSI_SEL, DSI_SEL_IN_BLS
> +               DISP_REG_CONFIG_DSI_SEL, DSI_SEL_IN_MASK,
> +               DSI_SEL_IN_BLS
>         }, {
>                 DDP_COMPONENT_BLS, DDP_COMPONENT_DPI0,
> -               DISP_REG_CONFIG_OUT_SEL, BLS_TO_DPI_RDMA1_TO_DSI
> +               DISP_REG_CONFIG_OUT_SEL, BLS_RDMA1_DSI_DPI_MASK,
> +               BLS_TO_DPI_RDMA1_TO_DSI
>         }, {
>                 DDP_COMPONENT_BLS, DDP_COMPONENT_DPI0,
> -               DISP_REG_CONFIG_DSI_SEL, DSI_SEL_IN_RDMA
> +               DISP_REG_CONFIG_DSI_SEL, DSI_SEL_IN_MASK,
> +               DSI_SEL_IN_RDMA
>         }, {
>                 DDP_COMPONENT_BLS, DDP_COMPONENT_DPI0,
> -               DISP_REG_CONFIG_DPI_SEL, DPI_SEL_IN_BLS
> +               DISP_REG_CONFIG_DPI_SEL, DPI_SEL_IN_MASK,
> +               DPI_SEL_IN_BLS
>         }, {
>                 DDP_COMPONENT_GAMMA, DDP_COMPONENT_RDMA1,
> -               DISP_REG_CONFIG_DISP_GAMMA_MOUT_EN, GAMMA_MOUT_EN_RDMA1
> +               DISP_REG_CONFIG_DISP_GAMMA_MOUT_EN, GAMMA_MOUT_EN_RDMA1,
> +               GAMMA_MOUT_EN_RDMA1
>         }, {
>                 DDP_COMPONENT_OD0, DDP_COMPONENT_RDMA0,
> -               DISP_REG_CONFIG_DISP_OD_MOUT_EN, OD_MOUT_EN_RDMA0
> +               DISP_REG_CONFIG_DISP_OD_MOUT_EN, OD_MOUT_EN_RDMA0,
> +               OD_MOUT_EN_RDMA0
>         }, {
>                 DDP_COMPONENT_OD1, DDP_COMPONENT_RDMA1,
> -               DISP_REG_CONFIG_DISP_OD_MOUT_EN, OD1_MOUT_EN_RDMA1
> +               DISP_REG_CONFIG_DISP_OD_MOUT_EN, OD1_MOUT_EN_RDMA1,
> +               OD1_MOUT_EN_RDMA1
>         }, {
>                 DDP_COMPONENT_OVL0, DDP_COMPONENT_COLOR0,
> -               DISP_REG_CONFIG_DISP_OVL0_MOUT_EN, OVL0_MOUT_EN_COLOR0
> +               DISP_REG_CONFIG_DISP_OVL0_MOUT_EN, OVL0_MOUT_EN_COLOR0,
> +               OVL0_MOUT_EN_COLOR0
>         }, {
>                 DDP_COMPONENT_OVL0, DDP_COMPONENT_COLOR0,
> -               DISP_REG_CONFIG_DISP_COLOR0_SEL_IN, COLOR0_SEL_IN_OVL0
> +               DISP_REG_CONFIG_DISP_COLOR0_SEL_IN, COLOR0_SEL_IN_OVL0,
> +               COLOR0_SEL_IN_OVL0
>         }, {
>                 DDP_COMPONENT_OVL0, DDP_COMPONENT_RDMA0,
> -               DISP_REG_CONFIG_DISP_OVL_MOUT_EN, OVL_MOUT_EN_RDMA
> +               DISP_REG_CONFIG_DISP_OVL_MOUT_EN, OVL_MOUT_EN_RDMA,
> +               OVL_MOUT_EN_RDMA
>         }, {
>                 DDP_COMPONENT_OVL1, DDP_COMPONENT_COLOR1,
> -               DISP_REG_CONFIG_DISP_OVL1_MOUT_EN, OVL1_MOUT_EN_COLOR1
> +               DISP_REG_CONFIG_DISP_OVL1_MOUT_EN, OVL1_MOUT_EN_COLOR1,
> +               OVL1_MOUT_EN_COLOR1
>         }, {
>                 DDP_COMPONENT_OVL1, DDP_COMPONENT_COLOR1,
> -               DISP_REG_CONFIG_DISP_COLOR1_SEL_IN, COLOR1_SEL_IN_OVL1
> +               DISP_REG_CONFIG_DISP_COLOR1_SEL_IN, COLOR1_SEL_IN_OVL1,
> +               COLOR1_SEL_IN_OVL1
>         }, {
>                 DDP_COMPONENT_RDMA0, DDP_COMPONENT_DPI0,
> -               DISP_REG_CONFIG_DISP_RDMA0_SOUT_EN, RDMA0_SOUT_DPI0
> +               DISP_REG_CONFIG_DISP_RDMA0_SOUT_EN, RDMA0_SOUT_MASK,
> +               RDMA0_SOUT_DPI0
>         }, {
>                 DDP_COMPONENT_RDMA0, DDP_COMPONENT_DPI1,
> -               DISP_REG_CONFIG_DISP_RDMA0_SOUT_EN, RDMA0_SOUT_DPI1
> +               DISP_REG_CONFIG_DISP_RDMA0_SOUT_EN, RDMA0_SOUT_MASK,
> +               RDMA0_SOUT_DPI1
>         }, {
>                 DDP_COMPONENT_RDMA0, DDP_COMPONENT_DSI1,
> -               DISP_REG_CONFIG_DISP_RDMA0_SOUT_EN, RDMA0_SOUT_DSI1
> +               DISP_REG_CONFIG_DISP_RDMA0_SOUT_EN, RDMA0_SOUT_MASK,
> +               RDMA0_SOUT_DSI1
>         }, {
>                 DDP_COMPONENT_RDMA0, DDP_COMPONENT_DSI2,
> -               DISP_REG_CONFIG_DISP_RDMA0_SOUT_EN, RDMA0_SOUT_DSI2
> +               DISP_REG_CONFIG_DISP_RDMA0_SOUT_EN, RDMA0_SOUT_MASK,
> +               RDMA0_SOUT_DSI2
>         }, {
>                 DDP_COMPONENT_RDMA0, DDP_COMPONENT_DSI3,
> -               DISP_REG_CONFIG_DISP_RDMA0_SOUT_EN, RDMA0_SOUT_DSI3
> +               DISP_REG_CONFIG_DISP_RDMA0_SOUT_EN, RDMA0_SOUT_MASK,
> +               RDMA0_SOUT_DSI3
>         }, {
>                 DDP_COMPONENT_RDMA1, DDP_COMPONENT_DPI0,
> -               DISP_REG_CONFIG_DISP_RDMA1_SOUT_EN, RDMA1_SOUT_DPI0
> +               DISP_REG_CONFIG_DISP_RDMA1_SOUT_EN, RDMA1_SOUT_MASK,
> +               RDMA1_SOUT_DPI0
>         }, {
>                 DDP_COMPONENT_RDMA1, DDP_COMPONENT_DPI0,
> -               DISP_REG_CONFIG_DPI_SEL_IN, DPI0_SEL_IN_RDMA1
> +               DISP_REG_CONFIG_DPI_SEL_IN, DPI0_SEL_IN_MASK,
> +               DPI0_SEL_IN_RDMA1
>         }, {
>                 DDP_COMPONENT_RDMA1, DDP_COMPONENT_DPI1,
> -               DISP_REG_CONFIG_DISP_RDMA1_SOUT_EN, RDMA1_SOUT_DPI1
> +               DISP_REG_CONFIG_DISP_RDMA1_SOUT_EN, RDMA1_SOUT_MASK,
> +               RDMA1_SOUT_DPI1
>         }, {
>                 DDP_COMPONENT_RDMA1, DDP_COMPONENT_DPI1,
> -               DISP_REG_CONFIG_DPI_SEL_IN, DPI1_SEL_IN_RDMA1
> +               DISP_REG_CONFIG_DPI_SEL_IN, DPI1_SEL_IN_MASK,
> +               DPI1_SEL_IN_RDMA1
>         }, {
>                 DDP_COMPONENT_RDMA1, DDP_COMPONENT_DSI0,
> -               DISP_REG_CONFIG_DSIE_SEL_IN, DSI0_SEL_IN_RDMA1
> +               DISP_REG_CONFIG_DSIE_SEL_IN, DSI0_SEL_IN_MASK,
> +               DSI0_SEL_IN_RDMA1
>         }, {
>                 DDP_COMPONENT_RDMA1, DDP_COMPONENT_DSI1,
> -               DISP_REG_CONFIG_DISP_RDMA1_SOUT_EN, RDMA1_SOUT_DSI1
> +               DISP_REG_CONFIG_DISP_RDMA1_SOUT_EN, RDMA1_SOUT_MASK,
> +               RDMA1_SOUT_DSI1
>         }, {
>                 DDP_COMPONENT_RDMA1, DDP_COMPONENT_DSI1,
> -               DISP_REG_CONFIG_DSIO_SEL_IN, DSI1_SEL_IN_RDMA1
> +               DISP_REG_CONFIG_DSIO_SEL_IN, DSI1_SEL_IN_MASK,
> +               DSI1_SEL_IN_RDMA1
>         }, {
>                 DDP_COMPONENT_RDMA1, DDP_COMPONENT_DSI2,
> -               DISP_REG_CONFIG_DISP_RDMA1_SOUT_EN, RDMA1_SOUT_DSI2
> +               DISP_REG_CONFIG_DISP_RDMA1_SOUT_EN, RDMA1_SOUT_MASK,
> +               RDMA1_SOUT_DSI2
>         }, {
>                 DDP_COMPONENT_RDMA1, DDP_COMPONENT_DSI2,
> -               DISP_REG_CONFIG_DSIE_SEL_IN, DSI2_SEL_IN_RDMA1
> +               DISP_REG_CONFIG_DSIE_SEL_IN, DSI2_SEL_IN_MASK,
> +               DSI2_SEL_IN_RDMA1
>         }, {
>                 DDP_COMPONENT_RDMA1, DDP_COMPONENT_DSI3,
> -               DISP_REG_CONFIG_DISP_RDMA1_SOUT_EN, RDMA1_SOUT_DSI3
> +               DISP_REG_CONFIG_DISP_RDMA1_SOUT_EN, RDMA1_SOUT_MASK,
> +               RDMA1_SOUT_DSI3
>         }, {
>                 DDP_COMPONENT_RDMA1, DDP_COMPONENT_DSI3,
> -               DISP_REG_CONFIG_DSIO_SEL_IN, DSI3_SEL_IN_RDMA1
> +               DISP_REG_CONFIG_DSIO_SEL_IN, DSI3_SEL_IN_MASK,
> +               DSI3_SEL_IN_RDMA1
>         }, {
>                 DDP_COMPONENT_RDMA2, DDP_COMPONENT_DPI0,
> -               DISP_REG_CONFIG_DISP_RDMA2_SOUT, RDMA2_SOUT_DPI0
> +               DISP_REG_CONFIG_DISP_RDMA2_SOUT, RDMA2_SOUT_MASK,
> +               RDMA2_SOUT_DPI0
>         }, {
>                 DDP_COMPONENT_RDMA2, DDP_COMPONENT_DPI0,
> -               DISP_REG_CONFIG_DPI_SEL_IN, DPI0_SEL_IN_RDMA2
> +               DISP_REG_CONFIG_DPI_SEL_IN, DPI0_SEL_IN_MASK,
> +               DPI0_SEL_IN_RDMA2
>         }, {
>                 DDP_COMPONENT_RDMA2, DDP_COMPONENT_DPI1,
> -               DISP_REG_CONFIG_DISP_RDMA2_SOUT, RDMA2_SOUT_DPI1
> +               DISP_REG_CONFIG_DISP_RDMA2_SOUT, RDMA2_SOUT_MASK,
> +               RDMA2_SOUT_DPI1
>         }, {
>                 DDP_COMPONENT_RDMA2, DDP_COMPONENT_DPI1,
> -               DISP_REG_CONFIG_DPI_SEL_IN, DPI1_SEL_IN_RDMA2
> +               DISP_REG_CONFIG_DPI_SEL_IN, DPI1_SEL_IN_MASK,
> +               DPI1_SEL_IN_RDMA2
>         }, {
>                 DDP_COMPONENT_RDMA2, DDP_COMPONENT_DSI0,
> -               DISP_REG_CONFIG_DSIE_SEL_IN, DSI0_SEL_IN_RDMA2
> +               DISP_REG_CONFIG_DSIE_SEL_IN, DSI0_SEL_IN_MASK,
> +               DSI0_SEL_IN_RDMA2
>         }, {
>                 DDP_COMPONENT_RDMA2, DDP_COMPONENT_DSI1,
> -               DISP_REG_CONFIG_DISP_RDMA2_SOUT, RDMA2_SOUT_DSI1
> +               DISP_REG_CONFIG_DISP_RDMA2_SOUT, RDMA2_SOUT_MASK,
> +               RDMA2_SOUT_DSI1
>         }, {
>                 DDP_COMPONENT_RDMA2, DDP_COMPONENT_DSI1,
> -               DISP_REG_CONFIG_DSIO_SEL_IN, DSI1_SEL_IN_RDMA2
> +               DISP_REG_CONFIG_DSIO_SEL_IN, DSI1_SEL_IN_MASK,
> +               DSI1_SEL_IN_RDMA2
>         }, {
>                 DDP_COMPONENT_RDMA2, DDP_COMPONENT_DSI2,
> -               DISP_REG_CONFIG_DISP_RDMA2_SOUT, RDMA2_SOUT_DSI2
> +               DISP_REG_CONFIG_DISP_RDMA2_SOUT, RDMA2_SOUT_MASK,
> +               RDMA2_SOUT_DSI2
>         }, {
>                 DDP_COMPONENT_RDMA2, DDP_COMPONENT_DSI2,
> -               DISP_REG_CONFIG_DSIE_SEL_IN, DSI2_SEL_IN_RDMA2
> +               DISP_REG_CONFIG_DSIE_SEL_IN, DSI2_SEL_IN_MASK,
> +               DSI2_SEL_IN_RDMA2
>         }, {
>                 DDP_COMPONENT_RDMA2, DDP_COMPONENT_DSI3,
> -               DISP_REG_CONFIG_DISP_RDMA2_SOUT, RDMA2_SOUT_DSI3
> +               DISP_REG_CONFIG_DISP_RDMA2_SOUT, RDMA2_SOUT_MASK,
> +               RDMA2_SOUT_DSI3
>         }, {
>                 DDP_COMPONENT_RDMA2, DDP_COMPONENT_DSI3,
> -               DISP_REG_CONFIG_DSIO_SEL_IN, DSI3_SEL_IN_RDMA2
> +               DISP_REG_CONFIG_DSIO_SEL_IN, DSI3_SEL_IN_MASK,
> +               DSI3_SEL_IN_RDMA2
>         }
>  };
>
> --
> 2.25.1
>
>
> _______________________________________________
> Linux-mediatek mailing list
> Linux-mediatek@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-mediatek
