Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4980E261EF4
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 21:57:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730568AbgIHT5K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 15:57:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:60622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730544AbgIHPfv (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Sep 2020 11:35:51 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2BCDF224B0;
        Tue,  8 Sep 2020 15:34:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599579294;
        bh=gUmqrbE6OGmP17U9EhCXe+1BUxATB/ebcCoqAMdJBTE=;
        h=From:To:Cc:Subject:Date:From;
        b=1qgeNURt5mHxOqqTvmt0iPh/iK7XI9i46mjLJ7ZiGmvqHbhv/qrqzgQQYtBw9cNn+
         m7NuAGTMEy+wL3Maar9mdIvGak8QZU4MvudSy44yQ4rldqp3jmDx2OoA/AxYBjLUGa
         WCHDAAHZTwByLIqMO0NV/g0JRA0KP8ZSVL2q1Nds=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 5.8 000/186] 5.8.8-rc1 review
Date:   Tue,  8 Sep 2020 17:22:22 +0200
Message-Id: <20200908152241.646390211@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-5.8.8-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.8.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.8.8-rc1
X-KernelTest-Deadline: 2020-09-10T15:22+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.8.8 release.
There are 186 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 10 Sep 2020 15:21:57 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.8.8-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.8.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.8.8-rc1

Himadri Pandya <himadrispandya@gmail.com>
    net: usb: Fix uninit-was-stored issue in asix_read_phy_addr()

Johannes Berg <johannes.berg@intel.com>
    cfg80211: regulatory: reject invalid hints

David Howells <dhowells@redhat.com>
    mm/khugepaged.c: fix khugepaged's request size in collapse_file

Muchun Song <songmuchun@bytedance.com>
    mm/hugetlb: fix a race between hugetlb sysctl handlers

Li Xinhai <lixinhai.lxh@gmail.com>
    mm/hugetlb: try preferred node first when alloc gigantic page from cma

Alistair Popple <alistair@popple.id.au>
    mm/migrate: fixup setting UFFD_WP flag

Mrinal Pandey <mrinalmni@gmail.com>
    checkpatch: fix the usage of capture group ( ... )

Sowjanya Komatineni <skomatineni@nvidia.com>
    sdhci: tegra: Add missing TMCLK for data timeout

Randy Dunlap <rdunlap@infradead.org>
    kconfig: streamline_config.pl: check defined(ENV variable) before using it

Wei Li <liwei391@huawei.com>
    perf record: Correct the help info of option "--no-bpf-event"

Jens Axboe <axboe@kernel.dk>
    io_uring: no read/write-retry on -EAGAIN error and O_NONBLOCK marked file

Alistair Popple <alistair@popple.id.au>
    mm/rmap: fixup copying of soft dirty and uffd ptes

Yang Shi <shy828301@gmail.com>
    mm: madvise: fix vma user-after-free

Joerg Roedel <jroedel@suse.de>
    mm: track page table modifications in __apply_to_page_range()

Eugeniu Rosca <erosca@de.adit-jv.com>
    mm: slub: fix conversion of freelist_corrupted()

Ye Bin <yebin10@huawei.com>
    dm thin metadata: Fix use-after-free in dm_bm_set_read_only

Ye Bin <yebin10@huawei.com>
    dm thin metadata: Avoid returning cmd->bm wild pointer on error

Ye Bin <yebin10@huawei.com>
    dm cache metadata: Avoid returning cmd->bm wild pointer on error

Damien Le Moal <damien.lemoal@wdc.com>
    dm crypt: Initialize crypto wait structures

Mikulas Patocka <mpatocka@redhat.com>
    dm integrity: fix error reporting in bitmap mode after creation

Mike Snitzer <snitzer@redhat.com>
    dm mpath: fix racey management of PG initialization

Mikulas Patocka <mpatocka@redhat.com>
    dm writecache: handle DAX to partitions on persistent memory correctly

Sandeep Raghuraman <sandy.8925@gmail.com>
    drm/amdgpu: Specify get_argument function for ci_smu_funcs

Evan Quan <evan.quan@amd.com>
    drm/amd/pm: avoid false alarm due to confusing softwareshutdowntemp setting

Sean Paul <seanpaul@chromium.org>
    drm/i915: Fix sha_text population code

Gustavo Pimentel <Gustavo.Pimentel@synopsys.com>
    dmaengine: dw-edma: Fix scatter-gather address calculation

Tejun Heo <tj@kernel.org>
    blk-stat: make q->stats->lock irqsafe

Tejun Heo <tj@kernel.org>
    blk-iocost: ioc_pd_free() shouldn't assume irq disabled

He Zhe <zhe.he@windriver.com>
    mips/oprofile: Fix fallthrough placement

