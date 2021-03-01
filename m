Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 243EB329B39
	for <lists+stable@lfdr.de>; Tue,  2 Mar 2021 11:59:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240053AbhCBBSc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 20:18:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:32908 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346226AbhCAXi6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 18:38:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E87AF60200;
        Mon,  1 Mar 2021 23:38:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614641898;
        bh=Yv06/zKfXgjPnrwxD0Y8kUsnC9VsgPBi5XguS6VqNNc=;
        h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
        b=H/txClNl8pRWKV3A8KbJsrmLpi6klSikmoNajWQ35Z8OmCq1wB1uqiTBIro6At+Og
         nPetTcs5km88bFbFO9U3NLz0j+dc7J4BvNMFGUFttdPU4erx3018Aqajo1eEqvVUvg
         rgWfPHIYVS59TRBE5RFOqohcAtsQ5gIbYA/YDwueedzQGIDtYJIia55VjLO8NsZhZn
         0rXPTg1k/TR1ZU1fM76eGynv6BFkTdUK5aBvd2sn3VrTwboaEezzOtE5gP9HFoflNs
         3jqNasvg3YxDDzfq0HgWyuh4cnPgLjZ3AhPI5uZBK6fngMnHzgDRqipSRdWBuVGNA5
         FkM4YDanAvtXQ==
From:   Mark Brown <broonie@kernel.org>
To:     Robin Gong <yibin.gong@nxp.com>,
        Schrempf Frieder <frieder.schrempf@kontron.de>,
        Liam Girdwood <lgirdwood@gmail.com>
Cc:     linux-kernel@vger.kernel.org,
        Rikard Falkeborn <rikard.falkeborn@gmail.com>,
        Axel Lin <axel.lin@ingics.com>, stable@vger.kernel.org
In-Reply-To: <20210222115229.166620-1-frieder.schrempf@kontron.de>
References: <20210222115229.166620-1-frieder.schrempf@kontron.de>
Subject: Re: [PATCH v2] regulator: pca9450: Clear PRESET_EN bit to fix BUCK1/2/3 voltage setting
Message-Id: <161464183215.31485.14810671512981409540.b4-ty@kernel.org>
Date:   Mon, 01 Mar 2021 23:37:12 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 22 Feb 2021 12:52:20 +0100, Schrempf Frieder wrote:
> The driver uses the DVS registers PCA9450_REG_BUCKxOUT_DVS0 to set the
> voltage for the buck regulators 1, 2 and 3. This has no effect as the
> PRESET_EN bit is set by default and therefore the preset values are used
> instead, which are set to 850 mV.
> 
> To fix this we clear the PRESET_EN bit at time of initialization.

Applied to

   https://git.kernel.org/pub/scm/linux/kernel/git/broonie/regulator.git for-next

Thanks!

[1/1] regulator: pca9450: Clear PRESET_EN bit to fix BUCK1/2/3 voltage setting
      commit: 66f9f2d5d94f374605d829b9e690e8cdc9d0d05d

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
