Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D29F382E27
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 16:03:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235619AbhEQOEg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 10:04:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:53250 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230507AbhEQOEg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:04:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1C4FF61074;
        Mon, 17 May 2021 14:03:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621260198;
        bh=+DbWOZQCsDibM3lgI5/nV0civXRkpXf9xOd+u24SoqE=;
        h=From:To:Cc:Subject:Date:From;
        b=ttg2Xk/3c+d7stH+KdTqABPC8Q00S6uDjI5dWLtDsEOkZ10/TFofLP//da/BnSEm9
         Da2pRVcoOa+Q3PcZ8B0xAPjevwjGT/0uoU9VPCH5Ht3KfzPo6z9NJojaqekgN+yvL5
         CDygHC3IOQK3TjnNKRpDmqr77EKV+nXYW+sx3q24=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 5.4 000/141] 5.4.120-rc1 review
Date:   Mon, 17 May 2021 16:00:52 +0200
Message-Id: <20210517140242.729269392@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.120-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.120-rc1
X-KernelTest-Deadline: 2021-05-19T14:02+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.4.120 release.
There are 141 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 19 May 2021 14:02:20 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.120-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.4.120-rc1

Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
    ASoC: rsnd: check all BUSIF status when error

Christoph Hellwig <hch@lst.de>
    nvme: do not try to reconfigure APST when the controller is not live

Paweł Chmiel <pawel.mikolaj.chmiel@gmail.com>
    clk: exynos7: Mark aclk_fsys1_200 as critical

Jonathon Reinhart <jonathon.reinhart@gmail.com>
    netfilter: conntrack: Make global sysctls readonly in non-init netns

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    kobject_uevent: remove warning in init_uevent_argv()

Badhri Jagan Sridharan <badhri@google.com>
    usb: typec: tcpm: Fix error while calculating PPS out values

Ard Biesheuvel <ardb@kernel.org>
    ARM: 9027/1: head.S: explicitly map DT even if it lives in the first physical section

Ard Biesheuvel <ardb@kernel.org>
    ARM: 9020/1: mm: use correct section size macro to describe the FDT virtual address

Ard Biesheuvel <ardb@kernel.org>
    ARM: 9012/1: move device tree mapping out of linear region

Ard Biesheuvel <ardb@kernel.org>
    ARM: 9011/1: centralize phys-to-virt conversion of DT/ATAGS address

Eric Biggers <ebiggers@google.com>
    f2fs: fix error handling in f2fs_end_enable_verity()

Lukasz Luba <lukasz.luba@arm.com>
    thermal/core/fair share: Lock the thermal zone while looping over instances

Maciej W. Rozycki <macro@orcam.me.uk>
    MIPS: Avoid handcoded DIVU in `__div64_32' altogether

Maciej W. Rozycki <macro@orcam.me.uk>
    MIPS: Avoid DIVU in `__div64_32' is result would be zero

