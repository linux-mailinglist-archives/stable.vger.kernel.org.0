Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8659624D715
	for <lists+stable@lfdr.de>; Fri, 21 Aug 2020 16:13:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726440AbgHUONr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Aug 2020 10:13:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725948AbgHUONq (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Aug 2020 10:13:46 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D35AFC061573;
        Fri, 21 Aug 2020 07:13:45 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id w25so1983615ljo.12;
        Fri, 21 Aug 2020 07:13:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iuOUrhDGs69pCpgj1fMoa06fENK8uW3BqIW8Jq5g85Q=;
        b=ZGW6gaN2P0cT3qr4LuJjzkzbSgOXn/pUE1LDefJiepgL2ga8abKfz1DuDER/Jy8p6D
         khQY2g2VODZNBVKWAoT1h38toCQcVnrsjEoyKoR4feb6RUSTzKVDbLK7MgreTm6aDPxQ
         Pc7ABKq5+QiuS6GHL3umrbQ6Pj4y7jv4nZ13aO7fdaYv7H+P9Va0QWMkZhIT+arC8x12
         thypehnIhoCed6p/Me7np8GrymkpKQlR7Ri0NBny8hHGUBxsWi6cA+G/reu+L4Gatid+
         jJ7P20aqDeJ5GSse27pyd9bLhR4xlCuNuOrwmPXka9QgyVYscITZwxBhH2JmDRDZRrzU
         CHMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iuOUrhDGs69pCpgj1fMoa06fENK8uW3BqIW8Jq5g85Q=;
        b=DysJT6OHLKeyvPrVVquckbGIT1E3/V1TgcuZ79u60UXGTpJpJC9iDa7kdBYY20dY+B
         reRgm+I+3OjuKOCQGXZduyBvoPuU2Goikeph2rYGuXkQG3fjxHzOCBEkmFqAs/xnZh0P
         oEuvLCc73m7c1CGNrmHmPTdH2oYqg6QTH1ou3ZHfKY2bhlobnoGpzJHw25Yb3shP7Tdy
         /4Nx1XP/TbFNUiA2v8DjsGdU+0rp0WGUehdLH2huozc5n8xlivN+x1syJU4X0Qa7M9Fk
         GkFrfaaglRmQghti1Z5jtCrmd/UlMw0h2PrkawIWlsV8L1SCUU5DkNTsE9fOjCZvUYU9
         AR6g==
X-Gm-Message-State: AOAM531aUeMTNKsm+IUQp/LYZTgr7/lTHjDDf5a+YLmP0ADxEs4X8j38
        lmV1cay/nCTowx9idcLjTi0QODAd7SriXkHfmIQ=
X-Google-Smtp-Source: ABdhPJwMBpVd1ySrrPtiFSM7g7uixqBkVna/EYqmFeqaQr13VAUSfCDpHkv6TU6DJzfemWdYtOMIxjQniuzGL7SPB+4=
X-Received: by 2002:a2e:8ed4:: with SMTP id e20mr1744788ljl.403.1598019224063;
 Fri, 21 Aug 2020 07:13:44 -0700 (PDT)
MIME-Version: 1.0
References: <20200820041055.75848-1-cphealy@gmail.com> <1bf1c9664d8c376c87dc55aeb27da6e4@agner.ch>
In-Reply-To: <1bf1c9664d8c376c87dc55aeb27da6e4@agner.ch>
From:   Chris Healy <cphealy@gmail.com>
Date:   Fri, 21 Aug 2020 07:13:32 -0700
Message-ID: <CAFXsbZp0_hCZ-cz3vBtFySv-q4X8bKjSaPrAMt-aA5aAbtGVGA@mail.gmail.com>
Subject: Re: [PATCH v2] ARM: dts: vfxxx: Add syscon compatible with ocotp
To:     Stefan Agner <stefan@agner.ch>
Cc:     Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Rob Herring <robh+dt@kernel.org>,
        Andrey Smirnov <andrew.smirnov@gmail.com>,
        linux ARM <linux-arm-kernel@lists.infradead.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Fabio Estevam <festevam@gmail.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 21, 2020 at 6:21 AM Stefan Agner <stefan@agner.ch> wrote:
>
> On 2020-08-20 06:10, Chris Healy wrote:
> > From: Chris Healy <cphealy@gmail.com>
> >
> > Add syscon compatibility with Vybrid ocotp node. This is required to
> > access the UID.
>
> Hm, it seems today the SoC driver uses the specific compatible. It also
> should expose the UID as soc_id, see drivers/soc/imx/soc-imx.c.
>
Yes, until I added syscon, the soc_id was empty and I would get the
following line in dmesg:  "failed to find vf610-ocotp regmap!

> Maybe it does make sense exposing it as syscon, but then we should
> probably also adjust
> Documentation/devicetree/bindings/nvmem/vf610-ocotp.txt.
>
Makes sense.  I will update vf610-ocotp.txt in v3.  Tnx

> --
> Stefan
>
> >
> > Fixes: fa8d20c8dbb77 ("ARM: dts: vfxxx: Add node corresponding to OCOTP")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Chris Healy <cphealy@gmail.com>
> > ---
> > Changes in v2:
> >  - Add Fixes line to commit message
> >
> >  arch/arm/boot/dts/vfxxx.dtsi | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/arch/arm/boot/dts/vfxxx.dtsi b/arch/arm/boot/dts/vfxxx.dtsi
> > index 0fe03aa0367f..2259d11af721 100644
> > --- a/arch/arm/boot/dts/vfxxx.dtsi
> > +++ b/arch/arm/boot/dts/vfxxx.dtsi
> > @@ -495,7 +495,7 @@ edma1: dma-controller@40098000 {
> >                       };
> >
> >                       ocotp: ocotp@400a5000 {
> > -                             compatible = "fsl,vf610-ocotp";
> > +                             compatible = "fsl,vf610-ocotp", "syscon";
> >                               reg = <0x400a5000 0x1000>;
> >                               clocks = <&clks VF610_CLK_OCOTP>;
> >                       };
