Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 082D55AE9B7
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 15:34:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240490AbiIFNeH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 09:34:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240579AbiIFNdh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 09:33:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16F1E7677D;
        Tue,  6 Sep 2022 06:33:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AC726B8162F;
        Tue,  6 Sep 2022 13:32:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACF20C433C1;
        Tue,  6 Sep 2022 13:32:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662471177;
        bh=9DcsR/QUosfemgiq9Z8piTWKYOmGESqmS9si+QhgfIk=;
        h=From:To:Cc:Subject:Date:From;
        b=jz/NjNTs7oyOvKbhNGixZwgQm30qgVbKoMtV3j0yhpFHIZ7/tI1shiod2f1JFsPq6
         8N2s1jPKSFp+WL6vyGHSyZMEMPr7ZO/N7fb0HgSTSzxF+5+NSbzip8tA54Pb/hFE0O
         KlFYt3aIgpGtYCNc+JKK2tAeSzWKETLYj/W0sHn8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Subject: [PATCH 5.10 00/80] 5.10.142-rc1 review
Date:   Tue,  6 Sep 2022 15:29:57 +0200
Message-Id: <20220906132816.936069583@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.142-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.142-rc1
X-KernelTest-Deadline: 2022-09-08T13:28+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.10.142 release.
There are 80 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 08 Sep 2022 13:27:58 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.142-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.10.142-rc1

Johan Hovold <johan@kernel.org>
    USB: serial: ch341: fix disabled rx timer on older devices

Johan Hovold <johan@kernel.org>
    USB: serial: ch341: fix lost character on LCR updates

Johan Hovold <johan+linaro@kernel.org>
    usb: dwc3: disable USB core PHY management

Johan Hovold <johan+linaro@kernel.org>
    usb: dwc3: qcom: fix use-after-free on runtime-PM wakeup

Johan Hovold <johan+linaro@kernel.org>
    usb: dwc3: fix PHY disable sequence

Adrian Hunter <adrian.hunter@intel.com>
    mmc: core: Fix UHS-I SD 1.8V workaround branch

Anand Jain <anand.jain@oracle.com>
    btrfs: harden identification of a stale device

Diego Santa Cruz <Diego.SantaCruz@spinetix.com>
    drm/i915/glk: ECS Liva Q2 needs GLK HDMI port timing quirk

Takashi Iwai <tiwai@suse.de>
    ALSA: seq: Fix data-race at module auto-loading

Takashi Iwai <tiwai@suse.de>
    ALSA: seq: oss: Fix data-race for max_midi_devs access

Kacper Michajłow <kasper93@gmail.com>
    ALSA: hda/realtek: Add speaker AMP init for Samsung laptops with ALC298

Miquel Raynal <miquel.raynal@bootlin.com>
    net: mac802154: Fix a condition in the receive path

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    net: Use u64_stats_fetch_begin_irq() for stats fetch.

Nicolas Dichtel <nicolas.dichtel@6wind.com>
    ip: fix triggering of 'icmp redirect'

Siddh Raman Pant <code@siddh.me>
    wifi: mac80211: Fix UAF in ieee80211_scan_rx()

Siddh Raman Pant <code@siddh.me>
    wifi: mac80211: Don't finalize CSA in IBSS mode if state is disconnected

Isaac J. Manjarres <isaacmanjarres@google.com>
    driver core: Don't probe devices after bus_type.match() probe deferral

Krishna Kurapati <quic_kriskura@quicinc.com>
    usb: gadget: mass_storage: Fix cdrom data transfers on MAC-OS

Alan Stern <stern@rowland.harvard.edu>
    USB: core: Prevent nested device-reset calls

Josh Poimboeuf <jpoimboe@kernel.org>
    s390: fix nospec table alignments

Gerald Schaefer <gerald.schaefer@linux.ibm.com>
    s390/hugetlb: fix prepare_hugepage_range() check for 2 GB hugepages

Witold Lipieta <witold.lipieta@thaumatec.com>
    usb-storage: Add ignore-residue quirk for NXP PN7462AU

Thierry GUIBERT <thierry.guibert@croix-rouge.fr>
    USB: cdc-acm: Add Icom PMR F3400 support (0c26:0020)

