Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1F6218801E
	for <lists+stable@lfdr.de>; Tue, 17 Mar 2020 12:07:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727771AbgCQLHY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 07:07:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:49010 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727788AbgCQLHY (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Mar 2020 07:07:24 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EDABC20714;
        Tue, 17 Mar 2020 11:07:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584443242;
        bh=VP51pbzOgf7mTZD1TQSxDSx9yc/TWIp1idhEKAMjkYA=;
        h=From:To:Cc:Subject:Date:From;
        b=iwoGpEuerGTnkdyP1jE68XcCrVpsDihi2uI2XP7EqAFppGNyVPqxBlpTAZwiTkHVw
         r9YQ31XxCZuF8AxfesIopdmE7KYh4dsVbFY2O2aJTZjJuapckW4K7izGxYrjYhrtsz
         mjNvWtw/Z/hRJJU/ektXDU4utIuttO37tVprWqto=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 5.5 000/151] 5.5.10-rc1 review
Date:   Tue, 17 Mar 2020 11:53:30 +0100
Message-Id: <20200317103326.593639086@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-5.5.10-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.5.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.5.10-rc1
X-KernelTest-Deadline: 2020-03-19T10:33+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.5.10 release.
There are 151 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 19 Mar 2020 10:31:16 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.5.10-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.5.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.5.10-rc1

Karsten Graul <kgraul@linux.ibm.com>
    net/smc: check for valid ib_client_data

Eric Dumazet <edumazet@google.com>
    ipv6: restrict IPV6_ADDRFORM operation

Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
    iommu/amd: Fix IOMMU AVIC not properly update the is_run bit in IRTE

Wolfram Sang <wsa+renesas@sang-engineering.com>
    i2c: acpi: put device when verifying client fails

Daniel Drake <drake@endlessm.com>
    iommu/vt-d: Ignore devices with out-of-spec domain number

Zhenzhong Duan <zhenzhong.duan@gmail.com>
    iommu/vt-d: Fix the wrong printing in RHSA parsing

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nft_chain_nat: inet family is missing module ownership

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: dump NFTA_CHAIN_FLAGS attribute

Jakub Kicinski <kuba@kernel.org>
    netfilter: nft_tunnel: add missing attribute validation for tunnels

Jakub Kicinski <kuba@kernel.org>
    netfilter: nft_payload: add missing attribute validation for payload csum flags

Jakub Kicinski <kuba@kernel.org>
    netfilter: cthelper: add missing attribute validation for cthelper

Florian Westphal <fw@strlen.de>
    netfilter: nf_tables: free flowtable hooks on hook register error

Tommi Rantala <tommi.t.rantala@nokia.com>
    perf bench futex-wake: Restore thread count default to online CPU count

Jakub Kicinski <kuba@kernel.org>
    nl80211: add missing attribute validation for channel switch

Jakub Kicinski <kuba@kernel.org>
    nl80211: add missing attribute validation for beacon report scanning

Jakub Kicinski <kuba@kernel.org>
    nl80211: add missing attribute validation for critical protocol indication

Hamish Martin <hamish.martin@alliedtelesis.co.nz>
    i2c: gpio: suppress error on probe defer

Qian Cai <cai@lca.pw>
    iommu/vt-d: Fix RCU-list bugs in intel_iommu_init()

Christoph Hellwig <hch@lst.de>
    driver code: clarify and fix platform device DMA mask allocation

Zhenyu Wang <zhenyuw@linux.intel.com>
    drm/i915/gvt: Fix unnecessary schedule timer when no vGPU exits

Charles Keepax <ckeepax@opensource.cirrus.com>
    pinctrl: core: Remove extra kref_get which blocks hogs being freed

Tina Zhang <tina.zhang@intel.com>
    drm/i915/gvt: Fix dma-buf display blur issue on CFL

Thomas Gleixner <tglx@linutronix.de>
    x86/mce/therm_throt: Undo thermal polling properly on CPU offline

Suman Anna <s-anna@ti.com>
    virtio_ring: Fix mem leak with vring_new_virtqueue()

