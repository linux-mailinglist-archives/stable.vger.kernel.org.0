Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3BD4BB83EE
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 00:06:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405195AbfISWGY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Sep 2019 18:06:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:43758 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405187AbfISWGX (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Sep 2019 18:06:23 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2789621920;
        Thu, 19 Sep 2019 22:06:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568930781;
        bh=+mUMwXupKOO23n4l/H/y07e+hWOIwRn7JbNo61PVSzw=;
        h=From:To:Cc:Subject:Date:From;
        b=zP6vSE4sbvrc7kCWs+8ThD4nkLV4vkq4mInUpAI+5hJcm4i2xDKNdCDYgLqh5+TvY
         xYHx0oOUapVzDzDE4sA7t7MgNJVybdznfCIaRmaW+3RM/gANJliAtwAhKJE7vemSje
         8DetJVonnPHf4/a3bx23K4bpLeyNaZ9u8NJV5NSg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 5.2 000/124] 5.2.17-stable review
Date:   Fri, 20 Sep 2019 00:01:28 +0200
Message-Id: <20190919214819.198419517@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-5.2.17-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.2.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.2.17-rc1
X-KernelTest-Deadline: 2019-09-21T21:48+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.2.17 release.
There are 124 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat 21 Sep 2019 09:44:25 PM UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.2.17-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.2.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.2.17-rc1

David Howells <dhowells@redhat.com>
    vfs: Fix refcounting of filenames in fs_parser

Sean Young <sean@mess.org>
    media: technisat-usb2: break out of loop at end of buffer

Jann Horn <jannh@google.com>
    floppy: fix usercopy direction

Amir Goldstein <amir73il@gmail.com>
    ovl: fix regression caused by overlapping layers detection

Will Deacon <will@kernel.org>
    Revert "arm64: Remove unnecessary ISBs from set_{pte,pmd,pud}"

Joerg Roedel <jroedel@suse.de>
    iommu/amd: Fix race in increase_address_space()

Stuart Hayes <stuart.w.hayes@gmail.com>
    iommu/amd: Flush old domains in kdump kernel

Hillf Danton <hdanton@sina.com>
    keys: Fix missing null pointer check in request_key_auth_describe()

Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
    dmaengine: rcar-dmac: Fix DMACHCLR handling if iommu is mapped

Baolin Wang <baolin.wang@linaro.org>
    dmaengine: sprd: Fix the DMA link-list configuration

Jacob Pan <jacob.jun.pan@linux.intel.com>
    iommu/vt-d: Remove global page flush support

Tianyu Lan <Tianyu.Lan@microsoft.com>
    x86/hyper-v: Fix overflow bug in fill_gva_list()

Peter Zijlstra <peterz@infradead.org>
    x86/uaccess: Don't leak the AC flags into __get_user() argument evaluation

Wenwen Wang <wenwen@cs.uga.edu>
    dmaengine: ti: omap-dma: Add cleanup in omap_dma_probe()

Wenwen Wang <wenwen@cs.uga.edu>
    dmaengine: ti: dma-crossbar: Fix a memory leak bug

Geert Uytterhoeven <geert+renesas@glider.be>
    arm64: dts: renesas: r8a77995: draak: Fix backlight regulator name

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    net: seeq: Fix the function used to release some memory in an error handling path

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    enetc: Add missing call to 'pci_free_irq_vectors()' in probe and remove functions

Razvan Stefanescu <razvan.stefanescu@microchip.com>
    net: dsa: microchip: add KSZ8563 compatibility string

Dmitry Bogdanov <dmitry.bogdanov@aquantia.com>
    net: aquantia: fix out of memory condition on rx side

Igor Russkikh <Igor.Russkikh@aquantia.com>
    net: aquantia: linkstate irq should be oneshot

Dmitry Bogdanov <dmitry.bogdanov@aquantia.com>
    net: aquantia: reapply vlan filters on up

Dmitry Bogdanov <dmitry.bogdanov@aquantia.com>
    net: aquantia: fix removal of vlan 0

Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
    tools/power turbostat: Fix CPU%C1 display value

Rajneesh Bhardwaj <rajneesh.bhardwaj@linux.intel.com>
    tools/power turbostat: Add Ice Lake NNPI support

