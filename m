Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CCFD629B6B
	for <lists+stable@lfdr.de>; Tue, 15 Nov 2022 15:04:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238348AbiKOOEI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Nov 2022 09:04:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230187AbiKOOEI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Nov 2022 09:04:08 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE5792870A;
        Tue, 15 Nov 2022 06:04:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 56F45B81910;
        Tue, 15 Nov 2022 14:04:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 559A7C433C1;
        Tue, 15 Nov 2022 14:04:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668521042;
        bh=f7sEiTvJlCjd33OgPZV7wSvCaZT/CRC6JsaoDPFLqas=;
        h=From:To:Cc:Subject:Date:From;
        b=h8ZO/xLkXukF4ie1WlXO8Xmnk8MhDSvwFZNxnDXSZUU1RzbGHIMaAOyX1I61WWu1B
         /bv+KKkus/rfHpJbLIVSNTZ6pCkLRHkPaEkF2tYoEaIuxV2UybVzO/eV495d3TkzPH
         41Tx6bLUERs7OSpx4PBtUjof21HQHXcBoTIeshZY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: [PATCH 5.15 000/130] 5.15.79-rc2 review
Date:   Tue, 15 Nov 2022 15:04:00 +0100
Message-Id: <20221115140300.534663914@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.79-rc2.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.15.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.15.79-rc2
X-KernelTest-Deadline: 2022-11-17T14:03+00:00
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.15.79 release.
There are 130 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 17 Nov 2022 14:02:33 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.79-rc2.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.15.79-rc2

Eric Dumazet <edumazet@google.com>
    net: tun: call napi_schedule_prep() to ensure we own a napi

Philip Yang <Philip.Yang@amd.com>
    drm/amdkfd: Migrate in CPU page fault use current mm

Anders Roxell <anders.roxell@linaro.org>
    marvell: octeontx2: build error: unknown type name 'u64'

Tudor Ambarus <tudor.ambarus@microchip.com>
    dmaengine: at_hdmac: Check return code of dma_async_device_register

Tudor Ambarus <tudor.ambarus@microchip.com>
    dmaengine: at_hdmac: Fix impossible condition

Tudor Ambarus <tudor.ambarus@microchip.com>
    dmaengine: at_hdmac: Don't allow CPU to reorder channel enable

Tudor Ambarus <tudor.ambarus@microchip.com>
    dmaengine: at_hdmac: Fix completion of unissued descriptor in case of errors

Tudor Ambarus <tudor.ambarus@microchip.com>
    dmaengine: at_hdmac: Fix descriptor handling when issuing it to hardware

Tudor Ambarus <tudor.ambarus@microchip.com>
    dmaengine: at_hdmac: Fix concurrency over the active list

Tudor Ambarus <tudor.ambarus@microchip.com>
    dmaengine: at_hdmac: Free the memset buf without holding the chan lock

Tudor Ambarus <tudor.ambarus@microchip.com>
    dmaengine: at_hdmac: Fix concurrency over descriptor

Tudor Ambarus <tudor.ambarus@microchip.com>
    dmaengine: at_hdmac: Fix concurrency problems by removing atc_complete_all()

Tudor Ambarus <tudor.ambarus@microchip.com>
    dmaengine: at_hdmac: Protect atchan->status with the channel lock

Tudor Ambarus <tudor.ambarus@microchip.com>
    dmaengine: at_hdmac: Do not call the complete callback on device_terminate_all

Tudor Ambarus <tudor.ambarus@microchip.com>
    dmaengine: at_hdmac: Fix premature completion of desc in issue_pending

Tudor Ambarus <tudor.ambarus@microchip.com>
    dmaengine: at_hdmac: Start transfer for cyclic channels in issue_pending

Tudor Ambarus <tudor.ambarus@microchip.com>
    dmaengine: at_hdmac: Don't start transactions at tx_submit level

Tudor Ambarus <tudor.ambarus@microchip.com>
    dmaengine: at_hdmac: Fix at_lli struct definition

Linus Torvalds <torvalds@linux-foundation.org>
    cert host tools: Stop complaining about deprecated OpenSSL functions

Oliver Hartkopp <socketcan@hartkopp.net>
    can: j1939: j1939_send_one(): fix missing CAN header initialization

Peter Xu <peterx@redhat.com>
    mm/shmem: use page_mapping() to detect page cache for uffd continue