Tejun Heo <tj@kernel.org>
    libata: implement ATA_HORKAGE_MAX_TRIM_128M and apply to Sandisks

Eric Farman <farman@linux.ibm.com>
    s390: fix GENERIC_LOCKBREAK dependency typo in Kconfig

Jiufei Xue <jiufei.xue@linux.alibaba.com>
    io_uring: fix removing the wrong file in __io_sqe_files_update()

Jiufei Xue <jiufei.xue@linux.alibaba.com>
    io_uring: set table->files[i] to NULL when io_sqe_file_register failed

Jens Axboe <axboe@kernel.dk>
    block: ensure bdi->io_pages is always initialized

Ming Lei <ming.lei@redhat.com>
    block: allow for_each_bvec to support zero len bvec

Max Staudt <max@enpas.org>
    affs: fix basic permission bits to actually work

Sean Young <sean@mess.org>
    media: rc: uevent sysfs file races with rc_unregister_device()

Sean Young <sean@mess.org>
    media: rc: do not access device via sysfs after rc_unregister_device()

Adrian Hunter <adrian.hunter@intel.com>
    mmc: sdhci-pci: Fix SDHCI_RESET_ALL for CQHCI for Intel GLK-based controllers

Wenbin Mei <wenbin.mei@mediatek.com>
    mmc: dt-bindings: Add resets/reset-names for Mediatek MMC bindings

Wenbin Mei <wenbin.mei@mediatek.com>
    mmc: mediatek: add optional module reset property

Wenbin Mei <wenbin.mei@mediatek.com>
    arm64: dts: mt7622: add reset node for mmc device

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/realtek - Improved routing for Thinkpad X1 7th/8th Gen

Adrien Crivelli <adrien.crivelli@gmail.com>
    ALSA: hda/realtek: Add quirk for Samsung Galaxy Book Ion NT950XCJ-X716A

Takashi Sakamoto <o-takashi@sakamocchi.jp>
    ALSA; firewire-tascam: exclude Tascam FE-8 from detection

Dan Crawford <dnlcrwfrd@gmail.com>
    ALSA: hda - Fix silent audio output and corrupted input on MSI X570-A PRO

Takashi Sakamoto <o-takashi@sakamocchi.jp>
    ALSA: firewire-digi00x: exclude Avid Adrenaline from detection

Kai Vehmanen <kai.vehmanen@linux.intel.com>
    ALSA: hda/hdmi: always check pin power status in i915 pin fixup

Takashi Iwai <tiwai@suse.de>
    ALSA: pcm: oss: Remove superfluous WARN_ON() for mulaw sanity check

Joshua Sivec <sivec@posteo.net>
    ALSA: usb-audio: Add implicit feedback quirk for UR22C

František Kučera <franta-linux@frantovo.cz>
    ALSA: usb-audio: Add basic capture support for Pioneer DJ DJM-250MK2

Tong Zhang <ztong0001@gmail.com>
    ALSA: ca0106: fix error code handling

Tiezhu Yang <yangtiezhu@loongson.cn>
    Revert "ALSA: hda: Add support for Loongson 7A1000 controller"

Sasha Levin <sashal@kernel.org>
    x86/mm/32: Bring back vmalloc faulting on x86_32

Max Chou <max.chou@realtek.com>
    Bluetooth: Return NOTIFY_DONE for hci_suspend_notifier

Qu Wenruo <wqu@suse.com>
    btrfs: tree-checker: fix the error message for transid error

Marcos Paulo de Souza <mpdesouza@suse.com>
    btrfs: block-group: fix free-space bitmap threshold

Josef Bacik <josef@toxicpanda.com>
    btrfs: set the lockdep class for log tree extent buffers

Josef Bacik <josef@toxicpanda.com>
    btrfs: set the correct lockdep class for new nodes

Josef Bacik <josef@toxicpanda.com>
    btrfs: allocate scrub workqueues outside of locks

Josef Bacik <josef@toxicpanda.com>
    btrfs: fix potential deadlock in the search ioctl

Josef Bacik <josef@toxicpanda.com>
    btrfs: drop path before adding new uuid tree entry

Mike Rapoport <rppt@kernel.org>
    arc: fix memory initialization for systems with two memory banks

Vineet Gupta <vgupta@synopsys.com>
    ARC: perf: don't bail setup if pct irq missing in device-tree

Mikulas Patocka <mpatocka@redhat.com>
    xfs: don't update mtime on COW faults

Mikulas Patocka <mpatocka@redhat.com>
    ext2: don't update mtime on COW faults

Andy Lutomirski <luto@kernel.org>
    x86/debug: Allow a single level of #DB recursion

