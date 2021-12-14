Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04DA34744F4
	for <lists+stable@lfdr.de>; Tue, 14 Dec 2021 15:28:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232953AbhLNO2T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Dec 2021 09:28:19 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:44768 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233871AbhLNO2Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Dec 2021 09:28:16 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B166BB819C2;
        Tue, 14 Dec 2021 14:28:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC17DC34601;
        Tue, 14 Dec 2021 14:28:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639492093;
        bh=BNWmNi2A1n5ZF1WymTal4/CaMi41l31oNUn3XZhPgFo=;
        h=From:To:Cc:Subject:Date:From;
        b=X62C1SLGcChZncJVBMNx7FcvHFpO7YHx175MyXPjqQyAAObvujchsrCexcBbZjNju
         yL3502lwkQUB7+Pb20K2QgR6KdJ8y6M1H4eEySqNLo4SP6Ql7M5+QhkVvFYt0KnXDf
         epbrGzcjSpIh2mVesJlVHjUdMZzmYT6Ajp/RNEiQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.10.85
Date:   Tue, 14 Dec 2021 15:28:05 +0100
Message-Id: <1639492086124214@kroah.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.10.85 kernel.

All users of the 5.10 kernel series must upgrade.

The updated 5.10.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.10.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/devicetree/bindings/net/ethernet-phy.yaml         |    8 
 Documentation/kbuild/gcc-plugins.rst                            |   47 
 Documentation/locking/locktypes.rst                             |    9 
 MAINTAINERS                                                     |    1 
 Makefile                                                        |    2 
 arch/csky/kernel/traps.c                                        |    4 
 arch/x86/Kconfig                                                |    1 
 arch/x86/include/asm/kvm_host.h                                 |    2 
 arch/x86/platform/efi/quirks.c                                  |    3 
 block/ioprio.c                                                  |    3 
 drivers/android/binder.c                                        |   21 
 drivers/ata/libata-core.c                                       |    2 
 drivers/clk/imx/clk-imx8qxp-lpcg.c                              |    2 
 drivers/clk/imx/clk-imx8qxp.c                                   |    2 
 drivers/clk/qcom/clk-regmap-mux.c                               |    2 
 drivers/clk/qcom/common.c                                       |   12 
 drivers/clk/qcom/common.h                                       |    2 
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.c                      |   97 -
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h                      |  145 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c                      |    8 
 drivers/gpu/drm/amd/amdkfd/kfd_device.c                         |   15 
 drivers/gpu/drm/drm_syncobj.c                                   |   11 
 drivers/hid/Kconfig                                             |   10 
 drivers/hid/hid-asus.c                                          |    6 
 drivers/hid/hid-bigbenff.c                                      |    2 
 drivers/hid/hid-chicony.c                                       |    8 
 drivers/hid/hid-corsair.c                                       |    7 
 drivers/hid/hid-elan.c                                          |    2 
 drivers/hid/hid-elo.c                                           |    3 
 drivers/hid/hid-google-hammer.c                                 |    2 
 drivers/hid/hid-holtek-kbd.c                                    |    9 
 drivers/hid/hid-holtek-mouse.c                                  |    9 
 drivers/hid/hid-ids.h                                           |    2 
 drivers/hid/hid-lg.c                                            |   10 
 drivers/hid/hid-logitech-dj.c                                   |    2 
 drivers/hid/hid-prodikeys.c                                     |   10 
 drivers/hid/hid-quirks.c                                        |    1 
 drivers/hid/hid-roccat-arvo.c                                   |    3 
 drivers/hid/hid-roccat-isku.c                                   |    3 
 drivers/hid/hid-roccat-kone.c                                   |    3 
 drivers/hid/hid-roccat-koneplus.c                               |    3 
 drivers/hid/hid-roccat-konepure.c                               |    3 
 drivers/hid/hid-roccat-kovaplus.c                               |    3 
 drivers/hid/hid-roccat-lua.c                                    |    3 
 drivers/hid/hid-roccat-pyra.c                                   |    3 
 drivers/hid/hid-roccat-ryos.c                                   |    3 
 drivers/hid/hid-roccat-savu.c                                   |    3 
 drivers/hid/hid-samsung.c                                       |    3 
 drivers/hid/hid-u2fzero.c                                       |    2 
 drivers/hid/hid-uclogic-core.c                                  |    3 
 drivers/hid/hid-uclogic-params.c                                |    3 
 drivers/hid/wacom_sys.c                                         |   19 
 drivers/iio/accel/kxcjk-1013.c                                  |    5 
 drivers/iio/accel/kxsd9.c                                       |    6 
 drivers/iio/accel/mma8452.c                                     |    2 
 drivers/iio/adc/ad7768-1.c                                      |    2 
 drivers/iio/adc/at91-sama5d2_adc.c                              |    3 
 drivers/iio/adc/axp20x_adc.c                                    |   18 
 drivers/iio/adc/dln2-adc.c                                      |   21 
 drivers/iio/adc/stm32-adc.c                                     |    1 
 drivers/iio/gyro/adxrs290.c                                     |    5 
 drivers/iio/gyro/itg3200_buffer.c                               |    2 
 drivers/iio/industrialio-trigger.c                              |    1 
 drivers/iio/light/ltr501.c                                      |    2 
 drivers/iio/light/stk3310.c                                     |    6 
 drivers/iio/trigger/stm32-timer-trigger.c                       |    2 
 drivers/infiniband/hw/hfi1/chip.c                               |    2 
 drivers/infiniband/hw/hfi1/driver.c                             |    2 
 drivers/infiniband/hw/hfi1/init.c                               |   40 
 drivers/infiniband/hw/hfi1/sdma.c                               |    2 
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c                      |   14 
 drivers/irqchip/irq-armada-370-xp.c                             |   16 
 drivers/irqchip/irq-aspeed-scu-ic.c                             |    4 
 drivers/irqchip/irq-gic-v3-its.c                                |    2 
 drivers/irqchip/irq-nvic.c                                      |    2 
 drivers/md/md.c                                                 |    1 
 drivers/misc/fastrpc.c                                          |   10 
 drivers/mmc/host/renesas_sdhi_core.c                            |    2 
 drivers/mtd/nand/raw/fsmc_nand.c                                |   36 
 drivers/net/bonding/bond_alb.c                                  |   14 
 drivers/net/can/kvaser_pciefd.c                                 |    8 
 drivers/net/can/m_can/m_can.c                                   |   14 
 drivers/net/can/pch_can.c                                       |    2 
 drivers/net/can/sja1000/ems_pcmcia.c                            |    7 
 drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c                |  101 +
 drivers/net/ethernet/altera/altera_tse_main.c                   |    9 
 drivers/net/ethernet/freescale/fec.h                            |    3 
 drivers/net/ethernet/freescale/fec_main.c                       |    2 
 drivers/net/ethernet/intel/i40e/i40e_debugfs.c                  |    8 
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c              |   75 -
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.h              |    2 
 drivers/net/ethernet/intel/iavf/iavf_ethtool.c                  |   43 
 drivers/net/ethernet/intel/iavf/iavf_main.c                     |    1 
 drivers/net/ethernet/intel/ice/ice_main.c                       |    3 
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c                 |    4 
 drivers/net/ethernet/netronome/nfp/nfpcore/nfp_cppcore.c        |    4 
 drivers/net/ethernet/qlogic/qede/qede_fp.c                      |    7 
 drivers/net/ethernet/qlogic/qla3xxx.c                           |   19 
 drivers/net/usb/cdc_ncm.c                                       |    2 
 drivers/net/vrf.c                                               |    8 
 drivers/pci/controller/pci-aardvark.c                           |    9 
 drivers/scsi/pm8001/pm8001_init.c                               |    6 
 drivers/scsi/qla2xxx/qla_dbg.c                                  |    3 
 drivers/scsi/scsi_debug.c                                       |    2 
 drivers/usb/core/config.c                                       |    6 
 drivers/usb/gadget/composite.c                                  |   14 
 drivers/usb/gadget/function/uvc.h                               |    2 
 drivers/usb/gadget/function/uvc_v4l2.c                          |   49 
 drivers/usb/gadget/legacy/dbgp.c                                |   15 
 drivers/usb/gadget/legacy/inode.c                               |   16 
 drivers/usb/host/xhci-hub.c                                     |    1 
 drivers/usb/host/xhci-ring.c                                    |    1 
 drivers/usb/host/xhci.c                                         |   26 
 fs/aio.c                                                        |  184 ++
 fs/btrfs/extent_io.c                                            |    6 
 fs/btrfs/root-tree.c                                            |    3 
 fs/nfsd/nfs4recover.c                                           |    1 
 fs/nfsd/nfs4state.c                                             |    9 
 fs/nfsd/nfsctl.c                                                |   14 
 fs/signalfd.c                                                   |   12 
 fs/tracefs/inode.c                                              |   76 +
 include/linux/bpf.h                                             |    1 
 include/linux/hid.h                                             |    5 
 include/linux/pm_runtime.h                                      |    2 
 include/linux/wait.h                                            |   26 
 include/net/bond_alb.h                                          |    2 
 include/net/netfilter/nf_conntrack.h                            |    6 
 include/uapi/asm-generic/poll.h                                 |    2 
 kernel/bpf/verifier.c                                           |    2 
 kernel/sched/wait.c                                             |    7 
 mm/backing-dev.c                                                |    7 
 net/core/devlink.c                                              |   16 
 net/core/neighbour.c                                            |    3 
 net/ipv4/udp.c                                                  |    2 
 net/ipv6/seg6_iptunnel.c                                        |    8 
 net/netfilter/nf_conntrack_core.c                               |    6 
 net/netfilter/nf_conntrack_netlink.c                            |    2 
 net/netfilter/nf_flow_table_core.c                              |    4 
 net/netfilter/nft_set_pipapo_avx2.c                             |    2 
 net/nfc/netlink.c                                               |    6 
 net/sched/sch_fq_pie.c                                          |    1 
 scripts/dummy-tools/gcc                                         |   10 
 scripts/gcc-plugin.sh                                           |   19 
 scripts/gcc-plugins/Kconfig                                     |    2 
 scripts/gcc-plugins/Makefile                                    |    4 
 sound/core/control_compat.c                                     |    3 
 sound/core/oss/pcm_oss.c                                        |   37 
 sound/pci/hda/patch_realtek.c                                   |   80 -
 sound/soc/codecs/rt5682.c                                       |   10 
 sound/soc/codecs/wcd934x.c                                      |  126 +
 sound/soc/codecs/wsa881x.c                                      |   16 
 sound/soc/qcom/qdsp6/q6routing.c                                |    8 
 tools/build/Makefile.feature                                    |    1 
 tools/build/feature/Makefile                                    |    4 
 tools/build/feature/test-all.c                                  |    5 
 tools/build/feature/test-libpython-version.c                    |   11 
 tools/perf/Makefile.config                                      |    2 
 tools/perf/util/smt.c                                           |    2 
 tools/testing/selftests/bpf/verifier/xdp_direct_packet_access.c |  632 +++++++++-
 tools/testing/selftests/net/fib_tests.sh                        |   59 
 tools/testing/selftests/netfilter/Makefile                      |    3 
 tools/testing/selftests/netfilter/conntrack_vrf.sh              |  241 +++
 162 files changed, 2243 insertions(+), 684 deletions(-)

