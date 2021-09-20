Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BCF541211C
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:00:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346105AbhITSCA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:02:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:57650 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1356432AbhITR7z (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 13:59:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5EC83619A6;
        Mon, 20 Sep 2021 17:15:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632158139;
        bh=8sm/9+NGdDav55+GK32WzlKaRImOdOk3tlOvOEIrU60=;
        h=From:To:Cc:Subject:Date:From;
        b=mzuhjpRJpD9dRSaGKT70kWLikdsNeGLqwDhpA1OTaLKejGRDZP9hAzIPxRdLT0JVG
         ZQ5nprr/G5oXez/c+f6qAZcmDi0Rz8QS7oCkZOWgUc65BLH/D+UgpKH0337fcccj35
         pSzH8wL5cbxNgGgG9hoO3lqGAA1FpR9aehfgN+YQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 5.4 000/260] 5.4.148-rc1 review
Date:   Mon, 20 Sep 2021 18:40:18 +0200
Message-Id: <20210920163931.123590023@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.148-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.148-rc1
X-KernelTest-Deadline: 2021-09-22T16:39+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.4.148 release.
There are 260 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 22 Sep 2021 16:38:49 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.148-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.4.148-rc1

Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
    net: renesas: sh_eth: Fix freeing wrong tx descriptor

Willem de Bruijn <willemb@google.com>
    ip_gre: validate csum_start only on pull

Dinghao Liu <dinghao.liu@zju.edu.cn>
    qlcnic: Remove redundant unlock in qlcnic_pinit_from_rom

Eric Dumazet <edumazet@google.com>
    fq_codel: reject silly quantum parameters

Benjamin Hesmans <benjamin.hesmans@tessares.net>
    netfilter: socket: icmp6: fix use-after-scope

Rafał Miłecki <rafal@milecki.pl>
    net: dsa: b53: Fix calculating number of switch ports

Li Huafei <lihuafei1@huawei.com>
    perf unwind: Do not overwrite FEATURE_CHECK_LDFLAGS-libunwind-{x86,aarch64}

Randy Dunlap <rdunlap@infradead.org>
    ARC: export clear_user_page() for modules

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    mtd: rawnand: cafe: Fix a resource leak in the error handling path of 'cafe_nand_probe()'

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    PCI: Sync __pci_register_driver() stub for CONFIG_PCI=n

Oliver Upton <oupton@google.com>
    KVM: arm64: Handle PSCI resets before userspace touches vCPU state

Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
    mfd: tqmx86: Clear GPIO IRQ resource when no IRQ is set

Dan Carpenter <dan.carpenter@oracle.com>
    PCI: Fix pci_dev_str_match_path() alloc while atomic bug

Hans de Goede <hdegoede@redhat.com>
    mfd: axp20x: Update AXP288 volatile ranges

Yang Li <yang.lee@linux.alibaba.com>
    NTB: perf: Fix an error code in perf_setup_inbuf()

Yang Li <yang.lee@linux.alibaba.com>
    NTB: Fix an error code in ntb_msit_probe()

Yang Li <yang.lee@linux.alibaba.com>
    ethtool: Fix an error code in cxgb2.c

Vishal Aslot <os.vaslot@gmail.com>
    PCI: ibmphp: Fix double unmap of io_mem

Paolo Valente <paolo.valente@linaro.org>
    block, bfq: honor already-setup queue merges

Daniele Palmas <dnlplm@gmail.com>
    net: usb: cdc_mbim: avoid altsetting toggling for Telit LN920

Ryoga Saito <contact@proelbtn.com>
    Set fc_nlinfo in nh_create_ipv4, nh_create_ipv6

George Cherian <george.cherian@marvell.com>
    PCI: Add ACS quirks for Cavium multi-function devices

Masami Hiramatsu <mhiramat@kernel.org>
    tracing/probes: Reject events which have the same name of existing one

Marc Zyngier <maz@kernel.org>
    mfd: Don't use irq_create_mapping() to resolve a mapping

Miklos Szeredi <mszeredi@redhat.com>
    fuse: fix use after free in fuse_read_interrupt()

Wasim Khan <wasim.khan@nxp.com>
    PCI: Add ACS quirks for NXP LX2xx0 and LX2xx2 platforms

Linus Walleij <linus.walleij@linaro.org>
    mfd: db8500-prcmu: Adjust map to reality

Miquel Raynal <miquel.raynal@bootlin.com>
    dt-bindings: mtd: gpmc: Fix the ECC bytes vs. OOB bytes equation

David Hildenbrand <david@redhat.com>
    mm/memory_hotplug: use "unsigned long" for PFN in zone_for_pfn_range()

Jiaran Zhang <zhangjiaran@huawei.com>
    net: hns3: fix the timing issue of VF clearing interrupt sources

Yufeng Mo <moyufeng@huawei.com>
    net: hns3: disable mac in flr process

Yufeng Mo <moyufeng@huawei.com>
    net: hns3: change affinity_mask to numa node range

Yufeng Mo <moyufeng@huawei.com>
    net: hns3: pad the short tunnel frame before sending to hardware

Nicholas Piggin <npiggin@gmail.com>
    KVM: PPC: Book3S HV: Tolerate treclaim. in fake-suspend mode changing registers

Sukadev Bhattiprolu <sukadev@linux.ibm.com>
    ibmvnic: check failover_pending in login response

David Heidelberg <david@ixit.cz>
    dt-bindings: arm: Fix Toradex compatible typo

Shai Malin <smalin@marvell.com>
    qed: Handle management FW error

zhenggy <zhenggy@chinatelecom.cn>
    tcp: fix tp->undo_retrans accounting in tcp_sacktag_one()

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dsa: destroy the phylink instance on any error in dsa_slave_phy_setup

Eric Dumazet <edumazet@google.com>
    net/af_unix: fix a data-race in unix_dgram_poll

Paolo Abeni <pabeni@redhat.com>
    vhost_net: fix OoB on sendmsg() failure.

Baptiste Lepers <baptiste.lepers@gmail.com>
    events: Reuse value read using READ_ONCE instead of re-reading it

Maor Gottlieb <maorg@nvidia.com>
    net/mlx5: Fix potential sleeping in atomic context

Saeed Mahameed <saeedm@nvidia.com>
    net/mlx5: FWTrace, cancel work on alloc pd error flow

