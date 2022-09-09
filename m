Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3A365B42B0
	for <lists+stable@lfdr.de>; Sat, 10 Sep 2022 00:57:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231365AbiIIW5K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Sep 2022 18:57:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231342AbiIIW5H (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 9 Sep 2022 18:57:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C463010B007;
        Fri,  9 Sep 2022 15:57:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2AED1B82320;
        Fri,  9 Sep 2022 22:57:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E43EC433D7;
        Fri,  9 Sep 2022 22:57:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662764223;
        bh=ZCVhj1+wfjOMA0Had6ciscyEFKnluS+v1H1EBTpafiY=;
        h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
        b=fNossQnLiG/J6rtZTmNxIyHMbCYbg2ohdsHBi0Arvjcr20QuWwu7fRY7Y1QQXFzYe
         plOFby9dAQIehBeHZ0WZvkujKtVKVN8Ep5h4Wp7iLnsc9z09N1dPzTDvCoDTUeXwQL
         ytYMNyVUXaFyIX2tt5D8LJdbP5zG4RGSb72JGVG++XiBjQ436VZs7PhWdgYcW95Rwq
         7BTwwdr4kMrLDwkeABEq85kKOikMPzObp01DIYqrlke+sKFpnF2eyCE6Zocgv0Beb3
         5RfiV989cBKK/Y50AQKavpGuzz56KSg63yzQFS5pVtPG3epSyD2sUc8lzVM1uuw9Cv
         sSoHuXCiave5A==
From:   Mark Brown <broonie@kernel.org>
To:     Linus Walleij <linus.walleij@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Bjorn Andersson <andersson@kernel.org>,
        linux-arm-msm@vger.kernel.org,
        Konrad Dybcio <konrad.dybcio@somainline.org>,
        Andy Gross <agross@kernel.org>
In-Reply-To: <20220909112529.239143-1-linus.walleij@linaro.org>
References: <20220909112529.239143-1-linus.walleij@linaro.org>
Subject: Re: [PATCH] regulator: qcom_rpm: Fix circular deferral regression
Message-Id: <166276422182.339577.316696992835624011.b4-ty@kernel.org>
Date:   Fri, 09 Sep 2022 23:57:01 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailer: b4 0.10.0-dev-fc921
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 9 Sep 2022 13:25:29 +0200, Linus Walleij wrote:
> On recent kernels, the PM8058 L16 (or any other PM8058 LDO-regulator)
> does not come up if they are supplied by an SMPS-regulator. This
> is not very strange since the regulators are registered in a long
> array and the L-regulators are registered before the S-regulators,
> and if an L-regulator defers, it will never get around to registering
> the S-regulator that it needs.
> 
> [...]

Applied to

   https://git.kernel.org/pub/scm/linux/kernel/git/broonie/regulator.git for-next

Thanks!

[1/1] regulator: qcom_rpm: Fix circular deferral regression
      commit: 8478ed5844588703a1a4c96a004b1525fbdbdd5e

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
