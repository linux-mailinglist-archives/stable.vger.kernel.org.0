Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 848BC3AEE29
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 18:24:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231679AbhFUQ0H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 12:26:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:40216 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232056AbhFUQYd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 12:24:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C2ED761353;
        Mon, 21 Jun 2021 16:21:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624292478;
        bh=LrIEWczLBVO5I2cdcw8QRfavdc+PyRHgJOol0chknis=;
        h=From:To:Cc:Subject:Date:From;
        b=zHq10UQ3OoaQ/mu/KVvnzOVSxoRrKLByKLxAMm70AxY/Tyos2sgP0B3x1xJDsHoZY
         t0HGJG9i3vqWhmKQ7tACa1mzSad7/GQ7OsAXNdwaS/bAVNDyyZXoS0kMzzfITb7Sj0
         avKm9zod0CxDyvvtXV/0JVqDH3I03nov+hbM0QZc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 5.10 000/146] 5.10.46-rc1 review
Date:   Mon, 21 Jun 2021 18:13:50 +0200
Message-Id: <20210621154911.244649123@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.46-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.46-rc1
X-KernelTest-Deadline: 2021-06-23T15:49+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.10.46 release.
There are 146 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 23 Jun 2021 15:48:46 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.46-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.10.46-rc1

Peter Chen <peter.chen@kernel.org>
    usb: dwc3: core: fix kernel panic when do reboot

Jack Pham <jackp@codeaurora.org>
    usb: dwc3: debugfs: Add and remove endpoint dirs dynamically

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf beauty: Update copy of linux/socket.h with the kernel sources

Arnaldo Carvalho de Melo <acme@redhat.com>
    tools headers UAPI: Sync linux/in.h copy with the kernel sources

Fugang Duan <fugang.duan@nxp.com>
    net: fec_ptp: add clock rate zero check

Joakim Zhang <qiangqing.zhang@nxp.com>
    net: stmmac: disable clocks in stmmac_remove_config_dt()

Andrew Morton <akpm@linux-foundation.org>
    mm/slub.c: include swab.h

Kees Cook <keescook@chromium.org>
    mm/slub: actually fix freelist pointer vs redzoning

Kees Cook <keescook@chromium.org>
    mm/slub: fix redzoning for small allocations

Kees Cook <keescook@chromium.org>
    mm/slub: clarify verification reporting

Peter Xu <peterx@redhat.com>
    mm/swap: fix pte_same_as_swp() not removing uffd-wp bit when compare

Nikolay Aleksandrov <nikolay@nvidia.com>
    net: bridge: fix vlan tunnel dst refcnt when egressing

Nikolay Aleksandrov <nikolay@nvidia.com>
    net: bridge: fix vlan tunnel dst null pointer dereference

Esben Haabendal <esben@geanix.com>
    net: ll_temac: Fix TX BD buffer overwrite

Esben Haabendal <esben@geanix.com>
    net: ll_temac: Make sure to free skb when it is completely used

Yifan Zhang <yifan1.zhang@amd.com>
    drm/amdgpu/gfx9: fix the doorbell missing when in CGPG issue.

Yifan Zhang <yifan1.zhang@amd.com>
    drm/amdgpu/gfx10: enlarge CP_MEC_DOORBELL_RANGE_UPPER to cover full doorbell.

Avraham Stern <avraham.stern@intel.com>
    cfg80211: avoid double free of PMSR request

Johannes Berg <johannes.berg@intel.com>
    cfg80211: make certificate generation more robust

Mathy Vanhoef <Mathy.Vanhoef@kuleuven.be>
    mac80211: Fix NULL ptr deref for injected rate info

Bumyong Lee <bumyong.lee@samsung.com>
    dmaengine: pl330: fix wrong usage of spinlock flags in dma_cyclc

Pingfan Liu <kernelfans@gmail.com>
    crash_core, vmcoreinfo: append 'SECTION_SIZE_BITS' to vmcoreinfo

Thomas Gleixner <tglx@linutronix.de>
    x86/fpu: Reset state for all signal restore failures

