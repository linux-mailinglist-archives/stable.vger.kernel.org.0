Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D4E7126B39
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 19:56:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729804AbfLSSyu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 13:54:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:50364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730565AbfLSSys (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Dec 2019 13:54:48 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3D5B124676;
        Thu, 19 Dec 2019 18:54:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576781687;
        bh=l0VM2KK+6gXgwI54BF6jSEblSjbhsYy9NayhWjXSQcI=;
        h=From:To:Cc:Subject:Date:From;
        b=ggFOl8La/8LKNqCt7SkN5Ide2lAu+VifTVOm/JIhinxz0eJ3Ntvr1fR+SgOJICv9Q
         Ov38Fx8kS1Zq17O2wXvhF9EhuVibENTUPCXJcLU2FJOx5aCWP/ouh7ldrPNXMNzY/K
         gY4WnjiRbRCdb91AoM9DhABfvuMLCIzKsb/Ce+Mg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 5.4 00/80] 5.4.6-stable review
Date:   Thu, 19 Dec 2019 19:33:52 +0100
Message-Id: <20191219183031.278083125@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-5.4.6-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.6-rc1
X-KernelTest-Deadline: 2019-12-21T18:31+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.4.6 release.
There are 80 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat, 21 Dec 2019 18:24:44 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.6-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.4.6-rc1

changzhu <Changfeng.Zhu@amd.com>
    drm/amdgpu: add invalidate semaphore limit for SRIOV and picasso in gmc9

changzhu <Changfeng.Zhu@amd.com>
    drm/amdgpu: avoid using invalidate semaphore for picasso

Zhenyu Wang <zhenyuw@linux.intel.com>
    drm/i915/gvt: Fix cmd length check for MI_ATOMIC

Xiaojie Yuan <xiaojie.yuan@amd.com>
    drm/amdgpu/gfx10: re-init clear state buffer after gpu reset

Xiaojie Yuan <xiaojie.yuan@amd.com>
    drm/amdgpu/gfx10: explicitly wait for cp idle after halt/unhalt

changzhu <Changfeng.Zhu@amd.com>
    drm/amdgpu: invalidate mmhub semaphore workaround in gmc9/gmc10

changzhu <Changfeng.Zhu@amd.com>
    drm/amdgpu: initialize vm_inv_eng0_sem for gfxhub and mmhub

Alex Deucher <alexander.deucher@amd.com>
    drm/amd/display: add default clocks if not able to fetch them

Alex Deucher <alexander.deucher@amd.com>
    drm/amd/display: re-enable wait in pipelock, but add timeout

Wayne Lin <Wayne.Lin@amd.com>
    drm/dp_mst: Correct the bug in drm_dp_update_payload_part1()

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: fix r1xx/r2xx register checker for POT textures

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/i915/fbc: Disable fbc by default on all glk+

Lyude Paul <lyude@redhat.com>
    drm/nouveau/kms/nv50-: Limit MST BPC to 8

Lyude Paul <lyude@redhat.com>
    drm/nouveau/kms/nv50-: Store the bpc we're using in nv50_head_atom

Lyude Paul <lyude@redhat.com>
    drm/nouveau/kms/nv50-: Call outp_atomic_check_view() before handling PBN

Michael Hernandez <mhernandez@marvell.com>
    scsi: qla2xxx: Fix incorrect SFUB length used for Secure Flash Update MB Cmd

Himanshu Madhani <hmadhani@marvell.com>
    scsi: qla2xxx: Correctly retrieve and interpret active flash region

Roman Bolshakov <r.bolshakov@yadro.com>
    scsi: qla2xxx: Change discovery state before PLOGI

Michael Hernandez <mhernandez@marvell.com>
    scsi: qla2xxx: Added support for MPI and PEP regions for ISP28XX

Roman Bolshakov <r.bolshakov@yadro.com>
    scsi: qla2xxx: Initialize free_work before flushing it

Roman Bolshakov <r.bolshakov@yadro.com>
    scsi: qla2xxx: Ignore NULL pointer in tcm_qla2xxx_free_mcmd

Bart Van Assche <bvanassche@acm.org>
    scsi: iscsi: Fix a potential deadlock in the timeout handler

sheebab <sheebab@cadence.com>
    scsi: ufs: Disable autohibern8 feature in Cadence UFS

Nikos Tsironis <ntsironis@arrikto.com>
    dm thin: Flush data device before committing metadata