Alan Young (1):
      ALSA: ctl: Fix copy of updated id with element read/write

Alexander Stein (1):
      dt-bindings: net: Reintroduce PHY no lane swap binding

Alexander Sverdlin (1):
      nfsd: Fix nsfd startup race (again)

Alyssa Ross (1):
      iio: trigger: stm32-timer: fix MODULE_ALIAS

Andrea Mayer (1):
      seg6: fix the iif in the IPv6 socket control block

Arnaldo Carvalho de Melo (1):
      tools build: Remove needless libpython-version feature check that breaks test-all fast path

Bas Nieuwenhuizen (1):
      drm/syncobj: Deal with signalled fences in drm_syncobj_find_fence.

Benjamin Tissoires (1):
      HID: bigbenff: prevent null pointer dereference

Billy Tsai (1):
      irqchip/aspeed-scu: Replace update_bits with write_bits.

Björn Töpel (1):
      bpf, x86: Fix "no previous prototype" warning

Brian Silverman (1):
      can: m_can: Disable and ignore ELO interrupt

Dan Carpenter (3):
      can: sja1000: fix use after free in ems_pcmcia_add_card()
      net: altera: set a couple error code in probe()
      net/qla3xxx: fix an error code in ql_adapter_up()

Davidlohr Bueso (1):
      block: fix ioprio_get(IOPRIO_WHO_PGRP) vs setuid(2)

