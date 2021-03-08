Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69A5A330BB8
	for <lists+stable@lfdr.de>; Mon,  8 Mar 2021 11:53:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229575AbhCHKwg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Mar 2021 05:52:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:41662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231531AbhCHKw1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Mar 2021 05:52:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B1AF3651A5;
        Mon,  8 Mar 2021 10:52:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615200747;
        bh=pMZw1TDBbUwEEUX1lkSoLFf+kqIBxMbLfKVSPQF9aaQ=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Cq/00uHwzgIWa2KhCcr2lkUukJ6RAb7W8ZHe5c0F53BJVsTwVQfIh7wW0MgtqdSrP
         2Fhdzs40UVdWveB9g+5MsYy3Q7JxWL1qORCs/1qonr8lKj/v1zZ99uwvh6VNZSgbIf
         KBuPyT6XPnWIu3pF+z64xNcEeyMBUG0pfZ839f3yxPUdNWVhDU3YBG9TihxLQfmJx3
         wBcMQaAkYeOY9yyebMeZGiLX9hwZdQoIMlLNMokOpbBpOgIRB7Xa9G/S4Rsa/kNg9m
         I22JRNGXbXB4Ki/nFerZAqxsFTRZ3pQOkv5i4BV0//HiJ3CCcdijtN0rVWMXJmiTlI
         aU4x6/1455Ujg==
Received: by mail-ed1-f47.google.com with SMTP id dm26so13918784edb.12;
        Mon, 08 Mar 2021 02:52:26 -0800 (PST)
X-Gm-Message-State: AOAM530uJXgA8VZAVtPC7w5+zMZ4WLsJPwaDLMXHcNFmlBwQAoclvB7m
        3xojD4LK7xymrb/1/tQ1gzWfyBUvd5LvYxHazg==
X-Google-Smtp-Source: ABdhPJwqrES4G6zQVHpgFQQXFeYCzz2BE4zfV+Kku+1yeWjOOp6BnRWpxzqG37t7y9Uurj0BLHKxt6C58JJCGy7Z2A4=
X-Received: by 2002:aa7:cf14:: with SMTP id a20mr21354191edy.49.1615200745215;
 Mon, 08 Mar 2021 02:52:25 -0800 (PST)
MIME-Version: 1.0
References: <20210308070520.40429-1-chunfeng.yun@mediatek.com>
In-Reply-To: <20210308070520.40429-1-chunfeng.yun@mediatek.com>
From:   Chun-Kuang Hu <chunkuang.hu@kernel.org>
Date:   Mon, 8 Mar 2021 18:52:13 +0800
X-Gmail-Original-Message-ID: <CAAOTY__rno0A_8WCWHiNv6tLyqDOVe+dVmbJbv7_pDse+BTpSQ@mail.gmail.com>
Message-ID: <CAAOTY__rno0A_8WCWHiNv6tLyqDOVe+dVmbJbv7_pDse+BTpSQ@mail.gmail.com>
Subject: Re: [PATCH] arm64: dts: mt8173: fix property typo of 'phys' in dsi node
To:     Chunfeng Yun <chunfeng.yun@mediatek.com>
Cc:     Matthias Brugger <matthias.bgg@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Cawa Cheng <cawa.cheng@mediatek.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Jie Qiu <jie.qiu@mediatek.com>, CK Hu <ck.hu@mediatek.com>,
        Chun-Kuang Hu <chunkuang.hu@kernel.org>,
        DTML <devicetree@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi, Chunfeng:

Chunfeng Yun <chunfeng.yun@mediatek.com> =E6=96=BC 2021=E5=B9=B43=E6=9C=888=
=E6=97=A5 =E9=80=B1=E4=B8=80 =E4=B8=8B=E5=8D=883:05=E5=AF=AB=E9=81=93=EF=BC=
=9A
>
> Use 'phys' instead of 'phy'.

Reviewed-by: Chun-Kuang Hu <chunkuang.hu@kernel.org>

>
> Fixes: 81ad4dbaf7af ("arm64: dts: mt8173: Add display subsystem related n=
odes")
> Cc: stable <stable@vger.kernel.org>
> Signed-off-by: Chunfeng Yun <chunfeng.yun@mediatek.com>
> ---
>  arch/arm64/boot/dts/mediatek/mt8173.dtsi | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/arm64/boot/dts/mediatek/mt8173.dtsi b/arch/arm64/boot/d=
ts/mediatek/mt8173.dtsi
> index 75040a820f0d..003a5653c505 100644
> --- a/arch/arm64/boot/dts/mediatek/mt8173.dtsi
> +++ b/arch/arm64/boot/dts/mediatek/mt8173.dtsi
> @@ -1236,7 +1236,7 @@
>                                  <&mmsys CLK_MM_DSI1_DIGITAL>,
>                                  <&mipi_tx1>;
>                         clock-names =3D "engine", "digital", "hs";
> -                       phy =3D <&mipi_tx1>;
> +                       phys =3D <&mipi_tx1>;
>                         phy-names =3D "dphy";
>                         status =3D "disabled";
>                 };
> --
> 2.18.0
>
