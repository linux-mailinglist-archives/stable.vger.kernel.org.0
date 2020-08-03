Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1ABA823A6DF
	for <lists+stable@lfdr.de>; Mon,  3 Aug 2020 14:55:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727031AbgHCMW3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Aug 2020 08:22:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:46006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727020AbgHCMW1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Aug 2020 08:22:27 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A7958204EC;
        Mon,  3 Aug 2020 12:22:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596457344;
        bh=kzAKCCmX/diwUVGna2OCQHhoBB1Nq1mlBr6EeZw23vI=;
        h=From:To:Cc:Subject:Date:From;
        b=KuYS88c1X+GdmgbMy5NNxt6+Vp/HJHLnIIPzJ1/BVzNHuwaI9/7JJub3MC4bD2VDQ
         O2qskVN9gwN/LQ6JU/L/s3brQiCL2THVPN6RngQzYaEvzFoLLHe7ui9EgXDAFCbJgg
         JnEk9YMiUXHrKWaslZsiyK157rAzksbVr1X+5oac=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 5.7 000/120] 5.7.13-rc1 review
Date:   Mon,  3 Aug 2020 14:17:38 +0200
Message-Id: <20200803121902.860751811@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-5.7.13-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.7.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.7.13-rc1
X-KernelTest-Deadline: 2020-08-05T12:19+00:00
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.7.13 release.
There are 120 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 05 Aug 2020 12:18:33 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.7.13-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.7.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.7.13-rc1

Thomas Gleixner <tglx@linutronix.de>
    x86/i8259: Use printk_deferred() to prevent deadlock

Wanpeng Li <wanpengli@tencent.com>
    KVM: SVM: Fix disable pause loop exit/pause filtering capability on SVM

Wanpeng Li <wanpengli@tencent.com>
    KVM: LAPIC: Prevent setting the tscdeadline timer if the lapic is hw disabled

Will Deacon <will@kernel.org>
    KVM: arm64: Don't inherit exec permission across page-table levels

Atish Patra <atish.patra@wdc.com>
    riscv: Parse all memory blocks to remove unusable memory

Xie He <xie.he.0141@gmail.com>
    drivers/net/wan: lapb: Corrected the usage of skb_cow

Atish Patra <atish.patra@wdc.com>
    RISC-V: Set maximum number of mapped pages correctly

Andrea Righi <andrea.righi@canonical.com>
    xen-netfront: fix potential deadlock in xennet_remove()

Navid Emamdoost <navid.emamdoost@gmail.com>
    cxgb4: add missing release on skb in uld_send()

Josh Poimboeuf <jpoimboe@redhat.com>
    x86/stacktrace: Fix reliable check for empty user task stacks

Josh Poimboeuf <jpoimboe@redhat.com>
    x86/unwind/orc: Fix ORC for newly forked tasks

Raviteja Narayanam <raviteja.narayanam@xilinx.com>
    i2c: cadence: Clear HOLD bit at correct time in Rx path

Raviteja Narayanam <raviteja.narayanam@xilinx.com>
    Revert "i2c: cadence: Fix the hold bit setting"

Paolo Pisati <paolo.pisati@canonical.com>
    selftest: txtimestamp: fix net ns entry logic

Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
    net: ethernet: ravb: exit if re-initialization fails in tx timeout

Liam Beguin <liambeguin@gmail.com>
    parisc: add support for cmpxchg on u8 pointers

Vincent Chen <vincent.chen@sifive.com>
    riscv: kasan: use local_tlb_flush_all() to avoid uninitialized __sbi_rfence

Ming Lei <ming.lei@redhat.com>
    scsi: core: Run queue in case of I/O resource contention failure

Navid Emamdoost <navid.emamdoost@gmail.com>
    nfc: s3fwrn5: add missing release on skb in s3fwrn5_recv_frame

Oded Gabbay <oded.gabbay@gmail.com>
    habanalabs: prevent possible out-of-bounds array access

Daniele Albano <d.albano@gmail.com>
    io_uring: always allow drain/link/hardlink/async sqe flags

Paolo Pisati <paolo.pisati@canonical.com>
    selftests: net: ip_defrag: modprobe missing nf_defrag_ipv6 support

