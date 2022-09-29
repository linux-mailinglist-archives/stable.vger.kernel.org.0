Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CC765EF876
	for <lists+stable@lfdr.de>; Thu, 29 Sep 2022 17:16:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235729AbiI2PQV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Sep 2022 11:16:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235702AbiI2PQU (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Sep 2022 11:16:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4742A14C9FB;
        Thu, 29 Sep 2022 08:16:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D67C1611E9;
        Thu, 29 Sep 2022 15:16:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F887C433D6;
        Thu, 29 Sep 2022 15:16:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664464578;
        bh=mVEW7JO/5gg4rXh1VB/iXP+N7uIZwhJ9sprNGbG8dR8=;
        h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
        b=ms21SE7B1GAZIuKbydj1TVvkdbHH24K9WjGzBPO37BM/vPYBV7sUFMIcWSyXLUxte
         MCndNlidJ523R/WRkwnVzCgShZtzLMQ8iCtawPQe60wBZrvNH48yjlG9cz7XbclF/K
         nSWYvMqIKdkluiEmNEW0Mvs8aLvXvEp4egc7Itn9KOdmCsC1DUVk5jnVOxxNmhK9xf
         4UlF4auB09qZ7HO/hoAkEb5XLM6lEP7rgXdDYBWEXqmJKn2zveKN8+nai3o8h5chaF
         chD/kVO/51/N3tgLmKhMJbWM/cZStg74nqDjb3rhb0tadd47boUXd9y8zEQP4EHfDD
         sb/HcXZjiTsjA==
From:   Mark Brown <broonie@kernel.org>
To:     Banajit Goswami <bgoswami@quicinc.com>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Takashi Iwai <tiwai@suse.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Cezary Rojewski <cezary.rojewski@intel.com>,
        Jaroslav Kysela <perex@perex.cz>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Liam Girdwood <lgirdwood@gmail.com>
Cc:     Bard Liao <yung-chuan.liao@linux.intel.com>,
        stable@vger.kernel.org,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
In-Reply-To: <20220929131528.217502-1-krzysztof.kozlowski@linaro.org>
References: <20220929131528.217502-1-krzysztof.kozlowski@linaro.org>
Subject: Re: [PATCH] ASoC: wcd-mbhc-v2: Revert "ASoC: wcd-mbhc-v2: use pm_runtime_resume_and_get()"
Message-Id: <166446457527.149592.13835062357104188946.b4-ty@kernel.org>
Date:   Thu, 29 Sep 2022 16:16:15 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailer: b4 0.10.0-dev-fc921
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 29 Sep 2022 15:15:28 +0200, Krzysztof Kozlowski wrote:
> This reverts commit ddea4bbf287b6028eaa15a185d0693856956ecf2 ("ASoC:
> wcd-mbhc-v2: use pm_runtime_resume_and_get()"), because it introduced
> double runtime PM put if pm_runtime_get_sync() returns -EACCES:
> 
>   wcd934x-codec wcd934x-codec.3.auto: WCD934X Minor:0x1 Version:0x401
>   wcd934x-codec wcd934x-codec.3.auto: Runtime PM usage count underflow!
> 
> [...]

Applied to

   https://git.kernel.org/pub/scm/linux/kernel/git/broonie/sound.git for-next

Thanks!

[1/1] ASoC: wcd-mbhc-v2: Revert "ASoC: wcd-mbhc-v2: use pm_runtime_resume_and_get()"
      commit: e18f6bcf8e864ea0e9690691d0d749c662b6a2c7

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
