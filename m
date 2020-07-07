Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0A5C2171A8
	for <lists+stable@lfdr.de>; Tue,  7 Jul 2020 17:43:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729308AbgGGPXm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jul 2020 11:23:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:36644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728306AbgGGPXc (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jul 2020 11:23:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 211BC206F6;
        Tue,  7 Jul 2020 15:23:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594135411;
        bh=tx1EXrE6nV0wmRTZNMGPVkvWcXAB9YQ3khc0wx/yOKQ=;
        h=From:To:Cc:Subject:Date:From;
        b=ioVQ7kd+W5v61cRLw/IYW4yZAtoZPod5FsIbNVvQHATyELq6H0N9CyOBvZPWx25d9
         ZXNjVOnlQ1yws/74TzCUa/sKnFwvCi0SGYFK7ZYM4Po7a6JBVJwBOtOGGokaG7ayBl
         YzirFJfAH8Uqa4jUa3bGXBQ7zBWyXQSJHW1x/MN8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 5.7 000/112] 5.7.8-rc1 review
Date:   Tue,  7 Jul 2020 17:16:05 +0200
Message-Id: <20200707145800.925304888@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-5.7.8-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.7.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.7.8-rc1
X-KernelTest-Deadline: 2020-07-09T14:58+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.7.8 release.
There are 112 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 09 Jul 2020 14:57:34 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.7.8-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.7.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.7.8-rc1

Peter Jones <pjones@redhat.com>
    efi: Make it possible to disable efivar_ssdt entirely

Hou Tao <houtao1@huawei.com>
    dm zoned: assign max_io_len correctly

Barry Song <song.bao.hua@hisilicon.com>
    mm/cma.c: use exact_nid true to fix possible per-numa cma leak

Mike Kravetz <mike.kravetz@oracle.com>
    mm/hugetlb.c: fix pages per hugetlb calculation

Marc Zyngier <maz@kernel.org>
    irqchip/gic: Atomically update affinity

Sumit Semwal <sumit.semwal@linaro.org>
    dma-buf: Move dma_buf_release() from fops to dentry_ops

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/atomfirmware: fix vram_info fetching for renoir

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu: use %u rather than %d for sclk/mclk

Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
    drm/amd/display: Only revalidate bandwidth on medium and fast updates

Ivan Mironov <mironov.ivan@gmail.com>
    drm/amd/powerplay: Fix NULL dereference in lock_bus() on Vega20 w/o RAS

Rodrigo Vivi <rodrigo.vivi@intel.com>
    drm/i915: Include asm sources for {ivb, hsw}_clear_kernel.c

Hauke Mehrtens <hauke@hauke-m.de>
    MIPS: Add missing EHB in mtc0 -> mfc0 sequence for DSPen

Martin Blumenstingl <martin.blumenstingl@googlemail.com>
    MIPS: lantiq: xway: sysctrl: fix the GPHY clock alias names

Sean Christopherson <sean.j.christopherson@intel.com>
    x86/split_lock: Don't write MSR_TEST_CTRL on CPUs that aren't whitelisted

Bob Peterson <rpeterso@redhat.com>
    gfs2: fix trans slab error when withdraw occurs inside log_flush

Sumeet Pawnikar <sumeet.r.pawnikar@intel.com>
    ACPI: fan: Fix Tiger Lake ACPI device ID

Finley Xiao <finley.xiao@rock-chips.com>
    thermal/drivers/cpufreq_cooling: Fix wrong frequency converted from power

Jan Kundrát <jan.kundrat@cesnet.cz>
    hwmon: (pmbus) Fix page vs. register when accessing fans

Joseph Salisbury <joseph.salisbury@microsoft.com>
    Drivers: hv: Change flag to write log level in panic msg to false

Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
    cifs: Fix the target file was deleted when rename failed.

Paul Aurich <paul@darkrain42.org>
    SMB3: Honor 'handletimeout' flag for multiuser mounts

Paul Aurich <paul@darkrain42.org>
    SMB3: Honor lease disabling for multiuser mounts

Paul Aurich <paul@darkrain42.org>
    SMB3: Honor persistent/resilient handle flags for multiuser mounts

Paul Aurich <paul@darkrain42.org>
    SMB3: Honor 'seal' flag for multiuser mounts

Daniel Jordan <daniel.m.jordan@oracle.com>
    padata: upgrade smp_mb__after_atomic to smp_mb in padata_do_serial

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "ALSA: usb-audio: Improve frames size computation"

