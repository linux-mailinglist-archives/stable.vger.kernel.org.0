Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A4D8473FE7
	for <lists+stable@lfdr.de>; Tue, 14 Dec 2021 10:52:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231148AbhLNJwh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Dec 2021 04:52:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232742AbhLNJw3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Dec 2021 04:52:29 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A53EDC061748;
        Tue, 14 Dec 2021 01:52:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 358DA61425;
        Tue, 14 Dec 2021 09:52:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10B8CC34600;
        Tue, 14 Dec 2021 09:52:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639475548;
        bh=rMumAkeJS0ptGaK9xSuXzMc2xM2OWTU9K2MX+kmf/9c=;
        h=From:To:Cc:Subject:Date:From;
        b=So+ojLLy800FrCqMT4N4gKM64cyf9u6oBtWC1MQbZC/+T9PFetGzBVEsBlSEUEEJi
         87UciIqfZ4MAd0+IrMrt2KptK8J/HXcQvW9T7buxDBsgAf2O0GcXr19FPQmF4q7dEA
         Ug2QsA990cE2OWLXu1xG1zP1CktZXXHJhMR6HlCs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.19.221
Date:   Tue, 14 Dec 2021 10:52:21 +0100
Message-Id: <16394755428513@kroah.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.19.221 kernel.

All users of the 4.19 kernel series must upgrade.

