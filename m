Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47C236D5EE3
	for <lists+stable@lfdr.de>; Tue,  4 Apr 2023 13:24:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234733AbjDDLYw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Apr 2023 07:24:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234378AbjDDLYv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Apr 2023 07:24:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D0831FD3;
        Tue,  4 Apr 2023 04:24:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 195F963249;
        Tue,  4 Apr 2023 11:24:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C04EC433D2;
        Tue,  4 Apr 2023 11:24:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680607489;
        bh=45L8OTcH+B0HWF79y0YD7k2NGle3X+Mu1k7dADgiuIg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=e2sUn9AHkU/mGqOiQjFSjOTOeeqi+/qO/SD7OuXyJwZ/4+BxHqlo3FP1BMfyuNmLW
         iLDYGlWqSqQetpuK2MiHk7AyqmAGr+9MXJ9C87yOPiKceKrjYrv6Ay5FyCBbM8cNsk
         2WkufQbMwmAqAxOCMHiSfXf7uZGZVLbVyMPr4uSGXxc5uObWSK8JxC272F3V8bQaHI
         tGTZQ6vejtEc+qOEp24vzhtMyqJ3+9l97OvlS/pIokW/AKnDE8aHNNo6kEbqB+VC47
         OYi5krSn8ueKDBzScVjrSbrNVBCrRR/MIqmQnkEQrLXQmVtqwPwhxzw89LdThSTR41
         M3ySq6oHzj9Hg==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1pjemp-0006bj-TV; Tue, 04 Apr 2023 13:25:16 +0200
Date:   Tue, 4 Apr 2023 13:25:15 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Cc:     andersson@kernel.org, Thinh.Nguyen@synopsys.com,
        gregkh@linuxfoundation.org, mathias.nyman@intel.com,
        konrad.dybcio@linaro.org, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, linux-arm-msm@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 1/5] arm64: dts: qcom: sc8280xp: Add missing dwc3 quirks
Message-ID: <ZCwJG5SEqmeIzJG1@hovoldconsulting.com>
References: <20230325165217.31069-1-manivannan.sadhasivam@linaro.org>
 <20230325165217.31069-2-manivannan.sadhasivam@linaro.org>
 <ZCKrXZn7Eu/jvdpG@hovoldconsulting.com>
 <20230328093853.GA5695@thinkpad>
 <20230329052600.GA5575@thinkpad>
 <ZCP4MHe+9M24S4nJ@hovoldconsulting.com>
 <20230329132343.GD5575@thinkpad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230329132343.GD5575@thinkpad>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 29, 2023 at 06:53:43PM +0530, Manivannan Sadhasivam wrote:
> On Wed, Mar 29, 2023 at 10:34:56AM +0200, Johan Hovold wrote:
> > On Wed, Mar 29, 2023 at 10:56:00AM +0530, Manivannan Sadhasivam wrote:
> > > On Tue, Mar 28, 2023 at 03:09:03PM +0530, Manivannan Sadhasivam wrote:
> > > > On Tue, Mar 28, 2023 at 10:54:53AM +0200, Johan Hovold wrote:
> > > > > On Sat, Mar 25, 2023 at 10:22:13PM +0530, Manivannan Sadhasivam wrote:

> > > > > > diff --git a/arch/arm64/boot/dts/qcom/sc8280xp.dtsi b/arch/arm64/boot/dts/qcom/sc8280xp.dtsi
> > > > > > index 0d02599d8867..266a94c712aa 100644
> > > > > > --- a/arch/arm64/boot/dts/qcom/sc8280xp.dtsi
> > > > > > +++ b/arch/arm64/boot/dts/qcom/sc8280xp.dtsi
> > > > > > @@ -3040,6 +3040,13 @@ usb_0_dwc3: usb@a600000 {
> > > > > >  				iommus = <&apps_smmu 0x820 0x0>;
> > > > > >  				phys = <&usb_0_hsphy>, <&usb_0_qmpphy QMP_USB43DP_USB3_PHY>;
> > > > > >  				phy-names = "usb2-phy", "usb3-phy";
> > > > > > +				snps,hird-threshold = /bits/ 8 <0x0>;
> > > > > > +				snps,usb2-gadget-lpm-disable;
> > > > > 
> > > > > Here you are disabling LPM for gadget mode, which makes most of the
> > > > > other properties entirely pointless.
> > > 
> > > Checked with Qcom on these quirks. So this one is just disabling lpm for USB2
> > > and rest of the quirks below are for SS/SSP modes.
> > 
> > No, snps,hird-threshold is for USB2 LPM and so is
> > snps,is-utmi-l1-suspend and snps,has-lpm-erratum as you'll see if you
> > look at the implementation.
> > 
> 
> Correct me if I'm wrong. When I look into the code, "snps,is-utmi-l1-suspend"
> and "snps,hird-threshold" are used independently of the LPM mode atleast in one
> place:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/drivers/usb/dwc3/gadget.c#n2867
> 
> But I could be completely wrong here as my understanding of the usb stack is not
> that great.

Yeah, it's not that obvious from just looking at the code, but L1 (and
BESL) are USB2 LPM concepts and if you disable LPM then there is no need
to override these values in the BOS descriptor either (as is done in
dwc3_gadget_config_params() and bos_desc()).

> > > > > > +				snps,is-utmi-l1-suspend;
> > > > > > +				snps,dis-u1-entry-quirk;
> > > > > > +				snps,dis-u2-entry-quirk;
> > > > > 
> > > > > These appear to be used to optimise certain gadget application and
> > > > > likely not something that should be set in a dtsi.
> > > > > 
> > > > 
> > > > I will cross check these with Qcom and respin accordingly.
> > > > 
> > > 
> > > These quirks are needed as per the DWC IP integration with this SoC it seems.
> > > But I got the point that these don't add any values for host only
> > > configurations. At the same time, these quirks still hold true for the SoC even
> > > if not exercised.
> > > 
> > > So I think we should keep these in the dtsi itself.
> > 
> > Please take a closer look at the quirks you're enabling first. Commit
> > 729dcffd1ed3 ("usb: dwc3: gadget: Add support for disabling U1 and U2
> > entries") which added 
> > 
> > > > > > +				snps,dis-u1-entry-quirk;
> > > > > > +				snps,dis-u2-entry-quirk;
> > 
> > explicitly mentions
> > 
> > 	Gadget applications may have a requirement to disable the U1 and U2
> > 	entry based on the usecase.
> > 
> > which sounds like something that needs to be done in a per board dts at
> > least.
> > 
> 
> Going by this commit message it sounds like it. But...
> 
> > Perhaps keeping all of these in in the dtsi is correct, but that's going
> > to need some more motivation than simply that some vendor does so (as
> > they often do all sorts of things they should not).
> > 
> 
> If you read my last reply one more time, I didn't reason it based on the vendor
> code.

I was referring to the fact that these properties had been copied from
the vendor dtsi and seemingly so without further review or
justification in the commit message (e.g. to explain the
inconsistencies).

> But I hear a contradict reply from Qcom saying that these properties are
> required as a part of the DWC3 IP integration with the SoC. I need to recheck
> with them again tomorrow.
> 
> Also, if these properties are application specific then they shouldn't be in
> devicetree atleast :/

I fully agree with that.

Johan
