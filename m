Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 664C6219C42
	for <lists+stable@lfdr.de>; Thu,  9 Jul 2020 11:30:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726519AbgGIJ3Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Jul 2020 05:29:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:34598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726786AbgGIJ3X (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Jul 2020 05:29:23 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A4C2A2074B;
        Thu,  9 Jul 2020 09:29:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594286962;
        bh=VMMUZtfx/uyZZ7U1sjVS/s+Gc59I3WPWYrXbMoqXfnE=;
        h=From:To:Cc:Subject:Date:From;
        b=VwmKYh278fXHXIpTNk99rsJ65UIgfU33ZzoOGx7URq5nosy0b4yxqhEne4PIUTm1n
         ZMXpb20R+W5brlGTwSuoEX0rP5OfqoJ7v/tGavtHM5Mzaw8MpZkm5NQQazWq5Pej30
         yxrwbxXm5todi1yL7hEbL3irFj/tYeRVk20//0N8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.7.8
Date:   Thu,  9 Jul 2020 11:29:16 +0200
Message-Id: <159428695623482@kroah.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.7.8 kernel.

All users of the 5.7 kernel series must upgrade.

The updated 5.7.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.7.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                                |    2 
 arch/mips/kernel/traps.c                                |    1 
 arch/mips/lantiq/xway/sysctrl.c                         |    8 
 arch/powerpc/include/asm/kvm_book3s_64.h                |   23 ++
 arch/powerpc/kvm/book3s_64_mmu_radix.c                  |   45 ++++-
 arch/powerpc/kvm/book3s_hv_nested.c                     |    2 
 arch/s390/kernel/debug.c                                |    3 
 arch/x86/kernel/cpu/intel.c                             |   11 +
 crypto/af_alg.c                                         |   26 +--
 crypto/algif_aead.c                                     |    9 -
 crypto/algif_hash.c                                     |    9 -
 crypto/algif_skcipher.c                                 |    9 -
 drivers/acpi/fan.c                                      |    2 
 drivers/block/virtio_blk.c                              |    1 
 drivers/char/tpm/tpm-dev-common.c                       |   19 +-
 drivers/char/tpm/tpm_ibmvtpm.c                          |   14 -
 drivers/dma-buf/dma-buf.c                               |   54 +++---
 drivers/firmware/efi/Kconfig                            |   11 +
 drivers/firmware/efi/efi.c                              |    2 
 drivers/gpu/drm/amd/amdgpu/amdgpu_atomfirmware.c        |    1 
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c              |    3 
 drivers/gpu/drm/amd/amdgpu/amdgpu_pm.c                  |    4 
 drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c                 |   29 ++-
 drivers/gpu/drm/amd/amdgpu/amdgpu_ras.h                 |    4 
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c       |  103 +++++++-----
 drivers/gpu/drm/amd/display/dc/core/dc.c                |   10 -
 drivers/gpu/drm/amd/powerplay/smumgr/vega20_smumgr.c    |   11 -
 drivers/gpu/drm/i915/gt/intel_timeline.c                |   12 +
 drivers/gpu/drm/i915/gt/shaders/README                  |   46 +++++
 drivers/gpu/drm/i915/gt/shaders/clear_kernel/hsw.asm    |  119 ++++++++++++++
 drivers/gpu/drm/i915/gt/shaders/clear_kernel/ivb.asm    |  117 ++++++++++++++
 drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c             |    2 
 drivers/gpu/drm/sun4i/sun4i_hdmi_enc.c                  |    5 
 drivers/hv/vmbus_drv.c                                  |    2 
 drivers/hwmon/acpi_power_meter.c                        |    4 
 drivers/hwmon/max6697.c                                 |    7 
 drivers/hwmon/pmbus/pmbus_core.c                        |    8 
 drivers/i2c/algos/i2c-algo-pca.c                        |    3 
 drivers/i2c/busses/i2c-designware-platdrv.c             |   14 +
 drivers/i2c/busses/i2c-mlxcpld.c                        |    4 
 drivers/infiniband/core/counters.c                      |    4 
 drivers/irqchip/irq-gic-v3-its.c                        |    8 
 drivers/irqchip/irq-gic.c                               |   14 -
 drivers/md/dm-zoned-target.c                            |    2 
 drivers/net/ethernet/chelsio/cxgb4/cudbg_lib.c          |    6 
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c       |   25 +--
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c         |    2 
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c    |   30 +--
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_u32.c       |   18 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_u32_parse.h |  122 +++++++++-----
 drivers/net/ethernet/chelsio/cxgb4/sge.c                |    2 
 drivers/net/ethernet/freescale/enetc/enetc.c            |   49 +++++
 drivers/net/ethernet/freescale/enetc/enetc.h            |   48 +++++
 drivers/net/ethernet/freescale/enetc/enetc_hw.h         |   33 +++
 drivers/net/ethernet/freescale/enetc/enetc_pf.c         |   17 --
 drivers/net/usb/smsc95xx.c                              |    2 
 drivers/nvme/host/core.c                                |   20 +-
 drivers/nvme/host/multipath.c                           |   45 ++++-
 drivers/nvme/host/nvme.h                                |    2 
 drivers/scsi/qla2xxx/qla_init.c                         |    2 
 drivers/soc/ti/omap_prm.c                               |    8 
 drivers/spi/spi-fsl-dspi.c                              |   17 +-
 drivers/thermal/cpufreq_cooling.c                       |    6 
 drivers/thermal/mtk_thermal.c                           |    5 
 drivers/thermal/rcar_gen3_thermal.c                     |    2 
 drivers/thermal/sprd_thermal.c                          |    4 
 drivers/usb/misc/usbtest.c                              |    1 
 fs/btrfs/block-group.c                                  |   60 +++++--
 fs/btrfs/file.c                                         |   37 +++-
 fs/cifs/connect.c                                       |   10 -
 fs/cifs/inode.c                                         |   10 -
 fs/exfat/dir.c                                          |   12 -
 fs/exfat/exfat_fs.h                                     |    1 
 fs/exfat/file.c                                         |   19 ++
 fs/exfat/namei.c                                        |   14 +
 fs/exfat/super.c                                        |   10 +
 fs/gfs2/log.c                                           |   10 +
 fs/io_uring.c                                           |   74 +++++++-
 fs/nfsd/nfs4state.c                                     |    8 
 fs/nfsd/nfsctl.c                                        |   23 +-
 fs/nfsd/nfsd.h                                          |    3 
 fs/nfsd/vfs.c                                           |    6 
 fs/xfs/xfs_log_cil.c                                    |   10 -
 fs/xfs/xfs_log_priv.h                                   |    2 
 include/crypto/if_alg.h                                 |    4 
 include/linux/lsm_hook_defs.h                           |    2 
 include/linux/sched/jobctl.h                            |    4 
 include/linux/task_work.h                               |    5 
 include/net/seg6.h                                      |    2 
 kernel/debug/debug_core.c                               |    4 
 kernel/padata.c                                         |    4 
 kernel/sched/debug.c                                    |    2 
 kernel/signal.c                                         |   10 -
 kernel/task_work.c                                      |   16 +
 mm/cma.c                                                |    4 
 mm/debug.c                                              |   56 ++++++
 mm/hugetlb.c                                            |    2 
 mm/slub.c                                               |   30 +++
 mm/swap_state.c                                         |    4 
 net/core/filter.c                                       |    2 
 net/hsr/hsr_device.c                                    |   21 --
 net/hsr/hsr_device.h                                    |    2 
 net/hsr/hsr_main.c                                      |   27 ++-
 net/hsr/hsr_netlink.c                                   |   17 ++
 net/ipv6/ipv6_sockglue.c                                |    2 
 net/ipv6/seg6.c                                         |   16 +
 net/ipv6/seg6_iptunnel.c                                |    2 
 net/ipv6/seg6_local.c                                   |    6 
 net/mptcp/subflow.c                                     |   18 +-
 net/rxrpc/call_event.c                                  |   29 +--
 net/tipc/msg.c                                          |    7 
 net/tipc/msg.h                                          |   14 +
 net/tipc/socket.c                                       |   69 ++++++--
 samples/vfs/test-statx.c                                |    2 
 security/security.c                                     |   17 +-
 sound/usb/card.h                                        |    4 
 sound/usb/endpoint.c                                    |   43 -----
 sound/usb/endpoint.h                                    |    1 
 sound/usb/pcm.c                                         |    2 
 tools/lib/traceevent/event-parse.c                      |  133 +++++++++-------
 tools/testing/selftests/tpm2/test_smoke.sh              |    7 
 tools/testing/selftests/tpm2/test_space.sh              |    2 
 122 files changed, 1543 insertions(+), 611 deletions(-)

Ahmed Abdelsalam (1):
      seg6: fix seg6_validate_srh() to avoid slab-out-of-bounds

Alex Deucher (2):
      drm/amdgpu: use %u rather than %d for sclk/mclk
      drm/amdgpu/atomfirmware: fix vram_info fetching for renoir

Aneesh Kumar K.V (2):
      powerpc/kvm/book3s: Add helper to walk partition scoped linux page table.
      powerpc/book3s64/kvm: Fix secondary page table walk warning during migration

Anton Eidelman (2):
      nvme-multipath: fix deadlock between ana_work and scan_work
      nvme-multipath: fix deadlock due to head->lock

Barry Song (1):
      mm/cma.c: use exact_nid true to fix possible per-numa cma leak

Bob Peterson (1):
      gfs2: fix trans slab error when withdraw occurs inside log_flush

Chen Tao (1):
      drm/msm/dpu: fix error return code in dpu_encoder_init

Chen-Yu Tsai (1):
      drm: sun4i: hdmi: Remove extra HPD polling

Chris Packham (1):
      i2c: algo-pca: Add 0x78 as SCL stuck low status for PCA9665

Chris Wilson (1):
      drm/i915/gt: Mark timeline->cacheline as destroyed after rcu grace period

Christian Borntraeger (1):
      s390/debug: avoid kernel warning on too large number of pages

Christoph Hellwig (1):
      nvme: fix a crash in nvme_mpath_add_disk

Chu Lin (1):
      hwmon: (max6697) Make sure the OVERT mask is set correctly

Claudiu Manoil (1):
      enetc: Fix HW_VLAN_CTAG_TX|RX toggling

Dan Carpenter (2):
      exfat: add missing brelse() calls on error paths
      scsi: qla2xxx: Fix a condition in qla2x00_find_all_fabric_devs()

Daniel Jordan (1):
      padata: upgrade smp_mb__after_atomic to smp_mb in padata_do_serial

Dave Chinner (1):
      xfs: fix use-after-free on CIL context on shutdown

David Gibson (1):
      tpm: ibmvtpm: Wait for ready buffer before probing for TPM2 attributes

David Howells (2):
      rxrpc: Fix race between incoming ACK parser and retransmitter
      rxrpc: Fix afs large storage transmission performance drop

Dien Pham (1):
      thermal/drivers/rcar_gen3: Fix undefined temperature if negative

Dongli Zhang (1):
      mm/slub.c: fix corrupted freechain in deactivate_slab()

Douglas Anderson (1):
      kgdb: Avoid suspicious RCU usage warning

Evan Quan (1):
      drm/amdgpu: fix non-pointer dereference for non-RAS supported

Filipe Manana (2):
      btrfs: fix race between block group removal and block group creation
      btrfs: fix RWF_NOWAIT writes blocking on extent locks and waiting for IO

Finley Xiao (1):
      thermal/drivers/cpufreq_cooling: Fix wrong frequency converted from power

Greg Kroah-Hartman (2):
      Revert "ALSA: usb-audio: Improve frames size computation"
      Linux 5.7.8

Guchun Chen (1):
      drm/amdgpu: fix kernel page fault issue by ras recovery on sGPU

Hauke Mehrtens (1):
      MIPS: Add missing EHB in mtc0 -> mfc0 sequence for DSPen

Herbert Xu (1):
      crypto: af_alg - fix use-after-free in af_alg_accept() due to bh_lock_sock()

Hou Tao (2):
      virtio-blk: free vblk-vqs in error path of virtblk_probe()
      dm zoned: assign max_io_len correctly

Hugh Dickins (1):
      mm: fix swap cache node allocation mask

Hyeongseok.Kim (1):
      exfat: Set the unused characters of FileName field to the value 0000h

Hyunchul Lee (1):
      exfat: call sync_filesystem for read-only remount

Ivan Mironov (1):
      drm/amd/powerplay: Fix NULL dereference in lock_bus() on Vega20 w/o RAS

J. Bruce Fields (3):
      nfsd4: fix nfsdfs reference count loop
      nfsd: fix nfsdfs inode reference count leak
      nfsd: apply umask on fs without ACL support

James Bottomley (1):
      tpm: Fix TIS locality timeout problems

Jan Kundrát (1):
      hwmon: (pmbus) Fix page vs. register when accessing fans

Jarkko Sakkinen (2):
      Revert "tpm: selftest: cleanup after unseal with wrong auth/policy test"
      selftests: tpm: Use /bin/sh instead of /bin/bash

Jens Axboe (2):
      io_uring: use signal based task_work running
      io_uring: fix regression with always ignoring signals in io_cqring_wait()

John Clements (1):
      drm/amdgpu: disable ras query and iject during gpu reset

Joseph Salisbury (1):
      Drivers: hv: Change flag to write log level in panic msg to false

KP Singh (1):
      security: Fix hook iteration and default value for inode_copy_up_xattr

Kees Cook (1):
      samples/vfs: avoid warning in statx override

Keith Busch (1):
      nvme-multipath: set bdi capabilities once

Krzysztof Kozlowski (1):
      spi: spi-fsl-dspi: Fix external abort on interrupt in resume or exit paths

Marc Zyngier (1):
      irqchip/gic: Atomically update affinity

Mark Zhang (1):
      RDMA/counter: Query a counter before release

Martin Blumenstingl (1):
      MIPS: lantiq: xway: sysctrl: fix the GPHY clock alias names

Michael Kao (1):
      thermal/drivers/mediatek: Fix bank number settings on mt8183

Mike Kravetz (1):
      mm/hugetlb.c: fix pages per hugetlb calculation

Misono Tomohiro (1):
      hwmon: (acpi_power_meter) Fix potential memory leak in acpi_power_meter_add()

Namjae Jeon (1):
      exfat: move setting VOL_DIRTY over exfat_remove_entries()

Nicholas Kazlauskas (1):
      drm/amd/display: Only revalidate bandwidth on medium and fast updates

Oleg Nesterov (1):
      task_work: teach task_work_add() to do signal_wake_up()

Paolo Abeni (1):
      mptcp: drop MP_JOIN request sock on syn cookies

Paul Aurich (5):
      SMB3: Honor 'posix' flag for multiuser mounts
      SMB3: Honor 'seal' flag for multiuser mounts
      SMB3: Honor persistent/resilient handle flags for multiuser mounts
      SMB3: Honor lease disabling for multiuser mounts
      SMB3: Honor 'handletimeout' flag for multiuser mounts

Pavel Begunkov (2):
      io_uring: fix {SQ,IO}POLL with unsupported opcodes
      io_uring: fix current->mm NULL dereference on exit

Peter Jones (1):
      efi: Make it possible to disable efivar_ssdt entirely

Po Liu (1):
      net: enetc: add hw tc hw offload features for PSPF capability

Qian Cai (1):
      mm/slub: fix stack overruns with SLUB_STATS

Qu Wenruo (1):
      btrfs: block-group: refactor how we delete one block group item

Rahul Lakkireddy (5):
      cxgb4: use unaligned conversion for fetching timestamp
      cxgb4: parse TC-U32 key values and masks natively
      cxgb4: fix endian conversions for L4 ports in filters
      cxgb4: use correct type for all-mask IP address comparison
      cxgb4: fix SGE queue dump destination buffer context

Ricardo Ribalda (1):
      i2c: designware: platdrv: Set class based on DMI

Rodrigo Vivi (1):
      drm/i915: Include asm sources for {ivb, hsw}_clear_kernel.c

Sagi Grimberg (3):
      nvme: fix possible deadlock when I/O is blocked
      nvme-multipath: fix bogus request queue reference put
      nvme: fix identify error status silent ignore

Sean Christopherson (1):
      x86/split_lock: Don't write MSR_TEST_CTRL on CPUs that aren't whitelisted

Steven Rostedt (VMware) (2):
      tools lib traceevent: Add append() function helper for appending strings
      tools lib traceevent: Handle __attribute__((user)) in field names

Stylon Wang (2):
      drm/amd/display: Fix incorrectly pruned modes with deep color
      drm/amd/display: Fix ineffective setting of max bpc property

Sumeet Pawnikar (1):
      ACPI: fan: Fix Tiger Lake ACPI device ID

Sumit Semwal (1):
      dma-buf: Move dma_buf_release() from fops to dentry_ops

Sungjong Seo (1):
      exfat: flush dirty metadata in fsync

Taehee Yoo (2):
      hsr: remove hsr interface if all slaves are removed
      hsr: avoid to create proc file after unregister

Tero Kristo (1):
      soc: ti: omap-prm: use atomic iopoll instead of sleeping one

Tiezhu Yang (1):
      thermal/drivers/sprd: Fix return value of sprd_thm_probe()

Tuomas Tynkkynen (1):
      usbnet: smsc95xx: Fix use-after-free after removal

Tuong Lien (2):
      tipc: add test for Nagle algorithm effectiveness
      tipc: fix kernel WARNING in tipc_msg_append()

Valentin Schneider (1):
      sched/debug: Make sd->flags sysctl read-only

Vlastimil Babka (1):
      mm, dump_page(): do not crash with invalid mapping pointer

Wolfram Sang (1):
      i2c: mlxcpld: check correct size of maximum RECV_LEN packet

Xuan Zhuo (1):
      io_uring: fix io_sq_thread no schedule when busy

YueHaibing (1):
      tipc: Fix NULL pointer dereference in __tipc_sendstream()

Zenghui Yu (1):
      irqchip/gic-v4.1: Use readx_poll_timeout_atomic() to fix sleep in atomic

Zhang Xiaoxu (1):
      cifs: Fix the target file was deleted when rename failed.

Zqiang (1):
      usb: usbtest: fix missing kfree(dev->buf) in usbtest_disconnect