Pankaj Gupta <pankaj.gupta@amd.com>
    mm/memremap.c: map FS_DAX device memory as decrypted

SeongJae Park <sj@kernel.org>
    mm/damon/dbgfs: check if rm_contexts input is for a real context

ZhangPeng <zhangpeng362@huawei.com>
    udf: Fix a slab-out-of-bounds write bug in udf_find_entry()

Brian Norris <briannorris@chromium.org>
    mms: sdhci-esdhc-imx: Fix SDHCI_RESET_ALL for CQHCI

Johannes Thumshirn <johannes.thumshirn@wdc.com>
    btrfs: zoned: initialize device's zone info for seeding

Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
    btrfs: selftests: fix wrong error check in btrfs_free_dummy_root()

Liu Shixin <liushixin2@huawei.com>
    btrfs: fix match incorrectly in dev_args_match_device

Wen Gong <quic_wgong@quicinc.com>
    wifi: ath11k: avoid deadlock during regulatory update in ath11k_regd_update()

Jorge Lopez <jorge.lopez2@hp.com>
    platform/x86: hp_wmi: Fix rfkill causing soft blocked wifi

Guchun Chen <guchun.chen@amd.com>
    drm/amdgpu: disable BACO on special BEIGE_GOBY card

Matthew Auld <matthew.auld@intel.com>
    drm/i915/dmabuf: fix sg_table handling in map_dma_buf

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: fix use-after-free bug of ns_writer on remount

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: fix deadlock in nilfs_count_free_blocks()

Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
    ata: libata-scsi: fix SYNCHRONIZE CACHE (16) command failure

Nathan Chancellor <nathan@kernel.org>
    vmlinux.lds.h: Fix placement of '.data..decrypted' section

Jussi Laako <jussi@sonarnerd.net>
    ALSA: usb-audio: Add DSD support for Accuphase DAC-60

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Add quirk entry for M-Audio Micro

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Yet more regression for for the delayed card registration

Edson Juliano Drosdeck <edson.drosdeck@gmail.com>
    ALSA: hda/realtek: Add Positivo C6300 model quirk

Ye Bin <yebin10@huawei.com>
    ALSA: hda: fix potential memleak in 'add_widget_node'

Xian Wang <dev@xianwang.io>
    ALSA: hda/ca0132: add quirk for EVGA Z390 DARK

Evan Quan <evan.quan@amd.com>
    ALSA: hda/hdmi - enable runtime pm for more AMD display audio

Haibo Chen <haibo.chen@nxp.com>
    mmc: sdhci-esdhc-imx: use the correct host caps for MMC_CAP_8_BIT_DATA

Brian Norris <briannorris@chromium.org>
    mmc: sdhci-tegra: Fix SDHCI_RESET_ALL for CQHCI

Brian Norris <briannorris@chromium.org>
    mmc: sdhci_am654: Fix SDHCI_RESET_ALL for CQHCI

Brian Norris <briannorris@chromium.org>
    mmc: sdhci-of-arasan: Fix SDHCI_RESET_ALL for CQHCI

Brian Norris <briannorris@chromium.org>
    mmc: cqhci: Provide helper for resetting both SDHCI and CQHCI

Jiaxun Yang <jiaxun.yang@flygoat.com>
    MIPS: jump_label: Fix compat branch range check

Ard Biesheuvel <ardb@kernel.org>
    arm64: efi: Fix handling of misaligned runtime regions and drop warning

Conor Dooley <conor.dooley@microchip.com>
    riscv: fix reserved memory setup

Jisheng Zhang <jszhang@kernel.org>
    riscv: vdso: fix build with llvm

Jisheng Zhang <jszhang@kernel.org>
    riscv: process: fix kernel info leakage

Chuang Wang <nashuiliang@gmail.com>
    net: macvlan: fix memory leaks of macvlan_common_newlink

Zhengchao Shao <shaozhengchao@huawei.com>
    ethernet: tundra: free irq when alloc ring failed in tsi108_open()

Zhengchao Shao <shaozhengchao@huawei.com>
    net: mv643xx_eth: disable napi when init rxq or txq failed in mv643xx_eth_open()

Zhengchao Shao <shaozhengchao@huawei.com>
    ethernet: s2io: disable napi when start nic failed in s2io_card_up()

Antoine Tenart <atenart@kernel.org>
    net: atlantic: macsec: clear encryption keys from the stack

