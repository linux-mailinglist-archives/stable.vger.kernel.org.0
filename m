Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 131961CF23C
	for <lists+stable@lfdr.de>; Tue, 12 May 2020 12:21:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728371AbgELKVj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 May 2020 06:21:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:42584 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727783AbgELKVb (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 May 2020 06:21:31 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CE54320736;
        Tue, 12 May 2020 10:21:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589278889;
        bh=aXsknNY4pPaxjYIakVc8U6uboeJkTUVX2PRa3miUVLE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QkZoTPD7us1V1bMWUW4u+Kv4a8f7DvkZWGvSD3tlaoQe9WbPFUfdPB1o3K4MXtc2k
         7OhA5Ye2n5Ls2rR4GnyP5OelnxgFugnUEyHYw8a3GGmZlKylVYC6DvMoAoM6IIrLlj
         jSG37cKcC5vgGAjZ71XipSwbWjYmNGhuBdd8YSEM=
Date:   Tue, 12 May 2020 12:21:27 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     stable@vger.kernel.org, Sasha Levin <sashal@kernel.org>
Subject: Re: List of patches to apply to stable releases (5/11)
Message-ID: <20200512102127.GC3991701@kroah.com>
References: <20200512010721.GA221140@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200512010721.GA221140@roeck-us.net>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 11, 2020 at 06:07:21PM -0700, Guenter Roeck wrote:
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
> Upstream commit fd25ea29093e ("Revert "ACPI / video: Add force_native quirk for HP Pavilion dv6"")
>   upstream: v4.10-rc6
>     Fixes: 6276e53fa8c0 ("ACPI / video: Add force_native quirk for HP Pavilion dv6")
>       in linux-4.4.y: 69e236e70ead
>       in linux-4.9.y: a04465251f94
>       upstream: v4.10-rc1
>     Affected branches:
>       linux-4.4.y
>       linux-4.9.y
> 
> Upstream commit 56f772279a76 ("enic: do not overwrite error code")
>   upstream: v4.18-rc2
>     Fixes: e8588e268509 ("enic: enable rq before updating rq descriptors")
>       in linux-4.4.y: 6af8cf3ca5cb
>       in linux-4.9.y: 92ff7ff0318f
>       in linux-4.14.y: 87337cb5663c
>       upstream: v4.17-rc1
>     Affected branches:
>       linux-4.4.y
>       linux-4.9.y (already applied)
>       linux-4.14.y (already applied)
> 
> Upstream commit afe49de44c27 ("ipv6: fix cleanup ordering for ip6_mr failure")
>   upstream: v4.19-rc3
>     Fixes: 15e668070a64 ("ipv6: reorder icmpv6_init() and ip6_mr_init()")
>       in linux-4.4.y: 7c5deeccc664
>       in linux-4.9.y: 05a59bc2f3c0
>       upstream: v4.11-rc3
>     Affected branches:
>       linux-4.4.y
>       linux-4.9.y (already applied)
>       linux-4.14.y
>         [commit 15e668070a64 is in v4.14 and thus in v4.14.y but its fix isn't]
> 
> Upstream commit bbdc6076d2e5 ("binfmt_elf: move brk out of mmap when doing direct loader exec")
>   upstream: v5.2-rc1
>     Fixes: eab09532d400 ("binfmt_elf: use ELF_ET_DYN_BASE only for PIE")
>       in linux-4.4.y: 7eb968cd04d4
>       in linux-4.9.y: 63c2f8f8c41b
>       upstream: v4.13-rc1
>     Affected branches:
>       linux-4.4.y
>       linux-4.9.y
>       linux-4.14.y (already applied)
>       linux-4.19.y (already applied)
> 
> Upstream commit 6f6060a5c9cc ("x86/apm: Don't access __preempt_count with zeroed fs")
>   upstream: v4.18-rc6
>     Fixes: dd84441a7971 ("x86/speculation: Use IBRS if available before calling into firmware")
>       in linux-4.4.y: 7ec391255421
>       in linux-4.9.y: a27ede1bedcb
>       in linux-4.14.y: c3ffdb5a2ed4
>       upstream: v4.16-rc4
>     Affected branches:
>       linux-4.4.y
>       linux-4.9.y (already applied)
>       linux-4.14.y (already applied)
> 
> Upstream commit 612601d0013f ("Revert "IB/ipoib: Update broadcast object if PKey value was changed in index 0"")
>   upstream: v4.14-rc3
>     Fixes: 9a9b8112699d ("IB/ipoib: Update broadcast object if PKey value was changed in index 0")
>       in linux-4.4.y: 8716c87ec253
>       in linux-4.9.y: 089f13786bdc
>       upstream: v4.12-rc1
>     Affected branches:
>       linux-4.4.y
>       linux-4.9.y (already applied)
> 
> Upstream commit 778fbf417999 ("HID: wacom: Read HID_DG_CONTACTMAX directly for non-generic devices")
>   upstream: v5.7-rc5
>     Fixes: 184eccd40389 ("HID: wacom: generic: read HID_DG_CONTACTMAX from any feature report")
>       in linux-4.14.y: 4e268e9c404a
>       in linux-4.19.y: 8993c673d6c4
>       upstream: v5.3-rc1
>     Affected branches:
>       linux-4.14.y
>       linux-4.19.y
>       linux-5.4.y
>       linux-5.6.y
> 
> Upstream commit f9094b7603c0 ("geneve: only configure or fill UDP_ZERO_CSUM6_RX/TX info when CONFIG_IPV6")
>   upstream: v4.15-rc1
>     Fixes: fd7eafd02121 ("geneve: fix fill_info when link down")
>       in linux-4.14.y: 81a1c2d3f9eb
>       upstream: v4.15-rc1
>     Affected branches:
>       linux-4.14.y
> 
> Upstream commit 57d38f26d81e ("vt: fix unicode console freeing with a common interface")
>   upstream: v5.7-rc5
>     Fixes: 9a98e7a80f95 ("vt: don't use kmalloc() for the unicode screen buffer")
>       in linux-4.19.y: b91c4171c74e
>       in linux-5.4.y: 64882aa0c531
>       in linux-5.6.y: ec6e885a4cb0
>       upstream: v5.7-rc3
>     Affected branches:
>       linux-4.19.y
>       linux-5.4.y
>       linux-5.6.y
> 
> Upstream commit 145cb2f7177d ("sctp: Fix bundling of SHUTDOWN with COOKIE-ACK")
>   upstream: v5.7-rc3
>     Fixes: 4ff40b86262b ("sctp: set chunk transport correctly when it's a new asoc")
>       in linux-4.19.y: cbf23d40cece
>       upstream: v5.0-rc4
>     Affected branches:
>       linux-4.19.y
>       linux-5.4.y
>       linux-5.6.y
> 
> Upstream commit 2ae11c46d5fd ("tty: xilinx_uartps: Fix missing id assignment to the console")
>   upstream: v5.7-rc5
>     Fixes: 18cc7ac8a28e ("Revert "serial: uartps: Register own uart console and driver structures"")
>       in linux-5.4.y: c4606876164c
>       in linux-5.6.y: 29772eb399a3
>       upstream: v5.7-rc3
>     Affected branches:
>       linux-5.4.y
>       linux-5.6.y

Thanks for these, all now queued up!

greg k-h