Peter Zijlstra <peterz@infradead.org>
    x86/entry: Fix AC assertion

Vamshi K Sthambamkadi <vamshi.k.sthambamkadi@gmail.com>
    tracing/kprobes, x86/ptrace: Fix regs argument order for i386

Chris Wilson <chris@chris-wilson.co.uk>
    iommu/vt-d: Handle 36bit addressing for x86-32

Jason Gunthorpe <jgg@nvidia.com>
    include/linux/log2.h: add missing () around n in roundup_pow_of_two()

Or Cohen <orcohen@paloaltonetworks.com>
    net/packet: fix overflow in tpacket_rcv

Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
    iommu/amd: Use cmpxchg_double() when updating 128-bit IRTE

Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
    iommu/amd: Restore IRTE.RemapEn bit after programming IRTE

Veera Vegivada <vvegivad@codeaurora.org>
    thermal: qcom-spmi-temp-alarm: Don't suppress negative temp

Tony Lindgren <tony@atomide.com>
    thermal: ti-soc-thermal: Fix bogus thermal shutdowns for omap4430

Lu Baolu <baolu.lu@linux.intel.com>
    iommu/vt-d: Serialize IOMMU GCMD register modifications

Huang Ying <ying.huang@intel.com>
    x86, fakenuma: Fix invalid starting node ID

Michael Chan <michael.chan@broadcom.com>
    tg3: Fix soft lockup when tg3_reset_task() fails.

YueHaibing <yuehaibing@huawei.com>
    perf bench: The do_run_multi_threaded() function must use IS_ERR(perf_session__new())

Jin Yao <yao.jin@linux.intel.com>
    perf stat: Turn off summary for interval mode by default

Namhyung Kim <namhyung@kernel.org>
    perf jevents: Fix suspicious code in fixregex()

Darrick J. Wong <darrick.wong@oracle.com>
    xfs: fix xfs_bmap_validate_extent_raw when checking attr fork of rt files

Thomas Bogendoerfer <tsbogend@alpha.franken.de>
    MIPS: SNI: Fix SCSI interrupt

Huang Pei <huangpei@loongson.cn>
    MIPS: add missing MSACSR and upper MSA initialization

Kai-Heng Feng <kai.heng.feng@canonical.com>
    drm/radeon: Prefer lower feedback dividers

Dan Murphy <dmurphy@ti.com>
    net: dp83867: Fix WoL SecureOn password

Louis Peens <louis.peens@netronome.com>
    nfp: flower: fix ABI mismatch between driver and firmware

Dan Carpenter <dan.carpenter@oracle.com>
    net: gemini: Fix another missing clk_disable_unprepare() in probe

Denis Efremov <efremov@linux.com>
    net: bcmgenet: fix mask check in bcmgenet_validate_flow()

Al Viro <viro@zeniv.linux.org.uk>
    fix regression in "epoll: Keep a reference on files added to the check list"

Shung-Hsi Yu <shung-hsi.yu@suse.com>
    net: ethernet: mlx4: Fix memory allocation in mlx4_buddy_init()

Al Grant <al.grant@foss.arm.com>
    perf tools: Correct SNOOPX field offset

Al Grant <al.grant@arm.com>
    perf intel-pt: Fix corrupt data after perf inject from

Al Grant <al.grant@arm.com>
    perf cs-etm: Fix corrupt data after perf inject from

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf top/report: Fix infinite loop in the TUI for grouped events

Christoph Hellwig <hch@lst.de>
    block: fix locking in bdev_del_partition

Tiezhu Yang <yangtiezhu@loongson.cn>
    MIPS: perf: Fix wrong check condition of Loongson event IDs

Grygorii Strashko <grygorii.strashko@ti.com>
    net: ethernet: ti: am65-cpsw: fix rmii 100Mbit link mode

Potnuri Bharat Teja <bharat@chelsio.com>
    cxgb4: fix thermal zone device registration

Viresh Kumar <viresh.kumar@linaro.org>
    opp: Don't drop reference for an OPP table that was never parsed

Florian Westphal <fw@strlen.de>
    netfilter: conntrack: do not auto-delete clash entries on reply

Keith Busch <kbusch@kernel.org>
    nvme: fix controller instance leak

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    nvmet-fc: Fix a missed _irqsave version of spin_lock in 'nvmet_fc_fod_op_done()'

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nfnetlink: nfnetlink_unicast() reports EAGAIN instead of ENOBUFS

Landen Chao <landen.chao@mediatek.com>
    net: dsa: mt7530: fix advertising unsupported 1000baseT_Half

Jesper Dangaard Brouer <brouer@redhat.com>
    selftests/bpf: Fix massive output from test_maps