Michael Petlan <mpetlan@redhat.com>
    perf machine: Initialize srcline string member in add_location struct

Hoang Le <hoang.h.le@dektech.com.au>
    tipc: increase timeout in tipc_sk_enqueue()

Florian Fainelli <f.fainelli@gmail.com>
    r6040: Restore MDIO clock frequency after MAC reset

Xiyu Yang <xiyuyang19@fudan.edu.cn>
    net/l2tp: Fix reference count leak in l2tp_udp_recv_core

Lin, Zhenpeng <zplin@psu.edu>
    dccp: don't duplicate ccid when cloning dccp sock

Randy Dunlap <rdunlap@infradead.org>
    ptp: dp83640: don't define PAGE0

Eric Dumazet <edumazet@google.com>
    net-caif: avoid user-triggerable WARN_ON(1)

Xin Long <lucien.xin@gmail.com>
    tipc: fix an use-after-free issue in tipc_recvmsg

Mike Rapoport <rppt@linux.ibm.com>
    x86/mm: Fix kern_addr_valid() to cope with existing but not present entries

Alexander Egorenkov <egorenar@linux.ibm.com>
    s390/sclp: fix Secure-IPL facility detection

Lucas Stach <l.stach@pengutronix.de>
    drm/etnaviv: add missing MMU context put when reaping MMU mapping

Lucas Stach <l.stach@pengutronix.de>
    drm/etnaviv: reference MMU context when setting up hardware state

Lucas Stach <l.stach@pengutronix.de>
    drm/etnaviv: fix MMU context leak on GPU reset

Lucas Stach <l.stach@pengutronix.de>
    drm/etnaviv: exec and MMU state is lost when resetting the GPU

Lucas Stach <l.stach@pengutronix.de>
    drm/etnaviv: keep MMU context across runtime suspend/resume

Lucas Stach <l.stach@pengutronix.de>
    drm/etnaviv: stop abusing mmu_context as FE running marker

Lucas Stach <l.stach@pengutronix.de>
    drm/etnaviv: put submit prev MMU context when it exists

Lucas Stach <l.stach@pengutronix.de>
    drm/etnaviv: return context from etnaviv_iommu_context_get

Ernst Sjöstrand <ernstp@gmail.com>
    drm/amd/amdgpu: Increase HWIP_MAX_INSTANCE to 10

Evan Quan <evan.quan@amd.com>
    PCI: Add AMD GPU multi-function power dependencies

Juergen Gross <jgross@suse.com>
    PM: base: power: don't try to use non-existing RTC for storing data

Mark Brown <broonie@kernel.org>
    arm64/sve: Use correct size when reinitialising SVE state

Adrian Bunk <bunk@kernel.org>
    bnx2x: Fix enabling network interfaces without VFs

Juergen Gross <jgross@suse.com>
    xen: reset legacy rtc flag for PV domU

Anand Jain <anand.jain@oracle.com>
    btrfs: fix upper limit for max_inline for page size 64K

Alyssa Rosenzweig <alyssa.rosenzweig@collabora.com>
    drm/panfrost: Clamp lock region to Bifrost minimum

Alyssa Rosenzweig <alyssa.rosenzweig@collabora.com>
    drm/panfrost: Use u64 for size in lock_region

Alyssa Rosenzweig <alyssa.rosenzweig@collabora.com>
    drm/panfrost: Simplify lock_region calculation

Andrey Grodzovsky <andrey.grodzovsky@amd.com>
    drm/amdgpu: Fix BUG_ON assert

David Heidelberg <david@ixit.cz>
    drm/msi/mdp4: populate priv->kms in mdp4_kms_init

Jan Hoffmann <jan@3e8.eu>
    net: dsa: lantiq_gswip: fix maximum frame length

Kees Cook <keescook@chromium.org>
    lib/test_stackinit: Fix static initializer test

Patryk Duda <pdk@semihalf.com>
    platform/chrome: cros_ec_proto: Send command again when timeout occurs

Vasily Averin <vvs@virtuozzo.com>
    memcg: enable accounting for pids in nested pid namespaces

Rik van Riel <riel@surriel.com>
    mm,vmscan: fix divide by zero in get_scan_count

Liu Zixian <liuzixian4@huawei.com>
    mm/hugetlb: initialize hugetlb_usage in mm_init

Halil Pasic <pasic@linux.ibm.com>
    s390/pv: fix the forcing of the swiotlb

Pratik R. Sampat <psampat@linux.ibm.com>
    cpufreq: powernv: Fix init_chip_info initialization in numa=off

Saurav Kashyap <skashyap@marvell.com>
    scsi: qla2xxx: Sync queue idx with queue_pair_map idx

Saurav Kashyap <skashyap@marvell.com>
    scsi: qla2xxx: Changes to support kdump kernel

Maciej W. Rozycki <macro@orcam.me.uk>
    scsi: BusLogic: Fix missing pr_cont() use

chenying <chenying.kernel@bytedance.com>
    ovl: fix BUG_ON() in may_delete() when called from ovl_cleanup()

Mikulas Patocka <mpatocka@redhat.com>
    parisc: fix crash with signals and alloca

Yang Yingliang <yangyingliang@huawei.com>
    net: w5100: check return value after calling platform_get_resource()

Haimin Zhang <tcs_kernel@tencent.com>
    fix array-index-out-of-bounds in taprio_change

王贇 <yun.wang@linux.alibaba.com>
    net: fix NULL pointer reference in cipso_v4_doi_free

Miaoqing Pan <miaoqing@codeaurora.org>
    ath9k: fix sleeping in atomic context

Zekun Shen <bruceshenzk@gmail.com>
    ath9k: fix OOB read ar9300_eeprom_restore_internal

Colin Ian King <colin.king@canonical.com>
    parport: remove non-zero check on count

Yevgeny Kliteynik <kliteyn@nvidia.com>
    net/mlx5: DR, Enable QP retransmission

Johannes Berg <johannes.berg@intel.com>
    iwlwifi: mvm: fix access to BSS elements

Johannes Berg <johannes.berg@intel.com>
    iwlwifi: mvm: avoid static queue number aliasing

Zhang Qilong <zhangqilong3@huawei.com>
    iwlwifi: mvm: fix a memory leak in iwl_mvm_mac_ctxt_beacon_changed

