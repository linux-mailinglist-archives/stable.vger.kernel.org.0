Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9A511C457D
	for <lists+stable@lfdr.de>; Mon,  4 May 2020 20:17:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730611AbgEDR65 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 May 2020 13:58:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:51922 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730608AbgEDR64 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 May 2020 13:58:56 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 93BD1206B8;
        Mon,  4 May 2020 17:58:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588615136;
        bh=Ftxti7lop+KcEeLsEEWDtpC4IVlenhFXF+tNff1LMgg=;
        h=From:To:Cc:Subject:Date:From;
        b=2LB97toUFV/ybq/kgEhwWtst7qzSFXog9KSUN4KyeYZEvoF75R+RW/XbP07HCYpQn
         1OLBAuiAZ8zEtKNKhEQJef1kiUko0JzznSdc5OV7aLFgZU+JtVX0I96lHHpZ4BflKU
         KJS+zE7D6f4uUKDnZvzXpDAJWvbZuTUONEAoECvg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.4 00/18] 4.4.222-rc1 review
Date:   Mon,  4 May 2020 19:56:58 +0200
Message-Id: <20200504165441.533160703@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.222-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.4.222-rc1
X-KernelTest-Deadline: 2020-05-06T16:54+00:00
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.4.222 release.
There are 18 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 06 May 2020 16:52:55 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.222-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.4.222-rc1

Paul Moore <paul@paul-moore.com>
    selinux: properly handle multiple messages in selinux_netlink_send()

Olivier Matz <olivier.matz@6wind.com>
    ipv6: use READ_ONCE() for inet->hdrincl as in ipv4

Lars-Peter Clausen <lars@metafoo.de>
    ASoC: imx-spdif: Fix crash on suspend

Stuart Henderson <stuart.henderson@cirrus.com>
    ASoC: wm8960: Fix WM8960_SYSCLK_PLL mode

Rasmus Villemoes <linux@rasmusvillemoes.dk>
    exynos4-is: fix a format string bug

Peter Zijlstra <peterz@infradead.org>
    perf/x86: Fix uninitialized value usage

Madhavan Srinivasan <maddy@linux.vnet.ibm.com>
    powerpc/perf: Remove PPMU_HAS_SSLOT flag for Power8

Jiri Olsa <jolsa@kernel.org>
    perf hists: Fix HISTC_MEM_DCACHELINE width setting

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    i2c: designware-pci: use IRQF_COND_SUSPEND flag

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    dmaengine: dmatest: Fix iteration non-stop logic

Andreas Gruenbacher <agruenba@redhat.com>
    nfs: Fix potential posix_acl refcnt leak in nfs3_set_acl

Arnd Bergmann <arnd@arndb.de>
    ALSA: opti9xx: shut up gcc-10 range warning

Sean Christopherson <sean.j.christopherson@intel.com>
    vfio/type1: Fix VA->PA translation for PFNMAP VMAs in vaddr_get_pfn()

Alaa Hleihel <alaa@mellanox.com>
    RDMA/mlx4: Initialize ib_spec on the stack

Kai-Heng Feng <kai.heng.feng@canonical.com>
    PM: ACPI: Output correct message on target power state

Takashi Iwai <tiwai@suse.de>
    ALSA: pcm: oss: Place the plugin buffer overflow checks correctly

Vasily Averin <vvs@virtuozzo.com>
    drm/qxl: qxl_release leak in qxl_hw_surface_alloc()

Theodore Ts'o <tytso@mit.edu>
    ext4: fix special inode number checks in __ext4_iget()


-------------

Diffstat:

 Makefile                                           |  4 +-
 arch/powerpc/perf/power8-pmu.c                     |  2 +-
 arch/x86/kernel/cpu/perf_event_intel.c             |  3 +-
 drivers/acpi/device_pm.c                           |  4 +-
 drivers/dma/dmatest.c                              |  4 +-
 drivers/gpu/drm/qxl/qxl_cmd.c                      |  5 +-
 drivers/i2c/busses/i2c-designware-core.c           |  3 +-
 drivers/infiniband/hw/mlx4/main.c                  |  3 +-
 drivers/media/platform/exynos4-is/fimc-isp-video.c |  4 +-
 drivers/vfio/vfio_iommu_type1.c                    |  4 +-
 fs/ext4/inode.c                                    |  2 +-
 fs/nfs/nfs3acl.c                                   | 22 ++++---
 net/ipv6/raw.c                                     | 12 +++-
 security/selinux/hooks.c                           | 69 ++++++++++++++--------
 sound/core/oss/pcm_plugin.c                        | 20 ++++---
 sound/isa/opti9xx/miro.c                           |  9 ++-
 sound/isa/opti9xx/opti92x-ad1848.c                 |  9 ++-
 sound/soc/codecs/wm8960.c                          | 32 +++++-----
 sound/soc/fsl/imx-spdif.c                          |  2 -
 tools/perf/util/hist.c                             |  2 +
 20 files changed, 134 insertions(+), 81 deletions(-)


