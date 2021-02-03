Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0633F30E4B4
	for <lists+stable@lfdr.de>; Wed,  3 Feb 2021 22:11:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232171AbhBCVJy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Feb 2021 16:09:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:36020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232222AbhBCVJs (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 3 Feb 2021 16:09:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9CED764F5F;
        Wed,  3 Feb 2021 21:09:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612386548;
        bh=vMN2ZwN3DmW+Bfkh7W+rkJVdTFGNkh40nq5AITVU4P8=;
        h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
        b=tQqrVbRzFt9pT18LzgvEPe6/P5CE8Ae0Z3ACEOW8TKlqzfPBNTcgyLtUVPf9k/ykL
         NE4HhaBzOFVwlaF59ns7/AsvJjTrn8/u3+GyLHLvW5l5zovHrnVM010fCEYgcOVoBm
         U5GhjijUkrWD1GwDHv/pyTqgTeTtaboPctvkItJT6chPDNOXIfGclCFhS8Oerhf3Sj
         0cgncTmkbb/6LG4hjq17lSuTZNh+LXvkfiQ6lGurifDMiQon/bp1rqq2sSOx4oQrsP
         oFRidxjMM9hriCcTcrRM0od+qtHis+vH3Z/bPn5Cr1u6KKlDV7GpS9bLkU4MTv/KK7
         Oe3A0SFkEwbAA==
From:   Mark Brown <broonie@kernel.org>
To:     linux-spi@vger.kernel.org, jassisinghbrar@gmail.com
Cc:     Masahisa Kojima <masahisa.kojima@linaro.org>,
        stable@vger.kernel.org, Jassi Brar <jaswinder.singh@linaro.org>
In-Reply-To: <20210201073109.9036-1-jassisinghbrar@gmail.com>
References: <20210201073109.9036-1-jassisinghbrar@gmail.com>
Subject: Re: [PATCH] spi: spi-synquacer: fix set_cs handling
Message-Id: <161238649945.34568.2886009579298697252.b4-ty@kernel.org>
Date:   Wed, 03 Feb 2021 21:08:19 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 1 Feb 2021 01:31:09 -0600, jassisinghbrar@gmail.com wrote:
> When the slave chip select is deasserted, DMSTOP bit
> must be set.

Applied to

   https://git.kernel.org/pub/scm/linux/kernel/git/broonie/spi.git for-next

Thanks!

[1/1] spi: spi-synquacer: fix set_cs handling
      commit: 1c9f1750f0305bf605ff22686fc0ac89c06deb28

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