Jacopo Mondi <jacopo+renesas@jmondi.org>
    media: i2c: imx214: select V4L2_FWNODE

Murali Karicheri <m-karicheri2@ti.com>
    net: ethernet: ti: cpsw_new: fix error handling in cpsw_ndo_vlan_rx_kill_vid()

Ezequiel Garcia <ezequiel@collabora.com>
    media: cedrus: Add missing v4l2_ctrl_request_hdl_put()

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    media: vicodec: add missing v4l2_ctrl_request_hdl_put()

Jakub Kicinski <kuba@kernel.org>
    bnxt: don't enable NAPI until rings are ready

Eric Sandeen <sandeen@redhat.com>
    xfs: fix boundary test in xfs_attr_shortform_verify

Brian Foster <bfoster@redhat.com>
    xfs: finish dfops on every insert range shift iteration

Edwin Peer <edwin.peer@broadcom.com>
    bnxt_en: fix HWRM error when querying VF temperature

Michael Chan <michael.chan@broadcom.com>
    bnxt_en: Fix possible crash in bnxt_fw_reset_task().

Vasundhara Volam <vasundhara-v.volam@broadcom.com>
    bnxt_en: Fix PCI AER error recovery flow

Michael Chan <michael.chan@broadcom.com>
    bnxt_en: Fix ethtool -S statitics with XDP or TCs enabled.

Vasundhara Volam <vasundhara-v.volam@broadcom.com>
    bnxt_en: Check for zero dir entries in NVRAM.

Pavan Chebbi <pavan.chebbi@broadcom.com>
    bnxt_en: Don't query FW when netif_running() is false.

Murali Karicheri <m-karicheri2@ti.com>
    net: ethernet: ti: cpsw_new: fix clean up of vlan mc entries for host port

Murali Karicheri <m-karicheri2@ti.com>
    net: ethernet: ti: cpsw: fix clean up of vlan mc entries for host port

Nicolas Dichtel <nicolas.dichtel@6wind.com>
    gtp: add GTPA_LINK info to msg sent to userspace

Peter Ujfalusi <peter.ujfalusi@ti.com>
    dmaengine: ti: k3-udma: Fix the TR initialization for prep_slave_sg

Marek Szyprowski <m.szyprowski@samsung.com>
    dmaengine: pl330: Fix burst length if burst size is smaller than bus width

Yonghong Song <yhs@fb.com>
    bpf: Fix a buffer out-of-bound access when filling raw_tp link_info

Dinghao Liu <dinghao.liu@zju.edu.cn>
    net: arc_emac: Fix memleak in arc_mdio_probe

Yuusuke Ashizuka <ashiduka@fujitsu.com>
    ravb: Fixed to be able to unload modules

Dinghao Liu <dinghao.liu@zju.edu.cn>
    net: systemport: Fix memleak in bcm_sysport_probe

Dinghao Liu <dinghao.liu@zju.edu.cn>
    net: hns: Fix memleak in hns_nic_dev_probe

Florian Westphal <fw@strlen.de>
    netfilter: nf_tables: fix destination register zeroing

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: incorrect enum nft_list_attributes definition

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: add NFTA_SET_USERDATA if not null

Tiezhu Yang <yangtiezhu@loongson.cn>
    perf top: Skip side-band event setup if HAVE_LIBBPF_SUPPORT is not set

David Ahern <dsahern@kernel.org>
    perf sched timehist: Fix use of CPU list with summary option

Raul E Rangel <rrangel@chromium.org>
    mmc: sdhci-acpi: Fix HS400 tuning for AMDI0040

Florian Fainelli <f.fainelli@gmail.com>
    MIPS: BMIPS: Also call bmips_cpu_setup() for secondary cores

Florian Fainelli <f.fainelli@gmail.com>
    MIPS: mm: BMIPS5000 has inclusive physical caches

David Howells <dhowells@redhat.com>
    rxrpc: Make rxrpc_kernel_get_srtt() indicate validity

David Howells <dhowells@redhat.com>
    rxrpc: Fix loss of RTT samples due to interposed ACK

David Howells <dhowells@redhat.com>
    rxrpc: Keep the ACK serial in a var in rxrpc_input_ack()

Yu Kuai <yukuai3@huawei.com>
    dmaengine: at_hdmac: add missing kfree() call in at_dma_xlate()

Yu Kuai <yukuai3@huawei.com>
    dmaengine: at_hdmac: add missing put_device() call in at_dma_xlate()

Yu Kuai <yukuai3@huawei.com>
    dmaengine: at_hdmac: check return value of of_find_device_by_node() in at_dma_xlate()

