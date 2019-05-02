Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 221C011E77
	for <lists+stable@lfdr.de>; Thu,  2 May 2019 17:45:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728587AbfEBP37 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 May 2019 11:29:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:48080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728567AbfEBP36 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 May 2019 11:29:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A04C720675;
        Thu,  2 May 2019 15:29:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556810997;
        bh=z40lyj+7G9doNQ1x0I5kUFWEoZ9Hyot6PJFi709FAzw=;
        h=From:To:Cc:Subject:Date:From;
        b=wqIWBzxYe5MtwWRanIkTHzmQ/yq/0hFlVs5g7+/HqNWDbV7ssAWNFkd4TLmCOVbeJ
         UvJMduvcysME8cBFDuJHeudVraUSN2zLbroqmiBH29SUKuS+fu0+aSJgUWnogHlJnj
         8wCD3/0oBzeOfrWLK9morENMqWcYnJRA8FIudm0E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 5.0 000/101] 5.0.12-stable review
Date:   Thu,  2 May 2019 17:20:02 +0200
Message-Id: <20190502143339.434882399@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-5.0.12-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.0.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.0.12-rc1
X-KernelTest-Deadline: 2019-05-04T14:33+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.0.12 release.
There are 101 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat 04 May 2019 02:32:10 PM UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.0.12-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.0.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.0.12-rc1

Rasmus Villemoes <linux@rasmusvillemoes.dk>
    leds: trigger: netdev: use memcpy in device_name_store

Kangjie Lu <kjlu@umn.edu>
    leds: pca9532: fix a potential NULL pointer dereference

Andrei Vagin <avagin@gmail.com>
    ptrace: take into account saved_sigmask in PTRACE{GET,SET}SIGMASK

Qian Cai <cai@lca.pw>
    kasan: fix variable 'tag' set but not used warning

Joerg Roedel <jroedel@suse.de>
    iommu/amd: Reserve exclusion range in iova-domain

Changbin Du <changbin.du@gmail.com>
    kconfig/[mn]conf: handle backspace (^H) key

Wei Li <liwei391@huawei.com>
    perf machine: Update kernel map address and re-order properly

Solomon Tan <solomonbobstoner@gmail.com>
    perf cs-etm: Add missing case value

Max Gurtovoy <maxg@mellanox.com>
    nvmet: fix error flow during ns enable

Ming Lei <ming.lei@redhat.com>
    nvmet: fix building bvec from sg list

Martin George <marting@netapp.com>
    nvme-multipath: relax ANA state check

Geert Uytterhoeven <geert+renesas@glider.be>
    gpio: of: Fix of_gpiochip_add() error path

Sean Christopherson <sean.j.christopherson@intel.com>
    KVM: selftests: complete IO before migrating guest state

Sean Christopherson <sean.j.christopherson@intel.com>
    KVM: selftests: disable stack protector for all KVM tests

Sean Christopherson <sean.j.christopherson@intel.com>
    KVM: selftests: explicitly disable PIE for tests

Sean Christopherson <sean.j.christopherson@intel.com>
    KVM: selftests: assert on exit reason in CR4/cpuid sync test

Vitaly Kuznetsov <vkuznets@redhat.com>
    x86/kvm/hyper-v: avoid spurious pending stimer on vCPU init

Xiaoyao Li <xiaoyao.li@linux.intel.com>
    kvm/x86: Move MSR_IA32_ARCH_CAPABILITIES to array emulated_msrs

Singh, Brijesh <brijesh.singh@amd.com>
    KVM: SVM: Workaround errata#1096 (insn_len maybe zero on SMAP violation)

Sean Christopherson <sean.j.christopherson@intel.com>
    KVM: nVMX: Do not inherit quadrant and invalid for the root shadow EPT

Andrey Smirnov <andrew.smirnov@gmail.com>
    gpio: of: Check for "spi-cs-high" in child instead of parent node

Andrey Smirnov <andrew.smirnov@gmail.com>
    gpio: of: Check propname before applying "cs-gpios" quirks

David Howells <dhowells@redhat.com>
    afs: Fix StoreData op marshalling

Masahiro Yamada <yamada.masahiro@socionext.com>
    kbuild: skip parsing pre sub-make code for recursion

raymond pang <raymondpangxd@gmail.com>
    libata: fix using DMA buffers on stack

Ralph Campbell <rcampbell@nvidia.com>
    x86/mm: Don't exceed the valid physical address space

