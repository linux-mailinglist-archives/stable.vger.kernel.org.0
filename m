Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2095021B7A8
	for <lists+stable@lfdr.de>; Fri, 10 Jul 2020 16:03:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728347AbgGJOCr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Jul 2020 10:02:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:49806 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727097AbgGJOCq (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 10 Jul 2020 10:02:46 -0400
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 71AA62082E;
        Fri, 10 Jul 2020 14:02:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594389765;
        bh=5Yj0QMEn6lHcJlQSk4cJzs3huqev+UWwsh2+PwNLyWk=;
        h=Date:From:To:To:To:Cc:Cc:Cc:Cc:Cc:Cc:Cc:Subject:In-Reply-To:
         References:From;
        b=0/Fjy2jnR1FAu5TAmWsD7F21cJ+Z8MyiI1bUL4NCaKan+KtmJr/oERySt9oJdz2ns
         X4sHBFFYN1oZFm6gnYdFiEBoit83aoHMcNnktjKy3uMJiOWb7tml/Xs1cfzCOGON+w
         ywzmQcDf8DuybFD5pJ4ecbSnA9PE2PqVWuuM03DQ=
Date:   Fri, 10 Jul 2020 14:02:44 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc:     <stable@vger.kernel.org>
Cc:     Nicolas Ferre <nicolas.ferre@microchip.com>
Cc:     Alexandre Belloni <alexandre.belloni@bootlin.com>
Cc:     Ludovic Desroches <ludovic.desroches@microchip.com>
Cc:     Boris Brezillon <boris.brezillon@free-electrons.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 09/10] mfd: atmel-smc: Add missing colon(s) for 'conf' arguments
In-Reply-To: <20200625064619.2775707-10-lee.jones@linaro.org>
References: <20200625064619.2775707-10-lee.jones@linaro.org>
Message-Id: <20200710140245.71AA62082E@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a -stable tag.
The stable tag indicates that it's relevant for the following trees: all

The bot has tested the following trees: v5.7.6, v5.4.49, v4.19.130, v4.14.186, v4.9.228, v4.4.228.

v5.7.6: Build OK!
v5.4.49: Build OK!
v4.19.130: Build OK!
v4.14.186: Build OK!
v4.9.228: Failed to apply! Possible dependencies:
    87108dc78eb89 ("memory: atmel-ebi: Enable the SMC clock if specified")
    8eb8c7d844b9d ("memory: atmel-ebi: Simplify SMC config code")
    b0f3ab20e7649 ("mfd: syscon: atmel-smc: Add helper to retrieve register layout")
    b5169d35ed585 ("mtd: nand: atmel: return error code of nand_scan_ident/tail() on error")
    f88fc122cc34c ("mtd: nand: Cleanup/rework the atmel_nand driver")
    f9ce2eddf1769 ("mtd: nand: atmel: Add ->setup_data_interface() hooks")
    fe9d7cb22ef3a ("mfd: syscon: atmel-smc: Add new helpers to ease SMC regs manipulation")

v4.4.228: Failed to apply! Possible dependencies:
    1d8d8b5c852b6 ("mtd: nand: fix drivers abusing mtd->priv")
    4bd4ebcc540c3 ("mtd: nand: make use of mtd_to_nand() in NAND drivers")
    5575075612cad ("mtd: atmel_nand: Support PMECC on SAMA5D2")
    5ddc7bd43ccc7 ("mtd: atmel_nand: Support variable RB_EDGE interrupts")
    66e8e47eae658 ("mtd: pxa3xx_nand: Fix initial controller configuration")
    6a4ec4cd08888 ("memory: add Atmel EBI (External Bus Interface) driver")
    72eaec21b0cf1 ("mtd: nand: atmel_nand: constify atmel_nand_caps structures")
    87108dc78eb89 ("memory: atmel-ebi: Enable the SMC clock if specified")
    8eb8c7d844b9d ("memory: atmel-ebi: Simplify SMC config code")
    b0f3ab20e7649 ("mfd: syscon: atmel-smc: Add helper to retrieve register layout")
    c7f00c29aa846 ("mtd: pxa3xx_nand: Increase the initial chunk size")
    cc00383722db7 ("mtd: nand: atmel: switch to mtd_ooblayout_ops")
    d699ed250c073 ("mtd: nand: make use of nand_set/get_controller_data() helpers")
    ee194289502a6 ("memory/atmel-ebi: Fix ns <-> cycles conversions")
    ee4fec5f44a2c ("memory: atmel-ebi: use PTR_ERR_OR_ZERO() to simplify the code")
    f88fc122cc34c ("mtd: nand: Cleanup/rework the atmel_nand driver")
    fe9d7cb22ef3a ("mfd: syscon: atmel-smc: Add new helpers to ease SMC regs manipulation")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
