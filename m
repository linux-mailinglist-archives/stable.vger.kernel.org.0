Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F678174C6E
	for <lists+stable@lfdr.de>; Sun,  1 Mar 2020 10:36:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726465AbgCAJgY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 1 Mar 2020 04:36:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:32808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725768AbgCAJgW (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 1 Mar 2020 04:36:22 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D25C420880;
        Sun,  1 Mar 2020 09:36:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583055381;
        bh=gBdFTcoSVhISjNq41lR6N4TgYz6nKhcI/sTgNEsjIgk=;
        h=Date:From:To:Cc:Subject:From;
        b=TNyYhz0I8R9MkTiv6oWvpjB7cNezfjoZK3bPqMErtCUezsZIiOyR7IsxS020q8B0f
         Mozno4l2XzJ/P+sf1TXhvlaiK/4xWlUscPwXlou7EDmNftnQo2PdWgMkuwqroOwkna
         GQthHUimmEWdtVImFHtQWOF/rgRqo0r15BnnttmI=
Date:   Sun, 1 Mar 2020 10:36:19 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.9.215
Message-ID: <20200301093619.GA1006593@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="ikeVEW9yuYc//A+q"
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--ikeVEW9yuYc//A+q
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 4.9.215 kernel.

All users of the 4.9 kernel series must upgrade.

The updated 4.9.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-4.9.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Ds=
ummary

thanks,

greg k-h

------------

 Makefile                                                |    2=20
 arch/arm/Kconfig                                        |    2=20
 arch/arm/boot/dts/r8a7779.dtsi                          |    8=20
 arch/arm64/include/asm/alternative.h                    |   32=20
 arch/microblaze/kernel/cpu/cache.c                      |    3=20
 arch/mips/loongson64/loongson-3/platform.c              |    3=20
 arch/powerpc/kernel/eeh_driver.c                        |    6=20
 arch/powerpc/kernel/pci_dn.c                            |   15=20
 arch/powerpc/platforms/powernv/pci-ioda.c               |   19=20
 arch/powerpc/platforms/powernv/pci.c                    |    4=20
 arch/s390/include/asm/page.h                            |    2=20
 arch/s390/include/asm/timex.h                           |    2=20
 arch/s390/kernel/mcount.S                               |   15=20
 arch/sh/include/cpu-sh2a/cpu/sh7269.h                   |   11=20
 arch/sparc/kernel/vmlinux.lds.S                         |    6=20
 arch/x86/entry/vdso/vdso32-setup.c                      |    1=20
 arch/x86/events/amd/core.c                              |    1=20
 arch/x86/events/intel/ds.c                              |    2=20
 arch/x86/include/asm/cpufeatures.h                      |    1=20
 arch/x86/include/asm/vgtod.h                            |    7=20
 arch/x86/kernel/cpu/mcheck/mce_amd.c                    |   50=20
 arch/x86/kernel/sysfb_simplefb.c                        |    2=20
 arch/x86/kvm/cpuid.c                                    |    7=20
 arch/x86/kvm/emulate.c                                  |   22=20
 arch/x86/kvm/irq_comm.c                                 |    2=20
 arch/x86/kvm/lapic.c                                    |    4=20
 arch/x86/kvm/vmx.c                                      |  102=20
 arch/x86/kvm/vmx/vmx.c                                  | 8033 -----------=
-----
 arch/x86/lib/x86-opcode-map.txt                         |    2=20
 arch/x86/platform/efi/efi.c                             |   13=20
 drivers/acpi/acpica/dsfield.c                           |    2=20
 drivers/acpi/acpica/dswload.c                           |   21=20
 drivers/ata/ahci.c                                      |    7=20
 drivers/ata/libata-core.c                               |   21=20
 drivers/base/dd.c                                       |    5=20
 drivers/base/platform.c                                 |   12=20
 drivers/block/brd.c                                     |   22=20
 drivers/block/floppy.c                                  |    7=20
 drivers/clk/qcom/clk-rcg2.c                             |    3=20
 drivers/devfreq/Kconfig                                 |    3=20
 drivers/devfreq/event/Kconfig                           |    2=20
 drivers/gpio/gpio-grgpio.c                              |   10=20
 drivers/gpu/drm/amd/amdgpu/amdgpu_atombios.c            |   19=20
 drivers/gpu/drm/gma500/framebuffer.c                    |    8=20
 drivers/gpu/drm/mediatek/mtk_drm_crtc.c                 |    8=20
 drivers/gpu/drm/nouveau/nouveau_fence.c                 |    2=20
 drivers/gpu/drm/nouveau/nvkm/engine/disp/channv50.c     |    2=20
 drivers/gpu/drm/nouveau/nvkm/engine/gr/gk20a.c          |   21=20
 drivers/gpu/drm/radeon/radeon_display.c                 |    2=20
 drivers/gpu/drm/vmwgfx/vmwgfx_cmdbuf_res.c              |    4=20
 drivers/hwmon/pmbus/ltc2978.c                           |    4=20
 drivers/ide/cmd64x.c                                    |    3=20
 drivers/ide/serverworks.c                               |    6=20
 drivers/infiniband/sw/rxe/rxe_verbs.h                   |    2=20
 drivers/infiniband/ulp/isert/ib_isert.c                 |   12=20
 drivers/input/touchscreen/edt-ft5x06.c                  |    7=20
 drivers/iommu/arm-smmu-v3.c                             |    3=20
 drivers/irqchip/irq-gic-v3-its.c                        |    2=20
 drivers/irqchip/irq-gic-v3.c                            |    9=20
 drivers/md/bcache/bset.h                                |    3=20
 drivers/media/i2c/mt9v032.c                             |   10=20
 drivers/media/platform/sti/bdisp/bdisp-hw.c             |    6=20
 drivers/net/ethernet/cisco/enic/enic_main.c             |    2=20
 drivers/net/ethernet/freescale/gianfar.c                |   10=20
 drivers/net/wan/fsl_ucc_hdlc.c                          |    5=20
 drivers/net/wan/ixp4xx_hss.c                            |    4=20
 drivers/net/wireless/broadcom/b43legacy/main.c          |    5=20
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c |    1=20
 drivers/net/wireless/intel/ipw2x00/ipw2100.c            |    7=20
 drivers/net/wireless/intel/ipw2x00/ipw2200.c            |    5=20
 drivers/net/wireless/intel/iwlegacy/3945-mac.c          |    5=20
 drivers/net/wireless/intel/iwlegacy/4965-mac.c          |    5=20
 drivers/net/wireless/intel/iwlegacy/common.c            |    2=20
 drivers/net/wireless/intel/iwlwifi/mvm/tt.c             |    4=20
 drivers/net/wireless/intersil/hostap/hostap_ap.c        |    2=20
 drivers/net/wireless/intersil/orinoco/orinoco_usb.c     |    3=20
 drivers/net/wireless/realtek/rtlwifi/pci.c              |   10=20
 drivers/nfc/port100.c                                   |    2=20
 drivers/pci/iov.c                                       |    1=20
 drivers/pinctrl/intel/pinctrl-baytrail.c                |    8=20
 drivers/pinctrl/sh-pfc/pfc-sh7264.c                     |    9=20
 drivers/pinctrl/sh-pfc/pfc-sh7269.c                     |   39=20
 drivers/pwm/pwm-omap-dmtimer.c                          |    7=20
 drivers/regulator/rk808-regulator.c                     |    2=20
 drivers/remoteproc/remoteproc_core.c                    |    2=20
 drivers/scsi/aic7xxx/aic7xxx_core.c                     |    2=20
 drivers/scsi/iscsi_tcp.c                                |    4=20
 drivers/scsi/qla2xxx/qla_os.c                           |   19=20
 drivers/scsi/scsi_transport_iscsi.c                     |   26=20
 drivers/soc/tegra/fuse/tegra-apbmisc.c                  |    2=20
 drivers/staging/android/ashmem.c                        |   28=20
 drivers/staging/greybus/audio_manager.c                 |    2=20
 drivers/staging/rtl8188eu/os_dep/ioctl_linux.c          |    4=20
 drivers/staging/vt6656/dpc.c                            |    2=20
 drivers/target/iscsi/iscsi_target.c                     |   16=20
 drivers/tty/serial/atmel_serial.c                       |    3=20
 drivers/tty/serial/imx.c                                |    2=20
 drivers/tty/synclink_gt.c                               |   18=20
 drivers/tty/synclinkmp.c                                |   24=20
 drivers/tty/vt/selection.c                              |    7=20
 drivers/tty/vt/vt_ioctl.c                               |   75=20
 drivers/uio/uio_dmem_genirq.c                           |    6=20
 drivers/usb/core/hub.c                                  |    5=20
 drivers/usb/core/quirks.c                               |    3=20
 drivers/usb/gadget/composite.c                          |    8=20
 drivers/usb/gadget/udc/gr_udc.c                         |   16=20
 drivers/usb/host/xhci-mem.c                             |   12=20
 drivers/usb/host/xhci-pci.c                             |    4=20
 drivers/usb/musb/omap2430.c                             |    2=20
 drivers/usb/storage/uas.c                               |   23=20
 drivers/video/fbdev/pxa168fb.c                          |    6=20
 drivers/vme/bridges/vme_fake.c                          |   30=20
 drivers/xen/preempt.c                                   |    4=20
 fs/btrfs/disk-io.c                                      |    1=20
 fs/btrfs/extent_map.c                                   |   11=20
 fs/btrfs/ordered-data.c                                 |    7=20
 fs/btrfs/super.c                                        |    2=20
 fs/cifs/connect.c                                       |    6=20
 fs/ecryptfs/crypto.c                                    |    6=20
 fs/ecryptfs/keystore.c                                  |    2=20
 fs/ecryptfs/messaging.c                                 |    1=20
 fs/ext4/dir.c                                           |   14=20
 fs/ext4/ext4.h                                          |   14=20
 fs/ext4/inode.c                                         |   24=20
 fs/ext4/migrate.c                                       |   27=20
 fs/ext4/mmp.c                                           |   12=20
 fs/ext4/namei.c                                         |    8=20
 fs/ext4/super.c                                         |   20=20
 fs/jbd2/checkpoint.c                                    |    2=20
 fs/jbd2/commit.c                                        |   50=20
 fs/jbd2/journal.c                                       |   21=20
 fs/jbd2/transaction.c                                   |   10=20
 fs/ocfs2/journal.h                                      |    8=20
 fs/orangefs/orangefs-debugfs.c                          |    1=20
 fs/reiserfs/stree.c                                     |    3=20
 fs/reiserfs/super.c                                     |    2=20
 fs/udf/super.c                                          |   22=20
 include/linux/libata.h                                  |    1=20
 include/linux/list_nulls.h                              |    8=20
 include/linux/rculist_nulls.h                           |    8=20
 include/media/v4l2-device.h                             |   12=20
 include/scsi/iscsi_proto.h                              |    1=20
 include/sound/rawmidi.h                                 |    6=20
 ipc/sem.c                                               |    6=20
 kernel/cpu.c                                            |   13=20
 kernel/padata.c                                         |   45=20
 kernel/trace/ftrace.c                                   |    5=20
 kernel/trace/trace_events_trigger.c                     |    5=20
 kernel/trace/trace_stat.c                               |   31=20
 lib/scatterlist.c                                       |    2=20
 lib/stackdepot.c                                        |    8=20
 net/netfilter/xt_bpf.c                                  |    3=20
 net/netfilter/xt_hashlimit.c                            |   10=20
 net/sched/cls_flower.c                                  |    1=20
 net/sched/cls_matchall.c                                |    1=20
 scripts/kconfig/confdata.c                              |    2=20
 security/selinux/avc.c                                  |    2=20
 sound/core/seq/seq_clientmgr.c                          |    4=20
 sound/core/seq/seq_queue.c                              |   29=20
 sound/core/seq/seq_timer.c                              |   13=20
 sound/core/seq/seq_timer.h                              |    3=20
 sound/hda/hdmi_chmap.c                                  |    2=20
 sound/pci/hda/hda_codec.c                               |    2=20
 sound/pci/hda/hda_eld.c                                 |    2=20
 sound/pci/hda/hda_sysfs.c                               |    4=20
 sound/pci/hda/patch_conexant.c                          |    1=20
 sound/sh/aica.c                                         |    4=20
 sound/soc/atmel/Kconfig                                 |    2=20
 sound/usb/quirks.c                                      |    1=20
 sound/usb/usx2y/usX2Yhwdep.c                            |    2=20
 tools/lib/api/fs/fs.c                                   |    4=20
 tools/objtool/arch/x86/lib/x86-opcode-map.txt           |    2=20
 tools/usb/usbip/src/usbip_network.c                     |   40=20
 tools/usb/usbip/src/usbip_network.h                     |   12=20
 174 files changed, 1102 insertions(+), 8589 deletions(-)

Aditya Pakki (2):
      orinoco: avoid assertion in case of NULL pointer
      ecryptfs: replace BUG_ON with error handling code

Al Viro (1):
      VT_RESIZEX: get rid of field-by-field copyin

Alan Stern (1):
      USB: hub: Don't record a connect-change event during reset-resume

Alexander Potapenko (1):
      lib/stackdepot.c: fix global out-of-bounds in stack_slabs

Allen Pais (1):
      scsi: qla2xxx: fix a potential NULL pointer dereference

Andreas Dilger (1):
      ext4: don't assume that mmp_nodename/bdevname have NUL

Andrei Otcheretianski (1):
      iwlwifi: mvm: Fix thermal zone registration

Andrey Zhizhikin (1):
      tools lib api fs: Fix gcc9 stringop-truncation compilation error

Andy Lutomirski (1):
      x86/vdso: Use RDPID in preference to LSL when available

Ard Biesheuvel (1):
      efi/x86: Map the entire EFI vendor string before copying it

Arnd Bergmann (2):
      wan: ixp4xx_hss: fix compile-testing on 64-bit
      vme: bridges: reduce stack usage

Arvind Sankar (2):
      ALSA: usb-audio: Apply sample rate quirk for Audioengine D1
      x86/sysfb: Fix check for bad VRAM size

Bart Van Assche (2):
      scsi: Revert "RDMA/isert: Fix a recently introduced regression relate=
d to logout"
      scsi: Revert "target: iscsi: Wait for all commands to finish before f=
reeing a session"

Ben Skeggs (2):
      drm/nouveau/gr/gk20a,gm200-: add terminators to method lists read fro=
m fw
      drm/nouveau/disp/nv50-: prevent oops when no channel method map provi=
ded

Bibby Hsieh (1):
      drm/mediatek: handle events when enabling/disabling crtc

Borislav Petkov (1):
      x86/mce/amd: Publish the bank pointer only after setup has succeeded

Brandon Maier (1):
      remoteproc: Initialize rproc_class before use

Chanwoo Choi (1):
      PM / devfreq: rk3399_dmc: Add COMPILE_TEST and HAVE_ARM_SMCCC depende=
ncy

Chen Zhou (1):
      ASoC: atmel: fix build error with CONFIG_SND_ATMEL_SOC_DMA=3Dm

Christophe JAILLET (1):
      pxa168fb: Fix the function used to release some memory in an error ha=
ndling path

Colin Ian King (2):
      driver core: platform: fix u32 greater or equal to zero comparison
      iwlegacy: ensure loop counter addr does not wrap and cause an infinit=
e loop

Coly Li (1):
      bcache: explicity type cast in bset_bkey_last()

Cong Wang (1):
      netfilter: xt_hashlimit: limit the max size of hashtable

Dan Carpenter (4):
      brcmfmac: Fix use after free in brcmf_sdio_readframes()
      cmd64x: potential buffer overflow in cmd64x_program_timings()
      ide: serverworks: potential overflow in svwks_set_pio_mode()
      staging: greybus: use after free in gb_audio_manager_remove_all()

Daniel Vetter (1):
      radeon: insert 10ms sleep in dce5_crtc_load_lut

David S. Miller (1):
      sparc: Add .exit.data section.

David Sterba (2):
      btrfs: log message when rw remount is attempted with unclean tree-log
      btrfs: print message when tree-log replay starts

Davide Caratti (2):
      net/sched: matchall: add missing validation of TCA_MATCHALL_FLAGS
      net/sched: flower: add missing validation of TCA_FLOWER_FLAGS

Dmitry Osipenko (1):
      soc/tegra: fuse: Correct straps' address for older Tegra124 device tr=
ees

Douglas Anderson (1):
      clk: qcom: rcg2: Don't crash if our parent can't be found; return an =
error

EJ Hsu (1):
      usb: uas: fix a plug & unplug racing

Eric Biggers (2):
      ext4: rename s_journal_flag_rwsem to s_writepages_rwsem
      ext4: fix race between writepages and enabling EXT4_EXTENTS_FL

Eric Dumazet (1):
      vt: vt_ioctl: fix race in VT_RESIZEX

Erik Kaneda (1):
      ACPICA: Disassembler: create buffer fields in ACPI_PARSE_LOAD_PASS1

Eugen Hristev (1):
      media: i2c: mt9v032: fix enum mbus codes and frame sizes

Filipe Manana (2):
      Btrfs: fix race between using extent maps and merging them
      Btrfs: fix btrfs_wait_ordered_range() so that it waits for all ordere=
d extents

Firo Yang (1):
      enic: prevent waking up stopped tx queues over watchdog reset

Fugang Duan (1):
      tty: serial: imx: setup the correct sg entry for tx dma

Geert Uytterhoeven (4):
      pinctrl: sh-pfc: sh7264: Fix CAN function GPIOs
      ARM: dts: r8a7779: Add device node for ARM global timer
      pinctrl: sh-pfc: sh7269: Fix CAN function GPIOs
      driver core: Print device when resources present in really_probe()

Greg Kroah-Hartman (1):
      Linux 4.9.215

Hans de Goede (1):
      pinctrl: baytrail: Do not clear IRQ flags on direct-irq enabled pins

Herbert Xu (1):
      padata: Remove broken queue flushing

Ioanna Alifieraki (1):
      Revert "ipc,sem: remove uneeded sem_undo_list lock usage in exit_sem(=
)"

Jack Pham (1):
      usb: gadget: composite: Fix bMaxPower for SuperSpeedPlus

Jaihind Yadav (1):
      selinux: ensure we cleanup the internal AVC counters on error in avc_=
update()

Jan Kara (4):
      ext4: fix checksum errors with indexed dirs
      reiserfs: Fix spurious unlock in reiserfs_fill_super() error handling
      udf: Fix free space reporting for metadata and virtual partitions
      ext4: fix mount failure with quota configured as module

Jann Horn (1):
      netfilter: xt_bpf: add overflow checks

Jia-Ju Bai (4):
      gpio: gpio-grgpio: fix possible sleep-in-atomic-context bugs in grgpi=
o_irq_map/unmap()
      media: sti: bdisp: fix a possible sleep-in-atomic-context bug in bdis=
p_device_run()
      uio: fix a sleep-in-atomic-context bug in uio_dmem_genirq_irqcontrol()
      usb: gadget: udc: fix possible sleep-in-atomic-context bugs in gr_pro=
be()

Jiewei Ke (1):
      RDMA/rxe: Fix error type of mmap_offset

Jiri Slaby (1):
      vt: selection, handle pending signals in paste_selection

Kai Li (1):
      jbd2: clear JBD2_ABORT flag before journal_reset to update log tail i=
nfo when load journal

Kan Liang (1):
      perf/x86/intel: Fix inaccurate period in context switch for auto-relo=
ad

Kim Phillips (1):
      perf/x86/amd: Add missing L2 misses event spec to AMD Family 17h's ev=
ent map

Larry Finger (2):
      staging: rtl8188eu: Fix potential security hole
      staging: rtl8188eu: Fix potential overuse of kernel memory

Linus Torvalds (1):
      floppy: check FDC index for errors before assigning it

Luis Henriques (1):
      tracing: Fix tracing_stat return values in error handling paths

Malcolm Priestley (1):
      staging: vt6656: fix sign of rx_dbm to bb_pre_ed_rssi.

Mao Wenan (1):
      NFC: port100: Convert cpu_to_le16(le16_to_cpu(E1) + E2) to use le16_a=
dd_cpu().

Marc Zyngier (1):
      irqchip/gic-v3: Only provision redistributors that are enabled in ACPI

Masahiro Yamada (1):
      kconfig: fix broken dependency in randconfig-generated .config

Masami Hiramatsu (1):
      x86/decoder: Add TEST opcode to Group3-2

Mathias Nyman (2):
      xhci: Force Maximum Packet size for Full-speed bulk devices to valid =
range.
      xhci: apply XHCI_PME_STUCK_QUIRK to Intel Comet Lake platforms

Miaohe Lin (2):
      KVM: x86: don't notify userspace IOAPIC on edge-triggered interrupt E=
OI
      KVM: apic: avoid calculating pending eoi from an uninitialized val

Mike Jones (1):
      hwmon: (pmbus/ltc2978) Fix PMBus polling of MFR_COMMON definitions.

Miquel Raynal (1):
      regulator: rk808: Lower log level on optional GPIOs being not availab=
le

Nathan Chancellor (9):
      s390/time: Fix clk type in get_tod_clock
      media: v4l2-device.h: Explicitly compare grp{id,mask} to zero in v4l2=
_device macros
      ALSA: usx2y: Adjust indentation in snd_usX2Y_hwdep_dsp_status
      scsi: aic7xxx: Adjust indentation in ahc_find_syncrate
      tty: synclinkmp: Adjust indentation in several functions
      tty: synclink_gt: Adjust indentation in several functions
      hostap: Adjust indentation in prism2_hostapd_add_sta
      lib/scatterlist.c: adjust indentation in __sg_alloc_table
      s390/mm: Explicitly compare PAGE_DEFAULT_KEY against zero in storage_=
key_init_range

Navid Emamdoost (2):
      PCI/IOV: Fix memory leak in pci_iov_add_virtfn()
      drm/vmwgfx: prevent memory leak in vmw_cmdbuf_res_add

