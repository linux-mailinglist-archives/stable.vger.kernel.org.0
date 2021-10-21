Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19480436105
	for <lists+stable@lfdr.de>; Thu, 21 Oct 2021 14:04:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230463AbhJUMGk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Oct 2021 08:06:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230231AbhJUMGj (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 Oct 2021 08:06:39 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03F5FC06161C
        for <stable@vger.kernel.org>; Thu, 21 Oct 2021 05:04:24 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id m22so827375wrb.0
        for <stable@vger.kernel.org>; Thu, 21 Oct 2021 05:04:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=ALaF5bcRuLL8d8keCANGTQfz6z7fdsJXQrN1DNjYf74=;
        b=a0WzIsBTTCoMPZrFWgDMsvwuRE2bVLyaswCIdbcszH9T/7FFZeeEXemVYZy/bl6g2i
         rPskyWTQebZ1HVLFYS5K0KsnXweIFiYHFgOsMBrYJYGG6H+/LbEmKh6JAt3mY18OwlCj
         TDOsU9A/oYMUGxx3+LEMwPkMg4tYmd0GoxPfhnmTI/0BkRI7XmyKvPAfcJ88AkRJACSe
         ZfK4Sq4chU6g5I3RArx8dY6TNcnIBpbcU8uNu+CQ1NT9p7V634xDwQNOo9pR0IpGtIwq
         oyRcYbKl35GR0dhZ1ALA3+n3qob0lkWOXf43tWfNoqx4BP/C1o+YXa9pHJfpk9zqtnp0
         B1QQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=ALaF5bcRuLL8d8keCANGTQfz6z7fdsJXQrN1DNjYf74=;
        b=tzFXjc7/i+pexbJ8h54k4qvZnyrHK0tDNIJZdErqugwkQ0UoO0LcU9yioJq1/3RhaZ
         zkC7tjRe0uF4BBhLuJc3PcgOULAORAJv2O6QsrwXuC4Gq23Wlajuxp/Zsmtw0VMj2Efw
         XXSWzZpTmf1zRWoqo2Nw7H7pZ8YIxT7Z0UoWGZnIY1M3MHEpHb74OXPS3IYy9VUTGDKa
         h4+3pyR99UQrsQHPUAbxdeI5WmdabOI0qlXOiN7dRxe/dwft1k1KpLeSVA7v+x6vClLS
         HTAn9XoEEhgyZ58A0ZJeq8HLpv9bmEy9yWEyKfVyOh6tVHxv692j16nJEZ3FDmlWcIhO
         HTTQ==
X-Gm-Message-State: AOAM533cKOd6eKFdus0uIAxkdS4e5L2pzpxhf9BW0GBrTmAc43BaGT+p
        +Tua8FCIEf0wAy4OmsV9jJu4Iy0co4s2Mw==
X-Google-Smtp-Source: ABdhPJyBZahsnpxwYvLV/qR3VP4yIiJian3RTLdz5eQQ0EYiT9CXl2QlXtPceZtwyk65zpgvnq9kng==
X-Received: by 2002:adf:e292:: with SMTP id v18mr6487110wri.369.1634817862441;
        Thu, 21 Oct 2021 05:04:22 -0700 (PDT)
Received: from google.com ([95.148.6.207])
        by smtp.gmail.com with ESMTPSA id p18sm5370734wmq.4.2021.10.21.05.04.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Oct 2021 05:04:22 -0700 (PDT)
Date:   Thu, 21 Oct 2021 13:04:20 +0100
From:   Lee Jones <lee.jones@linaro.org>
To:     Noralf =?iso-8859-1?Q?Tr=F8nnes?= <noralf@tronnes.org>
Cc:     linux-kernel@vger.kernel.org, Jack Andersen <jackoalan@gmail.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH] mfd: dln2: Add cell for initializing DLN2 ADC
Message-ID: <YXFXRE1Pwl7U1a7g@google.com>
References: <20211018112541.25466-1-noralf@tronnes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211018112541.25466-1-noralf@tronnes.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 18 Oct 2021, Noralf Trønnes wrote:

> From: Jack Andersen <jackoalan@gmail.com>
> 
> This patch extends the DLN2 driver; adding cell for adc_dln2 module.
> 
> The original patch[1] fell through the cracks when the driver was added
> so ADC has never actually been usable. That patch did not have ACPI
> support which was added in v5.9, so the oldest supported version this
> current patch can be backported to is 5.10.
> 
> [1] https://www.spinics.net/lists/linux-iio/msg33975.html
> 
> Cc: <stable@vger.kernel.org> # 5.10+
> Signed-off-by: Jack Andersen <jackoalan@gmail.com>
> Signed-off-by: Noralf Trønnes <noralf@tronnes.org>
> ---
>  drivers/mfd/dln2.c | 18 ++++++++++++++++++
>  1 file changed, 18 insertions(+)

Applied, thanks.

-- 
Lee Jones [李琼斯]
Senior Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog
