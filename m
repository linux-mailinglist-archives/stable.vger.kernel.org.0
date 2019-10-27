Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2CFE2E66A8
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:14:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730374AbfJ0VOC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:14:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:32924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730371AbfJ0VOB (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:14:01 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4D7EB208C0;
        Sun, 27 Oct 2019 21:14:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572210840;
        bh=a93RO9N3KB+synyN1vK8RExqqgsMYqfpP5pt7HKYoXQ=;
        h=From:To:Cc:Subject:Date:From;
        b=aATtpqBDejSncxaZorvfqF7PkMMkfT/QxZkFhmOMZaJcIEZLDyn1/Fn635rmF3DDe
         ZISEdUdrczeYqp/cHycxZKczt3aWbNdPi4XNCZLymbavQhFt/is/KMvA7PrA6MXoMb
         hBIiMqinSP54DXfDjIP0HfZNp+rYEBIhZodK/bQQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.19 00/93] 4.19.81-stable review
Date:   Sun, 27 Oct 2019 22:00:12 +0100
Message-Id: <20191027203251.029297948@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.81-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.81-rc1
X-KernelTest-Deadline: 2019-10-29T20:33+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.19.81 release.
There are 93 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Tue 29 Oct 2019 08:27:02 PM UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.81-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.19.81-rc1

Greg KH <gregkh@linuxfoundation.org>
    RDMA/cxgb4: Do not dma memory off of the stack

Tejun Heo <tj@kernel.org>
    blk-rq-qos: fix first node deletion of rq_qos_del()

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    PCI: PM: Fix pci_power_up()

Juergen Gross <jgross@suse.com>
    xen/netback: fix error path of xenvif_connect_data()

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    cpufreq: Avoid cpufreq_suspend() deadlock on system shutdown

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    memstick: jmb38x_ms: Fix an error handling path in 'jmb38x_ms_probe()'

Qu Wenruo <wqu@suse.com>
    btrfs: tracepoints: Fix bad entry members of qgroup events

Filipe Manana <fdmanana@suse.com>
    Btrfs: check for the full sync flag while holding the inode lock during fsync

Filipe Manana <fdmanana@suse.com>
    Btrfs: add missing extents release on file extent cluster relocation error

Qu Wenruo <wqu@suse.com>
    btrfs: block-group: Fix a memory leak due to missing btrfs_put_block_group()

Patrick Williams <alpawi@amazon.com>
    pinctrl: armada-37xx: swap polarity on LED group

Patrick Williams <alpawi@amazon.com>
    pinctrl: armada-37xx: fix control of pins 32 and up

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    pinctrl: cherryview: restore Strago DMI workaround for all versions

Sean Christopherson <sean.j.christopherson@intel.com>
    x86/apic/x2apic: Fix a NULL pointer deref when handling a dying cpu

Steve Wahl <steve.wahl@hpe.com>
    x86/boot/64: Make level2_kernel_pgt pages invalid outside kernel area

Mikulas Patocka <mpatocka@redhat.com>
    dm cache: fix bugs when a GFP_NOWAIT allocation fails

Prateek Sood <prsood@codeaurora.org>
    tracing: Fix race in perf_trace_buf initialization

Alexander Shishkin <alexander.shishkin@linux.intel.com>
    perf/aux: Fix AUX output stopping

Pavel Shilovsky <pshilov@microsoft.com>
    CIFS: Fix use after free of file info structures

Roberto Bergantinos Corpas <rbergant@redhat.com>
    CIFS: avoid using MID 0xFFFF

Marc Zyngier <marc.zyngier@arm.com>
    arm64: Enable workaround for Cavium TX2 erratum 219 when running SMT

James Morse <james.morse@arm.com>
    EDAC/ghes: Fix Use after free in ghes_edac remove path

Helge Deller <deller@gmx.de>
    parisc: Fix vmap memory leak in ioremap()/iounmap()

Max Filippov <jcmvbkbc@gmail.com>
    xtensa: drop EXPORT_SYMBOL for outs*/ins*

Jane Chu <jane.chu@oracle.com>
    mm/memory-failure: poison read receives SIGKILL instead of SIGBUS if mmaped more than once

David Hildenbrand <david@redhat.com>
    hugetlbfs: don't access uninitialized memmaps in pfn_range_valid_gigantic()

Qian Cai <cai@lca.pw>
    mm/page_owner: don't access uninitialized memmaps when reading /proc/pagetypeinfo

Qian Cai <cai@lca.pw>
    mm/slub: fix a deadlock in show_slab_objects()

David Hildenbrand <david@redhat.com>
    mm/memory-failure.c: don't access uninitialized memmaps in memory_failure()