Nick Black (1):
      scsi: iscsi: Don't destroy session if there are outstanding connectio=
ns

Nicolas Ferre (1):
      tty/serial: atmel: manage shutdown in case of RS485 or ISO7816 mode

Oliver O'Halloran (2):
      powerpc/powernv/iov: Ensure the pdn for VFs always contains a valid P=
E number
      powerpc/sriov: Remove VF eeh_dev state when disabling SR-IOV

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

Peter Gro=DFe (1):
      ALSA: hda - Add docking station support for Lenovo Thinkpad T420s

Peter Zijlstra (1):
      cpu/hotplug, stop_machine: Fix stop_machine vs hotplug order

Philipp Zabel (1):
      Input: edt-ft5x06 - work around first register access error

Phong Tran (4):
      b43legacy: Fix -Wcast-function-type
      ipw2x00: Fix -Wcast-function-type
      iwlegacy: Fix -Wcast-function-type
      rtlwifi: rtl_pci: Fix -Wcast-function-type

Prabhakar Kushwaha (1):
      ata: ahci: Add shutdown to freeze hardware resources of ahci

Qian Cai (1):
      ext4: fix a data race in EXT4_I(inode)->i_disksize

Rasmus Villemoes (1):
      net/wan/fsl_ucc_hdlc: reject muram offsets above 64K

