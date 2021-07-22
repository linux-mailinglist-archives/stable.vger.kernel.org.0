Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 679E03D29A7
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 19:06:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234140AbhGVQFx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 12:05:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:40490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233423AbhGVQDw (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 12:03:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C76EC61C63;
        Thu, 22 Jul 2021 16:44:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626972244;
        bh=WuhDL3t8HkTmp3m5JWhsv5Nnia81YfNU6jvf/wgZJb4=;
        h=From:To:Cc:Subject:Date:From;
        b=eCLpWytJNzbVQ+qUOapKswOCMD2Gy7cbKatB21vSYQMod+ggwhdTvl4DM/qiMLBc0
         lBLbSmxw/1Bz6ofqeMiUwCV7AwPCHmI1ISB1Dvche+PQdLHzqI3sEakMvqj9whwnJw
         amhHnrFffJMmo7WdJxGhEnHt3jJlGttcMCvRxcNE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 5.13 000/156] 5.13.5-rc1 review
Date:   Thu, 22 Jul 2021 18:29:35 +0200
Message-Id: <20210722155628.371356843@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.13.5-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.13.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.13.5-rc1
X-KernelTest-Deadline: 2021-07-24T15:56+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.13.5 release.
There are 156 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat, 24 Jul 2021 15:56:00 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.13.5-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.13.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.13.5-rc1

Aaron Ma <aaron.ma@canonical.com>
    mt76: mt7921: continue to probe driver when fw already downloaded

Paolo Abeni <pabeni@redhat.com>
    udp: properly flush normal packet at GRO time

Eric Dumazet <edumazet@google.com>
    udp: annotate data races around unix_sk(sk)->gso_size

Cristian Marussi <cristian.marussi@arm.com>
    firmware: arm_scmi: Avoid padding in sensor message structure

Linus Walleij <linus.walleij@linaro.org>
    drm/panel: nt35510: Do not fail if DSI read fails

Riccardo Mancini <rickyman7@gmail.com>
    perf test bpf: Free obj_buf

John Fastabend <john.fastabend@gmail.com>
    bpf: Track subprog poke descriptors correctly and fix use-after-free

Gu Shengxian <gushengxian@yulong.com>
    bpftool: Properly close va_list 'ap' by va_end() on error

Wei Li <liwei391@huawei.com>
    tools: bpf: Fix error in 'make -C tools/ bpf_install'

Talal Ahmad <talalahmad@google.com>
    tcp: call sk_wmem_schedule before sk_mem_charge in zerocopy path

Eric Dumazet <edumazet@google.com>
    ipv6: tcp: drop silly ICMPv6 packet too big messages

Nguyen Dinh Phi <phind.uet@gmail.com>
    tcp: fix tcp_init_transfer() to not reset icsk_ca_initialized

Eric Dumazet <edumazet@google.com>
    tcp: annotate data races around tp->mtu_info

Paolo Abeni <pabeni@redhat.com>
    tcp: consistently disable header prediction for mptcp

Andrew Jeffery <andrew@aj.id.au>
    ARM: dts: everest: Add phase corrections for eMMC

Andrew Jeffery <andrew@aj.id.au>
    ARM: dts: tacoma: Add phase corrections for eMMC

Joel Stanley <joel@jms.id.au>
    ARM: dts: aspeed: Fix AST2600 machines line names

Hans de Goede <hdegoede@redhat.com>
    vboxsf: Add support for the atomic_open directory-inode op

Hans de Goede <hdegoede@redhat.com>
    vboxsf: Add vboxsf_[create|release]_sf_handle() helpers

Hans de Goede <hdegoede@redhat.com>
    vboxsf: Make vboxsf_dir_create() return the handle for the created file

Hans de Goede <hdegoede@redhat.com>
    vboxsf: Honor excl flag to the dir-inode create op

Masahiro Yamada <masahiroy@kernel.org>
    kbuild: do not suppress Kconfig prompts for silent build

Jason Ekstrand <jason@jlekstrand.net>
    dma-buf/sync_file: Don't leak fences on merge failure

Pavel Skripkin <paskripkin@gmail.com>
    net: fddi: fix UAF in fza_probe

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dsa: properly check for the bridge_leave methods in dsa_switch_bridge_leave()

Taehee Yoo <ap420073@gmail.com>
    net: validate lwtstate->data before returning from skb_tunnel_info()

Antoine Tenart <atenart@kernel.org>
    net: do not reuse skbuff allocated from skbuff_fclone_cache in the skb cache

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

Taehee Yoo <ap420073@gmail.com>
    net: netdevsim: use xso.real_dev instead of xso.dev in callback functions of struct xfrmdev_ops

