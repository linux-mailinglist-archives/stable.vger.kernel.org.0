Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D02D12AAB20
	for <lists+stable@lfdr.de>; Sun,  8 Nov 2020 14:22:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728557AbgKHNW1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Nov 2020 08:22:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:52608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728197AbgKHNWM (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 8 Nov 2020 08:22:12 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 71619206E3;
        Sun,  8 Nov 2020 13:21:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604841695;
        bh=SkSaZbbxbQKlOyOPpNzaJmiIA3JNvn8dwgGWjfjN+QE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=B4LVcidPH89nRcLhaaOqQuqZ//Xwx4z/bwAId7RogC4qHijueLwYDdlMOGsBajKnw
         ixHHmNnGau6nQGSI7eZSMZg+vvZeoN5wJIbx9j+OSjsobsDFy5NY2O/cM0kM0NRKJe
         UDvCl7vF/UFzDXD/gth7CDHwo3hiY2AO9NNQvFgE=
Date:   Sun, 8 Nov 2020 08:21:34 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Neil Armstrong <narmstrong@baylibre.com>,
        Kevin Hilman <khilman@baylibre.com>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-amlogic@lists.infradead.org
Subject: Re: [PATCH AUTOSEL 5.4 05/24] arm64: dts: amlogic: meson-g12: use
 the G12A specific dwmac compatible
Message-ID: <20201108132134.GQ2092@sasha-vm>
References: <20201103012007.183429-1-sashal@kernel.org>
 <20201103012007.183429-5-sashal@kernel.org>
 <CAFBinCCZiO9Xe1WKT8MZ-90c7m1u_m1Mt-OXf=Pyuo0vukQQ5g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAFBinCCZiO9Xe1WKT8MZ-90c7m1u_m1Mt-OXf=Pyuo0vukQQ5g@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 03, 2020 at 06:53:17AM +0100, Martin Blumenstingl wrote:
>Hi Sasha,
>
>On Tue, Nov 3, 2020 at 2:20 AM Sasha Levin <sashal@kernel.org> wrote:
>>
>> From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
>>
>> [ Upstream commit 1fdc97ae450ede2b4911d6737a57e6fca63b5f4a ]
>>
>> We have a dedicated "amlogic,meson-g12a-dwmac" compatible string for the
>> Ethernet controller since commit 3efdb92426bf4 ("dt-bindings: net:
>> dwmac-meson: Add a compatible string for G12A onwards").
>> Using the AXG compatible string worked fine so far because the
>> dwmac-meson8b driver doesn't handle the newly introduced register bits
>> for G12A. However, once that changes the driver must be probed with the
>> correct compatible string to manage these new register bits.
>>
>> Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
>> Reviewed-by: Neil Armstrong <narmstrong@baylibre.com>
>> Signed-off-by: Kevin Hilman <khilman@baylibre.com>
>> Link: https://lore.kernel.org/r/20200925211743.537496-1-martin.blumenstingl@googlemail.com
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>if this patch will be included in 5.4-stable then please also backport
>the following two commits:
>- 3efdb92426bf4 ("dt-bindings: net: dwmac-meson: Add a compatible
>string for G12A onwards")
>- a4f63342d03d2d ("net: stmmac: dwmac-meson8b: add a compatible string
>for G12A SoCs")
>
>Without these above two commits we'll lose Ethernet connectivity
>because there's no G12A compatible string in 5.4 yet
>
>The quick solution would be to not backport this patch because the
>driver in question doesn't do anything with the new compatible string
>yet.

I'll drop it from older branches that don't have those commits, thanks!

-- 
Thanks,
Sasha