Nikos Tsironis <ntsironis@arrikto.com>
    dm thin metadata: Add support for a pre-commit callback

Nikos Tsironis <ntsironis@arrikto.com>
    dm clone: Flush destination device before committing metadata

Nikos Tsironis <ntsironis@arrikto.com>
    dm clone metadata: Use a two phase commit

Nikos Tsironis <ntsironis@arrikto.com>
    dm clone metadata: Track exact changes per transaction

Hou Tao <houtao1@huawei.com>
    dm btree: increase rebalance threshold in __rebalance2()

Mike Snitzer <snitzer@redhat.com>
    dm mpath: remove harmful bio-based optimization

Martin Blumenstingl <martin.blumenstingl@googlemail.com>
    drm: meson: venc: cvbs: fix CVBS mode matching

Thomas Zimmermann <tzimmermann@suse.de>
    drm/mgag200: Flag all G200 SE A machines as broken wrt <startadd>

Thomas Zimmermann <tzimmermann@suse.de>
    drm/mgag200: Add workaround for HW that does not support 'startadd'

Thomas Zimmermann <tzimmermann@suse.de>
    drm/mgag200: Store flags from PCI driver data in device structure

Thomas Zimmermann <tzimmermann@suse.de>
    drm/mgag200: Extract device type from flags

Boris Brezillon <boris.brezillon@collabora.com>
    drm/panfrost: Fix a race in panfrost_gem_free_object()

Boris Brezillon <boris.brezillon@collabora.com>
    drm/panfrost: Fix a BO leak in panfrost_ioctl_mmap_bo()

Boris Brezillon <boris.brezillon@collabora.com>
    drm/panfrost: Fix a race in panfrost_ioctl_madvise()

Navid Emamdoost <navid.emamdoost@gmail.com>
    dma-buf: Fix memory leak in sync_file_merge()

Jiang Yi <giangyi@amazon.com>
    vfio/pci: call irq_bypass_unregister_producer() before freeing irq

Dmitry Osipenko <digetx@gmail.com>
    ARM: tegra: Fix FLOW_CTLR_HALT register clobbering by tegra_resume()

Lihua Yao <ylhuajnu@outlook.com>
    ARM: dts: s3c64xx: Fix init order of clock providers

Paulo Alcantara (SUSE) <pc@cjr.nz>
    cifs: Fix retrieval of DFS referrals in cifs_mount()

Pavel Shilovsky <pshilov@microsoft.com>
    CIFS: Fix NULL pointer dereference in mid callback

Pavel Shilovsky <pshilov@microsoft.com>
    CIFS: Do not miss cancelled OPEN responses

Pavel Shilovsky <pshilov@microsoft.com>
    CIFS: Close open handle after interrupted close

Pavel Shilovsky <pshilov@microsoft.com>
    CIFS: Respect O_SYNC and O_DIRECT flags during reconnect

Long Li <longli@microsoft.com>
    cifs: Don't display RDMA transport on reconnect

Long Li <longli@microsoft.com>
    cifs: smbd: Return -ECONNABORTED when trasnport is not in connected state

Long Li <longli@microsoft.com>
    cifs: smbd: Return -EINVAL when the number of iovs exceeds SMBDIRECT_MAX_SGE

Long Li <longli@microsoft.com>
    cifs: smbd: Add messages on RDMA session destroy and reconnection

Long Li <longli@microsoft.com>
    cifs: smbd: Only queue work for error recovery on memory registration

Long Li <longli@microsoft.com>
    cifs: smbd: Return -EAGAIN when transport is reconnecting

Bjorn Andersson <bjorn.andersson@linaro.org>
    rpmsg: glink: Free pending deferred work on remove

Bjorn Andersson <bjorn.andersson@linaro.org>
    rpmsg: glink: Don't send pending rx_done during remove

Chris Lew <clew@codeaurora.org>
    rpmsg: glink: Fix rpmsg_register_device err handling

Chris Lew <clew@codeaurora.org>
    rpmsg: glink: Put an extra reference during cleanup

Arun Kumar Neelakantam <aneela@codeaurora.org>
    rpmsg: glink: Fix use after free in open_ack TIMEOUT case

Arun Kumar Neelakantam <aneela@codeaurora.org>
    rpmsg: glink: Fix reuse intents memory leak issue

Chris Lew <clew@codeaurora.org>
    rpmsg: glink: Set tail pointer to 0 at end of FIFO

