Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D382D441840
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 10:43:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232513AbhKAJpX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 05:45:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:48168 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233468AbhKAJmK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Nov 2021 05:42:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9687961391;
        Mon,  1 Nov 2021 09:28:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635758924;
        bh=xUY/XD70XYktadYtapRMLANWtwGmFo4Q/1xTkmLq1xs=;
        h=From:To:Cc:Subject:Date:From;
        b=SU3L2uKmAvOvOEeIOA7QpWtGB9P/t2zJcVNC4DvfxJQ4pRCHx4T5LQ25TDMKPlxur
         DY3MCRbSDSrgu9kWXn55+75Lp5kMPd5m+p4p59NK6/mAcGGPiqzDlRqH8G0Xmk1bfv
         feSzxnvyqsJv8rP3d6XLuDkjFWmbYlEd/TvlK5iw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 5.14 000/125] 5.14.16-rc1 review
Date:   Mon,  1 Nov 2021 10:16:13 +0100
Message-Id: <20211101082533.618411490@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.14.16-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.14.16-rc1
X-KernelTest-Deadline: 2021-11-03T08:25+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.14.16 release.
There are 125 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 03 Nov 2021 08:24:20 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.14.16-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.14.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.14.16-rc1

David Woodhouse <dwmw@amazon.co.uk>
    KVM: x86: Take srcu lock in post_kvm_run_save()

Paolo Bonzini <pbonzini@redhat.com>
    KVM: SEV-ES: fix another issue with string I/O VMGEXITs

David Woodhouse <dwmw@amazon.co.uk>
    KVM: x86: switch pvclock_gtod_sync_lock to a raw spinlock

David Woodhouse <dwmw@amazon.co.uk>
    KVM: x86/xen: Fix kvm_xen_has_interrupt() sleeping in kvm_vcpu_block()

Song Liu <songliubraving@fb.com>
    perf script: Check session->header.env.arch before using it

Alexandre Ghiti <alexandre.ghiti@canonical.com>
    riscv: Fix asan-stack clang build

Alexandre Ghiti <alexandre.ghiti@canonical.com>
    riscv: Do not re-populate shadow memory with kasan_populate_early_shadow

Chen Lu <181250012@smail.nju.edu.cn>
    riscv: fix misalgned trap vector base address

Brian King <brking@linux.vnet.ibm.com>
    scsi: ibmvfc: Fix up duplicate response detection

Kan Liang <kan.liang@linux.intel.com>
    perf script: Fix PERF_SAMPLE_WEIGHT_STRUCT support

Chanho Park <chanho61.park@samsung.com>
    scsi: ufs: ufs-exynos: Correct timeout value setting registers

Halil Pasic <pasic@linux.ibm.com>
    KVM: s390: preserve deliverable_mask in __airqs_kick_single_vcpu

Halil Pasic <pasic@linux.ibm.com>
    KVM: s390: clear kicked_mask before sleeping again

Subbaraya Sundeep <sbhatta@marvell.com>
    octeontx2-af: Check whether ipolicers exists

Vincent Whitchurch <vincent.whitchurch@axis.com>
    virtio-ring: fix DMA metadata flags

Guangbin Huang <huangguangbin2@huawei.com>
    net: hns3: expand buffer len for some debugfs command

Jie Wang <wangjie125@huawei.com>
    net: hns3: add more string spaces for dumping packets number of queue info in debugfs

Tejun Heo <tj@kernel.org>
    bpf: Move BPF_MAP_TYPE for INODE_STORAGE and TASK_STORAGE outside of CONFIG_NET

Jamie Iles <quic_jiles@quicinc.com>
    watchdog: sbsa: only use 32-bit accessors

Stanislav Fomichev <sdf@google.com>
    bpf: Use kvmalloc for map values in syscall

Xin Long <lucien.xin@gmail.com>
    sctp: add vtag check in sctp_sf_ootb

Xin Long <lucien.xin@gmail.com>
    sctp: add vtag check in sctp_sf_do_8_5_1_E_sa

