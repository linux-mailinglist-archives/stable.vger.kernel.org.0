Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA5CAE6736
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:19:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731382AbfJ0VTB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:19:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:39284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731370AbfJ0VTA (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:19:00 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4B0D0205C9;
        Sun, 27 Oct 2019 21:18:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572211138;
        bh=WC3Ur81H2kE+D3VBjJsadlTO24T7lO7q601i/E5u++8=;
        h=From:To:Cc:Subject:Date:From;
        b=ZDRmDU8uXsv6yqV2t83qNd0DWOnm9PvrXaT1HsILjIfe84tJ+6qftzf2KouwMRLbh
         6vjgBjaqkOlPfMzLHVZO1Kf92WR7do4SbbiUL7ZDd10vhxTVMFb6+oHV0vecjqhAJp
         j7md9mFnaQUdB9IUQxEEO95qZP/lHphlKt7B+j00=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 5.3 000/197] 5.3.8-stable review
Date:   Sun, 27 Oct 2019 21:58:38 +0100
Message-Id: <20191027203351.684916567@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-5.3.8-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.3.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.3.8-rc1
X-KernelTest-Deadline: 2019-10-29T20:34+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.3.8 release.
There are 197 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Tue 29 Oct 2019 08:27:02 PM UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.3.8-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.3.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.3.8-rc1

Greg KH <gregkh@linuxfoundation.org>
    RDMA/cxgb4: Do not dma memory off of the stack

Tejun Heo <tj@kernel.org>
    blk-rq-qos: fix first node deletion of rq_qos_del()

Chris Goldsworthy <cgoldswo@codeaurora.org>
    of: reserved_mem: add missing of_node_put() for proper ref-counting

Viresh Kumar <viresh.kumar@linaro.org>
    opp: of: drop incorrect lockdep_assert_held()

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    PCI: PM: Fix pci_power_up()

Juergen Gross <jgross@suse.com>
    xen/netback: fix error path of xenvif_connect_data()

Jeff Layton <jlayton@kernel.org>
    ceph: just skip unrecognized info in ceph_reply_info_extra

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    cpufreq: Avoid cpufreq_suspend() deadlock on system shutdown

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    memstick: jmb38x_ms: Fix an error handling path in 'jmb38x_ms_probe()'

Greg Kurz <groug@kaod.org>
    KVM: PPC: Book3S HV: XIVE: Ensure VP isn't already in use

Qu Wenruo <wqu@suse.com>
    btrfs: tracepoints: Fix bad entry members of qgroup events

Qu Wenruo <wqu@suse.com>
    btrfs: tracepoints: Fix wrong parameter order for qgroup events

Filipe Manana <fdmanana@suse.com>
    Btrfs: check for the full sync flag while holding the inode lock during fsync

Filipe Manana <fdmanana@suse.com>
    Btrfs: fix qgroup double free after failure to reserve metadata for delalloc

David Sterba <dsterba@suse.com>
    btrfs: don't needlessly create extent-refs kernel thread

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

Roman Kagan <rkagan@virtuozzo.com>
    x86/hyperv: Make vapic support x2apic mode

Sean Christopherson <sean.j.christopherson@intel.com>
    x86/apic/x2apic: Fix a NULL pointer deref when handling a dying cpu

Steve Wahl <steve.wahl@hpe.com>
    x86/boot/64: Make level2_kernel_pgt pages invalid outside kernel area

Marc Zyngier <maz@kernel.org>
    irqchip/sifive-plic: Switch to fasteoi flow

Mikulas Patocka <mpatocka@redhat.com>
    dm cache: fix bugs when a GFP_NOWAIT allocation fails

Dan Williams <dan.j.williams@intel.com>
    fs/dax: Fix pmd vs pte conflict detection

Prateek Sood <prsood@codeaurora.org>
    tracing: Fix race in perf_trace_buf initialization

Alexander Shishkin <alexander.shishkin@linux.intel.com>
    perf/aux: Fix AUX output stopping

Pavel Shilovsky <pshilov@microsoft.com>
    CIFS: Fix use after free of file info structures

Chuhong Yuan <hslester96@gmail.com>
    cifs: Fix missed free operations

Roberto Bergantinos Corpas <rbergant@redhat.com>
    CIFS: avoid using MID 0xFFFF

Marc Zyngier <maz@kernel.org>
    arm64: Allow CAVIUM_TX2_ERRATUM_219 to be selected