Len Brown <len.brown@intel.com>
    tools/power turbostat: Fix Haswell Core systems

Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
    tools/power turbostat: fix buffer overrun

Gustavo A. R. Silva <gustavo@embeddedor.com>
    tools/power turbostat: fix file descriptor leaks

Colin Ian King <colin.king@canonical.com>
    tools/power turbostat: fix leak of file descriptor on error return path

Zephaniah E. Loss-Cutler-Hull <zephaniah@gmail.com>
    tools/power x86_energy_perf_policy: Fix argument parsing

Ben Hutchings <ben@decadent.org.uk>
    tools/power x86_energy_perf_policy: Fix "uninitialized variable" warnings at -O2

Florian Westphal <fw@strlen.de>
    netfilter: nf_flow_table: clear skb tstamp before xmit

YueHaibing <yuehaibing@huawei.com>
    amd-xgbe: Fix error path in xgbe_mod_init()

Hsin-Yi Wang <hsinyi@chromium.org>
    i2c: mediatek: disable zero-length transfers for mt8183

Lori Hikichi <lori.hikichi@broadcom.com>
    i2c: iproc: Stop advertising support of SMBUS quick cmd

Kim Phillips <kim.phillips@amd.com>
    perf/x86/amd/ibs: Fix sample bias for dispatched micro-ops

Josh Hunt <johunt@akamai.com>
    perf/x86/intel: Restrict period on Nehalem

Jarkko Nikula <jarkko.nikula@linux.intel.com>
    i2c: designware: Synchronize IRQs when unregistering slave client

Takashi Iwai <tiwai@suse.de>
    sky2: Disable MSI on yet another ASUS boards (P6Xxxx)

Thomas Falcon <tlfalcon@linux.ibm.com>
    ibmvnic: Do not process reset during or after device removal

zhaoyang <huangzhaoyang@gmail.com>
    ARM: 8901/1: add a criteria for pfn_valid of arm

Anup Patel <Anup.Patel@wdc.com>
    RISC-V: Fix FIXMAP area corruption on RV32 systems

Nagarjuna Kristam <nkristam@nvidia.com>
    usb: host: xhci-tegra: Set DMA mask correctly

Jia-Ju Bai <baijiaju1990@gmail.com>
    libceph: don't call crypto_free_sync_skcipher() on a NULL tfm

Dan Carpenter <dan.carpenter@oracle.com>
    cifs: Use kzfree() to zero out the password

Ronnie Sahlberg <lsahlber@redhat.com>
    cifs: set domainName when a domain-key is used in multiuser

Evan Quan <evan.quan@amd.com>
    drm/amd/powerplay: correct Vega20 dpm level related settings

Florian Westphal <fw@strlen.de>
    netfilter: conntrack: make sysctls per-namespace again

Marc Zyngier <maz@kernel.org>
    kallsyms: Don't let kallsyms_lookup_size_offset() fail on retrieving the first symbol

YueHaibing <yuehaibing@huawei.com>
    NFS: remove set but not used variable 'mapping'

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFSv2: Fix write regression

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFSv2: Fix eof handling

Thomas Jarosch <thomas.jarosch@intra2net.com>
    netfilter: nf_conntrack_ftp: Fix debug output

Todd Seidelmann <tseidelmann@linode.com>
    netfilter: xt_physdev: Fix spurious error message in physdev_mt_check

Christian König <christian.koenig@amd.com>
    drm/amdgpu: fix dma_fence_wait without reference

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFS: Fix writepage(s) error handling to not report errors twice

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFS: Fix spurious EIO read errors

Trond Myklebust <trond.myklebust@hammerspace.com>
    pNFS/flexfiles: Don't time out requests on hard mounts

Thomas Gleixner <tglx@linutronix.de>
    x86/apic: Fix arch_dynirq_lower_bound() bug for DT enabled machines

Prashant Malani <pmalani@chromium.org>
    r8152: Set memory to all 0xFFs on failed reg reads

Ilya Leoshkevich <iii@linux.ibm.com>
    bpf: allow narrow loads of some sk_reuseport_md fields with offset > 0

Jakub Sitnicki <jakub@cloudflare.com>
    flow_dissector: Fix potential use-after-free on BPF_PROG_DETACH