Xin Long <lucien.xin@gmail.com>
    sctp: add vtag check in sctp_sf_violation

Xin Long <lucien.xin@gmail.com>
    sctp: fix the processing for COOKIE_ECHO chunk

Xin Long <lucien.xin@gmail.com>
    sctp: fix the processing for INIT_ACK chunk

Xin Long <lucien.xin@gmail.com>
    sctp: fix the processing for INIT chunk

Xin Long <lucien.xin@gmail.com>
    sctp: use init_tag from inithdr for ABORT chunk

Mustafa Ismail <mustafa.ismail@intel.com>
    RDMA/irdma: Do not hold qos mutex twice on QP resume

Mustafa Ismail <mustafa.ismail@intel.com>
    RDMA/irdma: Set VLAN in UD work completion correctly

Shiraz Saleem <shiraz.saleem@intel.com>
    RDMA/irdma: Process extended CQ entries correctly

Andrew Lunn <andrew@lunn.ch>
    phy: phy_ethtool_ksettings_set: Lock the PHY while changing settings

Andrew Lunn <andrew@lunn.ch>
    phy: phy_start_aneg: Add an unlocked version

Andrew Lunn <andrew@lunn.ch>
    phy: phy_ethtool_ksettings_set: Move after phy_start_aneg

Andrew Lunn <andrew@lunn.ch>
    phy: phy_ethtool_ksettings_get: Lock the phy for consistency

Daniel Jordan <daniel.m.jordan@oracle.com>
    net/tls: Fix flipped sign in async_wait.err assignment

Yuiko Oshino <yuiko.oshino@microchip.com>
    net: ethernet: microchip: lan743x: Fix skb allocation failure

Jie Wang <wangjie125@huawei.com>
    net: hns3: fix data endian problem of some functions of debugfs

Guangbin Huang <huangguangbin2@huawei.com>
    net: hns3: fix pause config problem after autoneg disabled

Trevor Woerner <twoerner@gmail.com>
    net: nxp: lpc_eth.c: avoid hang when bringing interface down

Yuiko Oshino <yuiko.oshino@microchip.com>
    net: ethernet: microchip: lan743x: Fix dma allocation failure by using dma_set_mask_and_coherent

Yuiko Oshino <yuiko.oshino@microchip.com>
    net: ethernet: microchip: lan743x: Fix driver crash when lan743x_pm_resume fails

Ido Schimmel <idosch@nvidia.com>
    mlxsw: pci: Recycle received packet upon allocation failure

Guenter Roeck <linux@roeck-us.net>
    nios2: Make NIOS2_DTB_SOURCE_BOOL depend on !COMPILE_TEST

Jonas Gorski <jonas.gorski@gmail.com>
    gpio: xgs-iproc: fix parsing of ngpios property

Mark Zhang <markzhang@nvidia.com>
    RDMA/sa_query: Use strscpy_pad instead of memcpy to copy a string

Aharon Landau <aharonl@nvidia.com>
    RDMA/mlx5: Initialize the ODP xarray when creating an ODP MR

Michael Chan <michael.chan@broadcom.com>
    net: Prevent infinite while loop in skb_tx_hash()

Janusz Dziedzic <janusz.dziedzic@gmail.com>
    cfg80211: correct bridge/4addr mode check

Xin Long <lucien.xin@gmail.com>
    net-sysfs: initialize uid and gid before calling net_ns_get_ownership

Pavel Skripkin <paskripkin@gmail.com>
    net: batman-adv: fix error handling

Yang Yingliang <yangyingliang@huawei.com>
    regmap: Fix possible double-free in regcache_rbtree_exit()

Jim Quinlan <jim2101024@gmail.com>
    reset: brcmstb-rescal: fix incorrect polarity of status bit

Clément Bœsch <u@pkh.me>
    arm64: dts: allwinner: h5: NanoPI Neo 2: Fix ethernet node

Yongxin Liu <yongxin.liu@windriver.com>
    ice: check whether PTP is initialized in ice_ptp_release()

Patrisious Haddad <phaddad@nvidia.com>
    RDMA/mlx5: Set user priority for DCT

