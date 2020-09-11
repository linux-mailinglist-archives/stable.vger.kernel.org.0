Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62C36266179
	for <lists+stable@lfdr.de>; Fri, 11 Sep 2020 16:47:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726055AbgIKOqc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Sep 2020 10:46:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:52674 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726170AbgIKNCV (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 11 Sep 2020 09:02:21 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 91C9D22288;
        Fri, 11 Sep 2020 12:57:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599829028;
        bh=v/CxNMoXXw5BDtpf2UJhre6LsDZofzdsS11Gl/0WBYc=;
        h=From:To:Cc:Subject:Date:From;
        b=R3r2pnTyQnaIhkeuvgp2zXjMWMTDhw7piEobG+UkMhAyVPm0DAFamTgdTyXGZtmlE
         qFONSpU3Dt8sgk+cJcNRaoSlgTNW1fLG47xur62glcRXPNZ6VepBvaE1V6VQ67qIvc
         CrUPA0u1HxmRO42Slc1IWY+IU3eyDFVIg10E98v8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.9 00/71] 4.9.236-rc1 review
Date:   Fri, 11 Sep 2020 14:45:44 +0200
Message-Id: <20200911122504.928931589@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.236-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.9.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.9.236-rc1
X-KernelTest-Deadline: 2020-09-13T12:25+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.9.236 release.
There are 71 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun, 13 Sep 2020 12:24:42 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.236-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.9.236-rc1

Jakub Kicinski <kuba@kernel.org>
    net: disable netpoll on fresh napis

Xin Long <lucien.xin@gmail.com>
    sctp: not disable bh in the whole sctp_get_port_local()

Kamil Lorenc <kamil@re-ws.pl>
    net: usb: dm9601: Add USB ID of Keenetic Plus DSL

Paul Moore <paul@paul-moore.com>
    netlabel: fix problems with mapping removal

Jakub Kicinski <kuba@kernel.org>
    bnxt: don't enable NAPI until rings are ready

Shung-Hsi Yu <shung-hsi.yu@suse.com>
    net: ethernet: mlx4: Fix memory allocation in mlx4_buddy_init()

Max Staudt <max@enpas.org>
    affs: fix basic permission bits to actually work

Fabian Frederick <fabf@skynet.be>
    fs/affs: use octal for permissions

Takashi Sakamoto <o-takashi@sakamocchi.jp>
    ALSA; firewire-tascam: exclude Tascam FE-8 from detection

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

Tim Froidcoeur <tim.froidcoeur@tessares.net>
    net: initialize fastreuse on inet_inherit_port

Tim Froidcoeur <tim.froidcoeur@tessares.net>
    net: refactor bind_bucket fastreuse into helper

James Morse <james.morse@arm.com>
    KVM: arm64: Set HCR_EL2.PTW to prevent AT taking synchronous exception

James Morse <james.morse@arm.com>
    KVM: arm64: Survive synchronous exceptions caused by AT instructions

James Morse <james.morse@arm.com>
    KVM: arm64: Defer guest entry when an asynchronous exception is pending

James Morse <james.morse@arm.com>
    KVM: arm64: Add kvm_extable for vaxorcism code

Alex Williamson <alex.williamson@redhat.com>
    vfio-pci: Invalidate mmaps and block MMIO access on disabled memory

Alex Williamson <alex.williamson@redhat.com>
    vfio-pci: Fault mmaps to enable vma tracking

Alex Williamson <alex.williamson@redhat.com>
    vfio/type1: Support faulting PFNMAP vmas

Eugeniu Rosca <erosca@de.adit-jv.com>
    mm: slub: fix conversion of freelist_corrupted()

Ye Bin <yebin10@huawei.com>
    dm thin metadata: Avoid returning cmd->bm wild pointer on error

Ye Bin <yebin10@huawei.com>
    dm cache metadata: Avoid returning cmd->bm wild pointer on error

Tejun Heo <tj@kernel.org>
    libata: implement ATA_HORKAGE_MAX_TRIM_128M and apply to Sandisks

Bart Van Assche <bart.vanassche@wdc.com>
    block: Move SECTOR_SIZE and SECTOR_SHIFT definitions into <linux/blkdev.h>

Ming Lei <ming.lei@redhat.com>
    block: allow for_each_bvec to support zero len bvec

