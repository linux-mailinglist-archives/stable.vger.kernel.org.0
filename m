Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D47C738A239
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 11:38:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233073AbhETJjg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 05:39:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:40532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232807AbhETJiF (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 05:38:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 43F606139A;
        Thu, 20 May 2021 09:30:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621503036;
        bh=j2RDawG61eNKFB2zjlVjaPP/Nsgskgg3iY9Ft6QrvjE=;
        h=From:To:Cc:Subject:Date:From;
        b=IIQr4CZ5QMkpXnkOjwH5dF4z38ROeC1U/XiB3zFmfYcb9LFvV2gVq+C/SAos/jTBG
         MIBtSYmu0lyICbfiMWA3upQHpB1Woe2MIE6/HuuOTYy56dWjA0OOSz3LD8XFQr4XT8
         d6gafvgku5d5IFc0f7Y3lrFfzyb/qjJ98c8NookU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 4.19 000/425] 4.19.191-rc1 review
Date:   Thu, 20 May 2021 11:16:09 +0200
Message-Id: <20210520092131.308959589@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.191-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.191-rc1
X-KernelTest-Deadline: 2021-05-22T09:21+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.19.191 release.
There are 425 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat, 22 May 2021 09:20:38 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.191-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.19.191-rc1

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    scripts: switch explicitly to Python 3

Finn Behrens <me@kloenk.de>
    tweewide: Fix most Shebang lines

Alexandru Elisei <alexandru.elisei@arm.com>
    KVM: arm64: Initialize VCPU mdcr_el2 before loading it

Christoph Hellwig <hch@lst.de>
    iomap: fix sub-page uptodate handling

Eric Dumazet <edumazet@google.com>
    ipv6: remove extra dev_hold() for fallback tunnels

Eric Dumazet <edumazet@google.com>
    ip6_tunnel: sit: proper dev_{hold|put} in ndo_[un]init methods

Eric Dumazet <edumazet@google.com>
    sit: proper dev_{hold|put} in ndo_[un]init methods

Eric Dumazet <edumazet@google.com>
    ip6_gre: proper dev_{hold|put} in ndo_[un]init methods

Yannick Vignon <yannick.vignon@nxp.com>
    net: stmmac: Do not enable RX FIFO overflow interrupts

Zqiang <qiang.zhang@windriver.com>
    lib: stackdepot: turn depot_lock spinlock to raw_spinlock

yangerkun <yangerkun@huawei.com>
    block: reexpand iov_iter after read/write

Hui Wang <hui.wang@canonical.com>
    ALSA: hda: generic: change the DAC ctl name for LO+SPK or LO+HP

Hans de Goede <hdegoede@redhat.com>
    gpiolib: acpi: Add quirk to ignore EC wakeups on Dell Venue 10 Pro 5055

Bodo Stroesser <bostroesser@gmail.com>
    scsi: target: tcmu: Return from tcmu_handle_completions() if cmd_id not found

Jeff Layton <jlayton@kernel.org>
    ceph: fix fscache invalidation

Nathan Chancellor <nathan@kernel.org>
    riscv: Workaround mcount name prior to clang-13

Nathan Chancellor <nathan@kernel.org>
    scripts/recordmcount.pl: Fix RISC-V regex for clang

Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
    ARM: 9075/1: kernel: Fix interrupted SMC calls

Johannes Berg <johannes.berg@intel.com>
    um: Mark all kernel symbols as local

Hans de Goede <hdegoede@redhat.com>
    Input: silead - add workaround for x86 BIOS-es which bring the chip up in a stuck state

Hans de Goede <hdegoede@redhat.com>
    Input: elants_i2c - do not bind to i2c-hid compatible ACPI instantiated devices

Feilong Lin <linfeilong@huawei.com>
    ACPI / hotplug / PCI: Fix reference count leak in enable_slot()

louis.wang <liang26812@gmail.com>
    ARM: 9066/1: ftrace: pause/unpause function graph tracer in cpu_suspend()

Arnd Bergmann <arnd@arndb.de>
    PCI: thunder: Fix compile testing

Ard Biesheuvel <ardb@kernel.org>
    ARM: 9058/1: cache-v7: refactor v7_invalidate_l1 to avoid clobbering r5/r6

Magnus Karlsson <magnus.karlsson@intel.com>
    xsk: Simplify detection of empty and full rings

Josh Poimboeuf <jpoimboe@redhat.com>
    pinctrl: ingenic: Improve unreachable code generation

Arnd Bergmann <arnd@arndb.de>
    isdn: capi: fix mismatched prototypes

Kaixu Xia <kaixuxia@tencent.com>
    cxgb4: Fix the -Wmisleading-indentation warning

Arnd Bergmann <arnd@arndb.de>
    usb: sl811-hcd: improve misleading indentation

Arnd Bergmann <arnd@arndb.de>
    kgdb: fix gcc-11 warning on indentation

Arnd Bergmann <arnd@arndb.de>
    x86/msr: Fix wr/rdmsr_safe_regs_on_cpu() prototypes

Christoph Hellwig <hch@lst.de>
    nvme: do not try to reconfigure APST when the controller is not live

Paweł Chmiel <pawel.mikolaj.chmiel@gmail.com>
    clk: exynos7: Mark aclk_fsys1_200 as critical

Jonathon Reinhart <jonathon.reinhart@gmail.com>
    netfilter: conntrack: Make global sysctls readonly in non-init netns

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    kobject_uevent: remove warning in init_uevent_argv()

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

Bart Van Assche <bvanassche@acm.org>
    blk-mq: Swap two calls in blk_mq_exit_queue()

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    ACPI: scan: Fix a memory leak in an error handling path

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    usb: fotg210-hcd: Fix an error message

Dinghao Liu <dinghao.liu@zju.edu.cn>
    iio: proximity: pulsedlight: Fix rumtime PM imbalance on error

Kai-Heng Feng <kai.heng.feng@canonical.com>
    drm/radeon/dpm: Disable sclk switching on Oland when two 4K 60Hz monitors are connected

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

Vineet Gupta <vgupta@synopsys.com>
    ARC: entry: fix off-by-one error in syscall number validation

Yunjian Wang <wangyunjian@huawei.com>
    i40e: Fix use-after-free in i40e_client_subtask()

Eric Dumazet <edumazet@google.com>
    netfilter: nftables: avoid overflows in nft_hash_buckets()

Jia-Ju Bai <baijiaju1990@gmail.com>
    kernel: kexec_file: fix error return code of kexec_calculate_store_digests()

Odin Ugedal <odin@uged.al>
    sched/fair: Fix unfairness caused by missing load decay

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nfnetlink_osf: Fix a missing skb_header_pointer() NULL check

Cong Wang <cong.wang@bytedance.com>
    smc: disallow TCP_ULP in smc_setsockopt()

Maciej Żenczykowski <maze@google.com>
    net: fix nla_strcmp to handle more then one trailing null character

Miaohe Lin <linmiaohe@huawei.com>
    ksm: fix potential missing rmap_item for stable_node

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

Xin Long <lucien.xin@gmail.com>
    sctp: do asoc update earlier in sctp_sf_do_dupcook_a

Yufeng Mo <moyufeng@huawei.com>
    net: hns3: disable phy loopback setting in hclge_mac_start_phy

Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
    rtc: ds1307: Fix wday settings for rx8130

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

David Ward <david.ward@gatech.edu>
    ASoC: rt286: Make RT286_SET_GPIO_* readable and writable

Sergei Trofimovich <slyfox@gentoo.org>
    ia64: module: fix symbolizer crash on fdescr

Felix Fietkau <nbd@nbd.name>
    net: ethernet: mtk_eth_soc: fix RX VLAN offload

Alexey Kardashevskiy <aik@ozlabs.ru>
    powerpc/iommu: Annotate nested lock for lockdep

Gustavo A. R. Silva <gustavoars@kernel.org>
    wl3501_cs: Fix out-of-bounds warnings in wl3501_mgmt_join

Gustavo A. R. Silva <gustavoars@kernel.org>
    wl3501_cs: Fix out-of-bounds warnings in wl3501_send_pkt

Michael Ellerman <mpe@ellerman.id.au>
    powerpc/pseries: Stop calling printk in rtas_stop_self()

Yaqi Chen <chendotjs@gmail.com>
    samples/bpf: Fix broken tracex1 due to kprobe argument change

Gustavo A. R. Silva <gustavoars@kernel.org>
    ethtool: ioctl: Fix out-of-bounds warning in store_link_ksettings_for_user()

David Ward <david.ward@gatech.edu>
    ASoC: rt286: Generalize support for ALC3263 codec

Srikar Dronamraju <srikar@linux.vnet.ibm.com>
    powerpc/smp: Set numa node before updating mask

Gustavo A. R. Silva <gustavoars@kernel.org>
    sctp: Fix out-of-bounds warning in sctp_process_asconf_param()

Mihai Moldovan <ionic@ionic.de>
    kconfig: nconf: stop endless search loops

Yonghong Song <yhs@fb.com>
    selftests: Set CC to clang in lib.mk if LLVM is set

Miklos Szeredi <mszeredi@redhat.com>
    cuse: prevent clone

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

Tong Zhang <ztong0001@gmail.com>
    ALSA: rme9652: don't disable if not enabled