Dave Ertman <david.m.ertman@intel.com>
    ice: Respond to a NETDEV_UNREGISTER event for LAG

Rakesh Babu Saladi <rsaladi2@marvell.com>
    octeontx2-af: Fix possible null pointer dereference.

Rakesh Babu <rsaladi2@marvell.com>
    octeontx2-af: Display all enabled PF VF rsrc_alloc entries.

Varun Prakash <varun@chelsio.com>
    nvme-tcp: fix possible req->offset corruption

Varun Prakash <varun@chelsio.com>
    nvme-tcp: fix data digest pointer calculation

Varun Prakash <varun@chelsio.com>
    nvmet-tcp: fix data digest pointer calculation

Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>
    IB/hfi1: Fix abba locking issue with sc_disable()

Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>
    IB/qib: Protect from buffer overflow in struct qib_user_sdma_pkt fields

Xu Kuohai <xukuohai@huawei.com>
    bpf: Fix error usage of map_fd and fdget() in generic_map_update_batch()

Toke Høiland-Jørgensen <toke@redhat.com>
    bpf: Fix potential race in tail call compatibility check

Liu Jian <liujian56@huawei.com>
    tcp_bpf: Fix one concurrency problem in the tcp_bpf_send_verdict function

Björn Töpel <bjorn@kernel.org>
    riscv, bpf: Fix potential NULL dereference

Quanyang Wang <quanyang.wang@windriver.com>
    cgroup: Fix memory leak caused by missing cgroup_bpf_offline

Guenter Roeck <linux@roeck-us.net>
    Revert "watchdog: iTCO_wdt: Account for rebooting on second timeout"

Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
    drm/amd/display: Fix deadlock when falling back to v2 from v3

Michael Strauss <michael.strauss@amd.com>
    drm/amd/display: Fallback to clocks which meet requested voltage on DCN31

Jake Wang <haonan.wang2@amd.com>
    drm/amd/display: Moved dccg init to after bios golden init

Nikola Cornij <nikola.cornij@amd.com>
    drm/amd/display: Increase watermark latencies for DCN3.1

Eric Yang <Eric.Yang2@amd.com>
    drm/amd/display: increase Z9 latency to workaround underflow in Z9

Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
    drm/amd/display: Fix prefetch bandwidth calculation for DCN3.1

Nikola Cornij <nikola.cornij@amd.com>
    drm/amd/display: Limit display scaling to up to true 4k for DCN 3.1

Aaron Liu <aaron.liu@amd.com>
    drm/amdgpu: support B0&B1 external revision id for yellow carp

Thelford Williams <tdwilliamsiv@gmail.com>
    drm/amdgpu: fix out of bounds write

Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
    drm/amdgpu: Fix even more out of bound writes from debugfs

Imre Deak <imre.deak@intel.com>
    drm/i915/dp: Skip the HW readout of DPCD on disabled encoders

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/i915: Catch yet another unconditioal clflush

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/i915: Convert unconditional clflush to drm_clflush_virt_range()

Christian König <christian.koenig@amd.com>
    drm/ttm: fix memleak in ttm_transfered_destroy

Johannes Berg <johannes.berg@intel.com>
    mac80211: mesh: fix HE operation element length check

Frieder Schrempf <frieder.schrempf@kontron.de>
    arm64: dts: imx8mm-kontron: Make sure SOC and DRAM supply voltages are correct

Frieder Schrempf <frieder.schrempf@kontron.de>
    arm64: dts: imx8mm-kontron: Set lower limit of VDD_SNVS to 800 mV

Frieder Schrempf <frieder.schrempf@kontron.de>
    arm64: dts: imx8mm-kontron: Fix connection type for VSC8531 RGMII PHY

Frieder Schrempf <frieder.schrempf@kontron.de>
    arm64: dts: imx8mm-kontron: Fix CAN SPI clock frequency

Frieder Schrempf <frieder.schrempf@kontron.de>
    arm64: dts: imx8mm-kontron: Fix polarity of reg_rst_eth2