Marc Zyngier <maz@kernel.org>
    arm64: Enable workaround for Cavium TX2 erratum 219 when running SMT

Marc Zyngier <maz@kernel.org>
    arm64: Avoid Cavium TX2 erratum 219 when switching TTBR

Marc Zyngier <maz@kernel.org>
    arm64: KVM: Trap VM ops when ARM64_WORKAROUND_CAVIUM_TX2_219_TVM is set

James Morse <james.morse@arm.com>
    EDAC/ghes: Fix Use after free in ghes_edac remove path

Helge Deller <deller@gmx.de>
    parisc: Fix vmap memory leak in ioremap()/iounmap()

Thomas Gleixner <tglx@linutronix.de>
    lib/vdso: Make clock_getres() POSIX compliant again

Gerald Schaefer <gerald.schaefer@de.ibm.com>
    s390/kaslr: add support for R_390_GLOB_DAT relocation type

Johan Hovold <johan@kernel.org>
    s390/zcrypt: fix memleak at release

Max Filippov <jcmvbkbc@gmail.com>
    xtensa: fix change_bit in exclusive access option

Max Filippov <jcmvbkbc@gmail.com>
    xtensa: drop EXPORT_SYMBOL for outs*/ins*

Chenwandun <chenwandun@huawei.com>
    zram: fix race between backing_dev_show and backing_dev_store

Jane Chu <jane.chu@oracle.com>
    mm/memory-failure: poison read receives SIGKILL instead of SIGBUS if mmaped more than once

David Hildenbrand <david@redhat.com>
    hugetlbfs: don't access uninitialized memmaps in pfn_range_valid_gigantic()

Mike Rapoport <rppt@linux.ibm.com>
    mm: memblock: do not enforce current limit for memblock_phys* family

Honglei Wang <honglei.wang@oracle.com>
    mm: memcg: get number of pages on the LRU list in memcgroup base on lru_zone_size

Vlastimil Babka <vbabka@suse.cz>
    mm, compaction: fix wrong pfn handling in __reset_isolation_pfn()

Roman Gushchin <guro@fb.com>
    mm: memcg/slab: fix panic in __free_slab() caused by premature memcg pointer release

Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
    mm/memunmap: don't access uninitialized memmap in memunmap_pages()

David Hildenbrand <david@redhat.com>
    mm/memory_hotplug: don't access uninitialized memmaps in shrink_pgdat_span()

Qian Cai <cai@lca.pw>
    mm/page_owner: don't access uninitialized memmaps when reading /proc/pagetypeinfo

Qian Cai <cai@lca.pw>
    mm/slub: fix a deadlock in show_slab_objects()

David Hildenbrand <david@redhat.com>
    mm/memory-failure.c: don't access uninitialized memmaps in memory_failure()

Faiz Abbas <faiz_abbas@ti.com>
    mmc: sdhci-omap: Fix Tuning procedure for temperatures < -20C

Faiz Abbas <faiz_abbas@ti.com>
    mmc: cqhci: Commit descriptors before setting the doorbell

Sascha Hauer <s.hauer@pengutronix.de>
    mmc: mxs: fix flags passed to dmaengine_prep_slave_sg

Jens Axboe <axboe@kernel.dk>
    io_uring: used cached copies of sq->dropped and cq->overflow

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: Fix race for sqes with userspace

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: Fix broken links with offloading

David Hildenbrand <david@redhat.com>
    fs/proc/page.c: don't access uninitialized memmaps in fs/proc/page.c

David Hildenbrand <david@redhat.com>
    drivers/base/memory.c: don't access uninitialized memmaps in soft_offline_page_store()

Philip Yang <Philip.Yang@amd.com>
    drm/amdgpu: user pages array memory leak fix

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/uvd7: fix allocation size in enc ring test (v2)

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/uvd6: fix allocation size in enc ring test (v2)

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/vcn: fix allocation size in enc ring test

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/vce: fix allocation size in enc ring test

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/i915: Favor last VBT child device with conflicting AUX ch/DDC pin

Chris Wilson <chris@chris-wilson.co.uk>
    drm/i915/userptr: Never allow userptr into the mappable GGTT

Xiaojie Yuan <xiaojie.yuan@amd.com>
    drm/amdgpu/sdma5: fix mask value of POLL_REGMEM packet for pipe sync

Hans de Goede <hdegoede@redhat.com>
    drm/amdgpu: Bail earlier when amdgpu.cik_/si_support is not set to 1

