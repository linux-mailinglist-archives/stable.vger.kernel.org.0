Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86C9B45EB68
	for <lists+stable@lfdr.de>; Fri, 26 Nov 2021 11:25:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376724AbhKZK2i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Nov 2021 05:28:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:60930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1376729AbhKZK0h (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Nov 2021 05:26:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E803361155;
        Fri, 26 Nov 2021 10:23:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637922204;
        bh=wDfqV+dkgrJlqoONslOPKm2bMwn8EXSMdaOMo39mSY8=;
        h=From:To:Cc:Subject:Date:From;
        b=oENZE9I0waSGCBgD0oVJ7MuYCdW/BDHDunEMitOWPtjGG6exHOJozFHT4IHSRKYcQ
         vg7mX00oiSaLs4L+aSOnSqH2Y+3r/8HoK6Y8lIP3g4jC4O5FrZSe0ommY9eK9E77UB
         t5oDOaR3oAW3zxRMTEIN0kk5LVzL7jWlOxYbKu6s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.4.162
Date:   Fri, 26 Nov 2021 11:23:16 +0100
Message-Id: <1637922196223198@kroah.com>
X-Mailer: git-send-email 2.34.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.4.162 kernel.

All users of the 5.4 kernel series must upgrade.

The updated 5.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                               |    2 
 arch/arm/boot/dts/bcm-nsp.dtsi                         |    4 
 arch/arm/boot/dts/ls1021a-tsn.dts                      |    2 
 arch/arm/boot/dts/ls1021a.dtsi                         |   66 +++----
 arch/arm/boot/dts/omap-gpmc-smsc9221.dtsi              |    2 
 arch/arm/boot/dts/omap3-overo-tobiduo-common.dtsi      |    2 
 arch/arm64/boot/dts/freescale/fsl-ls1088a.dtsi         |   16 -
 arch/arm64/boot/dts/freescale/fsl-ls208xa.dtsi         |   16 -
 arch/arm64/boot/dts/hisilicon/hi3660.dtsi              |    4 
 arch/arm64/boot/dts/hisilicon/hi6220.dtsi              |    2 
 arch/arm64/boot/dts/qcom/msm8998.dtsi                  |   20 +-
 arch/arm64/boot/dts/xilinx/zynqmp-zc1751-xm016-dc2.dts |    4 
 arch/arm64/boot/dts/xilinx/zynqmp.dtsi                 |    4 
 arch/arm64/kernel/vdso32/Makefile                      |    3 
 arch/hexagon/lib/io.c                                  |    4 
 arch/mips/Kconfig                                      |    3 
 arch/mips/bcm63xx/clk.c                                |    6 
 arch/mips/generic/yamon-dt.c                           |    2 
 arch/mips/lantiq/clk.c                                 |    6 
 arch/mips/sni/time.c                                   |    4 
 arch/powerpc/boot/dts/charon.dts                       |    2 
 arch/powerpc/boot/dts/digsy_mtc.dts                    |    2 
 arch/powerpc/boot/dts/lite5200.dts                     |    2 
 arch/powerpc/boot/dts/lite5200b.dts                    |    2 
 arch/powerpc/boot/dts/media5200.dts                    |    2 
 arch/powerpc/boot/dts/mpc5200b.dtsi                    |    2 
 arch/powerpc/boot/dts/o2d.dts                          |    2 
 arch/powerpc/boot/dts/o2d.dtsi                         |    2 
 arch/powerpc/boot/dts/o2dnt2.dts                       |    2 
 arch/powerpc/boot/dts/o3dnt.dts                        |    2 
 arch/powerpc/boot/dts/pcm032.dts                       |    2 
 arch/powerpc/boot/dts/tqm5200.dts                      |    2 
 arch/powerpc/kvm/book3s_hv_rmhandlers.S                |    4 
 arch/powerpc/sysdev/dcr-low.S                          |    2 
 arch/s390/include/asm/kexec.h                          |    6 
 arch/s390/kernel/ipl.c                                 |    3 
 arch/s390/kernel/machine_kexec_file.c                  |   18 +
 arch/sh/Kconfig.debug                                  |    1 
 arch/sh/include/asm/sfp-machine.h                      |    8 
 arch/sh/kernel/cpu/sh4a/smp-shx3.c                     |    5 
 arch/sh/math-emu/math.c                                |  103 ----------
 arch/x86/events/intel/uncore_snbep.c                   |    4 
 arch/x86/hyperv/hv_init.c                              |    3 
 drivers/base/firmware_loader/main.c                    |   13 -
 drivers/clk/clk-ast2600.c                              |   12 -
 drivers/clk/imx/clk-imx6ul.c                           |    2 
 drivers/clk/ingenic/cgu.c                              |    6 
 drivers/clk/qcom/gcc-msm8996.c                         |   15 -
 drivers/gpu/drm/amd/amdgpu/amdgpu_connectors.c         |    1 
 drivers/gpu/drm/i915/display/intel_dp.c                |   11 +
 drivers/gpu/drm/nouveau/nouveau_drm.c                  |    2 
 drivers/gpu/drm/nouveau/nvkm/engine/disp/hdmigv100.c   |    1 
 drivers/gpu/drm/udl/udl_connector.c                    |    2 
 drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c           |    6 
 drivers/infiniband/hw/bnxt_re/ib_verbs.c               |   12 -
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_init_ops.h   |    4 
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c       |    4 
 drivers/net/ethernet/intel/i40e/i40e.h                 |    2 
 drivers/net/ethernet/intel/i40e/i40e_main.c            |  160 +++++++++++------
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c     |   70 ++-----
 drivers/net/ethernet/intel/iavf/iavf_ethtool.c         |   13 -
 drivers/net/ethernet/intel/iavf/iavf_main.c            |   14 -
 drivers/net/ethernet/intel/ice/ice_main.c              |    3 
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c        |   14 -
 drivers/net/tun.c                                      |    5 
 drivers/platform/x86/hp_accel.c                        |    2 
 drivers/scsi/advansys.c                                |    4 
 drivers/scsi/lpfc/lpfc_sli.c                           |    1 
 drivers/scsi/scsi_sysfs.c                              |   30 ++-
 drivers/sh/maple/maple.c                               |    5 
 drivers/target/target_core_alua.c                      |    1 
 drivers/target/target_core_device.c                    |    2 
 drivers/target/target_core_internal.h                  |    1 
 drivers/target/target_core_transport.c                 |   76 +++++---
 drivers/tty/tty_buffer.c                               |    3 
 drivers/usb/host/max3421-hcd.c                         |   25 --
 drivers/usb/host/ohci-tmio.c                           |    2 
 drivers/usb/musb/tusb6010.c                            |    5 
 drivers/usb/typec/tps6598x.c                           |    2 
 drivers/video/console/sticon.c                         |   12 -
 fs/btrfs/async-thread.c                                |   14 +
 fs/udf/dir.c                                           |   32 +++
 fs/udf/namei.c                                         |    3 
 fs/udf/super.c                                         |    2 
 include/asm-generic/tlb.h                              |   55 ++++-
 include/linux/virtio_net.h                             |    7 
 include/rdma/rdma_netlink.h                            |    2 
 include/sound/hdaudio_ext.h                            |    2 
 include/target/target_core_base.h                      |    6 
 include/trace/events/f2fs.h                            |   12 -
 ipc/util.c                                             |    6 
 kernel/events/core.c                                   |   10 -
 kernel/sched/core.c                                    |    3 
 kernel/trace/trace_events_hist.c                       |   41 +++-
 mm/hugetlb.c                                           |   23 ++
 mm/slab.h                                              |    2 
 net/batman-adv/fragmentation.c                         |   26 +-
 net/batman-adv/hard-interface.c                        |    3 
 net/nfc/core.c                                         |   32 +--
 net/nfc/nci/core.c                                     |   11 -
 net/sched/act_mirred.c                                 |   11 -
 net/wireless/util.c                                    |    1 
 sound/core/Makefile                                    |    2 
 sound/hda/ext/hdac_ext_stream.c                        |   46 ++--
 sound/hda/hdac_stream.c                                |    4 
 sound/isa/Kconfig                                      |    2 
 sound/isa/gus/gus_dma.c                                |    2 
 sound/pci/Kconfig                                      |    1 
 sound/soc/codecs/nau8824.c                             |   40 ++++
 sound/soc/soc-dapm.c                                   |   29 ++-
 sound/soc/sof/intel/hda-dai.c                          |    7 
 tools/perf/bench/futex-lock-pi.c                       |    1 
 tools/perf/bench/futex-requeue.c                       |    1 
 tools/perf/bench/futex-wake-parallel.c                 |    1 
 tools/perf/bench/futex-wake.c                          |    1 
 tools/perf/tests/shell/record+zstd_comp_decomp.sh      |    2 
 tools/perf/util/bpf-event.c                            |    6 
 tools/perf/util/env.c                                  |    5 
 tools/perf/util/env.h                                  |    2 
 119 files changed, 805 insertions(+), 547 deletions(-)

Alexander Antonov (2):
      perf/x86/intel/uncore: Fix filter_tid mask for CHA events on Skylake Server
      perf/x86/intel/uncore: Fix IIO event constraints for Skylake Server

Alexander Mikhalitsyn (1):
      ipc: WARN if trying to remove ipc object which is absent

Amit Kumar Mahapatra (1):
      arm64: zynqmp: Do not duplicate flash partition label property

Anatolij Gustschin (1):
      powerpc/5200: dts: fix memory node unit name

AngeloGioacchino Del Regno (1):
      arm64: dts: qcom: msm8998: Fix CPU/L2 idle state latency and residency

Baoquan He (1):
      s390/kexec: fix memory leak of ipl report buffer

Bart Van Assche (1):
      MIPS: sni: Fix the build

Chengfeng Ye (1):
      ALSA: gus: fix null pointer dereference on pointer block

Christophe JAILLET (1):
      platform/x86: hp_accel: Fix an error handling path in 'lis3lv02d_probe()'

Colin Ian King (1):
      MIPS: generic/yamon-dt: fix uninitialized variable error

Dmitry Baryshkov (1):
      clk: qcom: gcc-msm8996: Drop (again) gcc_aggre1_pnoc_ahb_clk

Eryk Rybak (3):
      i40e: Fix correct max_pkt_size on VF RX queue
      i40e: Fix changing previously set num_queue_pairs for PFs
      i40e: Fix ping is lost after configuring ADq on VF

Gao Xiang (1):
      f2fs: fix up f2fs_lookup tracepoints

Greg Kroah-Hartman (2):
      Revert "net: mvpp2: disable force link UP during port init procedure"
      Linux 5.4.162

Greg Thelen (1):
      perf/core: Avoid put_page() when GUP fails

Grzegorz Szczurek (1):
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

Jeremy Cline (1):
      drm/nouveau: use drm_dev_unplug() during device removal

Joel Stanley (1):
      clk/ast2600: Fix soc revision for AHB

Johan Hovold (1):
      drm/udl: fix control-message timeout

Jonathan Davies (1):
      net: virtio_net_hdr_to_skb: count transport header in UFO

Leon Romanovsky (2):
      RDMA/netlink: Add __maybe_unused to static inline in C file
      ice: Delete always true check of PF pointer

Li Yang (2):
      ARM: dts: ls1021a: move thermal-zones node out of soc/
      ARM: dts: ls1021a-tsn: use generic "jedec,spi-nor" compatible for flash

Lin Ma (2):
      NFC: reorganize the functions in nci_request
      NFC: reorder the logic in nfc_{un,}register_device

Lu Wei (1):
      maple: fix wrong return value of maple_bus_init().

Luis Chamberlain (1):
      firmware_loader: fix pre-allocated buf built-in firmware use

Masami Hiramatsu (1):
      tracing/histogram: Do not copy the fixed-size char array field over the field size

Matthew Hagan (1):
      ARM: dts: NSP: Fix mpcore, mmc node names

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

Nathan Chancellor (1):
      hexagon: export raw I/O routines for modules

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

Paul Cercueil (1):
      clk: ingenic: Fix bugs with divided dividers

Pavel Skripkin (2):
      net: bnx2x: fix variable dereferenced before check
      net: dpaa2-eth: fix use-after-free in dpaa2_eth_remove

Peter Zijlstra (Intel) (1):
      tlb: mmu_gather: add tlb_flush_*_range APIs

Pierre-Louis Bossart (3):
      ASoC: SOF: Intel: hda-dai: fix potential locking issue
      ALSA: hda: hdac_ext_stream: fix potential locking issues
      ALSA: hda: hdac_stream: fix potential locking issue in snd_hdac_stream_assign()

Piotr Marczak (1):
      iavf: Fix failure to exit out from last all-multicast mode

Randy Dunlap (7):
      ALSA: ISA: not for M68K
      sh: fix kconfig unmet dependency warning for FRAME_POINTER
      sh: math-emu: drop unused functions
      sh: define __BIG_ENDIAN for math-emu
      mips: BCM63XX: ensure that CPU_SUPPORTS_32BIT_KERNEL is set
      mips: bcm63xx: add support for clk_get_parent()
      mips: lantiq: add support for clk_get_parent()

Roger Quadros (1):
      ARM: dts: omap: fix gpmc,mux-add-data type

Rustam Kovhaev (1):
      mm: kmemleak: slob: respect SLAB_NOLEAKTRACE flag

Sean Christopherson (1):
      x86/hyperv: Fix NULL deref in set_hv_tscchange_cb() if Hyper-V setup fails

Selvin Xavier (1):
      RDMA/bnxt_re: Check if the vlan is valid before reporting

Sohaib Mohamed (1):
      perf bench futex: Fix memory leak of perf_cpu_map__new()

Stefan Riedmueller (1):
      clk: imx: imx6ul: Move csi_sel mux to correct base register

Surabhi Boob (1):
      iavf: Fix for the false positive ASQ/ARQ errors while issuing VF reset

Sven Eckelmann (3):
      batman-adv: Consider fragmentation for needed_headroom
      batman-adv: Reserve needed_*room for fragments
      batman-adv: Don't always reallocate the fragmentation skb head

Sven Peter (1):
      usb: typec: tipd: Remove WARN_ON in tps6598x_block_read

Sven Schnelle (1):
      parisc/sticon: fix reverse colors

Takashi Iwai (1):
      ASoC: DAPM: Cover regression by kctl change notification fix

Teng Qi (1):
      iio: imu: st_lsm6dsx: Avoid potential array overflow in st_lsm6dsx_set_odr()

Tom Zanussi (1):
      tracing: Save normal string variables

Uwe Kleine-König (1):
      usb: max-3421: Use driver data instead of maintaining a list of bound devices

Vincent Donnefort (1):
      sched/core: Mitigate race cpus_share_cache()/update_top_cache_domain()

Xin Long (1):
      net: sched: act_mirred: drop dst for the direction from egress to ingress

Yang Yingliang (2):
      usb: musb: tusb6010: check return value after calling platform_get_resource()
      usb: host: ohci-tmio: check return value after calling platform_get_resource()

hongao (1):
      drm/amdgpu: fix set scaling mode Full/Full aspect/Center not works on vga and dvi connectors

