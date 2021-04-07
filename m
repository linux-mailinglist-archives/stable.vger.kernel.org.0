Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68E41356AEE
	for <lists+stable@lfdr.de>; Wed,  7 Apr 2021 13:17:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351780AbhDGLQt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Apr 2021 07:16:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:36404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242260AbhDGLQt (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 7 Apr 2021 07:16:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 749CB61154;
        Wed,  7 Apr 2021 11:16:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617794200;
        bh=AU3v7RqhchyvV27KQryoW3RRC/7K1U4ZIRcW71MUkMQ=;
        h=From:To:Cc:Subject:Date:From;
        b=va6LP5stCbnuhxH8/Zo+Mn5aSWhK/0LRNsPt21S/QQGsQbImy6Hds6q6cbhvQuUrN
         KE2vfy/r9M/ojoUB1DcVvqCrVJxFOce7xcHwNImpen5mYlzu0GQS3gOcqcfJ6L1cAV
         aT7LJKHVTS4A03ENLvRZ8d7tL8DbzyQV0mAuO16U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.14.229
Date:   Wed,  7 Apr 2021 13:16:36 +0200
Message-Id: <1617794196159229@kroah.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.14.229 kernel.

All users of the 4.14 kernel series must upgrade.

The updated 4.14.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.14.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                                    |    2 
 arch/powerpc/include/asm/cpu_has_feature.h                  |    4 
 drivers/extcon/extcon.c                                     |    1 
 drivers/firewire/nosy.c                                     |    9 
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c                      |   10 -
 drivers/net/ethernet/aquantia/atlantic/aq_main.c            |    4 
 drivers/net/wan/lmc/lmc_main.c                              |    2 
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c |    7 
 drivers/pinctrl/pinctrl-rockchip.c                          |   13 -
 drivers/scsi/qla2xxx/qla_target.h                           |    2 
 drivers/scsi/st.c                                           |    2 
 drivers/staging/comedi/drivers/cb_pcidas.c                  |    2 
 drivers/staging/comedi/drivers/cb_pcidas64.c                |    2 
 drivers/staging/rtl8192e/rtllib.h                           |    2 
 drivers/staging/rtl8192e/rtllib_rx.c                        |    2 
 drivers/usb/class/cdc-acm.c                                 |   60 ++++--
 drivers/usb/core/quirks.c                                   |    4 
 drivers/usb/gadget/udc/amd5536udc_pci.c                     |   10 -
 drivers/usb/host/xhci-mtk.c                                 |   10 -
 drivers/usb/musb/musb_core.c                                |   12 -
 drivers/usb/usbip/vhci_hcd.c                                |    2 
 drivers/vhost/vhost.c                                       |    2 
 drivers/video/fbdev/core/fbcon.c                            |    3 
 fs/ext4/inode.c                                             |    6 
 fs/ext4/namei.c                                             |   18 -
 fs/reiserfs/xattr.h                                         |    2 
 include/linux/extcon.h                                      |   23 ++
 include/linux/memcontrol.h                                  |  111 ++++++++----
 kernel/trace/trace.c                                        |    3 
 mm/memcontrol.c                                             |   54 ++++-
 mm/memory.c                                                 |    2 
 mm/oom_kill.c                                               |    2 
 mm/vmscan.c                                                 |    2 
 net/appletalk/ddp.c                                         |   33 ++-
 net/core/filter.c                                           |   11 -
 net/dccp/ipv6.c                                             |    5 
 net/ipv6/ip6_input.c                                        |   10 -
 net/ipv6/tcp_ipv6.c                                         |    5 
 net/sunrpc/auth_gss/svcauth_gss.c                           |   11 -
 net/vmw_vsock/af_vsock.c                                    |    1 
 sound/pci/hda/patch_realtek.c                               |    3 
 sound/soc/codecs/cs42l42.c                                  |    7 
 sound/soc/codecs/cs42l42.h                                  |    1 
 sound/soc/codecs/es8316.c                                   |    9 
 sound/soc/codecs/rt5640.c                                   |    4 
 sound/soc/codecs/rt5651.c                                   |    4 
 sound/soc/codecs/rt5659.c                                   |    5 
 sound/soc/codecs/sgtl5000.c                                 |    2 
 sound/usb/quirks.c                                          |    1 
 49 files changed, 334 insertions(+), 168 deletions(-)

Aaron Lu (1):
      mem_cgroup: make sure moving_account, move_lock_task and stat_cpu in the same cacheline

Alexey Dobriyan (1):
      scsi: qla2xxx: Fix broken #endif placement

Atul Gopinathan (2):
      staging: rtl8192e: Fix incorrect source in memcpy()
      staging: rtl8192e: Change state information from u16 to u8

Benjamin Rood (1):
      ASoC: sgtl5000: set DAP_AVC_CTRL register to correct default value on probe

Christophe Leroy (1):
      powerpc: Force inlining of cpu_has_feature() to avoid build failure

Chunfeng Yun (1):
      usb: xhci-mtk: fix broken streams issue on 0.96 xHCI

David Brazdil (1):
      selinux: vsock: Set SID for socket returned by accept()

Dinghao Liu (1):
      extcon: Fix error handling in extcon_dev_register

Doug Brown (1):
      appletalk: Fix skb allocation size in loopback case

Du Cheng (1):
      drivers: video: fbcon: fix NULL dereference in fbcon_cursor()

Greg Kroah-Hartman (1):
      Linux 4.14.229

Greg Thelen (1):
      mm: writeback: use exact memcg dirty counts

Hans de Goede (3):
      ASoC: rt5640: Fix dac- and adc- vol-tlv values being off by a factor of 10
      ASoC: rt5651: Fix dac- and adc- vol-tlv values being off by a factor of 10
      ASoC: es8316: Simplify adc_pga_gain_tlv table

Hui Wang (2):
      ALSA: hda/realtek: fix a determine_headset_type issue for a Dell AIO
      ALSA: hda/realtek: call alc_update_headset_mode() in hp_automute_hook

Ikjoon Jang (1):
      ALSA: usb-audio: Apply sample rate quirk to Logitech Connect

Ilya Lipnitskiy (1):
      mm: fix race by making init_zero_pfn() early_initcall

J. Bruce Fields (1):
      rpc: fix NULL dereference on kmalloc failure

Jakub Kicinski (1):
      ipv6: weaken the v4mapped source check

Jesper Dangaard Brouer (1):
      bpf: Remove MTU check in __bpf_skb_max_len

Johan Hovold (1):
      USB: cdc-acm: fix use-after-free after probe failure

Johannes Weiner (2):
      mm: memcontrol: fix NR_WRITEBACK leak in memcg and system stats
      mm: memcg: make sure memory.events is uptodate when waking pollers

Krzysztof Kozlowski (1):
      extcon: Add stubs for extcon_register_notifier_all() functions

Laurent Vivier (1):
      vhost: Fix vhost_vq_reset()

Luca Pesce (1):
      brcmfmac: clear EAP/association status bits on linkdown events

Lucas Tanure (2):
      ASoC: cs42l42: Fix mixer volume control
      ASoC: cs42l42: Always wait at least 3ms after reset

Lv Yunlong (1):
      scsi: st: Fix a use after free in st_open()

Nathan Rossi (1):
      net: ethernet: aquantia: Handle error cleanup of start on open

Nirmoy Das (1):
      drm/amdgpu: fix offset calculation in amdgpu_vm_bo_clear_mappings()

Oliver Neukum (3):
      cdc-acm: fix BREAK rx code path adding necessary calls
      USB: cdc-acm: untangle a circular dependency between callback and softint
      USB: cdc-acm: downgrade message to debug

Roman Gushchin (1):
      mm: fix oom_kill event handling

Sameer Pujar (1):
      ASoC: rt5659: Update MCLK rate in set_sysclk()

Shuah Khan (1):
      usbip: vhci_hcd fix shift out-of-bounds in vhci_hub_control()

Steven Rostedt (VMware) (1):
      tracing: Fix stack trace event size

Tetsuo Handa (1):
      reiserfs: update reiserfs_xattrs_initialized() condition

Tong Zhang (4):
      staging: comedi: cb_pcidas: fix request_irq() warn
      staging: comedi: cb_pcidas64: fix request_irq() warn
      net: wan/lmc: unregister device when no matching device is found
      usb: gadget: udc: amd5536udc_pci fix null-ptr-dereference

Tony Lindgren (1):
      usb: musb: Fix suspend with devices connected for a64

Vincent Palatin (1):
      USB: quirks: ignore remote wake-up on Fibocom L850-GL LTE modem

Wang Panzhenzhuan (1):
      pinctrl: rockchip: fix restore error in resume

Xℹ Ruoyao (1):
      drm/amdgpu: check alignment on CPU page for bo map

Zhaolong Zhang (1):
      ext4: fix bh ref count on error paths

Zheyu Ma (1):
      firewire: nosy: Fix a use-after-free bug in nosy_ioctl()

zhangyi (F) (1):
      ext4: do not iput inode under running transaction in ext4_rename()

