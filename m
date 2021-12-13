Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED028472587
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 10:44:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235462AbhLMJoH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 04:44:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235765AbhLMJmS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 04:42:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F355C08EA6C;
        Mon, 13 Dec 2021 01:39:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 48919B80D1F;
        Mon, 13 Dec 2021 09:39:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 843FBC341DE;
        Mon, 13 Dec 2021 09:39:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639388383;
        bh=t9ZB0AkoqWUe1WAITzRdSMxhyKpW1CjRHUMWB+nIVSM=;
        h=From:To:Cc:Subject:Date:From;
        b=dQ5ci840MncRP8+Jq6uIob+uPpGspZx83IZZRrP8PEOixmrn1jMmljq6yOPIjp1KU
         WLZsmGNVSRjzX1wM/Ne5YX3q5Ap/Z2F6tvt6XF2IK1LefqF1AL8ypOD0PjUySt8rdI
         zmeNI7V2qUKwD4c5APbaTmO4LupboahKt7chcGGQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 4.19 00/74] 4.19.221-rc1 review
Date:   Mon, 13 Dec 2021 10:29:31 +0100
Message-Id: <20211213092930.763200615@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.221-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.221-rc1
X-KernelTest-Deadline: 2021-12-15T09:29+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.19.221 release.
There are 74 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 15 Dec 2021 09:29:16 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.221-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.19.221-rc1

Wei Yongjun <weiyongjun1@huawei.com>
    net: sched: make function qdisc_free_cb() static

Cong Wang <xiyou.wangcong@gmail.com>
    net_sched: fix a crash in tc_new_tfilter()

Vladimir Murzin <vladimir.murzin@arm.com>
    irqchip: nvic: Fix offset for Interrupt Priority Offsets

Wudi Wang <wangwudi@hisilicon.com>
    irqchip/irq-gic-v3-its.c: Force synchronisation when issuing INVALL

Pali Rohár <pali@kernel.org>
    irqchip/armada-370-xp: Fix support for Multi-MSI interrupts

Pali Rohár <pali@kernel.org>
    irqchip/armada-370-xp: Fix return value of armada_370_xp_msi_alloc()

Yang Yingliang <yangyingliang@huawei.com>
    iio: accel: kxcjk-1013: Fix possible memory leak in probe and remove

Evgeny Boger <boger@wirenboard.com>
    iio: adc: axp20x_adc: fix charging current reporting on AXP22x

Gwendal Grignou <gwendal@chromium.org>
    iio: at91-sama5d2: Fix incorrect sign extension

Lars-Peter Clausen <lars@metafoo.de>
    iio: dln2: Check return value of devm_iio_trigger_register()

Noralf Trønnes <noralf@tronnes.org>
    iio: dln2-adc: Fix lockdep complaint

Lars-Peter Clausen <lars@metafoo.de>
    iio: itg3200: Call iio_trigger_notify_done() on error

Lars-Peter Clausen <lars@metafoo.de>
    iio: kxsd9: Don't return error code in trigger handler

Lars-Peter Clausen <lars@metafoo.de>
    iio: ltr501: Don't return error code in trigger handler

Lars-Peter Clausen <lars@metafoo.de>
    iio: mma8452: Fix trigger reference couting

Lars-Peter Clausen <lars@metafoo.de>
    iio: stk3310: Don't return error code in interrupt handler

Alyssa Ross <hi@alyssa.is>
    iio: trigger: stm32-timer: fix MODULE_ALIAS

Lars-Peter Clausen <lars@metafoo.de>
    iio: trigger: Fix reference counting

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: avoid race between disable slot command and host runtime suspend

Pavel Hofman <pavel.hofman@ivitera.com>
    usb: core: config: using bit mask instead of individual bits

Kai-Heng Feng <kai.heng.feng@canonical.com>
    xhci: Remove CONFIG_USB_DEFAULT_PERSIST to prevent xHCI from runtime suspending

Pavel Hofman <pavel.hofman@ivitera.com>
    usb: core: config: fix validation of wMaxPacketValue entries

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    USB: gadget: zero allocate endpoint 0 buffers

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    USB: gadget: detect too-big endpoint 0 requests

Dan Carpenter <dan.carpenter@oracle.com>
    net/qla3xxx: fix an error code in ql_adapter_up()

