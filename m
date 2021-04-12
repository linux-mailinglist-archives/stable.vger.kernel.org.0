Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED3DE35BF1C
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 11:03:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239293AbhDLJCr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 05:02:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:54804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239811AbhDLJBX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 05:01:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DD15B61262;
        Mon, 12 Apr 2021 08:59:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618217959;
        bh=f2/XMBj5SmRszCRYwtwlIuQIVFOxD3jUB02EFl8oCiE=;
        h=From:To:Cc:Subject:Date:From;
        b=YycsOAjbUhQx5umMgzBK176UmlyCvQ39LPLxpKvnZ7DQtJE51KzRW2ALGnq0ueDtZ
         Ook2apB3hPwr9pFEzIag8+0tAjAobhhlx6ecqCizFs2Qg5jKWy/qy9G8wYbU4Jru8l
         9VECZMGWHN/3G2c1AgxZgsuhINrOVcP+03//ciXY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 5.11 000/210] 5.11.14-rc1 review
Date:   Mon, 12 Apr 2021 10:38:25 +0200
Message-Id: <20210412084016.009884719@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.11.14-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.11.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.11.14-rc1
X-KernelTest-Deadline: 2021-04-14T08:40+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.11.14 release.
There are 210 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 14 Apr 2021 08:39:44 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.11.14-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.11.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.11.14-rc1

Vlad Buslov <vladbu@nvidia.com>
    Revert "net: sched: bump refcount for new action in ACT replace mode"

Alexander Aring <aahringo@redhat.com>
    net: ieee802154: stop dump llsec params for monitors

Alexander Aring <aahringo@redhat.com>
    net: ieee802154: forbid monitor for del llsec seclevel

Alexander Aring <aahringo@redhat.com>
    net: ieee802154: forbid monitor for set llsec params

Alexander Aring <aahringo@redhat.com>
    net: ieee802154: fix nl802154 del llsec devkey

Alexander Aring <aahringo@redhat.com>
    net: ieee802154: fix nl802154 add llsec key

Alexander Aring <aahringo@redhat.com>
    net: ieee802154: fix nl802154 del llsec dev

Alexander Aring <aahringo@redhat.com>
    net: ieee802154: fix nl802154 del llsec key

Alexander Aring <aahringo@redhat.com>
    net: ieee802154: nl-mac: fix check on panid

Pavel Skripkin <paskripkin@gmail.com>
    net: mac802154: Fix general protection fault

Pavel Skripkin <paskripkin@gmail.com>
    drivers: net: fix memory leak in peak_usb_create_dev

Pavel Skripkin <paskripkin@gmail.com>
    drivers: net: fix memory leak in atusb_probe

Phillip Potter <phil@philpotter.co.uk>
    net: tun: set tun->dev->addr_len during TUNSETLINK processing

Du Cheng <ducheng2@gmail.com>
    cfg80211: remove WARN_ON() in cfg80211_sme_connect

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    gpiolib: Read "gpio-line-names" from a firmware node

Thomas Tai <thomas.tai@oracle.com>
    x86/traps: Correct exc_general_protection() and math_error() return paths

Kumar Kartikeya Dwivedi <memxor@gmail.com>
    net: sched: bump refcount for new action in ACT replace mode

Rafał Miłecki <rafal@milecki.pl>
    dt-bindings: net: ethernet-controller: fix typo in NVMEM

Arnd Bergmann <arnd@arndb.de>
    lockdep: Address clang -Wformat warning printing for %hd

Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
    clk: socfpga: fix iomem pointer cast on 64-bit

William Roche <william.roche@oracle.com>
    RAS/CEC: Correct ce_add_elem()'s returned values

Eli Cohen <elic@nvidia.com>
    vdpa/mlx5: Fix wrong use of bit numbers

Si-Wei Liu <si-wei.liu@oracle.com>
    vdpa/mlx5: should exclude header length and fcs from mtu

Leon Romanovsky <leon@kernel.org>
    RDMA/addr: Be strict with gid size

Grzegorz Siwik <grzegorz.siwik@intel.com>
    i40e: Fix parameters in aq_get_phy_register()

Dom Cobley <popcornmix@gmail.com>
    drm/vc4: crtc: Reduce PV fifo threshold on hvs4

Kamal Heib <kamalheib1@gmail.com>
    RDMA/qedr: Fix kernel panic when trying to access recv_cq

Jin Yao <yao.jin@linux.intel.com>
    perf report: Fix wrong LBR block sorting

Potnuri Bharat Teja <bharat@chelsio.com>
    RDMA/cxgb4: check for ipv6 address properly while destroying listener

Aya Levin <ayal@nvidia.com>
    net/mlx5: Fix PBMC register mapping

Aya Levin <ayal@nvidia.com>
    net/mlx5: Fix PPLM register mapping

Raed Salem <raeds@nvidia.com>
    net/mlx5: Fix placement of log_max_flow_counter

Eli Cohen <elic@nvidia.com>
    net/mlx5: Fix HW spec violation configuring uplink

Guangbin Huang <huangguangbin2@huawei.com>
    net: hns3: clear VF down state bit before request link status

Xin Long <lucien.xin@gmail.com>
    tipc: increment the tmp aead refcnt before attaching it

