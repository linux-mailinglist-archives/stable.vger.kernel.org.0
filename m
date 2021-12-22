Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF19D47D35A
	for <lists+stable@lfdr.de>; Wed, 22 Dec 2021 15:04:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245576AbhLVOEy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Dec 2021 09:04:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237349AbhLVOEw (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Dec 2021 09:04:52 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1465C061574;
        Wed, 22 Dec 2021 06:04:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AE38DB81CBC;
        Wed, 22 Dec 2021 14:04:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EE26C36AE5;
        Wed, 22 Dec 2021 14:04:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640181889;
        bh=GpuaFsWoFLVuvfhOa8Znb8zkvhgTeFHuqoMq8n5e/SQ=;
        h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
        b=d0MLLI/QtJJ+B2X932VWsR6XYGD2gMUA7IhzUovdfrHvUBvHzT8va1pyjdB5OM5kD
         Gzm0lV0cbqLxEd7nnAfqfUelPmifBKp5jjEjFNHW29QIpABMqqVqMIxdc2tbKKxEWC
         hYVjWbaA/rpXz+QJq5+mCIjBY/IBYnSGIxm82htQZWOra5TMwaCTlpfE4wwGbZ6zYL
         Tl5lVjwBKsB2gfBOmrNRKSZcxJUOOfQFNSrAvp/Wv10EdPF8AvhS5fwRy7TCNCGpJi
         epc1Dmc+LJL/1rQqZ9UyvGjfPUek5IjGz0Pao1Rtd7aP6yJ+/dn/mvyru7Cg0E/VGM
         1DcxWCQECqwIA==
From:   Mark Brown <broonie@kernel.org>
To:     Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
Cc:     stable@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Masami Hiramatsu <mhiramat@kernel.org>,
        linux-spi@vger.kernel.org,
        Keiji Hayashibara <hayashibara.keiji@socionext.com>
In-Reply-To: <1640148492-32178-1-git-send-email-hayashi.kunihiko@socionext.com>
References: <1640148492-32178-1-git-send-email-hayashi.kunihiko@socionext.com>
Subject: Re: [PATCH] spi: uniphier: Fix a bug that doesn't point to private data correctly
Message-Id: <164018188784.2906151.4009933677547937001.b4-ty@kernel.org>
Date:   Wed, 22 Dec 2021 14:04:47 +0000
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
      commit: 80bb73a9fbcde4ecc55e12f10c73fabbe68a24d1

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
