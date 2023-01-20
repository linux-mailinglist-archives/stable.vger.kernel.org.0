Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89C0267589A
	for <lists+stable@lfdr.de>; Fri, 20 Jan 2023 16:32:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231434AbjATPcf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Jan 2023 10:32:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229997AbjATPce (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Jan 2023 10:32:34 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB19D10416;
        Fri, 20 Jan 2023 07:32:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 73A0C61FB4;
        Fri, 20 Jan 2023 15:32:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38288C433D2;
        Fri, 20 Jan 2023 15:32:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674228752;
        bh=UqjtNwl5kDRSb+YtjO+rBemZOFwUeZQ1N608lc+Qt5I=;
        h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
        b=cAEgfiRP/Pj+a59hRF7HjklLOxwBImQ97+NfZXCHU+v8TbJxYaqhdu8ZMygr40Kje
         1SkuWrcb8sCcVbgr2Nu6dVNcgdcbiydJVW6asFO0ZV5MRCDq2754NvJOAYIkzSN1AV
         6PUIQg2xExjEUwoeFWYIyEkN79+CWnI+14YNTT1O3FensSWeNTXxmo+W8LwFgNtwst
         quv94nUHhzrxiDE3XUL/Wk2RIVqQl4CvywltkfeB5vulqXVW0Bk/Qqjvh03d3Yu8cZ
         XWoSznW05uOOTNkjxRLoeJBewG/F2OoM8ceNE+nupXicaMZ91RlrGyZjhm9OqW2xAi
         QUGqoEmC/12+A==
From:   Mark Brown <broonie@kernel.org>
To:     Liam Girdwood <lgirdwood@gmail.com>,
        Rob Herring <robh+dt@kernel.org>, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     stable@vger.kernel.org
In-Reply-To: <20230120131447.289702-1-krzysztof.kozlowski@linaro.org>
References: <20230120131447.289702-1-krzysztof.kozlowski@linaro.org>
Subject: Re: [PATCH] regulator: dt-bindings: samsung,s2mps14: add lost
 samsung,ext-control-gpios
Message-Id: <167422875087.1341358.9390757664237941652.b4-ty@kernel.org>
Date:   Fri, 20 Jan 2023 15:32:30 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.12-dev-77e06
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 20 Jan 2023 14:14:47 +0100, Krzysztof Kozlowski wrote:
> The samsung,ext-control-gpios property was lost during conversion to DT
> schema:
> 
>   exynos3250-artik5-eval.dtb: pmic@66: regulators:LDO11: Unevaluated properties are not allowed ('samsung,ext-control-gpios' was unexpected)
> 
> 

Applied to

   broonie/regulator.git for-next

Thanks!

[1/1] regulator: dt-bindings: samsung,s2mps14: add lost samsung,ext-control-gpios
      commit: 4bb3d82a1820c1b609ede8eb2332f3cb038c5840

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

