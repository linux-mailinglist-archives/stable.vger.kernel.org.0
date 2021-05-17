Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBA48382E4B
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 16:05:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237798AbhEQOFy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 10:05:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:55376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237805AbhEQOFT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:05:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 19F8D611ED;
        Mon, 17 May 2021 14:04:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621260242;
        bh=WlEiUZakhN6k0CTazkNOg34zw+AhihcXncH1edB3U84=;
        h=From:To:Cc:Subject:Date:From;
        b=e5/YsTnnRtV9jEFlNQh92+2V5q9IX3koUYXphOEMVBExsRD6QUKEpmqkL9jsK4veA
         aBmb9RfKWC6qTlp73SNoJKUgQi52cZqGKG2xTCAzodCIV8UMkQdNWEZcK7fsC5M+h/
         4bq9H0uhvlw5LLvhaEtVfweh3Bg33/lYnpCrOe0Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 5.11 000/329] 5.11.22-rc1 review
Date:   Mon, 17 May 2021 15:58:31 +0200
Message-Id: <20210517140302.043055203@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.11.22-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.11.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.11.22-rc1
X-KernelTest-Deadline: 2021-05-19T14:03+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.11.22 release.
There are 329 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 19 May 2021 14:02:16 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.11.22-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.11.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.11.22-rc1

Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
    ASoC: rsnd: check all BUSIF status when error

Christoph Hellwig <hch@lst.de>
    nvme: do not try to reconfigure APST when the controller is not live

Arnd Bergmann <arnd@arndb.de>
    ext4: fix debug format string warning

Kees Cook <keescook@chromium.org>
    debugfs: Make debugfs_allow RO after init

Geert Uytterhoeven <geert+renesas@glider.be>
    dt-bindings: PCI: rcar-pci-host: Document missing R-Car H1 support

Zhen Lei <thunder.leizhen@huawei.com>
    dt-bindings: serial: 8250: Remove duplicated compatible strings

Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
    dt-bindings: thermal: rcar-gen3-thermal: Support five TSC nodes on r8a779a0

Geert Uytterhoeven <geert+renesas@glider.be>
    dt-bindings: media: renesas,vin: Make resets optional on R-Car Gen1

Qii Wang <qii.wang@mediatek.com>
    i2c: mediatek: Fix send master code at more than 1MHz

Fabio Estevam <festevam@gmail.com>
    media: rkvdec: Remove of_match_ptr()

Enric Balletbo i Serra <enric.balletbo@collabora.com>
    soc: mediatek: pm-domains: Add a power domain names for mt8192

Enric Balletbo i Serra <enric.balletbo@collabora.com>
    soc: mediatek: pm-domains: Add a power domain names for mt8183

Enric Balletbo i Serra <enric.balletbo@collabora.com>
    soc: mediatek: pm-domains: Add a meaningful power domain name

Paweł Chmiel <pawel.mikolaj.chmiel@gmail.com>
    clk: exynos7: Mark aclk_fsys1_200 as critical

Stéphane Marchesin <marcheu@chromium.org>
    drm/i915: Fix crash in auto_retire

Tvrtko Ursulin <tvrtko.ursulin@intel.com>
    drm/i915/overlay: Fix active retire callback alignment

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/i915: Read C0DRB3/C1DRB3 as 16 bits again

Kuogee Hsieh <khsieh@codeaurora.org>
    drm/msm/dp: check sink_count before update is_connected status

Lv Yunlong <lyl2019@mail.ustc.edu.cn>
    drm/i915/gt: Fix a double free in gen8_preallocate_top_level_pdp

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    kobject_uevent: remove warning in init_uevent_argv()

Badhri Jagan Sridharan <badhri@google.com>
    usb: typec: tcpm: Fix error while calculating PPS out values

Tony Lindgren <tony@atomide.com>
    clocksource/drivers/timer-ti-dm: Handle dra7 timer wrap errata i940

Tony Lindgren <tony@atomide.com>
    clocksource/drivers/timer-ti-dm: Prepare to handle dra7 timer wrap issue

Maciej W. Rozycki <macro@orcam.me.uk>
    MIPS: Avoid handcoded DIVU in `__div64_32' altogether

Maciej W. Rozycki <macro@orcam.me.uk>
    MIPS: Avoid DIVU in `__div64_32' is result would be zero