Maciej W. Rozycki <macro@orcam.me.uk>
    MIPS: Reinstate platform `__div64_32' handler

Maciej W. Rozycki <macro@orcam.me.uk>
    FDDI: defxx: Make MMIO the configuration default except for EISA

Matthew Wilcox (Oracle) <willy@infradead.org>
    mm: fix struct page layout on 32-bit systems

Thomas Gleixner <tglx@linutronix.de>
    KVM: x86: Cancel pvclock_gtod_work on module removal

Oliver Neukum <oneukum@suse.com>
    cdc-wdm: untangle a circular dependency between callback and softint

Colin Ian King <colin.king@canonical.com>
    iio: tsl2583: Fix division by a zero lux_val

Dmitry Osipenko <digetx@gmail.com>
    iio: gyro: mpu3050: Fix reported temperature value

Sandeep Singh <sandeep.singh@amd.com>
    xhci: Add reset resume quirk for AMD xhci controller.

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    xhci: Do not use GFP_KERNEL in (potentially) atomic context

Wesley Cheng <wcheng@codeaurora.org>
    usb: dwc3: gadget: Return success always for kick transfer in ep queue

Chunfeng Yun <chunfeng.yun@mediatek.com>
    usb: core: hub: fix race condition about TRSMRCY of resume

Phil Elwell <phil@raspberrypi.com>
    usb: dwc2: Fix gadget DMA unmap direction

Maximilian Luz <luzmaximilian@gmail.com>
    usb: xhci: Increase timeout for HC halt

Ferry Toth <ftoth@exalondelft.nl>
    usb: dwc3: pci: Enable usb2-gadget-lpm-disable for Intel Merrifield

Marcel Hamer <marcel@solidxs.se>
    usb: dwc3: omap: improve extcon initialization

Christoph Hellwig <hch@lst.de>
    iomap: fix sub-page uptodate handling

Bart Van Assche <bvanassche@acm.org>
    blk-mq: Swap two calls in blk_mq_exit_queue()

Sun Ke <sunke32@huawei.com>
    nbd: Fix NULL pointer in flush_workqueue

Omar Sandoval <osandov@fb.com>
    kyber: fix out of bounds access when preempted

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    ACPI: scan: Fix a memory leak in an error handling path

Eddie James <eajames@linux.ibm.com>
    hwmon: (occ) Fix poll rate limiting

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    usb: fotg210-hcd: Fix an error message

Dinghao Liu <dinghao.liu@zju.edu.cn>
    iio: proximity: pulsedlight: Fix rumtime PM imbalance on error

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/i915: Avoid div-by-zero on gen2

Kai-Heng Feng <kai.heng.feng@canonical.com>
    drm/radeon/dpm: Disable sclk switching on Oland when two 4K 60Hz monitors are connected

Peter Xu <peterx@redhat.com>
    mm/hugetlb: fix F_SEAL_FUTURE_WRITE

Axel Rasmussen <axelrasmussen@google.com>
    userfaultfd: release page in error path to avoid BUG_ON

Phillip Lougher <phillip@squashfs.org.uk>
    squashfs: fix divide error in calculate_skip()

Jouni Roivas <jouni.roivas@tuxera.com>
    hfsplus: prevent corruption in shrinking truncate

Michael Ellerman <mpe@ellerman.id.au>
    powerpc/64s: Fix crashes when toggling entry flush barrier

Michael Ellerman <mpe@ellerman.id.au>
    powerpc/64s: Fix crashes when toggling stf barrier

Vladimir Isaev <isaev@synopsys.com>
    ARC: mm: PAE: use 40-bit physical page mask

Vineet Gupta <vgupta@synopsys.com>
    ARC: entry: fix off-by-one error in syscall number validation

Mateusz Palczewski <mateusz.palczewski@intel.com>
    i40e: Fix PHY type identifiers for 2.5G and 5G adapters

Jaroslaw Gawin <jaroslawx.gawin@intel.com>
    i40e: fix the restart auto-negotiation after FEC modified

Yunjian Wang <wangyunjian@huawei.com>
    i40e: Fix use-after-free in i40e_client_subtask()

Eric Dumazet <edumazet@google.com>
    netfilter: nftables: avoid overflows in nft_hash_buckets()

Jia-Ju Bai <baijiaju1990@gmail.com>
    kernel: kexec_file: fix error return code of kexec_calculate_store_digests()

Odin Ugedal <odin@uged.al>
    sched/fair: Fix unfairness caused by missing load decay

Quentin Perret <qperret@google.com>
    sched: Fix out-of-bound access in uclamp

Marc Kleine-Budde <mkl@pengutronix.de>
    can: m_can: m_can_tx_work_queue(): fix tx_skb race condition

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nfnetlink_osf: Fix a missing skb_header_pointer() NULL check

Cong Wang <cong.wang@bytedance.com>
    smc: disallow TCP_ULP in smc_setsockopt()

Maciej Żenczykowski <maze@google.com>
    net: fix nla_strcmp to handle more then one trailing null character

Miaohe Lin <linmiaohe@huawei.com>
    ksm: fix potential missing rmap_item for stable_node

Miaohe Lin <linmiaohe@huawei.com>
    mm/migrate.c: fix potential indeterminate pte entry in migrate_vma_insert_page()

Miaohe Lin <linmiaohe@huawei.com>
    mm/hugeltb: handle the error case in hugetlb_fix_reserve_counts()

Miaohe Lin <linmiaohe@huawei.com>
    khugepaged: fix wrong result value for trace_mm_collapse_huge_page_isolate()

Kees Cook <keescook@chromium.org>
    drm/radeon: Avoid power table parsing memory leaks

Kees Cook <keescook@chromium.org>
    drm/radeon: Fix off-by-one power_state index heap overwrite

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: xt_SECMARK: add new revision to fix structure layout

Xin Long <lucien.xin@gmail.com>
    sctp: fix a SCTP_MIB_CURRESTAB leak in sctp_sf_do_dupcook_b

Lv Yunlong <lyl2019@mail.ustc.edu.cn>
    ethernet:enic: Fix a use after free bug in enic_hard_start_xmit

Baptiste Lepers <baptiste.lepers@gmail.com>
    sunrpc: Fix misplaced barrier in call_decode

Anup Patel <anup.patel@wdc.com>
    RISC-V: Fix error code returned by riscv_hartid_to_cpuid()

Xin Long <lucien.xin@gmail.com>
    sctp: do asoc update earlier in sctp_sf_do_dupcook_a

Yufeng Mo <moyufeng@huawei.com>
    net: hns3: disable phy loopback setting in hclge_mac_start_phy

Peng Li <lipeng321@huawei.com>
    net: hns3: use netif_tx_disable to stop the transmit queue

Hao Chen <chenhao288@hisilicon.com>
    net: hns3: fix for vxlan gpe tx checksum bug

Jian Shen <shenjian15@huawei.com>
    net: hns3: add check for HNS3_NIC_STATE_INITED in hns3_reset_notify_up_enet()

Yufeng Mo <moyufeng@huawei.com>
    net: hns3: initialize the message content in hclge_get_link_mode()

Yufeng Mo <moyufeng@huawei.com>
    net: hns3: fix incorrect configuration for igu_egu_hw_err

Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
    rtc: ds1307: Fix wday settings for rx8130

Jeff Layton <jlayton@kernel.org>
    ceph: fix inode leak on getattr error in __fh_to_dentry

Michael Walle <michael@walle.cc>
    rtc: fsl-ftm-alarm: add MODULE_TABLE()

Olga Kornievskaia <kolga@netapp.com>
    NFSv4.2 fix handling of sr_eof in SEEK's reply

Nikola Livic <nlivic@gmail.com>
    pNFS/flexfiles: fix incorrect size check in decode_nfs_fh()

Yang Yingliang <yangyingliang@huawei.com>
    PCI: endpoint: Fix missing destroy_workqueue()

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFS: Deal correctly with attribute generation counter overflow

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFSv4.2: Always flush out writes in nfs42_proc_fallocate()

Jia-Ju Bai <baijiaju1990@gmail.com>
    rpmsg: qcom_glink_native: fix error return code of qcom_glink_rx_data()

Zhen Lei <thunder.leizhen@huawei.com>
    ARM: 9064/1: hw_breakpoint: Do not directly check the event's overflow_handler hook

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    PCI: Release OF node in pci_scan_device()'s error path

Pali Rohár <pali@kernel.org>
    PCI: iproc: Fix return value of iproc_msi_irq_domain_alloc()

Colin Ian King <colin.king@canonical.com>
    f2fs: fix a redundant call to f2fs_balance_fs if an error occurs

Jia-Ju Bai <baijiaju1990@gmail.com>
    thermal: thermal_of: Fix error return code of thermal_of_populate_bind_params()

David Ward <david.ward@gatech.edu>
    ASoC: rt286: Make RT286_SET_GPIO_* readable and writable

Sergei Trofimovich <slyfox@gentoo.org>
    ia64: module: fix symbolizer crash on fdescr

Michael Chan <michael.chan@broadcom.com>
    bnxt_en: Add PCI IDs for Hyper-V VF devices.

Felix Fietkau <nbd@nbd.name>
    net: ethernet: mtk_eth_soc: fix RX VLAN offload

Stefan Assmann <sassmann@kpanic.de>
    iavf: remove duplicate free resources calls

Alexey Kardashevskiy <aik@ozlabs.ru>
    powerpc/iommu: Annotate nested lock for lockdep

Lee Gibson <leegib@gmail.com>
    qtnfmac: Fix possible buffer overflow in qtnf_event_handle_external_auth

Gustavo A. R. Silva <gustavoars@kernel.org>
    wl3501_cs: Fix out-of-bounds warnings in wl3501_mgmt_join

Gustavo A. R. Silva <gustavoars@kernel.org>
    wl3501_cs: Fix out-of-bounds warnings in wl3501_send_pkt

Robin Singh <robin.singh@amd.com>
    drm/amd/display: fixed divide by zero kernel crash during dsc enablement

Michael Ellerman <mpe@ellerman.id.au>
    powerpc/pseries: Stop calling printk in rtas_stop_self()

Yaqi Chen <chendotjs@gmail.com>
    samples/bpf: Fix broken tracex1 due to kprobe argument change

Du Cheng <ducheng2@gmail.com>
    net: sched: tapr: prevent cycle_time == 0 in parse_taprio_schedule

Gustavo A. R. Silva <gustavoars@kernel.org>
    ethtool: ioctl: Fix out-of-bounds warning in store_link_ksettings_for_user()

David Ward <david.ward@gatech.edu>
    ASoC: rt286: Generalize support for ALC3263 codec

Srikar Dronamraju <srikar@linux.vnet.ibm.com>
    powerpc/smp: Set numa node before updating mask

Gustavo A. R. Silva <gustavoars@kernel.org>
    flow_dissector: Fix out-of-bounds warning in __skb_flow_bpf_to_target()

Gustavo A. R. Silva <gustavoars@kernel.org>
    sctp: Fix out-of-bounds warning in sctp_process_asconf_param()

Kai Vehmanen <kai.vehmanen@linux.intel.com>
    ALSA: hda/hdmi: fix race in handling acomp ELD notification at resume

Mihai Moldovan <ionic@ionic.de>
    kconfig: nconf: stop endless search loops

Yonghong Song <yhs@fb.com>
    selftests: Set CC to clang in lib.mk if LLVM is set

Anthony Wang <anthony1.wang@amd.com>
    drm/amd/display: Force vsync flip when reconfiguring MPCC

Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
    iommu/amd: Remove performance counter pre-initialization test

Paul Menzel <pmenzel@molgen.mpg.de>
    Revert "iommu/amd: Fix performance counter initialization"

Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
    ASoC: rsnd: call rsnd_ssi_master_clk_start() from rsnd_ssi_init()

Miklos Szeredi <mszeredi@redhat.com>
    cuse: prevent clone

David Bauer <mail@david-bauer.net>
    mt76: mt76x0: disable GTK offloading

Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
    pinctrl: samsung: use 'int' for register masks in Exynos

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    mac80211: clear the beacon's CRC after channel switch

Bence Csókás <bence98@sch.bme.hu>
    i2c: Add I2C_AQ_NO_REP_START adapter quirk

Hans de Goede <hdegoede@redhat.com>
    ASoC: Intel: bytcr_rt5640: Add quirk for the Chuwi Hi8 tablet

Eric Dumazet <edumazet@google.com>
    ip6_vti: proper dev_{hold|put} in ndo_[un]init methods

Archie Pusaka <apusaka@chromium.org>
    Bluetooth: check for zapped sk before connecting

Nikolay Aleksandrov <nikolay@nvidia.com>
    net: bridge: when suppression is enabled exclude RARP packets

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    Bluetooth: initialize skb_queue_head at l2cap_chan_create()

Archie Pusaka <apusaka@chromium.org>
    Bluetooth: Set CONF_NOT_COMPLETE as l2cap_chan default

Takashi Sakamoto <o-takashi@sakamocchi.jp>
    ALSA: bebob: enable to deliver MIDI messages for multiple ports

Tong Zhang <ztong0001@gmail.com>
    ALSA: rme9652: don't disable if not enabled

Tong Zhang <ztong0001@gmail.com>
    ALSA: hdspm: don't disable if not enabled

Tong Zhang <ztong0001@gmail.com>
    ALSA: hdsp: don't disable if not enabled

Wolfram Sang <wsa+renesas@sang-engineering.com>
    i2c: bail out early when RDWR parameters are wrong

Mikhail Durnev <mikhail_durnev@mentor.com>
    ASoC: rsnd: core: Check convert rate in rsnd_hw_params

Jonathan McDowell <noodles@earth.li>
    net: stmmac: Set FIFO sizes for ipq806x

Hans de Goede <hdegoede@redhat.com>
    ASoC: Intel: bytcr_rt5640: Enable jack-detect support on Asus T100TAF

Hoang Le <hoang.h.le@dektech.com.au>
    tipc: convert dest node's address to network order

Alexander Aring <aahringo@redhat.com>
    fs: dlm: fix debugfs dump

Tony Lindgren <tony@atomide.com>
    PM: runtime: Fix unpaired parent child_count for force_resume

Sean Christopherson <seanjc@google.com>
    KVM: x86/mmu: Remove the defunct update_pte() paging hook

Jarkko Sakkinen <jarkko@kernel.org>
    tpm, tpm_tis: Reserve locality in tpm_tis_resume()

Jarkko Sakkinen <jarkko@kernel.org>
    tpm, tpm_tis: Extend locality handling to TPM2 in tpm_tis_gen_interrupt()

Zhen Lei <thunder.leizhen@huawei.com>
    tpm: fix error return code in tpm2_get_cc_attrs_tbl()


-------------

Diffstat:

 Documentation/arm/memory.rst                       |  7 +-
 Makefile                                           |  4 +-
 arch/arc/include/asm/page.h                        | 12 +++
 arch/arc/include/asm/pgtable.h                     | 12 +--
 arch/arc/include/uapi/asm/page.h                   |  1 -
 arch/arc/kernel/entry.S                            |  4 +-
 arch/arc/mm/ioremap.c                              |  5 +-
 arch/arc/mm/tlb.c                                  |  2 +-
 arch/arm/include/asm/fixmap.h                      |  2 +-
 arch/arm/include/asm/memory.h                      |  5 ++
 arch/arm/include/asm/prom.h                        |  4 +-
 arch/arm/kernel/atags.h                            |  4 +-
 arch/arm/kernel/atags_parse.c                      |  6 +-
 arch/arm/kernel/devtree.c                          |  6 +-
 arch/arm/kernel/head.S                             |  9 +--
 arch/arm/kernel/hw_breakpoint.c                    |  2 +-
 arch/arm/kernel/setup.c                            | 19 +++--
 arch/arm/mm/init.c                                 |  1 -
 arch/arm/mm/mmu.c                                  | 20 +++--
 arch/arm/mm/pv-fixup-asm.S                         |  4 +-
 arch/ia64/include/asm/module.h                     |  6 +-
 arch/ia64/kernel/module.c                          | 29 ++++++-
 arch/mips/include/asm/div64.h                      | 55 ++++++++++----
 arch/powerpc/kernel/iommu.c                        |  4 +-
 arch/powerpc/kernel/smp.c                          |  6 +-
 arch/powerpc/lib/feature-fixups.c                  | 35 ++++++++-
 arch/powerpc/platforms/pseries/hotplug-cpu.c       |  3 -
 arch/riscv/kernel/smp.c                            |  2 +-
 arch/x86/include/asm/kvm_host.h                    |  3 -
 arch/x86/kvm/mmu.c                                 | 33 +-------
 arch/x86/kvm/x86.c                                 |  2 +-
 block/bfq-iosched.c                                |  3 +-
 block/blk-mq-sched.c                               |  8 +-
 block/blk-mq.c                                     |  6 +-
 block/kyber-iosched.c                              |  5 +-
 block/mq-deadline.c                                |  3 +-
 drivers/acpi/scan.c                                |  1 +
 drivers/base/power/runtime.c                       | 10 ++-
 drivers/block/nbd.c                                |  3 +-
 drivers/char/tpm/tpm2-cmd.c                        |  1 +
 drivers/char/tpm/tpm_tis_core.c                    | 22 ++++--
 drivers/clk/samsung/clk-exynos7.c                  |  7 +-
 drivers/gpu/drm/amd/display/dc/core/dc.c           |  4 +
 drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hubp.c  | 15 ++--
 drivers/gpu/drm/i915/gem/i915_gem_mman.c           |  2 +-
 drivers/gpu/drm/radeon/radeon.h                    |  1 +
 drivers/gpu/drm/radeon/radeon_atombios.c           | 26 +++++--
 drivers/gpu/drm/radeon/radeon_pm.c                 |  8 ++
 drivers/gpu/drm/radeon/si_dpm.c                    |  3 +
 drivers/hwmon/occ/common.c                         |  5 +-
 drivers/hwmon/occ/common.h                         |  2 +-
 drivers/i2c/i2c-dev.c                              |  9 ++-
 drivers/iio/gyro/mpu3050-core.c                    | 13 +++-
 drivers/iio/light/tsl2583.c                        |  8 ++
 drivers/iio/proximity/pulsedlight-lidar-lite-v2.c  |  1 +
 drivers/iommu/amd_iommu_init.c                     | 49 +-----------
 drivers/net/can/m_can/m_can.c                      |  3 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          | 19 ++++-
 drivers/net/ethernet/cisco/enic/enic_main.c        |  7 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    | 12 ++-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c |  3 +-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_err.h |  3 +-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c |  2 +-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_mdio.c    |  2 +
 drivers/net/ethernet/intel/i40e/i40e_adminq_cmd.h  |  6 +-
 drivers/net/ethernet/intel/i40e/i40e_client.c      |  1 +
 drivers/net/ethernet/intel/i40e/i40e_common.c      |  4 +-
 drivers/net/ethernet/intel/i40e/i40e_ethtool.c     |  7 +-
 drivers/net/ethernet/intel/i40e/i40e_type.h        |  7 +-
 drivers/net/ethernet/intel/iavf/iavf_main.c        |  2 -
 drivers/net/ethernet/mediatek/mtk_eth_soc.c        |  2 +-
 drivers/net/ethernet/mediatek/mtk_eth_soc.h        |  1 +
 .../net/ethernet/stmicro/stmmac/dwmac-ipq806x.c    |  2 +
 drivers/net/fddi/Kconfig                           | 15 ++--
 drivers/net/wireless/mediatek/mt76/mt76x02_util.c  |  4 +
 drivers/net/wireless/quantenna/qtnfmac/event.c     |  6 +-
 drivers/net/wireless/wl3501.h                      | 47 ++++++------
 drivers/net/wireless/wl3501_cs.c                   | 54 +++++++------
 drivers/nvme/host/core.c                           |  3 +-
 drivers/pci/controller/pcie-iproc-msi.c            |  2 +-
 drivers/pci/endpoint/functions/pci-epf-test.c      |  3 +
 drivers/pci/probe.c                                |  1 +
 drivers/pinctrl/samsung/pinctrl-exynos.c           | 10 +--
 drivers/rpmsg/qcom_glink_native.c                  |  1 +
 drivers/rtc/rtc-ds1307.c                           | 12 ++-
 drivers/rtc/rtc-fsl-ftm-alarm.c                    |  1 +
 drivers/thermal/fair_share.c                       |  4 +
 drivers/thermal/of-thermal.c                       |  7 +-
 drivers/usb/class/cdc-wdm.c                        | 30 ++++++--
 drivers/usb/core/hub.c                             |  6 +-
 drivers/usb/dwc2/core.h                            |  2 +
 drivers/usb/dwc2/gadget.c                          |  3 +-
 drivers/usb/dwc3/dwc3-omap.c                       |  5 ++
 drivers/usb/dwc3/dwc3-pci.c                        |  1 +
 drivers/usb/dwc3/gadget.c                          |  4 +-
 drivers/usb/host/fotg210-hcd.c                     |  4 +-
 drivers/usb/host/xhci-ext-caps.h                   |  5 +-
 drivers/usb/host/xhci-pci.c                        |  4 +-
 drivers/usb/host/xhci.c                            |  6 +-
 drivers/usb/typec/tcpm/tcpm.c                      |  6 +-
 fs/ceph/export.c                                   |  4 +-
 fs/dlm/debug_fs.c                                  |  1 +
 fs/f2fs/inline.c                                   |  3 +-
 fs/f2fs/verity.c                                   | 75 ++++++++++++------
 fs/fuse/cuse.c                                     |  2 +
 fs/hfsplus/extents.c                               |  7 +-
 fs/hugetlbfs/inode.c                               |  5 ++
 fs/iomap/buffered-io.c                             | 34 ++++++---
 fs/nfs/flexfilelayout/flexfilelayout.c             |  2 +-
 fs/nfs/inode.c                                     |  8 +-
 fs/nfs/nfs42proc.c                                 | 21 ++++--
 fs/squashfs/file.c                                 |  6 +-
 include/linux/elevator.h                           |  2 +-
 include/linux/i2c.h                                |  2 +
 include/linux/iomap.h                              |  1 +
 include/linux/mm.h                                 | 32 ++++++++
 include/linux/mm_types.h                           |  4 +-
 include/linux/pm.h                                 |  1 +
 include/net/page_pool.h                            | 12 ++-
 include/uapi/linux/netfilter/xt_SECMARK.h          |  6 ++
 kernel/kexec_file.c                                |  4 +-
 kernel/sched/core.c                                |  2 +-
 kernel/sched/fair.c                                | 12 ++-
 lib/kobject_uevent.c                               |  9 ++-
 lib/nlattr.c                                       |  2 +-
 mm/hugetlb.c                                       | 11 ++-
 mm/khugepaged.c                                    | 18 ++---
 mm/ksm.c                                           |  1 +
 mm/migrate.c                                       |  7 ++
 mm/shmem.c                                         | 34 ++++-----
 net/bluetooth/l2cap_core.c                         |  4 +
 net/bluetooth/l2cap_sock.c                         |  8 ++
 net/bridge/br_arp_nd_proxy.c                       |  4 +-
 net/core/ethtool.c                                 |  2 +-
 net/core/flow_dissector.c                          |  6 +-
 net/core/page_pool.c                               |  6 +-
 net/ipv6/ip6_vti.c                                 |  2 +-
 net/mac80211/mlme.c                                |  5 ++
 net/netfilter/nf_conntrack_standalone.c            |  5 +-
 net/netfilter/nfnetlink_osf.c                      |  2 +
 net/netfilter/nft_set_hash.c                       | 10 ++-
 net/netfilter/xt_SECMARK.c                         | 88 +++++++++++++++++-----
 net/sched/sch_taprio.c                             |  6 ++
 net/sctp/sm_make_chunk.c                           |  2 +-
 net/sctp/sm_statefuns.c                            | 28 +++++--
 net/smc/af_smc.c                                   |  4 +-
 net/sunrpc/clnt.c                                  | 11 ++-
 net/tipc/netlink_compat.c                          |  2 +-
 samples/bpf/tracex1_kern.c                         |  4 +-
 scripts/kconfig/nconf.c                            |  2 +-
 sound/firewire/bebob/bebob_stream.c                | 12 +--
 sound/pci/hda/patch_hdmi.c                         |  4 +-
 sound/pci/rme9652/hdsp.c                           |  3 +-
 sound/pci/rme9652/hdspm.c                          |  3 +-
 sound/pci/rme9652/rme9652.c                        |  3 +-
 sound/soc/codecs/rt286.c                           | 23 +++---
 sound/soc/intel/boards/bytcr_rt5640.c              | 20 +++++
 sound/soc/sh/rcar/core.c                           | 69 ++++++++++++++++-
 sound/soc/sh/rcar/ssi.c                            | 16 ++--
 tools/testing/selftests/lib.mk                     |  4 +
 160 files changed, 1035 insertions(+), 502 deletions(-)


