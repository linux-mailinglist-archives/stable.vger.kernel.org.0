Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA9A82979FC
	for <lists+stable@lfdr.de>; Sat, 24 Oct 2020 02:29:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1759018AbgJXA3K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Oct 2020 20:29:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:42340 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756447AbgJXA3K (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 23 Oct 2020 20:29:10 -0400
Received: from localhost (cpc102338-sgyl38-2-0-cust404.18-2.cable.virginm.net [77.102.33.149])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5BD42223EA;
        Sat, 24 Oct 2020 00:29:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603499349;
        bh=zfimlyBy7JEtPZjy/CuXm+eSPqDJs5sU0y4ieMN/Z3g=;
        h=Date:From:To:Cc:In-Reply-To:References:Subject:From;
        b=xcK0oNK5NCsH0KeLEAKdJqCLlymmK4uR6NPQLk26LCjwWgUzFpgg9krOau33iiuj6
         bPIZfJ2f2GAz7bSV1liD0jhdrABbDwnuQZvmj8bhiMTDkfDn+st9NxI7Wf6/cncnlc
         e/34mFKkNF1DTLlLWoYXwnaLFFH39AGrS4nlyByI=
Date:   Sat, 24 Oct 2020 01:29:07 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Sascha Hauer <s.hauer@pengutronix.de>, linux-spi@vger.kernel.org
Cc:     kernel@pengutronix.de, stable@vger.kernel.org,
        Christian Eggers <ceggers@arri.de>
In-Reply-To: <20201021104513.21560-1-s.hauer@pengutronix.de>
References: <20201021104513.21560-1-s.hauer@pengutronix.de>
Subject: Re: [PATCH] spi: imx: fix runtime pm support for !CONFIG_PM
Message-Id: <160349934785.28519.1780967767109665800.b4-ty@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 21 Oct 2020 12:45:13 +0200, Sascha Hauer wrote:
> 525c9e5a32bd introduced pm_runtime support for the i.MX SPI driver. With
> this pm_runtime is used to bring up the clocks initially. When CONFIG_PM
> is disabled the clocks are no longer enabled and the driver doesn't work
> anymore. Fix this by enabling the clocks in the probe function and
> telling pm_runtime that the device is active using
> pm_runtime_set_active().

Applied to

   https://git.kernel.org/pub/scm/linux/kernel/git/broonie/spi.git for-next

Thanks!

[1/1] spi: imx: fix runtime pm support for !CONFIG_PM
      commit: 43b6bf406cd0319e522638f97c9086b7beebaeaa

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
