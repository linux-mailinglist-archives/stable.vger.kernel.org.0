Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDA1A45EB63
	for <lists+stable@lfdr.de>; Fri, 26 Nov 2021 11:25:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376791AbhKZK23 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Nov 2021 05:28:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:60874 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1376721AbhKZK03 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Nov 2021 05:26:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8AEA86104F;
        Fri, 26 Nov 2021 10:23:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637922196;
        bh=l7uLkuXC7iEEoCfUmbPNANwoCDfTDGZhT2nIgbOf+gw=;
        h=From:To:Cc:Subject:Date:From;
        b=KCqEjlWPXtCY0pUj0DXfd0NAtMpR/35x9pd4qtZ7uHjtplcHzeFOt6ft44DsIDFOT
         wrLq0EwV/MQv71ltm8odT4f4YzYq6qBtNkRRhZ/oCtjKN6/9Ac7kgW2HYVMoS0UBs0
         p9hawsc26TmSQSrVDu5SESla/eK5Dg4r1AyPd1Ko=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.10.82
Date:   Fri, 26 Nov 2021 11:23:11 +0100
Message-Id: <163792219262239@kroah.com>
X-Mailer: git-send-email 2.34.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.10.82 kernel.

All users of the 5.10 kernel series must upgrade.

The updated 5.10.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.10.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                                   |    2 
 arch/arm/boot/dts/bcm-nsp.dtsi                             |    4 
 arch/arm/boot/dts/bcm53016-meraki-mr32.dts                 |   22 +
 arch/arm/boot/dts/ls1021a-tsn.dts                          |    2 
 arch/arm/boot/dts/ls1021a.dtsi                             |   66 ++--
 arch/arm/boot/dts/omap-gpmc-smsc9221.dtsi                  |    2 
 arch/arm/boot/dts/omap3-overo-tobiduo-common.dtsi          |    2 
 arch/arm/boot/dts/qcom-ipq8064-rb3011.dts                  |    6 
 arch/arm/boot/dts/ste-ux500-samsung-skomer.dts             |    8 
 arch/arm/boot/dts/sun8i-a33.dtsi                           |    4 
 arch/arm/boot/dts/sun8i-a83t.dtsi                          |    4 
 arch/arm/boot/dts/sun8i-h3.dtsi                            |    4 
 arch/arm64/boot/dts/allwinner/sun50i-a100.dtsi             |    6 
 arch/arm64/boot/dts/allwinner/sun50i-a64-cpu-opp.dtsi      |    2 
 arch/arm64/boot/dts/allwinner/sun50i-h5-cpu-opp.dtsi       |    2 
 arch/arm64/boot/dts/allwinner/sun50i-h5.dtsi               |    2 
 arch/arm64/boot/dts/allwinner/sun50i-h6-cpu-opp.dtsi       |    2 
 arch/arm64/boot/dts/freescale/fsl-ls1088a.dtsi             |   16 -
 arch/arm64/boot/dts/freescale/fsl-ls208xa.dtsi             |   16 -
 arch/arm64/boot/dts/hisilicon/hi3660.dtsi                  |    4 
 arch/arm64/boot/dts/hisilicon/hi6220.dtsi                  |    2 
 arch/arm64/boot/dts/qcom/ipq6018.dtsi                      |    2 
 arch/arm64/boot/dts/qcom/msm8998.dtsi                      |   20 -
 arch/arm64/boot/dts/rockchip/rk3399-pinebook-pro.dts       |    4 
 arch/arm64/boot/dts/xilinx/zynqmp-zc1751-xm016-dc2.dts     |    4 
 arch/arm64/boot/dts/xilinx/zynqmp.dtsi                     |    4 
 arch/arm64/kernel/vdso32/Makefile                          |    3 
 arch/hexagon/include/asm/timer-regs.h                      |   26 -
 arch/hexagon/include/asm/timex.h                           |    3 
 arch/hexagon/kernel/time.c                                 |   12 
 arch/hexagon/lib/io.c                                      |    4 
 arch/mips/Kconfig                                          |    3 
 arch/mips/bcm63xx/clk.c                                    |    6 
 arch/mips/generic/yamon-dt.c                               |    2 
 arch/mips/lantiq/clk.c                                     |    6 
 arch/mips/sni/time.c                                       |    4 
 arch/powerpc/boot/dts/charon.dts                           |    2 
 arch/powerpc/boot/dts/digsy_mtc.dts                        |    2 
 arch/powerpc/boot/dts/lite5200.dts                         |    2 
 arch/powerpc/boot/dts/lite5200b.dts                        |    2 
 arch/powerpc/boot/dts/media5200.dts                        |    2 
 arch/powerpc/boot/dts/mpc5200b.dtsi                        |    2 
 arch/powerpc/boot/dts/o2d.dts                              |    2 
 arch/powerpc/boot/dts/o2d.dtsi                             |    2 
 arch/powerpc/boot/dts/o2dnt2.dts                           |    2 
 arch/powerpc/boot/dts/o3dnt.dts                            |    2 
 arch/powerpc/boot/dts/pcm032.dts                           |    2 
 arch/powerpc/boot/dts/tqm5200.dts                          |    2 
 arch/powerpc/kernel/head_8xx.S                             |   13 
 arch/powerpc/kvm/book3s_hv_rmhandlers.S                    |    4 
 arch/powerpc/sysdev/dcr-low.S                              |    2 
 arch/s390/include/asm/kexec.h                              |    6 
 arch/s390/kernel/ipl.c                                     |    3 
 arch/s390/kernel/machine_kexec_file.c                      |   18 +
 arch/sh/Kconfig.debug                                      |    1 
 arch/sh/include/asm/sfp-machine.h                          |    8 
 arch/sh/kernel/cpu/sh4a/smp-shx3.c                         |    5 
 arch/sh/math-emu/math.c                                    |  103 -------
 arch/x86/Kconfig                                           |    3 
 arch/x86/events/intel/core.c                               |    4 
 arch/x86/events/intel/uncore_snbep.c                       |    4 
 arch/x86/hyperv/hv_init.c                                  |    3 
 arch/x86/kvm/vmx/nested.c                                  |   22 +
 block/blk-core.c                                           |    4 
 block/ioprio.c                                             |    9 
 drivers/base/firmware_loader/main.c                        |   13 
 drivers/bus/ti-sysc.c                                      |  110 +++++++
 drivers/clk/clk-ast2600.c                                  |   12 
 drivers/clk/imx/clk-imx6ul.c                               |    2 
 drivers/clk/ingenic/cgu.c                                  |    6 
 drivers/clk/qcom/gcc-msm8996.c                             |   15 -
 drivers/gpu/drm/amd/amdgpu/amdgpu_connectors.c             |    1 
 drivers/gpu/drm/amd/display/dc/dcn20/dcn20_resource.c      |    4 
 drivers/gpu/drm/amd/display/dc/dml/display_mode_enums.h    |    4 
 drivers/gpu/drm/i915/display/intel_dp.c                    |   11 
 drivers/gpu/drm/nouveau/nouveau_drm.c                      |   42 ++
 drivers/gpu/drm/nouveau/nouveau_drv.h                      |    5 
 drivers/gpu/drm/nouveau/nvkm/engine/disp/hdmigv100.c       |    1 
 drivers/gpu/drm/udl/udl_connector.c                        |    2 
 drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c               |    6 
 drivers/infiniband/hw/bnxt_re/ib_verbs.c                   |   12 
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_init_ops.h       |    4 
 drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c               |    2 
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c           |    4 
 drivers/net/ethernet/intel/e100.c                          |   18 -
 drivers/net/ethernet/intel/i40e/i40e.h                     |    2 
 drivers/net/ethernet/intel/i40e/i40e_main.c                |  160 +++++++----
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c         |  121 ++------
 drivers/net/ethernet/intel/iavf/iavf_ethtool.c             |   30 +-
 drivers/net/ethernet/intel/iavf/iavf_main.c                |   14 
 drivers/net/ethernet/intel/ice/ice_main.c                  |    3 
 drivers/net/ethernet/mellanox/mlx5/core/cq.c               |    5 
 drivers/net/ethernet/mellanox/mlx5/core/debugfs.c          |    4 
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c          |   11 
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.h          |    2 
 drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c |   28 -
 drivers/net/ethernet/mellanox/mlx5/core/lag.c              |   28 -
 drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c             |    5 
 drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c        |   24 +
 drivers/net/ipa/ipa_endpoint.c                             |    2 
 drivers/net/tun.c                                          |    5 
 drivers/pinctrl/qcom/pinctrl-sdm845.c                      |    1 
 drivers/platform/x86/hp_accel.c                            |    2 
 drivers/scsi/advansys.c                                    |    4 
 drivers/scsi/lpfc/lpfc_sli.c                               |    1 
 drivers/scsi/qla2xxx/qla_mbx.c                             |    6 
 drivers/scsi/scsi_debug.c                                  |   11 
 drivers/scsi/scsi_sysfs.c                                  |   30 +-
 drivers/scsi/ufs/ufshcd.c                                  |   57 +--
 drivers/scsi/ufs/ufshcd.h                                  |    1 
 drivers/sh/maple/maple.c                                   |    5 
 drivers/staging/rtl8723bs/core/rtw_mlme_ext.c              |    7 
 drivers/staging/rtl8723bs/core/rtw_recv.c                  |   10 
 drivers/staging/rtl8723bs/core/rtw_sta_mgt.c               |   22 -
 drivers/staging/rtl8723bs/core/rtw_xmit.c                  |   16 -
 drivers/staging/rtl8723bs/hal/rtl8723bs_xmit.c             |    2 
 drivers/staging/wfx/bus_sdio.c                             |   17 -
 drivers/target/target_core_alua.c                          |    1 
 drivers/target/target_core_device.c                        |    2 
 drivers/target/target_core_internal.h                      |    1 
 drivers/target/target_core_transport.c                     |   76 +++--
 drivers/tty/tty_buffer.c                                   |    3 
 drivers/usb/host/max3421-hcd.c                             |   25 -
 drivers/usb/host/ohci-tmio.c                               |    2 
 drivers/usb/musb/tusb6010.c                                |    5 
 drivers/usb/typec/tps6598x.c                               |    2 
 drivers/video/console/sticon.c                             |   12 
 fs/btrfs/async-thread.c                                    |   14 
 fs/btrfs/volumes.c                                         |   21 -
 fs/f2fs/f2fs.h                                             |    3 
 fs/f2fs/super.c                                            |    4 
 fs/inode.c                                                 |    7 
 fs/udf/dir.c                                               |   32 ++
 fs/udf/namei.c                                             |    3 
 fs/udf/super.c                                             |    2 
 include/linux/fs.h                                         |    2 
 include/linux/perf_event.h                                 |    1 
 include/linux/platform_data/ti-sysc.h                      |    1 
 include/linux/trace_events.h                               |    2 
 include/linux/virtio_net.h                                 |    7 
 include/net/nfc/nci_core.h                                 |    1 
 include/rdma/rdma_netlink.h                                |    2 
 include/sound/hdaudio_ext.h                                |    2 
 include/target/target_core_base.h                          |    6 
 include/trace/events/f2fs.h                                |   12 
 include/uapi/linux/tcp.h                                   |    2 
 ipc/util.c                                                 |    6 
 kernel/events/core.c                                       |  142 ++++-----
 kernel/sched/core.c                                        |    3 
 kernel/trace/trace_events_hist.c                           |   14 
 mm/hugetlb.c                                               |   23 +
 mm/slab.h                                                  |    2 
 net/core/sock.c                                            |  189 ++++++-------
 net/ipv4/tcp.c                                             |  122 ++++++--
 net/nfc/core.c                                             |   32 +-
 net/nfc/nci/core.c                                         |   34 +-
 net/sched/act_mirred.c                                     |   11 
 net/smc/smc_core.c                                         |    3 
 net/tipc/crypto.c                                          |    4 
 net/tipc/link.c                                            |    7 
 net/wireless/util.c                                        |    1 
 security/selinux/ss/hashtab.c                              |   17 -
 sound/core/Makefile                                        |    2 
 sound/hda/ext/hdac_ext_stream.c                            |   46 +--
 sound/hda/hdac_stream.c                                    |    4 
 sound/hda/intel-dsp-config.c                               |   22 +
 sound/isa/Kconfig                                          |    2 
 sound/isa/gus/gus_dma.c                                    |    2 
 sound/pci/Kconfig                                          |    1 
 sound/soc/codecs/nau8824.c                                 |   40 ++
 sound/soc/soc-dapm.c                                       |   29 +
 sound/soc/sof/intel/hda-dai.c                              |    7 
 tools/perf/bench/futex-lock-pi.c                           |    1 
 tools/perf/bench/futex-requeue.c                           |    1 
 tools/perf/bench/futex-wake-parallel.c                     |    1 
 tools/perf/bench/futex-wake.c                              |    1 
 tools/perf/tests/shell/record+zstd_comp_decomp.sh          |    2 
 tools/perf/util/bpf-event.c                                |    6 
 tools/perf/util/env.c                                      |    5 
 tools/perf/util/env.h                                      |    2 
 180 files changed, 1482 insertions(+), 982 deletions(-)