Faiz Abbas <faiz_abbas@ti.com>
    mmc: cqhci: Commit descriptors before setting the doorbell

David Hildenbrand <david@redhat.com>
    fs/proc/page.c: don't access uninitialized memmaps in fs/proc/page.c

David Hildenbrand <david@redhat.com>
    drivers/base/memory.c: don't access uninitialized memmaps in soft_offline_page_store()

Hans de Goede <hdegoede@redhat.com>
    drm/amdgpu: Bail earlier when amdgpu.cik_/si_support is not set to 1

Thomas Hellstrom <thellstrom@vmware.com>
    drm/ttm: Restore ttm prefaulting

Kai-Heng Feng <kai.heng.feng@canonical.com>
    drm/edid: Add 6 bpc quirk for SDC panel in Lenovo G50

Will Deacon <will@kernel.org>
    mac80211: Reject malformed SSID elements

Will Deacon <will@kernel.org>
    cfg80211: wext: avoid copying malformed SSIDs

John Garry <john.garry@huawei.com>
    ACPI: CPPC: Set pcc_data[pcc_ss_id] to NULL in acpi_cppc_processor_exit()

Junya Monden <jmonden@jp.adit-jv.com>
    ASoC: rsnd: Reinitialize bit clock inversion flag for every format setting

Evan Green <evgreen@chromium.org>
    Input: synaptics-rmi4 - avoid processing unknown IRQs

Marco Felsch <m.felsch@pengutronix.de>
    Input: da9063 - fix capability and drop KEY_SLEEP

Bart Van Assche <bvanassche@acm.org>
    scsi: ch: Make it possible to open a ch device multiple times again

Yufen Yu <yuyufen@huawei.com>
    scsi: core: try to get module before removing device

Damien Le Moal <damien.lemoal@wdc.com>
    scsi: core: save/restore command resid for error handling

Oliver Neukum <oneukum@suse.com>
    scsi: sd: Ignore a failure to sync cache due to lack of authorization

Steffen Maier <maier@linux.ibm.com>
    scsi: zfcp: fix reaction on bit error threshold notification

Colin Ian King <colin.king@canonical.com>
    staging: wlan-ng: fix exit return when sme->key_idx >= NUM_WEPKEYS

Paul Burton <paulburton@kernel.org>
    MIPS: tlbex: Fix build_restore_pagemask KScratch restore

Johan Hovold <johan@kernel.org>
    USB: ldusb: fix read info leaks

Johan Hovold <johan@kernel.org>
    USB: usblp: fix use-after-free on disconnect

Johan Hovold <johan@kernel.org>
    USB: ldusb: fix memleak on disconnect

Johan Hovold <johan@kernel.org>
    USB: serial: ti_usb_3410_5052: fix port-close races

Gustavo A. R. Silva <gustavo@embeddedor.com>
    usb: udc: lpc32xx: fix bad bit shift operation

Lukas Wunner <lukas@wunner.de>
    ALSA: hda - Force runtime PM on Nvidia HDMI codecs

Szabolcs Szőke <szszoke.code@gmail.com>
    ALSA: usb-audio: Disable quirks for BOSS Katana amplifiers

Daniel Drake <drake@endlessm.com>
    ALSA: hda/realtek - Enable headset mic on Asus MJ401TA

Kailang Yang <kailang@realtek.com>
    ALSA: hda/realtek - Add support for ALC711

Johan Hovold <johan@kernel.org>
    USB: legousbtower: fix memleak on disconnect

Matthew Wilcox (Oracle) <willy@infradead.org>
    memfd: Fix locking when tagging pins

Xin Long <lucien.xin@gmail.com>
    sctp: change sctp_prot .no_autobind with true

Biao Huang <biao.huang@mediatek.com>
    net: stmmac: disable/enable ptp_ref_clk in suspend/resume flow

Xin Long <lucien.xin@gmail.com>
    net: ipv6: fix listify ip6_rcv_finish in case of forwarding

Cédric Le Goater <clg@kaod.org>
    net/ibmvnic: Fix EOI when running in XIVE mode.

Thomas Bogendoerfer <tbogendoerfer@suse.de>
    net: i82596: fix dma_alloc_attr for sni_82596

Florian Fainelli <f.fainelli@gmail.com>
    net: bcmgenet: Set phydev->dev_flags only for internal PHYs

Florian Fainelli <f.fainelli@gmail.com>
    net: bcmgenet: Fix RGMII_MODE_EN value for GENET v1/2/3

Eric Dumazet <edumazet@google.com>
    net: avoid potential infinite loop in tc_ctl_action()

