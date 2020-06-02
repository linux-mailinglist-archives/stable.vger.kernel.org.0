Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B3D61EB98B
	for <lists+stable@lfdr.de>; Tue,  2 Jun 2020 12:26:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727818AbgFBKZg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jun 2020 06:25:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:34834 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727070AbgFBKYX (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Jun 2020 06:24:23 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 740B5206E2;
        Tue,  2 Jun 2020 10:24:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591093462;
        bh=MTP7aLHjIpXfYB9fhSLk8zdlVlrOy1VyPsfVGo4h/tA=;
        h=From:To:Cc:Subject:Date:From;
        b=SvadjrxjwAI1SemtkyukLPytAPNeSJ2FQwhQgBzUtv+20EBqmgcx4SoIXv4XzhXWK
         CG8CBwqlcMiWrMI/mRP8Opvyskv9LZD8PGyj1plWyGm1XM0Tq2ORgw1HOU3Cg+1I/+
         BI18yLJqrlli7JrnFt66lkkxaFQyj1YO2tcQjQug=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 5.6 000/174] 5.6.16-rc2 review
Date:   Tue,  2 Jun 2020 12:24:19 +0200
Message-Id: <20200602101934.141130356@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-5.6.16-rc2.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.6.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.6.16-rc2
X-KernelTest-Deadline: 2020-06-04T10:19+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.6.16 release.
There are 174 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 04 Jun 2020 10:16:52 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.6.16-rc2.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.6.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.6.16-rc2

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_conntrack_pptp: fix compilation warning with W=1 build

Nathan Chancellor <natechancellor@gmail.com>
    netfilter: conntrack: Pass value of ctinfo to __nf_conntrack_update

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: conntrack: comparison of unsigned in cthelper confirmation

Petr Mladek <pmladek@suse.com>
    powerpc/bpf: Enable bpf_probe_read{, str}() on powerpc again

Qiushi Wu <wu000273@umn.edu>
    bonding: Fix reference count leak in bond_sysfs_slave_add.

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dsa: declare lockless TX feature for slave ports

David Ahern <dsahern@gmail.com>
    ipv4: nexthop version of fib_info_nh_uses_dev

David Ahern <dsahern@gmail.com>
    nexthop: Expand nexthop_is_multipath in a few places

Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
    nexthops: don't modify published nexthop groups

David Ahern <dsahern@gmail.com>
    nexthops: Move code from remove_nexthop_from_groups to remove_nh_grp_entry

Eric Dumazet <edumazet@google.com>
    crypto: chelsio/chtls: properly set tp->lsndtime

Qiushi Wu <wu000273@umn.edu>
    qlcnic: fix missing release in qlcnic_83xx_interrupt_test.

Björn Töpel <bjorn.topel@intel.com>
    xsk: Add overflow check for u64 division, stored into u32

Jay Lang <jaytlang@mit.edu>
    x86/ioperm: Prevent a memory leak when fork fails

Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>
    ieee80211: Fix incorrect mask for default PE duration

Edwin Peer <edwin.peer@broadcom.com>
    bnxt_en: fix firmware message length endianness

Michael Chan <michael.chan@broadcom.com>
    bnxt_en: Fix accumulation of bp->net_stats_prev.

Xin Long <lucien.xin@gmail.com>
    esp6: get the right proto for transport mode in esp6_gso_encap

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_conntrack_pptp: prevent buffer overflows in debug code

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nfnetlink_cthelper: unbreak userspace helper support

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: conntrack: make conntrack userspace helpers work again

Phil Sutter <phil@nwl.cc>
    netfilter: ipset: Fix subcounter update skip

Michael Braun <michael-dev@fami-braun.de>
    netfilter: nft_reject_bridge: enable reject with bridge vlan

Xin Long <lucien.xin@gmail.com>
    ip_vti: receive ipip packet by calling ip_tunnel_rcv

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

Sabrina Dubroca <sd@queasysnail.net>
    xfrm: espintcp: save and call old ->sk_destruct

Xin Long <lucien.xin@gmail.com>
    xfrm: remove the xfrm_state_put call becofe going to out_reset

Xin Long <lucien.xin@gmail.com>
    xfrm: do pskb_pull properly in __xfrm_transport_prep

