Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C91243916AD
	for <lists+stable@lfdr.de>; Wed, 26 May 2021 13:52:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234463AbhEZLxT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 May 2021 07:53:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:36234 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234469AbhEZLvp (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 26 May 2021 07:51:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 10E3961444;
        Wed, 26 May 2021 11:49:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622029768;
        bh=EbXHru0/NbBrR6mpHSAoixERaebQB+nUk34C5UWvalA=;
        h=From:To:Cc:Subject:Date:From;
        b=jBQYTunxjb2pXLQjTD1iUiKLtbqAcvjBdL/aixszMuJFk5RYwynWqmxKxVV0xnSVs
         ADywMW7P0JFY06RE7HqdzzMOkOIhumNUDy3YnQzWFGBLpnKHW9d2Oxr2cFtUA5Zcjo
         JoKkUaq5ZazFEsIcNRduokVtjwvPWgaBGRKrGY7w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.12.7
Date:   Wed, 26 May 2021 13:49:03 +0200
Message-Id: <1622029743148221@kroah.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.12.7 kernel.

All users of the 5.12 kernel series must upgrade.

The updated 5.12.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.12.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/powerpc/syscall64-abi.rst                 |   10 
 Makefile                                                |    2 
 arch/openrisc/kernel/setup.c                            |    2 
 arch/openrisc/mm/init.c                                 |    3 
 arch/powerpc/include/asm/hvcall.h                       |    3 
 arch/powerpc/include/asm/paravirt.h                     |   22 +
 arch/powerpc/include/asm/ptrace.h                       |   45 +-
 arch/powerpc/include/asm/syscall.h                      |   42 +-
 arch/powerpc/kernel/setup_64.c                          |    4 
 arch/powerpc/platforms/pseries/hvCall.S                 |   10 
 arch/powerpc/platforms/pseries/lpar.c                   |    3 
 arch/x86/Makefile                                       |   12 
 arch/x86/boot/compressed/head_64.S                      |   85 +++++
 arch/x86/events/intel/core.c                            |    2 
 arch/x86/kernel/sev-es-shared.c                         |    1 
 arch/x86/kernel/sev-es.c                                |  136 +++++---
 arch/x86/xen/enlighten_pv.c                             |    8 
 drivers/cdrom/gdrom.c                                   |   13 
 drivers/dma-buf/dma-buf.c                               |   10 
 drivers/firmware/arm_scpi.c                             |    4 
 drivers/gpio/gpio-tegra186.c                            |   11 
 drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c                 |    2 
 drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c                  |    6 
 drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c                   |   10 
 drivers/gpu/drm/amd/amdgpu/sdma_v5_0.c                  |    4 
 drivers/gpu/drm/amd/amdgpu/soc15.c                      |    2 
 drivers/gpu/drm/amd/display/dc/dcn30/dcn30_resource.c   |    7 
 drivers/gpu/drm/amd/display/dc/dcn301/dcn301_resource.c |    7 
 drivers/gpu/drm/amd/display/dc/dcn302/dcn302_resource.c |    7 
 drivers/gpu/drm/i915/gem/i915_gem_pages.c               |    2 
 drivers/gpu/drm/i915/gt/gen7_renderclear.c              |    5 
 drivers/gpu/drm/i915/i915_gem.c                         |   11 
 drivers/gpu/drm/radeon/radeon_gart.c                    |    3 
 drivers/gpu/drm/ttm/ttm_bo.c                            |    2 
 drivers/hwmon/lm80.c                                    |   11 
 drivers/infiniband/core/cma.c                           |    5 
 drivers/infiniband/core/uverbs_std_types_device.c       |    7 
 drivers/infiniband/hw/mlx5/devx.c                       |    6 
 drivers/infiniband/hw/mlx5/main.c                       |    1 
 drivers/infiniband/sw/rxe/rxe_comp.c                    |   20 -
 drivers/infiniband/sw/rxe/rxe_loc.h                     |   29 -
 drivers/infiniband/sw/rxe/rxe_mr.c                      |  271 +++++++---------
 drivers/infiniband/sw/rxe/rxe_pool.c                    |   14 
 drivers/infiniband/sw/rxe/rxe_qp.c                      |    7 
 drivers/infiniband/sw/rxe/rxe_req.c                     |   10 
 drivers/infiniband/sw/rxe/rxe_resp.c                    |   34 +-
 drivers/infiniband/sw/rxe/rxe_verbs.c                   |   22 -
 drivers/infiniband/sw/rxe/rxe_verbs.h                   |   60 ++-
 drivers/infiniband/sw/siw/siw_verbs.c                   |   11 
 drivers/leds/leds-lp5523.c                              |    2 
 drivers/md/dm-snap.c                                    |    1 
 drivers/media/platform/rcar_drif.c                      |    1 
 drivers/misc/eeprom/at24.c                              |    6 
 drivers/misc/habanalabs/gaudi/gaudi.c                   |    4 
 drivers/misc/ics932s401.c                               |    2 
 drivers/mmc/host/meson-gx-mmc.c                         |    7 
 drivers/mmc/host/sdhci-pci-gli.c                        |    7 
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_ethtool.c     |    3 
 drivers/net/ethernet/stmicro/stmmac/dwmac-sunxi.c       |    8 
 drivers/net/ethernet/sun/niu.c                          |   32 +
 drivers/net/wireless/realtek/rtlwifi/base.c             |   18 -
 drivers/nvme/host/core.c                                |    3 
 drivers/nvme/host/fc.c                                  |   12 
 drivers/nvme/host/multipath.c                           |   55 +--
 drivers/nvme/host/nvme.h                                |    8 
 drivers/nvme/host/tcp.c                                 |    5 
 drivers/nvme/target/core.c                              |    2 
 drivers/nvme/target/io-cmd-file.c                       |    8 
 drivers/nvme/target/loop.c                              |    4 
 drivers/platform/mellanox/mlxbf-tmfifo.c                |   11 
 drivers/platform/x86/Kconfig                            |    2 
 drivers/platform/x86/dell/dell-smbios-wmi.c             |    3 
 drivers/platform/x86/ideapad-laptop.c                   |   13 
 drivers/platform/x86/intel_int0002_vgpio.c              |   80 +++-
 drivers/rapidio/rio_cm.c                                |   17 -
 drivers/rtc/rtc-pcf85063.c                              |    7 
 drivers/scsi/qedf/qedf_main.c                           |    4 
 drivers/scsi/qla2xxx/qla_nx.c                           |    3 
 drivers/scsi/ufs/ufs-hisi.c                             |   15 
 drivers/scsi/ufs/ufshcd.c                               |    5 
 drivers/tee/amdtee/amdtee_private.h                     |   13 
 drivers/tee/amdtee/call.c                               |   94 ++++-
 drivers/tee/amdtee/core.c                               |   15 
 drivers/tty/serial/mvebu-uart.c                         |    3 
 drivers/tty/vt/vt.c                                     |    2 
 drivers/tty/vt/vt_ioctl.c                               |   57 ++-
 drivers/uio/uio_hv_generic.c                            |   12 
 drivers/uio/uio_pci_generic.c                           |    2 
 drivers/video/console/vgacon.c                          |   56 +--
 drivers/video/fbdev/core/fbcon.c                        |    2 
 drivers/video/fbdev/hgafb.c                             |   21 -
 drivers/video/fbdev/imsttfb.c                           |    5 
 drivers/xen/xen-pciback/vpci.c                          |   14 
 drivers/xen/xen-pciback/xenbus.c                        |   22 +
 fs/btrfs/inode.c                                        |    1 
 fs/btrfs/tree-log.c                                     |   18 +
 fs/cifs/smb2ops.c                                       |    2 
 fs/ecryptfs/crypto.c                                    |    6 
 fs/hugetlbfs/inode.c                                    |    2 
 fs/namespace.c                                          |    6 
 include/linux/console_struct.h                          |    1 
 ipc/mqueue.c                                            |    6 
 ipc/msg.c                                               |    6 
 ipc/sem.c                                               |    6 
 kernel/kcsan/debugfs.c                                  |    3 
 kernel/locking/lockdep.c                                |    4 
 kernel/locking/mutex-debug.c                            |    4 
 kernel/locking/mutex-debug.h                            |    2 
 kernel/locking/mutex.c                                  |   18 -
 kernel/locking/mutex.h                                  |    4 
 kernel/ptrace.c                                         |   18 +
 mm/gup.c                                                |    4 
 mm/internal.h                                           |   20 -
 mm/userfaultfd.c                                        |   28 -
 net/bluetooth/smp.c                                     |    9 
 sound/firewire/Kconfig                                  |    4 
 sound/firewire/amdtp-stream-trace.h                     |    6 
 sound/firewire/amdtp-stream.c                           |   42 +-
 sound/firewire/bebob/bebob.c                            |    2 
 sound/firewire/dice/dice-alesis.c                       |    2 
 sound/firewire/dice/dice-tcelectronic.c                 |    4 
 sound/firewire/oxfw/oxfw.c                              |    1 
 sound/isa/sb/sb8.c                                      |    4 
 sound/pci/hda/patch_realtek.c                           |  135 +++++++
 sound/pci/intel8x0.c                                    |    7 
 sound/usb/line6/driver.c                                |    4 
 sound/usb/line6/pod.c                                   |    5 
 sound/usb/line6/variax.c                                |    6 
 sound/usb/midi.c                                        |    4 
 sound/usb/quirks.c                                      |    4 
 tools/testing/selftests/exec/Makefile                   |    6 
 tools/testing/selftests/seccomp/seccomp_bpf.c           |   27 +
 132 files changed, 1363 insertions(+), 738 deletions(-)

Alexey Kardashevskiy (1):
      powerpc: Fix early setup to make early_ioremap() work

Anirudh Rayabharam (3):
      rapidio: handle create_workqueue() failure
      net: stmicro: handle clk_prepare() failure during init
      video: hgafb: correctly handle card detect failure during probe

Arnd Bergmann (1):
      kcsan: Fix debugfs initcall return type

Atul Gopinathan (1):
      cdrom: gdrom: deallocate struct gdrom_unit fields in remove_gdrom

Barnabás Pőcze (1):
      platform/x86: ideapad-laptop: fix method name typo

Bart Van Assche (1):
      scsi: ufs: core: Increase the usable queue depth

Bob Pearson (1):
      RDMA/rxe: Split MEM into MR and MW

Changfeng (1):
      drm/amdgpu: disable 3DCGCG on picasso/raven1 to avoid compute hang

Chris Wilson (1):
      drm/i915/gem: Pin the L-shape quirked object as unshrinkable

Christian Brauner (1):
      fs/mount_setattr: tighten permission checks

Christian König (2):
      drm/radeon: use the dummy page for GART if needed
      dma-buf: fix unintended pin/unpin warnings

Christoph Hellwig (1):
      nvme-multipath: fix double initialization of ANA state

Christophe JAILLET (3):
      openrisc: Fix a memory leak
      uio_hv_generic: Fix a memory leak in error handling paths
      uio_hv_generic: Fix another memory leak in error handling paths

Dan Carpenter (2):
      firmware: arm_scpi: Prevent the ternary sign expansion bug
      RDMA/uverbs: Fix a NULL vs IS_ERR() bug

Daniel Beer (1):
      mmc: sdhci-pci-gli: increase 1.8V regulator wait

Daniel Cordova A (1):
      ALSA: hda: fixup headset for ASUS GU502 laptop

Daniel Wagner (1):
      nvmet: seset ns->file when open fails

Darrick J. Wong (1):
      ics932s401: fix broken handling of errors when word reading fails

Du Cheng (1):
      ethernet: sun: niu: fix missing checks of niu_pci_eeprom_read()

Elia Devito (1):
      ALSA: hda/realtek: Add fixup for HP Spectre x360 15-df0xxx

Filipe Manana (1):
      btrfs: fix removed dentries still existing after log is synced

Francois Gervais (1):
      rtc: pcf85063: fallback to parent of_node

Greg Kroah-Hartman (18):
      Revert "ALSA: sb8: add a check for request_region"
      Revert "rapidio: fix a NULL pointer dereference when create_workqueue() fails"
      Revert "serial: mvebu-uart: Fix to avoid a potential NULL pointer dereference"
      Revert "video: hgafb: fix potential NULL pointer dereference"
      Revert "net: stmicro: fix a missing check of clk_prepare"
      Revert "leds: lp5523: fix a missing check of return value of lp55xx_read"
      Revert "hwmon: (lm80) fix a missing check of bus read in lm80 probe"
      Revert "video: imsttfb: fix potential NULL pointer dereferences"
      Revert "ecryptfs: replace BUG_ON with error handling code"
      Revert "scsi: ufs: fix a missing check of devm_reset_control_get"
      Revert "gdrom: fix a memory leak bug"
      cdrom: gdrom: initialize global variable at init time
      Revert "media: rcar_drif: fix a memory disclosure"
      Revert "rtlwifi: fix a potential NULL pointer dereference"
      Revert "qlcnic: Avoid potential NULL pointer dereference"
      Revert "niu: fix missing checks of niu_pci_eeprom_read"
      net: rtlwifi: properly check for alloc_workqueue() failure
      Linux 5.12.7

Guchun Chen (2):
      drm/amdgpu: update gc golden setting for Navi12
      drm/amdgpu: update sdma golden setting for Navi12

Hans de Goede (2):
      platform/x86: intel_int0002_vgpio: Only call enable_irq_wake() when using s2idle
      platform/x86: dell-smbios-wmi: Fix oops on rmmod dell_smbios

Hou Pu (1):
      nvmet: use new ana_log_size instead the old one

Hsin-Yi Wang (1):
      misc: eeprom: at24: check suspend status before disable regulator

Hui Wang (1):
      ALSA: hda/realtek: reset eapd coeff to default value for alc287

Igor Matheus Andrade Torrente (1):
      video: hgafb: fix potential NULL pointer dereference

James Smart (1):
      nvme-fc: clear q_live at beginning of association teardown

Jan Beulich (3):
      xen-pciback: redo VF placement in the virtual topology
      xen-pciback: reconfigure also from backend watch handler
      x86/Xen: swap NX determination and GDT setup on BSP

Javed Hasan (1):
      scsi: qedf: Add pointer checks in qedf_update_link_speed()

Joerg Roedel (4):
      x86/sev-es: Don't return NULL from sev_es_get_ghcb()
      x86/sev-es: Use __put_user()/__get_user() for data accesses
      x86/sev-es: Forward page-faults which happen during emulation
      x86/boot/compressed/64: Check SEV encryption in the 32-bit boot-path

Jon Hunter (1):
      gpio: tegra186: Don't set parent IRQ affinity

Josef Bacik (1):
      btrfs: avoid RCU stalls while running delayed iputs

Keith Busch (1):
      nvme-tcp: rerun io_work if req_list is not empty

Leo Yan (1):
      locking/lockdep: Correct calling tracepoints

Leon Romanovsky (5):
      RDMA/siw: Properly check send and receive CQ pointers
      RDMA/siw: Release xarray entry
      RDMA/core: Prevent divide-by-zero error triggered by the user
      RDMA/rxe: Clear all QP fields if creation failed
      RDMA/rxe: Return CQE error if invalid lkey was supplied

Like Xu (1):
      perf/x86: Avoid touching LBR_TOS MSR for Arch LBR

Liming Sun (1):
      platform/mellanox: mlxbf-tmfifo: Fix a memory barrier issue

Luiz Augusto von Dentz (1):
      Bluetooth: SMP: Fail if remote and local public keys are identical

Lv Yunlong (1):
      habanalabs/gaudi: Fix a potential use after free in gaudi_memset_device_memory

Maciej W. Rozycki (3):
      vgacon: Record video mode changes with VT_RESIZEX
      vt_ioctl: Revert VT_RESIZEX parameter handling removal
      vt: Fix character height handling with VT_RESIZEX

Maor Gottlieb (2):
      RDMA/mlx5: Recover from fatal event in dual port mode
      RDMA/mlx5: Fix query DCT via DEVX

Martin Ågren (1):
      uio/uio_pci_generic: fix return value changed in refactoring

Michal Hocko (1):
      Revert "mm/gup: check page posion status for coredump."

Mike Kravetz (1):
      userfaultfd: hugetlbfs: fix new flag usage in error path

Mike Rapoport (1):
      openrisc: mm/init.c: remove unused memblock_region variable in map_ram()

Mikulas Patocka (1):
      dm snapshot: fix crash with transient storage and zero chunk size

Nathan Chancellor (1):
      x86/build: Fix location of '-plugin-opt=' flags

Neil Armstrong (2):
      mmc: meson-gx: make replace WARN_ONCE with dev_warn_once about scatterlist offset alignment
      mmc: meson-gx: also check SD_IO_RW_EXTENDED for scatterlist size alignment

Nicholas Piggin (3):
      powerpc/pseries: Fix hcall tracing recursion in pv queued spinlocks
      powerpc/64s/syscall: Use pt_regs.trap to distinguish syscall ABI difference between sc and scv syscalls
      powerpc/64s/syscall: Fix ptrace syscall info with scv syscalls

Nicolas MURE (1):
      ALSA: usb-audio: Configure Pioneer DJM-850 samplerate

Nikola Cornij (1):
      drm/amd/display: Use the correct max downscaling value for DCN3.x family

Oleg Nesterov (1):
      ptrace: make ptrace() fail if the tracee changed its pid unexpectedly

Olivia Mackintosh (1):
      ALSA: usb-audio: DJM-750: ensure format is set

PeiSen Hou (1):
      ALSA: hda/realtek: Add some CLOVE SSIDs of ALC293

Phillip Potter (2):
      scsi: ufs: handle cleanup correctly on devm_reset_control_get error
      leds: lp5523: check return value of lp5xx_read and jump to cleanup code

Qiu Wenbo (1):
      platform/x86: ideapad-laptop: fix a NULL pointer dereference

Rijo Thomas (1):
      tee: amdtee: unload TA only when its refcount becomes 0

Ronnie Sahlberg (1):
      cifs: fix memory leak in smb2_copychunk_range

Sagi Grimberg (1):
      nvme-tcp: fix possible use-after-completion

Shay Drory (1):
      RDMA/core: Don't access cm_id after its destruction

Simon Rettberg (1):
      drm/i915/gt: Disable HiZ Raw Stall Optimization on broken gen7

Takashi Iwai (5):
      ALSA: intel8x0: Don't update period unless prepared
      ALSA: line6: Fix racy initialization of LINE6 MIDI
      ALSA: usb-audio: Validate MS endpoint descriptors
      ALSA: hda/realtek: Fix silent headphone output on ASUS UX430UA
      ALSA: hda/realtek: Add fixup for HP OMEN laptop

Takashi Sakamoto (6):
      ALSA: dice: fix stream format for TC Electronic Konnekt Live at high sampling transfer frequency
      ALSA: firewire-lib: fix amdtp_packet tracepoints event for packet_index field
      ALSA: dice: fix stream format at middle sampling rate for Alesis iO 26
      ALSA: firewire-lib: fix calculation for size of IR context payload
      ALSA: bebob/oxfw: fix Kconfig entry for Mackie d.2 Pro
      ALSA: firewire-lib: fix check for the size of isochronous packet payload

Tetsuo Handa (1):
      tty: vt: always invoke vc->vc_sw->con_resize callback

Tom Lendacky (2):
      x86/sev-es: Move sev_es_put_ghcb() in prep for follow on patch
      x86/sev-es: Invalidate the GHCB after completing VMGEXIT

Tom Seewald (1):
      qlcnic: Add null check after calling netdev_alloc_skb

Varad Gautam (1):
      ipc/mqueue, msg, sem: avoid relying on a stack reference past its expiry

Wu Bo (2):
      nvmet: fix memory leak in nvmet_alloc_ctrl()
      nvme-loop: fix memory leak in nvme_loop_create_ctrl()

Yang Yingliang (1):
      tools/testing/selftests/exec: fix link error

Yi Li (1):
      drm/amdgpu: Fix GPU TLB update error when PAGE_SIZE > AMDGPU_PAGE_SIZE

Zhen Lei (1):
      scsi: qla2xxx: Fix error return code in qla82xx_write_flash_dword()

Zqiang (1):
      locking/mutex: clear MUTEX_FLAGS if wait_list is empty due to signal

xinhui pan (1):
      drm/ttm: Do not add non-system domain BO into swap list

