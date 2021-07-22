Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A19A3D27EB
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 18:37:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230513AbhGVPxo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 11:53:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:57092 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231126AbhGVPxb (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 11:53:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3C3A16135F;
        Thu, 22 Jul 2021 16:34:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626971646;
        bh=LySjT2WxgRNrijBu32PU1Z0T9WC+9LrBTj1Ip1tdAIQ=;
        h=From:To:Cc:Subject:Date:From;
        b=nioWFUwvgU9P2woZQAJc+ybo7c+CVfQ0psismk5+KYS+oane1kzNW5V86nMKYdcbM
         4zjghtr4I3NZojBsP0jLj/jwqbtA8e7HJ0xJiuli1QsTx6KBftiVqCru60KvFVME33
         RTUubP4ao82iKTb0i9yBWVfdl1KGp7tTQAi66p7A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 5.4 00/71] 5.4.135-rc1 review
Date:   Thu, 22 Jul 2021 18:30:35 +0200
Message-Id: <20210722155617.865866034@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.135-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.135-rc1
X-KernelTest-Deadline: 2021-07-24T15:56+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.4.135 release.
There are 71 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat, 24 Jul 2021 15:56:00 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.135-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.4.135-rc1

Eric Dumazet <edumazet@google.com>
    udp: annotate data races around unix_sk(sk)->gso_size

Riccardo Mancini <rickyman7@gmail.com>
    perf test bpf: Free obj_buf

Gu Shengxian <gushengxian@yulong.com>
    bpftool: Properly close va_list 'ap' by va_end() on error

Eric Dumazet <edumazet@google.com>
    ipv6: tcp: drop silly ICMPv6 packet too big messages

Eric Dumazet <edumazet@google.com>
    tcp: annotate data races around tp->mtu_info

Jason Ekstrand <jason@jlekstrand.net>
    dma-buf/sync_file: Don't leak fences on merge failure

Pavel Skripkin <paskripkin@gmail.com>
    net: fddi: fix UAF in fza_probe

Taehee Yoo <ap420073@gmail.com>
    net: validate lwtstate->data before returning from skb_tunnel_info()

Alexander Ovechkin <ovov@yandex-team.ru>
    net: send SYNACK packet with accepted fwmark

Pavel Skripkin <paskripkin@gmail.com>
    net: ti: fix UAF in tlan_remove_one

Pavel Skripkin <paskripkin@gmail.com>
    net: qcom/emac: fix UAF in emac_remove

Pavel Skripkin <paskripkin@gmail.com>
    net: moxa: fix UAF in moxart_mac_probe

Hangbin Liu <liuhangbin@gmail.com>
    net: ip_tunnel: fix mtu calculation for ETHER tunnel devices

Florian Fainelli <f.fainelli@gmail.com>
    net: bcmgenet: Ensure all TX/RX queues DMAs are disabled

Wolfgang Bumiller <w.bumiller@proxmox.com>
    net: bridge: sync fdb to new unicast-filtering ports

wenxu <wenxu@ucloud.cn>
    net/sched: act_ct: fix err check for nf_conntrack_confirm

Vasily Averin <vvs@virtuozzo.com>
    netfilter: ctnetlink: suspicious RCU usage in ctnetlink_dump_helpinfo

Vadim Fedorenko <vfedorenko@novek.ru>
    net: ipv6: fix return value of ip6_skb_dst_mtu

Marek Behún <kabel@kernel.org>
    net: dsa: mv88e6xxx: enable .rmu_disable() on Topaz

Marek Behún <kabel@kernel.org>
    net: dsa: mv88e6xxx: enable .port_set_policy() on Topaz

Mikulas Patocka <mpatocka@redhat.com>
    dm writecache: return the exact table values that were set

Nanyong Sun <sunnanyong@huawei.com>
    mm: slab: fix kmem_cache_create failed when sysfs node not destroyed

Sanket Parmar <sparmar@cadence.com>
    usb: cdns3: Enable TDL_CHK only for OUT ep

Daniel Rosenberg <drosen@google.com>
    f2fs: Show casefolding support only when supported

Pali Rohár <pali@kernel.org>
    arm64: dts: marvell: armada-37xx: move firmware node to generic dtsi file

Pali Rohár <pali@kernel.org>
    firmware: turris-mox-rwtm: add marvell,armada-3700-rwtm-firmware compatible string

Marek Behún <marek.behun@nic.cz>
    arm64: dts: armada-3720-turris-mox: add firmware node

Paulo Alcantara <pc@cjr.nz>
    cifs: prevent NULL deref in cifs_compose_mount_options()