Xin Long <lucien.xin@gmail.com>
    xfrm: allow to accept packets with ipv6 NEXTHDR_HOP in xfrm_input

Al Viro <viro@zeniv.linux.org.uk>
    copy_xstate_to_kernel(): don't leave parts of destination uninitialized

Alexander Dahl <post@lespocky.de>
    x86/dma: Fix max PFN arithmetic overflow on 32 bit systems

Linus Lüssing <ll@simonwunderlich.de>
    mac80211: mesh: fix discovery timer re-arming issue / crash

Johannes Berg <johannes.berg@intel.com>
    cfg80211: fix debugfs rename crash

Helge Deller <deller@gmx.de>
    parisc: Fix kernel panic in mem_init()

Qiushi Wu <wu000273@umn.edu>
    iommu: Fix reference count leak in iommu_group_alloc.

Linus Walleij <linus.walleij@linaro.org>
    gpio: fix locking open drain IRQ lines

Jens Axboe <axboe@kernel.dk>
    Revert "block: end bio with BLK_STS_AGAIN in case of non-mq devs and REQ_NOWAIT"

Arnd Bergmann <arnd@arndb.de>
    include/asm-generic/topology.h: guard cpumask_of_node() macro argument

Alexander Potapenko <glider@google.com>
    fs/binfmt_elf.c: allocate initialized memory in fill_thread_core_info()

Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
    mm: remove VM_BUG_ON(PageSlab()) from page_mapcount()

Hugh Dickins <hughd@google.com>
    mm,thp: stop leaking unreleased file pages

Valentine Fatiev <valentinef@mellanox.com>
    IB/ipoib: Fix double free of skb in case of multicast traffic in CM mode

Aric Cyr <aric.cyr@amd.com>
    drm/amd/display: Fix potential integer wraparound resulting in a hang

Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
    drm/amd/display: Defer cursor lock until after VUPDATE

Aric Cyr <aric.cyr@amd.com>
    drm/amd/display: Use cursor locking to prevent flip delays

Anthony Koo <Anthony.Koo@amd.com>
    drm/amd/display: Added locking for atomic update stream and update planes

Anthony Koo <Anthony.Koo@amd.com>
    drm/amd/display: Indicate dsc updates explicitly

Anthony Koo <Anthony.Koo@amd.com>
    drm/amd/display: Split program front end part that occur outside lock

Simon Ser <contact@emersion.fr>
    drm/amd/display: drop cursor position check in atomic test

Jason Gunthorpe <jgg@ziepe.ca>
    RDMA/core: Fix double destruction of uobject

Jeff Layton <jlayton@kernel.org>
    ceph: flush release queue when handling caps for unknown inode

Jerry Lee <leisurelysw24@gmail.com>
    libceph: ignore pool overlay and cache logic on redirects

Kailang Yang <kailang@realtek.com>
    ALSA: hda/realtek - Add new codec supported for ALC287

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Quirks for Gigabyte TRX40 Aorus Master onboard audio

Vinod Koul <vkoul@kernel.org>
    clk: qcom: gcc: Fix parent for gpll0_out_even

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

Tiezhu Yang <yangtiezhu@loongson.cn>
    gpio: bcm-kona: Fix return value of bcm_kona_gpio_probe()

Tiezhu Yang <yangtiezhu@loongson.cn>
    gpio: pxa: Fix return value of pxa_gpio_probe()

Peng Hao <richard.peng@oppo.com>
    mmc: block: Fix use-after-free issue for rpmb

Maor Gottlieb <maorg@mellanox.com>
    RDMA/mlx5: Fix NULL pointer dereference in destroy_prefetch_work

Lubomir Rintel <lkundrak@v3.sk>
    ARM: dts: mmp3: Drop usb-nop-xceiv from HSIC phy

Lubomir Rintel <lkundrak@v3.sk>
    ARM: dts: mmp3-dell-ariel: Fix the SPI devices

Lubomir Rintel <lkundrak@v3.sk>
    ARM: dts: mmp3: Use the MMP3 compatible string for /clocks

Hamish Martin <hamish.martin@alliedtelesis.co.nz>
    ARM: dts: bcm: HR2: Fix PPI interrupt types

