Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4900F4D956E
	for <lists+stable@lfdr.de>; Tue, 15 Mar 2022 08:37:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235313AbiCOHiW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Mar 2022 03:38:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235018AbiCOHiV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Mar 2022 03:38:21 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 332D34B40B;
        Tue, 15 Mar 2022 00:37:10 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id e24so27517594wrc.10;
        Tue, 15 Mar 2022 00:37:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=OwoeDvRtQzvS4dvZsnQa2LZQBqsCmVjqhnox0xSOPkw=;
        b=A/s2nId2x/GkAj2vEU2y8bRnLG9OvetGVYTPr+1AqYHaW2KbbUa3CpX5L18HfhmEeX
         QrJwSca/SM4hKwYCqLWABiG7HDLqm147giJ1lXnRH0s4eTUnCaCBDT28SmPcvtdVqRO1
         6d097scoNQkPCkZ7roE+1YKOp85wW3PzQDCG3WndvgOyULIDsh9/R61IWXZ9BLdxUpDL
         r1Pfqp9DjaJYf/EaeuW2vO7mQr6zXF2pt04vRBauF0Osf2/U5w7ruOTQoyHenQ6Djpe3
         W5Jzt8yrl6T81gDttWw0R+EHDi4IbxauzND+9DdW7UcyZW88do/68ZOKEA0L7/vDVSPX
         MQSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=OwoeDvRtQzvS4dvZsnQa2LZQBqsCmVjqhnox0xSOPkw=;
        b=WsSBmOjHQc8Zb8OSNgNVme5ZshTMwhKgkXzFQnzDsNlJ3uq2TnsFr8W5GaFrsRwyhF
         yB4M+t2lsczW1QlhzaMYKN9/TmBdQsnlzMkNXsqJPqdfhCVO+8pM30ig9PX5e2ouY9Hm
         mZnCI1+gxRXPFy060Pn3cDjd9QDx1AwleRW9XCWNAjD6iqH2JrpOz227/AoqAetyjvFv
         TRj8LvZu6PA2EnzgZ7Qxldk+GTHUUBU6wMVqBXkJ2VaxXfqVigtr7BqwVYb+kgRmTIpi
         QyQ5204bTPWhOUlaHAYwdOsKEBBAc/CiHamqQPbVisj6iuEtFmp6ShnYD8vRjK2f1Dk4
         spXA==
X-Gm-Message-State: AOAM532xXwXaRTHcMBZV9vLoSumcDqHiAUn/H9Kw1swUtHfBXC9rHoso
        7oPY25NhnZr0nnJFqtESnZM=
X-Google-Smtp-Source: ABdhPJymNcUXpDAqZozSiaRLyRNNamAjYT4dnA0x5ZUi9ppHEM+ePeFNANf29fx9v1CjoZEtzlv/GQ==
X-Received: by 2002:a5d:5449:0:b0:1f0:1a0c:963f with SMTP id w9-20020a5d5449000000b001f01a0c963fmr18612606wrv.98.1647329828611;
        Tue, 15 Mar 2022 00:37:08 -0700 (PDT)
Received: from Red ([2a01:cb1d:3d5:a100:264b:feff:fe03:2806])
        by smtp.googlemail.com with ESMTPSA id u11-20020a05600c19cb00b00389efe9c512sm1574404wmq.23.2022.03.15.00.37.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Mar 2022 00:37:08 -0700 (PDT)
Date:   Tue, 15 Mar 2022 08:37:06 +0100
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     Petr =?utf-8?Q?=C5=A0tetiar?= <ynezz@true.cz>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Maxime Ripard <mripard@kernel.org>,
        Bastien =?iso-8859-1?Q?Roucari=E8s?= <rouca@debian.org>,
        Chen-Yu Tsai <wens@csie.org>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Rob Herring <robh+dt@kernel.org>, stable@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-sunxi@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Revert "ARM: dts: sun7i: A20-olinuxino-lime2: Fix
 ethernet phy-mode"
Message-ID: <YjBCImqGsbIZ3IF4@Red>
References: <20220308125531.27305-1-ynezz@true.cz>
 <20220315072846.GA9129@meh.true.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220315072846.GA9129@meh.true.cz>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Le Tue, Mar 15, 2022 at 08:28:58AM +0100, Petr Štetiar a écrit :
> Petr Štetiar <ynezz@true.cz> [2022-03-08 13:55:30]:
> 
> Hi Greg,
> 
> one week has passed and as I didn't received any feedback, I'm providing more
> details in a hope to make it more clear, why I think, that this fix is wrong
> and should be reverted in LTS kernels 5.10 and 5.15.
> 
> > This reverts commit 55dd7e059098ce4bd0a55c251cb78e74604abb57 as it breaks
> > network on my A20-olinuxino-lime2 hardware revision "K" which has Micrel
> > KSZ9031RNXCC-TR Gigabit PHY. Bastien has probably some previous hardware
> > revisions which were based on RTL8211E-VB-CG1 PHY and thus this fix was
> > working on his board.
> 
> Disclaimer, I don't own A20-olinuxino-lime2 board with earlier HW revisions
> G/G1/G2 utilizing RTL8211E PHY.
> 
> My understanding is, that up to kernel version 5.9 and specifically commit
> bbc4d71d6354 ("net: phy: realtek: fix rtl8211e rx/tx delay config") it was
> likely possible to use same DTS for A20-olinuxino-lime2 with KSZ9031 or
> RTL8211E PHYs (all HW revisions).
> 
> At least I was using my A20-olinuxino-lime2 HW revision K with KSZ9031 PHY
> just fine with 4.19 kernel. After upgrade to 5.10 LTS kernel my network
> stopped working, reverting stable backport commit a90398438517 ("ARM: dts:
> sun7i: A20-olinuxino-lime2: Fix ethernet phy-mode") fixed it.
> 
> From my POV proper fix for earlier HW revisions G/G1/G2 is introduction of
> sun7i-a20-olinuxino-lime2-revG.dts with a proper `phy-mode` for RTL8211E PHY.
> 
> Cheers,
> 
> Petr
> 

Hello

If your patch is applied, older revisions will stop working, right ?

What about adding a new dtb like sun7i-a20-olinuxino-lime2-revk.dts ?

Regards

> > Cc: stable@vger.kernel.org
> > Cc: Bastien Roucariès <rouca@debian.org>
> > References: https://github.com/openwrt/openwrt/issues/9153
> > References: https://github.com/OLIMEX/OLINUXINO/blob/master/HARDWARE/A20-OLinuXino-LIME2/hardware_revision_changes_log.txt
> > Signed-off-by: Petr Štetiar <ynezz@true.cz>
> > ---
> >  arch/arm/boot/dts/sun7i-a20-olinuxino-lime2.dts | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/arch/arm/boot/dts/sun7i-a20-olinuxino-lime2.dts b/arch/arm/boot/dts/sun7i-a20-olinuxino-lime2.dts
> > index ecb91fb899ff..8077f1716fbc 100644
> > --- a/arch/arm/boot/dts/sun7i-a20-olinuxino-lime2.dts
> > +++ b/arch/arm/boot/dts/sun7i-a20-olinuxino-lime2.dts
> > @@ -112,7 +112,7 @@ &gmac {
> >  	pinctrl-names = "default";
> >  	pinctrl-0 = <&gmac_rgmii_pins>;
> >  	phy-handle = <&phy1>;
> > -	phy-mode = "rgmii-id";
> > +	phy-mode = "rgmii";
> >  	status = "okay";
> >  };
> 