Antoine Tenart <atenart@kernel.org>
    net: phy: mscc: macsec: clear encryption keys when freeing a flow

Yang Yingliang <yangyingliang@huawei.com>
    stmmac: dwmac-loongson: fix missing of_node_put() while module exiting

Yang Yingliang <yangyingliang@huawei.com>
    stmmac: dwmac-loongson: fix missing pci_disable_device() in loongson_dwmac_probe()

Yang Yingliang <yangyingliang@huawei.com>
    stmmac: dwmac-loongson: fix missing pci_disable_msi() while module exiting

Zhengchao Shao <shaozhengchao@huawei.com>
    cxgb4vf: shut down the adapter when t4vf_update_port_info() failed in cxgb4vf_open()

Wei Yongjun <weiyongjun1@huawei.com>
    mctp: Fix an error handling path in mctp_init()

Tan, Tee Min <tee.min.tan@intel.com>
    stmmac: intel: Update PCH PTP clock rate from 200MHz to 204.8MHz

Wong Vee Khee <vee.khee.wong@linux.intel.com>
    stmmac: intel: Enable 2.5Gbps for Intel AlderLake-S

Zhengchao Shao <shaozhengchao@huawei.com>
    net: cxgb3_main: disable napi when bind qsets failed in cxgb_up()

Zhengchao Shao <shaozhengchao@huawei.com>
    net: cpsw: disable napi in cpsw_ndo_open()

Roi Dayan <roid@nvidia.com>
    net/mlx5e: E-Switch, Fix comparing termination table instance

Roy Novich <royno@nvidia.com>
    net/mlx5: Allow async trigger completion execution on single CPU systems

Vlad Buslov <vladbu@nvidia.com>
    net/mlx5: Bridge, verify LAG state when adding bond to bridge

M Chetan Kumar <m.chetan.kumar@linux.intel.com>
    net: wwan: iosm: fix memory leak in ipc_pcie_read_bios_cfg

Zhengchao Shao <shaozhengchao@huawei.com>
    net: nixge: disable napi when enable interrupts failed in nixge_open()

Zhengchao Shao <shaozhengchao@huawei.com>
    net: marvell: prestera: fix memory leak in prestera_rxtx_switch_init()

Shigeru Yoshida <syoshida@redhat.com>
    netfilter: Cleanup nft_net->module_list from nf_tables_exit_net()

Ziyang Xuan <william.xuanziyang@huawei.com>
    netfilter: nfnetlink: fix potential dead lock in nfnetlink_rcv_msg()

Donglin Peng <dolinux.peng@gmail.com>
    perf tools: Add the include/perf/ directory to .gitignore

Athira Rajeev <atrajeev@linux.vnet.ibm.com>
    perf stat: Fix printing os->prefix in CSV metrics output

Zhengchao Shao <shaozhengchao@huawei.com>
    drivers: net: xgene: disable napi when register irq failed in xgene_enet_open()

Zhengchao Shao <shaozhengchao@huawei.com>
    net: lapbether: fix issue of invalid opcode in lapbeth_open()

Yang Yingliang <yangyingliang@huawei.com>
    dmaengine: ti: k3-udma-glue: fix memory leak when register device fail

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    dmaengine: mv_xor_v2: Fix a resource leak in mv_xor_v2_remove()

Doug Brown <doug@schmorgal.com>
    dmaengine: pxa_dma: use platform_get_irq_optional

Xin Long <lucien.xin@gmail.com>
    tipc: fix the msg->req tlv len check in tipc_nl_compat_name_table_dump_header

YueHaibing <yuehaibing@huawei.com>
    net: broadcom: Fix BCMGENET Kconfig

Rasmus Villemoes <linux@rasmusvillemoes.dk>
    net: stmmac: dwmac-meson8b: fix meson8b_devm_clk_prepare_enable()

Zhengchao Shao <shaozhengchao@huawei.com>
    can: af_can: fix NULL pointer dereference in can_rx_register()

Alexander Potapenko <glider@google.com>
    ipv6: addrlabel: fix infoleak when sending struct ifaddrlblmsg to network

Lu Wei <luwei32@huawei.com>
    tcp: prohibit TCP_REPAIR_OPTIONS if data was already sent

Yuan Can <yuancan@huawei.com>
    drm/vc4: Fix missing platform_unregister_drivers() call in vc4_drm_register()

