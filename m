Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39A1349CEAE
	for <lists+stable@lfdr.de>; Wed, 26 Jan 2022 16:36:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242955AbiAZPgx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Jan 2022 10:36:53 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:53998 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235900AbiAZPgw (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Jan 2022 10:36:52 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 878ED61900;
        Wed, 26 Jan 2022 15:36:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87CF3C340E6;
        Wed, 26 Jan 2022 15:36:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643211412;
        bh=ET0k10DsnVM5FmCnwUkZOPhrA755rJdBFIyVpMWTFKI=;
        h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
        b=B3LiQeo3ymMdhFiayR2cDkSYoitYx/Z2Pwfl9O99uBFb+o66Fj9vSJiMcKIzww+fG
         kirHhqubbdRdFoaVvorzAqjFlP0iAJ8qXl1Tdp2q41o0UJbBgGUJ0Mruz6FfRgnhkR
         R8BcCNyr37rDvxin2sowx4dq41mc7jDgyIatZNskm2k+rXsdxr7wNWPWcbVJnIZokp
         qiAJX8mrAoBr/vERWbLKlgtqVmkG2FX6TW1sXY6SXFNe1HeVvMEp3++KQ9IQo/QEIm
         ztqh/yEszmgfUpv9p8NF7ts4CRMRCt8mvZRSjsjwVbZbP70LzubM7mvprodM26jUql
         sQ2+Je1YsbMwQ==
From:   Mark Brown <broonie@kernel.org>
To:     Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
Cc:     linux-spi@vger.kernel.org,
        Keiji Hayashibara <hayashibara.keiji@socionext.com>,
        linux-kernel@vger.kernel.org,
        Masami Hiramatsu <mhiramat@kernel.org>,
        linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org
In-Reply-To: <1640148492-32178-1-git-send-email-hayashi.kunihiko@socionext.com>
References: <1640148492-32178-1-git-send-email-hayashi.kunihiko@socionext.com>
Subject: Re: [PATCH] spi: uniphier: Fix a bug that doesn't point to private data correctly
Message-Id: <164321141026.490397.11451995975683431974.b4-ty@kernel.org>
Date:   Wed, 26 Jan 2022 15:36:50 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 22 Dec 2021 13:48:12 +0900, Kunihiko Hayashi wrote:
> In uniphier_spi_remove(), there is a wrong code to get private data from
> the platform device, so the driver can't be removed properly.
> 
> The driver should get spi_master from the platform device and retrieve
> the private data from it.
> 
> 
> [...]

Applied to

   https://git.kernel.org/pub/scm/linux/kernel/git/broonie/spi.git for-linus

Thanks!

[1/1] spi: uniphier: Fix a bug that doesn't point to private data correctly
      commit: 23e3404de1aecc62c14ac96d4b63403c3e0f52d5

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