J. Bruce Fields <bfields@redhat.com>
    nfsd: apply umask on fs without ACL support

Krzysztof Kozlowski <krzk@kernel.org>
    spi: spi-fsl-dspi: Fix external abort on interrupt in resume or exit paths

Jens Axboe <axboe@kernel.dk>
    io_uring: fix regression with always ignoring signals in io_cqring_wait()

Wolfram Sang <wsa+renesas@sang-engineering.com>
    i2c: mlxcpld: check correct size of maximum RECV_LEN packet

Ricardo Ribalda <ribalda@kernel.org>
    i2c: designware: platdrv: Set class based on DMI

Chris Packham <chris.packham@alliedtelesis.co.nz>
    i2c: algo-pca: Add 0x78 as SCL stuck low status for PCA9665

Kees Cook <keescook@chromium.org>
    samples/vfs: avoid warning in statx override

David Gibson <david@gibson.dropbear.id.au>
    tpm: ibmvtpm: Wait for ready buffer before probing for TPM2 attributes

Christoph Hellwig <hch@lst.de>
    nvme: fix a crash in nvme_mpath_add_disk

Sagi Grimberg <sagi@grimberg.me>
    nvme: fix identify error status silent ignore

Paul Aurich <paul@darkrain42.org>
    SMB3: Honor 'posix' flag for multiuser mounts

Hou Tao <houtao1@huawei.com>
    virtio-blk: free vblk-vqs in error path of virtblk_probe()

Chen-Yu Tsai <wens@csie.org>
    drm: sun4i: hdmi: Remove extra HPD polling

J. Bruce Fields <bfields@redhat.com>
    nfsd: fix nfsdfs inode reference count leak

J. Bruce Fields <bfields@redhat.com>
    nfsd4: fix nfsdfs reference count loop

J. Bruce Fields <bfields@redhat.com>
    nfsd: clients don't need to break their own delegations

J. Bruce Fields <bfields@redhat.com>
    kthread: save thread function

Dien Pham <dien.pham.ry@renesas.com>
    thermal/drivers/rcar_gen3: Fix undefined temperature if negative

Tiezhu Yang <yangtiezhu@loongson.cn>
    thermal/drivers/sprd: Fix return value of sprd_thm_probe()

Michael Kao <michael.kao@mediatek.com>
    thermal/drivers/mediatek: Fix bank number settings on mt8183

Dan Carpenter <dan.carpenter@oracle.com>
    scsi: qla2xxx: Fix a condition in qla2x00_find_all_fabric_devs()

Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
    hwmon: (acpi_power_meter) Fix potential memory leak in acpi_power_meter_add()

Chu Lin <linchuyuan@google.com>
    hwmon: (max6697) Make sure the OVERT mask is set correctly

KP Singh <kpsingh@google.com>
    security: Fix hook iteration and default value for inode_copy_up_xattr

Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
    cxgb4: fix SGE queue dump destination buffer context

Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
    cxgb4: use correct type for all-mask IP address comparison

Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
    cxgb4: fix endian conversions for L4 ports in filters

Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
    cxgb4: parse TC-U32 key values and masks natively

Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
    cxgb4: use unaligned conversion for fetching timestamp

Taehee Yoo <ap420073@gmail.com>
    hsr: avoid to create proc file after unregister

Taehee Yoo <ap420073@gmail.com>
    hsr: remove hsr interface if all slaves are removed

Dave Chinner <dchinner@redhat.com>
    xfs: fix use-after-free on CIL context on shutdown

Mark Zhang <markz@mellanox.com>
    RDMA/counter: Query a counter before release

Zenghui Yu <yuzenghui@huawei.com>
    irqchip/gic-v4.1: Use readx_poll_timeout_atomic() to fix sleep in atomic

Claudiu Manoil <claudiu.manoil@nxp.com>
    enetc: Fix HW_VLAN_CTAG_TX|RX toggling

Po Liu <Po.Liu@nxp.com>
    net: enetc: add hw tc hw offload features for PSPF capability

Paolo Abeni <pabeni@redhat.com>
    mptcp: drop MP_JOIN request sock on syn cookies

David Howells <dhowells@redhat.com>
    rxrpc: Fix afs large storage transmission performance drop

Filipe Manana <fdmanana@suse.com>
    btrfs: fix RWF_NOWAIT writes blocking on extent locks and waiting for IO

Chen Tao <chentao107@huawei.com>
    drm/msm/dpu: fix error return code in dpu_encoder_init

Jens Axboe <axboe@kernel.dk>
    io_uring: use signal based task_work running