Adrian Hunter (2):
      scsi: ufs: core: Fix task management completion
      scsi: ufs: core: Fix task management completion timeout race

Alex Elder (1):
      net: ipa: disable HOLB drop when updating timer

Alexander Antonov (2):
      perf/x86/intel/uncore: Fix filter_tid mask for CHA events on Skylake Server
      perf/x86/intel/uncore: Fix IIO event constraints for Skylake Server

Alexander Mikhalitsyn (1):
      ipc: WARN if trying to remove ipc object which is absent

Alistair Delva (1):
      block: Check ADMIN before NICE for IOPRIO_CLASS_RT

Alvin Lee (1):
      drm/amd/display: Update swizzle mode enums

Amit Kumar Mahapatra (1):
      arm64: zynqmp: Do not duplicate flash partition label property

Anatolij Gustschin (1):
      powerpc/5200: dts: fix memory node unit name

AngeloGioacchino Del Regno (1):
      arm64: dts: qcom: msm8998: Fix CPU/L2 idle state latency and residency

Arjun Roy (3):
      net-zerocopy: Copy straggler unaligned data for TCP Rx. zerocopy.
      net-zerocopy: Refactor skb frag fast-forward op.
      tcp: Fix uninitialized access in skb frags array for Rx 0cp.

Baoquan He (1):
      s390/kexec: fix memory leak of ipl report buffer