Leonard Crestez <leonard.crestez@nxp.com>
    pinctrl: imx: scu: Align imx sc msg structs to 4

Nicolas Belin <nbelin@baylibre.com>
    pinctrl: meson-gxl: fix GPIOX sdio pins

Anson Huang <Anson.Huang@nxp.com>
    clk: imx8mn: Fix incorrect clock defines

Sven Eckelmann <sven@narfation.org>
    batman-adv: Don't schedule OGM for disabled interface

Yonghyun Hwang <yonghyun@google.com>
    iommu/vt-d: Fix a bug in intel_iommu_iova_to_phys() for huge page

Amol Grover <frextrite@gmail.com>
    iommu/vt-d: Fix RCU list debugging warnings

Hans de Goede <hdegoede@redhat.com>
    iommu/vt-d: dmar_parse_one_rmrr: replace WARN_TAINT with pr_warn + add_taint

Hans de Goede <hdegoede@redhat.com>
    iommu/vt-d: dmar: replace WARN_TAINT with pr_warn + add_taint

Marc Zyngier <maz@kernel.org>
    iommu/dma: Fix MSI reservation allocation

Tony Luck <tony.luck@intel.com>
    x86/mce: Fix logic and comments around MSR_PPIN_CTL

Kim Phillips <kim.phillips@amd.com>
    perf/amd/uncore: Replace manual sampling check with CAP_NO_INTERRUPT flag

Felix Fietkau <nbd@nbd.name>
    mt76: fix array overflow on receiving too many fragments for a packet

Jarkko Nikula <jarkko.nikula@linux.intel.com>
    i2c: designware-pci: Fix BUG_ON during device removal

Vladis Dronov <vdronov@redhat.com>
    efi: Add a sanity check to efivar_store_raw()

Vladis Dronov <vdronov@redhat.com>
    efi: Fix a race and a buffer overflow while reading efivars via sysfs

Tom Lendacky <thomas.lendacky@amd.com>
    x86/ioremap: Map EFI runtime services data as encrypted for SEV

Wolfram Sang <wsa@the-dreams.de>
    macintosh: windfarm: fix MODINFO regression

Corey Minyard <cminyard@mvista.com>
    pid: Fix error return value in some cases

Eric Biggers <ebiggers@google.com>
    fscrypt: don't evict dirty inodes after removing key

Tejun Heo <tj@kernel.org>
    blk-iocost: fix incorrect vtime comparison in iocg_is_idle()

Artem Savkov <asavkov@redhat.com>
    ftrace: Return the first found result in lookup_rec()

Takashi Iwai <tiwai@suse.de>
    ipmi_si: Avoid spurious errors for optional IRQs

Stefan Haberland <sth@linux.ibm.com>
    s390/dasd: fix data corruption for thin provisioned devices

Paul Cercueil <paul@crapouillou.net>
    MIPS: Fix CONFIG_MIPS_CMDLINE_DTB_EXTEND handling

H. Nikolaus Schaller <hns@goldelico.com>
    MIPS: DTS: CI20: fix interrupt for pcf8563 RTC

H. Nikolaus Schaller <hns@goldelico.com>
    MIPS: DTS: CI20: fix PMU definitions for ACT8600

Miklos Szeredi <mszeredi@redhat.com>
    fuse: fix stack use after return

Eugeniy Paltsev <Eugeniy.Paltsev@synopsys.com>
    ARC: define __ALIGN_STR and __ALIGN symbols for ARC

Vitaly Kuznetsov <vkuznets@redhat.com>
    KVM: nVMX: avoid NULL pointer dereference with incorrect EVMCS GPAs

Vitaly Kuznetsov <vkuznets@redhat.com>
    KVM: x86: clear stale x86_emulate_ctxt->intercept value

Al Viro <viro@zeniv.linux.org.uk>
    gfs2_atomic_open(): fix O_EXCL|O_CREAT handling on cold dcache

