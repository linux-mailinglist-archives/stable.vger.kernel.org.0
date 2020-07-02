Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 838B0211C05
	for <lists+stable@lfdr.de>; Thu,  2 Jul 2020 08:36:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726578AbgGBGgV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jul 2020 02:36:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726068AbgGBGgU (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Jul 2020 02:36:20 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3670CC08C5DC
        for <stable@vger.kernel.org>; Wed,  1 Jul 2020 23:36:20 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id o11so26698644wrv.9
        for <stable@vger.kernel.org>; Wed, 01 Jul 2020 23:36:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=WIAkXvxDR/y/nxM+0UNwQaWfwsnzeh6PvfKZgXKtbTw=;
        b=CS81RrBzt27VFkR/GsGEibazwaVRMj9sOSOeup0899DQH/2qUd7r3g8cKGWdVwgMjx
         /DAH7TtjRsAuds9hnKYw3P9afxvhrpngKgLnWUXl72fY4m6kibrM8xkFpBoKePjrOtU3
         Waz8/ycDe5aZkfYsRGtn+iVYuGEBbWsiMhGKQNyoKYpJgUuPfyLOumsNNhWON/6mDtAU
         PhAacVAoDOAWe9IIThu5ftVoZU0BgDGteOuKNKB10018AZQ9tLqmTDLeWwf/OUjUPIX7
         ncTqdyI7Ca1qQQhqRkfM49aAvcFlgWdw60hIZRk2DXetJROr5LfLXUW/wIMty3EPw3pr
         g0gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=WIAkXvxDR/y/nxM+0UNwQaWfwsnzeh6PvfKZgXKtbTw=;
        b=svI3qmHA2vWBcxkg1X2Z95VajX/0DQlhgbMiYnF/ZoxWm9BF32U8WIRcro2q6LIU/4
         SnX4kJ5hFqPsITzgoYhzjeWbgM1f66uuz8HDU1cy31pTZUOaLRsIJMAIpms6vgK1042w
         soJcmTfi/3da8RLS3p8OR+foqvsi8xQqBXWhbtPRdKpBAKd3h7LerePaxi1485ls+Afh
         zy2GdzFPgDHgkt/CL7Gfo9bJwYOu/vqxjzmMR00Fhgd7NkS0xKNVElVP3MVSLDlq9Ljh
         wiC+hVecvTcjIGjLdikvveEFTa+E2k5TUQq0Lkuya4emHsHMKj21u+aLATS2ZApI34AL
         G18A==
X-Gm-Message-State: AOAM5308jkol4MLfw9ihVj9tPVl30iWDMLT5PaehQGNgDcoLoJlCKzEd
        zBeEn7J8rlMd6gopK1MoF0GA7g==
X-Google-Smtp-Source: ABdhPJzYmFnwkhCJixr68ZXq3iQtKfdKA4EJolbSrxKZLIZGLRNNNkIBKwQW4kmHQ6KC7VH+A1lxdQ==
X-Received: by 2002:a5d:464e:: with SMTP id j14mr29919342wrs.393.1593671778971;
        Wed, 01 Jul 2020 23:36:18 -0700 (PDT)
Received: from dell ([2.27.35.144])
        by smtp.gmail.com with ESMTPSA id k18sm1025428wrx.34.2020.07.01.23.36.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jul 2020 23:36:18 -0700 (PDT)
Date:   Thu, 2 Jul 2020 07:36:16 +0100
From:   Lee Jones <lee.jones@linaro.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Ludovic Desroches <ludovic.desroches@microchip.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>
Subject: Re: [PATCH 09/10] mfd: atmel-smc: Add missing colon(s) for 'conf'
 arguments
Message-ID: <20200702063616.GM1179328@dell>
References: <20200625064619.2775707-10-lee.jones@linaro.org>
 <20200701193314.8D68520853@mail.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200701193314.8D68520853@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 01 Jul 2020, Sasha Levin wrote:

> Hi
> 
> [This is an automated email]
> 
> This commit has been processed because it contains a -stable tag.
> The stable tag indicates that it's relevant for the following trees: all
> 
> The bot has tested the following trees: v5.7.6, v5.4.49, v4.19.130, v4.14.186, v4.9.228, v4.4.228.
> 
> v5.7.6: Build OK!
> v5.4.49: Build OK!
> v4.19.130: Build OK!
> v4.14.186: Build OK!
> v4.9.228: Failed to apply! Possible dependencies:
>     87108dc78eb89 ("memory: atmel-ebi: Enable the SMC clock if specified")
>     8eb8c7d844b9d ("memory: atmel-ebi: Simplify SMC config code")
>     b0f3ab20e7649 ("mfd: syscon: atmel-smc: Add helper to retrieve register layout")
>     b5169d35ed585 ("mtd: nand: atmel: return error code of nand_scan_ident/tail() on error")
>     f88fc122cc34c ("mtd: nand: Cleanup/rework the atmel_nand driver")
>     f9ce2eddf1769 ("mtd: nand: atmel: Add ->setup_data_interface() hooks")
>     fe9d7cb22ef3a ("mfd: syscon: atmel-smc: Add new helpers to ease SMC regs manipulation")
> 
> v4.4.228: Failed to apply! Possible dependencies:
>     1d8d8b5c852b6 ("mtd: nand: fix drivers abusing mtd->priv")
>     4bd4ebcc540c3 ("mtd: nand: make use of mtd_to_nand() in NAND drivers")
>     5575075612cad ("mtd: atmel_nand: Support PMECC on SAMA5D2")
>     5ddc7bd43ccc7 ("mtd: atmel_nand: Support variable RB_EDGE interrupts")
>     66e8e47eae658 ("mtd: pxa3xx_nand: Fix initial controller configuration")
>     6a4ec4cd08888 ("memory: add Atmel EBI (External Bus Interface) driver")
>     72eaec21b0cf1 ("mtd: nand: atmel_nand: constify atmel_nand_caps structures")
>     87108dc78eb89 ("memory: atmel-ebi: Enable the SMC clock if specified")
>     8eb8c7d844b9d ("memory: atmel-ebi: Simplify SMC config code")
>     b0f3ab20e7649 ("mfd: syscon: atmel-smc: Add helper to retrieve register layout")
>     c7f00c29aa846 ("mtd: pxa3xx_nand: Increase the initial chunk size")
>     cc00383722db7 ("mtd: nand: atmel: switch to mtd_ooblayout_ops")
>     d699ed250c073 ("mtd: nand: make use of nand_set/get_controller_data() helpers")
>     ee194289502a6 ("memory/atmel-ebi: Fix ns <-> cycles conversions")
>     ee4fec5f44a2c ("memory: atmel-ebi: use PTR_ERR_OR_ZERO() to simplify the code")
>     f88fc122cc34c ("mtd: nand: Cleanup/rework the atmel_nand driver")
>     fe9d7cb22ef3a ("mfd: syscon: atmel-smc: Add new helpers to ease SMC regs manipulation")
> 
> 
> NOTE: The patch will not be queued to stable trees until it is upstream.
> 
> How should we proceed with this patch?

Please drop it.

Greg indicated that these should not be bound for Stable.

-- 
Lee Jones [李琼斯]
Senior Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog
