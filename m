Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93ECE14D799
	for <lists+stable@lfdr.de>; Thu, 30 Jan 2020 09:31:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726882AbgA3Ibb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jan 2020 03:31:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:56756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726871AbgA3Iba (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Jan 2020 03:31:30 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2B40E2082E;
        Thu, 30 Jan 2020 08:31:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580373089;
        bh=CKbSOFNDqh92ZG8JAItiMKLIwRnLv7Awk5jfs5jLMAs=;
        h=Date:From:To:Cc:Subject:From;
        b=IK0/ldbh3qyCtLG4axYaCeZpQGUsbWUHHplOU3lkWwPFi2uKqYlaaenhDECtqKFda
         WB+7VPtu5nxD002pWZDDbRNSCnyOvc/+NT9A3eFI7xgiWhTT6FSuHzQP2l8V5XGCQ5
         IeuGo6M04ZocK+ZkStu0hF9kxM59h2Ukc4Z9fDms=
Date:   Thu, 30 Jan 2020 09:31:27 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 5.4.16
Message-ID: <20200130083127.GA646331@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="zYM0uCDKw75PZbzx"
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--zYM0uCDKw75PZbzx
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 5.4.16 kernel.

All users of the 5.4 kernel series must upgrade.

The updated 5.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-5.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Ds=
ummary

thanks,

greg k-h

------------

 Makefile                                                   |    2=20
 arch/powerpc/include/asm/book3s/64/mmu-hash.h              |    5=20
 arch/powerpc/include/asm/xive-regs.h                       |    1=20
 arch/powerpc/sysdev/xive/common.c                          |   15=20
 drivers/atm/firestream.c                                   |    3=20
 drivers/gpu/drm/i915/gem/i915_gem_busy.c                   |   12=20
 drivers/gpu/drm/i915/gem/i915_gem_userptr.c                |    9=20
 drivers/gpu/drm/i915/gt/intel_engine_types.h               |    4=20
 drivers/gpu/drm/i915/i915_gem_gtt.c                        |    2=20
 drivers/gpu/drm/panfrost/panfrost_drv.c                    |   91 ++-
 drivers/gpu/drm/panfrost/panfrost_gem.c                    |  124 +++-
 drivers/gpu/drm/panfrost/panfrost_gem.h                    |   41 +
 drivers/gpu/drm/panfrost/panfrost_gem_shrinker.c           |    3=20
 drivers/gpu/drm/panfrost/panfrost_job.c                    |   13=20
 drivers/gpu/drm/panfrost/panfrost_job.h                    |    1=20
 drivers/gpu/drm/panfrost/panfrost_mmu.c                    |   61 +-
 drivers/gpu/drm/panfrost/panfrost_mmu.h                    |    6=20
 drivers/gpu/drm/panfrost/panfrost_perfcnt.c                |   34 -
 drivers/hwmon/adt7475.c                                    |    5=20
 drivers/hwmon/hwmon.c                                      |   68 +-
 drivers/hwmon/nct7802.c                                    |   75 ++
 drivers/infiniband/ulp/isert/ib_isert.c                    |   12=20
 drivers/input/misc/keyspan_remote.c                        |    9=20
 drivers/input/misc/pm8xxx-vibrator.c                       |    2=20
 drivers/input/rmi4/rmi_smbus.c                             |    2=20
 drivers/input/tablet/aiptek.c                              |    6=20
 drivers/input/tablet/gtco.c                                |   10=20
 drivers/input/tablet/pegasus_notetaker.c                   |    2=20
 drivers/input/touchscreen/sun4i-ts.c                       |    6=20
 drivers/input/touchscreen/sur40.c                          |    2=20
 drivers/iommu/amd_iommu_init.c                             |   24=20
 drivers/iommu/intel-iommu.c                                |    3=20
 drivers/leds/leds-gpio.c                                   |   10=20
 drivers/media/v4l2-core/v4l2-ioctl.c                       |   24=20
 drivers/mmc/host/sdhci-tegra.c                             |    2=20
 drivers/mmc/host/sdhci.c                                   |   10=20
 drivers/mmc/host/sdhci_am654.c                             |   27=20
 drivers/net/can/slcan.c                                    |   12=20
 drivers/net/ethernet/broadcom/genet/bcmgenet.c             |    4=20
 drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c            |    2=20
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c |   49 -
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c            |    9=20
 drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c |    2=20
 drivers/net/ethernet/mellanox/mlx5/core/main.c             |    1=20
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c |    3=20
 drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c   |   42 -
 drivers/net/ethernet/mellanox/mlxsw/spectrum_acl.c         |   16=20
 drivers/net/ethernet/mellanox/mlxsw/switchx2.c             |   17=20
 drivers/net/ethernet/natsemi/sonic.c                       |  380 +++++++-=
-----
 drivers/net/ethernet/natsemi/sonic.h                       |   44 +
 drivers/net/gtp.c                                          |   10=20
 drivers/net/slip/slip.c                                    |   12=20
 drivers/net/tun.c                                          |    4=20
 drivers/net/usb/lan78xx.c                                  |   15=20
 drivers/net/wireless/cisco/airo.c                          |   20=20
 drivers/net/wireless/intel/iwlwifi/mvm/constants.h         |    1=20
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c          |   28=20
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h               |    4=20
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c              |   19=20
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c              |    2=20
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c                |    6=20
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c               |    4=20
 drivers/net/wireless/marvell/libertas/cfg.c                |   16=20
 drivers/pci/quirks.c                                       |   19=20
 drivers/pinctrl/intel/pinctrl-sunrisepoint.c               |    1=20
 drivers/target/iscsi/iscsi_target.c                        |    6=20
 fs/afs/cell.c                                              |   11=20
 fs/ceph/mds_client.c                                       |    8=20
 fs/io_uring.c                                              |    6=20
 fs/namei.c                                                 |   17=20
 fs/readdir.c                                               |   79 +-
 include/linux/netdevice.h                                  |    2=20
 include/linux/netfilter/ipset/ip_set.h                     |    7=20
 include/linux/netfilter/nfnetlink.h                        |    2=20
 include/net/netns/nftables.h                               |    1=20
 include/trace/events/xen.h                                 |    6=20
 kernel/power/snapshot.c                                    |   20=20
 kernel/trace/trace.c                                       |    5=20
 kernel/trace/trace_events_hist.c                           |   63 +-
 kernel/trace/trace_events_trigger.c                        |   20=20
 kernel/trace/trace_kprobe.c                                |    2=20
 kernel/trace/trace_probe.c                                 |    5=20
 kernel/trace/trace_probe.h                                 |    3=20
 kernel/trace/trace_uprobe.c                                |  124 ++--
 lib/strncpy_from_user.c                                    |   14=20
 lib/strnlen_user.c                                         |   14=20
 lib/test_xarray.c                                          |   56 +
 lib/xarray.c                                               |   33 -
 net/core/dev.c                                             |   97 +--
 net/core/rtnetlink.c                                       |   13=20
 net/core/skmsg.c                                           |    2=20
 net/hsr/hsr_main.h                                         |    2=20
 net/ipv4/esp4_offload.c                                    |    2=20
 net/ipv4/fib_trie.c                                        |    6=20
 net/ipv4/fou.c                                             |    4=20
 net/ipv4/ip_tunnel.c                                       |    4=20
 net/ipv4/tcp.c                                             |    1=20
 net/ipv4/tcp_bbr.c                                         |    3=20
 net/ipv4/tcp_input.c                                       |    1=20
 net/ipv4/tcp_output.c                                      |    1=20
 net/ipv4/udp.c                                             |    3=20
 net/ipv6/esp6_offload.c                                    |    2=20
 net/ipv6/ip6_gre.c                                         |    3=20
 net/ipv6/ip6_tunnel.c                                      |    4=20
 net/ipv6/seg6_local.c                                      |    4=20
 net/netfilter/ipset/ip_set_bitmap_gen.h                    |    2=20
 net/netfilter/ipset/ip_set_bitmap_ip.c                     |    6=20
 net/netfilter/ipset/ip_set_bitmap_ipmac.c                  |    6=20
 net/netfilter/ipset/ip_set_bitmap_port.c                   |    6=20
 net/netfilter/nf_tables_api.c                              |  155 +++--
 net/netfilter/nfnetlink.c                                  |    6=20
 net/netfilter/nft_osf.c                                    |    3=20
 net/sched/cls_api.c                                        |    5=20
 net/sched/ematch.c                                         |    2=20
 net/tls/tls_sw.c                                           |    4=20
 net/x25/af_x25.c                                           |    6=20
 scripts/recordmcount.c                                     |   17=20
 117 files changed, 1576 insertions(+), 766 deletions(-)

Al Viro (1):
      do_last(): fetch directory ->i_mode and ->i_uid before it's too late

Alex Deucher (1):
      PCI: Mark AMD Navi14 GPU rev 0xc5 ATS as broken

Alex Sverdlin (1):
      ARM: 8950/1: ftrace/recordmcount: filter relocation types

Alexander Potapenko (1):
      PM: hibernate: fix crashes with init_on_free=3D1

Aneesh Kumar K.V (1):
      powerpc/mm/hash: Fix sharing context ids between kernel & userspace

Bart Van Assche (1):
      scsi: RDMA/isert: Fix a recently introduced regression related to log=
out

Boris Brezillon (1):
      drm/panfrost: Add the panfrost_gem_mapping concept

Boyan Ding (1):
      pinctrl: sunrisepoint: Add missing Interrupt Status register offset

Changbin Du (1):
      tracing: xen: Ordered comparison of function pointers

Christophe Leroy (1):
      lib: Reduce user_access_begin() boundaries in strncpy_from_user() and=
 strnlen_user()

Chuhong Yuan (1):
      Input: sun4i-ts - add a check for devm_thermal_zone_of_sensor_register

Cong Wang (1):
      net_sched: fix datalen for ematch

David Ahern (1):
      ipv4: Detect rollover in specific fib table dump

David Howells (1):
      afs: Fix characters allowed into cell names

Eli Cohen (1):
      net/mlx5: E-Switch, Prevent ingress rate configuration of uplink rep

Emmanuel Grumbach (1):
      iwlwifi: mvm: don't send the IWL_MVM_RXQ_NSSN_SYNC notif to Rx queues

Erez Shitrit (2):
      net/mlx5: DR, Enable counter on non-fwd-dest objects
      net/mlx5: DR, use non preemptible call to get the current cpu number

Eric Dumazet (5):
      gtp: make sure only SOCK_DGRAM UDP sockets are accepted
      net: rtnetlink: validate IFLA_MTU attribute in rtnl_create_link()
      net_sched: use validated TCA_KIND attribute in tc_new_tfilter()
      tcp: do not leave dangling pointers in tp->highest_sack
      tun: add mutex_unlock() call and napi.skb clearing in tun_get_user()

Faiz Abbas (2):
      mmc: sdhci_am654: Remove Inverted Write Protect flag
      mmc: sdhci_am654: Reset Command and Data line after tuning

Finn Thain (12):
      net/sonic: Add mutual exclusion for accessing shared state
      net/sonic: Clear interrupt flags immediately
      net/sonic: Use MMIO accessors
      net/sonic: Fix interface error stats collection
      net/sonic: Fix receive buffer handling
      net/sonic: Avoid needless receive descriptor EOL flag updates
      net/sonic: Improve receive descriptor status flag check
      net/sonic: Fix receive buffer replenishment
      net/sonic: Quiesce SONIC before re-initializing descriptor memory
      net/sonic: Fix command register usage
      net/sonic: Fix CAM initialization
      net/sonic: Prevent tx watchdog timeout

Florian Fainelli (1):
      net: bcmgenet: Use netif_tx_napi_add() for TX NAPI

Florian Westphal (1):
      netfilter: nft_osf: add missing check for DREG attribute

Frederic Barrat (1):
      powerpc/xive: Discard ESB load value when interrupt is invalid

Gilles Buloz (2):
      hwmon: (nct7802) Fix voltage limits to wrong registers
      hwmon: (nct7802) Fix non-working alarm on voltages

Greg Kroah-Hartman (1):
      Linux 5.4.16

Guenter Roeck (1):
      hwmon: (core) Do not use device managed functions for memory allocati=
ons

Hans Verkuil (2):
      Revert "Input: synaptics-rmi4 - don't increment rmiaddr for SMBus tra=
nsfers"
      media: v4l2-ioctl.c: zero reserved fields for S/TRY_FMT

Ido Schimmel (2):
      mlxsw: spectrum_acl: Fix use-after-free during reload
      mlxsw: switchx2: Do not modify cloned SKBs during xmit

Jacek Anaszewski (1):
      leds: gpio: Fix uninitialized gpio label for fwnode based probe

Jakub Kicinski (1):
      net/tls: fix async operation

Jakub Sitnicki (1):
      net, sk_msg: Don't check if sock is locked when tearing down psock

James Hughes (1):
      net: usb: lan78xx: Add .ndo_features_check

Jeff Layton (1):
      ceph: hold extra reference to r_parent over life of request

Jens Axboe (1):
      Revert "io_uring: only allow submit from owning task"

Jerry Snitselaar (1):
      iommu/vt-d: Call __dmar_remove_one_dev_info with valid pointer

Johan Hovold (5):
      Input: keyspan-remote - fix control-message timeouts
      Input: sur40 - fix interface sanity checks
      Input: gtco - fix endpoint sanity check
      Input: aiptek - fix endpoint sanity check
      Input: pegasus_notetaker - fix endpoint sanity check

Johannes Berg (2):
      iwlwifi: mvm: fix SKB leak on invalid queue
      iwlwifi: mvm: fix potential SKB leak on TXQ TX

Jouni Hogander (1):
      net-sysfs: Fix reference count leak

Kadlecsik J=C3=B3zsef (1):
      netfilter: ipset: use bitmap infrastructure completely

Kristian Evensen (1):
      fou: Fix IPv6 netlink policy

Linus Torvalds (2):
      readdir: make user_access_begin() use the real access range
      readdir: be more conservative with directory entry names

Luuk Paulussen (1):
      hwmon: (adt7475) Make volt2reg return same reg as reg2volt input

Martin Schiller (1):
      net/x25: fix nonblocking connect

Masami Hiramatsu (2):
      tracing: trigger: Replace unneeded RCU-list traversals
      tracing/uprobe: Fix double perf_event linking on multiprobe uprobe

Masami Ichikawa (1):
      tracing: Do not set trace clock if tracefs lockdown is in effect

Matthew Auld (1):
      drm/i915/userptr: fix size calculation

Matthew Wilcox (Oracle) (3):
      XArray: Fix infinite loop with entry at ULONG_MAX
      XArray: Fix xa_find_after with multi-index entries
      XArray: Fix xas_find returning too many entries

Maxim Mikityanskiy (1):
      net: Fix packet reordering caused by GRO and listified RX cooperation

Mehmet Akif Tasova (1):
      Revert "iwlwifi: mvm: fix scan config command size"

Meir Lichtinger (1):
      net/mlx5: Update the list of the PCI supported devices

Michael Ellerman (3):
      net: cxgb3_main: Add CAP_NET_ADMIN check to CHELSIO_GET_MEM
      airo: Fix possible info leak in AIROOLDIOCTL/SIOCDEVPRIVATE
      airo: Add missing CAP_NET_ADMIN check in AIROOLDIOCTL/SIOCDEVPRIVATE

Micha=C5=82 Miros=C5=82aw (2):
      mmc: tegra: fix SDR50 tuning override
      mmc: sdhci: fix minimum clock rate for v3 controller

Niko Kortstrom (1):
      net: ip6_gre: fix moving ip6gre between namespaces

Pablo Neira Ayuso (2):
      netfilter: nf_tables: add __nft_chain_type_get()
      netfilter: nf_tables: autoload modules from the abort path

Paolo Abeni (1):
      Revert "udp: do rmem bulk free even if the rx sk queue is empty"

Paul Blakey (1):
      net/mlx5: Fix lowest FDB pool size

Richard Palethorpe (1):
      can, slip: Protect tty->disc_data in write_wakeup and close with RCU

Shuah Khan (1):
      iommu/amd: Fix IOMMU perf counter clobbering during init

Stephan Gerhold (1):
      Input: pm8xxx-vib - fix handling of separate enable register

Steven Rostedt (VMware) (1):
      tracing: Fix histogram code when expression has same var as value

Tariq Toukan (3):
      net/mlx5e: kTLS, Fix corner-case checks in TX resync flow
      net/mlx5e: kTLS, Remove redundant posts in TX resync flow
      net/mlx5e: kTLS, Do not send decrypted-marked SKBs via non-accel path

Tvrtko Ursulin (1):
      drm/i915: Align engine->uabi_class/instance with i915_drm.h

Ulrich Weber (1):
      xfrm: support output_mark for offload ESP packets

Wen Huang (1):
      libertas: Fix two buffer overflows at parsing bss descriptor

Wen Yang (1):
      tcp_bbr: improve arithmetic division in bbr_update_bw()

Wenwen Wang (1):
      firestream: fix memory leaks

William Dauchy (2):
      net, ip6_tunnel: fix namespaces move
      net, ip_tunnel: fix namespaces move

Yuki Taguchi (1):
      ipv6: sr: remove SKB_GSO_IPXIP6 on End.D* actions

xiaofeng.yan (1):
      hsr: Fix a compilation error


--zYM0uCDKw75PZbzx
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl4ylF8ACgkQONu9yGCS
aT4T9RAAnxjhOmlyKBtpBxmPA0m2909pCfUcbkLq1NqAmS8Q/qTF0xiCstSNyLIw
pdkk+YU5fXJFycusbgSGCHc7DlxmYTRqQ2Efd/BMNt+dtH9yXaT6tnNcPBujSIpB
nay/dXeHfXAMKAv4MsJsQg15vG4k7wBfJCOEsnmWO4bS6s58PL7O8ko4mfiskl5w
toEOOABKQEvhtoGKDVIuzBzVD8XdnuYvGwv/ps0zXzCLopei0QQRIGf5PUnucqEs
ITZ0N9r3EIeHwYG1sCbS9rvQIKwRmWxRL5JfVHbh1XLSDntvIFhqrwjXbYKW5bPY
OHakncY/rFyfaHXelKzZ8jxelxDIdHSRj9CMEnA4Rq5FLdQD8aJhzCvVcdIziXa4
bx6S9ifkl9VT/xPIXapTUwPQlZJSyL4S7QOkU5jEk4TxFQANJk4JS98LJjq8GuD4
wJdpbSYQCD2g5ag19F/SloeXl1heFqdSgy4006kUXNL1I1eI+Qskn/UYTFjK9QaN
gT2sqQhAoJ6dukhHEYY4vPOK0bCOz3R2mUU85VNDC/vekJmD73Qa+ISLF3Q2JRBe
vjAdUCJgbIyIn1GkL2tWVNkdFpXViVvpHpJSg/cZ4JxjjSulwHN/IQi2z8+4lJkr
esvMwRRoJtZivd4Jc85SplgC4bPbWhDTWMm9vrFOqP6G0CbTcDU=
=4Xpf
-----END PGP SIGNATURE-----

--zYM0uCDKw75PZbzx--
