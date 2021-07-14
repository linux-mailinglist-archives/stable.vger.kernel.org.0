Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 454523C82FD
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 12:34:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238836AbhGNKhc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 06:37:32 -0400
Received: from 8bytes.org ([81.169.241.247]:37792 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237788AbhGNKhb (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 06:37:31 -0400
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id 004BB352; Wed, 14 Jul 2021 12:34:37 +0200 (CEST)
Date:   Wed, 14 Jul 2021 12:34:36 +0200
From:   Joerg Roedel <joro@8bytes.org>
To:     Lu Baolu <baolu.lu@linux.intel.com>
Cc:     Sanjay Kumar <sanjay.k.kumar@intel.com>,
        Jon Derrick <jonathan.derrick@intel.com>,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 1/1] iommu/vt-d: Fix clearing real DMA device's
 scalable-mode context entries
Message-ID: <YO69vCLgf3CvSAT1@8bytes.org>
References: <20210712071712.3416949-1-baolu.lu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210712071712.3416949-1-baolu.lu@linux.intel.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 12, 2021 at 03:17:12PM +0800, Lu Baolu wrote:
>  drivers/iommu/intel/iommu.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)

Applied, thanks.