Yang Shi <shy828301@gmail.com>
    mm: khugepaged: skip huge page collapse for special files

Rongwei Wang <rongwei.wang@linux.alibaba.com>
    mm, thp: bail out early in collapse_file for writeback page

Yang Shi <shy828301@gmail.com>
    mm: filemap: check if THP has hwpoisoned subpage for PMD page fault

Yang Shi <shy828301@gmail.com>
    mm: hwpoison: remove the unnecessary THP check

Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
    drm/amd/display: Require immediate flip support for DCN3.1 planes

Johan Hovold <johan@kernel.org>
    net: lan78xx: fix division by zero in send path

Johannes Berg <johannes.berg@intel.com>
    cfg80211: fix management registrations locking

Johannes Berg <johannes.berg@intel.com>
    cfg80211: scan: fix RCU in cfg80211_add_nontrans_list()

Steven Rostedt (VMware) <rostedt@goodmis.org>
    ftrace/nds32: Update the proto for ftrace_trace_function to match ftrace_stub

Sagi Grimberg <sagi@grimberg.me>
    nvme-tcp: fix H2CData PDU send accounting (again)

Gautham Ananthakrishna <gautham.ananthakrishna@oracle.com>
    ocfs2: fix race between searching chunks and release journal_head from buffer_head

Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
    block: Fix partition check for host-aware zoned block devices

Haibo Chen <haibo.chen@nxp.com>
    mmc: sdhci-esdhc-imx: clear the buffer_read_ready to reset standard tuning circuit

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    mmc: sdhci-pci: Read card detect from ACPI for Intel Merrifield

Shawn Guo <shawn.guo@linaro.org>
    mmc: sdhci: Map more voltage level to SDHCI_POWER_330

Jaehoon Chung <jh80.chung@samsung.com>
    mmc: dw_mmc: exynos: fix the finding clock sample value

Wolfram Sang <wsa+renesas@sang-engineering.com>
    mmc: tmio: reenable card irqs after the reset callback

Wenbin Mei <wenbin.mei@mediatek.com>
    mmc: mediatek: Move cqhci init behind ungate clock

Wenbin Mei <wenbin.mei@mediatek.com>
    mmc: cqhci: clear HALT state after CQE enable

Johan Hovold <johan@kernel.org>
    mmc: vub300: fix control-message timeouts

Daniel Jordan <daniel.m.jordan@oracle.com>
    net/tls: Fix flipped sign in tls_err_abort() calls

Pavel Skripkin <paskripkin@gmail.com>
    Revert "net: mdiobus: Fix memory leak in __mdiobus_register"

Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
    nfc: port100: fix using -ERRNO as command type mask

Max VA <maxv@sentinelone.com>
    tipc: fix size validations for the MSG_CRYPTO type

Zheyu Ma <zheyuma97@gmail.com>
    ata: sata_mv: Fix the error handling of mv_chip_id()

Sachi King <nakato@nakato.io>
    pinctrl: amd: disable and mask interrupts on probe

Rafał Miłecki <rafal@milecki.pl>
    Revert "pinctrl: bcm: ns: support updated DT binding as syscon subnode"

Wang Hai <wanghai38@huawei.com>
    usbnet: fix error return code in usbnet_probe()

Oliver Neukum <oneukum@suse.com>
    usbnet: sanity check for maxpacket

LABBE Corentin <clabbe.montjoie@gmail.com>
    ARM: 9148/1: handle CONFIG_CPU_ENDIAN_BE32 in arch/arm/kernel/head.S

Arnd Bergmann <arnd@arndb.de>
    ARM: 9141/1: only warn about XIP address when not compile testing

Arnd Bergmann <arnd@arndb.de>
    ARM: 9139/1: kprobes: fix arch_init_kprobes() prototype

Arnd Bergmann <arnd@arndb.de>
    ARM: 9138/1: fix link warning with XIP + frame-pointer

Arnd Bergmann <arnd@arndb.de>
    ARM: 9134/1: remove duplicate memcpy() definition

Nick Desaulniers <ndesaulniers@google.com>
    ARM: 9133/1: mm: proc-macros: ensure *_tlb_fns are 4B aligned

