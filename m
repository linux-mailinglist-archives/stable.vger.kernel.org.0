Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B56719B230
	for <lists+stable@lfdr.de>; Wed,  1 Apr 2020 18:42:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389147AbgDAQls (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Apr 2020 12:41:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:42208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389446AbgDAQlr (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Apr 2020 12:41:47 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A13CD2063A;
        Wed,  1 Apr 2020 16:41:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585759306;
        bh=6GMJ5s0xn8v0N39Wd9CHlpb25vapOS2TPlM8QMpayBs=;
        h=From:To:Cc:Subject:Date:From;
        b=pnLWbxcsl3xw4mbTJzKnbnJsKQdsFJJwTO4BwfRKACVXEG0DlztW1xcZ3qQZdNH8V
         P2XxeZqkOmyXLjj1RDNkuz68Nw6AGtwbBdcanwOSo2psYVAL/meHwu1mMDA0wm4lk1
         nyqFv1XCozHkNL/9+GWWHcZ9y9pdha3r/4uw5vyc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.14 000/148] 4.14.175-rc1 review
Date:   Wed,  1 Apr 2020 18:16:32 +0200
Message-Id: <20200401161552.245876366@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.175-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.14.175-rc1
X-KernelTest-Deadline: 2020-04-03T16:16+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.14.175 release.
There are 148 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 03 Apr 2020 16:09:36 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.175-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.14.175-rc1

Madalin Bucur <madalin.bucur@oss.nxp.com>
    arm64: dts: ls1046ardb: set RGMII interfaces to RGMII_ID mode

Madalin Bucur <madalin.bucur@oss.nxp.com>
    arm64: dts: ls1043a-rdb: correct RGMII delay mode to rgmii-id

Nick Hudson <skrll@netbsd.org>
    ARM: bcm2835-rpi-zero-w: Add missing pinctrl name

Sungbo Eo <mans0n@gorani.run>
    ARM: dts: oxnas: Fix clear-mask property

disconnect3d <dominik.b.czarnota@gmail.com>
    perf map: Fix off by one in strncpy() size argument

Ilie Halip <ilie.halip@gmail.com>
    arm64: alternative: fix build with clang integrated assembler

Marek Vasut <marex@denx.de>
    net: ks8851-ml: Fix IO operations, again

Hans de Goede <hdegoede@redhat.com>
    gpiolib: acpi: Add quirk to ignore EC wakeups on HP x2 10 CHT + AXP288 model

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    bpf: Explicitly memset some bpf info structures declared on the stack

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    bpf: Explicitly memset the bpf_attr structure

Georg Müller <georgmueller@gmx.net>
    platform/x86: pmc_atom: Add Lex 2I385SW to critclk_systems DMI table

Eric Biggers <ebiggers@google.com>
    vt: vt_ioctl: fix use-after-free in vt_in_use()

Eric Biggers <ebiggers@google.com>
    vt: vt_ioctl: fix VT_DISALLOCATE freeing in-use virtual console

Eric Biggers <ebiggers@google.com>
    vt: vt_ioctl: remove unnecessary console allocation checks

Jiri Slaby <jslaby@suse.cz>
    vt: switch vt_dont_switch to bool

Jiri Slaby <jslaby@suse.cz>
    vt: ioctl, switch VT_IS_IN_USE and VT_BUSY to inlines

Jiri Slaby <jslaby@suse.cz>
    vt: selection, introduce vc_is_sel

Johannes Berg <johannes.berg@intel.com>
    mac80211: fix authentication with iwlwifi/mvm

Jouni Malinen <jouni@codeaurora.org>
    mac80211: Check port authorization in the ieee80211_tx_dequeue() case

Johan Hovold <johan@kernel.org>
    media: xirlink_cit: add missing descriptor sanity checks

Johan Hovold <johan@kernel.org>
    media: stv06xx: add missing descriptor sanity checks

Johan Hovold <johan@kernel.org>
    media: dib0700: fix rc endpoint lookup

Johan Hovold <johan@kernel.org>
    media: ov519: add missing endpoint sanity checks

Eric Biggers <ebiggers@google.com>
    libfs: fix infoleak in simple_attr_read()

Qiujun Huang <hqjagain@gmail.com>
    staging: wlan-ng: fix use-after-free Read in hfa384x_usbin_callback

Qiujun Huang <hqjagain@gmail.com>
    staging: wlan-ng: fix ODEBUG bug in prism2sta_disconnect_usb

Larry Finger <Larry.Finger@lwfinger.net>
    staging: rtl8188eu: Add ASUS USB-N10 Nano B1 to device table

Johan Hovold <johan@kernel.org>
    media: usbtv: fix control-message timeouts

Johan Hovold <johan@kernel.org>
    media: flexcop-usb: fix endpoint sanity check

Mans Rullgard <mans@mansr.com>
    usb: musb: fix crash with highmen PIO and usbmon

Qiujun Huang <hqjagain@gmail.com>
    USB: serial: io_edgeport: fix slab-out-of-bounds read in edge_interrupt_callback

Matthias Reichl <hias@horus.com>
    USB: cdc-acm: restore capability check order

Pawel Dembicki <paweldembicki@gmail.com>
    USB: serial: option: add Wistron Neweb D19Q1

Pawel Dembicki <paweldembicki@gmail.com>
    USB: serial: option: add BroadMobi BM806U

Pawel Dembicki <paweldembicki@gmail.com>
    USB: serial: option: add support for ASKEY WWHC050

David Howells <dhowells@redhat.com>
    afs: Fix some tracing details

Dan Carpenter <dan.carpenter@oracle.com>
    Input: raydium_i2c_ts - fix error codes in raydium_i2c_boot_trigger()

Gustavo A. R. Silva <gustavo@embeddedor.com>
    Input: raydium_i2c_ts - use true and false for boolean values

Torsten Hilbrich <torsten.hilbrich@secunet.com>
    vti6: Fix memory leak of skb if input policy check fails

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nft_fwd_netdev: validate family and chain type

YueHaibing <yuehaibing@huawei.com>
    xfrm: policy: Fix doulbe free in xfrm_policy_timer

Xin Long <lucien.xin@gmail.com>
    xfrm: add the missing verify_sec_ctx_len check in xfrm_add_acquire

Xin Long <lucien.xin@gmail.com>
    xfrm: fix uctx len check in verify_sec_ctx_len

Maor Gottlieb <maorg@mellanox.com>
    RDMA/mlx5: Block delay drop to unprivileged users

Nicolas Dichtel <nicolas.dichtel@6wind.com>
    vti[6]: fix packet tx through bpf_redirect() in XinY cases

Raed Salem <raeds@mellanox.com>
    xfrm: handle NETDEV_UNREGISTER for xfrm device

Edward Cree <ecree@solarflare.com>
    genirq: Fix reference leaks on irq affinity notifiers

Mike Marciniszyn <mike.marciniszyn@intel.com>
    RDMA/core: Ensure security pkey modify is not lost

Hans de Goede <hdegoede@redhat.com>
    gpiolib: acpi: Add quirk to ignore EC wakeups on HP x2 10 BYT + AXP288 model

Hans de Goede <hdegoede@redhat.com>
    gpiolib: acpi: Rework honor_wakeup option into an ignore_wake option

Hans de Goede <hdegoede@redhat.com>
    gpiolib: acpi: Correct comment for HP x2 10 honor_wakeup quirk

Johannes Berg <johannes.berg@intel.com>
    mac80211: mark station unauthorized before key removal

Martin K. Petersen <martin.petersen@oracle.com>
    scsi: sd: Fix optimal I/O size for devices that change reported values

Dirk Mueller <dmueller@suse.com>
    scripts/dtc: Remove redundant YYLOC global declaration

Masami Hiramatsu <mhiramat@kernel.org>
    tools: Let O= makes handle a relative path with -C option

Masami Hiramatsu <mhiramat@kernel.org>
    perf probe: Do not depend on dwfl_module_addrsym()

Roger Quadros <rogerq@ti.com>
    ARM: dts: omap5: Add bus_dma_limit for L3 bus

Roger Quadros <rogerq@ti.com>
    ARM: dts: dra7: Add bus_dma_limit for L3 bus

Eugene Syromiatnikov <esyr@redhat.com>
    Input: avoid BIT() macro usage in the serio.h UAPI header

Yussuf Khalil <dev@pp3345.net>
    Input: synaptics - enable RMI on HP Envy 13-ad105ng

Chuhong Yuan <hslester96@gmail.com>
    i2c: hix5hd2: add missed clk_disable_unprepare in remove

Jiri Kosina <jkosina@suse.cz>
    ftrace/x86: Anotate text_mutex split between ftrace_arch_code_modify_post_process() and ftrace_arch_code_modify_prepare()

Mark Rutland <mark.rutland@arm.com>
    arm64: compat: map SPSR_ELx<->PSR for signals

Mark Rutland <mark.rutland@arm.com>
    arm64: ptrace: map SPSR_ELx<->PSR for compat tasks

Dominik Czarnota <dominik.b.czarnota@gmail.com>
    sxgbe: Fix off by one in samsung driver strncpy size arg

Nathan Chancellor <natechancellor@gmail.com>
    dpaa_eth: Remove unnecessary boolean expression in dpaa_get_headroom

Nicolas Cavallari <nicolas.cavallari@green-communications.fr>
    mac80211: Do not send mesh HWMP PREQ if HWMP is disabled

Wen Xiong <wenxiong@linux.vnet.ibm.com>
    scsi: ipr: Fix softlockup when rescanning devices in petitboot

Madalin Bucur <madalin.bucur@nxp.com>
    fsl/fman: detect FMan erratum A050385

Madalin Bucur <madalin.bucur@nxp.com>
    arm64: dts: ls1043a: FMan erratum A050385

Madalin Bucur <madalin.bucur@nxp.com>
    dt-bindings: net: FMan erratum A050385

Tycho Andersen <tycho@tycho.ws>
    cgroup1: don't call release_agent when it is ""

Dajun Jin <adajunjin@gmail.com>
    drivers/of/of_mdio.c:fix of_mdiobus_register()

Mike Gilbert <floppym@gentoo.org>
    cpupower: avoid multiple definition with gcc -fno-common

Vasily Averin <vvs@virtuozzo.com>
    cgroup-v1: cgroup_pidlist_next should update position index

Sabrina Dubroca <sd@queasysnail.net>
    net: ipv4: don't let PMTU updates increase route MTU

Taehee Yoo <ap420073@gmail.com>
    hsr: set .netnsok flag

Taehee Yoo <ap420073@gmail.com>
    hsr: add restart routine into hsr_get_node_list()

Taehee Yoo <ap420073@gmail.com>
    hsr: use rcu_read_lock() in hsr_get_node_{list/status}()

Taehee Yoo <ap420073@gmail.com>
    vxlan: check return value of gro_cells_init()

René van Dorst <opensource@vdorst.com>
    net: dsa: mt7530: Change the LINK bit to reflect the link status

Edwin Peer <edwin.peer@broadcom.com>
    bnxt_en: fix memory leaks in bnxt_dcbnl_ieee_getets()

Oliver Hartkopp <socketcan@hartkopp.net>
    slcan: not call free_netdev before rtnl_unlock in slcan_open

Dan Carpenter <dan.carpenter@oracle.com>
    NFC: fdp: Fix a signedness bug in fdp_nci_send_patch()

Emil Renner Berthing <kernel@esmil.dk>
    net: stmmac: dwmac-rk: fix error path in rk_gmac_probe

Cong Wang <xiyou.wangcong@gmail.com>
    net_sched: keep alloc_hash updated after hash allocation

Cong Wang <xiyou.wangcong@gmail.com>
    net_sched: cls_route: remove the right filter from hashtable

Pawel Dembicki <paweldembicki@gmail.com>
    net: qmi_wwan: add support for ASKEY WWHC050

Willem de Bruijn <willemb@google.com>
    net/packet: tpacket_rcv: avoid a producer race condition

Jisheng Zhang <Jisheng.Zhang@synaptics.com>
    net: mvneta: Fix the case where the last poll did not process all rx

Florian Fainelli <f.fainelli@gmail.com>
    net: dsa: Fix duplicate frames flooded by learning

Willem de Bruijn <willemb@google.com>
    macsec: restrict to ethernet devices

Taehee Yoo <ap420073@gmail.com>
    hsr: fix general protection fault in hsr_addr_is_self()

Lyude Paul <lyude@redhat.com>
    Revert "drm/dp_mst: Skip validating ports during destruction, just ref"

Johan Hovold <johan@kernel.org>
    staging: greybus: loopback_test: fix potential path truncations

Johan Hovold <johan@kernel.org>
    staging: greybus: loopback_test: fix potential path truncation

Jernej Skrabec <jernej.skrabec@siol.net>
    drm/bridge: dw-hdmi: fix AVI frame colorimetry

Cristian Marussi <cristian.marussi@arm.com>
    arm64: smp: fix crash_smp_send_stop() behaviour

Cristian Marussi <cristian.marussi@arm.com>
    arm64: smp: fix smp_send_stop() behaviour

Kai-Heng Feng <kai.heng.feng@canonical.com>
    ALSA: hda/realtek: Fix pop noise on ALC225

Sasha Levin <sashal@kernel.org>
    Revert "ipv6: Fix handling of LLA with VRF and sockets bound to VRF"

Sasha Levin <sashal@kernel.org>
    Revert "vrf: mark skb for multicast or link-local as enslaved to VRF"

Thomas Gleixner <tglx@linutronix.de>
    futex: Unbreak futex hashing

Peter Zijlstra <peterz@infradead.org>
    futex: Fix inode life-time issue

Nathan Chancellor <natechancellor@gmail.com>
    kbuild: Disable -Wpointer-to-enum-cast

Eugen Hristev <eugen.hristev@microchip.com>
    iio: adc: at91-sama5d2_adc: fix differential channels in triggered mode

Eugen Hristev <eugen.hristev@microchip.com>
    iio: adc: at91-sama5d2_adc: fix channel configuration for differential channels

Anthony Mallet <anthony.mallet@laas.fr>
    USB: cdc-acm: fix rounding error in TIOCSSERIAL

Anthony Mallet <anthony.mallet@laas.fr>
    USB: cdc-acm: fix close_delay and closing_wait units in TIOCSSERIAL

Joerg Roedel <jroedel@suse.de>
    x86/mm: split vmalloc_sync_all()

Qian Cai <cai@lca.pw>
    page-flags: fix a crash at SetPageError(THP_SWAP)

Vlastimil Babka <vbabka@suse.cz>
    mm, slub: prevent kmalloc_node crashes and memory leaks

Linus Torvalds <torvalds@linux-foundation.org>
    mm: slub: be more careful about the double cmpxchg of freelist

Chunguang Xu <brookxu@tencent.com>
    memcg: fix NULL pointer dereference in __mem_cgroup_usage_unregister_event

Steven Rostedt (VMware) <rostedt@goodmis.org>
    xhci: Do not open code __print_symbolic() in xhci trace events

Corentin Labbe <clabbe@baylibre.com>
    rtc: max8907: add missing select REGMAP_IRQ

Alexander Shishkin <alexander.shishkin@linux.intel.com>
    intel_th: pci: Add Elkhart Lake CPU support

Alexander Shishkin <alexander.shishkin@linux.intel.com>
    intel_th: Fix user-visible error codes

Samuel Thibault <samuel.thibault@ens-lyon.org>
    staging/speakup: fix get_word non-space look-ahead

Michael Straube <straube.linux@gmail.com>
    staging: rtl8188eu: Add device id for MERCUSYS MW150US v2

Michał Mirosław <mirq-linux@rere.qmqm.pl>
    mmc: sdhci-of-at91: fix cd-gpios for SAMA5D2

Stephan Gerhold <stephan@gerhold.net>
    iio: magnetometer: ak8974: Fix negative raw values in sysfs

Fabrice Gasnier <fabrice.gasnier@st.com>
    iio: trigger: stm32-timer: disable master mode when stopping

Takashi Iwai <tiwai@suse.de>
    ALSA: pcm: oss: Remove WARNING from snd_pcm_plug_alloc() checks

Takashi Iwai <tiwai@suse.de>
    ALSA: pcm: oss: Avoid plugin buffer overflow

Takashi Iwai <tiwai@suse.de>
    ALSA: seq: oss: Fix running status after receiving sysex

Takashi Iwai <tiwai@suse.de>
    ALSA: seq: virmidi: Fix running status after receiving sysex

Takashi Iwai <tiwai@suse.de>
    ALSA: line6: Fix endless MIDI read loop

Alberto Mattea <alberto@mattea.info>
    usb: xhci: apply XHCI_SUSPEND_DELAY to AMD XHCI controller 1022:145c

Scott Chen <scott@labau.com.tw>
    USB: serial: pl2303: add device-id for HP LD381

Ran Wang <ran.wang_1@nxp.com>
    usb: host: xhci-plat: add a shutdown

Daniele Palmas <dnlplm@gmail.com>
    USB: serial: option: add ME910G1 ECM composition 0x110b

Hans de Goede <hdegoede@redhat.com>
    usb: quirks: add NO_LPM quirk for RTL8153 based ethernet adapters

Kai-Heng Feng <kai.heng.feng@canonical.com>
    USB: Disable LPM on WD19's Realtek Hub

Jonathan Neuschäfer <j.neuschaefer@gmx.net>
    parse-maintainers: Mark as executable

Carlo Nonato <carlo.nonato95@gmail.com>
    block, bfq: fix overwrite of bfq_group pointer in bfq_find_set_group()

Dongli Zhang <dongli.zhang@oracle.com>
    xenbus: req->err should be updated before req->state

Dongli Zhang <dongli.zhang@oracle.com>
    xenbus: req->body should be updated before req->state

Mike Snitzer <snitzer@redhat.com>
    dm bio record: save/restore bi_end_io and bi_integrity

Daniel Axtens <dja@axtens.net>
    altera-stapl: altera_get_note: prevent write beyond end of 'key'

luanshi <zhangliguang@linux.alibaba.com>
    drivers/perf: arm_pmu_acpi: Fix incorrect checking of gicc pointer

Marek Szyprowski <m.szyprowski@samsung.com>
    drm/exynos: dsi: fix workaround for the legacy clock name

Marek Szyprowski <m.szyprowski@samsung.com>
    drm/exynos: dsi: propagate error value and silence meaningless warning

Thommy Jakobsson <thommyj@gmail.com>
    spi/zynqmp: remove entry that causes a cs glitch

Evan Green <evgreen@chromium.org>
    spi: pxa2xx: Add CS control clock quirk

Kishon Vijay Abraham I <kishon@ti.com>
    ARM: dts: dra7: Add "dma-ranges" property to PCIe RC DT nodes

Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
    powerpc: Include .BTF section

Yuji Sasaki <sasakiy@chromium.org>
    spi: qup: call spi_qup_pm_resume_runtime before suspending


-------------

Diffstat:

 Documentation/devicetree/bindings/net/fsl-fman.txt |   7 ++
 Makefile                                           |   4 +-
 arch/arm/boot/dts/bcm2835-rpi-zero-w.dts           |   1 +
 arch/arm/boot/dts/dra7.dtsi                        |   3 +
 arch/arm/boot/dts/omap5.dtsi                       |   1 +
 arch/arm/boot/dts/ox810se.dtsi                     |   4 +-
 arch/arm/boot/dts/ox820.dtsi                       |   4 +-
 arch/arm64/boot/dts/freescale/fsl-ls1043-post.dtsi |   2 +
 arch/arm64/boot/dts/freescale/fsl-ls1043a-rdb.dts  |   4 +-
 arch/arm64/boot/dts/freescale/fsl-ls1046a-rdb.dts  |   4 +-
 arch/arm64/include/asm/alternative.h               |   2 +-
 arch/arm64/kernel/ptrace.c                         |   2 +
 arch/arm64/kernel/signal32.c                       |   8 +-
 arch/arm64/kernel/smp.c                            |  25 +++-
 arch/powerpc/kernel/vmlinux.lds.S                  |   6 +
 arch/x86/kernel/ftrace.c                           |   2 +
 arch/x86/mm/fault.c                                |  26 +++-
 block/bfq-cgroup.c                                 |   9 +-
 drivers/acpi/apei/ghes.c                           |   2 +-
 drivers/gpio/gpiolib-acpi.c                        | 140 +++++++++++++++++----
 drivers/gpu/drm/bridge/synopsys/dw-hdmi.c          |  46 ++++---
 drivers/gpu/drm/drm_dp_mst_topology.c              |  15 +--
 drivers/gpu/drm/exynos/exynos_drm_dsi.c            |  12 +-
 drivers/hwtracing/intel_th/msu.c                   |   6 +-
 drivers/hwtracing/intel_th/pci.c                   |   5 +
 drivers/i2c/busses/i2c-hix5hd2.c                   |   1 +
 drivers/iio/adc/at91-sama5d2_adc.c                 |  45 ++++++-
 drivers/iio/magnetometer/ak8974.c                  |   2 +-
 drivers/iio/trigger/stm32-timer-trigger.c          |  11 +-
 drivers/infiniband/core/security.c                 |  11 +-
 drivers/infiniband/hw/mlx5/qp.c                    |   4 +
 drivers/input/mouse/synaptics.c                    |   1 +
 drivers/input/touchscreen/raydium_i2c_ts.c         |   4 +-
 drivers/md/dm-bio-record.h                         |  15 +++
 drivers/media/usb/b2c2/flexcop-usb.c               |   6 +-
 drivers/media/usb/dvb-usb/dib0700_core.c           |   4 +-
 drivers/media/usb/gspca/ov519.c                    |  10 ++
 drivers/media/usb/gspca/stv06xx/stv06xx.c          |  19 ++-
 drivers/media/usb/gspca/stv06xx/stv06xx_pb0100.c   |   4 +
 drivers/media/usb/gspca/xirlink_cit.c              |  18 ++-
 drivers/media/usb/usbtv/usbtv-core.c               |   2 +-
 drivers/media/usb/usbtv/usbtv-video.c              |   5 +-
 drivers/misc/altera-stapl/altera.c                 |  12 +-
 drivers/mmc/host/sdhci-of-at91.c                   |   8 +-
 drivers/net/can/slcan.c                            |   3 +
 drivers/net/dsa/mt7530.c                           |   2 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_dcb.c      |  15 ++-
 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c     |   4 +-
 drivers/net/ethernet/freescale/fman/Kconfig        |  28 +++++
 drivers/net/ethernet/freescale/fman/fman.c         |  18 +++
 drivers/net/ethernet/freescale/fman/fman.h         |   5 +
 drivers/net/ethernet/marvell/mvneta.c              |   3 +-
 drivers/net/ethernet/micrel/ks8851_mll.c           |  56 ++++++++-
 drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c    |   2 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c     |   2 +-
 drivers/net/macsec.c                               |   3 +
 drivers/net/usb/qmi_wwan.c                         |   1 +
 drivers/net/vrf.c                                  |  19 +--
 drivers/net/vxlan.c                                |  11 +-
 drivers/nfc/fdp/fdp.c                              |   5 +-
 drivers/of/of_mdio.c                               |   1 +
 drivers/perf/arm_pmu_acpi.c                        |   7 +-
 drivers/platform/x86/pmc_atom.c                    |   8 ++
 drivers/rtc/Kconfig                                |   1 +
 drivers/scsi/ipr.c                                 |   3 +-
 drivers/scsi/ipr.h                                 |   1 +
 drivers/scsi/sd.c                                  |   4 +-
 drivers/spi/spi-pxa2xx.c                           |  23 ++++
 drivers/spi/spi-qup.c                              |  11 +-
 drivers/spi/spi-zynqmp-gqspi.c                     |   3 -
 drivers/staging/greybus/tools/loopback_test.c      |  17 +--
 drivers/staging/rtl8188eu/os_dep/usb_intf.c        |   2 +
 drivers/staging/speakup/main.c                     |   2 +-
 drivers/staging/wlan-ng/hfa384x_usb.c              |   2 +
 drivers/staging/wlan-ng/prism2usb.c                |   1 +
 drivers/tty/vt/selection.c                         |   5 +
 drivers/tty/vt/vt.c                                |  30 ++++-
 drivers/tty/vt/vt_ioctl.c                          |  80 ++++++------
 drivers/usb/class/cdc-acm.c                        |  20 ++-
 drivers/usb/core/quirks.c                          |   6 +
 drivers/usb/host/xhci-pci.c                        |   3 +-
 drivers/usb/host/xhci-plat.c                       |   1 +
 drivers/usb/host/xhci-trace.h                      |  23 +---
 drivers/usb/musb/musb_host.c                       |  17 +--
 drivers/usb/serial/io_edgeport.c                   |   2 +-
 drivers/usb/serial/option.c                        |   8 ++
 drivers/usb/serial/pl2303.c                        |   1 +
 drivers/usb/serial/pl2303.h                        |   1 +
 drivers/xen/xenbus/xenbus_comms.c                  |   4 +
 drivers/xen/xenbus/xenbus_xs.c                     |   9 +-
 fs/afs/rxrpc.c                                     |   4 +-
 fs/inode.c                                         |   1 +
 fs/libfs.c                                         |   8 +-
 include/linux/fs.h                                 |   1 +
 include/linux/futex.h                              |  17 +--
 include/linux/page-flags.h                         |   2 +-
 include/linux/selection.h                          |   4 +-
 include/linux/vmalloc.h                            |   5 +-
 include/linux/vt_kern.h                            |   2 +-
 include/trace/events/afs.h                         |   2 +-
 include/uapi/linux/serio.h                         |  10 +-
 kernel/bpf/syscall.c                               |   9 +-
 kernel/cgroup/cgroup-v1.c                          |   3 +-
 kernel/futex.c                                     |  93 ++++++++------
 kernel/irq/manage.c                                |  11 +-
 kernel/notifier.c                                  |   2 +-
 mm/memcontrol.c                                    |  10 +-
 mm/nommu.c                                         |  10 +-
 mm/slub.c                                          |  32 +++--
 mm/vmalloc.c                                       |  11 +-
 net/dsa/tag_brcm.c                                 |   2 +
 net/hsr/hsr_framereg.c                             |  10 +-
 net/hsr/hsr_netlink.c                              |  74 ++++++-----
 net/hsr/hsr_slave.c                                |   8 +-
 net/ipv4/Kconfig                                   |   1 +
 net/ipv4/ip_vti.c                                  |  38 ++++--
 net/ipv4/route.c                                   |   7 +-
 net/ipv6/ip6_vti.c                                 |  34 +++--
 net/ipv6/tcp_ipv6.c                                |   3 +-
 net/mac80211/mesh_hwmp.c                           |   3 +-
 net/mac80211/sta_info.c                            |   6 +
 net/mac80211/tx.c                                  |  20 ++-
 net/netfilter/nft_fwd_netdev.c                     |   8 ++
 net/packet/af_packet.c                             |  21 ++++
 net/packet/internal.h                              |   5 +-
 net/sched/cls_route.c                              |   4 +-
 net/sched/cls_tcindex.c                            |   1 +
 net/xfrm/xfrm_device.c                             |   1 +
 net/xfrm/xfrm_policy.c                             |   2 +
 net/xfrm/xfrm_user.c                               |   6 +-
 scripts/Makefile.extrawarn                         |   1 +
 scripts/dtc/dtc-lexer.l                            |   1 -
 scripts/parse-maintainers.pl                       |   0
 sound/core/oss/pcm_plugin.c                        |  12 +-
 sound/core/seq/oss/seq_oss_midi.c                  |   1 +
 sound/core/seq/seq_virmidi.c                       |   1 +
 sound/pci/hda/patch_realtek.c                      |   2 +
 sound/usb/line6/driver.c                           |   2 +-
 sound/usb/line6/midibuf.c                          |   2 +-
 tools/perf/Makefile                                |   2 +-
 tools/perf/util/map.c                              |   2 +-
 tools/perf/util/probe-finder.c                     |  11 +-
 .../cpupower/utils/idle_monitor/amd_fam14h_idle.c  |   2 +-
 .../cpupower/utils/idle_monitor/cpuidle_sysfs.c    |   2 +-
 .../cpupower/utils/idle_monitor/cpupower-monitor.c |   2 +
 .../cpupower/utils/idle_monitor/cpupower-monitor.h |   2 +-
 tools/scripts/Makefile.include                     |   4 +-
 147 files changed, 1099 insertions(+), 436 deletions(-)


