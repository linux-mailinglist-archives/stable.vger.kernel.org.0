Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6B49276087
	for <lists+stable@lfdr.de>; Wed, 23 Sep 2020 20:55:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726727AbgIWSzF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Sep 2020 14:55:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:42330 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726672AbgIWSzB (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 23 Sep 2020 14:55:01 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E456721D92;
        Wed, 23 Sep 2020 18:54:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600887298;
        bh=Bjy1msjgT96z4Us4w3Vqc3BW14CoGqCTEZZm/93w2DM=;
        h=From:To:Cc:Subject:Date:From;
        b=XmOQ77j2MZey8Ho7QGGrEwHnENM+ZA0xuSW3F2Do1aCOvpysQNnTDdaoglX5rVMOi
         njuYXSg+G1gvc1uZjqqTH/MxZZ1QJkuCuAwVdKV1tVAd8eskLgsW7FRnL/WGAWdFKL
         0KNZDcVgPxLQG94qODqTuWK6GmDx3ia6oYl19264=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.8.11
Date:   Wed, 23 Sep 2020 20:55:12 +0200
Message-Id: <160088731268131@kroah.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.8.11 kernel.

All users of the 5.8 kernel series must upgrade.

The updated 5.8.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.8.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/devicetree/bindings/pci/intel-gw-pcie.yaml    |    8 
 Documentation/devicetree/bindings/spi/brcm,spi-bcm-qspi.txt |   16 -
 Makefile                                                    |    2 
 arch/arm64/kernel/cpu_errata.c                              |    8 
 arch/arm64/kernel/paravirt.c                                |   26 -
 arch/arm64/net/bpf_jit_comp.c                               |   43 ++
 arch/mips/Kconfig                                           |    1 
 arch/mips/kvm/mips.c                                        |    2 
 arch/mips/sni/a20r.c                                        |    9 
 arch/openrisc/mm/cache.c                                    |    2 
 arch/powerpc/include/asm/book3s/64/mmu.h                    |   10 
 arch/powerpc/kernel/dma-iommu.c                             |    3 
 arch/powerpc/mm/book3s64/radix_pgtable.c                    |   15 
 arch/powerpc/mm/init_64.c                                   |   11 
 arch/riscv/mm/init.c                                        |    7 
 arch/s390/kernel/entry.h                                    |    1 
 arch/s390/kernel/pgm_check.S                                |    2 
 arch/s390/mm/fault.c                                        |   20 +
 arch/s390/pci/pci.c                                         |    4 
 arch/s390/pci/pci_event.c                                   |    2 
 arch/x86/boot/compressed/Makefile                           |    2 
 arch/x86/include/asm/frame.h                                |   19 +
 arch/x86/kernel/process.c                                   |    3 
 block/bfq-iosched.c                                         |   12 
 block/blk-mq-sched.h                                        |    2 
 drivers/base/firmware_loader/firmware.h                     |    2 
 drivers/base/firmware_loader/main.c                         |   17 -
 drivers/block/loop.c                                        |    4 
 drivers/clk/davinci/pll.c                                   |    2 
 drivers/clk/rockchip/clk-rk3228.c                           |    2 
 drivers/dax/super.c                                         |    4 
 drivers/firmware/efi/efibc.c                                |    2 
 drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c       |    2 
 drivers/gpu/drm/i915/gem/i915_gem_context.c                 |   48 +--
 drivers/gpu/drm/i915/i915_sw_fence.c                        |   10 
 drivers/gpu/drm/mediatek/mtk_drm_crtc.c                     |   20 -
 drivers/gpu/drm/mediatek/mtk_drm_ddp_comp.c                 |    1 
 drivers/gpu/drm/mediatek/mtk_drm_drv.c                      |   18 -
 drivers/gpu/drm/mediatek/mtk_dsi.c                          |    9 
 drivers/gpu/drm/mediatek/mtk_hdmi.c                         |   26 +
 drivers/hv/channel_mgmt.c                                   |    7 
 drivers/hv/vmbus_drv.c                                      |    9 
 drivers/i2c/algos/i2c-algo-pca.c                            |   35 +-
 drivers/i2c/busses/i2c-i801.c                               |   21 -
 drivers/i2c/busses/i2c-mt65xx.c                             |    4 
 drivers/i2c/busses/i2c-mxs.c                                |   10 
 drivers/infiniband/hw/bnxt_re/qplib_sp.c                    |    2 
 drivers/infiniband/hw/bnxt_re/qplib_sp.h                    |    1 
 drivers/input/mouse/trackpoint.c                            |   10 
 drivers/input/mouse/trackpoint.h                            |   10 
 drivers/input/serio/i8042-x86ia64io.h                       |   16 +
 drivers/interconnect/core.c                                 |   10 
 drivers/iommu/amd/iommu.c                                   |    8 
 drivers/md/dm-table.c                                       |   10 
 drivers/md/dm.c                                             |    5 
 drivers/misc/habanalabs/debugfs.c                           |    2 
 drivers/misc/habanalabs/include/gaudi/gaudi_masks.h         |   32 +-
 drivers/net/hyperv/netvsc_drv.c                             |    2 
 drivers/nvme/host/fc.c                                      |    1 
 drivers/nvme/host/rdma.c                                    |    1 
 drivers/nvme/host/tcp.c                                     |    1 
 drivers/nvme/target/loop.c                                  |    3 
 drivers/phy/ti/phy-omap-usb2.c                              |   47 ++-
 drivers/rapidio/Kconfig                                     |    2 
 drivers/regulator/pwm-regulator.c                           |    2 
 drivers/s390/crypto/zcrypt_ccamisc.c                        |    8 
 drivers/scsi/libfc/fc_disc.c                                |    2 
 drivers/scsi/libsas/sas_discover.c                          |    3 
 drivers/scsi/lpfc/lpfc_els.c                                |    7 
 drivers/scsi/lpfc/lpfc_hw4.h                                |    2 
 drivers/scsi/pm8001/pm8001_sas.c                            |    2 
 drivers/spi/spi-loopback-test.c                             |    2 
 drivers/spi/spi.c                                           |    9 
 drivers/thunderbolt/eeprom.c                                |   20 +
 drivers/tty/serial/8250/8250_pci.c                          |   11 
 drivers/tty/serial/serial_core.c                            |   44 +-
 drivers/usb/class/usblp.c                                   |    5 
 drivers/usb/core/quirks.c                                   |    4 
 drivers/usb/host/ehci-hcd.c                                 |    1 
 drivers/usb/host/ehci-hub.c                                 |    1 
 drivers/usb/storage/uas.c                                   |   14 
 drivers/usb/typec/ucsi/ucsi.c                               |   22 +
 drivers/usb/typec/ucsi/ucsi_acpi.c                          |    2 
 drivers/video/fbdev/core/fbcon.c                            |    2 
 fs/cifs/inode.c                                             |    4 
 fs/f2fs/data.c                                              |    3 
 fs/f2fs/node.c                                              |    3 
 fs/nfs/nfs4proc.c                                           |   11 
 include/linux/cpuhotplug.h                                  |    1 
 include/linux/dax.h                                         |   21 +
 include/linux/i2c-algo-pca.h                                |   15 
 include/linux/percpu-rwsem.h                                |    8 
 include/linux/serial_core.h                                 |    1 
 include/sound/soc.h                                         |    4 
 include/uapi/linux/kvm.h                                    |    5 
 kernel/kprobes.c                                            |    9 
 kernel/locking/lockdep.c                                    |   35 +-
 kernel/locking/lockdep_internals.h                          |    2 
 kernel/locking/percpu-rwsem.c                               |    4 
 mm/huge_memory.c                                            |   42 +-
 mm/ksm.c                                                    |    4 
 mm/memory_hotplug.c                                         |   14 
 mm/page_isolation.c                                         |    8 
 mm/percpu.c                                                 |    2 
 mm/vmscan.c                                                 |    8 
 net/core/skbuff.c                                           |   10 
 net/mptcp/protocol.c                                        |    8 
 net/sunrpc/rpcb_clnt.c                                      |    4 
 net/sunrpc/xprtrdma/verbs.c                                 |    2 
 scripts/kconfig/qconf.cc                                    |    2 
 sound/pci/hda/patch_realtek.c                               |   79 +++++
 sound/soc/codecs/rt1308-sdw.c                               |    4 
 sound/soc/codecs/rt700-sdw.c                                |    4 
 sound/soc/codecs/rt711-sdw.c                                |    4 
 sound/soc/codecs/rt715-sdw.c                                |    4 
 sound/soc/codecs/tlv320adcx140.c                            |    4 
 sound/soc/intel/boards/skl_hda_dsp_generic.c                |    2 
 sound/soc/intel/haswell/sst-haswell-dsp.c                   |  185 +++++-------
 sound/soc/meson/axg-toddr.c                                 |   24 +
 sound/soc/qcom/apq8016_sbc.c                                |    1 
 sound/soc/qcom/apq8096.c                                    |    1 
 sound/soc/qcom/common.c                                     |    6 
 sound/soc/qcom/sdm845.c                                     |    1 
 sound/soc/qcom/storm.c                                      |    1 
 sound/soc/soc-core.c                                        |   13 
 sound/soc/soc-dai.c                                         |    4 
 sound/soc/soc-pcm.c                                         |    2 
 tools/perf/tests/bp_signal.c                                |    5 
 tools/perf/tests/pmu-events.c                               |    5 
 tools/perf/tests/pmu.c                                      |    1 
 tools/perf/util/evlist.c                                    |   11 
 tools/perf/util/metricgroup.c                               |    7 
 tools/perf/util/parse-events.c                              |    2 
 tools/perf/util/pmu.c                                       |   13 
 tools/perf/util/pmu.h                                       |    2 
 tools/perf/util/record.c                                    |   34 +-
 tools/testing/selftests/vm/map_hugetlb.c                    |    2 
 137 files changed, 1013 insertions(+), 447 deletions(-)

Alexey Kardashevskiy (1):
      powerpc/dma: Fix dma_map_ops::get_required_mask

Andrew Jones (1):
      arm64: paravirt: Initialize steal time when cpu is online

Aneesh Kumar K.V (1):
      powerpc/book3s64/radix: Fix boot failure with large amount of guest memory

Ard Biesheuvel (1):
      efi: efibc: check for efivars write capability

Arvind Sankar (1):
      x86/boot/compressed: Disable relocation relaxation

Camel Guo (1):
      ASoC: tlv320adcx140: Fix accessing uninitialized adcx140->dev

Cezary Rojewski (2):
      ASoC: Intel: haswell: Fix power transition refactor
      ASoC: core: Do not cleanup uninitialized dais on soc_pcm_open failure

Chaitanya Kulkarni (1):
      nvme-loop: set ctrl state connecting after init

Chris Wilson (3):
      drm/i915/gem: Reduce context termination list iteration guard to RCU
      drm/i915/gem: Delay tracking the GEM context until it is registered
      drm/i915: Filter wake_flags passed to default_wake_function

Christophe JAILLET (1):
      clk: davinci: Use the correct size when allocating memory

Christophe Leroy (1):
      selftests/vm: fix display of page size in map_hugetlb

Chuck Lever (2):
      xprtrdma: Release in-flight MRs on disconnect
      NFS: Zero-stateid SETATTR should first return delegation

Chun-Kuang Hu (1):
      drm/mediatek: Use CPU when fail to get cmdq event

Dan Carpenter (1):
      scsi: libsas: Fix error path in sas_notify_lldd_dev_found()

Dan Williams (1):
      dm/dax: Fix table reference counts

David Milburn (3):
      nvme-fc: cancel async events before freeing event struct
      nvme-rdma: cancel async events before freeing event struct
      nvme-tcp: cancel async events before freeing event struct

Dennis Li (1):
      drm/kfd: fix a system crash issue during GPU recovery

Dexuan Cui (1):
      Drivers: hv: vmbus: hibernation: do not hang forever in vmbus_bus_resume()

Dinghao Liu (2):
      scsi: pm8001: Fix memleak in pm8001_exec_internal_task_abort
      ASoC: qcom: common: Fix refcount imbalance on error

Evan Nimmo (1):
      i2c: algo: pca: Reapply i2c bus settings after reset

Florian Fainelli (1):
      dt-bindings: spi: Fix spi-bcm-qspi compatible ordering

Florian Westphal (1):
      mptcp: sendmsg: reset iter on error

Gabriel Krisman Bertazi (1):
      f2fs: Return EOF on unaligned end of file DIO read

Greentime Hu (1):
      riscv: Add sfence.vma after early page table changes

Greg Kroah-Hartman (2):
      Revert "ALSA: hda - Fix silent audio output and corrupted input on MSI X570-A PRO"
      Linux 5.8.11

Gustav Wiklander (1):
      spi: Fix memory leak on splited transfers

Haiyang Zhang (1):
      hv_netvsc: Remove "unlikely" from netvsc_select_queue

Hans de Goede (1):
      Input: i8042 - add Entroware Proteus EL07R4 to nomux and reset lists

Harald Freudenberger (1):
      s390/zcrypt: fix kmalloc 256k failure

Heikki Krogerus (2):
      usb: typec: ucsi: acpi: Increase command completion timeout value
      usb: typec: ucsi: Prevent mode overrun

Hou Tao (1):
      locking/percpu-rwsem: Use this_cpu_{inc,dec}() for read_count

Huacai Chen (1):
      KVM: MIPS: Change the definition of kvm type

Hugh Dickins (1):
      ksm: reinstate memcg charge on copied pages

Hui Wang (1):
      ALSA: hda/realtek - The Mic on a RedmiBook doesn't work

Ian Rogers (1):
      perf record: Don't clear event's period if set by a term

Ilias Apalodimas (1):
      arm64: bpf: Fix branch offset in JIT

J. Bruce Fields (1):
      SUNRPC: stop printk reading past end of string

James Smart (2):
      scsi: lpfc: Fix FLOGI/PLOGI receive race condition in pt2pt discovery
      scsi: lpfc: Extend the RDF FPIN Registration descriptor for additional events

Jan Kara (2):
      dm: Call proper helper to determine dax support
      dax: Fix compilation for CONFIG_DAX && !CONFIG_FS_DAX

Janosch Frank (1):
      s390: add 3f program exception handler

Javed Hasan (1):
      scsi: libfc: Fix for double free()

Jerome Brunet (1):
      ASoC: meson: axg-toddr: fix channel order on g12 platforms

Jiri Olsa (1):
      perf test: Fix the "signal" test inline assembly

Jitao Shi (1):
      drm/mediatek: dsi: Fix scrolling of panel with small hfp or hbp

Joao Martins (1):
      iommu/amd: Fix potential @entry null deref

Johan Hovold (2):
      serial: core: fix port-lock initialisation
      serial: core: fix console port-lock regression

Josh Poimboeuf (1):
      x86/unwind/fp: Fix FP unwinding in ret_from_fork

Kuninori Morimoto (1):
      ASoC: soc-core: add snd_soc_find_dai_with_mutex()

Laurent Pinchart (1):
      rapidio: Replace 'select' DMAENGINES 'with depends on'

Luke D Jones (1):
      ALSA: hda: fixup headset for ASUS GX502 laptop

Marc Zyngier (1):
      arm64: Allow CPUs unffected by ARM erratum 1418040 to come in late

Martijn Coenen (1):
      loop: Set correct device size when using LOOP_CONFIGURE

Masahiro Yamada (1):
      kconfig: qconf: use delete[] instead of delete to free array (again)

Mateusz Gorski (1):
      ASoC: Intel: skl_hda_dsp_generic: Fix NULLptr dereference in autosuspend delay

Matthias Kaehlcke (1):
      interconnect: Show bandwidth for disabled paths as zero in debugfs

Matthias Schiffer (1):
      i2c: mxs: use MXS_DMA_CTRL_WAIT4END instead of DMA_CTRL_ACK

Miaohe Lin (1):
      net: handle the return value of pskb_carve_frag_list() correctly

Michael Kelley (1):
      Drivers: hv: vmbus: Add timeout to vmbus_wait_for_unload

Mika Westerberg (1):
      thunderbolt: Retry DROM read once if parsing fails

Moti Haimovski (1):
      habanalabs: prevent user buff overflow

Muchun Song (1):
      kprobes: fix kill kprobe which has been marked as gone

Namhyung Kim (5):
      perf test: Free aliases for PMU event map aliases test
      perf metric: Fix some memory leaks
      perf evlist: Fix cpu/thread map leak
      perf parse-event: Fix memory leak in evsel->unit
      perf test: Free formats for perf pmu parse test

Naresh Kumar PBS (1):
      RDMA/bnxt_re: Restrict the max_gids to 256

Nathan Chancellor (1):
      clk: rockchip: Fix initialization of mux_pll_src_4plls_p

Niklas Schnelle (1):
      s390/pci: fix leak of DMA tables on hard unplug

Ofir Bitton (1):
      habanalabs: fix report of RAZWI initiator coordinates

Olga Kornievskaia (1):
      NFSv4.1 handle ERR_DELAY error reclaiming locking state on delegation recall

Oliver Neukum (2):
      USB: UAS: fix disconnect by unplugging a hub
      usblp: fix race between disconnect() and read()

Omar Sandoval (1):
      block: only call sched requeue_request() for scheduled requests

Pavel Tatashin (1):
      mm/memory_hotplug: drain per-cpu pages again during memory offline

Penghao (1):
      USB: quirks: Add USB_QUIRK_IGNORE_REMOTE_WAKEUP quirk for BYD zhaoxin notebook

Prateek Sood (1):
      firmware_loader: fix memory leak for paged buffer

Qii Wang (1):
      i2c: mediatek: Fix generic definitions for bus frequency

Quentin Perret (1):
      ehci-hcd: Move include to keep CRC stable

Ralph Campbell (1):
      mm/thp: fix __split_huge_pmd_locked() for migration PMD

Rob Herring (1):
      dt-bindings: PCI: intel,lgm-pcie: Fix matching on all snps,dw-pcie instances

Roger Quadros (1):
      phy: omap-usb2-phy: disable PHY charger detect

Ronnie Sahlberg (1):
      cifs: fix DFS mount with cifsacl/modefromsid

Sahitya Tummala (1):
      f2fs: fix indefinite loop scanning for free nid

Stafford Horne (1):
      openrisc: Fix cache API compile issue when not inlining

Stephan Gerhold (1):
      ASoC: qcom: Set card->owner to avoid warnings

Sunghyun Jin (1):
      percpu: fix first chunk size calculation for populated bitmap

Suravee Suthikulpanit (1):
      iommu/amd: Restore IRTE.RemapEn bit for amd_iommu_activate_guest_mode

Tetsuo Handa (1):
      fbcon: Fix user font detection test at fbcon_resize().

Thomas Bogendoerfer (2):
      MIPS: SNI: Fix MIPS_L1_CACHE_SHIFT
      MIPS: SNI: Fix spurious interrupts

Tobias Diedrich (1):
      serial: 8250_pci: Add Realtek 816a and 816b

Vincent Huang (1):
      Input: trackpoint - add new trackpoint variant IDs

Vincent Whitchurch (2):
      regulator: pwm: Fix machine constraints application
      spi: spi-loopback-test: Fix out-of-bounds read

Vinod Koul (4):
      ASoC: rt1308-sdw: Fix return check for devm_regmap_init_sdw()
      ASoC: rt711: Fix return check for devm_regmap_init_sdw()
      ASoC: rt715: Fix return check for devm_regmap_init_sdw()
      ASoC: rt700: Fix return check for devm_regmap_init_sdw()

Volker Rümelin (1):
      i2c: i801: Fix resume bug

Xunlei Pang (1):
      mm: memcg: fix memcg reclaim soft lockup

Yu Kuai (4):
      drm/mediatek: Add missing put_device() call in mtk_ddp_comp_init()
      drm/mediatek: Add exception handing in mtk_drm_probe() if component init fail
      drm/mediatek: Add missing put_device() call in mtk_drm_kms_init()
      drm/mediatek: Add missing put_device() call in mtk_hdmi_dt_parse_pdata()

peterz@infradead.org (1):
      locking/lockdep: Fix "USED" <- "IN-NMI" inversions

