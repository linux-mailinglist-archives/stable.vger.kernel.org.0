Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4CF95B7478
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 17:25:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229995AbiIMPVt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 11:21:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236015AbiIMPUl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 11:20:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DFF27B1DC;
        Tue, 13 Sep 2022 07:36:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ADD2DB80FD4;
        Tue, 13 Sep 2022 14:34:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F123CC433C1;
        Tue, 13 Sep 2022 14:34:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663079668;
        bh=RCOQygFLd9yW/fQDkIorFD6efmrB3nmA4SiVWdMx04U=;
        h=From:To:Cc:Subject:Date:From;
        b=O0mVCWsACHNBqfFbNGKg4O0eEeJSkEdzxswMzMwl5zXa9sT+ViwpecHNm1Qn3C7Vm
         +c/PCCzURUisZqtmSaCORihMoJz/IeeLzW5XqILEXwiuwntV3/2nlBKueNvBpwHbqn
         57NBuTvRfsYZu8H1u5FvoP/eb1MBIEy41LUtJfOE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Subject: [PATCH 4.14 00/61] 4.14.293-rc1 review
Date:   Tue, 13 Sep 2022 16:07:02 +0200
Message-Id: <20220913140346.422813036@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.293-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.14.293-rc1
X-KernelTest-Deadline: 2022-09-15T14:03+00:00
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

This is the start of the stable review cycle for the 4.14.293 release.
There are 61 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 15 Sep 2022 14:03:27 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.293-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.14.293-rc1

NeilBrown <neilb@suse.de>
    SUNRPC: use _bh spinlocking on ->transport_lock

Yang Ling <gnaygnil@gmail.com>
    MIPS: loongson32: ls1c: Fix hang during startup

Johan Hovold <johan@kernel.org>
    USB: serial: ch341: fix disabled rx timer on older devices

Johan Hovold <johan@kernel.org>
    USB: serial: ch341: fix lost character on LCR updates

Johan Hovold <johan+linaro@kernel.org>
    usb: dwc3: fix PHY disable sequence

Toke Høiland-Jørgensen <toke@toke.dk>
    sch_sfb: Also store skb len before calling child enqueue

Neal Cardwell <ncardwell@google.com>
    tcp: fix early ETIMEDOUT after spurious non-SACK RTO

David Lebrun <dlebrun@google.com>
    ipv6: sr: fix out-of-bounds read when setting HMAC data.

Dan Carpenter <dan.carpenter@oracle.com>
    tipc: fix shift wrapping bug in map_get()

Toke Høiland-Jørgensen <toke@toke.dk>
    sch_sfb: Don't assume the skb is still around after enqueueing to child

David Leadbeater <dgl@dgl.cx>
    netfilter: nf_conntrack_irc: Fix forged IP logic

Harsh Modi <harshmodi@google.com>
    netfilter: br_netfilter: Drop dst references before setting.

Isaac J. Manjarres <isaacmanjarres@google.com>
    driver core: Don't probe devices after bus_type.match() probe deferral

Sreekanth Reddy <sreekanth.reddy@broadcom.com>
    scsi: mpt3sas: Fix use-after-free warning

Christian A. Ehrhardt <lk@c--e.de>
    kprobes: Prohibit probes in gate area

Dongxiang Ke <kdx.glider@gmail.com>
    ALSA: usb-audio: Fix an out-of-bounds bug in __snd_usb_parse_audio_interface()

Pattara Teerapong <pteerapong@chromium.org>
    ALSA: aloop: Fix random zeros in capture data when using jiffies timer

Tasos Sahanidis <tasos@tasossah.com>
    ALSA: emu10k1: Fix out of bounds access in snd_emu10k1_pcm_channel_alloc()

Yang Yingliang <yangyingliang@huawei.com>
    fbdev: chipsfb: Add missing pci_disable_device() in chipsfb_pci_init()

Mark Brown <broonie@kernel.org>
    arm64/signal: Raise limit on stack frames

