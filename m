Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4637C1497C8
	for <lists+stable@lfdr.de>; Sat, 25 Jan 2020 21:27:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726690AbgAYU1X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 Jan 2020 15:27:23 -0500
Received: from mail-ed1-f65.google.com ([209.85.208.65]:46861 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726448AbgAYU1X (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 25 Jan 2020 15:27:23 -0500
Received: by mail-ed1-f65.google.com with SMTP id m8so6608573edi.13;
        Sat, 25 Jan 2020 12:27:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tmtvZ7+Bxr7d5ieDrIi/rySNUKYiB6ocaNnAhvSWmSs=;
        b=WpWNw2I12JdqnEw49VZ4yXrElgq01aqx2UNQjTKBgi3UavvRRup++2C9yOf0Rw3XYp
         hfDnhztTtSs5OGfdPUqYiLMqf6Ug6J/tVMMT7Jep9BjlnRUC1UWVaAf7hmszhlTjsOXx
         ZlTs8Dqus8GUJ//gGuOw9J04YVrGUGFKVx6dPRmzBZwu08jH6oo99/iObBGafcENMcya
         cge917M9Ma5boCncT5DbRhH8FitHjXTx8oyqG0a3r3qn1NRpN1GcQ8aAaFPHz6pxSFCD
         9PoIrZ2IwV1833Qic1jCIMQ2fYIcEB9X0JIj9ihsLRnJW+oZyUDIiZQRUooC7PbEp70e
         9hiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tmtvZ7+Bxr7d5ieDrIi/rySNUKYiB6ocaNnAhvSWmSs=;
        b=Zm3oSDAD9fgDJn9yvsOPrUgMxKb7Ppo1ggxqka5uEDdFlFMPeuk5uDHieJjxrt0+UV
         DT7EUazyp8unwhZWSdlrHz+UnjXI197BJOKl95VlyXsWgLQ+w+9sDZhm+NVJLAD1vZFI
         v5bUSFYMBRtWx9CtqgaeaL34+TcWatO0nUDwK0QfhHwSRVd+zkig6XYnSeyPwtYiPSBk
         pKil+pTp9Ip7PMNw+sr+xmiHDlLUZj4rrzsst7zkWrf0AiNULP5NNigT7z+OBTmOT34T
         zc0mMOl4C1P1fNQHiq+yBlnqD53IgMHOwIr/jwfiZoBFTfIYm3uqJlwA9iGFAFbTdaRb
         LjVg==
X-Gm-Message-State: APjAAAU7woTKKnKvQ02EETRhXydQ6UMmHB/js7J+uoyMBcZpt9kIxEyk
        /OQckiEHdvuuv4EfB5rdGb/w0hICBXj7ZHMGxfQ=
X-Google-Smtp-Source: APXvYqyfJlkeCGXAjSuG0GeYRh2mx4h1xrB6y0VvhtLPD7oexpo8GY7Own0wYzBhiOyBBQ6JyuSRolO+tOJBTPol9Es=
X-Received: by 2002:aa7:c44e:: with SMTP id n14mr8196842edr.179.1579984041043;
 Sat, 25 Jan 2020 12:27:21 -0800 (PST)
MIME-Version: 1.0
References: <20200124093047.008739095@linuxfoundation.org> <20200124093127.122646308@linuxfoundation.org>
 <20200125191333.GG14064@duo.ucw.cz>
In-Reply-To: <20200125191333.GG14064@duo.ucw.cz>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Sat, 25 Jan 2020 22:27:10 +0200
Message-ID: <CA+h21hrcv3=xyJY-LdpdDyTRjsEy6jfhgdWT=Jr04_MMgSn25A@mail.gmail.com>
Subject: Re: [PATCH 4.19 320/639] ARM: dts: ls1021: Fix SGMII PCS link
 remaining down after PHY disconnect
To:     Pavel Machek <pavel@denx.de>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        lkml <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Li Yang <leoyang.li@nxp.com>, Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Pavel,

On Sat, 25 Jan 2020 at 21:13, Pavel Machek <pavel@denx.de> wrote:
>
> Hi!
>
> > [ Upstream commit c7861adbe37f576931650ad8ef805e0c47564b9a ]
> >
> > Each eTSEC MAC has its own TBI (SGMII) PCS and private MDIO bus.
> > But due to a DTS oversight, both SGMII-compatible MACs of the LS1021 SoC
> > are pointing towards the same internal PCS. Therefore nobody is
> > controlling the internal PCS of eTSEC0.
> >
> > Upon initial ndo_open, the SGMII link is ok by virtue of U-boot
> > initialization. But upon an ifdown/ifup sequence, the code path from
> > ndo_open -> init_phy -> gfar_configure_serdes does not get executed for
> > the PCS of eTSEC0 (and is executed twice for MAC eTSEC1). So the SGMII
> > link remains down for eTSEC0. On the LS1021A-TWR board, to signal this
> > failure condition, the PHY driver keeps printing
> > '803x_aneg_done: SGMII link is not ok'.
> >
> > Also, it changes compatible of mdio0 to "fsl,etsec2-mdio" to match
> > mdio1 device.
>
> It actually changes compatible of both devices.
>
> > +++ b/arch/arm/boot/dts/ls1021a.dtsi
> > @@ -584,7 +584,7 @@
> >               };
> >
> >               mdio0: mdio@2d24000 {
> > -                     compatible = "gianfar";
> > +                     compatible = "fsl,etsec2-mdio";
> >                       device_type = "mdio";
> >                       #address-cells = <1>;
> >                       #size-cells = <0>;
> > @@ -592,6 +592,15 @@
> >                             <0x0 0x2d10030 0x0 0x4>;
> >               };
> >
> > +             mdio1: mdio@2d64000 {
> > +                     compatible = "fsl,etsec2-mdio";
>
>
> And they trigger different code in the driver:
>
>                 .type = "mdio",
>                 .compatible = "gianfar",
>                 .data = &(struct fsl_pq_mdio_data) {
>                 ...
>                         .get_tbipa = get_gfar_tbipa_from_mdio,
>                 },
>
>                 .compatible = "fsl,etsec2-mdio",
>                 .data = &(struct fsl_pq_mdio_data) {
>                 ...
>                         .get_tbipa = get_etsec_tbipa,
>                 },
>
> Are you sure that is good idea for both mainline and stable?
>

Thanks for spotting this.

What has happened is that [ Leo ] Li Yang suggested me to change the
compatible in v1 of this patch here:
https://patchwork.ozlabs.org/patch/1064015/

Not having any argument to oppose (and not much experience, to be
frank) I complied and sent out a 2-patch v2 series:
https://patchwork.ozlabs.org/patch/1084366/
https://patchwork.ozlabs.org/patch/1084365/

And Shawn squashed them when merging them, "to get it land as fix a bit easier".

Judging the code in more detail, you are indeed correct that the
"gianfar" compatible was the right one for this hardware. The
difference being the "get_tbipa" function which calculates the address
of the TBIPA register automatically, if not explicitly specified.
However, for ls1021a.dtsi, the TBIPA register _is_ explicitly
specified via the second "reg" (<0x0 0x2d10030 0x0 0x4>), so the
"get_tbipa" function is dead code for LS1021A. Therefore, luckily no
harm was done.

I would suggest that this patch continues to be applied as-is to the
stable kernels, just for the sake of not having divergent patches
across branches, and I'll send a new one that turns the compatible
back into "gianfar".

> Best regards,
>                                                                         Pavel
> --
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

Thanks,
-Vladimir
