Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8237345C6A9
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 15:07:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349555AbhKXOKh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 09:10:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:53614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1355060AbhKXOI3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 09:08:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 297DD61B1B;
        Wed, 24 Nov 2021 12:47:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637758043;
        bh=eTPK96M5CB5MKGG5ZBzVtubEu3XZqOD1NkNRCS/d3+8=;
        h=From:To:Cc:Subject:Date:From;
        b=T1Ot6WQITn3NUdS4hPvjcZVUekZ3LJGLgRpsBc00/05mo5hUH9qQfgbCSfXQ4hASG
         pCjDr5jTxoko8FIYsThV4psLmQ1TzQfjvSYY0xvgJISFisWMtD2twQOjWI0wftYbLx
         HluW/b0g2HFjx+UfqRhoBv0wcUw8ib64dmtCZwKQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 5.4 000/100] 5.4.162-rc1 review
Date:   Wed, 24 Nov 2021 12:57:16 +0100
Message-Id: <20211124115654.849735859@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.162-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.162-rc1
X-KernelTest-Deadline: 2021-11-26T11:56+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.4.162 release.
There are 100 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 26 Nov 2021 11:56:36 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.162-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.4.162-rc1

Nadav Amit <namit@vmware.com>
    hugetlbfs: flush TLBs correctly after huge_pmd_unshare

Peter Zijlstra (Intel) <peterz@infradead.org>
    tlb: mmu_gather: add tlb_flush_*_range APIs

Leon Romanovsky <leonro@nvidia.com>
    ice: Delete always true check of PF pointer

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    usb: max-3421: Use driver data instead of maintaining a list of bound devices

Takashi Iwai <tiwai@suse.de>
    ASoC: DAPM: Cover regression by kctl change notification fix

Sven Eckelmann <sven@narfation.org>
    batman-adv: Don't always reallocate the fragmentation skb head

Sven Eckelmann <sven@narfation.org>
    batman-adv: Reserve needed_*room for fragments

Sven Eckelmann <sven@narfation.org>
    batman-adv: Consider fragmentation for needed_headroom

Greg Thelen <gthelen@google.com>
    perf/core: Avoid put_page() when GUP fails

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "net: mvpp2: disable force link UP during port init procedure"

hongao <hongao@uniontech.com>
    drm/amdgpu: fix set scaling mode Full/Full aspect/Center not works on vga and dvi connectors

Imre Deak <imre.deak@intel.com>
    drm/i915/dp: Ensure sink rate values are always valid

Jeremy Cline <jcline@redhat.com>
    drm/nouveau: use drm_dev_unplug() during device removal

Johan Hovold <johan@kernel.org>
    drm/udl: fix control-message timeout

Nguyen Dinh Phi <phind.uet@gmail.com>
    cfg80211: call cfg80211_stop_ap when switch from P2P_GO type

Sven Schnelle <svens@stackframe.org>
    parisc/sticon: fix reverse colors

Nikolay Borisov <nborisov@suse.com>
    btrfs: fix memory ordering between normal and ordered work functions

Jan Kara <jack@suse.cz>
    udf: Fix crash after seekdir

Baoquan He <bhe@redhat.com>
    s390/kexec: fix memory leak of ipl report buffer

Sean Christopherson <seanjc@google.com>
    x86/hyperv: Fix NULL deref in set_hv_tscchange_cb() if Hyper-V setup fails

Rustam Kovhaev <rkovhaev@gmail.com>
    mm: kmemleak: slob: respect SLAB_NOLEAKTRACE flag

Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>
    ipc: WARN if trying to remove ipc object which is absent

Nathan Chancellor <nathan@kernel.org>
    hexagon: export raw I/O routines for modules

Nicolas Dichtel <nicolas.dichtel@6wind.com>
    tun: fix bonding active backup with arp monitoring

Nick Desaulniers <ndesaulniers@google.com>
    arm64: vdso32: suppress error message for 'make mrproper'

Heiko Carstens <hca@linux.ibm.com>
    s390/kexec: fix return code handling

Alexander Antonov <alexander.antonov@linux.intel.com>
    perf/x86/intel/uncore: Fix IIO event constraints for Skylake Server

Alexander Antonov <alexander.antonov@linux.intel.com>
    perf/x86/intel/uncore: Fix filter_tid mask for CHA events on Skylake Server