Richard Dodd (1):
      USB: Fix novation SourceControl XL after suspend

Ronnie Sahlberg (1):
      cifs: fix NULL dereference in match_prepath

Sami Tolvanen (1):
      arm64: fix alternatives with LLVM's integrated assembler

Sasha Levin (1):
      Revert "KVM: VMX: Add non-canonical check on writes to RTIT address M=
SRs"

Shijie Luo (1):
      ext4: add cond_resched() to __ext4_find_entry()

Shuah Khan (1):
      usbip: Fix unsafe unaligned pointer usage

Shubhrajyoti Datta (1):
      microblaze: Prevent the overflow of the start

Simon Schwartz (1):
      driver core: platform: Prevent resouce overflow from causing infinite=
 loops

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

Theodore Ts'o (1):
      ext4: improve explanation of a mount failure caused by a misconfigure=
d kernel

Thomas Gleixner (2):
      x86/mce/amd: Fix kobject lifetime
      xen: Enable interrupts when calling _cond_resched()

Tiezhu Yang (1):
      MIPS: Loongson: Fix potential NULL dereference in loongson3_platform_=
init()

Tony Lindgren (1):
      usb: musb: omap2430: Get rid of musb .set_vbus for omap2430 glue

Uwe Kleine-K=F6nig (1):
      pwm: omap-dmtimer: Remove PWM chip in .remove before making it unfunc=
