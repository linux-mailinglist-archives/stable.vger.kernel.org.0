Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D57524DA2AB
	for <lists+stable@lfdr.de>; Tue, 15 Mar 2022 19:50:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346084AbiCOSvl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Mar 2022 14:51:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231664AbiCOSvj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Mar 2022 14:51:39 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 222A056C3B;
        Tue, 15 Mar 2022 11:50:27 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id w25so1770058edi.11;
        Tue, 15 Mar 2022 11:50:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=isS1AYQcwVPOcEynJdmCksyBOj5J5k4cGXy9RxN9siM=;
        b=EJAR8bgpKmAzptXx9PJ1JiXWfZa4MK/+HWdD9If3KRwYbuvcHJuGI23cqy7p1yoRML
         tW8cZV/UomyHa9mRQI/k3hZkoINAsGKuFcOs0nQQO8GYttIqs9e4RfVUzigKZ/AmLqKt
         aH6gnqHpIIHuHXG2v5Rjscm7xPDW2OCKzy1J8tCbxxE285qCSPV9rngp6i9a8TAVVvlm
         PASZUntJ91F3OG07e1StFZGA2A5EKPiqfwsN0xUeYk6WVzmM5DtgKJNVsy/13bKKm3p7
         tjM0vwmCWiueiGNu+GUlp+N71G/6RutaybQ0Qwb9e7DrRRfQf2NCSoje3jKCD48pmffa
         fj7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=isS1AYQcwVPOcEynJdmCksyBOj5J5k4cGXy9RxN9siM=;
        b=55AmE51VKyOaX4OEo4VV37t8MauQ/ECxRc6lmiBBtRGrrmUl6QYrk9b60mGdfhInOP
         u/Yl0asICiLxPnm4knku98x/tYLI4jNu0cCleBc5hcAUpm2jBTC6caFdz0delzLYmuq2
         r+bQQKOtd4SlYgDqHM52ZtfJxuuaEOhLLd0hpUfTElG4ucXmM7aI/N/VEli4YBWsFy5z
         6vWv8c4FrvuVF+RR1nJDfFzf/hIVJWA6rIS8Y8jTEVM6gTSHwZ+nXLyzAMlvBElchRkP
         7wdn9b0ld/z59/DZrH5fL3Bz83JqIGOqUOV2wFf38Rh/8I0RpScH3xxICkt6uzbJEAIh
         57Ag==
X-Gm-Message-State: AOAM530r16EGoxbZKlRCsNSHssBVeTklVCOWauwsXF7zMSDFO2Pyqy5k
        oO2gQKe99cqbAOXClZHLVpg=
X-Google-Smtp-Source: ABdhPJxInX22y59stRqwLhA58e5mYMCN0nEinf10VE+bMfkXFl0cU9SFTmDTCGo59xL2vgPYa8y5ow==
X-Received: by 2002:a50:d78e:0:b0:416:2cd7:7ac5 with SMTP id w14-20020a50d78e000000b004162cd77ac5mr26447468edi.320.1647370225554;
        Tue, 15 Mar 2022 11:50:25 -0700 (PDT)
Received: from kista.localnet (cpe-86-58-32-107.static.triera.net. [86.58.32.107])
        by smtp.gmail.com with ESMTPSA id f6-20020a0564021e8600b00412ae7fda95sm9970933edf.44.2022.03.15.11.50.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Mar 2022 11:50:25 -0700 (PDT)
From:   Jernej =?utf-8?B?xaBrcmFiZWM=?= <jernej.skrabec@gmail.com>
To:     Rob Herring <robh+dt@kernel.org>,
        Maxime Ripard <mripard@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>,
        Petr =?utf-8?B?xaB0ZXRpYXI=?= <ynezz@true.cz>
Cc:     Petr =?utf-8?B?xaB0ZXRpYXI=?= <ynezz@true.cz>,
        stable@vger.kernel.org,
        Bastien =?ISO-8859-1?Q?Roucari=E8s?= <rouca@debian.org>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-sunxi@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/3] Revert "ARM: dts: sun7i: A20-olinuxino-lime2: Fix ethernet phy-mode"
Date:   Tue, 15 Mar 2022 19:50:23 +0100
Message-ID: <44524634.fMDQidcC6G@kista>
In-Reply-To: <20220315095244.29718-2-ynezz@true.cz>
References: <20220315095244.29718-1-ynezz@true.cz> <20220315095244.29718-2-ynezz@true.cz>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
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

Hi Petr!

Dne torek, 15. marec 2022 ob 10:52:42 CET je Petr =C5=A0tetiar napisal(a):
> This reverts commit 55dd7e059098ce4bd0a55c251cb78e74604abb57 as it
> breaks network on my A20-olinuxino-lime2 hardware revision "K" which has
> Micrel KSZ9031RNXCC-TR Gigabit PHY. Bastien has probably some previous
> hardware revisions which were based on RTL8211E-VB-CG1 PHY and thus this
> fix was working on his board.

NAK.

As Corentin mentioned in another discussion, new DT variant should be=20
introduced for newer board model. Otherwise we can play this revert game wi=
th=20
each new revision which changes Ethernet PHY behaviour. It also makes most=
=20
sense to have naming chronologically sorted. If board name in DT file doesn=
't=20
have any postfix, it should be compatible with earliest publicly available=
=20
board. If board manufacturer releases new board variant with incompatible=20
changes, new DT with appropriate postfix should be introduced.

I understand that this is frustrating for you, but whole situation around=20
mentioned commit is unfortunate and we can't satisfy everyone.

Also good way to solve such issues is to apply DT overlay in bootloader bas=
ed=20
on board revision number. I know Olimex implemented DT fixup in their=20
downstream U-Boot fork.

Best regards,
Jernej

>=20
> Cc: stable@vger.kernel.org
> Cc: Bastien Roucari=C3=A8s <rouca@debian.org>
> References: https://github.com/openwrt/openwrt/issues/9153
> References: https://github.com/OLIMEX/OLINUXINO/blob/master/HARDWARE/A20-=
OLinuXino-LIME2/hardware_revision_changes_log.txt
> Signed-off-by: Petr =C5=A0tetiar <ynezz@true.cz>
> ---
>  arch/arm/boot/dts/sun7i-a20-olinuxino-lime2.dts | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/arch/arm/boot/dts/sun7i-a20-olinuxino-lime2.dts b/arch/arm/b=
oot/
dts/sun7i-a20-olinuxino-lime2.dts
> index ecb91fb899ff..8077f1716fbc 100644
> --- a/arch/arm/boot/dts/sun7i-a20-olinuxino-lime2.dts
> +++ b/arch/arm/boot/dts/sun7i-a20-olinuxino-lime2.dts
> @@ -112,7 +112,7 @@ &gmac {
>  	pinctrl-names =3D "default";
>  	pinctrl-0 =3D <&gmac_rgmii_pins>;
>  	phy-handle =3D <&phy1>;
> -	phy-mode =3D "rgmii-id";
> +	phy-mode =3D "rgmii";
>  	status =3D "okay";
>  };
> =20
>=20