Jussi Kivilinna <jussi.kivilinna@haltian.com>
    batman-adv: bla: use netif_rx_ni when not in interrupt context

Linus Lüssing <linus.luessing@c0d3.blue>
    batman-adv: Fix own OGM check in aggregated OGMs

Sven Eckelmann <sven@narfation.org>
    batman-adv: Avoid uninitialized chaddr when handling DHCP

Peter Ujfalusi <peter.ujfalusi@ti.com>
    dmaengine: of-dma: Fix of_dma_router_xlate's of_dma_xlate handling

Linus Torvalds <torvalds@linux-foundation.org>
    fsldma: fix very broken 32-bit ppc ioread64 functionality

Simon Leiner <simon@leiner.me>
    xen/xenbus: Fix granting of vmalloc'd memory

Dinghao Liu <dinghao.liu@zju.edu.cn>
    drm/amd/display: Fix memleak in amdgpu_dm_mode_config_init

Wayne Lin <Wayne.Lin@amd.com>
    drm/amd/display: Retry AUX write when fail occurs

Brandon Syu <Brandon.Syu@amd.com>
    drm/amd/display: Keep current gain when ABM disable immediately

Samson Tam <Samson.Tam@amd.com>
    drm/amd/display: Fix passive dongle mistaken as active dongle in EDID emulation

Jaehyun Chung <jaehyun.chung@amd.com>
    drm/amd/display: Revert HDCP disable sequence change

Furquan Shaikh <furquan@google.com>
    drivers: gpu: amd: Initialize amdgpu_dm_backlight_caps object to 0 in amdgpu_dm_update_backlight_caps

Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
    drm/amd/display: Reject overlay plane configurations in multi-display scenarios

Tong Zhang <ztong0001@gmail.com>
    drm/amd/display: should check error using DC_OK

Sven Schnelle <svens@linux.ibm.com>
    s390: don't trace preemption in percpu macros

Hou Pu <houpu@bytedance.com>
    nbd: restore default timeout when setting it to zero

Peter Zijlstra <peterz@infradead.org>
    cpuidle: Fixup IRQ state

Paul Cercueil <paul@crapouillou.net>
    irqchip/ingenic: Leave parent IRQ unmasked on suspend

Tomi Valkeinen <tomi.valkeinen@ti.com>
    drm/omap: fix incorrect lock state

Ray Jui <ray.jui@broadcom.com>
    i2c: iproc: Fix shifting 31 bits

Jeff Layton <jlayton@kernel.org>
    ceph: don't allow setlease on cephfs

Vineeth Pillai <viremana@linux.microsoft.com>
    hv_utils: drain the timesync packets on onchannelcallback

Vineeth Pillai <viremana@linux.microsoft.com>
    hv_utils: return error if host timesysnc update is stale

Bob Peterson <rpeterso@redhat.com>
    gfs2: add some much needed cleanup for log flushes that fail

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    drm/msm/a6xx: fix gmu start on newer firmware

Ofir Bitton <obitton@habana.ai>
    habanalabs: check correct vmalloc return code

Ofir Bitton <obitton@habana.ai>
    habanalabs: validate FW file size

Oded Gabbay <oded.gabbay@gmail.com>
    habanalabs: set max power according to card type

Ofir Bitton <obitton@habana.ai>
    habanalabs: proper handling of alloc size in coresight

Ofir Bitton <obitton@habana.ai>
    habanalabs: set clock gating according to mask

Ofir Bitton <obitton@habana.ai>
    habanalabs: validate packet id during CB parse

Ofir Bitton <obitton@habana.ai>
    habanalabs: unmap PCI bars upon iATU failure

Rob Clark <robdclark@chromium.org>
    drm/msm: enable vblank during atomic commits

Amit Engel <amit.engel@dell.com>
    nvmet: Disable keep-alive timer when kato is cleared to 0h

Tom Rix <trix@redhat.com>
    hwmon: (applesmc) check status earlier.

Krishna Manikandan <mkrishn@codeaurora.org>
    drm/msm: add shutdown support for display platform_driver

John Stultz <john.stultz@linaro.org>
    tty: serial: qcom_geni_serial: Drop __init from qcom_geni_console_setup

Rob Clark <robdclark@chromium.org>
    drm/msm/dpu: fix unitialized variable error

Kalyan Thota <kalyan_t@codeaurora.org>
    drm/msm/dpu: Fix scale params in plane validation

Kalyan Thota <kalyan_t@codeaurora.org>
    drm/msm/dpu: Fix reservation failures in modeset

Sebastian Parschauer <s.parschauer@gmx.de>
    HID: quirks: Always poll three more Lenovo PixArt mice

Grant Peltier <grantpeltier93@gmail.com>
    hwmon: (pmbus/isl68137) remove READ_TEMPERATURE_1 telemetry for RAA228228