Michael Ellerman <mpe@ellerman.id.au>
    KVM: PPC: Book3S HV: Use GLOBAL_TOC for kvmppc_h_set_dabr/xdabr()

Sohaib Mohamed <sohaib.amhmd@gmail.com>
    perf bench: Fix two memory leaks detected with ASan

Lin Ma <linma@zju.edu.cn>
    NFC: reorder the logic in nfc_{un,}register_device

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    drm/nouveau: hdmigv100.c: fix corrupted HDMI Vendor InfoFrame

Lin Ma <linma@zju.edu.cn>
    NFC: reorganize the functions in nci_request

Grzegorz Szczurek <grzegorzx.szczurek@intel.com>
    i40e: Fix display error code in dmesg

Jedrzej Jagielski <jedrzej.jagielski@intel.com>
    i40e: Fix creation of first queue by omitting it if is not power of two

Eryk Rybak <eryk.roch.rybak@intel.com>
    i40e: Fix ping is lost after configuring ADq on VF

Eryk Rybak <eryk.roch.rybak@intel.com>
    i40e: Fix changing previously set num_queue_pairs for PFs

Michal Maloszewski <michal.maloszewski@intel.com>
    i40e: Fix NULL ptr dereference on VSI filter sync

Eryk Rybak <eryk.roch.rybak@intel.com>
    i40e: Fix correct max_pkt_size on VF RX queue

Jonathan Davies <jonathan.davies@nutanix.com>
    net: virtio_net_hdr_to_skb: count transport header in UFO

Pavel Skripkin <paskripkin@gmail.com>
    net: dpaa2-eth: fix use-after-free in dpaa2_eth_remove

Xin Long <lucien.xin@gmail.com>
    net: sched: act_mirred: drop dst for the direction from egress to ingress

Mike Christie <michael.christie@oracle.com>
    scsi: core: sysfs: Fix hang when device state is set via sysfs

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    platform/x86: hp_accel: Fix an error handling path in 'lis3lv02d_probe()'

Randy Dunlap <rdunlap@infradead.org>
    mips: lantiq: add support for clk_get_parent()

Randy Dunlap <rdunlap@infradead.org>
    mips: bcm63xx: add support for clk_get_parent()

Colin Ian King <colin.i.king@googlemail.com>
    MIPS: generic/yamon-dt: fix uninitialized variable error

Surabhi Boob <surabhi.boob@intel.com>
    iavf: Fix for the false positive ASQ/ARQ errors while issuing VF reset

Mitch Williams <mitch.a.williams@intel.com>
    iavf: validate pointers

Jacob Keller <jacob.e.keller@intel.com>
    iavf: prevent accidental free of filter structure

Piotr Marczak <piotr.marczak@intel.com>
    iavf: Fix failure to exit out from last all-multicast mode

Nicholas Nunley <nicholas.d.nunley@intel.com>
    iavf: free q_vectors before queues in iavf_disable_vf

Nicholas Nunley <nicholas.d.nunley@intel.com>
    iavf: check for null in iavf_fix_features

Pavel Skripkin <paskripkin@gmail.com>
    net: bnx2x: fix variable dereferenced before check

James Clark <james.clark@arm.com>
    perf tests: Remove bash construct from record+zstd_comp_decomp.sh

Sohaib Mohamed <sohaib.amhmd@gmail.com>
    perf bench futex: Fix memory leak of perf_cpu_map__new()

Ian Rogers <irogers@google.com>
    perf bpf: Avoid memory leak from perf_env__insert_btf()

Leon Romanovsky <leonro@nvidia.com>
    RDMA/netlink: Add __maybe_unused to static inline in C file

Masami Hiramatsu <mhiramat@kernel.org>
    tracing/histogram: Do not copy the fixed-size char array field over the field size

Tom Zanussi <zanussi@kernel.org>
    tracing: Save normal string variables

Vincent Donnefort <vincent.donnefort@arm.com>
    sched/core: Mitigate race cpus_share_cache()/update_top_cache_domain()

Randy Dunlap <rdunlap@infradead.org>
    mips: BCM63XX: ensure that CPU_SUPPORTS_32BIT_KERNEL is set

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    clk: qcom: gcc-msm8996: Drop (again) gcc_aggre1_pnoc_ahb_clk

