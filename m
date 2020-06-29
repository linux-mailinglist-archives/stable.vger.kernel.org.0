Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5938720D861
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 22:09:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731893AbgF2Tim (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 15:38:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:46388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728107AbgF2Til (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 15:38:41 -0400
Received: from localhost (fw-tnat.cambridge.arm.com [217.140.96.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6B80820672;
        Mon, 29 Jun 2020 19:38:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593459520;
        bh=MaMLRdKGA2R2MLXvl0tCL0oYxq7/CID2IPMt3BqbmhY=;
        h=Date:From:To:Cc:In-Reply-To:References:Subject:From;
        b=oFJae37Oikbrw1fa9XojJE82yyto8cL5rTai2NSwGIglgFtrvCmTPEvvQCA3WsgIL
         OjV3YO0MAYMBmM0mjbF3vKCu06Hv6SG+GVcLWFh4LiT3ys9yeGz+cEof3I2MeXHA9m
         JzhdKmqC4ATM44tVtTUKGJdxc2xry/SHE0bdwTO8=
Date:   Mon, 29 Jun 2020 20:38:38 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Liam Girdwood <liam.r.girdwood@linux.intel.com>,
        Cezary Rojewski <cezary.rojewski@intel.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Jie Yang <yang.jie@linux.intel.com>,
        Oder Chiou <oder_chiou@realtek.com>
Cc:     stable@vger.kernel.org, alsa-devel@alsa-project.org
In-Reply-To: <20200628155231.71089-2-hdegoede@redhat.com>
References: <20200628155231.71089-1-hdegoede@redhat.com> <20200628155231.71089-2-hdegoede@redhat.com>
Subject: Re: [PATCH 1/6] ASoC: Intel: cht_bsw_rt5672: Change bus format to I2S 2 channel
Message-Id: <159345951863.3333.2806987177417509858.b4-ty@kernel.org>
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

[1/4] ASoC: Intel: cht_bsw_rt5672: Change bus format to I2S 2 channel
      commit: 0ceb8a36d023d4bb4ffca3474a452fb1dfaa0ef2
[2/4] ASoC: rt5670: Correct RT5670_LDO_SEL_MASK
      commit: 5cacc6f5764e94fa753b2c1f5f7f1f3f74286e82
[3/4] ASoC: rt5670: Add new gpio1_is_ext_spk_en quirk and enable it on the Lenovo Miix 2 10
      commit: 85ca6b17e2bb96b19caac3b02c003d670b66de96
[4/4] ASoC: rt5670: Fix dac- and adc- vol-tlv values being off by a factor of 10
      commit: 3f31f7d9b5404a10648abe536c8b408bfb4502e1

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
