Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A662472641
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 10:51:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235776AbhLMJtr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 04:49:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236858AbhLMJrg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 04:47:36 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AF99C07E5C5;
        Mon, 13 Dec 2021 01:42:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CAD5CB80E18;
        Mon, 13 Dec 2021 09:42:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED257C00446;
        Mon, 13 Dec 2021 09:42:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639388573;
        bh=fH+b1KAkc37Qv2Kga4uqqZhd8dAwcxuTxaR6+dodyGs=;
        h=From:To:Cc:Subject:Date:From;
        b=Ak9vYDoVEmkfuFA+xVsA0EUOo/RRjUdPOyPqe2ZQrsaLiRBXW1MxhteYUVLg2xbhY
         kPhhXsbs08iOpHcuIO8R4iWrCVXIqtlJ+823f5cMbKFtti1TLA51MyWlmAll4Mg3PB
         jR17dqYUgLxgJq8QfkbKS2MYrowt1d9TpQZPrYrA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 5.4 00/88] 5.4.165-rc1 review
Date:   Mon, 13 Dec 2021 10:29:30 +0100
Message-Id: <20211213092933.250314515@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.165-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.165-rc1
X-KernelTest-Deadline: 2021-12-15T09:29+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.4.165 release.
There are 88 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 15 Dec 2021 09:29:16 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.165-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.4.165-rc1

Maxim Mikityanskiy <maximmi@nvidia.com>
    bpf: Add selftests to cover packet access corner cases

Jeya R <jeyr@codeaurora.org>
    misc: fastrpc: fix improper packet size calculation

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

Lars-Peter Clausen <lars@metafoo.de>
    iio: ad7768-1: Call iio_trigger_notify_done() on error

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

Peilin Ye <peilin.ye@bytedance.com>
    selftests/fib_tests: Rework fib_rp_filter_test()

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

Alexander Stein <alexander.stein@ew.tq-group.com>
    dt-bindings: net: Reintroduce PHY no lane swap binding

Herve Codina <herve.codina@bootlin.com>
    mtd: rawnand: fsmc: Fix timing computation

Herve Codina <herve.codina@bootlin.com>
    mtd: rawnand: fsmc: Take instruction delay into account

Mateusz Palczewski <mateusz.palczewski@intel.com>
    i40e: Fix pre-set max number of queues for VF

Karen Sornek <karen.sornek@intel.com>
    i40e: Fix failed opcode appearing if handling messages from VF

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

Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>
    drm/syncobj: Deal with signalled fences in drm_syncobj_find_fence.

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    clk: qcom: regmap-mux: fix parent clock lookup

Steven Rostedt (VMware) <rostedt@goodmis.org>
    tracefs: Have new files inherit the ownership of their parent

Alexander Sverdlin <alexander.sverdlin@nokia.com>
    nfsd: Fix nsfd startup race (again)

Qu Wenruo <wqu@suse.com>
    btrfs: replace the BUG_ON in btrfs_del_root_ref with proper error handling

Josef Bacik <josef@toxicpanda.com>
    btrfs: clear extent buffer uptodate when we fail to write it

Takashi Iwai <tiwai@suse.de>
    ALSA: pcm: oss: Handle missing errors in snd_pcm_oss_change_params*()

Takashi Iwai <tiwai@suse.de>
    ALSA: pcm: oss: Limit the period size to 16MB

Takashi Iwai <tiwai@suse.de>
    ALSA: pcm: oss: Fix negative period/buffer sizes

Kailang Yang <kailang@realtek.com>
    ALSA: hda/realtek - Add headset Mic support for Lenovo ALC897 platform

Alan Young <consult.awy@gmail.com>
    ALSA: ctl: Fix copy of updated id with element read/write

Manjong Lee <mj0123.lee@samsung.com>
    mm: bdi: initialize bdi_min_ratio when bdi is unregistered

Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>
    IB/hfi1: Correct guard on eager buffer deallocation

Michal Maloszewski <michal.maloszewski@intel.com>
    iavf: Fix reporting when setting descriptor count

Mitch Williams <mitch.a.williams@intel.com>
    iavf: restore MSI state on reset

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

Nicolas Dichtel <nicolas.dichtel@6wind.com>
    vrf: don't run conntrack on vrf with !dflt qdisc

