Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5DD51FF2D9
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 15:18:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728049AbgFRNSN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Jun 2020 09:18:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:40878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728677AbgFRNSF (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 18 Jun 2020 09:18:05 -0400
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 21F452082F;
        Thu, 18 Jun 2020 13:18:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592486283;
        bh=r+svTNjiGuXkIc5TL7bKksU/+xmdE0WLkg7AhS5a8Vs=;
        h=Date:From:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:From;
        b=1dVMhvmIO38fIPe07lJ9KVf5ig5XvJL+7FH1mog+5nT/J3UZrJS713l1bHKXSfZfF
         a1C8/fiiNfzWNbZt+PFLzEuGe455kyjOladDu//nKae0riQLM7Cg3zal2elkMLp2BL
         OCy7VSEE70ndzdZ6hdNOO/uu+/fD0lOcVs0wapBY=
Date:   Thu, 18 Jun 2020 13:18:02 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Krzysztof Kozlowski <krzk@kernel.org>
To:     Mark Brown <broonie@kernel.org>
Cc:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     <stable@vger.kernel.org>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH v3 1/2] spi: spi-fsl-dspi: Fix external abort on interrupt in resume or exit paths
In-Reply-To: <1592300467-29196-1-git-send-email-krzk@kernel.org>
References: <1592300467-29196-1-git-send-email-krzk@kernel.org>
Message-Id: <20200618131803.21F452082F@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag
fixing commit: 349ad66c0ab0 ("spi:Add Freescale DSPI driver for Vybrid VF610 platform").

The bot has tested the following trees: v5.7.2, v5.4.46, v4.19.128, v4.14.184, v4.9.227, v4.4.227.

v5.7.2: Build OK!
v5.4.46: Build OK!
v4.19.128: Failed to apply! Possible dependencies:
    06d5dd29976fb ("spi: spi-fsl-dspi: Change usage pattern of SPI_MCR_* and SPI_CTAR_* macros")
    13aed23927414 ("spi: spi-fsl-dspi: use IRQF_SHARED mode to request IRQ")
    3a11ea664be6f ("spi: spi-fsl-dspi: Replace legacy spi_master names with spi_controller")
    50fcd84764fcb ("spi: spi-fsl-dspi: Fix code alignment")
    5ce3cc5674718 ("spi: spi-fsl-dspi: Provide support for DSPI slave mode operation (Vybryd vf610)")
    aa54c1c9d90e6 ("spi: fix initial SPI_SR value in spi-fsl-dspi")
    b2655196cf9ce ("spi: spi-fsl-dspi: Use BIT() and GENMASK() macros")

v4.14.184: Failed to apply! Possible dependencies:
    00ac9562158e8 ("spi: spi-fsl-dspi: add SPI_LSB_FIRST to driver capabilities")
    0a4ec2c158634 ("spi: spi-fsl-dspi: Simplify transfer counter handling")
    3a11ea664be6f ("spi: spi-fsl-dspi: Replace legacy spi_master names with spi_controller")
    3e7cc6252dc81 ("spi: spi-fsl-dspi: Enable extended SPI mode")
    4779f23d1ac86 ("spi: spi-fsl-dspi: Drop unneeded use of dataflags bits")
    50fcd84764fcb ("spi: spi-fsl-dspi: Fix code alignment")
    51d583ae7792c ("spi: spi-fsl-dspi: Framesize control for XSPI mode")
    58ba07ec79e62 ("spi: spi-fsl-dspi: Add support for XSPI mode registers")
    5ce3cc5674718 ("spi: spi-fsl-dspi: Provide support for DSPI slave mode operation (Vybryd vf610)")
    8570043e2cc65 ("spi: spi-fsl-dspi: Fixup regmap configuration")
    9e1dc9bd09936 ("spi: spi-fsl-dspi: Fix per transfer cs_change handling")
    aa54c1c9d90e6 ("spi: fix initial SPI_SR value in spi-fsl-dspi")
    c87bdcc89d867 ("spi: spi-fsl-dspi: Drop unreachable else if statement")
    d87e08f142137 ("spi: spi-fsl-dspi: Fix MCR register handling")
    dadcf4abd60ba ("spi: spi-fsl-dspi: Support 4 to 16 bits per word transfers")
    ec7ed7708e009 ("spi: spi-fsl-dspi: enabling Coldfire mcf5441x dspi")