Bart Van Assche (1):
      MIPS: sni: Fix the build

Bjorn Andersson (1):
      pinctrl: qcom: sdm845: Enable dual edge errata

Bongsu Jeon (1):
      net: nfc: nci: Change the NCI close sequence

Chao Yu (1):
      f2fs: fix incorrect return value in f2fs_sanity_check_ckpt()

Chengfeng Ye (1):
      ALSA: gus: fix null pointer dereference on pointer block

Christian Lamparter (1):
      ARM: BCM53016: Specify switch ports for Meraki MR32

Christophe JAILLET (1):
      platform/x86: hp_accel: Fix an error handling path in 'lis3lv02d_probe()'

Christophe Leroy (2):
      powerpc/8xx: Fix Oops with STRICT_KERNEL_RWX without DEBUG_RODATA_TEST
      powerpc/8xx: Fix pinned TLBs with CONFIG_STRICT_KERNEL_RWX

Colin Ian King (1):
      MIPS: generic/yamon-dt: fix uninitialized variable error

David Heidelberg (1):
      ARM: dts: qcom: fix memory and mdio nodes naming for RB3011

Dmitry Baryshkov (1):
      clk: qcom: gcc-msm8996: Drop (again) gcc_aggre1_pnoc_ahb_clk

Eric Dumazet (1):
      net: reduce indentation level in sk_clone_lock()

