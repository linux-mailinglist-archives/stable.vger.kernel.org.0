Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 329AA2C8A17
	for <lists+stable@lfdr.de>; Mon, 30 Nov 2020 17:57:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729065AbgK3Q5M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Nov 2020 11:57:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:34702 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729054AbgK3Q5K (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 30 Nov 2020 11:57:10 -0500
Received: from localhost (fw-tnat.cambridge.arm.com [217.140.96.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2ADDD207FF;
        Mon, 30 Nov 2020 16:56:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606755389;
        bh=Ln6tKHVqYwgyYnlAD/TpM6pTq44rPqJWJHhf4PojvBA=;
        h=Date:From:To:Cc:In-Reply-To:References:Subject:From;
        b=1q3sCPPZXtMt0F+ickBbyJAWwwwMr0SVioJNqJDKysRyNPknnPKBHRF0nPdMwBUnN
         djivFBgsfPZNSgbvgnYx8N9BAIBSI8JUEdTrnTP+NCHwbQtSC8fQ42fo6a8Z5mBjca
         jLuQhlwUHWCXDqk1V/ZoKeutRtexJ7uauNBIQeyc=
Date:   Mon, 30 Nov 2020 16:56:01 +0000
From:   Mark Brown <broonie@kernel.org>
To:     Rasmus Villemoes <rasmus.villemoes@prevas.dk>,
        linux-spi@vger.kernel.org
Cc:     Christophe Leroy <christophe.leroy@c-s.fr>, stable@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-kernel@vger.kernel.org
In-Reply-To: <20201127152947.376-1-rasmus.villemoes@prevas.dk>
References: <20201127152947.376-1-rasmus.villemoes@prevas.dk>
Subject: Re: [PATCH] spi: fsl: fix use of spisel_boot signal on MPC8309
Message-Id: <160675536158.30617.2427992198440401553.b4-ty@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 27 Nov 2020 16:29:47 +0100, Rasmus Villemoes wrote:
> Commit 0f0581b24bd0 ("spi: fsl: Convert to use CS GPIO descriptors")
> broke the use of the SPISEL_BOOT signal as a chip select on the
> MPC8309.
> 
> pdata->max_chipselect, which becomes master->num_chipselect, must be
> initialized to take into account the possibility that there's one more
> chip select in use than the number of GPIO chip selects.

Applied to

   https://git.kernel.org/pub/scm/linux/kernel/git/broonie/spi.git for-next

Thanks!

[1/1] spi: fsl: fix use of spisel_boot signal on MPC8309
      commit: 122541f2b10897b08f7f7e6db5f1eb693e51f0a1

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
