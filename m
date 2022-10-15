Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C1935FF8BA
	for <lists+stable@lfdr.de>; Sat, 15 Oct 2022 08:21:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229648AbiJOGVj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 15 Oct 2022 02:21:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229673AbiJOGV2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 15 Oct 2022 02:21:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F49663353;
        Fri, 14 Oct 2022 23:21:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 93023B8118F;
        Sat, 15 Oct 2022 06:21:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBB98C43141;
        Sat, 15 Oct 2022 06:21:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665814881;
        bh=JAFSXIL/EGUping96zU1v8CwG2+3OVXy0bb+UD3pUWw=;
        h=From:To:Cc:Subject:Date:From;
        b=x17rXpRvGQhkL3Z7lJS5CeHTbg5coZFlTWwFP5fAX9RgqMcYtFhJo3aGjYh6YJyUb
         7eKNCR7avdC3UXrmScmUIgidlxswl+hUJyePNqMEZyfZrkBnCtaAPAHnH0xd0il+Sd
         qZB8kbHfdIB1xrf+qRX8D2H6TnJrTkWeD8kOEsEs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.10.148
Date:   Sat, 15 Oct 2022 08:21:55 +0200
Message-Id: <166581491621139@kroah.com>
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

I'm announcing the release of the 5.10.148 kernel.

All users of the 5.10 kernel series must upgrade.

The updated 5.10.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.10.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/devicetree/bindings/dma/moxa,moxart-dma.txt   |    4 
 Documentation/process/code-of-conduct-interpretation.rst    |    2 
 Makefile                                                    |    2 
 arch/arm/boot/dts/moxart-uc7112lx.dts                       |    2 
 arch/arm/boot/dts/moxart.dtsi                               |    4 
 arch/powerpc/mm/book3s64/radix_pgtable.c                    |    9 
 arch/um/Makefile                                            |    8 
 arch/x86/um/shared/sysdep/syscalls_32.h                     |    5 
 arch/x86/um/tls_32.c                                        |    6 
 arch/x86/um/vdso/Makefile                                   |    2 
 drivers/char/mem.c                                          |    4 
 drivers/char/random.c                                       |   25 -
 drivers/clk/ti/clk-44xx.c                                   |  210 ++++++------
 drivers/clk/ti/clk-54xx.c                                   |  160 ++++-----
 drivers/clk/ti/clkctrl.c                                    |    4 
 drivers/dma/xilinx/xilinx_dma.c                             |   21 -
 drivers/firmware/arm_scmi/scmi_pm_domain.c                  |   20 +
 drivers/gpu/drm/amd/display/dc/dce110/dce110_hw_sequencer.c |    6 
 drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c          |    1 
 drivers/input/joystick/xpad.c                               |   20 +
 drivers/misc/pci_endpoint_test.c                            |   34 +
 drivers/mmc/core/sd.c                                       |    3 
 drivers/net/ethernet/aquantia/atlantic/aq_main.c            |    3 
 drivers/net/wireless/mac80211_hwsim.c                       |    2 
 drivers/rpmsg/qcom_glink_native.c                           |    2 
 drivers/rpmsg/qcom_smd.c                                    |    4 
 drivers/scsi/qedf/qedf_main.c                               |    5 
 drivers/scsi/stex.c                                         |   17 
 drivers/usb/mon/mon_bin.c                                   |    5 
 drivers/usb/serial/ftdi_sio.c                               |    3 
 drivers/usb/serial/qcserial.c                               |    1 
 fs/ceph/file.c                                              |   10 
 fs/inode.c                                                  |    7 
 fs/nilfs2/inode.c                                           |   19 +
 fs/nilfs2/segment.c                                         |   21 -
 include/linux/compiler-gcc.h                                |    3 
 include/linux/compiler_attributes.h                         |   24 +
 include/linux/compiler_types.h                              |    6 
 include/net/ieee802154_netdev.h                             |   37 ++
 include/net/xsk_buff_pool.h                                 |    2 
 include/scsi/scsi_cmnd.h                                    |    2 
 mm/gup.c                                                    |   34 +
 mm/khugepaged.c                                             |   10 
 net/ieee802154/socket.c                                     |   42 +-
 net/mac80211/rx.c                                           |   12 
 net/mac80211/util.c                                         |    2 
 net/wireless/scan.c                                         |   77 ++--
 net/xdp/xsk.c                                               |    4 
 net/xdp/xsk_buff_pool.c                                     |    5 
 scripts/Makefile.extrawarn                                  |    1 
 security/integrity/platform_certs/load_uefi.c               |    2 
 sound/core/oss/pcm_oss.c                                    |    5 
 sound/pci/hda/hda_intel.c                                   |    3 
 sound/pci/hda/patch_hdmi.c                                  |    1 
 tools/perf/util/get_current_dir_name.c                      |    3 
 55 files changed, 569 insertions(+), 357 deletions(-)

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
      Linux 5.10.148

