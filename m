Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D8EA6CD939
	for <lists+stable@lfdr.de>; Wed, 29 Mar 2023 14:15:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229945AbjC2MPn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Mar 2023 08:15:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229894AbjC2MPm (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Mar 2023 08:15:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC7321BC5;
        Wed, 29 Mar 2023 05:15:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 83517B822EF;
        Wed, 29 Mar 2023 12:15:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AF4DC433EF;
        Wed, 29 Mar 2023 12:15:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680092139;
        bh=ooI6Bfj0R2M+5cI2Mb1ScsbOJK9bXNmKBtl2mMblFqU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IltNfQiEhDRH4AoF+ZsHwKkNN89JrD1BldNiWv/KDIs1wfp6E+sR04uHWgeFIsTCE
         FeX66IdBZI6dMTgI8j0W+gFgUaMR8eFHaWUgqx4Oo9tX5StdUSpgp/KOG39kYefDfK
         bd8KB9QuV2SFv5HsNR3C6hsLOxL2gKL3BXLU1yLsMCrSbB/I3XpnBSbjgDaqnurGbY
         RlmI22iXA35WrKfWVDtCu0svv3vpfkTkEOaTMgVwWB+uUdTe9SbrHSoo3mzZfceTyh
         jgnC3onF+T92VPudm0MNKFkFlZU/+CrDrdmyWwLN8yE9iQXvlBv/KapVNhXhacmR1X
         E7VfZqsxnVRow==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1phUiY-0006ZQ-Jh; Wed, 29 Mar 2023 14:15:54 +0200
Date:   Wed, 29 Mar 2023 14:15:54 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Konrad Dybcio <konrad.dybcio@linaro.org>
Cc:     Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        andersson@kernel.org, Thinh.Nguyen@synopsys.com,
        gregkh@linuxfoundation.org, mathias.nyman@intel.com,
        robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        linux-arm-msm@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 1/5] arm64: dts: qcom: sc8280xp: Add missing dwc3 quirks
Message-ID: <ZCQr+hGr/9RQUBK1@hovoldconsulting.com>
References: <20230325165217.31069-1-manivannan.sadhasivam@linaro.org>
 <20230325165217.31069-2-manivannan.sadhasivam@linaro.org>
 <ZCKrXZn7Eu/jvdpG@hovoldconsulting.com>
 <20230328093853.GA5695@thinkpad>
 <20230329052600.GA5575@thinkpad>
 <ZCP4MHe+9M24S4nJ@hovoldconsulting.com>
 <a35bd0e2-b54e-ffa7-e54b-468a3cf77703@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a35bd0e2-b54e-ffa7-e54b-468a3cf77703@linaro.org>
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 29, 2023 at 01:24:27PM +0200, Konrad Dybcio wrote:
> On 29.03.2023 10:34, Johan Hovold wrote:

> > Perhaps keeping all of these in in the dtsi is correct, but that's going
> > to need some more motivation than simply that some vendor does so (as
> > they often do all sorts of things they should not).

> I'm looking at the DWC3 code and admittedly I don't understand much,
> but is there any harm to keeping them? What if somebody decides to
> plug in a laptop as a gadget device?

We should the add the bits that are really needed with a proper
descriptions of what they do (like all commit messages should).

Besides the commit message, the problem here is that these have just
been copied from some vendor kernel and some properties are conflicting
(e.g. both disabling LPM and configuring LPM settings) while others
appear to be application specific.

Johan