Dmitry Baryshkov (1):
      clk: qcom: regmap-mux: fix parent clock lookup

Eric Biggers (5):
      wait: add wake_up_pollfree()
      binder: use wake_up_pollfree()
      signalfd: use wake_up_pollfree()
      aio: keep poll requests on waitqueue until completed
      aio: fix use-after-free due to missing POLLFREE handling

Eric Dumazet (5):
      bonding: make tx_rebalance_counter an atomic
      netfilter: conntrack: annotate data-races around ct->timeout
      devlink: fix netns refcount leak in devlink_nl_cmd_reload()
      net/sched: fq_pie: prevent dismantle issue
      net, neigh: clear whole pneigh_entry at alloc time

Evgeny Boger (1):
      iio: adc: axp20x_adc: fix charging current reporting on AXP22x

Fabrice Gasnier (1):
      iio: adc: stm32: fix a current leak by resetting pcsel before disabling vdda

Florian Westphal (1):
      selftests: netfilter: add a vrf+conntrack testcase

Greg Kroah-Hartman (9):
      HID: add hid_is_usb() function to make it simpler for USB detection
      HID: add USB_HID dependancy to hid-prodikeys
      HID: add USB_HID dependancy to hid-chicony
      HID: add USB_HID dependancy on some USB HID drivers
      HID: wacom: fix problems when device is not a valid USB device
      HID: check for valid USB device for many HID drivers
      USB: gadget: detect too-big endpoint 0 requests
      USB: gadget: zero allocate endpoint 0 buffers
      Linux 5.10.85

