Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C938D181573
	for <lists+stable@lfdr.de>; Wed, 11 Mar 2020 11:04:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728255AbgCKKEP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Mar 2020 06:04:15 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:34869 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728245AbgCKKEO (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Mar 2020 06:04:14 -0400
Received: by mail-ed1-f67.google.com with SMTP id a20so2159942edj.2;
        Wed, 11 Mar 2020 03:04:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=tXEV6a1Ws8IvISOaUIezdbLVB68GaitP/idupt6rUWo=;
        b=bDTWoq6rqRju94sNtgK/8D2gEOSerAHLi2x1DYE4VtVYY1/uo1wyA+if47pp5FNKFt
         posGRmMOTQc5G6rgop1C39I8WpMgAE0b7eU+84BFipjqTryhrT/Rrvdab+lgG/mqe6ET
         7fYARr0g7qr5S8elYhcC50bDUDQ9wBgN6h0+poppd9WH1creUvBlUA5SGiQ5V3KtCUnG
         MchyzL/dSYTiiu1+z92m2kEx5A5q2F3UQQvGk42DSStj0ZC0OKWAscj95/5KuEdJwpUd
         mz1DPUwv7NRUL4tNJRxfbLz/5RYRuscqur0zaQG6ALfPpNVATqcnkFQl7zQCSegl8A/Y
         DrIA==
X-Gm-Message-State: ANhLgQ0Gf1KmUqcAkHw7MAb3QJPJXGi0oqN3gumrxIzagCF5RbRqgeZV
        bAuRQ0QJ4vERBuDhzSNHy2QrrH88
X-Google-Smtp-Source: ADFU+vub2vwxY6tQwSODpquvuutT2E7kmTD4yYGy4xS4Yl04fzvjGNRKQ9UWwHJ/LbfRpHiOHe+UOQ==
X-Received: by 2002:aa7:d042:: with SMTP id n2mr2013199edo.88.1583921053361;
        Wed, 11 Mar 2020 03:04:13 -0700 (PDT)
Received: from kozik-lap ([194.230.155.125])
        by smtp.googlemail.com with ESMTPSA id jt21sm3185763ejb.76.2020.03.11.03.04.12
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 11 Mar 2020 03:04:12 -0700 (PDT)
Date:   Wed, 11 Mar 2020 11:04:10 +0100
From:   Krzysztof Kozlowski <krzk@kernel.org>
To:     Marek Szyprowski <m.szyprowski@samsung.com>
Cc:     linux-samsung-soc@vger.kernel.org,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH] ARM: dts: exynos: Fix polarity of the LCD SPI bus on
 UniversalC210 board
Message-ID: <20200311100410.GA26284@kozik-lap>
References: <CGME20200304143756eucas1p1557bba245d3b9878cd2adc970e6d58f6@eucas1p1.samsung.com>
 <20200304143726.15826-1-m.szyprowski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200304143726.15826-1-m.szyprowski@samsung.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 04, 2020 at 03:37:26PM +0100, Marek Szyprowski wrote:
> Recent changes in the SPI core and the SPI-GPIO driver revealed that the
> GPIO lines for the LD9040 LCD controller on the UniversalC210 board are
> defined incorrectly. Fix the polarity for those lines to match the old
> behavior and hardware requirements to fix LCD panel operation with
> recent kernels.
> 
> CC: stable@vger.kernel.org # 5.0+

Thanks, applied (with slightly adjusted Cc-stable format, as in
documentation).

Best regards,
Krzysztof