Florian Westphal <fw@strlen.de>
    selftests: netfilter: add a vrf+conntrack testcase

Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
    nfc: fix potential NULL pointer deref in nfc_genl_dump_ses_done

Dan Carpenter <dan.carpenter@oracle.com>
    can: sja1000: fix use after free in ems_pcmcia_add_card()

Jimmy Assarsson <extja@kvaser.com>
    can: kvaser_pciefd: kvaser_pciefd_rx_error_frame(): increase correct stats->{rx,tx}_errors counter

Jimmy Assarsson <extja@kvaser.com>
    can: kvaser_usb: get CAN clock frequency from device

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    HID: check for valid USB device for many HID drivers

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    HID: wacom: fix problems when device is not a valid USB device

Benjamin Tissoires <benjamin.tissoires@redhat.com>
    HID: bigbenff: prevent null pointer dereference

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

Hans de Goede <hdegoede@redhat.com>
    HID: quirks: Add quirk for the Microsoft Surface 3 type-cover

Luca Stefani <luca.stefani.ge1@gmail.com>
    ntfs: fix ntfs_test_inode and ntfs_init_locked_inode function type

Patrik John <patrik.john@u-blox.com>
    serial: tegra: Change lower tolerance baud rate limit for tegra20 and tegra30


-------------

