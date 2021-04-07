Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA816356CD5
	for <lists+stable@lfdr.de>; Wed,  7 Apr 2021 15:02:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352533AbhDGNCx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Apr 2021 09:02:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:55046 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235783AbhDGNCv (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 7 Apr 2021 09:02:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8B5456120E;
        Wed,  7 Apr 2021 13:02:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617800560;
        bh=DbYRVrucLxHO9nHAsZNRRY10cuy9CJ4SfSE3AZCTTyU=;
        h=From:To:Cc:Subject:Date:From;
        b=CoA7ej/8wWGByHpBlPuVWjcTyHaGR9tghQvuFvwTR12Wn5nuTsdZtS5sN0TT4F4RQ
         K1WSHK/yVUWH0aLC0Mgmz/DuxX20u36wfBxV9sFeqtm6kPlQV28ZJ/TkCJB0UYWfai
         2Onu71mNrak6ZIYrs9QV7nqEramvdkqKeTtcFPc0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.4.110
Date:   Wed,  7 Apr 2021 15:02:36 +0200
Message-Id: <16178005569257@kroah.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.4.110 kernel.

All users of the 5.4 kernel series must upgrade.

The updated 5.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                                    |    2 
 arch/powerpc/include/asm/cpu_has_feature.h                  |    4 
 arch/xtensa/kernel/coprocessor.S                            |   64 
 drivers/base/power/runtime.c                                |   10 
 drivers/extcon/extcon.c                                     |    1 
 drivers/firewire/nosy.c                                     |    9 
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c                      |   10 
 drivers/net/can/Makefile                                    |    7 
 drivers/net/can/dev.c                                       | 1310 -----------
 drivers/net/can/dev/Makefile                                |    7 
 drivers/net/can/dev/dev.c                                   | 1312 ++++++++++++
 drivers/net/can/dev/rx-offload.c                            |  395 +++
 drivers/net/can/m_can/tcan4x5x.c                            |    2 
 drivers/net/can/rx-offload.c                                |  395 ---
 drivers/net/can/slcan.c                                     |    4 
 drivers/net/can/vcan.c                                      |    2 
 drivers/net/can/vxcan.c                                     |    6 
 drivers/net/ethernet/aquantia/atlantic/aq_main.c            |    4 
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c             |    4 
 drivers/net/wan/lmc/lmc_main.c                              |    2 
 drivers/net/wireless/ath/ath10k/wmi-tlv.c                   |    7 
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c |    7 
 drivers/pinctrl/pinctrl-rockchip.c                          |   13 
 drivers/scsi/qla2xxx/qla_target.h                           |    2 
 drivers/scsi/st.c                                           |    2 
 drivers/staging/comedi/drivers/cb_pcidas.c                  |    2 
 drivers/staging/comedi/drivers/cb_pcidas64.c                |    2 
 drivers/staging/rtl8192e/rtllib.h                           |    2 
 drivers/staging/rtl8192e/rtllib_rx.c                        |    2 
 drivers/thermal/thermal_sysfs.c                             |    3 
 drivers/usb/class/cdc-acm.c                                 |   61 
 drivers/usb/core/quirks.c                                   |    4 
 drivers/usb/dwc2/hcd.c                                      |    5 
 drivers/usb/gadget/udc/amd5536udc_pci.c                     |   10 
 drivers/usb/host/xhci-mtk.c                                 |   10 
 drivers/usb/musb/musb_core.c                                |   12 
 drivers/usb/usbip/vhci_hcd.c                                |    2 
 drivers/vfio/pci/Kconfig                                    |    2 
 drivers/vhost/vhost.c                                       |    2 
 drivers/video/fbdev/core/fbcon.c                            |    3 
 fs/ext4/balloc.c                                            |   38 
 fs/ext4/ext4.h                                              |    1 
 fs/ext4/inode.c                                             |    6 
 fs/ext4/namei.c                                             |   18 
 fs/ext4/super.c                                             |    5 
 fs/ext4/sysfs.c                                             |    7 
 fs/iomap/swapfile.c                                         |   10 
 fs/nfsd/Kconfig                                             |    1 
 fs/nfsd/nfs4callback.c                                      |    1 
 fs/reiserfs/xattr.h                                         |    2 
 include/linux/can/can-ml.h                                  |   12 
 include/linux/extcon.h                                      |   23 
 include/linux/netdevice.h                                   |   34 
 kernel/locking/mutex.c                                      |   25 
 kernel/module.c                                             |  166 +
 kernel/module_signature.c                                   |    2 
 kernel/module_signing.c                                     |    2 
 kernel/trace/trace.c                                        |    3 
 mm/memory.c                                                 |    2 
 net/appletalk/ddp.c                                         |   33 
 net/can/af_can.c                                            |   34 
 net/can/j1939/main.c                                        |   22 
 net/can/j1939/socket.c                                      |   13 
 net/can/proc.c                                              |   19 
 net/core/filter.c                                           |   12 
 net/core/flow_dissector.c                                   |    6 
 net/dccp/ipv6.c                                             |    5 
 net/ipv6/ip6_input.c                                        |   10 
 net/ipv6/tcp_ipv6.c                                         |    5 
 net/sunrpc/auth_gss/svcauth_gss.c                           |   11 
 net/vmw_vsock/af_vsock.c                                    |    1 
 sound/pci/hda/hda_intel.c                                   |    8 
 sound/pci/hda/patch_realtek.c                               |    3 
 sound/soc/codecs/cs42l42.c                                  |   74 
 sound/soc/codecs/cs42l42.h                                  |   13 
 sound/soc/codecs/es8316.c                                   |    9 
 sound/soc/codecs/rt5640.c                                   |    4 
 sound/soc/codecs/rt5651.c                                   |    4 
 sound/soc/codecs/rt5659.c                                   |    5 
 sound/soc/codecs/sgtl5000.c                                 |    2 
 sound/usb/quirks.c                                          |    1 
 tools/testing/selftests/net/forwarding/tc_flower.sh         |   38 
 82 files changed, 2356 insertions(+), 2037 deletions(-)

Adrian Hunter (2):
      PM: runtime: Fix race getting/putting suppliers at probe
      PM: runtime: Fix ordering in pm_runtime_get_suppliers()

Alexey Dobriyan (1):
      scsi: qla2xxx: Fix broken #endif placement

Artur Petrosyan (2):
      usb: dwc2: Fix HPRT0.PrtSusp bit setting for HiKey 960 board.
      usb: dwc2: Prevent core suspend when port connection flag is 0

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

Davide Caratti (1):
      flow_dissector: fix TTL and TOS dissection on IPv4 fragments

Dinghao Liu (1):
      extcon: Fix error handling in extcon_dev_register

Doug Brown (1):
      appletalk: Fix skb allocation size in loopback case

Du Cheng (1):
      drivers: video: fbcon: fix NULL dereference in fbcon_cursor()

Eric Whitney (1):
      ext4: shrink race window in ext4_should_retry_alloc()

Frank van der Linden (1):
      module: harden ELF info handling

Greg Kroah-Hartman (1):
      Linux 5.4.110

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

Jason Gunthorpe (1):
      vfio/nvlink: Add missing SPAPR_TCE_IOMMU depends

Jesper Dangaard Brouer (1):
      bpf: Remove MTU check in __bpf_skb_max_len

Jessica Yu (1):
      modsign: print module name along with error message

Johan Hovold (2):
      USB: cdc-acm: fix double free on probe failure
      USB: cdc-acm: fix use-after-free after probe failure

Julian Braha (1):
      fs: nfsd: fix kconfig dependency warning for NFSD_V4

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

Marc Kleine-Budde (1):
      can: dev: move driver related infrastructure into separate subdir

Max Filippov (1):
      xtensa: move coprocessor_flush to the .text section

Nathan Rossi (1):
      net: ethernet: aquantia: Handle error cleanup of start on open

Nirmoy Das (1):
      drm/amdgpu: fix offset calculation in amdgpu_vm_bo_clear_mappings()

Oleksij Rempel (1):
      net: introduce CAN specific pointer in the struct net_device

Olga Kornievskaia (1):
      NFSD: fix error handling in NFSv4.0 callbacks

Oliver Neukum (3):
      cdc-acm: fix BREAK rx code path adding necessary calls
      USB: cdc-acm: untangle a circular dependency between callback and softint
      USB: cdc-acm: downgrade message to debug

Ritesh Harjani (1):
      iomap: Fix negative assignment to unsigned sis->pages in iomap_swapfile_activate

Sameer Pujar (1):
      ASoC: rt5659: Update MCLK rate in set_sysclk()

Sasha Levin (2):
      net: mvpp2: fix interrupt mask/unmask skip condition
      can: tcan4x5x: fix max register value

Sergey Shtylyov (2):
      module: merge repetitive strings in module_sig_check()
      module: avoid *goto*s in module_sig_check()

Shuah Khan (2):
      ath10k: hold RCU lock when calling ieee80211_find_sta_by_ifaddr()
      usbip: vhci_hcd fix shift out-of-bounds in vhci_hub_control()

Steven Rostedt (VMware) (1):
      tracing: Fix stack trace event size

Takashi Iwai (2):
      ALSA: hda: Re-add dropped snd_poewr_change_state() calls
      ALSA: hda: Add missing sanity checks in PM prepare/complete callbacks

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