Steven Price <steven.price@arm.com>
    drm/panfrost: Handle resetting on timeout better

Thomas Hellstrom <thellstrom@vmware.com>
    drm/ttm: Restore ttm prefaulting

Kai-Heng Feng <kai.heng.feng@canonical.com>
    drm/edid: Add 6 bpc quirk for SDC panel in Lenovo G50

Will Deacon <will@kernel.org>
    mac80211: Reject malformed SSID elements

Will Deacon <will@kernel.org>
    cfg80211: wext: avoid copying malformed SSIDs

Luca Coelho <luciano.coelho@intel.com>
    iwlwifi: pcie: change qu with jf devices to use qu configuration

Dan Carpenter <dan.carpenter@oracle.com>
    ACPI: NFIT: Fix unlock on error in scrub_show()

John Garry <john.garry@huawei.com>
    ACPI: CPPC: Set pcc_data[pcc_ss_id] to NULL in acpi_cppc_processor_exit()

Junya Monden <jmonden@jp.adit-jv.com>
    ASoC: rsnd: Reinitialize bit clock inversion flag for every format setting

Dixit Parmar <dixitparmar19@gmail.com>
    Input: st1232 - fix reporting multitouch coordinates

Evan Green <evgreen@chromium.org>
    Input: synaptics-rmi4 - avoid processing unknown IRQs

Marco Felsch <m.felsch@pengutronix.de>
    Input: da9063 - fix capability and drop KEY_SLEEP

Kai-Heng Feng <kai.heng.feng@canonical.com>
    Revert "Input: elantech - enable SMBus on new (2018+) systems"

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

Jann Horn <jannh@google.com>
    binder: Don't modify VMA bounds in ->mmap handler

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

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: Fix corrupted user_data

Jens Axboe <axboe@kernel.dk>
    io_uring: fix bad inflight accounting for SETUP_IOPOLL|SETUP_SQTHREAD

Eric Dumazet <edumazet@google.com>
    rxrpc: use rcu protection while reading sk->sk_user_data

Micah Morton <mortonm@chromium.org>
    LSM: SafeSetID: Stop releasing uninitialized ruleset

Yonglong Liu <liuyonglong@huawei.com>
    net: phy: Fix "link partner" information disappear issue

Randy Dunlap <rdunlap@infradead.org>
    net: ethernet: broadcom: have drivers select DIMLIB as needed

YueHaibing <yuehaibing@huawei.com>
    netdevsim: Fix error handling in nsim_fib_init and nsim_fib_exit

Davide Caratti <dcaratti@redhat.com>
    net/sched: fix corrupted L2 header with MPLS 'push' and 'pop' actions

Davide Caratti <dcaratti@redhat.com>
    net: avoid errors when trying to pop MLPS header on non-MPLS packets

Marek Vasut <marex@denx.de>
    net: phy: micrel: Update KSZ87xx PHY name

Marek Vasut <marex@denx.de>
    net: phy: micrel: Discern KSZ8051 and KSZ8795 PHYs

Dmitry Bogdanov <dmitry.bogdanov@aquantia.com>
    net: aquantia: correctly handle macvlan and multicast coexistence

Dmitry Bogdanov <dmitry.bogdanov@aquantia.com>
    net: aquantia: do not pass lro session with invalid tcp checksum

Igor Russkikh <Igor.Russkikh@aquantia.com>
    net: aquantia: when cleaning hw cache it should be toggled

Igor Russkikh <Igor.Russkikh@aquantia.com>
    net: aquantia: temperature retrieval fix

Xin Long <lucien.xin@gmail.com>
    sctp: change sctp_prot .no_autobind with true

Vinicius Costa Gomes <vinicius.gomes@intel.com>
    sched: etf: Fix ordering of packets with same txtime

David Howells <dhowells@redhat.com>
    rxrpc: Fix possible NULL pointer access in ICMP handling

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

Kevin Hao <haokexin@gmail.com>
    nvme-pci: Set the prp2 correctly when using more than 4k page

Yi Li <yilikernel@gmail.com>
    ocfs2: fix panic due to ocfs2_wq is null

Alex Deucher <alexander.deucher@amd.com>
    Revert "drm/radeon: Fix EEH during kexec"

Song Liu <songliubraving@fb.com>
    md/raid0: fix warning message for parameter default_layout

Dan Williams <dan.j.williams@intel.com>
    libata/ahci: Fix PCS quirk application