Oleg Nesterov <oleg@redhat.com>
    task_work: teach task_work_add() to do signal_wake_up()

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: af_alg - fix use-after-free in af_alg_accept() due to bh_lock_sock()

James Bottomley <James.Bottomley@HansenPartnership.com>
    tpm: Fix TIS locality timeout problems

Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
    selftests: tpm: Use /bin/sh instead of /bin/bash

Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
    Revert "tpm: selftest: cleanup after unseal with wrong auth/policy test"

Douglas Anderson <dianders@chromium.org>
    kgdb: Avoid suspicious RCU usage warning

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: fix current->mm NULL dereference on exit

Sagi Grimberg <sagi@grimberg.me>
    nvme-multipath: fix bogus request queue reference put

Anton Eidelman <anton@lightbitslabs.com>
    nvme-multipath: fix deadlock due to head->lock

Anton Eidelman <anton@lightbitslabs.com>
    nvme-multipath: fix deadlock between ana_work and scan_work

Sagi Grimberg <sagi@grimberg.me>
    nvme: fix possible deadlock when I/O is blocked

Keith Busch <kbusch@kernel.org>
    nvme-multipath: set bdi capabilities once

Xuan Zhuo <xuanzhuo@linux.alibaba.com>
    io_uring: fix io_sq_thread no schedule when busy

Christian Borntraeger <borntraeger@de.ibm.com>
    s390/debug: avoid kernel warning on too large number of pages

Steven Rostedt (VMware) <rostedt@goodmis.org>
    tools lib traceevent: Handle __attribute__((user)) in field names

Steven Rostedt (VMware) <rostedt@goodmis.org>
    tools lib traceevent: Add append() function helper for appending strings

Zqiang <qiang.zhang@windriver.com>
    usb: usbtest: fix missing kfree(dev->buf) in usbtest_disconnect

David Howells <dhowells@redhat.com>
    rxrpc: Fix race between incoming ACK parser and retransmitter

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: fix {SQ,IO}POLL with unsupported opcodes

Vlastimil Babka <vbabka@suse.cz>
    mm, dump_page(): do not crash with invalid mapping pointer

Qian Cai <cai@lca.pw>
    mm/slub: fix stack overruns with SLUB_STATS

Dongli Zhang <dongli.zhang@oracle.com>
    mm/slub.c: fix corrupted freechain in deactivate_slab()

Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
    powerpc/book3s64/kvm: Fix secondary page table walk warning during migration

Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
    powerpc/kvm/book3s: Add helper to walk partition scoped linux page table.

Tero Kristo <t-kristo@ti.com>
    soc: ti: omap-prm: use atomic iopoll instead of sleeping one

Valentin Schneider <valentin.schneider@arm.com>
    sched/debug: Make sd->flags sysctl read-only

Guchun Chen <guchun.chen@amd.com>
    drm/amdgpu: fix kernel page fault issue by ras recovery on sGPU

Evan Quan <evan.quan@amd.com>
    drm/amdgpu: fix non-pointer dereference for non-RAS supported

John Clements <john.clements@amd.com>
    drm/amdgpu: disable ras query and iject during gpu reset

Chris Wilson <chris@chris-wilson.co.uk>
    drm/i915/gt: Mark timeline->cacheline as destroyed after rcu grace period

YueHaibing <yuehaibing@huawei.com>
    tipc: Fix NULL pointer dereference in __tipc_sendstream()

Tuomas Tynkkynen <tuomas.tynkkynen@iki.fi>
    usbnet: smsc95xx: Fix use-after-free after removal

Tuong Lien <tuong.t.lien@dektech.com.au>
    tipc: fix kernel WARNING in tipc_msg_append()

Tuong Lien <tuong.t.lien@dektech.com.au>
    tipc: add test for Nagle algorithm effectiveness

Ahmed Abdelsalam <ahabdels@gmail.com>
    seg6: fix seg6_validate_srh() to avoid slab-out-of-bounds

Stylon Wang <stylon.wang@amd.com>
    drm/amd/display: Fix ineffective setting of max bpc property

Stylon Wang <stylon.wang@amd.com>
    drm/amd/display: Fix incorrectly pruned modes with deep color

Hugh Dickins <hughd@google.com>
    mm: fix swap cache node allocation mask

Filipe Manana <fdmanana@suse.com>
    btrfs: fix race between block group removal and block group creation

Qu Wenruo <wqu@suse.com>
    btrfs: block-group: refactor how we delete one block group item