Sven Eckelmann <sven@narfation.org>
    batman-adv: Only read OGM2 tvlv_len after buffer len check

Doug Berger <opendmb@gmail.com>
    ARM: 8874/1: mm: only adjust sections of valid mm structures

Gerd Hoffmann <kraxel@redhat.com>
    drm/virtio: use virtio_max_dma_size

Laurent Pinchart <laurent.pinchart@ideasonboard.com>
    drm/omap: Fix port lookup for SDI output

Wenwen Wang <wenwen@cs.uga.edu>
    qed: Add cleanup in qed_slowpath_start()

Anders Roxell <anders.roxell@linaro.org>
    selftests/bpf: add config fragment BPF_JIT

Ilya Leoshkevich <iii@linux.ibm.com>
    selftests/bpf: fix test_cgroup_storage on s390

Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
    xdp: unpin xdp umem pages in error path

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    Kconfig: Fix the reference to the IDT77105 Phy driver in the description of ATM_NICSTAR_USE_IDT77105

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFS: On fatal writeback errors, we need to call nfs_inode_remove_request()

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFS: Fix initialisation of I/O result struct in nfs_pgio_rpcsetup

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFSv4: Fix return value in nfs_finish_open()

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFSv4: Fix return values for nfs4_file_open()

Juliana Rodrigueiro <juliana.rodrigueiro@intra2net.com>
    netfilter: xt_nfacct: Fix alignment mismatch in xt_nfacct_match_info

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nft_flow_offload: missing netlink attribute policy

Todd Seidelmann <tseidelmann@linode.com>
    netfilter: ebtables: Fix argument order to ADD_COUNTER

Phil Reid <preid@electromag.com.au>
    fpga: altera-ps-spi: Fix getting of optional confd gpio

Quentin Monnet <quentin.monnet@netronome.com>
    tools: bpftool: close prog FD before exit on showing a single program

Ilya Leoshkevich <iii@linux.ibm.com>
    selftests/bpf: fix "bind{4, 6} deny specific IP & port" on s390

Ilya Leoshkevich <iii@linux.ibm.com>
    s390/bpf: use 32-bit index for tail calls

Tony Lindgren <tony@atomide.com>
    ARM: dts: Fix incomplete dts data for am3 and am4 mmc

Suman Anna <s-anna@ti.com>
    bus: ti-sysc: Simplify cleanup upon failures in sysc_probe()

Janusz Krzysztofik <jmkrzyszt@gmail.com>
    ARM: OMAP1: ams-delta-fiq: Fix missing irq_ack

Faiz Abbas <faiz_abbas@ti.com>
    ARM: dts: dra74x: Fix iodelay configuration for mmc3

Emmanuel Vadot <manu@freebsd.org>
    ARM: dts: am335x: Fix UARTs length

Tony Lindgren <tony@atomide.com>
    ARM: OMAP2+: Fix omap4 errata warning on other SoCs

Ilya Leoshkevich <iii@linux.ibm.com>
    s390/bpf: fix lcgr instruction encoding

Neil Armstrong <narmstrong@baylibre.com>
    arm64: dts: meson-g12a: add missing dwc2 phy-names

Tony Lindgren <tony@atomide.com>
    ARM: dts: Fix incorrect dcan register mapping for am3, am4 and dra7

Tony Lindgren <tony@atomide.com>
    ARM: dts: Fix flags for gpio7

Tony Lindgren <tony@atomide.com>
    bus: ti-sysc: Fix using configured sysc mask value

Tony Lindgren <tony@atomide.com>
    bus: ti-sysc: Fix handling of forced idle

Tony Lindgren <tony@atomide.com>
    ARM: OMAP2+: Fix missing SYSC_HAS_RESET_STATUS for dra7 epwmss

Faiz Abbas <faiz_abbas@ti.com>
    ARM: dts: am57xx: Disable voltage switching for SD card

YueHaibing <yuehaibing@huawei.com>
    ieee802154: hwsim: unregister hw while hwsim_subscribe_all_others fails

YueHaibing <yuehaibing@huawei.com>
    ieee802154: hwsim: Fix error handle path in hwsim_init_module

Masashi Honma <masashi.honma@gmail.com>
    nl80211: Fix possible Spectre-v1 for CQM RSSI thresholds

