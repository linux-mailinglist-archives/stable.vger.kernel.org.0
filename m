Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98385356AF4
	for <lists+stable@lfdr.de>; Wed,  7 Apr 2021 13:17:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351824AbhDGLRJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Apr 2021 07:17:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:36594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1351818AbhDGLRD (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 7 Apr 2021 07:17:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C040761369;
        Wed,  7 Apr 2021 11:16:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617794213;
        bh=wmP1nN1hGJ4zzcoyeJjn9anKxliy7sYJn2dONOcbMZc=;
        h=From:To:Cc:Subject:Date:From;
        b=vjr10uFzbrPyagvclzhNqr5shb6PDlaMAJ56O7Mdhyhzfy1PtqzLWlCBJOkGq088a
         ZNXLFmIJcmtbQgHe8R9XyFiguFmpcBNpGDkGtKppF7gIP9E2f/KGNzwCckl+zTx2Dj
         /+5+FEfAFJk62p/Y6dnymZJkRLpNMVHZjfinxj4o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.19.185
Date:   Wed,  7 Apr 2021 13:16:47 +0200
Message-Id: <1617794207185142@kroah.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.19.185 kernel.

All users of the 4.19 kernel series must upgrade.

The updated 4.19.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.19.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                                    |    2 
 drivers/base/power/runtime.c                                |   10 +
 drivers/extcon/extcon.c                                     |    1 
 drivers/firewire/nosy.c                                     |    9 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c                      |   10 -
 drivers/net/ethernet/aquantia/atlantic/aq_main.c            |    4 
 drivers/net/wan/lmc/lmc_main.c                              |    2 
 drivers/net/wireless/ath/ath10k/wmi-tlv.c                   |    7 -
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c |    7 -
 drivers/pinctrl/pinctrl-rockchip.c                          |   13 +-
 drivers/scsi/qla2xxx/qla_target.h                           |    2 
 drivers/scsi/st.c                                           |    2 
 drivers/staging/comedi/drivers/cb_pcidas.c                  |    2 
 drivers/staging/comedi/drivers/cb_pcidas64.c                |    2 
 drivers/staging/rtl8192e/rtllib.h                           |    2 
 drivers/staging/rtl8192e/rtllib_rx.c                        |    2 
 drivers/thermal/thermal_sysfs.c                             |    3 
 drivers/usb/class/cdc-acm.c                                 |   61 ++++++---
 drivers/usb/core/quirks.c                                   |    4 
 drivers/usb/dwc2/hcd.c                                      |    2 
 drivers/usb/gadget/udc/amd5536udc_pci.c                     |   10 -
 drivers/usb/host/xhci-mtk.c                                 |   10 +
 drivers/usb/musb/musb_core.c                                |   12 +
 drivers/usb/usbip/vhci_hcd.c                                |    2 
 drivers/vhost/vhost.c                                       |    2 
 drivers/video/fbdev/core/fbcon.c                            |    3 
 fs/ext4/inode.c                                             |    6 
 fs/ext4/namei.c                                             |   18 +-
 fs/reiserfs/xattr.h                                         |    2 
 include/linux/extcon.h                                      |   23 +++
 include/net/inet_connection_sock.h                          |    2 
 kernel/locking/mutex.c                                      |   25 ++--
 kernel/trace/trace.c                                        |    3 
 mm/memory.c                                                 |    2 
 net/appletalk/ddp.c                                         |   33 +++--
 net/core/filter.c                                           |   12 -
 net/dccp/ipv6.c                                             |    5 
 net/ipv4/inet_connection_sock.c                             |    7 -
 net/ipv4/tcp_minisocks.c                                    |    7 -
 net/ipv6/ip6_input.c                                        |   10 -
 net/ipv6/tcp_ipv6.c                                         |    5 
 net/sunrpc/auth_gss/svcauth_gss.c                           |   11 +
 net/vmw_vsock/af_vsock.c                                    |    1 
 sound/pci/hda/patch_realtek.c                               |    3 
 sound/soc/codecs/cs42l42.c                                  |   74 +++++-------
 sound/soc/codecs/cs42l42.h                                  |   13 +-
 sound/soc/codecs/es8316.c                                   |    9 -
 sound/soc/codecs/rt5640.c                                   |    4 
 sound/soc/codecs/rt5651.c                                   |    4 
 sound/soc/codecs/rt5659.c                                   |    5 
 sound/soc/codecs/sgtl5000.c                                 |    2 
 sound/usb/quirks.c                                          |    1 
 52 files changed, 292 insertions(+), 181 deletions(-)

Adrian Hunter (2):
      PM: runtime: Fix race getting/putting suppliers at probe
      PM: runtime: Fix ordering in pm_runtime_get_suppliers()

Alexander Ovechkin (1):
      tcp: relookup sock for RST+ACK packets handled by obsolete req sock

Alexey Dobriyan (1):
      scsi: qla2xxx: Fix broken #endif placement

Artur Petrosyan (1):
      usb: dwc2: Fix HPRT0.PrtSusp bit setting for HiKey 960 board.

Atul Gopinathan (2):
      staging: rtl8192e: Fix incorrect source in memcpy()
      staging: rtl8192e: Change state information from u16 to u8

Benjamin Rood (1):
      ASoC: sgtl5000: set DAP_AVC_CTRL register to correct default value on probe

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
      Linux 4.19.185

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

Johan Hovold (2):
      USB: cdc-acm: fix double free on probe failure
      USB: cdc-acm: fix use-after-free after probe failure

Krzysztof Kozlowski (1):
      extcon: Add stubs for extcon_register_notifier_all() functions

Laurent Vivier (1):
      vhost: Fix vhost_vq_reset()

Luca Pesce (1):
      brcmfmac: clear EAP/association status bits on linkdown events

Lucas Tanure (4):
      ASoC: cs42l42: Fix Bitclock polarity inversion
      ASoC: cs42l42: Fix channel width support
      ASoC: cs42l42: Fix mixer volume control
      ASoC: cs42l42: Always wait at least 3ms after reset

Lv Yunlong (1):
      scsi: st: Fix a use after free in st_open()

Manaf Meethalavalappu Pallikunhi (1):
      thermal/core: Add NULL pointer check before using cooling device stats

Nathan Rossi (1):
      net: ethernet: aquantia: Handle error cleanup of start on open

Nirmoy Das (1):
      drm/amdgpu: fix offset calculation in amdgpu_vm_bo_clear_mappings()

Oliver Neukum (3):
      cdc-acm: fix BREAK rx code path adding necessary calls
      USB: cdc-acm: untangle a circular dependency between callback and softint
      USB: cdc-acm: downgrade message to debug

Sameer Pujar (1):
      ASoC: rt5659: Update MCLK rate in set_sysclk()

Shuah Khan (2):
      ath10k: hold RCU lock when calling ieee80211_find_sta_by_ifaddr()
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

Waiman Long (1):
      locking/ww_mutex: Simplify use_ww_ctx & ww_ctx handling

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

