Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C59B6CB9E9
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 10:55:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232381AbjC1Iy6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 04:54:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232276AbjC1Iyq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 04:54:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B253719A1;
        Tue, 28 Mar 2023 01:54:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6230DB81BBF;
        Tue, 28 Mar 2023 08:54:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD22FC433EF;
        Tue, 28 Mar 2023 08:54:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679993683;
        bh=FlhEhP6prp2j0gTaGdnVSIx+i5NWL7KCri11ZYnsy3I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SJRGXCjhZkx/iOapcmyPGdXscZHKSIdLVHHLMURh1Rf6qwEnc3Xlad0Qvwr7KT+qF
         1MENXlQqeB6wAxszDpo0TlZmxkBw9FBjElNI3lmZEwodbevs5J0gzufBZbX0mRJdhf
         vC8+Ux1CbqncIrFCgHueOAiBJ+SC1rsOFyCvtvF8jIFY1Og2EUQ7iCdVEy7jrzzCGJ
         YQsXyp4K2PTCsfootJyrObN8PSegqIaDFVCs650s/Kz/BEbhs4gmnYGP3HVngdZrES
         FvDmZClERmEwCYz3P6muXFqsF2d3ARRaq5wJPoyotbW36VpAoQYf/hmQcGjpBck2D5
         QfcbOfLgQZHBw==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1ph56U-0003mE-05; Tue, 28 Mar 2023 10:54:54 +0200
Date:   Tue, 28 Mar 2023 10:54:53 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Cc:     andersson@kernel.org, Thinh.Nguyen@synopsys.com,
        gregkh@linuxfoundation.org, mathias.nyman@intel.com,
        konrad.dybcio@linaro.org, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, linux-arm-msm@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 1/5] arm64: dts: qcom: sc8280xp: Add missing dwc3 quirks
Message-ID: <ZCKrXZn7Eu/jvdpG@hovoldconsulting.com>
References: <20230325165217.31069-1-manivannan.sadhasivam@linaro.org>
 <20230325165217.31069-2-manivannan.sadhasivam@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230325165217.31069-2-manivannan.sadhasivam@linaro.org>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Mar 25, 2023 at 10:22:13PM +0530, Manivannan Sadhasivam wrote:
> Add missing quirks for the USB DWC3 IP.

This is not an acceptable commit message generally and certainly not for
something that you have tagged for stable.

At a minimum, you need to describe why these are needed and what the
impact is.

Also, why are you sending as part of a series purporting to enable
runtime PM when it appears to be all about optimising specific gadget
applications?

Did you confirm that the below makes any sense or has this just been
copied verbatim from the vendor devicetree (it looks like that)?

The fact that almost none of the qcom SoCs sets these also indicates
that something is not right here.

> Cc: stable@vger.kernel.org # 5.20
> Fixes: 152d1faf1e2f ("arm64: dts: qcom: add SC8280XP platform")
> Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
> ---
>  arch/arm64/boot/dts/qcom/sc8280xp.dtsi | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
> 
> diff --git a/arch/arm64/boot/dts/qcom/sc8280xp.dtsi b/arch/arm64/boot/dts/qcom/sc8280xp.dtsi
> index 0d02599d8867..266a94c712aa 100644
> --- a/arch/arm64/boot/dts/qcom/sc8280xp.dtsi
> +++ b/arch/arm64/boot/dts/qcom/sc8280xp.dtsi
> @@ -3040,6 +3040,13 @@ usb_0_dwc3: usb@a600000 {
>  				iommus = <&apps_smmu 0x820 0x0>;
>  				phys = <&usb_0_hsphy>, <&usb_0_qmpphy QMP_USB43DP_USB3_PHY>;
>  				phy-names = "usb2-phy", "usb3-phy";
> +				snps,hird-threshold = /bits/ 8 <0x0>;
> +				snps,usb2-gadget-lpm-disable;

Here you are disabling LPM for gadget mode, which makes most of the
other properties entirely pointless.

> +				snps,is-utmi-l1-suspend;
> +				snps,dis-u1-entry-quirk;
> +				snps,dis-u2-entry-quirk;

These appear to be used to optimise certain gadget application and
likely not something that should be set in a dtsi.

> +				snps,has-lpm-erratum;
> +				tx-fifo-resize;

Same here.

>  				port {
>  					usb_0_role_switch: endpoint {

Johan
