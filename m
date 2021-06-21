Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 365CB3AED9D
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 18:19:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231187AbhFUQVV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 12:21:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:41362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231626AbhFUQUj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 12:20:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2085E61289;
        Mon, 21 Jun 2021 16:18:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624292304;
        bh=BbFSm4JzqmK+TK7i16hO+2cwhfppUTmx4P3jXNchskg=;
        h=From:To:Cc:Subject:Date:From;
        b=K/zpqQn6fkYwe29nyxFitMRePGFvBPYWb7d9wNe0VFJ30/ijShVrvyzqXeQALKnb5
         usSdUx9jdT7zGbXisTmkC5f4CrK4051TnIoGeZAGScLS7eP8uZLYHeKCzkS+C12ldB
         S+yFMa7lp6VaFbFTFi1yXHKMeWH/aT8cLzJAJ4sw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 5.4 00/90] 5.4.128-rc1 review
Date:   Mon, 21 Jun 2021 18:14:35 +0200
Message-Id: <20210621154904.159672728@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.128-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.128-rc1
X-KernelTest-Deadline: 2021-06-23T15:49+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.4.128 release.
There are 90 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 23 Jun 2021 15:48:46 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.128-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.4.128-rc1

Peter Chen <peter.chen@kernel.org>
    usb: dwc3: core: fix kernel panic when do reboot

Jack Pham <jackp@codeaurora.org>
    usb: dwc3: debugfs: Add and remove endpoint dirs dynamically

Tony Lindgren <tony@atomide.com>
    clocksource/drivers/timer-ti-dm: Handle dra7 timer wrap errata i940

Tony Lindgren <tony@atomide.com>
    clocksource/drivers/timer-ti-dm: Prepare to handle dra7 timer wrap issue

Tony Lindgren <tony@atomide.com>
    clocksource/drivers/timer-ti-dm: Add clockevent and clocksource support

afzal mohammed <afzal.mohd.ma@gmail.com>
    ARM: OMAP: replace setup_irq() by request_irq()

Eric Auger <eric.auger@redhat.com>
    KVM: arm/arm64: Fix KVM_VGIC_V3_ADDR_TYPE_REDIST read

Arnaldo Carvalho de Melo <acme@redhat.com>
    tools headers UAPI: Sync linux/in.h copy with the kernel sources

Fugang Duan <fugang.duan@nxp.com>
    net: fec_ptp: add clock rate zero check

Joakim Zhang <qiangqing.zhang@nxp.com>
    net: stmmac: disable clocks in stmmac_remove_config_dt()

Andrew Morton <akpm@linux-foundation.org>
    mm/slub.c: include swab.h

Kees Cook <keescook@chromium.org>
    mm/slub: fix redzoning for small allocations

Kees Cook <keescook@chromium.org>
    mm/slub: clarify verification reporting

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

Bumyong Lee <bumyong.lee@samsung.com>
    dmaengine: pl330: fix wrong usage of spinlock flags in dma_cyclc

Thomas Gleixner <tglx@linutronix.de>
    x86/fpu: Reset state for all signal restore failures

Thomas Gleixner <tglx@linutronix.de>
    x86/pkru: Write hardware init value to PKRU when xstate is init

Thomas Gleixner <tglx@linutronix.de>
    x86/process: Check PF_KTHREAD and not current->mm for kernel threads

Vineet Gupta <vgupta@synopsys.com>
    ARCv2: save ABI registers across signal handling

Sean Christopherson <seanjc@google.com>
    KVM: x86: Immediately reset the MMU context when the SMM flag is cleared

Chiqijun <chiqijun@huawei.com>
    PCI: Work around Huawei Intelligent NIC VF FLR erratum

Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>
    PCI: Add ACS quirk for Broadcom BCM57414 NIC

Pali Rohár <pali@kernel.org>
    PCI: aardvark: Fix kernel panic during PIO transfer

Remi Pommarel <repk@triplefau.lt>
    PCI: aardvark: Don't rely on jiffies while holding spinlock

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

Odin Ugedal <odin@uged.al>
    sched/fair: Correctly insert cfs_rq's to list on unthrottle

Riwen Lu <luriwen@kylinos.cn>
    hwmon: (scpi-hwmon) shows the negative temperature properly

Chen Li <chenli@uniontech.com>
    radeon: use memcpy_to/fromio for UVD fw upload

Sergio Paracuellos <sergio.paracuellos@gmail.com>
    pinctrl: ralink: rt2880: avoid to error in calls is pin is already enabled

Patrice Chotard <patrice.chotard@foss.st.com>
    spi: stm32-qspi: Always wait BUSY bit to be cleared in stm32_qspi_wait_cmd()

