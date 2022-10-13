Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47AF15FDF66
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 19:53:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229913AbiJMRxx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Oct 2022 13:53:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229921AbiJMRx1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Oct 2022 13:53:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70CDA15382D;
        Thu, 13 Oct 2022 10:53:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1902A618F6;
        Thu, 13 Oct 2022 17:53:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4BD4C433D7;
        Thu, 13 Oct 2022 17:53:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665683599;
        bh=7Pg2hH9xkajgQveM/ZCznyPUH/z8DiWF39Xp2aLLaPQ=;
        h=From:To:Cc:Subject:Date:From;
        b=oYj8Z4l19HtDsYPDY9lP5rdpFpjj97hGaAyn0oy5+w6cupapF9Fr45TPxEGrDf+8N
         gSWGVQJr+sfLc0KrY3PN8gghuUTGxhG75WaUSFopFPCOA/eVNGMLMIXURQcRETaYql
         udMDQRGF5nt/FUHtlJJ0rxQZIYnV9ngQHFo1yMHQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net
Subject: [PATCH 5.4 00/38] 5.4.218-rc1 review
Date:   Thu, 13 Oct 2022 19:52:01 +0200
Message-Id: <20221013175144.245431424@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.218-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.218-rc1
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

This is the start of the stable review cycle for the 5.4.218 release.
There are 38 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat, 15 Oct 2022 17:51:33 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.218-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.4.218-rc1

Cameron Gutman <aicommander@gmail.com>
    Input: xpad - fix wireless 360 controller breaking after suspend

Pavel Rojtberg <rojtberg@gmail.com>
    Input: xpad - add supported devices as contributed on github

Johannes Berg <johannes.berg@intel.com>
    wifi: cfg80211: update hidden BSSes to avoid WARN_ON

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

Jason A. Donenfeld <Jason@zx2c4.com>
    random: restore O_NONBLOCK support

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

Hu Weiwen <sehuww@mail.scut.edu.cn>
    ceph: don't truncate file in atomic_open

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: replace WARN_ONs by nilfs_error for checkpoint acquisition failure

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: fix leak of nilfs_root in case of writer thread creation failure

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: fix NULL pointer dereference at nilfs_bmap_lookup_at_level()

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    rpmsg: qcom: glink: replace strncpy() with strscpy_pad()

Brian Norris <briannorris@chromium.org>
    mmc: core: Terminate infinite loop in SD-UHS voltage switch

ChanWoo Lee <cw9316.lee@samsung.com>
    mmc: core: Replace with already defined values for readability

Johan Hovold <johan@kernel.org>
    USB: serial: ftdi_sio: fix 300 bps rate for SIO

Tadeusz Struk <tadeusz.struk@linaro.org>
    usb: mon: make mmapped memory read only

David Gow <davidgow@google.com>
    arch: um: Mark the stack non-executable to fix a binutils warning

Lukas Straub <lukasstraub2@web.de>
    um: Cleanup compiler warning in arch/x86/um/tls_32.c

Lukas Straub <lukasstraub2@web.de>
    um: Cleanup syscall_handler_t cast in syscalls_32.h

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

Cristian Marussi <cristian.marussi@arm.com>
    firmware: arm_scmi: Add SCMI PM driver remove routine

Dongliang Mu <mudongliangabcd@gmail.com>
    fs: fix UAF/GPF bug in nilfs_mdt_destroy

Alexey Dobriyan <adobriyan@gmail.com>
    perf tools: Fixup get_current_dir_name() compilation

Steven Price <steven.price@arm.com>
    mm: pagewalk: Fix race between unmap and page walker


-------------

Diffstat:

 .../devicetree/bindings/dma/moxa,moxart-dma.txt    |  4 +-
 Makefile                                           |  4 +-
 arch/arm/boot/dts/moxart-uc7112lx.dts              |  2 +-
 arch/arm/boot/dts/moxart.dtsi                      |  4 +-
 arch/um/Makefile                                   |  8 +++
 arch/x86/um/shared/sysdep/syscalls_32.h            |  5 +-
 arch/x86/um/tls_32.c                               |  6 --
 arch/x86/um/vdso/Makefile                          |  2 +-
 drivers/char/mem.c                                 |  4 +-
 drivers/char/random.c                              | 25 ++++---
 drivers/dma/xilinx/xilinx_dma.c                    |  8 ++-
 drivers/firmware/arm_scmi/scmi_pm_domain.c         | 20 ++++++
 drivers/input/joystick/xpad.c                      | 20 +++++-
 drivers/mmc/core/sd.c                              |  3 +-
 drivers/net/wireless/mac80211_hwsim.c              |  2 +
 drivers/rpmsg/qcom_glink_native.c                  |  2 +-
 drivers/rpmsg/qcom_smd.c                           |  4 +-
 drivers/scsi/qedf/qedf_main.c                      |  5 --
 drivers/scsi/stex.c                                | 17 ++---
 drivers/usb/mon/mon_bin.c                          |  5 ++
 drivers/usb/serial/ftdi_sio.c                      |  3 +-
 drivers/usb/serial/qcserial.c                      |  1 +
 fs/ceph/file.c                                     | 10 ++-
 fs/inode.c                                         |  7 +-
 fs/nilfs2/inode.c                                  |  2 +
 fs/nilfs2/segment.c                                | 21 +++---
 include/net/ieee802154_netdev.h                    | 37 +++++++++++
 include/scsi/scsi_cmnd.h                           |  2 +-
 mm/pagewalk.c                                      | 13 ++--
 net/ieee802154/socket.c                            | 42 ++++++------
 net/mac80211/util.c                                |  2 +
 net/wireless/scan.c                                | 77 ++++++++++++++--------
 security/integrity/platform_certs/load_uefi.c      |  2 +-
 sound/pci/hda/hda_intel.c                          |  3 +-
 tools/perf/util/get_current_dir_name.c             |  3 +-
 35 files changed, 256 insertions(+), 119 deletions(-)