Helge Deller <deller@gmx.de>
    parisc: Add runtime check to prevent PA2.0 kernels on PA1.x machines

Li Qiong <liqiong@nfschina.com>
    parisc: ccio-dma: Handle kmalloc failure in ccio_init_resources()

Zhenneng Li <lizhenneng@kylinos.cn>
    drm/radeon: add a force flush to delay work when radeon

Candice Li <candice.li@amd.com>
    drm/amdgpu: Check num_gfx_rings for gfx v9_0 rb setup.

Yee Lee <yee.lee@mediatek.com>
    Revert "mm: kmemleak: take a full lowmem check in kmemleak_*_phys()"

Linus Torvalds <torvalds@linux-foundation.org>
    fs: only do a memory barrier for the first set_buffer_uptodate()

Stanislaw Gruszka <stf_xl@wp.pl>
    wifi: iwlegacy: 4965: corrected fix for potential off-by-one overflow in il4965_rs_fill_link_cmd()

Hyunwoo Kim <imv4bel@gmail.com>
    efi: capsule-loader: Fix use-after-free in efi_capsule_write

Takashi Iwai <tiwai@suse.de>
    ALSA: seq: Fix data-race at module auto-loading

Takashi Iwai <tiwai@suse.de>
    ALSA: seq: oss: Fix data-race for max_midi_devs access

Miquel Raynal <miquel.raynal@bootlin.com>
    net: mac802154: Fix a condition in the receive path

Siddh Raman Pant <code@siddh.me>
    wifi: mac80211: Don't finalize CSA in IBSS mode if state is disconnected

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

Mika Westerberg <mika.westerberg@linux.intel.com>
    thunderbolt: Use the actual buffer in tb_async_error()

Armin Wolf <W_Armin@gmx.de>
    hwmon: (gpio-fan) Fix array out of bounds access

Peter Robinson <pbrobinson@gmail.com>
    Input: rk805-pwrkey - fix module autoloading

Colin Ian King <colin.i.king@gmail.com>
    drm/i915/reg: Fix spelling mistake "Unsupport" -> "Unsupported"

Carlos Llamas <cmllamas@google.com>
    binder: fix UAF of ref->proc caused by race condition

Niek Nooijens <niek.nooijens@omron.com>
    USB: serial: ftdi_sio: add Omron CS1W-CIF31 device id

Helge Deller <deller@gmx.de>
    vt: Clear selection before changing the font

Dan Carpenter <dan.carpenter@oracle.com>
    staging: rtl8712: fix use after free bugs

Shenwei Wang <shenwei.wang@nxp.com>
    serial: fsl_lpuart: RS485 RTS polariy is inverse

Cong Wang <cong.wang@bytedance.com>
    kcm: fix strp_init() order and cleanup

Duoming Zhou <duoming@zju.edu.cn>
    ethernet: rocker: fix sleep in atomic context bug in neigh_timer_handler

Dan Carpenter <dan.carpenter@oracle.com>
    wifi: cfg80211: debugfs: fix return type in ht40allow_map_read()

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    platform/x86: pmc_atom: Fix SLP_TYPx bitfield mask

Douglas Anderson <dianders@chromium.org>
    drm/msm/dsi: Fix number of regulators for msm8996_dsi_cfg

Maxim Mikityanskiy <maximmi@nvidia.com>
    bpf: Fix the off-by-two error in range markings

Stanislav Fomichev <sdf@google.com>
    selftests/bpf: Fix test_align verifier log patterns

John Fastabend <john.fastabend@gmail.com>
    bpf: Verifer, adjust_scalar_min_max_vals to always call update_reg_bounds()


-------------