Heiner Kallweit <hkallweit1@gmail.com>
    usb: dwc2: fix wrong order of phy_power_on and phy_init

Pablo Sun <pablo.sun@mediatek.com>
    usb: typec: altmodes/displayport: correct pin assignment for UFP receptacles

Slark Xiao <slark_xiao@163.com>
    USB: serial: option: add support for Cinterion MV32-WA/WB RmNet mode

Yonglin Tan <yonglin.tan@outlook.com>
    USB: serial: option: add Quectel EM060K modem

Yan Xinyu <sdlyyxy@bupt.edu.cn>
    USB: serial: option: add support for OPPO R11 diag port

Johan Hovold <johan@kernel.org>
    USB: serial: cp210x: add Decagon UCA device id

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: Add grace period after xHC start to prevent premature runtime suspend.

Alan Stern <stern@rowland.harvard.edu>
    media: mceusb: Use new usb_control_msg_*() routines

Mika Westerberg <mika.westerberg@linux.intel.com>
    thunderbolt: Use the actual buffer in tb_async_error()

SeongJae Park <sj@kernel.org>
    xen-blkfront: Advertise feature-persistent as user requested

SeongJae Park <sj@kernel.org>
    xen-blkback: Advertise feature-persistent as user requested

Steven Price <steven.price@arm.com>
    mm: pagewalk: Fix race between unmap and page walker

Dan Carpenter <dan.carpenter@oracle.com>
    xen/grants: prevent integer overflow in gnttab_dma_alloc_pages()

Jim Mattson <jmattson@google.com>
    KVM: x86: Mask off unsupported and unknown bits of IA32_ARCH_CAPABILITIES

Haibo Chen <haibo.chen@nxp.com>
    gpio: pca953x: Add mutex_lock for regcache sync in PM

Armin Wolf <W_Armin@gmx.de>
    hwmon: (gpio-fan) Fix array out of bounds access

Stefan Wahren <stefan.wahren@i2se.com>
    clk: bcm: rpi: Add missing newline

Stefan Wahren <stefan.wahren@i2se.com>
    clk: bcm: rpi: Prevent out-of-bounds access

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    clk: bcm: rpi: Use correct order for the parameters of devm_kcalloc()

Stefan Wahren <stefan.wahren@i2se.com>
    clk: bcm: rpi: Fix error handling of raspberrypi_fw_get_rate

Peter Robinson <pbrobinson@gmail.com>
    Input: rk805-pwrkey - fix module autoloading

Chen-Yu Tsai <wenst@chromium.org>
    clk: core: Fix runtime PM sequence in clk_core_unprepare()

Stephen Boyd <sboyd@kernel.org>
    Revert "clk: core: Honor CLK_OPS_PARENT_ENABLE for clk gate ops"

Chen-Yu Tsai <wenst@chromium.org>
    clk: core: Honor CLK_OPS_PARENT_ENABLE for clk gate ops

Colin Ian King <colin.i.king@gmail.com>
    drm/i915/reg: Fix spelling mistake "Unsupport" -> "Unsupported"

Carlos Llamas <cmllamas@google.com>
    binder: fix UAF of ref->proc caused by race condition

Niek Nooijens <niek.nooijens@omron.com>
    USB: serial: ftdi_sio: add Omron CS1W-CIF31 device id

Johan Hovold <johan+linaro@kernel.org>
    misc: fastrpc: fix memory corruption on open

Johan Hovold <johan+linaro@kernel.org>
    misc: fastrpc: fix memory corruption on probe

Marcus Folkesson <marcus.folkesson@gmail.com>
    iio: adc: mcp3911: use correct formula for AD conversion

Matti Vaittinen <mazziesaccount@gmail.com>
    iio: ad7292: Prevent regulator double disable

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    Input: iforce - wake up after clearing IFORCE_XMIT_RUNNING flag

Sherry Sun <sherry.sun@nxp.com>
    tty: serial: lpuart: disable flow control while waiting for the transmit engine to complete

Helge Deller <deller@gmx.de>
    vt: Clear selection before changing the font

Masahiro Yamada <masahiroy@kernel.org>
    powerpc: align syscall table for ppc32

Dan Carpenter <dan.carpenter@oracle.com>
    staging: rtl8712: fix use after free bugs