Hans de Goede <hdegoede@redhat.com>
    platform/x86: intel-hid: Fix spurious wakeups caused by tablet-mode events during suspend

Marc Kleine-Budde <mkl@pengutronix.de>
    can: mcp251x: fix support for half duplex SPI host controllers

Luca Coelho <luciano.coelho@intel.com>
    iwlwifi: fix 11ax disabled bit in the regulatory capability flags

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    i2c: designware: Adjust bus_freq_hz when refuse high speed mode set

Ilya Maximets <i.maximets@ovn.org>
    openvswitch: fix send of uninitialized stack memory in ct limit reply

Adrian Hunter <adrian.hunter@intel.com>
    perf inject: Fix repipe usage

Alexander Gordeev <agordeev@linux.ibm.com>
    s390/cpcmd: fix inline assembly register clobbering

Zqiang <qiang.zhang@windriver.com>
    workqueue: Move the position of debug_work_activate() in __queue_work()

Lukasz Bartosik <lb@semihalf.com>
    clk: fix invalid usage of list cursor in unregister

Lukasz Bartosik <lb@semihalf.com>
    clk: fix invalid usage of list cursor in register

Claudiu Beznea <claudiu.beznea@microchip.com>
    net: macb: restore cmp registers on resume path

Yunjian Wang <wangyunjian@huawei.com>
    net: cls_api: Fix uninitialised struct field bo->unlocked_driver_cb

Rui Salvaterra <rsalvaterra@gmail.com>
    ARM: dts: turris-omnia: fix hardware buffer management

Gregory CLEMENT <gregory.clement@bootlin.com>
    Revert "arm64: dts: marvell: armada-cp110: Switch to per-port SATA interrupts"

Kalyan Thota <kalyan_t@codeaurora.org>
    drm/msm/disp/dpu1: program 3d_merge only if block is attached

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    drm/msm: a6xx: fix version check for the A650 SQE microcode

Can Guo <cang@codeaurora.org>
    scsi: ufs: core: Fix wrong Task Tag used in task management request UPIUs

Can Guo <cang@codeaurora.org>
    scsi: ufs: core: Fix task management request completion timeout

Paolo Abeni <pabeni@redhat.com>
    mptcp: revert "mptcp: provide subflow aware release function"

Paolo Abeni <pabeni@redhat.com>
    mptcp: forbit mcast-related sockopt on MPTCP sockets

Norman Maurer <norman_maurer@apple.com>
    net: udp: Add support for getsockopt(..., ..., UDP_GRO, ..., ...);

Stephen Boyd <swboyd@chromium.org>
    drm/msm: Set drvdata to NULL when msm_drm_init() fails

Md Haris Iqbal <haris.iqbal@cloud.ionos.com>
    RDMA/rtrs-clt: Close rtrs client conn before destroying rtrs clt session files

Eryk Rybak <eryk.roch.rybak@intel.com>
    i40e: Fix display statistics for veb_tc

Magnus Karlsson <magnus.karlsson@intel.com>
    i40e: fix receiving of single packets in xsk zero-copy mode

Arnd Bergmann <arnd@arndb.de>
    soc/fsl: qbman: fix conflicting alignment attributes

Ong Boon Leong <boon.leong.ong@intel.com>
    xdp: fix xdp_return_frame() kernel BUG throw for page_pool memory model

Lv Yunlong <lyl2019@mail.ustc.edu.cn>
    net/rds: Fix a use after free in rds_message_map_pages

Tariq Toukan <tariqt@nvidia.com>
    net/mlx5e: Guarantee room for XSK wakeup NOP on async ICOSQ

Daniel Jurgens <danielj@mellanox.com>
    net/mlx5: Don't request more than supported EQs

Aya Levin <ayal@nvidia.com>
    net/mlx5e: Fix ethtool indication of connector type

Maor Dickman <maord@nvidia.com>
    net/mlx5: Delete auxiliary bus driver eth-rep first

Ariel Levkovich <lariel@nvidia.com>
    net/mlx5e: Fix mapping of ct_label zero

Bastian Germann <bage@linutronix.de>
    ASoC: sunxi: sun4i-codec: fill ASoC card owner

周琰杰 (Zhou Yanjie) <zhouyanjie@wanyeetech.com>
    I2C: JZ4780: Fix bug for Ingenic X1000.

Florian Fainelli <f.fainelli@gmail.com>
    net: phy: broadcom: Only advertise EEE for supported modes

Yinjun Zhang <yinjun.zhang@corigine.com>
    nfp: flower: ignore duplicate merge hints from FW

Loic Poulain <loic.poulain@linaro.org>
    net: qrtr: Fix memory leak on qrtr_tx_wait failure

Milton Miller <miltonm@us.ibm.com>
    net/ncsi: Avoid channel_monitor hrtimer deadlock

Stefan Riedmueller <s.riedmueller@phytec.de>
    ARM: dts: imx6: pbab01: Set vmmc supply for both SD interfaces

Lv Yunlong <lyl2019@mail.ustc.edu.cn>
    net:tipc: Fix a double free in tipc_sk_mcast_rcv

Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
    cxgb4: avoid collecting SGE_QBASE regs during traffic

