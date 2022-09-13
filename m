Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E7095B74D2
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 17:30:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233536AbiIMP3g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 11:29:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236219AbiIMP2P (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 11:28:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 367BD7DF52;
        Tue, 13 Sep 2022 07:39:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0F28BB81018;
        Tue, 13 Sep 2022 14:37:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BD6CC433D6;
        Tue, 13 Sep 2022 14:37:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663079829;
        bh=9aQ/J1S3fBuL18C8JFf1Sg9Dwzy9z8x3BAIYzwGqyUo=;
        h=From:To:Cc:Subject:Date:From;
        b=IWQwJ9ZQhnP85wU8CvrzUYADeAi2JVr8gcWao6qhhMTfYLQ0EJMgvT3QfagLdO7z/
         rtvquRRouh8HxCeOXvAIG1HSPiglhZ6lTuv8OLQswPICDTYxmkTvNMJCwDjvotV28n
         Gll/YZ8Pts/ZxROA7yn97JtmsD67pcDg3MQ0a3Qg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Subject: [PATCH 4.9 00/42] 4.9.328-rc1 review
Date:   Tue, 13 Sep 2022 16:07:31 +0200
Message-Id: <20220913140342.228397194@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.328-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.9.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.9.328-rc1
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

This is the start of the stable review cycle for the 4.9.328 release.
There are 42 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 15 Sep 2022 14:03:27 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.328-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.9.328-rc1

NeilBrown <neilb@suse.de>
    SUNRPC: use _bh spinlocking on ->transport_lock

Yang Ling <gnaygnil@gmail.com>
    MIPS: loongson32: ls1c: Fix hang during startup

Johan Hovold <johan+linaro@kernel.org>
    usb: dwc3: fix PHY disable sequence

Toke Høiland-Jørgensen <toke@toke.dk>
    sch_sfb: Also store skb len before calling child enqueue

Neal Cardwell <ncardwell@google.com>
    tcp: fix early ETIMEDOUT after spurious non-SACK RTO

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

Dongxiang Ke <kdx.glider@gmail.com>
    ALSA: usb-audio: Fix an out-of-bounds bug in __snd_usb_parse_audio_interface()

Pattara Teerapong <pteerapong@chromium.org>
    ALSA: aloop: Fix random zeros in capture data when using jiffies timer

Tasos Sahanidis <tasos@tasossah.com>
    ALSA: emu10k1: Fix out of bounds access in snd_emu10k1_pcm_channel_alloc()

Yang Yingliang <yangyingliang@huawei.com>
    fbdev: chipsfb: Add missing pci_disable_device() in chipsfb_pci_init()

Helge Deller <deller@gmx.de>
    parisc: Add runtime check to prevent PA2.0 kernels on PA1.x machines

Li Qiong <liqiong@nfschina.com>
    parisc: ccio-dma: Handle kmalloc failure in ccio_init_resources()

Zhenneng Li <lizhenneng@kylinos.cn>
    drm/radeon: add a force flush to delay work when radeon

Yee Lee <yee.lee@mediatek.com>
    Revert "mm: kmemleak: take a full lowmem check in kmemleak_*_phys()"

Linus Torvalds <torvalds@linux-foundation.org>
    fs: only do a memory barrier for the first set_buffer_uptodate()

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

Slark Xiao <slark_xiao@163.com>
    USB: serial: option: add support for Cinterion MV32-WA/WB RmNet mode

Yan Xinyu <sdlyyxy@bupt.edu.cn>
    USB: serial: option: add support for OPPO R11 diag port

Johan Hovold <johan@kernel.org>
    USB: serial: cp210x: add Decagon UCA device id

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: Add grace period after xHC start to prevent premature runtime suspend.

Armin Wolf <W_Armin@gmx.de>
    hwmon: (gpio-fan) Fix array out of bounds access

Niek Nooijens <niek.nooijens@omron.com>
    USB: serial: ftdi_sio: add Omron CS1W-CIF31 device id

Helge Deller <deller@gmx.de>
    vt: Clear selection before changing the font

Dan Carpenter <dan.carpenter@oracle.com>
    staging: rtl8712: fix use after free bugs

Shenwei Wang <shenwei.wang@nxp.com>
    serial: fsl_lpuart: RS485 RTS polariy is inverse

Dan Carpenter <dan.carpenter@oracle.com>
    wifi: cfg80211: debugfs: fix return type in ht40allow_map_read()

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    platform/x86: pmc_atom: Fix SLP_TYPx bitfield mask

Letu Ren <fantasquex@gmail.com>
    fbdev: fb_pm2fb: Avoid potential divide by zero error


-------------

Diffstat:

 Makefile                                     |  4 +--
 arch/mips/loongson32/ls1c/board.c            |  1 -
 arch/parisc/kernel/head.S                    | 43 +++++++++++++++++++++++++++-
 arch/s390/include/asm/hugetlb.h              |  6 ++--
 arch/s390/kernel/vmlinux.lds.S               |  1 +
 arch/x86/include/asm/pmc_atom.h              |  6 ++--
 arch/x86/platform/atom/pmc_atom.c            |  2 +-
 drivers/base/dd.c                            | 10 +++++++
 drivers/gpu/drm/radeon/radeon_device.c       |  3 ++
 drivers/hwmon/gpio-fan.c                     |  3 ++
 drivers/parisc/ccio-dma.c                    | 11 +++++--
 drivers/scsi/mpt3sas/mpt3sas_scsih.c         |  2 +-
 drivers/staging/rtl8712/rtl8712_cmd.c        | 36 -----------------------
 drivers/tty/serial/fsl_lpuart.c              |  4 +--
 drivers/tty/vt/vt.c                          | 12 +++++---
 drivers/usb/class/cdc-acm.c                  |  3 ++
 drivers/usb/core/hub.c                       | 10 +++++++
 drivers/usb/dwc3/core.c                      | 20 ++++++-------
 drivers/usb/gadget/function/storage_common.c |  6 ++--
 drivers/usb/host/xhci-hub.c                  | 11 +++++++
 drivers/usb/host/xhci.c                      |  4 ++-
 drivers/usb/host/xhci.h                      |  2 +-
 drivers/usb/serial/cp210x.c                  |  1 +
 drivers/usb/serial/ftdi_sio.c                |  2 ++
 drivers/usb/serial/ftdi_sio_ids.h            |  6 ++++
 drivers/usb/serial/option.c                  | 11 +++++++
 drivers/usb/storage/unusual_devs.h           |  7 +++++
 drivers/video/fbdev/chipsfb.c                |  1 +
 drivers/video/fbdev/pm2fb.c                  |  5 ++++
 include/linux/buffer_head.h                  | 11 +++++++
 include/linux/usb.h                          |  2 ++
 mm/kmemleak.c                                |  8 +++---
 net/bridge/br_netfilter_hooks.c              |  2 ++
 net/bridge/br_netfilter_ipv6.c               |  1 +
 net/ipv4/tcp_input.c                         | 25 +++++++++++-----
 net/mac80211/ibss.c                          |  4 +++
 net/mac802154/rx.c                           |  2 +-
 net/netfilter/nf_conntrack_irc.c             |  5 ++--
 net/sched/sch_sfb.c                          | 13 +++++----
 net/sunrpc/xprt.c                            |  4 +--
 net/tipc/monitor.c                           |  2 +-
 net/wireless/debugfs.c                       |  3 +-
 sound/core/seq/oss/seq_oss_midi.c            |  2 ++
 sound/core/seq/seq_clientmgr.c               | 12 ++++----
 sound/drivers/aloop.c                        |  7 +++--
 sound/pci/emu10k1/emupcm.c                   |  2 +-
 sound/usb/stream.c                           |  2 +-
 47 files changed, 236 insertions(+), 104 deletions(-)