Max Filippov <jcmvbkbc@gmail.com>
    xtensa: fix syscall_set_return_value

Max Filippov <jcmvbkbc@gmail.com>
    xtensa: fix TLB sanity checker

Bob Peterson <rpeterso@redhat.com>
    gfs2: fix glock reference problem in gfs2_trans_remove_revoke

Andreas Gruenbacher <agruenba@redhat.com>
    gfs2: Multi-block allocations in gfs2_page_mkwrite

Max Filippov <jcmvbkbc@gmail.com>
    xtensa: use MEMBLOCK_ALLOC_ANYWHERE for KASAN shadow map

Andreas Gruenbacher <agruenba@redhat.com>
    block: fix "check bi_size overflow before merge"

Leonard Crestez <leonard.crestez@nxp.com>
    PM / QoS: Redefine FREQ_QOS_MAX_DEFAULT_VALUE to S32_MAX

George Cherian <george.cherian@marvell.com>
    PCI: Apply Cavium ACS quirk to ThunderX2 and ThunderX3

Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
    PCI: rcar: Fix missing MACCTLR register setting in initialization sequence

Subbaraya Sundeep <sbhatta@marvell.com>
    PCI: Do not use bus number zero from EA capability

Jian-Hong Pan <jian-hong@endlessm.com>
    PCI/MSI: Fix incorrect MSI-X masking on resume

Steffen Liebergeld <steffen.liebergeld@kernkonzept.com>
    PCI: Fix Intel ACS quirk UPDCR register address

Lukas Wunner <lukas@wunner.de>
    PCI: pciehp: Avoid returning prematurely from sysfs requests

Dexuan Cui <decui@microsoft.com>
    PCI/PM: Always return devices to D0 when thawing

Logan Gunthorpe <logang@deltatee.com>
    PCI/switchtec: Read all 64 bits of part_event_bitmap

Ulf Hansson <ulf.hansson@linaro.org>
    mmc: core: Re-work HW reset for SDIO cards

Ulf Hansson <ulf.hansson@linaro.org>
    mmc: core: Drop check for mmc_card_is_removable() in mmc_rescan()

Chaotian Jing <chaotian.jing@mediatek.com>
    mmc: block: Add CMD13 polling for MMC IOCTLS with R1B response

Chaotian Jing <chaotian.jing@mediatek.com>
    mmc: block: Make card_busy_detect() a bit more generic