Al Viro <viro@zeniv.linux.org.uk>
    cifs_atomic_open(): fix double-put on late allocation failure

Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
    block: Fix partition support for host aware zoned block devices

Steven Rostedt (VMware) <rostedt@goodmis.org>
    ktest: Add timeout for ssh sync testing

Linus Walleij <linus.walleij@linaro.org>
    pinctrl: qcom: Assign irq_eoi conditionally

Mathias Kresin <dev@kresin.me>
    pinctrl: falcon: fix syntax error

Ben Chuang <ben.chuang@genesyslogic.com.tw>
    mmc: sdhci-pci-gli: Enable MSI interrupt for GL975x

Chris Wilson <chris@chris-wilson.co.uk>
    drm/i915/execlists: Enable timeslice on partial virtual engine dequeue

Chris Wilson <chris@chris-wilson.co.uk>
    drm/i915/gt: Close race between cacheline_retire and free

Chris Wilson <chris@chris-wilson.co.uk>
    drm/i915: Defer semaphore priority bumping to a workqueue

Matthew Auld <matthew.auld@intel.com>
    drm/i915: be more solid in checking the alignment

Chris Wilson <chris@chris-wilson.co.uk>
    drm/i915: Return early for await_start on same timeline

Chris Wilson <chris@chris-wilson.co.uk>
    drm/i915: Actually emit the await_start

Colin Ian King <colin.king@canonical.com>
    drm/amd/display: remove duplicated assignment to grph_obj_type

Hillf Danton <hdanton@sina.com>
    workqueue: don't use wq_select_unbound_cpu() for bound works

Vasily Averin <vvs@virtuozzo.com>
    netfilter: x_tables: xt_mttg_seq_next should increase position index

Vasily Averin <vvs@virtuozzo.com>
    netfilter: xt_recent: recent_seq_next should increase position index

Vasily Averin <vvs@virtuozzo.com>
    netfilter: synproxy: synproxy_cpu_seq_next should increase position index

Vasily Averin <vvs@virtuozzo.com>
    netfilter: nf_conntrack: ct_cpu_seq_next should increase position index

Hans de Goede <hdegoede@redhat.com>
    iommu/vt-d: quirk_ioat_snb_local_iommu: replace WARN_TAINT with pr_warn + add_taint

Halil Pasic <pasic@linux.ibm.com>
    virtio-blk: fix hw_queue stopped on arbitrary error

Dan Moulding <dmoulding@me.com>
    iwlwifi: mvm: Do not require PHY_SKU NVM section for 3168 devices

Florian Westphal <fw@strlen.de>
    netfilter: nf_tables: fix infinite loop when expr is not available

Michal Koutný <mkoutny@suse.com>
    cgroup: Iterate tasks that did not finish do_exit()

Vasily Averin <vvs@virtuozzo.com>
    cgroup: cgroup_procs_next should increase position index

Qian Cai <cai@lca.pw>
    cgroup: fix psi_show() crash on 32bit ino archs

Florian Fainelli <f.fainelli@gmail.com>
    net: phy: Avoid multiple suspends

Andrew Lunn <andrew@lunn.ch>
    net: dsa: mv88e6xxx: Add missing mask of ATU occupancy register

Andrew Lunn <andrew@lunn.ch>
    net: dsa: Don't instantiate phylink for CPU/DSA ports unless needed

Julian Wiedmann <jwi@linux.ibm.com>
    s390/qeth: handle error when backing RX buffer

Julian Wiedmann <jwi@linux.ibm.com>
    s390/qeth: don't reset default_out_queue

Hangbin Liu <liuhangbin@gmail.com>
    selftests/net/fib_tests: update addr_metric_test for peer route testing

Hangbin Liu <liuhangbin@gmail.com>
    net/ipv6: remove the old peer route if change it to a new one

Hangbin Liu <liuhangbin@gmail.com>
    net/ipv6: need update peer route when modify metric

Heiner Kallweit <hkallweit1@gmail.com>
    net: phy: fix MDIO bus PM PHY resuming

