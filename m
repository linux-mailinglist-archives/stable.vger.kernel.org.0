Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B0D01C7091
	for <lists+stable@lfdr.de>; Wed,  6 May 2020 14:44:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728117AbgEFMon (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 May 2020 08:44:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:56054 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727995AbgEFMon (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 6 May 2020 08:44:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EAFB2206DD;
        Wed,  6 May 2020 12:44:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588769082;
        bh=50PkU1868qfTxMa6Z7CRYoGDUWpB8Lugov23iXyHIjA=;
        h=Date:From:To:Cc:Subject:From;
        b=TJEBjvvYSnr4H4OnMofvV7PALdA5Sk9guhvKK0ICeShtUAZZHzIalyoJyqFEqcKBc
         uTdcJB6flf6m0Nkr2JG5DMEVKK+UdXLZnvvnrgWFpwH4flfXZfGir1rNuJ1ZwiEqdX
         Qt17QT0RYcwDmkljDsALH2LrRwFI4yGo8BNASyyg=
Date:   Wed, 6 May 2020 14:44:40 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.4.222
Message-ID: <20200506124440.GA3143558@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.4.222 kernel.

All users of the 4.4 kernel series must upgrade.

The updated 4.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                           |    2 
 arch/powerpc/perf/power8-pmu.c                     |    2 
 arch/x86/kernel/cpu/perf_event_intel.c             |    3 
 drivers/acpi/device_pm.c                           |    4 -
 drivers/dma/dmatest.c                              |    4 -
 drivers/gpu/drm/qxl/qxl_cmd.c                      |    5 -
 drivers/i2c/busses/i2c-designware-core.c           |    3 
 drivers/infiniband/hw/mlx4/main.c                  |    3 
 drivers/media/platform/exynos4-is/fimc-isp-video.c |    4 -
 drivers/vfio/vfio_iommu_type1.c                    |    4 -
 fs/ext4/inode.c                                    |    2 
 fs/nfs/nfs3acl.c                                   |   22 ++++--
 net/ipv6/raw.c                                     |   12 +++
 security/selinux/hooks.c                           |   69 +++++++++++++--------
 sound/core/oss/pcm_plugin.c                        |   20 +++---
 sound/isa/opti9xx/miro.c                           |    9 +-
 sound/isa/opti9xx/opti92x-ad1848.c                 |    9 +-
 sound/soc/codecs/wm8960.c                          |   32 +++++----
 sound/soc/fsl/imx-spdif.c                          |    2 
 tools/perf/util/hist.c                             |    2 
 20 files changed, 133 insertions(+), 80 deletions(-)

Alaa Hleihel (1):
      RDMA/mlx4: Initialize ib_spec on the stack

Andreas Gruenbacher (1):
      nfs: Fix potential posix_acl refcnt leak in nfs3_set_acl

Andy Shevchenko (2):
      dmaengine: dmatest: Fix iteration non-stop logic
      i2c: designware-pci: use IRQF_COND_SUSPEND flag

Arnd Bergmann (1):
      ALSA: opti9xx: shut up gcc-10 range warning

Greg Kroah-Hartman (1):
      Linux 4.4.222

Jiri Olsa (1):
      perf hists: Fix HISTC_MEM_DCACHELINE width setting

Kai-Heng Feng (1):
      PM: ACPI: Output correct message on target power state

Lars-Peter Clausen (1):
      ASoC: imx-spdif: Fix crash on suspend

Madhavan Srinivasan (1):
      powerpc/perf: Remove PPMU_HAS_SSLOT flag for Power8

Olivier Matz (1):
      ipv6: use READ_ONCE() for inet->hdrincl as in ipv4

Paul Moore (1):
      selinux: properly handle multiple messages in selinux_netlink_send()

Peter Zijlstra (1):
      perf/x86: Fix uninitialized value usage

Rasmus Villemoes (1):
      exynos4-is: fix a format string bug

Sean Christopherson (1):
      vfio/type1: Fix VA->PA translation for PFNMAP VMAs in vaddr_get_pfn()

Stuart Henderson (1):
      ASoC: wm8960: Fix WM8960_SYSCLK_PLL mode

Takashi Iwai (1):
      ALSA: pcm: oss: Place the plugin buffer overflow checks correctly

Theodore Ts'o (1):
      ext4: fix special inode number checks in __ext4_iget()

Vasily Averin (1):
      drm/qxl: qxl_release leak in qxl_hw_surface_alloc()