Shenwei Wang <shenwei.wang@nxp.com>
    serial: fsl_lpuart: RS485 RTS polariy is inverse

Yacan Liu <liuyacan@corp.netease.com>
    net/smc: Remove redundant refcount increase

Jakub Kicinski <kuba@kernel.org>
    Revert "sch_cake: Return __NET_XMIT_STOLEN when consuming enqueued skb"

Eric Dumazet <edumazet@google.com>
    tcp: annotate data-race around challenge_timestamp

Toke Høiland-Jørgensen <toke@toke.dk>
    sch_cake: Return __NET_XMIT_STOLEN when consuming enqueued skb

Cong Wang <cong.wang@bytedance.com>
    kcm: fix strp_init() order and cleanup

Duoming Zhou <duoming@zju.edu.cn>
    ethernet: rocker: fix sleep in atomic context bug in neigh_timer_handler

Wang Hai <wanghai38@huawei.com>
    net/sched: fix netdevice reference leaks in attach_default_qdiscs()

Zhengchao Shao <shaozhengchao@huawei.com>
    net: sched: tbf: don't call qdisc_put() while holding tree lock

Mathias Nyman <mathias.nyman@linux.intel.com>
    Revert "xhci: turn off port power in shutdown"

Dan Carpenter <dan.carpenter@oracle.com>
    wifi: cfg80211: debugfs: fix return type in ht40allow_map_read()

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ALSA: hda: intel-nhlt: Correct the handling of fmt_config flexible array

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    ALSA: hda: intel-nhlt: remove use of __func__ in dev_dbg

Lin Ma <linma@zju.edu.cn>
    ieee802154/adf7242: defer destroy_workqueue call

Pu Lehui <pulehui@huawei.com>
    bpf, cgroup: Fix kernel BUG in purge_effective_progs

Marcus Folkesson <marcus.folkesson@gmail.com>
    iio: adc: mcp3911: make use of the sign bit

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    platform/x86: pmc_atom: Fix SLP_TYPx bitfield mask

Douglas Anderson <dianders@chromium.org>
    drm/msm/dsi: Fix number of regulators for SDM660

Douglas Anderson <dianders@chromium.org>
    drm/msm/dsi: Fix number of regulators for msm8996_dsi_cfg

Kuogee Hsieh <quic_khsieh@quicinc.com>
    drm/msm/dp: delete DP_RECOVERED_CLOCK_OUT_EN to fix tps4

sunliming <sunliming@kylinos.cn>
    drm/msm/dsi: fix the inconsistent indenting


-------------