Steffen Maier <maier@linux.ibm.com>
    scsi: zfcp: reduce flood of fcrscn1 trace records on multi-element RSCN

Al Viro <viro@zeniv.linux.org.uk>
    ceph: fix use-after-free on symlink traversal

Mukesh Ojha <mojha@codeaurora.org>
    usb: u132-hcd: fix resource leak

Matteo Croce <mcroce@redhat.com>
    x86/realmode: Don't leak the trampoline kernel address

Alakesh Haloi <alakesh.haloi@gmail.com>
    SUNRPC: fix uninitialized variable warning

Rafał Miłecki <rafal@milecki.pl>
    leds: trigger: netdev: fix refcnt leak on interface rename

Aditya Pakki <pakki001@umn.edu>
    usb: usb251xb: fix to avoid potential NULL pointer dereference

Kangjie Lu <kjlu@umn.edu>
    scsi: qla4xxx: fix a potential NULL pointer dereference

Dave Carroll <david.carroll@microsemi.com>
    scsi: aacraid: Insure we don't access PCIe space during AER/EEH

Sreekanth Reddy <sreekanth.reddy@broadcom.com>
    scsi: mpt3sas: Fix kernel panic during expander reset

Dan Carpenter <dan.carpenter@oracle.com>
    staging: vc04_services: Fix an error code in vchiq_probe()

Ming Lei <ming.lei@redhat.com>
    sbitmap: order READ/WRITE freed instance and setting clear bit

Sekhar Nori <nsekhar@ti.com>
    ARM: davinci: fix build failure with allnoconfig

Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
    drm/meson: Uninstall IRQ handler

Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
    drm/meson: Fix invalid pointer in meson_drv_unbind()

Kangjie Lu <kjlu@umn.edu>
    gpio: aspeed: fix a potential NULL pointer dereference

Noralf Trønnes <noralf@tronnes.org>
    drm: Fix drm_release() and device unplug

Wen Yang <wen.yang99@zte.com.cn>
    net: ethernet: ti: fix possible object reference leak

Wen Yang <wen.yang99@zte.com.cn>
    net: ibm: fix possible object reference leak

Wen Yang <wen.yang99@zte.com.cn>
    net: xilinx: fix possible object reference leak

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFS: Fix a typo in nfs_init_timeout_values()

Thierry Reding <treding@nvidia.com>
    drm/tegra: hub: Fix dereference before check

Masanari Iida <standby24x7@gmail.com>
    ARM: dts: imx6qdl: Fix typo in imx6qdl-icore-rqs.dtsi

Davide Caratti <dcaratti@redhat.com>
    net/sched: don't dereference a->goto_chain to read the chain index

Harini Katakam <harini.katakam@xilinx.com>
    net: macb: Add null check for PCLK and HCLK

Dan Murphy <dmurphy@ti.com>
    net: phy: Add DP83825I to the DP83822 driver

Aditya Pakki <pakki001@umn.edu>
    staging: rtlwifi: Fix potential NULL pointer dereference of kzalloc

Dan Carpenter <dan.carpenter@oracle.com>
    staging: rtl8712: uninitialized memory in read_bbreg_hdl()

Aditya Pakki <pakki001@umn.edu>
    staging: rtlwifi: rtl8822b: fix to avoid potential NULL pointer dereference

Aditya Pakki <pakki001@umn.edu>
    staging: rtl8188eu: Fix potential NULL pointer dereference of kcalloc

Lukas Wunner <lukas@wunner.de>
    net: ks8851: Set initial carrier state to down

Lukas Wunner <lukas@wunner.de>
    net: ks8851: Delay requesting IRQ until opened

Lukas Wunner <lukas@wunner.de>
    net: ks8851: Reassert reset pin if chip ID check fails

Lukas Wunner <lukas@wunner.de>
    net: ks8851: Dequeue RX packets explicitly

Suzuki K Poulose <suzuki.poulose@arm.com>
    KVM: arm/arm64: Fix handling of stage2 huge mappings

Jarkko Nikula <jarkko.nikula@linux.intel.com>
    i2c: i801: Add support for Intel Comet Lake

Marco Felsch <m.felsch@pengutronix.de>
    ARM: dts: pfla02: increase phy reset duration

Guido Kiener <guido@kiener-muenchen.de>
    usb: gadget: net2272: Fix net2272_dequeue()

Guido Kiener <guido@kiener-muenchen.de>
    usb: gadget: net2280: Fix net2280_dequeue()