Wen Huang <huangwenabc@gmail.com>
    mwifiex: Fix three heap overflow at parsing element in cfg80211_ap_settings

Razvan Stefanescu <razvan.stefanescu@microchip.com>
    tty/serial: atmel: reschedule TX after RX was started

Chunyan Zhang <chunyan.zhang@unisoc.com>
    serial: sprd: correct the wrong sequence of arguments

Hung-Te Lin <hungte@chromium.org>
    firmware: google: check if size is valid when decoding VPD data

Matt Delco <delco@chromium.org>
    KVM: coalesced_mmio: add bounds checking

Andrew Lunn <andrew@lunn.ch>
    net: dsa: Fix load order between DSA drivers and taggers

Dongli Zhang <dongli.zhang@oracle.com>
    xen-netfront: do not assume sk_buff_head list is empty in error handling

Willem de Bruijn <willemb@google.com>
    udp: correct reuseport selection with connected sockets

Cong Wang <xiyou.wangcong@gmail.com>
    net_sched: let qdisc_put() accept NULL pointer

Paolo Abeni <pabeni@redhat.com>
    net/sched: fix race between deactivation and dequeue for NOLOCK qdisc

Xin Long <lucien.xin@gmail.com>
    ip6_gre: fix a dst leak in ip6erspan_tunnel_xmit

Dmitry Bogdanov <dmitry.bogdanov@aquantia.com>
    net: aquantia: fix limit of vlan filters

Yonglong Liu <liuyonglong@huawei.com>
    net: hns: fix LED configuration for marvell phy

Nicolas Boichat <drinkcat@chromium.org>
    scripts/decode_stacktrace: match basepath using shell prefix operator, not regex

Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
    powerpc/mm/radix: Use the right page size for vmemmap mapping

Darrick J. Wong <darrick.wong@oracle.com>
    nfs: disable client side deduplication

Fabien Dessenne <fabien.dessenne@st.com>
    media: stm32-dcmi: fix irq = 0 case

Trond Myklebust <trond.myklebust@hammerspace.com>
    SUNRPC: Handle connection breakages correctly in call_status()

Benjamin Tissoires <benjamin.tissoires@redhat.com>
    Input: elan_i2c - remove Lenovo Legion Y7000 PnpID

Aaron Armstrong Skomra <skomra@gmail.com>
    HID: wacom: generic: read HID_DG_CONTACTMAX from any feature report

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_flow_table: set default timeout after successful insertion

Huazhong Tan <tanhuazhong@huawei.com>
    net: hns3: adjust hns3_uninit_phy()'s location in the hns3_client_uninit()

Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
    phy: renesas: rcar-gen3-usb2: Disable clearing VBUS in over-current

Sean Young <sean@mess.org>
    media: tm6000: double free if usb disconnect while streaming

Alan Stern <stern@rowland.harvard.edu>
    USB: usbcore: Fix slab-out-of-bounds bug during device reset


-------------

