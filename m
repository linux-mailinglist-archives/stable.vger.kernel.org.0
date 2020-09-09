Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF4F72636B5
	for <lists+stable@lfdr.de>; Wed,  9 Sep 2020 21:39:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726399AbgIITja (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Sep 2020 15:39:30 -0400
Received: from mail-ej1-f66.google.com ([209.85.218.66]:45309 "EHLO
        mail-ej1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726408AbgIITj3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Sep 2020 15:39:29 -0400
Received: by mail-ej1-f66.google.com with SMTP id i26so5219340ejb.12;
        Wed, 09 Sep 2020 12:39:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=e4W6DmWRzbF1Vd8vLdjGFrgnjV3JprnSzUpFxxJ4Qz8=;
        b=hca7fnTr6A05P37+hRLn4FLgbfNpOEH9SVeTAO3JBXFK87iaO5cZ7eSPjivGaGPp8B
         vYrL0Ae82SvoU/sPlLD0kKcfp9N/XLiKntpz3uFGawyLvWDDy79pkx+i51ywg28bj5mf
         WkO3qsa7ii8hnP5tg2R9aFk7KnzM4t1ZvpsLHsX7WDybNqP1ndzsJtvtoWgUaNJ43c0s
         QtYrTEb4mJynaROnfw8y9jYZ15iC8SXgOU1fin2FniLyT2FmmwvS5jvNVGEHk5052Ovl
         nlGqcrysAeZb1hzJhYs416XVYDbQ+70TD/YvN/BUUfS00O+5Y3aZeYnmjThA7vXLN60I
         pEDA==
X-Gm-Message-State: AOAM533rAifCKkXacL3SDF+w6KVAZG961xe4uDqbLNcIjJNApHrvKykq
        oG0tr8XiqQyprxw5TEUHM+E=
X-Google-Smtp-Source: ABdhPJxixDeCW1Z3OsaBG7M1oqZj7nTiVh0oOIPSFhZbxejJRsXvA2jBaOVpm1yhSXmYr62rBGpPAQ==
X-Received: by 2002:a17:906:69d5:: with SMTP id g21mr4991420ejs.461.1599680364795;
        Wed, 09 Sep 2020 12:39:24 -0700 (PDT)
Received: from kozik-lap ([194.230.155.174])
        by smtp.googlemail.com with ESMTPSA id rn4sm3605279ejb.43.2020.09.09.12.39.22
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 09 Sep 2020 12:39:24 -0700 (PDT)
Date:   Wed, 9 Sep 2020 21:39:21 +0200
From:   Krzysztof Kozlowski <krzk@kernel.org>
To:     Kukjin Kim <kgene@kernel.org>, Rob Herring <robh+dt@kernel.org>,
        Jonathan Cameron <jic23@kernel.org>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Peter Meerwald-Stadler <pmeerw@pmeerw.net>,
        Jonathan Bakker <xc-racer2@live.ca>,
        =?utf-8?B?UGF3ZcWC?= Chmiel <pawel.mikolaj.chmiel@gmail.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 04/25] ARM: dts: s5pv210: fix pinctrl property of
 "vibrator-en" regulator in Aries
Message-ID: <20200909193921.GB21431@kozik-lap>
References: <20200907161141.31034-1-krzk@kernel.org>
 <20200907161141.31034-5-krzk@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200907161141.31034-5-krzk@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 07, 2020 at 06:11:20PM +0200, Krzysztof Kozlowski wrote:
> Fix typo in pinctrl property of "vibrator-en" fixed regulator in Aries
> family of boards.  The error caused lack of pin configuration for the
> GPIO used in vibrator.
> 
> Fixes: 04568cb58a43 ("ARM: dts: s5pv210: Disable pull for vibrator enable GPIO on Aries boards")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
> ---
>  arch/arm/boot/dts/s5pv210-aries.dtsi | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Applied 4-8.

Thanks Jonathan for testing.

Best regards,
Krzysztof