Stefano Brivio <sbrivio@redhat.com>
    ipv4: Return -ENETUNREACH if we can't create route but saddr is valid

Wei Wang <weiwan@google.com>
    ipv4: fix race condition between route lookup and invalidation

Yi Li <yilikernel@gmail.com>
    ocfs2: fix panic due to ocfs2_wq is null

Alex Deucher <alexander.deucher@amd.com>
    Revert "drm/radeon: Fix EEH during kexec"

Song Liu <songliubraving@fb.com>
    md/raid0: fix warning message for parameter default_layout

Dan Williams <dan.j.williams@intel.com>
    libata/ahci: Fix PCS quirk application

Jacob Keller <jacob.e.keller@intel.com>
    namespace: fix namespace.pl script to support relative paths

Kai-Heng Feng <kai.heng.feng@canonical.com>
    r8152: Set macpassthru in reset_resume callback

Randy Dunlap <rdunlap@infradead.org>
    lib: textsearch: fix escapes in example code

Yizhuo <yzhai003@ucr.edu>
    net: hisilicon: Fix usage of uninitialized variable in function mdio_sc_cfg_reg_write()

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    mips: Loongson: Fix the link time qualifier of 'serial_exit()'

Wen Yang <wenyang@linux.alibaba.com>
    net: dsa: rtl8366rb: add missing of_node_put after calling of_get_child_by_name

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nft_connlimit: disable bh on garbage collection

Miaoqing Pan <miaoqing@codeaurora.org>
    mac80211: fix txq null pointer dereference

Miaoqing Pan <miaoqing@codeaurora.org>
    nl80211: fix null pointer dereference

Ross Lagerwall <ross.lagerwall@citrix.com>
    xen/efi: Set nonblocking callbacks

Oleksij Rempel <o.rempel@pengutronix.de>
    MIPS: dts: ar9331: fix interrupt-controller size

Michal Vokáč <michal.vokac@ysoft.com>
    net: dsa: qca8k: Use up to 7 ports for all operations

Peter Ujfalusi <peter.ujfalusi@ti.com>
    ARM: dts: am4372: Set memory bandwidth limit for DISPC

Navid Emamdoost <navid.emamdoost@gmail.com>
    ieee802154: ca8210: prevent memory leak

Tony Lindgren <tony@atomide.com>
    ARM: OMAP2+: Fix warnings with broken omap2_set_init_voltage()

Tony Lindgren <tony@atomide.com>
    ARM: OMAP2+: Fix missing reset done flag for am3 and am43

Quinn Tran <qutran@marvell.com>
    scsi: qla2xxx: Fix unbound sleep in fcport delete path.

Xiang Chen <chenxiang66@hisilicon.com>
    scsi: megaraid: disable device when probe failed after enabled device

Stanley Chu <stanley.chu@mediatek.com>
    scsi: ufs: skip shutdown if hba is not powered