Eryk Rybak (3):
      i40e: Fix correct max_pkt_size on VF RX queue
      i40e: Fix changing previously set num_queue_pairs for PFs
      i40e: Fix ping is lost after configuring ADq on VF

Ewan D. Milne (1):
      scsi: qla2xxx: Fix mailbox direction flags in qla2xxx_get_adapter_id()

Fabio Aiuto (1):
      staging: rtl8723bs: remove possible deadlock when disconnect (v2)

Gao Xiang (1):
      f2fs: fix up f2fs_lookup tracepoints

Greg Kroah-Hartman (1):
      Linux 5.10.82

Grzegorz Szczurek (2):
      iavf: Fix for setting queues to 0
      i40e: Fix display error code in dmesg

Guanghui Feng (1):
      tty: tty_buffer: Fix the softlockup issue in flush_to_ldisc

Guo Zhi (1):
      scsi: advansys: Fix kernel pointer leak

Hans Verkuil (1):
      drm/nouveau: hdmigv100.c: fix corrupted HDMI Vendor InfoFrame

Hans de Goede (1):
      ASoC: nau8824: Add DMI quirk mechanism for active-high jack-detect

Heiko Carstens (1):
      s390/kexec: fix return code handling

Hyeong-Jun Kim (1):
      f2fs: compress: disallow disabling compress on non-empty compressed file