Taniya Das <tdas@codeaurora.org>
    clk: qcom: camcc: Update the clock ops for the SC7180

Maxim Kochetkov <fido_max@inbox.ru>
    net: dsa: Fix type was not set for devlink port

Claudiu Manoil <claudiu.manoil@nxp.com>
    gianfar: Handle error code at MAC address change

Lv Yunlong <lyl2019@mail.ustc.edu.cn>
    ethernet: myri10ge: Fix a use after free in myri10ge_sw_tso

Ido Schimmel <idosch@nvidia.com>
    mlxsw: spectrum: Fix ECN marking in tunnel decapsulation

Marc Kleine-Budde <mkl@pengutronix.de>
    can: uapi: can.h: mark union inside struct can_frame packed

Oliver Hartkopp <socketcan@hartkopp.net>
    can: isotp: fix msg_namelen values depending on CAN_REQUIRED_SIZE

Oliver Hartkopp <socketcan@hartkopp.net>
    can: bcm/raw: fix msg_namelen values depending on CAN_REQUIRED_SIZE

Steffen Klassert <steffen.klassert@secunet.com>
    xfrm: Provide private skb extensions for segmented and hw offloaded ESP packets

Oliver Stäbler <oliver.staebler@bytesatwork.ch>
    arm64: dts: imx8mm/q: Fix pad control of SD1_DATA0

Lv Yunlong <lyl2019@mail.ustc.edu.cn>
    drivers/net/wan/hdlc_fr: Fix a double free in pvc_xmit

Eric Dumazet <edumazet@google.com>
    sch_red: fix off-by-one checks in red_check_params()

Antoine Tenart <atenart@kernel.org>
    geneve: do not modify the shared tunnel info when PMTU triggers an ICMP reply

Antoine Tenart <atenart@kernel.org>
    vxlan: do not modify the shared tunnel info when PMTU triggers an ICMP reply

Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
    amd-xgbe: Update DMA coherency values

Al Viro <viro@zeniv.linux.org.uk>
    hostfs: fix memory handling in follow_link()

Eryk Rybak <eryk.roch.rybak@intel.com>
    i40e: Fix kernel oops when i40e driver removes VF's

Mateusz Palczewski <mateusz.palczewski@intel.com>
    i40e: Added Asym_Pause to supported link modes

Norbert Ciosek <norbertx.ciosek@intel.com>
    virtchnl: Fix layout of RSS structures

Steffen Klassert <steffen.klassert@secunet.com>
    xfrm: Fix NULL pointer dereference on policy lookup

Shengjiu Wang <shengjiu.wang@nxp.com>
    ASoC: wm8960: Fix wrong bclk and lrclk with pll enabled for some chips

Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>
    ASoC: SOF: Intel: HDA: fix core status verification

Xin Long <lucien.xin@gmail.com>
    esp: delete NETIF_F_SCTP_CRC bit from features for esp offload

Ahmed S. Darwish <a.darwish@linutronix.de>
    net: xfrm: Localize sequence counter per network namespace

Suman Anna <s-anna@ti.com>
    remoteproc: pru: Fix firmware loading crashes on K3 SoCs

Carlos Leija <cileija@ti.com>
    ARM: OMAP4: PM: update ROM return address for OSWR and OFF

Tony Lindgren <tony@atomide.com>
    ARM: OMAP4: Fix PMIC voltage domains for bionic

Geert Uytterhoeven <geert+renesas@glider.be>
    regulator: bd9571mwv: Fix AVS and DVFS voltage range

Arnd Bergmann <arnd@arndb.de>
    remoteproc: qcom: pil_info: avoid 64-bit division

Evan Nimmo <evan.nimmo@alliedtelesis.co.nz>
    xfrm: Use actual socket sk instead of skb socket for xfrm_output_resume

Eyal Birger <eyal.birger@gmail.com>
    xfrm: interface: fix ipv4 pmtu check to honor ip header df

Chinh T Cao <chinh.t.cao@intel.com>
    ice: Recognize 860 as iSCSI port in CEE mode

Chinh T Cao <chinh.t.cao@intel.com>
    ice: Refactor DCB related variables out of the ice_port_info struct

Vlad Buslov <vladbu@nvidia.com>
    net: sched: fix err handler in tcf_action_init()

Paolo Bonzini <pbonzini@redhat.com>
    KVM: x86/mmu: preserve pending TLB flush across calls to kvm_tdp_mmu_zap_sp

Sean Christopherson <seanjc@google.com>
    KVM: x86/mmu: Don't allow TDP MMU to yield when recovering NX pages

Sean Christopherson <seanjc@google.com>
    KVM: x86/mmu: Ensure TLBs are flushed for TDP MMU during NX zapping

Sean Christopherson <seanjc@google.com>
    KVM: x86/mmu: Ensure TLBs are flushed when yielding during GFN range zap

Ben Gardon <bgardon@google.com>
    KVM: x86/mmu: Yield in TDU MMU iter even if no SPTES changed

Ben Gardon <bgardon@google.com>
    KVM: x86/mmu: Ensure forward progress when yielding in TDP MMU iter

Ben Gardon <bgardon@google.com>
    KVM: x86/mmu: Rename goal_gfn to next_last_level_gfn