HW He <hw.he@mediatek.com>
    net: wwan: mhi: fix memory leak in mhi_mbim_dellink

HW He <hw.he@mediatek.com>
    net: wwan: iosm: fix memory leak in ipc_wwan_dellink

Zhengchao Shao <shaozhengchao@huawei.com>
    hamradio: fix issue of dev reference count leakage in bpq_device_event()

Zhengchao Shao <shaozhengchao@huawei.com>
    net: lapbether: fix issue of dev reference count leakage in lapbeth_device_event()

Nico Boehr <nrb@linux.ibm.com>
    KVM: s390: pv: don't allow userspace to set the clock under PV

John Thomson <git@johnthomson.fastmail.com.au>
    phy: ralink: mt7621-pci: add sentinel to quirks table

Gaosheng Cui <cuigaosheng1@huawei.com>
    capabilities: fix undefined behavior in bit shift for CAP_TO_MASK

Sean Anderson <sean.anderson@seco.com>
    net: fman: Unregister ethernet device on removal

Alex Barba <alex.barba@broadcom.com>
    bnxt_en: fix potentially incorrect return value for ndo_rx_flow_steer

Michael Chan <michael.chan@broadcom.com>
    bnxt_en: Fix possible crash in bnxt_hwrm_set_coal()

Wang Yufen <wangyufen@huawei.com>
    net: tun: Fix memory leaks of napi_get_frags

Ratheesh Kannoth <rkannoth@marvell.com>
    octeontx2-pf: NIX TX overwrites SQ_CTX_HW_S[SQ_INT]

Geetha sowjanya <gakula@marvell.com>
    octeontx2-pf: Use hardware register for CQE count

Sabrina Dubroca <sd@queasysnail.net>
    macsec: clear encryption keys from the stack after setting up offload

Sabrina Dubroca <sd@queasysnail.net>
    macsec: fix detection of RXSCs when toggling offloading

Sabrina Dubroca <sd@queasysnail.net>
    macsec: fix secy->n_rx_sc accounting

Sabrina Dubroca <sd@queasysnail.net>
    macsec: delete new rxsc when offload fails

Jiri Benc <jbenc@redhat.com>
    net: gso: fix panic on frag_list with mixed head alloc types

Youlin Li <liulin063@gmail.com>
    bpf: Fix wrong reg type conversion in release_reference()

Kumar Kartikeya Dwivedi <memxor@gmail.com>
    bpf: Add helper macro bpf_for_each_reg_in_vstate

Cong Wang <cong.wang@bytedance.com>
    bpf, sock_map: Move cancel_work_sync() out of sock lock

John Fastabend <john.fastabend@gmail.com>
    bpf: Fix sockmap calling sleepable function in teardown path

Wang Yufen <wangyufen@huawei.com>
    bpf, sockmap: Fix sk->sk_forward_alloc warn_on in sk_stream_kill_queues

Yang Yingliang <yangyingliang@huawei.com>
    HID: hyperv: fix possible memory leak in mousevsc_probe()

Pu Lehui <pulehui@huawei.com>
    bpftool: Fix NULL pointer dereference when pin {PROG, MAP, LINK} without FILE

Howard Hsu <howard-yh.hsu@mediatek.com>
    wifi: mac80211: Set TWT Information Frame Disabled bit as 1

Wang Yufen <wangyufen@huawei.com>
    bpf, sockmap: Fix the sk->sk_forward_alloc warning of sk_stream_kill_queues

Kees Cook <keescook@chromium.org>
    bpf, verifier: Fix memory leak in array reallocation for stack state

Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
    soundwire: qcom: check for outanding writes before doing a read

Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
    soundwire: qcom: reinit broadcast completion

Arend van Spriel <arend.vanspriel@broadcom.com>
    wifi: cfg80211: fix memory leak in query_regdb_file()

Johannes Berg <johannes.berg@intel.com>
    wifi: cfg80211: silence a sparse RCU warning

Dan Carpenter <dan.carpenter@oracle.com>
    phy: stm32: fix an error code in probe

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    hwspinlock: qcom: correct MMIO max register for newer SoCs

Yang Li <yang.lee@linux.alibaba.com>
    drm/amdkfd: Fix NULL pointer dereference in svm_migrate_to_ram()

Philip Yang <Philip.Yang@amd.com>
    drm/amdkfd: handle CPU fault on COW mapping