Maciej W. Rozycki <macro@orcam.me.uk>
    MIPS: Reinstate platform `__div64_32' handler

Matthew Wilcox (Oracle) <willy@infradead.org>
    mm: fix struct page layout on 32-bit systems

Sean Christopherson <seanjc@google.com>
    KVM: VMX: Disable preemption when probing user return MSRs

Sean Christopherson <seanjc@google.com>
    KVM: VMX: Do not advertise RDPID if ENABLE_RDTSCP control is unsupported

Vitaly Kuznetsov <vkuznets@redhat.com>
    KVM: nVMX: Always make an attempt to map eVMCS after migration

Sean Christopherson <seanjc@google.com>
    KVM: x86: Move RDPID emulation intercept to its own enum

Sean Christopherson <seanjc@google.com>
    KVM: x86: Emulate RDPID only if RDTSCP is supported

Juergen Gross <jgross@suse.com>
    xen/gntdev: fix gntdev_mmap() error exit path

Oliver Neukum <oneukum@suse.com>
    cdc-wdm: untangle a circular dependency between callback and softint

Colin Ian King <colin.king@canonical.com>
    iio: tsl2583: Fix division by a zero lux_val

Dmitry Osipenko <digetx@gmail.com>
    iio: gyro: mpu3050: Fix reported temperature value

Tomasz Duszynski <tomasz.duszynski@octakon.com>
    iio: core: fix ioctl handlers removal

Sandeep Singh <sandeep.singh@amd.com>
    xhci: Add reset resume quirk for AMD xhci controller.

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    xhci: Do not use GFP_KERNEL in (potentially) atomic context

Abhijeet Rao <abhijeet.rao@intel.com>
    xhci-pci: Allow host runtime PM as default for Intel Alder Lake xHCI

Andy Shevchenko <andy.shevchenko@gmail.com>
    usb: typec: ucsi: Put fwnode in any case during ->probe()

Jack Pham <jackp@codeaurora.org>
    usb: typec: ucsi: Retrieve all the PDOs instead of just the first 4

Wesley Cheng <wcheng@codeaurora.org>
    usb: dwc3: gadget: Return success always for kick transfer in ep queue

Jack Pham <jackp@codeaurora.org>
    usb: dwc3: gadget: Enable suspend events

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

Ming Lei <ming.lei@redhat.com>
    blk-mq: plug request for shared sbitmap

Sun Ke <sunke32@huawei.com>
    nbd: Fix NULL pointer in flush_workqueue

Chao Yu <chao@kernel.org>
    f2fs: compress: fix to assign cc.cluster_idx correctly

Chao Yu <chao@kernel.org>
    f2fs: compress: fix race condition of overwrite vs truncate

Chao Yu <chao@kernel.org>
    f2fs: compress: fix to free compress page correctly

Michal Kalderon <michal.kalderon@marvell.com>
    nvmet-rdma: Fix NULL deref when SEND is completed with error

Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
    nvmet: fix inline bio check for passthru

Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
    nvmet: fix inline bio check for bdev-ns

Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
    nvmet: add lba to sect conversion helpers

Omar Sandoval <osandov@fb.com>
    kyber: fix out of bounds access when preempted

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    ACPI: scan: Fix a memory leak in an error handling path

Andy Shevchenko <andy.shevchenko@gmail.com>
    hwmon: (ltc2992) Put fwnode in error case during ->probe()

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    usb: musb: Fix an error message

Eddie James <eajames@linux.ibm.com>
    hwmon: (occ) Fix poll rate limiting

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    usb: fotg210-hcd: Fix an error message

Alexandru Ardelean <aardelean@deviqon.com>
    iio: core: return ENODEV if ioctl is unknown

Alexandru Ardelean <aardelean@deviqon.com>
    iio: hid-sensors: select IIO_TRIGGERED_BUFFER under HID_SENSOR_IIO_TRIGGER

Dinghao Liu <dinghao.liu@zju.edu.cn>
    iio: proximity: pulsedlight: Fix rumtime PM imbalance on error

Dinghao Liu <dinghao.liu@zju.edu.cn>
    iio: light: gp2ap002: Fix rumtime PM imbalance on error

Jack Pham <jackp@codeaurora.org>
    usb: dwc3: gadget: Free gadget structure only after freeing endpoints

Jiri Olsa <jolsa@kernel.org>
    perf tools: Fix dynamic libbpf link

Zhen Lei <thunder.leizhen@huawei.com>
    xen/unpopulated-alloc: fix error return code in fill_list()

Vivek Goyal <vgoyal@redhat.com>
    dax: Wake up all waiters after invalidating dax entry

Vivek Goyal <vgoyal@redhat.com>
    dax: Add a wakeup mode parameter to put_unlocked_entry()

Vivek Goyal <vgoyal@redhat.com>
    dax: Add an enum for specifying dax wakup mode

Thomas Gleixner <tglx@linutronix.de>
    KVM: x86: Prevent deadlock against tk_core.seq

Thomas Gleixner <tglx@linutronix.de>
    KVM: x86: Cancel pvclock_gtod_work on module removal

Kuogee Hsieh <khsieh@codeaurora.org>
    drm/msm/dp: initialize audio_comp when audio starts

Wanpeng Li <wanpengli@tencent.com>
    KVM: LAPIC: Accurately guarantee busy wait for timer to expire when using hv_timer

Jonathan Marek <jonathan@marek.ca>
    drm/msm: fix LLC not being enabled for mmu500 targets

Benjamin Segall <bsegall@google.com>
    kvm: exit halt polling on need_resched() as well

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/i915: Avoid div-by-zero on gen2

David Ward <david.ward@gatech.edu>
    drm/amd/display: Initialize attribute for hdcp_srm sysfs file

Kai-Heng Feng <kai.heng.feng@canonical.com>
    drm/radeon/dpm: Disable sclk switching on Oland when two 4K 60Hz monitors are connected

Filipe Manana <fdmanana@suse.com>
    btrfs: fix race leading to unpersisted data and metadata on fsync

Filipe Manana <fdmanana@suse.com>
    btrfs: fix deadlock when cloning inline extents and using qgroups

Catalin Marinas <catalin.marinas@arm.com>
    arm64: Fix race condition on PG_dcache_clean in __sync_icache_dcache()

Peter Collingbourne <pcc@google.com>
    arm64: mte: initialize RGSR_EL1.SEED in __cpu_setup

Huang Rui <ray.huang@amd.com>
    x86, sched: Fix the AMD CPPC maximum performance value on certain AMD Ryzen generations

Tejun Heo <tj@kernel.org>
    blk-iocost: fix weight updates of inner active iocgs

Peter Xu <peterx@redhat.com>
    mm/hugetlb: fix F_SEAL_FUTURE_WRITE

Peter Collingbourne <pcc@google.com>
    kasan: fix unit tests with CONFIG_UBSAN_LOCAL_BOUNDS enabled

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

Eric Dumazet <edumazet@google.com>
    sh: Remove unused variable

Vladimir Isaev <isaev@synopsys.com>
    ARC: mm: Use max_high_pfn as a HIGHMEM zone border

Vladimir Isaev <isaev@synopsys.com>
    ARC: mm: PAE: use 40-bit physical page mask

Vineet Gupta <vgupta@synopsys.com>
    ARC: entry: fix off-by-one error in syscall number validation

Paolo Abeni <pabeni@redhat.com>
    mptcp: fix splat when closing unaccepted socket

Mateusz Palczewski <mateusz.palczewski@intel.com>
    i40e: Fix PHY type identifiers for 2.5G and 5G adapters

Jaroslaw Gawin <jaroslawx.gawin@intel.com>
    i40e: fix the restart auto-negotiation after FEC modified

Yunjian Wang <wangyunjian@huawei.com>
    i40e: Fix use-after-free in i40e_client_subtask()

Magnus Karlsson <magnus.karlsson@intel.com>
    i40e: fix broken XDP support

Eric Dumazet <edumazet@google.com>
    netfilter: nftables: avoid overflows in nft_hash_buckets()

David Hildenbrand <david@redhat.com>
    kernel/resource: make walk_mem_res() find all busy IORESOURCE_MEM resources

David Hildenbrand <david@redhat.com>
    kernel/resource: make walk_system_ram_res() find all busy IORESOURCE_SYSTEM_RAM resources

Jia-Ju Bai <baijiaju1990@gmail.com>
    kernel: kexec_file: fix error return code of kexec_calculate_store_digests()

Colin Ian King <colin.king@canonical.com>
    fs/proc/generic.c: fix incorrect pde_is_permanent check

Alex Elder <elder@linaro.org>
    net: ipa: fix inter-EE IRQ register definitions

Odin Ugedal <odin@uged.al>
    sched/fair: Fix unfairness caused by missing load decay

Quentin Perret <qperret@google.com>
    sched: Fix out-of-bound access in uclamp

Marc Kleine-Budde <mkl@pengutronix.de>
    can: m_can: m_can_tx_work_queue(): fix tx_skb race condition

Frieder Schrempf <frieder.schrempf@kontron.de>
    can: mcp251x: fix resume from sleep before interface was brought up

Marc Kleine-Budde <mkl@pengutronix.de>
    can: mcp251xfd: mcp251xfd_probe(): add missing can_rx_offload_del() in error path

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nftables: Fix a memleak from userdata error path in new objects

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nfnetlink_osf: Fix a missing skb_header_pointer() NULL check

Cong Wang <cong.wang@bytedance.com>
    smc: disallow TCP_ULP in smc_setsockopt()

Maciej Żenczykowski <maze@google.com>
    net: fix nla_strcmp to handle more then one trailing null character

Fernando Fernandez Mancera <ffmancera@riseup.net>
    ethtool: fix missing NLM_F_MULTI flag when dumping

Pavel Tatashin <pasha.tatashin@soleen.com>
    mm/gup: check for isolation errors

Pavel Tatashin <pasha.tatashin@soleen.com>
    mm/gup: return an error on migration failure

Pavel Tatashin <pasha.tatashin@soleen.com>
    mm/gup: check every subpage of a compound page during isolation

Miaohe Lin <linmiaohe@huawei.com>
    ksm: fix potential missing rmap_item for stable_node

Miaohe Lin <linmiaohe@huawei.com>
    mm/migrate.c: fix potential indeterminate pte entry in migrate_vma_insert_page()

Miaohe Lin <linmiaohe@huawei.com>
    mm/hugeltb: handle the error case in hugetlb_fix_reserve_counts()

Miaohe Lin <linmiaohe@huawei.com>
    khugepaged: fix wrong result value for trace_mm_collapse_huge_page_isolate()

Mark Rutland <mark.rutland@arm.com>
    arm64: entry: always set GIC_PRIO_PSR_I_SET during entry

Marc Zyngier <maz@kernel.org>
    arm64: entry: factor irq triage logic into macros

Kees Cook <keescook@chromium.org>
    drm/radeon: Avoid power table parsing memory leaks

Kees Cook <keescook@chromium.org>
    drm/radeon: Fix off-by-one power_state index heap overwrite

Ramesh Babu B <ramesh.babu.b@intel.com>
    net: stmmac: Clear receive all(RA) bit when promiscuous mode is off

Xuan Zhuo <xuanzhuo@linux.alibaba.com>
    xsk: Fix for xp_aligned_validate_desc() when len == chunk_size

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: xt_SECMARK: add new revision to fix structure layout

Xin Long <lucien.xin@gmail.com>
    sctp: fix a SCTP_MIB_CURRESTAB leak in sctp_sf_do_dupcook_b

Lv Yunlong <lyl2019@mail.ustc.edu.cn>
    ethernet:enic: Fix a use after free bug in enic_hard_start_xmit

Jim Quinlan <jim2101024@gmail.com>
    PCI: brcmstb: Use reset/rearm instead of deassert/assert

Jim Quinlan <jim2101024@gmail.com>
    ata: ahci_brcm: Fix use of BCM7216 reset controller

Md Haris Iqbal <haris.iqbal@cloud.ionos.com>
    block/rnbd-clt: Check the return value of the function rtrs_clt_query

Md Haris Iqbal <haris.iqbal@cloud.ionos.com>
    block/rnbd-clt: Change queue_depth type in rnbd_clt_session to size_t

Brendan Jackman <jackmanb@google.com>
    libbpf: Fix signed overflow in ringbuf_process_ring

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

Can Guo <cang@codeaurora.org>
    scsi: ufs: core: Narrow down fast path in system suspend path

Can Guo <cang@codeaurora.org>
    scsi: ufs: core: Cancel rpm_dev_flush_recheck_work during system suspend

Can Guo <cang@codeaurora.org>
    scsi: ufs: core: Do not put UFS power into LPM if link is broken

Anastasia Kovaleva <a.kovaleva@yadro.com>
    scsi: qla2xxx: Prevent PRLI in target mode

Jeff Layton <jlayton@kernel.org>
    ceph: fix inode leak on getattr error in __fh_to_dentry

Claire Chang <tientzu@chromium.org>
    swiotlb: Fix the type of index

Chuck Lever <chuck.lever@oracle.com>
    xprtrdma: rpcrdma_mr_pop() already does list_del_init()

Chuck Lever <chuck.lever@oracle.com>
    xprtrdma: Fix cwnd update ordering

Chuck Lever <chuck.lever@oracle.com>
    xprtrdma: Avoid Receive Queue wrapping

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    pwm: atmel: Fix duty cycle calculation in .get_state()

Yunjian Wang <wangyunjian@huawei.com>
    SUNRPC: Fix null pointer dereference in svc_rqst_free()

Dan Carpenter <dan.carpenter@oracle.com>
    SUNRPC: fix ternary sign expansion bug in tracing

Dave Jiang <dave.jiang@intel.com>
    dmaengine: idxd: fix cdev setup and free device lifetime issues

Dave Jiang <dave.jiang@intel.com>
    dmaengine: idxd: fix group conf_dev lifetime

Dave Jiang <dave.jiang@intel.com>
    dmaengine: idxd: fix engine conf_dev lifetime

Dave Jiang <dave.jiang@intel.com>
    dmaengine: idxd: fix wq conf_dev 'struct device' lifetime

Dave Jiang <dave.jiang@intel.com>
    dmaengine: idxd: fix idxd conf_dev 'struct device' lifetime

Dave Jiang <dave.jiang@intel.com>
    dmaengine: idxd: use ida for device instance enumeration

Zheng Yongjun <zhengyongjun3@huawei.com>
    dma: idxd: use DEFINE_MUTEX() for mutex lock

Dave Jiang <dave.jiang@intel.com>
    dmaengine: idxd: removal of pcim managed mmio mapping

Dave Jiang <dave.jiang@intel.com>
    dmaengine: idxd: cleanup pci interrupt vector allocation management

Dave Jiang <dave.jiang@intel.com>
    dmaengine: idxd: fix dma device lifetime

Colin Ian King <colin.king@canonical.com>
    dmaengine: idxd: Fix potential null dereference on pointer status

Michael Walle <michael@walle.cc>
    rtc: fsl-ftm-alarm: add MODULE_TABLE()

J. Bruce Fields <bfields@redhat.com>
    nfsd: ensure new clients break delegations

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFSv4.x: Don't return NFS4ERR_NOMATCHING_LAYOUT if we're unmounting

Guangqing Zhu <zhuguangqing83@gmail.com>
    thermal/drivers/tsens: Fix missing put_device error

Chris Dion <Christopher.Dion@dell.com>
    SUNRPC: Handle major timeout in xprt_adjust_timeout()

Chuck Lever <chuck.lever@oracle.com>
    SUNRPC: Remove trace_xprt_transmit_queued

Chuck Lever <chuck.lever@oracle.com>
    SUNRPC: Move fault injection call sites

Olga Kornievskaia <kolga@netapp.com>
    NFSv4.2 fix handling of sr_eof in SEEK's reply

Nikola Livic <nlivic@gmail.com>
    pNFS/flexfiles: fix incorrect size check in decode_nfs_fh()

Suman Anna <s-anna@ti.com>
    remoteproc: pru: Fix and cleanup firmware interrupt mapping logic

Suman Anna <s-anna@ti.com>
    remoteproc: pru: Fix wrong success return value for fw events

Suman Anna <s-anna@ti.com>
    remoteproc: pru: Fixup interrupt-parent logic for fw events

Yang Yingliang <yangyingliang@huawei.com>
    PCI: endpoint: Fix missing destroy_workqueue()

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFS: Deal correctly with attribute generation counter overflow

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFSv4.2: Always flush out writes in nfs42_proc_fallocate()

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFS: Fix attribute bitmask in _nfs42_proc_fallocate()

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFS: nfs4_bitmask_adjust() must not change the server global bitmasks

Jia-Ju Bai <baijiaju1990@gmail.com>
    rpmsg: qcom_glink_native: fix error return code of qcom_glink_rx_data()

Chao Yu <chao@kernel.org>
    f2fs: fix to avoid accessing invalid fio in f2fs_allocate_data_block()

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFS: Only change the cookie verifier if the directory page cache is empty

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFS: Fix handling of cookie verifier in uncached_readdir()

Nagendra S Tomar <natomar@microsoft.com>
    nfs: Subsequent READDIR calls should carry non-zero cookieverifier

Yi Zhuang <zhuangyi1@huawei.com>
    f2fs: Fix a hungtask problem in atomic write

Yang Yingliang <yangyingliang@huawei.com>
    fs: 9p: fix v9fs_file_open writeback fid error check

Chao Yu <chao@kernel.org>
    f2fs: fix to cover __allocate_new_section() with curseg_lock

Chao Yu <chao@kernel.org>
    f2fs: fix to avoid touching checkpointed data in get_victim()

Shradha Todi <shradha.t@samsung.com>
    PCI: endpoint: Fix NULL pointer dereference for ->get_features()

Kishon Vijay Abraham I <kishon@ti.com>
    PCI: endpoint: Make *_free_bar() to return error codes on failure

Kishon Vijay Abraham I <kishon@ti.com>
    PCI: endpoint: Add helper API to get the 'next' unreserved BAR

Kishon Vijay Abraham I <kishon@ti.com>
    PCI: endpoint: Make *_get_first_free_bar() take into account 64 bit BAR

Chao Yu <chao@kernel.org>
    f2fs: fix to update last i_size if fallocate partially succeeds

Chao Yu <chao@kernel.org>
    f2fs: fix to align to section for fallocate() on pinned file

Zhen Lei <thunder.leizhen@huawei.com>
    ARM: 9064/1: hw_breakpoint: Do not directly check the event's overflow_handler hook

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    PCI: Release OF node in pci_scan_device()'s error path

Pali Rohár <pali@kernel.org>
    PCI: iproc: Fix return value of iproc_msi_irq_domain_alloc()

Bjorn Andersson <bjorn.andersson@linaro.org>
    remoteproc: qcom_q6v5_mss: Validate p_filesz in ELF loader

Colin Ian King <colin.king@canonical.com>
    f2fs: fix a redundant call to f2fs_balance_fs if an error occurs

Chao Yu <chao@kernel.org>
    f2fs: fix panic during f2fs_resize_fs()

Chao Yu <chao@kernel.org>
    f2fs: fix to allow migrating fully valid segment

Qiuxu Zhuo <qiuxu.zhuo@intel.com>
    PCI/RCEC: Fix RCiEP device to RCEC association

Jia-Ju Bai <baijiaju1990@gmail.com>
    thermal: thermal_of: Fix error return code of thermal_of_populate_bind_params()

David Ward <david.ward@gatech.edu>
    ASoC: rt286: Make RT286_SET_GPIO_* readable and writable

Petr Mladek <pmladek@suse.com>
    watchdog: fix barriers when printing backtraces from all CPUs

Petr Mladek <pmladek@suse.com>
    watchdog/softlockup: remove logic that tried to prevent repeated reports

Petr Mladek <pmladek@suse.com>
    watchdog: explicitly update timestamp when reporting softlockup

Petr Mladek <pmladek@suse.com>
    watchdog: rename __touch_watchdog() to a better descriptive name

Sergei Trofimovich <slyfox@gentoo.org>
    ia64: module: fix symbolizer crash on fdescr

Michael Chan <michael.chan@broadcom.com>
    bnxt_en: Add PCI IDs for Hyper-V VF devices.

Masahiro Yamada <masahiroy@kernel.org>
    kbuild: generate Module.symvers only when vmlinux exists

Petr Machata <petrm@nvidia.com>
    selftests: mlxsw: Fix mausezahn invocation in ERSPAN scale test

Petr Machata <petrm@nvidia.com>
    selftests: mlxsw: Increase the tolerance of backlog buildup

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

Sean Christopherson <seanjc@google.com>
    crypto: ccp: Free SEV device if SEV init fails

Felix Fietkau <nbd@nbd.name>
    mt76: mt7615: fix entering driver-own state on mt7663

Jinzhou Su <Jinzhou.Su@amd.com>
    drm/amdgpu: Add mem sync flag for IB allocated by SA

Dingchen (David) Zhang <dingchen.zhang@amd.com>
    drm/amd/display: add handling for hdcp2 rx id list validation

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

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    mac80211: properly drop the connection in case of invalid CSA IE

David Mosberger-Tang <davidm@egauge.net>
    wilc1000: Bring MAC address setting in line with typical Linux behavior

Srikar Dronamraju <srikar@linux.vnet.ibm.com>
    powerpc/smp: Set numa node before updating mask

Cédric Le Goater <clg@kaod.org>
    powerpc/xive: Use the "ibm, chip-id" property only under PowerNV

Gustavo A. R. Silva <gustavoars@kernel.org>
    flow_dissector: Fix out-of-bounds warning in __skb_flow_bpf_to_target()

Gustavo A. R. Silva <gustavoars@kernel.org>
    sctp: Fix out-of-bounds warning in sctp_process_asconf_param()

Kai Vehmanen <kai.vehmanen@linux.intel.com>
    ALSA: hda/hdmi: fix race in handling acomp ELD notification at resume

Vamshi Krishna Gopal <vamshi.krishna.gopal@intel.com>
    ASoC: Intel: sof_sdw: add quirk for new ADL-P Rvp

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/realtek: Add quirk for Lenovo Ideapad S740

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

Vaibhav Jain <vaibhav@linux.ibm.com>
    powerpc/mm: Add cond_resched() while removing hpte mappings

Mordechay Goodstein <mordechay.goodstein@intel.com>
    iwlwifi: queue: avoid memory leak in reset flow

Johannes Berg <johannes.berg@intel.com>
    iwlwifi: pcie: make cfg vs. trans_cfg more robust

Miklos Szeredi <mszeredi@redhat.com>
    cuse: prevent clone

Miklos Szeredi <mszeredi@redhat.com>
    virtiofs: fix userns

Vivek Goyal <vgoyal@redhat.com>
    fuse: invalidate attrs when page writeback completes

Ye Weihua <yeweihua4@huawei.com>
    i2c: imx: Fix PM reference leak in i2c_imx_reg_slave()

Ryder Lee <ryder.lee@mediatek.com>
    mt76: mt7915: add wifi subsystem reset

Shayne Chen <shayne.chen@mediatek.com>
    mt76: mt7915: fix txpower init for TSSI off chips

Felix Fietkau <nbd@nbd.name>
    mt76: mt7915: fix key set/delete issue

Lorenzo Bianconi <lorenzo@kernel.org>
    mt76: mt7915: always check return value from mt7915_mcu_alloc_wtbl_req

David Bauer <mail@david-bauer.net>
    mt76: mt76x0: disable GTK offloading

Sander Vanheule <sander@svanheule.net>
    mt76: mt7615: support loading EEPROM for MT7613BE

Felix Fietkau <nbd@nbd.name>
    mt76: mt7615: fix key set/delete issues

Po-Hao Huang <phhuang@realtek.com>
    rtw88: 8822c: add LC calibration for RTL8822C

Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
    pinctrl: samsung: use 'int' for register masks in Exynos

Gyeongtaek Lee <gt82.lee@samsung.com>
    ASoC: soc-compress: lock pcm_mutex to resolve lockdep error

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    mac80211: clear the beacon's CRC after channel switch

Johan Almbladh <johan.almbladh@anyfinetworks.com>
    mac80211: Set priority and queue mapping for injected frames

Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>
    IB/hfi1: Correct oversized ring allocation

Suzuki K Poulose <suzuki.poulose@arm.com>
    coresight: Do not scan for graph if none is present

Tiezhu Yang <yangtiezhu@loongson.cn>
    MIPS: Loongson64: Use _CACHE_UNCACHED instead of _CACHE_UNCACHED_ACCELERATED

Daniel Winkler <danielwinkler@google.com>
    Bluetooth: Do not set cur_adv_instance in adv param MGMT request

Bence Csókás <bence98@sch.bme.hu>
    i2c: Add I2C_AQ_NO_REP_START adapter quirk

Matthieu Baerts <matthieu.baerts@tessares.net>
    selftests: mptcp: launch mptcp_connect with timeout

Hans de Goede <hdegoede@redhat.com>
    ASoC: rt5670: Add a quirk for the Dell Venue 10 Pro 5055

mark-yw.chen <mark-yw.chen@mediatek.com>
    Bluetooth: btusb: Enable quirk boolean flag for Mediatek Chip.

Paul M Stillwell Jr <paul.m.stillwell.jr@intel.com>
    ice: handle increasing Tx or Rx ring sizes

Hans de Goede <hdegoede@redhat.com>
    ASoC: Intel: bytcr_rt5640: Add quirk for the Chuwi Hi8 tablet

Eric Dumazet <edumazet@google.com>
    ip6_vti: proper dev_{hold|put} in ndo_[un]init methods

Yunsheng Lin <linyunsheng@huawei.com>
    net: hns3: add handling for xmit skb with recursive fraglist

Guangbin Huang <huangguangbin2@huawei.com>
    net: hns3: remediate a potential overflow risk of bd_num_list

Christophe Leroy <christophe.leroy@csgroup.eu>
    powerpc/32: Statically initialise first emergency context

Russell Currey <ruscur@russell.cc>
    selftests/powerpc: Fix L1D flushing tests for Power10

Archie Pusaka <apusaka@chromium.org>
    Bluetooth: check for zapped sk before connecting

Nikolay Aleksandrov <nikolay@nvidia.com>
    net: bridge: when suppression is enabled exclude RARP packets

Vladimir Oltean <vladimir.oltean@nxp.com>
    net/sched: cls_flower: use ntohs for struct flow_dissector_key_ports

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

Ayush Garg <ayush.garg@samsung.com>
    Bluetooth: Fix incorrect status handling in LE PHY UPDATE event

Mikhail Durnev <mikhail_durnev@mentor.com>
    ASoC: rsnd: core: Check convert rate in rsnd_hw_params

Jonathan McDowell <noodles@earth.li>
    net: stmmac: Set FIFO sizes for ipq806x

Maxim Mikityanskiy <maximmi@mellanox.com>
    net/mlx5e: Use net_prefetchw instead of prefetchw in MPWQE TX datapath

Hans de Goede <hdegoede@redhat.com>
    ASoC: Intel: bytcr_rt5640: Enable jack-detect support on Asus T100TAF

Hoang Le <hoang.h.le@dektech.com.au>
    tipc: convert dest node's address to network order

Alexander Aring <aahringo@redhat.com>
    fs: dlm: add shutdown hook

Alexander Aring <aahringo@redhat.com>
    fs: dlm: flush swork on shutdown

Alexander Aring <aahringo@redhat.com>
    fs: dlm: check on minimum msglen size

Alexander Aring <aahringo@redhat.com>
    fs: dlm: change allocation limits

Alexander Aring <aahringo@redhat.com>
    fs: dlm: add check if dlm is currently running

Alexander Aring <aahringo@redhat.com>
    fs: dlm: add errno handling to check callback

Alexander Aring <aahringo@redhat.com>
    fs: dlm: fix mark setting deadlock

Alexander Aring <aahringo@redhat.com>
    fs: dlm: fix debugfs dump

Nicolas MURE <nicolas.mure2019@gmail.com>
    ALSA: usb-audio: Add Pioneer DJM-850 to quirks-table

Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>
    ath11k: fix thermal temperature read

David Matlack <dmatlack@google.com>
    kvm: Cap halt polling at kvm->max_halt_poll_ns

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    cpufreq: intel_pstate: Use HWP if enabled by platform firmware

Tony Lindgren <tony@atomide.com>
    PM: runtime: Fix unpaired parent child_count for force_resume

Sumeet Pawnikar <sumeet.r.pawnikar@intel.com>
    ACPI: PM: Add ACPI ID of Alder Lake Fan

Lai Jiangshan <laijs@linux.alibaba.com>
    KVM/VMX: Invoke NMI non-IST entry instead of IST entry

Sean Christopherson <seanjc@google.com>
    KVM: x86/mmu: Remove the defunct update_pte() paging hook

Tom Lendacky <thomas.lendacky@amd.com>
    KVM: SVM: Make sure GHCB is mapped before updating

Jarkko Sakkinen <jarkko@kernel.org>
    tpm, tpm_tis: Reserve locality in tpm_tis_resume()

Jarkko Sakkinen <jarkko@kernel.org>
    tpm, tpm_tis: Extend locality handling to TPM2 in tpm_tis_gen_interrupt()

Zhen Lei <thunder.leizhen@huawei.com>
    tpm: fix error return code in tpm2_get_cc_attrs_tbl()

Colin Ian King <colin.king@canonical.com>
    KEYS: trusted: Fix memory leak on object td


-------------

Diffstat:

 .gitignore                                         |   1 +
 .../devicetree/bindings/media/renesas,vin.yaml     |  46 +-
 .../devicetree/bindings/pci/rcar-pci-host.yaml     |  12 +-
 Documentation/devicetree/bindings/serial/8250.yaml |   5 -
 .../bindings/thermal/rcar-gen3-thermal.yaml        |  43 +-
 Documentation/dontdiff                             |   1 +
 Makefile                                           |   6 +-
 arch/arc/include/asm/page.h                        |  12 +
 arch/arc/include/asm/pgtable.h                     |  12 +-
 arch/arc/include/uapi/asm/page.h                   |   1 -
 arch/arc/kernel/entry.S                            |   4 +-
 arch/arc/mm/init.c                                 |  11 +-
 arch/arc/mm/ioremap.c                              |   5 +-
 arch/arc/mm/tlb.c                                  |   2 +-
 arch/arm/boot/dts/dra7-l4.dtsi                     |   4 +-
 arch/arm/boot/dts/dra7.dtsi                        |  20 +
 arch/arm/kernel/hw_breakpoint.c                    |   2 +-
 arch/arm64/include/asm/daifflags.h                 |   3 +
 arch/arm64/kernel/entry-common.c                   |  17 -
 arch/arm64/kernel/entry.S                          |  85 ++--
 arch/arm64/mm/flush.c                              |   4 +-
 arch/arm64/mm/proc.S                               |  12 +
 arch/ia64/include/asm/module.h                     |   6 +-
 arch/ia64/kernel/module.c                          |  29 +-
 arch/mips/include/asm/div64.h                      |  55 ++-
 arch/mips/kernel/cpu-probe.c                       |   3 -
 arch/powerpc/kernel/head_32.h                      |   6 +-
 arch/powerpc/kernel/iommu.c                        |   4 +-
 arch/powerpc/kernel/setup_32.c                     |   2 +-
 arch/powerpc/kernel/smp.c                          |   6 +-
 arch/powerpc/lib/feature-fixups.c                  |  35 +-
 arch/powerpc/mm/book3s64/hash_utils.c              |  13 +-
 arch/powerpc/platforms/pseries/hotplug-cpu.c       |   3 -
 arch/powerpc/sysdev/xive/common.c                  |   9 +-
 arch/powerpc/sysdev/xive/native.c                  |   6 +
 arch/powerpc/sysdev/xive/xive-internal.h           |   1 +
 arch/riscv/kernel/smp.c                            |   2 +-
 arch/sh/kernel/traps.c                             |   1 -
 arch/x86/include/asm/idtentry.h                    |  15 +
 arch/x86/include/asm/kvm_host.h                    |   4 +-
 arch/x86/include/asm/processor.h                   |   2 +
 arch/x86/kernel/cpu/amd.c                          |  16 +
 arch/x86/kernel/nmi.c                              |  10 +
 arch/x86/kernel/smpboot.c                          |   2 +-
 arch/x86/kvm/cpuid.c                               |   3 +-
 arch/x86/kvm/emulate.c                             |   2 +-
 arch/x86/kvm/kvm_emulate.h                         |   1 +
 arch/x86/kvm/lapic.c                               |   2 +-
 arch/x86/kvm/mmu/mmu.c                             |  49 +-
 arch/x86/kvm/svm/sev.c                             |   3 +
 arch/x86/kvm/svm/svm.c                             |   2 +-
 arch/x86/kvm/vmx/nested.c                          |  29 +-
 arch/x86/kvm/vmx/vmx.c                             |  30 +-
 arch/x86/kvm/x86.c                                 |  40 +-
 block/bfq-iosched.c                                |   3 +-
 block/blk-iocost.c                                 |  14 +-
 block/blk-mq-sched.c                               |   8 +-
 block/blk-mq.c                                     |  11 +-
 block/kyber-iosched.c                              |   5 +-
 block/mq-deadline.c                                |   3 +-
 drivers/acpi/device_pm.c                           |   1 +
 drivers/acpi/scan.c                                |   1 +
 drivers/ata/ahci_brcm.c                            |  46 +-
 drivers/base/power/runtime.c                       |  10 +-
 drivers/block/nbd.c                                |   3 +-
 drivers/block/rnbd/rnbd-clt.c                      |  12 +-
 drivers/block/rnbd/rnbd-clt.h                      |   2 +-
 drivers/bluetooth/btusb.c                          |   4 +-
 drivers/char/tpm/tpm2-cmd.c                        |   1 +
 drivers/char/tpm/tpm_tis_core.c                    |  22 +-
 drivers/clk/samsung/clk-exynos7.c                  |   7 +-
 drivers/clocksource/timer-ti-dm-systimer.c         | 144 +++++-
 drivers/cpufreq/acpi-cpufreq.c                     |   6 +-
 drivers/cpufreq/intel_pstate.c                     |  14 +-
 drivers/crypto/ccp/sev-dev.c                       |   4 +-
 drivers/dma/idxd/cdev.c                            | 129 ++----
 drivers/dma/idxd/device.c                          |  25 +-
 drivers/dma/idxd/dma.c                             |  77 +++-
 drivers/dma/idxd/idxd.h                            |  89 +++-
 drivers/dma/idxd/init.c                            | 350 ++++++++++-----
 drivers/dma/idxd/irq.c                             |  10 +-
 drivers/dma/idxd/sysfs.c                           | 324 ++++++--------
 drivers/gpu/drm/amd/amdgpu/amdgpu_ib.c             |   2 +
 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_hdcp.c |   1 +
 drivers/gpu/drm/amd/display/dc/core/dc.c           |   4 +
 drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hubp.c  |  15 +-
 .../gpu/drm/amd/display/modules/hdcp/hdcp_psp.c    |   2 +
 drivers/gpu/drm/i915/display/intel_overlay.c       |   2 +-
 drivers/gpu/drm/i915/gem/i915_gem_mman.c           |   2 +-
 drivers/gpu/drm/i915/gt/gen8_ppgtt.c               |   1 -
 drivers/gpu/drm/i915/gt/intel_ggtt_fencing.c       |   4 +-
 drivers/gpu/drm/i915/i915_active.c                 |   3 +-
 drivers/gpu/drm/msm/adreno/a6xx_gpu.c              |   9 +-
 drivers/gpu/drm/msm/dp/dp_audio.c                  |   1 +
 drivers/gpu/drm/msm/dp/dp_display.c                |  26 +-
 drivers/gpu/drm/msm/dp/dp_display.h                |   1 +
 drivers/gpu/drm/radeon/radeon.h                    |   1 +
 drivers/gpu/drm/radeon/radeon_atombios.c           |  26 +-
 drivers/gpu/drm/radeon/radeon_pm.c                 |   8 +
 drivers/gpu/drm/radeon/si_dpm.c                    |   3 +
 drivers/hwmon/ltc2992.c                            |   8 +-
 drivers/hwmon/occ/common.c                         |   5 +-
 drivers/hwmon/occ/common.h                         |   2 +-
 drivers/hwtracing/coresight/coresight-platform.c   |   6 +
 drivers/i2c/busses/i2c-imx.c                       |   2 +-
 drivers/i2c/busses/i2c-mt65xx.c                    |   9 +-
 drivers/i2c/i2c-dev.c                              |   9 +-
 drivers/iio/accel/Kconfig                          |   1 -
 drivers/iio/common/hid-sensors/Kconfig             |   1 +
 drivers/iio/gyro/Kconfig                           |   1 -
 drivers/iio/gyro/mpu3050-core.c                    |  13 +-
 drivers/iio/humidity/Kconfig                       |   1 -
 drivers/iio/industrialio-core.c                    |   9 +-
 drivers/iio/light/Kconfig                          |   2 -
 drivers/iio/light/gp2ap002.c                       |   5 +-
 drivers/iio/light/tsl2583.c                        |   8 +
 drivers/iio/magnetometer/Kconfig                   |   1 -
 drivers/iio/orientation/Kconfig                    |   2 -
 drivers/iio/pressure/Kconfig                       |   1 -
 drivers/iio/proximity/pulsedlight-lidar-lite-v2.c  |   1 +
 drivers/iio/temperature/Kconfig                    |   1 -
 drivers/infiniband/hw/hfi1/ipoib.h                 |   3 +-
 drivers/infiniband/hw/hfi1/ipoib_tx.c              |  14 +-
 drivers/iommu/amd/init.c                           |  49 +-
 drivers/net/can/m_can/m_can.c                      |   3 +-
 drivers/net/can/spi/mcp251x.c                      |  35 +-
 drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c     |   4 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |  19 +-
 drivers/net/ethernet/cisco/enic/enic_main.c        |   7 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    | 127 ++++--
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.h    |   2 +
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c |   2 +
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c |   3 +-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_err.h |   3 +-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    |  27 +-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c |   2 +-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_mdio.c    |   2 +
 drivers/net/ethernet/intel/i40e/i40e_adminq_cmd.h  |   6 +-
 drivers/net/ethernet/intel/i40e/i40e_client.c      |   1 +
 drivers/net/ethernet/intel/i40e/i40e_common.c      |   4 +-
 drivers/net/ethernet/intel/i40e/i40e_ethtool.c     |   7 +-
 drivers/net/ethernet/intel/i40e/i40e_txrx.c        |   8 +-
 drivers/net/ethernet/intel/i40e/i40e_type.h        |   7 +-
 drivers/net/ethernet/intel/iavf/iavf_main.c        |   2 -
 drivers/net/ethernet/intel/ice/ice_lib.c           | 123 ++++--
 drivers/net/ethernet/intel/ice/ice_txrx.h          |   2 +
 drivers/net/ethernet/mediatek/mtk_eth_soc.c        |   2 +-
 drivers/net/ethernet/mediatek/mtk_eth_soc.h        |   1 +
 drivers/net/ethernet/mellanox/mlx5/core/en_tx.c    |   2 +-
 .../net/ethernet/stmicro/stmmac/dwmac-ipq806x.c    |   2 +
 drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c  |   1 +
 drivers/net/ipa/gsi.c                              |   4 +-
 drivers/net/ipa/gsi_reg.h                          |  18 +-
 drivers/net/wireless/ath/ath11k/wmi.c              |  53 +--
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c      |  35 +-
 .../net/wireless/intel/iwlwifi/pcie/trans-gen2.c   |   4 +-
 drivers/net/wireless/intel/iwlwifi/queue/tx.c      |  30 +-
 drivers/net/wireless/intel/iwlwifi/queue/tx.h      |   3 +-
 drivers/net/wireless/mediatek/mt76/mt76.h          |   1 +
 drivers/net/wireless/mediatek/mt76/mt7615/eeprom.c |   1 +
 drivers/net/wireless/mediatek/mt76/mt7615/mac.c    |  97 ++--
 drivers/net/wireless/mediatek/mt76/mt7615/main.c   |  18 +-
 drivers/net/wireless/mediatek/mt76/mt7615/mcu.c    |  12 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_util.c  |   4 +
 drivers/net/wireless/mediatek/mt76/mt7915/eeprom.c |  19 +-
 drivers/net/wireless/mediatek/mt76/mt7915/init.c   |  58 ++-
 drivers/net/wireless/mediatek/mt76/mt7915/main.c   |  25 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.c    |  27 +-
 drivers/net/wireless/mediatek/mt76/mt7915/regs.h   |  13 +
 drivers/net/wireless/microchip/wilc1000/netdev.c   |  25 +-
 drivers/net/wireless/quantenna/qtnfmac/event.c     |   6 +-
 drivers/net/wireless/realtek/rtw88/main.h          |   2 +
 drivers/net/wireless/realtek/rtw88/phy.c           |  14 +
 drivers/net/wireless/realtek/rtw88/phy.h           |   1 +
 drivers/net/wireless/realtek/rtw88/reg.h           |   5 +
 drivers/net/wireless/realtek/rtw88/rtw8822c.c      |  27 +-
 drivers/net/wireless/wl3501.h                      |  47 +-
 drivers/net/wireless/wl3501_cs.c                   |  54 +--
 drivers/nvme/host/core.c                           |   3 +-
 drivers/nvme/target/io-cmd-bdev.c                  |  10 +-
 drivers/nvme/target/nvmet.h                        |  16 +
 drivers/nvme/target/passthru.c                     |   2 +-
 drivers/nvme/target/rdma.c                         |   4 +-
 drivers/pci/controller/pcie-brcmstb.c              |  19 +-
 drivers/pci/controller/pcie-iproc-msi.c            |   2 +-
 drivers/pci/endpoint/functions/pci-epf-test.c      |  18 +-
 drivers/pci/endpoint/pci-epc-core.c                |  42 +-
 drivers/pci/pcie/rcec.c                            |   2 +-
 drivers/pci/probe.c                                |   1 +
 drivers/pinctrl/samsung/pinctrl-exynos.c           |  10 +-
 drivers/pwm/pwm-atmel.c                            |   2 +-
 drivers/remoteproc/pru_rproc.c                     |  41 +-
 drivers/remoteproc/qcom_q6v5_mss.c                 |  18 +
 drivers/rpmsg/qcom_glink_native.c                  |   1 +
 drivers/rtc/rtc-ds1307.c                           |  12 +-
 drivers/rtc/rtc-fsl-ftm-alarm.c                    |   1 +
 drivers/scsi/qla2xxx/qla_init.c                    |   3 +
 drivers/scsi/ufs/ufshcd.c                          |   7 +-
 drivers/soc/mediatek/mt8173-pm-domains.h           |  10 +
 drivers/soc/mediatek/mt8183-pm-domains.h           |  15 +
 drivers/soc/mediatek/mt8192-pm-domains.h           |  21 +
 drivers/soc/mediatek/mtk-pm-domains.c              |   6 +-
 drivers/soc/mediatek/mtk-pm-domains.h              |   2 +
 drivers/staging/media/rkvdec/rkvdec.c              |   2 +-
 drivers/thermal/qcom/tsens.c                       |   6 +-
 drivers/thermal/thermal_of.c                       |   7 +-
 drivers/usb/class/cdc-wdm.c                        |  30 +-
 drivers/usb/core/hub.c                             |   6 +-
 drivers/usb/dwc2/core.h                            |   2 +
 drivers/usb/dwc2/gadget.c                          |   3 +-
 drivers/usb/dwc3/dwc3-omap.c                       |   5 +
 drivers/usb/dwc3/dwc3-pci.c                        |   1 +
 drivers/usb/dwc3/gadget.c                          |  11 +-
 drivers/usb/host/fotg210-hcd.c                     |   4 +-
 drivers/usb/host/xhci-ext-caps.h                   |   5 +-
 drivers/usb/host/xhci-pci.c                        |   8 +-
 drivers/usb/host/xhci.c                            |   6 +-
 drivers/usb/musb/mediatek.c                        |   2 +-
 drivers/usb/typec/tcpm/tcpm.c                      |   6 +-
 drivers/usb/typec/ucsi/ucsi.c                      |  46 +-
 drivers/usb/typec/ucsi/ucsi.h                      |   6 +-
 drivers/xen/gntdev.c                               |   4 +-
 drivers/xen/unpopulated-alloc.c                    |   4 +-
 fs/9p/vfs_file.c                                   |   4 +-
 fs/btrfs/ctree.h                                   |   2 +-
 fs/btrfs/file.c                                    |  36 +-
 fs/btrfs/inode.c                                   |   4 +-
 fs/btrfs/ioctl.c                                   |   2 +-
 fs/btrfs/qgroup.c                                  |   2 +-
 fs/btrfs/send.c                                    |   4 +-
 fs/btrfs/tree-log.c                                |   3 +-
 fs/ceph/export.c                                   |   4 +-
 fs/dax.c                                           |  35 +-
 fs/debugfs/inode.c                                 |   2 +-
 fs/dlm/config.c                                    |  86 ++--
 fs/dlm/config.h                                    |   1 -
 fs/dlm/debug_fs.c                                  |   1 +
 fs/dlm/lockspace.c                                 |  20 +-
 fs/dlm/lowcomms.c                                  | 104 +++--
 fs/dlm/lowcomms.h                                  |   5 +
 fs/dlm/midcomms.c                                  |   7 +-
 fs/ext4/fast_commit.c                              |   2 +-
 fs/f2fs/compress.c                                 |  55 +--
 fs/f2fs/data.c                                     |   6 +-
 fs/f2fs/f2fs.h                                     |   7 +-
 fs/f2fs/file.c                                     |  42 +-
 fs/f2fs/gc.c                                       |  62 ++-
 fs/f2fs/inline.c                                   |   3 +-
 fs/f2fs/segment.c                                  |  86 ++--
 fs/f2fs/segment.h                                  |  14 +-
 fs/f2fs/super.c                                    |   2 +-
 fs/fuse/cuse.c                                     |   2 +
 fs/fuse/file.c                                     |   9 +
 fs/fuse/virtio_fs.c                                |   3 +-
 fs/hfsplus/extents.c                               |   7 +-
 fs/hugetlbfs/inode.c                               |   5 +
 fs/jbd2/recovery.c                                 |   5 +-
 fs/nfs/callback_proc.c                             |  17 +-
 fs/nfs/dir.c                                       |  22 +-
 fs/nfs/flexfilelayout/flexfilelayout.c             |   2 +-
 fs/nfs/inode.c                                     |   8 +-
 fs/nfs/nfs42proc.c                                 |  31 +-
 fs/nfs/nfs4proc.c                                  |  56 ++-
 fs/nfsd/nfs4state.c                                |  24 +-
 fs/proc/generic.c                                  |   2 +-
 fs/squashfs/file.c                                 |   6 +-
 include/linux/cpuhotplug.h                         |   1 +
 include/linux/elevator.h                           |   2 +-
 include/linux/i2c.h                                |   2 +
 include/linux/mm.h                                 |  32 ++
 include/linux/mm_types.h                           |   4 +-
 include/linux/nfs_xdr.h                            |  11 +-
 include/linux/pci-epc.h                            |   6 +-
 include/linux/pci-epf.h                            |   1 +
 include/linux/pm.h                                 |   1 +
 include/net/page_pool.h                            |  12 +-
 include/trace/events/sunrpc.h                      |   1 -
 include/uapi/linux/netfilter/xt_SECMARK.h          |   6 +
 kernel/dma/swiotlb.c                               |   3 +-
 kernel/kexec_file.c                                |   4 +-
 kernel/resource.c                                  |   4 +-
 kernel/sched/core.c                                |   2 +-
 kernel/sched/fair.c                                |  12 +-
 kernel/watchdog.c                                  |  40 +-
 lib/kobject_uevent.c                               |   9 +-
 lib/nlattr.c                                       |   2 +-
 lib/test_kasan.c                                   |  29 +-
 mm/gup.c                                           |  94 ++--
 mm/hugetlb.c                                       |  11 +-
 mm/khugepaged.c                                    |  18 +-
 mm/ksm.c                                           |   1 +
 mm/migrate.c                                       |   7 +
 mm/shmem.c                                         |  34 +-
 net/bluetooth/hci_event.c                          |   2 +-
 net/bluetooth/l2cap_core.c                         |   4 +
 net/bluetooth/l2cap_sock.c                         |   8 +
 net/bluetooth/mgmt.c                               |   1 -
 net/bridge/br_arp_nd_proxy.c                       |   4 +-
 net/core/flow_dissector.c                          |   6 +-
 net/core/page_pool.c                               |  12 +-
 net/ethtool/ioctl.c                                |   2 +-
 net/ethtool/netlink.c                              |   3 +-
 net/ipv6/ip6_vti.c                                 |   2 +-
 net/mac80211/mlme.c                                |  12 +-
 net/mac80211/tx.c                                  |  20 +-
 net/mptcp/subflow.c                                |   3 +-
 net/netfilter/nf_tables_api.c                      |   4 +-
 net/netfilter/nfnetlink_osf.c                      |   2 +
 net/netfilter/nft_set_hash.c                       |  10 +-
 net/netfilter/xt_SECMARK.c                         |  88 +++-
 net/sched/cls_flower.c                             |  36 +-
 net/sched/sch_taprio.c                             |   6 +
 net/sctp/sm_make_chunk.c                           |   2 +-
 net/sctp/sm_statefuns.c                            |  28 +-
 net/smc/af_smc.c                                   |   4 +-
 net/sunrpc/clnt.c                                  |  12 +-
 net/sunrpc/svc.c                                   |   3 +-
 net/sunrpc/svcsock.c                               |   2 +-
 net/sunrpc/xprt.c                                  |  12 +-
 net/sunrpc/xprtrdma/frwr_ops.c                     |   2 +-
 net/sunrpc/xprtrdma/rpc_rdma.c                     |   3 +-
 net/sunrpc/xprtrdma/transport.c                    |   6 +-
 net/sunrpc/xprtrdma/verbs.c                        |  10 +-
 net/sunrpc/xprtrdma/xprt_rdma.h                    |   2 +-
 net/tipc/netlink_compat.c                          |   2 +-
 net/xdp/xsk_queue.h                                |   7 +-
 samples/bpf/tracex1_kern.c                         |   4 +-
 scripts/Makefile.modpost                           |  15 +-
 scripts/kconfig/nconf.c                            |   2 +-
 scripts/mod/modpost.c                              |  15 +-
 security/keys/trusted-keys/trusted_tpm1.c          |   8 +-
 sound/firewire/bebob/bebob_stream.c                |  12 +-
 sound/pci/hda/ideapad_s740_helper.c                | 492 +++++++++++++++++++++
 sound/pci/hda/patch_hdmi.c                         |   4 +-
 sound/pci/hda/patch_realtek.c                      |  11 +
 sound/pci/rme9652/hdsp.c                           |   3 +-
 sound/pci/rme9652/hdspm.c                          |   3 +-
 sound/pci/rme9652/rme9652.c                        |   3 +-
 sound/soc/codecs/rt286.c                           |  23 +-
 sound/soc/codecs/rt5670.c                          |  12 +
 sound/soc/intel/boards/bytcr_rt5640.c              |  20 +
 sound/soc/intel/boards/sof_sdw.c                   |  11 +
 sound/soc/sh/rcar/core.c                           |  69 ++-
 sound/soc/sh/rcar/ssi.c                            |  16 +-
 sound/soc/soc-compress.c                           |   4 +
 sound/usb/quirks-table.h                           |  63 +++
 tools/lib/bpf/ringbuf.c                            |  30 +-
 tools/perf/Makefile.config                         |   1 +
 tools/perf/util/Build                              |   7 +
 .../drivers/net/mlxsw/mirror_gre_scale.sh          |   3 +-
 .../selftests/drivers/net/mlxsw/sch_red_core.sh    |   4 +-
 tools/testing/selftests/lib.mk                     |   4 +
 .../testing/selftests/net/forwarding/mirror_lib.sh |  19 +-
 tools/testing/selftests/net/mptcp/diag.sh          |  55 ++-
 tools/testing/selftests/net/mptcp/mptcp_connect.sh |  15 +-
 tools/testing/selftests/net/mptcp/mptcp_join.sh    |  22 +-
 tools/testing/selftests/net/mptcp/simult_flows.sh  |  13 +-
 .../selftests/powerpc/security/entry_flush.c       |   2 +-
 .../selftests/powerpc/security/flush_utils.h       |   4 +
 .../testing/selftests/powerpc/security/rfi_flush.c |   2 +-
 virt/kvm/kvm_main.c                                |   7 +-
 361 files changed, 4208 insertions(+), 1967 deletions(-)


