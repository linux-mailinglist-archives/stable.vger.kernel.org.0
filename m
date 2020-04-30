Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 016A51BF418
	for <lists+stable@lfdr.de>; Thu, 30 Apr 2020 11:27:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726391AbgD3J1H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Apr 2020 05:27:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:53278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726127AbgD3J1G (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Apr 2020 05:27:06 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8FECC2186A;
        Thu, 30 Apr 2020 09:27:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588238826;
        bh=+X9Mt+LN61IudrkPFid5NAJzOL5we9TQpLfcHnWKjUA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZoXvkMBkkk9gYBrVTj9IYBATH9v6fJUM75DrgPwMj5zS6BqLTxkAVAjv/e9oam/nY
         erwmbSQi8gckhupIpIL/IFcJ6kM45hypQuTColXXranOwhLhpesKyb3PGUqn2Wt9f0
         1M4PtDb5euo92mKPYFwiOIUI/RM+WepV0yyz7Kzc=
Date:   Thu, 30 Apr 2020 11:27:03 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     stable@vger.kernel.org, Sasha Levin <sashal@kernel.org>
Subject: Re: List of patches to apply to stable releases (4/29)
Message-ID: <20200430092703.GB2503105@kroah.com>
References: <20200429193033.GA83504@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200429193033.GA83504@roeck-us.net>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 29, 2020 at 12:30:33PM -0700, Guenter Roeck wrote:
> Hi,
> 
> Please consider applying the following patches to the listed stable releases.
> 
> The following patches were found to be missing in stable releases by the
> Chrome OS missing patch robot. The patches meet the following criteria.
> - The patch includes a Fixes: tag
> - The patch referenced in the Fixes: tag has been applied to the listed
>   stable release
> - The patch has not been applied to that stable release
> 
> All patches have been applied to the listed stable releases and to at least one
> Chrome OS branch. Resulting images have been build- and runtime-tested (where
> applicable) on real hardware and with virtual hardware on kerneltests.org.
> 
> Thanks,
> Guenter
> 
> ---
> Upstream commit a8dd397903a6 ("sctp: use right member as the param of list_for_each_entry")
>   upstream: v4.15-rc2
>     Fixes: d04adf1b3551 ("sctp: reset owner sk for data chunks on out queues when migrating a sock")
>       in linux-4.4.y: 4b5bb7723da1
>       in linux-4.9.y: b89fc6a5caff
>       upstream: v4.14-rc7
>     Affected branches:
>       linux-4.4.y
>       linux-4.9.y (already applied)
>       linux-4.14.y (already applied)
> i
> Upstream commit 2d84a2d19b61 ("fuse: fix possibly missed wake-up after abort")
>   upstream: v4.20-rc3
>     Fixes: b8f95e5d13f5 ("fuse: umount should wait for all requests")
>       in linux-4.4.y: 4d6ef17a060c
>       in linux-4.9.y: 6465d7688c2d
>       in linux-4.14.y: 973206923812
>       upstream: v4.19-rc1
>     Affected branches:
>       linux-4.4.y
>       linux-4.9.y
>       linux-4.14.y (already applied)
>       linux-4.19.y (already applied)
> 
> Upstream commit d9b8a67b3b95 ("mtd: cfi: fix deadloop in cfi_cmdset_0002.c do_write_buffer")
>   upstream: v5.1-rc4
>     Fixes: dfeae1073583 ("mtd: cfi_cmdset_0002: Change write buffer to check correct value")
>       in linux-4.4.y: 5069cd50117a
>       in linux-4.9.y: e9dc5dce0925
>       in linux-4.14.y: 746c1362c434
>       upstream: v4.18-rc1
>     Affected branches:
>       linux-4.4.y
>       linux-4.9.y
>       linux-4.14.y
>       linux-4.19.y
> 
> Upstream commit 467d12f5c784 ("include/uapi/linux/swab.h: fix userspace breakage, use __BITS_PER_LONG for swap")
>   upstream: v5.6-rc3
>     Fixes: d5767057c9a7 ("uapi: rename ext2_swab() to swab() and share globally in swab.h")
>       in linux-4.14.y: 4eb9d5bc7065
>       in linux-4.19.y: 9af535dc019e
>       in linux-5.4.y: 8b0f08036659
>       in linux-5.5.y: b83fb35b0300
>       upstream: v5.6-rc1
>     Affected branches:
>       linux-4.14.y
>       linux-4.19.y
>       linux-5.4.y (already applied)
> 
> Upstream commit 60d488571083 ("binder: take read mode of mmap_sem in binder_alloc_free_page()")
>   upstream: v5.2-rc1
>     Fixes: 5cec2d2e5839 ("binder: fix race between munmap() and direct reclaim")
>       in linux-4.14.y: c2a035d7822a
>       in linux-4.19.y: 9d57cfd4e9d8
>       upstream: v5.1-rc3
>     Affected branches:
>       linux-4.14.y
>       linux-4.19.y
> 
> Upstream commit e2bcb65782f9 ("ASoC: stm32: sai: fix sai probe")
>   upstream: v5.7-rc3
>     Fixes: 0d6defc7e0e4 ("ASoC: stm32: sai: manage rebind issue")
>       in linux-5.4.y: af7dd05d7c8f
>       in linux-5.5.y: 1ab75b0342d2
>       upstream: v5.6-rc5
>     Affected branches:
>       linux-5.4.y
>       linux-5.6.y

All now queued up, thanks for the list!

greg k-h
