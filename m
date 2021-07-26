Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26FFB3D5EE6
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 17:59:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236771AbhGZPOM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:14:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:50622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236904AbhGZPKB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:10:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 23AC160F02;
        Mon, 26 Jul 2021 15:50:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627314628;
        bh=N8I45rjjTmTSi6KaYg4S6Edqfs4a8TtGQLu5KLQjGo8=;
        h=From:To:Cc:Subject:Date:From;
        b=kbwS1VWR39qRXJQM1/YjPYJmFzKSrn3ZKAcYpSxwVMaTFGxS9iM/Ir2ZwcGhxVHIn
         kzpTZLwapC3nqj4BCVK+vPMonkaA66jW7cIzY2WZqLkTT61KdFlzBYR8NX9IJf8q6r
         4Py5qaOHfJW59PGHIq67b1pfoxjPhX77a0dve+wQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 4.19 000/120] 4.19.199-rc1 review
Date:   Mon, 26 Jul 2021 17:37:32 +0200
Message-Id: <20210726153832.339431936@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.199-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.199-rc1
X-KernelTest-Deadline: 2021-07-28T15:38+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.19.199 release.
There are 120 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 28 Jul 2021 15:38:12 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.199-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.19.199-rc1

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: add xhci_get_virt_ep() helper

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    spi: spi-fsl-dspi: Fix a resource leak in an error handling path

Evan Quan <evan.quan@amd.com>
    PCI: Mark AMD Navi14 GPU ATS as broken

David Sterba <dsterba@suse.com>
    btrfs: compression: don't try to compress if we don't have enough pages

Stephan Gerhold <stephan@gerhold.net>
    iio: accel: bma180: Fix BMA25x bandwidth register values

Linus Walleij <linus.walleij@linaro.org>
    iio: accel: bma180: Use explicit member assignment

Doug Berger <opendmb@gmail.com>
    net: bcmgenet: ensure EXT_ENERGY_DET_MASK is clear

Marek Behún <kabel@kernel.org>
    net: dsa: mv88e6xxx: use correct .stats_set_histogram() on Topaz

Nicholas Piggin <npiggin@gmail.com>
    KVM: do not allow mapping valid but non-reference-counted pages

Paolo Bonzini <pbonzini@redhat.com>
    KVM: do not assume PTE is writable after follow_pfn

Charles Baylis <cb-kernel@fishzet.co.uk>
    drm: Return -ENOTTY for non-drm ioctls

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    nds32: fix up stack guard gap

Peter Collingbourne <pcc@google.com>
    selftest: use mmap instead of posix_memalign to allocate memory

Markus Boehme <markubo@amazon.com>
    ixgbe: Fix packet corruption due to missing DMA sync

Gustavo A. R. Silva <gustavoars@kernel.org>
    media: ngene: Fix out-of-bounds bug in ngene_command_config_free_buf()

Haoran Luo <www@aegistudio.net>
    tracing: Fix bug in rb_per_cpu_empty() that might cause deadloop.

Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>
    usb: dwc2: gadget: Fix sending zero length packet in DDMA mode.

John Keeping <john@metanate.com>
    USB: serial: cp210x: add ID for CEL EM3588 USB ZigBee stick

Ian Ray <ian.ray@ge.com>
    USB: serial: cp210x: fix comments for GE CS1000

Marco De Marco <marco.demarco@posteo.net>
    USB: serial: option: add support for u-blox LARA-R6 family

Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
    usb: renesas_usbhs: Fix superfluous irqs happen after usb_pkt_pop()

Mark Tomlinson <mark.tomlinson@alliedtelesis.co.nz>
    usb: max-3421: Prevent corruption of freed memory

Julian Sikorski <belegdol@gmail.com>
    USB: usb-storage: Add LaCie Rugged USB3-FW to IGNORE_UAS

Mathias Nyman <mathias.nyman@linux.intel.com>
    usb: hub: Fix link power management max exit latency (MEL) calculations

Mathias Nyman <mathias.nyman@linux.intel.com>
    usb: hub: Disable USB 3 device initiated lpm if exit latency is too high