-------------

Diffstat:

 Documentation/devicetree/bindings/mmc/mtk-sd.txt   |   2 +
 Documentation/filesystems/affs.rst                 |  16 ++-
 Makefile                                           |   4 +-
 arch/arc/kernel/perf_event.c                       |  14 +--
 arch/arc/mm/init.c                                 |  27 +++--
 arch/arm64/boot/dts/mediatek/mt7622.dtsi           |   2 +
 arch/mips/kernel/perf_event_mipsxx.c               |   4 +-
 arch/mips/kernel/smp-bmips.c                       |   2 +
 arch/mips/kernel/traps.c                           |  12 ++
 arch/mips/mm/c-r4k.c                               |   4 +
 arch/mips/oprofile/op_model_mipsxx.c               |   4 +-
 arch/mips/sni/a20r.c                               |   4 +-
 arch/s390/Kconfig                                  |   2 +-
 arch/s390/include/asm/percpu.h                     |  28 ++---
 arch/x86/entry/common.c                            |  12 +-
 arch/x86/include/asm/ptrace.h                      |   2 +-
 arch/x86/include/asm/switch_to.h                   |  23 ++++
 arch/x86/kernel/setup_percpu.c                     |   6 +-
 arch/x86/kernel/traps.c                            |  66 +++++-----
 arch/x86/mm/fault.c                                | 134 +++++++++++++++++++++
 arch/x86/mm/numa_emulation.c                       |   2 +-
 arch/x86/mm/pti.c                                  |   8 +-
 arch/x86/mm/tlb.c                                  |  37 ++++++
 block/blk-core.c                                   |   1 +
 block/blk-iocost.c                                 |   5 +-
 block/blk-stat.c                                   |  17 ++-
 block/partitions/core.c                            |  27 ++---
 drivers/ata/libata-core.c                          |   5 +-
 drivers/ata/libata-scsi.c                          |   8 +-
 drivers/block/nbd.c                                |   2 +
 drivers/cpuidle/cpuidle.c                          |   3 +-
 drivers/dma/at_hdmac.c                             |  11 +-
 drivers/dma/dw-edma/dw-edma-core.c                 |  11 +-
 drivers/dma/fsldma.h                               |  12 +-
 drivers/dma/of-dma.c                               |   8 +-
 drivers/dma/pl330.c                                |   2 +-
 drivers/dma/ti/k3-udma.c                           |   6 +-
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |  12 +-
 .../amd/display/amdgpu_dm/amdgpu_dm_mst_types.c    |   2 +-
 drivers/gpu/drm/amd/display/dc/core/dc_link.c      |   3 +-
 drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c   |   8 +-
 drivers/gpu/drm/amd/display/dc/dc_stream.h         |   2 +-
 .../gpu/drm/amd/display/dc/dcn10/dcn10_resource.c  |   8 ++
 .../gpu/drm/amd/powerplay/hwmgr/vega10_thermal.c   |  14 ++-
 drivers/gpu/drm/amd/powerplay/smumgr/ci_smumgr.c   |   2 +
 drivers/gpu/drm/i915/display/intel_hdcp.c          |  26 +++-
 drivers/gpu/drm/msm/adreno/a6xx_gmu.c              |  12 +-
 drivers/gpu/drm/msm/disp/dpu1/dpu_crtc.c           |   2 +-
 drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c        |  20 +--
 drivers/gpu/drm/msm/disp/dpu1/dpu_plane.c          |   4 +-
 drivers/gpu/drm/msm/msm_atomic.c                   |  36 ++++++
 drivers/gpu/drm/msm/msm_drv.c                      |   8 ++
 drivers/gpu/drm/omapdrm/omap_crtc.c                |   3 +-
 drivers/gpu/drm/radeon/radeon_display.c            |   2 +-
 drivers/hid/hid-ids.h                              |   3 +
 drivers/hid/hid-quirks.c                           |   3 +
 drivers/hv/hv_util.c                               |  65 +++++++---
 drivers/hwmon/applesmc.c                           |  31 ++---
 drivers/hwmon/pmbus/isl68137.c                     |   7 +-
 drivers/i2c/busses/i2c-bcm-iproc.c                 |   4 +-
 drivers/iommu/Kconfig                              |   2 +-
 drivers/iommu/amd/init.c                           |  21 +++-
 drivers/iommu/amd/iommu.c                          |  19 ++-
 drivers/iommu/intel/iommu.c                        |  14 +--
 drivers/iommu/intel/irq_remapping.c                |  10 +-
 drivers/irqchip/irq-ingenic.c                      |   2 +-
 drivers/md/dm-cache-metadata.c                     |   8 +-
 drivers/md/dm-crypt.c                              |   4 +-
 drivers/md/dm-integrity.c                          |  12 ++
 drivers/md/dm-mpath.c                              |  22 ++--
 drivers/md/dm-thin-metadata.c                      |  10 +-
 drivers/md/dm-writecache.c                         |  12 +-
 drivers/md/persistent-data/dm-block-manager.c      |  14 ++-
 drivers/media/i2c/Kconfig                          |   2 +-
 drivers/media/rc/rc-main.c                         |  44 ++++---
 drivers/media/test-drivers/vicodec/vicodec-core.c  |   1 +
 drivers/misc/habanalabs/device.c                   |   7 +-
 drivers/misc/habanalabs/firmware_if.c              |   9 ++
 drivers/misc/habanalabs/gaudi/gaudi.c              |  90 ++++++++++----
 drivers/misc/habanalabs/gaudi/gaudiP.h             |   3 +-
 drivers/misc/habanalabs/gaudi/gaudi_coresight.c    |   8 +-
 drivers/misc/habanalabs/goya/goya.c                |  31 +++++
 drivers/misc/habanalabs/goya/goya_coresight.c      |   8 +-
 drivers/misc/habanalabs/habanalabs.h               |   7 +-
 drivers/misc/habanalabs/memory.c                   |   9 +-
 drivers/misc/habanalabs/mmu.c                      |   2 +-
 drivers/misc/habanalabs/pci.c                      |   6 +-
 drivers/misc/habanalabs/sysfs.c                    |   7 +-
 drivers/mmc/host/mtk-sd.c                          |  13 ++
 drivers/mmc/host/sdhci-acpi.c                      |  67 +++++++++--
 drivers/mmc/host/sdhci-pci-core.c                  |  10 +-
 drivers/mmc/host/sdhci-tegra.c                     |  53 +++++++-
 drivers/net/dsa/mt7530.c                           |   2 +-
 drivers/net/ethernet/arc/emac_mdio.c               |   1 +
 drivers/net/ethernet/broadcom/bcmsysport.c         |   6 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |  36 +++---
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c  |  16 +--
 drivers/net/ethernet/broadcom/genet/bcmgenet.c     |   2 +-
 drivers/net/ethernet/broadcom/tg3.c                |  17 ++-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_thermal.c |   8 +-
 drivers/net/ethernet/cortina/gemini.c              |  34 +++---
 drivers/net/ethernet/hisilicon/hns/hns_enet.c      |   9 +-
 drivers/net/ethernet/mellanox/mlx4/mr.c            |   2 +-
 .../ethernet/netronome/nfp/flower/tunnel_conf.c    |   2 +
 drivers/net/ethernet/renesas/ravb_main.c           | 110 ++++++++---------
 drivers/net/ethernet/ti/am65-cpsw-nuss.c           |   2 +
 drivers/net/ethernet/ti/cpsw.c                     |   2 +-
 drivers/net/ethernet/ti/cpsw_new.c                 |  29 +++--
 drivers/net/gtp.c                                  |   1 +
 drivers/net/phy/dp83867.c                          |   4 +-
 drivers/net/usb/asix_common.c                      |   2 +-
 drivers/nvme/host/core.c                           |   2 +-
 drivers/nvme/target/core.c                         |   6 +
 drivers/nvme/target/fc.c                           |   4 +-
 drivers/opp/core.c                                 |  22 +++-
 drivers/opp/opp.h                                  |   2 +-
 drivers/staging/media/sunxi/cedrus/cedrus.c        |   7 +-
 drivers/thermal/qcom/qcom-spmi-temp-alarm.c        |   4 +-
 .../thermal/ti-soc-thermal/omap4-thermal-data.c    |  23 ++--
 drivers/thermal/ti-soc-thermal/omap4xxx-bandgap.h  |  10 +-
 drivers/tty/serial/qcom_geni_serial.c              |   2 +-
 drivers/xen/xenbus/xenbus_client.c                 |  10 +-
 fs/affs/amigaffs.c                                 |  27 +++++
 fs/affs/file.c                                     |  26 +++-
 fs/afs/fs_probe.c                                  |   4 +-
 fs/afs/vl_probe.c                                  |   4 +-
 fs/btrfs/block-group.c                             |   4 +-
 fs/btrfs/ctree.c                                   |   6 +-
 fs/btrfs/extent-tree.c                             |   2 +-
 fs/btrfs/extent_io.c                               |   8 +-
 fs/btrfs/extent_io.h                               |   6 +-
 fs/btrfs/free-space-tree.c                         |   4 +
 fs/btrfs/ioctl.c                                   |  27 +++--
 fs/btrfs/scrub.c                                   | 122 +++++++++++--------
 fs/btrfs/tree-checker.c                            |   2 +-
 fs/btrfs/volumes.c                                 |   3 +-
 fs/ceph/file.c                                     |   1 +
 fs/eventpoll.c                                     |   6 +-
 fs/ext2/file.c                                     |   6 +-
 fs/gfs2/log.c                                      |  31 +++++
 fs/gfs2/trans.c                                    |   1 +
 fs/io_uring.c                                      |  16 ++-
 fs/xfs/libxfs/xfs_attr_leaf.c                      |   4 +-
 fs/xfs/libxfs/xfs_bmap.c                           |   2 +-
 fs/xfs/xfs_bmap_util.c                             |   2 +-
 fs/xfs/xfs_file.c                                  |  12 +-
 include/drm/drm_hdcp.h                             |   3 +
 include/linux/bvec.h                               |   9 +-
 include/linux/libata.h                             |   1 +
 include/linux/log2.h                               |   2 +-
 include/linux/netfilter/nfnetlink.h                |   3 +-
 include/net/af_rxrpc.h                             |   2 +-
 include/net/netfilter/nf_tables.h                  |   2 +
 include/trace/events/rxrpc.h                       |  27 ++++-
 include/uapi/linux/netfilter/nf_tables.h           |   2 +-
 kernel/bpf/syscall.c                               |   2 +-
 mm/hugetlb.c                                       |  49 ++++++--
 mm/khugepaged.c                                    |   2 +-
 mm/madvise.c                                       |   2 +-
 mm/memory.c                                        |  36 ++++--
 mm/migrate.c                                       |  17 ++-
 mm/rmap.c                                          |   9 +-
 mm/slub.c                                          |  12 +-
 net/batman-adv/bat_v_ogm.c                         |  11 +-
 net/batman-adv/bridge_loop_avoidance.c             |   5 +-
 net/batman-adv/gateway_client.c                    |   6 +-
 net/bluetooth/hci_core.c                           |   2 +-
 net/netfilter/nf_conntrack_proto_udp.c             |  26 ++--
 net/netfilter/nf_tables_api.c                      |  64 +++++-----
 net/netfilter/nfnetlink.c                          |  11 +-
 net/netfilter/nfnetlink_log.c                      |   3 +-
 net/netfilter/nfnetlink_queue.c                    |   2 +-
 net/netfilter/nft_flow_offload.c                   |   2 +-
 net/netfilter/nft_payload.c                        |   4 +-
 net/packet/af_packet.c                             |   7 +-
 net/rxrpc/ar-internal.h                            |  13 +-
 net/rxrpc/call_object.c                            |   1 +
 net/rxrpc/input.c                                  | 123 +++++++++++--------
 net/rxrpc/output.c                                 |  82 +++++++++----
 net/rxrpc/peer_object.c                            |  16 ++-
 net/rxrpc/rtt.c                                    |   3 +-
 net/wireless/reg.c                                 |   3 +
 scripts/checkpatch.pl                              |   4 +-
 scripts/kconfig/streamline_config.pl               |   5 +-
 sound/core/oss/mulaw.c                             |   4 +-
 sound/firewire/digi00x/digi00x.c                   |   5 +
 sound/firewire/tascam/tascam.c                     |  33 ++++-
 sound/pci/ca0106/ca0106_main.c                     |   3 +-
 sound/pci/hda/hda_intel.c                          |   2 -
 sound/pci/hda/patch_hdmi.c                         |   1 +
 sound/pci/hda/patch_realtek.c                      |  46 ++++++-
 sound/usb/pcm.c                                    |   2 +
 sound/usb/quirks-table.h                           |  60 +++++++--
 sound/usb/quirks.c                                 |   1 +
 tools/include/uapi/linux/perf_event.h              |   2 +-
 tools/perf/Documentation/perf-stat.txt             |   3 +
 tools/perf/bench/synthesize.c                      |   4 +-
 tools/perf/builtin-record.c                        |   2 +-
 tools/perf/builtin-sched.c                         |   6 +-
 tools/perf/builtin-stat.c                          |   8 +-
 tools/perf/builtin-top.c                           |   2 +
 tools/perf/pmu-events/jevents.c                    |   2 +-
 tools/perf/ui/browsers/hists.c                     |   3 +-
 tools/perf/util/cs-etm.c                           |   9 +-
 tools/perf/util/intel-pt.c                         |   9 +-
 tools/perf/util/stat.h                             |   1 +
 tools/testing/selftests/bpf/test_maps.c            |   2 +
 207 files changed, 2040 insertions(+), 783 deletions(-)