Balbir Singh <sblbir@amzn.com>
    nvme-pci: Fix a race in controller removal


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/arm/boot/dts/am4372.dtsi                      |   2 +
 .../mach-omap2/omap_hwmod_33xx_43xx_ipblock_data.c |   3 +-
 arch/arm/mach-omap2/pm.c                           | 100 ---------------------
 arch/arm/xen/efi.c                                 |   2 +
 arch/arm64/kernel/cpu_errata.c                     |  33 +++++++
 arch/mips/boot/dts/qca/ar9331.dtsi                 |   2 +-
 arch/mips/loongson64/common/serial.c               |   2 +-
 arch/mips/mm/tlbex.c                               |  23 +++--
 arch/parisc/mm/ioremap.c                           |  12 +--
 arch/x86/kernel/apic/x2apic_cluster.c              |   3 +-
 arch/x86/kernel/head64.c                           |  22 ++++-
 arch/x86/xen/efi.c                                 |   2 +
 arch/xtensa/kernel/xtensa_ksyms.c                  |   7 --
 block/blk-rq-qos.h                                 |  13 ++-
 drivers/acpi/cppc_acpi.c                           |   2 +-
 drivers/ata/ahci.c                                 |   4 +-
 drivers/base/core.c                                |   3 +
 drivers/base/memory.c                              |   3 +
 drivers/cpufreq/cpufreq.c                          |  10 ---
 drivers/edac/ghes_edac.c                           |   4 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c            |  35 ++++++++
 drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c            |  35 --------
 drivers/gpu/drm/drm_edid.c                         |   3 +
 drivers/gpu/drm/radeon/radeon_drv.c                |   8 --
 drivers/gpu/drm/ttm/ttm_bo_vm.c                    |  16 ++--
 drivers/infiniband/hw/cxgb4/mem.c                  |  28 +++---
 drivers/input/misc/da9063_onkey.c                  |   5 +-
 drivers/input/rmi4/rmi_driver.c                    |   6 +-
 drivers/md/dm-cache-target.c                       |  28 +-----
 drivers/md/raid0.c                                 |   2 +-
 drivers/memstick/host/jmb38x_ms.c                  |   2 +-
 drivers/mmc/host/cqhci.c                           |   3 +-
 drivers/net/dsa/qca8k.c                            |   4 +-
 drivers/net/dsa/rtl8366rb.c                        |  16 ++--
 drivers/net/ethernet/broadcom/genet/bcmgenet.h     |   1 +
 drivers/net/ethernet/broadcom/genet/bcmmii.c       |  11 ++-
 drivers/net/ethernet/hisilicon/hns_mdio.c          |   6 +-
 drivers/net/ethernet/i825xx/lasi_82596.c           |   4 +-
 drivers/net/ethernet/i825xx/lib82596.c             |   4 +-
 drivers/net/ethernet/i825xx/sni_82596.c            |   4 +-
 drivers/net/ethernet/ibm/ibmvnic.c                 |   8 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |  12 ++-
 drivers/net/ieee802154/ca8210.c                    |   2 +-
 drivers/net/usb/r8152.c                            |   3 +-
 drivers/net/xen-netback/interface.c                |   1 -
 drivers/nvme/host/core.c                           |   5 +-
 drivers/pci/pci.c                                  |  24 +++--
 drivers/pinctrl/intel/pinctrl-cherryview.c         |   4 -
 drivers/pinctrl/mvebu/pinctrl-armada-37xx.c        |  26 +++---
 drivers/s390/scsi/zfcp_fsf.c                       |  16 +++-
 drivers/scsi/ch.c                                  |   1 -
 drivers/scsi/megaraid.c                            |   4 +-
 drivers/scsi/qla2xxx/qla_target.c                  |   4 +
 drivers/scsi/scsi_error.c                          |   3 +
 drivers/scsi/scsi_sysfs.c                          |  11 ++-
 drivers/scsi/sd.c                                  |   3 +-
 drivers/scsi/ufs/ufshcd.c                          |   3 +
 drivers/staging/wlan-ng/cfg80211.c                 |   6 +-
 drivers/usb/class/usblp.c                          |   4 +-
 drivers/usb/gadget/udc/lpc32xx_udc.c               |   6 +-
 drivers/usb/misc/ldusb.c                           |  23 ++---
 drivers/usb/misc/legousbtower.c                    |   5 +-
 drivers/usb/serial/ti_usb_3410_5052.c              |  10 +--
 fs/btrfs/extent-tree.c                             |   1 +
 fs/btrfs/file.c                                    |  36 ++++----
 fs/btrfs/relocation.c                              |   2 +
 fs/cifs/file.c                                     |   6 +-
 fs/cifs/smb1ops.c                                  |   3 +
 fs/ocfs2/journal.c                                 |   3 +-
 fs/ocfs2/localalloc.c                              |   3 +-
 fs/proc/page.c                                     |  28 +++---
 include/scsi/scsi_eh.h                             |   1 +
 include/trace/events/btrfs.h                       |   3 +-
 kernel/events/core.c                               |   2 +-
 kernel/trace/trace_event_perf.c                    |   4 +
 lib/textsearch.c                                   |   4 +-
 mm/hugetlb.c                                       |   5 +-
 mm/memfd.c                                         |  18 ++--
 mm/memory-failure.c                                |  36 ++++----
 mm/page_owner.c                                    |   5 +-
 mm/slub.c                                          |  13 ++-
 net/ipv4/route.c                                   |  11 ++-
 net/ipv6/ip6_input.c                               |   4 +-
 net/mac80211/debugfs_netdev.c                      |  11 ++-
 net/mac80211/mlme.c                                |   5 +-
 net/netfilter/nft_connlimit.c                      |   7 +-
 net/sched/act_api.c                                |  14 +--
 net/sctp/socket.c                                  |   4 +-
 net/wireless/nl80211.c                             |   3 +
 net/wireless/wext-sme.c                            |   8 +-
 scripts/namespace.pl                               |  13 +--
 sound/pci/hda/patch_hdmi.c                         |   2 +
 sound/pci/hda/patch_realtek.c                      |  14 +++
 sound/soc/sh/rcar/core.c                           |   1 +
 sound/usb/pcm.c                                    |   3 +
 96 files changed, 495 insertions(+), 439 deletions(-)