The updated 4.19.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.19.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                                 |    2 
 block/ioprio.c                                           |    3 
 drivers/android/binder.c                                 |   21 -
 drivers/ata/libata-core.c                                |    2 
 drivers/clk/qcom/clk-regmap-mux.c                        |    2 
 drivers/clk/qcom/common.c                                |   12 
 drivers/clk/qcom/common.h                                |    2 
 drivers/hid/Kconfig                                      |   10 
 drivers/hid/hid-asus.c                                   |    2 
 drivers/hid/hid-chicony.c                                |    8 
 drivers/hid/hid-corsair.c                                |    7 
 drivers/hid/hid-elan.c                                   |    2 
 drivers/hid/hid-elo.c                                    |    3 
 drivers/hid/hid-google-hammer.c                          |    2 
 drivers/hid/hid-holtek-kbd.c                             |    9 
 drivers/hid/hid-holtek-mouse.c                           |    9 
 drivers/hid/hid-ids.h                                    |    1 
 drivers/hid/hid-lg.c                                     |   10 
 drivers/hid/hid-prodikeys.c                              |   10 
 drivers/hid/hid-roccat-arvo.c                            |    3 
 drivers/hid/hid-roccat-isku.c                            |    3 
 drivers/hid/hid-roccat-kone.c                            |    3 
 drivers/hid/hid-roccat-koneplus.c                        |    3 
 drivers/hid/hid-roccat-konepure.c                        |    3 
 drivers/hid/hid-roccat-kovaplus.c                        |    3 
 drivers/hid/hid-roccat-lua.c                             |    3 
 drivers/hid/hid-roccat-pyra.c                            |    3 
 drivers/hid/hid-roccat-ryos.c                            |    3 
 drivers/hid/hid-roccat-savu.c                            |    3 
 drivers/hid/hid-samsung.c                                |    3 
 drivers/hid/hid-uclogic.c                                |    3 
 drivers/hid/wacom_sys.c                                  |   19 +
 drivers/iio/accel/kxcjk-1013.c                           |    5 
 drivers/iio/accel/kxsd9.c                                |    6 
 drivers/iio/accel/mma8452.c                              |    2 
 drivers/iio/adc/at91-sama5d2_adc.c                       |    3 
 drivers/iio/adc/axp20x_adc.c                             |   18 -
 drivers/iio/adc/dln2-adc.c                               |   21 -
 drivers/iio/gyro/itg3200_buffer.c                        |    2 
 drivers/iio/industrialio-trigger.c                       |    1 
 drivers/iio/light/ltr501.c                               |    2 
 drivers/iio/light/stk3310.c                              |    6 
 drivers/iio/trigger/stm32-timer-trigger.c                |    2 
 drivers/infiniband/hw/hfi1/init.c                        |    2 
 drivers/irqchip/irq-armada-370-xp.c                      |   16 -
 drivers/irqchip/irq-gic-v3-its.c                         |    2 
 drivers/irqchip/irq-nvic.c                               |    2 
 drivers/mtd/nand/raw/fsmc_nand.c                         |    4 
 drivers/net/bonding/bond_alb.c                           |   14 -
 drivers/net/can/m_can/m_can.c                            |   14 -
 drivers/net/can/pch_can.c                                |    2 
 drivers/net/can/sja1000/ems_pcmcia.c                     |    7 
 drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c         |  101 +++++---
 drivers/net/ethernet/altera/altera_tse_main.c            |    9 
 drivers/net/ethernet/freescale/fec.h                     |    3 
 drivers/net/ethernet/freescale/fec_main.c                |    2 
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c       |    5 
 drivers/net/ethernet/intel/ice/ice_main.c                |    3 
 drivers/net/ethernet/netronome/nfp/nfpcore/nfp_cppcore.c |    4 
 drivers/net/ethernet/qlogic/qede/qede_fp.c               |    7 
 drivers/net/ethernet/qlogic/qla3xxx.c                    |   19 -
 drivers/net/usb/cdc_ncm.c                                |    2 
 drivers/usb/core/config.c                                |    6 
 drivers/usb/gadget/composite.c                           |   14 +
 drivers/usb/gadget/legacy/dbgp.c                         |   15 +
 drivers/usb/gadget/legacy/inode.c                        |   16 +
 drivers/usb/host/xhci-hub.c                              |    1 
 drivers/usb/host/xhci-ring.c                             |    1 
 drivers/usb/host/xhci.c                                  |   26 +-
 fs/aio.c                                                 |  184 ++++++++++++---
 fs/signalfd.c                                            |   12 
 fs/tracefs/inode.c                                       |   76 ++++++
 include/linux/hid.h                                      |    5 
 include/linux/rtnetlink.h                                |    7 
 include/linux/wait.h                                     |   26 ++
 include/net/bond_alb.h                                   |    2 
 include/net/pkt_sched.h                                  |    1 
 include/net/sch_generic.h                                |   17 +
 include/uapi/asm-generic/poll.h                          |    2 
 kernel/bpf/verifier.c                                    |    2 
 kernel/sched/wait.c                                      |    7 
 mm/backing-dev.c                                         |    7 
 net/core/neighbour.c                                     |    2 
 net/core/rtnetlink.c                                     |    6 
 net/ipv4/udp.c                                           |    2 
 net/ipv6/seg6_iptunnel.c                                 |    8 
 net/nfc/netlink.c                                        |    6 
 net/sched/cls_api.c                                      |   81 +++++-
 net/sched/sch_api.c                                      |   24 +
 net/sched/sch_atm.c                                      |    2 
 net/sched/sch_cbq.c                                      |    2 
 net/sched/sch_cbs.c                                      |    2 
 net/sched/sch_drr.c                                      |    4 
 net/sched/sch_dsmark.c                                   |    2 
 net/sched/sch_fifo.c                                     |    2 
 net/sched/sch_generic.c                                  |   48 +++
 net/sched/sch_hfsc.c                                     |    2 
 net/sched/sch_htb.c                                      |    4 
 net/sched/sch_mq.c                                       |    4 
 net/sched/sch_mqprio.c                                   |    4 
 net/sched/sch_multiq.c                                   |    6 
 net/sched/sch_netem.c                                    |    2 
 net/sched/sch_prio.c                                     |    6 
 net/sched/sch_qfq.c                                      |    4 
 net/sched/sch_red.c                                      |    4 
 net/sched/sch_sfb.c                                      |    4 
 net/sched/sch_tbf.c                                      |    4 
 sound/core/control_compat.c                              |    3 
 sound/core/oss/pcm_oss.c                                 |   37 ++-
 sound/soc/qcom/qdsp6/q6routing.c                         |    8 
 tools/build/Makefile.feature                             |    1 
 tools/build/feature/Makefile                             |    4 
 tools/build/feature/test-all.c                           |    5 
 tools/build/feature/test-libpython-version.c             |   11 
 tools/perf/Makefile.config                               |    2 
 115 files changed, 874 insertions(+), 317 deletions(-)

Alan Young (1):
      ALSA: ctl: Fix copy of updated id with element read/write

Alyssa Ross (1):
      iio: trigger: stm32-timer: fix MODULE_ALIAS

Andrea Mayer (1):
      seg6: fix the iif in the IPv6 socket control block

Arnaldo Carvalho de Melo (1):
      tools build: Remove needless libpython-version feature check that breaks test-all fast path

Brian Silverman (1):
      can: m_can: Disable and ignore ELO interrupt

Cong Wang (1):
      net_sched: fix a crash in tc_new_tfilter()

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

Eric Dumazet (2):
      bonding: make tx_rebalance_counter an atomic
      net, neigh: clear whole pneigh_entry at alloc time

