Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13DC915FBAB
	for <lists+stable@lfdr.de>; Sat, 15 Feb 2020 01:47:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727959AbgBOAoX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 19:44:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:50004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727763AbgBOAoW (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 19:44:22 -0500
Received: from localhost (unknown [38.98.37.142])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E7F78207FF;
        Sat, 15 Feb 2020 00:44:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581727461;
        bh=pYKdrTXJpI+E+gDFwb11hXMxYFMpgnK54W1kXUsMno8=;
        h=Date:From:To:Cc:Subject:From;
        b=OP/+1gzTJ0LUCVvU/MOi28gKkaVgNcXoQBeqnUwgSi6vPg8yycu99ay/8YGjGYPFa
         zVTKiRkkQSNq2tu2GHf+jXX+/5c1iWSZCHCxejjgx1zVGBl6d98J9imgWwc9v1rOox
         sWfcytCl517qtxL+eGL3M/Na7uHeOB+4FtuPD10s=
Date:   Fri, 14 Feb 2020 19:41:09 -0500
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.14.171
Message-ID: <20200215004109.GA28527@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="azLHFNyN32YCQGCU"
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--azLHFNyN32YCQGCU
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 4.14.171 kernel.

All users of the 4.14 kernel series must upgrade.

The updated 4.14.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-4.14.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Ds=
ummary

thanks,

greg k-h

------------

 Makefile                                               |    2=20
 arch/arc/boot/dts/axs10x_mb.dtsi                       |    1=20
 arch/arm/boot/dts/sama5d3.dtsi                         |   28=20
 arch/arm/boot/dts/sama5d3_can.dtsi                     |    4=20
 arch/arm/boot/dts/sama5d3_tcb1.dtsi                    |    1=20
 arch/arm/boot/dts/sama5d3_uart.dtsi                    |    4=20
 arch/arm/include/asm/kvm_emulate.h                     |    5=20
 arch/arm/include/asm/kvm_mmio.h                        |    2=20
 arch/arm/mach-tegra/sleep-tegra30.S                    |   11=20
 arch/arm/mm/init.c                                     |    2=20
 arch/arm64/include/asm/kvm_emulate.h                   |    5=20
 arch/arm64/include/asm/kvm_mmio.h                      |    6=20
 arch/arm64/kernel/cpufeature.c                         |    2=20
 arch/mips/Makefile.postlink                            |    2=20
 arch/powerpc/Kconfig                                   |    1=20
 arch/powerpc/boot/4xx.c                                |    2=20
 arch/powerpc/kvm/book3s_hv.c                           |    4=20
 arch/powerpc/kvm/book3s_pr.c                           |    4=20
 arch/powerpc/platforms/pseries/hotplug-memory.c        |    4=20
 arch/powerpc/platforms/pseries/iommu.c                 |   43=20
 arch/powerpc/platforms/pseries/vio.c                   |    2=20
 arch/powerpc/xmon/xmon.c                               |    9=20
 arch/s390/include/asm/page.h                           |    2=20
 arch/s390/kvm/kvm-s390.c                               |    6=20
 arch/s390/mm/hugetlbpage.c                             |  100=20
 arch/sparc/include/uapi/asm/ipcbuf.h                   |   22=20
 arch/x86/kernel/cpu/tsx.c                              |   13=20
 arch/x86/kvm/emulate.c                                 |   27=20
 arch/x86/kvm/hyperv.c                                  |   10=20
 arch/x86/kvm/i8259.c                                   |    6=20
 arch/x86/kvm/ioapic.c                                  |   15=20
 arch/x86/kvm/lapic.c                                   |   13=20
 arch/x86/kvm/mmu.c                                     |    6=20
 arch/x86/kvm/mtrr.c                                    |    8=20
 arch/x86/kvm/pmu.h                                     |   18=20
 arch/x86/kvm/pmu_intel.c                               |   24=20
 arch/x86/kvm/vmx.c                                     |    4=20
 arch/x86/kvm/vmx/vmx.c                                 | 8033 ++++++++++++=
+++++
 arch/x86/kvm/x86.c                                     |   27=20
 crypto/algapi.c                                        |   22=20
 crypto/api.c                                           |    3=20
 crypto/internal.h                                      |    1=20
 crypto/pcrypt.c                                        |    1=20
 drivers/acpi/video_detect.c                            |   13=20
 drivers/base/power/main.c                              |   42=20
 drivers/clk/tegra/clk-tegra-periph.c                   |    6=20
 drivers/crypto/atmel-aes.c                             |   37=20
 drivers/crypto/atmel-sha.c                             |    7=20
 drivers/crypto/axis/artpec6_crypto.c                   |    2=20
 drivers/crypto/ccp/ccp-dev-v3.c                        |    1=20
 drivers/crypto/picoxcell_crypto.c                      |   15=20
 drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_crtc.c         |    8=20
 drivers/hv/hv_balloon.c                                |   13=20
 drivers/infiniband/core/addr.c                         |    2=20
 drivers/infiniband/core/sa_query.c                     |    4=20
 drivers/infiniband/core/umem_odp.c                     |    2=20
 drivers/infiniband/hw/mlx5/gsi.c                       |    3=20
 drivers/md/dm-crypt.c                                  |   10=20
 drivers/md/dm-zoned-metadata.c                         |   23=20
 drivers/md/dm.c                                        |    9=20
 drivers/md/persistent-data/dm-space-map-common.c       |   27=20
 drivers/md/persistent-data/dm-space-map-common.h       |    2=20
 drivers/md/persistent-data/dm-space-map-disk.c         |    6=20
 drivers/md/persistent-data/dm-space-map-metadata.c     |    5=20
 drivers/media/i2c/adv748x/adv748x.h                    |    8=20
 drivers/media/rc/iguanair.c                            |    2=20
 drivers/media/usb/uvc/uvc_driver.c                     |   12=20
 drivers/media/v4l2-core/videobuf-dma-sg.c              |    5=20
 drivers/mfd/da9062-core.c                              |    2=20
 drivers/mfd/dln2.c                                     |   13=20
 drivers/mfd/rn5t618.c                                  |    1=20
 drivers/mmc/host/mmc_spi.c                             |   11=20
 drivers/mmc/host/sdhci-of-at91.c                       |    9=20
 drivers/mtd/ubi/fastmap.c                              |   23=20
 drivers/net/bonding/bond_alb.c                         |   44=20
 drivers/net/dsa/bcm_sf2.c                              |    4=20
 drivers/net/ethernet/broadcom/bcmsysport.c             |    3=20
 drivers/net/ethernet/broadcom/bnxt/bnxt.c              |    2=20
 drivers/net/ethernet/cadence/macb_main.c               |   14=20
 drivers/net/ethernet/dec/tulip/dmfe.c                  |    7=20
 drivers/net/ethernet/dec/tulip/uli526x.c               |    4=20
 drivers/net/ethernet/smsc/smc911x.c                    |    2=20
 drivers/net/gtp.c                                      |    6=20
 drivers/net/ppp/ppp_async.c                            |   18=20
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c |    1=20
 drivers/net/wireless/intel/iwlwifi/mvm/nvm.c           |    2=20
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c           |   10=20
 drivers/net/wireless/marvell/libertas/cfg.c            |    2=20
 drivers/net/wireless/marvell/mwifiex/scan.c            |    7=20
 drivers/net/wireless/marvell/mwifiex/sta_ioctl.c       |    1=20
 drivers/net/wireless/marvell/mwifiex/wmm.c             |    4=20
 drivers/nfc/pn544/pn544.c                              |    2=20
 drivers/of/Kconfig                                     |    4=20
 drivers/of/address.c                                   |    6=20
 drivers/pci/dwc/pci-keystone-dw.c                      |    2=20
 drivers/pci/setup-bus.c                                |   20=20
 drivers/pci/switch/switchtec.c                         |    2=20
 drivers/phy/qualcomm/phy-qcom-apq8064-sata.c           |    2=20
 drivers/pinctrl/sh-pfc/pfc-r8a7778.c                   |    4=20
 drivers/platform/x86/intel_mid_powerbtn.c              |    5=20
 drivers/platform/x86/intel_scu_ipc.c                   |   21=20
 drivers/power/supply/ltc2941-battery-gauge.c           |    2=20
 drivers/rtc/rtc-cmos.c                                 |    2=20
 drivers/rtc/rtc-hym8563.c                              |    2=20
 drivers/scsi/csiostor/csio_scsi.c                      |    2=20
 drivers/scsi/megaraid/megaraid_sas_base.c              |    3=20
 drivers/scsi/megaraid/megaraid_sas_fusion.c            |    3=20
 drivers/scsi/megaraid/megaraid_sas_fusion.h            |    1=20
 drivers/scsi/qla2xxx/qla_dbg.c                         |    6=20
 drivers/scsi/qla2xxx/qla_dbg.h                         |    6=20
 drivers/scsi/qla2xxx/qla_isr.c                         |   12=20
 drivers/scsi/qla2xxx/qla_mbx.c                         |    3=20
 drivers/scsi/qla2xxx/qla_nx.c                          |    7=20
 drivers/scsi/qla4xxx/ql4_os.c                          |    2=20
 drivers/scsi/ufs/ufshcd.c                              |    6=20
 drivers/tty/serial/xilinx_uartps.c                     |   17=20
 drivers/usb/gadget/function/f_ecm.c                    |   16=20
 drivers/usb/gadget/function/f_ncm.c                    |   17=20
 drivers/usb/gadget/legacy/cdc2.c                       |    2=20
 drivers/usb/gadget/legacy/g_ffs.c                      |    2=20
 drivers/usb/gadget/legacy/multi.c                      |    2=20
 drivers/usb/gadget/legacy/ncm.c                        |    2=20
 drivers/xen/xen-balloon.c                              |    2=20
 fs/btrfs/ctree.c                                       |   64=20
 fs/btrfs/ctree.h                                       |   32=20
 fs/btrfs/delayed-ref.c                                 |    8=20
 fs/btrfs/disk-io.c                                     |   22=20
 fs/btrfs/extent_io.c                                   |    8=20
 fs/btrfs/file-item.c                                   |    2=20
 fs/btrfs/file.c                                        |    3=20
 fs/btrfs/inode.c                                       |   12=20
 fs/btrfs/print-tree.c                                  |    4=20
 fs/btrfs/send.c                                        |   17=20
 fs/btrfs/tests/btrfs-tests.c                           |    1=20
 fs/btrfs/transaction.c                                 |    8=20
 fs/btrfs/tree-log.c                                    |  397=20
 fs/cifs/smb2pdu.c                                      |   10=20
 fs/ext2/super.c                                        |    6=20
 fs/ext4/page-io.c                                      |   19=20
 fs/f2fs/super.c                                        |   14=20
 fs/nfs/Kconfig                                         |    2=20
 fs/nfs/dir.c                                           |   47=20
 fs/nfs/direct.c                                        |    4=20
 fs/nfs/nfs3xdr.c                                       |    5=20
 fs/nfs/nfs4proc.c                                      |    5=20
 fs/nfs/nfs4xdr.c                                       |    5=20
 fs/nfs/pnfs_nfs.c                                      |    7=20
 fs/nfs/write.c                                         |    4=20
 fs/nfsd/nfs4layouts.c                                  |    2=20
 fs/nfsd/nfs4state.c                                    |    2=20
 fs/nfsd/state.h                                        |    2=20
 fs/ubifs/dir.c                                         |    2=20
 fs/ubifs/file.c                                        |    4=20
 fs/ubifs/ioctl.c                                       |   11=20
 include/linux/kvm_host.h                               |    2=20
 include/media/v4l2-rect.h                              |    8=20
 include/trace/events/btrfs.h                           |    2=20
 kernel/events/core.c                                   |   10=20
 kernel/irq/irqdomain.c                                 |    1=20
 kernel/module.c                                        |    2=20
 kernel/time/alarmtimer.c                               |    8=20
 kernel/time/clocksource.c                              |   11=20
 kernel/trace/ftrace.c                                  |   15=20
 kernel/trace/trace.h                                   |   29=20
 kernel/trace/trace_sched_switch.c                      |    4=20
 lib/test_kasan.c                                       |    1=20
 net/hsr/hsr_slave.c                                    |    2=20
 net/ipv4/tcp.c                                         |    6=20
 net/l2tp/l2tp_core.c                                   |    7=20
 net/rxrpc/ar-internal.h                                |    1=20
 net/rxrpc/call_object.c                                |    4=20
 net/rxrpc/conn_client.c                                |    3=20
 net/rxrpc/conn_object.c                                |    3=20
 net/rxrpc/input.c                                      |    3=20
 net/rxrpc/output.c                                     |   26=20
 net/sched/cls_rsvp.h                                   |    6=20
 net/sched/cls_tcindex.c                                |   43=20
 net/sunrpc/auth_gss/svcauth_gss.c                      |    4=20
 net/vmw_vsock/hyperv_transport.c                       |   68=20
 samples/bpf/Makefile                                   |    2=20
 sound/drivers/dummy.c                                  |    2=20
 sound/soc/soc-pcm.c                                    |   95=20
 tools/kvm/kvm_stat/kvm_stat                            |    8=20
 tools/power/acpi/Makefile.config                       |    2=20
 virt/kvm/arm/mmio.c                                    |    6=20
 virt/kvm/arm/mmu.c                                     |    3=20
 virt/kvm/arm/vgic/vgic-its.c                           |    3=20
 virt/kvm/kvm_main.c                                    |    4=20
 188 files changed, 9310 insertions(+), 957 deletions(-)

Alexander Lobakin (1):
      MIPS: fix indentation of the 'RELOCS' message

Alexandre Belloni (2):
      ARM: dts: at91: sama5d3: fix maximum peripheral clock rates
      ARM: dts: at91: sama5d3: define clock rate range for tcb1

Alexey Kardashevskiy (1):
      powerpc/pseries: Allow not having ibm, hypertas-functions::hcall-mult=
i-tce for DDW

Amol Grover (2):
      tracing: Annotate ftrace_graph_hash pointer with __rcu
      tracing: Annotate ftrace_graph_notrace_hash pointer with __rcu

Anand Jain (1):
      btrfs: use bool argument in free_root_pointers()

Anand Lodnoor (1):
      scsi: megaraid_sas: Do not initiate OCR if controller is not in ready=
 state

Andreas Kemnade (1):
      mfd: rn5t618: Mark ADC control register volatile

Andy Shevchenko (1):
      rtc: cmos: Stop using shared IRQ

Ard Biesheuvel (1):
      crypto: ccp - set max RSA modulus size for v3 platform devices as well

Arnd Bergmann (3):
      sparc32: fix struct ipc64_perm type definition
      nfsd: fix delay timer on 32-bit architectures
      nfsd: fix jiffies/time_t mixup in LRU list

Arun Easi (1):
      scsi: qla2xxx: Fix unbound NVME response length

Asutosh Das (1):
      scsi: ufs: Recheck bkops level if bkops is disabled

Bart Van Assche (1):
      scsi: qla2xxx: Fix the endianness of the qla82xx_get_fw_size() return=
 type

Bean Huo (1):
      scsi: ufs: Fix ufshcd_probe_hba() reture value in case ufshcd_scsi_ad=
d_wlus() fails

Brian Norris (1):
      mwifiex: fix unbalanced locking in mwifiex_process_country_ie()

Bryan O'Donoghue (2):
      usb: gadget: f_ncm: Use atomic_t to track in-flight request
      usb: gadget: f_ecm: Use atomic_t to track in-flight request

Chengguang Xu (3):
      f2fs: choose hardlimit when softlimit is larger than hardlimit in f2f=
s_statfs_project()
      f2fs: fix miscounted block limit in f2fs_statfs_project()
      f2fs: code cleanup for f2fs_statfs_project()

Christian Borntraeger (1):
      KVM: s390: do not clobber registers during guest reset/store status

Christoffer Dall (1):
      KVM: arm64: Only sign-extend MMIO up to register width

Chuhong Yuan (1):
      crypto: picoxcell - adjust the position of tasklet_init and fix misse=
d tasklet_kill

Claudiu Beznea (1):
      drm: atmel-hlcdc: enable clock before configuring timing engine

Cong Wang (2):
      net_sched: fix an OOB access in cls_tcindex
      net_sched: fix a resource leak in tcindex_set_parms()

Dan Carpenter (1):
      ubi: Fix an error pointer dereference in error handling code

David Howells (3):
      rxrpc: Fix insufficient receive notification generation
      rxrpc: Fix NULL pointer deref due to call->conn being cleared on disc=
onnect
      rxrpc: Fix service call disconnection

David Sterba (1):
      btrfs: remove trivial locking wrappers of tree mod log

Dmitry Fomichev (1):
      dm zoned: support zone sizes smaller than 128MiB

Eric Auger (1):
      KVM: arm/arm64: vgic-its: Fix restoration of unmapped collections

Eric Biggers (5):
      ubifs: Fix FS_IOC_SETFLAGS unexpectedly clearing encrypt flag
      ubifs: don't trigger assertion on invalid no-key filename
      ext4: fix deadlock allocating crypto bounce page from mempool
      crypto: artpec6 - return correct error code for failed setkey()
      crypto: atmel-sha - fix error handling when setting hmac key

Eric Dumazet (7):
      cls_rsvp: fix rsvp_policy
      net: hsr: fix possible NULL deref in hsr_handle_frame()
      tcp: clear tp->total_retrans in tcp_disconnect()
      tcp: clear tp->delivered in tcp_disconnect()
      tcp: clear tp->data_segs{in|out} in tcp_disconnect()
      tcp: clear tp->segs_{in|out} in tcp_disconnect()
      bonding/alb: properly access headers in bond_alb_xmit()

Filipe Manana (3):
      Btrfs: fix assertion failure on fsync with NO_HOLES enabled
      Btrfs: fix missing hole after hole punching and fsync when using NO_H=
OLES
      Btrfs: fix race between adding and putting tree mod seq elements and =
nodes

Florian Fainelli (2):
      net: dsa: bcm_sf2: Only 7278 supports 2Gb/sec IMP port
      net: systemport: Avoid RBUF stuck in Wake-on-LAN mode

Gavin Shan (2):
      tools/kvm_stat: Fix kvm_exit filter name
      KVM: arm/arm64: Fix young bit from mmu notifier

Geert Uytterhoeven (2):
      nfs: NFS_SWAP should depend on SWAP
      pinctrl: sh-pfc: r8a7778: Fix duplicate SDSELF_B and SD1_CLK_B

Gerald Schaefer (1):
      s390/mm: fix dynamic pagetable upgrade for hugetlbfs

Greg Kroah-Hartman (1):
      Linux 4.14.171

Gustavo A. R. Silva (2):
      lib/test_kasan.c: fix memory leak in kmalloc_oob_krealloc_more()
      media: i2c: adv748x: Fix unsafe macros

Hans de Goede (1):
      ACPI: video: Do not export a non working backlight interface on MSI M=
S-7721 boards

Harini Katakam (2):
      net: macb: Remove unnecessary alignment check for TSO
      net: macb: Limit maximum GEM TX length in TSO

Helen Koike (1):
      media: v4l2-rect.h: fix v4l2_rect_map_inside() top/left adjustments

Herbert Xu (3):
      crypto: api - Check spawn->alg under lock in crypto_drop_spawn
      crypto: pcrypt - Do not clear MAY_SLEEP flag in original request
      crypto: api - Fix race condition in crypto_spawn_alg

Hou Tao (1):
      ubifs: Reject unsupported ioctl flags explicitly

H=C3=A5kon Bugge (1):
      RDMA/netlink: Do not always generate an ACK for some netlink operatio=
ns

Joe Thornber (1):
      dm space map common: fix to ensure new block isn't already in use

Johan Hovold (1):
      media: iguanair: fix endpoint sanity check

John Hubbard (1):
      media/v4l2-core: set pages dirty upon releasing DMA buffers

Jose Abreu (1):
      ARC: [plat-axs10x]: Add missing multicast filter number to GMAC node

Josef Bacik (3):
      btrfs: set trans->drity in btrfs_commit_transaction
      btrfs: free block groups after free'ing fs trees
      btrfs: flush write bio if we loop in extent_write_cache_pages

Juergen Gross (1):
      xen/balloon: Support xend-based toolstack take two

Kevin Hao (1):
      irqdomain: Fix a memory leak in irq_domain_push_irq()

Konstantin Khlebnikov (1):
      clocksource: Prevent double add_timer_on() for watchdog_timer

Linus Walleij (1):
      mmc: spi: Toggle SPI polarity, do not hardcode it

Logan Gunthorpe (2):
      PCI/switchtec: Fix vep_vector_number ioread width
      PCI: Don't disable bridge BARs when assigning bus resources

Luca Coelho (2):
      iwlwifi: mvm: fix NVM check for 3168 devices
      iwlwifi: don't throw error when trying to remove IGTK

Marco Felsch (1):
      mfd: da9062: Fix watchdog compatible string

Marios Pomonis (12):
      KVM: x86: Refactor picdev_write() to prevent Spectre-v1/L1TF attacks
      KVM: x86: Refactor prefix decoding to prevent Spectre-v1/L1TF attacks
      KVM: x86: Protect DR-based index computations from Spectre-v1/L1TF at=
tacks
      KVM: x86: Protect kvm_lapic_reg_write() from Spectre-v1/L1TF attacks
      KVM: x86: Protect kvm_hv_msr_[get|set]_crash_data() from Spectre-v1/L=
1TF attacks
      KVM: x86: Protect ioapic_write_indirect() from Spectre-v1/L1TF attacks
      KVM: x86: Protect MSR-based index computations in pmu.h from Spectre-=
v1/L1TF attacks
      KVM: x86: Protect ioapic_read_indirect() from Spectre-v1/L1TF attacks
      KVM: x86: Protect MSR-based index computations from Spectre-v1/L1TF a=
ttacks in x86.c
      KVM: x86: Protect x86_decode_insn from Spectre-v1/L1TF attacks
      KVM: x86: Protect MSR-based index computations in fixed_msr_to_seg_un=
it() from Spectre-v1/L1TF attacks
      KVM: x86: Protect pmu_intel.c from Spectre-v1/L1TF attacks

Mathieu Desnoyers (1):
      tracing: Fix sched switch start/stop refcount racy updates

Miaohe Lin (1):
      KVM: nVMX: vmread should not set rflags to specify success in case of=
 #PF

Michael Chan (1):
      bnxt_en: Fix TC queue mapping.

Michael Ellerman (1):
      of: Add OF_DMA_DEFAULT_COHERENT & select it on powerpc

Micha=C5=82 Miros=C5=82aw (1):
      mmc: sdhci-of-at91: fix memleak on clk_get failure

Mika Westerberg (2):
      platform/x86: intel_scu_ipc: Fix interrupt support
      platform/x86: intel_mid_powerbtn: Take a copy of ddata

Mike Snitzer (1):
      dm: fix potential for q->make_request_fn NULL pointer

Milan Broz (1):
      dm crypt: fix benbi IV constructor crash if used in authenticated mode

Nathan Chancellor (9):
      scsi: csiostor: Adjust indentation in csio_device_reset
      scsi: qla4xxx: Adjust indentation in qla4xxx_mem_free
      phy: qualcomm: Adjust indentation in read_poll_timeout
      ext2: Adjust indentation in ext2_fill_super
      powerpc/44x: Adjust indentation in ibm4xx_denali_fixup_memsize
      NFC: pn544: Adjust indentation in pn544_hci_check_presence
      ppp: Adjust indentation into ppp_async_input
      net: smc911x: Adjust indentation in smc911x_phy_configure
      net: tulip: Adjust indentation in {dmfe, uli526x}_init_module

Navid Emamdoost (1):
      brcmfmac: Fix memory leak in brcmf_usbdev_qinit

Nicolai Stange (2):
      libertas: don't exit from lbs_ibss_join_existing() with RCU read lock=
 held
      libertas: make lbs_ibss_join_existing() return error code on rates ov=
erflow

Oliver Neukum (1):
      mfd: dln2: More sanity checking for endpoints

Olof Johansson (1):
      ARM: 8949/1: mm: mark free_memmap as __init

Paul Kocialkowski (1):
      rtc: hym8563: Return -EINVAL if the time is known to be invalid

Pawan Gupta (1):
      x86/cpu: Update cached HLE state on write to TSX_CTRL_CPUID_CLEAR

Pingfan Liu (1):
      powerpc/pseries: Advance pfn if section is not present in lmb_is_remo=
vable()

Prabhath Sajeepa (1):
      IB/mlx5: Fix outstanding_pi index for GSI qps

Qing Xu (2):
      mwifiex: Fix possible buffer overflows in mwifiex_ret_wmm_get_status()
      mwifiex: Fix possible buffer overflows in mwifiex_cmd_append_vsie_tlv=
()

Qu Wenruo (1):
      btrfs: Get rid of the confusing btrfs_file_extent_inline_len

Quinn Tran (1):
      scsi: qla2xxx: Fix mtcp dump collection failure

Rafael J. Wysocki (1):
      PM: core: Fix handling of devices deleted during system-wide resume

Ranjani Sridharan (1):
      ASoC: pcm: update FE/BE trigger order based on the command

Ridge Kennedy (1):
      l2tp: Allow duplicate session creation with UDP

Robert Milkowski (1):
      NFSv4: try lease recovery on NFS4ERR_EXPIRED

Roberto Bergantinos Corpas (1):
      sunrpc: expiry_time should be seconds not timeval

Roger Quadros (1):
      usb: gadget: legacy: set max_speed to super-speed

Ronnie Sahlberg (1):
      cifs: fail i/o on soft mounts if sessionsetup errors out

Sascha Hauer (1):
      ubi: fastmap: Fix inverted logic in seen selfcheck

Sean Christopherson (8):
      KVM: PPC: Book3S HV: Uninit vCPU if vcore creation fails
      KVM: PPC: Book3S PR: Free shared page if mmu initialization fails
      KVM: x86: Free wbinvd_dirty_mask if vCPU creation fails
      KVM: x86: Fix potential put_fpu() w/o load_fpu() on MPX platform
      KVM: x86/mmu: Apply max PA check for MMIO sptes to 32-bit KVM
      KVM: VMX: Add non-canonical check on writes to RTIT address MSRs
      KVM: Use vcpu-specific gva->hva translation when querying host page s=
ize
      KVM: Play nice with read-only memslots when querying host page size

Shubhrajyoti Datta (2):
      serial: uartps: Add a timeout to the tx empty wait
      serial: uartps: Move the spinlock after the read of the tx empty

Song Liu (1):
      perf/core: Fix mlock accounting in perf_mmap()

Stephen Boyd (1):
      alarmtimer: Unregister wakeup source when module get fails

Stephen Warren (2):
      ARM: tegra: Enable PLLP bypass during Tegra124 LP1
      clk: tegra: Mark fuse clock as critical

Steven Rostedt (VMware) (2):
      ftrace: Add comment to why rcu_dereference_sched() is open coded
      ftrace: Protect ftrace_graph_hash with ftrace_sync

Sukadev Bhattiprolu (1):
      powerpc/xmon: don't access ASDR in VMs

Sunil Muthuswamy (1):
      hv_sock: Remove the accept port restriction

Suzuki K Poulose (1):
      arm64: cpufeature: Fix the type of no FP/SIMD capability

Sven Van Asbroeck (1):
      power: supply: ltc2941-battery-gauge: fix use-after-free

Taehee Yoo (1):
      gtp: use __GFP_NOWARN to avoid memalloc warning

Takashi Iwai (1):
      ALSA: dummy: Fix PCM format loop in proc output

Tianyu Lan (1):
      hv_balloon: Balloon up according to request page number

Toke H=C3=B8iland-J=C3=B8rgensen (1):
      samples/bpf: Don't try to remove user's homedir on clean

Trond Myklebust (3):
      NFS: Fix memory leaks and corruption in readdir
      NFS: Directory page cache pages need to be locked when read
      NFS/pnfs: Fix pnfs_generic_prepare_to_resend_writes()

Tudor Ambarus (1):
      crypto: atmel-aes - Fix counter overflow in CTR mode

Tyrel Datwyler (1):
      powerpc/pseries/vio: Fix iommu_table use-after-free refcount warning

Will Deacon (1):
      media: uvcvideo: Avoid cyclic entity chains due to malformed USB desc=
riptors

Yishai Hadas (1):
      IB/core: Fix ODP get user pages flow

YueHaibing (1):
      kernel/module: Fix memleak in module_add_modinfo_attrs()

Yurii Monakov (1):
      PCI: keystone: Fix link training retries initiation

Zhengyuan Liu (1):
      tools/power/acpi: fix compilation error

Zhihao Cheng (1):
      ubifs: Fix deadlock in concurrent bulk-read and writepage


--azLHFNyN32YCQGCU
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl5HPiUACgkQONu9yGCS
aT5T6w/9G+0gfHgR1FzNs2999dp4HOaH1pI5FY9Y5FBlsHtqjLeVNS4tSkphmXkT
yYRj+f0T2x95yTI7XDEKrS7HnaySxS0tzRzYW10IUHfwsPUVuynkrlM166NsWzDK
83w67COTQ5FYCeYaSpwl47rzx78G0RSg1A5Akap4cqOVVue64+BeFWtqSUj8llr/
hITJnSCwCZVohUHPly4FQj6LsCZYV+H9QoLY9fpkoSrwNcnQQw378lwVcs0G9NLL
FlQ3UlRTZzlJF9kxDGyqeuxuSOQoyR3w/cGV9nOPmnGfp90RCuWBx5vyFA/2F3vV
6ZkUdzkiz58lzA3wFDxJWzWbP+PxKm6f3m8PU/kA8aVbJAbT9aOCTujCdWP+QejY
sly7wFw7adniZzz1K+h33pGZkTEs/0sW5uS65jMt+ytrkavcgg1PcLVG2d2StdrE
vFbR9+WxLDKKxh5zHnwBLrzALNWq4t9Om5icaga1L5ufnY2k5B8AnjNNkvJNB1b/
bYwjZqarePbZOnRIPr6QuSHGz9RUoQ9skKLYlddVziSpFBUFtSHWp91LT83gcUl6
r2L3YnDLLzN2EcFWqYKhp5LoXVqba6GE60vAy238tOqOHNCTX8/oca+yarOpynUW
2nTEPZE1KF2NgUDtHaCbxzu6hLyTiH2OMJq7Erz18xD9E6jGcGY=
=GIVh
-----END PGP SIGNATURE-----

--azLHFNyN32YCQGCU--