Gwendal Grignou (1):
      iio: at91-sama5d2: Fix incorrect sign extension

Hannes Reinecke (1):
      libata: add horkage for ASMedia 1092

Hans de Goede (1):
      HID: quirks: Add quirk for the Microsoft Surface 3 type-cover

Herve Codina (2):
      mtd: rawnand: fsmc: Take instruction delay into account
      mtd: rawnand: fsmc: Fix timing computation

Ian Rogers (1):
      perf tools: Fix SMT detection fast read path

Igor Pylypiv (1):
      scsi: pm80xx: Do not call scsi_remove_host() in pm8001_alloc()

J. Bruce Fields (1):
      nfsd: fix use-after-free due to delegation race

James Zhu (3):
      drm/amdkfd: separate kfd_iommu_resume from kfd_resume
      drm/amdgpu: add amdgpu_amdkfd_resume_iommu
      drm/amdgpu: move iommu_resume before ip init/resume

Jesse Brandeburg (1):
      ice: ignore dropped packets during init

Jeya R (1):
      misc: fastrpc: fix improper packet size calculation

Jianglei Nie (1):
      nfp: Fix memory leak in nfp_cpp_area_cache_add()

Jianguo Wu (1):
      udp: using datalen to cap max gso segments

Jimmy Assarsson (2):
      can: kvaser_usb: get CAN clock frequency from device
      can: kvaser_pciefd: kvaser_pciefd_rx_error_frame(): increase correct stats->{rx,tx}_errors counter

Joakim Zhang (1):
      net: fec: only clear interrupt of handling queue in fec_enet_rx_queue()

Josef Bacik (1):
      btrfs: clear extent buffer uptodate when we fail to write it

Kai-Heng Feng (1):
      xhci: Remove CONFIG_USB_DEFAULT_PERSIST to prevent xHCI from runtime suspending

Kailang Yang (1):
      ALSA: hda/realtek - Add headset Mic support for Lenovo ALC897 platform

Karen Sornek (1):
      i40e: Fix failed opcode appearing if handling messages from VF

Kelly Devilliv (1):
      csky: fix typo of fpu config macro

Kister Genesis Jimenez (1):
      iio: gyro: adxrs290: fix data signedness

Krzysztof Kozlowski (1):
      nfc: fix potential NULL pointer deref in nfc_genl_dump_ses_done

Lang Yu (1):
      drm/amd/amdkfd: adjust dummy functions' placement

Lars-Peter Clausen (8):
      iio: trigger: Fix reference counting
      iio: stk3310: Don't return error code in interrupt handler
      iio: mma8452: Fix trigger reference couting
      iio: ltr501: Don't return error code in trigger handler
      iio: kxsd9: Don't return error code in trigger handler
      iio: itg3200: Call iio_trigger_notify_done() on error
      iio: dln2: Check return value of devm_iio_trigger_register()
      iio: ad7768-1: Call iio_trigger_notify_done() on error

Lee Jones (1):
      net: cdc_ncm: Allow for dwNtbOutMaxSize to be unset or zero

Louis Amas (1):
      net: mvpp2: fix XDP rx queues registering

Lukas Bulwahn (1):
      MAINTAINERS: adjust GCC PLUGINS after gcc-plugin.sh removal

Manish Chopra (1):
      qede: validate non LSO skb length

Manjong Lee (1):
      mm: bdi: initialize bdi_min_ratio when bdi is unregistered

Marek Behún (1):
      Revert "PCI: aardvark: Fix support for PCI_ROM_ADDRESS1 on emulated bridge"

Markus Hochholdinger (1):
      md: fix update super 1.0 on rdev size change

Masahiro Yamada (3):
      gcc-plugins: simplify GCC plugin-dev capability test
      kbuild: simplify GCC_PLUGINS enablement in dummy-tools/gcc
      doc: gcc-plugins: update gcc-plugins.rst

Mateusz Palczewski (1):
      i40e: Fix pre-set max number of queues for VF