Heiner Kallweit <hkallweit1@gmail.com>
    net: phy: avoid clearing PHY interrupts twice in irq handler

Jakub Kicinski <kuba@kernel.org>
    nfc: add missing attribute validation for vendor subcommand

Jakub Kicinski <kuba@kernel.org>
    nfc: add missing attribute validation for deactivate target

Jakub Kicinski <kuba@kernel.org>
    nfc: add missing attribute validation for SE API

Jakub Kicinski <kuba@kernel.org>
    tipc: add missing attribute validation for MTU property

Jakub Kicinski <kuba@kernel.org>
    team: add missing attribute validation for array index

Jakub Kicinski <kuba@kernel.org>
    team: add missing attribute validation for port ifindex

Jakub Kicinski <kuba@kernel.org>
    net: taprio: add missing attribute validation for txtime delay

Jakub Kicinski <kuba@kernel.org>
    net: fq: add missing attribute validation for orphan mask

Jakub Kicinski <kuba@kernel.org>
    openvswitch: add missing attribute validation for hash

Jakub Kicinski <kuba@kernel.org>
    macsec: add missing attribute validation for port

Jakub Kicinski <kuba@kernel.org>
    can: add missing attribute validation for termination

Jakub Kicinski <kuba@kernel.org>
    nl802154: add missing attribute validation for dev_type

Jakub Kicinski <kuba@kernel.org>
    nl802154: add missing attribute validation

Jakub Kicinski <kuba@kernel.org>
    fib: add missing attribute validation for tun_id

Jakub Kicinski <kuba@kernel.org>
    devlink: validate length of region addr/len

Jakub Kicinski <kuba@kernel.org>
    devlink: validate length of param values

Jian Shen <shenjian15@huawei.com>
    net: hns3: clear port base VLAN when unload PF

Jian Shen <shenjian15@huawei.com>
    net: hns3: fix RMW issue for VLAN filter switch

Yonglong Liu <liuyonglong@huawei.com>
    net: hns3: fix "tc qdisc del" failed issue

Madalin Bucur <madalin.bucur@nxp.com>
    dpaa_eth: FMan erratum A050385 workaround

Madalin Bucur <madalin.bucur@nxp.com>
    fsl/fman: detect FMan erratum A050385

Madalin Bucur <madalin.bucur@nxp.com>
    arm64: dts: ls1043a: FMan erratum A050385

Madalin Bucur <madalin.bucur@nxp.com>
    dt-bindings: net: FMan erratum A050385

Eric Dumazet <edumazet@google.com>
    net: memcg: fix lockdep splat in inet_csk_accept()

Shakeel Butt <shakeelb@google.com>
    net: memcg: late association of sock to memcg

Shakeel Butt <shakeelb@google.com>
    cgroup: memcg: net: do not associate sock with unrelated cgroup

Edwin Peer <edwin.peer@broadcom.com>
    bnxt_en: fix error handling when flashing from file

Vasundhara Volam <vasundhara-v.volam@broadcom.com>
    bnxt_en: reinitialize IRQs when MTU is modified

Eric Dumazet <edumazet@google.com>
    bonding/alb: make sure arp header is pulled before accessing it

Vinicius Costa Gomes <vinicius.gomes@intel.com>
    taprio: Fix sending packets without dequeueing them

Eric Dumazet <edumazet@google.com>
    slip: make slhc_compress() more robust against malicious packets

Edward Cree <ecree@solarflare.com>
    sfc: detach from cb_page in efx_copy_channel()

You-Sheng Yang <vicamo.yang@canonical.com>
    r8152: check disconnect status after long sleep

Colin Ian King <colin.king@canonical.com>
    net: systemport: fix index check to avoid an array out of bounds access

Remi Pommarel <repk@triplefau.lt>
    net: stmmac: dwmac1000: Disable ACS if enhanced descs are not used

Karsten Graul <kgraul@linux.ibm.com>
    net/smc: cancel event worker during device removal

Jonas Gorski <jonas.gorski@gmail.com>
    net: phy: bcm63xx: fix OOPS due to missing driver name