Ian Rogers (1):
      perf bpf: Avoid memory leak from perf_env__insert_btf()

Imre Deak (1):
      drm/i915/dp: Ensure sink rate values are always valid

Jacob Keller (1):
      iavf: prevent accidental free of filter structure

James Clark (1):
      perf tests: Remove bash construct from record+zstd_comp_decomp.sh

James Smart (1):
      scsi: lpfc: Fix list_add() corruption in lpfc_drain_txq()

Jan Kara (1):
      udf: Fix crash after seekdir

Jedrzej Jagielski (1):
      i40e: Fix creation of first queue by omitting it if is not power of two

Jeremy Cline (3):
      drm/nouveau: Add a dedicated mutex for the clients list
      drm/nouveau: use drm_dev_unplug() during device removal
      drm/nouveau: clean up all clients on device removal

Jesse Brandeburg (1):
      e100: fix device suspend/resume

Joel Stanley (1):
      clk/ast2600: Fix soc revision for AHB

Johan Hovold (1):
      drm/udl: fix control-message timeout

Jonathan Davies (1):
      net: virtio_net_hdr_to_skb: count transport header in UFO

Josef Bacik (2):
      fs: export an inode_update_time helper
      btrfs: update device path inode time instead of bd_inode

Jérôme Pouiller (1):
      staging: wfx: ensure IRQ is ready before enabling it

Karen Sornek (1):
      i40e: Fix warning message and call stack during rmmod i40e driver

Keoseong Park (1):
      f2fs: fix to use WHINT_MODE

Laibin Qiu (1):
      blkcg: Remove extra blkcg_bio_issue_init

Leon Romanovsky (2):
      RDMA/netlink: Add __maybe_unused to static inline in C file
      ice: Delete always true check of PF pointer

Li Yang (2):
      ARM: dts: ls1021a: move thermal-zones node out of soc/
      ARM: dts: ls1021a-tsn: use generic "jedec,spi-nor" compatible for flash