Diffstat:

 Makefile                                      |  4 +--
 arch/arm64/kernel/signal.c                    |  2 +-
 arch/mips/loongson32/ls1c/board.c             |  1 -
 arch/parisc/kernel/head.S                     | 43 ++++++++++++++++++++++++++-
 arch/s390/include/asm/hugetlb.h               |  6 ++--
 arch/s390/kernel/vmlinux.lds.S                |  1 +
 drivers/android/binder.c                      | 12 ++++++++
 drivers/base/dd.c                             | 10 +++++++
 drivers/firmware/efi/capsule-loader.c         | 31 +++++--------------
 drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c         |  3 +-
 drivers/gpu/drm/i915/gvt/handlers.c           |  2 +-
 drivers/gpu/drm/msm/dsi/dsi_cfg.c             |  2 +-
 drivers/gpu/drm/radeon/radeon_device.c        |  3 ++
 drivers/hwmon/gpio-fan.c                      |  3 ++
 drivers/input/misc/rk805-pwrkey.c             |  1 +
 drivers/net/ethernet/rocker/rocker_ofdpa.c    |  2 +-
 drivers/net/wireless/intel/iwlegacy/4965-rs.c |  5 +---
 drivers/parisc/ccio-dma.c                     | 11 +++++--
 drivers/platform/x86/pmc_atom.c               |  2 +-
 drivers/scsi/mpt3sas/mpt3sas_scsih.c          |  2 +-
 drivers/staging/rtl8712/rtl8712_cmd.c         | 36 ----------------------
 drivers/thunderbolt/ctl.c                     |  2 +-
 drivers/tty/serial/fsl_lpuart.c               |  4 +--
 drivers/tty/vt/vt.c                           | 12 +++++---
 drivers/usb/class/cdc-acm.c                   |  3 ++
 drivers/usb/core/hub.c                        | 10 +++++++
 drivers/usb/dwc2/platform.c                   |  8 ++---
 drivers/usb/dwc3/core.c                       | 20 ++++++-------
 drivers/usb/gadget/function/storage_common.c  |  6 ++--
 drivers/usb/host/xhci-hub.c                   | 11 +++++++
 drivers/usb/host/xhci.c                       |  4 ++-
 drivers/usb/host/xhci.h                       |  2 +-
 drivers/usb/serial/ch341.c                    | 15 ++++++++--
 drivers/usb/serial/cp210x.c                   |  1 +
 drivers/usb/serial/ftdi_sio.c                 |  2 ++
 drivers/usb/serial/ftdi_sio_ids.h             |  6 ++++
 drivers/usb/serial/option.c                   | 15 ++++++++++
 drivers/usb/storage/unusual_devs.h            |  7 +++++
 drivers/video/fbdev/chipsfb.c                 |  1 +
 include/linux/buffer_head.h                   | 11 +++++++
 include/linux/platform_data/x86/pmc_atom.h    |  6 ++--
 include/linux/usb.h                           |  2 ++
 kernel/bpf/verifier.c                         |  1 +
 kernel/kprobes.c                              |  1 +
 mm/kmemleak.c                                 |  8 ++---
 net/bridge/br_netfilter_hooks.c               |  2 ++
 net/bridge/br_netfilter_ipv6.c                |  1 +
 net/ipv4/tcp_input.c                          | 25 +++++++++++-----
 net/ipv6/seg6.c                               |  5 ++++
 net/kcm/kcmsock.c                             | 15 +++++-----
 net/mac80211/ibss.c                           |  4 +++
 net/mac802154/rx.c                            |  2 +-
 net/netfilter/nf_conntrack_irc.c              |  5 ++--
 net/sched/sch_sfb.c                           | 13 ++++----
 net/sunrpc/xprt.c                             |  4 +--
 net/tipc/monitor.c                            |  2 +-
 net/wireless/debugfs.c                        |  3 +-
 sound/core/seq/oss/seq_oss_midi.c             |  2 ++
 sound/core/seq/seq_clientmgr.c                | 12 ++++----
 sound/drivers/aloop.c                         |  7 +++--
 sound/pci/emu10k1/emupcm.c                    |  2 +-
 sound/usb/stream.c                            |  2 +-
 tools/testing/selftests/bpf/test_align.c      | 27 +++++++++--------
 tools/testing/selftests/bpf/test_verifier.c   | 16 +++++-----
 64 files changed, 316 insertions(+), 173 deletions(-)