Takashi Sakamoto <o-takashi@sakamocchi.jp>
    ALSA: firewire-digi00x: exclude Avid Adrenaline from detection

Takashi Iwai <tiwai@suse.de>
    ALSA: pcm: oss: Remove superfluous WARN_ON() for mulaw sanity check

Tong Zhang <ztong0001@gmail.com>
    ALSA: ca0106: fix error code handling

Rogan Dawes <rogan@dawes.za.net>
    usb: qmi_wwan: add D-Link DWM-222 A2 device ID

Bjørn Mork <bjorn@mork.no>
    qmi_wwan: new Telewell and Sierra device IDs

Daniele Palmas <dnlplm@gmail.com>
    drivers: net: usb: qmi_wwan: add QMI_QUIRK_SET_DTR for Telit PID 0x1201

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

Josef Bacik <josef@toxicpanda.com>
    btrfs: drop path before adding new uuid tree entry

Jason Gunthorpe <jgg@nvidia.com>
    include/linux/log2.h: add missing () around n in roundup_pow_of_two()

Tony Lindgren <tony@atomide.com>
    thermal: ti-soc-thermal: Fix bogus thermal shutdowns for omap4430

Lu Baolu <baolu.lu@linux.intel.com>
    iommu/vt-d: Serialize IOMMU GCMD register modifications

Michael Chan <michael.chan@broadcom.com>
    tg3: Fix soft lockup when tg3_reset_task() fails.

Al Viro <viro@zeniv.linux.org.uk>
    fix regression in "epoll: Keep a reference on files added to the check list"

Vasundhara Volam <vasundhara-v.volam@broadcom.com>
    bnxt_en: Fix PCI AER error recovery flow

Vasundhara Volam <vasundhara-v.volam@broadcom.com>
    bnxt_en: Check for zero dir entries in NVRAM.

Marek Szyprowski <m.szyprowski@samsung.com>
    dmaengine: pl330: Fix burst length if burst size is smaller than bus width

Dinghao Liu <dinghao.liu@zju.edu.cn>
    net: arc_emac: Fix memleak in arc_mdio_probe

Yuusuke Ashizuka <ashiduka@fujitsu.com>
    ravb: Fixed to be able to unload modules

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

Sven Eckelmann <sven@narfation.org>
    batman-adv: Avoid uninitialized chaddr when handling DHCP

Peter Ujfalusi <peter.ujfalusi@ti.com>
    dmaengine: of-dma: Fix of_dma_router_xlate's of_dma_xlate handling

Simon Leiner <simon@leiner.me>
    xen/xenbus: Fix granting of vmalloc'd memory

Sven Schnelle <svens@linux.ibm.com>
    s390: don't trace preemption in percpu macros

Jeff Layton <jlayton@kernel.org>
    ceph: don't allow setlease on cephfs

Amit Engel <amit.engel@dell.com>
    nvmet: Disable keep-alive timer when kato is cleared to 0h

Tom Rix <trix@redhat.com>
    hwmon: (applesmc) check status earlier.

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
 arch/arm64/kvm/hyp/entry.S                         |  26 +-
 arch/arm64/kvm/hyp/hyp-entry.S                     |  63 ++--
 arch/arm64/kvm/hyp/switch.c                        |  39 ++-
 arch/mips/kernel/smp-bmips.c                       |   2 +
 arch/mips/mm/c-r4k.c                               |   4 +
 arch/s390/include/asm/percpu.h                     |  28 +-
 arch/xtensa/platforms/iss/simdisk.c                |   1 -
 drivers/ata/libata-core.c                          |   5 +-
 drivers/ata/libata-scsi.c                          |   8 +-
 drivers/block/brd.c                                |   1 -
 drivers/block/rbd.c                                |   9 -
 drivers/block/zram/zram_drv.h                      |   1 -
 drivers/dma/at_hdmac.c                             |   2 +
 drivers/dma/of-dma.c                               |   8 +-
 drivers/dma/pl330.c                                |   2 +-
 drivers/hid/hid-core.c                             |  15 +-
 drivers/hid/hid-input.c                            |   4 +
 drivers/hid/hid-multitouch.c                       |   2 +
 drivers/hwmon/applesmc.c                           |  31 +-
 drivers/ide/ide-cd.c                               |   8 +-
 drivers/ide/ide-cd.h                               |   6 +-
 drivers/iommu/intel_irq_remapping.c                |  10 +-
 drivers/md/dm-cache-metadata.c                     |   8 +-
 drivers/md/dm-thin-metadata.c                      |   8 +-
 drivers/net/ethernet/arc/emac_mdio.c               |   1 +
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |  12 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c  |   3 +
 drivers/net/ethernet/broadcom/tg3.c                |  17 +-
 drivers/net/ethernet/hisilicon/hns/hns_enet.c      |   9 +-
 drivers/net/ethernet/mellanox/mlx4/mr.c            |   2 +-
 drivers/net/ethernet/renesas/ravb_main.c           | 110 +++----
 drivers/net/usb/asix_common.c                      |   2 +-
 drivers/net/usb/dm9601.c                           |   4 +
 drivers/net/usb/qmi_wwan.c                         |   8 +-
 drivers/nvdimm/nd.h                                |   1 -
 drivers/nvme/target/core.c                         |   6 +
 drivers/scsi/gdth.h                                |   3 -
 .../thermal/ti-soc-thermal/omap4-thermal-data.c    |  23 +-
 drivers/thermal/ti-soc-thermal/omap4xxx-bandgap.h  |  10 +-
 drivers/vfio/pci/vfio_pci.c                        | 351 +++++++++++++++++++--
 drivers/vfio/pci/vfio_pci_config.c                 |  51 ++-
 drivers/vfio/pci/vfio_pci_intrs.c                  |  14 +
 drivers/vfio/pci/vfio_pci_private.h                |  16 +
 drivers/vfio/pci/vfio_pci_rdwr.c                   |  29 +-
 drivers/vfio/vfio_iommu_type1.c                    |  36 ++-
 drivers/xen/xenbus/xenbus_client.c                 |  10 +-
 fs/affs/amigaffs.c                                 |  63 ++--
 fs/affs/file.c                                     |  26 +-
 fs/btrfs/ctree.c                                   |   8 +-
 fs/btrfs/extent_io.c                               |   8 +-
 fs/btrfs/extent_io.h                               |   6 +-
 fs/btrfs/ioctl.c                                   |  27 +-
 fs/btrfs/volumes.c                                 |   3 +-
 fs/ceph/file.c                                     |   1 +
 fs/eventpoll.c                                     |   6 +-
 include/linux/blkdev.h                             |  42 ++-
 include/linux/bvec.h                               |   9 +-
 include/linux/device-mapper.h                      |   2 -
 include/linux/hid.h                                |  42 ++-
 include/linux/ide.h                                |   1 -
 include/linux/libata.h                             |   1 +
 include/linux/log2.h                               |   2 +-
 include/linux/uaccess.h                            |  26 ++
 include/net/inet_connection_sock.h                 |   4 +
 include/net/netfilter/nf_tables.h                  |   2 +
 include/uapi/linux/msdos_fs.h                      |   2 +
 include/uapi/linux/netfilter/nf_tables.h           |   2 +-
 mm/hugetlb.c                                       |  26 +-
 mm/maccess.c                                       | 167 +++++++++-
 mm/slub.c                                          |  12 +-
 net/batman-adv/bridge_loop_avoidance.c             |   5 +-
 net/batman-adv/gateway_client.c                    |   6 +-
 net/core/dev.c                                     |   3 +-
 net/core/netpoll.c                                 |   2 +-
 net/ipv4/inet_connection_sock.c                    |  37 ++-
 net/ipv4/inet_hashtables.c                         |   1 +
 net/netfilter/nf_tables_api.c                      |   3 +-
 net/netfilter/nft_payload.c                        |   4 +-
 net/netlabel/netlabel_domainhash.c                 |  59 ++--
 net/sctp/socket.c                                  |  16 +-
 net/wireless/reg.c                                 |   3 +
 scripts/checkpatch.pl                              |   4 +-
 sound/core/oss/mulaw.c                             |   4 +-
 sound/firewire/digi00x/digi00x.c                   |   5 +
 sound/firewire/tascam/tascam.c                     |  30 +-
 sound/pci/ca0106/ca0106_main.c                     |   3 +-
 tools/perf/Documentation/perf-record.txt           |   4 +
 tools/perf/Documentation/perf-stat.txt             |   4 +
 93 files changed, 1366 insertions(+), 398 deletions(-)


