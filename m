Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2539261ACE
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 20:40:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731309AbgIHSkn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 14:40:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:53538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731286AbgIHQID (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Sep 2020 12:08:03 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 579CE23EF4;
        Tue,  8 Sep 2020 15:47:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599580069;
        bh=2Wjnz3P/XCLgDB40ETcYyOIlwJ2kmKTYwPl6UrNybBc=;
        h=From:To:Cc:Subject:Date:From;
        b=o4ALjGMj109EJpMVzwZwdbcPb+yl5tIr8WOsgmtaEdSKhqkuoDHJqVwqZWsVuJ1js
         vBWWKfoghF81YFNFXvUu1aJmVQxg3PpRnis0xbF8kLcaXwOqtuyJpTF2oE9xNHsoRH
         jnQXJvpvQdbkn52H6Wn975dvwhksNg8/vJUQSkYI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.19 00/88] 4.19.144-rc1 review
Date:   Tue,  8 Sep 2020 17:25:01 +0200
Message-Id: <20200908152221.082184905@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.144-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.144-rc1
X-KernelTest-Deadline: 2020-09-10T15:22+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.19.144 release.
There are 88 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 10 Sep 2020 15:21:57 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.144-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.19.144-rc1

Himadri Pandya <himadrispandya@gmail.com>
    net: usb: Fix uninit-was-stored issue in asix_read_phy_addr()

Johannes Berg <johannes.berg@intel.com>
    cfg80211: regulatory: reject invalid hints

Muchun Song <songmuchun@bytedance.com>
    mm/hugetlb: fix a race between hugetlb sysctl handlers

Mrinal Pandey <mrinalmni@gmail.com>
    checkpatch: fix the usage of capture group ( ... )

Alex Williamson <alex.williamson@redhat.com>
    vfio/pci: Fix SR-IOV VF handling with MMIO blocking

James Morse <james.morse@arm.com>
    KVM: arm64: Set HCR_EL2.PTW to prevent AT taking synchronous exception

James Morse <james.morse@arm.com>
    KVM: arm64: Survive synchronous exceptions caused by AT instructions

James Morse <james.morse@arm.com>
    KVM: arm64: Defer guest entry when an asynchronous exception is pending

James Morse <james.morse@arm.com>
    KVM: arm64: Add kvm_extable for vaxorcism code

Eugeniu Rosca <erosca@de.adit-jv.com>
    mm: slub: fix conversion of freelist_corrupted()

Ye Bin <yebin10@huawei.com>
    dm thin metadata: Avoid returning cmd->bm wild pointer on error

Ye Bin <yebin10@huawei.com>
    dm cache metadata: Avoid returning cmd->bm wild pointer on error

Mikulas Patocka <mpatocka@redhat.com>
    dm writecache: handle DAX to partitions on persistent memory correctly

Tejun Heo <tj@kernel.org>
    libata: implement ATA_HORKAGE_MAX_TRIM_128M and apply to Sandisks

Ming Lei <ming.lei@redhat.com>
    block: allow for_each_bvec to support zero len bvec

Max Staudt <max@enpas.org>
    affs: fix basic permission bits to actually work

Sean Young <sean@mess.org>
    media: rc: uevent sysfs file races with rc_unregister_device()

Sean Young <sean@mess.org>
    media: rc: do not access device via sysfs after rc_unregister_device()

Dan Crawford <dnlcrwfrd@gmail.com>
    ALSA: hda - Fix silent audio output and corrupted input on MSI X570-A PRO

Takashi Sakamoto <o-takashi@sakamocchi.jp>
    ALSA: firewire-digi00x: exclude Avid Adrenaline from detection

Kai Vehmanen <kai.vehmanen@linux.intel.com>
    ALSA: hda/hdmi: always check pin power status in i915 pin fixup

Takashi Iwai <tiwai@suse.de>
    ALSA: pcm: oss: Remove superfluous WARN_ON() for mulaw sanity check

Tong Zhang <ztong0001@gmail.com>
    ALSA: ca0106: fix error code handling

Rogan Dawes <rogan@dawes.za.net>
    usb: qmi_wwan: add D-Link DWM-222 A2 device ID

Daniele Palmas <dnlplm@gmail.com>
    net: usb: qmi_wwan: add Telit 0x1050 composition

Josef Bacik <josef@toxicpanda.com>
    btrfs: fix potential deadlock in the search ioctl

Daniel Borkmann <daniel@iogearbox.net>
    uaccess: Add non-pagefault user-space write function

Masami Hiramatsu <mhiramat@kernel.org>
    uaccess: Add non-pagefault user-space read functions

Josef Bacik <josef@toxicpanda.com>
    btrfs: set the lockdep class for log tree extent buffers

Nikolay Borisov <nborisov@suse.com>
    btrfs: Remove extraneous extent_buffer_get from tree_mod_log_rewind

Nikolay Borisov <nborisov@suse.com>
    btrfs: Remove redundant extent_buffer_get in get_old_root

Alex Williamson <alex.williamson@redhat.com>
    vfio-pci: Invalidate mmaps and block MMIO access on disabled memory

