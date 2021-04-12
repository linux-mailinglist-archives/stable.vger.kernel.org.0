Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 256B835D088
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 20:45:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237222AbhDLSpm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 14:45:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:53862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229970AbhDLSpl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 14:45:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 69BCD61206;
        Mon, 12 Apr 2021 18:45:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618253122;
        bh=mawXYSh6eNcajH1P3AgMIeyVtwrpN/4s38ab6F6/ys8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=1er7MOxgf1ugZiEtjVuIiKihRKT0JY4jsjFnhR2kOj/szOpUMtwrbzIbbSOFCEZgv
         XtJl+zsdk34WKIH63QM/3nIBSTGPKtmy4g26/r6YWHbcMdxl6PrTrc35a+ndwFLmVO
         0n75s2xu3imSLs+IwJybYBwqkL9u2Bw6cZbmM50k=
Date:   Mon, 12 Apr 2021 20:45:19 +0200
From:   "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To:     Saeed Mirzamohammadi <saeed.mirzamohammadi@oracle.com>
Cc:     Lu Baolu <baolu.lu@linux.intel.com>,
        Camille Lu <camille.lu@hpe.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Joerg Roedel <joro@8bytes.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH 5.4 v2 1/1] iommu/vt-d: Fix agaw for a supported 48 bit
 guest address width
Message-ID: <YHSVPwE5qomsmtSA@kroah.com>
References: <20210407184030.21683-1-saeed.mirzamohammadi@oracle.com>
 <deca9431-a52a-2818-4493-5a6ffeadccb9@linux.intel.com>
 <E3377E7A-073F-4D9C-92FE-8CC4836343AF@oracle.com>
 <036429a7-9924-7ed5-6be9-2bd087594e9b@linux.intel.com>
 <DEA60498-1BFD-441D-B641-BC843695ED96@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DEA60498-1BFD-441D-B641-BC843695ED96@oracle.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 12, 2021 at 06:25:44PM +0000, Saeed Mirzamohammadi wrote:
> Hi Greg,
> 
> This patch fixes an issue with the IOMMU driver and it only applies to 5.4, 4.19, and 4.14 stable kernels. May I know when this patch would be available in the stable kernels?
> 
> Subject: iommu/vt-d: Fix agaw for a supported 48 bit guest address width
> 


<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
