Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F6C0183C25
	for <lists+stable@lfdr.de>; Thu, 12 Mar 2020 23:14:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726550AbgCLWOC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Mar 2020 18:14:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:43318 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726513AbgCLWOC (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 12 Mar 2020 18:14:02 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CFBC420716;
        Thu, 12 Mar 2020 22:14:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584051241;
        bh=l6XznlB0LB6E3SwsLnoRQRCkqISuNS9iUKDe9y3NVrY=;
        h=Date:From:To:Cc:Subject:From;
        b=2V31bPUEkTHrLLsUw3zEB50cLM0o7gx+rdniOVVym9SAqw6r96FF0PCoG+N3XG2Sx
         AeZJtQpHitYooqFsLZlvujSuuH2Iy4OQ5981md98wLz2TlUp4DcDImNVjnqJMB8sv1
         HZECUXitj8YNZxYNrlHRzzBYJhL3Yyz0aSjkzjsM=
Date:   Thu, 12 Mar 2020 23:13:59 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.14.173
Message-ID: <20200312221359.GA616648@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="+QahgC5+KEYLbs62"
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--+QahgC5+KEYLbs62
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 4.14.173 kernel.

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

 Makefile                                          |    2=20
 arch/arm/boot/dts/dra76x.dtsi                     |    5 +
 arch/arm/boot/dts/ls1021a.dtsi                    |    4=20
 arch/arm/mach-imx/Makefile                        |    2=20
 arch/arm/mach-imx/common.h                        |    4=20
 arch/arm/mach-imx/resume-imx6.S                   |   24 +++++
 arch/arm/mach-imx/suspend-imx6.S                  |   14 --
 arch/mips/kernel/vpe.c                            |    2=20
 arch/powerpc/kernel/cputable.c                    |    4=20
 arch/x86/boot/compressed/pagetable.c              |    3=20
 arch/x86/kernel/cpu/common.c                      |    2=20
 arch/x86/kernel/cpu/mcheck/mce-inject.c           |   14 +-
 arch/x86/kernel/cpu/mcheck/mce.c                  |   22 +---
 arch/x86/kvm/svm.c                                |   43 +++++++++
 arch/x86/kvm/vmx.c                                |   15 +++
 arch/x86/xen/enlighten_pv.c                       |    7 -
 drivers/acpi/acpi_watchdog.c                      |    3=20
 drivers/char/ipmi/ipmi_ssif.c                     |   10 +-
 drivers/char/random.c                             |    5 -
 drivers/devfreq/devfreq.c                         |    4=20
 drivers/dma/coh901318.c                           |    4=20
 drivers/dma/tegra20-apb-dma.c                     |    6 -
 drivers/edac/amd64_edac.c                         |    1=20
 drivers/gpu/drm/i915/gvt/vgpu.c                   |    2=20
 drivers/gpu/drm/msm/dsi/dsi_manager.c             |    7 +
 drivers/gpu/drm/msm/dsi/phy/dsi_phy.c             |    4=20
 drivers/gpu/drm/msm/mdp/mdp5/mdp5_crtc.c          |    4=20
 drivers/gpu/drm/msm/msm_drv.c                     |    8 +
 drivers/hid/hid-core.c                            |    4=20
 drivers/hid/hid-ite.c                             |    5 -
 drivers/hid/usbhid/hiddev.c                       |    2=20
 drivers/hwmon/adt7462.c                           |    2=20
 drivers/i2c/busses/i2c-altera.c                   |    2=20
 drivers/i2c/busses/i2c-jz4780.c                   |   36 -------
 drivers/infiniband/core/cm.c                      |    1=20
 drivers/infiniband/core/iwcm.c                    |    4=20
 drivers/infiniband/core/security.c                |   14 +-
 drivers/infiniband/hw/hfi1/verbs.c                |    4=20
 drivers/infiniband/hw/qib/qib_verbs.c             |    2=20
 drivers/md/dm-cache-target.c                      |    4=20
 drivers/md/dm-integrity.c                         |   15 ++-
 drivers/net/dsa/bcm_sf2.c                         |    3=20
 drivers/net/ethernet/amazon/ena/ena_com.c         |   48 ++++++++--
 drivers/net/ethernet/amazon/ena/ena_com.h         |    9 +
 drivers/net/ethernet/amazon/ena/ena_ethtool.c     |   46 +++++++++
 drivers/net/ethernet/amazon/ena/ena_netdev.c      |    6 -
 drivers/net/ethernet/amazon/ena/ena_netdev.h      |    2=20
 drivers/net/ethernet/apm/xgene/xgene_enet_main.c  |    2=20
 drivers/net/ethernet/aquantia/atlantic/aq_nic.c   |    4=20
 drivers/net/ethernet/cavium/thunder/thunder_bgx.c |   62 ++++++++++++-
 drivers/net/ethernet/cavium/thunder/thunder_bgx.h |    9 +
 drivers/net/ethernet/micrel/ks8851_mll.c          |   53 +----------
 drivers/net/ethernet/qlogic/qede/qede.h           |    2=20
 drivers/net/ethernet/qlogic/qede/qede_rdma.c      |   29 +++++-
 drivers/net/phy/mdio-bcm-iproc.c                  |   20 ++++
 drivers/net/tun.c                                 |   19 +++-
 drivers/net/usb/qmi_wwan.c                        |   43 +++------
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c   |   15 ++-
 drivers/net/wireless/marvell/mwifiex/tdls.c       |   75 +++++-----------
 drivers/nfc/pn544/i2c.c                           |    1=20
 drivers/nvme/host/core.c                          |    2=20
 drivers/s390/cio/blacklist.c                      |    5 -
 drivers/tty/serial/8250/8250_exar.c               |   33 +++++++
 drivers/tty/serial/ar933x_uart.c                  |    8 +
 drivers/tty/serial/mvebu-uart.c                   |    2=20
 drivers/tty/sysrq.c                               |    8 -
 drivers/tty/vt/selection.c                        |   26 ++++-
 drivers/tty/vt/vt.c                               |    2=20
 drivers/usb/core/hub.c                            |    8 +
 drivers/usb/core/port.c                           |   10 +-
 drivers/usb/core/quirks.c                         |    3=20
 drivers/usb/gadget/composite.c                    |   24 +++--
 drivers/usb/gadget/function/f_fs.c                |    5 -
 drivers/usb/gadget/function/u_serial.c            |    4=20
 drivers/usb/host/xhci-ring.c                      |    6 +
 drivers/usb/storage/unusual_devs.h                |    6 +
 drivers/vhost/net.c                               |   13 --
 drivers/video/console/vgacon.c                    |    3=20
 drivers/watchdog/da9062_wdt.c                     |    7 -
 drivers/watchdog/wdat_wdt.c                       |    2=20
 fs/cifs/cifsacl.c                                 |    4=20
 fs/cifs/connect.c                                 |    2=20
 fs/cifs/inode.c                                   |    8 +
 fs/dax.c                                          |    3=20
 fs/ecryptfs/keystore.c                            |    4=20
 fs/ext4/balloc.c                                  |   14 ++
 fs/ext4/ext4.h                                    |   30 +++++-
 fs/ext4/ialloc.c                                  |   23 ++--
 fs/ext4/mballoc.c                                 |   61 ++++++++-----
 fs/ext4/resize.c                                  |   62 ++++++++++---
 fs/ext4/super.c                                   |  103 +++++++++++++++--=
-----
 fs/fat/inode.c                                    |   19 +---
 fs/namei.c                                        |    2=20
 include/acpi/actypes.h                            |    3=20
 include/linux/bitops.h                            |    3=20
 include/linux/hid.h                               |    2=20
 include/net/flow_dissector.h                      |    9 +
 include/uapi/linux/usb/charger.h                  |   16 +--
 kernel/audit.c                                    |   40 ++++----
 kernel/auditfilter.c                              |   71 ++++++++-------
 kernel/kprobes.c                                  |   71 +++++++++------
 kernel/trace/trace.c                              |    2=20
 mm/huge_memory.c                                  |   26 +----
 mm/mprotect.c                                     |   38 +++++++-
 net/core/fib_rules.c                              |    2=20
 net/ipv6/ip6_fib.c                                |    7 -
 net/ipv6/route.c                                  |    1=20
 net/mac80211/util.c                               |   18 ++-
 net/netfilter/nf_conntrack_core.c                 |   30 ++++--
 net/netlink/af_netlink.c                          |    5 -
 net/sched/cls_flower.c                            |    1=20
 net/sctp/sm_statefuns.c                           |   29 ++++--
 net/wireless/ethtool.c                            |    8 +
 net/wireless/nl80211.c                            |    1=20
 sound/soc/codecs/pcm512x.c                        |    8 +
 sound/soc/intel/skylake/skl-debug.c               |   32 +++---
 sound/soc/soc-dapm.c                              |    2=20
 sound/soc/soc-pcm.c                               |   16 +--
 sound/soc/soc-topology.c                          |   17 ++-
 tools/perf/ui/browsers/hists.c                    |    1=20
 tools/testing/selftests/lib.mk                    |   23 ++--
 virt/kvm/kvm_main.c                               |   12 +-
 122 files changed, 1162 insertions(+), 612 deletions(-)

Ahmad Fatoum (1):
      ARM: imx: build v7_cpu_resume() unconditionally

Aleksa Sarai (1):
      namei: only return -ECHILD from follow_dotdot_rcu()

Arnaldo Carvalho de Melo (1):
      perf hists browser: Restore ESC as "Zoom out" of DSO/thread/etc

Arthur Kiyanovski (8):
      net: ena: fix potential crash when rxfh key is NULL
      net: ena: fix uses of round_jiffies()
      net: ena: add missing ethtool TX timestamping indication
      net: ena: fix incorrect default RSS key
      net: ena: rss: store hash function as values and not bits
      net: ena: fix incorrectly saving queue numbers when setting RSS indir=
ection table
      net: ena: ena-com.c: prevent NULL pointer dereference
      net: ena: make ena rxfh support ETH_RSS_HASH_NO_CHANGE

Arun Parameswaran (1):
      net: phy: restore mdio regs in the iproc mdio driver

Benjamin Poirier (2):
      ipv6: Fix nlmsg_flags when splitting a multipath route
      ipv6: Fix route replacement with dev-only route

Bernard Metzler (1):
      RDMA/iwcm: Fix iwcm work deallocation

Bj=F8rn Mork (2):
      qmi_wwan: re-add DW5821e pre-production variant
      qmi_wwan: unconditionally reject 2 ep interfaces

Brian Masney (1):
      drm/msm/mdp5: rate limit pp done timeout warnings

Brian Norris (1):
      mwifiex: drop most magic numbers from mwifiex_process_tdls_action_fra=
me()

Charles Keepax (1):
      ASoC: dapm: Correct DAPM handling of active widgets during shutdown

Chris Wilson (1):
      include/linux/bitops.h: introduce BITS_PER_TYPE

Christophe JAILLET (2):
      MIPS: VPE: Fix a double free and a memory leak in 'release_vpe()'
      drivers: net: xgene: Fix the order of the arguments of 'alloc_etherde=
v_mqs()'

Corey Minyard (1):
      ipmi:ssif: Handle a possible NULL pointer reference

Dan Carpenter (3):
      ext4: potential crash on allocation error in ext4_alloc_flex_bg_array=
()
      hwmon: (adt7462) Fix an error return in ADT7462_REG_VOLT()
      dmaengine: coh901318: Fix a double lock bug in dma_tc_handle()

Dan Lazewatsky (1):
      usb: quirks: add NO_LPM quirk for Logitech Screen Share

Daniel Golle (1):
      serial: ar933x_uart: set UART_CS_{RX,TX}_READY_ORIDE

David Rientjes (1):
      mm, thp: fix defrag setting if newline is not used

Dennis Dalessandro (1):
      IB/hfi1, qib: Ensure RCU is locked when accessing list

Desnes A. Nunes do Rosario (1):
      powerpc: fix hardware PMU exception bug on PowerVM compatibility mode=
 systems

Dmitry Osipenko (3):
      nfc: pn544: Fix occasional HW initialization failure
      dmaengine: tegra-apb: Fix use-after-free
      dmaengine: tegra-apb: Prevent race conditions of tasklet vs free list

Dragos Tarcatu (2):
      ASoC: topology: Fix memleak in soc_tplg_link_elems_load()
      ASoC: topology: Fix memleak in soc_tplg_manifest_load()

Eugenio P=E9rez (1):
      vhost: Check docket sk_family instead of call getname

Eugeniu Rosca (3):
      usb: core: hub: fix unhandled return by employing a void function
      usb: core: hub: do error out if usb_autopm_get_interface() fails
      usb: core: port: do error out if usb_autopm_get_interface() fails

Faiz Abbas (1):
      arm: dts: dra76x: Fix mmc3 max-frequency

Florian Fainelli (1):
      net: dsa: bcm_sf2: Forcibly configure IMP port for 1Gb/sec

Frank Sorenson (1):
      cifs: Fix mode output in debugging statements

Greg Kroah-Hartman (2):
      Revert "char/random: silence a lockdep splat with printk()"
      Linux 4.14.173

Gustavo A. R. Silva (1):
      i2c: altera: Fix potential integer overflow

H.J. Lu (1):
      x86/boot/compressed: Don't declare __force_order in kaslr_64.c

Hans de Goede (1):
      HID: ite: Only bind to keyboard USB interface on Acer SW5-012 keyboar=
d dock

Harigovindan P (1):
      drm/msm/dsi: save pll state before dsi host is powered off

Jack Pham (1):
      usb: gadget: composite: Support more than 500mA MaxPower

Jason Baron (1):
      net: sched: correct flower port blocking

Jason Gunthorpe (1):
      RMDA/cm: Fix missing ib_cm_destroy_id() in ib_cm_insert_listen()

Jason Wang (1):
      tuntap: correctly set SOCKWQ_ASYNC_NOSPACE

Jay Dolan (1):
      serial: 8250_exar: add support for ACCES cards

Jeff Moyer (1):
      dax: pass NOWAIT flag to iomap_apply

Jethro Beekman (1):
      net: fib_rules: Correctly set table field when table number exceeds 8=
 bits

Jim Lin (1):
      usb: storage: Add quirk for Samsung Fit flash

Jiri Benc (1):
      selftests: fix too long argument

Jiri Slaby (3):
      vt: selection, close sel_buffer race
      vt: selection, push console lock down
      vt: selection, push sel_lock up

Johan Korsnes (2):
      HID: core: fix off-by-one memset in hid_report_raw_event()
      HID: core: increase HID report buffer size to 8KiB

Johannes Berg (2):
      iwlwifi: pcie: fix rb_allocator workqueue allocation
      mac80211: consider more elements in parsing CRC

John Stultz (1):
      drm: msm: Fix return type of dsi_mgr_connector_mode_valid for kCFI

Kees Cook (1):
      x86/xen: Distribute switch variables for initialization

Keith Busch (1):
      nvme: Fix uninitialized-variable warning

Lars-Peter Clausen (1):
      usb: gadget: ffs: ffs_aio_cancel(): Save/restore IRQ flags

Maor Gottlieb (1):
      RDMA/core: Fix pkey and port assignment in get_new_pps

Marco Felsch (1):
      watchdog: da9062: do not ping the hw during stop()

Marek Vasut (3):
      net: ks8851-ml: Remove 8-bit bus accessors
      net: ks8851-ml: Fix 16-bit data access
      net: ks8851-ml: Fix 16-bit IO operation

Martynas Pumputis (1):
      netfilter: nf_conntrack: resolve clash for matching conntracks

Masami Hiramatsu (2):
      kprobes: Set unoptimized flag after unoptimizing code
      kprobes: Fix optimize_kprobe()/unoptimize_kprobe() cancellation logic

Mathias Nyman (1):
      xhci: handle port status events for removed USB3 hcd

Matthias Reichl (1):
      ASoC: pcm512x: Fix unbalanced regulator enable call in probe error pa=
th

Mel Gorman (1):
      mm, numa: fix bad pmd by atomically check for pmd_trans_huge when mar=
king page tables prot_numa

Michal Kalderon (1):
      qede: Fix race between rdma destroy workqueue and link change event

Mika Westerberg (2):
      ACPICA: Introduce ACPI_ACCESS_BYTE_WIDTH() macro
      ACPI: watchdog: Fix gas->access_width usage

Mikulas Patocka (2):
      dm cache: fix a crash due to incorrect work item cancelling
      dm integrity: fix a deadlock due to offloading to an incorrect workqu=
eue

Nathan Chancellor (2):
      ecryptfs: Fix up bad backport of fe2e082f5da5b4a0a92ae32978f81507ef37=
ec66
      RDMA/core: Fix use of logical OR in get_new_pps

Nikolay Aleksandrov (1):
      net: netlink: cap max groups which will be considered in netlink_bind=
()

OGAWA Hirofumi (1):
      fat: fix uninit-memory access for partial initialized inode

Oliver Upton (1):
      KVM: VMX: check descriptor table exits on instruction emulation

Orson Zhai (1):
      Revert "PM / devfreq: Modify the device name as devfreq(X) for sysfs"

Paul Moore (2):
      audit: fix error handling in audit_data_to_entry()
      audit: always check the netlink payload length in audit_receive_msg()

Pavel Belous (1):
      net: atlantic: fix potential error handling

Peter Chen (1):
      usb: charger: assign specific number for enum value

Petr Mladek (2):
      sysrq: Restore original console_loglevel when sysrq disabled
      sysrq: Remove duplicated sysrq message

Ronnie Sahlberg (1):
      cifs: don't leak -EAGAIN for stat() during reconnect

Sameeh Jubran (2):
      net: ena: rss: fix failure to get indirection table
      net: ena: ethtool: use correct value for crc32 hash

Sean Christopherson (2):
      KVM: Check for a bad hva before dropping into the ghc slow path
      x86/pkeys: Manually set X86_FEATURE_OSPKE to preserve existing changes

Sean Paul (1):
      drm/msm: Set dma maximum segment size for mdss

Sergey Matyukevich (2):
      cfg80211: check wiphy driver existence for drvinfo report
      cfg80211: add missing policy for NL80211_ATTR_STATUS_CODE

Sergey Organov (1):
      usb: gadget: serial: fix Tx stall after buffer overflow

Steven Rostedt (VMware) (1):
      tracing: Disable trace_printk() on post poned tests

Suraj Jitindar Singh (2):
      ext4: fix potential race between s_flex_groups online resizing and ac=
cess
      ext4: fix potential race between s_group_info online resizing and acc=
ess

Takashi Iwai (3):
      ASoC: intel: skl: Fix pin debug prints
      ASoC: intel: skl: Fix possible buffer overflow in debug outputs
      ASoC: pcm: Fix possible buffer overflow in dpcm state sysfs output

Theodore Ts'o (1):
      ext4: fix potential race between online resizing and write operations

Tim Harvey (1):
      net: thunderx: workaround BGX TX Underflow issue

Tina Zhang (1):
      drm/i915/gvt: Separate display reset from ALL_ENGINES reset

Tom Lendacky (1):
      KVM: SVM: Override default MMIO mask if memory encryption is enabled

Vasily Averin (1):
      s390/cio: cio_ignore_proc_seq_next should increase position index

Vladimir Oltean (1):
      ARM: dts: ls1021a: Restore MDIO compatible to gianfar

Wei Yang (1):
      mm/huge_memory.c: use head to check huge zero page

Wolfram Sang (1):
      i2c: jz4780: silence log flood on txabrt

Xin Long (1):
      sctp: move the format error check out of __sctp_sf_do_9_1_abort

Yazen Ghannam (2):
      x86/mce: Handle varying MCA bank counts
      EDAC/amd64: Set grain per DIMM

Zhang Xiaoxu (1):
      vgacon: Fix a UAF in vgacon_invert_region

dan.carpenter@oracle.com (1):
      HID: hiddev: Fix race in in hiddev_disconnect()

tangbin (1):
      tty:serial:mvebu-uart:fix a wrong return


--+QahgC5+KEYLbs62
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl5qtCcACgkQONu9yGCS
aT5LrBAArpYIA2XzcrzSzkIXJUsdv7HKz+UTIGLHn/lK+QLq5mhYIZqeCt/O2+Zq
fXmXWXANSza8WtfPA/AU0i0Brqw9QX6f8ixNtKFpTCPci+5+QoSx6eTY+MuEQult
A7dcDKUgBFCkOYrXMTVqJ7OXviaCAuh6PLrmBFfSKFZsUodgTlJKIY2gO0EvNCav
mlF1qIpSC1DSDw6aO1xveNL5m61eKHLzJrLhoO8yugE+YoY4Ccz312fa6gQb1OOT
f8C8q2vqJYMTcPkvs3GRa2DoBrp6AIx5z9A6kOQCgbhI54FQ2GTnXl7IFwkT3jPk
W5/1Oza61MfW8EQsGwCSWIlOliH3qxip2FwGTF5FMIQoDtaw2vp8ch8tDaBme3rW
Fw79mWiZaZE5X/5LMiUSmM4iPQXjqPhG4+nKp+A9nikW2IB+NHhYYVVYCnk/eWpj
FMlGRZ751FzX9Lr2rTPP3PNHvrjyU7E4w0+7ItaHhw8eJ7l+ZKIJdvMRthE33Ijl
Hh1FJ736LnLarlsKKwudHjig6xV2mVMuSj+S5DZbg5oVgiVDofKKCDuJdciWT5ow
H+7JXh0hXYv8wEWnucYsQFN0xQfBd0cE5icx3xFDivP6UXukl8dwd+NRZTCYwtYk
2iF8emQEGdfoLyP6Dxnq7jKQrovWSIrWc66TU0HcRvtvmPa8ni0=
=3NeN
-----END PGP SIGNATURE-----

--+QahgC5+KEYLbs62--