Tong Zhang <ztong0001@gmail.com>
    ALSA: hdspm: don't disable if not enabled

Tong Zhang <ztong0001@gmail.com>
    ALSA: hdsp: don't disable if not enabled

Wolfram Sang <wsa+renesas@sang-engineering.com>
    i2c: bail out early when RDWR parameters are wrong

Jonathan McDowell <noodles@earth.li>
    net: stmmac: Set FIFO sizes for ipq806x

Hans de Goede <hdegoede@redhat.com>
    ASoC: Intel: bytcr_rt5640: Enable jack-detect support on Asus T100TAF

Hoang Le <hoang.h.le@dektech.com.au>
    tipc: convert dest node's address to network order

Alexander Aring <aahringo@redhat.com>
    fs: dlm: fix debugfs dump

Zhen Lei <thunder.leizhen@huawei.com>
    tpm: fix error return code in tpm2_get_cc_attrs_tbl()

Quentin Perret <qperret@google.com>
    Revert "fdt: Properly handle "no-map" field in the memory region"

Quentin Perret <qperret@google.com>
    Revert "of/fdt: Make sure no-map does not remove already reserved regions"

Xin Long <lucien.xin@gmail.com>
    sctp: delay auto_asconf init until binding the first addr

Xin Long <lucien.xin@gmail.com>
    Revert "net/sctp: fix race condition in sctp_destroy_sock"

Arnd Bergmann <arnd@arndb.de>
    smp: Fix smp_call_function_single_async prototype

Jonathon Reinhart <jonathon.reinhart@gmail.com>
    net: Only allow init netns to set default tcp cong to a restricted algo

Jane Chu <jane.chu@oracle.com>
    mm/memory-failure: unnecessary amount of unmapping

Wang Wensheng <wangwensheng4@huawei.com>
    mm/sparse: add the missing sparse_buffer_fini() in error branch

Dan Carpenter <dan.carpenter@oracle.com>
    kfifo: fix ternary sign extension bugs

Lv Yunlong <lyl2019@mail.ustc.edu.cn>
    net:nfc:digital: Fix a double free in digital_tg_recv_dep_req

Lv Yunlong <lyl2019@mail.ustc.edu.cn>
    RDMA/bnxt_re: Fix a double free in bnxt_qplib_alloc_res

Lv Yunlong <lyl2019@mail.ustc.edu.cn>
    net:emac/emac-mac: Fix a use after free in emac_mac_tx_buf_send

Phillip Potter <phil@philpotter.co.uk>
    net: geneve: modify IP header check in geneve6_xmit_skb and geneve_xmit_skb

Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
    arm64: dts: uniphier: Change phy-mode to RGMII-ID to enable delay pins for RTL8211E

Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
    ARM: dts: uniphier: Change phy-mode to RGMII-ID to enable delay pins for RTL8211E

Dan Carpenter <dan.carpenter@oracle.com>
    bnxt_en: fix ternary sign extension bug in bnxt_show_temp()

Christophe Leroy <christophe.leroy@csgroup.eu>
    powerpc/52xx: Fix an invalid ASM expression ('addi' used instead of 'add')

Shuah Khan <skhan@linuxfoundation.org>
    ath10k: Fix ath10k_wmi_tlv_op_pull_peer_stats_info() unlock without lock

Toke Høiland-Jørgensen <toke@redhat.com>
    ath9k: Fix error check in ath9k_hw_read_revisions() for PCI devices

Colin Ian King <colin.king@canonical.com>
    net: davinci_emac: Fix incorrect masking of tx and rx error channel

Colin Ian King <colin.king@canonical.com>
    ALSA: usb: midi: don't return -ENOMEM when usb_urb_ep_type_check fails

Sindhu Devale <sindhu.devale@intel.com>
    RDMA/i40iw: Fix error unwinding when i40iw_hmc_sd_one fails

Stefano Garzarella <sgarzare@redhat.com>
    vsock/vmci: log once the failed queue pair allocation

Lv Yunlong <lyl2019@mail.ustc.edu.cn>
    mwl8k: Fix a double Free in mwl8k_probe_hw

Sergey Shtylyov <s.shtylyov@omprussia.ru>
    i2c: sh7760: fix IRQ error path

Ping-Ke Shih <pkshih@realtek.com>
    rtlwifi: 8821ae: upgrade PHY and RF parameters

Tyrel Datwyler <tyreld@linux.ibm.com>
    powerpc/pseries: extract host bridge from pci_bus prior to bus removal

Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
    MIPS: pci-legacy: stop using of_pci_range_to_resource

Dan Carpenter <dan.carpenter@oracle.com>
    drm/i915/gvt: Fix error code in intel_gvt_init_device()

Shengjiu Wang <shengjiu.wang@nxp.com>
    ASoC: ak5558: correct reset polarity

Sergey Shtylyov <s.shtylyov@omprussia.ru>
    i2c: sh7760: add IRQ check

Sergey Shtylyov <s.shtylyov@omprussia.ru>
    i2c: jz4780: add IRQ check

Sergey Shtylyov <s.shtylyov@omprussia.ru>
    i2c: emev2: add IRQ check

Sergey Shtylyov <s.shtylyov@omprussia.ru>
    i2c: cadence: add IRQ check

Wang Wensheng <wangwensheng4@huawei.com>
    RDMA/srpt: Fix error return code in srpt_cm_req_recv()

Colin Ian King <colin.king@canonical.com>
    net: thunderx: Fix unintentional sign extension issue

Wang Wensheng <wangwensheng4@huawei.com>
    IB/hfi1: Fix error return code in parse_platform_config()

Colin Ian King <colin.king@canonical.com>
    mt7601u: fix always true expression

Johannes Berg <johannes.berg@intel.com>
    mac80211: bail out if cipher schemes are invalid

Randy Dunlap <rdunlap@infradead.org>
    powerpc: iommu: fix build when neither PCI or IBMVIO is set

Athira Rajeev <atrajeev@linux.vnet.ibm.com>
    powerpc/perf: Fix PMU constraint check for EBB events

Jordan Niethe <jniethe5@gmail.com>
    powerpc/64s: Fix pte update for kernel memory on radix

Colin Ian King <colin.king@canonical.com>
    liquidio: Fix unintented sign extension of a left shift of a u16

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Add error checks for usb_driver_claim_interface() calls

Salil Mehta <salil.mehta@huawei.com>
    net: hns3: Limiting the scope of vector_ring_chain variable

Dan Carpenter <dan.carpenter@oracle.com>
    nfc: pn533: prevent potential memory corruption

Andrew Scull <ascull@google.com>
    bug: Remove redundant condition check in report_bug

Jia Zhou <zhou.jia2@zte.com.cn>
    ALSA: core: remove redundant spin_lock pair in snd_card_disconnect

Chen Huang <chenhuang5@huawei.com>
    powerpc: Fix HAVE_HARDLOCKUP_DETECTOR_ARCH build configuration

Nathan Chancellor <nathan@kernel.org>
    powerpc/prom: Mark identical_pvr_fixup as __init

Xie He <xie.he.0141@gmail.com>
    net: lapbether: Prevent racing when checking whether the netif is running

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf symbols: Fix dso__fprintf_symbols_by_name() to return the number of printed chars

Maxim Mikityanskiy <maxtram95@gmail.com>
    HID: plantronics: Workaround for double volume key presses

Lv Yunlong <lyl2019@mail.ustc.edu.cn>
    drivers/block/null_blk/main: Fix a double free in null_init.

Waiman Long <longman@redhat.com>
    sched/debug: Fix cgroup_path[] serialization

Nathan Chancellor <nathan@kernel.org>
    x86/events/amd/iommu: Fix sysfs type mismatch

Dan Carpenter <dan.carpenter@oracle.com>
    HSI: core: fix resource leaks in hsi_add_client_from_dt()

Fabrice Gasnier <fabrice.gasnier@foss.st.com>
    mfd: stm32-timers: Avoid clearing auto reload register

Brian King <brking@linux.vnet.ibm.com>
    scsi: ibmvfc: Fix invalid state machine BUG_ON()

Sergey Shtylyov <s.shtylyov@omprussia.ru>
    scsi: sni_53c710: Add IRQ check

Sergey Shtylyov <s.shtylyov@omprussia.ru>
    scsi: sun3x_esp: Add IRQ check

Sergey Shtylyov <s.shtylyov@omprussia.ru>
    scsi: jazz_esp: Add IRQ check

Colin Ian King <colin.king@canonical.com>
    clk: uniphier: Fix potential infinite loop

Chen Hui <clare.chenhui@huawei.com>
    clk: qcom: a53-pll: Add missing MODULE_DEVICE_TABLE

Jason Gunthorpe <jgg@nvidia.com>
    vfio/mdev: Do not allow a mdev_type to have a NULL parent pointer

Hannes Reinecke <hare@suse.de>
    nvme: retrigger ANA log update if group descriptor isn't found

Sergey Shtylyov <s.shtylyov@omprussia.ru>
    ata: libahci_platform: fix IRQ check

Sergey Shtylyov <s.shtylyov@omprussia.ru>
    sata_mv: add IRQ checks

Sergey Shtylyov <s.shtylyov@omprussia.ru>
    pata_ipx4xx_cf: fix IRQ check

