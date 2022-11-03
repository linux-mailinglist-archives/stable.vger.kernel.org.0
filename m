Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8CB0618074
	for <lists+stable@lfdr.de>; Thu,  3 Nov 2022 16:04:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231921AbiKCPER (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Nov 2022 11:04:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231890AbiKCPCq (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Nov 2022 11:02:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A3331A20B;
        Thu,  3 Nov 2022 08:02:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A1B7CB828D7;
        Thu,  3 Nov 2022 15:02:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12E81C433D6;
        Thu,  3 Nov 2022 15:02:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667487761;
        bh=K1PTm+17o7rlCm9d7IO7Q4ZMhALsdbic7kA4sjyGooc=;
        h=From:To:Cc:Subject:Date:From;
        b=E3QaFb9dkqELYp7t5X2K4R1I9zaHH+8KfEJw1cJH8zOahvBsWRL14QUABvFZGyukT
         HAGPBTDruAe+fbYxIUog3JQ3fxxmnjvZhp2vJI+J8G12NCGr+B9BZIltz2E5fh83gs
         F+236EYD1RGlm/ZM4tcCi97MCYmVtDZy62ikEOs0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.15.77
Date:   Fri,  4 Nov 2022 00:03:13 +0900
Message-Id: <1667487794254161@kroah.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.15.77 kernel.

All users of the 5.15 kernel series must upgrade.

The updated 5.15.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.15.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                                       |    2 
 arch/arc/include/asm/io.h                                      |    2 
 arch/arc/include/asm/pgtable-levels.h                          |    2 
 arch/arc/mm/ioremap.c                                          |    2 
 arch/arm64/include/asm/cputype.h                               |    4 
 arch/arm64/kernel/proton-pack.c                                |    6 
 arch/s390/include/asm/futex.h                                  |    3 
 arch/s390/pci/pci_mmio.c                                       |    8 
 arch/x86/events/intel/lbr.c                                    |    2 
 arch/x86/kernel/unwind_orc.c                                   |    2 
 drivers/base/power/domain.c                                    |    4 
 drivers/counter/microchip-tcb-capture.c                        |   18 
 drivers/cpufreq/intel_pstate.c                                 |  133 -
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c               |    6 
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c                     |   16 
 drivers/gpu/drm/i915/display/intel_dp.c                        |    2 
 drivers/gpu/drm/msm/disp/mdp4/mdp4_lvds_connector.c            |    5 
 drivers/gpu/drm/msm/dp/dp_display.c                            |    2 
 drivers/gpu/drm/msm/dsi/dsi.c                                  |    6 
 drivers/gpu/drm/msm/hdmi/hdmi.c                                |    5 
 drivers/hwtracing/coresight/coresight-cti-core.c               |    5 
 drivers/iio/accel/adxl372.c                                    |   23 
 drivers/iio/light/tsl2583.c                                    |    2 
 drivers/iio/temperature/ltc2983.c                              |   13 
 drivers/media/test-drivers/vivid/vivid-core.c                  |   38 
 drivers/media/test-drivers/vivid/vivid-core.h                  |    2 
 drivers/media/test-drivers/vivid/vivid-vid-cap.c               |   27 
 drivers/media/v4l2-core/v4l2-dv-timings.c                      |   14 
 drivers/mmc/core/block.c                                       |   44 
 drivers/mmc/core/sdio_bus.c                                    |    3 
 drivers/mmc/host/Kconfig                                       |    3 
 drivers/mmc/host/sdhci-esdhc-imx.c                             |   14 
 drivers/mmc/host/sdhci-pci-core.c                              |   14 
 drivers/mtd/nand/raw/intel-nand-controller.c                   |   19 
 drivers/mtd/nand/raw/marvell_nand.c                            |    2 
 drivers/net/can/mscan/mpc5xxx_can.c                            |    8 
 drivers/net/can/rcar/rcar_canfd.c                              |   24 
 drivers/net/can/spi/mcp251x.c                                  |    5 
 drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c              |    4 
 drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c               |    4 
 drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c                    |   17 
 drivers/net/ethernet/aquantia/atlantic/aq_macsec.c             |   96 -
 drivers/net/ethernet/aquantia/atlantic/aq_nic.h                |    2 
 drivers/net/ethernet/broadcom/bcm4908_enet.c                   |   10 
 drivers/net/ethernet/broadcom/bcmsysport.c                     |    3 
 drivers/net/ethernet/cadence/macb_main.c                       |    1 
 drivers/net/ethernet/freescale/enetc/enetc.c                   |    5 
 drivers/net/ethernet/freescale/fec_main.c                      |   46 
 drivers/net/ethernet/huawei/hinic/hinic_debugfs.c              |   18 
 drivers/net/ethernet/huawei/hinic/hinic_hw_cmdq.c              |    2 
 drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c               |    2 
 drivers/net/ethernet/huawei/hinic/hinic_sriov.c                |    1 
 drivers/net/ethernet/ibm/ehea/ehea_main.c                      |    1 
 drivers/net/ethernet/intel/i40e/i40e_ethtool.c                 |  100 -
 drivers/net/ethernet/intel/i40e/i40e_type.h                    |    4 
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c             |   43 
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.h             |    1 
 drivers/net/ethernet/lantiq_etop.c                             |    1 
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c                  |   10 
 drivers/net/ethernet/mellanox/mlx5/core/en/ptp.h               |    9 
 drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h              |    6 
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c       |    3 
 drivers/net/ethernet/mellanox/mlx5/core/en_tx.c                |    6 
 drivers/net/ethernet/mellanox/mlx5/core/lib/mpfs.c             |    6 
 drivers/net/ethernet/mellanox/mlx5/core/main.c                 |   55 
 drivers/net/ethernet/micrel/ksz884x.c                          |    2 
 drivers/net/ethernet/socionext/netsec.c                        |    2 
 drivers/net/ethernet/socionext/sni_ave.c                       |    6 
 drivers/net/netdevsim/dev.c                                    |   11 
 drivers/nfc/virtual_ncidev.c                                   |    3 
 drivers/pinctrl/pinctrl-ingenic.c                              |    4 
 drivers/scsi/lpfc/lpfc.h                                       |   40 
 drivers/scsi/lpfc/lpfc_bsg.c                                   |   50 
 drivers/scsi/lpfc/lpfc_crtn.h                                  |    3 
 drivers/scsi/lpfc/lpfc_ct.c                                    |    8 
 drivers/scsi/lpfc/lpfc_els.c                                   |  139 -
 drivers/scsi/lpfc/lpfc_hw4.h                                   |    7 
 drivers/scsi/lpfc/lpfc_init.c                                  |   13 
 drivers/scsi/lpfc/lpfc_nportdisc.c                             |    4 
 drivers/scsi/lpfc/lpfc_nvme.c                                  |   34 
 drivers/scsi/lpfc/lpfc_nvme.h                                  |    6 
 drivers/scsi/lpfc/lpfc_nvmet.c                                 |   83 
 drivers/scsi/lpfc/lpfc_scsi.c                                  |  441 ++---
 drivers/scsi/lpfc/lpfc_sli.c                                   |  876 +++++-----
 drivers/scsi/lpfc/lpfc_sli.h                                   |   26 
 drivers/scsi/qla2xxx/qla_attr.c                                |   28 
 drivers/scsi/sd.c                                              |    3 
 drivers/staging/media/atomisp/pci/sh_css_params.c              |    4 
 drivers/tty/serial/8250/8250_omap.c                            |    3 
 drivers/tty/serial/8250/8250_pci.c                             |    9 
 drivers/tty/serial/8250/8250_port.c                            |   12 
 drivers/tty/serial/fsl_lpuart.c                                |    8 
 drivers/tty/serial/imx.c                                       |    8 
 drivers/tty/serial/serial_core.c                               |   61 
 drivers/usb/core/quirks.c                                      |    9 
 drivers/usb/dwc3/gadget.c                                      |    8 
 drivers/usb/gadget/function/uvc_queue.c                        |    8 
 drivers/usb/gadget/function/uvc_video.c                        |   22 
 drivers/usb/gadget/udc/bdc/bdc_udc.c                           |    1 
 drivers/usb/host/xhci-mem.c                                    |   20 
 drivers/usb/host/xhci-pci.c                                    |   44 
 drivers/usb/host/xhci.c                                        |   10 
 drivers/usb/host/xhci.h                                        |    1 
 drivers/video/fbdev/smscufx.c                                  |   55 
 fs/binfmt_elf.c                                                |    3 
 fs/exec.c                                                      |    4 
 fs/kernfs/dir.c                                                |    5 
 fs/nfs/nfs4namespace.c                                         |    9 
 fs/nfs/nfs4proc.c                                              |   34 
 fs/nfs/nfs4state.c                                             |    9 
 fs/nfs/nfs4xdr.c                                               |    4 
 include/linux/mlx5/driver.h                                    |    2 
 include/linux/nfs_xdr.h                                        |    2 
 include/linux/perf_event.h                                     |   19 
 include/media/v4l2-common.h                                    |    3 
 include/net/sock.h                                             |    2 
 include/uapi/linux/videodev2.h                                 |    3 
 kernel/events/core.c                                           |  153 +
 kernel/events/ring_buffer.c                                    |    2 
 kernel/power/hibernate.c                                       |    2 
 kernel/sched/sched.h                                           |   18 
 net/can/j1939/transport.c                                      |    4 
 net/core/net_namespace.c                                       |    7 
 net/core/skbuff.c                                              |    2 
 net/ethtool/eeprom.c                                           |    2 
 net/ieee802154/socket.c                                        |    4 
 net/ipv4/nexthop.c                                             |    2 
 net/ipv4/tcp_input.c                                           |    3 
 net/ipv4/tcp_ipv4.c                                            |    7 
 net/ipv6/ip6_gre.c                                             |   12 
 net/ipv6/ip6_tunnel.c                                          |   11 
 net/ipv6/ipv6_sockglue.c                                       |    7 
 net/ipv6/sit.c                                                 |    8 
 net/kcm/kcmsock.c                                              |   25 
 net/mac802154/rx.c                                             |    5 
 net/openvswitch/datapath.c                                     |    3 
 net/tipc/topsrv.c                                              |   16 
 sound/aoa/soundbus/i2sbus/core.c                               |    7 
 sound/pci/ac97/ac97_codec.c                                    |    1 
 sound/pci/au88x0/au88x0.h                                      |    6 
 sound/pci/au88x0/au88x0_core.c                                 |    2 
 sound/pci/rme9652/hdsp.c                                       |   26 
 sound/pci/rme9652/rme9652.c                                    |   22 
 sound/soc/qcom/lpass-cpu.c                                     |   10 
 sound/synth/emux/emux.c                                        |    7 
 sound/usb/implicit.c                                           |    2 
 tools/iio/iio_utils.c                                          |    4 
 tools/perf/pmu-events/arch/arm64/hisilicon/hip08/metrics.json  |    6 
 tools/perf/pmu-events/arch/powerpc/power10/nest_metrics.json   |   72 
 tools/perf/util/auxtrace.c                                     |   10 
 tools/testing/selftests/kvm/memslot_modification_stress_test.c |    2 
 151 files changed, 2129 insertions(+), 1458 deletions(-)

Aaron Conole (1):
      openvswitch: switch from WARN to pr_warn

Adrian Hunter (1):
      perf auxtrace: Fix address filter symbol name match for modules

Alexander Stein (1):
      media: v4l2: Fix v4l2_i2c_subdev_set_name function documentation

Ankit Nautiyal (1):
      drm/i915/dp: Reset frl trained flag before restarting FRL training

Anssi Hannula (1):
      can: kvaser_usb: Fix possible completions during init_completion

Aya Levin (1):
      net/mlx5e: Extend SKB room check to include PTP-SQ

Benjamin Coddington (1):
      NFSv4: Fix free of uninitialized nfs4_label on referral lookup.

Bernd Edlinger (1):
      exec: Copy oldsighand->action under spin-lock

Biju Das (2):
      can: rcar_canfd: fix channel specific IRQ handling for RZ/G2L
      can: rcar_canfd: rcar_canfd_handle_global_receive(): fix IRQ storm on global FIFO receive

Brian Norris (1):
      mmc: sdhci_am654: 'select', not 'depends' REGMAP_MMIO

Chen Zhongjin (1):
      x86/unwind/orc: Fix unreliable stack dump with gcov

Christian A. Ehrhardt (1):
      kernfs: fix use-after-free in __kernfs_remove

Christian Löhle (1):
      mmc: block: Remove error check of hw_reset on reset

Colin Ian King (1):
      net: broadcom: bcm4908enet: remove redundant variable bytes

Cosmin Tanislav (1):
      iio: temperature: ltc2983: allocate iio channels once

D Scott Phillips (1):
      arm64: Add AMPERE1 to the Spectre-BHB affected list

Dan Carpenter (1):
      media: atomisp: prevent integer overflow in sh_css_set_black_frame()

Dan Vacura (1):
      usb: gadget: uvc: fix sg handling in error case

Dongliang Mu (2):
      can: mscan: mpc5xxx: mpc5xxx_can_probe(): add missing put_clock() in error path
      can: mcp251x: mcp251x_can_probe(): add missing unregister_candev() in error path

Eric Dumazet (6):
      kcm: annotate data-races around kcm->rx_psock
      kcm: annotate data-races around kcm->rx_wait
      tcp: minor optimization in tcp_add_backlog()
      ipv6: ensure sane device mtu in tunnels
      net: do not sense pfmemalloc status in skb_append_pagefrags()
      kcm: do not sense pfmemalloc status in kcm_sendpage()

Florian Fainelli (1):
      net: bcmsysport: Indicate MAC is in charge of PHY PM

Gavin Shan (1):
      KVM: selftests: Fix number of pages for memory slot in memslot_modification_stress_test

Greg Kroah-Hartman (1):
      Linux 5.15.77

Hannu Hartikainen (1):
      USB: add RESET_RESUME quirk for NVIDIA Jetson devices in RCM

Hans Verkuil (5):
      media: vivid: s_fbuf: add more sanity checks
      media: vivid: dev->bitmap_cap wasn't freed in all cases
      media: v4l2-dv-timings: add sanity checks for blanking values
      media: videodev2.h: V4L2_DV_BT_BLANKING_HEIGHT should check 'interlaced'
      media: vivid: set num_in/outputs to 0 if not supported

Heiko Carstens (2):
      s390/futex: add missing EX_TABLE entry to __futex_atomic_op()
      s390/pci: add missing EX_TABLE entries to __pcistg_mio_inuser()/__pcilg_mio_inuser()

Hyong Youb Kim (1):
      net/mlx5e: Do not increment ESN when updating IPsec ESN state

Hyunwoo Kim (1):
      fbdev: smscufx: Fix several use-after-free bugs

Jakub Kicinski (1):
      net-memcg: avoid stalls when under memory pressure

James Clark (1):
      coresight: cti: Fix hang in cti_disable_hw()

James Smart (6):
      Revert "scsi: lpfc: Resolve some cleanup issues following SLI path refactoring"
      Revert "scsi: lpfc: Fix element offset in __lpfc_sli_release_iocbq_s4()"
      Revert "scsi: lpfc: Fix locking for lpfc_sli_iocbq_lookup()"
      Revert "scsi: lpfc: SLI path split: Refactor SCSI paths"
      Revert "scsi: lpfc: SLI path split: Refactor fast and slow paths to native SLI4"
      Revert "scsi: lpfc: SLI path split: Refactor lpfc_iocbq"

Jason A. Donenfeld (2):
      ALSA: au88x0: use explicitly signed char
      ALSA: rme9652: use explicitly signed char

Jeff Vanhoof (1):
      usb: gadget: uvc: fix sg handling during video encode

Jens Glathe (1):
      usb: xhci: add XHCI_SPURIOUS_SUCCESS to ASM1042 despite being a V0.96 controller

Johan Hovold (3):
      drm/msm/dsi: fix memory corruption with too many bridges
      drm/msm/hdmi: fix memory corruption with too many bridges
      drm/msm/dp: fix IRQ lifetime

Juergen Borleis (1):
      net: fec: limit register access on i.MX6UL

Justin Chen (1):
      usb: bdc: change state when port disconnected

Kajol Jain (1):
      perf vendor events power10: Fix hv-24x7 metric events

Kunihiko Hayashi (1):
      net: ethernet: ave: Fix MAC to be in charge of PHY PM

Kuniyuki Iwashima (1):
      tcp/udp: Fix memory leak in ipv6_renew_options().

Li Zetao (1):
      fs/binfmt_elf: Fix memory leak in load_elf_binary()

Lin Shengwang (1):
      sched/core: Fix comparison in sched_group_cookie_match()

Lino Sanfilippo (1):
      serial: core: move RS485 configuration tasks from drivers into core

Lu Wei (1):
      tcp: fix a signed-integer-overflow bug in tcp_add_backlog()

Lukas Wunner (1):
      serial: Deassert Transmit Enable on probe in driver-specific way

Manish Rangankar (1):
      scsi: qla2xxx: Use transport-defined speed mask for supported_speeds

Mario Limonciello (2):
      xhci-pci: Set runtime PM as default policy on all xHC 1.2 or later devices
      PM: hibernate: Allow hybrid sleep to work with s2idle

Mathias Nyman (2):
      xhci: Add quirk to reset host back to default state at shutdown
      xhci: Remove device endpoints from bandwidth list when freeing the device

Matthew Ma (1):
      mmc: core: Fix kernel panic when remove non-standard SDIO card

Matti Vaittinen (2):
      tools: iio: iio_utils: fix digit calculation
      iio: adxl372: Fix unsafe buffer attributes

Maxim Levitsky (1):
      perf/x86/intel/lbr: Use setup_clear_cpu_cap() instead of clear_cpu_cap()

Miquel Raynal (1):
      mac802154: Fix LQI recording

Nathan Huckleberry (1):
      drm/msm: Fix return type of mdp4_lvds_connector_mode_valid

Neal Cardwell (1):
      tcp: fix indefinite deferral of RTO with SACK reneging

Nicolas Dichtel (1):
      nh: fix scope used to find saddr when adding non gw nh

Patrick Thompson (1):
      mmc: sdhci-pci-core: Disable ES for ASUS BIOS on Jasper Lake

Pavel Kozlov (1):
      ARC: mm: fix leakage of memory allocated for PTE

Peter Zijlstra (1):
      perf: Fix missing SIGTRAPs

Prike Liang (1):
      drm/amdgpu: disallow gfxoff until GC IP blocks complete s2idle resume

Rafael J. Wysocki (2):
      cpufreq: intel_pstate: Read all MSRs on the target CPU
      cpufreq: intel_pstate: hybrid: Use known scaling factor for P-cores

Rafael Mendonca (1):
      drm/amdkfd: Fix memory leak in kfd_mem_dmamap_userptr()

Rafał Miłecki (1):
      net: broadcom: bcm4908_enet: update TX stats after actual transmission

Raju Rangoju (2):
      amd-xgbe: fix the SFP compliance codes check for DAC cables
      amd-xgbe: add the bit rate quirk for Molex cables

Randy Dunlap (1):
      arc: iounmap() arg is volatile

Roy Novich (1):
      net/mlx5: Update fw fatal reporter state on PCI handlers successful recover

Saeed Mahameed (1):
      net/mlx5: Print more info on pci error handlers

Sascha Hauer (1):
      mmc: sdhci-esdhc-imx: Propagate ESDHC_FLAG_HS400* only on 8bit bus

Scott Mayhew (1):
      NFSv4: Add an fattr allocation to _nfs4_discover_trunking()

Sergiu Moga (1):
      net: macb: Specify PHY PM management done by MAC

Shang XiaoJing (2):
      nfc: virtual_ncidev: Fix memory leak in virtual_nci_send()
      perf vendor events arm64: Fix incorrect Hisi hip08 L3 metrics

Shreeya Patel (1):
      iio: light: tsl2583: Fix module unloading

Siarhei Volkau (1):
      pinctrl: Ingenic: JZ4755 bug fixes

Slawomir Laba (2):
      i40e: Fix ethtool rx-flow-hash setting for X722
      i40e: Fix flow-type by setting GL_HASH_INSET registers

Srinivasa Rao Mandadapu (2):
      ASoC: qcom: lpass-cpu: mark HDMI TX registers as volatile
      ASoC: qcom: lpass-cpu: Mark HDMI TX parity register as volatile

Steven Rostedt (Google) (1):
      ALSA: Use del_timer_sync() before freeing timer

Sudeep Holla (1):
      PM: domains: Fix handling of unavailable/disabled idle states

Suresh Devarakonda (1):
      net/mlx5: Fix crash during sync firmware reset

Sylwester Dziedziuch (1):
      i40e: Fix VF hang when reset is triggered on another VF

Takashi Iwai (2):
      ALSA: usb-audio: Add quirks for M-Audio Fast Track C400/600
      ALSA: aoa: Fix I2S device accounting

Tariq Toukan (1):
      net/mlx5: Fix possible use-after-free in async command interface

Thinh Nguyen (2):
      usb: dwc3: gadget: Stop processing more requests on IMI
      usb: dwc3: gadget: Don't set IMI for no_interrupt

Tony O'Brien (1):
      mtd: rawnand: marvell: Use correct logic for nand-keep-config

Vladimir Oltean (1):
      net: enetc: survive memory pressure without crashing

Wei Yongjun (1):
      net: ieee802154: fix error return code in dgram_bind()

William Breathitt Gray (1):
      counter: microchip-tcb-capture: Handle Signal1 read and Synapse

Xin Long (2):
      ethtool: eeprom: fix null-deref on genl_info in dump
      tipc: fix a null-ptr-deref in tipc_topsrv_accept

Yang Yingliang (7):
      can: j1939: transport: j1939_session_skb_drop_old(): spin_unlock_irqrestore() before kfree_skb()
      mtd: rawnand: intel: Add missing of_node_put() in ebu_nand_probe()
      ALSA: ac97: fix possible memory leak in snd_ac97_dev_register()
      net: netsec: fix error handling in netsec_register_mdio()
      net: ksz884x: fix missing pci_disable_device() on error in pcidev_init()
      ALSA: aoa: i2sbus: fix possible memory leak in i2sbus_add_dev()
      net: ehea: fix possible memory leak in ehea_register_port()

Yu Kuai (1):
      scsi: sd: Revert "scsi: sd: Remove a local variable"

Zhang Changzhong (1):
      net: lantiq_etop: don't free skb when returning NETDEV_TX_BUSY

Zhengchao Shao (6):
      net: hinic: fix incorrect assignment issue in hinic_set_interrupt_cfg()
      net: hinic: fix memory leak when reading function table
      net: hinic: fix the issue of CMDQ memory leaks
      net: hinic: fix the issue of double release MBOX callback of VF
      net: fix UAF issue in nfqnl_nf_hook_drop() when ops_init() failed
      netdevsim: remove dir in nsim_dev_debugfs_init() when creating ports dir failed

Íñigo Huguet (1):
      atlantic: fix deadlock at aq_nic_stop