Laurence Oberman <loberman@redhat.com>
    qed: Disable "MFW indication via attention" SPAM every 5 minutes

Paolo Pisati <paolo.pisati@canonical.com>
    selftests: fib_nexthop_multiprefix: fix cleanup() netns deletion

Geert Uytterhoeven <geert@linux-m68k.org>
    usb: hso: Fix debug compile warning on sparc32

Jiri Slaby <jslaby@suse.cz>
    iwlwifi: fix crash in iwl_dbg_tlv_alloc_trigger

Lorenzo Bianconi <lorenzo@kernel.org>
    mt76: mt7615: fix lmac queue debugsfs entry

Taehee Yoo <ap420073@gmail.com>
    vxlan: fix memleak of fdb

Wei Li <liwei391@huawei.com>
    perf tools: Fix record failure when mixed with ARM SPE event

Xin Xiong <xiongx18@fudan.edu.cn>
    net/mlx5e: fix bpf_prog reference count leaks in mlx5e_alloc_rq

Jianbo Liu <jianbol@mellanox.com>
    net/mlx5e: E-Switch, Add misc bit when misc fields changed for mirroring

Wang Hai <wanghai38@huawei.com>
    net: gemini: Fix missing clk_disable_unprepare() in error path of gemini_ethernet_port_probe()

Shannon Nelson <snelson@pensando.io>
    ionic: unlock queue mutex in error path

Landen Chao <landen.chao@mediatek.com>
    net: ethernet: mtk_eth_soc: fix MTU warnings

Lu Wei <luwei32@huawei.com>
    net: nixge: fix potential memory leak in nixge_probe()

Hangbin Liu <liuhangbin@gmail.com>
    selftests/bpf: fix netdevsim trap_flow_action_cookie read

Alain Michaud <alainm@chromium.org>
    Bluetooth: fix kernel oops in store_pending_adv_report

Robin Murphy <robin.murphy@arm.com>
    arm64: csum: Fix handling of bad packets

Sami Tolvanen <samitolvanen@google.com>
    arm64/alternatives: move length validation inside the subsection

Leon Romanovsky <leon@kernel.org>
    RDMA/core: Free DIM memory in error unwind

Leon Romanovsky <leon@kernel.org>
    RDMA/core: Stop DIM before destroying CQ

Remi Pommarel <repk@triplefau.lt>
    mac80211: mesh: Free pending skb when destroying a mpath

Remi Pommarel <repk@triplefau.lt>
    mac80211: mesh: Free ie data when leaving mesh

Sabrina Dubroca <sd@queasysnail.net>
    espintcp: handle short messages instead of breaking the encap socket

Andrii Nakryiko <andriin@fb.com>
    bpf: Fix map leak in HASH_OF_MAPS map

Thomas Falcon <tlfalcon@linux.ibm.com>
    ibmvnic: Fix IRQ mapping disposal in error path

Amit Cohen <amitc@mellanox.com>
    selftests: ethtool: Fix test when only two speeds are supported

Ido Schimmel <idosch@mellanox.com>
    mlxsw: spectrum_router: Fix use-after-free in router init / de-init

Ido Schimmel <idosch@mellanox.com>
    mlxsw: core: Free EMAD transactions using kfree_rcu()

Ido Schimmel <idosch@mellanox.com>
    mlxsw: core: Increase scope of RCU read-side critical section

Christoph Hellwig <hch@lst.de>
    nvme: add a Identify Namespace Identification Descriptor list quirk

Guillaume Nault <gnault@redhat.com>
    bareudp: forbid mixing IP and MPLS in multiproto mode

Subbaraya Sundeep <sbhatta@marvell.com>
    octeontx2-pf: Unregister netdev at driver remove

Subbaraya Sundeep <sbhatta@marvell.com>
    octeontx2-pf: cancel reset_task work

Subbaraya Sundeep <sbhatta@marvell.com>
    octeontx2-pf: Fix reset_task bugs

Jakub Kicinski <kuba@kernel.org>
    mlx4: disable device on shutdown