Guido Kiener <guido@kiener-muenchen.de>
    usb: gadget: net2280: Fix overrun of OUT messages

Felipe Balbi <felipe.balbi@linux.intel.com>
    usb: dwc3: pci: add support for Comet Lake PCH ID

Marc Zyngier <marc.zyngier@arm.com>
    KVM: arm/arm64: vgic-its: Take the srcu lock when parsing the memslots

Marc Zyngier <marc.zyngier@arm.com>
    KVM: arm/arm64: vgic-its: Take the srcu lock when writing to guest memory

Marc Zyngier <marc.zyngier@arm.com>
    arm64: KVM: Always set ICH_HCR_EL2.EN if GICv4 is enabled

Marc Zyngier <marc.zyngier@arm.com>
    KVM: arm64: Reset the PMU in preemptible context

Petr Štetiar <ynezz@true.cz>
    serial: ar933x_uart: Fix build failure with disabled console

Mao Wenan <maowenan@huawei.com>
    sc16is7xx: missing unregister/delete driver on error in sc16is7xx_init()

Wen Yang <wen.yang99@zte.com.cn>
    ARM: imx51: fix a leaked reference by adding missing of_node_put

Julian Wiedmann <jwi@linux.ibm.com>
    s390/qeth: fix race when initializing the IP address table

Kangjie Lu <kjlu@umn.edu>
    netfilter: ip6t_srh: fix NULL pointer dereferences

Arnd Bergmann <arnd@arndb.de>
    netfilter: fix NETFILTER_XT_TARGET_TEE dependencies

Xin Long <lucien.xin@gmail.com>
    netfilter: bridge: set skb transport_header before entering NF_INET_PRE_ROUTING

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nft_set_rbtree: check for inactive element after flag mismatch

Maxim Zhukov <mussitantesmortem@gmail.com>
    staging, mt7621-pci: fix build without pci support

Arnd Bergmann <arnd@arndb.de>
    staging: axis-fifo: add CONFIG_OF dependency

Björn Töpel <bjorn.topel@intel.com>
    xsk: fix umem memory leak on cleanup

Aditya Pakki <pakki001@umn.edu>
    qlcnic: Avoid potential NULL pointer dereference

Aaro Koskinen <aaro.koskinen@nokia.com>
    net: stmmac: fix jumbo frame sending with non-linear skbs

Aaro Koskinen <aaro.koskinen@nokia.com>
    net: stmmac: don't set own bit too early for jumbo frames

Filipe Manana <fdmanana@suse.com>
    Btrfs: fix file corruption after snapshotting due to mix of buffered/DIO writes

Li RongQing <lirongqing@baidu.com>
    ieee802154: hwsim: propagate genlmsg_reply return code

Kangjie Lu <kjlu@umn.edu>
    net: ieee802154: fix a potential NULL pointer dereference

Felix Fietkau <nbd@nbd.name>
    mt76: mt76x2: fix 2.4 GHz channel gain settings

Felix Fietkau <nbd@nbd.name>
    mt76: mt76x2: fix external LNA gain settings

Stanislaw Gruszka <sgruszka@redhat.com>
    mt76x02: fix hdr pointer in write txwi for USB

Martin Schwidefsky <schwidefsky@de.ibm.com>
    s390: limit brk randomization to 32MB

Helen Koike <helen.koike@collabora.com>
    ARM: dts: bcm283x: Fix hdmi hpd gpio pull

Takeshi Kihara <takeshi.kihara.df@renesas.com>
    arm64: dts: renesas: r8a77990: Fix SCIF5 DMA channels

Matthew Wilcox <willy@infradead.org>
    fs: prevent page refcount overflow in pipe_buf_get

Linus Torvalds <torvalds@linux-foundation.org>
    mm: prevent get_user_pages() from overflowing page refcount

Linus Torvalds <torvalds@linux-foundation.org>
    mm: add 'try_get_page()' helper function

Linus Torvalds <torvalds@linux-foundation.org>
    mm: make page ref count overflow check tighter and more explicit

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/i915: Do not enable FEC without DSC

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    Revert "ACPICA: Clear status of GPEs before enabling them"

Paulo Alcantara <paulo@paulo.ac>
    selinux: use kernel linux/socket.h for genheaders and mdp


-------------