Nicholas Piggin <npiggin@gmail.com>
    KVM: PPC: Book3S: Fix H_RTAS rets buffer overflow

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: Fix lost USB 2 remote wake

Takashi Iwai <tiwai@suse.de>
    ALSA: sb: Fix potential ABBA deadlock in CSP driver

Alexander Tsoy <alexander@tsoy.me>
    ALSA: usb-audio: Add registration quirk for JBL Quantum headsets

Vasily Gorbik <gor@linux.ibm.com>
    s390/ftrace: fix ftrace_update_ftrace_func implementation

Huang Pei <huangpei@loongson.cn>
    Revert "MIPS: add PMD table accounting into MIPS'pmd_alloc_one"

Marcelo Henrique Cerri <marcelo.cerri@canonical.com>
    proc: Avoid mixing integer types in mem_rw()

Maxime Ripard <maxime@cerno.tech>
    drm/panel: raspberrypi-touchscreen: Prevent double-free

Yajun Deng <yajun.deng@linux.dev>
    net: sched: cls_api: Fix the the wrong parameter

Xin Long <lucien.xin@gmail.com>
    sctp: update active_key for asoc when old key is being replaced

Vincent Palatin <vpalatin@chromium.org>
    Revert "USB: quirks: ignore remote wake-up on Fibocom L850-GL LTE modem"

Zhihao Cheng <chengzhihao1@huawei.com>
    nvme-pci: don't WARN_ON in nvme_reset_work if ctrl.state is not RESETTING

Peilin Ye <peilin.ye@bytedance.com>
    net/sched: act_skbmod: Skip non-Ethernet packets

Eric Dumazet <edumazet@google.com>
    net/tcp_fastopen: fix data races around tfo_active_disable_stamp

Marek Vasut <marex@denx.de>
    spi: cadence: Correct initialisation of runtime PM again

Dmitry Bogdanov <d.bogdanov@yadro.com>
    scsi: target: Fix protect handling in WRITE SAME(32)

Mike Christie <michael.christie@oracle.com>
    scsi: iscsi: Fix iface sysfs attr detection

Nguyen Dinh Phi <phind.uet@gmail.com>
    netrom: Decrease sock refcount when sock timers expire

Nicholas Piggin <npiggin@gmail.com>
    KVM: PPC: Fix kvm_arch_vcpu_ioctl vcpu_load leak

Yajun Deng <yajun.deng@linux.dev>
    net: decnet: Fix sleeping inside in af_decnet

Ziyang Xuan <william.xuanziyang@huawei.com>
    net: fix uninit-value in caif_seqpkt_sendmsg

Tobias Klauser <tklauser@distanz.ch>
    bpftool: Check malloc return value in mount_bpffs_for_pin

Colin Ian King <colin.king@canonical.com>
    s390/bpf: Perform r1 range checking before accessing jit->seen_reg[r1]

Colin Ian King <colin.king@canonical.com>
    liquidio: Fix unintentional sign extension issue on left shift of u16

Peter Hess <peter.hess@ph-home.de>
    spi: mediatek: fix fifo rx mode

Riccardo Mancini <rickyman7@gmail.com>
    perf probe-file: Delete namelist in del_events() on the error path

Riccardo Mancini <rickyman7@gmail.com>
    perf test bpf: Free obj_buf

Riccardo Mancini <rickyman7@gmail.com>
    perf lzma: Close lzma stream on exit

Riccardo Mancini <rickyman7@gmail.com>
    perf script: Fix memory 'threads' and 'cpus' leaks on exit

Riccardo Mancini <rickyman7@gmail.com>
    perf dso: Fix memory leak in dso__new_map()

Riccardo Mancini <rickyman7@gmail.com>
    perf test session_topology: Delete session->evlist

Riccardo Mancini <rickyman7@gmail.com>
    perf probe: Fix dso->nsinfo refcounting

Riccardo Mancini <rickyman7@gmail.com>
    perf map: Fix dso->nsinfo refcounting

Casey Chen <cachen@purestorage.com>
    nvme-pci: do not call nvme_dev_remove_admin from nvme_remove