Heiko Carstens <hca@linux.ibm.com>
    s390: introduce proper type handling call_on_stack() macro

Odin Ugedal <odin@uged.al>
    sched/fair: Fix CFS bandwidth hrtimer expiry type

Javed Hasan <jhasan@marvell.com>
    scsi: qedf: Add check to synchronize abort and flush

Javed Hasan <jhasan@marvell.com>
    scsi: libfc: Fix array index out of bound exception

Yufen Yu <yuyufen@huawei.com>
    scsi: libsas: Add LUN number check in .slave_alloc callback

Colin Ian King <colin.king@canonical.com>
    scsi: aic7xxx: Fix unintentional sign extension issue on left shift of u8

Krzysztof Kozlowski <krzk@kernel.org>
    rtc: max77686: Do not enforce (incorrect) interrupt trigger type

Matthias Maennich <maennich@google.com>
    kbuild: mkcompile_h: consider timestamp if KBUILD_BUILD_TIMESTAMP is set

Yang Yingliang <yangyingliang@huawei.com>
    thermal/core: Correct function name thermal_zone_device_unregister()

Lucas Stach <l.stach@pengutronix.de>
    arm64: dts: imx8mq: assign PCIe clocks

Mian Yousaf Kaukab <ykaukab@suse.de>
    arm64: dts: ls208xa: remove bus-num from dspi node

Thierry Reding <treding@nvidia.com>
    firmware: tegra: bpmp: Fix Tegra234-only builds

Thierry Reding <treding@nvidia.com>
    soc/tegra: fuse: Fix Tegra234-only builds

Alexandre Torgue <alexandre.torgue@foss.st.com>
    ARM: dts: stm32: move stmmac axi config in ethernet node on stm32mp15

Alexandre Torgue <alexandre.torgue@foss.st.com>
    ARM: dts: stm32: fix i2c node name on stm32f746 to prevent warnings

Johan Jonker <jbx6244@gmail.com>
    ARM: dts: rockchip: fix supply properties in io-domains nodes

Sudeep Holla <sudeep.holla@arm.com>
    arm64: dts: juno: Update SCPI nodes as per the YAML schema

Alexandre Torgue <alexandre.torgue@foss.st.com>
    ARM: dts: stm32: fix timer nodes on STM32 MCU to prevent warnings

Alexandre Torgue <alexandre.torgue@foss.st.com>
    ARM: dts: stm32: fix RCC node name on stm32f429 MCU

Alexandre Torgue <alexandre.torgue@foss.st.com>
    ARM: dts: stm32: fix gpio-keys node on STM32 MCU boards

Grygorii Strashko <grygorii.strashko@ti.com>
    ARM: dts: am437x-gp-evm: fix ti,no-reset-on-init flag for gpios

Grygorii Strashko <grygorii.strashko@ti.com>
    ARM: dts: am57xx-cl-som-am57x: fix ti,no-reset-on-init flag for gpios

Masahiro Yamada <masahiroy@kernel.org>
    kbuild: sink stdout from cmd for silent build

Bixuan Cui <cuibixuan@huawei.com>
    rtc: mxc_v2: add missing MODULE_DEVICE_TABLE

Jonathan Neuschäfer <j.neuschaefer@gmx.net>
    ARM: imx: pm-imx5: Fix references to imx5_cpu_suspend_info

Primoz Fiser <primoz.fiser@norik.com>
    ARM: dts: imx6: phyFLEX: Fix UART hardware flow control

Rafał Miłecki <rafal@milecki.pl>
    ARM: dts: Hurricane 2: Fix NAND nodes names

Rafał Miłecki <rafal@milecki.pl>
    ARM: dts: BCM63xx: Fix NAND nodes names

Rafał Miłecki <rafal@milecki.pl>
    ARM: NSP: dts: fix NAND nodes names

Rafał Miłecki <rafal@milecki.pl>
    ARM: Cygnus: dts: fix NAND nodes names

Rafał Miłecki <rafal@milecki.pl>
    ARM: brcmstb: dts: fix NAND nodes names

Philipp Zabel <p.zabel@pengutronix.de>
    reset: ti-syscon: fix to_ti_syscon_reset_data macro

Elaine Zhang <zhangqing@rock-chips.com>
    arm64: dts: rockchip: Fix power-controller node names for rk3328

Elaine Zhang <zhangqing@rock-chips.com>
    arm64: dts: rockchip: Fix power-controller node names for px30