Andy Lutomirski <luto@kernel.org>
    x86/fpu: Invalidate FPU state after a failed XRSTOR from a user buffer

Thomas Gleixner <tglx@linutronix.de>
    x86/fpu: Prevent state corruption in __fpu__restore_sig()

Thomas Gleixner <tglx@linutronix.de>
    x86/pkru: Write hardware init value to PKRU when xstate is init

Tom Lendacky <thomas.lendacky@amd.com>
    x86/ioremap: Map EFI-reserved memory as encrypted for SEV

Thomas Gleixner <tglx@linutronix.de>
    x86/process: Check PF_KTHREAD and not current->mm for kernel threads

Fan Du <fan.du@intel.com>
    x86/mm: Avoid truncating memblocks for SGX memory

Vineet Gupta <vgupta@synopsys.com>
    ARCv2: save ABI registers across signal handling

Harald Freudenberger <freude@linux.ibm.com>
    s390/ap: Fix hanging ioctl caused by wrong msg counter

Alexander Gordeev <agordeev@linux.ibm.com>
    s390/mcck: fix calculation of SIE critical section size

Wanpeng Li <wanpengli@tencent.com>
    KVM: X86: Fix x86_emulator slab cache leak

Sean Christopherson <seanjc@google.com>
    KVM: x86/mmu: Calculate and check "full" mmu_role for nested MMU

Sean Christopherson <seanjc@google.com>
    KVM: x86: Immediately reset the MMU context when the SMM flag is cleared

Chiqijun <chiqijun@huawei.com>
    PCI: Work around Huawei Intelligent NIC VF FLR erratum

Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>
    PCI: Add ACS quirk for Broadcom BCM57414 NIC

Pali Rohár <pali@kernel.org>
    PCI: aardvark: Fix kernel panic during PIO transfer

Shanker Donthineni <sdonthineni@nvidia.com>
    PCI: Mark some NVIDIA GPUs to avoid bus reset

Antti Järvinen <antti.jarvinen@gmail.com>
    PCI: Mark TI C667X to avoid bus reset

Steven Rostedt (VMware) <rostedt@goodmis.org>
    tracing: Do no increment trace_clock_global() by one

Steven Rostedt (VMware) <rostedt@goodmis.org>
    tracing: Do not stop recording comms if the trace file is being read

Steven Rostedt (VMware) <rostedt@goodmis.org>
    tracing: Do not stop recording cmdlines when tracing is off

Breno Lima <breno.lima@nxp.com>
    usb: chipidea: imx: Fix Battery Charger 1.2 CDP detection

Andrew Lunn <andrew@lunn.ch>
    usb: core: hub: Disable autosuspend for Cypress CY7C65632

Pavel Skripkin <paskripkin@gmail.com>
    can: mcba_usb: fix memory leak in mcba_usb

Oleksij Rempel <linux@rempel-privat.de>
    can: j1939: fix Use-after-Free, hold skb ref while in use

Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
    can: bcm/raw/isotp: use per module netdevice notifier

Norbert Slusarek <nslusarek@gmx.net>
    can: bcm: fix infoleak in struct bcm_msg_head

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Do not mark insn as seen under speculative path verification

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Inherit expanded/patched seen count from old aux data

Odin Ugedal <odin@uged.al>
    sched/fair: Correctly insert cfs_rq's to list on unthrottle

Marc Zyngier <maz@kernel.org>
    irqchip/gic-v3: Workaround inconsistent PMR setting on NMI entry

Feng Tang <feng.tang@intel.com>
    mm: relocate 'write_protect_seq' in struct mm_struct

Riwen Lu <luriwen@kylinos.cn>
    hwmon: (scpi-hwmon) shows the negative temperature properly

Chen Li <chenli@uniontech.com>
    radeon: use memcpy_to/fromio for UVD fw upload

Srinivasa Rao Mandadapu <srivasam@codeaurora.org>
    ASoC: qcom: lpass-cpu: Fix pop noise during audio capture begin

Saravana Kannan <saravanak@google.com>
    drm/sun4i: dw-hdmi: Make HDMI PHY into a platform device