Herbert Xu <herbert@gondor.apana.org.au>
    rhashtable: Fix unprotected RCU dereference in __rht_ptr

Johan Hovold <johan@kernel.org>
    net: lan78xx: fix transfer-buffer memory leak

Johan Hovold <johan@kernel.org>
    net: lan78xx: add missing endpoint sanity check

Alaa Hleihel <alaa@mellanox.com>
    net/mlx5e: Fix kernel crash when setting vf VLANID on a VF dev

Ron Diskin <rondi@mellanox.com>
    net/mlx5e: Modify uplink state on interface up/down

Eran Ben Elisha <eranbe@mellanox.com>
    net/mlx5: Query PPS pin operational status before registering it

Eran Ben Elisha <eranbe@mellanox.com>
    net/mlx5: Verify Hardware supports requested ptp function on a given pin

Eran Ben Elisha <eranbe@mellanox.com>
    net/mlx5: Fix a bug of using ptp channel index as pin index

Aya Levin <ayal@mellanox.com>
    net/mlx5e: Fix error path of device attach

Parav Pandit <parav@mellanox.com>
    net/mlx5: E-switch, Destroy TSAR after reload interface

Parav Pandit <parav@mellanox.com>
    net/mlx5: E-switch, Destroy TSAR when fail to enable the mode

Guojia Liao <liaoguojia@huawei.com>
    net: hns3: fix for VLAN config when reset failed

Guojia Liao <liaoguojia@huawei.com>
    net: hns3: fix aRFS FD rules leftover after add a user FD rule

Jian Shen <shenjian15@huawei.com>
    net: hns3: add reset check for VF updating port based VLAN

Yonglong Liu <liuyonglong@huawei.com>
    net: hns3: fix a TX timeout issue

Yunsheng Lin <linyunsheng@huawei.com>
    net: hns3: fix desc filling bug when skb is expanded or lineared

Michael Karcher <kernel@mkarcher.dialup.fu-berlin.de>
    sh: Fix validation of system call number

Peter Zijlstra <peterz@infradead.org>
    sh/tlb: Fix PGTABLE_LEVELS > 2

Tanner Love <tannerlove@google.com>
    selftests/net: tcp_mmap: fix clang warning for target arch PowerPC

Tanner Love <tannerlove@google.com>
    selftests/net: so_txtime: fix clang issues for target arch PowerPC

Tanner Love <tannerlove@google.com>
    selftests/net: psock_fanout: fix clang issues for target arch PowerPC

Tanner Love <tannerlove@google.com>
    selftests/net: rxtimestamp: fix clang issues for target arch PowerPC

Sagi Grimberg <sagi@grimberg.me>
    nvme-tcp: fix possible hang waiting for icresp response

Russell King <rmk+kernel@armlinux.org.uk>
    ARM: dts: armada-38x: fix NETA lockup when repeatedly switching speeds

Steffen Klassert <steffen.klassert@secunet.com>
    xfrm: Fix crash when the hold queue is used.

Sabrina Dubroca <sd@queasysnail.net>
    espintcp: recv() should return 0 when the peer socket is closed

Douglas Anderson <dianders@chromium.org>
    pinctrl: qcom: Handle broken/missing PDC dual edge IRQs on sc7180

Maxime Ripard <maxime@cerno.tech>
    ARM: dts sunxi: Relax a bit the CMA pool allocation range

Xin Long <lucien.xin@gmail.com>
    xfrm: policy: match with both mark and mask on user interfaces

YueHaibing <yuehaibing@huawei.com>
    net/x25: Fix null-ptr-deref in x25_disconnect

Xiyu Yang <xiyuyang19@fudan.edu.cn>
    net/x25: Fix x25_neigh refcnt leak when x25 disconnect

Ben Hutchings <ben@decadent.org.uk>
    libtraceevent: Fix build with binutils 2.35

Peilin Ye <yepeilin.cs@gmail.com>
    rds: Prevent kernel-infoleak in rds_notify_queue_get()

Linus Torvalds <torvalds@linux-foundation.org>
    random32: remove net_rand_state from the latent entropy gcc plugin

Willy Tarreau <w@1wt.eu>
    random: fix circular include dependency on arm64 after addition of percpu.h

