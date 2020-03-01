Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 502DC174C9E
	for <lists+stable@lfdr.de>; Sun,  1 Mar 2020 10:42:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725877AbgCAJms (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 1 Mar 2020 04:42:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:35406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725861AbgCAJms (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 1 Mar 2020 04:42:48 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 74FF820880;
        Sun,  1 Mar 2020 09:42:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583055766;
        bh=mXI/UOlP6ohdL++aq+Fe193skWZekypb9kYt+qGrsgQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FEJg1i5wUiFg2og7iNaLzJm6PEYWkETeaMbrBiPCbLKPm+oHZ8yjLJz78KEeD/jYh
         /j3iyg122q4BKZVaIZ3aAQEGQvsRHWD+Qoj6UwtisbxWahOGghtHa6DvjUPELZ/qjV
         W60DqeZWBnhNic40fGrAYWVbSaCVWnd8X9/j8kV0=
Date:   Sun, 1 Mar 2020 10:42:43 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        lkft-triage@lists.linaro.org, stable <stable@vger.kernel.org>
Subject: Re: [PATCH 4.14 000/237] 4.14.172-stable review
Message-ID: <20200301094243.GA1027353@kroah.com>
References: <20200227132255.285644406@linuxfoundation.org>
 <CAMuHMdXPzqmhj1E0AywSiThMQK1AfR4Rp19DV7W8uSp=8p_Zgg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMuHMdXPzqmhj1E0AywSiThMQK1AfR4Rp19DV7W8uSp=8p_Zgg@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Mar 01, 2020 at 10:38:18AM +0100, Geert Uytterhoeven wrote:
> Hi Greg,
> 
> On Thu, Feb 27, 2020 at 2:55 PM Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> > This is the start of the stable review cycle for the 4.14.172 release.
> > There are 237 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Sat, 29 Feb 2020 13:21:24 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.172-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> >
> > -------------
> > Pseudo-Shortlog of commits:
> 
> Given you do have a git branch containing these commits, is there any
> chance you can update your scripts to insert a real (sorted) shortlog
> here?
> That would make it easier for us contributors to track what has been
> backported.

How would a real shortlog help any better, except to have things sorted
a tad easier?

I can't remember why I do it this way, but for some reason, many many
years ago, this was a better solution than a "traditional" shortlog.

Here's the shortlog for this release for comparison:

Aditya Pakki (3):
      fore200e: Fix incorrect checks of NULL pointer dereference
      orinoco: avoid assertion in case of NULL pointer
      ecryptfs: replace BUG_ON with error handling code

Al Viro (1):
      VT_RESIZEX: get rid of field-by-field copyin

Alan Stern (1):
      USB: hub: Don't record a connect-change event during reset-resume

Alex Deucher (1):
      drm/amdgpu/soc15: fix xclk for raven

Alexander Potapenko (1):
      lib/stackdepot.c: fix global out-of-bounds in stack_slabs

Allen Pais (1):
      scsi: qla2xxx: fix a potential NULL pointer dereference

Anand Jain (1):
      btrfs: device stats, log when stats are zeroed

Andreas Dilger (1):
      ext4: don't assume that mmp_nodename/bdevname have NUL

Andrei Otcheretianski (1):
      iwlwifi: mvm: Fix thermal zone registration

Andrey Smirnov (1):
      ARM: dts: imx6: rdu2: Disable WP for USDHC2 and USDHC3

Andrey Zhizhikin (1):
      tools lib api fs: Fix gcc9 stringop-truncation compilation error

Andy Shevchenko (1):
      serial: 8250: Check UPF_IRQ_SHARED in advance

Ard Biesheuvel (3):
      efi/x86: Map the entire EFI vendor string before copying it
      efi/x86: Don't panic or BUG() on non-critical error conditions
      x86/mm: Fix NX bit clearing issue in kernel_map_pages_in_pgd

Arnd Bergmann (2):
      wan: ixp4xx_hss: fix compile-testing on 64-bit
      vme: bridges: reduce stack usage

Arvind Sankar (2):
      ALSA: usb-audio: Apply sample rate quirk for Audioengine D1
      x86/sysfb: Fix check for bad VRAM size

Bart Van Assche (2):
      scsi: Revert "RDMA/isert: Fix a recently introduced regression related to logout"
      scsi: Revert "target: iscsi: Wait for all commands to finish before freeing a session"

Ben Skeggs (2):
      drm/nouveau/gr/gk20a,gm200-: add terminators to method lists read from fw
      drm/nouveau/disp/nv50-: prevent oops when no channel method map provided

Benjamin Tissoires (1):
      Input: synaptics - remove the LEN0049 dmi id from topbuttonpad list

Bibby Hsieh (1):
      drm/mediatek: handle events when enabling/disabling crtc

Borislav Petkov (1):
      x86/mce/amd: Publish the bank pointer only after setup has succeeded

Brandon Maier (1):
      remoteproc: Initialize rproc_class before use

Can Guo (1):
      scsi: ufs: Complete pending requests in host reset and restore path

Chanwoo Choi (1):
      PM / devfreq: rk3399_dmc: Add COMPILE_TEST and HAVE_ARM_SMCCC dependency

Chao Yu (1):
      f2fs: fix memleak of kobject

Chen Zhou (1):
      ASoC: atmel: fix build error with CONFIG_SND_ATMEL_SOC_DMA=m

Christian Borntraeger (1):
      KVM: s390: ENOTSUPP -> EOPNOTSUPP fixups

Christophe JAILLET (1):
      pxa168fb: Fix the function used to release some memory in an error handling path

Colin Ian King (4):
      clocksource/drivers/bcm2835_timer: Fix memory leak of timer
      driver core: platform: fix u32 greater or equal to zero comparison
      iwlegacy: ensure loop counter addr does not wrap and cause an infinite loop
      staging: rtl8723bs: fix copy of overlapping memory

Coly Li (1):
      bcache: explicity type cast in bset_bkey_last()

Cong Wang (1):
      netfilter: xt_hashlimit: limit the max size of hashtable

Dan Carpenter (5):
      brcmfmac: Fix use after free in brcmf_sdio_readframes()
      drm/nouveau/secboot/gm20b: initialize pointer in gm20b_secboot_new()
      cmd64x: potential buffer overflow in cmd64x_program_timings()
      ide: serverworks: potential overflow in svwks_set_pio_mode()
      staging: greybus: use after free in gb_audio_manager_remove_all()

Daniel Vetter (1):
      radeon: insert 10ms sleep in dce5_crtc_load_lut

David S. Miller (1):
      sparc: Add .exit.data section.

David Sterba (3):
      btrfs: print message when tree-log replay starts
      btrfs: log message when rw remount is attempted with unclean tree-log
      btrfs: safely advance counter when looking up bio csums

Davide Caratti (2):
      net/sched: matchall: add missing validation of TCA_MATCHALL_FLAGS
      net/sched: flower: add missing validation of TCA_FLOWER_FLAGS

Dingchen Zhang (1):
      drm: remove the newline for CRC source name.

Dmitry Osipenko (1):
      soc/tegra: fuse: Correct straps' address for older Tegra124 device trees

Douglas Anderson (1):
      clk: qcom: rcg2: Don't crash if our parent can't be found; return an error

EJ Hsu (1):
      usb: uas: fix a plug & unplug racing

Eric Biggers (2):
      ext4: rename s_journal_flag_rwsem to s_writepages_rwsem
      ext4: fix race between writepages and enabling EXT4_EXTENTS_FL

Eric Dumazet (2):
      net/smc: fix leak of kernel memory to user space
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

Gaurav Agrawal (1):
      Input: synaptics - enable SMBus on ThinkPad L470

Gavin Shan (1):
      mm/vmscan.c: don't round up scan size for online memory cgroup

Geert Uytterhoeven (4):
      pinctrl: sh-pfc: sh7264: Fix CAN function GPIOs
      ARM: dts: r8a7779: Add device node for ARM global timer
      pinctrl: sh-pfc: sh7269: Fix CAN function GPIOs
      driver core: Print device when resources present in really_probe()

Greg Kroah-Hartman (4):
      USB: misc: iowarrior: add support for 2 OEMed devices
      USB: misc: iowarrior: add support for the 28 and 28L devices
      USB: misc: iowarrior: add support for the 100 device
      Linux 4.14.172

Hans de Goede (1):
      pinctrl: baytrail: Do not clear IRQ flags on direct-irq enabled pins

Hardik Gajjar (1):
      USB: hub: Fix the broken detection of USB3 device in SMSC hub

Herbert Xu (1):
      padata: Remove broken queue flushing

Icenowy Zheng (1):
      clk: sunxi-ng: add mux and pll notifiers for A64 CPU clock

Ido Schimmel (1):
      mlxsw: spectrum_dpipe: Add missing error path

Ioanna Alifieraki (1):
      Revert "ipc,sem: remove uneeded sem_undo_list lock usage in exit_sem()"

Jack Pham (1):
      usb: gadget: composite: Fix bMaxPower for SuperSpeedPlus

Jaegeuk Kim (1):
      f2fs: free sysfs kobject

Jaihind Yadav (1):
      selinux: ensure we cleanup the internal AVC counters on error in avc_update()

Jan Kara (4):
      ext4: fix checksum errors with indexed dirs
      reiserfs: Fix spurious unlock in reiserfs_fill_super() error handling
      udf: Fix free space reporting for metadata and virtual partitions
      ext4: fix mount failure with quota configured as module

Jani Nikula (1):
      MAINTAINERS: Update drm/i915 bug filing URL

Jia-Ju Bai (4):
      gpio: gpio-grgpio: fix possible sleep-in-atomic-context bugs in grgpio_irq_map/unmap()
      media: sti: bdisp: fix a possible sleep-in-atomic-context bug in bdisp_device_run()
      uio: fix a sleep-in-atomic-context bug in uio_dmem_genirq_irqcontrol()
      usb: gadget: udc: fix possible sleep-in-atomic-context bugs in gr_probe()

Jiewei Ke (1):
      RDMA/rxe: Fix error type of mmap_offset

Jiri Slaby (1):
      vt: selection, handle pending signals in paste_selection

Joerg Roedel (1):
      iommu/vt-d: Fix compile warning from intel-svm.h

Johan Hovold (1):
      serdev: ttyport: restore client ops on deregistration

Johannes Thumshirn (1):
      btrfs: fix possible NULL-pointer dereference in integrity checks

John Garry (1):
      irqchip/mbigen: Set driver .suppress_bind_attrs to avoid remove problems

John Keeping (1):
      usb: dwc2: Fix IN FIFO allocation

Josef Bacik (2):
      btrfs: fix bytes_may_use underflow in prealloc error condtition
      btrfs: do not check delayed items are empty for single transaction cleanup

Kai Li (1):
      jbd2: clear JBD2_ABORT flag before journal_reset to update log tail info when load journal

Kai Vehmanen (1):
      ALSA: hda/hdmi - add retry logic to parse_intel_hdmi()

Kan Liang (1):
      perf/x86/intel: Fix inaccurate period in context switch for auto-reload

Kim Phillips (1):
      perf/x86/amd: Add missing L2 misses event spec to AMD Family 17h's event map

Larry Finger (4):
      staging: rtl8188eu: Fix potential security hole
      staging: rtl8188eu: Fix potential overuse of kernel memory
      staging: rtl8723bs: Fix potential security hole
      staging: rtl8723bs: Fix potential overuse of kernel memory

Leon Romanovsky (1):
      RDMA/core: Fix protection fault in get_pkey_idx_qp_list

Linus Torvalds (1):
      floppy: check FDC index for errors before assigning it

Logan Gunthorpe (1):
      dmaengine: Store module owner in dma_device struct

Luis Henriques (1):
      tracing: Fix tracing_stat return values in error handling paths

Lyude Paul (1):
      Input: synaptics - switch T470s to RMI4 by default

Malcolm Priestley (1):
      staging: vt6656: fix sign of rx_dbm to bb_pre_ed_rssi.

Manu Gautam (1):
      arm64: dts: qcom: msm8996: Disable USB2 PHY suspend by core

Mao Wenan (1):
      NFC: port100: Convert cpu_to_le16(le16_to_cpu(E1) + E2) to use le16_add_cpu().

Marc Zyngier (1):
      irqchip/gic-v3: Only provision redistributors that are enabled in ACPI

Masahiro Yamada (1):
      kconfig: fix broken dependency in randconfig-generated .config

Masami Hiramatsu (1):
      x86/decoder: Add TEST opcode to Group3-2

Mathias Nyman (3):
      xhci: Force Maximum Packet size for Full-speed bulk devices to valid range.
      xhci: fix runtime pm enabling for quirky Intel hosts
      xhci: apply XHCI_PME_STUCK_QUIRK to Intel Comet Lake platforms

Miaohe Lin (2):
      KVM: x86: don't notify userspace IOAPIC on edge-triggered interrupt EOI
      KVM: apic: avoid calculating pending eoi from an uninitialized val

Michael S. Tsirkin (1):
      virtio_balloon: prevent pfn array overflow

Mika Westerberg (1):
      thunderbolt: Prevent crash if non-active NVMem file is read

Mike Jones (1):
      hwmon: (pmbus/ltc2978) Fix PMBus polling of MFR_COMMON definitions.

Mike Marciniszyn (2):
      IB/hfi1: Close window for pq and request coliding
      IB/hfi1: Add software counter for ctxt0 seq drop

Miquel Raynal (1):
      regulator: rk808: Lower log level on optional GPIOs being not available

Nathan Chancellor (9):
      s390/time: Fix clk type in get_tod_clock
      media: v4l2-device.h: Explicitly compare grp{id,mask} to zero in v4l2_device macros
      ALSA: usx2y: Adjust indentation in snd_usX2Y_hwdep_dsp_status
      scsi: aic7xxx: Adjust indentation in ahc_find_syncrate
      tty: synclinkmp: Adjust indentation in several functions
      tty: synclink_gt: Adjust indentation in several functions
      hostap: Adjust indentation in prism2_hostapd_add_sta
      lib/scatterlist.c: adjust indentation in __sg_alloc_table
      s390/mm: Explicitly compare PAGE_DEFAULT_KEY against zero in storage_key_init_range

Navid Emamdoost (2):
      PCI/IOV: Fix memory leak in pci_iov_add_virtfn()
      drm/vmwgfx: prevent memory leak in vmw_cmdbuf_res_add

Nick Black (1):
      scsi: iscsi: Don't destroy session if there are outstanding connections

Nicolas Ferre (1):
      tty/serial: atmel: manage shutdown in case of RS485 or ISO7816 mode

Nicolas Pitre (1):
      ARM: 8723/2: always assume the "unified" syntax for assembly code

Oliver O'Halloran (2):
      powerpc/powernv/iov: Ensure the pdn for VFs always contains a valid PE number
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

Per Forlin (1):
      net: dsa: tag_qca: Make sure there is headroom for tag

Peter Chen (1):
      usb: host: xhci: update event ring dequeue pointer on purpose

Peter Große (1):
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

Ritesh Harjani (1):
      ext4: fix ext4_dax_read/write inode locking sequence for IOCB_NOWAIT

Robin Murphy (1):
      iommu/qcom: Fix bogus detach logic

Ronnie Sahlberg (1):
      cifs: fix NULL dereference in match_prepath

Sami Tolvanen (1):
      arm64: fix alternatives with LLVM's integrated assembler

Samuel Holland (1):
      ASoC: sun8i-codec: Fix setting DAI data format

Sasha Levin (2):
      Revert "KVM: nVMX: Use correct root level for nested EPT shadow page tables"
      Revert "KVM: VMX: Add non-canonical check on writes to RTIT address MSRs"

Sean Christopherson (2):
      KVM: nVMX: Use correct root level for nested EPT shadow page tables
      KVM: nVMX: Use correct root level for nested EPT shadow page tables

Sergey Senozhatsky (1):
      char/random: silence a lockdep splat with printk()

Shijie Luo (1):
      ext4: add cond_resched() to __ext4_find_entry()

Shuah Khan (1):
      usbip: Fix unsafe unaligned pointer usage

Shubhrajyoti Datta (1):
      microblaze: Prevent the overflow of the start

Siddhesh Poyarekar (1):
      kselftest: Minimise dependency of get_size on C library interfaces

Simon Schwartz (1):
      driver core: platform: Prevent resouce overflow from causing infinite loops

Steven Rostedt (VMware) (1):
      tracing: Fix very unlikely race of registering two stat tracers

Sun Ke (1):
      nbd: add a flush_workqueue in nbd_start_device

Suren Baghdasaryan (1):
      staging: android: ashmem: Disallow ashmem memory from being remapped

Suzuki K Poulose (3):
      arm64: cpufeature: Set the FP/SIMD compat HWCAP bits properly
      arm64: ptrace: nofpsimd: Fail FP/SIMD regset operations
      arm64: nofpsimd: Handle TIF_FOREIGN_FPSTATE flag cleanly

Takashi Iwai (6):
      ALSA: hda: Use scnprintf() for printing texts for sysfs/procfs
      ALSA: sh: Fix unused variable warnings
      ALSA: sh: Fix compile warning wrt const
      ALSA: rawmidi: Avoid bit fields for state flags
      ALSA: seq: Avoid concurrent access to queue flags
      ALSA: seq: Fix concurrent access to queue current tick/time

Takashi Sakamoto (1):
      ALSA: ctl: allow TLV read operation for callback type of element in locked case

Theodore Ts'o (2):
      ext4: fix support for inode sizes > 1024 bytes
      ext4: improve explanation of a mount failure caused by a misconfigured kernel

Thomas Gleixner (4):
      watchdog/softlockup: Enforce that timestamp is valid on boot
      x86/mce/amd: Fix kobject lifetime
      genirq/proc: Reject invalid affinity masks (again)
      xen: Enable interrupts when calling _cond_resched()

Tiezhu Yang (1):
      MIPS: Loongson: Fix potential NULL dereference in loongson3_platform_init()

Tony Lindgren (1):
      usb: musb: omap2430: Get rid of musb .set_vbus for omap2430 glue

Uwe Kleine-König (3):
      serial: imx: ensure that RX irqs are off if RX is off
      serial: imx: Only handle irqs that are actually enabled
      pwm: omap-dmtimer: Remove PWM chip in .remove before making it unfunctional

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

Vitaly Kuznetsov (1):
      KVM: nVMX: handle nested posted interrupts when apicv is disabled for L1

Vladimir Oltean (1):
      gianfar: Fix TX timestamping with a stacked DSA driver

Wenwen Wang (2):
      ecryptfs: fix a memory leak bug in parse_tag_1_packet()
      ecryptfs: fix a memory leak bug in ecryptfs_init_messaging()

Will Deacon (2):
      arm64: ssbs: Fix context-switch when SSBS is present on all CPUs
      iommu/arm-smmu-v3: Use WRITE_ONCE() when changing validity of an STE

Xiubo Li (1):
      ceph: check availability of mds cluster on mount after wait timeout

YueHaibing (1):
      drm/nouveau: Fix copy-paste error in nouveau_fence_wait_uevent_handler

Yunfeng Ye (1):
      reiserfs: prevent NULL pointer dereference in reiserfs_insert_item()

Zahari Petkov (1):
      leds: pca963x: Fix open-drain initialization

Zenghui Yu (1):
      irqchip/gic-v3-its: Reference to its_invall_cmd descriptor when building INVALL

Zhiqiang Liu (1):
      brd: check and limit max_part par

wangyan (1):
      ocfs2: fix a NULL pointer dereference when call ocfs2_update_inode_fsync_trans()

yu kuai (2):
      drm/amdgpu: remove 4 set but not used variable in amdgpu_atombios_get_connector_info_from_object_table
      pwm: Remove set but not set variable 'pwm'

zhangyi (F) (5):
      jbd2: move the clearing of b_modified flag to the journal_unmap_buffer()
      jbd2: do not clear the BH_Mapped flag when forgetting a metadata buffer
      ext4, jbd2: ensure panic when aborting with zero errno
      jbd2: switch to use jbd2_journal_abort() when failed to submit the commit record
      jbd2: make sure ESHUTDOWN to be recorded in the journal superblock

