Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 826DD1384C
	for <lists+stable@lfdr.de>; Sat,  4 May 2019 10:37:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726215AbfEDIhh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 4 May 2019 04:37:37 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:45151 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726214AbfEDIhg (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 4 May 2019 04:37:36 -0400
Received: by mail-pf1-f193.google.com with SMTP id e24so4085369pfi.12;
        Sat, 04 May 2019 01:37:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=iIxms+P0w9jLETgwMDi4mRKjK3e2PuUlc8PVBGNpyMA=;
        b=Xc/yfZJIhj36HgtS2Ta+7jeQTgCDiRd6RqN8KeUPrVsjemgeNZrAXQZy/sjZ58pXkh
         VAXt0LVharFF67gNRHpuqYmzjjN5bpri1IVo6KLItzIx78uO6KMWU0lMjaeAFXbIb25r
         tl8nqeAXtAPzMqXb0DG/y4VgyfNYDWwABDt02+SMpgnVuUly8VwjLgY91K2/o8tBZ6ya
         3bIkRQbE6C8D7vcFMoZaaIUUfqH8/jRUogLt4/VNteKE49JqIlh8TIhfH+iSoVLM8kiB
         4zCHH16JNsCirpamzk+rDrbI93XvVrWrKI39eLuf8OD3PxciF9L3AD4fF/5Eg9BpM146
         UuNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=iIxms+P0w9jLETgwMDi4mRKjK3e2PuUlc8PVBGNpyMA=;
        b=iuE6NF0MVKhcZ0KtbZ1711MMBnD8+7akorwaxcmWeNAQ9AOR36cLYPA17jhZRaRHyg
         PffHqK779/O6xwHj+PGWlZa8oYBkwrkgO/hQH3BA1ceIPtANOU8MstY0QoMviyN9H7/z
         INALips7GmfGY5uSJZZTSCsQprHjwtbBmD9S08uVBvzi60ulGGRqLiZ9AglWjshXNguC
         c2JpMcHPTwAm4wup/jXX6nUXOACXH0qTb4A4eL/fBlrDQMJ2mZ8aUe+anhpwa+85G+KE
         VHHwnvD8WeospUt8rJKVXjnsRNKYV21qlWy4BrRuh7S1OV/8So0DnCuzATGTod+/NB8W
         eCAg==
X-Gm-Message-State: APjAAAXXZm4oFmi8w7mwx9acD8ToyCP3fcPXTR7FoCzZKDfxW4Vzfrcq
        9Emo0fHaivHdozYPTTlDd9g=
X-Google-Smtp-Source: APXvYqw4DfvOjT6s68J6KiMj/r7Vo+yzoHcTCF1KMb0Cy9+CCzMxfb9sF/Lpn35CDb7G7YBZ4VsGlw==
X-Received: by 2002:a65:4589:: with SMTP id o9mr17130857pgq.381.1556959055569;
        Sat, 04 May 2019 01:37:35 -0700 (PDT)
Received: from ArchLinux ([103.231.91.34])
        by smtp.gmail.com with ESMTPSA id o9sm7302702pgh.68.2019.05.04.01.37.28
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 04 May 2019 01:37:33 -0700 (PDT)
Date:   Sat, 4 May 2019 14:07:20 +0530
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org, lwn@lwn.net,
        Jiri Slaby <jslaby@suse.cz>
Subject: Re: Linux 5.0.12
Message-ID: <20190504083720.GA3027@ArchLinux>
References: <20190504082114.GA31258@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="vtzGhvizbBRQ85DL"
Content-Disposition: inline
In-Reply-To: <20190504082114.GA31258@kroah.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--vtzGhvizbBRQ85DL
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


Thanks, a bunch Greg!
On 10:21 Sat 04 May , Greg KH wrote:
>I'm announcing the release of the 5.0.12 kernel.
>
>All users of the 5.0 kernel series must upgrade.
>
>The updated 5.0.y git tree can be found at:
>	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git lin=
ux-5.0.y
>and can be browsed at the normal kernel.org git web browser:
>	http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Ds=
ummary
>
>thanks,
>
>greg k-h
>
>------------
>
> Documentation/i2c/busses/i2c-i801                             |    1
> Makefile                                                      |   10 +
> arch/arm/Kconfig                                              |    1
> arch/arm/boot/dts/bcm2835-rpi-b-rev2.dts                      |    2
> arch/arm/boot/dts/imx6qdl-icore-rqs.dtsi                      |    4
> arch/arm/boot/dts/imx6qdl-phytec-pfla02.dtsi                  |    1
> arch/arm/include/asm/kvm_mmu.h                                |   11 +
> arch/arm/include/asm/stage2_pgtable.h                         |    2
> arch/arm/mach-imx/mach-imx51.c                                |    1
> arch/arm64/boot/dts/renesas/r8a77990.dtsi                     |    7 -
> arch/arm64/include/asm/kvm_mmu.h                              |   11 +
> arch/arm64/kvm/reset.c                                        |    6 -
> arch/s390/include/asm/elf.h                                   |   11 +
> arch/x86/include/asm/kvm_host.h                               |    2
> arch/x86/kvm/hyperv.c                                         |    9 +
> arch/x86/kvm/mmu.c                                            |   21 ++-
> arch/x86/kvm/svm.c                                            |   32 +++++
> arch/x86/kvm/vmx/vmx.c                                        |    6 +
> arch/x86/kvm/x86.c                                            |    3
> arch/x86/mm/mmap.c                                            |    2
> arch/x86/realmode/init.c                                      |    2
> drivers/acpi/acpica/evgpe.c                                   |    6 -
> drivers/ata/libata-zpodd.c                                    |   34 ++++-
> drivers/gpio/gpio-aspeed.c                                    |    2
> drivers/gpio/gpiolib-of.c                                     |   17 ++
> drivers/gpu/drm/drm_drv.c                                     |    6 -
> drivers/gpu/drm/drm_file.c                                    |    6 -
> drivers/gpu/drm/i915/intel_dp.c                               |    6 -
> drivers/gpu/drm/meson/meson_drv.c                             |    9 +
> drivers/gpu/drm/tegra/hub.c                                   |    4
> drivers/i2c/busses/Kconfig                                    |    1
> drivers/i2c/busses/i2c-i801.c                                 |    4
> drivers/iommu/amd_iommu.c                                     |    9 +
> drivers/iommu/amd_iommu_init.c                                |    7 -
> drivers/iommu/amd_iommu_types.h                               |    2
> drivers/leds/leds-pca9532.c                                   |    8 +
> drivers/leds/trigger/ledtrig-netdev.c                         |   16 +-
> drivers/net/ethernet/cadence/macb_main.c                      |   10 +
> drivers/net/ethernet/ibm/ehea/ehea_main.c                     |    1
> drivers/net/ethernet/micrel/ks8851.c                          |   36 +++-=
--
> drivers/net/ethernet/qlogic/qlcnic/qlcnic_ethtool.c           |    2
> drivers/net/ethernet/stmicro/stmmac/ring_mode.c               |    8 -
> drivers/net/ethernet/stmicro/stmmac/stmmac_main.c             |   14 +-
> drivers/net/ethernet/ti/netcp_ethss.c                         |    8 +
> drivers/net/ethernet/xilinx/xilinx_axienet_main.c             |    2
> drivers/net/ieee802154/adf7242.c                              |    4
> drivers/net/ieee802154/mac802154_hwsim.c                      |    2
> drivers/net/phy/dp83822.c                                     |   34 +++--
> drivers/net/wireless/mediatek/mt76/mt76x02_usb_core.c         |    3
> drivers/net/wireless/mediatek/mt76/mt76x2/phy.c               |   30 +++--
> drivers/nvme/host/multipath.c                                 |    5
> drivers/nvme/target/core.c                                    |    4
> drivers/nvme/target/io-cmd-file.c                             |   20 +--
> drivers/s390/net/qeth_l3_main.c                               |    4
> drivers/s390/scsi/zfcp_fc.c                                   |   21 ++-
> drivers/scsi/aacraid/aacraid.h                                |    7 +
> drivers/scsi/aacraid/commsup.c                                |    4
> drivers/scsi/mpt3sas/mpt3sas_base.c                           |    6 +
> drivers/scsi/mpt3sas/mpt3sas_scsih.c                          |   12 ++
> drivers/scsi/qla4xxx/ql4_os.c                                 |    2
> drivers/staging/axis-fifo/Kconfig                             |    1
> drivers/staging/mt7621-pci/Kconfig                            |    1
> drivers/staging/rtl8188eu/core/rtw_xmit.c                     |    9 +
> drivers/staging/rtl8188eu/include/rtw_xmit.h                  |    2
> drivers/staging/rtl8712/rtl8712_cmd.c                         |   10 -
> drivers/staging/rtl8712/rtl8712_cmd.h                         |    2
> drivers/staging/rtl8723bs/core/rtw_xmit.c                     |   14 +-
> drivers/staging/rtl8723bs/include/rtw_xmit.h                  |    2
> drivers/staging/rtlwifi/phydm/rtl_phydm.c                     |    2
> drivers/staging/rtlwifi/rtl8822be/fw.c                        |    2
> drivers/staging/vc04_services/interface/vchiq_arm/vchiq_arm.c |    8 +
> drivers/tty/serial/ar933x_uart.c                              |   24 +---
> drivers/tty/serial/sc16is7xx.c                                |   12 +-
> drivers/usb/dwc3/dwc3-pci.c                                   |    4
> drivers/usb/gadget/udc/net2272.c                              |    1
> drivers/usb/gadget/udc/net2280.c                              |    8 -
> drivers/usb/host/u132-hcd.c                                   |    3
> drivers/usb/misc/usb251xb.c                                   |    2
> fs/afs/fsclient.c                                             |    6 -
> fs/afs/yfsclient.c                                            |    2
> fs/btrfs/transaction.c                                        |   49 ++++=
+++-
> fs/ceph/inode.c                                               |    2
> fs/fuse/dev.c                                                 |   12 +-
> fs/nfs/client.c                                               |    2
> fs/pipe.c                                                     |    4
> fs/splice.c                                                   |   12 +-
> include/linux/mm.h                                            |   15 ++
> include/linux/pipe_fs_i.h                                     |   10 +
> include/linux/sched/signal.h                                  |   18 +++
> include/net/tc_act/tc_gact.h                                  |    2
> include/net/xdp_sock.h                                        |    1
> kernel/ptrace.c                                               |   15 ++
> kernel/trace/trace.c                                          |    6 -
> lib/sbitmap.c                                                 |   11 +
> mm/gup.c                                                      |   48 ++++=
++--
> mm/hugetlb.c                                                  |   13 ++
> mm/kasan/kasan.h                                              |    5
> net/bridge/br_netfilter_hooks.c                               |    1
> net/bridge/br_netfilter_ipv6.c                                |    2
> net/ipv6/netfilter/ip6t_srh.c                                 |    6 +
> net/netfilter/Kconfig                                         |    1
> net/netfilter/nft_set_rbtree.c                                |    7 -
> net/sunrpc/xprtsock.c                                         |    4
> net/xdp/xdp_umem.c                                            |   19 ---
> scripts/kconfig/lxdialog/inputbox.c                           |    3
> scripts/kconfig/nconf.c                                       |    2
> scripts/kconfig/nconf.gui.c                                   |    3
> scripts/selinux/genheaders/genheaders.c                       |    1
> scripts/selinux/mdp/mdp.c                                     |    1
> security/selinux/include/classmap.h                           |    1
> tools/build/feature/test-libopencsd.c                         |    4
> tools/perf/util/cs-etm-decoder/cs-etm-decoder.c               |    1
> tools/perf/util/machine.c                                     |   32 +++--
> tools/testing/selftests/kvm/Makefile                          |    4
> tools/testing/selftests/kvm/include/kvm_util.h                |    1
> tools/testing/selftests/kvm/lib/kvm_util.c                    |   16 ++
> tools/testing/selftests/kvm/x86_64/cr4_cpuid_sync_test.c      |   35 +++--
> tools/testing/selftests/kvm/x86_64/state_test.c               |   18 ++-
> virt/kvm/arm/hyp/vgic-v3-sr.c                                 |    4
> virt/kvm/arm/mmu.c                                            |   59 ++++=
+++---
> virt/kvm/arm/vgic/vgic-its.c                                  |   21 ++-
> virt/kvm/arm/vgic/vgic-v3.c                                   |    4
> virt/kvm/arm/vgic/vgic.c                                      |   14 +-
> 123 files changed, 776 insertions(+), 349 deletions(-)
>
>Aaro Koskinen (2):
>      net: stmmac: don't set own bit too early for jumbo frames
>      net: stmmac: fix jumbo frame sending with non-linear skbs
>
>Aditya Pakki (5):
>      qlcnic: Avoid potential NULL pointer dereference
>      staging: rtl8188eu: Fix potential NULL pointer dereference of kcalloc
>      staging: rtlwifi: rtl8822b: fix to avoid potential NULL pointer dere=
ference
>      staging: rtlwifi: Fix potential NULL pointer dereference of kzalloc
>      usb: usb251xb: fix to avoid potential NULL pointer dereference
>
>Al Viro (1):
>      ceph: fix use-after-free on symlink traversal
>
>Alakesh Haloi (1):
>      SUNRPC: fix uninitialized variable warning
>
>Andrei Vagin (1):
>      ptrace: take into account saved_sigmask in PTRACE{GET,SET}SIGMASK
>
>Andrey Smirnov (2):
>      gpio: of: Check propname before applying "cs-gpios" quirks
>      gpio: of: Check for "spi-cs-high" in child instead of parent node
>
>Arnd Bergmann (2):
>      staging: axis-fifo: add CONFIG_OF dependency
>      netfilter: fix NETFILTER_XT_TARGET_TEE dependencies
>
>Bj=C3=B6rn T=C3=B6pel (1):
>      xsk: fix umem memory leak on cleanup
>
>Changbin Du (1):
>      kconfig/[mn]conf: handle backspace (^H) key
>
>Dan Carpenter (2):
>      staging: rtl8712: uninitialized memory in read_bbreg_hdl()
>      staging: vc04_services: Fix an error code in vchiq_probe()
>
>Dan Murphy (1):
>      net: phy: Add DP83825I to the DP83822 driver
>
>Dave Carroll (1):
>      scsi: aacraid: Insure we don't access PCIe space during AER/EEH
>
>David Howells (1):
>      afs: Fix StoreData op marshalling
>
>Davide Caratti (1):
>      net/sched: don't dereference a->goto_chain to read the chain index
>
>Felipe Balbi (1):
>      usb: dwc3: pci: add support for Comet Lake PCH ID
>
>Felix Fietkau (2):
>      mt76: mt76x2: fix external LNA gain settings
>      mt76: mt76x2: fix 2.4 GHz channel gain settings
>
>Filipe Manana (1):
>      Btrfs: fix file corruption after snapshotting due to mix of buffered=
/DIO writes
>
>Geert Uytterhoeven (1):
>      gpio: of: Fix of_gpiochip_add() error path
>
>Greg Kroah-Hartman (1):
>      Linux 5.0.12
>
>Guido Kiener (3):
>      usb: gadget: net2280: Fix overrun of OUT messages
>      usb: gadget: net2280: Fix net2280_dequeue()
>      usb: gadget: net2272: Fix net2272_dequeue()
>
>Harini Katakam (1):
>      net: macb: Add null check for PCLK and HCLK
>
>Helen Koike (1):
>      ARM: dts: bcm283x: Fix hdmi hpd gpio pull
>
>Jarkko Nikula (1):
>      i2c: i801: Add support for Intel Comet Lake
>
>Jean-Philippe Brucker (2):
>      drm/meson: Fix invalid pointer in meson_drv_unbind()
>      drm/meson: Uninstall IRQ handler
>
>Joerg Roedel (1):
>      iommu/amd: Reserve exclusion range in iova-domain
>
>Julian Wiedmann (1):
>      s390/qeth: fix race when initializing the IP address table
>
>Kangjie Lu (5):
>      net: ieee802154: fix a potential NULL pointer dereference
>      netfilter: ip6t_srh: fix NULL pointer dereferences
>      gpio: aspeed: fix a potential NULL pointer dereference
>      scsi: qla4xxx: fix a potential NULL pointer dereference
>      leds: pca9532: fix a potential NULL pointer dereference
>
>Li RongQing (1):
>      ieee802154: hwsim: propagate genlmsg_reply return code
>
>Linus Torvalds (3):
>      mm: make page ref count overflow check tighter and more explicit
>      mm: add 'try_get_page()' helper function
>      mm: prevent get_user_pages() from overflowing page refcount
>
>Lukas Wunner (4):
>      net: ks8851: Dequeue RX packets explicitly
>      net: ks8851: Reassert reset pin if chip ID check fails
>      net: ks8851: Delay requesting IRQ until opened
>      net: ks8851: Set initial carrier state to down
>
>Mao Wenan (1):
>      sc16is7xx: missing unregister/delete driver on error in sc16is7xx_in=
it()
>
>Marc Zyngier (4):
>      KVM: arm64: Reset the PMU in preemptible context
>      arm64: KVM: Always set ICH_HCR_EL2.EN if GICv4 is enabled
>      KVM: arm/arm64: vgic-its: Take the srcu lock when writing to guest m=
emory
>      KVM: arm/arm64: vgic-its: Take the srcu lock when parsing the memslo=
ts
>
>Marco Felsch (1):
>      ARM: dts: pfla02: increase phy reset duration
>
>Martin George (1):
>      nvme-multipath: relax ANA state check
>
>Martin Schwidefsky (1):
>      s390: limit brk randomization to 32MB
>
>Masahiro Yamada (1):
>      kbuild: skip parsing pre sub-make code for recursion
>
>Masanari Iida (1):
>      ARM: dts: imx6qdl: Fix typo in imx6qdl-icore-rqs.dtsi
>
>Matteo Croce (1):
>      x86/realmode: Don't leak the trampoline kernel address
>
>Matthew Wilcox (1):
>      fs: prevent page refcount overflow in pipe_buf_get
>
>Max Gurtovoy (1):
>      nvmet: fix error flow during ns enable
>
>Maxim Zhukov (1):
>      staging, mt7621-pci: fix build without pci support
>
>Ming Lei (2):
>      sbitmap: order READ/WRITE freed instance and setting clear bit
>      nvmet: fix building bvec from sg list
>
>Mukesh Ojha (1):
>      usb: u132-hcd: fix resource leak
>
>Noralf Tr=C3=B8nnes (1):
>      drm: Fix drm_release() and device unplug
>
>Pablo Neira Ayuso (1):
>      netfilter: nft_set_rbtree: check for inactive element after flag mis=
match
>
>Paulo Alcantara (1):
>      selinux: use kernel linux/socket.h for genheaders and mdp
>
>Petr =C5=A0tetiar (1):
>      serial: ar933x_uart: Fix build failure with disabled console
>
>Qian Cai (1):
>      kasan: fix variable 'tag' set but not used warning
>
>Rafael J. Wysocki (1):
>      Revert "ACPICA: Clear status of GPEs before enabling them"
>
>Rafa=C5=82 Mi=C5=82ecki (1):
>      leds: trigger: netdev: fix refcnt leak on interface rename
>
>Ralph Campbell (1):
>      x86/mm: Don't exceed the valid physical address space
>
>Rasmus Villemoes (1):
>      leds: trigger: netdev: use memcpy in device_name_store
>
>Sean Christopherson (5):
>      KVM: nVMX: Do not inherit quadrant and invalid for the root shadow E=
PT
>      KVM: selftests: assert on exit reason in CR4/cpuid sync test
>      KVM: selftests: explicitly disable PIE for tests
>      KVM: selftests: disable stack protector for all KVM tests
>      KVM: selftests: complete IO before migrating guest state
>
>Sekhar Nori (1):
>      ARM: davinci: fix build failure with allnoconfig
>
>Singh, Brijesh (1):
>      KVM: SVM: Workaround errata#1096 (insn_len maybe zero on SMAP violat=
ion)
>
>Solomon Tan (1):
>      perf cs-etm: Add missing case value
>
>Sreekanth Reddy (1):
>      scsi: mpt3sas: Fix kernel panic during expander reset
>
>Stanislaw Gruszka (1):
>      mt76x02: fix hdr pointer in write txwi for USB
>
>Steffen Maier (1):
>      scsi: zfcp: reduce flood of fcrscn1 trace records on multi-element R=
SCN
>
>Suzuki K Poulose (1):
>      KVM: arm/arm64: Fix handling of stage2 huge mappings
>
>Takeshi Kihara (1):
>      arm64: dts: renesas: r8a77990: Fix SCIF5 DMA channels
>
>Thierry Reding (1):
>      drm/tegra: hub: Fix dereference before check
>
>Trond Myklebust (1):
>      NFS: Fix a typo in nfs_init_timeout_values()
>
>Ville Syrj=C3=A4l=C3=A4 (1):
>      drm/i915: Do not enable FEC without DSC
>
>Vitaly Kuznetsov (1):
>      x86/kvm/hyper-v: avoid spurious pending stimer on vCPU init
>
>Wei Li (1):
>      perf machine: Update kernel map address and re-order properly
>
>Wen Yang (4):
>      ARM: imx51: fix a leaked reference by adding missing of_node_put
>      net: xilinx: fix possible object reference leak
>      net: ibm: fix possible object reference leak
>      net: ethernet: ti: fix possible object reference leak
>
>Xiaoyao Li (1):
>      kvm/x86: Move MSR_IA32_ARCH_CAPABILITIES to array emulated_msrs
>
>Xin Long (1):
>      netfilter: bridge: set skb transport_header before entering NF_INET_=
PRE_ROUTING
>
>raymond pang (1):
>      libata: fix using DMA buffers on stack
>



--vtzGhvizbBRQ85DL
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEnwF+nWawchZUPOuwsjqdtxFLKRUFAlzNTzgACgkQsjqdtxFL
KRVqJQf+N1+kH4aEO+5rZVVZvas1I104voro/NAIHmXejQf/FLQ0x+VX63zFybOX
HmEii0N7ybYXWX4pEfyRh4dU5TI+9ThnA9ldrU5i7w4eyzkt+G7R1jzRuRJ9/0nB
RzvipAgYiklWuAxodLsctxzVYwR8PCNH037lpLTWP632fMixCCSi/RGn4VJJOsgm
hYLlbDM2AGXj86zH7RCGz7DfRYMSIp9oQ2kHtOjpzCK8EQabsgsmJiG4TwnZjCL0
GXDlqDlSfRyUoQzUtyAtmjZYR46MZj700l9Hn7cPh1aF8E6/qJIjJmIsPKFmdx9e
lkxaqL6O0T8LFe4xSrHR+WwPHBVdLw==
=ZSuO
-----END PGP SIGNATURE-----

--vtzGhvizbBRQ85DL--