Joel Stanley <joel@jms.id.au>
    clk/ast2600: Fix soc revision for AHB

Paul Cercueil <paul@crapouillou.net>
    clk: ingenic: Fix bugs with divided dividers

Randy Dunlap <rdunlap@infradead.org>
    sh: define __BIG_ENDIAN for math-emu

Randy Dunlap <rdunlap@infradead.org>
    sh: math-emu: drop unused functions

Randy Dunlap <rdunlap@infradead.org>
    sh: fix kconfig unmet dependency warning for FRAME_POINTER

Gao Xiang <hsiangkao@linux.alibaba.com>
    f2fs: fix up f2fs_lookup tracepoints

Lu Wei <luwei32@huawei.com>
    maple: fix wrong return value of maple_bus_init().

Nick Desaulniers <ndesaulniers@google.com>
    sh: check return code of request_irq

Michael Ellerman <mpe@ellerman.id.au>
    powerpc/dcr: Use cmplwi instead of 3-argument cmpli

Chengfeng Ye <cyeaa@connect.ust.hk>
    ALSA: gus: fix null pointer dereference on pointer block

Anatolij Gustschin <agust@denx.de>
    powerpc/5200: dts: fix memory node unit name

Teng Qi <starmiku1207184332@gmail.com>
    iio: imu: st_lsm6dsx: Avoid potential array overflow in st_lsm6dsx_set_odr()

Mike Christie <michael.christie@oracle.com>
    scsi: target: Fix alua_tg_pt_gps_count tracking

Mike Christie <michael.christie@oracle.com>
    scsi: target: Fix ordered tag handling

Bart Van Assche <bvanassche@acm.org>
    MIPS: sni: Fix the build

Guanghui Feng <guanghuifeng@linux.alibaba.com>
    tty: tty_buffer: Fix the softlockup issue in flush_to_ldisc

Randy Dunlap <rdunlap@infradead.org>
    ALSA: ISA: not for M68K

Li Yang <leoyang.li@nxp.com>
    ARM: dts: ls1021a-tsn: use generic "jedec,spi-nor" compatible for flash

Li Yang <leoyang.li@nxp.com>
    ARM: dts: ls1021a: move thermal-zones node out of soc/

Yang Yingliang <yangyingliang@huawei.com>
    usb: host: ohci-tmio: check return value after calling platform_get_resource()

Roger Quadros <rogerq@kernel.org>
    ARM: dts: omap: fix gpmc,mux-add-data type

Luis Chamberlain <mcgrof@kernel.org>
    firmware_loader: fix pre-allocated buf built-in firmware use

Guo Zhi <qtxuning1999@sjtu.edu.cn>
    scsi: advansys: Fix kernel pointer leak

Hans de Goede <hdegoede@redhat.com>
    ASoC: nau8824: Add DMI quirk mechanism for active-high jack-detect

Stefan Riedmueller <s.riedmueller@phytec.de>
    clk: imx: imx6ul: Move csi_sel mux to correct base register

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    ASoC: SOF: Intel: hda-dai: fix potential locking issue

Michael Walle <michael@walle.cc>
    arm64: dts: freescale: fix arm,sp805 compatible string

Stephan Gerhold <stephan@gerhold.net>
    arm64: dts: qcom: msm8916: Add unit name for /soc node

AngeloGioacchino Del Regno <angelogioacchino.delregno@somainline.org>
    arm64: dts: qcom: msm8998: Fix CPU/L2 idle state latency and residency

Sven Peter <sven@svenpeter.dev>
    usb: typec: tipd: Remove WARN_ON in tps6598x_block_read

Yang Yingliang <yangyingliang@huawei.com>
    usb: musb: tusb6010: check return value after calling platform_get_resource()

Selvin Xavier <selvin.xavier@broadcom.com>
    RDMA/bnxt_re: Check if the vlan is valid before reporting

Michael Walle <michael@walle.cc>
    arm64: dts: hisilicon: fix arm,sp805 compatible string

James Smart <jsmart2021@gmail.com>
    scsi: lpfc: Fix list_add() corruption in lpfc_drain_txq()

