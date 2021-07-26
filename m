Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26C243D5975
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 14:27:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234045AbhGZLrE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 07:47:04 -0400
Received: from 8bytes.org ([81.169.241.247]:47154 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233713AbhGZLrD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 07:47:03 -0400
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id 565562B0; Mon, 26 Jul 2021 14:27:31 +0200 (CEST)
Date:   Mon, 26 Jul 2021 14:27:29 +0200
From:   Joerg Roedel <joro@8bytes.org>
To:     Ezequiel Garcia <ezequiel@collabora.com>
Cc:     iommu@lists.linux-foundation.org, linux-media@vger.kernel.org,
        Will Deacon <will@kernel.org>, Christoph Hellwig <hch@lst.de>,
        Tomasz Figa <tfiga@chromium.org>,
        Ricardo Ribalda <ribalda@chromium.org>, kernel@collabora.com,
        stable@vger.kernel.org
Subject: Re: [PATCH] iommu/dma: Fix leak in non-contiguous API
Message-ID: <YP6qMWbhZKFO9ADf@8bytes.org>
References: <20210723010552.50969-1-ezequiel@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210723010552.50969-1-ezequiel@collabora.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 22, 2021 at 10:05:52PM -0300, Ezequiel Garcia wrote:
>  drivers/iommu/dma-iommu.c | 1 +
>  1 file changed, 1 insertion(+)

Applied to iommu/fixes, thanks.