Alex Williamson <alex.williamson@redhat.com>
    vfio-pci: Fault mmaps to enable vma tracking

Alex Williamson <alex.williamson@redhat.com>
    vfio/type1: Support faulting PFNMAP vmas

Josef Bacik <josef@toxicpanda.com>
    btrfs: drop path before adding new uuid tree entry

Mikulas Patocka <mpatocka@redhat.com>
    xfs: don't update mtime on COW faults

Mikulas Patocka <mpatocka@redhat.com>
    ext2: don't update mtime on COW faults

Jason Gunthorpe <jgg@nvidia.com>
    include/linux/log2.h: add missing () around n in roundup_pow_of_two()

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

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    nvmet-fc: Fix a missed _irqsave version of spin_lock in 'nvmet_fc_fod_op_done()'

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nfnetlink: nfnetlink_unicast() reports EAGAIN instead of ENOBUFS

Jesper Dangaard Brouer <brouer@redhat.com>
    selftests/bpf: Fix massive output from test_maps

Jakub Kicinski <kuba@kernel.org>
    bnxt: don't enable NAPI until rings are ready

Eric Sandeen <sandeen@redhat.com>
    xfs: fix boundary test in xfs_attr_shortform_verify

Edwin Peer <edwin.peer@broadcom.com>
    bnxt_en: fix HWRM error when querying VF temperature

Vasundhara Volam <vasundhara-v.volam@broadcom.com>
    bnxt_en: Fix PCI AER error recovery flow

Vasundhara Volam <vasundhara-v.volam@broadcom.com>
    bnxt_en: Check for zero dir entries in NVRAM.

Pavan Chebbi <pavan.chebbi@broadcom.com>
    bnxt_en: Don't query FW when netif_running() is false.

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

Florian Fainelli <f.fainelli@gmail.com>
    MIPS: BMIPS: Also call bmips_cpu_setup() for secondary cores

Florian Fainelli <f.fainelli@gmail.com>
    MIPS: mm: BMIPS5000 has inclusive physical caches

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

Simon Leiner <simon@leiner.me>
    xen/xenbus: Fix granting of vmalloc'd memory

Sven Schnelle <svens@linux.ibm.com>
    s390: don't trace preemption in percpu macros

Peter Zijlstra <peterz@infradead.org>
    cpuidle: Fixup IRQ state

Jeff Layton <jlayton@kernel.org>
    ceph: don't allow setlease on cephfs

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    drm/msm/a6xx: fix gmu start on newer firmware

Amit Engel <amit.engel@dell.com>
    nvmet: Disable keep-alive timer when kato is cleared to 0h

Tom Rix <trix@redhat.com>
    hwmon: (applesmc) check status earlier.

Krishna Manikandan <mkrishn@codeaurora.org>
    drm/msm: add shutdown support for display platform_driver

John Stultz <john.stultz@linaro.org>
    tty: serial: qcom_geni_serial: Drop __init from qcom_geni_console_setup

Bodo Stroesser <bstroesser@ts.fujitsu.com>
    scsi: target: tcmu: Optimize use of flush_dcache_page

Bodo Stroesser <bstroesser@ts.fujitsu.com>
    scsi: target: tcmu: Fix size in calls to tcmu_flush_dcache_range

Kim Phillips <kim.phillips@amd.com>
    perf record/stat: Explicitly call out event modifiers in the documentation

Marc Zyngier <maz@kernel.org>
    HID: core: Sanitize event code and type when mapping input

Marc Zyngier <maz@kernel.org>
    HID: core: Correctly handle ReportSize being zero


-------------

