Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5A011228A8
	for <lists+stable@lfdr.de>; Tue, 17 Dec 2019 11:28:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726164AbfLQK2F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Dec 2019 05:28:05 -0500
Received: from 8bytes.org ([81.169.241.247]:57732 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725940AbfLQK2F (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Dec 2019 05:28:05 -0500
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id DF6FE286; Tue, 17 Dec 2019 11:28:03 +0100 (CET)
Date:   Tue, 17 Dec 2019 11:28:02 +0100
From:   Joerg Roedel <joro@8bytes.org>
To:     Lu Baolu <baolu.lu@linux.intel.com>
Cc:     David Woodhouse <dwmw2@infradead.org>, ashok.raj@intel.com,
        jacob.jun.pan@intel.com, kevin.tian@intel.com,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Jerry Snitselaar <jsnitsel@redhat.com>, stable@vger.kernel.org
Subject: Re: [PATCH 1/1] iommu/vt-d: Fix dmar pte read access not set error
Message-ID: <20191217102802.GO8689@8bytes.org>
References: <20191211014015.7898-1-baolu.lu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191211014015.7898-1-baolu.lu@linux.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 11, 2019 at 09:40:15AM +0800, Lu Baolu wrote:
> If the default DMA domain of a group doesn't fit a device, it
> will still sit in the group but use a private identity domain.
> When map/unmap/iova_to_phys come through iommu API, the driver
> should still serve them, otherwise, other devices in the same
> group will be impacted. Since identity domain has been mapped
> with the whole available memory space and RMRRs, we don't need
> to worry about the impact on it.
> 
> Link: https://www.spinics.net/lists/iommu/msg40416.html
> Cc: Jerry Snitselaar <jsnitsel@redhat.com>
> Reported-by: Jerry Snitselaar <jsnitsel@redhat.com>
> Fixes: 942067f1b6b97 ("iommu/vt-d: Identify default domains replaced with private")
> Cc: stable@vger.kernel.org # v5.3+
> Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
> ---
>  drivers/iommu/intel-iommu.c | 8 --------
>  1 file changed, 8 deletions(-)

Applied for v5.5, thanks.

