Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA5D3356CB3
	for <lists+stable@lfdr.de>; Wed,  7 Apr 2021 14:52:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352477AbhDGMxA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Apr 2021 08:53:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:53802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230234AbhDGMxA (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 7 Apr 2021 08:53:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 487486124B;
        Wed,  7 Apr 2021 12:52:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617799970;
        bh=psKgAB8c7VSdJsx3qaR+1NEhKVkYFqGhspq+pM1W8TM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=zb2nDOteMGegAGcJTYAM52aGCFBzIVcoMcUA8A519wjaJEG1buisVhhYUEj82M9iE
         pxIpIe1D/QrJvdCBLz9uII+aw1cOyfp5MzSvc/noIPweDtO7LdWSh5UBYogbfvwyJI
         uxfvBVlMLXaArWO+i+mjGT4SNo/8360O7vEUTJwc=
Date:   Wed, 7 Apr 2021 14:52:48 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jianxiong Gao <jxgao@google.com>
Cc:     stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [PATCH V2 v5.4 1/8] driver core: add a min_align_mask field to
 struct device_dma_parameters
Message-ID: <YG2rIASGZ89UnrlO@kroah.com>
References: <20210406204326.1932888-1-jxgao@google.com>
 <20210406204326.1932888-2-jxgao@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210406204326.1932888-2-jxgao@google.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 06, 2021 at 08:43:20PM +0000, Jianxiong Gao wrote:
> 'commit 36950f2da1ea ("driver core: add a min_align_mask field to struct device_dma_parameters")'
> 
> Some devices rely on the address offset in a page to function
> correctly (NVMe driver as an example). These devices may use
> a different page size than the Linux kernel. The address offset
> has to be preserved upon mapping, and in order to do so, we
> need to record the page_offset_mask first.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Acked-by: Jianxiong Gao <jxgao@google.com>
> Tested-by: Jianxiong Gao <jxgao@google.com>
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> Signed-off-by: Jianxiong Gao <jxgao@google.com>
> ---
>  include/linux/device.h      |  1 +
>  include/linux/dma-mapping.h | 16 ++++++++++++++++
>  2 files changed, 17 insertions(+)

The signed-off-by area is still not correct with what is in Linus's
tree, how did you create this thing?

That does not bode well, so I'm dropping this whole series, see my
comments on the 5.10 series for details.

thanks,

greg k-h
