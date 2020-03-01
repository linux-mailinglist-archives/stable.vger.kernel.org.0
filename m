Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1766A174C67
	for <lists+stable@lfdr.de>; Sun,  1 Mar 2020 10:36:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725892AbgCAJgA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 1 Mar 2020 04:36:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:60816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725768AbgCAJgA (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 1 Mar 2020 04:36:00 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DAEB720880;
        Sun,  1 Mar 2020 09:35:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583055359;
        bh=z6+QzgWUhDTy8HckGy3cgIkkL5PHprLlQrODXIqllYQ=;
        h=Date:From:To:Cc:Subject:From;
        b=eOgVz9X2SfIMR3hFLxuW2gfCz+BmEk/bNTKJi0YL46npAu00843rGCN+At/TADMkk
         JT5UP5eQhFZPJ+2gGBYH+be3Fo/LcSBIlKI7HM+tlI6cY6X/zf19g593MzGi4WumPw
         YFCOPiUoLZTYG+bs4nI6AWJcm3P/+qNt+f1n8y7w=
Date:   Sun, 1 Mar 2020 10:35:57 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.4.215
Message-ID: <20200301093557.GA1004810@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.4.215 kernel.

All users of the 4.4 kernel series must upgrade.

The updated 4.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                            |    2 
 arch/arm/Kconfig                                    |    2 
 arch/arm/boot/dts/r8a7779.dtsi                      |    8 
 arch/microblaze/kernel/cpu/cache.c                  |    3 
 arch/mips/loongson64/loongson-3/platform.c          |    3 
 arch/s390/include/asm/timex.h                       |    2 
 arch/s390/kernel/mcount.S                           |   15 
 arch/sh/include/cpu-sh2a/cpu/sh7269.h               |   11 
 arch/x86/entry/vdso/vdso32-setup.c                  |    1 
 arch/x86/include/asm/cpufeatures.h                  |    1 
 arch/x86/include/asm/vgtod.h                        |    7 
 arch/x86/kernel/cpu/mcheck/mce_amd.c                |   17 
 arch/x86/kvm/cpuid.c                                |    7 
 arch/x86/kvm/emulate.c                              |   22 
 arch/x86/kvm/lapic.c                                |    4 
 arch/x86/kvm/vmx.c                                  |  102 
 arch/x86/kvm/vmx/vmx.c                              | 8033 --------------------
 arch/x86/platform/efi/efi.c                         |   13 
 drivers/acpi/acpica/dsfield.c                       |    2 
 drivers/acpi/acpica/dswload.c                       |   21 
 drivers/base/dd.c                                   |    5 
 drivers/block/brd.c                                 |   22 
 drivers/block/floppy.c                              |    7 
 drivers/clk/qcom/clk-rcg2.c                         |    3 
 drivers/gpu/drm/amd/amdgpu/amdgpu_atombios.c        |   19 
 drivers/gpu/drm/gma500/framebuffer.c                |    8 
 drivers/gpu/drm/nouveau/nouveau_fence.c             |    2 
 drivers/gpu/drm/nouveau/nvkm/engine/disp/channv50.c |    2 
 drivers/gpu/drm/radeon/radeon_display.c             |    2 
 drivers/gpu/drm/vmwgfx/vmwgfx_cmdbuf_res.c          |    4 
 drivers/hwmon/pmbus/ltc2978.c                       |    4 
 drivers/ide/cmd64x.c                                |    3 
 drivers/ide/serverworks.c                           |    6 
 drivers/infiniband/ulp/isert/ib_isert.c             |   12 
 drivers/input/touchscreen/edt-ft5x06.c              |    7 
 drivers/iommu/arm-smmu-v3.c                         |    3 
 drivers/irqchip/irq-gic-v3-its.c                    |    2 
 drivers/md/bcache/bset.h                            |    3 
 drivers/media/i2c/mt9v032.c                         |   10 
 drivers/media/platform/sti/bdisp/bdisp-hw.c         |    6 
 drivers/net/ethernet/cisco/enic/enic_main.c         |    2 
 drivers/net/ethernet/freescale/gianfar.c            |   10 
 drivers/net/wan/ixp4xx_hss.c                        |    4 
 drivers/net/wireless/b43legacy/main.c               |    5 
 drivers/net/wireless/brcm80211/brcmfmac/sdio.c      |    1 
 drivers/net/wireless/hostap/hostap_ap.c             |    2 
 drivers/net/wireless/ipw2x00/ipw2100.c              |    7 
 drivers/net/wireless/ipw2x00/ipw2200.c              |    5 
 drivers/net/wireless/iwlegacy/3945-mac.c            |    5 
 drivers/net/wireless/iwlegacy/4965-mac.c            |    5 
 drivers/net/wireless/iwlegacy/common.c              |    2 
 drivers/net/wireless/orinoco/orinoco_usb.c          |    3 
 drivers/net/wireless/realtek/rtlwifi/pci.c          |   10 
 drivers/nfc/port100.c                               |    2 
 drivers/pci/setup-bus.c                             |   20 
 drivers/pinctrl/sh-pfc/pfc-sh7264.c                 |    9 
 drivers/pinctrl/sh-pfc/pfc-sh7269.c                 |   39 
 drivers/regulator/rk808-regulator.c                 |    2 
 drivers/remoteproc/remoteproc_core.c                |    2 
 drivers/scsi/aic7xxx/aic7xxx_core.c                 |    2 
 drivers/scsi/iscsi_tcp.c                            |    4 
 drivers/scsi/qla2xxx/qla_os.c                       |   19 
 drivers/scsi/scsi_transport_iscsi.c                 |   26 
 drivers/soc/tegra/fuse/tegra-apbmisc.c              |    2 
 drivers/staging/android/ashmem.c                    |   28 
 drivers/staging/rtl8188eu/os_dep/ioctl_linux.c      |    4 
 drivers/staging/vt6656/dpc.c                        |    2 
 drivers/target/iscsi/iscsi_target.c                 |   16 
 drivers/tty/serial/imx.c                            |    2 
 drivers/tty/vt/vt_ioctl.c                           |   75 
 drivers/uio/uio_dmem_genirq.c                       |    6 
 drivers/usb/core/hub.c                              |    5 
 drivers/usb/core/quirks.c                           |    3 
 drivers/usb/gadget/udc/gr_udc.c                     |   16 
 drivers/usb/host/xhci-pci.c                         |    4 
 drivers/usb/storage/uas.c                           |   23 
 drivers/xen/preempt.c                               |    4 
 fs/btrfs/disk-io.c                                  |    1 
 fs/btrfs/extent_map.c                               |   11 
 fs/btrfs/ordered-data.c                             |    7 
 fs/btrfs/super.c                                    |    2 
 fs/ecryptfs/crypto.c                                |    6 
 fs/ecryptfs/keystore.c                              |    2 
 fs/ecryptfs/messaging.c                             |    1 
 fs/ext4/dir.c                                       |   14 
 fs/ext4/ext4.h                                      |    7 
 fs/ext4/inode.c                                     |   14 
 fs/ext4/namei.c                                     |    8 
 fs/jbd2/checkpoint.c                                |    2 
 fs/jbd2/commit.c                                    |   50 
 fs/jbd2/journal.c                                   |   21 
 fs/jbd2/transaction.c                               |   10 
 fs/nfs/Kconfig                                      |    2 
 fs/ocfs2/journal.h                                  |    8 
 fs/reiserfs/stree.c                                 |    3 
 fs/reiserfs/super.c                                 |    2 
 fs/ubifs/file.c                                     |    5 
 include/linux/list_nulls.h                          |    8 
 include/linux/rculist_nulls.h                       |    8 
 include/scsi/iscsi_proto.h                          |    1 
 include/sound/rawmidi.h                             |    6 
 ipc/sem.c                                           |    6 
 kernel/padata.c                                     |   45 
 kernel/trace/trace_events_trigger.c                 |    5 
 kernel/trace/trace_stat.c                           |   19 
 lib/scatterlist.c                                   |    2 
 net/netfilter/xt_bpf.c                              |    3 
 scripts/kconfig/confdata.c                          |    2 
 security/selinux/avc.c                              |    2 
 sound/core/seq/seq_clientmgr.c                      |    4 
 sound/core/seq/seq_queue.c                          |   29 
 sound/core/seq/seq_timer.c                          |   13 
 sound/core/seq/seq_timer.h                          |    3 
 sound/pci/hda/hda_codec.c                           |    2 
 sound/pci/hda/hda_eld.c                             |    2 
 sound/pci/hda/hda_sysfs.c                           |    4 
 sound/pci/hda/patch_conexant.c                      |    1 
 sound/sh/aica.c                                     |    4 
 sound/soc/atmel/Kconfig                             |    2 
 sound/usb/quirks.c                                  |    1 
 sound/usb/usx2y/usX2Yhwdep.c                        |    2 
 tools/lib/api/fs/fs.c                               |    4 
 tools/usb/usbip/src/usbip_network.c                 |   40 
 tools/usb/usbip/src/usbip_network.h                 |   12 
 124 files changed, 777 insertions(+), 8411 deletions(-)

Aditya Pakki (2):
      orinoco: avoid assertion in case of NULL pointer
      ecryptfs: replace BUG_ON with error handling code

Al Viro (1):
      VT_RESIZEX: get rid of field-by-field copyin

Alan Stern (1):
      USB: hub: Don't record a connect-change event during reset-resume

Allen Pais (1):
      scsi: qla2xxx: fix a potential NULL pointer dereference

Andrey Zhizhikin (1):
      tools lib api fs: Fix gcc9 stringop-truncation compilation error

Andy Lutomirski (1):
      x86/vdso: Use RDPID in preference to LSL when available

Ard Biesheuvel (1):
      efi/x86: Map the entire EFI vendor string before copying it

Arnd Bergmann (1):
      wan: ixp4xx_hss: fix compile-testing on 64-bit

Arvind Sankar (1):
      ALSA: usb-audio: Apply sample rate quirk for Audioengine D1

Bart Van Assche (2):
      scsi: Revert "RDMA/isert: Fix a recently introduced regression related to logout"
      scsi: Revert "target: iscsi: Wait for all commands to finish before freeing a session"

Ben Skeggs (1):
      drm/nouveau/disp/nv50-: prevent oops when no channel method map provided

Brandon Maier (1):
      remoteproc: Initialize rproc_class before use

Chen Zhou (1):
      ASoC: atmel: fix build error with CONFIG_SND_ATMEL_SOC_DMA=m

Colin Ian King (1):
      iwlegacy: ensure loop counter addr does not wrap and cause an infinite loop

Coly Li (1):
      bcache: explicity type cast in bset_bkey_last()

Dan Carpenter (3):
      brcmfmac: Fix use after free in brcmf_sdio_readframes()
      cmd64x: potential buffer overflow in cmd64x_program_timings()
      ide: serverworks: potential overflow in svwks_set_pio_mode()

Daniel Vetter (1):
      radeon: insert 10ms sleep in dce5_crtc_load_lut

David Sterba (2):
      btrfs: log message when rw remount is attempted with unclean tree-log
      btrfs: print message when tree-log replay starts

Dmitry Osipenko (1):
      soc/tegra: fuse: Correct straps' address for older Tegra124 device trees

Douglas Anderson (1):
      clk: qcom: rcg2: Don't crash if our parent can't be found; return an error

EJ Hsu (1):
      usb: uas: fix a plug & unplug racing

Eric Dumazet (1):
      vt: vt_ioctl: fix race in VT_RESIZEX

Erik Kaneda (1):
      ACPICA: Disassembler: create buffer fields in ACPI_PARSE_LOAD_PASS1

Eugen Hristev (1):
      media: i2c: mt9v032: fix enum mbus codes and frame sizes

Filipe Manana (2):
      Btrfs: fix race between using extent maps and merging them
      Btrfs: fix btrfs_wait_ordered_range() so that it waits for all ordered extents

Firo Yang (1):
      enic: prevent waking up stopped tx queues over watchdog reset

Fugang Duan (1):
      tty: serial: imx: setup the correct sg entry for tx dma

Geert Uytterhoeven (5):
      pinctrl: sh-pfc: sh7264: Fix CAN function GPIOs
      nfs: NFS_SWAP should depend on SWAP
      ARM: dts: r8a7779: Add device node for ARM global timer
      pinctrl: sh-pfc: sh7269: Fix CAN function GPIOs
      driver core: Print device when resources present in really_probe()

Greg Kroah-Hartman (1):
      Linux 4.4.215

Herbert Xu (1):
      padata: Remove broken queue flushing

Ioanna Alifieraki (1):
      Revert "ipc,sem: remove uneeded sem_undo_list lock usage in exit_sem()"

Jaihind Yadav (1):
      selinux: ensure we cleanup the internal AVC counters on error in avc_update()

Jan Kara (2):
      ext4: fix checksum errors with indexed dirs
      reiserfs: Fix spurious unlock in reiserfs_fill_super() error handling

Jann Horn (1):
      netfilter: xt_bpf: add overflow checks

Jia-Ju Bai (3):
      media: sti: bdisp: fix a possible sleep-in-atomic-context bug in bdisp_device_run()
      uio: fix a sleep-in-atomic-context bug in uio_dmem_genirq_irqcontrol()
      usb: gadget: udc: fix possible sleep-in-atomic-context bugs in gr_probe()

Kai Li (1):
      jbd2: clear JBD2_ABORT flag before journal_reset to update log tail info when load journal

Larry Finger (2):
      staging: rtl8188eu: Fix potential security hole
      staging: rtl8188eu: Fix potential overuse of kernel memory

Linus Torvalds (1):
      floppy: check FDC index for errors before assigning it

Logan Gunthorpe (1):
      PCI: Don't disable bridge BARs when assigning bus resources

Malcolm Priestley (1):
      staging: vt6656: fix sign of rx_dbm to bb_pre_ed_rssi.

Mao Wenan (1):
      NFC: port100: Convert cpu_to_le16(le16_to_cpu(E1) + E2) to use le16_add_cpu().

Masahiro Yamada (1):
      kconfig: fix broken dependency in randconfig-generated .config

Mathias Nyman (1):
      xhci: apply XHCI_PME_STUCK_QUIRK to Intel Comet Lake platforms

Miaohe Lin (1):
      KVM: apic: avoid calculating pending eoi from an uninitialized val

Mike Jones (1):
      hwmon: (pmbus/ltc2978) Fix PMBus polling of MFR_COMMON definitions.

Miquel Raynal (1):
      regulator: rk808: Lower log level on optional GPIOs being not available

Nathan Chancellor (5):
      s390/time: Fix clk type in get_tod_clock
      ALSA: usx2y: Adjust indentation in snd_usX2Y_hwdep_dsp_status
      scsi: aic7xxx: Adjust indentation in ahc_find_syncrate
      hostap: Adjust indentation in prism2_hostapd_add_sta
      lib/scatterlist.c: adjust indentation in __sg_alloc_table

Navid Emamdoost (1):
      drm/vmwgfx: prevent memory leak in vmw_cmdbuf_res_add

Nick Black (1):
      scsi: iscsi: Don't destroy session if there are outstanding connections

Oliver Upton (2):
      KVM: nVMX: Refactor IO bitmap checks into helper function
      KVM: nVMX: Check IO instruction VM-exit conditions

Paolo Bonzini (2):
      KVM: x86: emulate RDPID
      KVM: nVMX: Don't emulate instructions in guest mode

Paul E. McKenney (1):
      rcu: Use WRITE_ONCE() for assignments to ->pprev for hlist_nulls

Paul Kocialkowski (1):
      drm/gma500: Fixup fbdev stolen size usage evaluation

Peter Große (1):
      ALSA: hda - Add docking station support for Lenovo Thinkpad T420s

Philipp Zabel (1):
      Input: edt-ft5x06 - work around first register access error

Phong Tran (4):
      b43legacy: Fix -Wcast-function-type
      ipw2x00: Fix -Wcast-function-type
      iwlegacy: Fix -Wcast-function-type
      rtlwifi: rtl_pci: Fix -Wcast-function-type

Qian Cai (1):
      ext4: fix a data race in EXT4_I(inode)->i_disksize

Richard Dodd (1):
      USB: Fix novation SourceControl XL after suspend

Sasha Levin (1):
      Revert "KVM: VMX: Add non-canonical check on writes to RTIT address MSRs"

Shijie Luo (1):
      ext4: add cond_resched() to __ext4_find_entry()

Shuah Khan (1):
      usbip: Fix unsafe unaligned pointer usage

Shubhrajyoti Datta (1):
      microblaze: Prevent the overflow of the start

Steven Rostedt (VMware) (1):
      tracing: Fix very unlikely race of registering two stat tracers

Suren Baghdasaryan (1):
      staging: android: ashmem: Disallow ashmem memory from being remapped

Takashi Iwai (5):
      ALSA: hda: Use scnprintf() for printing texts for sysfs/procfs
      ALSA: sh: Fix compile warning wrt const
      ALSA: rawmidi: Avoid bit fields for state flags
      ALSA: seq: Avoid concurrent access to queue flags
      ALSA: seq: Fix concurrent access to queue current tick/time

Thomas Gleixner (2):
      x86/mce/amd: Fix kobject lifetime
      xen: Enable interrupts when calling _cond_resched()

Tiezhu Yang (1):
      MIPS: Loongson: Fix potential NULL dereference in loongson3_platform_init()

Valdis Kletnieks (1):
      x86/vdso: Provide missing include file

Vasily Averin (1):
      trigger_next should increase position index

Vasily Gorbik (1):
      s390/ftrace: generate traced function stack frame

Vincenzo Frascino (1):
      ARM: 8951/1: Fix Kexec compilation issue.

Vladimir Oltean (1):
      gianfar: Fix TX timestamping with a stacked DSA driver

Wenwen Wang (2):
      ecryptfs: fix a memory leak bug in parse_tag_1_packet()
      ecryptfs: fix a memory leak bug in ecryptfs_init_messaging()

Will Deacon (1):
      iommu/arm-smmu-v3: Use WRITE_ONCE() when changing validity of an STE

YueHaibing (1):
      drm/nouveau: Fix copy-paste error in nouveau_fence_wait_uevent_handler

Yunfeng Ye (1):
      reiserfs: prevent NULL pointer dereference in reiserfs_insert_item()

Zenghui Yu (1):
      irqchip/gic-v3-its: Reference to its_invall_cmd descriptor when building INVALL

Zhihao Cheng (1):
      ubifs: Fix deadlock in concurrent bulk-read and writepage

Zhiqiang Liu (1):
      brd: check and limit max_part par

wangyan (1):
      ocfs2: fix a NULL pointer dereference when call ocfs2_update_inode_fsync_trans()

yu kuai (1):
      drm/amdgpu: remove 4 set but not used variable in amdgpu_atombios_get_connector_info_from_object_table

zhangyi (F) (4):
      jbd2: move the clearing of b_modified flag to the journal_unmap_buffer()
      jbd2: do not clear the BH_Mapped flag when forgetting a metadata buffer
      ext4, jbd2: ensure panic when aborting with zero errno
      jbd2: switch to use jbd2_journal_abort() when failed to submit the commit record

