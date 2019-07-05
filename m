Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E9CBB601BD
	for <lists+stable@lfdr.de>; Fri,  5 Jul 2019 09:49:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728035AbfGEHtl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Jul 2019 03:49:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:35408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728033AbfGEHtl (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Jul 2019 03:49:41 -0400
Received: from localhost (unknown [122.167.76.109])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 05FEF218A3;
        Fri,  5 Jul 2019 07:49:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562312980;
        bh=nbUdxjVXdeGRh1ae5O8KsM/oe6+kZ/hnblt7BvODiQs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rEpSjo2aPJ7I1Pk7pXNwW0tbQRyOrO3vHMUD16ysrCTHZsSdWk0z/2hdRSCG1zm/7
         facLWarRUcEU7134axoOzgtpBqSskyyxT3o8cGSd6phbIKvMgcxcvgLc44hg7LCyFJ
         Ui5X+yfVKfTATY1LdxtU6YEWv2vsq50BijvQ+rxI=
Date:   Fri, 5 Jul 2019 13:16:26 +0530
From:   Vinod Koul <vkoul@kernel.org>
To:     yibin.gong@nxp.com
Cc:     shawnguo@kernel.org, s.hauer@pengutronix.de, festevam@gmail.com,
        dan.j.williams@intel.com, thesven73@gmail.com,
        m.olbrich@pengutronix.de, linux-imx@nxp.com,
        stable@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        dmaengine@vger.kernel.org, kernel@pengutronix.de
Subject: Re: [PATCH v2] dmaengine: imx-sdma: remove BD_INTR for channel0
Message-ID: <20190705074626.GB2911@vkoul-mobl>
References: <20190621082306.34415-1-yibin.gong@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190621082306.34415-1-yibin.gong@nxp.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 21-06-19, 16:23, yibin.gong@nxp.com wrote:
> From: Robin Gong <yibin.gong@nxp.com>
> 
> It is possible for an irq triggered by channel0 to be received later
> after clks are disabled once firmware loaded during sdma probe. If
> that happens then clearing them by writing to SDMA_H_INTR won't work
> and the kernel will hang processing infinite interrupts. Actually,
> don't need interrupt triggered on channel0 since it's pollling
> SDMA_H_STATSTOP to know channel0 done rather than interrupt in
> current code, just clear BD_INTR to disable channel0 interrupt to
> avoid the above case.
> This issue was brought by commit 1d069bfa3c78 ("dmaengine: imx-sdma:
> ack channel 0 IRQ in the interrupt handler") which didn't take care
> the above case.

Applied, thanks

-- 
~Vinod
