Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDDF2273511
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 23:41:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726498AbgIUVls (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 17:41:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:58388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726452AbgIUVls (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 17:41:48 -0400
Received: from localhost (fw-tnat.cambridge.arm.com [217.140.96.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 148B623A60;
        Mon, 21 Sep 2020 21:41:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600724507;
        bh=jju9SLxwn4Bjq7abtdJqJjPWwHxsd8XkpO610vWUqIg=;
        h=Date:From:To:Cc:In-Reply-To:References:Subject:From;
        b=VrMOy/knCTZV2eYk60oKEabmEKHp4PGyd8KckGWL0lpoTWSRD+GAhrvZyIHDGuBNt
         5gVbxn2XXb6u/5QSkwQJ9h/M8fCrJNJU/5Rj5X8/JofHGeiUI1MN6USGGpEy7iT4y/
         Lb2YE0gDCGfQOp7fauD5eS6TrJ42YzlIBDQ3JmZU=
Date:   Mon, 21 Sep 2020 22:40:55 +0100
From:   Mark Brown <broonie@kernel.org>
To:     hkallweit1@gmail.com, npiggin@gmail.com,
        Chris Packham <chris.packham@alliedtelesis.co.nz>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        linux-spi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
In-Reply-To: <20200904002812.7300-1-chris.packham@alliedtelesis.co.nz>
References: <20200904002812.7300-1-chris.packham@alliedtelesis.co.nz>
Subject: Re: [PATCH] spi: fsl-espi: Only process interrupts for expected events
Message-Id: <160072445517.57049.9668130965130008187.b4-ty@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 4 Sep 2020 12:28:12 +1200, Chris Packham wrote:
> The SPIE register contains counts for the TX FIFO so any time the irq
> handler was invoked we would attempt to process the RX/TX fifos. Use the
> SPIM value to mask the events so that we only process interrupts that
> were expected.
> 
> This was a latent issue exposed by commit 3282a3da25bd ("powerpc/64:
> Implement soft interrupt replay in C").

Applied to

   https://git.kernel.org/pub/scm/linux/kernel/git/broonie/spi.git for-next

Thanks!

[1/1] spi: fsl-espi: Only process interrupts for expected events
      commit: b867eef4cf548cd9541225aadcdcee644669b9e1

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
