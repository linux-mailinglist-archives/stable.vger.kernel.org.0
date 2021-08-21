Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C2623F3A75
	for <lists+stable@lfdr.de>; Sat, 21 Aug 2021 13:49:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234520AbhHULuJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 21 Aug 2021 07:50:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:34688 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234466AbhHULuJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 21 Aug 2021 07:50:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 413B7611CB;
        Sat, 21 Aug 2021 11:49:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629546570;
        bh=Vc4SZYiaNxK5ztZcTp2G+n5lW8xqzWWlj/0WxDYBWBU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=wdbsEyAGnILl7tKTBVH1jnxE49z8ICDju/4ZJ7hVvWTpjxzohOKFMBBxfrxF/yxL8
         uxq1Eri73coNkMWgiHmaUO6oAzR1mOkw8bhzs9BZD6yMOVWMH19xUoh49LvMEo52Ba
         UGe/0QGa+Tjkpmfl5Z/ONfm4c+nR87OQj2cPlS9I=
Date:   Sat, 21 Aug 2021 13:49:26 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Fei Li <fei1.li@intel.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        yu1.wang@intel.com, shuox.liu@gmail.com
Subject: Re: [PATCH 2/3] virt: acrn: Introduce interfaces for virtual device
 creating/destroying
Message-ID: <YSDoRlr7xBy60eNa@kroah.com>
References: <20210820060306.10682-1-fei1.li@intel.com>
 <20210820060306.10682-3-fei1.li@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210820060306.10682-3-fei1.li@intel.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 20, 2021 at 02:03:05PM +0800, Fei Li wrote:
> From: Shuo Liu <shuo.a.liu@intel.com>
> 
> The ACRN hypervisor can emulate a virtual device within hypervisor for a
> Guest VM. The emulated virtual device can work without the ACRN
> userspace after creation. The hypervisor do the emulation of that device.
> 
> To support the virtual device creating/destroying, HSM provides the
> following ioctls:
>   - ACRN_IOCTL_CREATE_VDEV
>     Pass data struct acrn_vdev from userspace to the hypervisor, and inform
>     the hypervisor to create a virtual device for a User VM.
>   - ACRN_IOCTL_DESTROY_VDEV
>     Pass data struct acrn_vdev from userspace to the hypervisor, and inform
>     the hypervisor to destroy a virtual device of a User VM.
> 
> Signed-off-by: Shuo Liu <shuo.a.liu@intel.com>
> Signed-off-by: Fei Li <fei1.li@intel.com>
> ---
>  drivers/virt/acrn/hsm.c       | 24 ++++++++++++++++++++
>  drivers/virt/acrn/hypercall.h | 26 ++++++++++++++++++++++
>  include/uapi/linux/acrn.h     | 42 +++++++++++++++++++++++++++++++++++
>  3 files changed, 92 insertions(+)
> 


<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
