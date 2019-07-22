Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9EE6F70480
	for <lists+stable@lfdr.de>; Mon, 22 Jul 2019 17:51:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728446AbfGVPvS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Jul 2019 11:51:18 -0400
Received: from 8bytes.org ([81.169.241.247]:44876 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727309AbfGVPvS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Jul 2019 11:51:18 -0400
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id D4CAF1F2; Mon, 22 Jul 2019 17:51:16 +0200 (CEST)
Date:   Mon, 22 Jul 2019 17:51:15 +0200
From:   Joerg Roedel <joro@8bytes.org>
To:     Chris Wilson <chris@chris-wilson.co.uk>
Cc:     iommu@lists.linux-foundation.org, intel-gfx@lists.freedesktop.org,
        Robin Murphy <robin.murphy@arm.com>,
        Joerg Roedel <jroedel@suse.de>, stable@vger.kernel.org
Subject: Re: [PATCH] iommu/iova: Remove stale cached32_node
Message-ID: <20190722155115.GH12009@8bytes.org>
References: <20190720180848.15192-1-chris@chris-wilson.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190720180848.15192-1-chris@chris-wilson.co.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jul 20, 2019 at 07:08:48PM +0100, Chris Wilson wrote:
> ---
>  drivers/iommu/iova.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)

Applied to iommu/fixes.

