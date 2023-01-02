Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E93A065AC91
	for <lists+stable@lfdr.de>; Mon,  2 Jan 2023 01:07:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229488AbjABAHD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 1 Jan 2023 19:07:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbjABAHC (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 1 Jan 2023 19:07:02 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C94225EC;
        Sun,  1 Jan 2023 16:07:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2B1FD60B8B;
        Mon,  2 Jan 2023 00:07:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D77E3C433D2;
        Mon,  2 Jan 2023 00:06:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672618019;
        bh=jlPeJZeQYZ4yIPjGo8SjrONFcNbow4lvs25CiRF5HWg=;
        h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
        b=oRy4qR28cMs92DmL+zYulpiGpTOpXBm7+Ke1kGRHlrd8NhcGesQgqxjcr4ACTmFl7
         gTFhpLk/kCPBq9UpiJu2n2gfbkebsV6SCqA+ozRr1/Moyzeg3r2g1vlR8l2jLBAyTf
         K902C7NG+0rQ6oqoSW1Sc7uilD0DF841clUJCMKH5EkxsaOGLDRWiX7MqrFmFQsuZk
         mfa0ZnxbQuSrN/yFZMcXTIuzJokxVU1Mb5tRiBl8Uj6rmrX6dXabspo7UlN/KpbD68
         utzMtTOXj0LO62yUss2RmumVspbFdCZC0OHD75lzt7XXMj/Z4vcxpCyW/Qsorw3mFk
         k2vmbzuRRkPeg==
From:   Mark Brown <broonie@kernel.org>
To:     Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Banajit Goswami <bgoswami@quicinc.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Brian Norris <computersforpeace@gmail.com>
Cc:     alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
In-Reply-To: <20221231061545.2110253-1-computersforpeace@gmail.com>
References: <20221231061545.2110253-1-computersforpeace@gmail.com>
Subject: Re: [PATCH] ASoC: qcom: lpass-cpu: Fix fallback SD line index handling
Message-Id: <167261801758.166157.11703189928077074093.b4-ty@kernel.org>
Date:   Mon, 02 Jan 2023 00:06:57 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.12-dev-69c4d
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 30 Dec 2022 22:15:45 -0800, Brian Norris wrote:
> These indices should reference the ID placed within the dai_driver
> array, not the indices of the array itself.
> 
> This fixes commit 4ff028f6c108 ("ASoC: qcom: lpass-cpu: Make I2S SD
> lines configurable"), which among others, broke IPQ8064 audio
> (sound/soc/qcom/lpass-ipq806x.c) because it uses ID 4 but we'd stop
> initializing the mi2s_playback_sd_mode and mi2s_capture_sd_mode arrays
> at ID 0.
> 
> [...]

Applied to

   broonie/sound.git for-next

Thanks!

[1/1] ASoC: qcom: lpass-cpu: Fix fallback SD line index handling
      commit: 000bca8d706d1bf7cca01af75787247c5a2fdedf

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