Evgeny Boger (1):
      iio: adc: axp20x_adc: fix charging current reporting on AXP22x

Greg Kroah-Hartman (9):
      HID: add hid_is_usb() function to make it simpler for USB detection
      HID: add USB_HID dependancy to hid-prodikeys
      HID: add USB_HID dependancy to hid-chicony
      HID: add USB_HID dependancy on some USB HID drivers
      HID: wacom: fix problems when device is not a valid USB device
      HID: check for valid USB device for many HID drivers
      USB: gadget: detect too-big endpoint 0 requests
      USB: gadget: zero allocate endpoint 0 buffers
      Linux 4.19.221

Gwendal Grignou (1):
      iio: at91-sama5d2: Fix incorrect sign extension

Hannes Reinecke (1):
      libata: add horkage for ASMedia 1092

Herve Codina (1):
      mtd: rawnand: fsmc: Take instruction delay into account

Jesse Brandeburg (1):
      ice: ignore dropped packets during init

Jianglei Nie (1):
      nfp: Fix memory leak in nfp_cpp_area_cache_add()

Jianguo Wu (1):
      udp: using datalen to cap max gso segments

Jimmy Assarsson (1):
      can: kvaser_usb: get CAN clock frequency from device

Joakim Zhang (1):
      net: fec: only clear interrupt of handling queue in fec_enet_rx_queue()

Kai-Heng Feng (1):
      xhci: Remove CONFIG_USB_DEFAULT_PERSIST to prevent xHCI from runtime suspending

Krzysztof Kozlowski (1):
      nfc: fix potential NULL pointer deref in nfc_genl_dump_ses_done

Lars-Peter Clausen (7):
      iio: trigger: Fix reference counting
      iio: stk3310: Don't return error code in interrupt handler
      iio: mma8452: Fix trigger reference couting
      iio: ltr501: Don't return error code in trigger handler
      iio: kxsd9: Don't return error code in trigger handler
      iio: itg3200: Call iio_trigger_notify_done() on error
      iio: dln2: Check return value of devm_iio_trigger_register()

Lee Jones (1):
      net: cdc_ncm: Allow for dwNtbOutMaxSize to be unset or zero

Manish Chopra (1):
      qede: validate non LSO skb length

Manjong Lee (1):
      mm: bdi: initialize bdi_min_ratio when bdi is unregistered

Mateusz Palczewski (1):
      i40e: Fix pre-set max number of queues for VF

Mathias Nyman (1):
      xhci: avoid race between disable slot command and host runtime suspend

Maxim Mikityanskiy (1):
      bpf: Fix the off-by-two error in range markings

Mike Marciniszyn (1):
      IB/hfi1: Correct guard on eager buffer deallocation

Noralf Trønnes (1):
      iio: dln2-adc: Fix lockdep complaint

Pali Rohár (2):
      irqchip/armada-370-xp: Fix return value of armada_370_xp_msi_alloc()
      irqchip/armada-370-xp: Fix support for Multi-MSI interrupts

Pavel Hofman (2):
      usb: core: config: fix validation of wMaxPacketValue entries
      usb: core: config: using bit mask instead of individual bits

Srinivas Kandagatla (1):
      ASoC: qdsp6: q6routing: Fix return value from msm_routing_put_audio_mixer

Steven Rostedt (VMware) (2):
      tracefs: Have new files inherit the ownership of their parent
      tracefs: Set all files to the same group ownership as the mount option

Takashi Iwai (3):
      ALSA: pcm: oss: Fix negative period/buffer sizes
      ALSA: pcm: oss: Limit the period size to 16MB
      ALSA: pcm: oss: Handle missing errors in snd_pcm_oss_change_params*()

Vincent Mailhol (1):
      can: pch_can: pch_can_rx_normal: fix use after free

Vlad Buslov (5):
      net: core: netlink: add helper refcount dec and lock function
      net: sched: rename qdisc_destroy() to qdisc_put()
      net: sched: extend Qdisc with rcu
      net: sched: add helper function to take reference to Qdisc
      net: sched: use Qdisc rcu API instead of relying on rtnl lock

Vladimir Murzin (1):
      irqchip: nvic: Fix offset for Interrupt Priority Offsets

Wei Yongjun (1):
      net: sched: make function qdisc_free_cb() static

Wudi Wang (1):
      irqchip/irq-gic-v3-its.c: Force synchronisation when issuing INVALL

Yang Yingliang (1):
      iio: accel: kxcjk-1013: Fix possible memory leak in probe and remove

xiazhengqiao (1):
      HID: google: add eel USB id

