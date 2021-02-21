Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C2C8320D59
	for <lists+stable@lfdr.de>; Sun, 21 Feb 2021 21:00:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230315AbhBUT7k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 21 Feb 2021 14:59:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230174AbhBUT7j (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 21 Feb 2021 14:59:39 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45C6CC061574
        for <stable@vger.kernel.org>; Sun, 21 Feb 2021 11:58:59 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id v22so19247493edx.13
        for <stable@vger.kernel.org>; Sun, 21 Feb 2021 11:58:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=RXCDkpK2A3tyyE+QGcPFTZkL+c696kV2buAbFqO4aic=;
        b=W8RITQvy3/BbTse4eemtWpnws5H+89N1kB/sMxqX5UhrPr81hRLZrpBD5EHYD12q+K
         l+KaLssvgGYNpXVgsFmYNHOMsQ3iKlgH9qxdC54tplcRuUn+3R+Anyh+XEoGx38ik9JW
         z1kqIqa9/CXcjvCT+DAAcqZFvye6s5Vl2XFRiYdrRXlc3+vP59JxBgPCLm18ZueT/OfH
         wsSuhZdXV0G37RVnGAENpuzdMMKBqT2K5qm/7zDO34NFdPyrHptKCkBzwCid45v51Dgd
         6KkSc1DU/3pWfBRdYIDHRZP0bYbCCGlRUR0Tu2ZBZ2/YDey/NbuA6bE2ilODSWICeeqG
         RlNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=RXCDkpK2A3tyyE+QGcPFTZkL+c696kV2buAbFqO4aic=;
        b=k7KyLaTofL72knfVZrXIBh290WCtvMtYghNsvUT38Mm+BstaZ9wqer8g4GnlB6CprF
         yLlaL5GXXPpE9HFANE6HwH3xZDXKgycU4FG3SxmwYSW/UwebM+aG55CiguZ2lFfckTsh
         PIt1lDM+lTaddnMnmvT2pHxv4H+rjGhZVLIb9P1WLvX2UYSjKksBW4fyMIIlyPdb19bo
         jockvIdF9XB4J5XaqrDgKCkvZ2jO0oEldmrUePnkCzSAS4Zs0NF8cLVQdhMgks0uCWVu
         zhPnrulgmrjNYEePOZ8FVgoOKrfkdeWqUwd+Yc3zsuwwtpkZydjtd3HFY0pbjCCsCWvG
         sSgA==
X-Gm-Message-State: AOAM533iV6Mkw0rGX25+z3L+RbNNH6VWYADlXIX5qcI/jqtcGs6coUZ1
        69mcLzrHHiuZNxkvC8WrVnDclFkBpWNkip7VNg==
X-Google-Smtp-Source: ABdhPJyB6MLiXI2Lzwgr0wT919BOXlKhDHJSC+cjoYyR8TKv7rDUFZcXENJewqK0ba1LdHX4OnEGY5w0TJGSsnobV/A=
X-Received: by 2002:a05:6402:26c9:: with SMTP id x9mr19441875edd.365.1613937537920;
 Sun, 21 Feb 2021 11:58:57 -0800 (PST)
MIME-Version: 1.0
References: <20210220231144.32325-1-kabel@kernel.org>
In-Reply-To: <20210220231144.32325-1-kabel@kernel.org>
From:   Rui Salvaterra <rsalvaterra@gmail.com>
Date:   Sun, 21 Feb 2021 19:58:46 +0000
Message-ID: <CALjTZvbVTw51vq6n+rBNsJNs_69Ueog8HT+PNqrDSJMNg830vA@mail.gmail.com>
Subject: Re: [PATCH mvebu-dt] ARM: dts: turris-omnia: configure LED[2]/INTn
 pin as interrupt pin
To:     =?UTF-8?B?TWFyZWsgQmVow7pu?= <kabel@kernel.org>
Cc:     Gregory CLEMENT <gregory.clement@bootlin.com>,
        =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= <uwe@kleine-koenig.org>,
        linux-arm-kernel@lists.infradead.org, Andrew Lunn <andrew@lunn.ch>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi, Marek,

On Sat, 20 Feb 2021 at 23:12, Marek Beh=C3=BAn <kabel@kernel.org> wrote:
>
> Use the `marvell,reg-init` DT property to configure the LED[2]/INTn pin
> of the Marvell 88E1514 ethernet PHY on Turris Omnia into interrupt mode.
>
> Without this the pin is by default in LED[2] mode, and the Marvell PHY
> driver configures LED[2] into "On - Link, Blink - Activity" mode.
>
> This fixes the issue where the pca9538 GPIO/interrupt controller (which
> can't mask interrupts in HW) received too many interrupts and after a
> time started ignoring the interrupt with error message:
>   IRQ 71: nobody cared
>
> There is a work in progress to have the Marvell PHY driver support
> parsing PHY LED nodes from OF and registering the LEDs as Linux LED
> class devices. Once this is done the PHY driver can also automatically
> set the pin into INTn mode if it does not find LED[2] in OF.
>
> Until then, though, we fix this via `marvell,reg-init` DT property.
>
> Signed-off-by: Marek Beh=C3=BAn <kabel@kernel.org>
> Reported-by: Rui Salvaterra <rsalvaterra@gmail.com>
> Fixes: 26ca8b52d6e1 ("ARM: dts: add support for Turris Omnia")
> Cc: Uwe Kleine-K=C3=B6nig <uwe@kleine-koenig.org>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: Gregory CLEMENT <gregory.clement@bootlin.com>
> Cc: <stable@vger.kernel.org>
>
> ---
>
> This patch fixes bug introduced with the commit that added Turris
> Omnia's DTS (26ca8b52d6e1), but will not apply cleanly because there is
> commit 8ee4a5f4f40d which changed node name and node compatible
> property and this commit did not go into stable.
>
> So either commit 8ee4a5f4f40d has also to go into stable before this, or
> this patch has to be fixed a little in order to apply to 4.14+.
>
> Please let me know how should I handle this.
>
> ---
>  arch/arm/boot/dts/armada-385-turris-omnia.dts | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/arch/arm/boot/dts/armada-385-turris-omnia.dts b/arch/arm/boo=
t/dts/armada-385-turris-omnia.dts
> index 646a06420c77..b0f3fd8e1429 100644
> --- a/arch/arm/boot/dts/armada-385-turris-omnia.dts
> +++ b/arch/arm/boot/dts/armada-385-turris-omnia.dts
> @@ -389,6 +389,7 @@ &mdio {
>         phy1: ethernet-phy@1 {
>                 compatible =3D "ethernet-phy-ieee802.3-c22";
>                 reg =3D <1>;
> +               marvell,reg-init =3D <3 18 0 0x4985>;
>
>                 /* irq is connected to &pcawan pin 7 */
>         };
> --
> 2.26.2
>

This does seem to fix the problem on my Omnia. Feel free to add my

Tested-by: Rui Salvaterra <rsalvaterra@gmail.com>

Thanks,
Rui