Lorenzo Bianconi <lorenzo@kernel.org>
    net: marvell: always set skb_shared_info in mvneta_swbm_add_rx_fragment

Wolfgang Bumiller <w.bumiller@proxmox.com>
    net: bridge: sync fdb to new unicast-filtering ports

Louis Peens <louis.peens@corigine.com>
    net/sched: act_ct: remove and free nf_table callbacks

Ronak Doshi <doshir@vmware.com>
    vmxnet3: fix cksum offload issues for tunnels with non-default udp ports

Colin Ian King <colin.king@canonical.com>
    netfilter: nf_tables: Fix dereference of null pointer flow

wenxu <wenxu@ucloud.cn>
    net/sched: act_ct: fix err check for nf_conntrack_confirm

Vasily Averin <vvs@virtuozzo.com>
    netfilter: ctnetlink: suspicious RCU usage in ctnetlink_dump_helpinfo

Vadim Fedorenko <vfedorenko@novek.ru>
    net: ipv6: fix return value of ip6_skb_dst_mtu

Marek Behún <kabel@kernel.org>
    net: dsa: mv88e6xxx: enable SerDes PCS register dump via ethtool -d on Topaz

Marek Behún <kabel@kernel.org>
    net: dsa: mv88e6xxx: enable SerDes RX stats for Topaz

Marek Behún <kabel@kernel.org>
    net: dsa: mv88e6xxx: enable devlink ATU hash param for Topaz

Marek Behún <kabel@kernel.org>
    net: dsa: mv88e6xxx: enable .rmu_disable() on Topaz

Marek Behún <kabel@kernel.org>
    net: dsa: mv88e6xxx: use correct .stats_set_histogram() on Topaz

Marek Behún <kabel@kernel.org>
    net: dsa: mv88e6xxx: enable .port_set_policy() on Topaz

Doug Berger <opendmb@gmail.com>
    net: bcmgenet: ensure EXT_ENERGY_DET_MASK is clear

Daniel Rosenberg <drosen@google.com>
    f2fs: Show casefolding support only when supported

Peter Xu <peterx@redhat.com>
    mm/userfaultfd: fix uffd-wp special cases for fork()

Peter Xu <peterx@redhat.com>
    mm/thp: simplify copying of huge zero page pmd when fork

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "mm/shmem: fix shmem_swapin() race with swapoff"

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "swap: fix do_swap_page() race with swapoff"

Pali Rohár <pali@kernel.org>
    arm64: dts: marvell: armada-37xx: move firmware node to generic dtsi file

Pali Rohár <pali@kernel.org>
    firmware: turris-mox-rwtm: add marvell,armada-3700-rwtm-firmware compatible string

Paulo Alcantara <pc@cjr.nz>
    cifs: prevent NULL deref in cifs_compose_mount_options()

Heiko Carstens <hca@linux.ibm.com>
    s390: introduce proper type handling call_on_stack() macro

Ilya Leoshkevich <iii@linux.ibm.com>
    s390/traps: do not test MONITOR CALL without CONFIG_BUG

Dmitry Osipenko <digetx@gmail.com>
    thermal/core/thermal_of: Stop zone device before unregistering it

Kan Liang <kan.liang@linux.intel.com>
    perf/x86/intel/uncore: Clean up error handling path of iio mapping

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

Konstantin Porotchkin <kostap@marvell.com>
    arch/arm64/boot/dts/marvell: fix NAND partitioning scheme

Matthias Maennich <maennich@google.com>
    kbuild: mkcompile_h: consider timestamp if KBUILD_BUILD_TIMESTAMP is set

Konrad Dybcio <konrad.dybcio@somainline.org>
    arm64: dts: qcom: sm8150: Disable Adreno and modem by default

Konrad Dybcio <konrad.dybcio@somainline.org>
    arm64: dts: qcom: sm8250: Fix pcie2_lane unit address

Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
    thermal/drivers/sprd: Add missing of_node_put for loop iteration

Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
    thermal/drivers/imx_sc: Add missing of_node_put for loop iteration

Geert Uytterhoeven <geert+renesas@glider.be>
    thermal/drivers/rcar_gen3_thermal: Do not shadow rcar_gen3_ths_tj_1

Yang Yingliang <yangyingliang@huawei.com>
    thermal/core: Correct function name thermal_zone_device_unregister()

Dong Aisheng <aisheng.dong@nxp.com>
    arm64: dts: imx8: conn: fix enet clock setting

Lucas Stach <l.stach@pengutronix.de>
    arm64: dts: imx8mq: assign PCIe clocks

