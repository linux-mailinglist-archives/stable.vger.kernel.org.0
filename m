Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E1A626197C
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 20:16:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731476AbgIHSPh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 14:15:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:56670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731271AbgIHQLS (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Sep 2020 12:11:18 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 075C0247CF;
        Tue,  8 Sep 2020 15:42:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599579746;
        bh=7jGAZuxrNH2Y9XhswSIpw4tsrOw2yCpWvWi9hZbRRZQ=;
        h=From:To:Cc:Subject:Date:From;
        b=Vy0FZHm0YEu/ecObTTA4sw/QX2sljU4jVA34onp3SHy0xPTC+up2q/Dncxjx99C07
         8UwbeTcfrjrZWV6pzAKugpiqu6P13iiYGvSnjJTx6OxDdkZxTmbeoKBL76shUhzjQR
         z4y5R/L9GHBe9Wuma2Tm6vwV8K+CSuQ18wImZhu8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 5.4 000/129] 5.4.64-rc1 review
Date:   Tue,  8 Sep 2020 17:24:01 +0200
Message-Id: <20200908152229.689878733@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-5.4.64-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.64-rc1
X-KernelTest-Deadline: 2020-09-10T15:22+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.4.64 release.
There are 129 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 10 Sep 2020 15:21:57 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.64-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.4.64-rc1

Himadri Pandya <himadrispandya@gmail.com>
    net: usb: Fix uninit-was-stored issue in asix_read_phy_addr()

Johannes Berg <johannes.berg@intel.com>
    cfg80211: regulatory: reject invalid hints

David Howells <dhowells@redhat.com>
    mm/khugepaged.c: fix khugepaged's request size in collapse_file

Muchun Song <songmuchun@bytedance.com>
    mm/hugetlb: fix a race between hugetlb sysctl handlers

Mrinal Pandey <mrinalmni@gmail.com>
    checkpatch: fix the usage of capture group ( ... )

Sowjanya Komatineni <skomatineni@nvidia.com>
    sdhci: tegra: Add missing TMCLK for data timeout

Wei Li <liwei391@huawei.com>
    perf record: Correct the help info of option "--no-bpf-event"

Alex Williamson <alex.williamson@redhat.com>
    vfio/pci: Fix SR-IOV VF handling with MMIO blocking

Yang Shi <shy828301@gmail.com>
    mm: madvise: fix vma user-after-free

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

Evan Quan <evan.quan@amd.com>
    drm/amd/pm: avoid false alarm due to confusing softwareshutdowntemp setting

Gustavo Pimentel <Gustavo.Pimentel@synopsys.com>
    dmaengine: dw-edma: Fix scatter-gather address calculation

Tejun Heo <tj@kernel.org>
    blk-iocost: ioc_pd_free() shouldn't assume irq disabled

Tejun Heo <tj@kernel.org>
    libata: implement ATA_HORKAGE_MAX_TRIM_128M and apply to Sandisks

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

Adrian Hunter <adrian.hunter@intel.com>
    mmc: cqhci: Add cqhci_deactivate()

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

Tong Zhang <ztong0001@gmail.com>
    ALSA: ca0106: fix error code handling

Tiezhu Yang <yangtiezhu@loongson.cn>
    Revert "ALSA: hda: Add support for Loongson 7A1000 controller"

Sasha Levin <sashal@kernel.org>
    Revert "net: dsa: microchip: set the correct number of ports"

Josef Bacik <josef@toxicpanda.com>
    btrfs: fix potential deadlock in the search ioctl

Alexander Lobakin <alobakin@dlink.ru>
    net: core: use listified Rx for GRO_NORMAL in napi_gro_receive()

Qu Wenruo <wqu@suse.com>
    btrfs: tree-checker: fix the error message for transid error

Josef Bacik <josef@toxicpanda.com>
    btrfs: set the lockdep class for log tree extent buffers

