Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23A6521474
	for <lists+stable@lfdr.de>; Fri, 17 May 2019 09:35:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728393AbfEQHfF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 May 2019 03:35:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:45544 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727500AbfEQHfF (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 17 May 2019 03:35:05 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7A4B4206A3;
        Fri, 17 May 2019 07:35:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558078503;
        bh=Lw9iDpXYFB3qGaqEjnJCIvUACszoIH535XWihjNqUyE=;
        h=Date:From:To:Cc:Subject:From;
        b=YFFutnp2AlQQQH62VvQhD0SO/khutOvBMxjKO5h6yK11f1WY41fCLr+vDLO4aFGeT
         1LoMWXa+culdNel2wb4IwMJZ5fKKcFk0dM70Ue/KXIKdKkFTpl+GogScfMKZggB7Qn
         07QeC1Ff/1xOMFxypm5zsTMSyyDGlUgsh6bu/3CQ=
Date:   Fri, 17 May 2019 09:35:00 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.4.180
Message-ID: <20190517073500.GA22325@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.4.180 kernel.

All users of the 4.4 kernel series must upgrade.

The updated 4.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/ABI/testing/sysfs-devices-system-cpu  |    2 
 Documentation/hw-vuln/mds.rst                       |  305 +++++++++
 Documentation/kernel-parameters.txt                 |  110 +++
 Documentation/networking/ip-sysctl.txt              |    1 
 Documentation/spec_ctrl.txt                         |    9 
 Documentation/usb/power-management.txt              |   14 
 Documentation/x86/mds.rst                           |  225 ++++++
 Makefile                                            |    2 
 arch/arm/boot/dts/imx6qdl-phytec-pfla02.dtsi        |    1 
 arch/arm/mach-iop13xx/setup.c                       |    8 
 arch/arm/mach-iop13xx/tpmi.c                        |   10 
 arch/arm/plat-iop/adma.c                            |    6 
 arch/arm/plat-orion/common.c                        |    4 
 arch/mips/kernel/scall64-o32.S                      |    2 
 arch/powerpc/Kconfig                                |    7 
 arch/powerpc/include/asm/asm-prototypes.h           |   21 
 arch/powerpc/include/asm/barrier.h                  |   21 
 arch/powerpc/include/asm/code-patching-asm.h        |   18 
 arch/powerpc/include/asm/code-patching.h            |    2 
 arch/powerpc/include/asm/exception-64s.h            |   35 +
 arch/powerpc/include/asm/feature-fixups.h           |   40 +
 arch/powerpc/include/asm/hvcall.h                   |    5 
 arch/powerpc/include/asm/paca.h                     |    3 
 arch/powerpc/include/asm/ppc-opcode.h               |    1 
 arch/powerpc/include/asm/ppc_asm.h                  |   11 
 arch/powerpc/include/asm/reg_booke.h                |    2 
 arch/powerpc/include/asm/security_features.h        |   92 ++
 arch/powerpc/include/asm/setup.h                    |   23 
 arch/powerpc/include/asm/uaccess.h                  |   18 
 arch/powerpc/kernel/Makefile                        |    1 
 arch/powerpc/kernel/asm-offsets.c                   |    3 
 arch/powerpc/kernel/entry_32.S                      |   10 
 arch/powerpc/kernel/entry_64.S                      |   69 ++
 arch/powerpc/kernel/exceptions-64e.S                |   27 
 arch/powerpc/kernel/exceptions-64s.S                |   98 +--
 arch/powerpc/kernel/head_booke.h                    |   12 
 arch/powerpc/kernel/head_fsl_booke.S                |   15 
 arch/powerpc/kernel/module.c                        |   10 
 arch/powerpc/kernel/security.c                      |  434 +++++++++++++
 arch/powerpc/kernel/setup_32.c                      |    3 
 arch/powerpc/kernel/setup_64.c                      |   51 -
 arch/powerpc/kernel/vmlinux.lds.S                   |   33 -
 arch/powerpc/kvm/bookehv_interrupts.S               |    4 
 arch/powerpc/kvm/e500_emulate.c                     |    7 
 arch/powerpc/lib/code-patching.c                    |   29 
 arch/powerpc/lib/feature-fixups.c                   |  218 ++++++
 arch/powerpc/mm/mem.c                               |    2 
 arch/powerpc/mm/tlb_low_64e.S                       |    7 
 arch/powerpc/platforms/powernv/setup.c              |   99 ++-
 arch/powerpc/platforms/pseries/mobility.c           |    3 
 arch/powerpc/platforms/pseries/pseries.h            |    2 
 arch/powerpc/platforms/pseries/setup.c              |   88 ++
 arch/powerpc/xmon/xmon.c                            |    2 
 arch/x86/Kconfig                                    |    8 
 arch/x86/entry/common.c                             |    3 
 arch/x86/entry/vdso/Makefile                        |    3 
 arch/x86/include/asm/cpufeatures.h                  |   12 
 arch/x86/include/asm/intel-family.h                 |   30 
 arch/x86/include/asm/irqflags.h                     |    5 
 arch/x86/include/asm/microcode_intel.h              |   15 
 arch/x86/include/asm/msr-index.h                    |   30 
 arch/x86/include/asm/mwait.h                        |    7 
 arch/x86/include/asm/nospec-branch.h                |   66 ++
 arch/x86/include/asm/pgtable_64.h                   |   16 
 arch/x86/include/asm/processor.h                    |    7 
 arch/x86/include/asm/spec-ctrl.h                    |   20 
 arch/x86/include/asm/switch_to.h                    |    3 
 arch/x86/include/asm/thread_info.h                  |   20 
 arch/x86/include/asm/tlbflush.h                     |    8 
 arch/x86/include/uapi/asm/Kbuild                    |    1 
 arch/x86/include/uapi/asm/mce.h                     |    4 
 arch/x86/kernel/cpu/bugs.c                          |  643 ++++++++++++++++----
 arch/x86/kernel/cpu/common.c                        |  140 ++--
 arch/x86/kernel/cpu/intel.c                         |   11 
 arch/x86/kernel/cpu/mcheck/mce-severity.c           |    5 
 arch/x86/kernel/cpu/mcheck/mce.c                    |    4 
 arch/x86/kernel/cpu/microcode/amd.c                 |   22 
 arch/x86/kernel/cpu/microcode/intel.c               |   64 +
 arch/x86/kernel/cpu/perf_event_intel.c              |    2 
 arch/x86/kernel/nmi.c                               |    4 
 arch/x86/kernel/process.c                           |  101 ++-
 arch/x86/kernel/process.h                           |   39 +
 arch/x86/kernel/process_32.c                        |    9 
 arch/x86/kernel/process_64.c                        |    9 
 arch/x86/kernel/traps.c                             |    8 
 arch/x86/kvm/cpuid.c                                |   13 
 arch/x86/kvm/cpuid.h                                |    2 
 arch/x86/kvm/svm.c                                  |   10 
 arch/x86/kvm/trace.h                                |    4 
 arch/x86/kvm/x86.c                                  |    4 
 arch/x86/mm/kaiser.c                                |    4 
 arch/x86/mm/pgtable.c                               |    6 
 arch/x86/mm/tlb.c                                   |  114 ++-
 drivers/ata/libata-zpodd.c                          |   34 -
 drivers/base/cpu.c                                  |    8 
 drivers/block/loop.c                                |   42 -
 drivers/block/loop.h                                |    1 
 drivers/block/xsysace.c                             |    2 
 drivers/gpu/ipu-v3/ipu-dp.c                         |   12 
 drivers/hid/hid-debug.c                             |    5 
 drivers/hid/hid-input.c                             |    6 
 drivers/hwtracing/intel_th/gth.c                    |    2 
 drivers/iio/adc/xilinx-xadc-core.c                  |    2 
 drivers/input/keyboard/snvs_pwrkey.c                |    6 
 drivers/iommu/amd_iommu_init.c                      |    2 
 drivers/md/raid5.c                                  |   19 
 drivers/media/i2c/ov7670.c                          |   16 
 drivers/net/bonding/bond_options.c                  |    7 
 drivers/net/bonding/bond_sysfs_slave.c              |    4 
 drivers/net/ethernet/broadcom/bnxt/bnxt.c           |    9 
 drivers/net/ethernet/freescale/ucc_geth_ethtool.c   |    8 
 drivers/net/ethernet/hisilicon/hns/hnae.c           |    4 
 drivers/net/ethernet/hisilicon/hns/hns_enet.c       |    7 
 drivers/net/ethernet/ibm/ehea/ehea_main.c           |    1 
 drivers/net/ethernet/intel/igb/e1000_defines.h      |    2 
 drivers/net/ethernet/intel/igb/igb_main.c           |   57 -
 drivers/net/ethernet/micrel/ks8851.c                |   36 -
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_ethtool.c |    2 
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c   |    4 
 drivers/net/ethernet/ti/netcp_ethss.c               |    8 
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c   |    2 
 drivers/net/slip/slhc.c                             |    2 
 drivers/net/team/team.c                             |    6 
 drivers/net/usb/ipheth.c                            |   33 -
 drivers/net/wireless/cw1200/scan.c                  |    5 
 drivers/nvdimm/btt_devs.c                           |   18 
 drivers/platform/x86/sony-laptop.c                  |    8 
 drivers/rtc/rtc-da9063.c                            |    7 
 drivers/rtc/rtc-sh.c                                |    2 
 drivers/s390/block/dasd_eckd.c                      |    6 
 drivers/s390/char/con3270.c                         |    2 
 drivers/s390/char/fs3270.c                          |    3 
 drivers/s390/char/raw3270.c                         |    3 
 drivers/s390/char/raw3270.h                         |    4 
 drivers/s390/char/tty3270.c                         |    3 
 drivers/s390/net/ctcm_main.c                        |    1 
 drivers/s390/scsi/zfcp_fc.c                         |   21 
 drivers/scsi/csiostor/csio_scsi.c                   |    5 
 drivers/scsi/libsas/sas_expander.c                  |    9 
 drivers/scsi/qla2xxx/qla_attr.c                     |    4 
 drivers/scsi/qla4xxx/ql4_os.c                       |    2 
 drivers/scsi/storvsc_drv.c                          |   13 
 drivers/staging/iio/addac/adt7316.c                 |   22 
 drivers/tty/serial/sc16is7xx.c                      |   12 
 drivers/usb/core/driver.c                           |   36 -
 drivers/usb/core/hub.c                              |   16 
 drivers/usb/core/message.c                          |    7 
 drivers/usb/core/sysfs.c                            |    5 
 drivers/usb/core/usb.h                              |   10 
 drivers/usb/dwc3/core.c                             |    2 
 drivers/usb/gadget/udc/net2272.c                    |    1 
 drivers/usb/gadget/udc/net2280.c                    |    8 
 drivers/usb/host/u132-hcd.c                         |    3 
 drivers/usb/misc/yurex.c                            |    1 
 drivers/usb/serial/generic.c                        |   57 +
 drivers/usb/storage/realtek_cr.c                    |   13 
 drivers/usb/storage/uas.c                           |   38 -
 drivers/usb/usbip/stub_rx.c                         |   18 
 drivers/usb/usbip/usbip_common.h                    |    7 
 drivers/vfio/pci/vfio_pci.c                         |    4 
 drivers/vfio/vfio_iommu_type1.c                     |   14 
 drivers/virt/fsl_hypervisor.c                       |   29 
 drivers/w1/masters/ds2490.c                         |    6 
 fs/ceph/dir.c                                       |    6 
 fs/ceph/inode.c                                     |    2 
 fs/ceph/mds_client.c                                |    9 
 fs/ceph/snap.c                                      |    7 
 fs/cifs/inode.c                                     |    4 
 fs/debugfs/inode.c                                  |   13 
 fs/hugetlbfs/inode.c                                |   20 
 fs/jffs2/readinode.c                                |    5 
 fs/jffs2/super.c                                    |    5 
 fs/nfs/super.c                                      |    3 
 fs/nfsd/nfs4callback.c                              |    8 
 fs/nfsd/state.h                                     |    1 
 fs/proc/proc_sysctl.c                               |    6 
 include/linux/bitops.h                              |   21 
 include/linux/bits.h                                |   26 
 include/linux/cpu.h                                 |   19 
 include/linux/jump_label.h                          |    6 
 include/linux/ptrace.h                              |   21 
 include/linux/sched.h                               |    9 
 include/linux/sched/smt.h                           |   20 
 include/linux/usb.h                                 |    2 
 include/net/addrconf.h                              |    1 
 include/net/bluetooth/hci_core.h                    |    3 
 include/uapi/linux/prctl.h                          |    1 
 init/main.c                                         |    4 
 kernel/cpu.c                                        |   23 
 kernel/irq/manage.c                                 |    4 
 kernel/ptrace.c                                     |   10 
 kernel/sched/core.c                                 |   24 
 kernel/sched/fair.c                                 |    4 
 kernel/sched/sched.h                                |    1 
 kernel/time/timer_stats.c                           |    2 
 kernel/trace/ring_buffer.c                          |    2 
 net/8021q/vlan_dev.c                                |    4 
 net/bluetooth/hci_conn.c                            |    8 
 net/bluetooth/hidp/sock.c                           |    1 
 net/bridge/br_if.c                                  |   13 
 net/bridge/br_netfilter_hooks.c                     |    1 
 net/bridge/br_netfilter_ipv6.c                      |    2 
 net/bridge/netfilter/ebtables.c                     |    3 
 net/core/filter.c                                   |   23 
 net/ipv4/ip_output.c                                |    1 
 net/ipv4/raw.c                                      |    4 
 net/ipv4/route.c                                    |   32 
 net/ipv4/sysctl_net_ipv4.c                          |    5 
 net/ipv6/ip6_flowlabel.c                            |   22 
 net/ipv6/ipv6_sockglue.c                            |    3 
 net/ipv6/mcast.c                                    |   17 
 net/ipv6/sit.c                                      |    2 
 net/netfilter/ipvs/ip_vs_core.c                     |    2 
 net/netfilter/x_tables.c                            |    2 
 net/packet/af_packet.c                              |   48 +
 net/sunrpc/cache.c                                  |    3 
 net/tipc/netlink_compat.c                           |   24 
 scripts/Kbuild.include                              |    4 
 scripts/kconfig/lxdialog/inputbox.c                 |    3 
 scripts/kconfig/nconf.c                             |    2 
 scripts/kconfig/nconf.gui.c                         |    3 
 security/selinux/hooks.c                            |   40 -
 sound/soc/codecs/cs4270.c                           |    1 
 sound/soc/codecs/tlv320aic32x4.c                    |    2 
 sound/soc/intel/common/sst-dsp.c                    |    8 
 sound/soc/soc-pcm.c                                 |    7 
 sound/usb/line6/driver.c                            |   60 +
 sound/usb/line6/toneport.c                          |   24 
 tools/lib/traceevent/event-parse.c                  |    2 
 tools/power/x86/turbostat/Makefile                  |    2 
 tools/testing/selftests/net/run_netsocktests        |    2 
 231 files changed, 4170 insertions(+), 977 deletions(-)

Aditya Pakki (2):
      qlcnic: Avoid potential NULL pointer dereference
      libnvdimm/btt: Fix a kmemdup failure check

Al Viro (3):
      ceph: fix use-after-free on symlink traversal
      jffs2: fix use-after-free on symlink traversal
      debugfs: fix use-after-free on symlink traversal

Alan Stern (4):
      USB: yurex: Fix protection fault after device removal
      USB: w1 ds2490: Fix bug caused by improper use of altsetting array
      USB: core: Fix unterminated string returned by usb_string()
      USB: core: Fix bug caused by duplicate interface PM usage counter

Alex Williamson (1):
      vfio/type1: Limit DMA mappings per container

Alexander Kappner (1):
      usbnet: ipheth: prevent TX queue timeouts when device not ready

Alexander Shishkin (1):
      intel_th: gth: Fix an off-by-one in output unassigning

Alexandre Belloni (1):
      rtc: da9063: set uie_unsupported when relevant

Alistair Strachan (1):
      x86/vdso: Pass --eh-frame-hdr to the linker

Andi Kleen (3):
      x86/speculation/mds: Add basic bug infrastructure for MDS
      x86/kvm: Expose X86_FEATURE_MD_CLEAR to guests
      x86/cpu/bugs: Use __initconst for 'const' init data

Andrew Vasquez (1):
      scsi: qla2xxx: Fix incorrect region-size setting in optrom SYSFS routines

Annaliese McDermond (1):
      ASoC: tlv320aic32x4: Fix Common Pins

Anson Huang (1):
      Input: snvs_pwrkey - initialize necessary driver data before enabling IRQ

Arnd Bergmann (3):
      ARM: orion: don't use using 64-bit DMA masks
      ARM: iop: don't use using 64-bit DMA masks
      s390: ctcm: fix ctcm_new_device error return code

Arvind Sankar (1):
      igb: Fix WARN_ONCE on runtime suspend

Ashok Raj (1):
      x86/microcode/intel: Check microcode revision before updating sibling threads

Aurelien Jarno (1):
      MIPS: scall64-o32: Fix indirect syscall number load

Ben Hutchings (5):
      timer/debug: Change /proc/timer_stats from 0644 to 0600
      x86/cpufeatures: Hide AMD-specific speculation flags
      sched: Add sched_smt_active()
      x86/speculation/l1tf: Document l1tf in sysfs
      x86/bugs: Change L1TF mitigation string to match upstream

Boris Ostrovsky (1):
      x86/speculation/mds: Fix comment

Borislav Petkov (1):
      x86/microcode/intel: Add a helper which gives the microcode revision

Breno Leitao (1):
      powerpc/64s: Include cpu header

Changbin Du (1):
      kconfig/[mn]conf: handle backspace (^H) key

Christophe Leroy (3):
      powerpc/fsl: Fix the flush of branch predictor.
      net: ucc_geth - fix Oops when changing number of buffers in the ring
      powerpc/lib: fix book3s/32 boot failure due to code patching

Dan Carpenter (2):
      drivers/virt/fsl_hypervisor.c: dereferencing error pointers in ioctl
      drivers/virt/fsl_hypervisor.c: prevent integer overflow in ioctl

Dan Williams (1):
      init: initialize jump labels before command line option parsing

Daniel Borkmann (1):
      bpf: reject wrong sized filters earlier

Daniel Mack (1):
      ASoC: cs4270: Set auto-increment bit for register writes

David Ahern (1):
      ipv4: Fix raw socket lookup for local traffic

Diana Craciun (18):
      powerpc/64: Disable the speculation barrier from the command line
      powerpc/64: Make stf barrier PPC_BOOK3S_64 specific.
      powerpc/64: Make meltdown reporting Book3S 64 specific
      powerpc/fsl: Add barrier_nospec implementation for NXP PowerPC Book3E
      powerpc/fsl: Add infrastructure to fixup branch predictor flush
      powerpc/fsl: Add macro to flush the branch predictor
      powerpc/fsl: Fix spectre_v2 mitigations reporting
      powerpc/fsl: Add nospectre_v2 command line argument
      powerpc/fsl: Flush the branch predictor at each kernel entry (64bit)
      powerpc/fsl: Update Spectre v2 reporting
      powerpc/fsl: Enable runtime patching if nospectre_v2 boot arg is used
      powerpc/fsl: Flush branch predictor when entering KVM
      powerpc/fsl: Emulate SPRN_BUCSR register
      powerpc/fsl: Flush the branch predictor at each kernel entry (32 bit)
      powerpc/fsl: Sanitize the syscall table for NXP PowerPC 32 bit platforms
      powerpc/fsl: Fixed warning: orphan section `__btb_flush_fixup'
      powerpc/fsl: Add FSL_PPC_BOOK3E as supported arch for nospectre_v2 boot arg
      Documentation: Add nospectre_v1 parameter

Dmitry Torokhov (2):
      HID: input: add mapping for Expose/Overview key
      HID: input: add mapping for keyboard Brightness Up/Down/Toggle keys

Dominik Brodowski (1):
      x86/speculation: Simplify the CPU bug detection logic

Eduardo Habkost (1):
      kvm: x86: Report STIBP on GET_SUPPORTED_CPUID

Eric Dumazet (2):
      ipv4: add sanity checks in ipv4_link_failure()
      ipv6/flowlabel: wait rcu grace period before put_pid()

Filippo Sironi (1):
      x86/microcode: Update the new microcode revision unconditionally

Florian Westphal (1):
      netfilter: ebtables: CONFIG_COMPAT: drop a bogus WARN_ON

Francesco Ruggeri (1):
      netfilter: compat: initialize all fields in xt_init

Frank Sorenson (1):
      cifs: do not attempt cifs operation on smb2+ rename error

Geert Uytterhoeven (1):
      rtc: sh: Fix invalid alarm warning for non-enabled alarm

Greg Kroah-Hartman (3):
      Revert "block/loop: Use global lock for ioctl() operation."
      ALSA: line6: use dynamic buffers
      Linux 4.4.180

Guenter Roeck (1):
      xsysace: Fix error handling in ace_setup

Guido Kiener (3):
      usb: gadget: net2280: Fix overrun of OUT messages
      usb: gadget: net2280: Fix net2280_dequeue()
      usb: gadget: net2272: Fix net2272_dequeue()

Gustavo A. R. Silva (2):
      usbnet: ipheth: fix potential null pointer dereference in ipheth_carrier_set
      platform/x86: sony-laptop: Fix unintentional fall-through

Hangbin Liu (2):
      team: fix possible recursive locking when add slaves
      vlan: disable SIOCSHWTSTAMP in container

He, Bo (1):
      HID: debug: fix race condition with between rdesc_show() and device removal

Jacopo Mondi (1):
      media: v4l2: i2c: ov7670: Fix PLL bypass register values

Jarod Wilson (1):
      bonding: fix arp_validate toggling in active-backup mode

Jason Yan (1):
      scsi: libsas: fix a race condition when smp task timeout

Jeff Layton (1):
      ceph: ensure d_name stability in ceph_dentry_hash()

Jeremy Fertic (3):
      staging: iio: adt7316: allow adt751x to use internal vref for all dacs
      staging: iio: adt7316: fix the dac read calculation
      staging: iio: adt7316: fix the dac write calculation

Jiang Biao (1):
      x86/speculation: Remove SPECTRE_V2_IBRS in enum spectre_v2_mitigation

Jiri Kosina (3):
      x86/speculation: Apply IBPB more strictly to avoid cross-process data leak
      x86/speculation: Enable cross-hyperthread spectre v2 STIBP mitigation
      x86/speculation: Propagate information about RSB filling mitigation to sysfs

Joerg Roedel (1):
      iommu/amd: Set exclusion range correctly

Johan Hovold (1):
      USB: serial: fix unthrottle races

Josh Poimboeuf (6):
      x86/speculation: Move arch_smt_update() call to after mitigation decisions
      x86/speculation/mds: Add SMT warning message
      cpu/speculation: Add 'mitigations=' cmdline option
      x86/speculation: Support 'mitigations=' cmdline option
      x86/speculation/mds: Add 'mitigations=' support for MDS
      x86/speculation/mds: Fix documentation typo

Julian Anastasov (1):
      ipvs: do not schedule icmp errors from tunnels

Kai-Heng Feng (2):
      USB: Add new USB LPM helpers
      USB: Consolidate LPM checks to avoid enabling LPM twice

Kangjie Lu (1):
      scsi: qla4xxx: fix a potential NULL pointer dereference

Konrad Rzeszutek Wilk (4):
      x86/bugs: Add AMD's variant of SSB_NO
      x86/bugs: Add AMD's SPEC_CTRL MSR usage
      x86/bugs: Switch the selection of mitigation from CPU vendor to CPU features
      x86/speculation/mds: Print SMT vulnerable on MSBDS with mitigations off

Konstantin Khorenko (1):
      bonding: show full hw address in sysfs for slave entries

Laurentiu Tudor (1):
      powerpc/booke64: set RI in default MSR

Linus Torvalds (1):
      slip: make slhc_free() silently accept an error pointer

Louis Taylor (1):
      vfio/pci: use correct format characters

Lucas Stach (1):
      gpu: ipu-v3: dp: fix CSC handling

Lukas Wunner (4):
      net: ks8851: Dequeue RX packets explicitly
      net: ks8851: Reassert reset pin if chip ID check fails
      net: ks8851: Delay requesting IRQ until opened
      net: ks8851: Set initial carrier state to down

Malte Leip (1):
      usb: usbip: fix isoc packet num validation in get_pipe

Mao Wenan (1):
      sc16is7xx: missing unregister/delete driver on error in sc16is7xx_init()

Marcel Holtmann (1):
      Bluetooth: Align minimum encryption key size for LE and BR/EDR connections

Marco Felsch (1):
      ARM: dts: pfla02: increase phy reset duration

Martin Schwidefsky (1):
      s390/3270: fix lockdep false positive on view->lock

Masahiro Yamada (1):
      kbuild: simplify ld-option implementation

Matthias Kaehlcke (1):
      bitops: avoid integer overflow in GENMASK(_ULL)

Mauricio Faria de Oliveira (4):
      powerpc/rfi-flush: Differentiate enabled and patched flush types
      powerpc/pseries: Fix clearing of security feature flags
      powerpc: Move default security feature flags
      powerpc/pseries: Restore default security feature flags on setup

Michael Chan (1):
      bnxt_en: Improve multicast address setup logic.

Michael Ellerman (29):
      powerpc/xmon: Add RFI flush related fields to paca dump
      powerpc/pseries: Support firmware disable of RFI flush
      powerpc/powernv: Support firmware disable of RFI flush
      powerpc/rfi-flush: Move the logic to avoid a redo into the debugfs code
      powerpc/rfi-flush: Make it possible to call setup_rfi_flush() again
      powerpc/rfi-flush: Always enable fallback flush on pseries
      powerpc/pseries: Add new H_GET_CPU_CHARACTERISTICS flags
      powerpc/rfi-flush: Call setup_rfi_flush() after LPM migration
      powerpc: Add security feature flags for Spectre/Meltdown
      powerpc/pseries: Set or clear security feature flags
      powerpc/powernv: Set or clear security feature flags
      powerpc/64s: Move cpu_show_meltdown()
      powerpc/64s: Enhance the information in cpu_show_meltdown()
      powerpc/powernv: Use the security flags in pnv_setup_rfi_flush()
      powerpc/pseries: Use the security flags in pseries_setup_rfi_flush()
      powerpc/64s: Wire up cpu_show_spectre_v1()
      powerpc/64s: Wire up cpu_show_spectre_v2()
      powerpc/64s: Fix section mismatch warnings from setup_rfi_flush()
      powerpc/64: Use barrier_nospec in syscall entry
      powerpc: Use barrier_nospec in copy_from_user()
      powerpc64s: Show ori31 availability in spectre_v1 sysfs file not v2
      powerpc/64: Add CONFIG_PPC_BARRIER_NOSPEC
      powerpc/64: Call setup_barrier_nospec() from setup_arch()
      powerpc/asm: Add a patch_site macro & helpers for patching instructions
      powerpc/64s: Add new security feature flags for count cache flush
      powerpc/64s: Add support for software count cache flush
      powerpc/pseries: Query hypervisor for count cache flush settings
      powerpc/powernv: Query firmware for count cache flush settings
      powerpc/security: Fix spectre_v2 reporting

Michael Kelley (1):
      scsi: storvsc: Fix calculation of sub-channel count

Michael Neuling (1):
      powerpc: Avoid code patching freed init sections

Michal Suchanek (5):
      powerpc/64s: Add barrier_nospec
      powerpc/64s: Add support for ori barrier_nospec patching
      powerpc/64s: Patch barrier_nospec in modules
      powerpc/64s: Enable barrier_nospec based on firmware settings
      powerpc/64s: Enhance the information in cpu_show_spectre_v1()

Mike Kravetz (1):
      hugetlbfs: fix memory leak for resv_map

Mukesh Ojha (1):
      usb: u132-hcd: fix resource leak

Nadav Amit (1):
      x86/mm: Use WRITE_ONCE() when setting PTEs

NeilBrown (1):
      sunrpc: don't mark uninitialised items as VALID.

Nicholas Piggin (2):
      powerpc/64s: Improve RFI L1-D cache flush fallback
      powerpc/64s: Add support for a store forwarding barrier at kernel entry/exit

Nicolas Dichtel (1):
      x86: stop exporting msr-index.h to userland

Nigel Croxon (1):
      Don't jump to compute_result state from check_result state

Oliver Neukum (2):
      UAS: fix alignment of scatter/gather segments
      USB: serial: use variable for status

Ondrej Mosnacek (1):
      selinux: never allow relabeling on context mounts

Paolo Bonzini (1):
      KVM: fail KVM_SET_VCPU_EVENTS with invalid exception number

Peter Oberparleiter (1):
      s390/dasd: Fix capacity calculation for large volumes

Peter Zijlstra (2):
      trace: Fix preempt_enable_no_resched() abuse
      x86/cpu: Sanitize FAM6_ATOM naming

Po-Hsu Lin (1):
      selftests/net: correct the return value for run_netsocktests

Prarit Bhargava (1):
      x86/microcode: Make sure boot_cpu_data.microcode is up-to-date

Prasad Sodagudi (1):
      genirq: Prevent use-after-free and work list corruption

Rander Wang (1):
      ASoC:soc-pcm:fix a codec fixup issue in TDM case

Rikard Falkeborn (1):
      tools lib traceevent: Fix missing equality check for strcmp

Ross Zwisler (1):
      ASoC: Intel: avoid Oops if DMA setup fails

Sai Praneeth (1):
      x86/speculation: Support Enhanced IBRS on future CPUs

Shmulik Ladkani (1):
      ipv4: ip_do_fragment: Preserve skb_iif during fragmentation

Steffen Maier (1):
      scsi: zfcp: reduce flood of fcrscn1 trace records on multi-element RSCN

Stephane Eranian (1):
      perf/x86/intel: Fix handling of wakeup_events for multi-entry PEBS

Stephen Suryaputra (1):
      vrf: sit mtu should not be updated when vrf netdev is the link

Sven Van Asbroeck (1):
      iio: adc: xilinx: fix potential use-after-free on remove

Tetsuo Handa (1):
      NFS: Forbid setting AF_INET6 to "struct sockaddr_in"->sin_family.

Thinh Nguyen (1):
      usb: dwc3: Fix default lpm_nyet_threshold value

Thomas Gleixner (30):
      KVM: x86: SVM: Call x86_spec_ctrl_set_guest/host() with interrupts disabled
      x86/speculation: Rename SSBD update functions
      x86/Kconfig: Select SCHED_SMT if SMP enabled
      x86/speculation: Rework SMT state change
      x86/speculation: Reorder the spec_v2 code
      x86/speculation: Mark string arrays const correctly
      x86/speculataion: Mark command line parser data __initdata
      x86/speculation: Unify conditional spectre v2 print functions
      x86/speculation: Add command line control for indirect branch speculation
      x86/process: Consolidate and simplify switch_to_xtra() code
      x86/speculation: Avoid __switch_to_xtra() calls
      x86/speculation: Prepare for conditional IBPB in switch_mm()
      x86/speculation: Split out TIF update
      x86/speculation: Prepare arch_smt_update() for PRCTL mode
      x86/speculation: Prevent stale SPEC_CTRL msr content
      x86/speculation: Add prctl() control for indirect branch speculation
      x86/speculation: Enable prctl mode for spectre_v2_user
      x86/speculation: Add seccomp Spectre v2 user space protection mode
      x86/speculation: Provide IBPB always command line options
      x86/msr-index: Cleanup bit defines
      x86/speculation: Consolidate CPU whitelists
      x86/speculation/mds: Add BUG_MSBDS_ONLY
      x86/speculation/mds: Add mds_clear_cpu_buffers()
      x86/speculation/mds: Clear CPU buffers on exit to user
      x86/speculation/mds: Conditionally clear CPU buffers on idle entry
      x86/speculation/mds: Add mitigation control for MDS
      x86/speculation/mds: Add sysfs reporting for MDS
      x86/speculation/mds: Add mitigation mode VMWERV
      Documentation: Move L1TF to separate directory
      Documentation: Add MDS vulnerability documentation

Tim Chen (7):
      x86/speculation: Update the TIF_SSBD comment
      x86/speculation: Clean up spectre_v2_parse_cmdline()
      x86/speculation: Remove unnecessary ret variable in cpu_show_common()
      x86/speculation: Move STIPB/IBPB string conditionals out of cpu_show_common()
      x86/speculation: Disable STIBP when enhanced IBRS is in use
      x86/speculation: Reorganize speculation control MSRs update
      x86/speculation: Prepare for per task indirect branch speculation control

Tobin C. Harding (1):
      bridge: Fix error path for kobject_init_and_add()

Tom Lendacky (1):
      x86/bugs: Fix the AMD SSBD usage of the SPEC_CTRL MSR

Tony Luck (3):
      x86/mce: Improve error message when kernel cannot recover, p2
      locking/static_keys: Provide DECLARE and well as DEFINE macros
      x86/MCE: Save microcode revision in machine check records

Trond Myklebust (1):
      nfsd: Don't release the callback slot unless it was actually held

Tyler Hicks (1):
      Documentation: Correct the possible MDS sysfs values

Varun Prakash (1):
      scsi: csiostor: fix missing data copy in csio_scsi_err_handler()

Vinod Koul (1):
      net: stmmac: move stmmac_check_ether_addr() to driver probe

Vitaly Kuznetsov (1):
      KVM: x86: avoid misreporting level-triggered irqs as edge-triggered in tracing

WANG Cong (1):
      ipv6: fix a potential deadlock in do_ipv6_setsockopt()

Wei Yongjun (1):
      cw1200: fix missing unlock on error in cw1200_hw_scan()

Wen Yang (3):
      net: xilinx: fix possible object reference leak
      net: ibm: fix possible object reference leak
      net: ethernet: ti: fix possible object reference leak

Will Deacon (1):
      locking/atomics, asm-generic: Move some macros from <linux/bitops.h> to a new <linux/bits.h> file

Willem de Bruijn (2):
      ipv6: invert flowlabel sharing check in process and user mode
      packet: validate msg_namelen in send directly

Xie XiuQi (1):
      sched/numa: Fix a possible divide-by-zero

Xin Long (4):
      tipc: handle the err returned from cmd header function
      tipc: check bearer name with right length in tipc_nl_compat_bearer_enable
      tipc: check link name with right length in tipc_nl_compat_link_set
      netfilter: bridge: set skb transport_header before entering NF_INET_PRE_ROUTING

Yan, Zheng (1):
      ceph: fix ci->i_head_snapc leak

Yonglong Liu (2):
      net: hns: Use NAPI_POLL_WEIGHT for hns driver
      net: hns: Fix WARNING when remove HNS driver with SMMU enabled

Young Xiao (1):
      Bluetooth: hidp: fix buffer overflow

YueHaibing (2):
      fs/proc/proc_sysctl.c: Fix a NULL pointer dereference
      packet: Fix error path in packet_init

ZhangXiaoxu (1):
      ipv4: set the tcp_min_rtt_wlen range from 0 to one day

raymond pang (1):
      libata: fix using DMA buffers on stack

speck for Pawan Gupta (1):
      x86/mds: Add MDSUM variant to the MDS documentation

