Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE54E19CB0C
	for <lists+stable@lfdr.de>; Thu,  2 Apr 2020 22:24:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389851AbgDBUYK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Apr 2020 16:24:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:37118 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389848AbgDBUYJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Apr 2020 16:24:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9883B2078B;
        Thu,  2 Apr 2020 20:24:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585859046;
        bh=sZ3jNeHbeKFGMfa9IsQEQOtZhrZe8g5oD3j/FbjjGkE=;
        h=Date:From:To:Cc:Subject:From;
        b=LIfv4bFwSW7JweFUOx45GndIaYtZTgVObI913g4NmIqL/b9a0AAHJNTpSx6mcotcv
         WXieLd0UAWvhixBtmXHBvf4XZ9/PIElN2hCt9HmrTyMs/NIe6S4rM8IUqaVgtvnlAb
         USw7HwtC5RN2dDNEqanMdgMIOSkGsE5VZPYXIe74=
Date:   Thu, 2 Apr 2020 22:24:03 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.9.218
Message-ID: <20200402202403.GA3259218@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="/04w6evG8XlLl3ft"
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--/04w6evG8XlLl3ft
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 4.9.218 kernel.

All users of the 4.9 kernel series must upgrade.

The updated 4.9.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-4.9.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Ds=
ummary

thanks,

greg k-h

------------

 Documentation/devicetree/bindings/powerpc/fsl/fman.txt     |    7=20
 Makefile                                                   |    2=20
 arch/arm/boot/dts/dra7.dtsi                                |    3=20
 arch/arm/boot/dts/omap5.dtsi                               |    1=20
 arch/arm64/include/asm/alternative.h                       |    2=20
 arch/arm64/kernel/smp.c                                    |   17 +-
 arch/powerpc/kernel/vmlinux.lds.S                          |    6=20
 arch/x86/kvm/vmx.c                                         |    4=20
 arch/x86/mm/fault.c                                        |   26 +++
 drivers/acpi/apei/ghes.c                                   |    2=20
 drivers/gpu/drm/drm_dp_mst_topology.c                      |   15 --
 drivers/gpu/drm/exynos/exynos_drm_dsi.c                    |   12 -
 drivers/hwtracing/intel_th/msu.c                           |    6=20
 drivers/i2c/busses/i2c-hix5hd2.c                           |    1=20
 drivers/iio/magnetometer/ak8974.c                          |    2=20
 drivers/input/touchscreen/raydium_i2c_ts.c                 |    4=20
 drivers/media/usb/b2c2/flexcop-usb.c                       |    6=20
 drivers/media/usb/dvb-usb/dib0700_core.c                   |    4=20
 drivers/media/usb/gspca/ov519.c                            |   10 +
 drivers/media/usb/gspca/stv06xx/stv06xx.c                  |   19 ++
 drivers/media/usb/gspca/stv06xx/stv06xx_pb0100.c           |    4=20
 drivers/media/usb/gspca/xirlink_cit.c                      |   18 ++
 drivers/media/usb/usbtv/usbtv-core.c                       |    2=20
 drivers/misc/altera-stapl/altera.c                         |   12 -
 drivers/mmc/host/sdhci-of-at91.c                           |    8 -
 drivers/net/can/slcan.c                                    |    3=20
 drivers/net/ethernet/marvell/mvneta.c                      |    3=20
 drivers/net/ethernet/micrel/ks8851_mll.c                   |   56 +++++++
 drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c            |    2=20
 drivers/net/macsec.c                                       |    3=20
 drivers/net/vxlan.c                                        |   11 +
 drivers/nfc/fdp/fdp.c                                      |    5=20
 drivers/rtc/Kconfig                                        |    1=20
 drivers/scsi/ipr.c                                         |    3=20
 drivers/scsi/ipr.h                                         |    1=20
 drivers/scsi/sd.c                                          |    4=20
 drivers/spi/spi-qup.c                                      |   11 -
 drivers/spi/spi-zynqmp-gqspi.c                             |    3=20
 drivers/staging/greybus/tools/loopback_test.c              |   17 +-
 drivers/staging/rtl8188eu/os_dep/usb_intf.c                |    2=20
 drivers/staging/speakup/main.c                             |    3=20
 drivers/staging/wlan-ng/hfa384x_usb.c                      |    2=20
 drivers/staging/wlan-ng/prism2usb.c                        |    1=20
 drivers/tty/vt/selection.c                                 |    5=20
 drivers/tty/vt/vt.c                                        |   30 +++-
 drivers/tty/vt/vt_ioctl.c                                  |   80 +++++---=