Ben Gardon <bgardon@google.com>
    KVM: x86/mmu: Merge flush and non-flush tdp_mmu_iter_cond_resched

Ben Gardon <bgardon@google.com>
    KVM: x86/mmu: change TDP MMU yield function returns to match cond_resched

Christophe Leroy <christophe.leroy@csgroup.eu>
    powerpc/ptrace: Don't return error when getting/setting FP regs without CONFIG_PPC_FPU_REGS

Christophe Leroy <christophe.leroy@csgroup.eu>
    powerpc/vdso: Make sure vdso_wrapper.o is rebuilt everytime vdso.so is rebuilt

Wolfram Sang <wsa+renesas@sang-engineering.com>
    i2c: turn recovery error on init to debug

Roman Gushchin <guro@fb.com>
    percpu: make pcpu_nr_empty_pop_pages per chunk type

Roman Bolshakov <r.bolshakov@yadro.com>
    scsi: target: iscsi: Fix zero tag inside a trace event

Viswas G <Viswas.G@microchip.com>
    scsi: pm80xx: Fix chip initialization failure

Saravana Kannan <saravanak@google.com>
    driver core: Fix locking bug in deferred_probe_timeout_work_func()

Shuah Khan <skhan@linuxfoundation.org>
    usbip: synchronize event handler with sysfs code paths

Shuah Khan <skhan@linuxfoundation.org>
    usbip: vudc synchronize sysfs code paths

Shuah Khan <skhan@linuxfoundation.org>
    usbip: stub-dev synchronize sysfs code paths

Shuah Khan <skhan@linuxfoundation.org>
    usbip: add sysfs_lock to synchronize sysfs code paths

Dan Carpenter <dan.carpenter@oracle.com>
    thunderbolt: Fix off by one in tb_port_find_retimer()

Dan Carpenter <dan.carpenter@oracle.com>
    thunderbolt: Fix a leak in tb_retimer_add()

Paolo Abeni <pabeni@redhat.com>
    net: let skb_orphan_partial wake-up waiters.

Maciej Żenczykowski <maze@google.com>
    net-ipv6: bugfix - raw & sctp - switch to ipv6_can_nonlocal_bind()

Kurt Kanzenbach <kurt@linutronix.de>
    net: hsr: Reset MAC header for Tx path

Johannes Berg <johannes.berg@intel.com>
    mac80211: fix TXQ AC confusion

Ben Greear <greearb@candelatech.com>
    mac80211: fix time-is-after bug in mlme

Johannes Berg <johannes.berg@intel.com>
    cfg80211: check S1G beacon compat element length

Johannes Berg <johannes.berg@intel.com>
    nl80211: fix potential leak of ACL params

Johannes Berg <johannes.berg@intel.com>
    nl80211: fix beacon head validation

Vlad Buslov <vladbu@nvidia.com>
    net: sched: fix action overwrite reference counting

Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
    net: sched: sch_teql: fix null-pointer dereference

Eli Cohen <elic@nvidia.com>
    vdpa/mlx5: Fix suspend/resume index restoration

Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
    i40e: Fix sparse errors in i40e_txrx.c

Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
    i40e: Fix sparse error: uninitialized symbol 'ring'

Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
    i40e: Fix sparse error: 'vsi->netdev' could be null

Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
    i40e: Fix sparse warning: missing error code 'err'

Eric Dumazet <edumazet@google.com>
    virtio_net: Do not pull payload in skb->head

Eric Dumazet <edumazet@google.com>
    net: ensure mac header is set in virtio_net_hdr_to_skb()

John Fastabend <john.fastabend@gmail.com>
    bpf, sockmap: Fix incorrect fwd_alloc accounting

John Fastabend <john.fastabend@gmail.com>
    bpf, sockmap: Fix sk->prot unhash op reset

Dave Marchevsky <davemarchevsky@fb.com>
    bpf: Refcount task stack in bpf_get_task_stack

Ciara Loftus <ciara.loftus@intel.com>
    libbpf: Only create rx and tx XDP rings when necessary

Ciara Loftus <ciara.loftus@intel.com>
    libbpf: Restore umem state after socket create failure

Ciara Loftus <ciara.loftus@intel.com>
    libbpf: Ensure umem pointer is non-NULL before dereferencing

Lv Yunlong <lyl2019@mail.ustc.edu.cn>
    ethernet/netronome/nfp: Fix a use after free in nfp_bpf_ctrl_msg_rx

Lorenz Bauer <lmb@cloudflare.com>
    bpf: link: Refuse non-O_RDWR flags in BPF_OBJ_GET

Toke Høiland-Jørgensen <toke@redhat.com>
    bpf: Enforce that struct_ops programs be GPL-only

Pedro Tammela <pctammela@gmail.com>
    libbpf: Fix bail out from 'ringbuf_process_ring()' on error

Anirudh Rayabharam <mail@anirudhrb.com>
    net: hso: fix null-ptr-deref during tty device unregistration

Yongxin Liu <yongxin.liu@windriver.com>
    ice: fix memory leak of aRFS after resuming from suspend

Johannes Berg <johannes.berg@intel.com>
    iwlwifi: pcie: properly set LTR workarounds on 22000 devices

