Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 219485FF8B4
	for <lists+stable@lfdr.de>; Sat, 15 Oct 2022 08:21:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229581AbiJOGVG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 15 Oct 2022 02:21:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229560AbiJOGVF (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 15 Oct 2022 02:21:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3D3260C85;
        Fri, 14 Oct 2022 23:21:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3BD5860AB7;
        Sat, 15 Oct 2022 06:21:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B2F4C433B5;
        Sat, 15 Oct 2022 06:20:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665814860;
        bh=LVEsRgFQi1qmdq107gEMD1Bv0KmWQvSKwd8lgf3gFGc=;
        h=From:To:Cc:Subject:Date:From;
        b=L0/KbETEa7O5sHrjg5gwuAL5GgDcQFR42HnpTpymyjnWoa8yODHfsp7gdsBG+8IqZ
         mDgS1UA+p9jcBYp+ASShGftTdk/+wD6buCANfaRgE6PzQ9P3/YXRx2c/pyPqwf4P2B
         hmj7zFVEQ1AgsoOiW4bvwBE1WEM+tJAU2keKrQLU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.4.218
Date:   Sat, 15 Oct 2022 08:21:44 +0200
Message-Id: <166581490418223@kroah.com>
X-Mailer: git-send-email 2.38.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.4.218 kernel.

All users of the 5.4 kernel series must upgrade.

The updated 5.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/devicetree/bindings/dma/moxa,moxart-dma.txt |    4 
 Makefile                                                  |    2 
 arch/arm/boot/dts/moxart-uc7112lx.dts                     |    2 
 arch/arm/boot/dts/moxart.dtsi                             |    4 
 arch/um/Makefile                                          |    8 +
 arch/x86/um/shared/sysdep/syscalls_32.h                   |    5 
 arch/x86/um/tls_32.c                                      |    6 -
 arch/x86/um/vdso/Makefile                                 |    2 
 drivers/char/mem.c                                        |    4 
 drivers/char/random.c                                     |   25 +++-
 drivers/dma/xilinx/xilinx_dma.c                           |    8 +
 drivers/firmware/arm_scmi/scmi_pm_domain.c                |   20 +++
 drivers/input/joystick/xpad.c                             |   20 +++
 drivers/mmc/core/sd.c                                     |    3 
 drivers/net/wireless/mac80211_hwsim.c                     |    2 
 drivers/rpmsg/qcom_glink_native.c                         |    2 
 drivers/rpmsg/qcom_smd.c                                  |    4 
 drivers/scsi/qedf/qedf_main.c                             |    5 
 drivers/scsi/stex.c                                       |   17 +--
 drivers/usb/mon/mon_bin.c                                 |    5 
 drivers/usb/serial/ftdi_sio.c                             |    3 
 drivers/usb/serial/qcserial.c                             |    1 
 fs/ceph/file.c                                            |   10 +
 fs/inode.c                                                |    7 -
 fs/nilfs2/inode.c                                         |    2 
 fs/nilfs2/segment.c                                       |   21 ++-
 include/net/ieee802154_netdev.h                           |   37 ++++++
 include/scsi/scsi_cmnd.h                                  |    2 
 mm/pagewalk.c                                             |   13 +-
 net/ieee802154/socket.c                                   |   42 ++++---
 net/mac80211/util.c                                       |    2 
 net/wireless/scan.c                                       |   77 +++++++++-----
 security/integrity/platform_certs/load_uefi.c             |    2 
 sound/pci/hda/hda_intel.c                                 |    3 
 tools/perf/util/get_current_dir_name.c                    |    3 
 35 files changed, 255 insertions(+), 118 deletions(-)

Alexey Dobriyan (1):
      perf tools: Fixup get_current_dir_name() compilation

Brian Norris (1):
      mmc: core: Terminate infinite loop in SD-UHS voltage switch

Cameron Gutman (1):
      Input: xpad - fix wireless 360 controller breaking after suspend

ChanWoo Lee (1):
      mmc: core: Replace with already defined values for readability

Cristian Marussi (1):
      firmware: arm_scmi: Add SCMI PM driver remove routine

David Gow (1):
      arch: um: Mark the stack non-executable to fix a binutils warning

Dongliang Mu (1):
      fs: fix UAF/GPF bug in nilfs_mdt_destroy

Frank Wunderlich (1):
      USB: serial: qcserial: add new usb-id for Dell branded EM7455

Greg Kroah-Hartman (1):
      Linux 5.4.218

Haimin Zhang (1):
      net/ieee802154: fix uninit value bug in dgram_sendmsg

Hu Weiwen (1):
      ceph: don't truncate file in atomic_open

Jason A. Donenfeld (4):
      random: clamp credited irq bits to maximum mixed
      random: restore O_NONBLOCK support
      random: avoid reading two cache lines on irq randomness
      random: use expired timer rather than wq for mixing fast pool

Johan Hovold (1):
      USB: serial: ftdi_sio: fix 300 bps rate for SIO

Johannes Berg (7):
      wifi: cfg80211: fix u8 overflow in cfg80211_update_notlisted_nontrans()
      wifi: cfg80211/mac80211: reject bad MBSSID elements
      wifi: cfg80211: ensure length byte is present before access
      wifi: cfg80211: fix BSS refcounting bugs
      wifi: cfg80211: avoid nontransmitted BSS list corruption
      wifi: mac80211_hwsim: avoid mac80211 warning on bad rate
      wifi: cfg80211: update hidden BSSes to avoid WARN_ON

Krzysztof Kozlowski (1):
      rpmsg: qcom: glink: replace strncpy() with strscpy_pad()

Letu Ren (1):
      scsi: qedf: Fix a UAF bug in __qedf_probe()

Linus Torvalds (1):
      scsi: stex: Properly zero out the passthrough command structure

Lukas Straub (2):
      um: Cleanup syscall_handler_t cast in syscalls_32.h
      um: Cleanup compiler warning in arch/x86/um/tls_32.c

Orlando Chamberlain (1):
      efi: Correct Macmini DMI match in uefi cert quirk

Pavel Rojtberg (1):
      Input: xpad - add supported devices as contributed on github

Ryusuke Konishi (3):
      nilfs2: fix NULL pointer dereference at nilfs_bmap_lookup_at_level()
      nilfs2: fix leak of nilfs_root in case of writer thread creation failure
      nilfs2: replace WARN_ONs by nilfs_error for checkpoint acquisition failure

Sergei Antonov (1):
      ARM: dts: fix Moxa SDIO 'compatible', remove 'sdhci' misnomer

Steven Price (1):
      mm: pagewalk: Fix race between unmap and page walker

Swati Agarwal (2):
      dmaengine: xilinx_dma: cleanup for fetching xlnx,num-fstores property
      dmaengine: xilinx_dma: Report error in case of dma_set_mask_and_coherent API failure

Tadeusz Struk (1):
      usb: mon: make mmapped memory read only

Takashi Iwai (1):
      ALSA: hda: Fix position reporting on Poulsbo