Jack Yu <jack.yu@realtek.com>
    ASoC: rt5659: Fix the lost powers for the HDA header

Axel Lin <axel.lin@ingics.com>
    regulator: bd70528: Fix off-by-one for buck123 .n_voltages setting

Pavel Skripkin <paskripkin@gmail.com>
    net: ethernet: fix potential use-after-free in ec_bhf_remove

Toke Høiland-Jørgensen <toke@redhat.com>
    icmp: don't send out ICMP messages with a source address of 0.0.0.0

Somnath Kotur <somnath.kotur@broadcom.com>
    bnxt_en: Call bnxt_ethtool_free() in bnxt_init_one() error path

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

Pavel Skripkin <paskripkin@gmail.com>
    net: qrtr: fix OOB Read in qrtr_endpoint_post

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    netxen_nic: Fix an error handling path in 'netxen_nic_probe()'

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    qlcnic: Fix an error handling path in 'qlcnic_probe()'

Changbin Du <changbin.du@intel.com>
    net: make get_net_ns return error if NET_NS is disabled

Jisheng Zhang <Jisheng.Zhang@synaptics.com>
    net: stmmac: dwmac1000: Fix extended MAC address registers definition

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    alx: Fix an error handling path in 'alx_probe()'

Maxim Mikityanskiy <maximmi@nvidia.com>
    sch_cake: Fix out of bounds when parsing TCP options and header

Maxim Mikityanskiy <maximmi@nvidia.com>
    netfilter: synproxy: Fix out of bounds when parsing TCP options

Aya Levin <ayal@nvidia.com>
    net/mlx5e: Block offload of outer header csum for UDP tunnels

Davide Caratti <dcaratti@redhat.com>
    net/mlx5e: allow TSO on VXLAN over VLAN topologies

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

Aleksander Jan Bajkowski <olek2@wp.pl>
    net: lantiq: disable interrupt before sheduling NAPI

Pavel Skripkin <paskripkin@gmail.com>
    net: rds: fix memory leak in rds_recvmsg

Nicolas Dichtel <nicolas.dichtel@6wind.com>
    vrf: fix maximum MTU

Nanyong Sun <sunnanyong@huawei.com>
    net: ipv4: fix memory leak in netlbl_cipsov4_add_std

Sven Eckelmann <sven@narfation.org>
    batman-adv: Avoid WARN_ON timing related checks

Jim Mattson <jmattson@google.com>
    kvm: LAPIC: Restore guard to prevent illegal APIC register access

yangerkun <yangerkun@huawei.com>
    mm/memory-failure: make sure wait for page writeback in memory_failure

Dan Carpenter <dan.carpenter@oracle.com>
    afs: Fix an IS_ERR() vs NULL check

Yang Yingliang <yangyingliang@huawei.com>
    dmaengine: stedma40: add missing iounmap() on error in d40_probe()

Randy Dunlap <rdunlap@infradead.org>
    dmaengine: QCOM_HIDMA_MGMT depends on HAS_IOMEM

Randy Dunlap <rdunlap@infradead.org>
    dmaengine: ALTERA_MSGDMA depends on HAS_IOMEM


-------------