Sean Keely <Sean.Keely@amd.com>
    drm/amdkfd: Account for SH/SE count when setting up cu masks.

Xiaotan Luo <lxt@rock-chips.com>
    ASoC: rockchip: i2s: Fixup config for DAIFMT_DSP_A/B

Sugar Zhang <sugar.zhang@rock-chips.com>
    ASoC: rockchip: i2s: Fix regmap_ops hang

Shuah Khan <skhan@linuxfoundation.org>
    usbip:vhci_hcd USB port can get stuck in the disabled state

Anirudh Rayabharam <mail@anirudhrb.com>
    usbip: give back URBs for unsent unlink requests during cleanup

Nadezda Lutovinova <lutovinova@ispras.ru>
    usb: musb: musb_dsps: request_irq() after initializing musb

Mathias Nyman <mathias.nyman@linux.intel.com>
    Revert "USB: xhci: fix U1/U2 handling for hardware with XHCI_INTEL_HOST quirk set"

Ding Hui <dinghui@sangfor.com.cn>
    cifs: fix wrong release in sess_alloc_buffer() failed path

Nishad Kamdar <nishadkamdar@gmail.com>
    mmc: core: Return correct emmc response in case of ioctl error

Li Zhijian <lizhijian@cn.fujitsu.com>
    selftests/bpf: Enlarge select() timeout for test_maps

Thomas Hebb <tommyhebb@gmail.com>
    mmc: rtsx_pci: Fix long reads when clock is prescaled

Manish Narani <manish.narani@xilinx.com>
    mmc: sdhci-of-arasan: Check return value of non-void funtions

Marc Zyngier <maz@kernel.org>
    of: Don't allow __of_attached_node_sysfs() without CONFIG_SYSFS

Gustaw Lewandowski <gustaw.lewandowski@linux.intel.com>
    ASoC: Intel: Skylake: Fix passing loadable flag for module

Cezary Rojewski <cezary.rojewski@intel.com>
    ASoC: Intel: Skylake: Fix module configuration for KPB and MIXER

Marcos Paulo de Souza <mpdesouza@suse.com>
    btrfs: tree-log: check btrfs_lookup_data_extent return value

Arnd Bergmann <arnd@arndb.de>
    m68knommu: only set CONFIG_ISA_DMA_API for ColdFire sub-arch

Nathan Chancellor <nathan@kernel.org>
    drm/exynos: Always initialize mapping in exynos_drm_register_dma()

J. Bruce Fields <bfields@redhat.com>
    lockd: lockd server-side shouldn't set fl_ops

Li Jun <jun.li@nxp.com>
    usb: chipidea: host: fix port index underflow and UBSAN complains

Bob Peterson <rpeterso@redhat.com>
    gfs2: Don't call dlm after protocol is unmounted

Kees Cook <keescook@chromium.org>
    staging: rts5208: Fix get_ms_information() heap buffer size

J. Bruce Fields <bfields@redhat.com>
    rpc: fix gss_svc_init cleanup on failure

Luke Hsiao <lukehsiao@google.com>
    tcp: enable data-less, empty-cookie SYN with TFO_SERVER_COOKIE_NOT_REQD

Ulrich Hecht <uli+renesas@fpond.eu>
    serial: sh-sci: fix break handling for sysrq

Rajendra Nayak <rnayak@codeaurora.org>
    opp: Don't print an error if required-opps is missing

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: Fix handling of LE Enhanced Connection Complete

Sagi Grimberg <sagi@grimberg.me>
    nvme-tcp: don't check blk_mq_tag_to_rq when receiving pdu data

Raag Jadav <raagjadav@gmail.com>
    arm64: dts: ls1046a: fix eeprom entries

Thierry Reding <treding@nvidia.com>
    arm64: tegra: Fix compatible string for Tegra132 CPUs

Andreas Obergschwandtner <andreas.obergschwandtner@gmail.com>
    ARM: tegra: tamonten: Fix UART pad setting

Johan Almbladh <johan.almbladh@anyfinetworks.com>
    mac80211: Fix monitor MTU limit so that A-MSDUs get through

Tuo Li <islituo@gmail.com>
    drm/display: fix possible null-pointer dereference in dcn10_set_clock()

Tuo Li <islituo@gmail.com>
    gpu: drm: amd: amdgpu: amdgpu_i2c: fix possible uninitialized-variable access in amdgpu_i2c_router_select_ddc_port()

Eran Ben Elisha <eranbe@nvidia.com>
    net/mlx5: Fix variable type to match 64bit

Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>
    Bluetooth: avoid circular locks in sco_sock_connect

Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>
    Bluetooth: schedule SCO timeouts with delayed_work

Jussi Maki <joamaki@gmail.com>
    selftests/bpf: Fix xdp_tx.c prog section name

David Heidelberg <david@ixit.cz>
    drm/msm: mdp4: drop vblank get/put from prepare/complete_commit

Nathan Chancellor <nathan@kernel.org>
    net: ethernet: stmmac: Do not use unreachable() in ipq806x_gmac_probe()

Vinod Koul <vkoul@kernel.org>
    arm64: dts: qcom: sdm660: use reg value for memory node

Sebastian Reichel <sebastian.reichel@collabora.com>
    ARM: dts: imx53-ppd: Fix ACHC entry

Evgeny Novikov <novikov@ispras.ru>
    media: tegra-cec: Handle errors of clk_prepare_enable()

Krzysztof Hałasa <khalasa@piap.pl>
    media: TDA1997x: fix tda1997x_query_dv_timings() return value

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    media: v4l2-dv-timings.c: fix wrong condition in two for-loops

Umang Jain <umang.jain@ideasonboard.com>
    media: imx258: Limit the max analogue gain to 480

Laurent Pinchart <laurent.pinchart@ideasonboard.com>
    media: imx258: Rectify mismatch of VTS value

Hans de Goede <hdegoede@redhat.com>
    ASoC: Intel: bytcr_rt5640: Move "Platform Clock" routes to the maps for the matching in-/output

Vidya Sagar <vidyas@nvidia.com>
    arm64: tegra: Fix Tegra194 PCIe EP compatible string

Yufeng Mo <moyufeng@huawei.com>
    bonding: 3ad: fix the concurrency between __bond_release_one() and bond_3ad_state_machine_handler()

