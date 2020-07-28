Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0040230F51
	for <lists+stable@lfdr.de>; Tue, 28 Jul 2020 18:32:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731383AbgG1Qbw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jul 2020 12:31:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:47546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731450AbgG1Qbw (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jul 2020 12:31:52 -0400
Received: from localhost (fw-tnat.cambridge.arm.com [217.140.96.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5247C207FC;
        Tue, 28 Jul 2020 16:31:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595953912;
        bh=P4Av0vatTuW3dIpD4sg/Elju5zXKvaEg+tC7WacAyII=;
        h=Date:From:To:Cc:In-Reply-To:References:Subject:From;
        b=dmimmK7qJ2DIMxYDyJpSgAwS4DQSzCGUmBQ1eIpG62ANy/wbC5Jb/8LpVCpHt136e
         CVLkSpLEA3uSzZrWDs++9rOt+EIx3nZmH/L+GNRdrWyuDXQYARNwKwKr04XKIItMJ7
         tx7xRHlFSQaE6NZKWYVftUydj7+qaLmMEiDtdNGc=
Date:   Tue, 28 Jul 2020 17:31:33 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Christian Eggers <ceggers@arri.de>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        linux-spi@vger.kernel.org
In-Reply-To: <20200728100832.24788-1-ceggers@arri.de>
References: <20200728100832.24788-1-ceggers@arri.de>
Subject: Re: [PATCH] spi: spidev: Align buffers for DMA
Message-Id: <159595388006.15302.11430995371603179380.b4-ty@kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 28 Jul 2020 12:08:32 +0200, Christian Eggers wrote:
> Simply copying all xfers from userspace into one bounce buffer causes
> alignment problems if the SPI controller uses DMA.
> 
> Ensure that all transfer data blocks within the rx and tx bounce buffers
> are aligned for DMA (according to ARCH_KMALLOC_MINALIGN).
> 
> Alignment may increase the usage of the bounce buffers. In some cases,
> the buffers may need to be increased using the "bufsiz" module
> parameter.

Applied to

   https://git.kernel.org/pub/scm/linux/kernel/git/broonie/spi.git for-next

Thanks!

[1/1] spi: spidev: Align buffers for DMA
      commit: aa9e862d7d5bcecd4dca9f39e8b684b93dd84ee7

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
