Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99C151EAE39
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 20:53:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730117AbgFASDu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 14:03:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:47878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730121AbgFASDq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jun 2020 14:03:46 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DA6AB21501;
        Mon,  1 Jun 2020 18:03:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591034624;
        bh=hHOBvCg/8ucSPJryg+om8J2wPCzs8Km3xe9q86BQpKo=;
        h=From:To:Cc:Subject:Date:From;
        b=QPnHly90vKakMcWdErfhDp0V0e45t/QX1AqWvmG+Ku8INAKWNLFW45s2dcUWa89Hf
         yqHn84zaivHUQZ5BtI5LxLIn87Pl+ojZY9X37lqXKAwq5NPV/IFlFI6jE0NBVuJqA+
         I3ePDIjGKdFXJAJsrk4jALJs9bJAX5vUJ1oKyseo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.19 00/95] 4.19.126-rc1 review
Date:   Mon,  1 Jun 2020 19:53:00 +0200
Message-Id: <20200601174020.759151073@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.126-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.126-rc1
X-KernelTest-Deadline: 2020-06-03T17:40+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.19.126 release.
There are 95 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 03 Jun 2020 17:38:19 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.126-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.19.126-rc1

Liviu Dudau <liviu@dudau.co.uk>
    mm/vmalloc.c: don't dereference possible NULL pointer in __vunmap()

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_conntrack_pptp: fix compilation warning with W=1 build

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    Revert "Input: i8042 - add ThinkPad S230u to i8042 nomux list"

Qiushi Wu <wu000273@umn.edu>
    bonding: Fix reference count leak in bond_sysfs_slave_add.

Eric Dumazet <edumazet@google.com>
    crypto: chelsio/chtls: properly set tp->lsndtime

Qiushi Wu <wu000273@umn.edu>
    qlcnic: fix missing release in qlcnic_83xx_interrupt_test.

Björn Töpel <bjorn.topel@intel.com>
    xsk: Add overflow check for u64 division, stored into u32

Michael Chan <michael.chan@broadcom.com>
    bnxt_en: Fix accumulation of bp->net_stats_prev.

Xin Long <lucien.xin@gmail.com>
    esp6: get the right proto for transport mode in esp6_gso_encap

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_conntrack_pptp: prevent buffer overflows in debug code

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nfnetlink_cthelper: unbreak userspace helper support

Phil Sutter <phil@nwl.cc>
    netfilter: ipset: Fix subcounter update skip

Michael Braun <michael-dev@fami-braun.de>
    netfilter: nft_reject_bridge: enable reject with bridge vlan

Xin Long <lucien.xin@gmail.com>
    ip_vti: receive ipip packet by calling ip_tunnel_rcv

Jeremy Sowden <jeremy@azazel.net>
    vti4: eliminated some duplicate code.

Antony Antony <antony@phenome.org>
    xfrm: fix error in comment

Xin Long <lucien.xin@gmail.com>
    xfrm: fix a NULL-ptr deref in xfrm_local_error

Xin Long <lucien.xin@gmail.com>
    xfrm: fix a warning in xfrm_policy_insert_list

Nicolas Dichtel <nicolas.dichtel@6wind.com>
    xfrm interface: fix oops when deleting a x-netns interface

Xin Long <lucien.xin@gmail.com>
    xfrm: call xfrm_output_gso when inner_protocol is set in xfrm_output

Xin Long <lucien.xin@gmail.com>
    xfrm: allow to accept packets with ipv6 NEXTHDR_HOP in xfrm_input

Al Viro <viro@zeniv.linux.org.uk>
    copy_xstate_to_kernel(): don't leave parts of destination uninitialized

Alexander Dahl <post@lespocky.de>
    x86/dma: Fix max PFN arithmetic overflow on 32 bit systems

Linus Lüssing <ll@simonwunderlich.de>
    mac80211: mesh: fix discovery timer re-arming issue / crash