---
 drivers/usb/class/cdc-acm.c                                |   20 +-
 drivers/usb/core/quirks.c                                  |    6=20
 drivers/usb/host/xhci-plat.c                               |    1=20
 drivers/usb/musb/musb_host.c                               |   17 --
 drivers/usb/serial/io_edgeport.c                           |    2=20
 drivers/usb/serial/option.c                                |    8 +
 drivers/usb/serial/pl2303.c                                |    1=20
 drivers/usb/serial/pl2303.h                                |    1=20
 fs/inode.c                                                 |    1=20
 fs/libfs.c                                                 |    8 -
 include/linux/fs.h                                         |    1=20
 include/linux/futex.h                                      |   17 +-
 include/linux/kref.h                                       |    5=20
 include/linux/selection.h                                  |    4=20
 include/linux/vmalloc.h                                    |    5=20
 include/linux/vt_kern.h                                    |    2=20
 kernel/bpf/syscall.c                                       |    3=20
 kernel/futex.c                                             |   93 +++++++-=
-----
 kernel/irq/manage.c                                        |   11 +
 kernel/notifier.c                                          |    2=20
 mm/memcontrol.c                                            |   10 +
 mm/nommu.c                                                 |   10 -
 mm/slub.c                                                  |   32 ++--
 mm/vmalloc.c                                               |   11 -
 net/dsa/tag_brcm.c                                         |    2=20
 net/hsr/hsr_framereg.c                                     |   10 -
 net/hsr/hsr_netlink.c                                      |   74 +++++---=
--
 net/hsr/hsr_slave.c                                        |    8 -
 net/ipv4/Kconfig                                           |    1=20
 net/ipv4/ip_vti.c                                          |   38 ++++-
 net/ipv4/route.c                                           |    7=20
 net/ipv6/ip6_vti.c                                         |   34 +++-
 net/mac80211/mesh_hwmp.c                                   |    3=20
 net/mac80211/sta_info.c                                    |    6=20
 net/mac80211/tx.c                                          |   20 ++
 net/netfilter/nft_fwd_netdev.c                             |    8 +
 net/sched/cls_route.c                                      |    4=20
 net/sched/cls_tcindex.c                                    |    1=20
 net/xfrm/xfrm_policy.c                                     |    2=20
 net/xfrm/xfrm_user.c                                       |    6=20
 scripts/Makefile.extrawarn                                 |    1=20
 scripts/dtc/dtc-lexer.l                                    |    1=20
 scripts/dtc/dtc-lexer.lex.c_shipped                        |    1=20
 sound/core/oss/pcm_plugin.c                                |   12 +
 sound/core/seq/oss/seq_oss_midi.c                          |    1=20
 sound/core/seq/seq_virmidi.c                               |    1=20
 sound/pci/hda/patch_realtek.c                              |    2=20
 sound/usb/line6/driver.c                                   |    2=20
 sound/usb/line6/midibuf.c                                  |    2=20
 tools/perf/Makefile                                        |    2=20
 tools/perf/util/map.c                                      |    2=20
 tools/perf/util/probe-finder.c                             |   11 +
 tools/power/cpupower/utils/idle_monitor/amd_fam14h_idle.c  |    2=20
 tools/power/cpupower/utils/idle_monitor/cpuidle_sysfs.c    |    2=20
 tools/power/cpupower/utils/idle_monitor/cpupower-monitor.c |    2=20
 tools/power/cpupower/utils/idle_monitor/cpupower-monitor.h |    2=20
 tools/scripts/Makefile.include                             |    4=20
 103 files changed, 681 insertions(+), 303 deletions(-)

Alexander Shishkin (1):
      intel_th: Fix user-visible error codes

Anthony Mallet (2):
      USB: cdc-acm: fix close_delay and closing_wait units in TIOCSSERIAL
      USB: cdc-acm: fix rounding error in TIOCSSERIAL

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

Cristian Marussi (1):
      arm64: smp: fix smp_send_stop() behaviour

Dan Carpenter (2):
      NFC: fdp: Fix a signedness bug in fdp_nci_send_patch()
      Input: raydium_i2c_ts - fix error codes in raydium_i2c_boot_trigger()

Daniel Axtens (1):
      altera-stapl: altera_get_note: prevent write beyond end of 'key'

Daniele Palmas (1):
      USB: serial: option: add ME910G1 ECM composition 0x110b

Dirk Mueller (1):
      scripts/dtc: Remove redundant YYLOC global declaration

Dominik Czarnota (1):
      sxgbe: Fix off by one in samsung driver strncpy size arg

Edward Cree (1):
      genirq: Fix reference leaks on irq affinity notifiers

Eric Biggers (4):
      libfs: fix infoleak in simple_attr_read()
      vt: vt_ioctl: remove unnecessary console allocation checks
      vt: vt_ioctl: fix VT_DISALLOCATE freeing in-use virtual console
      vt: vt_ioctl: fix use-after-free in vt_in_use()

Florian Fainelli (1):
      net: dsa: Fix duplicate frames flooded by learning

Greg Kroah-Hartman (2):
      bpf: Explicitly memset the bpf_attr structure
      Linux 4.9.218

Gustavo A. R. Silva (1):
      Input: raydium_i2c_ts - use true and false for boolean values

Hans de Goede (1):
      usb: quirks: add NO_LPM quirk for RTL8153 based ethernet adapters

Ilie Halip (1):
      arm64: alternative: fix build with clang integrated assembler

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