Sergio Paracuellos <sergio.paracuellos@gmail.com>
    pinctrl: ralink: rt2880: avoid to error in calls is pin is already enabled

Oder Chiou <oder_chiou@realtek.com>
    ASoC: rt5682: Fix the fast discharge for headset unplugging in soundwire mode

Axel Lin <axel.lin@ingics.com>
    regulator: rt4801: Fix NULL pointer dereference if priv->enable_gpios is NULL

Patrice Chotard <patrice.chotard@foss.st.com>
    spi: stm32-qspi: Always wait BUSY bit to be cleared in stm32_qspi_wait_cmd()

Richard Weinberger <richard@nod.at>
    ASoC: tas2562: Fix TDM_CFG0_SAMPRATE values

Vincent Guittot <vincent.guittot@linaro.org>
    sched/pelt: Ensure that *_sum is always synced with *_avg

zpershuai <zpershuai@gmail.com>
    spi: spi-zynq-qspi: Fix some wrong goto jumps & missing error code

ChiYuan Huang <cy_huang@richtek.com>
    regulator: rtmv20: Fix to make regcache value first reading back from HW

Nicolas Cavallari <nicolas.cavallari@green-communications.fr>
    ASoC: fsl-asoc-card: Set .owner attribute when registering card.

Tiezhu Yang <yangtiezhu@loongson.cn>
    phy: phy-mtk-tphy: Fix some resource leaks in mtk_phy_init()

Jack Yu <jack.yu@realtek.com>
    ASoC: rt5659: Fix the lost powers for the HDA header

Til Jasper Ullrich <tju@tju.me>
    platform/x86: thinkpad_acpi: Add X1 Carbon Gen 9 second fan support

Axel Lin <axel.lin@ingics.com>
    regulator: bd70528: Fix off-by-one for buck123 .n_voltages setting

Dmitry Osipenko <digetx@gmail.com>
    regulator: max77620: Silence deferred probe error

Axel Lin <axel.lin@ingics.com>
    regulator: cros-ec: Fix error code in dev_err message

Pavel Skripkin <paskripkin@gmail.com>
    net: ethernet: fix potential use-after-free in ec_bhf_remove

Toke Høiland-Jørgensen <toke@redhat.com>
    icmp: don't send out ICMP messages with a source address of 0.0.0.0

Somnath Kotur <somnath.kotur@broadcom.com>
    bnxt_en: Call bnxt_ethtool_free() in bnxt_init_one() error path

Rukhsana Ansari <rukhsana.ansari@broadcom.com>
    bnxt_en: Fix TQM fastpath ring backing store computation

Michael Chan <michael.chan@broadcom.com>
    bnxt_en: Rediscover PHY capabilities after firmware reset

Pavel Machek <pavel@denx.de>
    cxgb4: fix wrong shift.

Linyu Yuan <linyyuan@codeaurora.org>
    net: cdc_eem: fix tx fixup skb leak

Pavel Skripkin <paskripkin@gmail.com>
    net: hamradio: fix memory leak in mkiss_close

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    be2net: Fix an error handling path in 'be_probe()'

Aya Levin <ayal@nvidia.com>
    net/mlx5: Reset mkey index on creation

Parav Pandit <parav@nvidia.com>
    net/mlx5: E-Switch, Allow setting GUID for host PF vport

Parav Pandit <parav@nvidia.com>
    net/mlx5: E-Switch, Read PF mac address

Eric Dumazet <edumazet@google.com>
    net/af_unix: fix a data-race in unix_dgram_sendmsg / unix_release_sock

Chengyang Fan <cy.fan@huawei.com>
    net: ipv4: fix memory leak in ip_mc_add1_src

Joakim Zhang <qiangqing.zhang@nxp.com>
    net: fec_ptp: fix issue caused by refactor the fec_devtype

Dongliang Mu <mudongliangabcd@gmail.com>
    net: usb: fix possible use-after-free in smsc75xx_bind

Aleksander Jan Bajkowski <olek2@wp.pl>
    lantiq: net: fix duplicated skb in rx descriptor ring

