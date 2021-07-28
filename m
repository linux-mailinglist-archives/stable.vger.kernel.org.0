Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29BAF3D8D4A
	for <lists+stable@lfdr.de>; Wed, 28 Jul 2021 13:57:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234695AbhG1L5d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Jul 2021 07:57:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:53936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234647AbhG1L5c (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 28 Jul 2021 07:57:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 14D0360F9D;
        Wed, 28 Jul 2021 11:57:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627473451;
        bh=ePFSE9OAadEEn+/TF+nAhB5GbgOvHDU1K2mot6m6AM4=;
        h=From:To:Cc:Subject:Date:From;
        b=UgulP/1ajwgL6NAOeab+cfmKUyqnqzuG2D4tfmzNqo/h+UJc5ea7YhaZqStZKTHAY
         fgKDS5z14R8RlfFsKPmoY1XqJ3LJ5JmHzdDje/cwuiASGO6aMYbDlHBMFVTDtHEfcv
         POJHFfQJECsxirqxLHcAGeTezvrBwVAwzptPlp3A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.4.136
Date:   Wed, 28 Jul 2021 13:57:28 +0200
Message-Id: <162747344836149@kroah.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.4.136 kernel.

All users of the 5.4 kernel series must upgrade.

The updated 5.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/arm64/tagged-address-abi.rst                |   26 ++-
 Documentation/trace/histogram.rst                         |    2 
 Makefile                                                  |    2 
 arch/mips/include/asm/pgalloc.h                           |   10 -
 arch/nds32/mm/mmap.c                                      |    2 
 arch/powerpc/kvm/book3s_hv.c                              |    2 
 arch/powerpc/kvm/book3s_hv_nested.c                       |   20 ++
 arch/powerpc/kvm/book3s_rtas.c                            |   25 ++
 arch/powerpc/kvm/powerpc.c                                |    4 
 arch/s390/boot/text_dma.S                                 |   19 --
 arch/s390/include/asm/ftrace.h                            |    1 
 arch/s390/kernel/ftrace.c                                 |    2 
 arch/s390/kernel/mcount.S                                 |    4 
 arch/s390/net/bpf_jit_comp.c                              |    2 
 drivers/block/rbd.c                                       |   32 +--
 drivers/firmware/efi/efi.c                                |   13 +
 drivers/firmware/efi/tpm.c                                |    8 
 drivers/gpu/drm/drm_ioctl.c                               |    3 
 drivers/gpu/drm/panel/panel-raspberrypi-touchscreen.c     |    1 
 drivers/iio/accel/bma180.c                                |   75 +++++---
 drivers/media/pci/ngene/ngene-core.c                      |    2 
 drivers/media/pci/ngene/ngene.h                           |   14 -
 drivers/net/dsa/mv88e6xxx/chip.c                          |    4 
 drivers/net/ethernet/broadcom/bnxt/bnxt.c                 |   28 ++-
 drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c             |   19 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.h             |    3 
 drivers/net/ethernet/broadcom/genet/bcmgenet.c            |   16 -
 drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c        |    6 
 drivers/net/ethernet/cavium/liquidio/cn23xx_pf_device.c   |    2 
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c           |   18 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.c            |    3 
 drivers/net/ethernet/google/gve/gve_main.c                |    5 
 drivers/net/ethernet/hisilicon/hip04_eth.c                |    6 
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c |   10 +
 drivers/net/ethernet/intel/e1000e/netdev.c                |    1 
 drivers/net/ethernet/intel/fm10k/fm10k_pci.c              |    1 
 drivers/net/ethernet/intel/iavf/iavf_main.c               |    1 
 drivers/net/ethernet/intel/igb/igb_main.c                 |   15 +
 drivers/net/ethernet/intel/igc/igc.h                      |    2 
 drivers/net/ethernet/intel/igc/igc_main.c                 |    6 
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c             |    4 
 drivers/net/ethernet/realtek/r8169_main.c                 |    3 
 drivers/nvme/host/core.c                                  |    5 
 drivers/nvme/host/pci.c                                   |    5 
 drivers/pci/quirks.c                                      |    4 
 drivers/pwm/pwm-sprd.c                                    |   11 -
 drivers/regulator/hi6421-regulator.c                      |   30 +--
 drivers/scsi/scsi_transport_iscsi.c                       |   90 +++-------
 drivers/spi/spi-cadence.c                                 |   14 +
 drivers/spi/spi-imx.c                                     |   37 ++--
 drivers/spi/spi-mt65xx.c                                  |   16 +
 drivers/spi/spi-stm32.c                                   |   41 +++-
 drivers/target/target_core_sbc.c                          |   35 +---
 drivers/usb/core/hub.c                                    |  120 +++++++++-----
 drivers/usb/core/quirks.c                                 |    4 
 drivers/usb/dwc2/gadget.c                                 |   10 -
 drivers/usb/host/max3421-hcd.c                            |   44 +----
 drivers/usb/host/xhci-hub.c                               |    3 
 drivers/usb/host/xhci-ring.c                              |   58 +++++-
 drivers/usb/host/xhci.h                                   |    3 
 drivers/usb/renesas_usbhs/fifo.c                          |    7 
 drivers/usb/serial/cp210x.c                               |    5 
 drivers/usb/serial/option.c                               |    3 
 drivers/usb/storage/unusual_uas.h                         |    7 
 fs/afs/cmservice.c                                        |   25 --
 fs/btrfs/extent-tree.c                                    |    3 
 fs/btrfs/inode.c                                          |    2 
 fs/hugetlbfs/inode.c                                      |    2 
 fs/proc/base.c                                            |    2 
 fs/userfaultfd.c                                          |   22 +-
 include/drm/drm_ioctl.h                                   |    1 
 include/trace/events/afs.h                                |   67 +++++++
 kernel/trace/ring_buffer.c                                |   28 ++-
 kernel/trace/trace.c                                      |    4 
 kernel/trace/trace_events_hist.c                          |   22 +-
 net/caif/caif_socket.c                                    |    3 
 net/decnet/af_decnet.c                                    |   27 +--
 net/ipv4/tcp_bpf.c                                        |    2 
 net/ipv4/tcp_fastopen.c                                   |   19 +-
 net/ipv6/ip6_output.c                                     |    4 
 net/ipv6/route.c                                          |    2 
 net/netrom/nr_timer.c                                     |   20 +-
 net/sched/act_skbmod.c                                    |   12 -
 net/sched/cls_api.c                                       |    2 
 net/sched/cls_tcindex.c                                   |    5 
 net/sctp/auth.c                                           |    2 
 sound/isa/sb/sb16_csp.c                                   |    4 
 sound/pci/hda/patch_hdmi.c                                |    1 
 sound/soc/codecs/rt5631.c                                 |    2 
 sound/usb/mixer.c                                         |   10 +
 sound/usb/quirks.c                                        |    3 
 tools/bpf/bpftool/common.c                                |    5 
 tools/perf/builtin-inject.c                               |    8 
 tools/perf/builtin-script.c                               |    7 
 tools/perf/tests/event_update.c                           |    2 
 tools/perf/tests/topology.c                               |    1 
 tools/perf/util/data.c                                    |    2 
 tools/perf/util/dso.c                                     |    4 
 tools/perf/util/env.c                                     |    1 
 tools/perf/util/lzma.c                                    |    8 
 tools/perf/util/map.c                                     |    2 
 tools/perf/util/probe-event.c                             |    4 
 tools/perf/util/probe-file.c                              |    4 
 tools/testing/selftests/net/icmp_redirect.sh              |    5 
 tools/testing/selftests/vm/userfaultfd.c                  |    6 
 105 files changed, 848 insertions(+), 481 deletions(-)

Alain Volmat (1):
      spi: stm32: fixes pm_runtime calls in probe/remove

Aleksandr Loktionov (1):
      igb: Check if num of q_vectors is smaller than max before array access

Alexander Egorenkov (1):
      s390/boot: fix use of expolines in the DMA code

Alexander Tsoy (1):
      ALSA: usb-audio: Add registration quirk for JBL Quantum headsets

Anand Jain (1):
      btrfs: check for missing device in btrfs_trim_fs

Axel Lin (2):
      regulator: hi6421: Use correct variable type for regmap api val argument
      regulator: hi6421: Fix getting wrong drvdata

Casey Chen (1):
      nvme-pci: do not call nvme_dev_remove_admin from nvme_remove

Charles Baylis (1):
      drm: Return -ENOTTY for non-drm ioctls

Christoph Hellwig (1):
      nvme: set the PRACT bit when using Write Zeroes with T10 PI

Christophe JAILLET (7):
      ixgbe: Fix an error handling path in 'ixgbe_probe()'
      igc: Fix an error handling path in 'igc_probe()'
      igb: Fix an error handling path in 'igb_probe()'
      fm10k: Fix an error handling path in 'fm10k_probe()'
      e1000e: Fix an error handling path in 'e1000_probe()'
      iavf: Fix an error handling path in 'iavf_probe()'
      gve: Fix an error handling path in 'gve_probe()'

Clark Wang (1):
      spi: imx: add a check for speed_hz before calculating the clock

Colin Ian King (2):
      liquidio: Fix unintentional sign extension issue on left shift of u16
      s390/bpf: Perform r1 range checking before accessing jit->seen_reg[r1]

David Howells (1):
      afs: Fix tracepoint string placement with built-in AFS

David Sterba (1):
      btrfs: compression: don't try to compress if we don't have enough pages

Dmitry Bogdanov (1):
      scsi: target: Fix protect handling in WRITE SAME(32)

Doug Berger (1):
      net: bcmgenet: ensure EXT_ENERGY_DET_MASK is clear

Eric Dumazet (1):
      net/tcp_fastopen: fix data races around tfo_active_disable_stamp

Evan Quan (1):
      PCI: Mark AMD Navi14 GPU ATS as broken

Greg Kroah-Hartman (2):
      nds32: fix up stack guard gap
      Linux 5.4.136

Gustavo A. R. Silva (1):
      media: ngene: Fix out-of-bounds bug in ngene_command_config_free_buf()

Hangbin Liu (2):
      selftests: icmp_redirect: remove from checking for IPv6 route get
      selftests: icmp_redirect: IPv6 PMTU info should be cleared after redirect

Haoran Luo (1):
      tracing: Fix bug in rb_per_cpu_empty() that might cause deadloop.

Huang Pei (1):
      Revert "MIPS: add PMD table accounting into MIPS'pmd_alloc_one"

Ian Ray (1):
      USB: serial: cp210x: fix comments for GE CS1000

Ilya Dryomov (2):
      rbd: don't hold lock_rwsem while running_list is being drained
      rbd: always kick acquire on "acquired" and "released" notifications

Jedrzej Jagielski (1):
      igb: Fix position of assignment to *ring

Jian Shen (1):
      net: hns3: fix rx VLAN offload state inconsistent issue

John Fastabend (1):
      bpf, sockmap, tcp: sk_prot needs inuse_idx set for proc stats

John Keeping (1):
      USB: serial: cp210x: add ID for CEL EM3588 USB ZigBee stick

Julian Sikorski (1):
      USB: usb-storage: Add LaCie Rugged USB3-FW to IGNORE_UAS

Linus Walleij (1):
      iio: accel: bma180: Use explicit member assignment

Marc Zyngier (1):
      firmware/efi: Tell memblock about EFI iomem reservations

Marcelo Henrique Cerri (1):
      proc: Avoid mixing integer types in mem_rw()

Marco De Marco (1):
      USB: serial: option: add support for u-blox LARA-R6 family

Marek Behún (1):
      net: dsa: mv88e6xxx: use correct .stats_set_histogram() on Topaz

Marek Vasut (1):
      spi: cadence: Correct initialisation of runtime PM again

Mark Tomlinson (1):
      usb: max-3421: Prevent corruption of freed memory

Markus Boehme (1):
      ixgbe: Fix packet corruption due to missing DMA sync

Mathias Nyman (4):
      xhci: Fix lost USB 2 remote wake
      usb: hub: Disable USB 3 device initiated lpm if exit latency is too high
      usb: hub: Fix link power management max exit latency (MEL) calculations
      xhci: add xhci_get_virt_ep() helper

Maxim Schwalm (1):
      ASoC: rt5631: Fix regcache sync errors on resume

Maxime Ripard (1):
      drm/panel: raspberrypi-touchscreen: Prevent double-free

Michael Chan (2):
      bnxt_en: Refresh RoCE capabilities in bnxt_ulp_probe()
      bnxt_en: Add missing check for BNXT_STATE_ABORT_ERR in bnxt_fw_rset_task()

Michal Suchanek (1):
      efi/tpm: Differentiate missing and invalid final event log table.

Mike Christie (1):
      scsi: iscsi: Fix iface sysfs attr detection

Mike Kravetz (1):
      hugetlbfs: fix mount mode command line processing

Minas Harutyunyan (1):
      usb: dwc2: gadget: Fix sending zero length packet in DDMA mode.

Nguyen Dinh Phi (1):
      netrom: Decrease sock refcount when sock timers expire

Nicholas Piggin (4):
      KVM: PPC: Book3S: Fix CONFIG_TRANSACTIONAL_MEM=n crash
      KVM: PPC: Fix kvm_arch_vcpu_ioctl vcpu_load leak
      KVM: PPC: Book3S: Fix H_RTAS rets buffer overflow
      KVM: PPC: Book3S HV Nested: Sanitise H_ENTER_NESTED TM state

Nicolas Dichtel (1):
      ipv6: fix 'disable_policy' for fwd packets

Paolo Abeni (1):
      ipv6: fix another slab-out-of-bounds in fib6_nh_flush_exceptions

Pavel Skripkin (1):
      net: sched: fix memory leak in tcindex_partial_destroy_work

Peilin Ye (1):
      net/sched: act_skbmod: Skip non-Ethernet packets

Peter Collingbourne (2):
      selftest: use mmap instead of posix_memalign to allocate memory
      userfaultfd: do not untag user pointers

Peter Hess (1):
      spi: mediatek: fix fifo rx mode

Peter Ujfalusi (1):
      spi: stm32: Use dma_request_chan() instead dma_request_slave_channel()

Randy Dunlap (1):
      net: hisilicon: rename CACHE_LINE_MASK to avoid redefinition

Riccardo Mancini (11):
      perf map: Fix dso->nsinfo refcounting
      perf probe: Fix dso->nsinfo refcounting
      perf env: Fix sibling_dies memory leak
      perf test session_topology: Delete session->evlist
      perf test event_update: Fix memory leak of evlist
      perf dso: Fix memory leak in dso__new_map()
      perf script: Fix memory 'threads' and 'cpus' leaks on exit
      perf lzma: Close lzma stream on exit
      perf probe-file: Delete namelist in del_events() on the error path
      perf data: Close all files in close_dir()
      perf inject: Close inject.output on exit

Sasha Neftin (1):
      igc: Prefer to use the pci_release_mem_regions method

Sayanta Pattanayak (1):
      r8169: Avoid duplicate sysfs entry creation error

Shahjada Abul Husain (1):
      cxgb4: fix IRQ free race during driver unload

Somnath Kotur (1):
      bnxt_en: Check abort error state in bnxt_half_open_nic()

Stephan Gerhold (1):
      iio: accel: bma180: Fix BMA25x bandwidth register values

Steven Rostedt (VMware) (1):
      tracing/histogram: Rename "cpu" to "common_cpu"

Takashi Iwai (3):
      ALSA: usb-audio: Add missing proc text entry for BESPOKEN type
      ALSA: sb: Fix potential ABBA deadlock in CSP driver
      ALSA: hdmi: Expose all pins on MSI MS-7C94 board

Tobias Klauser (1):
      bpftool: Check malloc return value in mount_bpffs_for_pin

Tom Rix (1):
      igc: change default return of igc_read_phy_reg()

Uwe Kleine-König (1):
      pwm: sprd: Ensure configuring period and duty_cycle isn't wrongly skipped

Vasily Gorbik (1):
      s390/ftrace: fix ftrace_update_ftrace_func implementation

Vasundhara Volam (1):
      bnxt_en: Improve bnxt_ulp_stop()/bnxt_ulp_start() call sequence.

Vincent Palatin (1):
      Revert "USB: quirks: ignore remote wake-up on Fibocom L850-GL LTE modem"

Vinicius Costa Gomes (2):
      igc: Fix use-after-free error during reset
      igb: Fix use-after-free error during reset

Xin Long (1):
      sctp: update active_key for asoc when old key is being replaced

Yajun Deng (2):
      net: decnet: Fix sleeping inside in af_decnet
      net: sched: cls_api: Fix the the wrong parameter

Yoshihiro Shimoda (1):
      usb: renesas_usbhs: Fix superfluous irqs happen after usb_pkt_pop()

Zhihao Cheng (1):
      nvme-pci: don't WARN_ON in nvme_reset_work if ctrl.state is not RESETTING

Ziyang Xuan (1):
      net: fix uninit-value in caif_seqpkt_sendmsg

