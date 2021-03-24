Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25E1C34856D
	for <lists+stable@lfdr.de>; Thu, 25 Mar 2021 00:41:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232019AbhCXXk3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Mar 2021 19:40:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:36748 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239049AbhCXXj7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Mar 2021 19:39:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5EF2061A26;
        Wed, 24 Mar 2021 23:39:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616629198;
        bh=EimFBW3SCXo0+WwU4jzLeQWKMLbyziufk9GU5wuitos=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RO0K49SE3550+F4GgLw+ScpoFl/tuklH6AFLxgywLtqs9ZO97HmtyDyId6lONX9Lc
         TUQRM+8wFCrPXtLDey2pIU4oBaPimpvwu7bjc00rDbGG/08aI8zw4IAhjYfZdsZGOR
         wmEdohfcvwWRMYeq7ASkK6Ztyny5/7LbeOSYH4bepDt+ln4uw43D+6iXqkHfPGB3DC
         2SgQsQIzVSjpHu9bWz15gPWxjO1OQCWD1173TT9m/FrKPefmpzn07MsJSUMpWIYNL6
         X883yUmU+1+z6mIP0EiIoaDGX0OrDmh/bdozmYa76vWqvSut8pLiOxnfCFrQZfjvC5
         5EhKB7xMoTtEg==
From:   Mark Brown <broonie@kernel.org>
To:     Hans de Goede <hdegoede@redhat.com>,
        Cezary Rojewski <cezary.rojewski@intel.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Jie Yang <yang.jie@linux.intel.com>
Cc:     Mark Brown <broonie@kernel.org>, stable@vger.kernel.org,
        alsa-devel@alsa-project.org
Subject: Re: [PATCH 1/2] ASoC: intel: atom: Stop advertising non working S24LE support
Date:   Wed, 24 Mar 2021 23:39:37 +0000
Message-Id: <161662872373.51441.3814240028664055092.b4-ty@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210309105520.9185-1-hdegoede@redhat.com>
References: <20210309105520.9185-1-hdegoede@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 9 Mar 2021 11:55:19 +0100, Hans de Goede wrote:
> The SST firmware's media and deep-buffer inputs are hardcoded to
> S16LE, the corresponding DAIs don't have a hw_params callback and
> their prepare callback also does not take the format into account.
> 
> So far the advertising of non working S24LE support has not caused
> issues because pulseaudio defaults to S16LE, but changing pulse-audio's
> config to use S24LE will result in broken sound.
> 
> [...]

Applied to

   https://git.kernel.org/pub/scm/linux/kernel/git/broonie/sound.git for-next

Thanks!

[1/2] ASoC: intel: atom: Stop advertising non working S24LE support
      commit: aa65bacdb70e549a81de03ec72338e1047842883
[2/2] ASoC: intel: atom: Remove 44100 sample-rate from the media and deep-buffer DAI descriptions
      commit: 632aeebe1b7a3a8b193d71942a10e66919bebfb8

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