Robert Malz <robertx.malz@intel.com>
    ice: Cleanup fltr list in case of allocation issues

Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
    ice: Use port number instead of PF ID for WoL

Jacek Bułatek <jacekx.bulatek@intel.com>
    ice: Fix for dereference of NULL pointer

Dave Ertman <david.m.ertman@intel.com>
    ice: remove DCBNL_DEVRESET bit from PF state

Bruce Allan <bruce.w.allan@intel.com>
    ice: fix memory allocation call

Krzysztof Goreczny <krzysztof.goreczny@intel.com>
    ice: prevent ice_open and ice_stop during reset

Fabio Pricoco <fabio.pricoco@intel.com>
    ice: Increase control queue timeout

Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
    ice: Continue probe on link/PHY errors

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    batman-adv: initialize "struct batadv_tvlv_tt_vlan_data"->reserved field

Marek Behún <kabel@kernel.org>
    ARM: dts: turris-omnia: configure LED[2]/INTn pin as interrupt pin

Gao Xiang <hsiangkao@redhat.com>
    parisc: avoid a warning on u8 cast for cmpxchg on u8 pointers

Helge Deller <deller@gmx.de>
    parisc: parisc-agp requires SBA IOMMU driver

Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
    of: property: fw_devlink: do not link ".*,nr-gpios"

Wong Vee Khee <vee.khee.wong@linux.intel.com>
    ethtool: fix incorrect datatype in set_eee ops

Jack Qiu <jack.qiu@huawei.com>
    fs: direct-io: fix missing sdio->boundary

Wengang Wang <wen.gang.wang@oracle.com>
    ocfs2: fix deadlock between setattr and dio_end_io_write

Mike Rapoport <rppt@kernel.org>
    nds32: flush_dcache_page: use page_mapping_file to avoid races with swapoff

Sergei Trofimovich <slyfox@gentoo.org>
    ia64: fix user_stack_pointer() for ptrace()

Nick Desaulniers <ndesaulniers@google.com>
    gcov: re-fix clang-11+ support

Al Viro <viro@zeniv.linux.org.uk>
    LOOKUP_MOUNTPOINT: we are cleaning "jumped" flag too late

Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>
    IB/hfi1: Fix probe time panic when AIP is enabled with a buggy BIOS

Shyam Prasad N <sprasad@microsoft.com>
    cifs: On cifs_reconnect, resolve the hostname again.

Maciek Borzecki <maciek.borzecki@gmail.com>
    cifs: escape spaces in share names

Johannes Berg <johannes.berg@intel.com>
    rfkill: revert back to old userspace API by default

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/smu7: fix CAC setting on TOPAZ

xinhui pan <xinhui.pan@amd.com>
    drm/amdgpu: Fix size overflow

xinhui pan <xinhui.pan@amd.com>
    drm/radeon: Fix size overflow

Vitaly Kuznetsov <vkuznets@redhat.com>
    ACPI: processor: Fix build when CONFIG_ACPI_PROCESSOR=m

Takashi Iwai <tiwai@suse.de>
    drm/i915: Fix invalid access to ACPI _DSM objects

Martin Blumenstingl <martin.blumenstingl@googlemail.com>
    net: dsa: lantiq_gswip: Configure all remaining GSWIP_MII_CFG bits

Martin Blumenstingl <martin.blumenstingl@googlemail.com>
    net: dsa: lantiq_gswip: Don't use PHY auto polling

Martin Blumenstingl <martin.blumenstingl@googlemail.com>
    net: dsa: lantiq_gswip: Let GSWIP automatically set the xMII clock

Muhammad Usama Anjum <musamaanjum@gmail.com>
    net: ipv6: check for validity before dereferencing cfg->fc_nlinfo.nlh

Luca Fancellu <luca.fancellu@arm.com>
    xen/evtchn: Change irq_info lock to raw_spinlock_t

Ondrej Mosnacek <omosnace@redhat.com>
    selinux: fix race between old and new sidtab

Ondrej Mosnacek <omosnace@redhat.com>
    selinux: fix cond_list corruption when changing booleans

Ondrej Mosnacek <omosnace@redhat.com>
    selinux: make nslot handling in avtab more robust

Xiaoming Ni <nixiaoming@huawei.com>
    nfc: Avoid endless loops caused by repeated llcp_sock_connect()

Xiaoming Ni <nixiaoming@huawei.com>
    nfc: fix memory leak in llcp_sock_connect()

Xiaoming Ni <nixiaoming@huawei.com>
    nfc: fix refcount leak in llcp_sock_connect()

Xiaoming Ni <nixiaoming@huawei.com>
    nfc: fix refcount leak in llcp_sock_bind()

Hans de Goede <hdegoede@redhat.com>
    ASoC: intel: atom: Stop advertising non working S24LE support

Christian Brauner <christian.brauner@ubuntu.com>
    file: fix close_range() for unshare+cloexec

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/conexant: Apply quirk for another HP ZBook G5 model

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/realtek: Fix speaker amp setup on Acer Aspire E1

Jonas Holmberg <jonashg@axis.com>
    ALSA: aloop: Fix initialization of controls