Willem de Bruijn <willemb@google.com>
    net/packet: tpacket_rcv: do not increment ring index on drop

Dan Carpenter <dan.carpenter@oracle.com>
    net: nfc: fix bounds checking bugs on "pipe"

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: mscc: ocelot: properly account for VLAN header length when setting MRU

Dmitry Bogdanov <dbogdanov@marvell.com>
    net: macsec: update SCI upon MAC address change.

Pablo Neira Ayuso <pablo@netfilter.org>
    netlink: Use netlink header as base to calculate bad attribute offset

Hangbin Liu <liuhangbin@gmail.com>
    net/ipv6: use configured metric when add peer route

Jian Shen <shenjian15@huawei.com>
    net: hns3: fix a not link up issue when fibre port supports autoneg

Jakub Kicinski <kuba@kernel.org>
    net: fec: validate the new settings in fec_enet_set_coalesce()

Russell King <rmk+kernel@armlinux.org.uk>
    net: dsa: mv88e6xxx: fix lockup on warm boot

Russell King <rmk+kernel@armlinux.org.uk>
    net: dsa: fix phylink_start()/phylink_stop() calls

Mahesh Bandewar <maheshb@google.com>
    macvlan: add cond_resched() during multicast processing

Mahesh Bandewar <maheshb@google.com>
    ipvlan: don't deref eth hdr before checking it's set

Eric Dumazet <edumazet@google.com>
    ipvlan: do not use cond_resched_rcu() in ipvlan_process_multicast()

Jiri Wiesner <jwiesner@suse.com>
    ipvlan: do not add hardware address of master to its unicast filter list

Mahesh Bandewar <maheshb@google.com>
    ipvlan: add cond_resched_rcu() while processing muticast backlog

Hangbin Liu <liuhangbin@gmail.com>
    ipv6/addrconf: call ipv6_mc_up() for non-Ethernet interface

Dmitry Yakunin <zeil@yandex-team.ru>
    inet_diag: return classid for all socket types

Eric Dumazet <edumazet@google.com>
    gre: fix uninit-value in __iptunnel_pull_header

Vishal Kulkarni <vishal@chelsio.com>
    cxgb4: fix checks for max queues to allocate

Dmitry Yakunin <zeil@yandex-team.ru>
    cgroup, netclassid: periodically release file_lock on classid updating

Kailang Yang <kailang@realtek.com>
    ALSA: hda/realtek - Fixed one of HP ALC671 platform Headset Mic supported

Kailang Yang <kailang@realtek.com>
    ALSA: hda/realtek - Add Headset Mic supported for HP cPC

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/realtek - More constifications

Nathan Chancellor <natechancellor@gmail.com>
    virtio_balloon: Adjust label in virtballoon_probe


-------------