Jason Gunthorpe <jgg@ziepe.ca>
    RDMA/core: Fix double destruction of uobject

Sarthak Garg <sartgarg@codeaurora.org>
    mmc: core: Fix recursive locking issue in CQE recovery path

Helge Deller <deller@gmx.de>
    parisc: Fix kernel panic in mem_init()

Qiushi Wu <wu000273@umn.edu>
    iommu: Fix reference count leak in iommu_group_alloc.

Arnd Bergmann <arnd@arndb.de>
    include/asm-generic/topology.h: guard cpumask_of_node() macro argument

Alexander Potapenko <glider@google.com>
    fs/binfmt_elf.c: allocate initialized memory in fill_thread_core_info()

Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
    mm: remove VM_BUG_ON(PageSlab()) from page_mapcount()

Valentine Fatiev <valentinef@mellanox.com>
    IB/ipoib: Fix double free of skb in case of multicast traffic in CM mode

Jerry Lee <leisurelysw24@gmail.com>
    libceph: ignore pool overlay and cache logic on redirects

Kailang Yang <kailang@realtek.com>
    ALSA: hda/realtek - Add new codec supported for ALC287

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Quirks for Gigabyte TRX40 Aorus Master onboard audio

Eric W. Biederman <ebiederm@xmission.com>
    exec: Always set cap_ambient in cap_bprm_set_creds

Chris Chiu <chiu@endlessm.com>
    ALSA: usb-audio: mixer: volume quirk for ESS Technology Asus USB DAC

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/realtek - Add a model for Thinkpad T570 without DAC workaround

Changming Liu <liu.changm@northeastern.edu>
    ALSA: hwdep: fix a left shifting 1 by 31 UB bug

Qiushi Wu <wu000273@umn.edu>
    RDMA/pvrdma: Fix missing pci disable in pvrdma_pci_probe()

Peng Hao <richard.peng@oppo.com>
    mmc: block: Fix use-after-free issue for rpmb

Hamish Martin <hamish.martin@alliedtelesis.co.nz>
    ARM: dts: bcm: HR2: Fix PPI interrupt types

Vincent Stehlé <vincent.stehle@laposte.net>
    ARM: dts: bcm2835-rpi-zero-w: Fix led polarity

Robert Beckett <bob.beckett@collabora.com>
    ARM: dts/imx6q-bx50v3: Set display interface clock parents

Kaike Wan <kaike.wan@intel.com>
    IB/qib: Call kobject_put() when kobject_init_and_add() fails

Takashi Iwai <tiwai@suse.de>
    gpio: exar: Fix bad handling for ida_simple_get error path

Russell King <rmk+kernel@armlinux.org.uk>
    ARM: uaccess: fix DACR mismatch with nested exceptions

Russell King <rmk+kernel@armlinux.org.uk>
    ARM: uaccess: integrate uaccess_save and uaccess_restore

Russell King <rmk+kernel@armlinux.org.uk>
    ARM: uaccess: consolidate uaccess asm to asm/uaccess-asm.h

Stefan Agner <stefan@agner.ch>
    ARM: 8843/1: use unified assembler in headers

Łukasz Stelmach <l.stelmach@samsung.com>
    ARM: 8970/1: decompressor: increase tag size

Wei Yongjun <weiyongjun1@huawei.com>
    Input: synaptics-rmi4 - fix error return code in rmi_driver_probe()

Evan Green <evgreen@chromium.org>
    Input: synaptics-rmi4 - really fix attn_data use-after-free

Kevin Locke <kevin@kevinlocke.name>
    Input: i8042 - add ThinkPad S230u to i8042 reset list

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    Input: dlink-dir685-touchkeys - fix a typo in driver name

Łukasz Patron <priv.luk@gmail.com>
    Input: xpad - add custom init packet for Xbox One S controllers

Brendan Shanks <bshanks@codeweavers.com>
    Input: evdev - call input_flush_device() on release(), not flush()

