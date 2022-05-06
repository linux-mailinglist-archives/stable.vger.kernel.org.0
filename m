Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C581251DB2E
	for <lists+stable@lfdr.de>; Fri,  6 May 2022 16:53:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442312AbiEFO4q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 May 2022 10:56:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1442497AbiEFO4j (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 May 2022 10:56:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAA776B098
        for <stable@vger.kernel.org>; Fri,  6 May 2022 07:52:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 89AD2B83666
        for <stable@vger.kernel.org>; Fri,  6 May 2022 14:52:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0897C385A8;
        Fri,  6 May 2022 14:52:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651848773;
        bh=PAte/TbD+ZopDPC2fZXFq6Gm6BzyW3fPcZytc2NUz+c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=snMPIIFhggEyAO8fjgHMZmwIgLJhufwFA05SA1g9ebMYmljzA5IbHJd9J1iClgTDV
         8z9uxSrjxrCaCl7vvlEqazjm9lwiDLFmNpZY+XM2HxFkVhzrb7XsdafnR8MVM0WvHV
         UmasghmXuJD0kkYdtTkNZXlmelg4tk5VH2hSr+XA=
Date:   Fri, 6 May 2022 16:52:49 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Kun(llfl)" <llfl@linux.alibaba.com>
Cc:     Jiangbo Wu <jiangbo.wu@intel.com>, Xu Yu <xuyu@linux.alibaba.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Sanjay Kumar <sanjay.k.kumar@intel.com>,
        stable@vger.kernel.org, Jon Derrick <jonathan.derrick@intel.com>
Subject: Re: [PATCH 06/19] iommu/vt-d: Fix clearing real DMA device's
 scalable-mode context entries
Message-ID: <YnU2QcC7QQzvcWUI@kroah.com>
References: <20220506120057.77320-1-llfl@linux.alibaba.com>
 <20220506120057.77320-6-llfl@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220506120057.77320-6-llfl@linux.alibaba.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 06, 2022 at 08:00:44PM +0800, Kun(llfl) wrote:
> From: Lu Baolu <baolu.lu@linux.intel.com>
> 
> ANBZ: #1105
> 
> commit 474dd1c6506411752a9b2f2233eec11f1733a099 upstream.
> 
> The commit 2b0140c69637e ("iommu/vt-d: Use pci_real_dma_dev() for mapping")
> fixes an issue of "sub-device is removed where the context entry is cleared
> for all aliases". But this commit didn't consider the PASID entry and PASID
> table in VT-d scalable mode. This fix increases the coverage of scalable
> mode.
> 
> Suggested-by: Sanjay Kumar <sanjay.k.kumar@intel.com>
> Fixes: 8038bdb855331 ("iommu/vt-d: Only clear real DMA device's context entries")
> Fixes: 2b0140c69637e ("iommu/vt-d: Use pci_real_dma_dev() for mapping")
> Cc: stable@vger.kernel.org # v5.6+

Same here, what kernels is this to be applied to, and what is the "ANBZ"
tag?

thanks,

greg k-h