Maciej Żenczykowski <maze@google.com>
    net: cdc_ncm: switch to eth%d interface naming

Jakub Kicinski <kuba@kernel.org>
    ptp: improve max_adj check against unreasonable values

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Fix leakage under speculation on mispredicted branches

Pavel Skripkin <paskripkin@gmail.com>
    net: qrtr: fix OOB Read in qrtr_endpoint_post

David Ahern <dsahern@kernel.org>
    ipv4: Fix device used for dst_alloc with local routes

Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
    cxgb4: fix wrong ethtool n-tuple rule lookup

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    netxen_nic: Fix an error handling path in 'netxen_nic_probe()'

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    qlcnic: Fix an error handling path in 'qlcnic_probe()'

Jakub Kicinski <kuba@kernel.org>
    ethtool: strset: fix message length calculation

Alex Elder <elder@linaro.org>
    net: qualcomm: rmnet: don't over-count statistics

Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
    net: qualcomm: rmnet: Update rmnet device MTU based on real device

Changbin Du <changbin.du@intel.com>
    net: make get_net_ns return error if NET_NS is disabled

Jisheng Zhang <Jisheng.Zhang@synaptics.com>
    net: stmmac: dwmac1000: Fix extended MAC address registers definition

Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
    cxgb4: halt chip before flashing PHY firmware image

Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
    cxgb4: fix sleep in atomic when flashing PHY firmware

Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
    cxgb4: fix endianness when flashing boot image

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    alx: Fix an error handling path in 'alx_probe()'

Paolo Abeni <pabeni@redhat.com>
    selftests: mptcp: enable syncookie only in absence of reorders

Paolo Abeni <pabeni@redhat.com>
    mptcp: do not warn on bad input from the network

Paolo Abeni <pabeni@redhat.com>
    mptcp: try harder to borrow memory from subflow under pressure

Maxim Mikityanskiy <maximmi@nvidia.com>
    sch_cake: Fix out of bounds when parsing TCP options and header

Maxim Mikityanskiy <maximmi@nvidia.com>
    mptcp: Fix out of bounds when parsing TCP options

Maxim Mikityanskiy <maximmi@nvidia.com>
    netfilter: synproxy: Fix out of bounds when parsing TCP options

Aya Levin <ayal@nvidia.com>
    net/mlx5e: Block offload of outer header csum for UDP tunnels

Maor Gottlieb <maorg@nvidia.com>
    net/mlx5: DR, Don't use SW steering when RoCE is not supported

Yevgeny Kliteynik <kliteyn@nvidia.com>
    net/mlx5: DR, Allow SW steering for sw_owner_v2 devices

Maor Gottlieb <maorg@nvidia.com>
    net/mlx5: Consider RoCE cap before init RDMA resources

Dima Chumak <dchumak@nvidia.com>
    net/mlx5e: Fix page reclaim for dead peer hairpin

Huy Nguyen <huyn@nvidia.com>
    net/mlx5e: Remove dependency in IPsec initialization flows

Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
    net/sched: act_ct: handle DNAT tuple collision

Ido Schimmel <idosch@nvidia.com>
    rtnetlink: Fix regression in bridge VLAN configuration

Paolo Abeni <pabeni@redhat.com>
    udp: fix race between close() and udp_abort()

Maciej Fijalkowski <maciej.fijalkowski@intel.com>
    ice: parameterize functions responsible for Tx ring management

Maciej Fijalkowski <maciej.fijalkowski@intel.com>
    ice: add ndo_bpf callback for safe mode netdev ops

Florian Westphal <fw@strlen.de>
    netfilter: nft_fib_ipv6: skip ipv6 packets from any to link-local

Aleksander Jan Bajkowski <olek2@wp.pl>
    net: lantiq: disable interrupt before sheduling NAPI

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dsa: felix: re-enable TX flow control in ocelot_port_flush()

Pavel Skripkin <paskripkin@gmail.com>
    net: rds: fix memory leak in rds_recvmsg

Nicolas Dichtel <nicolas.dichtel@6wind.com>
    vrf: fix maximum MTU