Biju Das <biju.das.jz@bp.renesas.com>
    drm: of: Fix double-free bug

Steve Cohen <cohens@codeaurora.org>
    drm: hold gem reference until object is no longer accessed

Linus Walleij <linus.walleij@linaro.org>
    drm/mcde: Fix stability issue

Paul Cercueil <paul@crapouillou.net>
    drm/dbi: Fix SPI Type 1 (9-bit) transfer

Peilin Ye <yepeilin.cs@gmail.com>
    drm/amdgpu: Prevent kernel-infoleak in amdgpu_info_ioctl()

Mazin Rezk <mnrzk@protonmail.com>
    drm/amd/display: Clear dm_state for fast updates

Alex Deucher <alexander.deucher@amd.com>
    Revert "drm/amdgpu: Fix NULL dereference in dpm sysfs handlers"

Grygorii Strashko <grygorii.strashko@ti.com>
    ARM: percpu.h: fix build error

Willy Tarreau <w@1wt.eu>
    random32: update the net random state on interrupt and activity

Michael S. Tsirkin <mst@redhat.com>
    virtio_balloon: fix up endian-ness for free cmd id

Michael Trimarchi <michael@amarulasolutions.com>
    ARM: dts: imx6qdl-icore: Fix OTG_ID pin and sdcard detect

Fabio Estevam <festevam@gmail.com>
    ARM: dts: imx6sx-sdb: Fix the phy-mode on fec2

Fabio Estevam <festevam@gmail.com>
    ARM: dts: imx6sx-sabreauto: Fix the phy-mode on fec2

Jaedon Shin <jaedon.shin@gmail.com>
    ARM: 8987/1: VDSO: Fix incorrect clock_gettime64

Will Deacon <will@kernel.org>
    ARM: 8986/1: hw_breakpoint: Don't invoke overflow handler on uaccess watchpoints

Paul Moore <paul@paul-moore.com>
    revert: 1320a4052ea1 ("audit: trigger accompanying records when no rules present")

Wang Hai <wanghai38@huawei.com>
    9p/trans_fd: Fix concurrency del of req_list in p9_fd_cancelled/p9_read_work

Michael S. Tsirkin <mst@redhat.com>
    vhost/scsi: fix up req type endian-ness

Mike Marciniszyn <mike.marciniszyn@intel.com>
    IB/rdmavt: Fix RQ counting issues causing use of an invalid RWQE

Jason Gunthorpe <jgg@nvidia.com>
    RDMA/mlx5: Fix prefetch memory leak if get_prefetchable_mr fails

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/hdmi: Fix keep_power assignment for non-component devices

Takashi Iwai <tiwai@suse.de>
    ALSA: hda: Workaround for spurious wakeups on some Intel platforms

Kailang Yang <kailang@realtek.com>
    ALSA: hda/realtek - Fixed HP right speaker no sound

PeiSen Hou <pshou@realtek.com>
    ALSA: hda/realtek: Fix add a "ultra_low_power" function for intel reference board (alc256)

Armas Spann <zappel@retarded.farm>
    ALSA: hda/realtek: typo_fix: enable headset mic of ASUS ROG Zephyrus G14(GA401) series with ALC289

Armas Spann <zappel@retarded.farm>
    ALSA: hda/realtek: enable headset mic of ASUS ROG Zephyrus G15(GA502) series with ALC289

Laurence Tratt <laurie@tratt.net>
    ALSA: usb-audio: Add implicit feedback quirk for SSL2

Robert Hancock <hancockrwd@gmail.com>
    PCI/ASPM: Disable ASPM on ASMedia ASM1083/1085 PCIe-to-PCI bridge

NeilBrown <neilb@suse.de>
    sunrpc: check that domain table is empty at module unload.


-------------