Adam Ford <aford173@gmail.com>
    arm64: dts: imx8mn-beacon-som: Assign PMIC clock

Mian Yousaf Kaukab <ykaukab@suse.de>
    arm64: dts: ls208xa: remove bus-num from dspi node

Punit Agrawal <punitagrawal@gmail.com>
    arm64: dts: rockchip: Update RK3399 PCI host bridge window to 32-bit address memory

Thierry Reding <treding@nvidia.com>
    firmware: tegra: bpmp: Fix Tegra234-only builds

Thierry Reding <treding@nvidia.com>
    soc/tegra: fuse: Fix Tegra234-only builds

Tony Lindgren <tony@atomide.com>
    ARM: OMAP2+: Block suspend for am3 and am4 if PM is not configured

Srinivasa Rao Mandadapu <srivasam@codeaurora.org>
    arm64: dts: qcom: sc7180: Add wakeup delay for adau codec

Alexandre Torgue <alexandre.torgue@foss.st.com>
    ARM: dts: stm32: fix stpmic node for stm32mp1 boards

Marek Vasut <marex@denx.de>
    ARM: dts: stm32: Rename spi-flash/mx66l51235l@N to flash@N on DHCOM SoM

Marek Vasut <marex@denx.de>
    ARM: dts: stm32: Rename eth@N to ethernet@N on DHCOM SoM

Marek Vasut <marex@denx.de>
    ARM: dts: stm32: Drop unused linux,wakeup from touchscreen node on DHCOM SoM

Grzegorz Szymaszek <gszymaszek@short.pl>
    ARM: dts: stm32: fix the Odyssey SoM eMMC VQMMC supply

Alexandre Torgue <alexandre.torgue@foss.st.com>
    ARM: dts: stm32: fix ltdc pinctrl on microdev2.0-of7

Alexandre Torgue <alexandre.torgue@foss.st.com>
    ARM: dts: stm32: move stmmac axi config in ethernet node on stm32mp15

Alexandre Torgue <alexandre.torgue@foss.st.com>
    ARM: dts: stm32: fix i2c node name on stm32f746 to prevent warnings

Johan Jonker <jbx6244@gmail.com>
    ARM: dts: rockchip: fix supply properties in io-domains nodes

Sudeep Holla <sudeep.holla@arm.com>
    arm64: dts: juno: Update SCPI nodes as per the YAML schema

Yang Yingliang <yangyingliang@huawei.com>
    i3c: master: svc: drop free_irq of devm_request_irq allocated irq

Stefan Wahren <stefan.wahren@i2se.com>
    ARM: dts: bcm283x: Fix up GPIO LED node names

Stefan Wahren <stefan.wahren@i2se.com>
    ARM: dts: bcm283x: Fix up MMC node names

Santosh Puranik <santosh.puranik@in.ibm.com>
    ARM: dts: aspeed: Everest: Fix cable card PCA chips

Sudeep Holla <sudeep.holla@arm.com>
    firmware: arm_scmi: Fix the build when CONFIG_MAILBOX is not selected

Etienne Carriere <etienne.carriere@linaro.org>
    firmware: arm_scmi: Add SMCCC discovery dependency in Kconfig

Dmitry Osipenko <digetx@gmail.com>
    memory: tegra: Fix compilation warnings on 64bit platforms

Alexandre Torgue <alexandre.torgue@foss.st.com>
    ARM: dts: stm32: fix timer nodes on STM32 MCU to prevent warnings

Alexandre Torgue <alexandre.torgue@foss.st.com>
    ARM: dts: stm32: fix RCC node name on stm32f429 MCU

Alexandre Torgue <alexandre.torgue@foss.st.com>
    ARM: dts: stm32: fix gpio-keys node on STM32 MCU boards

Grzegorz Szymaszek <gszymaszek@short.pl>
    ARM: dts: stm32: fix stm32mp157c-odyssey card detect pin

Marek Vasut <marex@denx.de>
    ARM: dts: stm32: Fix touchscreen node on dhcom-pdk2

Marek Vasut <marex@denx.de>
    ARM: dts: stm32: Remove extra size-cells on dhcom-pdk2

Sujit Kautkar <sujitka@chromium.org>
    arm64: dts: qcom: sc7180: Move rmtfs memory region

Jonathan Marek <jonathan@marek.ca>
    arm64: dts: qcom: sm8250: fix display nodes

Konrad Dybcio <konrad.dybcio@somainline.org>
    arm64: dts: qcom: msm8996: Make CPUCC actually probe (and work)

Vinod Koul <vkoul@kernel.org>
    arm64: dts: qcom: sm8350: fix the node unit addresses