Josef Bacik <josef@toxicpanda.com>
    btrfs: set the correct lockdep class for new nodes

Josef Bacik <josef@toxicpanda.com>
    btrfs: allocate scrub workqueues outside of locks

Josef Bacik <josef@toxicpanda.com>
    btrfs: drop path before adding new uuid tree entry

Vineet Gupta <vgupta@synopsys.com>
    ARC: perf: don't bail setup if pct irq missing in device-tree

Mikulas Patocka <mpatocka@redhat.com>
    xfs: don't update mtime on COW faults

Mikulas Patocka <mpatocka@redhat.com>
    ext2: don't update mtime on COW faults

Vamshi K Sthambamkadi <vamshi.k.sthambamkadi@gmail.com>
    tracing/kprobes, x86/ptrace: Fix regs argument order for i386

Chris Wilson <chris@chris-wilson.co.uk>
    iommu/vt-d: Handle 36bit addressing for x86-32

Ajay Kaher <akaher@vmware.com>
    vfio-pci: Invalidate mmaps and block MMIO access on disabled memory

Ajay Kaher <akaher@vmware.com>
    vfio-pci: Fault mmaps to enable vma tracking

Ajay Kaher <akaher@vmware.com>
    vfio/type1: Support faulting PFNMAP vmas

Jason Gunthorpe <jgg@nvidia.com>
    include/linux/log2.h: add missing () around n in roundup_pow_of_two()

Or Cohen <orcohen@paloaltonetworks.com>
    net/packet: fix overflow in tpacket_rcv

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

Namhyung Kim <namhyung@kernel.org>
    perf jevents: Fix suspicious code in fixregex()

Darrick J. Wong <darrick.wong@oracle.com>
    xfs: fix xfs_bmap_validate_extent_raw when checking attr fork of rt files

Huang Pei <huangpei@loongson.cn>
    MIPS: add missing MSACSR and upper MSA initialization

Kai-Heng Feng <kai.heng.feng@canonical.com>
    drm/radeon: Prefer lower feedback dividers

Dan Carpenter <dan.carpenter@oracle.com>
    net: gemini: Fix another missing clk_disable_unprepare() in probe

Al Viro <viro@zeniv.linux.org.uk>
    fix regression in "epoll: Keep a reference on files added to the check list"

Shung-Hsi Yu <shung-hsi.yu@suse.com>
    net: ethernet: mlx4: Fix memory allocation in mlx4_buddy_init()

Al Grant <al.grant@foss.arm.com>
    perf tools: Correct SNOOPX field offset

Potnuri Bharat Teja <bharat@chelsio.com>
    cxgb4: fix thermal zone device registration

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

Ezequiel Garcia <ezequiel@collabora.com>
    media: cedrus: Add missing v4l2_ctrl_request_hdl_put()

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    media: vicodec: add missing v4l2_ctrl_request_hdl_put()

Jakub Kicinski <kuba@kernel.org>
    bnxt: don't enable NAPI until rings are ready

Eric Sandeen <sandeen@redhat.com>
    xfs: fix boundary test in xfs_attr_shortform_verify

Edwin Peer <edwin.peer@broadcom.com>
    bnxt_en: fix HWRM error when querying VF temperature

Michael Chan <michael.chan@broadcom.com>
    bnxt_en: Fix possible crash in bnxt_fw_reset_task().

Vasundhara Volam <vasundhara-v.volam@broadcom.com>
    bnxt_en: Fix PCI AER error recovery flow

Vasundhara Volam <vasundhara-v.volam@broadcom.com>
    bnxt_en: Check for zero dir entries in NVRAM.

Pavan Chebbi <pavan.chebbi@broadcom.com>
    bnxt_en: Don't query FW when netif_running() is false.

Murali Karicheri <m-karicheri2@ti.com>
    net: ethernet: ti: cpsw: fix clean up of vlan mc entries for host port

