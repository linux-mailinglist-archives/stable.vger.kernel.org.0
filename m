Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9B221C454E
	for <lists+stable@lfdr.de>; Mon,  4 May 2020 20:15:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730898AbgEDR74 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 May 2020 13:59:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:54066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730894AbgEDR7z (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 May 2020 13:59:55 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2513B206B8;
        Mon,  4 May 2020 17:59:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588615194;
        bh=FZqtJdOJ6nZu43xCVXVs5WuqsmOOeeUDgUAo1PFw8/A=;
        h=From:To:Cc:Subject:Date:From;
        b=dcHqA2K3fQ3+5kg9uBM1Z2vvIqN1U1TbofNnINKyxF+bczoynUsrIgE85TYo8IfaA
         hzVWda6EU2+GuhToYR7p13Je3sw4a5mLIiznspgzWHhT8PBp5vNHqYk0bOiel7FuKP
         iSu7/trloQaLb0O97RSXOilLFKVTKD9x2E+eGGnM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.9 00/18] 4.9.222-rc1 review
Date:   Mon,  4 May 2020 19:57:10 +0200
Message-Id: <20200504165442.028485341@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.222-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.9.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.9.222-rc1
X-KernelTest-Deadline: 2020-05-06T16:54+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.9.222 release.
There are 18 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 06 May 2020 16:52:55 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.222-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.9.222-rc1

Vasily Averin <vvs@virtuozzo.com>
    drm/qxl: qxl_release use after free

Paul Moore <paul@paul-moore.com>
    selinux: properly handle multiple messages in selinux_netlink_send()

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    dmaengine: dmatest: Fix iteration non-stop logic

Andreas Gruenbacher <agruenba@redhat.com>
    nfs: Fix potential posix_acl refcnt leak in nfs3_set_acl

Arnd Bergmann <arnd@arndb.de>
    ALSA: opti9xx: shut up gcc-10 range warning

Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
    iommu/amd: Fix legacy interrupt remapping for x2APIC-enabled system

Sean Christopherson <sean.j.christopherson@intel.com>
    vfio/type1: Fix VA->PA translation for PFNMAP VMAs in vaddr_get_pfn()

Alaa Hleihel <alaa@mellanox.com>
    RDMA/mlx4: Initialize ib_spec on the stack

Sunwook Eom <speed.eom@samsung.com>
    dm verity fec: fix hash block number in verity_fec_decode

Dexuan Cui <decui@microsoft.com>
    PM: hibernate: Freeze kernel threads in software_resume()

Kai-Heng Feng <kai.heng.feng@canonical.com>
    PM: ACPI: Output correct message on target power state

Takashi Iwai <tiwai@suse.de>
    ALSA: pcm: oss: Place the plugin buffer overflow checks correctly

Wu Bo <wubo40@huawei.com>
    ALSA: hda/hdmi: fix without unlocked before return

Xiyu Yang <xiyuyang19@fudan.edu.cn>
    btrfs: fix block group leak when removing fails

Vasily Averin <vvs@virtuozzo.com>
    drm/qxl: qxl_release leak in qxl_hw_surface_alloc()

Vasily Averin <vvs@virtuozzo.com>
    drm/qxl: qxl_release leak in qxl_draw_dirty_fb()

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/edid: Fix off-by-one in DispID DTD pixel clock

Theodore Ts'o <tytso@mit.edu>
    ext4: fix special inode number checks in __ext4_iget()


-------------

Diffstat:

 Makefile                           |  4 +--
 drivers/acpi/device_pm.c           |  4 +--
 drivers/dma/dmatest.c              |  4 +--
 drivers/gpu/drm/drm_edid.c         |  2 +-
 drivers/gpu/drm/qxl/qxl_cmd.c      | 10 +++---
 drivers/gpu/drm/qxl/qxl_display.c  |  8 ++---
 drivers/gpu/drm/qxl/qxl_draw.c     | 13 ++++----
 drivers/gpu/drm/qxl/qxl_ioctl.c    |  5 +--
 drivers/infiniband/hw/mlx4/main.c  |  3 +-
 drivers/iommu/amd_iommu_init.c     |  2 +-
 drivers/md/dm-verity-fec.c         |  2 +-
 drivers/vfio/vfio_iommu_type1.c    |  4 +--
 fs/btrfs/extent-tree.c             | 16 +++++----
 fs/ext4/inode.c                    |  2 +-
 fs/nfs/nfs3acl.c                   | 22 ++++++++----
 kernel/power/hibernate.c           |  7 ++++
 security/selinux/hooks.c           | 68 ++++++++++++++++++++++++--------------
 sound/core/oss/pcm_plugin.c        | 20 ++++++-----
 sound/isa/opti9xx/miro.c           |  9 +++--
 sound/isa/opti9xx/opti92x-ad1848.c |  9 +++--
 sound/pci/hda/patch_hdmi.c         |  4 ++-
 21 files changed, 134 insertions(+), 84 deletions(-)


