Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC99F2616E7
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 19:22:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731836AbgIHRV6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 13:21:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:57162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726694AbgIHRV5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Sep 2020 13:21:57 -0400
Received: from localhost (fw-tnat.cambridge.arm.com [217.140.96.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8321E206B5;
        Tue,  8 Sep 2020 17:21:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599585717;
        bh=Gzymf03QZheR0rew1DGzIq4ZxNN09MkNkW/PUkupiCs=;
        h=Date:From:To:Cc:In-Reply-To:References:Subject:From;
        b=hBlFCGvWNlYoIili+fAT+BAHvvkNeiySEFqKt+wzNdniqoH7NDLQp1Lzk62eO6cNt
         yVQGQj6zdyDJq1KsECcf8mPUwo0WiXO2hT2iQgatu/PhxqBwELKJVlAc3QWfAcl9bB
         HFKGE1nxCrPMAqCH6vN+fBomMO37QMGbUrR3+a0o=
Date:   Tue, 08 Sep 2020 18:21:13 +0100
From:   Mark Brown <broonie@kernel.org>
To:     linux-arm-kernel@lists.infradead.org,
        Masahisa Kojima <masahisa.kojima@linaro.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        linux-rpi-kernel@lists.infradead.org,
        Baolin Wang <baolin.wang7@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-kernel@vger.kernel.org,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Tudor Ambarus <tudor.ambarus@microchip.com>,
        linux-tegra@vger.kernel.org, Andy Gross <agross@kernel.org>,
        Scott Branden <sbranden@broadcom.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        linux-spi@vger.kernel.org, Orson Zhai <orsonzhai@gmail.com>,
        Ludovic Desroches <ludovic.desroches@microchip.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        linux-arm-msm@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com, Ray Jui <rjui@broadcom.com>,
        Nicolas Saenz Julienne <nsaenzjulienne@suse.de>,
        Chunyan Zhang <zhang.lyra@gmail.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>
Cc:     stable@vger.kernel.org
In-Reply-To: <20200901152713.18629-1-krzk@kernel.org>
References: <20200901152713.18629-1-krzk@kernel.org>
Subject: Re: [PATCH 01/11] spi: sprd: Release DMA channel also on probe deferral
Message-Id: <159958565716.16771.12447755739031265902.b4-ty@kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 1 Sep 2020 17:27:03 +0200, Krzysztof Kozlowski wrote:
> If dma_request_chan() for TX channel fails with EPROBE_DEFER, the RX
> channel would not be released and on next re-probe it would be requested
> second time.

Applied to

   https://git.kernel.org/pub/scm/linux/kernel/git/broonie/spi.git for-next

Thanks!

[01/11] spi: sprd: Release DMA channel also on probe deferral
        commit: 687a2e76186dcfa42f22c14b655c3fb159839e79
[02/11] spi: sprd: Simplify with dev_err_probe()
        (no commit info)
[03/11] spi: atmel: Simplify with dev_err_probe()
        commit: 96189475820835d7176171492640a58c600aca42
[04/11] spi: bcm2835: Simplify with dev_err_probe()
        commit: 65acd82c4eb7f08747922ed3afb2d099a1b25d3f
[05/11] spi: cadence-quadspi: Simplify with dev_err_probe()
        commit: 436a5c208037a71f64f35312969e27a05d6d7c53
[06/11] spi: spi-mux: Simplify with dev_err_probe()
        commit: 2d9bdf645584d15ed1d4aae6204cb6ea8b673d48
[07/11] spi: qcom-qspi: Simplify with dev_err_probe()
        commit: 034532681c56cfffaea169a59155fe11e9172d9c
[08/11] spi: stm32: Simplify with dev_err_probe()
        commit: a05cec2dc2df1e5d25addb7aba398f3eb451e163
[09/11] spi: synquacer: Simplify with dev_err_probe()
        commit: 74ee6dc1257edf5fcfba67fd8075b766d11c42a0
[10/11] spi: tegra114: Simplify with dev_err_probe()
        commit: 68fffc191ed19ea5618285b128e6048d1536e680
[11/11] spi: tegra20: Simplify with dev_err_probe()
        commit: 7708aff1e2ebc8fdccdd61cf9ab8576a66989166

All being well this means that it will be integrated into the linux-next
tree (usually sometime in the next 24 hours) and sent to Linus during
the next merge window (or sooner if it is a bug fix), however if
problems are discovered then the patch may be dropped or reverted.

You may get further e-mails resulting from automated or manual testing
and review of the tree, please engage with people reporting problems and
send followup patches addressing any issues that are reported if needed.

If any updates are required or you are submitting further changes they
should be sent as incremental updates against current git, existing
patches will not be replaced.

Please add any relevant lists and maintainers to the CCs when replying
to this mail.

Thanks,
Mark