Cong Wang <xiyou.wangcong@gmail.com>
    net_sched: fix backward compatibility for TCA_ACT_KIND

Cong Wang <xiyou.wangcong@gmail.com>
    net_sched: fix backward compatibility for TCA_KIND

Linus Torvalds <torvalds@linux-foundation.org>
    filldir[64]: remove WARN_ON_ONCE() for bad directory entries

Linus Torvalds <torvalds@linux-foundation.org>
    uaccess: implement a proper unsafe_copy_to_user() and switch filldir over to it

Linus Torvalds <torvalds@linux-foundation.org>
    Make filldir[64]() verify the directory entry filename is valid

Linus Torvalds <torvalds@linux-foundation.org>
    elf: don't use MAP_FIXED_NOREPLACE for elf executable mappings

Linus Torvalds <torvalds@linux-foundation.org>
    Convert filldir[64]() from __put_user() to unsafe_put_user()

Jacob Keller <jacob.e.keller@intel.com>
    namespace: fix namespace.pl script to support relative paths

Russell King <rmk+kernel@armlinux.org.uk>
    net: phy: fix write to mii-ctrl1000 register

Andrea Merello <andrea.merello@gmail.com>
    net: phy: allow for reset line to be tied to a sleepy GPIO controller

Kai-Heng Feng <kai.heng.feng@canonical.com>
    r8152: Set macpassthru in reset_resume callback

Qian Cai <cai@lca.pw>
    s390/mm: fix -Wunused-but-set-variable warnings

Randy Dunlap <rdunlap@infradead.org>
    lib: textsearch: fix escapes in example code

Shuah Khan <skhan@linuxfoundation.org>
    selftests: kvm: Fix libkvm build error

Thierry Reding <treding@nvidia.com>
    net: stmmac: Avoid deadlock on suspend/resume

Yizhuo <yzhai003@ucr.edu>
    net: hisilicon: Fix usage of uninitialized variable in function mdio_sc_cfg_reg_write()

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    mips: Loongson: Fix the link time qualifier of 'serial_exit()'

Navid Emamdoost <navid.emamdoost@gmail.com>
    drm/amd/display: memory leak

Navid Emamdoost <navid.emamdoost@gmail.com>
    drm/amdgpu: fix multiple memory leaks in acp_hw_init

Albert Ou <aou@eecs.berkeley.edu>
    riscv: Fix memblock reservation for device tree blob

Palmer Dabbelt <palmer@sifive.com>
    RISC-V: Clear load reservations while restoring hart contexts

Oleksij Rempel <linux@rempel-privat.de>
    net: ag71xx: fix mdio subnode support

Jose Abreu <Jose.Abreu@synopsys.com>
    net: stmmac: Do not stop PHY if WoL is enabled

Jose Abreu <Jose.Abreu@synopsys.com>
    net: stmmac: Correctly take timestamp for PTPv2

Jose Abreu <Jose.Abreu@synopsys.com>
    net: stmmac: dwmac4: Always update the MAC Hash Filter

Jose Abreu <Jose.Abreu@synopsys.com>
    net: stmmac: xgmac: Not all Unicast addresses may be available

Wen Yang <wenyang@linux.alibaba.com>
    net: dsa: rtl8366rb: add missing of_node_put after calling of_get_child_by_name

Wen Yang <wenyang@linux.alibaba.com>
    net: mscc: ocelot: add missing of_node_put after calling of_get_child_by_name

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nft_connlimit: disable bh on garbage collection

Miaoqing Pan <miaoqing@codeaurora.org>
    mac80211: fix txq null pointer dereference

Miaoqing Pan <miaoqing@codeaurora.org>
    nl80211: fix null pointer dereference

Martijn Coenen <maco@android.com>
    loop: change queue block size to match when using DIO

Ross Lagerwall <ross.lagerwall@citrix.com>
    xen/efi: Set nonblocking callbacks

Oleksij Rempel <linux@rempel-privat.de>
    MIPS: dts: ar9331: fix interrupt-controller size

Michal Vokáč <michal.vokac@ysoft.com>
    net: dsa: qca8k: Use up to 7 ports for all operations

Peter Ujfalusi <peter.ujfalusi@ti.com>
    ARM: dts: am4372: Set memory bandwidth limit for DISPC

Navid Emamdoost <navid.emamdoost@gmail.com>
    ieee802154: ca8210: prevent memory leak

Ming Lei <ming.lei@redhat.com>
    blk-mq: honor IO scheduler for multiqueue devices

