Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC87817AE27
	for <lists+stable@lfdr.de>; Thu,  5 Mar 2020 19:35:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726036AbgCESfy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Mar 2020 13:35:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:43334 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725946AbgCESfx (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 5 Mar 2020 13:35:53 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D4F2520705;
        Thu,  5 Mar 2020 18:35:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583433352;
        bh=dTSDkGqNKUpr9kSANw6j5pY030TF9Sx/GOPsi6S1d5A=;
        h=Date:From:To:Cc:Subject:From;
        b=cnZwwC26TaNGlp5PWuKYZJxzl3WSdjsFmCE0V6bHn0GcmZ4pBVZPPIEjCtUtkzze6
         7k9Iw4ZRvkLxJpI+GwpB/6wxIr4CZqd6rjd0q9p5zFVzHx8uF2UMb1gMycj/3hu2pz
         bn6aPetF5Xo/1H2BJXL74w/TjR5u9zK8z5+2jN1o=
Date:   Thu, 5 Mar 2020 19:35:49 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.19.108
Message-ID: <20200305183549.GA2122081@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="gKMricLos+KVdGMg"
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--gKMricLos+KVdGMg
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 4.19.108 kernel.

All users of the 4.19 kernel series must upgrade.

The updated 4.19.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-4.19.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Ds=
ummary

thanks,

greg k-h

------------

 Documentation/networking/nf_flowtable.txt                  |    2=20
 Makefile                                                   |    2=20
 arch/arm/boot/dts/stihxxx-b2120.dtsi                       |    2=20
 arch/mips/kernel/vpe.c                                     |    2=20
 arch/x86/kvm/svm.c                                         |   43 +++++++
 arch/x86/kvm/vmx.c                                         |   15 ++
 arch/x86/kvm/x86.c                                         |    6 -
 drivers/acpi/acpi_watchdog.c                               |    3=20
 drivers/char/ipmi/ipmi_ssif.c                              |   10 +
 drivers/devfreq/devfreq.c                                  |    4=20
 drivers/gpu/drm/amd/amdgpu/amdgpu_gmc.h                    |    1=20
 drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c                      |   37 ++++++
 drivers/gpu/drm/amd/include/asic_reg/dce/dce_12_0_offset.h |    2=20
 drivers/gpu/drm/i915/gvt/dmabuf.c                          |    2=20
 drivers/gpu/drm/i915/gvt/vgpu.c                            |    2=20
 drivers/gpu/drm/msm/msm_drv.c                              |    8 +
 drivers/hid/hid-alps.c                                     |    2=20
 drivers/hid/hid-core.c                                     |    4=20
 drivers/hid/hid-ite.c                                      |    5=20
 drivers/hid/usbhid/hiddev.c                                |    2=20
 drivers/i2c/busses/i2c-altera.c                            |    2=20
 drivers/i2c/busses/i2c-jz4780.c                            |   36 ------
 drivers/irqchip/irq-gic-v3-its.c                           |    2=20
 drivers/macintosh/therm_windtunnel.c                       |   52 +++++----
 drivers/net/ethernet/amazon/ena/ena_com.c                  |   48 ++++++--
 drivers/net/ethernet/amazon/ena/ena_com.h                  |    9 +
 drivers/net/ethernet/amazon/ena/ena_ethtool.c              |   46 +++++++
 drivers/net/ethernet/amazon/ena/ena_netdev.c               |    6 -
 drivers/net/ethernet/amazon/ena/ena_netdev.h               |    2=20
 drivers/net/ethernet/apm/xgene/xgene_enet_main.c           |    2=20
 drivers/net/ethernet/aquantia/atlantic/aq_nic.c            |    8 -
 drivers/net/ethernet/aquantia/atlantic/aq_ring.c           |    7 -
 drivers/net/ethernet/mscc/ocelot_board.c                   |    8 +
 drivers/net/ethernet/qlogic/qede/qede.h                    |    2=20
 drivers/net/ethernet/qlogic/qede/qede_rdma.c               |   29 ++++-
 drivers/net/hyperv/netvsc.c                                |    2=20
 drivers/net/hyperv/netvsc_drv.c                            |    3=20
 drivers/net/phy/mdio-bcm-iproc.c                           |   20 +++
 drivers/net/usb/qmi_wwan.c                                 |   43 ++-----
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c            |   15 +-
 drivers/net/wireless/marvell/mwifiex/main.h                |   13 --
 drivers/net/wireless/marvell/mwifiex/tdls.c                |   75 ++++----=
-----
 drivers/nfc/pn544/i2c.c                                    |    1=20
 drivers/pwm/pwm-omap-dmtimer.c                             |   21 ++-
 drivers/s390/crypto/ap_bus.h                               |    4=20
 drivers/s390/crypto/ap_card.c                              |    8 -
 drivers/s390/crypto/ap_queue.c                             |    6 -
 drivers/s390/crypto/zcrypt_api.c                           |   16 +-
 drivers/s390/net/qeth_l2_main.c                            |   29 ++---
 drivers/soc/tegra/fuse/fuse-tegra30.c                      |    3=20
 drivers/thermal/broadcom/brcmstb_thermal.c                 |   31 +----
 drivers/tty/sysrq.c                                        |    8 -
 drivers/vhost/net.c                                        |   10 -
 drivers/watchdog/wdat_wdt.c                                |    2=20
 fs/cifs/cifsacl.c                                          |    4=20
 fs/cifs/connect.c                                          |    2=20
 fs/cifs/inode.c                                            |    2=20
 fs/dax.c                                                   |    3=20
 fs/ext4/super.c                                            |    6 -
 fs/namei.c                                                 |    2=20
 include/acpi/actypes.h                                     |    3=20
 include/linux/hid.h                                        |    2=20
 include/net/flow_dissector.h                               |    9 +
 include/uapi/linux/usb/charger.h                           |   16 +-
 kernel/audit.c                                             |   40 +++---
 kernel/auditfilter.c                                       |   71 ++++++--=
----
 kernel/kprobes.c                                           |    4=20
 kernel/sched/fair.c                                        |   69 ++++++++=
+--
 kernel/trace/trace.c                                       |    2=20
 mm/huge_memory.c                                           |   26 +---
 net/core/fib_rules.c                                       |    2=20
 net/ipv6/ip6_fib.c                                         |    7 -
 net/ipv6/route.c                                           |    1=20
 net/mac80211/util.c                                        |   18 ++-
 net/netfilter/nft_tunnel.c                                 |    4=20
 net/netlink/af_netlink.c                                   |    5=20
 net/sched/cls_flower.c                                     |    1=20
 net/sctp/sm_statefuns.c                                    |   29 +++--
 net/smc/smc_clc.c                                          |    4=20
 net/tls/tls_device.c                                       |   21 +++
 net/wireless/ethtool.c                                     |    8 +
 net/wireless/nl80211.c                                     |    1=20
 tools/perf/ui/browsers/hists.c                             |    1=20
 tools/perf/util/stat-shadow.c                              |    6 -
 tools/testing/selftests/net/fib_tests.sh                   |    6 +
 virt/kvm/kvm_main.c                                        |   12 +-
 86 files changed, 699 insertions(+), 411 deletions(-)

Aleksa Sarai (1):
      namei: only return -ECHILD from follow_dotdot_rcu()

Alexandra Winter (1):
      s390/qeth: vnicc Fix EOPNOTSUPP precedence

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
      ipv6: Fix route replacement with dev-only route
      ipv6: Fix nlmsg_flags when splitting a multipath route

Bj=F8rn Mork (2):
      qmi_wwan: re-add DW5821e pre-production variant
      qmi_wwan: unconditionally reject 2 ep interfaces

Brian Norris (2):
      mwifiex: drop most magic numbers from mwifiex_process_tdls_action_fra=
me()
      mwifiex: delete unused mwifiex_get_intf_num()

Christophe JAILLET (3):
      HID: alps: Fix an error handling path in 'alps_input_configured()'
      MIPS: VPE: Fix a double free and a memory leak in 'release_vpe()'
      drivers: net: xgene: Fix the order of the arguments of 'alloc_etherde=
v_mqs()'

Corey Minyard (1):
      ipmi:ssif: Handle a possible NULL pointer reference

Dan Carpenter (1):
      ext4: potential crash on allocation error in ext4_alloc_flex_bg_array=
()

David Rientjes (1):
      mm, thp: fix defrag setting if newline is not used

Dmitry Osipenko (1):
      nfc: pn544: Fix occasional HW initialization failure

Eugenio P=E9rez (1):
      vhost: Check docket sk_family instead of call getname

Florian Fainelli (1):
      thermal: brcmstb_thermal: Do not use DT coefficients

Frank Sorenson (1):
      cifs: Fix mode output in debugging statements

Greg Kroah-Hartman (1):
      Linux 4.19.108

Gustavo A. R. Silva (1):
      i2c: altera: Fix potential integer overflow

Haiyang Zhang (1):
      hv_netvsc: Fix unwanted wakeup in netvsc_attach()

Hans de Goede (1):
      HID: ite: Only bind to keyboard USB interface on Acer SW5-012 keyboar=
d dock

Harald Freudenberger (1):
      s390/zcrypt: fix card and queue total counter wrap

Horatiu Vultur (1):
      net: mscc: fix in frame extraction

Jason Baron (1):
      net: sched: correct flower port blocking

Jeff Moyer (1):
      dax: pass NOWAIT flag to iomap_apply

Jethro Beekman (1):
      net: fib_rules: Correctly set table field when table number exceeds 8=
 bits

Joe Perches (1):
      irqchip/gic-v3-its: Fix misuse of GENMASK macro

Johan Korsnes (2):
      HID: core: fix off-by-one memset in hid_report_raw_event()
      HID: core: increase HID report buffer size to 8KiB

Johannes Berg (2):
      iwlwifi: pcie: fix rb_allocator workqueue allocation
      mac80211: consider more elements in parsing CRC

Kuninori Morimoto (1):
      ARM: dts: sti: fixup sound frame-inversion for stihxxx-b2120.dtsi

Masami Hiramatsu (1):
      kprobes: Set unoptimized flag after unoptimizing code

Matteo Croce (1):
      netfilter: nf_flowtable: fix documentation

Michal Kalderon (1):
      qede: Fix race between rdma destroy workqueue and link change event

Mika Westerberg (2):
      ACPICA: Introduce ACPI_ACCESS_BYTE_WIDTH() macro
      ACPI: watchdog: Fix gas->access_width usage

Nikolay Aleksandrov (1):
      net: netlink: cap max groups which will be considered in netlink_bind=
()

Oliver Upton (1):
      KVM: VMX: check descriptor table exits on instruction emulation

Orson Zhai (1):
      Revert "PM / devfreq: Modify the device name as devfreq(X) for sysfs"

Paul Moore (2):
      audit: fix error handling in audit_data_to_entry()
      audit: always check the netlink payload length in audit_receive_msg()

Pavel Belous (2):
      net: atlantic: fix use after free kasan warn
      net: atlantic: fix potential error handling

Peter Chen (1):
      usb: charger: assign specific number for enum value

Petr Mladek (2):
      sysrq: Restore original console_loglevel when sysrq disabled
      sysrq: Remove duplicated sysrq message

Ravi Bangoria (2):
      perf stat: Use perf_evsel__is_clocki() for clock events
      perf stat: Fix shadow stats for clock events

Rohit Maheshwari (1):
      net/tls: Fix to avoid gettig invalid tls record

Sameeh Jubran (2):
      net: ena: rss: fix failure to get indirection table
      net: ena: ethtool: use correct value for crc32 hash

Sean Christopherson (3):
      KVM: Check for a bad hva before dropping into the ghc slow path
      KVM: x86: Remove spurious kvm_mmu_unload() from vcpu destruction path
      KVM: x86: Remove spurious clearing of async #PF MSR

Sean Paul (1):
      drm/msm: Set dma maximum segment size for mdss

Sergey Matyukevich (2):
      cfg80211: check wiphy driver existence for drvinfo report
      cfg80211: add missing policy for NL80211_ATTR_STATUS_CODE

Shirish S (1):
      amdgpu/gmc_v9: save/restore sdpif regs during S3

Steven Rostedt (VMware) (1):
      tracing: Disable trace_printk() on post poned tests

Thierry Reding (1):
      soc/tegra: fuse: Fix build with Tegra194 configuration

Tina Zhang (2):
      drm/i915/gvt: Fix orphan vgpu dmabuf_objs' lifetime
      drm/i915/gvt: Separate display reset from ALL_ENGINES reset

Tom Lendacky (1):
      KVM: SVM: Override default MMIO mask if memory encryption is enabled

Ursula Braun (1):
      net/smc: no peer ID in CLC decline for SMCD

Uwe Kleine-K=F6nig (1):
      pwm: omap-dmtimer: put_device() after of_find_device_by_node()

Vincent Guittot (2):
      sched/fair: Optimize update_blocked_averages()
      sched/fair: Fix O(nr_cgroups) in the load balancing path

Wei Yang (1):
      mm/huge_memory.c: use head to check huge zero page

Wolfram Sang (2):
      macintosh: therm_windtunnel: fix regression when instantiating devices
      i2c: jz4780: silence log flood on txabrt

Xin Long (2):
      sctp: move the format error check out of __sctp_sf_do_9_1_abort
      netfilter: nft_tunnel: no need to call htons() when dumping ports

dan.carpenter@oracle.com (1):
      HID: hiddev: Fix race in in hiddev_disconnect()


--gKMricLos+KVdGMg
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl5hRoIACgkQONu9yGCS
aT4o2g//ZInOYuxu3QsATyB4YNPEWIfumowWhk29B8rRVmydoqpPO3bi1wHFi8z3
UlhcROC9wAsT+tKjbC3gZWmIkykH0ehrGLzAW7M5ywvN87oFC02p1g96mU+srTZz
CE54APOqJ4I8oKPEZy9kqwrBQzVTWRK9P57Ire46R8JNISdOGuYnyU8rblTHNreI
Y2zW+1Bxqo5LwFy6WyHZUfTLJ9dvicsSH2wnxb9vXnT8o3fIWjLwQJv8vSxE2nOo
fi8ypgk+nmf/NZ95NeDFCWSuEaj2yJkCgpxwk02Po4KsaIe6zUkgruTHOd8qh5Zc
1vHz8Y2SqXDm5bWru0t1Nz/Q71bIILQZMkjhPq3qBXPMVYTSapDyMn10+lTqTKQH
Ji8TO5D/2KYWU3aThQhFFLkfycWOJ9X7QNd7SfHM7OZKFl34d9bJK+GtgJXGJYYr
N/5S0puCb4PIOk7lLhULNAh+hf+tJKkPEBeIMs1DwqzWvD/2dofaRHje5/SO/poJ
oFhm7XjrA4OGgMpwDtdIcYfthQ8Vu+lf+wwwpEAMgeu7jhNgqRB6slgL8+JQU0Qg
Demf/SH12wsajXfohQDlxhFmjo7MgJxQthznKhF5fh6yRRKxmYHK749VjoHboDTM
LQ0yrzV56rCJPtM7oiYVsdC7S34c221o3xuL51lt3rM7roT+8xw=
=cFfS
-----END PGP SIGNATURE-----

--gKMricLos+KVdGMg--
