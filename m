Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F01D11463CF
	for <lists+stable@lfdr.de>; Thu, 23 Jan 2020 09:46:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727453AbgAWIqf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jan 2020 03:46:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:56644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725785AbgAWIqf (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 Jan 2020 03:46:35 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AC9D82087E;
        Thu, 23 Jan 2020 08:46:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579769194;
        bh=NsM3rceQBUIDbaMPtlDG//Row1nIVlo5Gk18MdSrJBI=;
        h=Date:From:To:Cc:Subject:From;
        b=f8aGdm92zsuG4Lyp3G/rYvfECg5r2S58Kjefekid7ldowvrJjfEAcA357B0Op6yum
         /WlvN5hs3fqgOqJ7nvKuyoB87+vcll5/6KR2uBxefGoclSLH7HlsqPt2qFGoc398WW
         16e6TQ/nGQyMwvm6MCPJE9pN4fXwsboElQrgEKXY=
Date:   Thu, 23 Jan 2020 09:46:32 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.19.98
Message-ID: <20200123084632.GA435419@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="ew6BAiZeqk4r7MaW"
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--ew6BAiZeqk4r7MaW
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 4.19.98 kernel.

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

 Makefile                                                   |    2=20
 arch/arm/boot/dts/am571x-idk.dts                           |    2=20
 arch/arm/boot/dts/imx6dl-icore-mipi.dts                    |    2=20
 arch/arm/boot/dts/imx6q-dhcom-pdk2.dts                     |    2=20
 arch/arm/boot/dts/imx6q-dhcom-som.dtsi                     |    2=20
 arch/arm/boot/dts/imx6qdl-icore-1.5.dtsi                   |   34 ++
 arch/arm/boot/dts/imx7s-colibri.dtsi                       |    4=20
 arch/arm/boot/dts/meson8.dtsi                              |    2=20
 arch/arm64/boot/dts/allwinner/sun50i-a64-olinuxino.dts     |    2=20
 arch/arm64/boot/dts/altera/socfpga_stratix10.dtsi          |    8=20
 arch/arm64/boot/dts/amlogic/meson-gxl-s905x-khadas-vim.dts |    4=20
 arch/arm64/boot/dts/arm/juno-base.dtsi                     |    1=20
 arch/arm64/boot/dts/marvell/armada-cp110.dtsi              |    8=20
 arch/x86/boot/compressed/head_64.S                         |    5=20
 arch/x86/kernel/cpu/amd.c                                  |    4=20
 arch/x86/kernel/cpu/intel_rdt.c                            |    2=20
 arch/x86/kernel/cpu/intel_rdt_rdtgroup.c                   |    6=20
 block/blk-settings.c                                       |    2=20
 drivers/block/xen-blkfront.c                               |    4=20
 drivers/clk/clk.c                                          |   10=20
 drivers/clk/qcom/gcc-sdm845.c                              |    7=20
 drivers/clk/sprd/common.c                                  |    2=20
 drivers/gpu/drm/i915/selftests/i915_random.h               |    1=20
 drivers/gpu/drm/nouveau/nvkm/subdev/bar/gf100.c            |    2=20
 drivers/gpu/drm/nouveau/nvkm/subdev/bar/nv50.c             |    2=20
 drivers/gpu/drm/nouveau/nvkm/subdev/mmu/vmm.c              |    2=20
 drivers/hwmon/pmbus/ibm-cffps.c                            |   10=20
 drivers/iio/industrialio-buffer.c                          |    6=20
 drivers/irqchip/Kconfig                                    |    4=20
 drivers/md/dm-snap-persistent.c                            |    2=20
 drivers/md/raid0.c                                         |    2=20
 drivers/message/fusion/mptctl.c                            |  213 +++-----=
-----
 drivers/mtd/devices/mchp23k256.c                           |   20 -
 drivers/net/ethernet/hisilicon/hns/hns_enet.c              |    4=20
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c             |   13=20
 drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c       |   30 +
 drivers/net/ethernet/renesas/sh_eth.c                      |   38 +-
 drivers/net/ethernet/stmicro/stmmac/common.h               |    5=20
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c          |    4=20
 drivers/net/hyperv/rndis_filter.c                          |    2=20
 drivers/net/macvlan.c                                      |    5=20
 drivers/net/usb/lan78xx.c                                  |    1=20
 drivers/net/usb/r8152.c                                    |    3=20
 drivers/net/wan/fsl_ucc_hdlc.c                             |    2=20
 drivers/net/wireless/st/cw1200/fwio.c                      |    6=20
 drivers/nfc/pn533/usb.c                                    |    2=20
 drivers/ptp/ptp_clock.c                                    |    4=20
 drivers/scsi/bnx2i/bnx2i_iscsi.c                           |    2=20
 drivers/scsi/esas2r/esas2r_flash.c                         |    1=20
 drivers/scsi/fnic/vnic_dev.c                               |   20 -
 drivers/scsi/qla2xxx/qla_init.c                            |    6=20
 drivers/scsi/qla2xxx/qla_isr.c                             |    6=20
 drivers/scsi/qla4xxx/ql4_mbx.c                             |    3=20
 drivers/scsi/scsi_trace.c                                  |  113 ++----
 drivers/target/target_core_fabric_lib.c                    |    2=20
 drivers/usb/core/hub.c                                     |    1=20
 drivers/usb/serial/ch341.c                                 |    6=20
 drivers/usb/serial/io_edgeport.c                           |   16=20
 drivers/usb/serial/keyspan.c                               |    4=20
 drivers/usb/serial/opticon.c                               |    2=20
 drivers/usb/serial/option.c                                |    6=20
 drivers/usb/serial/quatech2.c                              |    6=20
 drivers/usb/serial/usb-serial-simple.c                     |    2=20
 drivers/usb/serial/usb-serial.c                            |    3=20
 firmware/Makefile                                          |    2=20
 fs/btrfs/inode.c                                           |   73 ++--
 fs/btrfs/qgroup.c                                          |    6=20
 fs/btrfs/root-tree.c                                       |   10=20
 fs/reiserfs/xattr.c                                        |    8=20
 include/dt-bindings/reset/amlogic,meson8b-reset.h          |    6=20
 include/linux/blkdev.h                                     |    8=20
 include/linux/lsm_hooks.h                                  |    8=20
 include/linux/regulator/ab8500.h                           |    2=20
 include/linux/security.h                                   |   28 -
 include/linux/tnum.h                                       |    2=20
 kernel/bpf/tnum.c                                          |    9=20
 kernel/bpf/verifier.c                                      |   13=20
 kernel/capability.c                                        |   22 -
 kernel/ptrace.c                                            |   15=20
 kernel/seccomp.c                                           |    4=20
 kernel/time/tick-sched.c                                   |   14=20
 mm/huge_memory.c                                           |   38 +-
 mm/page-writeback.c                                        |    4=20
 mm/shmem.c                                                 |    7=20
 mm/slab_common.c                                           |    3=20
 net/batman-adv/distributed-arp-table.c                     |    4=20
 net/dsa/tag_qca.c                                          |    3=20
 net/ipv4/netfilter/arp_tables.c                            |   19 -
 net/ipv4/tcp.c                                             |    6=20
 net/ipv4/tcp_input.c                                       |    7=20
 net/netfilter/ipset/ip_set_bitmap_gen.h                    |    2=20
 net/netfilter/nf_tables_api.c                              |   38 +-
 net/netfilter/nft_tunnel.c                                 |    2=20
 net/wireless/nl80211.c                                     |    1=20
 net/wireless/rdev-ops.h                                    |    4=20
 net/wireless/sme.c                                         |    6=20
 net/wireless/util.c                                        |    2=20
 security/apparmor/capability.c                             |   14=20
 security/apparmor/include/capability.h                     |    2=20
 security/apparmor/ipc.c                                    |    3=20
 security/apparmor/lsm.c                                    |    4=20
 security/apparmor/resource.c                               |    2=20
 security/commoncap.c                                       |   17 -
 security/security.c                                        |   14=20
 security/selinux/hooks.c                                   |   18 -
 security/smack/smack_access.c                              |    2=20
 sound/core/seq/seq_timer.c                                 |   14=20
 sound/firewire/dice/dice-extension.c                       |    5=20
 sound/soc/codecs/msm8916-wcd-analog.c                      |   20 -
 sound/soc/codecs/msm8916-wcd-digital.c                     |    6=20
 sound/usb/pcm.c                                            |    2=20
 tools/perf/builtin-report.c                                |    5=20
 tools/perf/util/hist.h                                     |    4=20
 tools/perf/util/probe-finder.c                             |   32 -
 114 files changed, 643 insertions(+), 594 deletions(-)

Adrian Huang (1):
      mm: memcg/slab: call flush_memcg_workqueue() only if memcg workqueue =
is valid

Alexander Lobakin (1):
      net: dsa: tag_qca: fix doubled Tx statistics

Alexandre Belloni (1):
      ARM: dts: imx6q-dhcom: fix rtc compatible

Angelo Dureghello (1):
      mtd: devices: fix mchp23k256 read and write

Ard Biesheuvel (1):
      x86/efistub: Disable paging at mixed mode entry

Arnd Bergmann (1):
      scsi: fnic: fix invalid stack access

Baolin Wang (1):
      clk: sprd: Use IS_ERR() to validate the return value of syscon_regmap=
_lookup_by_phandle()

Bart Van Assche (2):
      scsi: target: core: Fix a pr_debug() argument
      scsi: core: scsi_trace: Use get_unaligned_be*()

Bharath Vedartham (1):
      mm/huge_memory.c: make __thp_get_unmapped_area static

Christian Brauner (1):
      ptrace: reintroduce usage of subjective credentials in ptrace_has_cap=
()

Christian Hewitt (1):
      arm64: dts: meson-gxl-s905x-khadas-vim: fix gpio-keys-polled node

Colin Ian King (1):
      net/wan/fsl_ucc_hdlc: fix out of bounds write on array utdm_info

Cong Wang (1):
      netfilter: fix a use-after-free in mtype_destroy()

Dan Carpenter (3):
      scsi: mptfusion: Fix double fetch bug in ioctl
      cw1200: Fix a signedness bug in cw1200_load_firmware()
      scsi: esas2r: unlock on error in esas2r_nvram_read_direct()

Daniel Borkmann (1):
      bpf: Fix incorrect verifier simulation of ARSH under ALU32

Dinh Nguyen (1):
      arm64: dts: agilex/stratix10: fix pmu interrupt numbers

Eddie James (1):
      hwmon: (pmbus/ibm-cffps) Switch LEDs to blocking brightness call

Eric Dumazet (4):
      macvlan: use skb_reset_mac_header() in macvlan_queue_xmit()
      net: usb: lan78xx: limit size of local TSO packets
      tcp: refine rule to allow EPOLLOUT generation under mem pressure
      tick/sched: Annotate lockless access to last_jiffies_update

Felix Fietkau (2):
      cfg80211: fix memory leak in cfg80211_cqm_rssi_update
      cfg80211: fix page refcount issue in A-MSDU decap

Florian Westphal (4):
      netfilter: arp_tables: init netns pointer in xt_tgdtor_param struct
      netfilter: nft_tunnel: fix null-attribute check
      netfilter: nf_tables: remove WARN and add NLA_STRING upper limits
      netfilter: nf_tables: fix flowtable list del corruption

Georgi Djakov (1):
      clk: qcom: gcc-sdm845: Add missing flag to votable GDSCs

Greg Kroah-Hartman (1):
      Linux 4.19.98

Guenter Roeck (1):
      clk: Don't try to enable critical clocks if prepare failed

Huacai Chen (1):
      scsi: qla2xxx: Fix qla2x00_request_irqs() for MSI

Jacopo Mondi (1):
      ARM: dts: imx6qdl: Add Engicam i.Core 1.5 MX6

Jagan Teki (1):
      ARM: dts: imx6q-icore-mipi: Use 1.5 version of i.Core MX6DL

Jari Ruusu (1):
      Fix built-in early-load Intel microcode alignment

Jeff Mahoney (1):
      reiserfs: fix handling of -EOPNOTSUPP in reiserfs_for_each_xattr

Jer=F3nimo Borque (1):
      USB: serial: simple: Add Motorola Solutions TETRA MTP3xxx and MTP85xx

Jin Yao (1):
      perf report: Fix incorrectly added dimensions as switch perf data file

Johan Hovold (10):
      USB: serial: opticon: fix control-message timeouts
      USB: serial: suppress driver bind attributes
      USB: serial: ch341: handle unbound port at reset_resume
      USB: serial: io_edgeport: handle unbound ports on URB completion
      USB: serial: io_edgeport: add missing active-port sanity check
      USB: serial: keyspan: handle unbound ports
      USB: serial: quatech2: handle unbound ports
      ALSA: usb-audio: fix sync-ep altsetting sanity check
      NFC: pn533: fix bulk-message timeout
      r8152: add missing endpoint sanity check

Johannes Berg (1):
      cfg80211: check for set_wiphy_params

Johannes Thumshirn (1):
      btrfs: fix memory leak in qgroup accounting

Jon Derrick (3):
      drm/nouveau/bar/nv50: check bar1 vmm return value
      drm/nouveau/bar/gf100: ensure BAR is mapped
      drm/nouveau/mmu: qualify vmm during dtor

Jonathan Neusch=E4fer (1):
      irqchip: Place CONFIG_SIFIVE_PLIC into the menu

Jose Abreu (2):
      net: stmmac: 16KB buffer must be 16 byte aligned
      net: stmmac: Enable 16KB buffer size

Josef Bacik (3):
      btrfs: rework arguments of btrfs_unlink_subvol
      btrfs: fix invalid removal of root ref
      btrfs: do not delete mismatched root refs

Keiya Nobuta (1):
      usb: core: hub: Improved device recognition on remote wakeup

Kirill A. Shutemov (2):
      mm/shmem.c: thp, shmem: fix conflict of above-47bit hint address and =
PMD alignment
      mm/huge_memory.c: thp: fix conflict of above-47bit hint address and P=
MD alignment

Kishon Vijay Abraham I (1):
      ARM: dts: am571x-idk: Fix gpios property to have the correct gpio num=
ber

Kristian Evensen (1):
      USB: serial: option: Add support for Quectel RM500Q

Lars M=F6llendorf (1):
      iio: buffer: align the size of scan bytes to size of the largest elem=
ent

Marcel Ziswiler (1):
      ARM: dts: imx7: Fix Toradex Colibri iMX7S 256MB NAND flash support

Marek Vasut (1):
      ARM: dts: imx6q-dhcom: Fix SGTL5000 VDDIO regulator connection

Markus Theil (1):
      cfg80211: fix deadlocks in autodisconnect work

Martin Blumenstingl (2):
      ARM: dts: meson8: fix the size of the PMU registers
      dt-bindings: reset: meson8b: fix duplicate reset IDs

Martin Wilck (1):
      scsi: qla2xxx: fix rports not being mark as lost in sync fabric scan

Masami Hiramatsu (1):
      perf probe: Fix wrong address verification

Micah Morton (1):
      LSM: generalize flag passing to security_capable

Mikulas Patocka (1):
      block: fix an integer overflow in logical block size

Miquel Raynal (1):
      arm64: dts: marvell: Fix CP110 NAND controller node multi-line commen=
t alignment

Mohammed Gamal (1):
      hv_netvsc: Fix memory leak when removing rndis device

Nathan Chancellor (1):
      xen/blkfront: Adjust indentation in xlvbd_alloc_gendisk

Pablo Neira Ayuso (1):
      netfilter: nf_tables: store transaction list locally while requesting=
 module

Pan Bian (2):
      scsi: qla4xxx: fix double free bug
      scsi: bnx2i: fix potential use after free

Pengcheng Yang (1):
      tcp: fix marked lost packets not being retransmitted

Petr Machata (2):
      mlxsw: spectrum: Wipe xstats.backlog of down ports
      mlxsw: spectrum_qdisc: Include MC TCs in Qdisc counters

Qian Cai (1):
      x86/resctrl: Fix an imbalance in domain_remove_cpu()

Reinhard Speyerer (1):
      USB: serial: option: add support for Quectel RM500Q in QDL mode

Sergei Shtylyov (1):
      sh_eth: check sh_eth_cpu_data::dual_port when dumping registers

Shakeel Butt (1):
      x86/resctrl: Fix potential memory leak

Stefan Mavrodiev (1):
      arm64: dts: allwinner: a64: olinuxino: Fix SDIO supply regulator

Stephan Gerhold (4):
      ASoC: msm8916-wcd-digital: Reset RX interpolation path after use
      ASoC: msm8916-wcd-analog: Fix selected events for MIC BIAS External1
      ASoC: msm8916-wcd-analog: Fix MIC BIAS Internal1
      regulator: ab8500: Remove SYSCLKREQ from enum ab8505_regulator_id

Sudeep Holla (1):
      Revert "arm64: dts: juno: add dma-ranges property"

Sven Eckelmann (1):
      batman-adv: Fix DAT candidate selection on little endian systems

Takashi Iwai (1):
      ALSA: seq: Fix racy access for queue timer in proc read

Takashi Sakamoto (1):
      ALSA: dice: fix fallback from protocol extension into limited functio=
nality

Tom Lendacky (1):
      x86/CPU/AMD: Ensure clearing of SME/SEV features is maintained

Vladis Dronov (1):
      ptp: free ptp device pin descriptors properly

Wen Yang (1):
      mm/page-writeback.c: avoid potential division by zero in wb_min_max_r=
atio()

Yonglong Liu (1):
      net: hns: fix soft lockup when there is not enough memory

YueHaibing (1):
      drm/i915: Add missing include file <linux/math64.h>

Yuya Fujita (1):
      perf hists: Fix variable name's inconsistency in hists__for_each() ma=
cro


--ew6BAiZeqk4r7MaW
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl4pXWcACgkQONu9yGCS
aT7n1RAAp8gNWmvGybQcerHDFNe1FG90bq56Y4+N5zdwXj//PSFcJufN/GAJtJ/R
lfJh+RQMhug+v6K7lcVJfCsN8btGd2zfPQMT5yTi1sTZCl3993l908QQlpFzkPb8
ke6d6YihojVyw8Xa5KGTp3pyJthCHhlPkLMzXPxH56/CCcvmOFcMYB07QMZQ2QS4
TYDw6tpBfncW4Hc5s1EyJ3kYnJmGF4mKs24LGr7QSn0h5DAGZSz9qm/zz4hE0Djb
7WVbZGIzo2ZCjrJc57tWcROXRCry0sWWGSQp9EJYYNT06v07HvkzvwE+WueGJLgt
axMEYOZaEjL/zoM2dI7DUhFuGGeURbU+pL+7BkeTD26b4Ez/ZEcqd2yC6xuMpnrx
CXWmOMKyvZNnIO2LXWb/2TdZ4tTuKsrQgthoxVGD6AADZ0+VkkTha3Ku/FcVqMlG
J7z0qKw9nA1YdyjxIO963TJUaKH7ZvQeYaAQjDoUIsQoC9hq6TlQQDQRtSKrbL/F
Ty5SdYDeP8hqIj8/FNtIsVVGQine0EEA0aC9eCySsfvzs5dHVqotGny1qBgc0Nta
iYz9uUuubw+lW4gA1pBCvFYQsZYPVUmfCs6E11PtuxdZVCMfTzqxD/XXjMpz6spN
gNQ9WSrPdFM40jtUBYv8IY5r5bhrXFpxBjiVJvLMR6oh+WRbjMQ=
=/YZZ
-----END PGP SIGNATURE-----

--ew6BAiZeqk4r7MaW--
