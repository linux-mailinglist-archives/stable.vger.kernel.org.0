Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46DCEB84B9
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 00:13:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390899AbfISWNj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Sep 2019 18:13:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:52802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388812AbfISWNi (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Sep 2019 18:13:38 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 97DED21907;
        Thu, 19 Sep 2019 22:13:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568931217;
        bh=gyHfSo4kldsZEDl4+kd1Up6YP/blKoqB77q9b9NW3jQ=;
        h=From:To:Cc:Subject:Date:From;
        b=v8XRF3HcQsPmYpfQxluEMh92Lec8XzRHhYapwgqdV6jDyGIEiY2B9qrEL0bVhe0Qy
         rCNXWVDJAK5ERbUd1VQYivSLCNObNMq1aKtJ/CZ84Ux7xJTBW8XAlevDm936KGcEtc
         TLb6vxdVQfbLiX2msigFDaQsrFwRBVyyLokvnYbs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.19 00/79] 4.19.75-stable review
Date:   Fri, 20 Sep 2019 00:02:45 +0200
Message-Id: <20190919214807.612593061@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.75-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.75-rc1
X-KernelTest-Deadline: 2019-09-21T21:48+00:00
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.19.75 release.
There are 79 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat 21 Sep 2019 09:44:25 PM UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.75-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.19.75-rc1

Sean Young <sean@mess.org>
    media: technisat-usb2: break out of loop at end of buffer

Will Deacon <will.deacon@arm.com>
    arm64: kpti: Whitelist Cortex-A CPUs that don't implement the CSV3 field

Kees Cook <keescook@chromium.org>
    binfmt_elf: move brk out of mmap when doing direct loader exec

Jann Horn <jannh@google.com>
    floppy: fix usercopy direction

Amir Goldstein <amir73il@gmail.com>
    ovl: fix regression caused by overlapping layers detection

Nathan Chancellor <natechancellor@gmail.com>
    PCI: kirin: Fix section mismatch warning

Joerg Roedel <jroedel@suse.de>
    iommu/amd: Fix race in increase_address_space()

Stuart Hayes <stuart.w.hayes@gmail.com>
    iommu/amd: Flush old domains in kdump kernel

Hillf Danton <hdanton@sina.com>
    keys: Fix missing null pointer check in request_key_auth_describe()

Tianyu Lan <Tianyu.Lan@microsoft.com>
    x86/hyper-v: Fix overflow bug in fill_gva_list()

Peter Zijlstra <peterz@infradead.org>
    x86/uaccess: Don't leak the AC flags into __get_user() argument evaluation

Wenwen Wang <wenwen@cs.uga.edu>
    dmaengine: ti: omap-dma: Add cleanup in omap_dma_probe()

Wenwen Wang <wenwen@cs.uga.edu>
    dmaengine: ti: dma-crossbar: Fix a memory leak bug

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    net: seeq: Fix the function used to release some memory in an error handling path

Dmitry Bogdanov <dmitry.bogdanov@aquantia.com>
    net: aquantia: fix out of memory condition on rx side

Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
    tools/power turbostat: fix buffer overrun

Zephaniah E. Loss-Cutler-Hull <zephaniah@gmail.com>
    tools/power x86_energy_perf_policy: Fix argument parsing

Ben Hutchings <ben@decadent.org.uk>
    tools/power x86_energy_perf_policy: Fix "uninitialized variable" warnings at -O2

YueHaibing <yuehaibing@huawei.com>
    amd-xgbe: Fix error path in xgbe_mod_init()

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

Nagarjuna Kristam <nkristam@nvidia.com>
    usb: host: xhci-tegra: Set DMA mask correctly

Dan Carpenter <dan.carpenter@oracle.com>
    cifs: Use kzfree() to zero out the password

Ronnie Sahlberg <lsahlber@redhat.com>
    cifs: set domainName when a domain-key is used in multiuser

Marc Zyngier <maz@kernel.org>
    kallsyms: Don't let kallsyms_lookup_size_offset() fail on retrieving the first symbol

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFSv2: Fix write regression

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFSv2: Fix eof handling

Thomas Jarosch <thomas.jarosch@intra2net.com>
    netfilter: nf_conntrack_ftp: Fix debug output

Todd Seidelmann <tseidelmann@linode.com>
    netfilter: xt_physdev: Fix spurious error message in physdev_mt_check

Thomas Gleixner <tglx@linutronix.de>
    x86/apic: Fix arch_dynirq_lower_bound() bug for DT enabled machines

Prashant Malani <pmalani@chromium.org>
    r8152: Set memory to all 0xFFs on failed reg reads

