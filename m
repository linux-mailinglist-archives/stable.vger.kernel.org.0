Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68D8C3F3A73
	for <lists+stable@lfdr.de>; Sat, 21 Aug 2021 13:49:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234441AbhHULuC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 21 Aug 2021 07:50:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:34510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229968AbhHULuB (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 21 Aug 2021 07:50:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C965F611CB;
        Sat, 21 Aug 2021 11:49:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629546562;
        bh=LKGaF6AanJDgf94XmfHI472lbsoLuvOzEqcCiQ93a6o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qn2zF4zHhThcTb0y1kTbN0bdk7G5p9bU38K25uB23xdPUKMQAF6YQyvlB+d0t2cCZ
         i6jXRmTy64qxCByTzSgxqXPJ47Q9bm42bS2ZC1MYuAmL0oSHoZznAWavNq9NSX0pRj
         k2wmiQ3ODDr9qWTMGkMcsMolrTAx2WmPL1B8rYY4=
Date:   Sat, 21 Aug 2021 13:49:19 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Fei Li <fei1.li@intel.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        yu1.wang@intel.com, shuox.liu@gmail.com
Subject: Re: [PATCH 1/3] virt: acrn: Introduce interfaces for MMIO device
 passthrough
Message-ID: <YSDoP0mgMrQLaXxG@kroah.com>
References: <20210820060306.10682-1-fei1.li@intel.com>
 <20210820060306.10682-2-fei1.li@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210820060306.10682-2-fei1.li@intel.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 20, 2021 at 02:03:04PM +0800, Fei Li wrote:
> From: Shuo Liu <shuo.a.liu@intel.com>
> 
> MMIO device passthrough enables an OS in a virtual machine to directly
> access a MMIO device in the host. It promises almost the native
> performance, which is required in performance-critical scenarios of
> ACRN.
> 
> HSM provides the following ioctls:
>   - Assign - ACRN_IOCTL_ASSIGN_MMIODEV
>     Pass data struct acrn_mmiodev from userspace to the hypervisor, and
>     inform the hypervisor to assign a MMIO device to a User VM.
> 
>   - De-assign - ACRN_IOCTL_DEASSIGN_PCIDEV
>     Pass data struct acrn_mmiodev from userspace to the hypervisor, and
>     inform the hypervisor to de-assign a MMIO device from a User VM.
> 
> Signed-off-by: Shuo Liu <shuo.a.liu@intel.com>
> Signed-off-by: Fei Li <fei1.li@intel.com>
> ---
>  drivers/virt/acrn/hsm.c       | 25 +++++++++++++++++++++++++
>  drivers/virt/acrn/hypercall.h | 26 ++++++++++++++++++++++++++
>  include/uapi/linux/acrn.h     | 28 ++++++++++++++++++++++++++++
>  3 files changed, 79 insertions(+)
> 

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