Dmitry Safonov <0x7f454c46@gmail.com>
    xfrm/compat: Cleanup WARN()s that can be user-triggered


-------------

Diffstat:

 .../bindings/net/ethernet-controller.yaml          |   2 +-
 Makefile                                           |   4 +-
 arch/arm/boot/dts/armada-385-turris-omnia.dts      |   4 +-
 arch/arm/boot/dts/imx6qdl-phytec-pfla02.dtsi       |   2 +
 arch/arm/mach-omap2/omap-secure.c                  |  39 +++++
 arch/arm/mach-omap2/omap-secure.h                  |   1 +
 arch/arm/mach-omap2/pmic-cpcap.c                   |   4 +-
 arch/arm64/boot/dts/freescale/imx8mm-pinfunc.h     |   2 +-
 arch/arm64/boot/dts/freescale/imx8mq-pinfunc.h     |   2 +-
 arch/arm64/boot/dts/marvell/armada-cp11x.dtsi      |   6 +-
 arch/ia64/include/asm/ptrace.h                     |   8 +-
 arch/nds32/mm/cacheflush.c                         |   2 +-
 arch/parisc/include/asm/cmpxchg.h                  |   2 +-
 arch/powerpc/kernel/Makefile                       |   4 +
 arch/powerpc/kernel/ptrace/Makefile                |   4 +-
 arch/powerpc/kernel/ptrace/ptrace-decl.h           |  14 --
 arch/powerpc/kernel/ptrace/ptrace-fpu.c            |  10 ++
 arch/powerpc/kernel/ptrace/ptrace-novsx.c          |   8 +
 arch/powerpc/kernel/ptrace/ptrace-view.c           |   2 -
 arch/s390/kernel/cpcmd.c                           |   6 +-
 arch/x86/include/asm/smp.h                         |   2 +-
 arch/x86/kernel/smpboot.c                          |  26 ++-
 arch/x86/kernel/traps.c                            |   4 +-
 arch/x86/kvm/mmu/mmu.c                             |  13 +-
 arch/x86/kvm/mmu/tdp_iter.c                        |  30 +---
 arch/x86/kvm/mmu/tdp_iter.h                        |  11 +-
 arch/x86/kvm/mmu/tdp_mmu.c                         |  99 +++++++----
 arch/x86/kvm/mmu/tdp_mmu.h                         |  18 +-
 drivers/acpi/processor_idle.c                      |   4 +-
 drivers/base/dd.c                                  |   8 +-
 drivers/char/agp/Kconfig                           |   2 +-
 drivers/clk/clk.c                                  |  47 +++--
 drivers/clk/qcom/camcc-sc7180.c                    |  50 +++---
 drivers/clk/socfpga/clk-gate.c                     |   2 +-
 drivers/gpio/gpiolib.c                             |  12 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c            |   2 +-
 .../gpu/drm/amd/pm/powerplay/hwmgr/smu7_hwmgr.c    |   3 +-
 drivers/gpu/drm/i915/display/intel_acpi.c          |  22 ++-
 drivers/gpu/drm/msm/adreno/a6xx_gpu.c              |   6 +-
 drivers/gpu/drm/msm/disp/dpu1/dpu_hw_ctl.c         |   4 +-
 drivers/gpu/drm/msm/msm_drv.c                      |   1 +
 drivers/gpu/drm/radeon/radeon_ttm.c                |   4 +-
 drivers/gpu/drm/vc4/vc4_crtc.c                     |  17 ++
 drivers/i2c/busses/i2c-designware-master.c         |   1 +
 drivers/i2c/busses/i2c-jz4780.c                    |   4 +-
 drivers/i2c/i2c-core-base.c                        |   7 +-
 drivers/infiniband/core/addr.c                     |   4 +-
 drivers/infiniband/hw/cxgb4/cm.c                   |   3 +-
 drivers/infiniband/hw/hfi1/affinity.c              |  21 +--
 drivers/infiniband/hw/hfi1/hfi.h                   |   1 +
 drivers/infiniband/hw/hfi1/init.c                  |  10 +-
 drivers/infiniband/hw/hfi1/netdev_rx.c             |   3 +-
 drivers/infiniband/hw/qedr/verbs.c                 |   3 +-
 drivers/infiniband/ulp/rtrs/rtrs-clt.c             |   2 +-
 drivers/net/can/spi/mcp251x.c                      |  24 ++-
 drivers/net/can/usb/peak_usb/pcan_usb_core.c       |   6 +-
 drivers/net/dsa/lantiq_gswip.c                     | 195 ++++++++++++++++++---
 drivers/net/ethernet/amd/xgbe/xgbe.h               |   6 +-
 drivers/net/ethernet/cadence/macb_main.c           |   7 +
 drivers/net/ethernet/chelsio/cxgb4/cudbg_lib.c     |  23 ++-
 drivers/net/ethernet/chelsio/cxgb4/t4_hw.c         |   3 +-
 drivers/net/ethernet/freescale/gianfar.c           |   6 +-
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  |   4 +-
 drivers/net/ethernet/intel/i40e/i40e.h             |   1 +
 drivers/net/ethernet/intel/i40e/i40e_debugfs.c     |   3 +
 drivers/net/ethernet/intel/i40e/i40e_ethtool.c     |  55 +++++-
 drivers/net/ethernet/intel/i40e/i40e_main.c        |  11 +-
 drivers/net/ethernet/intel/i40e/i40e_txrx.c        |  12 +-
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c |   9 +
 drivers/net/ethernet/intel/i40e/i40e_xsk.c         |   4 +-
 drivers/net/ethernet/intel/ice/ice.h               |   4 +-
 drivers/net/ethernet/intel/ice/ice_common.c        |   2 +-
 drivers/net/ethernet/intel/ice/ice_controlq.h      |   4 +-
 drivers/net/ethernet/intel/ice/ice_dcb.c           |  76 +++++---
 drivers/net/ethernet/intel/ice/ice_dcb_lib.c       |  47 ++---
 drivers/net/ethernet/intel/ice/ice_dcb_nl.c        |  52 +++---
 drivers/net/ethernet/intel/ice/ice_ethtool.c       |   8 +-
 drivers/net/ethernet/intel/ice/ice_lib.c           |   7 +-
 drivers/net/ethernet/intel/ice/ice_main.c          |  53 ++++--
 drivers/net/ethernet/intel/ice/ice_switch.c        |  15 +-
 drivers/net/ethernet/intel/ice/ice_txrx.c          |   2 +-
 drivers/net/ethernet/intel/ice/ice_type.h          |  17 +-
 drivers/net/ethernet/mellanox/mlx5/core/dev.c      |   4 +-
 drivers/net/ethernet/mellanox/mlx5/core/en.h       |   1 +
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c |  36 +++-
 drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h  |   6 +
 .../ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c |  18 +-
 .../net/ethernet/mellanox/mlx5/core/en_ethtool.c   |  22 +--
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |  21 ++-
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   |   5 +-
 drivers/net/ethernet/mellanox/mlx5/core/eq.c       |  13 +-
 drivers/net/ethernet/mellanox/mlxsw/spectrum.h     |  15 ++
 .../net/ethernet/mellanox/mlxsw/spectrum_ipip.c    |   7 +-
 drivers/net/ethernet/mellanox/mlxsw/spectrum_nve.c |   7 +-
 drivers/net/ethernet/myricom/myri10ge/myri10ge.c   |   2 +-
 drivers/net/ethernet/netronome/nfp/bpf/cmsg.c      |   1 +
 drivers/net/ethernet/netronome/nfp/flower/main.h   |   8 +
 .../net/ethernet/netronome/nfp/flower/metadata.c   |  16 +-
 .../net/ethernet/netronome/nfp/flower/offload.c    |  48 ++++-
 drivers/net/geneve.c                               |  24 ++-
 drivers/net/ieee802154/atusb.c                     |   1 +
 drivers/net/phy/bcm-phy-lib.c                      |  13 +-
 drivers/net/tun.c                                  |  48 +++++
 drivers/net/usb/hso.c                              |  33 ++--
 drivers/net/virtio_net.c                           |  10 +-
 drivers/net/vxlan.c                                |  18 +-
 drivers/net/wan/hdlc_fr.c                          |   5 +-
 drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c |   2 +-
 .../wireless/intel/iwlwifi/pcie/ctxt-info-gen3.c   |  31 +---
 .../net/wireless/intel/iwlwifi/pcie/ctxt-info.c    |   3 +-
 .../net/wireless/intel/iwlwifi/pcie/trans-gen2.c   |  35 ++++
 drivers/of/property.c                              |  11 +-
 drivers/platform/x86/intel-hid.c                   |  16 +-
 drivers/ras/cec.c                                  |  15 +-
 drivers/regulator/bd9571mwv-regulator.c            |   4 +-
 drivers/remoteproc/pru_rproc.c                     |   2 +-
 drivers/remoteproc/qcom_pil_info.c                 |   2 +-
 drivers/scsi/pm8001/pm8001_hwi.c                   |   8 +-
 drivers/scsi/ufs/ufshcd.c                          |  31 ++--
 drivers/soc/fsl/qbman/qman.c                       |   2 +-
 drivers/target/iscsi/iscsi_target.c                |   3 +-
 drivers/thunderbolt/retimer.c                      |   4 +-
 drivers/usb/usbip/stub_dev.c                       |  11 +-
 drivers/usb/usbip/usbip_common.h                   |   3 +
 drivers/usb/usbip/usbip_event.c                    |   2 +
 drivers/usb/usbip/vhci_hcd.c                       |   1 +
 drivers/usb/usbip/vhci_sysfs.c                     |  30 +++-
 drivers/usb/usbip/vudc_dev.c                       |   1 +
 drivers/usb/usbip/vudc_sysfs.c                     |   5 +
 drivers/vdpa/mlx5/core/mlx5_vdpa.h                 |   4 +
 drivers/vdpa/mlx5/net/mlx5_vnet.c                  |  40 +++--
 drivers/xen/events/events_base.c                   |  12 +-
 fs/cifs/Kconfig                                    |   3 +-
 fs/cifs/Makefile                                   |   5 +-
 fs/cifs/cifsfs.c                                   |   3 +-
 fs/cifs/connect.c                                  |  17 +-
 fs/direct-io.c                                     |   5 +-
 fs/file.c                                          |  21 ++-
 fs/hostfs/hostfs_kern.c                            |   7 +-
 fs/namei.c                                         |   8 +-
 fs/ocfs2/aops.c                                    |  11 +-
 fs/ocfs2/file.c                                    |   8 +-
 include/linux/avf/virtchnl.h                       |   2 -
 include/linux/mlx5/mlx5_ifc.h                      |  10 +-
 include/linux/skmsg.h                              |   7 +-
 include/linux/virtio_net.h                         |  16 +-
 include/net/act_api.h                              |  12 +-
 include/net/netns/xfrm.h                           |   4 +-
 include/net/red.h                                  |   4 +-
 include/net/sock.h                                 |   9 +
 include/net/xfrm.h                                 |   4 +-
 include/uapi/linux/can.h                           |   2 +-
 include/uapi/linux/rfkill.h                        |  80 +++++++--
 kernel/bpf/inode.c                                 |   2 +-
 kernel/bpf/stackmap.c                              |  12 +-
 kernel/bpf/verifier.c                              |   5 +
 kernel/gcov/clang.c                                |  29 +--
 kernel/locking/lockdep.c                           |   2 +-
 kernel/workqueue.c                                 |   2 +-
 mm/percpu-internal.h                               |   2 +-
 mm/percpu-stats.c                                  |   9 +-
 mm/percpu.c                                        |  14 +-
 net/batman-adv/translation-table.c                 |   2 +
 net/can/bcm.c                                      |  10 +-
 net/can/isotp.c                                    |  11 +-
 net/can/raw.c                                      |  14 +-
 net/core/skmsg.c                                   |  12 +-
 net/core/sock.c                                    |  12 +-
 net/core/xdp.c                                     |   3 +-
 net/dsa/dsa2.c                                     |   8 +-
 net/ethtool/eee.c                                  |   4 +-
 net/hsr/hsr_device.c                               |   1 +
 net/hsr/hsr_forward.c                              |   6 -
 net/ieee802154/nl-mac.c                            |   7 +-
 net/ieee802154/nl802154.c                          |  23 ++-
 net/ipv4/ah4.c                                     |   2 +-
 net/ipv4/esp4.c                                    |   2 +-
 net/ipv4/esp4_offload.c                            |  17 +-
 net/ipv4/udp.c                                     |   4 +
 net/ipv6/ah6.c                                     |   2 +-
 net/ipv6/esp6.c                                    |   2 +-
 net/ipv6/esp6_offload.c                            |  17 +-
 net/ipv6/raw.c                                     |   2 +-
 net/ipv6/route.c                                   |   8 +-
 net/mac80211/mlme.c                                |   5 +-
 net/mac80211/tx.c                                  |   2 +-
 net/mac802154/llsec.c                              |   2 +-
 net/mptcp/protocol.c                               | 100 +++++------
 net/ncsi/ncsi-manage.c                             |  20 ++-
 net/nfc/llcp_sock.c                                |  10 ++
 net/openvswitch/conntrack.c                        |   8 +-
 net/qrtr/qrtr.c                                    |   5 +-
 net/rds/message.c                                  |   3 +-
 net/rfkill/core.c                                  |   7 +-
 net/sched/act_api.c                                |  48 +++--
 net/sched/cls_api.c                                |  16 +-
 net/sched/sch_teql.c                               |   3 +
 net/sctp/ipv6.c                                    |   7 +-
 net/tipc/crypto.c                                  |   3 +-
 net/tipc/socket.c                                  |   2 +-
 net/wireless/nl80211.c                             |  10 +-
 net/wireless/scan.c                                |  14 +-
 net/wireless/sme.c                                 |   2 +-
 net/xfrm/xfrm_compat.c                             |  12 +-
 net/xfrm/xfrm_device.c                             |   2 -
 net/xfrm/xfrm_interface.c                          |   3 +
 net/xfrm/xfrm_output.c                             |  10 +-
 net/xfrm/xfrm_state.c                              |  10 +-
 security/selinux/ss/avtab.c                        | 101 ++++-------
 security/selinux/ss/avtab.h                        |   2 +-
 security/selinux/ss/conditional.c                  |  12 +-
 security/selinux/ss/services.c                     | 157 +++++++++++++----
 security/selinux/ss/sidtab.c                       |  21 +++
 security/selinux/ss/sidtab.h                       |   4 +
 sound/drivers/aloop.c                              |  11 +-
 sound/pci/hda/patch_conexant.c                     |   1 +
 sound/pci/hda/patch_realtek.c                      |  16 ++
 sound/soc/codecs/wm8960.c                          |   8 +-
 sound/soc/intel/atom/sst-mfld-platform-pcm.c       |   6 +-
 sound/soc/sof/intel/hda-dsp.c                      |  15 +-
 sound/soc/sunxi/sun4i-codec.c                      |   5 +
 tools/lib/bpf/ringbuf.c                            |   2 +-
 tools/lib/bpf/xsk.c                                |  57 +++---
 tools/perf/builtin-inject.c                        |   2 +-
 tools/perf/util/block-info.c                       |   6 +-
 225 files changed, 2075 insertions(+), 1027 deletions(-)


