Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA31C1463D5
	for <lists+stable@lfdr.de>; Thu, 23 Jan 2020 09:46:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726792AbgAWIqy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jan 2020 03:46:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:56778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725785AbgAWIqy (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 Jan 2020 03:46:54 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2A7AA2087E;
        Thu, 23 Jan 2020 08:46:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579769212;
        bh=QpGUGYfXsHzYDbR981w86yyGtqbfKqOfYdmtLUgD6lo=;
        h=Date:From:To:Cc:Subject:From;
        b=zOIE3Ya7sAl2wwxxaKFAjbK6ROM0jmR+XVfgZZFhEjU2GBitiFnCbAhmgtcXCjDrf
         +gVCEZAU9bfkfWI879TFN1atCswdS82SuOiNUvynQGJUM7T/rtrSDBs+fvdlFGDDf2
         J81uHzRRSUQzN0QNPx3/AmoE7Ml0U8aoFRC1L3so=
Date:   Thu, 23 Jan 2020 09:46:50 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 5.4.14
Message-ID: <20200123084650.GA435525@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="pWyiEgJYm5f9v55/"
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--pWyiEgJYm5f9v55/
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 5.4.14 kernel.

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

 Documentation/devicetree/bindings/net/snps,dwmac.yaml       |    1=20
 Makefile                                                    |    2=20
 arch/arm/boot/dts/am571x-idk.dts                            |    2=20
 arch/arm/boot/dts/dra7-l4.dtsi                              |    2=20
 arch/arm/boot/dts/imx6dl-icore-mipi.dts                     |    2=20
 arch/arm/boot/dts/imx6q-dhcom-pdk2.dts                      |    2=20
 arch/arm/boot/dts/imx6q-dhcom-som.dtsi                      |    2=20
 arch/arm/boot/dts/imx6qdl-sabresd.dtsi                      |    4=20
 arch/arm/boot/dts/imx6sl-evk.dts                            |    4=20
 arch/arm/boot/dts/imx6sll-evk.dts                           |    4=20
 arch/arm/boot/dts/imx6sx-sdb-reva.dts                       |    4=20
 arch/arm/boot/dts/imx6sx-sdb.dts                            |    4=20
 arch/arm/boot/dts/imx6ul-kontron-n6310-s.dts                |    4=20
 arch/arm/boot/dts/imx7s-colibri.dtsi                        |    4=20
 arch/arm/boot/dts/imx7ulp.dtsi                              |    4=20
 arch/arm/boot/dts/meson8.dtsi                               |    2=20
 arch/arm/boot/dts/omap4.dtsi                                |    4=20
 arch/arm/mach-davinci/Kconfig                               |    1=20
 arch/arm/mach-omap2/pdata-quirks.c                          |    6=20
 arch/arm64/boot/dts/allwinner/sun50i-a64-olinuxino-emmc.dts |    2=20
 arch/arm64/boot/dts/allwinner/sun50i-a64-olinuxino.dts      |    2=20
 arch/arm64/boot/dts/allwinner/sun50i-a64.dtsi               |    9=20
 arch/arm64/boot/dts/altera/socfpga_stratix10.dtsi           |    8=20
 arch/arm64/boot/dts/amlogic/meson-axg.dtsi                  |   12=20
 arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi           |   12=20
 arch/arm64/boot/dts/amlogic/meson-gxl-s905x-khadas-vim.dts  |    4=20
 arch/arm64/boot/dts/arm/juno-base.dtsi                      |    1=20
 arch/arm64/boot/dts/arm/juno-clocks.dtsi                    |    4=20
 arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi              |    2=20
 arch/arm64/boot/dts/freescale/imx8mm-evk.dts                |    2=20
 arch/arm64/boot/dts/freescale/imx8mm.dtsi                   |   10=20
 arch/arm64/boot/dts/freescale/imx8mq-librem5-devkit.dts     |    2=20
 arch/arm64/boot/dts/intel/socfpga_agilex.dtsi               |    8=20
 arch/arm64/boot/dts/marvell/armada-ap806-dual.dtsi          |    2=20
 arch/arm64/boot/dts/marvell/armada-cp110.dtsi               |    8=20
 arch/arm64/boot/dts/qcom/msm8998-mtp.dtsi                   |   68 +++
 arch/arm64/boot/dts/qcom/msm8998.dtsi                       |   51 +-
 arch/arm64/boot/dts/qcom/sdm845-cheza.dtsi                  |    2=20
 arch/arm64/boot/dts/qcom/sdm845.dtsi                        |    2=20
 arch/arm64/boot/dts/renesas/hihope-common.dtsi              |   20 -
 arch/arm64/boot/dts/renesas/r8a774a1.dtsi                   |   11=20
 arch/arm64/boot/dts/renesas/r8a77970.dtsi                   |    2=20
 arch/s390/kernel/setup.c                                    |    2=20
 arch/um/drivers/Kconfig                                     |    2=20
 arch/um/drivers/virtio_uml.c                                |    4=20
 arch/um/os-Linux/main.c                                     |    2=20
 arch/x86/boot/compressed/head_64.S                          |    5=20
 arch/x86/events/intel/uncore_snbep.c                        |    1=20
 arch/x86/kernel/cpu/amd.c                                   |    4=20
 arch/x86/kernel/cpu/resctrl/core.c                          |    2=20
 arch/x86/kernel/cpu/resctrl/rdtgroup.c                      |    6=20
 block/blk-settings.c                                        |    2=20
 block/bsg-lib.c                                             |    2=20
 drivers/base/firmware_loader/builtin/Makefile               |    2=20
 drivers/block/xen-blkfront.c                                |    4=20
 drivers/bus/ti-sysc.c                                       |   10=20
 drivers/clk/clk.c                                           |   10=20
 drivers/clk/imx/clk-imx7ulp.c                               |    6=20
 drivers/clk/qcom/gcc-sdm845.c                               |    7=20
 drivers/clk/samsung/clk-exynos5420.c                        |    8=20
 drivers/clk/sprd/common.c                                   |    2=20
 drivers/clk/sunxi-ng/ccu-sun8i-r40.c                        |    6=20
 drivers/cpuidle/governors/teo.c                             |    2=20
 drivers/firmware/efi/earlycon.c                             |   16=20
 drivers/gpio/Kconfig                                        |    1=20
 drivers/gpio/gpio-thunderx.c                                |  163 ++++++-=
--
 drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c                       |    4=20
 drivers/gpu/drm/amd/display/dc/core/dc_link.c               |    2=20
 drivers/gpu/drm/i915/selftests/i915_random.h                |    1=20
 drivers/hwmon/pmbus/ibm-cffps.c                             |   37 +-
 drivers/i2c/busses/i2c-iop3xx.c                             |   12=20
 drivers/i2c/busses/i2c-tegra.c                              |   38 +-
 drivers/iio/adc/ad7124.c                                    |   12=20
 drivers/iio/chemical/Kconfig                                |    1=20
 drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c                |    3=20
 drivers/iio/industrialio-buffer.c                           |    6=20
 drivers/iio/light/vcnl4000.c                                |    3=20
 drivers/irqchip/Kconfig                                     |    4=20
 drivers/md/dm-snap-persistent.c                             |    2=20
 drivers/md/raid0.c                                          |    2=20
 drivers/message/fusion/mptctl.c                             |  213 ++-----=
-----
 drivers/mtd/chips/cfi_cmdset_0002.c                         |   60 ++-
 drivers/mtd/devices/mchp23k256.c                            |   20 -
 drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c                  |   11=20
 drivers/mtd/spi-nor/spi-nor.c                               |    4=20
 drivers/net/dsa/bcm_sf2.c                                   |    2=20
 drivers/net/dsa/sja1105/sja1105_main.c                      |    2=20
 drivers/net/ethernet/broadcom/bcmsysport.c                  |    7=20
 drivers/net/ethernet/broadcom/bnxt/bnxt.c                   |   29 +
 drivers/net/ethernet/broadcom/bnxt/bnxt.h                   |    4=20
 drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c               |    3=20
 drivers/net/ethernet/hisilicon/hns/hns_enet.c               |    4=20
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c             |    6=20
 drivers/net/ethernet/intel/i40e/i40e_main.c                 |    1=20
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c              |   31 +
 drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c        |   30 +
 drivers/net/ethernet/renesas/sh_eth.c                       |   38 +-
 drivers/net/ethernet/socionext/sni_ave.c                    |   20 -
 drivers/net/ethernet/stmicro/stmmac/common.h                |    5=20
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c           |    4=20
 drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c      |   46 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c             |    4=20
 drivers/net/hyperv/rndis_filter.c                           |    2=20
 drivers/net/macvlan.c                                       |    5=20
 drivers/net/phy/dp83867.c                                   |    8=20
 drivers/net/usb/lan78xx.c                                   |    1=20
 drivers/net/usb/r8152.c                                     |    3=20
 drivers/net/wan/fsl_ucc_hdlc.c                              |    2=20
 drivers/net/wireless/realtek/rtw88/phy.c                    |   17=20
 drivers/net/wireless/realtek/rtw88/phy.h                    |    9=20
 drivers/net/wireless/realtek/rtw88/rtw8822c.c               |    4=20
 drivers/net/wireless/st/cw1200/fwio.c                       |    6=20
 drivers/nfc/pn533/usb.c                                     |    2=20
 drivers/ptp/ptp_clock.c                                     |    4=20
 drivers/reset/core.c                                        |    6=20
 drivers/s390/crypto/zcrypt_ccamisc.c                        |    4=20
 drivers/scsi/bnx2i/bnx2i_iscsi.c                            |    2=20
 drivers/scsi/esas2r/esas2r_flash.c                          |    1=20
 drivers/scsi/fnic/vnic_dev.c                                |   20 -
 drivers/scsi/hisi_sas/hisi_sas_main.c                       |    3=20
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c                      |   11=20
 drivers/scsi/lpfc/lpfc_scsi.c                               |    2=20
 drivers/scsi/lpfc/lpfc_sli.c                                |   56 +--
 drivers/scsi/qla2xxx/qla_init.c                             |    6=20
 drivers/scsi/qla2xxx/qla_isr.c                              |    6=20
 drivers/scsi/qla4xxx/ql4_mbx.c                              |    3=20
 drivers/scsi/scsi_trace.c                                   |  113 +-----
 drivers/scsi/scsi_transport_sas.c                           |    9=20
 drivers/scsi/storvsc_drv.c                                  |    4=20
 drivers/soc/amlogic/meson-ee-pwrc.c                         |   24 -
 drivers/staging/comedi/drivers/ni_routes.c                  |   12=20
 drivers/target/target_core_fabric_lib.c                     |    2=20
 drivers/usb/core/hub.c                                      |    1=20
 drivers/usb/serial/ch341.c                                  |    6=20
 drivers/usb/serial/io_edgeport.c                            |   16=20
 drivers/usb/serial/keyspan.c                                |    4=20
 drivers/usb/serial/opticon.c                                |    2=20
 drivers/usb/serial/option.c                                 |    6=20
 drivers/usb/serial/quatech2.c                               |    6=20
 drivers/usb/serial/usb-serial-simple.c                      |    2=20
 drivers/usb/serial/usb-serial.c                             |    3=20
 fs/btrfs/inode.c                                            |   73 ++--
 fs/btrfs/ioctl.c                                            |   14=20
 fs/btrfs/qgroup.c                                           |    6=20
 fs/btrfs/relocation.c                                       |   51 ++
 fs/btrfs/root-tree.c                                        |   10=20
 fs/btrfs/volumes.c                                          |    6=20
 fs/fuse/file.c                                              |    4=20
 fs/io_uring.c                                               |    6=20
 fs/reiserfs/xattr.c                                         |    8=20
 include/dt-bindings/reset/amlogic,meson8b-reset.h           |    6=20
 include/linux/blkdev.h                                      |    8=20
 include/linux/mm.h                                          |   18 -
 include/linux/mmzone.h                                      |    5=20
 include/linux/netdevice.h                                   |    2=20
 include/linux/regulator/ab8500.h                            |    2=20
 include/linux/skmsg.h                                       |   13=20
 include/linux/tnum.h                                        |    2=20
 include/net/tcp.h                                           |    6=20
 include/trace/events/huge_memory.h                          |    3=20
 init/main.c                                                 |    1=20
 kernel/bpf/tnum.c                                           |    9=20
 kernel/bpf/verifier.c                                       |   13=20
 kernel/cpu.c                                                |  143 ++++----
 kernel/events/core.c                                        |    4=20
 kernel/locking/lockdep.c                                    |    7=20
 kernel/locking/rwsem.c                                      |    4=20
 kernel/ptrace.c                                             |   15=20
 kernel/time/tick-sched.c                                    |   14=20
 mm/huge_memory.c                                            |   38 +-
 mm/memcontrol.c                                             |   37 --
 mm/page-writeback.c                                         |    4=20
 mm/page_alloc.c                                             |   37 --
 mm/shmem.c                                                  |    7=20
 mm/slab.c                                                   |    4=20
 mm/slab_common.c                                            |    3=20
 mm/slub.c                                                   |    2=20
 mm/sparse.c                                                 |    9=20
 mm/vmalloc.c                                                |    4=20
 net/batman-adv/distributed-arp-table.c                      |    4=20
 net/core/dev.c                                              |   12=20
 net/core/devlink.c                                          |    2=20
 net/core/filter.c                                           |   20 -
 net/core/skmsg.c                                            |    2=20
 net/core/sock_map.c                                         |    7=20
 net/dsa/tag_gswip.c                                         |    2=20
 net/dsa/tag_qca.c                                           |    3=20
 net/ipv4/netfilter/arp_tables.c                             |   19 -
 net/ipv4/tcp.c                                              |    6=20
 net/ipv4/tcp_bpf.c                                          |   17=20
 net/ipv4/tcp_input.c                                        |    7=20
 net/ipv4/tcp_ulp.c                                          |    6=20
 net/netfilter/ipset/ip_set_bitmap_gen.h                     |    2=20
 net/netfilter/nf_nat_proto.c                                |   13=20
 net/netfilter/nf_tables_api.c                               |   38 +-
 net/netfilter/nft_tunnel.c                                  |    5=20
 net/sched/act_ctinfo.c                                      |   11=20
 net/sched/act_ife.c                                         |    7=20
 net/tipc/bcast.c                                            |   24 -
 net/tipc/socket.c                                           |   32 +
 net/tls/tls_main.c                                          |   10=20
 net/tls/tls_sw.c                                            |   31 +
 net/wireless/nl80211.c                                      |    3=20
 net/wireless/rdev-ops.h                                     |    4=20
 net/wireless/sme.c                                          |    6=20
 net/wireless/util.c                                         |    2=20
 sound/core/seq/seq_timer.c                                  |   14=20
 sound/firewire/dice/dice-extension.c                        |    5=20
 sound/firewire/tascam/amdtp-tascam.c                        |    5=20
 sound/soc/codecs/msm8916-wcd-analog.c                       |   20 -
 sound/soc/codecs/msm8916-wcd-digital.c                      |    6=20
 sound/soc/intel/boards/bytcht_es8316.c                      |    3=20
 sound/soc/stm/stm32_adfsdm.c                                |   12=20
 sound/soc/stm/stm32_sai_sub.c                               |  194 +++++++=
---
 sound/usb/pcm.c                                             |    2=20
 tools/bpf/bpftool/btf_dumper.c                              |    2=20
 tools/perf/builtin-report.c                                 |    5=20
 tools/perf/builtin-script.c                                 |   10=20
 tools/perf/util/hist.h                                      |    4=20
 tools/perf/util/probe-finder.c                              |   32 -
 tools/perf/util/time-utils.c                                |   27 +
 tools/perf/util/time-utils.h                                |    5=20
 tools/testing/selftests/drivers/net/mlxsw/qos_mc_aware.sh   |    8=20
 223 files changed, 1687 insertions(+), 1195 deletions(-)

Adam Ford (1):
      arm64: dts: imx8mm: Change SDMA1 ahb clock for imx8mm

Adrian Huang (1):
      mm: memcg/slab: call flush_memcg_workqueue() only if memcg workqueue =
is valid

Alexander Lobakin (2):
      net: dsa: tag_qca: fix doubled Tx statistics
      net: dsa: tag_gswip: fix typo in tagger name

Alexandre Belloni (1):
      ARM: dts: imx6q-dhcom: fix rtc compatible

Alexandru Tachici (1):
      iio: adc: ad7124: Fix DT channel configuration

Andi Kleen (2):
      perf script: Allow --time with --reltime
      perf script: Fix --reltime with --time

Andre Przywara (2):
      arm64: dts: allwinner: a64: Re-add PMU node
      arm64: dts: juno: Fix UART frequency

Angelo Dureghello (1):
      mtd: devices: fix mchp23k256 read and write

Angus Ainslie (Purism) (1):
      arm64: dts: imx8mq-librem5-devkit: use correct interrupt for the magn=
etometer

Anson Huang (6):
      ARM: dts: imx6qdl-sabresd: Remove incorrect power supply assignment
      ARM: dts: imx6sx-sdb: Remove incorrect power supply assignment
      ARM: dts: imx6sl-evk: Remove incorrect power supply assignment
      ARM: dts: imx6sll-evk: Remove incorrect power supply assignment
      clk: imx7ulp: Correct system clock source option #7
      clk: imx7ulp: Correct DDR clock mux options

Ard Biesheuvel (1):
      x86/efistub: Disable paging at mixed mode entry

Arnd Bergmann (3):
      ARM: davinci: select CONFIG_RESET_CONTROLLER
      scsi: fnic: fix invalid stack access
      cpu/SMT: Fix x86 link error without CONFIG_SYSFS

Arvind Sankar (1):
      efi/earlycon: Fix write-combine mapping on x86

Baolin Wang (1):
      clk: sprd: Use IS_ERR() to validate the return value of syscon_regmap=
_lookup_by_phandle()

Bart Van Assche (4):
      block: Fix the type of 'sts' in bsg_queue_rq()
      scsi: target: core: Fix a pr_debug() argument
      scsi: core: scsi_trace: Use get_unaligned_be*()
      scsi: lpfc: Fix a kernel warning triggered by lpfc_get_sgl_per_hdwq()

Biju Das (1):
      arm64: dts: renesas: r8a774a1: Remove audio port node

Chen-Yu Tsai (1):
      clk: sunxi-ng: r40: Allow setting parent rate for external clock outp=
uts

Christian Brauner (1):
      ptrace: reintroduce usage of subjective credentials in ptrace_has_cap=
()

Christian Hewitt (1):
      arm64: dts: meson-gxl-s905x-khadas-vim: fix gpio-keys-polled node

Colin Ian King (1):
      net/wan/fsl_ucc_hdlc: fix out of bounds write on array utdm_info

Cong Wang (2):
      netfilter: fix a use-after-free in mtype_destroy()
      net: avoid updating qdisc_xmit_lock_key in netdev_update_lockdep_key()

Dan Carpenter (3):
      scsi: mptfusion: Fix double fetch bug in ioctl
      cw1200: Fix a signedness bug in cw1200_load_firmware()
      scsi: esas2r: unlock on error in esas2r_nvram_read_direct()

Daniel Borkmann (1):
      bpf: Fix incorrect verifier simulation of ARSH under ALU32

David Hildenbrand (1):
      mm/memory_hotplug: don't free usage map when removing a re-added earl=
y section

Dinh Nguyen (1):
      arm64: dts: agilex/stratix10: fix pmu interrupt numbers

Dmitry Osipenko (2):
      i2c: tegra: Fix suspending in active runtime PM state
      i2c: tegra: Properly disable runtime PM on driver's probe error

Eddie James (2):
      hwmon: (pmbus/ibm-cffps) Switch LEDs to blocking brightness call
      hwmon: (pmbus/ibm-cffps) Fix LED blink behavior

Eric Dumazet (6):
      macvlan: use skb_reset_mac_header() in macvlan_queue_xmit()
      net/sched: act_ife: initalize ife->metalist earlier
      net: usb: lan78xx: limit size of local TSO packets
      net: sched: act_ctinfo: fix memory leak
      tcp: refine rule to allow EPOLLOUT generation under mem pressure
      tick/sched: Annotate lockless access to last_jiffies_update

Esben Haabendal (2):
      mtd: rawnand: gpmi: Fix suspend/resume problem
      mtd: rawnand: gpmi: Restore nfc timing setup after suspend/resume

Eyal Birger (1):
      netfilter: nat: fix ICMP header corruption on ICMP errors

Felix Fietkau (3):
      cfg80211: fix memory leak in nl80211_probe_mesh_link
      cfg80211: fix memory leak in cfg80211_cqm_rssi_update
      cfg80211: fix page refcount issue in A-MSDU decap

Filipe Manana (1):
      Btrfs: always copy scrub arguments back to user space

Florian Fainelli (2):
      net: systemport: Fixed queue mapping in internal ring map
      net: dsa: bcm_sf2: Configure IMP port for 2Gb/sec

Florian Westphal (5):
      netfilter: arp_tables: init netns pointer in xt_tgdtor_param struct
      netfilter: nft_tunnel: fix null-attribute check
      netfilter: nft_tunnel: ERSPAN_VERSION must not be null
      netfilter: nf_tables: remove WARN and add NLA_STRING upper limits
      netfilter: nf_tables: fix flowtable list del corruption

Frieder Schrempf (1):
      ARM: dts: imx6ul-kontron-n6310-s: Disable the snvs-poweroff driver

Geert Uytterhoeven (1):
      reset: Fix {of,devm}_reset_control_array_get kerneldoc return types

Georgi Djakov (1):
      clk: qcom: gcc-sdm845: Add missing flag to votable GDSCs

Greg Kroah-Hartman (1):
      Linux 5.4.14

Grygorii Strashko (1):
      ARM: dts: dra7: fix cpsw mdio fck clock

Guenter Roeck (1):
      clk: Don't try to enable critical clocks if prepare failed

Guido G=FCnther (1):
      iio: light: vcnl4000: Fix scale for vcnl4040

Hans de Goede (1):
      ASoC: Intel: bytcht_es8316: Fix Irbis NB41 netbook quirk

Harald Freudenberger (1):
      s390/zcrypt: Fix CCA cipher key gen with clear key value function

Huacai Chen (1):
      scsi: qla2xxx: Fix qla2x00_request_irqs() for MSI

Ian Abbott (2):
      staging: comedi: ni_routes: fix null dereference in ni_find_route_sou=
rce()
      staging: comedi: ni_routes: allow partial routing information

Ido Schimmel (2):
      mlxsw: spectrum: Do not modify cloned SKBs during xmit
      devlink: Wait longer before warning about unset port type

Ikjoon Jang (1):
      cpuidle: teo: Fix intervals[] array indexing bug

Jagan Teki (1):
      ARM: dts: imx6q-icore-mipi: Use 1.5 version of i.Core MX6DL

James Smart (4):
      scsi: lpfc: fix: Coverity: lpfc_get_scsi_buf_s3(): Null pointer deref=
erences
      scsi: lpfc: Fix list corruption detected in lpfc_put_sgl_per_hdwq
      scsi: lpfc: Fix hdwq sgl locks and irq handling
      scsi: lpfc: use hdwq assigned cpu for allocation

Jari Ruusu (1):
      Fix built-in early-load Intel microcode alignment

Jeff Mahoney (1):
      reiserfs: fix handling of -EOPNOTSUPP in reiserfs_for_each_xattr

Jens Axboe (1):
      io_uring: only allow submit from owning task

Jerome Brunet (2):
      arm64: dts: meson: axg: fix audio fifo reg size
      arm64: dts: meson: g12: fix audio fifo reg size

Jer=F3nimo Borque (1):
      USB: serial: simple: Add Motorola Solutions TETRA MTP3xxx and MTP85xx

Jin Yao (1):
      perf report: Fix incorrectly added dimensions as switch perf data file

Johan Hovold (10):
      ALSA: usb-audio: fix sync-ep altsetting sanity check
      USB: serial: opticon: fix control-message timeouts
      USB: serial: suppress driver bind attributes
      USB: serial: ch341: handle unbound port at reset_resume
      USB: serial: io_edgeport: handle unbound ports on URB completion
      USB: serial: io_edgeport: add missing active-port sanity check
      USB: serial: keyspan: handle unbound ports
      USB: serial: quatech2: handle unbound ports
      NFC: pn533: fix bulk-message timeout
      r8152: add missing endpoint sanity check

Johannes Berg (3):
      cfg80211: check for set_wiphy_params
      um: Don't trace irqflags during shutdown
      um: virtio_uml: Disallow modular build

Johannes Thumshirn (1):
      btrfs: fix memory leak in qgroup accounting

John Fastabend (8):
      bpf: Sockmap/tls, during free we may call tcp_bpf_unhash() in loop
      bpf: Sockmap, ensure sock lock held during tear down
      bpf: Sockmap/tls, push write_space updates through ulp updates
      bpf: Sockmap, skmsg helper overestimates push, pull, and pop bounds
      bpf: Sockmap/tls, msg_push_data may leave end mark in place
      bpf: Sockmap/tls, tls_sw can create a plaintext buf > encrypt buf
      bpf: Sockmap/tls, skmsg can have wrapped skmsg that needs extra chain=
ing
      bpf: Sockmap/tls, fix pop data with SK_DROP return code

John Garry (1):
      scsi: scsi_transport_sas: Fix memory leak when removing devices

Jonathan Neusch=E4fer (1):
      irqchip: Place CONFIG_SIFIVE_PLIC into the menu

Jose Abreu (6):
      net: stmmac: 16KB buffer must be 16 byte aligned
      net: stmmac: Enable 16KB buffer size
      net: stmmac: selftests: Make it work in Synopsys AXS101 boards
      net: stmmac: selftests: Mark as fail when received VLAN ID !=3D expec=
ted
      net: stmmac: selftests: Update status when disabling RSS
      net: stmmac: tc: Do not setup flower filtering if RSS is enabled

Josef Bacik (4):
      btrfs: rework arguments of btrfs_unlink_subvol
      btrfs: fix invalid removal of root ref
      btrfs: do not delete mismatched root refs
      btrfs: check rw_devices, not num_devices for balance

Kan Liang (1):
      perf/x86/intel/uncore: Fix missing marker for snr_uncore_imc_freerunn=
ing_events

Keiya Nobuta (1):
      usb: core: hub: Improved device recognition on remote wakeup

Kevin Hao (1):
      Revert "gpio: thunderx: Switch to GPIOLIB_IRQCHIP"

Kieran Bingham (1):
      arm64: dts: renesas: r8a77970: Fix PWM3

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

Krzysztof Kozlowski (1):
      i2c: iop3xx: Fix memory leak in probe error path

Kunihiko Hayashi (1):
      net: ethernet: ave: Avoid lockdep warning

Lars M=F6llendorf (1):
      iio: buffer: align the size of scan bytes to size of the largest elem=
ent

Lingpeng Chen (1):
      bpf/sockmap: Read psock ingress_msg before sk_receive_queue

Long Li (1):
      scsi: storvsc: Correctly set number of hardware queues for IDE disk

Lorenz Bauer (1):
      net: bpf: Don't leak time wait and request sockets

Marcel Ziswiler (1):
      ARM: dts: imx7: Fix Toradex Colibri iMX7S 256MB NAND flash support

Marek Szyprowski (1):
      clk: samsung: exynos5420: Keep top G3D clocks enabled

Marek Vasut (1):
      ARM: dts: imx6q-dhcom: Fix SGTL5000 VDDIO regulator connection

Mario Kleiner (1):
      drm/amd/display: Reorder detect_edp_sink_caps before link settings re=
ad.

Mark Rutland (1):
      perf: Correctly handle failed perf_get_aux_event()

Markus Theil (1):
      cfg80211: fix deadlocks in autodisconnect work

Martin Blumenstingl (4):
      ARM: dts: meson8: fix the size of the PMU registers
      soc: amlogic: meson-ee-pwrc: propagate PD provider registration errors
      soc: amlogic: meson-ee-pwrc: propagate errors from pm_genpd_init()
      dt-bindings: reset: meson8b: fix duplicate reset IDs

Martin KaFai Lau (1):
      bpftool: Fix printing incorrect pointer in btf_dump_ptr

Martin Wilck (1):
      scsi: qla2xxx: fix rports not being mark as lost in sync fabric scan

Masami Hiramatsu (1):
      perf probe: Fix wrong address verification

Michael Chan (3):
      bnxt_en: Fix NTUPLE firmware command failures.
      bnxt_en: Fix ipv6 RFS filter matching logic.
      bnxt_en: Do not treat DSN (Digital Serial Number) read failure as fat=
al.

Michael Grzeschik (1):
      net: phy: dp83867: Set FORCE_LINK_GOOD to default after reset

Miklos Szeredi (1):
      fuse: fix fuse_send_readpages() in the syncronous read case

Mikulas Patocka (1):
      block: fix an integer overflow in logical block size

Miquel Raynal (2):
      arm64: dts: marvell: Add AP806-dual missing CPU clocks
      arm64: dts: marvell: Fix CP110 NAND controller node multi-line commen=
t alignment

Mohammed Gamal (1):
      hv_netvsc: Fix memory leak when removing rndis device

Nathan Chancellor (1):
      xen/blkfront: Adjust indentation in xlvbd_alloc_gendisk

Navid Emamdoost (1):
      i40e: prevent memory leak in i40e_setup_macvlans

Olivier Moysan (2):
      ASoC: stm32: sai: fix possible circular locking
      ASoC: stm32: dfsdm: fix 16 bits record

Pablo Neira Ayuso (1):
      netfilter: nf_tables: store transaction list locally while requesting=
 module

Pan Bian (2):
      scsi: qla4xxx: fix double free bug
      scsi: bnx2i: fix potential use after free

Peng Fan (1):
      ARM: dts: imx7ulp: fix reg of cpu node

Pengcheng Yang (1):
      tcp: fix marked lost packets not being retransmitted

Petr Machata (3):
      mlxsw: spectrum: Wipe xstats.backlog of down ports
      mlxsw: spectrum_qdisc: Include MC TCs in Qdisc counters
      selftests: mlxsw: qos_mc_aware: Fix mausezahn invocation

Philipp Rudo (1):
      s390/setup: Fix secure ipl message

Qian Cai (1):
      x86/resctrl: Fix an imbalance in domain_remove_cpu()

Qu Wenruo (1):
      btrfs: relocation: fix reloc_root lifespan and access

Randy Dunlap (1):
      net: fix kernel-doc warning in <linux/netdevice.h>

Reinhard Speyerer (1):
      USB: serial: option: add support for Quectel RM500Q in QDL mode

Rob Clark (1):
      arm64: dts: qcom: sdm845-cheza: delete zap-shader

Rob Herring (1):
      dt-bindings: Add missing 'properties' keyword enclosing 'snps,tso'

Roman Gushchin (1):
      mm: memcg/slab: fix percpu slab vmstats flushing

S.j. Wang (1):
      arm64: dts: imx8mm-evk: Assigned clocks for audio plls

Sai Prakash Ranjan (1):
      arm64: dts: qcom: msm8998: Disable coresight by default

Sergei Shtylyov (3):
      sh_eth: check sh_eth_cpu_data::dual_port when dumping registers
      mtd: cfi_cmdset_0002: only check errors when ready in cfi_check_err_s=
tatus()
      mtd: cfi_cmdset_0002: fix delayed error detection on HyperFlash

Shakeel Butt (1):
      x86/resctrl: Fix potential memory leak

Stefan Mavrodiev (2):
      arm64: dts: allwinner: a64: olinuxino: Fix SDIO supply regulator
      arm64: dts: allwinner: a64: olinuxino: Fix eMMC supply regulator

Stephan Gerhold (5):
      ASoC: msm8916-wcd-digital: Reset RX interpolation path after use
      ASoC: msm8916-wcd-analog: Fix selected events for MIC BIAS External1
      ASoC: msm8916-wcd-analog: Fix MIC BIAS Internal1
      iio: imu: st_lsm6dsx: Fix selection of ST_LSM6DS3_ID
      regulator: ab8500: Remove SYSCLKREQ from enum ab8505_regulator_id

Sudeep Holla (1):
      Revert "arm64: dts: juno: add dma-ranges property"

Sven Eckelmann (1):
      batman-adv: Fix DAT candidate selection on little endian systems

Takashi Iwai (1):
      ALSA: seq: Fix racy access for queue timer in proc read

Takashi Sakamoto (2):
      ALSA: dice: fix fallback from protocol extension into limited functio=
nality
      ALSA: firewire-tascam: fix corruption due to spin lock without restor=
ation in SoftIRQ context

Tom Lendacky (1):
      x86/CPU/AMD: Ensure clearing of SME/SEV features is maintained

Tomasz Duszynski (1):
      iio: chemical: pms7003: fix unmet triggered buffer dependency

Tony Lindgren (3):
      bus: ti-sysc: Fix iterating over clocks
      ARM: OMAP2+: Fix ti_sysc_find_one_clockdomain to check for to_clk_hw_=
omap
      ARM: dts: Fix sgx sysconfig register for omap4

Tuong Lien (2):
      tipc: fix potential hanging after b/rcast changing
      tipc: fix retrans failure due to wrong destination

Tzu-En Huang (1):
      rtw88: fix potential read outside array boundary

Vignesh Raghavendra (1):
      mtd: spi-nor: Fix selection of 4-byte addressing opcodes on Spansion

Vladimir Oltean (1):
      net: dsa: sja1105: Don't error out on disabled ports with no phy-mode

Vladis Dronov (1):
      ptp: free ptp device pin descriptors properly

Vlastimil Babka (1):
      mm, debug_pagealloc: don't rely on static keys too early

Waiman Long (2):
      locking/rwsem: Fix kernel crash when spinning on RWSEM_OWNER_UNKNOWN
      locking/lockdep: Fix buffer overrun problem in stack_trace[]

Wen Yang (1):
      mm/page-writeback.c: avoid potential division by zero in wb_min_max_r=
atio()

Xiang Chen (3):
      scsi: hisi_sas: Don't create debugfs dump folder twice
      scsi: hisi_sas: Set the BIST init value before enabling BIST
      scsi: hisi_sas: Return directly if init hardware failed

Yang Shi (1):
      mm: khugepaged: add trace status description for SCAN_PAGE_HAS_PRIVATE

Yinbo Zhu (1):
      arm64: dts: ls1028a: fix endian setting for dcfg

Yonglong Liu (1):
      net: hns: fix soft lockup when there is not enough memory

YueHaibing (1):
      drm/i915: Add missing include file <linux/math64.h>

Yunsheng Lin (1):
      net: hns3: pad the short frame before sending to the hardware

Yuya Fujita (1):
      perf hists: Fix variable name's inconsistency in hists__for_each() ma=
cro

changzhu (1):
      drm/amdgpu: allow direct upload save restore list for raven2


--pWyiEgJYm5f9v55/
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl4pXXoACgkQONu9yGCS
aT4UuA/+NNejobEXshBjEucE91plP9f7prgz1VsD3Vm4EdS1xNUgB4iGRTpYHFR9
M5ZXTxXKuCQGjV4V2d+0NZsVna4dEX9I6ZrGckzPxXs50L/yXPtglnw+ckKpBkqI
P6BeUBoLeldD0gow305Cqtmi2cUr2ggvEbqHCQTbJi6rXwz4AQE9/RVp8UYbfpHk
zd0lLyPoZ/sspuL6AYy39SdhE/VLDE8xY/SS50NQ/rfoXUpe8rq5W5RAoKrA5Qh+
P9r+Lb5ScXvtN5mkV4enKSryzEzrWexWboXlRZfAPMoSlWPZ1/ftLx6f/aqfrQNE
p9owwU2+TVt20JOXcU3XgUc+eG9iQPM+95zQaHc/o8GC308JH4Np5OZU+AnAnFVK
5vXSvWcdTJ9rB1Fr41KVfa/18VmTsRmRp0icaRhhNQXpawuowR5mHBNXPs09mUjr
dIWzlQLq9Kwmve4pq+1rVMB4m//+zFjfmes3xd4cSo151UxG+uQbt8v/QNykYZkj
Q1XPHaTVQXCqDUXVX1LcO2hQWWdm3/lzlN3qeCe4UrgKOrLK0tMln6d3VIoSEHZp
4zeNveLyef4TOdLQEd1fjYpOT8KFEPVLjLC9OYxWW8nGsBzqTSktgwDImoe0qAdK
EPS++lwzAExE4LU1b/q9zhfBrLY5CX64Uz0gzVoLVbVuVBbWRJk=
=3qiF
-----END PGP SIGNATURE-----

--pWyiEgJYm5f9v55/--
