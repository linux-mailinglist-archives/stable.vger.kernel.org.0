Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C96719CB13
	for <lists+stable@lfdr.de>; Thu,  2 Apr 2020 22:25:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390139AbgDBUYw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Apr 2020 16:24:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:37508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389431AbgDBUYv (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Apr 2020 16:24:51 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A6DF420678;
        Thu,  2 Apr 2020 20:24:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585859090;
        bh=x5o+1iwpQU/BmYPvFHGvB3SjrDT4GjiibfY3KH1S78c=;
        h=Date:From:To:Cc:Subject:From;
        b=piensMzC5rGjoELH2HXGcFLhB45lyuP5FyQOLwtvjp8MIUZucdM0kxQTSgQHQf0nY
         aE5i/sgeS5GKNEC+iHDa4Cibg0timWY0Rf+kYmZDLcpE7wnFUH/pEQPPQ0EMsU6Qkn
         rWJUPP6kQhwz4+RHUc2mQYYxLRb6nJJcgAat7cmk=
Date:   Thu, 2 Apr 2020 22:24:47 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.14.175
Message-ID: <20200402202447.GA3259359@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="8t9RHnE3ZwKMSgU+"
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--8t9RHnE3ZwKMSgU+
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 4.14.175 kernel.

All users of the 4.14 kernel series must upgrade.

The updated 4.14.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-4.14.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Ds=
ummary

thanks,

greg k-h

------------

 Documentation/devicetree/bindings/net/fsl-fman.txt         |    7=20
 Makefile                                                   |    2=20
 arch/arm/boot/dts/bcm2835-rpi-zero-w.dts                   |    1=20
 arch/arm/boot/dts/dra7.dtsi                                |    3=20
 arch/arm/boot/dts/omap5.dtsi                               |    1=20
 arch/arm/boot/dts/ox810se.dtsi                             |    4=20
 arch/arm/boot/dts/ox820.dtsi                               |    4=20
 arch/arm64/boot/dts/freescale/fsl-ls1043-post.dtsi         |    2=20
 arch/arm64/boot/dts/freescale/fsl-ls1043a-rdb.dts          |    4=20
 arch/arm64/boot/dts/freescale/fsl-ls1046a-rdb.dts          |    4=20
 arch/arm64/include/asm/alternative.h                       |    2=20
 arch/arm64/kernel/ptrace.c                                 |    2=20
 arch/arm64/kernel/signal32.c                               |    8=20
 arch/arm64/kernel/smp.c                                    |   25 +-
 arch/powerpc/kernel/vmlinux.lds.S                          |    6=20
 arch/x86/kernel/ftrace.c                                   |    2=20
 arch/x86/mm/fault.c                                        |   26 ++
 block/bfq-cgroup.c                                         |    9=20
 drivers/acpi/apei/ghes.c                                   |    2=20
 drivers/gpio/gpiolib-acpi.c                                |  140 ++++++++=
++---
 drivers/gpu/drm/bridge/synopsys/dw-hdmi.c                  |   46 ++--
 drivers/gpu/drm/drm_dp_mst_topology.c                      |   15 -
 drivers/gpu/drm/exynos/exynos_drm_dsi.c                    |   12 -
 drivers/hwtracing/intel_th/msu.c                           |    6=20
 drivers/hwtracing/intel_th/pci.c                           |    5=20
 drivers/i2c/busses/i2c-hix5hd2.c                           |    1=20
 drivers/iio/adc/at91-sama5d2_adc.c                         |   45 +++-
 drivers/iio/magnetometer/ak8974.c                          |    2=20
 drivers/iio/trigger/stm32-timer-trigger.c                  |   11 -
 drivers/infiniband/core/security.c                         |   11 -
 drivers/infiniband/hw/mlx5/qp.c                            |    4=20
 drivers/input/mouse/synaptics.c                            |    1=20
 drivers/input/touchscreen/raydium_i2c_ts.c                 |    4=20
 drivers/md/dm-bio-record.h                                 |   15 +
 drivers/media/usb/b2c2/flexcop-usb.c                       |    6=20
 drivers/media/usb/dvb-usb/dib0700_core.c                   |    4=20
 drivers/media/usb/gspca/ov519.c                            |   10=20
 drivers/media/usb/gspca/stv06xx/stv06xx.c                  |   19 +
 drivers/media/usb/gspca/stv06xx/stv06xx_pb0100.c           |    4=20
 drivers/media/usb/gspca/xirlink_cit.c                      |   18 +
 drivers/media/usb/usbtv/usbtv-core.c                       |    2=20
 drivers/media/usb/usbtv/usbtv-video.c                      |    5=20
 drivers/misc/altera-stapl/altera.c                         |   12 -
 drivers/mmc/host/sdhci-of-at91.c                           |    8=20
 drivers/net/can/slcan.c                                    |    3=20
 drivers/net/dsa/mt7530.c                                   |    2=20
 drivers/net/ethernet/broadcom/bnxt/bnxt_dcb.c              |   15 -
 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c             |    4=20
 drivers/net/ethernet/freescale/fman/Kconfig                |   28 ++
 drivers/net/ethernet/freescale/fman/fman.c                 |   18 +
 drivers/net/ethernet/freescale/fman/fman.h                 |    5=20
 drivers/net/ethernet/marvell/mvneta.c                      |    3=20
 drivers/net/ethernet/micrel/ks8851_mll.c                   |   56 ++++-
 drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c            |    2=20
 drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c             |    2=20
 drivers/net/macsec.c                                       |    3=20
 drivers/net/usb/qmi_wwan.c                                 |    1=20
 drivers/net/vrf.c                                          |   19 -
 drivers/net/vxlan.c                                        |   11 -
 drivers/nfc/fdp/fdp.c                                      |    5=20
 drivers/of/of_mdio.c                                       |    1=20
 drivers/perf/arm_pmu_acpi.c                                |    7=20
 drivers/platform/x86/pmc_atom.c                            |    8=20
 drivers/rtc/Kconfig                                        |    1=20
 drivers/scsi/ipr.c                                         |    3=20
 drivers/scsi/ipr.h                                         |    1=20
 drivers/scsi/sd.c                                          |    4=20
 drivers/spi/spi-pxa2xx.c                                   |   23 ++
 drivers/spi/spi-qup.c                                      |   11 -
 drivers/spi/spi-zynqmp-gqspi.c                             |    3=20
 drivers/staging/greybus/tools/loopback_test.c              |   17 -
 drivers/staging/rtl8188eu/os_dep/usb_intf.c                |    2=20
 drivers/staging/speakup/main.c                             |    2=20
 drivers/staging/wlan-ng/hfa384x_usb.c                      |    2=20
 drivers/staging/wlan-ng/prism2usb.c                        |    1=20
 drivers/tty/vt/selection.c                                 |    5=20
 drivers/tty/vt/vt.c                                        |   30 ++
 drivers/tty/vt/vt_ioctl.c                                  |   80 +++----
 drivers/usb/class/cdc-acm.c                                |   20 +
 drivers/usb/core/quirks.c                                  |    6=20
 drivers/usb/host/xhci-pci.c                                |    3=20
 drivers/usb/host/xhci-plat.c                               |    1=20
 drivers/usb/host/xhci-trace.h                              |   23 --
 drivers/usb/musb/musb_host.c                               |   17 -
 drivers/usb/serial/io_edgeport.c                           |    2=20
 drivers/usb/serial/option.c                                |    8=20
 drivers/usb/serial/pl2303.c                                |    1=20
 drivers/usb/serial/pl2303.h                                |    1=20
 drivers/xen/xenbus/xenbus_comms.c                          |    4=20
 drivers/xen/xenbus/xenbus_xs.c                             |    9=20
 fs/afs/rxrpc.c                                             |    4=20
 fs/inode.c                                                 |    1=20
 fs/libfs.c                                                 |    8=20
 include/linux/fs.h                                         |    1=20
 include/linux/futex.h                                      |   17 -
 include/linux/page-flags.h                                 |    2=20
 include/linux/selection.h                                  |    4=20
 include/linux/vmalloc.h                                    |    5=20
 include/linux/vt_kern.h                                    |    2=20
 include/trace/events/afs.h                                 |    2=20
 include/uapi/linux/serio.h                                 |   10=20
 kernel/bpf/syscall.c                                       |    9=20
 kernel/cgroup/cgroup-v1.c                                  |    3=20
 kernel/futex.c                                             |   93 +++++---
 kernel/irq/manage.c                                        |   11 -
 kernel/notifier.c                                          |    2=20
 mm/memcontrol.c                                            |   10=20
 mm/nommu.c                                                 |   10=20
 mm/slub.c                                                  |   32 +-
 mm/vmalloc.c                                               |   11 -
 net/dsa/tag_brcm.c                                         |    2=20
 net/hsr/hsr_framereg.c                                     |   10=20
 net/hsr/hsr_netlink.c                                      |   74 +++---
 net/hsr/hsr_slave.c                                        |    8=20
 net/ipv4/Kconfig                                           |    1=20
 net/ipv4/ip_vti.c                                          |   38 ++-
 net/ipv4/route.c                                           |    7=20
 net/ipv6/ip6_vti.c                                         |   34 ++-
 net/ipv6/tcp_ipv6.c                                        |    3=20
 net/mac80211/mesh_hwmp.c                                   |    3=20
 net/mac80211/sta_info.c                                    |    6=20
 net/mac80211/tx.c                                          |   20 +
 net/netfilter/nft_fwd_netdev.c                             |    8=20
 net/packet/af_packet.c                                     |   21 +
 net/packet/internal.h                                      |    5=20
 net/sched/cls_route.c                                      |    4=20
 net/sched/cls_tcindex.c                                    |    1=20
 net/xfrm/xfrm_device.c                                     |    1=20
 net/xfrm/xfrm_policy.c                                     |    2=20
 net/xfrm/xfrm_user.c                                       |    6=20
 scripts/Makefile.extrawarn                                 |    1=20
 scripts/dtc/dtc-lexer.l                                    |    1=20
 scripts/dtc/dtc-lexer.lex.c_shipped                        |    1=20
 sound/core/oss/pcm_plugin.c                                |   12 -
 sound/core/seq/oss/seq_oss_midi.c                          |    1=20
 sound/core/seq/seq_virmidi.c                               |    1=20
 sound/pci/hda/patch_realtek.c                              |    2=20
 sound/usb/line6/driver.c                                   |    2=20
 sound/usb/line6/midibuf.c                                  |    2=20
 tools/perf/Makefile                                        |    2=20
 tools/perf/util/map.c                                      |    2=20
 tools/perf/util/probe-finder.c                             |   11 -
 tools/power/cpupower/utils/idle_monitor/amd_fam14h_idle.c  |    2=20
 tools/power/cpupower/utils/idle_monitor/cpuidle_sysfs.c    |    2=20
 tools/power/cpupower/utils/idle_monitor/cpupower-monitor.c |    2=20
 tools/power/cpupower/utils/idle_monitor/cpupower-monitor.h |    2=20
 tools/scripts/Makefile.include                             |    4=20
 147 files changed, 1098 insertions(+), 436 deletions(-)

Alberto Mattea (1):
      usb: xhci: apply XHCI_SUSPEND_DELAY to AMD XHCI controller 1022:145c

Alexander Shishkin (2):
      intel_th: Fix user-visible error codes
      intel_th: pci: Add Elkhart Lake CPU support

Anthony Mallet (2):
      USB: cdc-acm: fix close_delay and closing_wait units in TIOCSSERIAL
      USB: cdc-acm: fix rounding error in TIOCSSERIAL

Carlo Nonato (1):
      block, bfq: fix overwrite of bfq_group pointer in bfq_find_set_group()

Chuhong Yuan (1):
      i2c: hix5hd2: add missed clk_disable_unprepare in remove

Chunguang Xu (1):
      memcg: fix NULL pointer dereference in __mem_cgroup_usage_unregister_=
event

Cong Wang (2):
      net_sched: cls_route: remove the right filter from hashtable
      net_sched: keep alloc_hash updated after hash allocation

Corentin Labbe (1):
      rtc: max8907: add missing select REGMAP_IRQ

Cristian Marussi (2):
      arm64: smp: fix smp_send_stop() behaviour
      arm64: smp: fix crash_smp_send_stop() behaviour

Dajun Jin (1):
      drivers/of/of_mdio.c:fix of_mdiobus_register()

Dan Carpenter (2):
      NFC: fdp: Fix a signedness bug in fdp_nci_send_patch()
      Input: raydium_i2c_ts - fix error codes in raydium_i2c_boot_trigger()

Daniel Axtens (1):
      altera-stapl: altera_get_note: prevent write beyond end of 'key'

Daniele Palmas (1):
      USB: serial: option: add ME910G1 ECM composition 0x110b

David Howells (1):
      afs: Fix some tracing details

Dirk Mueller (1):
      scripts/dtc: Remove redundant YYLOC global declaration

Dominik Czarnota (1):
      sxgbe: Fix off by one in samsung driver strncpy size arg

Dongli Zhang (2):
      xenbus: req->body should be updated before req->state
      xenbus: req->err should be updated before req->state

Edward Cree (1):
      genirq: Fix reference leaks on irq affinity notifiers

Edwin Peer (1):
      bnxt_en: fix memory leaks in bnxt_dcbnl_ieee_getets()

Emil Renner Berthing (1):
      net: stmmac: dwmac-rk: fix error path in rk_gmac_probe

Eric Biggers (4):
      libfs: fix infoleak in simple_attr_read()
      vt: vt_ioctl: remove unnecessary console allocation checks
      vt: vt_ioctl: fix VT_DISALLOCATE freeing in-use virtual console
      vt: vt_ioctl: fix use-after-free in vt_in_use()

Eugen Hristev (2):
      iio: adc: at91-sama5d2_adc: fix channel configuration for differentia=
l channels
      iio: adc: at91-sama5d2_adc: fix differential channels in triggered mo=
de

Eugene Syromiatnikov (1):
      Input: avoid BIT() macro usage in the serio.h UAPI header

Evan Green (1):
      spi: pxa2xx: Add CS control clock quirk

Fabrice Gasnier (1):
      iio: trigger: stm32-timer: disable master mode when stopping

Florian Fainelli (1):
      net: dsa: Fix duplicate frames flooded by learning

Georg M=C3=BCller (1):
      platform/x86: pmc_atom: Add Lex 2I385SW to critclk_systems DMI table

Greg Kroah-Hartman (3):
      bpf: Explicitly memset the bpf_attr structure
      bpf: Explicitly memset some bpf info structures declared on the stack
      Linux 4.14.175

Gustavo A. R. Silva (1):
      Input: raydium_i2c_ts - use true and false for boolean values

Hans de Goede (5):
      usb: quirks: add NO_LPM quirk for RTL8153 based ethernet adapters
      gpiolib: acpi: Correct comment for HP x2 10 honor_wakeup quirk
      gpiolib: acpi: Rework honor_wakeup option into an ignore_wake option
      gpiolib: acpi: Add quirk to ignore EC wakeups on HP x2 10 BYT + AXP28=
8 model
      gpiolib: acpi: Add quirk to ignore EC wakeups on HP x2 10 CHT + AXP28=
8 model

Ilie Halip (1):
      arm64: alternative: fix build with clang integrated assembler

Jernej Skrabec (1):
      drm/bridge: dw-hdmi: fix AVI frame colorimetry

Jiri Kosina (1):
      ftrace/x86: Anotate text_mutex split between ftrace_arch_code_modify_=
post_process() and ftrace_arch_code_modify_prepare()

Jiri Slaby (3):
      vt: selection, introduce vc_is_sel
      vt: ioctl, switch VT_IS_IN_USE and VT_BUSY to inlines
      vt: switch vt_dont_switch to bool

Jisheng Zhang (1):
      net: mvneta: Fix the case where the last poll did not process all rx

Joerg Roedel (1):
      x86/mm: split vmalloc_sync_all()

Johan Hovold (8):
      staging: greybus: loopback_test: fix potential path truncation
      staging: greybus: loopback_test: fix potential path truncations
      media: flexcop-usb: fix endpoint sanity check
      media: usbtv: fix control-message timeouts
      media: ov519: add missing endpoint sanity checks
      media: dib0700: fix rc endpoint lookup
      media: stv06xx: add missing descriptor sanity checks
      media: xirlink_cit: add missing descriptor sanity checks

Johannes Berg (2):
      mac80211: mark station unauthorized before key removal
      mac80211: fix authentication with iwlwifi/mvm

Jonathan Neusch=C3=A4fer (1):
      parse-maintainers: Mark as executable

Jouni Malinen (1):
      mac80211: Check port authorization in the ieee80211_tx_dequeue() case

Kai-Heng Feng (2):
      USB: Disable LPM on WD19's Realtek Hub
      ALSA: hda/realtek: Fix pop noise on ALC225

Kishon Vijay Abraham I (1):
      ARM: dts: dra7: Add "dma-ranges" property to PCIe RC DT nodes

Larry Finger (1):
      staging: rtl8188eu: Add ASUS USB-N10 Nano B1 to device table

Linus Torvalds (1):
      mm: slub: be more careful about the double cmpxchg of freelist

Lyude Paul (1):
      Revert "drm/dp_mst: Skip validating ports during destruction, just re=
f"

Madalin Bucur (5):
      dt-bindings: net: FMan erratum A050385
      arm64: dts: ls1043a: FMan erratum A050385
      fsl/fman: detect FMan erratum A050385
      arm64: dts: ls1043a-rdb: correct RGMII delay mode to rgmii-id
      arm64: dts: ls1046ardb: set RGMII interfaces to RGMII_ID mode

Mans Rullgard (1):
      usb: musb: fix crash with highmen PIO and usbmon

Maor Gottlieb (1):
      RDMA/mlx5: Block delay drop to unprivileged users

Marek Szyprowski (2):
      drm/exynos: dsi: propagate error value and silence meaningless warning
      drm/exynos: dsi: fix workaround for the legacy clock name

Marek Vasut (1):
      net: ks8851-ml: Fix IO operations, again

Mark Rutland (2):
      arm64: ptrace: map SPSR_ELx<->PSR for compat tasks
      arm64: compat: map SPSR_ELx<->PSR for signals

Martin K. Petersen (1):
      scsi: sd: Fix optimal I/O size for devices that change reported values

Masami Hiramatsu (2):
      perf probe: Do not depend on dwfl_module_addrsym()
      tools: Let O=3D makes handle a relative path with -C option

Matthias Reichl (1):
      USB: cdc-acm: restore capability check order

Michael Straube (1):
      staging: rtl8188eu: Add device id for MERCUSYS MW150US v2

Micha=C5=82 Miros=C5=82aw (1):
      mmc: sdhci-of-at91: fix cd-gpios for SAMA5D2

Mike Gilbert (1):
      cpupower: avoid multiple definition with gcc -fno-common

Mike Marciniszyn (1):
      RDMA/core: Ensure security pkey modify is not lost

Mike Snitzer (1):
      dm bio record: save/restore bi_end_io and bi_integrity

Nathan Chancellor (2):
      kbuild: Disable -Wpointer-to-enum-cast
      dpaa_eth: Remove unnecessary boolean expression in dpaa_get_headroom

Naveen N. Rao (1):
      powerpc: Include .BTF section

Nick Hudson (1):
      ARM: bcm2835-rpi-zero-w: Add missing pinctrl name

Nicolas Cavallari (1):
      mac80211: Do not send mesh HWMP PREQ if HWMP is disabled

Nicolas Dichtel (1):
      vti[6]: fix packet tx through bpf_redirect() in XinY cases

Oliver Hartkopp (1):
      slcan: not call free_netdev before rtnl_unlock in slcan_open

Pablo Neira Ayuso (1):
      netfilter: nft_fwd_netdev: validate family and chain type

Pawel Dembicki (4):
      net: qmi_wwan: add support for ASKEY WWHC050
      USB: serial: option: add support for ASKEY WWHC050
      USB: serial: option: add BroadMobi BM806U
      USB: serial: option: add Wistron Neweb D19Q1

Peter Zijlstra (1):
      futex: Fix inode life-time issue

Qian Cai (1):
      page-flags: fix a crash at SetPageError(THP_SWAP)

Qiujun Huang (3):
      USB: serial: io_edgeport: fix slab-out-of-bounds read in edge_interru=
pt_callback
      staging: wlan-ng: fix ODEBUG bug in prism2sta_disconnect_usb
      staging: wlan-ng: fix use-after-free Read in hfa384x_usbin_callback

Raed Salem (1):
      xfrm: handle NETDEV_UNREGISTER for xfrm device

Ran Wang (1):
      usb: host: xhci-plat: add a shutdown

Ren=C3=A9 van Dorst (1):
      net: dsa: mt7530: Change the LINK bit to reflect the link status

Roger Quadros (2):
      ARM: dts: dra7: Add bus_dma_limit for L3 bus
      ARM: dts: omap5: Add bus_dma_limit for L3 bus

Sabrina Dubroca (1):
      net: ipv4: don't let PMTU updates increase route MTU

Samuel Thibault (1):
      staging/speakup: fix get_word non-space look-ahead

Sasha Levin (2):
      Revert "vrf: mark skb for multicast or link-local as enslaved to VRF"
      Revert "ipv6: Fix handling of LLA with VRF and sockets bound to VRF"

Scott Chen (1):
      USB: serial: pl2303: add device-id for HP LD381

Stephan Gerhold (1):
      iio: magnetometer: ak8974: Fix negative raw values in sysfs

Steven Rostedt (VMware) (1):
      xhci: Do not open code __print_symbolic() in xhci trace events

Sungbo Eo (1):
      ARM: dts: oxnas: Fix clear-mask property

Taehee Yoo (5):
      hsr: fix general protection fault in hsr_addr_is_self()
      vxlan: check return value of gro_cells_init()
      hsr: use rcu_read_lock() in hsr_get_node_{list/status}()
      hsr: add restart routine into hsr_get_node_list()
      hsr: set .netnsok flag

Takashi Iwai (5):
      ALSA: line6: Fix endless MIDI read loop
      ALSA: seq: virmidi: Fix running status after receiving sysex
      ALSA: seq: oss: Fix running status after receiving sysex
      ALSA: pcm: oss: Avoid plugin buffer overflow
      ALSA: pcm: oss: Remove WARNING from snd_pcm_plug_alloc() checks

Thomas Gleixner (1):
      futex: Unbreak futex hashing

Thommy Jakobsson (1):
      spi/zynqmp: remove entry that causes a cs glitch

Torsten Hilbrich (1):
      vti6: Fix memory leak of skb if input policy check fails

Tycho Andersen (1):
      cgroup1: don't call release_agent when it is ""

Vasily Averin (1):
      cgroup-v1: cgroup_pidlist_next should update position index

Vlastimil Babka (1):
      mm, slub: prevent kmalloc_node crashes and memory leaks

Wen Xiong (1):
      scsi: ipr: Fix softlockup when rescanning devices in petitboot

Willem de Bruijn (2):
      macsec: restrict to ethernet devices
      net/packet: tpacket_rcv: avoid a producer race condition

Xin Long (2):
      xfrm: fix uctx len check in verify_sec_ctx_len
      xfrm: add the missing verify_sec_ctx_len check in xfrm_add_acquire

YueHaibing (1):
      xfrm: policy: Fix doulbe free in xfrm_policy_timer

Yuji Sasaki (1):
      spi: qup: call spi_qup_pm_resume_runtime before suspending

Yussuf Khalil (1):
      Input: synaptics - enable RMI on HP Envy 13-ad105ng

disconnect3d (1):
      perf map: Fix off by one in strncpy() size argument

luanshi (1):
      drivers/perf: arm_pmu_acpi: Fix incorrect checking of gicc pointer


--8t9RHnE3ZwKMSgU+
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl6GSg8ACgkQONu9yGCS
aT7S/hAAiwxv+gTkMhBAE5uCG1SjBm+rznD3syOZ5LmD9bvsjoKP/vb7sABZePiJ
yFWqSqMqX2p5rsMwY333hNo0EJzgqUeoO5+/Du0uhr51G2oFdIFevYYXozto8qYK
I/ymW/ZGVj6FLO75lRLu96WmD9bUvsOY6GufPjWaqfTOJMmJ1QGxl+uVDe8K61/C
HMfK77CA+3v1KGUdW4BMMFxS7CrGx0yESPR7ySpZ4747/zp5aYZC/gyOJhmFcwcw
A6hbJLewRr6oFBuLxqlqp8Ouxv5W8dCTZJ4rytzLqhlKd/7XLQHpSeEnTVRxe2mq
DcaypwmhW+fiFVXNi+RG10x9EXk8rFoFl7AOJkaRg1y3i3CTuMyn0Rl96lvksLHF
6DhHG8+jbCQVK/TcdtEKaAwL2p0414829AMO0QjOC1gB/Sj5nT0/nQ1sReGpAYQ8
/9/6QtpwO+wha+YxiCGE4igGrpMX3ibUuklQTBTwmSvtDfy6npms5uh9jMPWtZJR
6Q0NWSYFpHTBS+Oheb7o21rDxPmG93JE2GMI8KvIsX0rrxnweYi0BrrJiFBOFWVN
zOlCJDD59ZW64fu4JuUQlmjJtHUy2VUP4wYqecm5XnnN9NVjeaUqcU1qac1VvEKD
vu8NiKkQTi5cMFJCe5atinxp8LVre01DNbAtiIA/zC3W+UecTw0=
=NFb8
-----END PGP SIGNATURE-----

--8t9RHnE3ZwKMSgU+--
