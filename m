Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7415F2995B2
	for <lists+stable@lfdr.de>; Mon, 26 Oct 2020 19:49:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1790302AbgJZStf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Oct 2020 14:49:35 -0400
Received: from mail-ej1-f65.google.com ([209.85.218.65]:39580 "EHLO
        mail-ej1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1781539AbgJZStf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Oct 2020 14:49:35 -0400
Received: by mail-ej1-f65.google.com with SMTP id qh17so15175770ejb.6;
        Mon, 26 Oct 2020 11:49:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=GQIBSJiUpItQVV47yS1O2MQNglVHqWwEsW9rriz9+2s=;
        b=HHkIxe/K05VHpQRb5kV5ejVS8d+eeS8BdOMOAjplhL2y8YEkpo/AaJ+hcW8VyzKeri
         8hdb+5l6PJeTZTwTNYnjpk0ZzUXbgeP0B8Laf6qNHDwZRvXdo1CRrWbwJs6hmQ5uPwos
         tNHjHZsRQLbBFYeUPd1392qqEErM5DIbpX+a5K6sBwkTrA5zMZvXGXiGqYYtKponcKOV
         kchuaUTXRXHEXFixW9KoIkafodKM8LVfDWO4syZVJYazqorp3xEprSG2RbpDjkWcXDjs
         WGyPeYi3mUNbGfXWcBmo9iiwETkSS0uqp+Uv6kcpqcMTmoyEksnpsny7hJPg9oRpnKxx
         XPGg==
X-Gm-Message-State: AOAM5312cdTyrRiVpyNRYnyErnQ7eezLuqNLEuKYUvE2i1mz5GLUWyh+
        d2MwHD1AOlNxmX1Bzybf2Jk=
X-Google-Smtp-Source: ABdhPJwOmnNgqqXfhoWUZtOX0kQ9uwTzdA7KAzX2gr6XGD2bhmdURQiU1gHOx6komaExHxtSMJO5gg==
X-Received: by 2002:a17:906:ce5a:: with SMTP id se26mr16580149ejb.106.1603738173688;
        Mon, 26 Oct 2020 11:49:33 -0700 (PDT)
Received: from kozik-lap ([194.230.155.184])
        by smtp.googlemail.com with ESMTPSA id ce13sm5822601edb.32.2020.10.26.11.49.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2020 11:49:32 -0700 (PDT)
Date:   Mon, 26 Oct 2020 19:49:30 +0100
From:   Krzysztof Kozlowski <krzk@kernel.org>
To:     Rob Herring <robh+dt@kernel.org>, Kukjin Kim <kgene@kernel.org>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Marek Szyprowski <m.szyprowski@samsung.com>,
        Gabriel Ribba Esteva <gabriel.ribbae@gmail.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH 1/4] ARM: dts: exynos: fix roles of USB 3.0 ports on
 Odroid XU
Message-ID: <20201026184930.GD165725@kozik-lap>
References: <20201015182044.480562-1-krzk@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201015182044.480562-1-krzk@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 15, 2020 at 08:20:41PM +0200, Krzysztof Kozlowski wrote:
> On Odroid XU board the USB3-0 port is a microUSB and USB3-1 port is USB
> type A (host).  The roles were copied from Odroid XU3 (Exynos5422)
> design which has it reversed.
> 
> Fixes: 8149afe4dbf9 ("ARM: dts: exynos: Add initial support for Odroid XU board")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
> ---
>  arch/arm/boot/dts/exynos5410-odroidxu.dts | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Applied all four, with Gabriel's tested-by tag.

Best regards,
Krzysztof