Diffstat:

 .../devicetree/bindings/net/ethernet-phy.yaml      |   8 +
 Makefile                                           |   4 +-
 arch/x86/Kconfig                                   |   1 +
 arch/x86/platform/efi/quirks.c                     |   3 +-
 block/ioprio.c                                     |   3 +
 drivers/android/binder.c                           |  21 +-
 drivers/ata/libata-core.c                          |   2 +
 drivers/clk/qcom/clk-regmap-mux.c                  |   2 +-
 drivers/clk/qcom/common.c                          |  12 +
 drivers/clk/qcom/common.h                          |   2 +
 drivers/gpu/drm/drm_syncobj.c                      |  11 +-
 drivers/hid/Kconfig                                |  10 +-
 drivers/hid/hid-asus.c                             |   2 +-
 drivers/hid/hid-bigbenff.c                         |   2 +-
 drivers/hid/hid-chicony.c                          |   8 +-
 drivers/hid/hid-corsair.c                          |   7 +-
 drivers/hid/hid-elan.c                             |   2 +-
 drivers/hid/hid-elo.c                              |   3 +
 drivers/hid/hid-google-hammer.c                    |   2 +
 drivers/hid/hid-holtek-kbd.c                       |   9 +-
 drivers/hid/hid-holtek-mouse.c                     |   9 +
 drivers/hid/hid-ids.h                              |   2 +
 drivers/hid/hid-lg.c                               |  10 +-
 drivers/hid/hid-logitech-dj.c                      |   2 +-
 drivers/hid/hid-prodikeys.c                        |  10 +-
 drivers/hid/hid-quirks.c                           |   1 +
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
 drivers/hid/hid-u2fzero.c                          |   2 +-
 drivers/hid/hid-uclogic-core.c                     |   3 +
 drivers/hid/hid-uclogic-params.c                   |   3 +-
 drivers/hid/wacom_sys.c                            |  19 +-
 drivers/iio/accel/kxcjk-1013.c                     |   5 +-
 drivers/iio/accel/kxsd9.c                          |   6 +-
 drivers/iio/accel/mma8452.c                        |   2 +-
 drivers/iio/adc/ad7768-1.c                         |   2 +-
 drivers/iio/adc/at91-sama5d2_adc.c                 |   3 +-
 drivers/iio/adc/axp20x_adc.c                       |  18 +-
 drivers/iio/adc/dln2-adc.c                         |  21 +-
 drivers/iio/gyro/itg3200_buffer.c                  |   2 +-
 drivers/iio/industrialio-trigger.c                 |   1 -
 drivers/iio/light/ltr501.c                         |   2 +-
 drivers/iio/light/stk3310.c                        |   6 +-
 drivers/iio/trigger/stm32-timer-trigger.c          |   2 +-
 drivers/infiniband/hw/hfi1/init.c                  |   2 +-
 drivers/irqchip/irq-armada-370-xp.c                |  16 +-
 drivers/irqchip/irq-gic-v3-its.c                   |   2 +-
 drivers/irqchip/irq-nvic.c                         |   2 +-
 drivers/misc/fastrpc.c                             |  10 +-
 drivers/mtd/nand/raw/fsmc_nand.c                   |  36 +-
 drivers/net/bonding/bond_alb.c                     |  14 +-
 drivers/net/can/kvaser_pciefd.c                    |   8 +-
 drivers/net/can/m_can/m_can.c                      |  14 +-
 drivers/net/can/pch_can.c                          |   2 +-
 drivers/net/can/sja1000/ems_pcmcia.c               |   7 +-
 drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c   | 101 +++-
 drivers/net/ethernet/altera/altera_tse_main.c      |   9 +-
 drivers/net/ethernet/freescale/fec.h               |   3 +
 drivers/net/ethernet/freescale/fec_main.c          |   2 +-
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c |  75 ++-
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.h |   2 +
 drivers/net/ethernet/intel/iavf/iavf_ethtool.c     |  43 +-
 drivers/net/ethernet/intel/iavf/iavf_main.c        |   1 +
 drivers/net/ethernet/intel/ice/ice_main.c          |   3 +
 .../ethernet/netronome/nfp/nfpcore/nfp_cppcore.c   |   4 +-
 drivers/net/ethernet/qlogic/qede/qede_fp.c         |   7 +
 drivers/net/ethernet/qlogic/qla3xxx.c              |  19 +-
 drivers/net/usb/cdc_ncm.c                          |   2 +
 drivers/net/vrf.c                                  |   8 +-
 drivers/tty/serial/serial-tegra.c                  |   4 +-
 drivers/usb/core/config.c                          |   6 +-
 drivers/usb/gadget/composite.c                     |  14 +-
 drivers/usb/gadget/legacy/dbgp.c                   |  15 +-
 drivers/usb/gadget/legacy/inode.c                  |  16 +-
 drivers/usb/host/xhci-hub.c                        |   1 +
 drivers/usb/host/xhci-ring.c                       |   1 -
 drivers/usb/host/xhci.c                            |  26 +-
 fs/aio.c                                           | 184 ++++--
 fs/btrfs/extent_io.c                               |   6 +
 fs/btrfs/root-tree.c                               |   3 +-
 fs/nfsd/nfs4recover.c                              |   1 +
 fs/nfsd/nfsctl.c                                   |  14 +-
 fs/ntfs/dir.c                                      |   2 +-
 fs/ntfs/inode.c                                    |  27 +-
 fs/ntfs/inode.h                                    |   4 +-
 fs/ntfs/mft.c                                      |   4 +-
 fs/signalfd.c                                      |  12 +-
 fs/tracefs/inode.c                                 |  76 +++
 include/linux/hid.h                                |   5 +
 include/linux/wait.h                               |  26 +
 include/net/bond_alb.h                             |   2 +-
 include/uapi/asm-generic/poll.h                    |   2 +-
 kernel/bpf/verifier.c                              |   2 +-
 kernel/sched/wait.c                                |   7 +
 mm/backing-dev.c                                   |   7 +
 net/core/neighbour.c                               |   3 +-
 net/ipv4/udp.c                                     |   2 +-
 net/ipv6/seg6_iptunnel.c                           |   8 +
 net/nfc/netlink.c                                  |   6 +-
 sound/core/control_compat.c                        |   3 +
 sound/core/oss/pcm_oss.c                           |  37 +-
 sound/pci/hda/patch_realtek.c                      |  40 ++
 sound/soc/qcom/qdsp6/q6routing.c                   |   8 +-
 tools/build/Makefile.feature                       |   1 -
 tools/build/feature/Makefile                       |   4 -
 tools/build/feature/test-all.c                     |   5 -
 tools/build/feature/test-libpython-version.c       |  11 -
 tools/perf/Makefile.config                         |   2 -
 .../bpf/verifier/xdp_direct_packet_access.c        | 632 +++++++++++++++++++--
 tools/testing/selftests/net/fib_tests.sh           |  59 +-
 tools/testing/selftests/netfilter/conntrack_vrf.sh | 241 ++++++++
 120 files changed, 1809 insertions(+), 390 deletions(-)


