Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0999A2DC376
	for <lists+stable@lfdr.de>; Wed, 16 Dec 2020 16:54:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725957AbgLPPxu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Dec 2020 10:53:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:46008 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725812AbgLPPxu (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Dec 2020 10:53:50 -0500
From:   Mark Brown <broonie@kernel.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org, Thomas Hebb <tommyhebb@gmail.com>
Cc:     alsa-devel@alsa-project.org, Takashi Iwai <tiwai@suse.com>,
        Liam Girdwood <lgirdwood@gmail.com>, stable@vger.kernel.org
In-Reply-To: <f8b5f031d50122bf1a9bfc9cae046badf4a7a31a.1607822410.git.tommyhebb@gmail.com>
References: <f8b5f031d50122bf1a9bfc9cae046badf4a7a31a.1607822410.git.tommyhebb@gmail.com>
Subject: Re: [PATCH] ASoC: dapm: remove widget from dirty list on free
Message-Id: <160813397774.31838.3814954649059477238.b4-ty@kernel.org>
Date:   Wed, 16 Dec 2020 15:52:57 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, 12 Dec 2020 17:20:12 -0800, Thomas Hebb wrote:
> A widget's "dirty" list_head, much like its "list" list_head, eventually
> chains back to a list_head on the snd_soc_card itself. This means that
> the list can stick around even after the widget (or all widgets) have
> been freed. Currently, however, widgets that are in the dirty list when
> freed remain there, corrupting the entire list and leading to memory
> errors and undefined behavior when the list is next accessed or
> modified.
> 
> [...]

Applied to

   https://git.kernel.org/pub/scm/linux/kernel/git/broonie/sound.git for-next

Thanks!

[1/1] ASoC: dapm: remove widget from dirty list on free
      commit: 5c6679b5cb120f07652418524ab186ac47680b49

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