Vincent Stehlé <vincent.stehle@laposte.net>
    ARM: dts: bcm2835-rpi-zero-w: Fix led polarity

Robert Beckett <bob.beckett@collabora.com>
    ARM: dts/imx6q-bx50v3: Set display interface clock parents

Kaike Wan <kaike.wan@intel.com>
    IB/qib: Call kobject_put() when kobject_init_and_add() fails

Paul Cercueil <paul@crapouillou.net>
    gpu/drm: Ingenic: Fix opaque pointer casted to wrong type

Paul Cercueil <paul@crapouillou.net>
    gpu/drm: ingenic: Fix bogus crtc_atomic_check callback

Dennis YC Hsieh <dennis-yc.hsieh@mediatek.com>
    soc: mediatek: cmdq: return send msg error code

Hsin-Yi Wang <hsinyi@chromium.org>
    arm64: dts: mt8173: fix vcodec-enc clock

Takashi Iwai <tiwai@suse.de>
    gpio: exar: Fix bad handling for ida_simple_get error path

Russell King <rmk+kernel@armlinux.org.uk>
    ARM: uaccess: fix DACR mismatch with nested exceptions

Russell King <rmk+kernel@armlinux.org.uk>
    ARM: uaccess: integrate uaccess_save and uaccess_restore

Russell King <rmk+kernel@armlinux.org.uk>
    ARM: uaccess: consolidate uaccess asm to asm/uaccess-asm.h

Łukasz Stelmach <l.stelmach@samsung.com>
    ARM: 8970/1: decompressor: increase tag size

Wei Yongjun <weiyongjun1@huawei.com>
    Input: synaptics-rmi4 - fix error return code in rmi_driver_probe()

Evan Green <evgreen@chromium.org>
    Input: synaptics-rmi4 - really fix attn_data use-after-free

Kevin Locke <kevin@kevinlocke.name>
    Input: i8042 - add ThinkPad S230u to i8042 reset list

Sascha Hauer <s.hauer@pengutronix.de>
    gpio: mvebu: Fix probing for chips without PWM

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    Input: dlink-dir685-touchkeys - fix a typo in driver name

Łukasz Patron <priv.luk@gmail.com>
    Input: xpad - add custom init packet for Xbox One S controllers

Brendan Shanks <bshanks@codeweavers.com>
    Input: evdev - call input_flush_device() on release(), not flush()

James Hilliard <james.hilliard1@gmail.com>
    Input: usbtouchscreen - add support for BonXeon TP

Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
    drivers: net: hamradio: Fix suspicious RCU usage warning in bpqether.c

Matteo Croce <mcroce@redhat.com>
    samples: bpf: Fix build error

Al Viro <viro@zeniv.linux.org.uk>
    csky: Fixup raw_copy_from_user()

Steve French <stfrench@microsoft.com>
    cifs: Fix null pointer check in cifs_read

Kefeng Wang <wangkefeng.wang@huawei.com>
    riscv: pgtable: Fix __kernel_map_pages build error if NOMMU

Amy Shih <amy.shih@advantech.com.tw>
    hwmon: (nct7904) Fix incorrect range of temperature limit registers

Bernard Zhao <bernard@vivo.com>
    drm/meson: pm resume add return errno branch

Liu Yibin <jiulong@linux.alibaba.com>
    csky: Fixup remove duplicate irq_disable

Mao Han <han_mao@linux.alibaba.com>
    csky: Fixup perf callchain unwind

Liu Yibin <jiulong@linux.alibaba.com>
    csky: Fixup msa highest 3 bits mask

Tero Kristo <t-kristo@ti.com>
    clk: ti: am33xx: fix RTC clock parent

Kefeng Wang <wangkefeng.wang@huawei.com>
    riscv: Add pgprot_writecombine/device and PAGE_SHARED defination if NOMMU