Dmitry Osipenko <digetx@gmail.com>
    ARM: tegra: nexus7: Correct 3v3 regulator GPIO of PM269 variant

Dmitry Osipenko <digetx@gmail.com>
    ARM: tegra: wm8903: Fix polarity of headphones-detection GPIO in device-trees

Grygorii Strashko <grygorii.strashko@ti.com>
    arm64: dts: ti: k3-am654x/j721e/j7200-common-proc-board: Fix MCU_RGMII1_TXC direction

Jon Hunter <jonathanh@nvidia.com>
    arm64: tegra: Add PMU node for Tegra194

Suman Anna <s-anna@ti.com>
    ARM: dts: OMAP2+: Replace underscores in sub-mailbox node names

Grygorii Strashko <grygorii.strashko@ti.com>
    ARM: dts: am335x: fix ti,no-reset-on-init flag for gpios

Grygorii Strashko <grygorii.strashko@ti.com>
    ARM: dts: am437x-gp-evm: fix ti,no-reset-on-init flag for gpios

Grygorii Strashko <grygorii.strashko@ti.com>
    ARM: dts: am57xx-cl-som-am57x: fix ti,no-reset-on-init flag for gpios

Masahiro Yamada <masahiroy@kernel.org>
    kbuild: sink stdout from cmd for silent build

Adam Ford <aford173@gmail.com>
    arm64: dts: renesas: beacon: Fix USB ref clock references

Adam Ford <aford173@gmail.com>
    arm64: dts: renesas: beacon: Fix USB extal reference

Bixuan Cui <cuibixuan@huawei.com>
    rtc: mxc_v2: add missing MODULE_DEVICE_TABLE

Linus Walleij <linus.walleij@linaro.org>
    ARM: dts: ux500: Fix orientation of Janice accelerometer

Oleksij Rempel <linux@rempel-privat.de>
    ARM: dts: imx6dl-riotboard: configure PHY clock and set proper EEE value

Linus Walleij <linus.walleij@linaro.org>
    ARM: dts: ux500: Fix some compatible strings

Linus Walleij <linus.walleij@linaro.org>
    ARM: dts: ux500: Fix orientation of accelerometer

Sebastian Reichel <sebastian.reichel@collabora.com>
    ARM: dts: ux500: Rename gpio-controller node

Sebastian Reichel <sebastian.reichel@collabora.com>
    ARM: dts: ux500: Fix interrupt cells

Johan Jonker <jbx6244@gmail.com>
    arm64: dts: rockchip: fix regulator-gpio states array

Jonathan Neuschäfer <j.neuschaefer@gmx.net>
    ARM: imx: pm-imx5: Fix references to imx5_cpu_suspend_info

Primoz Fiser <primoz.fiser@norik.com>
    ARM: dts: imx6: phyFLEX: Fix UART hardware flow control

Zou Wei <zou_wei@huawei.com>
    soc: mediatek: add missing MODULE_DEVICE_TABLE

Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
    soc: bcm: brcmstb: remove unused variable 'brcmstb_machine_match'

Rafał Miłecki <rafal@milecki.pl>
    ARM: dts: BCM5301X: Fix pinmux subnodes names

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

Rafał Miłecki <rafal@milecki.pl>
    ARM: dts: BCM5301X: Fix NAND nodes names

Philipp Zabel <p.zabel@pengutronix.de>
    reset: ti-syscon: fix to_ti_syscon_reset_data macro

Elaine Zhang <zhangqing@rock-chips.com>
    arm64: dts: rockchip: Fix power-controller node names for rk3399

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

Peter Robinson <pbrobinson@gmail.com>
    arm64: dts: rockchip: Use only supported PCIe link speed on rk3399

Johan Jonker <jbx6244@gmail.com>
    ARM: dts: rockchip: fix pinctrl sleep nodename for rk3036-kylin and rk3288

Ezequiel Garcia <ezequiel@collabora.com>
    ARM: dts: rockchip: Fix thermal sensor cells o rk322x

Corentin Labbe <clabbe@baylibre.com>
    ARM: dts: gemini: add device_type on pci

Corentin Labbe <clabbe@baylibre.com>
    ARM: dts: gemini: rename mdio to the right name


-------------