Diffstat:

 Documentation/vm/slub.rst                          |  10 +-
 Makefile                                           |   4 +-
 arch/arc/include/uapi/asm/sigcontext.h             |   1 +
 arch/arc/kernel/signal.c                           |  43 +++++
 arch/arm/boot/dts/dra7-l4.dtsi                     |   4 +-
 arch/arm/boot/dts/dra7.dtsi                        |  20 +++
 arch/arm/mach-omap1/pm.c                           |  13 +-
 arch/arm/mach-omap1/time.c                         |  10 +-
 arch/arm/mach-omap1/timer32k.c                     |  10 +-
 arch/arm/mach-omap2/board-generic.c                |   4 +-
 arch/arm/mach-omap2/timer.c                        | 181 ++++++++++++++-------
 arch/x86/include/asm/fpu/internal.h                |  13 +-
 arch/x86/kernel/fpu/signal.c                       |  26 +--
 arch/x86/kvm/lapic.c                               |   3 +
 arch/x86/kvm/x86.c                                 |   5 +-
 drivers/clk/ti/clk-7xx.c                           |   1 +
 drivers/dma/Kconfig                                |   1 +
 drivers/dma/pl330.c                                |   6 +-
 drivers/dma/qcom/Kconfig                           |   1 +
 drivers/dma/ste_dma40.c                            |   3 +
 drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c             |   6 +-
 drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c              |   6 +-
 drivers/gpu/drm/radeon/radeon_uvd.c                |   4 +-
 drivers/hwmon/scpi-hwmon.c                         |   9 +
 drivers/net/can/usb/mcba_usb.c                     |  17 +-
 drivers/net/ethernet/atheros/alx/main.c            |   1 +
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |   6 +
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c  |   2 +-
 drivers/net/ethernet/ec_bhf.c                      |   4 +-
 drivers/net/ethernet/emulex/benet/be_main.c        |   1 +
 drivers/net/ethernet/freescale/fec_ptp.c           |   8 +-
 drivers/net/ethernet/lantiq_xrx200.c               |   5 +-
 .../ethernet/mellanox/mlx5/core/en_accel/ipsec.c   |   3 -
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |   8 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/rdma.c     |   3 +
 drivers/net/ethernet/mellanox/mlx5/core/transobj.c |  30 +++-
 .../net/ethernet/qlogic/netxen/netxen_nic_main.c   |   2 +
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c   |   1 +
 drivers/net/ethernet/stmicro/stmmac/dwmac1000.h    |   8 +-
 .../net/ethernet/stmicro/stmmac/stmmac_platform.c  |   2 +
 drivers/net/ethernet/xilinx/ll_temac_main.c        |   8 +-
 drivers/net/hamradio/mkiss.c                       |   1 +
 drivers/net/usb/cdc_eem.c                          |   2 +-
 drivers/net/usb/cdc_ncm.c                          |   2 +-
 drivers/net/usb/smsc75xx.c                         |  10 +-
 drivers/net/vrf.c                                  |   6 +-
 drivers/pci/controller/pci-aardvark.c              |  59 +++++--
 drivers/pci/quirks.c                               |  89 ++++++++++
 drivers/ptp/ptp_clock.c                            |   6 +-
 drivers/spi/spi-stm32-qspi.c                       |   5 +-
 drivers/staging/mt7621-pinctrl/pinctrl-rt2880.c    |   2 +-
 drivers/usb/core/hub.c                             |   7 +
 drivers/usb/dwc3/core.c                            |   2 +-
 drivers/usb/dwc3/debug.h                           |   3 +
 drivers/usb/dwc3/debugfs.c                         |  21 +--
 drivers/usb/dwc3/gadget.c                          |   3 +
 fs/afs/main.c                                      |   4 +-
 include/linux/cpuhotplug.h                         |   1 +
 include/linux/mfd/rohm-bd70528.h                   |   4 +-
 include/linux/mlx5/transobj.h                      |   1 +
 include/linux/ptp_clock_kernel.h                   |   2 +-
 include/linux/socket.h                             |   2 -
 include/net/net_namespace.h                        |   7 +
 include/uapi/linux/in.h                            |   3 +
 kernel/sched/fair.c                                |  44 ++---
 kernel/trace/trace.c                               |  11 --
 kernel/trace/trace_clock.c                         |   6 +-
 mm/memory-failure.c                                |   7 +-
 mm/slab_common.c                                   |   3 +-
 mm/slub.c                                          |  23 +--
 net/batman-adv/bat_iv_ogm.c                        |   4 +-
 net/bridge/br_private.h                            |   4 +-
 net/bridge/br_vlan_tunnel.c                        |  38 +++--
 net/can/bcm.c                                      |  62 +++++--
 net/can/j1939/transport.c                          |  54 ++++--
 net/can/raw.c                                      |  62 +++++--
 net/core/net_namespace.c                           |  12 ++
 net/core/rtnetlink.c                               |   8 +-
 net/ipv4/cipso_ipv4.c                              |   1 +
 net/ipv4/icmp.c                                    |   7 +
 net/ipv4/igmp.c                                    |   1 +
 net/ipv4/udp.c                                     |  10 ++
 net/ipv6/udp.c                                     |   3 +
 net/netfilter/nf_synproxy_core.c                   |   5 +
 net/qrtr/qrtr.c                                    |   2 +-
 net/rds/recv.c                                     |   2 +-
 net/sched/act_ct.c                                 |  21 ++-
 net/sched/sch_cake.c                               |   6 +-
 net/socket.c                                       |  13 --
 net/unix/af_unix.c                                 |   7 +-
 net/wireless/Makefile                              |   2 +-
 net/wireless/pmsr.c                                |  16 +-
 sound/soc/codecs/rt5659.c                          |  26 ++-
 tools/include/uapi/linux/in.h                      |   3 +
 virt/kvm/arm/vgic/vgic-kvm-device.c                |   4 +-
 96 files changed, 865 insertions(+), 339 deletions(-)


