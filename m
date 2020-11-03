Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC3932A4672
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 14:30:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729209AbgKCNan (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 08:30:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729133AbgKCNam (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Nov 2020 08:30:42 -0500
Received: from theia.8bytes.org (8bytes.org [IPv6:2a01:238:4383:600:38bc:a715:4b6d:a889])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E5B1C0613D1;
        Tue,  3 Nov 2020 05:30:42 -0800 (PST)
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id 4E9BC433; Tue,  3 Nov 2020 14:30:41 +0100 (CET)
Date:   Tue, 3 Nov 2020 14:30:39 +0100
From:   Joerg Roedel <joro@8bytes.org>
To:     Lu Baolu <baolu.lu@linux.intel.com>
Cc:     Xu Pengfei <pengfei.xu@intel.com>,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 1/1] iommu/vt-d: Fix kernel NULL pointer dereference in
 find_domain()
Message-ID: <20201103133039.GH22888@8bytes.org>
References: <20201028070725.24979-1-baolu.lu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201028070725.24979-1-baolu.lu@linux.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 28, 2020 at 03:07:25PM +0800, Lu Baolu wrote:
> Fixes: e2726daea583d ("iommu/vt-d: debugfs: Add support to show page table internals")
> Cc: stable@vger.kernel.org#v5.6+
> Reported-and-tested-by: Xu Pengfei <pengfei.xu@intel.com>
> Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>

Applied for v5.10, thanks.

