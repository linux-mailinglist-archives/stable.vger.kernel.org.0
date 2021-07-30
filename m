Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EE793DBEA9
	for <lists+stable@lfdr.de>; Fri, 30 Jul 2021 21:03:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230402AbhG3TEC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Jul 2021 15:04:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:45152 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231134AbhG3TD7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 30 Jul 2021 15:03:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 53FC460F4B;
        Fri, 30 Jul 2021 19:03:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627671834;
        bh=TY2LPGRIJuK2iU0iLZqPl0A+ea1bC5iQxu9ZtLUwNlw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cAcpwMVK0WZxSzC/hvdozHI94g7pHd8cCU+eJpe3BmeEKpvAwr5XJcKgk2SLwXKDk
         x84uuNJOiSv/HMBlNsIoF67uoO/COILvG8jPr8dVCCE6ac99CQ66DNaNIaEkbtV9OK
         8ZtT/SQJSfXdCo2gN+vv7QR4nOGvfwTBtoYoeqTEhbfiCjU7c+Vn0foSzmMx8BCULk
         Ge35HQkqjzm8XHSdxH5yrjSxlL+4VG5eHqydhge61hrydNmUPwNvE6sp11/ZhP+Qda
         jwNoMc0hTXqfNQubKC4CgPy9ZLjjcHYCxGQYyg6+yNuR+CfRSvbJqrdqwG7QW61yDr
         I8H2Yck5IqvEg==
From:   Mark Brown <broonie@kernel.org>
To:     Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org
Cc:     Mark Brown <broonie@kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH 1/5] ASoC: amd: Fix reference to PCM buffer address
Date:   Fri, 30 Jul 2021 20:03:35 +0100
Message-Id: <162767143673.56427.5656341194627198116.b4-ty@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210728112353.6675-2-tiwai@suse.de>
References: <20210728112353.6675-1-tiwai@suse.de> <20210728112353.6675-2-tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 28 Jul 2021 13:23:49 +0200, Takashi Iwai wrote:
> PCM buffers might be allocated dynamically when the buffer
> preallocation failed or a larger buffer is requested, and it's not
> guaranteed that substream->dma_buffer points to the actually used
> buffer.  The driver needs to refer to substream->runtime->dma_addr
> instead for the buffer address.

Applied to

   https://git.kernel.org/pub/scm/linux/kernel/git/broonie/sound.git for-next

Thanks!

[1/5] ASoC: amd: Fix reference to PCM buffer address
      (no commit info)
[2/5] ASoC: intel: atom: Fix reference to PCM buffer address
      commit: 2e6b836312a477d647a7920b56810a5a25f6c856
[3/5] ASoC: xilinx: Fix reference to PCM buffer address
      commit: 42bc62c9f1d3d4880bdc27acb5ab4784209bb0b0
[4/5] ASoC: uniphier: Fix reference to PCM buffer address
      commit: 827f3164aaa579eee6fd50c6654861d54f282a11
[5/5] ASoC: kirkwood: Fix reference to PCM buffer address
      commit: bb6a40fc5a830cae45ddd5cd6cfa151b008522ed

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