Sergey Shtylyov <s.shtylyov@omprussia.ru>
    pata_arasan_cf: fix IRQ check

Masami Hiramatsu <mhiramat@kernel.org>
    x86/kprobes: Fix to check non boostable prefixes correctly

Felix Kuehling <Felix.Kuehling@amd.com>
    drm/amdkfd: fix build error with AMD_IOMMU_V2=m

Colin Ian King <colin.king@canonical.com>
    media: m88rs6000t: avoid potential out-of-bounds reads on arrays

Yang Yingliang <yangyingliang@huawei.com>
    media: omap4iss: return error code when omap4iss_get() failed

Colin Ian King <colin.king@canonical.com>
    media: vivid: fix assignment of dev->fbuf_out_flags

Dan Carpenter <dan.carpenter@oracle.com>
    soc: aspeed: fix a ternary sign expansion bug

Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
    ttyprintk: Add TTY hangup callback.

Artur Petrosyan <Arthur.Petrosyan@synopsys.com>
    usb: dwc2: Fix hibernation between host and device modes.

Artur Petrosyan <Arthur.Petrosyan@synopsys.com>
    usb: dwc2: Fix host mode hibernation exit with remote wakeup flow.

Michael Kelley <mikelley@microsoft.com>
    Drivers: hv: vmbus: Increase wait time for VMbus unload

Ingo Molnar <mingo@kernel.org>
    x86/platform/uv: Fix !KEXEC build failure

Steffen Dirkwinkel <s.dirkwinkel@beckhoff.com>
    platform/x86: pmc_atom: Match all Beckhoff Automation baytrail boards with critclk_systems DMI table

Ye Bin <yebin10@huawei.com>
    usbip: vudc: fix missing unlock on error in usbip_sockfd_store()

He Ying <heying24@huawei.com>
    firmware: qcom-scm: Fix QCOM_SCM configuration

Johan Hovold <johan@kernel.org>
    tty: fix return value for unsupported ioctls

Johan Hovold <johan@kernel.org>
    tty: actually undefine superseded ASYNC flags

Johan Hovold <johan@kernel.org>
    USB: cdc-acm: fix unprivileged TIOCCSERIAL

Colin Ian King <colin.king@canonical.com>
    usb: gadget: r8a66597: Add missing null check on return from platform_get_resource

Pali Rohár <pali@kernel.org>
    cpufreq: armada-37xx: Fix determining base CPU frequency

Pali Rohár <pali@kernel.org>
    cpufreq: armada-37xx: Fix driver cleanup when registration failed

Pali Rohár <pali@kernel.org>
    clk: mvebu: armada-37xx-periph: Fix workaround for switching from L1 to L0

Pali Rohár <pali@kernel.org>
    clk: mvebu: armada-37xx-periph: Fix switching CPU freq from 250 Mhz to 1 GHz

Pali Rohár <pali@kernel.org>
    cpufreq: armada-37xx: Fix the AVS value for load L1

Marek Behún <kabel@kernel.org>
    clk: mvebu: armada-37xx-periph: remove .set_parent method for CPU PM clock

Marek Behún <kabel@kernel.org>
    cpufreq: armada-37xx: Fix setting TBG parent for load levels

Lv Yunlong <lyl2019@mail.ustc.edu.cn>
    crypto: qat - Fix a double free in adf_create_ring

Nathan Chancellor <nathan@kernel.org>
    ACPI: CPPC: Replace cppc_attr with kobj_attribute

Bjorn Andersson <bjorn.andersson@linaro.org>
    soc: qcom: mdt_loader: Detect truncated read of segments

Bjorn Andersson <bjorn.andersson@linaro.org>
    soc: qcom: mdt_loader: Validate that p_filesz < p_memsz

William A. Kennington III <wak@google.com>
    spi: Fix use-after-free with devm_spi_alloc_*

Johan Hovold <johan@kernel.org>
    staging: greybus: uart: fix unprivileged TIOCCSERIAL

Colin Ian King <colin.king@canonical.com>
    staging: rtl8192u: Fix potential infinite loop

Arnd Bergmann <arnd@arndb.de>
    irqchip/gic-v3: Fix OF_BAD_ADDR error handling

Lv Yunlong <lyl2019@mail.ustc.edu.cn>
    mtd: rawnand: gpmi: Fix a double free in gpmi_nand_init

Rander Wang <rander.wang@intel.com>
    soundwire: stream: fix memory leak in stream config error path

Yang Yingliang <yangyingliang@huawei.com>
    USB: gadget: udc: fix wrong pointer passed to IS_ERR() and PTR_ERR()

Tao Ren <rentao.bupt@gmail.com>
    usb: gadget: aspeed: fix dma map failure

Giovanni Cabiddu <giovanni.cabiddu@intel.com>
    crypto: qat - fix error path in adf_isr_resource_alloc()

Geert Uytterhoeven <geert+renesas@glider.be>
    phy: marvell: ARMADA375_USBCLUSTER_PHY should not default to y, unconditionally

Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
    soundwire: bus: Fix device found flag correctly

Pan Bian <bianpan2016@163.com>
    bus: qcom: Put child node before return

Michael Walle <michael@walle.cc>
    mtd: require write permissions for locking and badblock ioctls

Fabian Vogt <fabian@ritter-vogt.de>
    fotg210-udc: Complete OUT requests on short packets

Fabian Vogt <fabian@ritter-vogt.de>
    fotg210-udc: Don't DMA more than the buffer can take

Fabian Vogt <fabian@ritter-vogt.de>
    fotg210-udc: Mask GRP2 interrupts we don't handle

Fabian Vogt <fabian@ritter-vogt.de>
    fotg210-udc: Remove a dubious condition leading to fotg210_done

Fabian Vogt <fabian@ritter-vogt.de>
    fotg210-udc: Fix EP0 IN requests bigger than two packets

Fabian Vogt <fabian@ritter-vogt.de>
    fotg210-udc: Fix DMA on EP0 for length > max packet size

Tong Zhang <ztong0001@gmail.com>
    crypto: qat - ADF_STATUS_PF_RUNNING should be set after adf_dev_init

Tong Zhang <ztong0001@gmail.com>
    crypto: qat - don't release uninitialized resources

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    usb: gadget: pch_udc: Check for DMA mapping error

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    usb: gadget: pch_udc: Check if driver is present before calling ->setup()

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    usb: gadget: pch_udc: Replace cpu_to_le32() by lower_32_bits()

Otavio Pontes <otavio.pontes@intel.com>
    x86/microcode: Check for offline CPUs before requesting new microcode

Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
    mtd: rawnand: qcom: Return actual error code instead of -ENODEV

Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
    mtd: Handle possible -EPROBE_DEFER from parse_mtd_partitions()

Álvaro Fernández Rojas <noltari@gmail.com>
    mtd: rawnand: brcmnand: fix OOB R/W with Hamming ECC

Dan Carpenter <dan.carpenter@oracle.com>
    mtd: rawnand: fsmc: Fix error code in fsmc_nand_probe()

Meng Li <Meng.Li@windriver.com>
    regmap: set debugfs_name to NULL after it is freed

Badhri Jagan Sridharan <badhri@google.com>
    usb: typec: tcpci: Check ROLE_CONTROL while interpreting CC_STATUS

Erwan Le Ray <erwan.leray@foss.st.com>
    serial: stm32: fix tx_empty condition

Erwan Le Ray <erwan.leray@foss.st.com>
    serial: stm32: fix incorrect characters on console

Krzysztof Kozlowski <krzk@kernel.org>
    ARM: dts: exynos: correct PMIC interrupt trigger level on Snow

Krzysztof Kozlowski <krzk@kernel.org>
    ARM: dts: exynos: correct PMIC interrupt trigger level on SMDK5250

Krzysztof Kozlowski <krzk@kernel.org>
    ARM: dts: exynos: correct PMIC interrupt trigger level on Odroid X/U3 family

Krzysztof Kozlowski <krzk@kernel.org>
    ARM: dts: exynos: correct PMIC interrupt trigger level on Midas family

Krzysztof Kozlowski <krzk@kernel.org>
    ARM: dts: exynos: correct MUIC interrupt trigger level on Midas family

Krzysztof Kozlowski <krzk@kernel.org>
    ARM: dts: exynos: correct fuel gauge interrupt trigger level on Midas family

Colin Ian King <colin.king@canonical.com>
    memory: gpmc: fix out of bounds read and dereference on gpmc_cs[]

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    usb: gadget: pch_udc: Revert d3cb25a12138 completely

Dan Carpenter <dan.carpenter@oracle.com>
    ovl: fix missing revert_creds() on error path

Claudio Imbrenda <imbrenda@linux.ibm.com>
    KVM: s390: split kvm_s390_real_to_abs

Heiko Carstens <hca@linux.ibm.com>
    KVM: s390: fix guarded storage control register handling

Claudio Imbrenda <imbrenda@linux.ibm.com>
    KVM: s390: split kvm_s390_logical_to_effective

Sean Christopherson <seanjc@google.com>
    x86/cpu: Initialize MSR_TSC_AUX if RDTSCP *or* RDPID is supported

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/realtek: Remove redundant entry for ALC861 Haier/Uniwill devices

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/realtek: Re-order ALC269 Lenovo quirk table entries

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/realtek: Re-order ALC269 Sony quirk table entries

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/realtek: Re-order ALC269 Dell quirk table entries

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/realtek: Re-order ALC269 HP quirk table entries

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/realtek: Re-order ALC882 Clevo quirk table entries

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/realtek: Re-order ALC882 Sony quirk table entries

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/realtek: Re-order ALC882 Acer quirk table entries

