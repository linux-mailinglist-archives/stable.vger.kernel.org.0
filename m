Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FADC23A9E4
	for <lists+stable@lfdr.de>; Mon,  3 Aug 2020 17:52:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726942AbgHCPww (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Aug 2020 11:52:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:43252 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726772AbgHCPww (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Aug 2020 11:52:52 -0400
Received: from localhost (fw-tnat.cambridge.arm.com [217.140.96.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DCBC12072A;
        Mon,  3 Aug 2020 15:52:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596469971;
        bh=mQeowY8CWoF5oCIepRkpl7Z5wCiGFjMYaay4ZC1xFKc=;
        h=Date:From:To:Cc:In-Reply-To:References:Subject:From;
        b=oq1ZBmDUyZc/OPO86rY/94O3VDdxgn06WGSeZuXz5lpt74RsZIyUO1mZCQ9dUx8dm
         R+iMzBeOVcqJomoD8qVH0VRSghoZTdhLIA1qqSnoyQp/vsgNThKEFoyMqP2q+NesDi
         ANWwzVI5/CU38VBMpUPFj1OmlR1DlSufDHYCKiIs=
Date:   Mon, 03 Aug 2020 16:52:31 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Hui Wang <hui.wang@canonical.com>, alsa-devel@alsa-project.org,
        Vijendar.Mukunda@amd.com
Cc:     stable@vger.kernel.org
In-Reply-To: <20200730075020.15667-1-hui.wang@canonical.com>
References: <20200730075020.15667-1-hui.wang@canonical.com>
Subject: Re: [PATCH] ASoC: amd: renoir: restore two more registers during resume
Message-Id: <159646994087.2524.11753685481726603724.b4-ty@kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 30 Jul 2020 15:50:20 +0800, Hui Wang wrote:
> Recently we found an issue about the suspend and resume. If dmic is
> recording the sound, and we run suspend and resume, after the resume,
> the dmic can't work well anymore. we need to close the app and reopen
> the app, then the dmic could record the sound again.
> 
> For example, we run "arecord -D hw:CARD=acp,DEV=0 -f S32_LE -c 2
> -r 48000 test.wav", then suspend and resume, after the system resume
> back, we speak to the dmic. then stop the arecord, use aplay to play
> the test.wav, we could hear the sound recorded after resume is weird,
> it is not what we speak to the dmic.
> 
> [...]

Applied to

   https://git.kernel.org/pub/scm/linux/kernel/git/broonie/sound.git for-next

Thanks!

[1/1] ASoC: amd: renoir: restore two more registers during resume
      commit: ccff7bd468d5e0595176656a051ef67c01f01968

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
