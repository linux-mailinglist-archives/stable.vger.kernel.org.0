Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61142213DEE
	for <lists+stable@lfdr.de>; Fri,  3 Jul 2020 19:04:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726874AbgGCRDg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jul 2020 13:03:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:33144 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726747AbgGCRDg (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 3 Jul 2020 13:03:36 -0400
Received: from localhost (fw-tnat.cambridge.arm.com [217.140.96.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7396820870;
        Fri,  3 Jul 2020 17:03:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593795816;
        bh=WgkvmGtlUl6Eo7CF4+ocruAMNgDPflJpM8Ax/aFh0l0=;
        h=Date:From:To:Cc:In-Reply-To:References:Subject:From;
        b=uxD548lJoPyX2Qis0noGWhZOcW53hnPY1DW1Vw423r8hl6OD1VXTB4gA9TnrgqyZ4
         /LQyGHmBMwkjp+r+IJUESWr1GI/5zcnMCia9lf/ebSpoNpKZWS0e2YIxn/TyW5t7u3
         dhROD7HSMUVRYGcRxnZHcUHK1Ztpjt7iwUItC0qg=
Date:   Fri, 03 Jul 2020 18:03:33 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Liam Girdwood <liam.r.girdwood@linux.intel.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Cezary Rojewski <cezary.rojewski@intel.com>,
        Oder Chiou <oder_chiou@realtek.com>,
        Jie Yang <yang.jie@linux.intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Cc:     alsa-devel@alsa-project.org, stable@vger.kernel.org
In-Reply-To: <20200628155231.71089-2-hdegoede@redhat.com>
References: <20200628155231.71089-1-hdegoede@redhat.com> <20200628155231.71089-2-hdegoede@redhat.com>
Subject: Re: [PATCH 1/6] ASoC: Intel: cht_bsw_rt5672: Change bus format to I2S 2 channel
Message-Id: <159379581380.55795.15728838678765550745.b4-ty@kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, 28 Jun 2020 17:52:26 +0200, Hans de Goede wrote:
> The default mode for SSP configuration is TDM 4 slot and so far we were
> using this for the bus format on cht-bsw-rt56732 boards.
> 
> One board, the Lenovo Miix 2 10 uses not 1 but 2 codecs connected to SSP2.
> The second piggy-backed, output-only codec is inside the keyboard-dock
> (which has extra speakers). Unlike the main rt5672 codec, we cannot
> configure this codec, it is hard coded to use 2 channel 24 bit I2S.
> 
> [...]

Applied to

   https://git.kernel.org/pub/scm/linux/kernel/git/broonie/sound.git for-next

Thanks!

[1/2] ASoC: rt5670: Remove struct rt5670_platform_data
      commit: c14f61a89c1335f95d9b37624ee157fb1fd424ee
[2/2] ASoC: rt5670: Rename dev_gpio to gpio1_is_irq
      commit: 883330c11fa6dca55e30f8612398b3e0abc51dc5

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
