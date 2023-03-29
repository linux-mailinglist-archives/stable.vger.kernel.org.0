Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFB626CD4B6
	for <lists+stable@lfdr.de>; Wed, 29 Mar 2023 10:34:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231172AbjC2Ies (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Mar 2023 04:34:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230334AbjC2Ier (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Mar 2023 04:34:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE2A910E5;
        Wed, 29 Mar 2023 01:34:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5502A61B7F;
        Wed, 29 Mar 2023 08:34:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA8E4C433EF;
        Wed, 29 Mar 2023 08:34:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680078881;
        bh=+anbd3/A6zrR8paeDyAzGqJwmuQ3rhLDHCRUEX9PUJM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jA+/s/Wwl0pw6hugM7xg3sS1u/tw8fGDVbP6qPa2+FyXJHSNAhFWz8CVJifaBNwcg
         KDoDt5KE9bBcLFTNEf7E2oBgIpSCq99mu5Vlm5mZcLMfxjcR4nS735KITFRXagFgEO
         ATVShgyWiSvMv94AOA/0U0X5llkcw72dppBwW9Y/ZrHMbMhIhmQM2X5bXcs9kiypto
         bJVGk00UAMID0FDQOADfRoVkw/ESSMcQUNtjtzBbm2BSfrxNRnTE9bh5EmtER34pt1
         UUHgR8L2mdBrNFOrtWZm5OgHKmAAwArWutc0AK2q1BrH65czlHWvRgsr5D3ax5I//M
         Rgy8yK5lxyI9A==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1phRGi-00065x-NH; Wed, 29 Mar 2023 10:34:56 +0200
Date:   Wed, 29 Mar 2023 10:34:56 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Cc:     andersson@kernel.org, Thinh.Nguyen@synopsys.com,
        gregkh@linuxfoundation.org, mathias.nyman@intel.com,
        konrad.dybcio@linaro.org, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, linux-arm-msm@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 1/5] arm64: dts: qcom: sc8280xp: Add missing dwc3 quirks
Message-ID: <ZCP4MHe+9M24S4nJ@hovoldconsulting.com>
References: <20230325165217.31069-1-manivannan.sadhasivam@linaro.org>
 <20230325165217.31069-2-manivannan.sadhasivam@linaro.org>
 <ZCKrXZn7Eu/jvdpG@hovoldconsulting.com>
 <20230328093853.GA5695@thinkpad>
 <20230329052600.GA5575@thinkpad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230329052600.GA5575@thinkpad>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 29, 2023 at 10:56:00AM +0530, Manivannan Sadhasivam wrote:
> On Tue, Mar 28, 2023 at 03:09:03PM +0530, Manivannan Sadhasivam wrote:
> > On Tue, Mar 28, 2023 at 10:54:53AM +0200, Johan Hovold wrote:
> > > On Sat, Mar 25, 2023 at 10:22:13PM +0530, Manivannan Sadhasivam wrote:
> > > > Add missing quirks for the USB DWC3 IP.
> > > 
> > > This is not an acceptable commit message generally and certainly not for
> > > something that you have tagged for stable.
> > > 
> > > At a minimum, you need to describe why these are needed and what the
> > > impact is.
> > > 
> > 
> > I can certainly improve the commit message. But usually the quirks are copied
> > from the downstream devicetree where qualcomm engineers would've added them
> > based on the platform requirements.
> > 
> > > Also, why are you sending as part of a series purporting to enable
> > > runtime PM when it appears to be all about optimising specific gadget
> > > applications?
> > > 
> > 
> > It's not related to this series I agree but just wanted to group it with a
> > series touching usb so that it won't get lost.
> > 
> > I could respin it separately though in v2.

That's also generally best for USB patches as Greg expects series to be
merged through a single tree.

> > > Did you confirm that the below makes any sense or has this just been
> > > copied verbatim from the vendor devicetree (it looks like that)?
> > > 
> > 
> > As you've mentioned, most of the quirks are for gadget mode which is not
> > supported by the upstream supported boards. So I haven't really tested them but
> > for I assumed that Qcom engineers did.
> > 
> > > The fact that almost none of the qcom SoCs sets these also indicates
> > > that something is not right here.
> > > 
> > > > Cc: stable@vger.kernel.org # 5.20
> > > > Fixes: 152d1faf1e2f ("arm64: dts: qcom: add SC8280XP platform")
> > > > Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
> > > > ---
> > > >  arch/arm64/boot/dts/qcom/sc8280xp.dtsi | 14 ++++++++++++++
> > > >  1 file changed, 14 insertions(+)
> > > > 
> > > > diff --git a/arch/arm64/boot/dts/qcom/sc8280xp.dtsi b/arch/arm64/boot/dts/qcom/sc8280xp.dtsi
> > > > index 0d02599d8867..266a94c712aa 100644
> > > > --- a/arch/arm64/boot/dts/qcom/sc8280xp.dtsi
> > > > +++ b/arch/arm64/boot/dts/qcom/sc8280xp.dtsi
> > > > @@ -3040,6 +3040,13 @@ usb_0_dwc3: usb@a600000 {
> > > >  				iommus = <&apps_smmu 0x820 0x0>;
> > > >  				phys = <&usb_0_hsphy>, <&usb_0_qmpphy QMP_USB43DP_USB3_PHY>;
> > > >  				phy-names = "usb2-phy", "usb3-phy";
> > > > +				snps,hird-threshold = /bits/ 8 <0x0>;
> > > > +				snps,usb2-gadget-lpm-disable;
> > > 
> > > Here you are disabling LPM for gadget mode, which makes most of the
> > > other properties entirely pointless.
> 
> Checked with Qcom on these quirks. So this one is just disabling lpm for USB2
> and rest of the quirks below are for SS/SSP modes.

No, snps,hird-threshold is for USB2 LPM and so is
snps,is-utmi-l1-suspend and snps,has-lpm-erratum as you'll see if you
look at the implementation.

> > > > +				snps,is-utmi-l1-suspend;
> > > > +				snps,dis-u1-entry-quirk;
> > > > +				snps,dis-u2-entry-quirk;
> > > 
> > > These appear to be used to optimise certain gadget application and
> > > likely not something that should be set in a dtsi.
> > > 
> > 
> > I will cross check these with Qcom and respin accordingly.
> > 
> 
> These quirks are needed as per the DWC IP integration with this SoC it seems.
> But I got the point that these don't add any values for host only
> configurations. At the same time, these quirks still hold true for the SoC even
> if not exercised.
> 
> So I think we should keep these in the dtsi itself.

Please take a closer look at the quirks you're enabling first. Commit
729dcffd1ed3 ("usb: dwc3: gadget: Add support for disabling U1 and U2
entries") which added 

> > > > +				snps,dis-u1-entry-quirk;
> > > > +				snps,dis-u2-entry-quirk;

explicitly mentions

	Gadget applications may have a requirement to disable the U1 and U2
	entry based on the usecase.

which sounds like something that needs to be done in a per board dts at
least.

Perhaps keeping all of these in in the dtsi is correct, but that's going
to need some more motivation than simply that some vendor does so (as
they often do all sorts of things they should not).

Johan