Diffstat:

 Documentation/devicetree/bindings/net/fsl-fman.txt |   7 +
 Documentation/filesystems/porting.rst              |   8 +
 Makefile                                           |   4 +-
 arch/arc/include/asm/linkage.h                     |   2 +
 arch/arm64/boot/dts/freescale/fsl-ls1043-post.dtsi |   2 +
 arch/mips/boot/dts/ingenic/ci20.dts                |  44 ++++--
 arch/mips/kernel/setup.c                           |   3 +-
 arch/x86/events/amd/uncore.c                       |  17 +--
 arch/x86/kernel/cpu/mce/intel.c                    |   9 +-
 arch/x86/kernel/cpu/mce/therm_throt.c              |   9 +-
 arch/x86/kvm/emulate.c                             |   1 +
 arch/x86/kvm/vmx/nested.c                          |   5 +-
 arch/x86/mm/ioremap.c                              |  18 +++
 block/blk-iocost.c                                 |   2 +-
 block/genhd.c                                      |  36 +++++
 drivers/base/platform.c                            |  25 +---
 drivers/block/virtio_blk.c                         |   8 +-
 drivers/char/ipmi/ipmi_si_platform.c               |   4 +-
 drivers/firmware/efi/efivars.c                     |  32 ++--
 drivers/gpu/drm/amd/amdgpu/amdgpu_atombios.c       |   3 +-
 drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c     |   3 +-
 drivers/gpu/drm/i915/gt/intel_lrc.c                |  29 ++--
 drivers/gpu/drm/i915/gt/intel_timeline.c           |   8 +-
 drivers/gpu/drm/i915/gvt/display.c                 |   3 +-
 drivers/gpu/drm/i915/gvt/vgpu.c                    |  12 +-
 drivers/gpu/drm/i915/i915_request.c                |  28 +++-
 drivers/gpu/drm/i915/i915_request.h                |   2 +
 drivers/gpu/drm/i915/i915_utils.h                  |   5 +
 drivers/i2c/busses/i2c-designware-pcidrv.c         |   1 +
 drivers/i2c/busses/i2c-gpio.c                      |   2 +-
 drivers/i2c/i2c-core-acpi.c                        |  10 +-
 drivers/iommu/amd_iommu.c                          |   4 +-
 drivers/iommu/dma-iommu.c                          |  16 +-
 drivers/iommu/dmar.c                               |  21 ++-
 drivers/iommu/intel-iommu.c                        |  24 ++-
 drivers/macintosh/windfarm_ad7417_sensor.c         |   7 +
 drivers/macintosh/windfarm_fcu_controls.c          |   7 +
 drivers/macintosh/windfarm_lm75_sensor.c           |  16 +-
 drivers/macintosh/windfarm_lm87_sensor.c           |   7 +
 drivers/macintosh/windfarm_max6690_sensor.c        |   7 +
 drivers/macintosh/windfarm_smu_sat.c               |   7 +
 drivers/mmc/host/sdhci-pci-gli.c                   |  17 +++
 drivers/net/bonding/bond_alb.c                     |  20 +--
 drivers/net/can/dev.c                              |   1 +
 drivers/net/dsa/mv88e6xxx/chip.c                   |   2 +
 drivers/net/dsa/mv88e6xxx/global2.c                |   8 +-
 drivers/net/ethernet/broadcom/bcmsysport.c         |   2 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |   4 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c  |  24 ++-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c    |  49 ++++---
 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c     | 110 +++++++++++++-
 drivers/net/ethernet/freescale/fec_main.c          |   6 +-
 drivers/net/ethernet/freescale/fman/Kconfig        |  28 ++++
 drivers/net/ethernet/freescale/fman/fman.c         |  18 +++
 drivers/net/ethernet/freescale/fman/fman.h         |   5 +
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    |   2 +-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    |  46 +++++-
 drivers/net/ethernet/mscc/ocelot.c                 |  28 ++--
 drivers/net/ethernet/mscc/ocelot_dev.h             |   2 +-
 drivers/net/ethernet/sfc/efx.c                     |   1 +
 .../net/ethernet/stmicro/stmmac/dwmac1000_core.c   |   3 +-
 drivers/net/ipvlan/ipvlan_core.c                   |  19 ++-
 drivers/net/ipvlan/ipvlan_main.c                   |   5 +-
 drivers/net/macsec.c                               |  12 +-
 drivers/net/macvlan.c                              |   2 +
 drivers/net/phy/bcm63xx.c                          |   1 +
 drivers/net/phy/phy.c                              |   3 +-
 drivers/net/phy/phy_device.c                       |  11 +-
 drivers/net/slip/slhc.c                            |  14 +-
 drivers/net/team/team.c                            |   2 +
 drivers/net/usb/r8152.c                            |   8 +
 drivers/net/wireless/intel/iwlwifi/mvm/nvm.c       |   3 +-
 drivers/net/wireless/mediatek/mt76/dma.c           |   9 +-
 drivers/pinctrl/core.c                             |   1 -
 drivers/pinctrl/freescale/pinctrl-scu.c            |   4 +-
 drivers/pinctrl/meson/pinctrl-meson-gxl.c          |   4 +-
 drivers/pinctrl/pinctrl-falcon.c                   |   2 +-
 drivers/pinctrl/qcom/pinctrl-msm.c                 |   3 +-
 drivers/s390/block/dasd.c                          |  27 +++-
 drivers/s390/block/dasd_eckd.c                     | 163 ++++++++++++++++++++-
 drivers/s390/block/dasd_int.h                      |  15 +-
 drivers/s390/net/qeth_core_main.c                  |  14 +-
 drivers/virtio/virtio_balloon.c                    |   2 +-
 drivers/virtio/virtio_ring.c                       |   4 +-
 fs/cifs/dir.c                                      |   1 -
 fs/crypto/keysetup.c                               |   9 ++
 fs/fuse/dev.c                                      |   6 +-
 fs/fuse/fuse_i.h                                   |   2 +
 fs/gfs2/inode.c                                    |   2 +-
 fs/open.c                                          |   3 -
 include/dt-bindings/clock/imx8mn-clock.h           |   4 +-
 include/linux/cgroup.h                             |   1 +
 include/linux/dmar.h                               |   8 +-
 include/linux/genhd.h                              |  13 +-
 include/linux/inet_diag.h                          |  18 ++-
 include/linux/phy.h                                |   3 +
 include/linux/platform_device.h                    |   2 +-
 include/net/fib_rules.h                            |   1 +
 kernel/cgroup/cgroup.c                             |  43 ++++--
 kernel/pid.c                                       |   2 +
 kernel/trace/ftrace.c                              |   2 +
 kernel/workqueue.c                                 |  14 +-
 mm/memcontrol.c                                    |  14 +-
 net/batman-adv/bat_iv_ogm.c                        |   4 +
 net/core/devlink.c                                 |  33 +++--
 net/core/netclassid_cgroup.c                       |  47 ++++--
 net/core/sock.c                                    |   5 +-
 net/dsa/dsa_priv.h                                 |   2 +
 net/dsa/port.c                                     |  44 ++++--
 net/dsa/slave.c                                    |   8 +-
 net/ieee802154/nl_policy.c                         |   6 +
 net/ipv4/gre_demux.c                               |  12 +-
 net/ipv4/inet_connection_sock.c                    |  20 +++
 net/ipv4/inet_diag.c                               |  44 +++---
 net/ipv4/raw_diag.c                                |   5 +-
 net/ipv4/udp_diag.c                                |   5 +-
 net/ipv6/addrconf.c                                |  51 +++++--
 net/ipv6/ipv6_sockglue.c                           |  10 +-
 net/netfilter/nf_conntrack_standalone.c            |   2 +-
 net/netfilter/nf_synproxy_core.c                   |   2 +-
 net/netfilter/nf_tables_api.c                      |  22 ++-
 net/netfilter/nfnetlink_cthelper.c                 |   2 +
 net/netfilter/nft_chain_nat.c                      |   1 +
 net/netfilter/nft_payload.c                        |   1 +
 net/netfilter/nft_tunnel.c                         |   2 +
 net/netfilter/x_tables.c                           |   6 +-
 net/netfilter/xt_recent.c                          |   2 +-
 net/netlink/af_netlink.c                           |   2 +-
 net/nfc/hci/core.c                                 |  19 ++-
 net/nfc/netlink.c                                  |   4 +
 net/openvswitch/datapath.c                         |   1 +
 net/packet/af_packet.c                             |  13 +-
 net/sched/sch_fq.c                                 |   1 +
 net/sched/sch_taprio.c                             |  13 +-
 net/sctp/diag.c                                    |   8 +-
 net/smc/smc_ib.c                                   |   3 +
 net/tipc/netlink.c                                 |   1 +
 net/wireless/nl80211.c                             |   5 +
 sound/pci/hda/patch_realtek.c                      | 163 +++++++++++++--------
 tools/perf/bench/futex-wake.c                      |   4 +-
 tools/testing/ktest/ktest.pl                       |   2 +-
 tools/testing/selftests/net/fib_tests.sh           |  34 ++++-
 142 files changed, 1420 insertions(+), 499 deletions(-)


