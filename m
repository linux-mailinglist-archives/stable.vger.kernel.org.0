Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F28B42A3C37
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 06:53:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725968AbgKCFxa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 00:53:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725953AbgKCFx3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Nov 2020 00:53:29 -0500
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 747DBC0617A6;
        Mon,  2 Nov 2020 21:53:29 -0800 (PST)
Received: by mail-ed1-x541.google.com with SMTP id a71so11633709edf.9;
        Mon, 02 Nov 2020 21:53:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mbxSfoSmP856zGHTji+nbwksNv1J/cgE4QrDKUz3wMU=;
        b=pEKAMK9h4oND5JtBLHzwr/fUGb2DM09YmSHv3ArjvKMG9vaS0nm2LuK1Zob+ogPTyM
         C3V+TPBbmwtFHLfHM6/qTxkkMN4bXr210KplfSXPAIDr1MtJPlvj0FHAPPmTl4M/ml6n
         fTlLOYI9Kbx3H0V9JnADqFQcVo556nLvo517cWhoBWc88B/cLRTPPkQeBdiaX0vgBPse
         pz5uA1zkrGuYtVyZn0kMhScGoRYI4GYLo03trae98B+R2p25XqtfwXGywMGGhjnGqbHq
         YwuuL2ihpcy8FXxQjOe8md3UZqBVc4dVV8E8FTtbPXcCeglAIvY2zq0S/pAlJJoQ7mZc
         fh7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mbxSfoSmP856zGHTji+nbwksNv1J/cgE4QrDKUz3wMU=;
        b=fFKvnruVSrbIqguCUk33DcW1YM3C7B9mVLj+JvR8kFFzaChG0UBabCoDIXZhRgehPi
         nfQQ2bPoUau9KGdxjiCbXTDyZvDGz2Mil8jEEL/LKIPoql7ituKbUAHJP9+Z7ffUMVVS
         MUBLXjh13Yt9bb7oOQTdIXnj/J8j00PSWV5TO0KZ9GwMBB1dLxSNTrbMHoMAFaqQfUn2
         aZzK2kbXpZY3SO59rhuTP2BIEWp8m7qMVTGoBoJVatGBW3+3lmNKWdr7MazTaW7CZyTX
         6iG5A3DXi5UbYHnAzv+0lJp7+4yLQqPS/rnm7lrVDmIHWWIFVdKiXsA9GzP/Gul5N9Co
         UoBQ==
X-Gm-Message-State: AOAM5315Ukqs3EeYlprbh93QtBJ+D9n/h1Gs0X0jp5GxYzrIerUM314n
        GccZf3wVz8QRxd7ywLFcSwrCSezGbplb267W3/o=
X-Google-Smtp-Source: ABdhPJy5sXxaVPqPLCAlm8CNwM3kf6fo5mZgVh3EF7GepdVE9byq/HTWl0sU+0PF/k7PfOQLgL/x4TJgK1+G2QcJEkA=
X-Received: by 2002:aa7:cb0f:: with SMTP id s15mr16272969edt.338.1604382808165;
 Mon, 02 Nov 2020 21:53:28 -0800 (PST)
MIME-Version: 1.0
References: <20201103012007.183429-1-sashal@kernel.org> <20201103012007.183429-5-sashal@kernel.org>
In-Reply-To: <20201103012007.183429-5-sashal@kernel.org>
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date:   Tue, 3 Nov 2020 06:53:17 +0100
Message-ID: <CAFBinCCZiO9Xe1WKT8MZ-90c7m1u_m1Mt-OXf=Pyuo0vukQQ5g@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 5.4 05/24] arm64: dts: amlogic: meson-g12: use the
 G12A specific dwmac compatible
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Neil Armstrong <narmstrong@baylibre.com>,
        Kevin Hilman <khilman@baylibre.com>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-amlogic@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Sasha,

On Tue, Nov 3, 2020 at 2:20 AM Sasha Levin <sashal@kernel.org> wrote:
>
> From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
>
> [ Upstream commit 1fdc97ae450ede2b4911d6737a57e6fca63b5f4a ]
>
> We have a dedicated "amlogic,meson-g12a-dwmac" compatible string for the
> Ethernet controller since commit 3efdb92426bf4 ("dt-bindings: net:
> dwmac-meson: Add a compatible string for G12A onwards").
> Using the AXG compatible string worked fine so far because the
> dwmac-meson8b driver doesn't handle the newly introduced register bits
> for G12A. However, once that changes the driver must be probed with the
> correct compatible string to manage these new register bits.
>
> Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
> Reviewed-by: Neil Armstrong <narmstrong@baylibre.com>
> Signed-off-by: Kevin Hilman <khilman@baylibre.com>
> Link: https://lore.kernel.org/r/20200925211743.537496-1-martin.blumenstingl@googlemail.com
> Signed-off-by: Sasha Levin <sashal@kernel.org>
if this patch will be included in 5.4-stable then please also backport
the following two commits:
- 3efdb92426bf4 ("dt-bindings: net: dwmac-meson: Add a compatible
string for G12A onwards")
- a4f63342d03d2d ("net: stmmac: dwmac-meson8b: add a compatible string
for G12A SoCs")

Without these above two commits we'll lose Ethernet connectivity
because there's no G12A compatible string in 5.4 yet

The quick solution would be to not backport this patch because the
driver in question doesn't do anything with the new compatible string
yet.


Best regards,
Martin