Nicolas Dichtel <nicolas.dichtel@6wind.com>
    ipv6: fix 'disable_policy' for fwd packets

Jedrzej Jagielski <jedrzej.jagielski@intel.com>
    igb: Fix position of assignment to *ring

Aleksandr Loktionov <aleksandr.loktionov@intel.com>
    igb: Check if num of q_vectors is smaller than max before array access

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    iavf: Fix an error handling path in 'iavf_probe()'

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    e1000e: Fix an error handling path in 'e1000_probe()'

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    fm10k: Fix an error handling path in 'fm10k_probe()'

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    igb: Fix an error handling path in 'igb_probe()'

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    ixgbe: Fix an error handling path in 'ixgbe_probe()'

Vinicius Costa Gomes <vinicius.gomes@intel.com>
    igb: Fix use-after-free error during reset

Hangbin Liu <liuhangbin@gmail.com>
    net: ip_tunnel: fix mtu calculation for ETHER tunnel devices

Eric Dumazet <edumazet@google.com>
    udp: annotate data races around unix_sk(sk)->gso_size

Gu Shengxian <gushengxian@yulong.com>
    bpftool: Properly close va_list 'ap' by va_end() on error

Eric Dumazet <edumazet@google.com>
    ipv6: tcp: drop silly ICMPv6 packet too big messages

Eric Dumazet <edumazet@google.com>
    tcp: annotate data races around tp->mtu_info

Jason Ekstrand <jason@jlekstrand.net>
    dma-buf/sync_file: Don't leak fences on merge failure

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

Florian Fainelli <f.fainelli@gmail.com>
    net: bcmgenet: Ensure all TX/RX queues DMAs are disabled

Wolfgang Bumiller <w.bumiller@proxmox.com>
    net: bridge: sync fdb to new unicast-filtering ports

Vasily Averin <vvs@virtuozzo.com>
    netfilter: ctnetlink: suspicious RCU usage in ctnetlink_dump_helpinfo

Vadim Fedorenko <vfedorenko@novek.ru>
    net: ipv6: fix return value of ip6_skb_dst_mtu

Marek Behún <kabel@kernel.org>
    net: dsa: mv88e6xxx: enable .rmu_disable() on Topaz

Mikulas Patocka <mpatocka@redhat.com>
    dm writecache: fix writing beyond end of underlying device when shrinking

Mikulas Patocka <mpatocka@redhat.com>
    dm writecache: return the exact table values that were set

Nanyong Sun <sunnanyong@huawei.com>
    mm: slab: fix kmem_cache_create failed when sysfs node not destroyed

Odin Ugedal <odin@uged.al>
    sched/fair: Fix CFS bandwidth hrtimer expiry type

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

