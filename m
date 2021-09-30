Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B066841DCDE
	for <lists+stable@lfdr.de>; Thu, 30 Sep 2021 17:00:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352099AbhI3PCE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Sep 2021 11:02:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:47282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352060AbhI3PBx (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Sep 2021 11:01:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 70CA761A0D;
        Thu, 30 Sep 2021 15:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633014011;
        bh=P3IGvvfLtkYj4sQhVrqizbpeSgN1EKz8MdB6rfmt6VQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uGEBZQcPA1PNmoM+56SzDE1q3OpwENvSX5Q/9eIZu2S7AMG6XA40Srrg5gID6QiTt
         OynBfCZgpxIoUDTxgbMTxnNo0rEqGJjPedWnkMx8jRhTuOYRxgjK+zMMAVqpxPVsZ3
         Y+A3N1PPfBDPzw9unYytOBSLaovrigbowEjugEiG5zLGoMIK12EN7S1t51pfY8Hqkc
         9PFx0qNK9jJavWUD8oG04fthopLSSvPGQFYfhEj8aX3nnogqiiO1zLs41zizFs+C8W
         cKx5dhLOGhJT68/5/xawMntFVV39kZfXapwLJQnaRqv0Qc5Ns6NWoNlzOBDxcaFVq3
         jdeqW5kDR9SzQ==
From:   Mark Brown <broonie@kernel.org>
To:     Liam Girdwood <lgirdwood@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>
Cc:     Mark Brown <broonie@kernel.org>, alsa-devel@alsa-project.org,
        stable@vger.kernel.org
Subject: Re: [PATCH regression fix] ASoC: nau8824: Fix headphone vs headset, button-press detection no longer working
Date:   Thu, 30 Sep 2021 15:58:57 +0100
Message-Id: <163301248178.43045.235876482448408566.b4-ty@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210929201512.460360-1-hdegoede@redhat.com>
References: <20210929201512.460360-1-hdegoede@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 29 Sep 2021 22:15:12 +0200, Hans de Goede wrote:
> Commit 1d25684e2251 ("ASoC: nau8824: Fix open coded prefix handling")
> replaced the nau8824_dapm_enable_pin() helper with direct calls to
> snd_soc_dapm_enable_pin(), but the helper was using
> snd_soc_dapm_force_enable_pin() and not forcing the MICBIAS + SAR
> supplies on breaks headphone vs headset and button-press detection.
> 
> Replace the snd_soc_dapm_enable_pin() calls with
> snd_soc_dapm_force_enable_pin() to fix this.
> 
> [...]

Applied to

   https://git.kernel.org/pub/scm/linux/kernel/git/broonie/sound.git for-next

Thanks!

[1/1] ASoC: nau8824: Fix headphone vs headset, button-press detection no longer working
      commit: 42871e95a3afea8956d8cc567ea725b33a837775

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