Diffstat:

 Documentation/filesystems/affs.txt                 |  16 +-
 Makefile                                           |   4 +-
 arch/arm64/include/asm/kvm_arm.h                   |   3 +-
 arch/arm64/include/asm/kvm_asm.h                   |  43 +++
 arch/arm64/kernel/vmlinux.lds.S                    |   8 +
 arch/arm64/kvm/hyp/entry.S                         |  31 +-
 arch/arm64/kvm/hyp/hyp-entry.S                     |  63 ++--
 arch/arm64/kvm/hyp/switch.c                        |  39 ++-
 arch/mips/kernel/smp-bmips.c                       |   2 +
 arch/mips/mm/c-r4k.c                               |   4 +
 arch/s390/include/asm/percpu.h                     |  28 +-
 arch/x86/mm/numa_emulation.c                       |   2 +-
 drivers/ata/libata-core.c                          |   5 +-
 drivers/ata/libata-scsi.c                          |   8 +-
 drivers/cpuidle/cpuidle.c                          |   3 +-
 drivers/dma/at_hdmac.c                             |   2 +
 drivers/dma/of-dma.c                               |   8 +-
 drivers/dma/pl330.c                                |   2 +-
 drivers/gpu/drm/msm/adreno/a6xx_gmu.c              |  12 +-
 drivers/gpu/drm/msm/msm_drv.c                      |   8 +
 drivers/gpu/drm/radeon/radeon_display.c            |   2 +-
 drivers/hid/hid-core.c                             |  15 +-
 drivers/hid/hid-input.c                            |   4 +
 drivers/hid/hid-multitouch.c                       |   2 +
 drivers/hwmon/applesmc.c                           |  31 +-
 drivers/iommu/intel_irq_remapping.c                |  10 +-
 drivers/md/dm-cache-metadata.c                     |   8 +-
 drivers/md/dm-thin-metadata.c                      |   8 +-
 drivers/md/dm-writecache.c                         |  12 +-
 drivers/media/rc/rc-main.c                         |  44 ++-
 drivers/net/ethernet/arc/emac_mdio.c               |   1 +
 drivers/net/ethernet/broadcom/bcmsysport.c         |   6 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |  26 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c  |   5 +-
 drivers/net/ethernet/broadcom/tg3.c                |  17 +-
 drivers/net/ethernet/cortina/gemini.c              |  34 +-
 drivers/net/ethernet/hisilicon/hns/hns_enet.c      |   9 +-
 drivers/net/ethernet/mellanox/mlx4/mr.c            |   2 +-
 drivers/net/ethernet/renesas/ravb_main.c           | 110 +++----
 drivers/net/gtp.c                                  |   1 +
 drivers/net/usb/asix_common.c                      |   2 +-
 drivers/net/usb/qmi_wwan.c                         |   2 +
 drivers/nvme/target/core.c                         |   6 +
 drivers/nvme/target/fc.c                           |   4 +-
 drivers/target/target_core_user.c                  |  15 +-
 .../thermal/ti-soc-thermal/omap4-thermal-data.c    |  23 +-
 drivers/thermal/ti-soc-thermal/omap4xxx-bandgap.h  |  10 +-
 drivers/tty/serial/qcom_geni_serial.c              |   2 +-
 drivers/vfio/pci/vfio_pci.c                        | 349 +++++++++++++++++++--
 drivers/vfio/pci/vfio_pci_config.c                 |  51 ++-
 drivers/vfio/pci/vfio_pci_intrs.c                  |  14 +
 drivers/vfio/pci/vfio_pci_private.h                |  16 +
 drivers/vfio/pci/vfio_pci_rdwr.c                   |  24 +-
 drivers/vfio/vfio_iommu_type1.c                    |  36 ++-
 drivers/xen/xenbus/xenbus_client.c                 |  10 +-
 fs/affs/amigaffs.c                                 |  27 ++
 fs/affs/file.c                                     |  26 +-
 fs/btrfs/ctree.c                                   |   8 +-
 fs/btrfs/extent_io.c                               |   8 +-
 fs/btrfs/extent_io.h                               |   6 +-
 fs/btrfs/ioctl.c                                   |  27 +-
 fs/btrfs/volumes.c                                 |   3 +-
 fs/ceph/file.c                                     |   1 +
 fs/eventpoll.c                                     |   6 +-
 fs/ext2/file.c                                     |   6 +-
 fs/xfs/libxfs/xfs_attr_leaf.c                      |   4 +-
 fs/xfs/libxfs/xfs_bmap.c                           |   2 +-
 fs/xfs/xfs_file.c                                  |  12 +-
 include/linux/bvec.h                               |   9 +-
 include/linux/hid.h                                |  42 ++-
 include/linux/libata.h                             |   1 +
 include/linux/log2.h                               |   2 +-
 include/linux/netfilter/nfnetlink.h                |   3 +-
 include/linux/uaccess.h                            |  26 ++
 include/net/netfilter/nf_tables.h                  |   2 +
 include/uapi/linux/netfilter/nf_tables.h           |   2 +-
 mm/hugetlb.c                                       |  26 +-
 mm/maccess.c                                       | 167 +++++++++-
 mm/slub.c                                          |  12 +-
 net/batman-adv/bat_v_ogm.c                         |  11 +-
 net/batman-adv/bridge_loop_avoidance.c             |   5 +-
 net/batman-adv/gateway_client.c                    |   6 +-
 net/netfilter/nf_tables_api.c                      |  64 ++--
 net/netfilter/nfnetlink.c                          |  11 +-
 net/netfilter/nfnetlink_log.c                      |   3 +-
 net/netfilter/nfnetlink_queue.c                    |   2 +-
 net/netfilter/nft_payload.c                        |   4 +-
 net/wireless/reg.c                                 |   3 +
 scripts/checkpatch.pl                              |   4 +-
 sound/core/oss/mulaw.c                             |   4 +-
 sound/firewire/digi00x/digi00x.c                   |   5 +
 sound/pci/ca0106/ca0106_main.c                     |   3 +-
 sound/pci/hda/patch_hdmi.c                         |   1 +
 sound/pci/hda/patch_realtek.c                      |   1 +
 tools/include/uapi/linux/perf_event.h              |   2 +-
 tools/perf/Documentation/perf-record.txt           |   4 +
 tools/perf/Documentation/perf-stat.txt             |   4 +
 tools/perf/pmu-events/jevents.c                    |   2 +-
 tools/testing/selftests/bpf/test_maps.c            |   2 +
 99 files changed, 1379 insertions(+), 392 deletions(-)