Mian Yousaf Kaukab <ykaukab@suse.de>
    arm64: dts: ls208xa: remove bus-num from dspi node

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
    ARM: dts: rockchip: Fix power-controller node names for rk3288

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

 Makefile                                           |   4 +-
 arch/arm/boot/dts/bcm-cygnus.dtsi                  |   2 +-
 arch/arm/boot/dts/bcm-hr2.dtsi                     |   2 +-
 arch/arm/boot/dts/bcm-nsp.dtsi                     |   2 +-
 arch/arm/boot/dts/bcm63138.dtsi                    |   2 +-
 arch/arm/boot/dts/bcm7445-bcm97445svmb.dts         |   4 +-
 arch/arm/boot/dts/bcm7445.dtsi                     |   2 +-
 arch/arm/boot/dts/bcm911360_entphn.dts             |   4 +-
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
 arch/arm/boot/dts/gemini-dlink-dns-313.dts         |   2 +-
 arch/arm/boot/dts/gemini-nas4220b.dts              |   2 +-
 arch/arm/boot/dts/gemini-rut1xx.dts                |   2 +-
 arch/arm/boot/dts/gemini-wbd111.dts                |   2 +-
 arch/arm/boot/dts/gemini-wbd222.dts                |   2 +-
 arch/arm/boot/dts/gemini.dtsi                      |   1 +
 arch/arm/boot/dts/imx6qdl-phytec-pfla02.dtsi       |   5 +-
 arch/arm/boot/dts/rk3036-kylin.dts                 |   2 +-
 arch/arm/boot/dts/rk3188.dtsi                      |   8 +-
 arch/arm/boot/dts/rk322x.dtsi                      |  10 +-
 arch/arm/boot/dts/rk3288-rock2-som.dtsi            |   2 +-
 arch/arm/boot/dts/rk3288-vyasa.dts                 |   4 +-
 arch/arm/boot/dts/rk3288.dtsi                      |  14 +--
 arch/arm/boot/dts/stm32429i-eval.dts               |   8 +-
 arch/arm/boot/dts/stm32746g-eval.dts               |   6 +-
 arch/arm/boot/dts/stm32f429-disco.dts              |   6 +-
 arch/arm/boot/dts/stm32f429.dtsi                   |  10 +-
 arch/arm/boot/dts/stm32f469-disco.dts              |   6 +-
 arch/arm/boot/dts/stm32f746.dtsi                   |  12 +--
 arch/arm/boot/dts/stm32f769-disco.dts              |   6 +-
 arch/arm/boot/dts/stm32h743.dtsi                   |   4 -
 arch/arm/boot/dts/stm32mp157c.dtsi                 |  12 +--
 arch/arm/mach-imx/suspend-imx53.S                  |   4 +-
 arch/arm64/boot/dts/arm/juno-base.dtsi             |   6 +-
 arch/arm64/boot/dts/freescale/fsl-ls208xa.dtsi     |   1 -
 arch/arm64/boot/dts/rockchip/rk3328.dtsi           |   6 +-
 arch/arm64/boot/dts/rockchip/rk3399.dtsi           |   2 +-
 arch/mips/include/asm/pgalloc.h                    |  10 +-
 arch/nds32/mm/mmap.c                               |   2 +-
 arch/powerpc/kvm/book3s_rtas.c                     |  25 ++++-
 arch/powerpc/kvm/powerpc.c                         |   4 +-
 arch/s390/include/asm/ftrace.h                     |   1 +
 arch/s390/kernel/ftrace.c                          |   2 +
 arch/s390/kernel/mcount.S                          |   4 +-
 arch/s390/net/bpf_jit_comp.c                       |   2 +-
 drivers/dma-buf/sync_file.c                        |  13 +--
 drivers/gpu/drm/drm_ioctl.c                        |   3 +
 .../gpu/drm/panel/panel-raspberrypi-touchscreen.c  |   1 -
 drivers/iio/accel/bma180.c                         |  75 ++++++++-----
 drivers/md/dm-writecache.c                         |  50 ++++++---
 drivers/media/pci/ngene/ngene-core.c               |   2 +-
 drivers/media/pci/ngene/ngene.h                    |  14 +--
 drivers/net/dsa/mv88e6xxx/chip.c                   |   6 +-
 drivers/net/ethernet/broadcom/genet/bcmgenet.c     |  22 ++--
 drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c |   6 --
 .../ethernet/cavium/liquidio/cn23xx_pf_device.c    |   2 +-
 drivers/net/ethernet/intel/e1000e/netdev.c         |   1 +
 drivers/net/ethernet/intel/fm10k/fm10k_pci.c       |   1 +
 drivers/net/ethernet/intel/i40evf/i40evf_main.c    |   1 +
 drivers/net/ethernet/intel/igb/igb_main.c          |  15 ++-
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c      |   4 +-
 drivers/net/ethernet/moxa/moxart_ether.c           |   4 +-
 drivers/net/ethernet/qualcomm/emac/emac.c          |   3 +-
 drivers/net/ethernet/ti/tlan.c                     |   3 +-
 drivers/nvme/host/pci.c                            |   5 +-
 drivers/pci/quirks.c                               |   4 +-
 drivers/reset/reset-ti-syscon.c                    |   4 +-
 drivers/rtc/rtc-max77686.c                         |   4 +-
 drivers/rtc/rtc-mxc_v2.c                           |   1 +
 drivers/scsi/aic7xxx/aic7xxx_core.c                |   2 +-
 drivers/scsi/aic94xx/aic94xx_init.c                |   1 +
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c             |   1 +
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c             |   1 +
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c             |   1 +
 drivers/scsi/isci/init.c                           |   1 +
 drivers/scsi/libfc/fc_rport.c                      |  13 ++-
 drivers/scsi/libsas/sas_scsi_host.c                |   9 ++
 drivers/scsi/mvsas/mv_init.c                       |   1 +
 drivers/scsi/pm8001/pm8001_init.c                  |   1 +
 drivers/scsi/scsi_transport_iscsi.c                |  90 ++++++----------
 drivers/soc/tegra/fuse/fuse-tegra30.c              |   3 +-
 drivers/spi/spi-cadence.c                          |  14 ++-
 drivers/spi/spi-fsl-dspi.c                         |   4 +-
 drivers/spi/spi-mt65xx.c                           |  16 ++-
 drivers/target/target_core_sbc.c                   |  35 +++---
 drivers/thermal/thermal_core.c                     |   2 +-
 drivers/usb/core/hub.c                             | 120 ++++++++++++++-------
 drivers/usb/core/quirks.c                          |   4 -
 drivers/usb/dwc2/gadget.c                          |  10 +-
 drivers/usb/host/max3421-hcd.c                     |  44 +++-----
 drivers/usb/host/xhci-hub.c                        |   3 +-
 drivers/usb/host/xhci-ring.c                       |  58 +++++++---
 drivers/usb/host/xhci.h                            |   3 +-
 drivers/usb/renesas_usbhs/fifo.c                   |   7 ++
 drivers/usb/serial/cp210x.c                        |   5 +-
 drivers/usb/serial/option.c                        |   3 +
 drivers/usb/storage/unusual_uas.h                  |   7 ++
 fs/btrfs/inode.c                                   |   2 +-
 fs/proc/base.c                                     |   2 +-
 include/drm/drm_ioctl.h                            |   1 +
 include/net/dst_metadata.h                         |   4 +-
 include/net/ip6_route.h                            |   2 +-
 kernel/sched/fair.c                                |   4 +-
 kernel/trace/ring_buffer.c                         |  28 ++++-
 mm/slab_common.c                                   |  18 ++--
 net/bridge/br_if.c                                 |  17 ++-
 net/caif/caif_socket.c                             |   3 +-
 net/decnet/af_decnet.c                             |  27 +++--
 net/ipv4/ip_tunnel.c                               |  22 +++-
 net/ipv4/tcp_fastopen.c                            |  19 +++-
 net/ipv4/tcp_ipv4.c                                |   4 +-
 net/ipv4/tcp_output.c                              |   1 +
 net/ipv4/udp.c                                     |   6 +-
 net/ipv6/ip6_output.c                              |   4 +-
 net/ipv6/tcp_ipv6.c                                |  22 +++-
 net/ipv6/udp.c                                     |   2 +-
 net/ipv6/xfrm6_output.c                            |   2 +-
 net/netfilter/nf_conntrack_netlink.c               |   3 +
 net/netrom/nr_timer.c                              |  20 ++--
 net/sched/act_skbmod.c                             |  12 ++-
 net/sched/cls_api.c                                |   2 +-
 net/sctp/auth.c                                    |   2 +
 scripts/mkcompile_h                                |  14 ++-
 sound/isa/sb/sb16_csp.c                            |   4 +
 sound/usb/quirks.c                                 |   3 +
 tools/bpf/bpftool/common.c                         |   5 +
 tools/bpf/bpftool/jit_disasm.c                     |   6 +-
 tools/perf/builtin-script.c                        |   7 ++
 tools/perf/tests/bpf.c                             |   2 +
 tools/perf/tests/topology.c                        |   1 +
 tools/perf/util/dso.c                              |   4 +-
 tools/perf/util/lzma.c                             |   8 +-
 tools/perf/util/map.c                              |   2 +
 tools/perf/util/probe-event.c                      |   4 +-
 tools/perf/util/probe-file.c                       |   4 +-
 tools/testing/selftests/vm/userfaultfd.c           |   6 +-
 virt/kvm/kvm_main.c                                |  34 +++++-
 146 files changed, 796 insertions(+), 501 deletions(-)