Diffstat:

 Makefile                                           |  4 +-
 arch/arm/boot/dts/armada-38x.dtsi                  |  3 +-
 arch/arm/boot/dts/imx6qdl-icore.dtsi               |  3 +-
 arch/arm/boot/dts/imx6sx-sabreauto.dts             |  2 +-
 arch/arm/boot/dts/imx6sx-sdb.dtsi                  |  2 +-
 arch/arm/boot/dts/sun4i-a10.dtsi                   |  2 +-
 arch/arm/boot/dts/sun5i.dtsi                       |  2 +-
 arch/arm/boot/dts/sun7i-a20.dtsi                   |  2 +-
 arch/arm/include/asm/percpu.h                      |  2 +
 arch/arm/kernel/hw_breakpoint.c                    | 27 ++++++--
 arch/arm/kernel/vdso.c                             |  1 +
 arch/arm64/include/asm/alternative.h               |  4 +-
 arch/arm64/include/asm/checksum.h                  |  5 +-
 arch/parisc/include/asm/cmpxchg.h                  |  2 +
 arch/parisc/lib/bitops.c                           | 12 ++++
 arch/riscv/mm/init.c                               | 33 ++++-----
 arch/riscv/mm/kasan_init.c                         |  4 +-
 arch/sh/include/asm/pgalloc.h                      | 10 +--
 arch/sh/kernel/entry-common.S                      |  6 +-
 arch/x86/kernel/i8259.c                            |  2 +-
 arch/x86/kernel/stacktrace.c                       |  5 --
 arch/x86/kernel/unwind_orc.c                       |  8 ++-
 arch/x86/kvm/lapic.c                               |  2 +-
 arch/x86/kvm/svm/svm.c                             |  9 ++-
 drivers/char/random.c                              |  1 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c            |  3 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_pm.c             |  9 ++-
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  | 36 +++++++---
 drivers/gpu/drm/drm_gem.c                          | 10 ++-
 drivers/gpu/drm/drm_mipi_dbi.c                     |  2 +-
 drivers/gpu/drm/drm_of.c                           |  4 +-
 drivers/gpu/drm/mcde/mcde_display.c                | 11 ++-
 drivers/i2c/busses/i2c-cadence.c                   | 28 ++++----
 drivers/infiniband/core/cq.c                       | 14 +++-
 drivers/infiniband/hw/mlx5/odp.c                   |  5 +-
 drivers/infiniband/sw/rdmavt/qp.c                  | 33 ++-------
 drivers/infiniband/sw/rdmavt/rc.c                  |  4 +-
 drivers/misc/habanalabs/command_submission.c       | 14 +++-
 drivers/net/bareudp.c                              | 29 ++++++--
 drivers/net/ethernet/chelsio/cxgb4/sge.c           |  1 +
 drivers/net/ethernet/cortina/gemini.c              |  5 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    | 18 ++---
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 35 +++++-----
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  | 38 +++++++----
 drivers/net/ethernet/ibm/ibmvnic.c                 |  2 +-
 .../net/ethernet/marvell/octeontx2/nic/otx2_pf.c   |  3 +
 .../net/ethernet/marvell/octeontx2/nic/otx2_vf.c   |  2 +
 drivers/net/ethernet/mediatek/mtk_eth_soc.c        |  2 +
 drivers/net/ethernet/mellanox/mlx4/main.c          |  2 +
 .../ethernet/mellanox/mlx5/core/en/tc_tun_geneve.c |  2 +
 .../ethernet/mellanox/mlx5/core/en/tc_tun_gre.c    |  2 +
 .../ethernet/mellanox/mlx5/core/en/tc_tun_vxlan.c  |  2 +
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  | 31 +++++++--
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   |  2 +
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    |  1 +
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c  | 27 +++++---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.h  |  2 +
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c |  6 +-
 .../net/ethernet/mellanox/mlx5/core/lib/clock.c    | 78 ++++++++++++++++++----
 drivers/net/ethernet/mellanox/mlxsw/core.c         |  8 ++-
 .../net/ethernet/mellanox/mlxsw/spectrum_router.c  | 50 +++++++-------
 drivers/net/ethernet/ni/nixge.c                    |  8 ++-
 drivers/net/ethernet/pensando/ionic/ionic_lif.c    |  4 +-
 drivers/net/ethernet/qlogic/qed/qed_int.c          |  3 +-
 drivers/net/ethernet/renesas/ravb_main.c           | 26 +++++++-
 drivers/net/usb/hso.c                              |  5 +-
 drivers/net/usb/lan78xx.c                          |  6 ++
 drivers/net/vxlan.c                                |  6 +-
 drivers/net/wan/hdlc_x25.c                         |  4 +-
 drivers/net/wan/lapbether.c                        |  8 ++-
 drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c   | 16 ++++-
 .../net/wireless/mediatek/mt76/mt7615/debugfs.c    |  9 +--
 drivers/net/xen-netfront.c                         | 64 ++++++++++++------
 drivers/nfc/s3fwrn5/core.c                         |  1 +
 drivers/nvme/host/core.c                           | 15 +----
 drivers/nvme/host/nvme.h                           |  7 ++
 drivers/nvme/host/pci.c                            |  2 +
 drivers/nvme/host/tcp.c                            |  3 +
 drivers/pci/quirks.c                               | 13 ++++
 drivers/pinctrl/qcom/Kconfig                       |  2 +
 drivers/pinctrl/qcom/pinctrl-msm.c                 | 74 +++++++++++++++++++-
 drivers/pinctrl/qcom/pinctrl-msm.h                 |  4 ++
 drivers/pinctrl/qcom/pinctrl-sc7180.c              |  1 +
 drivers/scsi/scsi_lib.c                            | 16 +++--
 drivers/vhost/scsi.c                               |  2 +-
 drivers/virtio/virtio_balloon.c                    |  6 +-
 fs/io_uring.c                                      | 13 ++--
 include/linux/mlx5/mlx5_ifc.h                      |  1 +
 include/linux/random.h                             |  3 +
 include/linux/rhashtable.h                         | 25 +++----
 include/net/xfrm.h                                 | 15 +++--
 include/rdma/rdmavt_qp.h                           | 19 ++++++
 kernel/audit.c                                     |  1 -
 kernel/audit.h                                     |  8 ---
 kernel/auditsc.c                                   |  3 +
 kernel/bpf/hashtab.c                               | 12 +++-
 kernel/time/timer.c                                |  8 +++
 lib/random32.c                                     |  2 +-
 net/9p/trans_fd.c                                  | 15 ++++-
 net/bluetooth/hci_event.c                          | 26 ++++++--
 net/key/af_key.c                                   |  4 +-
 net/mac80211/cfg.c                                 |  1 +
 net/mac80211/mesh_pathtbl.c                        |  1 +
 net/rds/recv.c                                     |  3 +-
 net/sunrpc/sunrpc.h                                |  1 +
 net/sunrpc/sunrpc_syms.c                           |  2 +
 net/sunrpc/svcauth.c                               | 25 +++++++
 net/x25/x25_subr.c                                 |  6 ++
 net/xfrm/espintcp.c                                | 30 ++++++++-
 net/xfrm/xfrm_policy.c                             | 39 +++++------
 net/xfrm/xfrm_user.c                               | 18 +++--
 sound/pci/hda/hda_controller.h                     |  2 +-
 sound/pci/hda/hda_intel.c                          | 17 ++++-
 sound/pci/hda/patch_hdmi.c                         |  2 +-
 sound/pci/hda/patch_realtek.c                      | 36 ++++++++--
 sound/usb/pcm.c                                    |  1 +
 tools/lib/traceevent/plugins/Makefile              |  2 +-
 tools/perf/arch/arm/util/auxtrace.c                |  8 +--
 tools/testing/selftests/bpf/test_offload.py        |  3 +
 .../selftests/net/fib_nexthop_multiprefix.sh       |  2 +-
 tools/testing/selftests/net/forwarding/ethtool.sh  |  2 -
 tools/testing/selftests/net/ip_defrag.sh           |  2 +
 tools/testing/selftests/net/psock_fanout.c         |  3 +-
 tools/testing/selftests/net/rxtimestamp.c          |  3 +-
 tools/testing/selftests/net/so_txtime.c            |  2 +-
 tools/testing/selftests/net/tcp_mmap.c             |  6 +-
 tools/testing/selftests/net/txtimestamp.sh         |  2 +-
 virt/kvm/arm/mmu.c                                 | 11 +--
 128 files changed, 942 insertions(+), 422 deletions(-)