Nicolas Dichtel <nicolas.dichtel@6wind.com>
    gtp: add GTPA_LINK info to msg sent to userspace

Marek Szyprowski <m.szyprowski@samsung.com>
    dmaengine: pl330: Fix burst length if burst size is smaller than bus width

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

Raul E Rangel <rrangel@chromium.org>
    mmc: sdhci-acpi: Fix HS400 tuning for AMDI0040

Florian Fainelli <f.fainelli@gmail.com>
    MIPS: BMIPS: Also call bmips_cpu_setup() for secondary cores

Florian Fainelli <f.fainelli@gmail.com>
    MIPS: mm: BMIPS5000 has inclusive physical caches

David Howells <dhowells@redhat.com>
    rxrpc: Make rxrpc_kernel_get_srtt() indicate validity

David Howells <dhowells@redhat.com>
    rxrpc: Keep the ACK serial in a var in rxrpc_input_ack()

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

Furquan Shaikh <furquan@google.com>
    drivers: gpu: amd: Initialize amdgpu_dm_backlight_caps object to 0 in amdgpu_dm_update_backlight_caps

Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
    drm/amd/display: Reject overlay plane configurations in multi-display scenarios

Sven Schnelle <svens@linux.ibm.com>
    s390: don't trace preemption in percpu macros

Hou Pu <houpu@bytedance.com>
    nbd: restore default timeout when setting it to zero

Peter Zijlstra <peterz@infradead.org>
    cpuidle: Fixup IRQ state

Tomi Valkeinen <tomi.valkeinen@ti.com>
    drm/omap: fix incorrect lock state

Jeff Layton <jlayton@kernel.org>
    ceph: don't allow setlease on cephfs

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    drm/msm/a6xx: fix gmu start on newer firmware

Ofir Bitton <obitton@habana.ai>
    habanalabs: check correct vmalloc return code

Ofir Bitton <obitton@habana.ai>
    habanalabs: validate FW file size

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

Kalyan Thota <kalyan_t@codeaurora.org>
    drm/msm/dpu: Fix scale params in plane validation

Sebastian Parschauer <s.parschauer@gmx.de>
    HID: quirks: Always poll three more Lenovo PixArt mice


-------------