Matthew Hagan <mnhagan88@gmail.com>
    ARM: dts: NSP: Fix mpcore, mmc node names

Michal Simek <michal.simek@xilinx.com>
    arm64: zynqmp: Fix serial compatible string

Amit Kumar Mahapatra <amit.kumar-mahapatra@xilinx.com>
    arm64: zynqmp: Do not duplicate flash partition label property


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/arm/boot/dts/bcm-nsp.dtsi                     |   4 +-
 arch/arm/boot/dts/ls1021a-tsn.dts                  |   2 +-
 arch/arm/boot/dts/ls1021a.dtsi                     |  66 ++++-----
 arch/arm/boot/dts/omap-gpmc-smsc9221.dtsi          |   2 +-
 arch/arm/boot/dts/omap3-overo-tobiduo-common.dtsi  |   2 +-
 arch/arm64/boot/dts/freescale/fsl-ls1088a.dtsi     |  16 +--
 arch/arm64/boot/dts/freescale/fsl-ls208xa.dtsi     |  16 +--
 arch/arm64/boot/dts/hisilicon/hi3660.dtsi          |   4 +-
 arch/arm64/boot/dts/hisilicon/hi6220.dtsi          |   2 +-
 arch/arm64/boot/dts/qcom/msm8916.dtsi              |   2 +-
 arch/arm64/boot/dts/qcom/msm8998.dtsi              |  20 +--
 .../boot/dts/xilinx/zynqmp-zc1751-xm016-dc2.dts    |   4 +-
 arch/arm64/boot/dts/xilinx/zynqmp.dtsi             |   4 +-
 arch/arm64/kernel/vdso32/Makefile                  |   3 +-
 arch/hexagon/lib/io.c                              |   4 +
 arch/mips/Kconfig                                  |   3 +
 arch/mips/bcm63xx/clk.c                            |   6 +
 arch/mips/generic/yamon-dt.c                       |   2 +-
 arch/mips/lantiq/clk.c                             |   6 +
 arch/mips/sni/time.c                               |   4 +-
 arch/powerpc/boot/dts/charon.dts                   |   2 +-
 arch/powerpc/boot/dts/digsy_mtc.dts                |   2 +-
 arch/powerpc/boot/dts/lite5200.dts                 |   2 +-
 arch/powerpc/boot/dts/lite5200b.dts                |   2 +-
 arch/powerpc/boot/dts/media5200.dts                |   2 +-
 arch/powerpc/boot/dts/mpc5200b.dtsi                |   2 +-
 arch/powerpc/boot/dts/o2d.dts                      |   2 +-
 arch/powerpc/boot/dts/o2d.dtsi                     |   2 +-
 arch/powerpc/boot/dts/o2dnt2.dts                   |   2 +-
 arch/powerpc/boot/dts/o3dnt.dts                    |   2 +-
 arch/powerpc/boot/dts/pcm032.dts                   |   2 +-
 arch/powerpc/boot/dts/tqm5200.dts                  |   2 +-
 arch/powerpc/kvm/book3s_hv_rmhandlers.S            |   4 +-
 arch/powerpc/sysdev/dcr-low.S                      |   2 +-
 arch/s390/include/asm/kexec.h                      |   6 +
 arch/s390/kernel/ipl.c                             |   3 +-
 arch/s390/kernel/machine_kexec_file.c              |  18 ++-
 arch/sh/Kconfig.debug                              |   1 +
 arch/sh/include/asm/sfp-machine.h                  |   8 ++
 arch/sh/kernel/cpu/sh4a/smp-shx3.c                 |   5 +-
 arch/sh/math-emu/math.c                            | 103 -------------
 arch/x86/events/intel/uncore_snbep.c               |   4 +
 arch/x86/hyperv/hv_init.c                          |   3 +
 drivers/base/firmware_loader/main.c                |  13 +-
 drivers/clk/clk-ast2600.c                          |  12 +-
 drivers/clk/imx/clk-imx6ul.c                       |   2 +-
 drivers/clk/ingenic/cgu.c                          |   6 +-
 drivers/clk/qcom/gcc-msm8996.c                     |  15 --
 drivers/gpu/drm/amd/amdgpu/amdgpu_connectors.c     |   1 +
 drivers/gpu/drm/i915/display/intel_dp.c            |  11 ++
 drivers/gpu/drm/nouveau/nouveau_drm.c              |   2 +-
 .../gpu/drm/nouveau/nvkm/engine/disp/hdmigv100.c   |   1 -
 drivers/gpu/drm/udl/udl_connector.c                |   2 +-
 drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c       |   6 +-
 drivers/infiniband/hw/bnxt_re/ib_verbs.c           |  12 +-
 .../net/ethernet/broadcom/bnx2x/bnx2x_init_ops.h   |   4 +-
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c   |   4 +-
 drivers/net/ethernet/intel/i40e/i40e.h             |   2 +
 drivers/net/ethernet/intel/i40e/i40e_main.c        | 160 +++++++++++++--------
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c |  70 +++------
 drivers/net/ethernet/intel/iavf/iavf_ethtool.c     |  13 +-
 drivers/net/ethernet/intel/iavf/iavf_main.c        |  14 +-
 drivers/net/ethernet/intel/ice/ice_main.c          |   3 -
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c    |  14 +-
 drivers/net/tun.c                                  |   5 +
 drivers/platform/x86/hp_accel.c                    |   2 +
 drivers/scsi/advansys.c                            |   4 +-
 drivers/scsi/lpfc/lpfc_sli.c                       |   1 +
 drivers/scsi/scsi_sysfs.c                          |  30 ++--
 drivers/sh/maple/maple.c                           |   5 +-
 drivers/target/target_core_alua.c                  |   1 -
 drivers/target/target_core_device.c                |   2 +
 drivers/target/target_core_internal.h              |   1 +
 drivers/target/target_core_transport.c             |  76 +++++++---
 drivers/tty/tty_buffer.c                           |   3 +
 drivers/usb/host/max3421-hcd.c                     |  25 +---
 drivers/usb/host/ohci-tmio.c                       |   2 +-
 drivers/usb/musb/tusb6010.c                        |   5 +
 drivers/usb/typec/tps6598x.c                       |   2 +-
 drivers/video/console/sticon.c                     |  12 +-
 fs/btrfs/async-thread.c                            |  14 ++
 fs/udf/dir.c                                       |  32 ++++-
 fs/udf/namei.c                                     |   3 +
 fs/udf/super.c                                     |   2 +
 include/asm-generic/tlb.h                          |  55 +++++--
 include/linux/virtio_net.h                         |   7 +-
 include/rdma/rdma_netlink.h                        |   2 +-
 include/target/target_core_base.h                  |   6 +-
 include/trace/events/f2fs.h                        |  12 +-
 ipc/util.c                                         |   6 +-
 kernel/events/core.c                               |  10 +-
 kernel/sched/core.c                                |   3 +
 kernel/trace/trace_events_hist.c                   |  41 +++++-
 mm/hugetlb.c                                       |  23 ++-
 mm/slab.h                                          |   2 +-
 net/batman-adv/fragmentation.c                     |  26 ++--
 net/batman-adv/hard-interface.c                    |   3 +
 net/nfc/core.c                                     |  32 +++--
 net/nfc/nci/core.c                                 |  11 +-
 net/sched/act_mirred.c                             |  11 +-
 net/wireless/util.c                                |   1 +
 sound/core/Makefile                                |   2 +
 sound/isa/Kconfig                                  |   2 +-
 sound/isa/gus/gus_dma.c                            |   2 +
 sound/pci/Kconfig                                  |   1 +
 sound/soc/codecs/nau8824.c                         |  40 ++++++
 sound/soc/soc-dapm.c                               |  29 +++-
 sound/soc/sof/intel/hda-dai.c                      |   7 +-
 tools/perf/bench/futex-lock-pi.c                   |   1 +
 tools/perf/bench/futex-requeue.c                   |   1 +
 tools/perf/bench/futex-wake-parallel.c             |   1 +
 tools/perf/bench/futex-wake.c                      |   1 +
 tools/perf/bench/sched-messaging.c                 |   4 +
 tools/perf/tests/shell/record+zstd_comp_decomp.sh  |   2 +-
 tools/perf/util/bpf-event.c                        |   6 +-
 tools/perf/util/env.c                              |   5 +-
 tools/perf/util/env.h                              |   2 +-
 118 files changed, 779 insertions(+), 529 deletions(-)