Alex Sierra <alex.sierra@amd.com>
    drm/amdkfd: avoid recursive lock in migrations back to RAM

Miklos Szeredi <mszeredi@redhat.com>
    fuse: fix readdir cache race

Sanjay R Mehta <sanju.mehta@amd.com>
    thunderbolt: Add DP OUT resource when DP tunnel is discovered

Mika Westerberg <mika.westerberg@linux.intel.com>
    thunderbolt: Tear down existing tunnels when resuming from hibernate


-------------

Diffstat:

 Documentation/virt/kvm/devices/vm.rst              |   3 +
 Makefile                                           |   4 +-
 arch/arm64/kernel/efi.c                            |  52 ++++---
 arch/mips/kernel/jump_label.c                      |   2 +-
 arch/riscv/kernel/process.c                        |   2 +
 arch/riscv/kernel/setup.c                          |   1 +
 arch/riscv/kernel/vdso/Makefile                    |   2 +-
 arch/riscv/mm/init.c                               |   1 -
 arch/s390/kvm/kvm-s390.c                           |  26 ++--
 arch/s390/kvm/kvm-s390.h                           |   1 -
 drivers/ata/libata-scsi.c                          |   3 +
 drivers/dma/at_hdmac.c                             | 153 ++++++++-------------
 drivers/dma/at_hdmac_regs.h                        |  10 +-
 drivers/dma/mv_xor_v2.c                            |   1 +
 drivers/dma/pxa_dma.c                              |   4 +-
 drivers/dma/ti/k3-udma-glue.c                      |   3 +
 drivers/gpu/drm/amd/amdkfd/kfd_migrate.c           |  49 +++++--
 drivers/gpu/drm/amd/amdkfd/kfd_priv.h              |   1 +
 drivers/gpu/drm/amd/amdkfd/kfd_svm.c               |   2 +
 .../drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c    |   4 +-
 drivers/gpu/drm/i915/gem/i915_gem_dmabuf.c         |   4 +-
 drivers/gpu/drm/vc4/vc4_drv.c                      |   7 +-
 drivers/hid/hid-hyperv.c                           |   2 +-
 drivers/hwspinlock/qcom_hwspinlock.c               |   2 +-
 drivers/mmc/host/sdhci-cqhci.h                     |  24 ++++
 drivers/mmc/host/sdhci-esdhc-imx.c                 |   7 +-
 drivers/mmc/host/sdhci-of-arasan.c                 |   3 +-
 drivers/mmc/host/sdhci-tegra.c                     |   3 +-
 drivers/mmc/host/sdhci_am654.c                     |   7 +-
 drivers/net/ethernet/apm/xgene/xgene_enet_main.c   |   4 +-
 drivers/net/ethernet/aquantia/atlantic/aq_macsec.c |   2 +
 .../ethernet/aquantia/atlantic/macsec/macsec_api.c |  18 ++-
 drivers/net/ethernet/broadcom/Kconfig              |   2 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |   2 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c  |   2 +-
 drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c    |   1 +
 .../net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c    |   2 +-
 drivers/net/ethernet/freescale/fman/mac.c          |   9 ++
 drivers/net/ethernet/marvell/mv643xx_eth.c         |   1 +
 .../ethernet/marvell/octeontx2/nic/otx2_common.c   |   3 +
 .../ethernet/marvell/octeontx2/nic/otx2_common.h   |   1 +
 .../net/ethernet/marvell/octeontx2/nic/otx2_pf.c   | 135 ++++++++++++++----
 .../ethernet/marvell/octeontx2/nic/otx2_struct.h   |  57 ++++++++
 .../net/ethernet/marvell/octeontx2/nic/otx2_txrx.c |  69 +++++++++-
 .../net/ethernet/marvell/octeontx2/nic/otx2_txrx.h |   5 +
 .../net/ethernet/marvell/prestera/prestera_rxtx.c  |   7 +-
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c      |  11 +-
 .../ethernet/mellanox/mlx5/core/en/rep/bridge.c    |  31 +++++
 .../mellanox/mlx5/core/eswitch_offloads_termtbl.c  |  14 +-
 drivers/net/ethernet/neterion/s2io.c               |  29 ++--
 drivers/net/ethernet/ni/nixge.c                    |   1 +
 drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c  |  14 +-
 .../net/ethernet/stmicro/stmmac/dwmac-loongson.c   |  39 ++++--
 .../net/ethernet/stmicro/stmmac/dwmac-meson8b.c    |   8 +-
 drivers/net/ethernet/ti/cpsw.c                     |   2 +
 drivers/net/ethernet/tundra/tsi108_eth.c           |   5 +-
 drivers/net/hamradio/bpqether.c                    |   2 +-
 drivers/net/macsec.c                               |  23 ++--
 drivers/net/macvlan.c                              |   4 +-
 drivers/net/phy/mscc/mscc_macsec.c                 |   1 +
 drivers/net/tun.c                                  |  18 ++-
 drivers/net/wan/lapbether.c                        |   3 +-
 drivers/net/wireless/ath/ath11k/reg.c              |   6 +-
 drivers/net/wwan/iosm/iosm_ipc_pcie.c              |  11 +-
 drivers/net/wwan/iosm/iosm_ipc_wwan.c              |   1 +
 drivers/net/wwan/mhi_wwan_mbim.c                   |   1 +
 drivers/phy/ralink/phy-mt7621-pci.c                |   3 +-
 drivers/phy/st/phy-stm32-usbphyc.c                 |   2 +
 drivers/platform/x86/hp-wmi.c                      |  12 +-
 drivers/soundwire/qcom.c                           |   9 ++
 drivers/thunderbolt/path.c                         |  42 +++---
 drivers/thunderbolt/tb.c                           |  96 ++++++++++---
 drivers/thunderbolt/tb.h                           |   5 +-
 drivers/thunderbolt/tunnel.c                       |  27 ++--
 drivers/thunderbolt/tunnel.h                       |   9 +-
 fs/btrfs/disk-io.c                                 |   4 +-
 fs/btrfs/tests/btrfs-tests.c                       |   2 +-
 fs/btrfs/volumes.c                                 |  27 ++--
 fs/btrfs/volumes.h                                 |   2 +-
 fs/fuse/readdir.c                                  |  10 +-
 fs/nilfs2/segment.c                                |  15 +-
 fs/nilfs2/super.c                                  |   2 -
 fs/nilfs2/the_nilfs.c                              |   2 -
 fs/udf/namei.c                                     |   2 +-
 include/asm-generic/vmlinux.lds.h                  |   2 +-
 include/linux/bpf.h                                |   1 +
 include/linux/bpf_verifier.h                       |  21 +++
 include/linux/skmsg.h                              |   3 +-
 include/linux/soc/marvell/octeontx2/asm.h          |  15 ++
 include/uapi/linux/capability.h                    |   2 +-
 kernel/bpf/verifier.c                              | 148 ++++++--------------
 mm/damon/dbgfs.c                                   |   7 +
 mm/memremap.c                                      |   1 +
 mm/userfaultfd.c                                   |   2 +-
 net/can/af_can.c                                   |   2 +-
 net/can/j1939/main.c                               |   3 +
 net/core/skbuff.c                                  |  36 ++---
 net/core/skmsg.c                                   |   8 +-
 net/core/sock_map.c                                |  28 +++-
 net/ipv4/tcp.c                                     |   2 +-
 net/ipv4/tcp_bpf.c                                 |   9 +-
 net/ipv6/addrlabel.c                               |   1 +
 net/mac80211/s1g.c                                 |   3 +
 net/mctp/af_mctp.c                                 |   4 +-
 net/mctp/route.c                                   |   2 +-
 net/netfilter/nf_tables_api.c                      |   3 +-
 net/netfilter/nfnetlink.c                          |   1 +
 net/tipc/netlink_compat.c                          |   2 +-
 net/wireless/reg.c                                 |  12 +-
 net/wireless/scan.c                                |   4 +-
 scripts/extract-cert.c                             |   7 +
 scripts/sign-file.c                                |   7 +
 sound/hda/hdac_sysfs.c                             |   4 +-
 sound/pci/hda/hda_intel.c                          |   3 +
 sound/pci/hda/patch_ca0132.c                       |   1 +
 sound/pci/hda/patch_realtek.c                      |   1 +
 sound/usb/card.c                                   |  29 ++--
 sound/usb/quirks-table.h                           |   4 +
 sound/usb/quirks.c                                 |   1 +
 tools/bpf/bpftool/common.c                         |   3 +
 tools/perf/.gitignore                              |   1 +
 tools/perf/util/stat-display.c                     |   2 +-
 122 files changed, 1072 insertions(+), 511 deletions(-)