Haimin Zhang (1):
      net/ieee802154: fix uninit value bug in dgram_sendmsg

Hu Weiwen (1):
      ceph: don't truncate file in atomic_open

Hugo Hu (1):
      drm/amd/display: update gamut remap if plane has changed

Jalal Mostafa (1):
      xsk: Inherit need_wakeup flag for shared sockets

Jaroslav Kysela (1):
      ALSA: hda/hdmi: Fix the converter reuse for the silent stream

Jason A. Donenfeld (4):
      random: restore O_NONBLOCK support
      random: clamp credited irq bits to maximum mixed
      random: avoid reading two cache lines on irq randomness
      random: use expired timer rather than wq for mixing fast pool

Jianglei Nie (1):
      net: atlantic: fix potential memory leak in aq_ndev_close()

Johan Hovold (1):
      USB: serial: ftdi_sio: fix 300 bps rate for SIO

Johannes Berg (8):
      wifi: cfg80211: fix u8 overflow in cfg80211_update_notlisted_nontrans()
      wifi: cfg80211/mac80211: reject bad MBSSID elements
      wifi: cfg80211: ensure length byte is present before access
      wifi: cfg80211: fix BSS refcounting bugs
      wifi: cfg80211: avoid nontransmitted BSS list corruption
      wifi: mac80211_hwsim: avoid mac80211 warning on bad rate
      wifi: mac80211: fix crash in beacon protection for P2P-device
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

Nick Desaulniers (1):
      compiler_attributes.h: move __compiletime_{error|warning}

Orlando Chamberlain (1):
      efi: Correct Macmini DMI match in uefi cert quirk

Pavel Rojtberg (1):
      Input: xpad - add supported devices as contributed on github

Ryusuke Konishi (4):
      nilfs2: fix NULL pointer dereference at nilfs_bmap_lookup_at_level()
      nilfs2: fix use-after-free bug of struct nilfs_root
      nilfs2: fix leak of nilfs_root in case of writer thread creation failure
      nilfs2: replace WARN_ONs by nilfs_error for checkpoint acquisition failure

Sami Tolvanen (1):
      Makefile.extrawarn: Move -Wcast-function-type-strict to W=1

Sasha Levin (1):
      Revert "clk: ti: Stop using legacy clkctrl names for omap4 and 5"

Sergei Antonov (1):
      ARM: dts: fix Moxa SDIO 'compatible', remove 'sdhci' misnomer

Shuah Khan (1):
      docs: update mediator information in CoC docs

Shunsuke Mie (2):
      misc: pci_endpoint_test: Aggregate params checking for xfer
      misc: pci_endpoint_test: Fix pci_endpoint_test_{copy,write,read}() panic

Swati Agarwal (3):
      dmaengine: xilinx_dma: Fix devm_platform_ioremap_resource error handling
      dmaengine: xilinx_dma: cleanup for fetching xlnx,num-fstores property
      dmaengine: xilinx_dma: Report error in case of dma_set_mask_and_coherent API failure

Tadeusz Struk (1):
      usb: mon: make mmapped memory read only

Takashi Iwai (2):
      ALSA: pcm: oss: Fix race at SNDCTL_DSP_SYNC
      ALSA: hda: Fix position reporting on Poulsbo

Yang Shi (2):
      mm: gup: fix the fast GUP race against THP collapse
      powerpc/64s/radix: don't need to broadcast IPI for radix pmd collapse flush

zhikzhai (1):
      drm/amd/display: skip audio setup when audio stream is enabled

