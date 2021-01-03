Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 844B42E8D05
	for <lists+stable@lfdr.de>; Sun,  3 Jan 2021 17:11:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726505AbhACQLR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 3 Jan 2021 11:11:17 -0500
Received: from mail-wm1-f51.google.com ([209.85.128.51]:35517 "EHLO
        mail-wm1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726008AbhACQLR (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 3 Jan 2021 11:11:17 -0500
Received: by mail-wm1-f51.google.com with SMTP id e25so15625082wme.0;
        Sun, 03 Jan 2021 08:11:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=L/ciLi8sFKw3kDB1t38D/+A3+H6/u8IDPE39NSlBYpI=;
        b=ADM46zbgMx4p1rWMyQG08DhDtY+yxJib7Doar+FFKLo175OIS6drAIbvk0oRvxOwH/
         vEPNAyv7T/fc4GCA8o4oYGxVATn/k+2A3PHmDl458S7JlSZjVyLnd7LcU1xj6XXmm9hp
         jYaBX1Bf9s3I6mOp0ZrkzV1nAvSKKglXGGFB9b9n/7946TJGxQsC5Tb+fGh0U0GLeON/
         rU07GaM/vxwPVDsxLY8gEiTZXj74E7L6dINX8dTjRAGzF2guJPL+IV+c4X3q8OG2oSJC
         /SQwiv3EtSvTWUyWRoV6IcAKI/euuk/7LPigIm5t0v6u0rf+F3M3RF0Trur/96xaRJ8u
         mkgA==
X-Gm-Message-State: AOAM53208pphRTCtp5b2p5MDThRl5dBpBIIIrK7SXkGRtvkGgmzCwnxt
        MRuW6UjX8pG/IlI5T7WlI04=
X-Google-Smtp-Source: ABdhPJzc41yNQwH32ukm4bbyuQMc9Fj8WDh5NhtQItcsvZZNTBiwYSmi5iJAVgaXezDzVkN1gS2NcQ==
X-Received: by 2002:a1c:a9cc:: with SMTP id s195mr23495854wme.97.1609690234844;
        Sun, 03 Jan 2021 08:10:34 -0800 (PST)
Received: from kozik-lap (adsl-84-226-167-205.adslplus.ch. [84.226.167.205])
        by smtp.googlemail.com with ESMTPSA id e17sm84923543wrw.84.2021.01.03.08.10.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Jan 2021 08:10:33 -0800 (PST)
Date:   Sun, 3 Jan 2021 17:10:32 +0100
From:   Krzysztof Kozlowski <krzk@kernel.org>
To:     linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Sylwester Nawrocki <snawrocki@kernel.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Pankaj Dubey <pankaj.dubey@samsung.com>, stable@vger.kernel.org
Subject: Re: [PATCH v2 1/4] soc: samsung: exynos-asv: don't defer early on
 not-supported SoCs
Message-ID: <20210103161032.GA7799@kozik-lap>
References: <20201207190517.262051-1-krzk@kernel.org>
 <20201207190517.262051-2-krzk@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201207190517.262051-2-krzk@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 07, 2020 at 08:05:14PM +0100, Krzysztof Kozlowski wrote:
> From: Marek Szyprowski <m.szyprowski@samsung.com>
> 
> Check if the SoC is really supported before gathering the needed
> resources. This fixes endless deferred probe on some SoCs other than
> Exynos5422 (like Exynos5410).
> 
> Fixes: 5ea428595cc5 ("soc: samsung: Add Exynos Adaptive Supply Voltage driver")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
> ---
>  drivers/soc/samsung/exynos-asv.c | 10 +++++-----

Thanks, applied.

Best regards,
Krzysztof

