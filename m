Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D33F667C198
	for <lists+stable@lfdr.de>; Thu, 26 Jan 2023 01:29:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229602AbjAZA3F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Jan 2023 19:29:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230423AbjAZA3C (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 Jan 2023 19:29:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D3A85142D;
        Wed, 25 Jan 2023 16:28:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 47F19B81C69;
        Thu, 26 Jan 2023 00:28:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED5B2C4339C;
        Thu, 26 Jan 2023 00:28:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674692933;
        bh=gubbhzGaviSeApE3IdtZWRMvA0UHhr8l5Bb71wx7pHE=;
        h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
        b=tuIKNqm4mU2Li0CLx3FjM1AU7UJSU4+yfdyi0iYXnnatFEF1v57rvOic1GS2TLqk/
         5kuA0L8CiRqoJr61ikJLH11e/0Pjf087rVIsL9X+zCgsoEErlmwTW6ryrKNN11l+2f
         yu2kdJwnbMx6s/W6nIQ7Qw03SP1GkTCGh7/CxEpu+wPFmIBGaaS/FwMN/4yjNzq3jF
         kXkHwnfTJGwG1hTaUTw7RYsqJFeq6rZO9m9iDcrhjJT9BFhhMcSzzcEdOOnCspfrFt
         Qluy9+VnBfG9N5jPTin0UNkY16poI0H+otWEjcTlsvmpBa9ilrmxueMwQt3dfhIx/B
         9JwUuYGlhGYRg==
From:   Mark Brown <broonie@kernel.org>
To:     Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Banajit Goswami <bgoswami@quicinc.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     stable@vger.kernel.org
In-Reply-To: <20230124123049.285395-1-krzysztof.kozlowski@linaro.org>
References: <20230124123049.285395-1-krzysztof.kozlowski@linaro.org>
Subject: Re: [PATCH] ASoC: codecs: wsa883x: correct playback min/max rates
Message-Id: <167469293063.2696228.862026813738827424.b4-ty@kernel.org>
Date:   Thu, 26 Jan 2023 00:28:50 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.12.0
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 24 Jan 2023 13:30:49 +0100, Krzysztof Kozlowski wrote:
> Correct reversed values used in min/max rates, leading to incorrect
> playback constraints.
> 
> 

Applied to

   broonie/sound.git for-next

Thanks!

[1/1] ASoC: codecs: wsa883x: correct playback min/max rates
      commit: 100c94ffde489ee11e23400f2a07b236144b048f

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