Diffstat:

 Makefile                                           |  13 +-
 arch/arm/boot/dts/am335x-baltos.dtsi               |   4 +-
 arch/arm/boot/dts/am335x-evmsk.dts                 |   2 +-
 arch/arm/boot/dts/am335x-moxa-uc-2100-common.dtsi  |   2 +-
 arch/arm/boot/dts/am335x-moxa-uc-8100-common.dtsi  |   2 +-
 arch/arm/boot/dts/am33xx-l4.dtsi                   |   2 +-
 arch/arm/boot/dts/am437x-gp-evm.dts                |   5 +-
 arch/arm/boot/dts/am437x-l4.dtsi                   |   2 +-
 arch/arm/boot/dts/am57xx-cl-som-am57x.dts          |  13 +-
 arch/arm/boot/dts/aspeed-bmc-ibm-everest.dts       | 169 ++++++++++-----------
 arch/arm/boot/dts/aspeed-bmc-ibm-rainier.dts       |   5 +-
 arch/arm/boot/dts/aspeed-bmc-opp-tacoma.dts        |   6 +-
 arch/arm/boot/dts/bcm-cygnus.dtsi                  |   2 +-
 arch/arm/boot/dts/bcm-hr2.dtsi                     |   2 +-
 arch/arm/boot/dts/bcm-nsp.dtsi                     |   2 +-
 arch/arm/boot/dts/bcm2711-rpi-4-b.dts              |   4 +-
 arch/arm/boot/dts/bcm2711.dtsi                     |   2 +-
 arch/arm/boot/dts/bcm2835-rpi-a-plus.dts           |   4 +-
 arch/arm/boot/dts/bcm2835-rpi-a.dts                |   2 +-
 arch/arm/boot/dts/bcm2835-rpi-b-plus.dts           |   4 +-
 arch/arm/boot/dts/bcm2835-rpi-b-rev2.dts           |   2 +-
 arch/arm/boot/dts/bcm2835-rpi-b.dts                |   2 +-
 arch/arm/boot/dts/bcm2835-rpi-cm1.dtsi             |   2 +-
 arch/arm/boot/dts/bcm2835-rpi-zero-w.dts           |   2 +-
 arch/arm/boot/dts/bcm2835-rpi-zero.dts             |   2 +-
 arch/arm/boot/dts/bcm2835-rpi.dtsi                 |   2 +-
 arch/arm/boot/dts/bcm2836-rpi-2-b.dts              |   4 +-
 arch/arm/boot/dts/bcm2837-rpi-3-a-plus.dts         |   4 +-
 arch/arm/boot/dts/bcm2837-rpi-3-b-plus.dts         |   4 +-
 arch/arm/boot/dts/bcm2837-rpi-3-b.dts              |   2 +-
 arch/arm/boot/dts/bcm2837-rpi-cm3.dtsi             |   2 +-
 arch/arm/boot/dts/bcm283x.dtsi                     |   2 +-
 arch/arm/boot/dts/bcm4708-luxul-xwc-1000.dts       |   4 +-
 arch/arm/boot/dts/bcm47094-dlink-dir-885l.dts      |   4 +-
 arch/arm/boot/dts/bcm47094.dtsi                    |   2 +-
 arch/arm/boot/dts/bcm5301x-nand-cs0.dtsi           |   4 +-
 arch/arm/boot/dts/bcm5301x.dtsi                    |   8 +-
 arch/arm/boot/dts/bcm63138.dtsi                    |   2 +-
 arch/arm/boot/dts/bcm7445-bcm97445svmb.dts         |   4 +-
 arch/arm/boot/dts/bcm7445.dtsi                     |   2 +-
 arch/arm/boot/dts/bcm911360_entphn.dts             |   4 +-
 arch/arm/boot/dts/bcm953012k.dts                   |   4 +-
 arch/arm/boot/dts/bcm958300k.dts                   |   4 +-
 arch/arm/boot/dts/bcm958305k.dts                   |   4 +-
 arch/arm/boot/dts/bcm958522er.dts                  |   4 +-
 arch/arm/boot/dts/bcm958525er.dts                  |   4 +-
 arch/arm/boot/dts/bcm958525xmc.dts                 |   4 +-
 arch/arm/boot/dts/bcm958622hr.dts                  |   4 +-
 arch/arm/boot/dts/bcm958623hr.dts                  |   4 +-
 arch/arm/boot/dts/bcm958625hr.dts                  |   4 +-
 arch/arm/boot/dts/bcm958625k.dts                   |   4 +-
 arch/arm/boot/dts/bcm963138dvt.dts                 |   4 +-
 arch/arm/boot/dts/bcm988312hr.dts                  |   4 +-
 arch/arm/boot/dts/dm816x.dtsi                      |   2 +-
 arch/arm/boot/dts/dra7-ipu-dsp-common.dtsi         |   6 +-
 arch/arm/boot/dts/dra7-l4.dtsi                     |   4 +-
 arch/arm/boot/dts/dra72x.dtsi                      |   6 +-
 arch/arm/boot/dts/dra74-ipu-dsp-common.dtsi        |   2 +-
 arch/arm/boot/dts/dra74x.dtsi                      |   8 +-
 arch/arm/boot/dts/gemini-dlink-dns-313.dts         |   2 +-
 arch/arm/boot/dts/gemini-nas4220b.dts              |   2 +-
 arch/arm/boot/dts/gemini-rut1xx.dts                |   2 +-
 arch/arm/boot/dts/gemini-wbd111.dts                |   2 +-
 arch/arm/boot/dts/gemini-wbd222.dts                |   2 +-
 arch/arm/boot/dts/gemini.dtsi                      |   1 +
 arch/arm/boot/dts/imx6dl-riotboard.dts             |   2 +
 arch/arm/boot/dts/imx6qdl-phytec-pfla02.dtsi       |   5 +-
 arch/arm/boot/dts/omap4-l4.dtsi                    |   4 +-
 arch/arm/boot/dts/omap5-l4.dtsi                    |   4 +-
 arch/arm/boot/dts/rk3036-kylin.dts                 |   2 +-
 arch/arm/boot/dts/rk3066a.dtsi                     |   6 +-
 arch/arm/boot/dts/rk3188.dtsi                      |  14 +-
 arch/arm/boot/dts/rk322x.dtsi                      |  12 +-
 arch/arm/boot/dts/rk3288-rock2-som.dtsi            |   2 +-
 arch/arm/boot/dts/rk3288-vyasa.dts                 |   4 +-
 arch/arm/boot/dts/rk3288.dtsi                      |  14 +-
 arch/arm/boot/dts/ste-ab8500.dtsi                  |  28 ++--
 arch/arm/boot/dts/ste-ab8505.dtsi                  |  24 +--
 arch/arm/boot/dts/ste-href-ab8500.dtsi             |   2 +-
 arch/arm/boot/dts/ste-href-tvk1281618-r3.dtsi      |   3 +
 arch/arm/boot/dts/ste-href.dtsi                    |   2 +-
 arch/arm/boot/dts/ste-snowball.dts                 |   2 +-
 arch/arm/boot/dts/ste-ux500-samsung-golden.dts     |   3 +-
 arch/arm/boot/dts/ste-ux500-samsung-janice.dts     |  11 +-
 arch/arm/boot/dts/ste-ux500-samsung-skomer.dts     |   3 +-
 arch/arm/boot/dts/stm32429i-eval.dts               |   8 +-
 arch/arm/boot/dts/stm32746g-eval.dts               |   6 +-
 arch/arm/boot/dts/stm32f429-disco.dts              |   6 +-
 arch/arm/boot/dts/stm32f429.dtsi                   |  10 +-
 arch/arm/boot/dts/stm32f469-disco.dts              |   6 +-
 arch/arm/boot/dts/stm32f746.dtsi                   |  12 +-
 arch/arm/boot/dts/stm32f769-disco.dts              |   6 +-
 arch/arm/boot/dts/stm32h743.dtsi                   |   4 -
 arch/arm/boot/dts/stm32mp151.dtsi                  |  12 +-
 ...m32mp157a-microgea-stm32mp1-microdev2.0-of7.dts |   2 +-
 arch/arm/boot/dts/stm32mp157a-stinger96.dtsi       |   7 +-
 arch/arm/boot/dts/stm32mp157c-odyssey-som.dtsi     |   7 +-
 arch/arm/boot/dts/stm32mp157c-odyssey.dts          |   2 +-
 arch/arm/boot/dts/stm32mp15xx-dhcom-pdk2.dtsi      |   7 +-
 arch/arm/boot/dts/stm32mp15xx-dhcom-som.dtsi       |   9 +-
 arch/arm/boot/dts/stm32mp15xx-dhcor-som.dtsi       |   2 +-
 arch/arm/boot/dts/stm32mp15xx-osd32.dtsi           |   7 +-
 arch/arm/boot/dts/tegra20-acer-a500-picasso.dts    |   2 +-
 arch/arm/boot/dts/tegra20-harmony.dts              |   2 +-
 arch/arm/boot/dts/tegra20-medcom-wide.dts          |   2 +-
 arch/arm/boot/dts/tegra20-plutux.dts               |   2 +-
 arch/arm/boot/dts/tegra20-seaboard.dts             |   2 +-
 arch/arm/boot/dts/tegra20-tec.dts                  |   2 +-
 arch/arm/boot/dts/tegra20-ventana.dts              |   2 +-
 .../dts/tegra30-asus-nexus7-grouper-ti-pmic.dtsi   |   2 +-
 arch/arm/boot/dts/tegra30-cardhu.dtsi              |   2 +-
 arch/arm/mach-imx/suspend-imx53.S                  |   4 +-
 arch/arm/mach-omap2/pm33xx-core.c                  |  40 +++++
 arch/arm64/boot/dts/arm/juno-base.dtsi             |   6 +-
 arch/arm64/boot/dts/broadcom/bcm4908/bcm4908.dtsi  |   2 +-
 arch/arm64/boot/dts/freescale/fsl-ls208xa.dtsi     |   1 -
 arch/arm64/boot/dts/freescale/imx8-ss-conn.dtsi    |  50 +++---
 .../boot/dts/freescale/imx8mn-beacon-som.dtsi      |   3 +
 arch/arm64/boot/dts/freescale/imx8mq.dtsi          |  16 ++
 .../boot/dts/marvell/armada-3720-turris-mox.dts    |   6 +-
 arch/arm64/boot/dts/marvell/armada-37xx.dtsi       |   8 +
 arch/arm64/boot/dts/marvell/cn9130-db.dts          |   2 +-
 arch/arm64/boot/dts/nvidia/tegra194.dtsi           |  14 ++
 arch/arm64/boot/dts/qcom/msm8996.dtsi              |   7 +-
 arch/arm64/boot/dts/qcom/sc7180-idp.dts            |   2 +-
 .../arm64/boot/dts/qcom/sc7180-trogdor-coachz.dtsi |   1 +
 arch/arm64/boot/dts/qcom/sm8150-hdk.dts            |  10 +-
 arch/arm64/boot/dts/qcom/sm8150-mtp.dts            |  10 +-
 arch/arm64/boot/dts/qcom/sm8150.dtsi               |   6 +
 arch/arm64/boot/dts/qcom/sm8250.dtsi               |   6 +-
 arch/arm64/boot/dts/qcom/sm8350.dtsi               |   6 +-
 .../boot/dts/renesas/beacon-renesom-baseboard.dtsi |   4 +-
 .../arm64/boot/dts/renesas/beacon-renesom-som.dtsi |   6 +-
 arch/arm64/boot/dts/rockchip/px30.dtsi             |  16 +-
 arch/arm64/boot/dts/rockchip/rk3308-roc-cc.dts     |   4 +-
 arch/arm64/boot/dts/rockchip/rk3328-nanopi-r2s.dts |   4 +-
 arch/arm64/boot/dts/rockchip/rk3328-roc-cc.dts     |   4 +-
 arch/arm64/boot/dts/rockchip/rk3328.dtsi           |   6 +-
 .../boot/dts/rockchip/rk3399-gru-scarlet.dtsi      |   2 +-
 arch/arm64/boot/dts/rockchip/rk3399-gru.dtsi       |   4 +-
 arch/arm64/boot/dts/rockchip/rk3399-nanopi4.dtsi   |   1 -
 arch/arm64/boot/dts/rockchip/rk3399-rock-pi-4.dtsi |   1 -
 arch/arm64/boot/dts/rockchip/rk3399.dtsi           |  44 +++---
 .../boot/dts/rockchip/rk3399pro-vmarc-som.dtsi     |   1 -
 arch/arm64/boot/dts/ti/k3-am654-base-board.dts     |   2 +-
 .../boot/dts/ti/k3-j7200-common-proc-board.dts     |   2 +-
 .../boot/dts/ti/k3-j721e-common-proc-board.dts     |   2 +-
 arch/s390/include/asm/stacktrace.h                 |  97 ++++++++++++
 arch/s390/kernel/traps.c                           |   2 +
 arch/x86/events/intel/uncore_snbep.c               |   6 +-
 arch/x86/net/bpf_jit_comp.c                        |   3 +
 drivers/dma-buf/sync_file.c                        |  13 +-
 drivers/firmware/Kconfig                           |   2 +-
 drivers/firmware/arm_scmi/common.h                 |   2 +-
 drivers/firmware/arm_scmi/driver.c                 |   2 +
 drivers/firmware/arm_scmi/sensors.c                |   6 +-
 drivers/firmware/tegra/Makefile                    |   1 +
 drivers/firmware/tegra/bpmp-private.h              |   3 +-
 drivers/firmware/tegra/bpmp.c                      |   3 +-
 drivers/firmware/turris-mox-rwtm.c                 |   1 +
 drivers/gpu/drm/panel/panel-novatek-nt35510.c      |   4 +-
 drivers/i3c/master/svc-i3c-master.c                |   1 -
 drivers/memory/tegra/tegra124-emc.c                |   4 +-
 drivers/memory/tegra/tegra30-emc.c                 |   4 +-
 drivers/net/dsa/mv88e6xxx/chip.c                   |  22 ++-
 drivers/net/dsa/mv88e6xxx/serdes.c                 |   6 +-
 drivers/net/ethernet/broadcom/genet/bcmgenet.c     |  23 +--
 drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c |   6 -
 drivers/net/ethernet/marvell/mvneta.c              |  20 +--
 drivers/net/ethernet/moxa/moxart_ether.c           |   4 +-
 drivers/net/ethernet/qualcomm/emac/emac.c          |   3 +-
 drivers/net/ethernet/ti/tlan.c                     |   3 +-
 drivers/net/fddi/defza.c                           |   3 +-
 drivers/net/netdevsim/ipsec.c                      |   8 +-
 drivers/net/vmxnet3/vmxnet3_ethtool.c              |  22 ++-
 drivers/net/wireless/mediatek/mt76/mt7921/mcu.c    |   3 +-
 drivers/reset/reset-ti-syscon.c                    |   4 +-
 drivers/rtc/rtc-max77686.c                         |   4 +-
 drivers/rtc/rtc-mxc_v2.c                           |   1 +
 drivers/scsi/aic7xxx/aic7xxx_core.c                |   2 +-
 drivers/scsi/aic94xx/aic94xx_init.c                |   1 +
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c             |   1 +
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c             |   1 +
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c             |   1 +
 drivers/scsi/isci/init.c                           |   1 +
 drivers/scsi/libfc/fc_rport.c                      |  13 +-
 drivers/scsi/libsas/sas_scsi_host.c                |   9 ++
 drivers/scsi/mvsas/mv_init.c                       |   1 +
 drivers/scsi/pm8001/pm8001_init.c                  |   1 +
 drivers/scsi/qedf/qedf_io.c                        |  22 ++-
 drivers/soc/bcm/brcmstb/common.c                   |   5 -
 drivers/soc/mediatek/mtk-devapc.c                  |   1 +
 drivers/soc/tegra/fuse/fuse-tegra30.c              |   3 +-
 drivers/thermal/imx_sc_thermal.c                   |   3 +
 drivers/thermal/rcar_gen3_thermal.c                |   5 +-
 drivers/thermal/sprd_thermal.c                     |  15 +-
 drivers/thermal/thermal_core.c                     |   2 +-
 drivers/thermal/thermal_of.c                       |   3 +
 fs/cifs/cifs_dfs_ref.c                             |   3 +
 fs/f2fs/sysfs.c                                    |   4 +
 fs/vboxsf/dir.c                                    |  76 +++++++--
 fs/vboxsf/file.c                                   |  71 +++++----
 fs/vboxsf/vfsmod.h                                 |   7 +
 include/linux/bpf.h                                |   1 +
 include/linux/huge_mm.h                            |   2 +-
 include/linux/swap.h                               |   9 --
 include/linux/swapops.h                            |   2 +
 include/net/dst_metadata.h                         |   4 +-
 include/net/ip6_route.h                            |   2 +-
 include/net/tcp.h                                  |   4 +
 kernel/bpf/core.c                                  |   8 +-
 kernel/bpf/verifier.c                              |  60 +++-----
 kernel/sched/fair.c                                |   4 +-
 mm/huge_memory.c                                   |  36 +++--
 mm/memory.c                                        |  36 ++---
 mm/shmem.c                                         |  14 +-
 net/bridge/br_if.c                                 |  17 ++-
 net/core/dev.c                                     |   2 +
 net/dsa/switch.c                                   |   4 +-
 net/ipv4/ip_tunnel.c                               |  18 ++-
 net/ipv4/tcp.c                                     |   3 +
 net/ipv4/tcp_input.c                               |   2 +-
 net/ipv4/tcp_ipv4.c                                |   4 +-
 net/ipv4/tcp_output.c                              |   1 +
 net/ipv4/udp.c                                     |   6 +-
 net/ipv4/udp_offload.c                             |   6 +-
 net/ipv6/tcp_ipv6.c                                |  21 ++-
 net/ipv6/udp.c                                     |   2 +-
 net/ipv6/xfrm6_output.c                            |   2 +-
 net/netfilter/nf_conntrack_netlink.c               |   3 +
 net/netfilter/nf_tables_api.c                      |   3 +-
 net/sched/act_ct.c                                 |  14 +-
 scripts/Kbuild.include                             |   7 +-
 scripts/mkcompile_h                                |  14 +-
 tools/bpf/Makefile                                 |   7 +-
 tools/bpf/bpftool/jit_disasm.c                     |   6 +-
 tools/perf/tests/bpf.c                             |   2 +
 237 files changed, 1113 insertions(+), 729 deletions(-)