Lexi Shao <shaolexi@huawei.com>
    ARM: 9132/1: Fix __get_user_check failure with ARM KASAN images


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/arm/boot/compressed/decompress.c              |   3 +
 arch/arm/include/asm/uaccess.h                     |   4 +-
 arch/arm/kernel/head.S                             |   4 +-
 arch/arm/kernel/vmlinux-xip.lds.S                  |   6 +-
 arch/arm/mm/proc-macros.S                          |   1 +
 arch/arm/probes/kprobes/core.c                     |   2 +-
 .../boot/dts/allwinner/sun50i-h5-nanopi-neo2.dts   |   2 +-
 .../boot/dts/freescale/imx8mm-kontron-n801x-s.dts  |   8 +-
 .../dts/freescale/imx8mm-kontron-n801x-som.dtsi    |   8 +-
 arch/nds32/kernel/ftrace.c                         |   2 +-
 arch/nios2/platform/Kconfig.platform               |   1 +
 arch/riscv/Kconfig                                 |   6 +
 arch/riscv/include/asm/kasan.h                     |   3 +-
 arch/riscv/kernel/head.S                           |   1 +
 arch/riscv/mm/kasan_init.c                         |  14 +-
 arch/riscv/net/bpf_jit_core.c                      |   3 +-
 arch/s390/kvm/interrupt.c                          |   5 +-
 arch/s390/kvm/kvm-s390.c                           |   1 +
 arch/x86/include/asm/kvm_host.h                    |   2 +-
 arch/x86/kvm/svm/sev.c                             |  15 ++-
 arch/x86/kvm/x86.c                                 |  36 +++--
 arch/x86/kvm/xen.c                                 |  27 +++-
 block/blk-settings.c                               |  20 ++-
 drivers/ata/sata_mv.c                              |   4 +-
 drivers/base/regmap/regcache-rbtree.c              |   7 +-
 drivers/gpio/gpio-xgs-iproc.c                      |   2 +-
 drivers/gpu/drm/amd/amdgpu/nv.c                    |   2 +-
 .../drm/amd/display/amdgpu_dm/amdgpu_dm_debugfs.c  |  20 +--
 .../amd/display/dc/clk_mgr/dcn31/dcn31_clk_mgr.c   |  29 ++--
 drivers/gpu/drm/amd/display/dc/dcn31/dcn31_hwseq.c |   7 +-
 .../gpu/drm/amd/display/dc/dcn31/dcn31_resource.c  |  13 +-
 .../amd/display/dc/dml/dcn31/display_mode_vba_31.c |   6 +-
 drivers/gpu/drm/amd/display/include/dal_asic_id.h  |   2 +-
 .../gpu/drm/amd/display/modules/hdcp/hdcp_psp.c    |   6 +-
 drivers/gpu/drm/i915/display/intel_dp.c            |   3 +
 drivers/gpu/drm/i915/gt/intel_timeline.c           |   4 +-
 drivers/gpu/drm/ttm/ttm_bo_util.c                  |   1 +
 drivers/infiniband/core/sa_query.c                 |   5 +-
 drivers/infiniband/hw/hfi1/pio.c                   |   9 +-
 drivers/infiniband/hw/irdma/uk.c                   |   4 +-
 drivers/infiniband/hw/irdma/verbs.c                |   8 +-
 drivers/infiniband/hw/irdma/ws.c                   |  13 +-
 drivers/infiniband/hw/mlx5/mr.c                    |   2 +-
 drivers/infiniband/hw/mlx5/qp.c                    |   2 +
 drivers/infiniband/hw/qib/qib_user_sdma.c          |  33 +++--
 drivers/mmc/host/cqhci-core.c                      |   3 +
 drivers/mmc/host/dw_mmc-exynos.c                   |  14 ++
 drivers/mmc/host/mtk-sd.c                          |  38 +++---
 drivers/mmc/host/sdhci-esdhc-imx.c                 |  16 +++
 drivers/mmc/host/sdhci-pci-core.c                  |  29 +++-
 drivers/mmc/host/sdhci.c                           |   6 +
 drivers/mmc/host/tmio_mmc_core.c                   |  17 ++-
 drivers/mmc/host/vub300.c                          |  18 +--
 drivers/net/ethernet/hisilicon/hns3/hnae3.h        |   1 +
 drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c |  10 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c |  33 +++--
 .../ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c |  30 ++---
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    |  30 +++++
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c  |   2 +-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.h  |   1 +
 drivers/net/ethernet/intel/ice/ice_lag.c           |  18 +--
 drivers/net/ethernet/intel/ice/ice_ptp.c           |   3 +
 .../ethernet/marvell/octeontx2/af/rvu_debugfs.c    | 148 ++++++++++++++++-----
 .../net/ethernet/marvell/octeontx2/af/rvu_nix.c    |   3 +
 drivers/net/ethernet/mellanox/mlxsw/pci.c          |  25 ++--
 drivers/net/ethernet/microchip/lan743x_main.c      |  35 ++++-
 drivers/net/ethernet/nxp/lpc_eth.c                 |   5 +-
 drivers/net/phy/mdio_bus.c                         |   1 -
 drivers/net/phy/phy.c                              | 140 +++++++++++--------
 drivers/net/usb/lan78xx.c                          |   6 +
 drivers/net/usb/usbnet.c                           |   5 +
 drivers/nfc/port100.c                              |   4 +-
 drivers/nvme/host/tcp.c                            |   9 +-
 drivers/nvme/target/tcp.c                          |   2 +-
 drivers/pinctrl/bcm/pinctrl-ns.c                   |  29 ++--
 drivers/pinctrl/pinctrl-amd.c                      |  31 +++++
 drivers/reset/reset-brcmstb-rescal.c               |   2 +-
 drivers/scsi/ibmvscsi/ibmvfc.c                     |   3 +-
 drivers/scsi/ufs/ufs-exynos.c                      |   6 +-
 drivers/virtio/virtio_ring.c                       |   2 +-
 drivers/watchdog/iTCO_wdt.c                        |  12 +-
 drivers/watchdog/sbsa_gwdt.c                       |   4 +-
 fs/ocfs2/suballoc.c                                |  22 +--
 include/linux/bpf.h                                |   7 +-
 include/linux/bpf_types.h                          |   8 +-
 include/linux/page-flags.h                         |  23 ++++
 include/net/cfg80211.h                             |   2 -
 include/net/tls.h                                  |   9 +-
 kernel/bpf/arraymap.c                              |   1 +
 kernel/bpf/core.c                                  |  20 ++-
 kernel/bpf/syscall.c                               |  39 +++---
 kernel/cgroup/cgroup.c                             |   4 +-
 mm/huge_memory.c                                   |   2 +
 mm/khugepaged.c                                    |  26 ++--
 mm/memory-failure.c                                |  28 ++--
 mm/memory.c                                        |   9 ++
 mm/page_alloc.c                                    |   4 +-
 net/batman-adv/bridge_loop_avoidance.c             |   8 +-
 net/batman-adv/main.c                              |  56 +++++---
 net/batman-adv/network-coding.c                    |   4 +-
 net/batman-adv/translation-table.c                 |   4 +-
 net/core/dev.c                                     |   6 +
 net/core/net-sysfs.c                               |   4 +-
 net/ipv4/tcp_bpf.c                                 |  12 ++
 net/mac80211/mesh.c                                |   9 +-
 net/sctp/sm_statefuns.c                            | 139 +++++++++++--------
 net/tipc/crypto.c                                  |  32 +++--
 net/tls/tls_sw.c                                   |  19 ++-
 net/wireless/core.c                                |   2 +-
 net/wireless/core.h                                |   2 +
 net/wireless/mlme.c                                |  26 ++--
 net/wireless/scan.c                                |   7 +-
 net/wireless/util.c                                |  14 +-
 tools/perf/builtin-script.c                        |  14 +-
 115 files changed, 1098 insertions(+), 565 deletions(-)