Sagi Grimberg <sagi@grimberg.me>
    nvme-rdma: fix possible use-after-free in connect timeout

Navid Emamdoost <navid.emamdoost@gmail.com>
    drm/komeda: prevent memory leak in komeda_wb_connector_add

Marta Rybczynska <mrybczyn@kalray.eu>
    nvme: allow 64-bit results in passthru commands

Jian-Hong Pan <jian-hong@endlessm.com>
    nvme: Add quirk for Kingston NVME SSD running FW E8FK11.T

Gabriel Craciunescu <nix.or.die@gmail.com>
    Added QUIRKs for ADATA XPG SX8200 Pro 512GB

Max Gurtovoy <maxg@mellanox.com>
    nvme-rdma: Fix max_hw_sectors calculation

Dan Carpenter <dan.carpenter@oracle.com>
    nvme: fix an error code in nvme_init_subsystem()

Mario Limonciello <mario.limonciello@dell.com>
    nvme-pci: Save PCI state before putting drive into deepest state

Wunderlich, Mark <mark.wunderlich@intel.com>
    nvme-tcp: fix wrong stop condition in io_work

Tony Lindgren <tony@atomide.com>
    ARM: OMAP2+: Fix warnings with broken omap2_set_init_voltage()

Tony Lindgren <tony@atomide.com>
    ARM: OMAP2+: Add missing LCDC midlemode for am335x

Tony Lindgren <tony@atomide.com>
    ARM: OMAP2+: Fix missing reset done flag for am3 and am43

Tony Lindgren <tony@atomide.com>
    ARM: dts: Fix gpio0 flags for am335x-icev2

Quinn Tran <qutran@marvell.com>
    scsi: qla2xxx: Fix N2N link up fail

Quinn Tran <qutran@marvell.com>
    scsi: qla2xxx: Fix N2N link reset

Quinn Tran <qutran@marvell.com>
    scsi: qla2xxx: Fix stale mem access on driver unload

Quinn Tran <qutran@marvell.com>
    scsi: qla2xxx: Fix unbound sleep in fcport delete path.

Himanshu Madhani <hmadhani@marvell.com>
    scsi: qla2xxx: Silence fwdump template message

Xiang Chen <chenxiang66@hisilicon.com>
    scsi: megaraid: disable device when probe failed after enabled device

Stanley Chu <stanley.chu@mediatek.com>
    scsi: ufs: skip shutdown if hba is not powered

Balbir Singh <sblbir@amzn.com>
    nvme-pci: Fix a race in controller removal

Tony Lindgren <tony@atomide.com>
    ARM: dts: Fix wrong clocks for dra7 mcasp

Tony Lindgren <tony@atomide.com>
    clk: ti: dra7: Fix mcasp8 clock bits

Lowry Li (Arm Technology China) <Lowry.Li@arm.com>
    drm: Clear the fence pointer when writeback job signaled

Lowry Li (Arm Technology China) <Lowry.Li@arm.com>
    drm: Free the writeback_job when it with an empty fb


-------------

