Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57C0036122D
	for <lists+stable@lfdr.de>; Thu, 15 Apr 2021 20:34:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234565AbhDOSev (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Apr 2021 14:34:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:42298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234598AbhDOSev (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Apr 2021 14:34:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 280D6611CD;
        Thu, 15 Apr 2021 18:34:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618511667;
        bh=DIjc359eJQvUuEAXonYp4ayJobMO/jbmR85gSygggvg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cFf1N+RAHcgMOxD7jOIxal/ixnnS9l8SrlF482aXeUDCq6/ssN2O1HVN9d3H6l77q
         IH3i1gCkMqiix+Bpi/LuoeJ3teu0jkl/GTuDODfgUZCsFtYfRXBZ+uDb8JSDwtD5j3
         WlGqlbjoy9D8EJQcRNHOlyiyI/u5lqt6tL8mTKRQcnguBA88fhaHUOoaoE9ie7xptm
         d8zncHj/UbVZyKSVIxz3jJVUpeZrDh3xY+9ikVWKy5yLh2nbYrYxzkE2LxWtl6uB3Q
         fze2RyRxGVXNOQPexxf30iInvksiop9UOO5kzg4UU8Va9B3h6VI0nybNmCYp0yIMZ7
         kPaxQZW3hjZQg==
From:   Mark Brown <broonie@kernel.org>
To:     Lukasz Majczak <lma@semihalf.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Harsha Priya <harshapriya.n@intel.com>,
        Vamshi Krishna Gopal <vamshi.krishna.gopal@intel.com>
Cc:     Mark Brown <broonie@kernel.org>, stable@vger.kernel.org,
        alsa-devel@alsa-project.org, upstream@semihalf.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1] ASoC: Intel: kbl_da7219_max98927: Fix kabylake_ssp_fixup function
Date:   Thu, 15 Apr 2021 19:33:46 +0100
Message-Id: <161851148785.23061.12027153189842499464.b4-ty@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210415124347.475432-1-lma@semihalf.com>
References: <20210415124347.475432-1-lma@semihalf.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 15 Apr 2021 14:43:47 +0200, Lukasz Majczak wrote:
> kabylake_ssp_fixup function uses snd_soc_dpcm to identify the
> codecs DAIs. The HW parameters are changed based on the codec DAI of the
> stream. The earlier approach to get snd_soc_dpcm was using container_of()
> macro on snd_pcm_hw_params.
> 
> The structures have been modified over time and snd_soc_dpcm does not have
> snd_pcm_hw_params as a reference but as a copy. This causes the current
> driver to crash when used.
> 
> [...]

Applied to

   https://git.kernel.org/pub/scm/linux/kernel/git/broonie/sound.git for-next

Thanks!

[1/1] ASoC: Intel: kbl_da7219_max98927: Fix kabylake_ssp_fixup function
      commit: a523ef731ac6674dc07574f31bf44cc5bfa14e4d

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
