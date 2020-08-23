Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C210D24EE04
	for <lists+stable@lfdr.de>; Sun, 23 Aug 2020 17:50:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727942AbgHWPuO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Aug 2020 11:50:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:55784 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726734AbgHWPuN (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 23 Aug 2020 11:50:13 -0400
Received: from localhost (unknown [122.171.38.130])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 62EFB2067C;
        Sun, 23 Aug 2020 15:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598197813;
        bh=B9LTAHlLuLxN0M4KmQQUmWtA81D9H08rXF+h2iRvExE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dU35rCUCQXkJ3T+Hhtw0NBrc7cMYu+4tHq6LJfR2Mvn5JQ+3yccS+nDbh48mYFDF1
         1YSB4HcT0SjAPYA35/QSCvSQtvFYzM3mWKdRLFooUWtl0/nqCMTEk7wr3cXDMlwGW5
         HmU+oytG9pHtU5XtYtWcLejU0GCmOTjSRURHho0E=
Date:   Sun, 23 Aug 2020 21:20:09 +0530
From:   Vinod Koul <vkoul@kernel.org>
To:     Sivaprakash Murugesan <sivaprak@codeaurora.org>
Cc:     agross@kernel.org, bjorn.andersson@linaro.org, bhelgaas@google.com,
        robh+dt@kernel.org, kishon@ti.com, svarbanov@mm-sol.com,
        lorenzo.pieralisi@arm.com, p.zabel@pengutronix.de,
        mgautam@codeaurora.org, smuthayy@codeaurora.org,
        varada@codeaurora.org, linux-arm-msm@vger.kernel.org,
        linux-pci@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Selvam Sathappan Periakaruppan <speriaka@codeaurora.org>
Subject: Re: [PATCH V2 3/7] phy: qcom-qmp: Use correct values for ipq8074
 PCIe Gen2 PHY init
Message-ID: <20200823155009.GV2639@vkoul-mobl>
References: <1596036607-11877-1-git-send-email-sivaprak@codeaurora.org>
 <1596036607-11877-4-git-send-email-sivaprak@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1596036607-11877-4-git-send-email-sivaprak@codeaurora.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 29-07-20, 21:00, Sivaprakash Murugesan wrote:
> There were some problem in ipq8074 Gen2 PCIe phy init sequence.
> 
> 1. Few register values were wrongly updated in the phy init sequence.
> 2. The register QSERDES_RX_SIGDET_CNTRL is a RX tuning parameter
>    register which is added in serdes table causing the wrong register
>    was getting updated.
> 3. Clocks and resets were not added in the phy init.
> 
> Fix these to make Gen2 PCIe port on ipq8074 devices to work.

Applied to fixes, thanks

> 
> Fixes: eef243d04b2b6 ("phy: qcom-qmp: Add support for IPQ8074")
> 

no need of empty line here, have fixed it up while applying

-- 
~Vinod