Diffstat:

 Documentation/devicetree/bindings/mmc/mtk-sd.txt   |   2 +
 Documentation/filesystems/affs.txt                 |  16 +-
 Makefile                                           |   4 +-
 arch/arc/kernel/perf_event.c                       |  14 +-
 arch/arm64/boot/dts/mediatek/mt7622.dtsi           |   2 +
 arch/mips/kernel/smp-bmips.c                       |   2 +
 arch/mips/kernel/traps.c                           |  12 +
 arch/mips/mm/c-r4k.c                               |   4 +
 arch/s390/include/asm/percpu.h                     |  28 +-
 arch/x86/include/asm/ptrace.h                      |   2 +-
 arch/x86/mm/numa_emulation.c                       |   2 +-
 block/blk-core.c                                   |   1 +
 block/blk-iocost.c                                 |   5 +-
 drivers/ata/libata-core.c                          |   5 +-
 drivers/ata/libata-scsi.c                          |   8 +-
 drivers/block/nbd.c                                |   2 +
 drivers/cpuidle/cpuidle.c                          |   3 +-
 drivers/dma/at_hdmac.c                             |   2 +
 drivers/dma/dw-edma/dw-edma-core.c                 |  11 +-
 drivers/dma/fsldma.h                               |  12 +-
 drivers/dma/of-dma.c                               |   8 +-
 drivers/dma/pl330.c                                |   2 +-
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |  12 +-
 .../amd/display/amdgpu_dm/amdgpu_dm_mst_types.c    |   2 +-
 .../gpu/drm/amd/display/dc/dcn10/dcn10_resource.c  |   8 +
 .../gpu/drm/amd/powerplay/hwmgr/vega10_thermal.c   |  14 +-
 drivers/gpu/drm/msm/adreno/a6xx_gmu.c              |  12 +-
 drivers/gpu/drm/msm/disp/dpu1/dpu_plane.c          |   4 +-
 drivers/gpu/drm/msm/msm_atomic.c                   |  36 +++
 drivers/gpu/drm/msm/msm_drv.c                      |   8 +
 drivers/gpu/drm/omapdrm/omap_crtc.c                |   3 +-
 drivers/gpu/drm/radeon/radeon_display.c            |   2 +-
 drivers/hid/hid-ids.h                              |   3 +
 drivers/hid/hid-quirks.c                           |   3 +
 drivers/hwmon/applesmc.c                           |  31 +-
 drivers/iommu/amd_iommu.c                          |   2 +
 drivers/iommu/intel-iommu.c                        |  14 +-
 drivers/iommu/intel_irq_remapping.c                |  10 +-
 drivers/md/dm-cache-metadata.c                     |   8 +-
 drivers/md/dm-crypt.c                              |   2 +-
 drivers/md/dm-integrity.c                          |  12 +
 drivers/md/dm-mpath.c                              |  22 +-
 drivers/md/dm-thin-metadata.c                      |  10 +-
 drivers/md/dm-writecache.c                         |  12 +-
 drivers/md/persistent-data/dm-block-manager.c      |  14 +-
 drivers/media/platform/vicodec/vicodec-core.c      |   1 +
 drivers/media/rc/rc-main.c                         |  44 ++-
 drivers/misc/habanalabs/firmware_if.c              |   9 +
 drivers/misc/habanalabs/memory.c                   |   9 +-
 drivers/misc/habanalabs/mmu.c                      |   2 +-
 drivers/mmc/host/cqhci.c                           |   6 +-
 drivers/mmc/host/cqhci.h                           |   6 +-
 drivers/mmc/host/mtk-sd.c                          |  13 +
 drivers/mmc/host/sdhci-acpi.c                      |  67 +++-
 drivers/mmc/host/sdhci-pci-core.c                  |  10 +-
 drivers/mmc/host/sdhci-tegra.c                     |  53 +++-
 drivers/net/dsa/microchip/ksz8795.c                |   3 -
 drivers/net/dsa/microchip/ksz9477.c                |   3 -
 drivers/net/dsa/mt7530.c                           |   2 +-
 drivers/net/ethernet/arc/emac_mdio.c               |   1 +
 drivers/net/ethernet/broadcom/bcmsysport.c         |   6 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |  36 ++-
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c  |   5 +-
 drivers/net/ethernet/broadcom/tg3.c                |  17 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_thermal.c |   8 +-
 drivers/net/ethernet/cortina/gemini.c              |  34 +-
 drivers/net/ethernet/hisilicon/hns/hns_enet.c      |   9 +-
 drivers/net/ethernet/mellanox/mlx4/mr.c            |   2 +-
 drivers/net/ethernet/renesas/ravb_main.c           | 110 +++----
 drivers/net/ethernet/ti/cpsw.c                     |   2 +-
 drivers/net/gtp.c                                  |   1 +
 drivers/net/usb/asix_common.c                      |   2 +-
 drivers/nvme/host/core.c                           |   2 +-
 drivers/nvme/target/core.c                         |   6 +
 drivers/nvme/target/fc.c                           |   4 +-
 drivers/staging/media/sunxi/cedrus/cedrus.c        |   7 +-
 drivers/thermal/qcom/qcom-spmi-temp-alarm.c        |   4 +-
 .../thermal/ti-soc-thermal/omap4-thermal-data.c    |  23 +-
 drivers/thermal/ti-soc-thermal/omap4xxx-bandgap.h  |  10 +-
 drivers/tty/serial/qcom_geni_serial.c              |   2 +-
 drivers/vfio/pci/vfio_pci.c                        | 349 +++++++++++++++++++--
 drivers/vfio/pci/vfio_pci_config.c                 |  51 ++-
 drivers/vfio/pci/vfio_pci_intrs.c                  |  14 +
 drivers/vfio/pci/vfio_pci_private.h                |  15 +
 drivers/vfio/pci/vfio_pci_rdwr.c                   |  24 +-
 drivers/vfio/vfio_iommu_type1.c                    |  36 ++-
 drivers/xen/xenbus/xenbus_client.c                 |  10 +-
 fs/affs/amigaffs.c                                 |  27 ++
 fs/affs/file.c                                     |  26 +-
 fs/afs/fs_probe.c                                  |   4 +-
 fs/afs/vl_probe.c                                  |   4 +-
 fs/btrfs/ctree.c                                   |   6 +-
 fs/btrfs/extent-tree.c                             |   2 +-
 fs/btrfs/extent_io.c                               |   8 +-
 fs/btrfs/extent_io.h                               |   6 +-
 fs/btrfs/ioctl.c                                   |  27 +-
 fs/btrfs/scrub.c                                   | 122 ++++---
 fs/btrfs/tree-checker.c                            |   2 +-
 fs/btrfs/volumes.c                                 |   3 +-
 fs/ceph/file.c                                     |   1 +
 fs/eventpoll.c                                     |   6 +-
 fs/ext2/file.c                                     |   6 +-
 fs/xfs/libxfs/xfs_attr_leaf.c                      |   4 +-
 fs/xfs/libxfs/xfs_bmap.c                           |   2 +-
 fs/xfs/xfs_file.c                                  |  12 +-
 include/linux/bvec.h                               |   9 +-
 include/linux/libata.h                             |   1 +
 include/linux/log2.h                               |   2 +-
 include/linux/netfilter/nfnetlink.h                |   3 +-
 include/net/af_rxrpc.h                             |   2 +-
 include/net/netfilter/nf_tables.h                  |   2 +
 include/uapi/linux/netfilter/nf_tables.h           |   2 +-
 mm/hugetlb.c                                       |  26 +-
 mm/khugepaged.c                                    |   2 +-
 mm/madvise.c                                       |   2 +-
 mm/slub.c                                          |  12 +-
 net/batman-adv/bat_v_ogm.c                         |  11 +-
 net/batman-adv/bridge_loop_avoidance.c             |   5 +-
 net/batman-adv/gateway_client.c                    |   6 +-
 net/core/dev.c                                     |   9 +-
 net/netfilter/nf_tables_api.c                      |  64 ++--
 net/netfilter/nfnetlink.c                          |  11 +-
 net/netfilter/nfnetlink_log.c                      |   3 +-
 net/netfilter/nfnetlink_queue.c                    |   2 +-
 net/netfilter/nft_payload.c                        |   4 +-
 net/packet/af_packet.c                             |   7 +-
 net/rxrpc/input.c                                  |  21 +-
 net/rxrpc/peer_object.c                            |  16 +-
 net/wireless/reg.c                                 |   3 +
 scripts/checkpatch.pl                              |   4 +-
 sound/core/oss/mulaw.c                             |   4 +-
 sound/firewire/digi00x/digi00x.c                   |   5 +
 sound/firewire/tascam/tascam.c                     |  33 +-
 sound/pci/ca0106/ca0106_main.c                     |   3 +-
 sound/pci/hda/hda_intel.c                          |   2 -
 sound/pci/hda/patch_hdmi.c                         |   1 +
 sound/pci/hda/patch_realtek.c                      |  46 ++-
 sound/usb/pcm.c                                    |   1 +
 tools/include/uapi/linux/perf_event.h              |   2 +-
 tools/perf/builtin-record.c                        |   2 +-
 tools/perf/pmu-events/jevents.c                    |   2 +-
 tools/testing/selftests/bpf/test_maps.c            |   2 +
 142 files changed, 1505 insertions(+), 504 deletions(-)