Diffstat:

 Documentation/arm64/silicon-errata.rst             |   2 +
 Makefile                                           |   4 +-
 arch/arm/boot/dts/am335x-icev2.dts                 |   2 +-
 arch/arm/boot/dts/am33xx-l4.dtsi                   |   6 +-
 arch/arm/boot/dts/am4372.dtsi                      |   2 +
 arch/arm/boot/dts/dra7-l4.dtsi                     |  48 ++--
 .../mach-omap2/omap_hwmod_33xx_43xx_ipblock_data.c |   3 +-
 arch/arm/mach-omap2/omap_hwmod_33xx_data.c         |   5 +-
 arch/arm/mach-omap2/pm.c                           | 100 --------
 arch/arm/xen/efi.c                                 |   2 +
 arch/arm64/Kconfig                                 |  17 ++
 arch/arm64/include/asm/cpucaps.h                   |   4 +-
 arch/arm64/kernel/cpu_errata.c                     |  38 +++
 arch/arm64/kernel/entry.S                          |   2 +
 arch/arm64/kvm/hyp/switch.c                        |  69 +++++-
 arch/mips/boot/dts/qca/ar9331.dtsi                 |   2 +-
 arch/mips/loongson64/common/serial.c               |   2 +-
 arch/mips/mm/tlbex.c                               |  23 +-
 arch/parisc/mm/ioremap.c                           |  12 +-
 arch/powerpc/kvm/book3s_xive.c                     |  24 +-
 arch/powerpc/kvm/book3s_xive.h                     |  12 +
 arch/powerpc/kvm/book3s_xive_native.c              |   6 +-
 arch/riscv/include/asm/asm.h                       |   1 +
 arch/riscv/kernel/entry.S                          |  21 +-
 arch/riscv/mm/init.c                               |  12 +-
 arch/s390/boot/startup.c                           |  14 +-
 arch/s390/include/asm/hugetlb.h                    |   9 +-
 arch/s390/include/asm/pgtable.h                    |   3 +-
 arch/s390/kernel/machine_kexec_reloc.c             |   1 +
 arch/x86/hyperv/hv_apic.c                          |  20 +-
 arch/x86/include/asm/uaccess.h                     |  23 ++
 arch/x86/kernel/apic/x2apic_cluster.c              |   3 +-
 arch/x86/kernel/head64.c                           |  22 +-
 arch/x86/xen/efi.c                                 |   2 +
 arch/xtensa/include/asm/bitops.h                   |   2 +-
 arch/xtensa/kernel/xtensa_ksyms.c                  |   7 -
 block/blk-mq.c                                     |   6 +-
 block/blk-rq-qos.h                                 |  13 +-
 drivers/acpi/cppc_acpi.c                           |   2 +-
 drivers/acpi/nfit/core.c                           |   2 +-
 drivers/android/binder.c                           |   7 -
 drivers/android/binder_alloc.c                     |   6 +-
 drivers/ata/ahci.c                                 |   4 +-
 drivers/base/core.c                                |   3 +
 drivers/base/memory.c                              |   3 +
 drivers/block/loop.c                               |  10 +
 drivers/block/zram/zram_drv.c                      |   5 +-
 drivers/clk/ti/clk-7xx.c                           |   6 +-
 drivers/cpufreq/cpufreq.c                          |  10 -
 drivers/edac/ghes_edac.c                           |   4 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_acp.c            |  34 ++-
 drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c             |   8 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c            |  35 +++
 drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c            |  35 ---
 drivers/gpu/drm/amd/amdgpu/amdgpu_vce.c            |  20 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_vce.h            |   1 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_vcn.c            |  35 ++-
 drivers/gpu/drm/amd/amdgpu/sdma_v5_0.c             |   2 +-
 drivers/gpu/drm/amd/amdgpu/uvd_v6_0.c              |  31 ++-
 drivers/gpu/drm/amd/amdgpu/uvd_v7_0.c              |  33 ++-
 .../drm/amd/display/dc/dce100/dce100_resource.c    |   1 +
 .../drm/amd/display/dc/dce110/dce110_resource.c    |   1 +
 .../drm/amd/display/dc/dce112/dce112_resource.c    |   1 +
 .../drm/amd/display/dc/dce120/dce120_resource.c    |   1 +
 .../gpu/drm/amd/display/dc/dce80/dce80_resource.c  |   1 +
 .../gpu/drm/amd/display/dc/dcn10/dcn10_resource.c  |   1 +
 .../gpu/drm/amd/display/dc/dcn20/dcn20_resource.c  |   1 +
 .../drm/arm/display/komeda/komeda_wb_connector.c   |   7 +-
 drivers/gpu/drm/arm/malidp_mw.c                    |   4 +-
 drivers/gpu/drm/drm_atomic.c                       |  13 +-
 drivers/gpu/drm/drm_edid.c                         |   3 +
 drivers/gpu/drm/drm_writeback.c                    |  23 +-
 drivers/gpu/drm/i915/display/intel_bios.c          |  22 +-
 drivers/gpu/drm/i915/gem/i915_gem_mman.c           |   7 +
 drivers/gpu/drm/i915/gem/i915_gem_object.h         |   6 +
 drivers/gpu/drm/i915/gem/i915_gem_object_types.h   |   3 +-
 drivers/gpu/drm/i915/gem/i915_gem_userptr.c        |   1 +
 drivers/gpu/drm/i915/i915_gem.c                    |   3 +
 drivers/gpu/drm/panfrost/panfrost_job.c            |  16 +-
 drivers/gpu/drm/radeon/radeon_drv.c                |   8 -
 drivers/gpu/drm/rcar-du/rcar_du_writeback.c        |   4 +-
 drivers/gpu/drm/ttm/ttm_bo_vm.c                    |  16 +-
 drivers/gpu/drm/vc4/vc4_txp.c                      |   5 +-
 drivers/infiniband/hw/cxgb4/mem.c                  |  28 ++-
 drivers/input/misc/da9063_onkey.c                  |   5 +-
 drivers/input/mouse/elantech.c                     |  55 +++--
 drivers/input/rmi4/rmi_driver.c                    |   6 +-
 drivers/input/touchscreen/st1232.c                 |   6 +-
 drivers/irqchip/irq-sifive-plic.c                  |  29 +--
 drivers/md/dm-cache-target.c                       |  28 +--
 drivers/md/raid0.c                                 |   2 +-
 drivers/memstick/host/jmb38x_ms.c                  |   2 +-
 drivers/mmc/host/cqhci.c                           |   3 +-
 drivers/mmc/host/mxs-mmc.c                         |   7 +-
 drivers/mmc/host/sdhci-omap.c                      |   2 +-
 drivers/net/dsa/qca8k.c                            |   4 +-
 drivers/net/dsa/rtl8366rb.c                        |  16 +-
 drivers/net/ethernet/aquantia/atlantic/aq_main.c   |   4 +-
 drivers/net/ethernet/aquantia/atlantic/aq_nic.c    |  32 +--
 drivers/net/ethernet/aquantia/atlantic/aq_ring.c   |   3 +-
 .../ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c  |  23 +-
 .../ethernet/aquantia/atlantic/hw_atl/hw_atl_llh.c |  17 +-
 .../ethernet/aquantia/atlantic/hw_atl/hw_atl_llh.h |   7 +-
 .../aquantia/atlantic/hw_atl/hw_atl_llh_internal.h |  19 ++
 .../aquantia/atlantic/hw_atl/hw_atl_utils_fw2x.c   |   2 +-
 drivers/net/ethernet/atheros/ag71xx.c              |   6 +-
 drivers/net/ethernet/broadcom/Kconfig              |   4 +-
 drivers/net/ethernet/broadcom/genet/bcmgenet.h     |   1 +
 drivers/net/ethernet/broadcom/genet/bcmmii.c       |  11 +-
 drivers/net/ethernet/hisilicon/hns_mdio.c          |   6 +-
 drivers/net/ethernet/i825xx/lasi_82596.c           |   4 +-
 drivers/net/ethernet/i825xx/lib82596.c             |   4 +-
 drivers/net/ethernet/i825xx/sni_82596.c            |   4 +-
 drivers/net/ethernet/ibm/ibmvnic.c                 |   8 +-
 drivers/net/ethernet/mscc/ocelot_board.c           |  14 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c  |  13 +-
 .../net/ethernet/stmicro/stmmac/dwxgmac2_core.c    |   2 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |  37 ++-
 drivers/net/ieee802154/ca8210.c                    |   2 +-
 drivers/net/netdevsim/fib.c                        |   3 +-
 drivers/net/phy/mdio_device.c                      |   2 +-
 drivers/net/phy/micrel.c                           |  42 +++-
 drivers/net/phy/phy-c45.c                          |   2 +
 drivers/net/phy/phy.c                              |   8 +-
 drivers/net/phy/phy_device.c                       |   9 +-
 drivers/net/usb/r8152.c                            |   3 +-
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c      | 274 ++++++++++-----------
 drivers/net/xen-netback/interface.c                |   1 -
 drivers/nvme/host/core.c                           | 128 ++++++++--
 drivers/nvme/host/pci.c                            |  23 +-
 drivers/nvme/host/rdma.c                           |  19 +-
 drivers/nvme/host/tcp.c                            |   4 +-
 drivers/of/of_reserved_mem.c                       |   4 +-
 drivers/opp/of.c                                   |   2 -
 drivers/pci/pci.c                                  |  24 +-
 drivers/pinctrl/intel/pinctrl-cherryview.c         |   4 -
 drivers/pinctrl/mvebu/pinctrl-armada-37xx.c        |  26 +-
 drivers/s390/crypto/zcrypt_api.c                   |   3 +-
 drivers/s390/scsi/zfcp_fsf.c                       |  16 +-
 drivers/scsi/ch.c                                  |   1 -
 drivers/scsi/megaraid.c                            |   4 +-
 drivers/scsi/qla2xxx/qla_def.h                     |   3 +-
 drivers/scsi/qla2xxx/qla_init.c                    | 109 +++++---
 drivers/scsi/qla2xxx/qla_mbx.c                     |  25 +-
 drivers/scsi/qla2xxx/qla_os.c                      |  11 +-
 drivers/scsi/qla2xxx/qla_target.c                  |  25 +-
 drivers/scsi/scsi_error.c                          |   3 +
 drivers/scsi/scsi_sysfs.c                          |  11 +-
 drivers/scsi/sd.c                                  |   3 +-
 drivers/scsi/ufs/ufshcd.c                          |   3 +
 drivers/staging/wlan-ng/cfg80211.c                 |   6 +-
 drivers/usb/class/usblp.c                          |   4 +-
 drivers/usb/gadget/udc/lpc32xx_udc.c               |   6 +-
 drivers/usb/misc/ldusb.c                           |  23 +-
 drivers/usb/misc/legousbtower.c                    |   5 +-
 drivers/usb/serial/ti_usb_3410_5052.c              |  10 +-
 fs/binfmt_elf.c                                    |  13 +-
 fs/btrfs/ctree.h                                   |   2 -
 fs/btrfs/delalloc-space.c                          |   1 -
 fs/btrfs/disk-io.c                                 |   6 -
 fs/btrfs/extent-tree.c                             |   1 +
 fs/btrfs/file.c                                    |  36 ++-
 fs/btrfs/qgroup.c                                  |   4 +-
 fs/btrfs/relocation.c                              |   2 +
 fs/ceph/mds_client.c                               |  21 +-
 fs/cifs/file.c                                     |   6 +-
 fs/cifs/inode.c                                    |   4 +-
 fs/cifs/smb1ops.c                                  |   3 +
 fs/dax.c                                           |   5 +-
 fs/io_uring.c                                      | 120 +++++----
 fs/ocfs2/journal.c                                 |   3 +-
 fs/ocfs2/localalloc.c                              |   3 +-
 fs/proc/page.c                                     |  28 ++-
 fs/readdir.c                                       | 128 +++++++---
 include/linux/micrel_phy.h                         |   2 +-
 include/linux/mii.h                                |   9 +
 include/linux/skbuff.h                             |   5 +-
 include/linux/uaccess.h                            |   6 +-
 include/scsi/scsi_eh.h                             |   1 +
 include/trace/events/btrfs.h                       |   3 +-
 include/uapi/linux/nvme_ioctl.h                    |  23 ++
 kernel/events/core.c                               |   2 +-
 kernel/trace/trace_event_perf.c                    |   4 +
 lib/textsearch.c                                   |   4 +-
 lib/vdso/gettimeofday.c                            |   9 +-
 mm/compaction.c                                    |   7 +-
 mm/hugetlb.c                                       |   5 +-
 mm/memblock.c                                      |   6 +-
 mm/memory-failure.c                                |  36 +--
 mm/memory_hotplug.c                                |  72 ++----
 mm/memremap.c                                      |  11 +-
 mm/page_owner.c                                    |   5 +-
 mm/slab_common.c                                   |   9 +-
 mm/slub.c                                          |  13 +-
 mm/vmscan.c                                        |   9 +-
 net/core/skbuff.c                                  |  21 +-
 net/ipv4/route.c                                   |  11 +-
 net/ipv6/ip6_input.c                               |   4 +-
 net/mac80211/debugfs_netdev.c                      |  11 +-
 net/mac80211/mlme.c                                |   5 +-
 net/netfilter/nft_connlimit.c                      |   7 +-
 net/openvswitch/actions.c                          |   5 +-
 net/rxrpc/peer_event.c                             |  11 +-
 net/sched/act_api.c                                |  23 +-
 net/sched/act_mpls.c                               |  12 +-
 net/sched/cls_api.c                                |  36 ++-
 net/sched/sch_api.c                                |   3 +-
 net/sched/sch_etf.c                                |   2 +-
 net/sctp/socket.c                                  |   4 +-
 net/wireless/nl80211.c                             |   3 +
 net/wireless/wext-sme.c                            |   8 +-
 scripts/namespace.pl                               |  13 +-
 security/safesetid/securityfs.c                    |   3 +-
 sound/pci/hda/patch_hdmi.c                         |   2 +
 sound/pci/hda/patch_realtek.c                      |  14 ++
 sound/soc/sh/rcar/core.c                           |   1 +
 sound/usb/pcm.c                                    |   3 +
 tools/testing/selftests/kvm/Makefile               |   2 +-
 218 files changed, 1919 insertions(+), 1165 deletions(-)


