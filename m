Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51D0B6D06B9
	for <lists+stable@lfdr.de>; Thu, 30 Mar 2023 15:28:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231452AbjC3N2t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Mar 2023 09:28:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231992AbjC3N2s (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Mar 2023 09:28:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0915AA5FA;
        Thu, 30 Mar 2023 06:28:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9913BB82775;
        Thu, 30 Mar 2023 13:28:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0F12C433EF;
        Thu, 30 Mar 2023 13:28:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680182915;
        bh=v8AtPPr2npAFWTLwZhYml/BlOepM7LWNbVlANAVOCtg=;
        h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
        b=uortMvtcdtdqnx0Y8n5Qs4F9ErnSxttq/nRUtqbVq9vZpzq6wAAZ4Dshr6cqcHpb6
         nH1y0MXpMPsIquNjIdG0NIA1YsfS3ydxDu9u0oRI3DB0FQytofcHLhKFdY5TGIgEE5
         DBkLno/7MT19g206Osn/IhZOk0vjoxEOpfGZatuyctJzn5Q3RtSCWt0mVnan/F0geQ
         A8ejzHrOAMhk3lE3NOCZUZbMZ3nYB7YGHpZI63Q7iTd8xzCXd7z9B+Z2lypc2x8Vlv
         LpTCOaz/G9ayCN6YYlcWhxsMMkv8ltlQXCaffLebVLmZgy9/Vq9FNFNVFGikjtbpme
         x5YRdOnuTkHHg==
From:   Mark Brown <broonie@kernel.org>
To:     Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Banajit Goswami <bgoswami@quicinc.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Venkata Prasad Potturu <quic_potturu@quicinc.com>,
        Srinivasa Rao Mandadapu <quic_srivasam@quicinc.com>,
        linux-arm-msm@vger.kernel.org, alsa-devel@alsa-project.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     stable@vger.kernel.org, Rob Herring <robh@kernel.org>
In-Reply-To: <20230330071333.24308-1-krzysztof.kozlowski@linaro.org>
References: <20230330071333.24308-1-krzysztof.kozlowski@linaro.org>
Subject: Re: [RESEND PATCH] ASoC: dt-bindings: qcom,lpass-rx-macro: correct
 minItems for clocks
Message-Id: <168018291034.3345013.1034943488652302497.b4-ty@kernel.org>
Date:   Thu, 30 Mar 2023 14:28:30 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.13-dev-2eb1a
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 30 Mar 2023 09:13:33 +0200, Krzysztof Kozlowski wrote:
> The RX macro codec comes on some platforms in two variants - ADSP
> and ADSP bypassed - thus the clock-names varies from 3 to 5.  The clocks
> must vary as well:
> 
>   sc7280-idp.dtb: codec@3200000: clocks: [[202, 8], [202, 7], [203]] is too short
> 
> 
> [...]

Applied to

   broonie/sound.git for-next

Thanks!

[1/1] ASoC: dt-bindings: qcom,lpass-rx-macro: correct minItems for clocks
      commit: 59257015ac8813d2430988aa01c2f4609a60e8e7

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

