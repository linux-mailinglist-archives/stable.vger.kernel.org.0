Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 686CA3D33E7
	for <lists+stable@lfdr.de>; Fri, 23 Jul 2021 07:09:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229733AbhGWE2d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Jul 2021 00:28:33 -0400
Received: from verein.lst.de ([213.95.11.211]:36922 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229698AbhGWE2c (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 23 Jul 2021 00:28:32 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 1B43C68AFE; Fri, 23 Jul 2021 07:09:03 +0200 (CEST)
Date:   Fri, 23 Jul 2021 07:09:02 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Ezequiel Garcia <ezequiel@collabora.com>
Cc:     iommu@lists.linux-foundation.org, linux-media@vger.kernel.org,
        Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Tomasz Figa <tfiga@chromium.org>,
        Ricardo Ribalda <ribalda@chromium.org>, kernel@collabora.com,
        stable@vger.kernel.org
Subject: Re: [PATCH] iommu/dma: Fix leak in non-contiguous API
Message-ID: <20210723050902.GA31187@lst.de>
References: <20210723010552.50969-1-ezequiel@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210723010552.50969-1-ezequiel@collabora.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

> As a side note, it appears the struct dma_sgt_handle type is exposed
> to users of the DMA-API by linux/dma-map-ops.h, but is has no users
> or functions returning the type explicitly.
> 
> This may indicate it's a good idea to move the struct dma_sgt_handle type
> to drivers/iommu/dma-iommu.c. The decision is left to maintainers :-)

linux/dma-map-ops.h is a helper header for the dma_ops implementations,
not for users of the DMA API.  sgt_handle, which references
dma_sgt_handle is used in kernel/dma/mapping.c
