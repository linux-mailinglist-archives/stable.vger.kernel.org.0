Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 576751B4B3D
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 19:03:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726584AbgDVRDz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 13:03:55 -0400
Received: from verein.lst.de ([213.95.11.211]:53680 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726057AbgDVRDz (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Apr 2020 13:03:55 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id F271B68C4E; Wed, 22 Apr 2020 19:03:49 +0200 (CEST)
Date:   Wed, 22 Apr 2020 19:03:49 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Ulf Hansson <ulf.hansson@linaro.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Christoph Hellwig <hch@lst.de>,
        Russell King <linux@armlinux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Vinod Koul <vkoul@kernel.org>, Haibo Chen <haibo.chen@nxp.com>,
        Ludovic Barre <ludovic.barre@st.com>,
        linux-arm-kernel@lists.infradead.org, dmaengine@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [RESEND PATCH v2 1/2] driver core: platform: Initialize
 dma_parms for platform devices
Message-ID: <20200422170349.GA28781@lst.de>
References: <20200422100954.31211-1-ulf.hansson@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200422100954.31211-1-ulf.hansson@linaro.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 22, 2020 at 12:09:54PM +0200, Ulf Hansson wrote:
> It's currently the platform driver's responsibility to initialize the
> pointer, dma_parms, for its corresponding struct device. The benefit with
> this approach allows us to avoid the initialization and to not waste memory
> for the struct device_dma_parameters, as this can be decided on a case by
> case basis.
> 
> However, it has turned out that this approach is not very practical.  Not
> only does it lead to open coding, but also to real errors. In principle
> callers of dma_set_max_seg_size() doesn't check the error code, but just
> assumes it succeeds.
> 
> For these reasons, let's do the initialization from the common platform bus
> at the device registration point. This also follows the way the PCI devices
> are being managed, see pci_device_add().
> 
> Suggested-by: Christoph Hellwig <hch@lst.de>
> Cc: <stable@vger.kernel.org>
> Tested-by: Haibo Chen <haibo.chen@nxp.com>
> Reviewed-by: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