Zhen Lei <thunder.leizhen@huawei.com>
    workqueue: Fix possible memory leaks in wq_numa_init()

Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>
    Bluetooth: skip invalid hci_sync_conn_complete_evt

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    ata: sata_dwc_460ex: No need to call phy_exit() befre phy_init()

Juhee Kang <claudiajkang@gmail.com>
    samples: bpf: Fix tracex7 error raised on the missing argument

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    staging: ks7010: Fix the initialization of the 'sleep_status' structure

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    serial: 8250_pci: make setup_port() parameters explicitly unsigned

Jiri Slaby <jslaby@suse.cz>
    hvsi: don't panic on tty_register_driver failure

Jiri Slaby <jslaby@suse.cz>
    xtensa: ISS: don't panic in rs_init

Maciej W. Rozycki <macro@orcam.me.uk>
    serial: 8250: Define RX trigger levels for OxSemi 950 devices

Niklas Schnelle <schnelle@linux.ibm.com>
    s390: make PCI mio support a machine flag

Heiko Carstens <hca@linux.ibm.com>
    s390/jump_label: print real address in a case of a jump label bug

Gustavo A. R. Silva <gustavoars@kernel.org>
    flow_dissector: Fix out-of-bounds warnings

Gustavo A. R. Silva <gustavoars@kernel.org>
    ipv4: ip_output.c: Fix out-of-bounds warning in ip_copy_addrs()

Zheyu Ma <zheyuma97@gmail.com>
    video: fbdev: riva: Error out if 'pixclock' equals zero

Zheyu Ma <zheyuma97@gmail.com>
    video: fbdev: kyro: Error out if 'pixclock' equals zero

Zheyu Ma <zheyuma97@gmail.com>
    video: fbdev: asiliantfb: Error out if 'pixclock' equals zero

Johan Almbladh <johan.almbladh@anyfinetworks.com>
    bpf/tests: Do not PASS tests without actually testing the result

Johan Almbladh <johan.almbladh@anyfinetworks.com>
    bpf/tests: Fix copy-and-paste error in double word test

Anson Jacob <Anson.Jacob@amd.com>
    drm/amd/amdgpu: Update debugfs link_settings output link_rate field in hex

Oliver Logush <oliver.logush@amd.com>
    drm/amd/display: Fix timer_per_pixel unit error

Zheyu Ma <zheyuma97@gmail.com>
    tty: serial: jsm: hold port lock when reporting modem line changes

Geert Uytterhoeven <geert+renesas@glider.be>
    staging: board: Fix uninitialized spinlock when attaching genpd

Jack Pham <jackp@codeaurora.org>
    usb: gadget: composite: Allow bMaxPower=0 if self-powered

Evgeny Novikov <novikov@ispras.ru>
    USB: EHCI: ehci-mv: improve error handling in mv_ehci_enable()

Maciej Żenczykowski <maze@google.com>
    usb: gadget: u_ether: fix a potential null pointer dereference

Kelly Devilliv <kelly.devilliv@gmail.com>
    usb: host: fotg210: fix the actual_length of an iso packet

Kelly Devilliv <kelly.devilliv@gmail.com>
    usb: host: fotg210: fix the endpoint's transactional opportunities calculation

Sasha Neftin <sasha.neftin@intel.com>
    igc: Check if num of q_vectors is smaller than max before array access

Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>
    drm: avoid blocking in drm_clients_info's rcu section

Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
    Smack: Fix wrong semantics in smk_access_entry()

Yajun Deng <yajun.deng@linux.dev>
    netlink: Deal with ESRCH error in nlmsg_notify()

Zheyu Ma <zheyuma97@gmail.com>
    video: fbdev: kyro: fix a DoS bug by restricting user input

David Heidelberg <david@ixit.cz>
    ARM: dts: qcom: apq8064: correct clock names

Stefan Assmann <sassmann@kpanic.de>
    iavf: fix locking of critical sections

Stefan Assmann <sassmann@kpanic.de>
    iavf: do not override the adapter state in the watchdog task

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio: dac: ad5624r: Fix incorrect handling of an optional regulator.

Xin Long <lucien.xin@gmail.com>
    tipc: keep the skb in rcv queue until the whole data is read

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    PCI: Use pci_update_current_state() in pci_enable_device_flags()

Sean Anderson <sean.anderson@seco.com>
    crypto: mxs-dcp - Use sg_mapping_iter to copy data

Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
    media: dib8000: rewrite the init prbs logic

Randy Dunlap <rdunlap@infradead.org>
    ASoC: atmel: ATMEL drivers don't need HAS_DMA

Luben Tuikov <luben.tuikov@amd.com>
    drm/amdgpu: Fix amdgpu_ras_eeprom_init()

Nadav Amit <namit@vmware.com>
    userfaultfd: prevent concurrent API initialization

Masahiro Yamada <masahiroy@kernel.org>
    kbuild: Fix 'no symbols' warning when CONFIG_TRIM_UNUSD_KSYMS=y

Oleksij Rempel <linux@rempel-privat.de>
    MIPS: Malta: fix alignment of the devicetree buffer

Chao Yu <chao@kernel.org>
    f2fs: fix to unmap pages from userspace process in punch_hole()

Chao Yu <chao@kernel.org>
    f2fs: fix unexpected ENOENT comes from f2fs_map_blocks()

Chao Yu <chao@kernel.org>
    f2fs: fix to account missing .skipped_gc_rwsem

Alexey Kardashevskiy <aik@ozlabs.ru>
    KVM: PPC: Fix clearing never mapped TCEs in realmode

Codrin Ciubotariu <codrin.ciubotariu@microchip.com>
    clk: at91: clk-generated: Limit the requested rate to our range

Claudiu Beznea <claudiu.beznea@microchip.com>
    clk: at91: clk-generated: pass the id of changeable parent at registration

Codrin Ciubotariu <codrin.ciubotariu@microchip.com>
    clk: at91: sam9x60: Don't use audio PLL

David Howells <dhowells@redhat.com>
    fscache: Fix cookie key hashing

Hans de Goede <hdegoede@redhat.com>
    platform/x86: dell-smbios-wmi: Add missing kfree in error-exit from run_smbios_call