v4.9.227: Failed to apply! Possible dependencies:
    1eaccf210c59e ("spi: spi-fsl-dspi: Fix incorrect DMA setup")
    3a11ea664be6f ("spi: spi-fsl-dspi: Replace legacy spi_master names with spi_controller")
    3e7cc6252dc81 ("spi: spi-fsl-dspi: Enable extended SPI mode")
    4779f23d1ac86 ("spi: spi-fsl-dspi: Drop unneeded use of dataflags bits")
    50fcd84764fcb ("spi: spi-fsl-dspi: Fix code alignment")
    51d583ae7792c ("spi: spi-fsl-dspi: Framesize control for XSPI mode")
    58ba07ec79e62 ("spi: spi-fsl-dspi: Add support for XSPI mode registers")
    90ba37033cb94 ("spi: spi-fsl-dspi: Add DMA support for Vybrid")
    9e1dc9bd09936 ("spi: spi-fsl-dspi: Fix per transfer cs_change handling")
    aa54c1c9d90e6 ("spi: fix initial SPI_SR value in spi-fsl-dspi")
    c87bdcc89d867 ("spi: spi-fsl-dspi: Drop unreachable else if statement")
    ccf7d8ee3d6eb ("spi: spi-fsl-dspi: Fix continuous selection format")
    d87e08f142137 ("spi: spi-fsl-dspi: Fix MCR register handling")
    dadcf4abd60ba ("spi: spi-fsl-dspi: Support 4 to 16 bits per word transfers")

v4.4.227: Failed to apply! Possible dependencies:
    1eaccf210c59e ("spi: spi-fsl-dspi: Fix incorrect DMA setup")
    3a11ea664be6f ("spi: spi-fsl-dspi: Replace legacy spi_master names with spi_controller")
    3e7cc6252dc81 ("spi: spi-fsl-dspi: Enable extended SPI mode")
    4779f23d1ac86 ("spi: spi-fsl-dspi: Drop unneeded use of dataflags bits")
    50fcd84764fcb ("spi: spi-fsl-dspi: Fix code alignment")
    51d583ae7792c ("spi: spi-fsl-dspi: Framesize control for XSPI mode")
    58ba07ec79e62 ("spi: spi-fsl-dspi: Add support for XSPI mode registers")
    5ee67b587a2b0 ("spi: dspi: clear SPI_SR before enable interrupt")
    90ba37033cb94 ("spi: spi-fsl-dspi: Add DMA support for Vybrid")
    92dc20d83adec ("spi: spi-fsl-dspi: Fix cs_change handling in message transfer")
    9419b2006cf47 ("spi: fsl-dspi: Set max_speed_hz for master")
    94b968b5a3e28 ("spi: spi-fsl-dspi: constify devtype_data")
    9e1dc9bd09936 ("spi: spi-fsl-dspi: Fix per transfer cs_change handling")
    aa54c1c9d90e6 ("spi: fix initial SPI_SR value in spi-fsl-dspi")
    c87bdcc89d867 ("spi: spi-fsl-dspi: Drop unreachable else if statement")
    ccf7d8ee3d6eb ("spi: spi-fsl-dspi: Fix continuous selection format")
    d87e08f142137 ("spi: spi-fsl-dspi: Fix MCR register handling")
    dadcf4abd60ba ("spi: spi-fsl-dspi: Support 4 to 16 bits per word transfers")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