Madalin Bucur (1):
      dt-bindings: net: FMan erratum A050385

Mans Rullgard (1):
      usb: musb: fix crash with highmen PIO and usbmon

Marek Szyprowski (2):
      drm/exynos: dsi: propagate error value and silence meaningless warning
      drm/exynos: dsi: fix workaround for the legacy clock name

Marek Vasut (1):
      net: ks8851-ml: Fix IO operations, again

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

Nathan Chancellor (1):
      kbuild: Disable -Wpointer-to-enum-cast

Naveen N. Rao (1):
      powerpc: Include .BTF section

Nicolas Cavallari (1):
      mac80211: Do not send mesh HWMP PREQ if HWMP is disabled

Nicolas Dichtel (1):
      vti[6]: fix packet tx through bpf_redirect() in XinY cases

Oliver Hartkopp (1):
      slcan: not call free_netdev before rtnl_unlock in slcan_open

Pablo Neira Ayuso (1):
      netfilter: nft_fwd_netdev: validate family and chain type

Pawel Dembicki (3):
      USB: serial: option: add support for ASKEY WWHC050
      USB: serial: option: add BroadMobi BM806U
      USB: serial: option: add Wistron Neweb D19Q1

Peter Zijlstra (2):
      futex: Fix inode life-time issue
      locking/atomic, kref: Add kref_read()

Qiujun Huang (3):
      USB: serial: io_edgeport: fix slab-out-of-bounds read in edge_interru=
pt_callback
      staging: wlan-ng: fix ODEBUG bug in prism2sta_disconnect_usb
      staging: wlan-ng: fix use-after-free Read in hfa384x_usbin_callback

Ran Wang (1):
      usb: host: xhci-plat: add a shutdown

Roger Quadros (2):
      ARM: dts: dra7: Add bus_dma_limit for L3 bus
      ARM: dts: omap5: Add bus_dma_limit for L3 bus

Sabrina Dubroca (1):
      net: ipv4: don't let PMTU updates increase route MTU

Samuel Thibault (1):
      staging/speakup: fix get_word non-space look-ahead

Scott Chen (1):
      USB: serial: pl2303: add device-id for HP LD381

Sean Christopherson (1):
      KVM: VMX: Do not allow reexecute_instruction() when skipping MMIO ins=
tr

Stephan Gerhold (1):
      iio: magnetometer: ak8974: Fix negative raw values in sysfs

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

Vlastimil Babka (1):
      mm, slub: prevent kmalloc_node crashes and memory leaks

Wen Xiong (1):
      scsi: ipr: Fix softlockup when rescanning devices in petitboot

Willem de Bruijn (1):
      macsec: restrict to ethernet devices

Xin Long (2):
      xfrm: fix uctx len check in verify_sec_ctx_len
      xfrm: add the missing verify_sec_ctx_len check in xfrm_add_acquire

YueHaibing (1):
      xfrm: policy: Fix doulbe free in xfrm_policy_timer

Yuji Sasaki (1):
      spi: qup: call spi_qup_pm_resume_runtime before suspending

disconnect3d (1):
      perf map: Fix off by one in strncpy() size argument


--/04w6evG8XlLl3ft
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl6GSeAACgkQONu9yGCS
aT6ONQ/+MxWsr/aNXp7bMFEljHoL66wHwjaCWyh+hbYHJvprudw6lpmIMUE4wfXU
Oy+mPOFGlWGGGU0750b6KdTen4TZHt2qzqyoUEbSwgnNm0NzZvdpUKSqwvAB2/bw
yDCs2/43/6woVh1iU1pzXOzQfF3I/0qOCITsBD+Vs8T2A6CC1/E/r7rquTEd3Tlz
WPUiXmw5DNUvD4eu9+CBgimShNw2iGIyCiKr/O9zlhbZdnwGae4AbyZQdc0NftfY
Dk5sRjxY2guuiLFITxEl+Vyxe+GJJPWVyZO5ofkflnMQMOmJCMz1EN0c78t33C8R
ObcF1UjWg50bXGlKAuk2O/IFTJaaGxQqKDVfuEWiT6t7KqzVd5ioMKNr8pvehUK/
5Ocs9PWahrhj8tehtGDjoVyZTkEB3xwg4nPmz05AwyDLWTNPKXvHGs5nneqOFj8X
TFiBCXlwltlpTtPkCGO5ahYOBtBtjZY6l/oXlesmlXAghZneyBoqbGkIz9uVxuBJ
eTgnXB0M2aK5uvqgadQWRdHe7PvoafPOjpGt9akw2Qfg1ecjCYTcYnBalvV2r/GJ
CPVEKGavOQrYpFl4lZZbgHH9auINwyau9BYjLP+Etro/w+Qk2SYVvNfWhxar0rSq
DmWCUCY6m+dN1zrxlmfJtIztotvMroENJkE4IGAkNkq2jJ/9Owo=
=EvIb
-----END PGP SIGNATURE-----

--/04w6evG8XlLl3ft--
