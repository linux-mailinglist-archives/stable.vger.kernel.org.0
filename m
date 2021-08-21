Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C4433F3A77
	for <lists+stable@lfdr.de>; Sat, 21 Aug 2021 13:49:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234448AbhHULuW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 21 Aug 2021 07:50:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:34924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229968AbhHULuT (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 21 Aug 2021 07:50:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 57224611F0;
        Sat, 21 Aug 2021 11:49:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629546580;
        bh=VFBMMgr+xxEPYxFRjw/Y404JXgcngCDOQlsX3wYtrj0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=eY+pBVcIwYg6ZLcfeM6nv1pf2KxGEWKkWhiaa/cL+HxukfNywuPEd8kMKRqiajhWL
         RCpu69CwCM1qo1yhqZKjlIH5JYlLAfpF+nBAR6ohto00PU0wLL4BAj/d7OxsdM20tU
         u75LI4V3mJwoIssv97ydhVpX+ceq12VuOGzroh5Y=
Date:   Sat, 21 Aug 2021 13:49:36 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Fei Li <fei1.li@intel.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        yu1.wang@intel.com, shuox.liu@gmail.com
Subject: Re: [PATCH 3/3] virt: acrn: Introduce interface to fetch platform
 info from the hypervisor
Message-ID: <YSDoUPlP9p+Hmhyp@kroah.com>
References: <20210820060306.10682-1-fei1.li@intel.com>
 <20210820060306.10682-4-fei1.li@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210820060306.10682-4-fei1.li@intel.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 20, 2021 at 02:03:06PM +0800, Fei Li wrote:
> From: Shuo Liu <shuo.a.liu@intel.com>
> 
> The ACRN hypervisor configures the guest VMs information statically and
> builds guest VM configurations within the hypervisor. There are also
> some hardware information are stored in the hypervisor in boot stage.
> The ACRN userspace needs platform information to do the orchestration.
> 
> The HSM provides the following interface for the ACRN userspace to fetch
> platform info:
>  - ACRN_IOCTL_GET_PLATFORM_INFO
>    Exchange the basic information by a struct acrn_platform_info. If the
>    ACRN userspace provides a userspace buffer (whose vma filled in
>    vm_configs_addr), the HSM creates a bounce buffer (kmalloced for
>    continuous memory region) to fetch VM configurations data from the
>    hypervisor.
> 
> Signed-off-by: Shuo Liu <shuo.a.liu@intel.com>
> Signed-off-by: Fei Li <fei1.li@intel.com>
> ---
>  drivers/virt/acrn/hsm.c       | 53 +++++++++++++++++++++++++++++++++++
>  drivers/virt/acrn/hypercall.h | 12 ++++++++
>  include/uapi/linux/acrn.h     | 44 +++++++++++++++++++++++++++++
>  3 files changed, 109 insertions(+)
: 

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