Ilya Leoshkevich <iii@linux.ibm.com>
    bpf: allow narrow loads of some sk_reuseport_md fields with offset > 0

Sven Eckelmann <sven@narfation.org>
    batman-adv: Only read OGM2 tvlv_len after buffer len check

Doug Berger <opendmb@gmail.com>
    ARM: 8874/1: mm: only adjust sections of valid mm structures

Wenwen Wang <wenwen@cs.uga.edu>
    qed: Add cleanup in qed_slowpath_start()

Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
    xdp: unpin xdp umem pages in error path

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    Kconfig: Fix the reference to the IDT77105 Phy driver in the description of ATM_NICSTAR_USE_IDT77105

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

Suman Anna <s-anna@ti.com>
    bus: ti-sysc: Simplify cleanup upon failures in sysc_probe()

Janusz Krzysztofik <jmkrzyszt@gmail.com>
    ARM: OMAP1: ams-delta-fiq: Fix missing irq_ack

Faiz Abbas <faiz_abbas@ti.com>
    ARM: dts: dra74x: Fix iodelay configuration for mmc3

Tony Lindgren <tony@atomide.com>
    ARM: OMAP2+: Fix omap4 errata warning on other SoCs

Ilya Leoshkevich <iii@linux.ibm.com>
    s390/bpf: fix lcgr instruction encoding

Tony Lindgren <tony@atomide.com>
    bus: ti-sysc: Fix using configured sysc mask value

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

Cong Wang <xiyou.wangcong@gmail.com>
    net_sched: let qdisc_put() accept NULL pointer

Dongli Zhang <dongli.zhang@oracle.com>
    xen-netfront: do not assume sk_buff_head list is empty in error handling

Willem de Bruijn <willemb@google.com>
    udp: correct reuseport selection with connected sockets

Xin Long <lucien.xin@gmail.com>
    ip6_gre: fix a dst leak in ip6erspan_tunnel_xmit

Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
    phy: renesas: rcar-gen3-usb2: Disable clearing VBUS in over-current

Sean Young <sean@mess.org>
    media: tm6000: double free if usb disconnect while streaming

Alan Stern <stern@rowland.harvard.edu>
    USB: usbcore: Fix slab-out-of-bounds bug during device reset

Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
    powerpc/mm/radix: Use the right page size for vmemmap mapping

Benjamin Tissoires <benjamin.tissoires@redhat.com>
    Input: elan_i2c - remove Lenovo Legion Y7000 PnpID

Leon Romanovsky <leon@kernel.org>
    RDMA/restrack: Release task struct which was hold by CM_ID object

Aaron Armstrong Skomra <skomra@gmail.com>
    HID: wacom: generic: read HID_DG_CONTACTMAX from any feature report

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_flow_table: set default timeout after successful insertion


-------------