Eric Dumazet <edumazet@google.com>
    net, neigh: clear whole pneigh_entry at alloc time

Joakim Zhang <qiangqing.zhang@nxp.com>
    net: fec: only clear interrupt of handling queue in fec_enet_rx_queue()

Dan Carpenter <dan.carpenter@oracle.com>
    net: altera: set a couple error code in probe()

Lee Jones <lee.jones@linaro.org>
    net: cdc_ncm: Allow for dwNtbOutMaxSize to be unset or zero

Arnaldo Carvalho de Melo <acme@redhat.com>
    tools build: Remove needless libpython-version feature check that breaks test-all fast path

Herve Codina <herve.codina@bootlin.com>
    mtd: rawnand: fsmc: Take instruction delay into account

Mateusz Palczewski <mateusz.palczewski@intel.com>
    i40e: Fix pre-set max number of queues for VF

Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
    ASoC: qdsp6: q6routing: Fix return value from msm_routing_put_audio_mixer

Manish Chopra <manishc@marvell.com>
    qede: validate non LSO skb length

Davidlohr Bueso <dave@stgolabs.net>
    block: fix ioprio_get(IOPRIO_WHO_PGRP) vs setuid(2)

Steven Rostedt (VMware) <rostedt@goodmis.org>
    tracefs: Set all files to the same group ownership as the mount option

Eric Biggers <ebiggers@google.com>
    aio: fix use-after-free due to missing POLLFREE handling

Eric Biggers <ebiggers@google.com>
    aio: keep poll requests on waitqueue until completed

Eric Biggers <ebiggers@google.com>
    signalfd: use wake_up_pollfree()

Eric Biggers <ebiggers@google.com>
    binder: use wake_up_pollfree()

Eric Biggers <ebiggers@google.com>
    wait: add wake_up_pollfree()

Hannes Reinecke <hare@suse.de>
    libata: add horkage for ASMedia 1092

Tom Lendacky <thomas.lendacky@amd.com>
    x86/sme: Explicitly map new EFI memmap table as encrypted

Brian Silverman <brian.silverman@bluerivertech.com>
    can: m_can: Disable and ignore ELO interrupt

Vincent Mailhol <mailhol.vincent@wanadoo.fr>
    can: pch_can: pch_can_rx_normal: fix use after free

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    clk: qcom: regmap-mux: fix parent clock lookup

Steven Rostedt (VMware) <rostedt@goodmis.org>
    tracefs: Have new files inherit the ownership of their parent

Takashi Iwai <tiwai@suse.de>
    ALSA: pcm: oss: Handle missing errors in snd_pcm_oss_change_params*()

Takashi Iwai <tiwai@suse.de>
    ALSA: pcm: oss: Limit the period size to 16MB

Takashi Iwai <tiwai@suse.de>
    ALSA: pcm: oss: Fix negative period/buffer sizes

Alan Young <consult.awy@gmail.com>
    ALSA: ctl: Fix copy of updated id with element read/write

Manjong Lee <mj0123.lee@samsung.com>
    mm: bdi: initialize bdi_min_ratio when bdi is unregistered

Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>
    IB/hfi1: Correct guard on eager buffer deallocation

Jianguo Wu <wujianguo@chinatelecom.cn>
    udp: using datalen to cap max gso segments

Andrea Mayer <andrea.mayer@uniroma2.it>
    seg6: fix the iif in the IPv6 socket control block

Jianglei Nie <niejianglei2021@163.com>
    nfp: Fix memory leak in nfp_cpp_area_cache_add()

Eric Dumazet <edumazet@google.com>
    bonding: make tx_rebalance_counter an atomic

Jesse Brandeburg <jesse.brandeburg@intel.com>
    ice: ignore dropped packets during init

Maxim Mikityanskiy <maximmi@nvidia.com>
    bpf: Fix the off-by-two error in range markings

Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
    nfc: fix potential NULL pointer deref in nfc_genl_dump_ses_done

Vlad Buslov <vladbu@mellanox.com>
    net: sched: use Qdisc rcu API instead of relying on rtnl lock

Vlad Buslov <vladbu@mellanox.com>
    net: sched: add helper function to take reference to Qdisc

