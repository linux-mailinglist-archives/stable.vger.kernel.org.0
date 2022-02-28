Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADFE94C6D40
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 13:55:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230127AbiB1M4G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 07:56:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229903AbiB1M4F (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 07:56:05 -0500
X-Greylist: delayed 369 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 28 Feb 2022 04:55:27 PST
Received: from theia.8bytes.org (8bytes.org [81.169.241.247])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C61171CAE
        for <stable@vger.kernel.org>; Mon, 28 Feb 2022 04:55:26 -0800 (PST)
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id 819304B0; Mon, 28 Feb 2022 13:49:14 +0100 (CET)
Date:   Mon, 28 Feb 2022 13:49:13 +0100
From:   Joerg Roedel <joro@8bytes.org>
To:     Lu Baolu <baolu.lu@linux.intel.com>
Cc:     Adrian Huang <ahuang12@lenovo.com>,
        iommu@lists.linux-foundation.org, stable@vger.kernel.org
Subject: Re: [PATCH 1/1] iommu/vt-d: Fix double list_add when enabling VMD in
 scalable mode
Message-ID: <YhzEyfJ2Fa5Ikn+x@8bytes.org>
References: <20220221053348.262724-1-baolu.lu@linux.intel.com>
 <20220221053348.262724-2-baolu.lu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220221053348.262724-2-baolu.lu@linux.intel.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 21, 2022 at 01:33:48PM +0800, Lu Baolu wrote:
> Fixes: 474dd1c65064 ("iommu/vt-d: Fix clearing real DMA device's scalable-mode context entries")
> Cc: stable@vger.kernel.org # v5.14+
> Signed-off-by: Adrian Huang <ahuang12@lenovo.com>
> Link: https://lore.kernel.org/r/20220216091307.703-1-adrianhuang0701@gmail.com
> Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
> ---
>  drivers/iommu/intel/iommu.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Applied for v5.17, thanks.

