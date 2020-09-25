Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 480D227926C
	for <lists+stable@lfdr.de>; Fri, 25 Sep 2020 22:43:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727067AbgIYUnJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Sep 2020 16:43:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:51002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726119AbgIYUnJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 25 Sep 2020 16:43:09 -0400
Received: from localhost (fw-tnat.cambridge.arm.com [217.140.96.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 424C422211;
        Fri, 25 Sep 2020 20:43:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601066588;
        bh=oPM6bYG0ziHYbXZRmN2AA5X5TBawJwfVerhBHqMHWC8=;
        h=Date:From:To:Cc:In-Reply-To:References:Subject:From;
        b=GgoN8RG8c5RxNABR8KzFMBCLLjLOKIBuYN85cL4PmfrHH1O5F8Km417yw0Mu6CU1A
         s3A4QSgBi6Y40+2k/fdF7mJN+5eam0q5d5pOBSfQDBnPIQ1rDzEe2yfvBJlkvlcRbs
         Ithol4KnaXVp9JJukk8aOKpYK/7CtakiNqW7UFbk=
Date:   Fri, 25 Sep 2020 21:42:13 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Chuanhong Guo <gch981213@gmail.com>, linux-spi@vger.kernel.org
Cc:     linux-mediatek@lists.infradead.org, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Matthias Brugger <matthias.bgg@gmail.com>,
        linux-arm-kernel@lists.infradead.org, bayi.cheng@mediatek.com
In-Reply-To: <20200922114905.2942859-1-gch981213@gmail.com>
References: <20200922114905.2942859-1-gch981213@gmail.com>
Subject: Re: [PATCH v2] spi: spi-mtk-nor: fix timeout calculation overflow
Message-Id: <160106652820.3325.17678735137859743508.b4-ty@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 22 Sep 2020 19:49:02 +0800, Chuanhong Guo wrote:
> CLK_TO_US macro is used to calculate potential transfer time for various
> timeout handling. However it overflows on transfer bigger than 512 bytes
> because it first did (len * 8 * 1000000).
> This controller typically operates at 45MHz. This patch did 2 things:
> 1. calculate clock / 1000000 first
> 2. add a 4M transfer size cap so that the final timeout in DMA reading
>    doesn't overflow

Applied to

   https://git.kernel.org/pub/scm/linux/kernel/git/broonie/spi.git for-next

Thanks!

[1/1] spi: spi-mtk-nor: fix timeout calculation overflow
      commit: 4cafaddedb5fbef9531202ee547784409fd0de33

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