Diffstat:

 Documentation/i2c/busses/i2c-i801                  |  1 +
 Makefile                                           | 12 +++--
 arch/arm/Kconfig                                   |  1 +
 arch/arm/boot/dts/bcm2835-rpi-b-rev2.dts           |  2 +-
 arch/arm/boot/dts/imx6qdl-icore-rqs.dtsi           |  4 +-
 arch/arm/boot/dts/imx6qdl-phytec-pfla02.dtsi       |  1 +
 arch/arm/include/asm/kvm_mmu.h                     | 11 ++++
 arch/arm/include/asm/stage2_pgtable.h              |  2 +
 arch/arm/mach-imx/mach-imx51.c                     |  1 +
 arch/arm64/boot/dts/renesas/r8a77990.dtsi          |  7 ++-
 arch/arm64/include/asm/kvm_mmu.h                   | 11 ++++
 arch/arm64/kvm/reset.c                             |  6 +--
 arch/s390/include/asm/elf.h                        | 11 ++--
 arch/x86/include/asm/kvm_host.h                    |  2 +
 arch/x86/kvm/hyperv.c                              |  9 +++-
 arch/x86/kvm/mmu.c                                 | 21 +++++---
 arch/x86/kvm/svm.c                                 | 32 ++++++++++++
 arch/x86/kvm/vmx/vmx.c                             |  6 +++
 arch/x86/kvm/x86.c                                 |  3 +-
 arch/x86/mm/mmap.c                                 |  2 +-
 arch/x86/realmode/init.c                           |  2 -
 drivers/acpi/acpica/evgpe.c                        |  6 +--
 drivers/ata/libata-zpodd.c                         | 34 +++++++++----
 drivers/gpio/gpio-aspeed.c                         |  2 +
 drivers/gpio/gpiolib-of.c                          | 17 +++++--
 drivers/gpu/drm/drm_drv.c                          |  6 +--
 drivers/gpu/drm/drm_file.c                         |  6 +--
 drivers/gpu/drm/i915/intel_dp.c                    |  6 +--
 drivers/gpu/drm/meson/meson_drv.c                  |  9 ++--
 drivers/gpu/drm/tegra/hub.c                        |  4 +-
 drivers/i2c/busses/Kconfig                         |  1 +
 drivers/i2c/busses/i2c-i801.c                      |  4 ++
 drivers/iommu/amd_iommu.c                          |  9 ++--
 drivers/iommu/amd_iommu_init.c                     |  7 +--
 drivers/iommu/amd_iommu_types.h                    |  2 +
 drivers/leds/leds-pca9532.c                        |  8 ++-
 drivers/leds/trigger/ledtrig-netdev.c              | 16 +++---
 drivers/net/ethernet/cadence/macb_main.c           | 10 +++-
 drivers/net/ethernet/ibm/ehea/ehea_main.c          |  1 +
 drivers/net/ethernet/micrel/ks8851.c               | 36 ++++++-------
 .../net/ethernet/qlogic/qlcnic/qlcnic_ethtool.c    |  2 +
 drivers/net/ethernet/stmicro/stmmac/ring_mode.c    |  8 +--
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  | 14 ++---
 drivers/net/ethernet/ti/netcp_ethss.c              |  8 ++-
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c  |  2 +
 drivers/net/ieee802154/adf7242.c                   |  4 ++
 drivers/net/ieee802154/mac802154_hwsim.c           |  2 +-
 drivers/net/phy/dp83822.c                          | 34 ++++++++-----
 .../net/wireless/mediatek/mt76/mt76x02_usb_core.c  |  3 +-
 drivers/net/wireless/mediatek/mt76/mt76x2/phy.c    | 30 ++++++++---
 drivers/nvme/host/multipath.c                      |  5 +-
 drivers/nvme/target/core.c                         |  4 +-
 drivers/nvme/target/io-cmd-file.c                  | 20 ++++----
 drivers/s390/net/qeth_l3_main.c                    |  4 +-
 drivers/s390/scsi/zfcp_fc.c                        | 21 ++++++--
 drivers/scsi/aacraid/aacraid.h                     |  7 ++-
 drivers/scsi/aacraid/commsup.c                     |  4 +-
 drivers/scsi/mpt3sas/mpt3sas_base.c                |  6 +++
 drivers/scsi/mpt3sas/mpt3sas_scsih.c               | 12 +++++
 drivers/scsi/qla4xxx/ql4_os.c                      |  2 +
 drivers/staging/axis-fifo/Kconfig                  |  1 +
 drivers/staging/mt7621-pci/Kconfig                 |  1 +
 drivers/staging/rtl8188eu/core/rtw_xmit.c          |  9 +++-
 drivers/staging/rtl8188eu/include/rtw_xmit.h       |  2 +-
 drivers/staging/rtl8712/rtl8712_cmd.c              | 10 +---
 drivers/staging/rtl8712/rtl8712_cmd.h              |  2 +-
 drivers/staging/rtl8723bs/core/rtw_xmit.c          | 14 ++---
 drivers/staging/rtl8723bs/include/rtw_xmit.h       |  2 +-
 drivers/staging/rtlwifi/phydm/rtl_phydm.c          |  2 +
 drivers/staging/rtlwifi/rtl8822be/fw.c             |  2 +
 .../vc04_services/interface/vchiq_arm/vchiq_arm.c  |  8 ++-
 drivers/tty/serial/ar933x_uart.c                   | 24 +++------
 drivers/tty/serial/sc16is7xx.c                     | 12 ++++-
 drivers/usb/dwc3/dwc3-pci.c                        |  4 ++
 drivers/usb/gadget/udc/net2272.c                   |  1 +
 drivers/usb/gadget/udc/net2280.c                   |  8 ++-
 drivers/usb/host/u132-hcd.c                        |  3 ++
 drivers/usb/misc/usb251xb.c                        |  2 +-
 fs/afs/fsclient.c                                  |  6 +--
 fs/afs/yfsclient.c                                 |  2 +-
 fs/btrfs/transaction.c                             | 49 +++++++++++++++---
 fs/ceph/inode.c                                    |  2 +-
 fs/fuse/dev.c                                      | 12 ++---
 fs/nfs/client.c                                    |  2 +-
 fs/pipe.c                                          |  4 +-
 fs/splice.c                                        | 12 ++++-
 include/linux/mm.h                                 | 15 +++++-
 include/linux/pipe_fs_i.h                          | 10 ++--
 include/linux/sched/signal.h                       | 18 +++++++
 include/net/tc_act/tc_gact.h                       |  2 +-
 include/net/xdp_sock.h                             |  1 -
 kernel/ptrace.c                                    | 15 +++++-
 kernel/trace/trace.c                               |  6 ++-
 lib/sbitmap.c                                      | 11 ++++
 mm/gup.c                                           | 48 +++++++++++++-----
 mm/hugetlb.c                                       | 13 +++++
 mm/kasan/kasan.h                                   |  5 +-
 net/bridge/br_netfilter_hooks.c                    |  1 +
 net/bridge/br_netfilter_ipv6.c                     |  2 +
 net/ipv6/netfilter/ip6t_srh.c                      |  6 +++
 net/netfilter/Kconfig                              |  1 +
 net/netfilter/nft_set_rbtree.c                     |  7 ++-
 net/sunrpc/xprtsock.c                              |  4 +-
 net/xdp/xdp_umem.c                                 | 19 +------
 scripts/kconfig/lxdialog/inputbox.c                |  3 +-
 scripts/kconfig/nconf.c                            |  2 +-
 scripts/kconfig/nconf.gui.c                        |  3 +-
 scripts/selinux/genheaders/genheaders.c            |  1 -
 scripts/selinux/mdp/mdp.c                          |  1 -
 security/selinux/include/classmap.h                |  1 +
 tools/build/feature/test-libopencsd.c              |  4 +-
 tools/perf/util/cs-etm-decoder/cs-etm-decoder.c    |  1 +
 tools/perf/util/machine.c                          | 32 +++++++-----
 tools/testing/selftests/kvm/Makefile               |  4 +-
 tools/testing/selftests/kvm/include/kvm_util.h     |  1 +
 tools/testing/selftests/kvm/lib/kvm_util.c         | 16 ++++++
 .../selftests/kvm/x86_64/cr4_cpuid_sync_test.c     | 35 +++++++------
 tools/testing/selftests/kvm/x86_64/state_test.c    | 18 ++++++-
 virt/kvm/arm/hyp/vgic-v3-sr.c                      |  4 +-
 virt/kvm/arm/mmu.c                                 | 59 ++++++++++++++++------
 virt/kvm/arm/vgic/vgic-its.c                       | 21 +++++---
 virt/kvm/arm/vgic/vgic-v3.c                        |  4 +-
 virt/kvm/arm/vgic/vgic.c                           | 14 +++--
 123 files changed, 777 insertions(+), 350 deletions(-)


