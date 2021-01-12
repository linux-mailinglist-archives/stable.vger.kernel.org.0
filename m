Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51BB12F3B11
	for <lists+stable@lfdr.de>; Tue, 12 Jan 2021 20:51:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406948AbhALTsF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jan 2021 14:48:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:57278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406756AbhALTsF (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Jan 2021 14:48:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 780312311C;
        Tue, 12 Jan 2021 19:47:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610480843;
        bh=pJwc4Vkk8HaLG59go+x+bdwSny4LXb+OW93VjQ0YTvw=;
        h=From:To:Cc:Subject:Date:From;
        b=L1T4ZRMYPVnEFvPS+doQYmR5A5zFyHXApDcJ4GwUHZ3TzhmFNbmr2h40jVwagOOJM
         nD/KCUerp7XGXrXJQaisXnXEOI22QuAqIFgQLHp8R6DWsPgKmVo5QxQ9lsBD70w9cJ
         6Z/BHwrxIz77givrCAxDT6m/h8mTspRi4cgBA6Hg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.10.7
Date:   Tue, 12 Jan 2021 20:48:28 +0100
Message-Id: <161048090814939@kroah.com>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.10.7 kernel.

All users of the 5.10 kernel series must upgrade.

The updated 5.10.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.10.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                                    |    4 
 arch/alpha/include/asm/local64.h                            |    1 
 arch/arc/include/asm/Kbuild                                 |    1 
 arch/arm/boot/dts/omap3-n950-n9.dtsi                        |    8 
 arch/arm/include/asm/Kbuild                                 |    1 
 arch/arm64/Makefile                                         |   10 -
 arch/arm64/include/asm/Kbuild                               |    1 
 arch/csky/include/asm/Kbuild                                |    1 
 arch/h8300/include/asm/Kbuild                               |    1 
 arch/hexagon/include/asm/Kbuild                             |    1 
 arch/ia64/include/asm/local64.h                             |    1 
 arch/m68k/include/asm/Kbuild                                |    1 
 arch/microblaze/include/asm/Kbuild                          |    1 
 arch/mips/include/asm/Kbuild                                |    1 
 arch/nds32/include/asm/Kbuild                               |    1 
 arch/parisc/include/asm/Kbuild                              |    1 
 arch/powerpc/include/asm/Kbuild                             |    1 
 arch/powerpc/kernel/vmlinux.lds.S                           |    2 
 arch/riscv/include/asm/Kbuild                               |    1 
 arch/s390/include/asm/Kbuild                                |    1 
 arch/sh/include/asm/Kbuild                                  |    1 
 arch/sparc/include/asm/Kbuild                               |    1 
 arch/x86/include/asm/local64.h                              |    1 
 arch/x86/kernel/cpu/mtrr/generic.c                          |    6 
 arch/x86/kernel/cpu/resctrl/rdtgroup.c                      |  117 ++++-------
 arch/x86/kvm/mmu.h                                          |    2 
 arch/x86/kvm/mmu/mmu.c                                      |   22 +-
 arch/x86/kvm/mmu/tdp_mmu.c                                  |  111 +++++------
 arch/x86/kvm/mmu/tdp_mmu.h                                  |    4 
 arch/x86/mm/pgtable.c                                       |    2 
 arch/xtensa/include/asm/Kbuild                              |    1 
 block/blk-core.c                                            |   13 -
 block/blk-iocost.c                                          |   16 +
 block/blk-mq-debugfs.c                                      |    2 
 block/blk-mq.c                                              |    4 
 block/blk-pm.h                                              |   14 -
 crypto/asymmetric_keys/asym_tpm.c                           |    2 
 crypto/ecdh.c                                               |    3 
 drivers/atm/idt77252.c                                      |    2 
 drivers/base/core.c                                         |    2 
 drivers/bluetooth/hci_h5.c                                  |    8 
 drivers/dma-buf/dma-buf.c                                   |   21 +-
 drivers/dma/idxd/sysfs.c                                    |    4 
 drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c              |    4 
 drivers/gpu/drm/i915/i915_cmd_parser.c                      |   27 --
 drivers/hwmon/amd_energy.c                                  |    3 
 drivers/ide/ide-atapi.c                                     |    1 
 drivers/ide/ide-io.c                                        |    7 
 drivers/ide/ide-pm.c                                        |    2 
 drivers/iommu/intel/svm.c                                   |    9 
 drivers/md/bcache/features.c                                |    2 
 drivers/md/bcache/features.h                                |   30 ++-
 drivers/md/bcache/super.c                                   |   36 +++
 drivers/net/bareudp.c                                       |    3 
 drivers/net/dsa/lantiq_gswip.c                              |   27 --
 drivers/net/ethernet/broadcom/bcmsysport.c                  |    1 
 drivers/net/ethernet/broadcom/bnxt/bnxt.c                   |   38 +--
 drivers/net/ethernet/broadcom/bnxt/bnxt.h                   |    7 
 drivers/net/ethernet/ethoc.c                                |    3 
 drivers/net/ethernet/freescale/ucc_geth.c                   |    3 
 drivers/net/ethernet/hisilicon/hns/hns_ethtool.c            |    4 
 drivers/net/ethernet/ibm/ibmvnic.c                          |   10 -
 drivers/net/ethernet/intel/e1000e/e1000.h                   |    1 
 drivers/net/ethernet/intel/e1000e/ethtool.c                 |   46 ++++
 drivers/net/ethernet/intel/e1000e/ich8lan.c                 |   17 +
 drivers/net/ethernet/intel/e1000e/netdev.c                  |   59 +----
 drivers/net/ethernet/intel/i40e/i40e.h                      |    3 
 drivers/net/ethernet/intel/i40e/i40e_main.c                 |   10 +
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c          |    4 
 drivers/net/ethernet/intel/iavf/iavf_main.c                 |    4 
 drivers/net/ethernet/marvell/mvneta.c                       |    2 
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c             |   13 -
 drivers/net/ethernet/marvell/mvpp2/mvpp2_prs.c              |   38 +++
 drivers/net/ethernet/marvell/mvpp2/mvpp2_prs.h              |    2 
 drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h           |    9 
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h |    8 
 drivers/net/ethernet/mellanox/mlx5/core/en_tx.c             |    9 
 drivers/net/ethernet/pensando/ionic/ionic_txrx.c            |    2 
 drivers/net/ethernet/qlogic/qede/qede_fp.c                  |    5 
 drivers/net/ethernet/realtek/r8169_main.c                   |    6 
 drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c           |    4 
 drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c         |    2 
 drivers/net/ethernet/ti/cpts.c                              |    2 
 drivers/net/tun.c                                           |    2 
 drivers/net/usb/cdc_ncm.c                                   |    3 
 drivers/net/usb/qmi_wwan.c                                  |    1 
 drivers/net/virtio_net.c                                    |   12 -
 drivers/net/wan/hdlc_ppp.c                                  |    7 
 drivers/net/wireless/realtek/rtlwifi/core.c                 |    8 
 drivers/scsi/scsi_lib.c                                     |   27 +-
 drivers/scsi/scsi_transport_spi.c                           |   27 +-
 drivers/scsi/ufs/ufshcd-pci.c                               |   73 +++++++
 drivers/scsi/ufs/ufshcd.c                                   |   72 ++++++-
 drivers/scsi/ufs/ufshcd.h                                   |    1 
 drivers/staging/comedi/comedi_fops.c                        |    4 
 drivers/staging/mt7621-dma/mtk-hsdma.c                      |    4 
 drivers/target/target_core_xcopy.c                          |  119 +++++++-----
 drivers/target/target_core_xcopy.h                          |    1 
 drivers/usb/chipidea/ci_hdrc_imx.c                          |    6 
 drivers/usb/class/cdc-acm.c                                 |    4 
 drivers/usb/class/cdc-wdm.c                                 |   16 +
 drivers/usb/class/usblp.c                                   |   21 +-
 drivers/usb/dwc3/core.h                                     |    1 
 drivers/usb/dwc3/dwc3-meson-g12a.c                          |    2 
 drivers/usb/dwc3/gadget.c                                   |   16 -
 drivers/usb/dwc3/ulpi.c                                     |   38 ++-
 drivers/usb/gadget/Kconfig                                  |    2 
 drivers/usb/gadget/composite.c                              |   10 -
 drivers/usb/gadget/configfs.c                               |   19 +
 drivers/usb/gadget/function/f_printer.c                     |    1 
 drivers/usb/gadget/function/f_uac2.c                        |   69 +++++-
 drivers/usb/gadget/function/u_ether.c                       |    9 
 drivers/usb/gadget/legacy/acm_ms.c                          |    4 
 drivers/usb/gadget/udc/dummy_hcd.c                          |   35 ++-
 drivers/usb/host/xhci.c                                     |   24 +-
 drivers/usb/misc/yurex.c                                    |    3 
 drivers/usb/serial/iuu_phoenix.c                            |   20 +-
 drivers/usb/serial/keyspan_pda.c                            |    2 
 drivers/usb/serial/option.c                                 |    3 
 drivers/usb/storage/unusual_uas.h                           |    7 
 drivers/usb/typec/mux/intel_pmc_mux.c                       |   11 +
 drivers/usb/usbip/vhci_hcd.c                                |    2 
 drivers/vhost/net.c                                         |    6 
 fs/btrfs/qgroup.c                                           |   30 ++-
 fs/btrfs/send.c                                             |   49 +++-
 include/asm-generic/Kbuild                                  |    1 
 include/linux/blk-mq.h                                      |    4 
 include/linux/blkdev.h                                      |   18 +
 include/linux/intel-iommu.h                                 |    2 
 include/net/red.h                                           |    4 
 include/uapi/linux/bcache.h                                 |    2 
 kernel/workqueue.c                                          |   13 +
 lib/genalloc.c                                              |   25 +-
 mm/page-writeback.c                                         |    2 
 net/core/net-sysfs.c                                        |   65 +++++-
 net/ipv4/fib_frontend.c                                     |    2 
 net/ipv4/gre_demux.c                                        |    2 
 net/ipv4/netfilter/arp_tables.c                             |    2 
 net/ipv4/netfilter/ip_tables.c                              |    2 
 net/ipv6/netfilter/ip6_tables.c                             |    2 
 net/ncsi/ncsi-rsp.c                                         |    2 
 net/netfilter/ipset/ip_set_hash_gen.h                       |   20 --
 net/netfilter/nft_dynset.c                                  |    6 
 net/netfilter/xt_RATEEST.c                                  |    3 
 net/sched/sch_choke.c                                       |    2 
 net/sched/sch_gred.c                                        |    2 
 net/sched/sch_red.c                                         |    2 
 net/sched/sch_sfq.c                                         |    2 
 net/sched/sch_taprio.c                                      |    7 
 net/xdp/xsk.c                                               |    4 
 net/xdp/xsk_buff_pool.c                                     |    2 
 scripts/depmod.sh                                           |    2 
 sound/pci/hda/hda_intel.c                                   |    2 
 sound/pci/hda/patch_conexant.c                              |    1 
 sound/pci/hda/patch_realtek.c                               |   10 +
 sound/pci/hda/patch_via.c                                   |   13 +
 sound/usb/midi.c                                            |    4 
 tools/testing/selftests/drivers/net/mlxsw/qos_pfc.sh        |    2 
 tools/testing/selftests/vm/Makefile                         |   10 -
 virt/kvm/kvm_main.c                                         |    3 
 160 files changed, 1211 insertions(+), 667 deletions(-)

Aaro Koskinen (1):
      ARM: dts: OMAP3: disable AES on N950/N9

Adrian Hunter (4):
      scsi: ufs-pci: Fix restore from S4 for Intel controllers
      scsi: ufs-pci: Ensure UFS device is in PowerDown mode for suspend-to-disk ->poweroff()
      scsi: ufs-pci: Fix recovery from hibernate exit errors for Intel controllers
      scsi: ufs-pci: Enable UFSHCD_CAP_RPM_AUTOSUSPEND for Intel controllers

Alan Stern (2):
      scsi: block: Do not accept any requests while suspended
      USB: Gadget: dummy-hcd: Fix shift-out-of-bounds bug

Andres Freund (1):
      block: add debugfs stanza for QUEUE_FLAG_NOWAIT

Antoine Tenart (4):
      net-sysfs: take the rtnl lock when storing xps_cpus
      net-sysfs: take the rtnl lock when accessing xps_cpus_map and num_tc
      net-sysfs: take the rtnl lock when storing xps_rxqs
      net-sysfs: take the rtnl lock when accessing xps_rxqs_map and num_tc

Ard Biesheuvel (1):
      crypto: ecdh - avoid buffer overflow in ecdh_set_secret()

Arnd Bergmann (1):
      usb: gadget: select CONFIG_CRC32

Bard Liao (1):
      Revert "device property: Keep secondary firmware node secondary by type"

Bart Van Assche (6):
      scsi: block: Introduce BLK_MQ_REQ_PM
      scsi: ide: Do not set the RQF_PREEMPT flag for sense requests
      scsi: ide: Mark power management requests with RQF_PM instead of RQF_PREEMPT
      scsi: scsi_transport_spi: Set RQF_PM for domain validation commands
      scsi: core: Only process PM requests if rpm_status != RPM_ACTIVE
      scsi: block: Remove RQF_PREEMPT and BLK_MQ_REQ_PREEMPT

Bean Huo (1):
      scsi: ufs: Fix wrong print message in dev_err()

Ben Gardon (1):
      KVM: x86/mmu: Ensure TDP MMU roots are freed after yield

Bjørn Mork (2):
      net: usb: qmi_wwan: add Quectel EM160R-GL
      USB: serial: option: add Quectel EM160R-GL

Chandana Kishori Chiluveru (1):
      usb: gadget: configfs: Preserve function ordering after bind failure

Charan Teja Reddy (1):
      dmabuf: fix use-after-free of dmabuf's file->f_inode

Christophe JAILLET (1):
      staging: mt7621-dma: Fix a resource leak in an error handling path

Coly Li (3):
      bcache: fix typo from SUUP to SUPP in features.h
      bcache: check unsupported feature sets for bcache register
      bcache: introduce BCH_FEATURE_INCOMPAT_LOG_LARGE_BUCKET_SIZE for large bucket

Cong Wang (1):
      erspan: fix version 1 check in gre_parse_header()

Dan Carpenter (3):
      atm: idt77252: call pci_disable_device() on error path
      Staging: comedi: Return -EFAULT if copy_to_user() fails
      dmaengine: idxd: off by one in cleanup code

Dan Williams (1):
      x86/mm: Fix leak of pmd ptlock

Daniel Palmer (1):
      USB: serial: option: add LongSung M5710 module support

David Arcari (1):
      hwmon: (amd_energy) fix allocation of hwmon_channel_info config

David Disseldorp (1):
      scsi: target: Fix XCOPY NAA identifier lookup

Davide Caratti (1):
      net/sched: sch_taprio: ensure to reset/destroy all child qdiscs

Dinghao Liu (2):
      net: ethernet: mvneta: Fix error handling in mvneta_probe
      net: ethernet: Fix memleak in ethoc_probe

Dominique Martinet (1):
      kbuild: don't hardcode depmod path

Eddie Hung (1):
      usb: gadget: configfs: Fix use-after-free issue with udc_name

Fenghua Yu (2):
      x86/resctrl: Use an IPI instead of task_work_add() to update PQR_ASSOC MSR
      x86/resctrl: Don't move a task to the same resource group

Filipe Manana (1):
      btrfs: send: fix wrong file path when there is an inode with a pending rmdir

Florian Fainelli (1):
      net: systemport: set dev->max_mtu to UMAC_MAX_MTU_SIZE

Florian Westphal (1):
      netfilter: xt_RATEEST: reject non-null terminated string from userspace

Greg Kroah-Hartman (2):
      crypto: asym_tpm: correct zero out potential secrets
      Linux 5.10.7

Grygorii Strashko (1):
      net: ethernet: ti: cpts: fix ethtool output when no ptp_clock registered

Guillaume Nault (1):
      ipv4: Ignore ECN bits for fib lookups in fib_compute_spec_dst()

Hans de Goede (1):
      Bluetooth: revert: hci_h5: close serdev device and free hu in h5_close

Harish (1):
      selftests/vm: fix building protection keys test

Heiner Kallweit (1):
      r8169: work around power-saving bug on some chip versions

Huang Shijie (1):
      lib/genalloc: fix the overflow when size is too big

Ido Schimmel (1):
      selftests: mlxsw: Set headroom size of correct port

Jaegeuk Kim (1):
      scsi: ufs: Clear UAC for FFU and RPMB LUNs

Jakub Kicinski (1):
      iavf: fix double-release of rtnl_lock

Jeff Dike (1):
      virtio_net: Fix recursive call to cpus_read_lock()

Jerome Brunet (1):
      usb: gadget: f_uac2: reset wMaxPacketSize

Johan Hovold (4):
      USB: serial: iuu_phoenix: fix DMA from stack
      USB: yurex: fix control-URB timeout handling
      USB: usblp: fix DMA to stack
      USB: serial: keyspan_pda: remove unused variable

John Wang (1):
      net/ncsi: Use real net-device for response handler

Kai-Heng Feng (1):
      ALSA: hda/realtek: Enable mute and micmute LED on HP EliteBook 850 G7

Kailang Yang (1):
      ALSA: hda/realtek - Fix speaker volume control on Lenovo C940

Lai Jiangshan (1):
      kvm: check tlbs_dirty directly

Lijun Pan (2):
      ibmvnic: fix login buffer memory leak
      ibmvnic: continue fatal error reset after passive init

Linus Torvalds (2):
      depmod: handle the case of /sbin/depmod without /sbin in PATH
      mm: make wait_on_page_writeback() wait for multiple pending writebacks

Liu Yi L (1):
      iommu/vt-d: Move intel_iommu info from struct intel_svm to struct intel_svm_dev

Madhusudanarao Amara (1):
      usb: typec: intel_pmc_mux: Configure HPD first for HPD+IRQ request

Magnus Karlsson (1):
      xsk: Fix memory leak for failed bind

Manish Chopra (1):
      qede: fix offload for IPIP tunnel packets

Manish Narani (1):
      usb: gadget: u_ether: Fix MTU size mismatch with RX packet size

Manuel Jiménez (1):
      ALSA: hda/realtek: Add mute LED quirk for more HP laptops

Mario Limonciello (4):
      e1000e: Only run S0ix flows if shutdown succeeded
      e1000e: bump up timeout to wait when ME un-configures ULP mode
      Revert "e1000e: disable s0ix entry and exit flows for ME systems"
      e1000e: Export S0ix flags to ethtool

Martin Blumenstingl (3):
      net: stmmac: dwmac-meson8b: ignore the second clock input
      net: dsa: lantiq_gswip: Enable GSWIP_MII_CFG_EN also for internal PHYs
      net: dsa: lantiq_gswip: Fix GSWIP_MII_CFG(p) register access

Matthew Auld (2):
      drm/i915: clear the shadow batch
      drm/i915: clear the gpu reloc batch

Michael Chan (1):
      bnxt_en: Check TQM rings for maximum supported value.

Michael Grzeschik (1):
      USB: xhci: fix U1/U2 handling for hardware with XHCI_INTEL_HOST quirk set

Moshe Shemesh (1):
      net/mlx5e: Fix SWP offsets when vlan inserted by driver

Nathan Chancellor (1):
      powerpc: Handle .text.{hot,unlikely}.* in linker script

Nick Desaulniers (1):
      arm64: link with -z norelro for LLD or aarch64-elf

Noor Azura Ahmad Tarmizi (1):
      stmmac: intel: Add PCI IDs for TGL-H platform

Pablo Neira Ayuso (1):
      netfilter: nft_dynset: report EOPNOTSUPP on missing set feature

Paolo Bonzini (1):
      KVM: x86: fix shift out of bounds reported by UBSAN

PeiSen Hou (1):
      ALSA: hda/realtek: Add two "Intel Reference board" SSID in the ALC256.

Ping-Ke Shih (1):
      rtlwifi: rise completion at the last step of firmware callback

Qu Wenruo (1):
      btrfs: qgroup: don't try to wait flushing if we're already holding a transaction

Randy Dunlap (3):
      net: sched: prevent invalid Scell_log shift count
      local64.h: make <asm/local64.h> mandatory
      usb: usbip: vhci_hcd: protect shift size

Rasmus Villemoes (2):
      ethernet: ucc_geth: fix use-after-free in ucc_geth_remove()
      ethernet: ucc_geth: set dev->max_mtu to 1518

Roland Dreier (1):
      CDC-NCM: remove "connected" log message

Sean Christopherson (2):
      KVM: x86/mmu: Use -1 to flag an undefined spte in get_mmio_spte()
      KVM: x86/mmu: Get root level from walkers when retrieving MMIO SPTE

Sean Young (1):
      USB: cdc-acm: blacklist another IR Droid device

Serge Semin (3):
      usb: dwc3: ulpi: Use VStsDone to detect PHY regs access completion
      usb: dwc3: ulpi: Replace CPU-based busyloop with Protocol-based one
      usb: dwc3: ulpi: Fix USB2.0 HS/FS/LS PHY suspend regression

Shannon Nelson (1):
      ionic: account for vlan tag len in rx buffer len

Sriharsha Allenki (1):
      usb: gadget: Fix spinlock lockup on usb_function_deactivate

Stefan Chulski (4):
      net: mvpp2: Add TCAM entry to drop flow control pause frames
      net: mvpp2: prs: fix PPPoE with ipv6 packet parse
      net: mvpp2: Fix GoP port 3 Networking Complex Control configurations
      net: mvpp2: fix pkt coalescing int-threshold configuration

Subash Abhinov Kasiviswanathan (1):
      netfilter: x_tables: Update remaining dereference to RCU

Sylwester Dziedziuch (1):
      i40e: Fix Error I40E_AQ_RC_EINVAL when removing VFs

Taehee Yoo (2):
      bareudp: set NETIF_F_LLTX flag
      bareudp: Fix use of incorrect min_headroom size

Takashi Iwai (2):
      ALSA: usb-audio: Fix UBSAN warnings for MIDI jacks
      ALSA: hda/via: Fix runtime PM for Clevo W35xSS

Tejun Heo (1):
      blk-iocost: fix NULL iocg deref from racing against initialization

Tetsuo Handa (1):
      USB: cdc-wdm: Fix use after free in service_outstanding_interrupt().

Thinh Nguyen (2):
      usb: dwc3: gadget: Clear wait flag on dequeue
      usb: uas: Add PNY USB Portable SSD to unusual_uas

Vasily Averin (1):
      netfilter: ipset: fix shift-out-of-bounds in htable_bits()

Vasundhara Volam (1):
      bnxt_en: Fix AER recovery.

Wesley Cheng (1):
      usb: dwc3: gadget: Restart DWC3 gadget when enabling pullup

Xie He (1):
      net: hdlc_ppp: Fix issues when mod_timer is called while timer is running

YANG LI (1):
      ibmvnic: fix: NULL pointer dereference.

Yang Yingliang (1):
      USB: gadget: legacy: fix return error code in acm_ms_bind()

Ying-Tsun Huang (1):
      x86/mtrr: Correct the range check before performing MTRR type lookups

Yu Kuai (1):
      usb: chipidea: ci_hdrc_imx: add missing put_device() call in usbmisc_get_init_data()

Yunfeng Ye (1):
      workqueue: Kick a worker based on the actual activation of delayed works

Yunjian Wang (3):
      tun: fix return value when the number of iovs exceeds MAX_SKB_FRAGS
      net: hns: fix return value check in __lb_other_process()
      vhost_net: fix ubuf refcount incorrectly when sendmsg fails

Zheng Zengkai (1):
      usb: dwc3: meson-g12a: disable clk on error handling path in probe

Zqiang (1):
      usb: gadget: function: printer: Fix a memory leak for interface descriptor

bo liu (1):
      ALSA: hda/conexant: add a new hda codec CX11970

taehyun.cho (1):
      usb: gadget: enable super speed plus