Nanyong Sun <sunnanyong@huawei.com>
    net: ipv4: fix memory leak in netlbl_cipsov4_add_std

Kev Jackson <foamdino@gmail.com>
    libbpf: Fixes incorrect rx_ring_setup_done

Mykola Kostenok <c_mykolak@nvidia.com>
    mlxsw: core: Set thermal zone polling delay argument to real value at init

Petr Machata <petrm@nvidia.com>
    mlxsw: reg: Spectrum-3: Enforce lowest max-shaper burst size of 11

Du Cheng <ducheng2@gmail.com>
    mac80211: fix skb length check in ieee80211_scan_rx()

Sven Eckelmann <sven@narfation.org>
    batman-adv: Avoid WARN_ON timing related checks

Matthew Bobrowski <repnop@google.com>
    fanotify: fix copy_event_to_user() fid error clean up

Jim Mattson <jmattson@google.com>
    kvm: LAPIC: Restore guard to prevent illegal APIC register access

yangerkun <yangerkun@huawei.com>
    mm/memory-failure: make sure wait for page writeback in memory_failure

Dan Carpenter <dan.carpenter@oracle.com>
    afs: Fix an IS_ERR() vs NULL check

Yang Yingliang <yangyingliang@huawei.com>
    dmaengine: stedma40: add missing iounmap() on error in d40_probe()

Randy Dunlap <rdunlap@infradead.org>
    dmaengine: SF_PDMA depends on HAS_IOMEM

Randy Dunlap <rdunlap@infradead.org>
    dmaengine: QCOM_HIDMA_MGMT depends on HAS_IOMEM

Randy Dunlap <rdunlap@infradead.org>
    dmaengine: ALTERA_MSGDMA depends on HAS_IOMEM

Quanyang Wang <quanyang.wang@windriver.com>
    dmaengine: xilinx: dpdma: initialize registers before request_irq

Zhen Lei <thunder.leizhen@huawei.com>
    dmaengine: fsl-dpaa2-qdma: Fix error return code in two functions

Dave Jiang <dave.jiang@intel.com>
    dmaengine: idxd: add missing dsa driver unregister


-------------

