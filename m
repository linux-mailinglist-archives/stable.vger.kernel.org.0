Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2C095FDFBD
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 19:57:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230257AbiJMR5v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Oct 2022 13:57:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230063AbiJMR5Y (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Oct 2022 13:57:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A52015200E;
        Thu, 13 Oct 2022 10:56:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7BF2AB82023;
        Thu, 13 Oct 2022 17:55:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FDCAC433C1;
        Thu, 13 Oct 2022 17:55:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665683704;
        bh=CuNVkSVuA7z+3TktD2cHvvHpZVV0FOIQ3QqpnWrSI+U=;
        h=From:To:Cc:Subject:Date:From;
        b=lA0GcU3NmLlf9x9M4jIJ7KRX2dUtgUjbDH0HZlwOf4xiWizYSMvaHsBceGUh9tZYF
         6R4CQK2uZwwkvo/mXjVqNTmXmlS55jHXWAG7EhJu5A+STEY8m4yeJZL2Be0CzCgXWZ
         09VTgGyAgaDme5GzQO7Drxo71Rb5XqtCqZHK4wIU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net
Subject: [PATCH 5.10 00/54] 5.10.148-rc1 review
Date:   Thu, 13 Oct 2022 19:51:54 +0200
Message-Id: <20221013175147.337501757@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.148-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.148-rc1
X-KernelTest-Deadline: 2022-10-15T17:51+00:00
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.10.148 release.
There are 54 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat, 15 Oct 2022 17:51:33 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.148-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.10.148-rc1

Shunsuke Mie <mie@igel.co.jp>
    misc: pci_endpoint_test: Fix pci_endpoint_test_{copy,write,read}() panic

Shunsuke Mie <mie@igel.co.jp>
    misc: pci_endpoint_test: Aggregate params checking for xfer

Cameron Gutman <aicommander@gmail.com>
    Input: xpad - fix wireless 360 controller breaking after suspend

Pavel Rojtberg <rojtberg@gmail.com>
    Input: xpad - add supported devices as contributed on github

Johannes Berg <johannes.berg@intel.com>
    wifi: cfg80211: update hidden BSSes to avoid WARN_ON

Johannes Berg <johannes.berg@intel.com>
    wifi: mac80211: fix crash in beacon protection for P2P-device

Johannes Berg <johannes.berg@intel.com>
    wifi: mac80211_hwsim: avoid mac80211 warning on bad rate

Johannes Berg <johannes.berg@intel.com>
    wifi: cfg80211: avoid nontransmitted BSS list corruption

Johannes Berg <johannes.berg@intel.com>
    wifi: cfg80211: fix BSS refcounting bugs

Johannes Berg <johannes.berg@intel.com>
    wifi: cfg80211: ensure length byte is present before access

Johannes Berg <johannes.berg@intel.com>
    wifi: cfg80211/mac80211: reject bad MBSSID elements

Johannes Berg <johannes.berg@intel.com>
    wifi: cfg80211: fix u8 overflow in cfg80211_update_notlisted_nontrans()

Jason A. Donenfeld <Jason@zx2c4.com>
    random: use expired timer rather than wq for mixing fast pool

Jason A. Donenfeld <Jason@zx2c4.com>
    random: avoid reading two cache lines on irq randomness

Frank Wunderlich <frank-w@public-files.de>
    USB: serial: qcserial: add new usb-id for Dell branded EM7455

Linus Torvalds <torvalds@linux-foundation.org>
    scsi: stex: Properly zero out the passthrough command structure

Orlando Chamberlain <redecorating@protonmail.com>
    efi: Correct Macmini DMI match in uefi cert quirk

Takashi Iwai <tiwai@suse.de>
    ALSA: hda: Fix position reporting on Poulsbo

Jason A. Donenfeld <Jason@zx2c4.com>
    random: clamp credited irq bits to maximum mixed

Jason A. Donenfeld <Jason@zx2c4.com>
    random: restore O_NONBLOCK support

Sasha Levin <sashal@kernel.org>
    Revert "clk: ti: Stop using legacy clkctrl names for omap4 and 5"

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    rpmsg: qcom: glink: replace strncpy() with strscpy_pad()

Johan Hovold <johan@kernel.org>
    USB: serial: ftdi_sio: fix 300 bps rate for SIO

Tadeusz Struk <tadeusz.struk@linaro.org>
    usb: mon: make mmapped memory read only

Brian Norris <briannorris@chromium.org>
    mmc: core: Terminate infinite loop in SD-UHS voltage switch

ChanWoo Lee <cw9316.lee@samsung.com>
    mmc: core: Replace with already defined values for readability

zhikzhai <zhikai.zhai@amd.com>
    drm/amd/display: skip audio setup when audio stream is enabled

Hugo Hu <hugo.hu@amd.com>
    drm/amd/display: update gamut remap if plane has changed

Jianglei Nie <niejianglei2021@163.com>
    net: atlantic: fix potential memory leak in aq_ndev_close()

David Gow <davidgow@google.com>
    arch: um: Mark the stack non-executable to fix a binutils warning

Lukas Straub <lukasstraub2@web.de>
    um: Cleanup compiler warning in arch/x86/um/tls_32.c

Lukas Straub <lukasstraub2@web.de>
    um: Cleanup syscall_handler_t cast in syscalls_32.h

Jaroslav Kysela <perex@perex.cz>
    ALSA: hda/hdmi: Fix the converter reuse for the silent stream

Haimin Zhang <tcs.kernel@gmail.com>
    net/ieee802154: fix uninit value bug in dgram_sendmsg

Letu Ren <fantasquex@gmail.com>
    scsi: qedf: Fix a UAF bug in __qedf_probe()

Sergei Antonov <saproj@gmail.com>
    ARM: dts: fix Moxa SDIO 'compatible', remove 'sdhci' misnomer

Swati Agarwal <swati.agarwal@xilinx.com>
    dmaengine: xilinx_dma: Report error in case of dma_set_mask_and_coherent API failure

Swati Agarwal <swati.agarwal@xilinx.com>
    dmaengine: xilinx_dma: cleanup for fetching xlnx,num-fstores property

Swati Agarwal <swati.agarwal@xilinx.com>
    dmaengine: xilinx_dma: Fix devm_platform_ioremap_resource error handling

Cristian Marussi <cristian.marussi@arm.com>
    firmware: arm_scmi: Add SCMI PM driver remove routine

Nick Desaulniers <ndesaulniers@google.com>
    compiler_attributes.h: move __compiletime_{error|warning}

Dongliang Mu <mudongliangabcd@gmail.com>
    fs: fix UAF/GPF bug in nilfs_mdt_destroy

Yang Shi <shy828301@gmail.com>
    powerpc/64s/radix: don't need to broadcast IPI for radix pmd collapse flush

Yang Shi <shy828301@gmail.com>
    mm: gup: fix the fast GUP race against THP collapse

Takashi Iwai <tiwai@suse.de>
    ALSA: pcm: oss: Fix race at SNDCTL_DSP_SYNC

Jalal Mostafa <jalal.a.mostapha@gmail.com>
    xsk: Inherit need_wakeup flag for shared sockets

Alexey Dobriyan <adobriyan@gmail.com>
    perf tools: Fixup get_current_dir_name() compilation

Shuah Khan <skhan@linuxfoundation.org>
    docs: update mediator information in CoC docs

Sami Tolvanen <samitolvanen@google.com>
    Makefile.extrawarn: Move -Wcast-function-type-strict to W=1

Hu Weiwen <sehuww@mail.scut.edu.cn>
    ceph: don't truncate file in atomic_open

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: replace WARN_ONs by nilfs_error for checkpoint acquisition failure

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: fix leak of nilfs_root in case of writer thread creation failure

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: fix use-after-free bug of struct nilfs_root

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: fix NULL pointer dereference at nilfs_bmap_lookup_at_level()


-------------

Diffstat:

 .../devicetree/bindings/dma/moxa,moxart-dma.txt    |   4 +-
 .../process/code-of-conduct-interpretation.rst     |   2 +-
 Makefile                                           |   4 +-
 arch/arm/boot/dts/moxart-uc7112lx.dts              |   2 +-
 arch/arm/boot/dts/moxart.dtsi                      |   4 +-
 arch/powerpc/mm/book3s64/radix_pgtable.c           |   9 -
 arch/um/Makefile                                   |   8 +
 arch/x86/um/shared/sysdep/syscalls_32.h            |   5 +-
 arch/x86/um/tls_32.c                               |   6 -
 arch/x86/um/vdso/Makefile                          |   2 +-
 drivers/char/mem.c                                 |   4 +-
 drivers/char/random.c                              |  25 ++-
 drivers/clk/ti/clk-44xx.c                          | 210 ++++++++++-----------
 drivers/clk/ti/clk-54xx.c                          | 160 ++++++++--------
 drivers/clk/ti/clkctrl.c                           |   4 +
 drivers/dma/xilinx/xilinx_dma.c                    |  21 ++-
 drivers/firmware/arm_scmi/scmi_pm_domain.c         |  20 ++
 .../amd/display/dc/dce110/dce110_hw_sequencer.c    |   6 +-
 drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c |   1 +
 drivers/input/joystick/xpad.c                      |  20 +-
 drivers/misc/pci_endpoint_test.c                   |  34 +++-
 drivers/mmc/core/sd.c                              |   3 +-
 drivers/net/ethernet/aquantia/atlantic/aq_main.c   |   3 -
 drivers/net/wireless/mac80211_hwsim.c              |   2 +
 drivers/rpmsg/qcom_glink_native.c                  |   2 +-
 drivers/rpmsg/qcom_smd.c                           |   4 +-
 drivers/scsi/qedf/qedf_main.c                      |   5 -
 drivers/scsi/stex.c                                |  17 +-
 drivers/usb/mon/mon_bin.c                          |   5 +
 drivers/usb/serial/ftdi_sio.c                      |   3 +-
 drivers/usb/serial/qcserial.c                      |   1 +
 fs/ceph/file.c                                     |  10 +-
 fs/inode.c                                         |   7 +-
 fs/nilfs2/inode.c                                  |  19 +-
 fs/nilfs2/segment.c                                |  21 ++-
 include/linux/compiler-gcc.h                       |   3 -
 include/linux/compiler_attributes.h                |  24 +++
 include/linux/compiler_types.h                     |   6 -
 include/net/ieee802154_netdev.h                    |  37 ++++
 include/net/xsk_buff_pool.h                        |   2 +-
 include/scsi/scsi_cmnd.h                           |   2 +-
 mm/gup.c                                           |  34 +++-
 mm/khugepaged.c                                    |  10 +-
 net/ieee802154/socket.c                            |  42 +++--
 net/mac80211/rx.c                                  |  12 +-
 net/mac80211/util.c                                |   2 +
 net/wireless/scan.c                                |  77 +++++---
 net/xdp/xsk.c                                      |   4 +-
 net/xdp/xsk_buff_pool.c                            |   5 +-
 scripts/Makefile.extrawarn                         |   1 +
 security/integrity/platform_certs/load_uefi.c      |   2 +-
 sound/core/oss/pcm_oss.c                           |   5 +-
 sound/pci/hda/hda_intel.c                          |   3 +-
 sound/pci/hda/patch_hdmi.c                         |   1 +
 tools/perf/util/get_current_dir_name.c             |   3 +-
 55 files changed, 570 insertions(+), 358 deletions(-)