Diffstat:

 Documentation/filesystems/overlayfs.txt            |  2 +-
 Makefile                                           |  4 +-
 arch/arm/boot/dts/am33xx-l4.dtsi                   | 16 +++--
 arch/arm/boot/dts/am33xx.dtsi                      | 32 ++++++++--
 arch/arm/boot/dts/am4372.dtsi                      | 32 ++++++++--
 arch/arm/boot/dts/am437x-l4.dtsi                   |  4 ++
 arch/arm/boot/dts/am571x-idk.dts                   |  7 +--
 arch/arm/boot/dts/am572x-idk.dts                   |  7 +--
 arch/arm/boot/dts/am574x-idk.dts                   |  7 +--
 arch/arm/boot/dts/am57xx-beagle-x15-common.dtsi    |  3 +-
 arch/arm/boot/dts/am57xx-beagle-x15-revb1.dts      |  7 +--
 arch/arm/boot/dts/am57xx-beagle-x15-revc.dts       |  7 +--
 arch/arm/boot/dts/dra7-evm.dts                     |  2 +-
 arch/arm/boot/dts/dra7-l4.dtsi                     |  6 +-
 arch/arm/boot/dts/dra74x-mmc-iodelay.dtsi          | 50 +++++++--------
 arch/arm/mach-omap1/ams-delta-fiq-handler.S        |  3 +-
 arch/arm/mach-omap1/ams-delta-fiq.c                |  4 +-
 arch/arm/mach-omap2/omap4-common.c                 |  3 +
 arch/arm/mach-omap2/omap_hwmod_7xx_data.c          |  3 +-
 arch/arm/mm/init.c                                 |  8 ++-
 arch/arm64/boot/dts/amlogic/meson-g12a.dtsi        |  1 +
 arch/arm64/boot/dts/renesas/r8a77995-draak.dts     |  6 +-
 arch/arm64/include/asm/pgtable.h                   | 12 +++-
 arch/powerpc/mm/book3s64/radix_pgtable.c           | 16 +++--
 arch/riscv/include/asm/fixmap.h                    |  4 --
 arch/riscv/include/asm/pgtable.h                   | 12 +++-
 arch/s390/net/bpf_jit_comp.c                       | 12 ++--
 arch/x86/events/amd/ibs.c                          | 13 +++-
 arch/x86/events/intel/core.c                       |  6 ++
 arch/x86/hyperv/mmu.c                              |  8 ++-
 arch/x86/include/asm/perf_event.h                  | 12 ++--
 arch/x86/include/asm/uaccess.h                     |  4 +-
 arch/x86/kernel/apic/io_apic.c                     |  8 ++-
 drivers/atm/Kconfig                                |  2 +-
 drivers/block/floppy.c                             |  4 +-
 drivers/bus/ti-sysc.c                              | 24 ++++---
 drivers/dma/sh/rcar-dmac.c                         | 28 ++++++---
 drivers/dma/sprd-dma.c                             | 10 ++-
 drivers/dma/ti/dma-crossbar.c                      |  4 +-
 drivers/dma/ti/omap-dma.c                          |  4 +-
 drivers/firmware/google/vpd.c                      |  4 +-
 drivers/firmware/google/vpd_decode.c               | 55 +++++++++-------
 drivers/firmware/google/vpd_decode.h               |  6 +-
 drivers/fpga/altera-ps-spi.c                       | 11 ++--
 drivers/gpu/drm/amd/amdgpu/amdgpu_ctx.c            | 27 ++++----
 drivers/gpu/drm/amd/powerplay/hwmgr/vega20_hwmgr.c | 60 ++++++++++++++++--
 drivers/gpu/drm/omapdrm/dss/output.c               |  4 +-
 drivers/gpu/drm/virtio/virtgpu_object.c            | 10 ++-
 drivers/hid/wacom_sys.c                            | 10 +--
 drivers/hid/wacom_wac.c                            |  4 ++
 drivers/i2c/busses/i2c-bcm-iproc.c                 |  5 +-
 drivers/i2c/busses/i2c-designware-slave.c          |  1 +
 drivers/i2c/busses/i2c-mt65xx.c                    | 11 +++-
 drivers/input/mouse/elan_i2c_core.c                |  2 +-
 drivers/iommu/amd_iommu.c                          | 40 ++++++++++--
 drivers/iommu/intel-svm.c                          | 36 +++++------
 drivers/media/platform/stm32/stm32-dcmi.c          |  2 +-
 drivers/media/usb/dvb-usb/technisat-usb2.c         | 22 +++----
 drivers/media/usb/tm6000/tm6000-dvb.c              |  3 +
 drivers/net/dsa/microchip/ksz9477_spi.c            |  1 +
 drivers/net/ethernet/amd/xgbe/xgbe-main.c          | 10 ++-
 .../net/ethernet/aquantia/atlantic/aq_filters.c    |  5 +-
 drivers/net/ethernet/aquantia/atlantic/aq_main.c   |  4 ++
 drivers/net/ethernet/aquantia/atlantic/aq_nic.c    |  2 +-
 drivers/net/ethernet/aquantia/atlantic/aq_vec.c    |  3 +-
 drivers/net/ethernet/freescale/enetc/enetc_ptp.c   |  5 +-
 drivers/net/ethernet/hisilicon/hns/hns_enet.c      | 23 ++++++-
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    |  4 +-
 drivers/net/ethernet/ibm/ibmvnic.c                 |  6 +-
 drivers/net/ethernet/marvell/sky2.c                |  7 +++
 drivers/net/ethernet/qlogic/qed/qed_main.c         |  4 +-
 drivers/net/ethernet/seeq/sgiseeq.c                |  7 ++-
 drivers/net/ieee802154/mac802154_hwsim.c           |  8 ++-
 drivers/net/usb/r8152.c                            |  5 +-
 drivers/net/wireless/marvell/mwifiex/ie.c          |  3 +
 drivers/net/wireless/marvell/mwifiex/uap_cmd.c     |  9 ++-
 drivers/net/xen-netfront.c                         |  2 +-
 drivers/phy/renesas/phy-rcar-gen3-usb2.c           |  2 +
 drivers/tty/serial/atmel_serial.c                  |  1 -
 drivers/tty/serial/sprd_serial.c                   |  2 +-
 drivers/usb/core/config.c                          | 12 ++--
 drivers/usb/host/xhci-tegra.c                      | 10 +++
 fs/cifs/connect.c                                  | 22 +++++++
 fs/fs_parser.c                                     |  1 +
 fs/nfs/dir.c                                       |  2 +-
 fs/nfs/flexfilelayout/flexfilelayout.c             | 11 +++-
 fs/nfs/internal.h                                  | 10 +++
 fs/nfs/nfs4file.c                                  | 18 +++---
 fs/nfs/pagelist.c                                  |  2 +-
 fs/nfs/proc.c                                      |  7 ++-
 fs/nfs/read.c                                      | 35 ++++++++---
 fs/nfs/write.c                                     | 38 +++++------
 fs/overlayfs/ovl_entry.h                           |  1 +
 fs/overlayfs/super.c                               | 73 ++++++++++++++--------
 include/linux/intel-iommu.h                        |  3 -
 include/net/pkt_sched.h                            |  7 ++-
 include/net/sock_reuseport.h                       | 21 ++++++-
 include/uapi/linux/netfilter/xt_nfacct.h           |  5 ++
 kernel/kallsyms.c                                  |  6 +-
 net/batman-adv/bat_v_ogm.c                         | 18 ++++--
 net/bridge/netfilter/ebtables.c                    |  8 +--
 net/ceph/crypto.c                                  |  6 +-
 net/core/dev.c                                     | 16 +++--
 net/core/filter.c                                  |  8 +--
 net/core/flow_dissector.c                          |  2 +-
 net/core/sock_reuseport.c                          | 15 ++++-
 net/dsa/dsa2.c                                     |  2 +
 net/ipv4/datagram.c                                |  2 +
 net/ipv4/udp.c                                     |  5 +-
 net/ipv6/datagram.c                                |  2 +
 net/ipv6/ip6_gre.c                                 |  2 +-
 net/ipv6/udp.c                                     |  5 +-
 net/netfilter/nf_conntrack_ftp.c                   |  2 +-
 net/netfilter/nf_conntrack_standalone.c            |  5 ++
 net/netfilter/nf_flow_table_core.c                 |  2 +-
 net/netfilter/nf_flow_table_ip.c                   |  3 +-
 net/netfilter/nft_flow_offload.c                   |  6 ++
 net/netfilter/xt_nfacct.c                          | 36 +++++++----
 net/netfilter/xt_physdev.c                         |  6 +-
 net/sched/sch_generic.c                            |  3 +
 net/sunrpc/clnt.c                                  |  2 +-
 net/wireless/nl80211.c                             |  4 +-
 net/xdp/xdp_umem.c                                 |  4 +-
 scripts/decode_stacktrace.sh                       |  2 +-
 security/keys/request_key_auth.c                   |  6 ++
 tools/bpf/bpftool/prog.c                           |  4 +-
 tools/power/x86/turbostat/turbostat.c              | 38 +++++++----
 .../x86_energy_perf_policy.c                       | 28 +++++----
 tools/testing/selftests/bpf/config                 |  1 +
 tools/testing/selftests/bpf/test_cgroup_storage.c  |  6 +-
 tools/testing/selftests/bpf/test_sock.c            |  7 ++-
 virt/kvm/coalesced_mmio.c                          | 19 +++---
 132 files changed, 936 insertions(+), 446 deletions(-)


