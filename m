Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 293AD19CB05
	for <lists+stable@lfdr.de>; Thu,  2 Apr 2020 22:23:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389548AbgDBUXh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Apr 2020 16:23:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:36816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389540AbgDBUXh (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Apr 2020 16:23:37 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E63C02078B;
        Thu,  2 Apr 2020 20:23:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585859014;
        bh=bItGeFY2s65j2QCY89Perd/0NVYCF+2EEsQKcLwuujw=;
        h=Date:From:To:Cc:Subject:From;
        b=IvTy4z5nsvM8hSBy8P0q/k5Y87TybCTnuD8fd1kq1Nxb0crxEJrSheeDQzCaTQFeU
         5EKGEFpKGC9o9qrqgeP3hDOWz6Thh2iZZ1pvpQJM7hnne6a55UbpnCADwCxyZwzV0E
         Rj6iqZ0/N0mwFGUykjCQKi+jajZlwqJGpTFM7wYk=
Date:   Thu, 2 Apr 2020 22:23:31 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.4.218
Message-ID: <20200402202331.GA3259090@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.4.218 kernel.

All users of the 4.4 kernel series must upgrade.

The updated 4.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/devicetree/bindings/powerpc/fsl/fman.txt     |    7 
 Makefile                                                   |    2 
 arch/arm/boot/dts/dra7.dtsi                                |    2 
 arch/arm64/kernel/smp.c                                    |   17 +-
 arch/powerpc/kernel/vmlinux.lds.S                          |    6 
 arch/x86/kvm/vmx.c                                         |    4 
 arch/x86/mm/fault.c                                        |   26 +++
 drivers/acpi/apei/ghes.c                                   |    2 
 drivers/gpu/drm/drm_dp_mst_topology.c                      |   15 --
 drivers/gpu/drm/exynos/exynos_drm_dsi.c                    |   12 -
 drivers/hwspinlock/hwspinlock_core.c                       |    2 
 drivers/hwtracing/intel_th/msu.c                           |    6 
 drivers/i2c/busses/i2c-hix5hd2.c                           |    1 
 drivers/infiniband/ulp/ipoib/ipoib_fs.c                    |    2 
 drivers/media/usb/b2c2/flexcop-usb.c                       |    6 
 drivers/media/usb/dvb-usb/dib0700_core.c                   |    4 
 drivers/media/usb/gspca/ov519.c                            |   10 +
 drivers/media/usb/gspca/stv06xx/stv06xx.c                  |   19 ++
 drivers/media/usb/gspca/stv06xx/stv06xx_pb0100.c           |    4 
 drivers/media/usb/gspca/xirlink_cit.c                      |   18 ++
 drivers/media/usb/usbtv/usbtv-core.c                       |    2 
 drivers/misc/altera-stapl/altera.c                         |   12 -
 drivers/net/can/slcan.c                                    |    3 
 drivers/net/ethernet/micrel/ks8851_mll.c                   |   56 +++++++
 drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c            |    2 
 drivers/net/vxlan.c                                        |   11 +
 drivers/nfc/fdp/fdp.c                                      |    5 
 drivers/rtc/Kconfig                                        |    1 
 drivers/scsi/ipr.c                                         |    3 
 drivers/scsi/ipr.h                                         |    1 
 drivers/scsi/sd.c                                          |    4 
 drivers/spi/spi-qup.c                                      |    5 
 drivers/spi/spi-zynqmp-gqspi.c                             |    3 
 drivers/staging/rtl8188eu/os_dep/usb_intf.c                |    2 
 drivers/staging/speakup/main.c                             |    3 
 drivers/staging/wlan-ng/hfa384x_usb.c                      |    2 
 drivers/tty/vt/selection.c                                 |    5 
 drivers/tty/vt/vt.c                                        |   30 +++-
 drivers/tty/vt/vt_ioctl.c                                  |   80 +++++------
 drivers/usb/class/cdc-acm.c                                |   20 +-
 drivers/usb/core/quirks.c                                  |    6 
 drivers/usb/host/xhci-plat.c                               |    1 
 drivers/usb/musb/musb_host.c                               |   17 --
 drivers/usb/serial/io_edgeport.c                           |    2 
 drivers/usb/serial/option.c                                |    8 +
 drivers/usb/serial/pl2303.c                                |    1 
 drivers/usb/serial/pl2303.h                                |    1 
 drivers/vhost/net.c                                        |   13 -
 fs/inode.c                                                 |    1 
 fs/libfs.c                                                 |    8 -
 include/linux/fs.h                                         |    1 
 include/linux/futex.h                                      |   17 +-
 include/linux/kref.h                                       |    5 
 include/linux/selection.h                                  |    4 
 include/linux/vmalloc.h                                    |    5 
 include/linux/vt_kern.h                                    |    2 
 include/uapi/linux/if.h                                    |    4 
 kernel/bpf/syscall.c                                       |    3 
 kernel/futex.c                                             |   93 +++++++------
 kernel/irq/manage.c                                        |   11 +
 kernel/notifier.c                                          |    2 
 mm/memcontrol.c                                            |   10 +
 mm/nommu.c                                                 |   10 -
 mm/slub.c                                                  |   32 ++--
 mm/vmalloc.c                                               |   11 -
 net/dsa/tag_brcm.c                                         |    2 
 net/hsr/hsr_framereg.c                                     |   10 -
 net/hsr/hsr_netlink.c                                      |   74 +++++-----
 net/hsr/hsr_slave.c                                        |    8 -
 net/ipv4/Kconfig                                           |    1 
 net/ipv4/ip_vti.c                                          |   38 ++++-
 net/ipv4/route.c                                           |    7 
 net/ipv6/ip6_vti.c                                         |   34 +++-
 net/mac80211/mesh_hwmp.c                                   |    3 
 net/mac80211/sta_info.c                                    |    6 
 net/sched/cls_route.c                                      |    4 
 net/sched/cls_tcindex.c                                    |    1 
 net/xfrm/xfrm_policy.c                                     |    2 
 net/xfrm/xfrm_user.c                                       |    6 
 scripts/Makefile.extrawarn                                 |    1 
 scripts/dtc/dtc-lexer.l                                    |    1 
 scripts/dtc/dtc-lexer.lex.c_shipped                        |    1 
 sound/core/oss/pcm_plugin.c                                |   12 +
 sound/core/seq/oss/seq_oss_midi.c                          |    1 
 sound/core/seq/seq_virmidi.c                               |    1 
 sound/pci/hda/patch_realtek.c                              |    2 
 sound/usb/line6/driver.c                                   |    2 
 sound/usb/line6/midibuf.c                                  |    2 
 tools/perf/Makefile                                        |    2 
 tools/perf/util/map.c                                      |    2 
 tools/perf/util/probe-finder.c                             |   11 +
 tools/power/cpupower/utils/idle_monitor/amd_fam14h_idle.c  |    2 
 tools/power/cpupower/utils/idle_monitor/cpuidle_sysfs.c    |    2 
 tools/power/cpupower/utils/idle_monitor/cpupower-monitor.c |    2 
 tools/power/cpupower/utils/idle_monitor/cpupower-monitor.h |    2 
 tools/scripts/Makefile.include                             |    4 
 96 files changed, 631 insertions(+), 298 deletions(-)

Alaa Hleihel (1):
      IB/ipoib: Do not warn if IPoIB debugfs doesn't exist

Alexander Shishkin (1):
      intel_th: Fix user-visible error codes

Anthony Mallet (2):
      USB: cdc-acm: fix close_delay and closing_wait units in TIOCSSERIAL
      USB: cdc-acm: fix rounding error in TIOCSSERIAL

Chuhong Yuan (1):
      i2c: hix5hd2: add missed clk_disable_unprepare in remove

Chunguang Xu (1):
      memcg: fix NULL pointer dereference in __mem_cgroup_usage_unregister_event

Cong Wang (2):
      net_sched: cls_route: remove the right filter from hashtable
      net_sched: keep alloc_hash updated after hash allocation

Corentin Labbe (1):
      rtc: max8907: add missing select REGMAP_IRQ

Cristian Marussi (1):
      arm64: smp: fix smp_send_stop() behaviour

Dan Carpenter (1):
      NFC: fdp: Fix a signedness bug in fdp_nci_send_patch()

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

Eugenio Pérez (1):
      vhost: Check docket sk_family instead of call getname

Florian Fainelli (1):
      net: dsa: Fix duplicate frames flooded by learning

Greg Kroah-Hartman (2):
      bpf: Explicitly memset the bpf_attr structure
      Linux 4.4.218

Hans de Goede (1):
      usb: quirks: add NO_LPM quirk for RTL8153 based ethernet adapters

Jiri Slaby (3):
      vt: selection, introduce vc_is_sel
      vt: ioctl, switch VT_IS_IN_USE and VT_BUSY to inlines
      vt: switch vt_dont_switch to bool

Joerg Roedel (1):
      x86/mm: split vmalloc_sync_all()

Johan Hovold (6):
      media: flexcop-usb: fix endpoint sanity check
      media: usbtv: fix control-message timeouts
      media: ov519: add missing endpoint sanity checks
      media: dib0700: fix rc endpoint lookup
      media: stv06xx: add missing descriptor sanity checks
      media: xirlink_cit: add missing descriptor sanity checks

Johannes Berg (1):
      mac80211: mark station unauthorized before key removal

Jonas Gorski (1):
      uapi glibc compat: fix outer guard of net device flags enum

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
      Revert "drm/dp_mst: Skip validating ports during destruction, just ref"

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
      tools: Let O= makes handle a relative path with -C option

Matthew Wilcox (1):
      drivers/hwspinlock: use correct radix tree API

Matthias Reichl (1):
      USB: cdc-acm: restore capability check order

Michael Straube (1):
      staging: rtl8188eu: Add device id for MERCUSYS MW150US v2

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

Pawel Dembicki (3):
      USB: serial: option: add support for ASKEY WWHC050
      USB: serial: option: add BroadMobi BM806U
      USB: serial: option: add Wistron Neweb D19Q1

Peter Zijlstra (2):
      futex: Fix inode life-time issue
      locking/atomic, kref: Add kref_read()

Qiujun Huang (2):
      USB: serial: io_edgeport: fix slab-out-of-bounds read in edge_interrupt_callback
      staging: wlan-ng: fix use-after-free Read in hfa384x_usbin_callback

Ran Wang (1):
      usb: host: xhci-plat: add a shutdown

Sabrina Dubroca (1):
      net: ipv4: don't let PMTU updates increase route MTU

Samuel Thibault (1):
      staging/speakup: fix get_word non-space look-ahead

Scott Chen (1):
      USB: serial: pl2303: add device-id for HP LD381

Sean Christopherson (1):
      KVM: VMX: Do not allow reexecute_instruction() when skipping MMIO instr

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

Xin Long (2):
      xfrm: fix uctx len check in verify_sec_ctx_len
      xfrm: add the missing verify_sec_ctx_len check in xfrm_add_acquire

YueHaibing (1):
      xfrm: policy: Fix doulbe free in xfrm_policy_timer

Yuji Sasaki (1):
      spi: qup: call spi_qup_pm_resume_runtime before suspending

disconnect3d (1):
      perf map: Fix off by one in strncpy() size argument