Kefeng Wang <wangkefeng.wang@huawei.com>
    riscv: stacktrace: Fix undefined reference to `walk_stackframe'

Kefeng Wang <wangkefeng.wang@huawei.com>
    riscv: Fix unmet direct dependencies built based on SOC_VIRT

Denis V. Lunev <den@openvz.org>
    IB/i40iw: Remove bogus call to netdev_master_upper_dev_get()

Leo (Hanghong) Ma <hanghong.ma@amd.com>
    drm/amd/amdgpu: Update update_config() logic

Arnd Bergmann <arnd@arndb.de>
    net: freescale: select CONFIG_FIXED_PHY where needed

Masahiro Yamada <masahiroy@kernel.org>
    usb: gadget: legacy: fix redundant initialization warnings

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    usb: phy: twl6030-usb: Fix a resource leak in an error handling path in 'twl6030_usb_probe()'

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    usb: dwc3: pci: Enable extcon driver for Intel Merrifield

Lei Xue <carmark.dlut@gmail.com>
    cachefiles: Fix race between read_waiter and read_copier involving op->to_do

Felix Kuehling <Felix.Kuehling@amd.com>
    drm/amdgpu: Use GEM obj reference for KFD BOs

Evan Quan <evan.quan@amd.com>
    drm/amd/powerplay: perform PG ungate prior to CG ungate

Evan Quan <evan.quan@amd.com>
    drm/amdgpu: drop unnecessary cancel_delayed_work_sync on PG ungate

Andreas Gruenbacher <agruenba@redhat.com>
    gfs2: Grab glock reference sooner in gfs2_add_revoke

Bob Peterson <rpeterso@redhat.com>
    gfs2: move privileged user check to gfs2_quota_lock_check

John Stultz <john.stultz@linaro.org>
    kselftests: dmabuf-heaps: Fix confused return value on expected error testing

Chuhong Yuan <hslester96@gmail.com>
    net: microchip: encx24j600: add missed kthread_stop

Tony Lindgren <tony@atomide.com>
    ARM: dts: omap4-droid4: Fix occasional lost wakeirq for uart1

Tony Lindgren <tony@atomide.com>
    ARM: dts: omap4-droid4: Fix flakey wlan by disabling internal pull for gpio

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
    ARM: dts: rockchip: fix phy nodename for rk3229-xms6

Johan Jonker <jbx6244@gmail.com>
    ARM: dts: rockchip: fix phy nodename for rk3228-evb

Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
    arm64: dts: qcom: db820c: fix audio configuration

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: mscc: ocelot: fix address ageing time (again)

Jiri Pirko <jiri@mellanox.com>
    mlxsw: spectrum: Fix use-after-free of split/unsplit/type_set in case reload fails

Tang Bin <tangbin@cmss.chinamobile.com>
    net: sgi: ioc3-eth: Fix return value check in ioc3eth_probe()

Qiushi Wu <wu000273@umn.edu>
    net/mlx4_core: fix a memory leak bug.

Qiushi Wu <wu000273@umn.edu>
    net: sun: fix missing release regions in cas_init_one().

Vadim Fedorenko <vfedorenko@novek.ru>
    net/tls: free record only on encryption error

Vadim Fedorenko <vfedorenko@novek.ru>
    net/tls: fix encryption error checking

Roi Dayan <roid@mellanox.com>
    net/mlx5: Annotate mutex destroy for root ns

Eran Ben Elisha <eranbe@mellanox.com>
    net/mlx5: Avoid processing commands before cmdif is ready

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "virtio-balloon: Revert "virtio-balloon: Switch back to OOM handler for VIRTIO_BALLOON_F_DEFLATE_ON_OOM""

Roi Dayan <roid@mellanox.com>
    net/mlx5: Fix cleaning unmanaged flow tables

Eran Ben Elisha <eranbe@mellanox.com>
    net/mlx5: Fix a race when moving command interface to events mode

Heiner Kallweit <hkallweit1@gmail.com>
    r8169: fix OCP access on RTL8117

Jason A. Donenfeld <Jason@zx2c4.com>
    wireguard: noise: separate receive counter from send counter

Jason A. Donenfeld <Jason@zx2c4.com>
    wireguard: queueing: preserve flow hash across packet scrubbing

Jason A. Donenfeld <Jason@zx2c4.com>
    wireguard: noise: read preshared key while taking lock

Shay Drory <shayd@mellanox.com>
    net/mlx5: Fix error flow in case of function_setup failure

Moshe Shemesh <moshe@mellanox.com>
    net/mlx5e: Update netdev txq on completions during closure

Moshe Shemesh <moshe@mellanox.com>
    net/mlx5: Fix memory leak in mlx5_events_init

Roi Dayan <roid@mellanox.com>
    net/mlx5e: Fix inner tirs handling

Tariq Toukan <tariqt@mellanox.com>
    net/mlx5e: kTLS, Destroy key object after destroying the TIS

Eric Dumazet <edumazet@google.com>
    tipc: block BH before using dst_cache

Jere Leppänen <jere.leppanen@nokia.com>
    sctp: Start shutdown on association restart if in SHUTDOWN-SENT state and socket is closed

Neil Horman <nhorman@tuxdriver.com>
    sctp: Don't add the shutdown timer if its already been added

Marc Payne <marc.payne@mdpsys.co.uk>
    r8152: support additional Microsoft Surface Ethernet Adapter variant

David Ahern <dsahern@gmail.com>
    nexthop: Fix attribute checking for groups

Vinay Kumar Yadav <vinay.yadav@chelsio.com>
    net/tls: fix race condition causing kernel panic

Roman Mashak <mrv@mojatatu.com>
    net sched: fix reporting the first-time use timestamp

Yuqi Jin <jinyuqi@huawei.com>
    net: revert "net: get rid of an signed integer overflow in ip_idents_reserve()"

Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
    net: qrtr: Fix passing invalid reference to qrtr_local_enqueue()

Stephen Worley <sworley@cumulusnetworks.com>
    net: nlmsg_cancel() if put fails for nhmsg

Russell King <rmk+kernel@armlinux.org.uk>
    net: mvpp2: fix RX hashing for non-10G ports

Moshe Shemesh <moshe@mellanox.com>
    net/mlx5: Add command entry handling completion

Vadim Fedorenko <vfedorenko@novek.ru>
    net: ipip: fix wrong address family in init error path

Martin KaFai Lau <kafai@fb.com>
    net: inet_csk: Fix so_reuseport bind-address cache in tb->fast*

Boris Sukholitko <boris.sukholitko@broadcom.com>
    __netif_receive_skb_core: pass skb by reference

Grygorii Strashko <grygorii.strashko@ti.com>
    net: ethernet: ti: cpsw: fix ASSERT_RTNL() warning during suspend

DENG Qingfang <dqfext@gmail.com>
    net: dsa: mt7530: fix roaming from DSA user ports

Sabrina Dubroca <sd@queasysnail.net>
    net: don't return invalid table id error when we fall back to PF_UNSPEC

Claudiu Manoil <claudiu.manoil@nxp.com>
    felix: Fix initialization of ioremap resources

Michal Kubecek <mkubecek@suse.cz>
    ethtool: count header size in reply size estimate

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
 arch/arm/boot/dts/imx6q-b450v3.dts                 |   7 -
 arch/arm/boot/dts/imx6q-b650v3.dts                 |   7 -
 arch/arm/boot/dts/imx6q-b850v3.dts                 |  11 --
 arch/arm/boot/dts/imx6q-bx50v3.dtsi                |  15 +++
 arch/arm/boot/dts/mmp3-dell-ariel.dts              |  12 +-
 arch/arm/boot/dts/mmp3.dtsi                        |   8 +-
 arch/arm/boot/dts/motorola-mapphone-common.dtsi    |  43 +++++-
 arch/arm/boot/dts/rk3036.dtsi                      |   2 +-
 arch/arm/boot/dts/rk3228-evb.dts                   |   2 +-
 arch/arm/boot/dts/rk3229-xms6.dts                  |   2 +-
 arch/arm/boot/dts/rk322x.dtsi                      |   6 +-
 arch/arm/boot/dts/rk3xxx.dtsi                      |   2 +-
 arch/arm/include/asm/assembler.h                   |  75 +----------
 arch/arm/include/asm/uaccess-asm.h                 | 117 ++++++++++++++++
 arch/arm/kernel/entry-armv.S                       |  11 +-
 arch/arm/kernel/entry-header.S                     |   9 +-
 arch/arm64/boot/dts/mediatek/mt8173.dtsi           |   4 +-
 arch/arm64/boot/dts/qcom/apq8096-db820c.dtsi       |  19 ++-
 arch/arm64/boot/dts/qcom/msm8996.dtsi              |   2 +
 arch/arm64/boot/dts/rockchip/rk3328-evb.dts        |   2 +-
 arch/arm64/boot/dts/rockchip/rk3399.dtsi           |   8 +-
 arch/csky/abiv1/inc/abi/entry.h                    |   4 +-
 arch/csky/abiv2/inc/abi/entry.h                    |   4 +-
 arch/csky/include/asm/uaccess.h                    |  49 +++----
 arch/csky/kernel/entry.S                           |   2 -
 arch/csky/kernel/perf_callchain.c                  |   9 +-
 arch/csky/lib/usercopy.c                           |   8 +-
 arch/parisc/mm/init.c                              |   2 +-
 arch/powerpc/Kconfig                               |   1 +
 arch/riscv/Kconfig.socs                            |  17 +--
 arch/riscv/include/asm/mmio.h                      |   2 +
 arch/riscv/include/asm/pgtable.h                   |   3 +
 arch/riscv/kernel/stacktrace.c                     |   2 +-
 arch/x86/include/asm/dma.h                         |   2 +-
 arch/x86/include/asm/io_bitmap.h                   |   4 +-
 arch/x86/kernel/fpu/xstate.c                       |  86 ++++++------
 arch/x86/kernel/ioport.c                           |  22 +--
 arch/x86/kernel/process.c                          |   4 +-
 block/blk-core.c                                   |  11 +-
 drivers/clk/qcom/gcc-sm8150.c                      |   3 +-
 drivers/clk/ti/clk-33xx.c                          |   2 +-
 drivers/crypto/chelsio/chtls/chtls_io.c            |   2 +-
 drivers/gpio/gpio-bcm-kona.c                       |   2 +-
 drivers/gpio/gpio-exar.c                           |   7 +-
 drivers/gpio/gpio-mvebu.c                          |  15 ++-
 drivers/gpio/gpio-pxa.c                            |   4 +-
 drivers/gpio/gpio-tegra.c                          |   1 +
 drivers/gpio/gpiolib.c                             |  11 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c   |   5 +-
 drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c             |   6 +-
 drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c              |  12 +-
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |   7 -
 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_hdcp.c |  10 +-
 drivers/gpu/drm/amd/display/dc/core/dc.c           | 124 +++++++++++++----
 drivers/gpu/drm/amd/display/dc/core/dc_stream.c    |  40 +-----
 drivers/gpu/drm/amd/display/dc/dc_stream.h         |   1 +
 .../amd/display/dc/dce110/dce110_hw_sequencer.c    |  30 ++---
 .../drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c  | 148 ++++++++++++++++-----
 .../drm/amd/display/dc/dcn10/dcn10_hw_sequencer.h  |  13 ++
 drivers/gpu/drm/amd/display/dc/dcn10/dcn10_init.c  |   4 +
 drivers/gpu/drm/amd/display/dc/dcn10/dcn10_mpc.c   |  15 +++
 drivers/gpu/drm/amd/display/dc/dcn10/dcn10_mpc.h   |  20 ++-
 .../gpu/drm/amd/display/dc/dcn10/dcn10_resource.c  |  14 +-
 drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c | 108 +++++++--------
 drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.h |   7 +-
 drivers/gpu/drm/amd/display/dc/dcn20/dcn20_init.c  |   5 +-
 drivers/gpu/drm/amd/display/dc/dcn20/dcn20_mpc.c   |   1 +
 drivers/gpu/drm/amd/display/dc/dcn20/dcn20_mpc.h   |   3 +-
 .../gpu/drm/amd/display/dc/dcn20/dcn20_resource.c  |   4 +
 drivers/gpu/drm/amd/display/dc/dcn21/dcn21_init.c  |   5 +-
 .../gpu/drm/amd/display/dc/dcn21/dcn21_resource.c  |   4 +
 drivers/gpu/drm/amd/display/dc/inc/hw/mpc.h        |  16 +++
 drivers/gpu/drm/amd/display/dc/inc/hw_sequencer.h  |  12 +-
 drivers/gpu/drm/amd/powerplay/amd_powerplay.c      |   6 +-
 drivers/gpu/drm/amd/powerplay/amdgpu_smu.c         |   6 +-
 drivers/gpu/drm/ingenic/ingenic-drm.c              |   6 +-
 drivers/gpu/drm/meson/meson_drv.c                  |   4 +-
 drivers/hwmon/nct7904.c                            |   4 +-
 drivers/infiniband/core/rdma_core.c                |  20 ++-
 drivers/infiniband/hw/i40iw/i40iw_cm.c             |   8 --
 drivers/infiniband/hw/mlx5/mr.c                    |   1 +
 drivers/infiniband/hw/qib/qib_sysfs.c              |   9 +-
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c     |   2 +-
 drivers/infiniband/ulp/ipoib/ipoib.h               |   4 +
 drivers/infiniband/ulp/ipoib/ipoib_cm.c            |  15 ++-
 drivers/infiniband/ulp/ipoib/ipoib_ib.c            |   9 +-
 drivers/infiniband/ulp/ipoib/ipoib_main.c          |  10 +-
 drivers/input/evdev.c                              |  19 +--
 drivers/input/joystick/xpad.c                      |  12 ++
 drivers/input/keyboard/dlink-dir685-touchkeys.c    |   2 +-
 drivers/input/rmi4/rmi_driver.c                    |   5 +-
 drivers/input/serio/i8042-x86ia64io.h              |   7 +
 drivers/input/touchscreen/usbtouchscreen.c         |   1 +
 drivers/iommu/iommu.c                              |   2 +-
 drivers/mmc/core/block.c                           |   2 +-
 drivers/net/bonding/bond_sysfs_slave.c             |   4 +-
 drivers/net/dsa/mt7530.c                           |   9 +-
 drivers/net/dsa/mt7530.h                           |   1 +
 drivers/net/dsa/ocelot/felix.c                     |  23 ++--
 drivers/net/dsa/ocelot/felix.h                     |   6 +-
 drivers/net/dsa/ocelot/felix_vsc9959.c             |  22 ++-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |  16 +--
 drivers/net/ethernet/broadcom/bnxt/bnxt.h          |   5 -
 drivers/net/ethernet/freescale/Kconfig             |   2 +
 drivers/net/ethernet/freescale/dpaa/Kconfig        |   1 +
 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c     |   2 +-
 drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c     |   2 +-
 drivers/net/ethernet/mellanox/mlx4/fw.c            |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c      |  59 +++++++-
 drivers/net/ethernet/mellanox/mlx5/core/en.h       |   2 +-
 .../ethernet/mellanox/mlx5/core/en_accel/ktls.c    |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |  12 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   |   4 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_tx.c    |   9 +-
 drivers/net/ethernet/mellanox/mlx5/core/eq.c       |   3 +
 drivers/net/ethernet/mellanox/mlx5/core/events.c   |   4 +-
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c  |  17 ++-
 .../net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c  |   4 +-
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |   7 +-
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c     |  14 +-
 drivers/net/ethernet/mellanox/mlxsw/switchx2.c     |   8 ++
 drivers/net/ethernet/microchip/encx24j600.c        |   5 +-
 drivers/net/ethernet/mscc/ocelot.c                 |   2 +-
 .../net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c    |   4 +-
 drivers/net/ethernet/realtek/r8169_main.c          |  17 ++-
 drivers/net/ethernet/sgi/ioc3-eth.c                |   8 +-
 drivers/net/ethernet/sun/cassini.c                 |   3 +-
 drivers/net/ethernet/ti/cpsw.c                     |   4 +
 drivers/net/hamradio/bpqether.c                    |   3 +-
 drivers/net/usb/cdc_ether.c                        |  11 +-
 drivers/net/usb/r8152.c                            |   1 +
 drivers/net/wireguard/messages.h                   |   2 +-
 drivers/net/wireguard/noise.c                      |  22 ++-
 drivers/net/wireguard/noise.h                      |  14 +-
 drivers/net/wireguard/queueing.h                   |  10 +-
 drivers/net/wireguard/receive.c                    |  44 +++---
 drivers/net/wireguard/selftest/counter.c           |  17 ++-
 drivers/net/wireguard/send.c                       |  19 +--
 drivers/soc/mediatek/mtk-cmdq-helper.c             |   4 +-
 drivers/usb/dwc3/dwc3-pci.c                        |   1 +
 drivers/usb/gadget/legacy/inode.c                  |   3 +-
 drivers/usb/phy/phy-twl6030-usb.c                  |  12 +-
 drivers/virtio/virtio_balloon.c                    | 107 ++++++---------
 fs/binfmt_elf.c                                    |   2 +-
 fs/cachefiles/rdwr.c                               |   2 +-
 fs/ceph/caps.c                                     |   2 +-
 fs/cifs/file.c                                     |   2 +-
 fs/gfs2/log.c                                      |   6 +-
 fs/gfs2/quota.c                                    |   3 +-
 fs/gfs2/quota.h                                    |   3 +-
 include/asm-generic/topology.h                     |   2 +-
 include/linux/ieee80211.h                          |   2 +-
 include/linux/mlx5/driver.h                        |  16 +++
 include/linux/mm.h                                 |  15 ++-
 include/linux/netfilter/nf_conntrack_pptp.h        |   2 +-
 include/net/act_api.h                              |   3 +-
 include/net/espintcp.h                             |   1 +
 include/net/ip_fib.h                               |  11 +-
 include/net/nexthop.h                              |  67 +++++++---
 include/net/tls.h                                  |   4 +
 include/rdma/uverbs_std_types.h                    |   2 +-
 include/uapi/linux/xfrm.h                          |   2 +-
 mm/khugepaged.c                                    |   1 +
 net/ax25/af_ax25.c                                 |   6 +-
 net/bridge/netfilter/nft_reject_bridge.c           |   6 +
 net/ceph/osd_client.c                              |   4 +-
 net/core/dev.c                                     |  20 ++-
 net/dsa/slave.c                                    |   1 +
 net/dsa/tag_mtk.c                                  |  15 +++
 net/ethtool/netlink.c                              |   4 +-
 net/ethtool/strset.c                               |   1 -
 net/ipv4/esp4_offload.c                            |   4 +-
 net/ipv4/fib_frontend.c                            |  22 +--
 net/ipv4/inet_connection_sock.c                    |  43 +++---
 net/ipv4/ip_vti.c                                  |  23 +++-
 net/ipv4/ipip.c                                    |   2 +-
 net/ipv4/ipmr.c                                    |   2 +-
 net/ipv4/netfilter/nf_nat_pptp.c                   |   7 +-
 net/ipv4/nexthop.c                                 | 105 +++++++++------
 net/ipv4/route.c                                   |  14 +-
 net/ipv6/esp6_offload.c                            |  13 +-
 net/ipv6/ip6_fib.c                                 |   2 +-
 net/ipv6/ip6mr.c                                   |   2 +-
 net/mac80211/mesh_hwmp.c                           |   7 +
 net/netfilter/ipset/ip_set_list_set.c              |   2 +-
 net/netfilter/nf_conntrack_core.c                  |  80 ++++++++++-
 net/netfilter/nf_conntrack_pptp.c                  |  62 +++++----
 net/netfilter/nfnetlink_cthelper.c                 |   3 +-
 net/qrtr/qrtr.c                                    |   2 +-
 net/sctp/sm_sideeffect.c                           |  14 +-
 net/sctp/sm_statefuns.c                            |   9 +-
 net/tipc/udp_media.c                               |   6 +-
 net/tls/tls_sw.c                                   |  50 +++++--
 net/wireless/core.c                                |   2 +-
 net/xdp/xdp_umem.c                                 |   8 +-
 net/xfrm/espintcp.c                                |   2 +
 net/xfrm/xfrm_device.c                             |   8 +-
 net/xfrm/xfrm_input.c                              |   2 +-
 net/xfrm/xfrm_interface.c                          |  21 +++
 net/xfrm/xfrm_output.c                             |  15 ++-
 net/xfrm/xfrm_policy.c                             |   7 +-
 samples/bpf/lwt_len_hist_user.c                    |   2 -
 security/commoncap.c                               |   1 +
 sound/core/hwdep.c                                 |   4 +-
 sound/pci/hda/patch_realtek.c                      |  39 ++++--
 sound/usb/mixer.c                                  |   8 ++
 sound/usb/mixer_maps.c                             |  24 ++++
 sound/usb/quirks-table.h                           |  26 ++++
 tools/testing/selftests/dmabuf-heaps/dmabuf-heap.c |   1 +
 213 files changed, 1810 insertions(+), 1017 deletions(-)