Colin Ian King <colin.king@canonical.com>
    drm/radeon: fix copy of uninitialized variable back to userspace

Johannes Berg <johannes.berg@intel.com>
    cfg80211: scan: drop entry from hidden_list on overflow

Dan Carpenter <dan.carpenter@oracle.com>
    ipw2x00: potential buffer overflow in libipw_wx_set_encodeext()

Jan Glauber <jglauber@digitalocean.com>
    md: Fix missing unused status line of /proc/mdstat

Zhao Heming <heming.zhao@suse.com>
    md: md_open returns -EBUSY when entering racing area

Christoph Hellwig <hch@lst.de>
    md: factor out a mddev_find_locked helper from mddev_find

Christoph Hellwig <hch@lst.de>
    md: split mddev_find

Heming Zhao <heming.zhao@suse.com>
    md-cluster: fix use-after-free issue when removing rdev

Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>
    md/bitmap: wait for external bitmap writes to complete during tear down

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    misc: vmw_vmci: explicitly initialize vmci_datagram payload

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    misc: vmw_vmci: explicitly initialize vmci_notify_bm_set_msg struct

Hans de Goede <hdegoede@redhat.com>
    misc: lis3lv02d: Fix false-positive WARN on various HP models

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio:accel:adis16201: Fix wrong axis assignment that prevents loading

Maciej W. Rozycki <macro@orcam.me.uk>
    FDDI: defxx: Bail out gracefully with unassigned PCI resource for CSR

Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
    MIPS: pci-rt2880: fix slot 0 configuration

Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
    MIPS: pci-mt7620: fix PLL lock check

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    ASoC: samsung: tm2_wm5110: check of of_parse return value

Or Cohen <orcohen@paloaltonetworks.com>
    net/nfc: fix use-after-free llcp_sock_bind/connect

Lin Ma <linma@zju.edu.cn>
    bluetooth: eliminate the potential race condition when removing the HCI controller

Taehee Yoo <ap420073@gmail.com>
    hsr: use netdev_err() instead of WARN_ONCE()

Archie Pusaka <apusaka@chromium.org>
    Bluetooth: verify AMP hci_chan before amp_destroy

Christoph Hellwig <hch@lst.de>
    modules: inherit TAINT_PROPRIETARY_MODULE

Christoph Hellwig <hch@lst.de>
    modules: return licensing information from find_symbol

Christoph Hellwig <hch@lst.de>
    modules: rename the licence field in struct symsearch to license

Christoph Hellwig <hch@lst.de>
    modules: unexport __module_address

Christoph Hellwig <hch@lst.de>
    modules: unexport __module_text_address

Christoph Hellwig <hch@lst.de>
    modules: mark each_symbol_section static

Christoph Hellwig <hch@lst.de>
    modules: mark find_symbol static

Christoph Hellwig <hch@lst.de>
    modules: mark ref_module static

Benjamin Block <bblock@linux.ibm.com>
    dm rq: fix double free of blk_mq_tag_set in dev remove after table load fails

Joe Thornber <ejt@redhat.com>
    dm space map common: fix division bug in sm_ll_find_free_block()

Joe Thornber <ejt@redhat.com>
    dm persistent data: packed struct should have an aligned() attribute too

Steven Rostedt (VMware) <rostedt@goodmis.org>
    tracing: Restructure trace_clock_global() to never block

Steven Rostedt (VMware) <rostedt@goodmis.org>
    tracing: Map all PIDs to command lines

Marek Vasut <marex@denx.de>
    rsi: Use resume_noirq for SDIO

Pavel Skripkin <paskripkin@gmail.com>
    tty: fix memory leak in vc_deallocate

Artur Petrosyan <Arthur.Petrosyan@synopsys.com>
    usb: dwc2: Fix session request interrupt handler

Thinh Nguyen <Thinh.Nguyen@synopsys.com>
    usb: dwc3: gadget: Fix START_TRANSFER link state check

Dean Anderson <dean@sensoray.com>
    usb: gadget/function/f_fs string table fix for multiple languages

Hemant Kumar <hemantk@codeaurora.org>
    usb: gadget: Fix double free of device descriptor pointers

Anirudh Rayabharam <mail@anirudhrb.com>
    usb: gadget: dummy_hcd: fix gpf in gadget_setup

Peilin Ye <yepeilin.cs@gmail.com>
    media: dvbdev: Fix memory leak in dvb_media_device_free()

Fengnan Chang <changfengnan@vivo.com>
    ext4: fix error code in ext4_commit_super

Zhang Yi <yi.zhang@huawei.com>
    ext4: do not set SB_ACTIVE in ext4_orphan_cleanup()

Zhang Yi <yi.zhang@huawei.com>
    ext4: fix check to prevent false positive report of incorrect used inodes

Jian Cai <jiancai@google.com>
    arm64: vdso: remove commas between macro name and arguments

Chen Jun <chenjun102@huawei.com>
    posix-timers: Preserve return value in clock_adjtime32()

Thomas Gleixner <tglx@linutronix.de>
    Revert 337f13046ff0 ("futex: Allow FUTEX_CLOCK_REALTIME with FUTEX_WAIT op")

Yang Yang <yang.yang29@zte.com.cn>
    jffs2: check the validity of dstlen in jffs2_zlib_compress()

Linus Torvalds <torvalds@linux-foundation.org>
    Fix misc new gcc warnings

Arnd Bergmann <arnd@arndb.de>
    security: commoncap: fix -Wstringop-overread warning

Heinz Mauelshagen <heinzm@redhat.com>
    dm raid: fix inconclusive reshape layout on fast raid4/5/6 table reload sequences

Paul Clements <paul.clements@us.sios.com>
    md/raid1: properly indicate failure when ending a failed write request

Stefan Berger <stefanb@linux.ibm.com>
    tpm: vtpm_proxy: Avoid reading host log when using a virtual device

Alexander Shishkin <alexander.shishkin@linux.intel.com>
    intel_th: pci: Add Alder Lake-M support

Tony Ambardar <tony.ambardar@gmail.com>
    powerpc: fix EDEADLOCK redefinition error in uapi/asm/errno.h

Mahesh Salgaonkar <mahesh@linux.ibm.com>
    powerpc/eeh: Fix EEH handling for hugepages in ioremap space.

lizhe <lizhe67@huawei.com>
    jffs2: Fix kasan slab-out-of-bounds problem

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFSv4: Don't discard segments marked for return in _pnfs_return_layout()

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFS: Don't discard pNFS layout segments that are marked for return

Marc Zyngier <maz@kernel.org>
    ACPI: GTDT: Don't corrupt interrupt mappings on watchdow probe failure

Davide Caratti <dcaratti@redhat.com>
    openvswitch: fix stack OOB read while fragmenting IPv4 packets

Ido Schimmel <idosch@nvidia.com>
    mlxsw: spectrum_mr: Update egress RIF list before route's action

Chao Yu <yuchao0@huawei.com>
    f2fs: fix to avoid out-of-bounds memory access

Guochun Mao <guochun.mao@mediatek.com>
    ubifs: Only check replay with inode type to judge if inode linked

Bill Wendling <morbo@google.com>
    arm64/vdso: Discard .note.gnu.property sections in vDSO

Filipe Manana <fdmanana@suse.com>
    btrfs: fix race when picking most recent mod log operation for an old root

Eckhart Mohr <e.mohr@tuxedocomputers.com>
    ALSA: hda/realtek: Add quirk for Intel Clevo PCx0Dx

Timo Gurr <timo.gurr@gmail.com>
    ALSA: usb-audio: Add dB range mapping for Sennheiser Communications Headset PC 8

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: More constifications

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Explicitly set up the clock selector

Lv Yunlong <lyl2019@mail.ustc.edu.cn>
    ALSA: sb: Fix two use after free in snd_sb_qsound_build

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/conexant: Re-order CX5066 quirk table entries

Lv Yunlong <lyl2019@mail.ustc.edu.cn>
    ALSA: emu8000: Fix a use after free in snd_emu8000_create_mixer

Harald Freudenberger <freude@linux.ibm.com>
    s390/archrandom: add parameter check for s390_arch_random_generate

Bart Van Assche <bvanassche@acm.org>
    scsi: libfc: Fix a format specifier

James Smart <jsmart2021@gmail.com>
    scsi: lpfc: Remove unsupported mbox PORT_CAPABILITIES logic

James Smart <jsmart2021@gmail.com>
    scsi: lpfc: Fix crash when a REG_RPI mailbox fails triggering a LOGO response

Guchun Chen <guchun.chen@amd.com>
    drm/amdgpu: fix NULL pointer dereference

Arnd Bergmann <arnd@arndb.de>
    amdgpu: avoid incorrect %hu format string

Marijn Suijten <marijn.suijten@somainline.org>
    drm/msm/mdp5: Configure PP_SYNC_HEIGHT to double the vtotal

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    media: gscpa/stv06xx: fix memory leak