Kevin Locke <kevin@kevinlocke.name>
    Input: i8042 - add ThinkPad S230u to i8042 nomux list

James Hilliard <james.hilliard1@gmail.com>
    Input: usbtouchscreen - add support for BonXeon TP

Matteo Croce <mcroce@redhat.com>
    samples: bpf: Fix build error

Steve French <stfrench@microsoft.com>
    cifs: Fix null pointer check in cifs_read

Kefeng Wang <wangkefeng.wang@huawei.com>
    riscv: stacktrace: Fix undefined reference to `walk_stackframe'

Denis V. Lunev <den@openvz.org>
    IB/i40iw: Remove bogus call to netdev_master_upper_dev_get()

Arnd Bergmann <arnd@arndb.de>
    net: freescale: select CONFIG_FIXED_PHY where needed

Masahiro Yamada <masahiroy@kernel.org>
    usb: gadget: legacy: fix redundant initialization warnings

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    usb: dwc3: pci: Enable extcon driver for Intel Merrifield

Lei Xue <carmark.dlut@gmail.com>
    cachefiles: Fix race between read_waiter and read_copier involving op->to_do

Bob Peterson <rpeterso@redhat.com>
    gfs2: don't call quota_unhold if quotas are not locked

Bob Peterson <rpeterso@redhat.com>
    gfs2: move privileged user check to gfs2_quota_lock_check

Chuhong Yuan <hslester96@gmail.com>
    net: microchip: encx24j600: add missed kthread_stop

Andrew Oakley <andrew@adoakley.name>
    ALSA: usb-audio: add mapping for ASRock TRX40 Creator

Stephen Warren <swarren@nvidia.com>
    gpio: tegra: mask GPIO IRQs during IRQ shutdown

Johan Jonker <jbx6244@gmail.com>
    ARM: dts: rockchip: fix pinctrl sub nodename for spi in rk322x.dtsi

Johan Jonker <jbx6244@gmail.com>
    ARM: dts: rockchip: swap clock-names of gpu nodes

Johan Jonker <jbx6244@gmail.com>
    arm64: dts: rockchip: swap interrupts interrupt-names rk3399 gpu node

Johan Jonker <jbx6244@gmail.com>
    arm64: dts: rockchip: fix status for &gmac2phy in rk3328-evb.dts

Johan Jonker <jbx6244@gmail.com>
    ARM: dts: rockchip: fix phy nodename for rk3228-evb

Jiri Pirko <jiri@mellanox.com>
    mlxsw: spectrum: Fix use-after-free of split/unsplit/type_set in case reload fails

Qiushi Wu <wu000273@umn.edu>
    net/mlx4_core: fix a memory leak bug.

Qiushi Wu <wu000273@umn.edu>
    net: sun: fix missing release regions in cas_init_one().

Roi Dayan <roid@mellanox.com>
    net/mlx5: Annotate mutex destroy for root ns

Moshe Shemesh <moshe@mellanox.com>
    net/mlx5e: Update netdev txq on completions during closure

Jere Leppänen <jere.leppanen@nokia.com>
    sctp: Start shutdown on association restart if in SHUTDOWN-SENT state and socket is closed

Neil Horman <nhorman@tuxdriver.com>
    sctp: Don't add the shutdown timer if its already been added

Marc Payne <marc.payne@mdpsys.co.uk>
    r8152: support additional Microsoft Surface Ethernet Adapter variant

Roman Mashak <mrv@mojatatu.com>
    net sched: fix reporting the first-time use timestamp

Yuqi Jin <jinyuqi@huawei.com>
    net: revert "net: get rid of an signed integer overflow in ip_idents_reserve()"

Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
    net: qrtr: Fix passing invalid reference to qrtr_local_enqueue()

Moshe Shemesh <moshe@mellanox.com>
    net/mlx5: Add command entry handling completion

Vadim Fedorenko <vfedorenko@novek.ru>
    net: ipip: fix wrong address family in init error path

Martin KaFai Lau <kafai@fb.com>
    net: inet_csk: Fix so_reuseport bind-address cache in tb->fast*

Boris Sukholitko <boris.sukholitko@broadcom.com>
    __netif_receive_skb_core: pass skb by reference

DENG Qingfang <dqfext@gmail.com>
    net: dsa: mt7530: fix roaming from DSA user ports

Vladimir Oltean <vladimir.oltean@nxp.com>
    dpaa_eth: fix usage as DSA master, try 3

Eric Dumazet <edumazet@google.com>
    ax25: fix setsockopt(SO_BINDTODEVICE)


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/arm/boot/compressed/vmlinux.lds.S             |   2 +-
 arch/arm/boot/dts/bcm-hr2.dtsi                     |   6 +-
 arch/arm/boot/dts/bcm2835-rpi-zero-w.dts           |   2 +-
 arch/arm/boot/dts/imx6q-b450v3.dts                 |   7 --
 arch/arm/boot/dts/imx6q-b650v3.dts                 |   7 --
 arch/arm/boot/dts/imx6q-b850v3.dts                 |  11 --
 arch/arm/boot/dts/imx6q-bx50v3.dtsi                |  15 +++
 arch/arm/boot/dts/rk3036.dtsi                      |   2 +-
 arch/arm/boot/dts/rk3228-evb.dts                   |   2 +-
 arch/arm/boot/dts/rk322x.dtsi                      |   6 +-
 arch/arm/boot/dts/rk3xxx.dtsi                      |   2 +-
 arch/arm/include/asm/assembler.h                   |  83 +--------------
 arch/arm/include/asm/uaccess-asm.h                 | 117 +++++++++++++++++++++
 arch/arm/include/asm/vfpmacros.h                   |   8 +-
 arch/arm/kernel/entry-armv.S                       |  11 +-
 arch/arm/kernel/entry-header.S                     |   9 +-
 arch/arm/lib/bitops.h                              |   8 +-
 arch/arm64/boot/dts/rockchip/rk3328-evb.dts        |   2 +-
 arch/arm64/boot/dts/rockchip/rk3399.dtsi           |   8 +-
 arch/parisc/mm/init.c                              |   2 +-
 arch/riscv/kernel/stacktrace.c                     |   2 +-
 arch/x86/include/asm/dma.h                         |   2 +-
 arch/x86/kernel/fpu/xstate.c                       |  86 ++++++++-------
 drivers/crypto/chelsio/chtls/chtls_io.c            |   2 +-
 drivers/gpio/gpio-exar.c                           |   7 +-
 drivers/gpio/gpio-tegra.c                          |   1 +
 drivers/infiniband/core/rdma_core.c                |  19 ++--
 drivers/infiniband/hw/i40iw/i40iw_cm.c             |   8 --
 drivers/infiniband/hw/qib/qib_sysfs.c              |   9 +-
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c     |   2 +-
 drivers/infiniband/ulp/ipoib/ipoib.h               |   4 +
 drivers/infiniband/ulp/ipoib/ipoib_cm.c            |  15 +--
 drivers/infiniband/ulp/ipoib/ipoib_ib.c            |   9 +-
 drivers/infiniband/ulp/ipoib/ipoib_main.c          |  10 +-
 drivers/input/evdev.c                              |  19 +---
 drivers/input/joystick/xpad.c                      |  12 +++
 drivers/input/keyboard/dlink-dir685-touchkeys.c    |   2 +-
 drivers/input/rmi4/rmi_driver.c                    |   5 +-
 drivers/input/serio/i8042-x86ia64io.h              |   7 ++
 drivers/input/touchscreen/usbtouchscreen.c         |   1 +
 drivers/iommu/iommu.c                              |   2 +-
 drivers/mmc/core/block.c                           |   2 +-
 drivers/mmc/core/queue.c                           |  13 +--
 drivers/net/bonding/bond_sysfs_slave.c             |   4 +-
 drivers/net/dsa/mt7530.c                           |   9 +-
 drivers/net/dsa/mt7530.h                           |   1 +
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |   2 +-
 drivers/net/ethernet/freescale/Kconfig             |   2 +
 drivers/net/ethernet/freescale/dpaa/Kconfig        |   1 +
 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c     |   2 +-
 drivers/net/ethernet/mellanox/mlx4/fw.c            |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c      |  14 +++
 drivers/net/ethernet/mellanox/mlx5/core/en_tx.c    |   6 +-
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c  |   6 ++
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c     |  14 ++-
 drivers/net/ethernet/mellanox/mlxsw/switchx2.c     |   8 ++
 drivers/net/ethernet/microchip/encx24j600.c        |   5 +-
 .../net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c    |   4 +-
 drivers/net/ethernet/sun/cassini.c                 |   3 +-
 drivers/net/usb/cdc_ether.c                        |  11 +-
 drivers/net/usb/r8152.c                            |   1 +
 drivers/usb/dwc3/dwc3-pci.c                        |   1 +
 drivers/usb/gadget/legacy/inode.c                  |   3 +-
 fs/binfmt_elf.c                                    |   2 +-
 fs/cachefiles/rdwr.c                               |   2 +-
 fs/cifs/file.c                                     |   2 +-
 fs/gfs2/quota.c                                    |   6 +-
 fs/gfs2/quota.h                                    |   3 +-
 include/asm-generic/topology.h                     |   2 +-
 include/linux/mlx5/driver.h                        |   1 +
 include/linux/mm.h                                 |  15 ++-
 include/linux/netfilter/nf_conntrack_pptp.h        |   2 +-
 include/net/act_api.h                              |   3 +-
 include/rdma/uverbs_std_types.h                    |   2 +-
 include/uapi/linux/xfrm.h                          |   2 +-
 mm/vmalloc.c                                       |   2 +-
 net/ax25/af_ax25.c                                 |   6 +-
 net/bridge/netfilter/nft_reject_bridge.c           |   6 ++
 net/ceph/osd_client.c                              |   4 +-
 net/core/dev.c                                     |  20 +++-
 net/dsa/tag_mtk.c                                  |  15 +++
 net/ipv4/inet_connection_sock.c                    |  43 ++++----
 net/ipv4/ip_vti.c                                  |  75 +++++++------
 net/ipv4/ipip.c                                    |   2 +-
 net/ipv4/netfilter/nf_nat_pptp.c                   |   7 +-
 net/ipv4/route.c                                   |  14 ++-
 net/ipv6/esp6_offload.c                            |   9 +-
 net/mac80211/mesh_hwmp.c                           |   7 ++
 net/netfilter/ipset/ip_set_list_set.c              |   2 +-
 net/netfilter/nf_conntrack_pptp.c                  |  62 ++++++-----
 net/netfilter/nfnetlink_cthelper.c                 |   3 +-
 net/qrtr/qrtr.c                                    |   2 +-
 net/sctp/sm_sideeffect.c                           |  14 ++-
 net/sctp/sm_statefuns.c                            |   9 +-
 net/xdp/xdp_umem.c                                 |   8 +-
 net/xfrm/xfrm_input.c                              |   2 +-
 net/xfrm/xfrm_interface.c                          |  21 ++++
 net/xfrm/xfrm_output.c                             |  15 +--
 net/xfrm/xfrm_policy.c                             |   7 +-
 samples/bpf/lwt_len_hist_user.c                    |   2 -
 security/commoncap.c                               |   1 +
 sound/core/hwdep.c                                 |   4 +-
 sound/pci/hda/patch_realtek.c                      |  39 +++++--
 sound/usb/mixer.c                                  |   8 ++
 sound/usb/mixer_maps.c                             |  24 +++++
 sound/usb/quirks-table.h                           |  26 +++++
 107 files changed, 724 insertions(+), 429 deletions(-)