Diffstat:

 Documentation/vm/slub.rst                          | 10 +--
 Makefile                                           |  4 +-
 arch/arc/include/uapi/asm/sigcontext.h             |  1 +
 arch/arc/kernel/signal.c                           | 43 +++++++++++
 arch/s390/kernel/entry.S                           |  2 +-
 arch/x86/include/asm/fpu/internal.h                | 13 +++-
 arch/x86/kernel/fpu/signal.c                       | 54 ++++++++-----
 arch/x86/kvm/lapic.c                               |  3 +
 arch/x86/kvm/mmu/mmu.c                             | 26 ++++++-
 arch/x86/kvm/x86.c                                 |  6 +-
 arch/x86/mm/ioremap.c                              |  4 +-
 arch/x86/mm/numa.c                                 |  8 +-
 drivers/dma/Kconfig                                |  1 +
 drivers/dma/fsl-dpaa2-qdma/dpaa2-qdma.c            |  3 +
 drivers/dma/idxd/init.c                            |  1 +
 drivers/dma/pl330.c                                |  6 +-
 drivers/dma/qcom/Kconfig                           |  1 +
 drivers/dma/sf-pdma/Kconfig                        |  1 +
 drivers/dma/ste_dma40.c                            |  3 +
 drivers/dma/xilinx/xilinx_dpdma.c                  | 24 +++++-
 drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c             |  6 +-
 drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c              |  6 +-
 drivers/gpu/drm/radeon/radeon_uvd.c                |  4 +-
 drivers/gpu/drm/sun4i/sun8i_dw_hdmi.c              | 31 +++++++-
 drivers/gpu/drm/sun4i/sun8i_dw_hdmi.h              |  5 +-
 drivers/gpu/drm/sun4i/sun8i_hdmi_phy.c             | 41 ++++++++--
 drivers/hwmon/scpi-hwmon.c                         |  9 +++
 drivers/irqchip/irq-gic-v3.c                       | 36 ++++++++-
 drivers/net/can/usb/mcba_usb.c                     | 17 ++++-
 drivers/net/ethernet/atheros/alx/main.c            |  1 +
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |  8 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c | 48 ++++++++----
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c  |  2 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c    |  2 -
 drivers/net/ethernet/chelsio/cxgb4/t4_hw.c         | 46 ++++++-----
 drivers/net/ethernet/ec_bhf.c                      |  4 +-
 drivers/net/ethernet/emulex/benet/be_main.c        |  1 +
 drivers/net/ethernet/freescale/fec_ptp.c           |  8 +-
 drivers/net/ethernet/intel/ice/ice_lib.c           | 18 +++--
 drivers/net/ethernet/intel/ice/ice_main.c          | 15 ++++
 drivers/net/ethernet/lantiq_xrx200.c               |  5 +-
 .../ethernet/mellanox/mlx5/core/en_accel/ipsec.c   |  3 -
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  | 10 +--
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    |  2 +-
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c  |  6 ++
 drivers/net/ethernet/mellanox/mlx5/core/mr.c       |  2 +-
 drivers/net/ethernet/mellanox/mlx5/core/rdma.c     |  3 +
 .../ethernet/mellanox/mlx5/core/steering/dr_cmd.c  | 17 +++--
 .../mellanox/mlx5/core/steering/dr_domain.c        | 17 +++--
 .../mellanox/mlx5/core/steering/dr_types.h         |  6 +-
 .../ethernet/mellanox/mlx5/core/steering/mlx5dr.h  |  6 +-
 drivers/net/ethernet/mellanox/mlx5/core/transobj.c | 30 ++++++--
 drivers/net/ethernet/mellanox/mlx5/core/vport.c    |  2 -
 drivers/net/ethernet/mellanox/mlxsw/core_thermal.c |  6 +-
 drivers/net/ethernet/mellanox/mlxsw/reg.h          |  2 +-
 drivers/net/ethernet/mscc/ocelot.c                 |  5 ++
 .../net/ethernet/qlogic/netxen/netxen_nic_main.c   |  2 +
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c   |  1 +
 drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c | 15 +++-
 drivers/net/ethernet/qualcomm/rmnet/rmnet_config.h |  2 +
 drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c    | 89 +++++++++++++++++++---
 drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.h    |  3 +
 drivers/net/ethernet/stmicro/stmmac/dwmac1000.h    |  8 +-
 .../net/ethernet/stmicro/stmmac/stmmac_platform.c  |  2 +
 drivers/net/ethernet/xilinx/ll_temac_main.c        |  8 +-
 drivers/net/hamradio/mkiss.c                       |  1 +
 drivers/net/usb/cdc_eem.c                          |  2 +-
 drivers/net/usb/cdc_ncm.c                          |  2 +-
 drivers/net/usb/smsc75xx.c                         | 10 ++-
 drivers/net/vrf.c                                  |  6 +-
 drivers/pci/controller/pci-aardvark.c              | 49 +++++++++---
 drivers/pci/quirks.c                               | 89 ++++++++++++++++++++++
 drivers/phy/mediatek/phy-mtk-tphy.c                |  2 +
 drivers/platform/x86/thinkpad_acpi.c               |  1 +
 drivers/ptp/ptp_clock.c                            |  6 +-
 drivers/regulator/cros-ec-regulator.c              |  3 +-
 drivers/regulator/max77620-regulator.c             | 10 +--
 drivers/regulator/rt4801-regulator.c               |  4 +-
 drivers/regulator/rtmv20-regulator.c               |  2 +
 drivers/s390/crypto/ap_queue.c                     | 11 ++-
 drivers/spi/spi-stm32-qspi.c                       |  5 +-
 drivers/spi/spi-zynq-qspi.c                        |  7 +-
 drivers/staging/mt7621-pinctrl/pinctrl-rt2880.c    |  2 +-
 drivers/usb/chipidea/usbmisc_imx.c                 | 16 +++-
 drivers/usb/core/hub.c                             |  7 ++
 drivers/usb/dwc3/core.c                            |  2 +-
 drivers/usb/dwc3/debug.h                           |  3 +
 drivers/usb/dwc3/debugfs.c                         | 21 +----
 drivers/usb/dwc3/gadget.c                          |  3 +
 fs/afs/main.c                                      |  4 +-
 fs/notify/fanotify/fanotify_user.c                 |  4 +-
 include/linux/mfd/rohm-bd70528.h                   |  4 +-
 include/linux/mlx5/transobj.h                      |  1 +
 include/linux/mm_types.h                           | 27 +++++--
 include/linux/ptp_clock_kernel.h                   |  2 +-
 include/linux/socket.h                             |  2 -
 include/linux/swapops.h                            | 15 +++-
 include/net/mac80211.h                             |  7 +-
 include/net/net_namespace.h                        |  7 ++
 include/uapi/linux/in.h                            |  3 +
 kernel/bpf/verifier.c                              | 68 +++++++++++++++--
 kernel/crash_core.c                                |  1 +
 kernel/sched/fair.c                                | 54 ++++++++-----
 kernel/trace/trace.c                               | 11 ---
 kernel/trace/trace_clock.c                         |  6 +-
 mm/memory-failure.c                                |  7 +-
 mm/slab_common.c                                   |  3 +-
 mm/slub.c                                          | 37 ++++-----
 mm/swapfile.c                                      |  2 +-
 net/batman-adv/bat_iv_ogm.c                        |  4 +-
 net/bridge/br_private.h                            |  4 +-
 net/bridge/br_vlan_tunnel.c                        | 38 +++++----
 net/can/bcm.c                                      | 62 +++++++++++----
 net/can/isotp.c                                    | 61 +++++++++++----
 net/can/j1939/transport.c                          | 54 +++++++++----
 net/can/raw.c                                      | 62 +++++++++++----
 net/core/net_namespace.c                           | 12 +++
 net/core/rtnetlink.c                               |  8 +-
 net/ethtool/strset.c                               |  2 +
 net/ipv4/cipso_ipv4.c                              |  1 +
 net/ipv4/icmp.c                                    |  7 ++
 net/ipv4/igmp.c                                    |  1 +
 net/ipv4/route.c                                   | 15 +++-
 net/ipv4/udp.c                                     | 10 +++
 net/ipv6/netfilter/nft_fib_ipv6.c                  | 22 +++++-
 net/ipv6/udp.c                                     |  3 +
 net/mac80211/scan.c                                | 21 +++--
 net/mac80211/tx.c                                  | 52 +++++++++----
 net/mptcp/options.c                                |  2 +
 net/mptcp/protocol.c                               | 10 ++-
 net/mptcp/subflow.c                                | 10 +--
 net/netfilter/nf_synproxy_core.c                   |  5 ++
 net/qrtr/qrtr.c                                    |  2 +-
 net/rds/recv.c                                     |  2 +-
 net/sched/act_ct.c                                 | 21 +++--
 net/sched/sch_cake.c                               |  6 +-
 net/socket.c                                       | 13 ----
 net/unix/af_unix.c                                 |  7 +-
 net/wireless/Makefile                              |  2 +-
 net/wireless/pmsr.c                                | 16 +++-
 sound/soc/codecs/rt5659.c                          | 26 +++++--
 sound/soc/codecs/rt5682-sdw.c                      |  3 +-
 sound/soc/codecs/tas2562.h                         | 14 ++--
 sound/soc/fsl/fsl-asoc-card.c                      |  1 +
 sound/soc/qcom/lpass-cpu.c                         | 79 +++++++++++++++++++
 sound/soc/qcom/lpass.h                             |  4 +
 tools/include/uapi/linux/in.h                      |  3 +
 tools/lib/bpf/xsk.c                                |  2 +-
 tools/perf/trace/beauty/include/linux/socket.h     |  2 -
 tools/testing/selftests/net/fib_tests.sh           | 25 ++++++
 tools/testing/selftests/net/mptcp/mptcp_connect.sh | 11 ++-
 151 files changed, 1542 insertions(+), 466 deletions(-)


