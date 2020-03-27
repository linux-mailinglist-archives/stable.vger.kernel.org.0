Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A631F195715
	for <lists+stable@lfdr.de>; Fri, 27 Mar 2020 13:28:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727125AbgC0M2d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Mar 2020 08:28:33 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:35700 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727115AbgC0M2d (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 Mar 2020 08:28:33 -0400
Received: by mail-ed1-f65.google.com with SMTP id a20so10893385edj.2;
        Fri, 27 Mar 2020 05:28:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=PgAzbs+aBW5+w0uP4I/irYOZdFxy1JgNoFDb63WsShQ=;
        b=rM8mPNvCRkPONqmqdOYz6rTEOVT8lpgfnN0BqLYFePU7HAqYvYAEbC1E8k4clfvC6i
         kZsiGFObYe0S/qcpl5k308oHoBZe+ustRQ/fYJWOGsjTckn0fKhXT8858orL9HkXoqN4
         1Uh1HG9eVBWGeblo9t82rp/xH0zouRXsFC+kESg7xHIwez8hNUBVsfD2KsHFH92VoYqs
         R/R2g0sxl/m/Iazv6oqYB9Vzu35d37difAopA89+XL1x5mkqxzRt5cw2adpxiHBdWTI4
         hIeJfZ5gRF1kpG9acA9kUX0fInfL9NUNIWFlAlLW7WXbln95jbLLi5LWmfMSCwz8Eu5p
         oH3Q==
X-Gm-Message-State: ANhLgQ0TPDva7U3zs3E91cziuGanmV+3uyk3Q2aeNjWY2QjvV6pMJef4
        qrn852VhqvmYVueFu2UlMEk=
X-Google-Smtp-Source: ADFU+vsCHvofpuiv7htgtNWNiK1WxSHJPJwjKg2k65ooH8I4fUF5mGcVNpdlu5pgkBQxAvEOSy79bQ==
X-Received: by 2002:a05:6402:705:: with SMTP id w5mr13218258edx.288.1585312111110;
        Fri, 27 Mar 2020 05:28:31 -0700 (PDT)
Received: from kozik-lap ([194.230.155.125])
        by smtp.googlemail.com with ESMTPSA id i23sm27707edr.54.2020.03.27.05.28.29
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 27 Mar 2020 05:28:30 -0700 (PDT)
Date:   Fri, 27 Mar 2020 13:28:28 +0100
From:   Krzysztof Kozlowski <krzk@kernel.org>
To:     Marek Szyprowski <m.szyprowski@samsung.com>
Cc:     linux-samsung-soc@vger.kernel.org,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Simon Shields <simon@lineageos.org>, stable@vger.kernel.org
Subject: Re: [PATCH] ARM: dts: exynos: Fix GPIO polarity for thr GalaxyS3
 CM36651 sensor's bus
Message-ID: <20200327122828.GF7233@kozik-lap>
References: <CGME20200326142048eucas1p29aee56575f8b530fc2d83860f6185d6b@eucas1p2.samsung.com>
 <20200326142037.20418-1-m.szyprowski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200326142037.20418-1-m.szyprowski@samsung.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 26, 2020 at 03:20:37PM +0100, Marek Szyprowski wrote:
> GPIO lines for the CM36651 sensor I2C bus use the normal not the inverted
> polarity. This bug has been there since adding the CM36651 sensor by
> commit 85cb4e0bd2294, but went unnoticed because the "i2c-gpio" driver
> ignored the GPIO polarity specified in the device-tree.
> 
> The recent conversion of "i2c-gpio" driver to the new, descriptor based
> GPIO API, automatically made it the DT-specified polarity aware, what
> broke the CM36651 sensor operation.
> 
> Fixes: c769eaf7a85d ("ARM: dts: exynos: Split Trats2 DTS in preparation for Midas boards")
> Fixes: c10d3290cbde ("ARM: dts: Use GPIO constants for flags cells in exynos4412 boards")
> Fixes: 85cb4e0bd229 ("ARM: dts: add cm36651 light/proximity sensor node for exynos4412-trats2")

Thanks, applied. I kept only last Fixes as this is the original error.
All later were just refactorings of the same bug.

Best regards,
Krzysztof