Fredrik Noring <noring@nocrew.org>
    USB: Fix incorrect DMA allocations for local memory pool drivers


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/arm/boot/dts/s3c6410-mini6410.dts             |   4 +
 arch/arm/boot/dts/s3c6410-smdk6410.dts             |   4 +
 arch/arm/mach-tegra/reset-handler.S                |   6 +-
 arch/xtensa/include/asm/syscall.h                  |   2 +-
 arch/xtensa/mm/kasan_init.c                        |   4 +-
 arch/xtensa/mm/tlb.c                               |   4 +-
 block/bio.c                                        |   4 +-
 drivers/dma-buf/sync_file.c                        |   2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_gmc.h            |   1 +
 drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c             |  57 ++++++--
 drivers/gpu/drm/amd/amdgpu/gfxhub_v1_0.c           |   2 +
 drivers/gpu/drm/amd/amdgpu/gfxhub_v2_0.c           |   2 +
 drivers/gpu/drm/amd/amdgpu/gmc_v10_0.c             |  57 ++++++++
 drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c              |  73 ++++++++++
 drivers/gpu/drm/amd/amdgpu/mmhub_v1_0.c            |   2 +
 drivers/gpu/drm/amd/amdgpu/mmhub_v2_0.c            |   2 +
 drivers/gpu/drm/amd/amdgpu/mmhub_v9_4.c            |   4 +
 drivers/gpu/drm/amd/amdgpu/soc15.h                 |   4 +-
 .../drm/amd/display/amdgpu_dm/amdgpu_dm_pp_smu.c   |   3 +-
 drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c |  19 +++
 drivers/gpu/drm/drm_dp_mst_topology.c              |   6 +-
 drivers/gpu/drm/i915/display/intel_fbc.c           |   2 +-
 drivers/gpu/drm/i915/gvt/cmd_parser.c              |   6 +-
 drivers/gpu/drm/meson/meson_venc_cvbs.c            |  48 ++++---
 drivers/gpu/drm/mgag200/mgag200_drv.c              |  36 ++++-
 drivers/gpu/drm/mgag200/mgag200_drv.h              |  18 +++
 drivers/gpu/drm/mgag200/mgag200_main.c             |   3 +-
 drivers/gpu/drm/nouveau/dispnv50/atom.h            |   1 +
 drivers/gpu/drm/nouveau/dispnv50/disp.c            | 102 ++++++++------
 drivers/gpu/drm/nouveau/dispnv50/head.c            |   5 +-
 drivers/gpu/drm/panfrost/panfrost_drv.c            |  18 +--
 drivers/gpu/drm/panfrost/panfrost_gem.c            |  15 +-
 drivers/gpu/drm/radeon/r100.c                      |   4 +-
 drivers/gpu/drm/radeon/r200.c                      |   4 +-
 drivers/md/dm-clone-metadata.c                     | 136 ++++++++++++++-----
 drivers/md/dm-clone-metadata.h                     |  17 +++
 drivers/md/dm-clone-target.c                       |  53 +++++++-
 drivers/md/dm-mpath.c                              |  37 +----
 drivers/md/dm-thin-metadata.c                      |  29 ++++
 drivers/md/dm-thin-metadata.h                      |   7 +
 drivers/md/dm-thin.c                               |  42 +++++-
 drivers/md/persistent-data/dm-btree-remove.c       |   8 +-
 drivers/mmc/core/block.c                           | 151 ++++++++-------------
 drivers/mmc/core/core.c                            |  12 +-
 drivers/mmc/core/core.h                            |   2 +
 drivers/mmc/core/sdio.c                            |  28 +++-
 drivers/mmc/core/sdio_bus.c                        |   9 +-
 drivers/pci/controller/pcie-rcar.c                 |   6 +
 drivers/pci/hotplug/pciehp.h                       |   2 +
 drivers/pci/hotplug/pciehp_ctrl.c                  |   6 +-
 drivers/pci/hotplug/pciehp_hpc.c                   |   2 +
 drivers/pci/msi.c                                  |   3 +-
 drivers/pci/pci-driver.c                           |  17 ++-
 drivers/pci/probe.c                                |  16 ++-
 drivers/pci/quirks.c                               |  22 +--
 drivers/pci/switch/switchtec.c                     |   2 +-
 drivers/rpmsg/qcom_glink_native.c                  |  53 ++++++--
 drivers/rpmsg/qcom_glink_smem.c                    |   2 +-
 drivers/scsi/libiscsi.c                            |   4 +-
 drivers/scsi/qla2xxx/qla_attr.c                    |   1 +
 drivers/scsi/qla2xxx/qla_bsg.c                     |   2 +-
 drivers/scsi/qla2xxx/qla_fw.h                      |   4 +
 drivers/scsi/qla2xxx/qla_init.c                    |   2 +
 drivers/scsi/qla2xxx/qla_sup.c                     |  35 +++--
 drivers/scsi/qla2xxx/qla_target.c                  |   1 -
 drivers/scsi/qla2xxx/tcm_qla2xxx.c                 |   2 +
 drivers/scsi/ufs/cdns-pltfrm.c                     |   6 +
 drivers/usb/core/hcd.c                             |  42 +++---
 drivers/usb/storage/scsiglue.c                     |   3 +-
 drivers/vfio/pci/vfio_pci_intrs.c                  |   2 +-
 fs/cifs/cifs_debug.c                               |   5 +
 fs/cifs/cifsglob.h                                 |   1 +
 fs/cifs/connect.c                                  |  53 +++++---
 fs/cifs/file.c                                     |   7 +
 fs/cifs/smb2misc.c                                 |  59 ++++++--
 fs/cifs/smb2ops.c                                  |   8 +-
 fs/cifs/smb2pdu.c                                  |  16 ++-
 fs/cifs/smb2proto.h                                |   3 +
 fs/cifs/smbdirect.c                                |  36 +++--
 fs/cifs/transport.c                                |  17 ++-
 fs/gfs2/file.c                                     |  15 +-
 fs/gfs2/log.c                                      |   8 ++
 fs/gfs2/log.h                                      |   1 +
 fs/gfs2/lops.c                                     |   5 +-
 fs/gfs2/trans.c                                    |   2 +
 include/linux/mmc/card.h                           |   1 +
 include/linux/pm_qos.h                             |   2 +-
 88 files changed, 1093 insertions(+), 440 deletions(-)