Sungjong Seo <sj1557.seo@samsung.com>
    exfat: flush dirty metadata in fsync

Namjae Jeon <namjae.jeon@samsung.com>
    exfat: move setting VOL_DIRTY over exfat_remove_entries()

Hyunchul Lee <hyc.lee@gmail.com>
    exfat: call sync_filesystem for read-only remount

Dan Carpenter <dan.carpenter@oracle.com>
    exfat: add missing brelse() calls on error paths

Hyeongseok.Kim <Hyeongseok@gmail.com>
    exfat: Set the unused characters of FileName field to the value 0000h


-------------

Diffstat:

 Documentation/filesystems/locking.rst              |   2 +
 Makefile                                           |   4 +-
 arch/mips/kernel/traps.c                           |   1 +
 arch/mips/lantiq/xway/sysctrl.c                    |   8 +-
 arch/powerpc/include/asm/kvm_book3s_64.h           |  23 ++++
 arch/powerpc/kvm/book3s_64_mmu_radix.c             |  45 +++++--
 arch/powerpc/kvm/book3s_hv_nested.c                |   2 +-
 arch/s390/kernel/debug.c                           |   3 +-
 arch/x86/kernel/cpu/intel.c                        |  11 +-
 crypto/af_alg.c                                    |  26 ++--
 crypto/algif_aead.c                                |   9 +-
 crypto/algif_hash.c                                |   9 +-
 crypto/algif_skcipher.c                            |   9 +-
 drivers/acpi/fan.c                                 |   2 +-
 drivers/block/virtio_blk.c                         |   1 +
 drivers/char/tpm/tpm-dev-common.c                  |  19 ++-
 drivers/char/tpm/tpm_ibmvtpm.c                     |  14 +--
 drivers/dma-buf/dma-buf.c                          |  54 ++++-----
 drivers/firmware/efi/Kconfig                       |  11 ++
 drivers/firmware/efi/efi.c                         |   2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_atomfirmware.c   |   1 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c         |   3 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_pm.c             |   4 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c            |  29 ++++-
 drivers/gpu/drm/amd/amdgpu/amdgpu_ras.h            |   4 +
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  | 103 ++++++++++------
 drivers/gpu/drm/amd/display/dc/core/dc.c           |  10 +-
 .../gpu/drm/amd/powerplay/smumgr/vega20_smumgr.c   |  11 +-
 drivers/gpu/drm/i915/gt/intel_timeline.c           |  12 +-
 drivers/gpu/drm/i915/gt/shaders/README             |  46 +++++++
 .../gpu/drm/i915/gt/shaders/clear_kernel/hsw.asm   | 119 ++++++++++++++++++
 .../gpu/drm/i915/gt/shaders/clear_kernel/ivb.asm   | 117 ++++++++++++++++++
 drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c        |   2 +-
 drivers/gpu/drm/sun4i/sun4i_hdmi_enc.c             |   5 +-
 drivers/hv/vmbus_drv.c                             |   2 +-
 drivers/hwmon/acpi_power_meter.c                   |   4 +-
 drivers/hwmon/max6697.c                            |   7 +-
 drivers/hwmon/pmbus/pmbus_core.c                   |   8 +-
 drivers/i2c/algos/i2c-algo-pca.c                   |   3 +-
 drivers/i2c/busses/i2c-designware-platdrv.c        |  14 ++-
 drivers/i2c/busses/i2c-mlxcpld.c                   |   4 +-
 drivers/infiniband/core/counters.c                 |   4 +-
 drivers/irqchip/irq-gic-v3-its.c                   |   8 +-
 drivers/irqchip/irq-gic.c                          |  14 +--
 drivers/md/dm-zoned-target.c                       |   2 +-
 drivers/net/ethernet/chelsio/cxgb4/cudbg_lib.c     |   6 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c  |  25 ++--
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c    |   2 +-
 .../net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c   |  30 ++---
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_u32.c  |  18 +--
 .../ethernet/chelsio/cxgb4/cxgb4_tc_u32_parse.h    | 122 ++++++++++++-------
 drivers/net/ethernet/chelsio/cxgb4/sge.c           |   2 +-
 drivers/net/ethernet/freescale/enetc/enetc.c       |  49 ++++++++
 drivers/net/ethernet/freescale/enetc/enetc.h       |  48 ++++++++
 drivers/net/ethernet/freescale/enetc/enetc_hw.h    |  33 +++--
 drivers/net/ethernet/freescale/enetc/enetc_pf.c    |  17 ++-
 drivers/net/usb/smsc95xx.c                         |   2 +-
 drivers/nvme/host/core.c                           |  20 ++--
 drivers/nvme/host/multipath.c                      |  45 +++++--
 drivers/nvme/host/nvme.h                           |   2 +
 drivers/scsi/qla2xxx/qla_init.c                    |   2 +-
 drivers/soc/ti/omap_prm.c                          |   8 +-
 drivers/spi/spi-fsl-dspi.c                         |  17 ++-
 drivers/thermal/cpufreq_cooling.c                  |   6 +-
 drivers/thermal/mtk_thermal.c                      |   5 +-
 drivers/thermal/rcar_gen3_thermal.c                |   2 +-
 drivers/thermal/sprd_thermal.c                     |   4 +-
 drivers/usb/misc/usbtest.c                         |   1 +
 fs/btrfs/block-group.c                             |  60 +++++++---
 fs/btrfs/file.c                                    |  37 ++++--
 fs/cifs/connect.c                                  |  10 +-
 fs/cifs/inode.c                                    |  10 +-
 fs/exfat/dir.c                                     |  12 +-
 fs/exfat/exfat_fs.h                                |   1 +
 fs/exfat/file.c                                    |  19 ++-
 fs/exfat/namei.c                                   |  14 ++-
 fs/exfat/super.c                                   |  10 ++
 fs/gfs2/log.c                                      |  10 ++
 fs/io_uring.c                                      |  74 ++++++++++--
 fs/locks.c                                         |   3 +
 fs/nfsd/nfs4proc.c                                 |   2 +
 fs/nfsd/nfs4state.c                                |  22 +++-
 fs/nfsd/nfsctl.c                                   |  23 ++--
 fs/nfsd/nfsd.h                                     |   5 +
 fs/nfsd/nfssvc.c                                   |   6 +
 fs/nfsd/vfs.c                                      |   6 +
 fs/xfs/xfs_log_cil.c                               |  10 +-
 fs/xfs/xfs_log_priv.h                              |   2 +-
 include/crypto/if_alg.h                            |   4 +-
 include/linux/fs.h                                 |   1 +
 include/linux/kthread.h                            |   1 +
 include/linux/lsm_hook_defs.h                      |   2 +-
 include/linux/sched/jobctl.h                       |   4 +-
 include/linux/sunrpc/svc.h                         |   1 +
 include/linux/task_work.h                          |   5 +-
 include/net/seg6.h                                 |   2 +-
 kernel/debug/debug_core.c                          |   4 +
 kernel/kthread.c                                   |  17 +++
 kernel/padata.c                                    |   4 +-
 kernel/sched/debug.c                               |   2 +-
 kernel/signal.c                                    |  10 +-
 kernel/task_work.c                                 |  16 ++-
 mm/cma.c                                           |   4 +-
 mm/debug.c                                         |  56 ++++++++-
 mm/hugetlb.c                                       |   2 +-
 mm/slub.c                                          |  30 ++++-
 mm/swap_state.c                                    |   4 +-
 net/core/filter.c                                  |   2 +-
 net/hsr/hsr_device.c                               |  21 +---
 net/hsr/hsr_device.h                               |   2 +-
 net/hsr/hsr_main.c                                 |  27 ++++-
 net/hsr/hsr_netlink.c                              |  17 +++
 net/ipv6/ipv6_sockglue.c                           |   2 +-
 net/ipv6/seg6.c                                    |  16 ++-
 net/ipv6/seg6_iptunnel.c                           |   2 +-
 net/ipv6/seg6_local.c                              |   6 +-
 net/mptcp/subflow.c                                |  18 +--
 net/rxrpc/call_event.c                             |  29 ++---
 net/tipc/msg.c                                     |   7 +-
 net/tipc/msg.h                                     |  14 ++-
 net/tipc/socket.c                                  |  69 +++++++++--
 samples/vfs/test-statx.c                           |   2 +
 security/security.c                                |  17 ++-
 sound/usb/card.h                                   |   4 -
 sound/usb/endpoint.c                               |  43 +------
 sound/usb/endpoint.h                               |   1 -
 sound/usb/pcm.c                                    |   2 -
 tools/lib/traceevent/event-parse.c                 | 133 ++++++++++++---------
 tools/testing/selftests/tpm2/test_smoke.sh         |   7 +-
 tools/testing/selftests/tpm2/test_space.sh         |   2 +-
 130 files changed, 1593 insertions(+), 612 deletions(-)