Nicholas Piggin <npiggin@gmail.com>
    KVM: PPC: Book3S HV Nested: Reflect guest PMU in-use to L0 when guest SPRs are live

Jim Broadus <jbroadus@gmail.com>
    HID: i2c-hid: Fix Elan touchpad regression

David Disseldorp <ddiss@suse.de>
    scsi: target: avoid per-loop XCOPY buffer allocations

Joel Stanley <joel@jms.id.au>
    powerpc/config: Renable MTD_PHYSMAP_OF

Dan Carpenter <dan.carpenter@oracle.com>
    scsi: qedf: Fix error codes in qedf_alloc_global_queues()

Dan Carpenter <dan.carpenter@oracle.com>
    scsi: qedi: Fix error codes in qedi_alloc_global_queues()

Dan Carpenter <dan.carpenter@oracle.com>
    scsi: smartpqi: Fix an error code in pqi_get_raid_map()

Zhen Lei <thunder.leizhen@huawei.com>
    pinctrl: single: Fix error return code in pcs_parse_bits_in_pinctrl_entry()

Wei Li <liwei391@huawei.com>
    scsi: fdomain: Fix error return code in fdomain_probe()

Trond Myklebust <trond.myklebust@hammerspace.com>
    SUNRPC: Fix potential memory corruption

Anthony Iliopoulos <ailiop@suse.com>
    dma-debug: fix debugfs initialization order

Randy Dunlap <rdunlap@infradead.org>
    openrisc: don't printk() unconditionally

Yangtao Li <frank.li@vivo.com>
    f2fs: reduce the scope of setting fsck tag when de->name_len is zero

Chao Yu <chao@kernel.org>
    f2fs: show f2fs instance in printk_ratelimited

Leon Romanovsky <leonro@nvidia.com>
    RDMA/efa: Remove double QP type assignment

Michal Suchanek <msuchanek@suse.de>
    powerpc/stacktrace: Include linux/delay.h

Jason Gunthorpe <jgg@nvidia.com>
    vfio: Use config not menuconfig for VFIO_NOIOMMU

Jaehyoung Choi <jkkkkk.choi@samsung.com>
    pinctrl: samsung: Fix pinctrl bank pin count

Leon Romanovsky <leonro@nvidia.com>
    docs: Fix infiniband uverbs minor number

Leon Romanovsky <leonro@nvidia.com>
    RDMA/iwcm: Release resources if iw_cm module initialization fails

Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>
    IB/hfi1: Adjust pkey entry in index 0

Christoph Hellwig <hch@lst.de>
    scsi: bsg: Remove support for SCSI_IOCTL_SEND_COMMAND

Chao Yu <chao@kernel.org>
    f2fs: quota: fix potential deadlock

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    HID: input: do not report stylus battery state as "full"

Pali Rohár <pali@kernel.org>
    PCI: aardvark: Fix masking and unmasking legacy INTx interrupts

Pali Rohár <pali@kernel.org>
    PCI: aardvark: Increase polling delay to 1.5s while waiting for PIO response

Evan Wang <xswang@marvell.com>
    PCI: aardvark: Fix checking for PIO status

Hyun Kwon <hyun.kwon@xilinx.com>
    PCI: xilinx-nwl: Enable the clock through CCF

Krzysztof Wilczyński <kw@linux.com>
    PCI: Return ~0 data on pciconfig_read() CAP_SYS_ADMIN failure

Marek Behún <kabel@kernel.org>
    PCI: Restrict ASMedia ASM1062 SATA Max Payload Size Supported

Stuart Hayes <stuart.w.hayes@gmail.com>
    PCI/portdrv: Enable Bandwidth Notification only if port supports it

David Heidelberg <david@ixit.cz>
    ARM: 9105/1: atags_to_fdt: don't warn about stack size

Hans de Goede <hdegoede@redhat.com>
    libata: add ATA_HORKAGE_NO_NCQ_TRIM for Samsung 860 and 870 SSDs

Robin Gong <yibin.gong@nxp.com>
    dmaengine: imx-sdma: remove duplicated sdma_load_context

Robin Gong <yibin.gong@nxp.com>
    Revert "dmaengine: imx-sdma: refine to load context only once"

Sean Young <sean@mess.org>
    media: rc-loopback: return number of emitters rather than error

Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
    media: uvc: don't do DMA on stack

Wang Hai <wanghai38@huawei.com>
    VMCI: fix NULL pointer dereference when unmapping queue pair

Arne Welzel <arne.welzel@corelight.com>
    dm crypt: Avoid percpu_counter spinlock contention in crypt_page_alloc()

Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
    power: supply: max17042: handle fails of reading status register

Damien Le Moal <damien.lemoal@wdc.com>
    block: bfq: fix bfq_set_next_ioprio_data()

zhenwei pi <pizhenwei@bytedance.com>
    crypto: public_key: fix overflow during implicit conversion

Mark Rutland <mark.rutland@arm.com>
    arm64: head: avoid over-mapping in map_memory

Iwona Winiarska <iwona.winiarska@intel.com>
    soc: aspeed: p2a-ctrl: Fix boundary check for mmap

Iwona Winiarska <iwona.winiarska@intel.com>
    soc: aspeed: lpc-ctrl: Fix boundary check for mmap

Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
    soc: qcom: aoss: Fix the out of bound usage of cooling_devs

Paul Cercueil <paul@crapouillou.net>
    pinctrl: ingenic: Fix incorrect pull up/down info

Marc Zyngier <maz@kernel.org>
    pinctrl: stmfx: Fix hazardous u8[] to unsigned long cast

Rolf Eike Beer <eb@emlix.com>
    tools/thermal/tmon: Add cross compiling support

Harshvardhan Jha <harshvardhan.jha@oracle.com>
    9p/xen: Fix end of loop tests for list_for_each_entry

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    include/linux/list.h: add a macro to test if entry is pointing to the head

Juergen Gross <jgross@suse.com>
    xen: fix setting of max_pfn in shared_info

Kajol Jain <kjain@linux.ibm.com>
    powerpc/perf/hv-gpci: Fix counter value parsing

Marek Marczykowski-Górecki <marmarek@invisiblethingslab.com>
    PCI/MSI: Skip masking MSI-X on Xen PV

Niklas Cassel <niklas.cassel@wdc.com>
    blk-zoned: allow BLKREPORTZONE without CAP_SYS_ADMIN