tional

Valdis Kletnieks (1):
      x86/vdso: Provide missing include file

Vasily Averin (3):
      ftrace: fpid_next() should increase position index
      trigger_next should increase position index
      help_next should increase position index

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
      irqchip/gic-v3-its: Reference to its_invall_cmd descriptor when build=
ing INVALL

Zhiqiang Liu (1):
      brd: check and limit max_part par

wangyan (1):
      ocfs2: fix a NULL pointer dereference when call ocfs2_update_inode_fs=
ync_trans()

yu kuai (1):
      drm/amdgpu: remove 4 set but not used variable in amdgpu_atombios_get=
_connector_info_from_object_table

zhangyi (F) (4):
      jbd2: move the clearing of b_modified flag to the journal_unmap_buffe=
r()
      jbd2: do not clear the BH_Mapped flag when forgetting a metadata buff=
er
      ext4, jbd2: ensure panic when aborting with zero errno
      jbd2: switch to use jbd2_journal_abort() when failed to submit the co=
mmit record


--ikeVEW9yuYc//A+q
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl5bgg8ACgkQONu9yGCS
aT4plBAAm98gIiUJbAR87XZ73JTVLwiLvujSbat0qDe39YmJi7Yj1lZmKXH4S4pM
ANPSuaJgLb/IIZ5fs90KpKk4M0K21PHY98x/DdzRJQ6bfWBnRMeu49FHuppNve7M
f3DNI7g2C/2R98euq9WGKi42V6iRgYheoCKHg3K++ypEvFzp9HyPChX+genKmyUP
i1Vqv5AN7hR1X6gUdjDQm4yur8GWVn5MiNHUab+ZJ8Iw9pPiMq2mcb97LV9o79Wk
bk9UVxVmwdMXcnkuiGkzG2MhC82lBmLU2psGyfG2ND1PN+0MRiGyXrVySz9GLVDq
6clSkyUaZUfy0pfcLoFvGWCuNH6Cne1kNGBUs+pbMTpwgw5Ic4ji6SHL0S3lldXC
Osnv6CDwl42BbK3qs44dpi9tBl1K8QiXB9IAofKCpkCCnf2RoRuqyW1i3TTr6LX/
R0ikm9yldayw9l0qpluQ9qlkjpSReEjxtaeCVKcJlED7NSuGbIQhdwNeIpd0WWZ+
aFbw2INtP2n2QwOvpRJ/PHcvyKwy6PswpdJdjgHPL0I/zbL8a+8BvMuQ7jZ2nTG9
cy7BsTaLy+F4RgDgfBX9SIpcfpN2Id+/11EIOsxPEFf8o+cE/6oM/n50CUbRFQTP
c/zN9sPJy9InJwtLMAvW2fI6nR37FPikJwiHAHyze05PXcB/U/s=
=uwJg
-----END PGP SIGNATURE-----

--ikeVEW9yuYc//A+q--