Pavel Skripkin <paskripkin@gmail.com>
    media: dvb-usb: fix memory leak in dvb_usb_adapter_init

Yang Yingliang <yangyingliang@huawei.com>
    media: i2c: adv7842: fix possible use-after-free in adv7842_remove()

Yang Yingliang <yangyingliang@huawei.com>
    media: i2c: adv7511-v4l2: fix possible use-after-free in adv7511_remove()

Yang Yingliang <yangyingliang@huawei.com>
    media: adv7604: fix possible use-after-free in adv76xx_remove()

Yang Yingliang <yangyingliang@huawei.com>
    media: tc358743: fix possible use-after-free in tc358743_remove()

Yang Yingliang <yangyingliang@huawei.com>
    power: supply: s3c_adc_battery: fix possible use-after-free in s3c_adc_bat_remove()

Yang Yingliang <yangyingliang@huawei.com>
    power: supply: generic-adc-battery: fix possible use-after-free in gab_remove()

Colin Ian King <colin.king@canonical.com>
    clk: socfpga: arria10: Fix memory leak of socfpga_clk on error return

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    media: vivid: update EDID

Muhammad Usama Anjum <musamaanjum@gmail.com>
    media: em28xx: fix memory leak

Ewan D. Milne <emilne@redhat.com>
    scsi: scsi_dh_alua: Remove check for ASC 24h in alua_rtpg()

Quinn Tran <qutran@marvell.com>
    scsi: qla2xxx: Fix use after free in bsg

Bart Van Assche <bvanassche@acm.org>
    scsi: qla2xxx: Always check the return value of qla24xx_get_isp_stats()

shaoyunl <shaoyun.liu@amd.com>
    drm/amdgpu : Fix asic reset regression issue introduce by 8f211fe8ac7c4f

dongjian <dongjian@yulong.com>
    power: supply: Use IRQF_ONESHOT

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    media: gspca/sq905.c: fix uninitialized variable

Daniel Niv <danielniv3@gmail.com>
    media: media/saa7164: fix saa7164_encoder_register() memory leak bugs

Hans de Goede <hdegoede@redhat.com>
    extcon: arizona: Fix some issues when HPDET IRQ fires after the jack has been unplugged

Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
    power: supply: bq27xxx: fix power_avg for newer ICs

Julian Braha <julianbraha@gmail.com>
    media: drivers: media: pci: sta2x11: fix Kconfig dependency on GPIOLIB

Sean Young <sean@mess.org>
    media: ite-cir: check for receive overflow

Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
    scsi: target: pscsi: Fix warning in pscsi_complete_cmd()

James Smart <jsmart2021@gmail.com>
    scsi: lpfc: Fix pt2pt connection does not recover after LOGO

James Smart <jsmart2021@gmail.com>
    scsi: lpfc: Fix incorrect dbde assignment when building target abts wqe

Josef Bacik <josef@toxicpanda.com>
    btrfs: convert logic BUG_ON()'s in replace_path to ASSERT()'s

Yang Yingliang <yangyingliang@huawei.com>
    phy: phy-twl4030-usb: Fix possible use-after-free in twl4030_usb_remove()

Pavel Machek <pavel@ucw.cz>
    intel_th: Consistency and off-by-one fix

Wei Yongjun <weiyongjun1@huawei.com>
    spi: omap-100k: Fix reference leak to master

Wei Yongjun <weiyongjun1@huawei.com>
    spi: dln2: Fix reference leak to master

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: fix potential array out of bounds with several interrupters

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: check control context is valid before dereferencing it.

Chunfeng Yun <chunfeng.yun@mediatek.com>
    usb: xhci-mtk: support quirk to disable usb2 lpm

Robin Murphy <robin.murphy@arm.com>
    perf/arm_pmu_platform: Fix error handling

Jerome Forissier <jerome@forissier.org>
    tee: optee: do not check memref size on return from Secure World

John Millikin <john@john-millikin.com>
    x86/build: Propagate $(CLANG_FLAGS) to $(REALMODE_FLAGS)

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    PCI: PM: Do not read power state in pci_enable_device_flags()

Thinh Nguyen <Thinh.Nguyen@synopsys.com>
    usb: xhci: Fix port minor revision

Wesley Cheng <wcheng@codeaurora.org>
    usb: dwc3: gadget: Ignore EP queue requests during bus reset

Ruslan Bilovol <ruslan.bilovol@gmail.com>
    usb: gadget: f_uac1: validate input parameters

Vitaly Kuznetsov <vkuznets@redhat.com>
    genirq/matrix: Prevent allocation counter corruption

Pawel Laszczak <pawell@cadence.com>
    usb: gadget: uvc: add bInterval checking for HS mode

Ard Biesheuvel <ardb@kernel.org>
    crypto: api - check for ERR pointers in crypto_destroy_tfm()

karthik alapati <mail@karthek.com>
    staging: wimax/i2400m: fix byte-order issue

Phillip Potter <phil@philpotter.co.uk>
    fbdev: zero-fill colormap in fbcmap.c

Alexander Shishkin <alexander.shishkin@linux.intel.com>
    intel_th: pci: Add Rocket Lake CPU support

Filipe Manana <fdmanana@suse.com>
    btrfs: fix metadata extent leak after failure to create subvolume

Paul Aurich <paul@darkrain42.org>
    cifs: Return correct error code from smb2_get_enc_key

Gao Xiang <hsiangkao@redhat.com>
    erofs: add unsupported inode i_format check

Seunghui Lee <sh043.lee@samsung.com>
    mmc: core: Set read only for SD cards with permanent write protect bit

DooHyun Hwang <dh0421.hwang@samsung.com>
    mmc: core: Do a power cycle when the CMD11 fails

Avri Altman <avri.altman@wdc.com>
    mmc: block: Issue a cache flush only when it's enabled

Avri Altman <avri.altman@wdc.com>
    mmc: block: Update ext_csd.cache_ctrl if it was written

Adrian Hunter <adrian.hunter@intel.com>
    mmc: sdhci-pci: Fix initialization of some SD cards for Intel BYT-based controllers

Arun Easi <aeasi@marvell.com>
    scsi: qla2xxx: Fix crash in qla2xxx_mqueuecommand()

Tudor Ambarus <tudor.ambarus@microchip.com>
    spi: spi-ti-qspi: Free DMA resources

Kai Stuhlemmer (ebee Engineering) <kai.stuhlemmer@ebee.de>
    mtd: rawnand: atmel: Update ecc_stats.corrected counter

Alexander Lobakin <alobakin@pm.me>
    mtd: spinand: core: add missing MODULE_DEVICE_TABLE()

Jeffrey Mitchell <jeffrey.mitchell@starlab.io>
    ecryptfs: fix kernel panic with null dev_name

Chunfeng Yun <chunfeng.yun@mediatek.com>
    arm64: dts: mt8173: fix property typo of 'phys' in dsi node

Marek Behún <kabel@kernel.org>
    arm64: dts: marvell: armada-37xx: add syscon compatible to NB clk node

Ard Biesheuvel <ardb@kernel.org>
    ARM: 9056/1: decompressor: fix BSS size calculation for LLVM ld.lld

Steven Rostedt (VMware) <rostedt@goodmis.org>
    ftrace: Handle commands when closing set_ftrace_filter file

Mark Langsdorf <mlangsdo@redhat.com>
    ACPI: custom_method: fix a possible memory leak

Mark Langsdorf <mlangsdo@redhat.com>
    ACPI: custom_method: fix potential use-after-free issue

Vasily Gorbik <gor@linux.ibm.com>
    s390/disassembler: increase ebpf disasm buffer size


-------------