Niklas Cassel <niklas.cassel@wdc.com>
    blk-zoned: allow zone management send operations without CAP_SYS_ADMIN

Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>
    btrfs: reset replace target device to allocation state on close

Josef Bacik <josef@toxicpanda.com>
    btrfs: wake up async_delalloc_pages waiters after submit

Dmitry Osipenko <digetx@gmail.com>
    rtc: tps65910: Correct driver module alias


-------------

Diffstat:

 Documentation/admin-guide/devices.txt              |   6 +-
 Documentation/devicetree/bindings/arm/tegra.yaml   |   2 +-
 .../devicetree/bindings/mtd/gpmc-nand.txt          |   2 +-
 Makefile                                           |   4 +-
 arch/arc/mm/cache.c                                |   2 +-
 arch/arm/boot/compressed/Makefile                  |   2 +
 arch/arm/boot/dts/imx53-ppd.dts                    |  23 +++--
 arch/arm/boot/dts/qcom-apq8064.dtsi                |   6 +-
 arch/arm/boot/dts/tegra20-tamonten.dtsi            |  14 +--
 arch/arm64/boot/dts/freescale/fsl-ls1046a-frwy.dts |   8 +-
 arch/arm64/boot/dts/freescale/fsl-ls1046a-rdb.dts  |   7 +-
 arch/arm64/boot/dts/nvidia/tegra132.dtsi           |   4 +-
 arch/arm64/boot/dts/nvidia/tegra194.dtsi           |   6 +-
 arch/arm64/boot/dts/qcom/ipq8074-hk01.dts          |   2 +-
 arch/arm64/include/asm/kernel-pgtable.h            |   4 +-
 arch/arm64/kernel/fpsimd.c                         |   2 +-
 arch/arm64/kernel/head.S                           |  11 ++-
 arch/m68k/Kconfig.bus                              |   2 +-
 arch/mips/mti-malta/malta-dtshim.c                 |   2 +-
 arch/openrisc/kernel/entry.S                       |   2 +
 arch/parisc/kernel/signal.c                        |   6 ++
 arch/powerpc/configs/mpc885_ads_defconfig          |   1 +
 arch/powerpc/include/asm/pmc.h                     |   7 ++
 arch/powerpc/kernel/stacktrace.c                   |   1 +
 arch/powerpc/kvm/book3s_64_vio_hv.c                |   9 +-
 arch/powerpc/kvm/book3s_hv.c                       |  20 ++++
 arch/powerpc/kvm/book3s_hv_rmhandlers.S            |  36 ++++++-
 arch/powerpc/perf/hv-gpci.c                        |   2 +-
 arch/s390/include/asm/setup.h                      |   2 +
 arch/s390/kernel/early.c                           |   4 +
 arch/s390/kernel/jump_label.c                      |   2 +-
 arch/s390/mm/init.c                                |   2 +-
 arch/s390/pci/pci.c                                |   5 +-
 arch/x86/mm/init_64.c                              |   6 +-
 arch/x86/xen/enlighten_pv.c                        |   7 ++
 arch/x86/xen/p2m.c                                 |   4 +-
 arch/xtensa/platforms/iss/console.c                |  17 +++-
 block/bfq-iosched.c                                |  18 +++-
 block/blk-zoned.c                                  |   6 --
 block/bsg.c                                        |   5 +-
 drivers/ata/libata-core.c                          |   4 +
 drivers/ata/sata_dwc_460ex.c                       |  12 +--
 drivers/base/power/trace.c                         |  10 ++
 drivers/clk/at91/clk-generated.c                   |  32 +++---
 drivers/clk/at91/dt-compat.c                       |   8 +-
 drivers/clk/at91/pmc.h                             |   4 +-
 drivers/clk/at91/sam9x60.c                         |  10 +-
 drivers/clk/at91/sama5d2.c                         |  31 +++---
 drivers/cpufreq/powernv-cpufreq.c                  |  16 ++-
 drivers/crypto/mxs-dcp.c                           |  36 ++-----
 drivers/dma/imx-sdma.c                             |  13 +--
 drivers/gpu/drm/amd/amdgpu/amdgpu.h                |   2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_i2c.c            |   2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_object.c         |   2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_ras_eeprom.c     |   2 +-
 drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager.c       |  84 ++++++++++++----
 drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager.h       |   1 +
 .../drm/amd/display/amdgpu_dm/amdgpu_dm_debugfs.c  |  16 +--
 .../drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c  |  11 +--
 .../gpu/drm/amd/display/dc/dcn20/dcn20_resource.c  |   2 +-
 drivers/gpu/drm/drm_debugfs.c                      |   3 +-
 drivers/gpu/drm/etnaviv/etnaviv_buffer.c           |   3 +-
 drivers/gpu/drm/etnaviv/etnaviv_gem.c              |   3 +-
 drivers/gpu/drm/etnaviv/etnaviv_gem_submit.c       |   3 +-
 drivers/gpu/drm/etnaviv/etnaviv_gpu.c              |  43 ++++----
 drivers/gpu/drm/etnaviv/etnaviv_gpu.h              |   1 +
 drivers/gpu/drm/etnaviv/etnaviv_iommu.c            |   4 +
 drivers/gpu/drm/etnaviv/etnaviv_iommu_v2.c         |   8 ++
 drivers/gpu/drm/etnaviv/etnaviv_mmu.c              |   1 +
 drivers/gpu/drm/etnaviv/etnaviv_mmu.h              |   4 +-
 drivers/gpu/drm/exynos/exynos_drm_dma.c            |   2 +
 drivers/gpu/drm/msm/disp/mdp4/mdp4_kms.c           |  17 +---
 drivers/gpu/drm/panfrost/panfrost_mmu.c            |  31 +++---
 drivers/gpu/drm/panfrost/panfrost_regs.h           |   2 +
 drivers/hid/hid-input.c                            |   2 -
 drivers/hid/i2c-hid/i2c-hid-core.c                 |   5 +-
 drivers/iio/dac/ad5624r_spi.c                      |  18 +++-
 drivers/infiniband/core/iwcm.c                     |  19 ++--
 drivers/infiniband/hw/efa/efa_verbs.c              |   1 -
 drivers/infiniband/hw/hfi1/init.c                  |   7 +-
 drivers/md/dm-crypt.c                              |   7 +-
 drivers/media/dvb-frontends/dib8000.c              |  58 +++++++----
 drivers/media/i2c/imx258.c                         |   4 +-
 drivers/media/i2c/tda1997x.c                       |   5 +-
 drivers/media/platform/tegra-cec/tegra_cec.c       |  10 +-
 drivers/media/rc/rc-loopback.c                     |   2 +-
 drivers/media/usb/uvc/uvc_v4l2.c                   |  34 ++++---
 drivers/media/v4l2-core/v4l2-dv-timings.c          |   4 +-
 drivers/mfd/ab8500-core.c                          |   2 +-
 drivers/mfd/axp20x.c                               |   3 +-
 drivers/mfd/db8500-prcmu.c                         |  14 ++-
 drivers/mfd/stmpe.c                                |   4 +-
 drivers/mfd/tc3589x.c                              |   2 +-
 drivers/mfd/tqmx86.c                               |   2 +
 drivers/mfd/wm8994-irq.c                           |   2 +-
 drivers/misc/vmw_vmci/vmci_queue_pair.c            |   6 +-
 drivers/mmc/core/block.c                           |   3 +-
 drivers/mmc/host/rtsx_pci_sdmmc.c                  |  36 ++++---
 drivers/mmc/host/sdhci-of-arasan.c                 |  18 +++-
 drivers/mtd/nand/raw/cafe_nand.c                   |   4 +-
 drivers/net/bonding/bond_main.c                    |   3 +-
 drivers/net/dsa/b53/b53_common.c                   |   3 +-
 drivers/net/dsa/lantiq_gswip.c                     |   3 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c  |   2 +-
 drivers/net/ethernet/chelsio/cxgb/cxgb2.c          |   1 +
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    |   8 +-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    |  19 ++--
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  |   6 +-
 drivers/net/ethernet/ibm/ibmvnic.c                 |   8 ++
 drivers/net/ethernet/intel/iavf/iavf_main.c        |  58 +++++++++--
 drivers/net/ethernet/intel/igc/igc_main.c          |   9 +-
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c      |   8 +-
 .../ethernet/mellanox/mlx5/core/diag/fw_tracer.c   |   3 +-
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c  |   5 +-
 .../ethernet/mellanox/mlx5/core/steering/dr_send.c |   1 +
 drivers/net/ethernet/qlogic/qed/qed_mcp.c          |   6 +-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_init.c   |   1 -
 drivers/net/ethernet/rdc/r6040.c                   |   9 +-
 drivers/net/ethernet/renesas/sh_eth.c              |   1 +
 .../net/ethernet/stmicro/stmmac/dwmac-ipq806x.c    |  18 ++--
 drivers/net/ethernet/wiznet/w5100.c                |   2 +
 drivers/net/phy/dp83640_reg.h                      |   2 +-
 drivers/net/usb/cdc_mbim.c                         |   5 +
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c     |   3 +-
 drivers/net/wireless/ath/ath9k/hw.c                |  12 ++-
 drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c  |   4 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  |   8 +-
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c       |  24 ++++-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c       |  30 +++---
 drivers/ntb/test/ntb_msi_test.c                    |   4 +-
 drivers/ntb/test/ntb_perf.c                        |   1 +
 drivers/nvme/host/tcp.c                            |  14 +--
 drivers/of/kobj.c                                  |   2 +-
 drivers/opp/of.c                                   |  12 +--
 drivers/parport/ieee1284_ops.c                     |   2 +-
 drivers/pci/controller/pci-aardvark.c              |  73 ++++++++++++--
 drivers/pci/controller/pcie-xilinx-nwl.c           |  12 +++
 drivers/pci/hotplug/TODO                           |   3 -
 drivers/pci/hotplug/ibmphp_ebda.c                  |   5 +-
 drivers/pci/msi.c                                  |   3 +
 drivers/pci/pci.c                                  |   8 +-
 drivers/pci/pcie/portdrv_core.c                    |   9 +-
 drivers/pci/quirks.c                               |  59 ++++++++++-
 drivers/pci/syscall.c                              |   4 +-
 drivers/pinctrl/pinctrl-ingenic.c                  |   6 +-
 drivers/pinctrl/pinctrl-single.c                   |   1 +
 drivers/pinctrl/pinctrl-stmfx.c                    |   6 +-
 drivers/pinctrl/samsung/pinctrl-samsung.c          |   2 +-
 drivers/platform/chrome/cros_ec_proto.c            |   9 ++
 drivers/platform/x86/dell-smbios-wmi.c             |   1 +
 drivers/power/supply/max17042_battery.c            |   6 +-
 drivers/rtc/rtc-tps65910.c                         |   2 +-
 drivers/s390/char/sclp_early.c                     |   3 +-
 drivers/scsi/BusLogic.c                            |   4 +-
 drivers/scsi/pcmcia/fdomain_cs.c                   |   4 +-
 drivers/scsi/qedf/qedf_main.c                      |  10 +-
 drivers/scsi/qedi/qedi_main.c                      |  14 +--
 drivers/scsi/qla2xxx/qla_nvme.c                    |   5 +-
 drivers/scsi/qla2xxx/qla_os.c                      |   6 ++
 drivers/scsi/smartpqi/smartpqi_init.c              |   1 +
 drivers/soc/aspeed/aspeed-lpc-ctrl.c               |   2 +-
 drivers/soc/aspeed/aspeed-p2a-ctrl.c               |   2 +-
 drivers/soc/qcom/qcom_aoss.c                       |   8 +-
 drivers/staging/board/board.c                      |   7 +-
 drivers/staging/ks7010/ks7010_sdio.c               |   2 +-
 drivers/staging/rts5208/rtsx_scsi.c                |  10 +-
 drivers/target/target_core_xcopy.c                 |  96 ++++++------------
 drivers/target/target_core_xcopy.h                 |   1 +
 drivers/tty/hvc/hvsi.c                             |  19 +++-
 drivers/tty/serial/8250/8250_pci.c                 |   2 +-
 drivers/tty/serial/8250/8250_port.c                |   3 +-
 drivers/tty/serial/jsm/jsm_neo.c                   |   2 +
 drivers/tty/serial/jsm/jsm_tty.c                   |   3 +
 drivers/tty/serial/sh-sci.c                        |   7 +-
 drivers/usb/chipidea/host.c                        |  14 ++-
 drivers/usb/gadget/composite.c                     |   8 +-
 drivers/usb/gadget/function/u_ether.c              |   5 +-
 drivers/usb/host/ehci-mv.c                         |  23 +++--
 drivers/usb/host/fotg210-hcd.c                     |  41 ++++----
 drivers/usb/host/fotg210.h                         |   5 -
 drivers/usb/host/xhci.c                            |  24 ++---
 drivers/usb/musb/musb_dsps.c                       |  13 ++-
 drivers/usb/usbip/vhci_hcd.c                       |  32 +++++-
 drivers/vfio/Kconfig                               |   2 +-
 drivers/vhost/net.c                                |  11 ++-
 drivers/video/fbdev/asiliantfb.c                   |   3 +
 drivers/video/fbdev/kyro/fbdev.c                   |   8 ++
 drivers/video/fbdev/riva/fbdev.c                   |   3 +
 fs/btrfs/disk-io.c                                 |  45 ++++-----
 fs/btrfs/inode.c                                   |  10 +-
 fs/btrfs/tree-log.c                                |   4 +-
 fs/btrfs/volumes.c                                 |   3 +
 fs/cifs/sess.c                                     |   2 +-
 fs/f2fs/checkpoint.c                               |   2 +-
 fs/f2fs/data.c                                     |  23 ++++-
 fs/f2fs/dir.c                                      |  15 ++-
 fs/f2fs/f2fs.h                                     |  24 ++---
 fs/f2fs/file.c                                     |   6 +-
 fs/f2fs/gc.c                                       |   6 +-
 fs/f2fs/inode.c                                    |   2 +-
 fs/f2fs/node.c                                     |   2 +-
 fs/f2fs/segment.c                                  |   9 +-
 fs/f2fs/super.c                                    |  84 +++++++++-------
 fs/fscache/cookie.c                                |  14 +--
 fs/fscache/internal.h                              |   2 +
 fs/fscache/main.c                                  |  39 ++++++++
 fs/fuse/dev.c                                      |   4 +-
 fs/gfs2/lock_dlm.c                                 |   5 +
 fs/lockd/svclock.c                                 |  30 +++---
 fs/overlayfs/dir.c                                 |   6 +-
 fs/userfaultfd.c                                   |  93 +++++++++---------
 include/crypto/public_key.h                        |   4 +-
 include/linux/hugetlb.h                            |   9 ++
 include/linux/list.h                               |  29 ++++--
 include/linux/memory_hotplug.h                     |   4 +-
 include/linux/pci.h                                |   5 +-
 include/linux/pci_ids.h                            |   3 +-
 include/linux/skbuff.h                             |   2 +-
 include/linux/sunrpc/xprt.h                        |   1 +
 include/uapi/linux/pkt_sched.h                     |   2 +
 include/uapi/linux/serial_reg.h                    |   1 +
 kernel/dma/debug.c                                 |   7 +-
 kernel/events/core.c                               |   2 +-
 kernel/fork.c                                      |   1 +
 kernel/pid_namespace.c                             |   3 +-
 kernel/trace/trace_kprobe.c                        |   6 +-
 kernel/trace/trace_probe.c                         |  25 +++++
 kernel/trace/trace_probe.h                         |   1 +
 kernel/trace/trace_uprobe.c                        |   6 +-
 kernel/workqueue.c                                 |  12 ++-
 lib/test_bpf.c                                     |  13 ++-
 lib/test_stackinit.c                               |  20 ++--
 mm/memory_hotplug.c                                |   4 +-
 mm/vmscan.c                                        |   2 +-
 net/9p/trans_xen.c                                 |   4 +-
 net/bluetooth/hci_event.c                          | 108 +++++++++++++++------
 net/bluetooth/sco.c                                |  74 ++++++++------
 net/caif/chnl_net.c                                |  19 +---
 net/core/flow_dissector.c                          |  12 ++-
 net/dccp/minisocks.c                               |   2 +
 net/dsa/slave.c                                    |  12 +--
 net/ipv4/ip_gre.c                                  |   9 +-
 net/ipv4/ip_output.c                               |   5 +-
 net/ipv4/nexthop.c                                 |   2 +
 net/ipv4/tcp_fastopen.c                            |   3 +-
 net/ipv4/tcp_input.c                               |   2 +-
 net/ipv6/netfilter/nf_socket_ipv6.c                |   4 +-
 net/l2tp/l2tp_core.c                               |   4 +-
 net/mac80211/iface.c                               |  11 ++-
 net/netlabel/netlabel_cipso_v4.c                   |   4 +-
 net/netlink/af_netlink.c                           |   4 +-
 net/sched/sch_fq_codel.c                           |  12 ++-
 net/sched/sch_taprio.c                             |   4 +-
 net/sunrpc/auth_gss/svcauth_gss.c                  |   2 +-
 net/sunrpc/xprt.c                                  |   6 +-
 net/tipc/socket.c                                  |  36 +++++--
 net/unix/af_unix.c                                 |   2 +-
 samples/bpf/test_override_return.sh                |   1 +
 samples/bpf/tracex7_user.c                         |   5 +
 scripts/gen_ksymdeps.sh                            |   8 +-
 security/smack/smack_access.c                      |  17 ++--
 sound/soc/atmel/Kconfig                            |   1 -
 sound/soc/intel/boards/bytcr_rt5640.c              |   9 +-
 sound/soc/intel/skylake/skl-messages.c             |  11 ++-
 sound/soc/intel/skylake/skl-pcm.c                  |  25 ++---
 sound/soc/rockchip/rockchip_i2s.c                  |  35 ++++---
 tools/perf/Makefile.config                         |   8 +-
 tools/perf/util/machine.c                          |   1 +
 tools/testing/selftests/bpf/progs/xdp_tx.c         |   2 +-
 tools/testing/selftests/bpf/test_maps.c            |   2 +-
 tools/testing/selftests/bpf/test_xdp_veth.sh       |   2 +-
 tools/thermal/tmon/Makefile                        |   2 +-
 virt/kvm/arm/arm.c                                 |   8 ++
 273 files changed, 1866 insertions(+), 1079 deletions(-)