Diffstat:

 Documentation/filesystems/overlayfs.txt            |  2 +-
 Makefile                                           |  4 +-
 arch/arm/boot/dts/am571x-idk.dts                   |  7 +--
 arch/arm/boot/dts/am572x-idk.dts                   |  7 +--
 arch/arm/boot/dts/am574x-idk.dts                   |  7 +--
 arch/arm/boot/dts/am57xx-beagle-x15-common.dtsi    |  1 +
 arch/arm/boot/dts/am57xx-beagle-x15-revb1.dts      |  7 +--
 arch/arm/boot/dts/am57xx-beagle-x15-revc.dts       |  7 +--
 arch/arm/boot/dts/dra74x-mmc-iodelay.dtsi          | 50 +++++++--------
 arch/arm/mach-omap1/ams-delta-fiq-handler.S        |  3 +-
 arch/arm/mach-omap1/ams-delta-fiq.c                |  4 +-
 arch/arm/mach-omap2/omap4-common.c                 |  3 +
 arch/arm/mach-omap2/omap_hwmod_7xx_data.c          |  3 +-
 arch/arm/mm/init.c                                 |  8 ++-
 arch/arm64/kernel/cpufeature.c                     |  6 ++
 arch/powerpc/mm/pgtable-radix.c                    | 16 +++--
 arch/s390/net/bpf_jit_comp.c                       | 12 ++--
 arch/x86/events/amd/ibs.c                          | 13 +++-
 arch/x86/events/intel/core.c                       |  6 ++
 arch/x86/hyperv/mmu.c                              |  8 ++-
 arch/x86/include/asm/perf_event.h                  | 12 ++--
 arch/x86/include/asm/uaccess.h                     |  4 +-
 arch/x86/kernel/apic/io_apic.c                     |  8 ++-
 drivers/atm/Kconfig                                |  2 +-
 drivers/block/floppy.c                             |  4 +-
 drivers/bus/ti-sysc.c                              | 19 +++---
 drivers/dma/ti/dma-crossbar.c                      |  4 +-
 drivers/dma/ti/omap-dma.c                          |  4 +-
 drivers/firmware/google/vpd.c                      |  4 +-
 drivers/firmware/google/vpd_decode.c               | 55 +++++++++-------
 drivers/firmware/google/vpd_decode.h               |  6 +-
 drivers/fpga/altera-ps-spi.c                       | 11 ++--
 drivers/hid/wacom_sys.c                            | 10 +--
 drivers/hid/wacom_wac.c                            |  4 ++
 drivers/i2c/busses/i2c-designware-slave.c          |  1 +
 drivers/infiniband/core/cma.c                      |  7 +--
 drivers/infiniband/core/restrack.c                 |  6 +-
 drivers/input/mouse/elan_i2c_core.c                |  2 +-
 drivers/iommu/amd_iommu.c                          | 40 ++++++++++--
 drivers/media/usb/dvb-usb/technisat-usb2.c         | 22 +++----
 drivers/media/usb/tm6000/tm6000-dvb.c              |  3 +
 drivers/net/ethernet/amd/xgbe/xgbe-main.c          | 10 ++-
 drivers/net/ethernet/aquantia/atlantic/aq_vec.c    |  3 +-
 drivers/net/ethernet/ibm/ibmvnic.c                 |  6 +-
 drivers/net/ethernet/marvell/sky2.c                |  7 +++
 drivers/net/ethernet/qlogic/qed/qed_main.c         |  4 +-
 drivers/net/ethernet/seeq/sgiseeq.c                |  7 ++-
 drivers/net/ieee802154/mac802154_hwsim.c           |  8 ++-
 drivers/net/usb/r8152.c                            |  5 +-
 drivers/net/wireless/marvell/mwifiex/ie.c          |  3 +
 drivers/net/wireless/marvell/mwifiex/uap_cmd.c     |  9 ++-
 drivers/net/xen-netfront.c                         |  2 +-
 drivers/pci/controller/dwc/pcie-kirin.c            |  4 +-
 drivers/phy/renesas/phy-rcar-gen3-usb2.c           |  2 +
 drivers/tty/serial/atmel_serial.c                  |  1 -
 drivers/tty/serial/sprd_serial.c                   |  2 +-
 drivers/usb/core/config.c                          | 12 ++--
 drivers/usb/host/xhci-tegra.c                      | 10 +++
 fs/binfmt_elf.c                                    | 11 ++++
 fs/cifs/connect.c                                  | 22 +++++++
 fs/nfs/dir.c                                       |  2 +-
 fs/nfs/nfs4file.c                                  | 12 ++--
 fs/nfs/pagelist.c                                  |  2 +-
 fs/nfs/proc.c                                      |  7 ++-
 fs/overlayfs/ovl_entry.h                           |  1 +
 fs/overlayfs/super.c                               | 73 ++++++++++++++--------
 include/net/sock_reuseport.h                       | 21 ++++++-
 include/uapi/linux/netfilter/xt_nfacct.h           |  5 ++
 kernel/kallsyms.c                                  |  6 +-
 net/batman-adv/bat_v_ogm.c                         | 18 ++++--
 net/bridge/netfilter/ebtables.c                    |  8 +--
 net/core/filter.c                                  |  8 +--
 net/core/sock_reuseport.c                          | 15 ++++-
 net/ipv4/datagram.c                                |  2 +
 net/ipv4/udp.c                                     |  5 +-
 net/ipv6/datagram.c                                |  2 +
 net/ipv6/ip6_gre.c                                 |  2 +-
 net/ipv6/udp.c                                     |  5 +-
 net/netfilter/nf_conntrack_ftp.c                   |  2 +-
 net/netfilter/nf_flow_table_core.c                 |  2 +-
 net/netfilter/nft_flow_offload.c                   |  6 ++
 net/netfilter/xt_nfacct.c                          | 36 +++++++----
 net/netfilter/xt_physdev.c                         |  6 +-
 net/sched/sch_generic.c                            |  3 +
 net/wireless/nl80211.c                             |  4 +-
 net/xdp/xdp_umem.c                                 |  4 +-
 security/keys/request_key_auth.c                   |  6 ++
 tools/bpf/bpftool/prog.c                           |  4 +-
 tools/power/x86/turbostat/turbostat.c              |  2 +-
 .../x86_energy_perf_policy.c                       | 28 +++++----
 tools/testing/selftests/bpf/test_sock.c            |  7 ++-
 virt/kvm/coalesced_mmio.c                          | 17 ++---
 92 files changed, 561 insertions(+), 290 deletions(-)