Diffstat:

 Makefile                                           |  4 +-
 arch/powerpc/kernel/systbl.S                       |  1 +
 arch/riscv/mm/pageattr.c                           |  4 +-
 arch/s390/include/asm/hugetlb.h                    |  6 ++-
 arch/s390/kernel/vmlinux.lds.S                     |  1 +
 arch/x86/kvm/x86.c                                 | 25 +++++++--
 drivers/android/binder.c                           | 12 +++++
 drivers/base/dd.c                                  | 10 ++++
 drivers/block/xen-blkback/common.h                 |  3 ++
 drivers/block/xen-blkback/xenbus.c                 |  6 ++-
 drivers/block/xen-blkfront.c                       |  8 ++-
 drivers/clk/bcm/clk-raspberrypi.c                  | 13 +++--
 drivers/clk/clk.c                                  |  3 +-
 drivers/gpio/gpio-pca953x.c                        |  8 ++-
 drivers/gpu/drm/i915/display/intel_quirks.c        |  3 ++
 drivers/gpu/drm/i915/gvt/handlers.c                |  2 +-
 drivers/gpu/drm/msm/dp/dp_ctrl.c                   |  2 +-
 drivers/gpu/drm/msm/dsi/dsi_cfg.c                  |  4 +-
 drivers/gpu/drm/msm/dsi/phy/dsi_phy.c              |  2 +-
 drivers/hwmon/gpio-fan.c                           |  3 ++
 drivers/iio/adc/ad7292.c                           |  4 +-
 drivers/iio/adc/mcp3911.c                          | 19 +++++--
 drivers/input/joystick/iforce/iforce-serio.c       |  6 +--
 drivers/input/joystick/iforce/iforce-usb.c         |  8 +--
 drivers/input/joystick/iforce/iforce.h             |  6 +++
 drivers/input/misc/rk805-pwrkey.c                  |  1 +
 drivers/media/rc/mceusb.c                          | 35 +++++-------
 drivers/misc/fastrpc.c                             | 12 +++--
 drivers/mmc/core/sd.c                              |  6 +--
 drivers/net/ethernet/cortina/gemini.c              | 24 ++++-----
 drivers/net/ethernet/google/gve/gve_ethtool.c      | 16 +++---
 drivers/net/ethernet/google/gve/gve_main.c         | 12 ++---
 drivers/net/ethernet/huawei/hinic/hinic_rx.c       |  4 +-
 drivers/net/ethernet/huawei/hinic/hinic_tx.c       |  4 +-
 .../net/ethernet/netronome/nfp/nfp_net_common.c    |  8 +--
 .../net/ethernet/netronome/nfp/nfp_net_ethtool.c   |  8 +--
 drivers/net/ethernet/rocker/rocker_ofdpa.c         |  2 +-
 drivers/net/ieee802154/adf7242.c                   |  3 +-
 drivers/net/netdevsim/netdev.c                     |  4 +-
 drivers/platform/x86/pmc_atom.c                    |  2 +-
 drivers/staging/rtl8712/rtl8712_cmd.c              | 36 -------------
 drivers/thunderbolt/ctl.c                          |  2 +-
 drivers/tty/serial/fsl_lpuart.c                    |  5 +-
 drivers/tty/vt/vt.c                                | 12 +++--
 drivers/usb/class/cdc-acm.c                        |  3 ++
 drivers/usb/core/hub.c                             | 10 ++++
 drivers/usb/dwc2/platform.c                        |  8 +--
 drivers/usb/dwc3/core.c                            | 19 +++----
 drivers/usb/dwc3/dwc3-qcom.c                       | 14 ++++-
 drivers/usb/dwc3/host.c                            | 11 ++++
 drivers/usb/gadget/function/storage_common.c       |  6 ++-
 drivers/usb/host/xhci-hub.c                        | 13 ++++-
 drivers/usb/host/xhci.c                            | 19 ++-----
 drivers/usb/host/xhci.h                            |  4 +-
 drivers/usb/serial/ch341.c                         | 16 +++++-
 drivers/usb/serial/cp210x.c                        |  1 +
 drivers/usb/serial/ftdi_sio.c                      |  2 +
 drivers/usb/serial/ftdi_sio_ids.h                  |  6 +++
 drivers/usb/serial/option.c                        | 15 ++++++
 drivers/usb/storage/unusual_devs.h                 |  7 +++
 drivers/usb/typec/altmodes/displayport.c           |  4 +-
 drivers/xen/grant-table.c                          |  3 ++
 fs/btrfs/volumes.c                                 | 44 ++++++++++++---
 include/linux/platform_data/x86/pmc_atom.h         |  6 ++-
 include/linux/usb.h                                |  2 +
 include/linux/usb/typec_dp.h                       |  5 ++
 kernel/bpf/cgroup.c                                |  4 +-
 mm/pagewalk.c                                      | 21 ++++----
 mm/ptdump.c                                        |  4 +-
 net/ipv4/fib_frontend.c                            |  4 +-
 net/ipv4/tcp_input.c                               |  4 +-
 net/kcm/kcmsock.c                                  | 15 +++---
 net/mac80211/ibss.c                                |  4 ++
 net/mac80211/scan.c                                | 11 ++--
 net/mac80211/sta_info.c                            |  8 +--
 net/mac802154/rx.c                                 |  2 +-
 net/mpls/af_mpls.c                                 |  4 +-
 net/sched/sch_generic.c                            | 31 +++++------
 net/sched/sch_tbf.c                                |  4 +-
 net/smc/af_smc.c                                   |  1 -
 net/wireless/debugfs.c                             |  3 +-
 sound/core/seq/oss/seq_oss_midi.c                  |  2 +
 sound/core/seq/seq_clientmgr.c                     | 12 ++---
 sound/hda/intel-nhlt.c                             | 25 +++++----
 sound/pci/hda/patch_realtek.c                      | 63 +++++++++++++++++++---
 85 files changed, 520 insertions(+), 279 deletions(-)