Like Xu (1):
      perf/x86/vlbr: Add c->flags to vlbr event constraints

Lin Ma (3):
      NFC: reorganize the functions in nci_request
      NFC: reorder the logic in nfc_{un,}register_device
      NFC: add NCI_UNREG flag to eliminate the race

Linus Walleij (1):
      ARM: dts: ux500: Skomer regulator fixes

Lu Wei (1):
      maple: fix wrong return value of maple_bus_init().

Luis Chamberlain (1):
      firmware_loader: fix pre-allocated buf built-in firmware use

Maher Sanalla (1):
      net/mlx5: Lag, update tracker when state change event received

Masami Hiramatsu (1):
      tracing/histogram: Do not copy the fixed-size char array field over the field size

Mateusz Palczewski (1):
      iavf: Fix return of set the new channel count

Matthew Hagan (1):
      ARM: dts: NSP: Fix mpcore, mmc node names

Matthias Brugger (1):
      arm64: dts: rockchip: Disable CDN DP on Pinebook Pro

Maxim Levitsky (1):
      KVM: nVMX: don't use vcpu->arch.efer when checking host state on nested state load

Maxime Ripard (3):
      ARM: dts: sunxi: Fix OPPs node name
      arm64: dts: allwinner: h5: Fix GPU thermal zone node name
      arm64: dts: allwinner: a100: Fix thermal zone node name

Meng Li (1):
      net: stmmac: socfpga: add runtime suspend/resume callback for stratix10 platform

Michael Ellerman (2):
      powerpc/dcr: Use cmplwi instead of 3-argument cmpli
      KVM: PPC: Book3S HV: Use GLOBAL_TOC for kvmppc_h_set_dabr/xdabr()

Michael Walle (2):
      arm64: dts: hisilicon: fix arm,sp805 compatible string
      arm64: dts: freescale: fix arm,sp805 compatible string

Michal Maloszewski (1):
      i40e: Fix NULL ptr dereference on VSI filter sync

Michal Simek (1):
      arm64: zynqmp: Fix serial compatible string

Mike Christie (3):
      scsi: target: Fix ordered tag handling
      scsi: target: Fix alua_tg_pt_gps_count tracking
      scsi: core: sysfs: Fix hang when device state is set via sysfs

Mitch Williams (1):
      iavf: validate pointers

Nadav Amit (1):
      hugetlbfs: flush TLBs correctly after huge_pmd_unshare

Nathan Chancellor (2):
      hexagon: export raw I/O routines for modules
      hexagon: clean up timer-regs.h

Nguyen Dinh Phi (1):
      cfg80211: call cfg80211_stop_ap when switch from P2P_GO type

Nicholas Nunley (2):
      iavf: check for null in iavf_fix_features
      iavf: free q_vectors before queues in iavf_disable_vf

Nick Desaulniers (2):
      sh: check return code of request_irq
      arm64: vdso32: suppress error message for 'make mrproper'

Nicolas Dichtel (1):
      tun: fix bonding active backup with arp monitoring

Nikolay Borisov (1):
      btrfs: fix memory ordering between normal and ordered work functions

Ondrej Mosnacek (1):
      selinux: fix NULL-pointer dereference when hashtab allocation fails

Paul Cercueil (1):
      clk: ingenic: Fix bugs with divided dividers

Pavel Skripkin (2):
      net: bnx2x: fix variable dereferenced before check
      net: dpaa2-eth: fix use-after-free in dpaa2_eth_remove

Pierre-Louis Bossart (4):
      ASoC: SOF: Intel: hda-dai: fix potential locking issue
      ALSA: intel-dsp-config: add quirk for APL/GLK/TGL devices based on ES8336 codec
      ALSA: hda: hdac_ext_stream: fix potential locking issues
      ALSA: hda: hdac_stream: fix potential locking issue in snd_hdac_stream_assign()