Vlad Buslov <vladbu@mellanox.com>
    net: sched: extend Qdisc with rcu

Vlad Buslov <vladbu@mellanox.com>
    net: sched: rename qdisc_destroy() to qdisc_put()

Vlad Buslov <vladbu@mellanox.com>
    net: core: netlink: add helper refcount dec and lock function

Dan Carpenter <dan.carpenter@oracle.com>
    can: sja1000: fix use after free in ems_pcmcia_add_card()

Jimmy Assarsson <extja@kvaser.com>
    can: kvaser_usb: get CAN clock frequency from device

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    HID: check for valid USB device for many HID drivers

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    HID: wacom: fix problems when device is not a valid USB device

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    HID: add USB_HID dependancy on some USB HID drivers

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    HID: add USB_HID dependancy to hid-chicony

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    HID: add USB_HID dependancy to hid-prodikeys

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    HID: add hid_is_usb() function to make it simpler for USB detection

xiazhengqiao <xiazhengqiao@huaqin.corp-partner.google.com>
    HID: google: add eel USB id


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/x86/Kconfig                                   |   1 +
 arch/x86/platform/efi/quirks.c                     |   3 +-
 block/ioprio.c                                     |   3 +
 drivers/android/binder.c                           |  21 +--
 drivers/ata/libata-core.c                          |   2 +
 drivers/clk/qcom/clk-regmap-mux.c                  |   2 +-
 drivers/clk/qcom/common.c                          |  12 ++
 drivers/clk/qcom/common.h                          |   2 +
 drivers/hid/Kconfig                                |  10 +-
 drivers/hid/hid-asus.c                             |   2 +-
 drivers/hid/hid-chicony.c                          |   8 +-
 drivers/hid/hid-corsair.c                          |   7 +-
 drivers/hid/hid-elan.c                             |   2 +-
 drivers/hid/hid-elo.c                              |   3 +
 drivers/hid/hid-google-hammer.c                    |   2 +
 drivers/hid/hid-holtek-kbd.c                       |   9 +-
 drivers/hid/hid-holtek-mouse.c                     |   9 +
 drivers/hid/hid-ids.h                              |   1 +
 drivers/hid/hid-lg.c                               |  10 +-
 drivers/hid/hid-prodikeys.c                        |  10 +-
 drivers/hid/hid-roccat-arvo.c                      |   3 +
 drivers/hid/hid-roccat-isku.c                      |   3 +
 drivers/hid/hid-roccat-kone.c                      |   3 +
 drivers/hid/hid-roccat-koneplus.c                  |   3 +
 drivers/hid/hid-roccat-konepure.c                  |   3 +
 drivers/hid/hid-roccat-kovaplus.c                  |   3 +
 drivers/hid/hid-roccat-lua.c                       |   3 +
 drivers/hid/hid-roccat-pyra.c                      |   3 +
 drivers/hid/hid-roccat-ryos.c                      |   3 +
 drivers/hid/hid-roccat-savu.c                      |   3 +
 drivers/hid/hid-samsung.c                          |   3 +
 drivers/hid/hid-uclogic.c                          |   3 +
 drivers/hid/wacom_sys.c                            |  19 ++-
 drivers/iio/accel/kxcjk-1013.c                     |   5 +-
 drivers/iio/accel/kxsd9.c                          |   6 +-
 drivers/iio/accel/mma8452.c                        |   2 +-
 drivers/iio/adc/at91-sama5d2_adc.c                 |   3 +-
 drivers/iio/adc/axp20x_adc.c                       |  18 +-
 drivers/iio/adc/dln2-adc.c                         |  21 ++-
 drivers/iio/gyro/itg3200_buffer.c                  |   2 +-
 drivers/iio/industrialio-trigger.c                 |   1 -
 drivers/iio/light/ltr501.c                         |   2 +-
 drivers/iio/light/stk3310.c                        |   6 +-
 drivers/iio/trigger/stm32-timer-trigger.c          |   2 +-
 drivers/infiniband/hw/hfi1/init.c                  |   2 +-
 drivers/irqchip/irq-armada-370-xp.c                |  16 +-
 drivers/irqchip/irq-gic-v3-its.c                   |   2 +-
 drivers/irqchip/irq-nvic.c                         |   2 +-
 drivers/mtd/nand/raw/fsmc_nand.c                   |   4 +
 drivers/net/bonding/bond_alb.c                     |  14 +-
 drivers/net/can/m_can/m_can.c                      |  14 +-
 drivers/net/can/pch_can.c                          |   2 +-
 drivers/net/can/sja1000/ems_pcmcia.c               |   7 +-
 drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c   | 101 +++++++----
 drivers/net/ethernet/altera/altera_tse_main.c      |   9 +-
 drivers/net/ethernet/freescale/fec.h               |   3 +
 drivers/net/ethernet/freescale/fec_main.c          |   2 +-
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c |   5 -
 drivers/net/ethernet/intel/ice/ice_main.c          |   3 +
 .../ethernet/netronome/nfp/nfpcore/nfp_cppcore.c   |   4 +-
 drivers/net/ethernet/qlogic/qede/qede_fp.c         |   7 +
 drivers/net/ethernet/qlogic/qla3xxx.c              |  19 +--
 drivers/net/usb/cdc_ncm.c                          |   2 +
 drivers/usb/core/config.c                          |   6 +-
 drivers/usb/gadget/composite.c                     |  14 +-
 drivers/usb/gadget/legacy/dbgp.c                   |  15 +-
 drivers/usb/gadget/legacy/inode.c                  |  16 +-
 drivers/usb/host/xhci-hub.c                        |   1 +
 drivers/usb/host/xhci-ring.c                       |   1 -
 drivers/usb/host/xhci.c                            |  26 +--
 fs/aio.c                                           | 184 +++++++++++++++++----
 fs/signalfd.c                                      |  12 +-
 fs/tracefs/inode.c                                 |  76 +++++++++
 include/linux/hid.h                                |   5 +
 include/linux/rtnetlink.h                          |   7 +
 include/linux/wait.h                               |  26 +++
 include/net/bond_alb.h                             |   2 +-
 include/net/pkt_sched.h                            |   1 +
 include/net/sch_generic.h                          |  17 +-
 include/uapi/asm-generic/poll.h                    |   2 +-
 kernel/bpf/verifier.c                              |   2 +-
 kernel/sched/wait.c                                |   7 +
 mm/backing-dev.c                                   |   7 +
 net/core/neighbour.c                               |   2 +-
 net/core/rtnetlink.c                               |   6 +
 net/ipv4/udp.c                                     |   2 +-
 net/ipv6/seg6_iptunnel.c                           |   8 +
 net/nfc/netlink.c                                  |   6 +-
 net/sched/cls_api.c                                |  81 +++++++--
 net/sched/sch_api.c                                |  24 ++-
 net/sched/sch_atm.c                                |   2 +-
 net/sched/sch_cbq.c                                |   2 +-
 net/sched/sch_cbs.c                                |   2 +-
 net/sched/sch_drr.c                                |   4 +-
 net/sched/sch_dsmark.c                             |   2 +-
 net/sched/sch_fifo.c                               |   2 +-
 net/sched/sch_generic.c                            |  48 ++++--
 net/sched/sch_hfsc.c                               |   2 +-
 net/sched/sch_htb.c                                |   4 +-
 net/sched/sch_mq.c                                 |   4 +-
 net/sched/sch_mqprio.c                             |   4 +-
 net/sched/sch_multiq.c                             |   6 +-
 net/sched/sch_netem.c                              |   2 +-
 net/sched/sch_prio.c                               |   6 +-
 net/sched/sch_qfq.c                                |   4 +-
 net/sched/sch_red.c                                |   4 +-
 net/sched/sch_sfb.c                                |   4 +-
 net/sched/sch_tbf.c                                |   4 +-
 sound/core/control_compat.c                        |   3 +
 sound/core/oss/pcm_oss.c                           |  37 +++--
 sound/soc/qcom/qdsp6/q6routing.c                   |   8 +-
 tools/build/Makefile.feature                       |   1 -
 tools/build/feature/Makefile                       |   4 -
 tools/build/feature/test-all.c                     |   5 -
 tools/build/feature/test-libpython-version.c       |  11 --
 tools/perf/Makefile.config                         |   2 -
 117 files changed, 878 insertions(+), 319 deletions(-)