Diffstat:

 Documentation/sphinx/parse-headers.pl              |   2 +-
 Documentation/target/tcm_mod_builder.py            |   2 +-
 Documentation/trace/postprocess/decode_msr.py      |   2 +-
 .../postprocess/trace-pagealloc-postprocess.pl     |   2 +-
 .../trace/postprocess/trace-vmscan-postprocess.pl  |   2 +-
 Makefile                                           |   4 +-
 arch/arc/kernel/entry.S                            |   4 +-
 arch/arm/boot/compressed/Makefile                  |   4 +-
 arch/arm/boot/dts/exynos4412-midas.dtsi            |   6 +-
 arch/arm/boot/dts/exynos4412-odroid-common.dtsi    |   2 +-
 arch/arm/boot/dts/exynos5250-smdk5250.dts          |   2 +-
 arch/arm/boot/dts/exynos5250-snow-common.dtsi      |   2 +-
 arch/arm/boot/dts/uniphier-pxs2.dtsi               |   2 +-
 arch/arm/include/asm/kvm_host.h                    |   1 +
 arch/arm/kernel/asm-offsets.c                      |   3 +
 arch/arm/kernel/hw_breakpoint.c                    |   2 +-
 arch/arm/kernel/smccc-call.S                       |  11 +-
 arch/arm/kernel/suspend.c                          |  19 +-
 arch/arm/mm/cache-v7.S                             |  51 ++-
 arch/arm64/boot/dts/marvell/armada-37xx.dtsi       |   3 +-
 arch/arm64/boot/dts/mediatek/mt8173.dtsi           |   2 +-
 arch/arm64/boot/dts/socionext/uniphier-ld20.dtsi   |   2 +-
 arch/arm64/boot/dts/socionext/uniphier-pxs3.dtsi   |   4 +-
 arch/arm64/include/asm/kvm_host.h                  |   1 +
 arch/arm64/kernel/vdso/gettimeofday.S              |   6 +-
 arch/arm64/kernel/vdso/vdso.lds.S                  |   8 +-
 arch/arm64/kvm/debug.c                             |  88 ++--
 arch/ia64/include/asm/module.h                     |   6 +-
 arch/ia64/kernel/module.c                          |  29 +-
 arch/ia64/scripts/unwcheck.py                      |   2 +-
 arch/mips/include/asm/div64.h                      |  55 ++-
 arch/mips/pci/pci-legacy.c                         |   9 +-
 arch/mips/pci/pci-mt7620.c                         |   5 +-
 arch/mips/pci/pci-rt2880.c                         |  37 +-
 arch/powerpc/Kconfig                               |   2 +-
 arch/powerpc/Kconfig.debug                         |   1 +
 arch/powerpc/include/asm/book3s/64/radix.h         |   6 +-
 arch/powerpc/include/uapi/asm/errno.h              |   1 +
 arch/powerpc/kernel/eeh.c                          |  11 +-
 arch/powerpc/kernel/iommu.c                        |   4 +-
 arch/powerpc/kernel/prom.c                         |   2 +-
 arch/powerpc/kernel/smp.c                          |   6 +-
 arch/powerpc/lib/feature-fixups.c                  |  35 +-
 arch/powerpc/mm/pgtable-radix.c                    |   4 +-
 arch/powerpc/perf/isa207-common.c                  |   4 +-
 arch/powerpc/platforms/52xx/lite5200_sleep.S       |   2 +-
 arch/powerpc/platforms/pseries/hotplug-cpu.c       |   3 -
 arch/powerpc/platforms/pseries/pci_dlpar.c         |   4 +-
 arch/riscv/include/asm/ftrace.h                    |  14 +-
 arch/riscv/kernel/mcount.S                         |  10 +-
 arch/s390/crypto/arch_random.c                     |   4 +
 arch/s390/kernel/dis.c                             |   2 +-
 arch/s390/kvm/gaccess.h                            |  54 ++-
 arch/s390/kvm/kvm-s390.c                           |   4 +-
 arch/um/kernel/dyn.lds.S                           |   6 +
 arch/um/kernel/uml.lds.S                           |   6 +
 arch/x86/Kconfig                                   |   1 +
 arch/x86/Makefile                                  |   1 +
 arch/x86/entry/vdso/vma.c                          |   2 +-
 arch/x86/events/amd/iommu.c                        |   6 +-
 arch/x86/kernel/cpu/microcode/core.c               |   8 +-
 arch/x86/kernel/kprobes/core.c                     |  17 +-
 arch/x86/kvm/x86.c                                 |   1 +
 arch/x86/lib/msr-smp.c                             |   4 +-
 block/blk-mq.c                                     |   6 +-
 crypto/api.c                                       |   2 +-
 drivers/acpi/arm64/gtdt.c                          |  10 +-
 drivers/acpi/cppc_acpi.c                           |  14 +-
 drivers/acpi/custom_method.c                       |   4 +-
 drivers/acpi/scan.c                                |   1 +
 drivers/ata/libahci_platform.c                     |   4 +-
 drivers/ata/pata_arasan_cf.c                       |  15 +-
 drivers/ata/pata_ixp4xx_cf.c                       |   6 +-
 drivers/ata/sata_mv.c                              |   4 +
 drivers/base/regmap/regmap-debugfs.c               |   1 +
 drivers/block/null_blk_zoned.c                     |   1 +
 drivers/bus/qcom-ebi2.c                            |   4 +-
 drivers/char/tpm/eventlog/common.c                 |   3 +
 drivers/char/tpm/tpm2-cmd.c                        |   1 +
 drivers/char/ttyprintk.c                           |  11 +
 drivers/clk/mvebu/armada-37xx-periph.c             |  83 ++--
 drivers/clk/qcom/a53-pll.c                         |   1 +
 drivers/clk/samsung/clk-exynos7.c                  |   7 +-
 drivers/clk/socfpga/clk-gate-a10.c                 |   1 +
 drivers/clk/uniphier/clk-uniphier-mux.c            |   4 +-
 drivers/cpufreq/armada-37xx-cpufreq.c              |  76 +++-
 drivers/crypto/qat/qat_c3xxxvf/adf_drv.c           |   4 +-
 drivers/crypto/qat/qat_c62xvf/adf_drv.c            |   4 +-
 drivers/crypto/qat/qat_common/adf_isr.c            |  29 +-
 drivers/crypto/qat/qat_common/adf_transport.c      |   1 +
 drivers/crypto/qat/qat_common/adf_vf_isr.c         |  17 +-
 drivers/crypto/qat/qat_dh895xccvf/adf_drv.c        |   4 +-
 drivers/extcon/extcon-arizona.c                    |  17 +-
 drivers/firmware/Kconfig                           |   1 +
 drivers/gpio/gpiolib-acpi.c                        |  14 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_irq.c            |   2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c            |   2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_uvd.c            |   2 +-
 drivers/gpu/drm/amd/amdkfd/kfd_iommu.c             |   6 +
 drivers/gpu/drm/amd/amdkfd/kfd_iommu.h             |   9 +-
 drivers/gpu/drm/i915/gvt/gvt.c                     |   8 +-
 drivers/gpu/drm/i915/intel_pm.c                    |   2 +-
 drivers/gpu/drm/msm/disp/mdp5/mdp5_cmd_encoder.c   |  10 +-
 drivers/gpu/drm/radeon/radeon.h                    |   1 +
 drivers/gpu/drm/radeon/radeon_atombios.c           |  26 +-
 drivers/gpu/drm/radeon/radeon_kms.c                |   1 +
 drivers/gpu/drm/radeon/radeon_pm.c                 |   8 +
 drivers/gpu/drm/radeon/si_dpm.c                    |   3 +
 drivers/hid/hid-ids.h                              |   1 +
 drivers/hid/hid-plantronics.c                      |  60 ++-
 drivers/hsi/hsi_core.c                             |   3 +-
 drivers/hv/channel_mgmt.c                          |  30 +-
 drivers/hwtracing/intel_th/gth.c                   |   4 +-
 drivers/hwtracing/intel_th/pci.c                   |  10 +
 drivers/i2c/busses/i2c-cadence.c                   |   5 +-
 drivers/i2c/busses/i2c-emev2.c                     |   5 +-
 drivers/i2c/busses/i2c-jz4780.c                    |   5 +-
 drivers/i2c/busses/i2c-sh7760.c                    |   5 +-
 drivers/i2c/i2c-dev.c                              |   9 +-
 drivers/iio/accel/adis16201.c                      |   2 +-
 drivers/iio/gyro/mpu3050-core.c                    |  13 +-
 drivers/iio/light/tsl2583.c                        |   8 +
 drivers/iio/proximity/pulsedlight-lidar-lite-v2.c  |   1 +
 drivers/infiniband/hw/bnxt_re/qplib_res.c          |   1 +
 drivers/infiniband/hw/hfi1/firmware.c              |   1 +
 drivers/infiniband/hw/i40iw/i40iw_pble.c           |   6 +-
 drivers/infiniband/ulp/srpt/ib_srpt.c              |   1 +
 drivers/input/touchscreen/elants_i2c.c             |  44 +-
 drivers/input/touchscreen/silead.c                 |  44 +-
 drivers/irqchip/irq-gic-v3-mbi.c                   |   2 +-
 drivers/isdn/capi/kcapi.c                          |   4 +-
 drivers/md/dm-raid.c                               |  34 +-
 drivers/md/dm-rq.c                                 |   2 +
 drivers/md/md-bitmap.c                             |   2 +
 drivers/md/md.c                                    |  73 +--
 drivers/md/persistent-data/dm-btree-internal.h     |   4 +-
 drivers/md/persistent-data/dm-space-map-common.c   |   2 +
 drivers/md/persistent-data/dm-space-map-common.h   |   8 +-
 drivers/md/raid1.c                                 |   2 +
 drivers/media/dvb-core/dvbdev.c                    |   1 +
 drivers/media/i2c/adv7511-v4l2.c                   |   2 +-
 drivers/media/i2c/adv7604.c                        |   2 +-
 drivers/media/i2c/adv7842.c                        |   2 +-
 drivers/media/i2c/tc358743.c                       |   2 +-
 drivers/media/pci/saa7164/saa7164-encoder.c        |  20 +-
 drivers/media/pci/sta2x11/Kconfig                  |   1 +
 drivers/media/platform/vivid/vivid-core.c          |   6 +-
 drivers/media/platform/vivid/vivid-vid-out.c       |   2 +-
 drivers/media/rc/ite-cir.c                         |   8 +-
 drivers/media/tuners/m88rs6000t.c                  |   6 +-
 drivers/media/usb/dvb-usb/dvb-usb-init.c           |  20 +-
 drivers/media/usb/dvb-usb/dvb-usb.h                |   2 +-
 drivers/media/usb/em28xx/em28xx-dvb.c              |   1 +
 drivers/media/usb/gspca/gspca.c                    |   2 +
 drivers/media/usb/gspca/gspca.h                    |   1 +
 drivers/media/usb/gspca/sq905.c                    |   2 +-
 drivers/media/usb/gspca/stv06xx/stv06xx.c          |   9 +
 drivers/memory/omap-gpmc.c                         |   7 +-
 drivers/mfd/stm32-timers.c                         |   7 +-
 drivers/misc/aspeed-lpc-snoop.c                    |   4 +-
 drivers/misc/kgdbts.c                              |  26 +-
 drivers/misc/lis3lv02d/lis3lv02d.c                 |  21 +-
 drivers/misc/vmw_vmci/vmci_doorbell.c              |   2 +-
 drivers/misc/vmw_vmci/vmci_guest.c                 |   2 +-
 drivers/mmc/core/block.c                           |  16 +
 drivers/mmc/core/core.c                            |   2 +-
 drivers/mmc/core/core.h                            |   9 +
 drivers/mmc/core/mmc.c                             |   7 +
 drivers/mmc/core/mmc_ops.c                         |   4 +-
 drivers/mmc/core/sd.c                              |   6 +
 drivers/mmc/host/sdhci-pci-core.c                  |  27 ++
 drivers/mtd/mtdchar.c                              |   8 +-
 drivers/mtd/mtdcore.c                              |   3 +
 drivers/mtd/nand/raw/atmel/nand-controller.c       |   6 +-
 drivers/mtd/nand/raw/brcmnand/brcmnand.c           |   6 +
 drivers/mtd/nand/raw/fsmc_nand.c                   |   2 +
 drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c         |   2 +-
 drivers/mtd/nand/raw/qcom_nandc.c                  |   7 +-
 drivers/mtd/nand/spi/core.c                        |   2 +
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |   4 +-
 .../net/ethernet/cavium/liquidio/cn23xx_pf_regs.h  |   2 +-
 drivers/net/ethernet/cavium/thunder/nicvf_queues.c |   2 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c |   2 +-
 drivers/net/ethernet/cisco/enic/enic_main.c        |   7 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    |   3 +-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_mdio.c    |   2 +
 drivers/net/ethernet/intel/i40e/i40e_client.c      |   1 +
 drivers/net/ethernet/mediatek/mtk_eth_soc.c        |   2 +-
 drivers/net/ethernet/mediatek/mtk_eth_soc.h        |   1 +
 drivers/net/ethernet/mellanox/mlxsw/spectrum_mr.c  |  30 +-
 drivers/net/ethernet/qualcomm/emac/emac-mac.c      |   4 +-
 .../net/ethernet/stmicro/stmmac/dwmac-ipq806x.c    |   2 +
 drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.c   |   7 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |  14 +-
 drivers/net/ethernet/ti/davinci_emac.c             |   4 +-
 drivers/net/fddi/Kconfig                           |  15 +-
 drivers/net/fddi/defxx.c                           |  47 +-
 drivers/net/geneve.c                               |   4 +-
 drivers/net/wan/lapbether.c                        |  32 +-
 drivers/net/wimax/i2400m/op-rfkill.c               |   2 +-
 drivers/net/wireless/ath/ath10k/wmi-tlv.c          |   3 +
 drivers/net/wireless/ath/ath9k/htc_drv_init.c      |   2 +-
 drivers/net/wireless/ath/ath9k/hw.c                |   2 +-
 drivers/net/wireless/intel/ipw2x00/libipw_wx.c     |   6 +-
 drivers/net/wireless/marvell/mwl8k.c               |   1 +
 drivers/net/wireless/mediatek/mt7601u/eeprom.c     |   2 +-
 .../net/wireless/realtek/rtlwifi/rtl8821ae/table.c | 500 +++++++++++++++------
 drivers/net/wireless/rsi/rsi_91x_sdio.c            |   2 +-
 drivers/net/wireless/wl3501.h                      |  47 +-
 drivers/net/wireless/wl3501_cs.c                   |  54 +--
 drivers/nfc/pn533/pn533.c                          |   3 +
 drivers/nvme/host/core.c                           |   3 +-
 drivers/nvme/host/multipath.c                      |   4 +
 drivers/of/fdt.c                                   |  12 +-
 drivers/pci/controller/pci-thunder-ecam.c          |   2 +-
 drivers/pci/controller/pci-thunder-pem.c           |  13 +-
 drivers/pci/controller/pcie-iproc-msi.c            |   2 +-
 drivers/pci/endpoint/functions/pci-epf-test.c      |   3 +
 drivers/pci/hotplug/acpiphp_glue.c                 |   1 +
 drivers/pci/pci.c                                  |  16 +-
 drivers/pci/pci.h                                  |   6 +
 drivers/pci/probe.c                                |   1 +
 drivers/perf/arm_pmu_platform.c                    |   2 +-
 drivers/phy/marvell/Kconfig                        |   4 +-
 drivers/phy/ti/phy-twl4030-usb.c                   |   2 +-
 drivers/pinctrl/pinctrl-ingenic.c                  |   3 +-
 drivers/pinctrl/samsung/pinctrl-exynos.c           |  10 +-
 drivers/platform/x86/pmc_atom.c                    |  28 +-
 drivers/power/supply/bq27xxx_battery.c             |  51 ++-
 drivers/power/supply/generic-adc-battery.c         |   2 +-
 drivers/power/supply/lp8788-charger.c              |   2 +-
 drivers/power/supply/pm2301_charger.c              |   2 +-
 drivers/power/supply/s3c_adc_battery.c             |   2 +-
 drivers/power/supply/tps65090-charger.c            |   2 +-
 drivers/power/supply/tps65217_charger.c            |   2 +-
 drivers/rpmsg/qcom_glink_native.c                  |   1 +
 drivers/rtc/rtc-ds1307.c                           |  12 +-
 drivers/scsi/device_handler/scsi_dh_alua.c         |   5 +-
 drivers/scsi/ibmvscsi/ibmvfc.c                     |  57 ++-
 drivers/scsi/jazz_esp.c                            |   4 +-
 drivers/scsi/libfc/fc_lport.c                      |   2 +-
 drivers/scsi/lpfc/lpfc_crtn.h                      |   3 -
 drivers/scsi/lpfc/lpfc_hw4.h                       | 174 +------
 drivers/scsi/lpfc/lpfc_init.c                      | 103 +----
 drivers/scsi/lpfc/lpfc_mbox.c                      |  36 --
 drivers/scsi/lpfc/lpfc_nportdisc.c                 |  11 +-
 drivers/scsi/lpfc/lpfc_nvmet.c                     |   1 -
 drivers/scsi/lpfc/lpfc_sli.c                       |   1 -
 drivers/scsi/qla2xxx/qla_attr.c                    |   8 +-
 drivers/scsi/qla2xxx/qla_bsg.c                     |   3 +-
 drivers/scsi/qla2xxx/qla_os.c                      |   7 -
 drivers/scsi/sni_53c710.c                          |   5 +-
 drivers/scsi/sun3x_esp.c                           |   4 +-
 drivers/soc/qcom/mdt_loader.c                      |  17 +
 drivers/soundwire/bus.c                            |   3 +-
 drivers/soundwire/stream.c                         |  10 +-
 drivers/spi/spi-dln2.c                             |   2 +-
 drivers/spi/spi-omap-100k.c                        |   6 +-
 drivers/spi/spi-ti-qspi.c                          |  20 +-
 drivers/spi/spi.c                                  |   9 +-
 drivers/staging/erofs/erofs_fs.h                   |   3 +
 drivers/staging/erofs/inode.c                      |   6 +
 drivers/staging/greybus/uart.c                     |   2 -
 drivers/staging/media/omap4iss/iss.c               |   4 +-
 drivers/staging/rtl8192u/r8192U_core.c             |   2 +-
 drivers/target/target_core_pscsi.c                 |   3 +-
 drivers/target/target_core_user.c                  |   4 +-
 drivers/tee/optee/core.c                           |  10 -
 drivers/thermal/fair_share.c                       |   4 +
 drivers/tty/serial/stm32-usart.c                   |  17 +-
 drivers/tty/serial/stm32-usart.h                   |   3 -
 drivers/tty/tty_io.c                               |   8 +-
 drivers/tty/vt/vt.c                                |   1 +
 drivers/usb/class/cdc-acm.c                        |   2 -
 drivers/usb/class/cdc-wdm.c                        |  30 +-
 drivers/usb/core/hub.c                             |   6 +-
 drivers/usb/dwc2/core.h                            |   2 +
 drivers/usb/dwc2/core_intr.c                       | 162 ++++---
 drivers/usb/dwc2/gadget.c                          |   3 +-
 drivers/usb/dwc2/hcd.c                             |  10 +-
 drivers/usb/dwc3/dwc3-omap.c                       |   5 +
 drivers/usb/dwc3/dwc3-pci.c                        |   1 +
 drivers/usb/dwc3/gadget.c                          |  26 +-
 drivers/usb/gadget/config.c                        |   4 +
 drivers/usb/gadget/function/f_fs.c                 |   3 +-
 drivers/usb/gadget/function/f_uac1.c               |  43 ++
 drivers/usb/gadget/function/f_uvc.c                |   7 +-
 drivers/usb/gadget/udc/aspeed-vhub/core.c          |   3 +-
 drivers/usb/gadget/udc/aspeed-vhub/epn.c           |   2 +-
 drivers/usb/gadget/udc/dummy_hcd.c                 |  23 +-
 drivers/usb/gadget/udc/fotg210-udc.c               |  26 +-
 drivers/usb/gadget/udc/pch_udc.c                   |  49 +-
 drivers/usb/gadget/udc/r8a66597-udc.c              |   2 +
 drivers/usb/gadget/udc/snps_udc_plat.c             |   4 +-
 drivers/usb/host/fotg210-hcd.c                     |   4 +-
 drivers/usb/host/sl811-hcd.c                       |   9 +-
 drivers/usb/host/xhci-ext-caps.h                   |   5 +-
 drivers/usb/host/xhci-mem.c                        |   9 +
 drivers/usb/host/xhci-mtk.c                        |   3 +
 drivers/usb/host/xhci-mtk.h                        |   1 +
 drivers/usb/host/xhci-pci.c                        |   4 +-
 drivers/usb/host/xhci.c                            |  20 +-
 drivers/usb/typec/tcpci.c                          |  21 +-
 drivers/usb/usbip/vudc_sysfs.c                     |   2 +
 drivers/vfio/mdev/mdev_sysfs.c                     |   2 +-
 drivers/video/fbdev/core/fbcmap.c                  |   8 +-
 fs/block_dev.c                                     |  20 +-
 fs/btrfs/ctree.c                                   |  20 +
 fs/btrfs/ioctl.c                                   |  18 +-
 fs/btrfs/relocation.c                              |   6 +-
 fs/ceph/caps.c                                     |   1 +
 fs/ceph/inode.c                                    |   1 +
 fs/cifs/smb2ops.c                                  |   2 +-
 fs/dlm/debug_fs.c                                  |   1 +
 fs/ecryptfs/main.c                                 |   6 +
 fs/ext4/ialloc.c                                   |  48 +-
 fs/ext4/super.c                                    |   9 +-
 fs/f2fs/inline.c                                   |   3 +-
 fs/f2fs/node.c                                     |   3 +
 fs/fuse/cuse.c                                     |   2 +
 fs/hfsplus/extents.c                               |   7 +-
 fs/iomap.c                                         |  34 +-
 fs/jffs2/compr_rtime.c                             |   3 +
 fs/jffs2/scan.c                                    |   2 +-
 fs/nfs/flexfilelayout/flexfilelayout.c             |   2 +-
 fs/nfs/inode.c                                     |   8 +-
 fs/nfs/nfs42proc.c                                 |  21 +-
 fs/nfs/pnfs.c                                      |   7 +-
 fs/overlayfs/copy_up.c                             |   3 +-
 fs/squashfs/file.c                                 |   6 +-
 fs/ubifs/replay.c                                  |   3 +-
 include/crypto/acompress.h                         |   2 +
 include/crypto/aead.h                              |   2 +
 include/crypto/akcipher.h                          |   2 +
 include/crypto/hash.h                              |   4 +
 include/crypto/kpp.h                               |   2 +
 include/crypto/rng.h                               |   2 +
 include/crypto/skcipher.h                          |   2 +
 include/linux/hid.h                                |   2 +
 include/linux/i2c.h                                |   2 +
 include/linux/iomap.h                              |   1 +
 include/linux/module.h                             |  26 +-
 include/linux/power/bq27xxx_battery.h              |   1 -
 include/linux/smp.h                                |   2 +-
 include/linux/spi/spi.h                            |   3 +
 include/linux/tty_driver.h                         |   2 +-
 include/net/bluetooth/hci_core.h                   |   1 +
 include/scsi/libfcoe.h                             |   2 +-
 include/uapi/linux/netfilter/xt_SECMARK.h          |   6 +
 include/uapi/linux/tty_flags.h                     |   4 +-
 kernel/futex.c                                     |   3 +-
 kernel/irq/matrix.c                                |   4 +-
 kernel/kexec_file.c                                |   4 +-
 kernel/module.c                                    |  61 ++-
 kernel/sched/debug.c                               |  42 +-
 kernel/sched/fair.c                                |  12 +-
 kernel/smp.c                                       |  10 +-
 kernel/time/posix-timers.c                         |   4 +-
 kernel/trace/ftrace.c                              |   5 +-
 kernel/trace/trace.c                               |  41 +-
 kernel/trace/trace_clock.c                         |  44 +-
 kernel/up.c                                        |   2 +-
 lib/bug.c                                          |  33 +-
 lib/kobject_uevent.c                               |   9 +-
 lib/nlattr.c                                       |   2 +-
 lib/stackdepot.c                                   |   6 +-
 mm/hugetlb.c                                       |  11 +-
 mm/khugepaged.c                                    |  18 +-
 mm/ksm.c                                           |   1 +
 mm/memory-failure.c                                |   2 +-
 mm/shmem.c                                         |  12 +-
 mm/sparse.c                                        |   1 +
 net/bluetooth/ecdh_helper.h                        |   2 +-
 net/bluetooth/hci_event.c                          |   3 +-
 net/bluetooth/hci_request.c                        |  12 +-
 net/bluetooth/l2cap_core.c                         |   4 +
 net/bluetooth/l2cap_sock.c                         |   8 +
 net/bridge/br_arp_nd_proxy.c                       |   4 +-
 net/core/ethtool.c                                 |   2 +-
 net/hsr/hsr_framereg.c                             |   3 +-
 net/ipv4/tcp_cong.c                                |   4 +
 net/ipv6/ip6_gre.c                                 |   7 +-
 net/ipv6/ip6_tunnel.c                              |   3 +-
 net/ipv6/ip6_vti.c                                 |   3 +-
 net/ipv6/sit.c                                     |   5 +-
 net/mac80211/main.c                                |   7 +-
 net/mac80211/mlme.c                                |   5 +
 net/netfilter/nf_conntrack_standalone.c            |   5 +-
 net/netfilter/nfnetlink_osf.c                      |   2 +
 net/netfilter/nft_set_hash.c                       |  10 +-
 net/netfilter/xt_SECMARK.c                         |  88 +++-
 net/nfc/digital_dep.c                              |   2 +
 net/nfc/llcp_sock.c                                |   4 +
 net/openvswitch/actions.c                          |   8 +-
 net/sctp/sm_make_chunk.c                           |   2 +-
 net/sctp/sm_statefuns.c                            |  28 +-
 net/sctp/socket.c                                  |  38 +-
 net/smc/af_smc.c                                   |   4 +-
 net/tipc/netlink_compat.c                          |   2 +-
 net/vmw_vsock/vmci_transport.c                     |   3 +-
 net/wireless/scan.c                                |   2 +
 net/xdp/xsk_queue.h                                |   7 +-
 samples/bpf/tracex1_kern.c                         |   4 +-
 samples/kfifo/bytestream-example.c                 |   8 +-
 samples/kfifo/inttype-example.c                    |   8 +-
 samples/kfifo/record-example.c                     |   8 +-
 scripts/bloat-o-meter                              |   2 +-
 scripts/config                                     |   2 +-
 scripts/diffconfig                                 |   2 +-
 scripts/kconfig/nconf.c                            |   2 +-
 scripts/recordmcount.pl                            |   2 +-
 scripts/split-man.pl                               |   2 +-
 security/commoncap.c                               |   2 +-
 sound/core/init.c                                  |   2 -
 sound/isa/sb/emu8000.c                             |   4 +-
 sound/isa/sb/sb16_csp.c                            |   8 +-
 sound/pci/hda/hda_generic.c                        |  16 +-
 sound/pci/hda/patch_conexant.c                     |  14 +-
 sound/pci/hda/patch_realtek.c                      |  89 ++--
 sound/pci/rme9652/hdsp.c                           |   3 +-
 sound/pci/rme9652/hdspm.c                          |   3 +-
 sound/pci/rme9652/rme9652.c                        |   3 +-
 sound/soc/codecs/ak5558.c                          |   4 +-
 sound/soc/codecs/rt286.c                           |  23 +-
 sound/soc/intel/boards/bytcr_rt5640.c              |  20 +
 sound/soc/samsung/tm2_wm5110.c                     |   2 +-
 sound/usb/card.c                                   |  14 +-
 sound/usb/clock.c                                  |  18 +-
 sound/usb/midi.c                                   |   2 +-
 sound/usb/mixer.c                                  |  60 +--
 sound/usb/mixer_maps.c                             |  68 +--
 sound/usb/mixer_quirks.c                           |   6 +-
 sound/usb/mixer_scarlett.c                         |  14 +-
 sound/usb/proc.c                                   |   2 +-
 sound/usb/quirks.c                                 |  16 +-
 sound/usb/stream.c                                 |   4 +-
 sound/usb/usbaudio.h                               |   2 +
 sound/usb/validate.c                               |   4 +-
 tools/perf/python/tracepoint.py                    |   2 +-
 tools/perf/util/symbol_fprintf.c                   |   2 +-
 tools/testing/ktest/compare-ktest-sample.pl        |   2 +-
 tools/testing/selftests/bpf/test_offload.py        |   2 +-
 tools/testing/selftests/lib.mk                     |   4 +
 tools/testing/selftests/tc-testing/tdc_batch.py    |   2 +-
 virt/kvm/arm/arm.c                                 |   2 +
 445 files changed, 3265 insertions(+), 1849 deletions(-)