Elaine Zhang <zhangqing@rock-chips.com>
    ARM: dts: rockchip: Fix power-controller node names for rk3288

Elaine Zhang <zhangqing@rock-chips.com>
    ARM: dts: rockchip: Fix power-controller node names for rk3188

Elaine Zhang <zhangqing@rock-chips.com>
    ARM: dts: rockchip: Fix power-controller node names for rk3066a

Benjamin Gaignard <benjamin.gaignard@collabora.com>
    ARM: dts: rockchip: Fix IOMMU nodes properties on rk322x

Ezequiel Garcia <ezequiel@collabora.com>
    ARM: dts: rockchip: Fix the timer clocks order

Johan Jonker <jbx6244@gmail.com>
    arm64: dts: rockchip: fix pinctrl sleep nodename for rk3399.dtsi

Johan Jonker <jbx6244@gmail.com>
    ARM: dts: rockchip: fix pinctrl sleep nodename for rk3036-kylin and rk3288

Corentin Labbe <clabbe@baylibre.com>
    ARM: dts: gemini: add device_type on pci

Corentin Labbe <clabbe@baylibre.com>
    ARM: dts: gemini: rename mdio to the right name


-------------

Diffstat:

 Makefile                                           |  4 +-
 arch/arm/boot/dts/am437x-gp-evm.dts                |  5 +-
 arch/arm/boot/dts/am437x-l4.dtsi                   |  2 +-
 arch/arm/boot/dts/am57xx-cl-som-am57x.dts          |  5 +-
 arch/arm/boot/dts/bcm-cygnus.dtsi                  |  2 +-
 arch/arm/boot/dts/bcm-hr2.dtsi                     |  2 +-
 arch/arm/boot/dts/bcm-nsp.dtsi                     |  2 +-
 arch/arm/boot/dts/bcm63138.dtsi                    |  2 +-
 arch/arm/boot/dts/bcm7445-bcm97445svmb.dts         |  4 +-
 arch/arm/boot/dts/bcm7445.dtsi                     |  2 +-
 arch/arm/boot/dts/bcm911360_entphn.dts             |  4 +-
 arch/arm/boot/dts/bcm958300k.dts                   |  4 +-
 arch/arm/boot/dts/bcm958305k.dts                   |  4 +-
 arch/arm/boot/dts/bcm958522er.dts                  |  4 +-
 arch/arm/boot/dts/bcm958525er.dts                  |  4 +-
 arch/arm/boot/dts/bcm958525xmc.dts                 |  4 +-
 arch/arm/boot/dts/bcm958622hr.dts                  |  4 +-
 arch/arm/boot/dts/bcm958623hr.dts                  |  4 +-
 arch/arm/boot/dts/bcm958625hr.dts                  |  4 +-
 arch/arm/boot/dts/bcm958625k.dts                   |  4 +-
 arch/arm/boot/dts/bcm963138dvt.dts                 |  4 +-
 arch/arm/boot/dts/bcm988312hr.dts                  |  4 +-
 arch/arm/boot/dts/dra7-l4.dtsi                     |  4 +-
 arch/arm/boot/dts/gemini-dlink-dns-313.dts         |  2 +-
 arch/arm/boot/dts/gemini-nas4220b.dts              |  2 +-
 arch/arm/boot/dts/gemini-rut1xx.dts                |  2 +-
 arch/arm/boot/dts/gemini-wbd111.dts                |  2 +-
 arch/arm/boot/dts/gemini-wbd222.dts                |  2 +-
 arch/arm/boot/dts/gemini.dtsi                      |  1 +
 arch/arm/boot/dts/imx6qdl-phytec-pfla02.dtsi       |  5 +-
 arch/arm/boot/dts/rk3036-kylin.dts                 |  2 +-
 arch/arm/boot/dts/rk3066a.dtsi                     |  6 +-
 arch/arm/boot/dts/rk3188.dtsi                      | 14 ++--
 arch/arm/boot/dts/rk322x.dtsi                      | 10 +--
 arch/arm/boot/dts/rk3288-rock2-som.dtsi            |  2 +-
 arch/arm/boot/dts/rk3288-vyasa.dts                 |  4 +-
 arch/arm/boot/dts/rk3288.dtsi                      | 14 ++--
 arch/arm/boot/dts/stm32429i-eval.dts               |  8 +-
 arch/arm/boot/dts/stm32746g-eval.dts               |  6 +-
 arch/arm/boot/dts/stm32f429-disco.dts              |  6 +-
 arch/arm/boot/dts/stm32f429.dtsi                   | 10 +--
 arch/arm/boot/dts/stm32f469-disco.dts              |  6 +-
 arch/arm/boot/dts/stm32f746.dtsi                   | 12 +--
 arch/arm/boot/dts/stm32f769-disco.dts              |  6 +-
 arch/arm/boot/dts/stm32h743.dtsi                   |  4 -
 arch/arm/boot/dts/stm32mp157c.dtsi                 | 12 +--
 arch/arm/mach-imx/suspend-imx53.S                  |  4 +-
 arch/arm64/boot/dts/arm/juno-base.dtsi             |  6 +-
 arch/arm64/boot/dts/freescale/fsl-ls208xa.dtsi     |  1 -
 arch/arm64/boot/dts/freescale/imx8mq.dtsi          | 16 ++++
 .../boot/dts/marvell/armada-3720-turris-mox.dts    |  6 ++
 arch/arm64/boot/dts/marvell/armada-37xx.dtsi       |  8 ++
 arch/arm64/boot/dts/rockchip/px30.dtsi             | 16 ++--
 arch/arm64/boot/dts/rockchip/rk3328.dtsi           |  6 +-
 arch/arm64/boot/dts/rockchip/rk3399.dtsi           |  2 +-
 arch/s390/include/asm/stacktrace.h                 | 97 ++++++++++++++++++++++
 drivers/dma-buf/sync_file.c                        | 13 +--
 drivers/firmware/tegra/Makefile                    |  1 +
 drivers/firmware/tegra/bpmp-private.h              |  3 +-
 drivers/firmware/tegra/bpmp.c                      |  3 +-
 drivers/firmware/turris-mox-rwtm.c                 |  1 +
 drivers/md/dm-writecache.c                         | 32 +++----
 drivers/net/dsa/mv88e6xxx/chip.c                   |  4 +
 drivers/net/ethernet/broadcom/genet/bcmgenet.c     |  6 ++
 drivers/net/ethernet/moxa/moxart_ether.c           |  4 +-
 drivers/net/ethernet/qualcomm/emac/emac.c          |  3 +-
 drivers/net/ethernet/ti/tlan.c                     |  3 +-
 drivers/net/fddi/defza.c                           |  3 +-
 drivers/reset/reset-ti-syscon.c                    |  4 +-
 drivers/rtc/rtc-max77686.c                         |  4 +-
 drivers/rtc/rtc-mxc_v2.c                           |  1 +
 drivers/scsi/aic7xxx/aic7xxx_core.c                |  2 +-
 drivers/scsi/aic94xx/aic94xx_init.c                |  1 +
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c             |  1 +
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c             |  1 +
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c             |  1 +
 drivers/scsi/isci/init.c                           |  1 +
 drivers/scsi/libfc/fc_rport.c                      | 13 +--
 drivers/scsi/libsas/sas_scsi_host.c                |  9 ++
 drivers/scsi/mvsas/mv_init.c                       |  1 +
 drivers/scsi/pm8001/pm8001_init.c                  |  1 +
 drivers/scsi/qedf/qedf_io.c                        | 22 ++++-
 drivers/soc/tegra/fuse/fuse-tegra30.c              |  3 +-
 drivers/thermal/thermal_core.c                     |  2 +-
 drivers/usb/cdns3/gadget.c                         |  8 +-
 fs/cifs/cifs_dfs_ref.c                             |  3 +
 fs/f2fs/sysfs.c                                    |  4 +
 include/net/dst_metadata.h                         |  4 +-
 include/net/ip6_route.h                            |  2 +-
 kernel/sched/fair.c                                |  4 +-
 mm/slab_common.c                                   | 18 ++--
 net/bridge/br_if.c                                 | 17 +++-
 net/ipv4/ip_tunnel.c                               | 18 +++-
 net/ipv4/tcp_ipv4.c                                |  4 +-
 net/ipv4/tcp_output.c                              |  1 +
 net/ipv4/udp.c                                     |  6 +-
 net/ipv6/tcp_ipv6.c                                | 23 ++++-
 net/ipv6/udp.c                                     |  2 +-
 net/ipv6/xfrm6_output.c                            |  2 +-
 net/netfilter/nf_conntrack_netlink.c               |  3 +
 net/sched/act_ct.c                                 |  3 +-
 scripts/Kbuild.include                             |  7 +-
 scripts/mkcompile_h                                | 14 +++-
 tools/bpf/bpftool/jit_disasm.c                     |  6 +-
 tools/perf/tests/bpf.c                             |  2 +
 105 files changed, 449 insertions(+), 227 deletions(-)


