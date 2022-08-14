Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA318591F80
	for <lists+stable@lfdr.de>; Sun, 14 Aug 2022 12:17:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235695AbiHNKRh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Aug 2022 06:17:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230488AbiHNKRg (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 14 Aug 2022 06:17:36 -0400
Received: from mail.z3ntu.xyz (mail.z3ntu.xyz [128.199.32.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B96F21E20;
        Sun, 14 Aug 2022 03:17:34 -0700 (PDT)
Received: from g550jk.localnet (217-149-168-95.nat.highway.telekom.at [217.149.168.95])
        by mail.z3ntu.xyz (Postfix) with ESMTPSA id 99ADBCA576;
        Sun, 14 Aug 2022 10:17:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=z3ntu.xyz; s=z3ntu;
        t=1660472221; bh=82bmlvZYh/pm/el+VeCtbE3cdx4IbOcvwUq9hPZ6kSY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=hA00L+v/kYzFnxj/8oNM7RiwSzjM+gCEB5S9FGTy7+hRX9KR8iIoPqk5seX8BKWG6
         ETJLHH0Qo3ecxHdijp5kbIqkeTtHmKnklWUkLMfpp/scp2mVeHs126qHMYhfH8NKIA
         1OCJNftWUF+GTSdrKAZES0D6fyHz18F4ySUBocRw=
From:   Luca Weiss <luca@z3ntu.xyz>
To:     stable-commits@vger.kernel.org, Sasha Levin <sashal@kernel.org>,
        stable@vger.kernel.org
Cc:     Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Konrad Dybcio <konrad.dybcio@somainline.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
Subject: Re: Patch "ARM: dts: qcom: msm8974-FP2: Add supplies for remoteprocs" has been added to the 5.18-stable tree
Date:   Sun, 14 Aug 2022 12:16:59 +0200
Message-ID: <5592507.DvuYhMxLoT@g550jk>
In-Reply-To: <20220813212142.1948036-1-sashal@kernel.org>
References: <20220813212142.1948036-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-0.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FROM_SUSPICIOUS_NTLD,
        PDS_OTHER_BAD_TLD,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Sasha and others,

On Samstag, 13. August 2022 23:21:42 CEST Sasha Levin wrote:
> This is a note to let you know that I've just added the patch titled
> 
>     ARM: dts: qcom: msm8974-FP2: Add supplies for remoteprocs
> 
> to the 5.18-stable tree which can be found at:
>    
> http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=sum
> mary
> 
> The filename of the patch is:
>      arm-dts-qcom-msm8974-fp2-add-supplies-for-remoteproc.patch
> and it can be found in the queue-5.18 subdirectory.
> 
> If you, or anyone else, feels it should not be added to the stable tree,
> please let <stable@vger.kernel.org> know about it.
> 

While I don't know the policy for backporting major dts changes, I don't think 
backporting all the msm8974 cleanup to anything older is really worth it.

I also don't think there's actually a user of msm8974 stable, all the activity 
I know of happens on the latest mainline plus some extra patches on top for 
extra functionality that cannot be upstreamed yet.

Regards
Luca

> 
> 
> commit d5e29d1fc785b60f8ac337c1a36b908a228b01ac
> Author: Luca Weiss <luca@z3ntu.xyz>
> Date:   Thu Apr 21 23:42:43 2022 +0200
> 
>     ARM: dts: qcom: msm8974-FP2: Add supplies for remoteprocs
> 
>     [ Upstream commit fb5e339fb1bc9eb7f34b341d995e4ab39c03588e ]
> 
>     Those were removed from msm8974.dtsi as part of a recent cleanup commit,
> so add them back for FP2.
> 
>     Signed-off-by: Luca Weiss <luca@z3ntu.xyz>
>     Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
>     Link: https://lore.kernel.org/r/20220421214243.352469-3-luca@z3ntu.xyz
>     Signed-off-by: Sasha Levin <sashal@kernel.org>
> 
> diff --git a/arch/arm/boot/dts/qcom-msm8974-fairphone-fp2.dts
> b/arch/arm/boot/dts/qcom-msm8974-fairphone-fp2.dts index
> d6799a1b820b..32975f56f896 100644
> --- a/arch/arm/boot/dts/qcom-msm8974-fairphone-fp2.dts
> +++ b/arch/arm/boot/dts/qcom-msm8974-fairphone-fp2.dts
> @@ -131,6 +131,17 @@ wcnss {
>  	};
>  };
> 
> +&remoteproc_adsp {
> +	cx-supply = <&pm8841_s2>;
> +};
> +
> +&remoteproc_mss {
> +	cx-supply = <&pm8841_s2>;
> +	mss-supply = <&pm8841_s3>;
> +	mx-supply = <&pm8841_s1>;
> +	pll-supply = <&pm8941_l12>;
> +};
> +
>  &rpm_requests {
>  	pm8841-regulators {
>  		compatible = "qcom,rpm-pm8841-regulators";




