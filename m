Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8882442EFC0
	for <lists+stable@lfdr.de>; Fri, 15 Oct 2021 13:32:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231397AbhJOLeF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Oct 2021 07:34:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:48160 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230030AbhJOLeE (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Oct 2021 07:34:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0A6F560F8F;
        Fri, 15 Oct 2021 11:31:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634297518;
        bh=u8dQdbjNo9NrTgpcI2VRi1Xc57Vs+C5m5M3FQQ8rNE8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PnDyCwHnM0GKys2Kzwgz1Glmwe6f7EHffOjJv/A9uO0oPq9f2U2/iSABFY6czhlwA
         69qhcEuqQYRUps7kiFcGKy2EId111SDLEZgb4ZEHcqvnRWyTMl0VimFxBxsbB5zZOL
         AB9eO9CQzm0V4YKepUBAAbRuNsVRuUtj/XGtBAZw=
Date:   Fri, 15 Oct 2021 13:31:56 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Georgi Djakov <djakov@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Shawn Guo <shawn.guo@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@somainline.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.14 05/30] interconnect: qcom: sdm660: Add missing a2noc
 qos clocks
Message-ID: <YWlmrAZ10EtLmrfD@kroah.com>
References: <20211014145209.520017940@linuxfoundation.org>
 <20211014145209.702501084@linuxfoundation.org>
 <4eeec0ec-c178-248a-f053-2352131c1052@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4eeec0ec-c178-248a-f053-2352131c1052@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 15, 2021 at 02:24:52PM +0300, Georgi Djakov wrote:
> Hi Greg,
> 
> On 14.10.21 17:54, Greg Kroah-Hartman wrote:
> > From: Shawn Guo <shawn.guo@linaro.org>
> > 
> > [ Upstream commit 13404ac8882f5225af07545215f4975a564c3740 ]
> > 
> > It adds the missing a2noc clocks required for QoS registers programming
> > per downstream kernel[1].  Otherwise, qcom_icc_noc_set_qos_priority()
> > call on mas_ufs or mas_usb_hs node will simply result in a hardware hang
> > on SDM660 SoC.
> > 
> > [1] https://source.codeaurora.org/quic/la/kernel/msm-4.4/tree/arch/arm/boot/dts/qcom/sdm660-bus.dtsi?h=LA.UM.8.2.r1-04800-sdm660.0#n43
> > 
> > Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
> > Tested-by: Bjorn Andersson <bjorn.andersson@linaro.org>
> > Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@somainline.org>
> > Link: https://lore.kernel.org/r/20210824043435.23190-3-shawn.guo@linaro.org
> > Signed-off-by: Georgi Djakov <djakov@kernel.org>
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> 
> There is no benefit to backport this change, as devices that
> needed it, would not boot on v5.14 anyways. Please drop it.

Now dropped, thanks!

greg k-h