Piotr Marczak (1):
      iavf: Fix failure to exit out from last all-multicast mode

Punit Agrawal (1):
      net: stmmac: dwmac-rk: Fix ethernet on rk3399 based devices

Raed Salem (1):
      net/mlx5: E-Switch, return error if encap isn't supported

Randy Dunlap (8):
      ALSA: ISA: not for M68K
      sh: fix kconfig unmet dependency warning for FRAME_POINTER
      sh: math-emu: drop unused functions
      sh: define __BIG_ENDIAN for math-emu
      mips: BCM63XX: ensure that CPU_SUPPORTS_32BIT_KERNEL is set
      mips: bcm63xx: add support for clk_get_parent()
      mips: lantiq: add support for clk_get_parent()
      x86/Kconfig: Fix an unused variable error in dell-smm-hwmon

Roger Quadros (1):
      ARM: dts: omap: fix gpmc,mux-add-data type

Roi Dayan (1):
      net/mlx5: E-Switch, Change mode lock from mutex to rw semaphore

Rustam Kovhaev (1):
      mm: kmemleak: slob: respect SLAB_NOLEAKTRACE flag

Sasha Levin (1):
      Revert "perf: Rework perf_event_exit_event()"

Sean Christopherson (1):
      x86/hyperv: Fix NULL deref in set_hv_tscchange_cb() if Hyper-V setup fails

Selvin Xavier (1):
      RDMA/bnxt_re: Check if the vlan is valid before reporting

Shawn Guo (1):
      arm64: dts: qcom: ipq6018: Fix qcom,controlled-remotely property

Sohaib Mohamed (1):
      perf bench futex: Fix memory leak of perf_cpu_map__new()

Sriharsha Basavapatna (1):
      bnxt_en: reject indirect blk offload when hw-tc-offload is off

Stefan Riedmueller (1):
      clk: imx: imx6ul: Move csi_sel mux to correct base register

Steven Rostedt (VMware) (1):
      tracing: Add length protection to histogram string copies

Surabhi Boob (1):
      iavf: Fix for the false positive ASQ/ARQ errors while issuing VF reset

Sven Peter (1):
      usb: typec: tipd: Remove WARN_ON in tps6598x_block_read

Sven Schnelle (1):
      parisc/sticon: fix reverse colors

Tadeusz Struk (1):
      tipc: check for null after calling kmemdup

Takashi Iwai (1):
      ASoC: DAPM: Cover regression by kctl change notification fix

Teng Qi (1):
      iio: imu: st_lsm6dsx: Avoid potential array overflow in st_lsm6dsx_set_odr()

Tetsuo Handa (1):
      sock: fix /proc/net/sockstat underflow in sk_clone_lock()

Tony Lindgren (2):
      bus: ti-sysc: Add quirk handling for reinit on context lost
      bus: ti-sysc: Use context lost quirk for otg

Uwe Kleine-König (1):
      usb: max-3421: Use driver data instead of maintaining a list of bound devices

Valentine Fatiev (1):
      net/mlx5e: nullify cq->dbg pointer in mlx5_debug_cq_remove()

Vincent Donnefort (1):
      sched/core: Mitigate race cpus_share_cache()/update_top_cache_domain()

Wen Gu (1):
      net/smc: Make sure the link_id is unique

Xin Long (2):
      tipc: only accept encrypted MSG_CRYPTO msgs
      net: sched: act_mirred: drop dst for the direction from egress to ingress

Yang Yingliang (2):
      usb: musb: tusb6010: check return value after calling platform_get_resource()
      usb: host: ohci-tmio: check return value after calling platform_get_resource()

Ye Bin (2):
      scsi: scsi_debug: Fix out-of-bound read in resp_readcap16()
      scsi: scsi_debug: Fix out-of-bound read in resp_report_tgtpgs()

hongao (1):
      drm/amdgpu: fix set scaling mode Full/Full aspect/Center not works on vga and dvi connectors

