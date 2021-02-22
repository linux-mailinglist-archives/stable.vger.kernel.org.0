Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E706D32218F
	for <lists+stable@lfdr.de>; Mon, 22 Feb 2021 22:38:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231939AbhBVVgW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Feb 2021 16:36:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231468AbhBVVgK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Feb 2021 16:36:10 -0500
Received: from mail-qk1-x732.google.com (mail-qk1-x732.google.com [IPv6:2607:f8b0:4864:20::732])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16E5AC061574;
        Mon, 22 Feb 2021 13:35:30 -0800 (PST)
Received: by mail-qk1-x732.google.com with SMTP id m144so14187860qke.10;
        Mon, 22 Feb 2021 13:35:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=J7X0zhfLCINe9toC12zsr4GElTcBHp7P7ApdhE+9HUw=;
        b=WMm+n17Y98oRSwxkMW/C8vCIgDKHYq7V5ZnxGc8yMhqXUChB6EG64gdq1/O5n9YoVU
         BHrGq48XhibTqUsV1hRwWbDgT710TG365SeXWNRlkPHVR+tpAgirAPLkXdcbdspvBxhW
         mQ0LxX9KSMe6Gzbpx42NseQJQFUOCpO2PLgNfLiPbZLrRNrF8xejI7/+R7IuBf86JqRT
         7TO8+TaBf3cITY85d9X4dm3ktONpEk9LLAtSJwdmPENMCBRWWBmAHOGlIrd7/PzOPywl
         kB+1jcWx8OYh2Go7HKS6ijxfF0LdzJ9d/K/uGPC0F2YJ6n5deU2oBSlqD94JBDIZr82N
         ESeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=J7X0zhfLCINe9toC12zsr4GElTcBHp7P7ApdhE+9HUw=;
        b=thT9EXTWFBuLq2k6JBU/xpTSjqj4lY3Q3/KrgTMAokY2eXY9+GZSwe/WmbAZsY9YuU
         U34H3SfbxL6jpmwsKTDn63XCcrTHtVz0DP69QVXFpcEX3OOVBtc45YONpNPDCM43Cb2g
         htCqs7VONW0DTdw894AxgG/1usInnPwAHIJ4PWKWVuNN+SvMfo0HIqayKTHPqaeRUdd8
         3jduLe1GeXiyugGRBNxqgsHxguhxLHN/Zc2ZtdHI38wYtSC6+2bBeMgEQabty8Uy06C9
         Oi1vsShdW4Dh2TC28oBzkHtdk/FZuXGN4SNoqzZ0cTV9ptxg+/Foo8x9mY/UzyWHNnyy
         bicw==
X-Gm-Message-State: AOAM531ULGge3u6k2X2di4eoAt5tNS6rh7nEd8Hezg2wHLZACnFSBhxs
        dTYF71rRH3zSK/UVo+iTjO1CwSmrywQCcTa+
X-Google-Smtp-Source: ABdhPJzh0NlYgVcm0L/yZbJO6NTe6FQjM0dgpECjjLWpSM3gq76pcbTzlWCSXHcKgpIhU/YVmfca/Q==
X-Received: by 2002:a37:4bd5:: with SMTP id y204mr19773279qka.295.1614029729374;
        Mon, 22 Feb 2021 13:35:29 -0800 (PST)
Received: from debian-vm ([189.120.76.30])
        by smtp.gmail.com with ESMTPSA id v135sm13392740qka.98.2021.02.22.13.35.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Feb 2021 13:35:28 -0800 (PST)
From:   Igor <igormtorrente@gmail.com>
X-Google-Original-From: Igor <igor>
Date:   Mon, 22 Feb 2021 18:35:24 -0300
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, stable@vger.kernel.org,
        skhan@linuxfoundation.org
Subject: Re: [PATCH 5.4 00/13] 5.4.100-rc1 review
Message-ID: <YDQjnOPit7uJ1SDB@debian-vm>
References: <20210222121013.583922436@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210222121013.583922436@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 22, 2021 at 01:13:17PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.100 release.
> There are 13 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 24 Feb 2021 12:07:46 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.100-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
>

Compiled and booted on my machine(x86_64) without any dmesg regression.
My compilation uses the default Debian 10 .config(From kernel
4.19.0-14-amd64), followed by olddefconfig.

Tested-by: Igor Matheus Andrade Torrente <igormtorrente@gmail.com>

Best regards,
---
Igor Matheus Andrade Torrente

> -------------
> Pseudo-Shortlog of commits:
> 
> Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>     Linux 5.4.100-rc1
> 
> Matwey V. Kornilov <matwey@sai.msu.ru>
>     media: pwc: Use correct device for DMA
> 
> Jan Beulich <jbeulich@suse.com>
>     xen-blkback: fix error handling in xen_blkbk_map()
> 
> Jan Beulich <jbeulich@suse.com>
>     xen-scsiback: don't "handle" error by BUG()
> 
> Jan Beulich <jbeulich@suse.com>
>     xen-netback: don't "handle" error by BUG()
> 
> Jan Beulich <jbeulich@suse.com>
>     xen-blkback: don't "handle" error by BUG()
> 
> Stefano Stabellini <stefano.stabellini@xilinx.com>
>     xen/arm: don't ignore return errors from set_phys_to_machine
> 
> Jan Beulich <jbeulich@suse.com>
>     Xen/gntdev: correct error checking in gntdev_map_grant_pages()
> 
> Jan Beulich <jbeulich@suse.com>
>     Xen/gntdev: correct dev_bus_addr handling in gntdev_map_grant_pages()
> 
> Jan Beulich <jbeulich@suse.com>
>     Xen/x86: also check kernel mapping in set_foreign_p2m_mapping()
> 
> Jan Beulich <jbeulich@suse.com>
>     Xen/x86: don't bail early from clear_foreign_p2m_mapping()
> 
> Wang Hai <wanghai38@huawei.com>
>     net: bridge: Fix a warning when del bridge sysfs
> 
> Loic Poulain <loic.poulain@linaro.org>
>     net: qrtr: Fix port ID for control messages
> 
> Paolo Bonzini <pbonzini@redhat.com>
>     KVM: SEV: fix double locking due to incorrect backport
> 
> 
> -------------
> 
> Diffstat:
> 
>  Makefile                            |  4 ++--
>  arch/arm/xen/p2m.c                  |  6 ++++--
>  arch/x86/kvm/svm.c                  |  1 -
>  arch/x86/xen/p2m.c                  | 15 +++++++--------
>  drivers/block/xen-blkback/blkback.c | 30 ++++++++++++++++--------------
>  drivers/media/usb/pwc/pwc-if.c      | 22 +++++++++++++---------
>  drivers/net/xen-netback/netback.c   |  4 +---
>  drivers/xen/gntdev.c                | 37 ++++++++++++++++++++-----------------
>  drivers/xen/xen-scsiback.c          |  4 ++--
>  include/xen/grant_table.h           |  1 +
>  net/bridge/br.c                     |  5 ++++-
>  net/qrtr/qrtr.c                     |  2 +-
>  12 files changed, 71 insertions(+), 60 deletions(-)
> 
> 