Mathias Nyman (1):
      xhci: avoid race between disable slot command and host runtime suspend

Maxim Mikityanskiy (2):
      bpf: Fix the off-by-two error in range markings
      bpf: Add selftests to cover packet access corner cases

Michal Maloszewski (1):
      iavf: Fix reporting when setting descriptor count

Mike Marciniszyn (4):
      IB/hfi1: Insure use of smp_processor_id() is preempt disabled
      IB/hfi1: Fix early init panic
      IB/hfi1: Fix leak of rcvhdrtail_dummy_kvaddr
      IB/hfi1: Correct guard on eager buffer deallocation

Miles Chen (1):
      clk: imx: use module_platform_driver

Mitch Williams (1):
      iavf: restore MSI state on reset

Nicolas Dichtel (1):
      vrf: don't run conntrack on vrf with !dflt qdisc

Noralf Trønnes (1):
      iio: dln2-adc: Fix lockdep complaint

Norbert Zulinski (1):
      i40e: Fix NULL pointer dereference in i40e_dbg_dump_desc

Pali Rohár (2):
      irqchip/armada-370-xp: Fix return value of armada_370_xp_msi_alloc()
      irqchip/armada-370-xp: Fix support for Multi-MSI interrupts

Pavel Hofman (2):
      usb: core: config: fix validation of wMaxPacketValue entries
      usb: core: config: using bit mask instead of individual bits

Peilin Ye (1):
      selftests/fib_tests: Rework fib_rp_filter_test()

Qu Wenruo (1):
      btrfs: replace the BUG_ON in btrfs_del_root_ref with proper error handling

Rafael J. Wysocki (1):
      PM: runtime: Fix pm_runtime_active() kerneldoc comment

Rob Clark (1):
      ASoC: rt5682: Fix crash due to out of scope stack vars

Robert Karszniewicz (1):
      Documentation/Kbuild: Remove references to gcc-plugin.sh

Roman Bolshakov (1):
      scsi: qla2xxx: Format log strings only if needed

Sebastian Andrzej Siewior (1):
      Documentation/locking/locktypes: Update migrate_disable() bits.

Shin'ichiro Kawasaki (1):
      scsi: scsi_debug: Fix buffer size of REPORT ZONES command

Srinivas Kandagatla (4):
      ASoC: qdsp6: q6routing: Fix return value from msm_routing_put_audio_mixer
      ASoC: codecs: wsa881x: fix return values from kcontrol put
      ASoC: codecs: wcd934x: handle channel mappping list correctly
      ASoC: codecs: wcd934x: return correct value from mixer put

Stefano Brivio (1):
      nft_set_pipapo: Fix bucket load in AVX2 lookup routine for six 8-bit groups

Steven Rostedt (VMware) (2):
      tracefs: Have new files inherit the ownership of their parent
      tracefs: Set all files to the same group ownership as the mount option

Takashi Iwai (3):
      ALSA: pcm: oss: Fix negative period/buffer sizes
      ALSA: pcm: oss: Limit the period size to 16MB
      ALSA: pcm: oss: Handle missing errors in snd_pcm_oss_change_params*()

Thomas Haemmerle (1):
      usb: gadget: uvc: fix multiple opens

Tom Lendacky (1):
      x86/sme: Explicitly map new EFI memmap table as encrypted

Valdis Kletnieks (1):
      gcc-plugins: fix gcc 11 indigestion with plugins...

Vincent Mailhol (1):
      can: pch_can: pch_can_rx_normal: fix use after free

Vitaly Kuznetsov (1):
      KVM: x86: Wait for IPIs to be delivered when handling Hyper-V TLB flush hypercall

Vladimir Murzin (1):
      irqchip: nvic: Fix offset for Interrupt Priority Offsets

Werner Sembach (1):
      ALSA: hda/realtek: Fix quirk for TongFang PHxTxX1

Wolfram Sang (1):
      mmc: renesas_sdhi: initialize variable properly when tuning

Wudi Wang (1):
      irqchip/irq-gic-v3-its.c: Force synchronisation when issuing INVALL

Yang Yingliang (1):
      iio: accel: kxcjk-1013: Fix possible memory leak in probe and remove

Yangyang Li (2):
      RDMA/hns: Do not halt commands during reset until later
      RDMA/hns: Do not destroy QP resources in the hw resetting phase

Yifan Zhang (2):
      drm/amdgpu: init iommu after amdkfd device init
      drm/amdkfd: fix boot failure when iommu is disabled in Picasso.

xiazhengqiao (1):
      HID: google: add eel USB id

