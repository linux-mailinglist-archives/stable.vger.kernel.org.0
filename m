Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7596153340
	for <lists+stable@lfdr.de>; Wed,  5 Feb 2020 15:43:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726460AbgBEOn5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Feb 2020 09:43:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:37056 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726119AbgBEOn5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 Feb 2020 09:43:57 -0500
Received: from localhost (unknown [212.187.182.165])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D86832082E;
        Wed,  5 Feb 2020 14:43:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580913834;
        bh=tO+tx4ayHvBti69UlF1Kg2TOUGO2/c6IVSqlgyPexFA=;
        h=Date:From:To:Cc:Subject:From;
        b=YX87EaLD9EJisi+i1kw2iPvNv/oMilq6uC0fumG1P4nMmJXbhfSmj7iHVWx50d8bY
         oBDPBX7zU31/I47u+4EF1MmcLZJuCeDxDrUGFicYfU4Nhh/4xbRhDMDF0CKTWuZCfS
         5J69HGT+jehwO+UkEbQWKtPzod/1K6jtDMyiY8M4=
Date:   Wed, 5 Feb 2020 14:43:51 +0000
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.4.213
Message-ID: <20200205144351.GA1232083@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.4.213 kernel.

All users of the 4.4 kernel series must upgrade.

The updated 4.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                              |    2 
 arch/arm64/boot/Makefile                              |    2 
 crypto/af_alg.c                                       |    6 
 crypto/pcrypt.c                                       |    3 
 drivers/atm/eni.c                                     |    4 
 drivers/char/ttyprintk.c                              |   15 +
 drivers/clk/mmp/clk-of-mmp2.c                         |    2 
 drivers/media/radio/si470x/radio-si470x-i2c.c         |    2 
 drivers/media/usb/dvb-usb/digitv.c                    |   10 -
 drivers/media/usb/dvb-usb/dvb-usb-urb.c               |    2 
 drivers/media/usb/gspca/gspca.c                       |    2 
 drivers/net/ethernet/broadcom/b44.c                   |    9 -
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c    |    3 
 drivers/net/ethernet/chelsio/cxgb4/l2t.c              |    3 
 drivers/net/ethernet/freescale/xgmac_mdio.c           |    7 
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c         |   37 +++-
 drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c     |    5 
 drivers/net/ethernet/natsemi/sonic.c                  |  109 +++++++++++---
 drivers/net/ethernet/natsemi/sonic.h                  |   25 +--
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_init.c |    1 
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_minidump.c  |    2 
 drivers/net/usb/r8152.c                               |    9 -
 drivers/net/wan/sdla.c                                |    2 
 drivers/net/wireless/airo.c                           |   20 +-
 drivers/net/wireless/ath/ath9k/hif_usb.c              |    2 
 drivers/net/wireless/brcm80211/brcmfmac/usb.c         |    4 
 drivers/net/wireless/orinoco/orinoco_usb.c            |    4 
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c      |    2 
 drivers/net/wireless/rsi/rsi_91x_usb.c                |    2 
 drivers/net/wireless/zd1211rw/zd_usb.c                |    2 
 drivers/scsi/fnic/fnic_scsi.c                         |    3 
 drivers/staging/most/aim-network/networking.c         |   10 +
 drivers/staging/vt6656/device.h                       |    2 
 drivers/staging/vt6656/int.c                          |    6 
 drivers/staging/vt6656/main_usb.c                     |    1 
 drivers/staging/vt6656/rxtx.c                         |   26 +--
 drivers/staging/wlan-ng/prism2mgmt.c                  |    2 
 drivers/usb/dwc3/core.c                               |    3 
 drivers/usb/serial/ir-usb.c                           |  136 +++++++++++++-----
 drivers/usb/storage/unusual_uas.h                     |    7 
 drivers/watchdog/rn5t618_wdt.c                        |    1 
 fs/btrfs/super.c                                      |   24 ++-
 fs/namei.c                                            |    4 
 fs/reiserfs/super.c                                   |    2 
 include/linux/usb/irda.h                              |   13 +
 mm/mempolicy.c                                        |    6 
 net/core/utils.c                                      |   20 ++
 net/ipv4/ip_vti.c                                     |   13 +
 net/ipv6/ip6_vti.c                                    |   13 +
 net/sched/ematch.c                                    |    3 
 net/wireless/wext-core.c                              |    3 
 sound/core/pcm_native.c                               |    2 
 52 files changed, 434 insertions(+), 164 deletions(-)

Al Viro (1):
      vfs: fix do_last() regression

Andreas Kemnade (1):
      watchdog: rn5t618_wdt: fix module aliases

Andrey Shvetsov (1):
      staging: most: net: fix buffer overflow

Arnd Bergmann (2):
      atm: eni: fix uninitialized variable warning
      wireless: wext: avoid gcc -O3 warning

Bin Liu (1):
      usb: dwc3: turn off VBUS when leaving host mode

Cambda Zhu (1):
      ixgbe: Fix calculation of queue with VFs and flow director on interface flap

Colin Ian King (1):
      staging: wlan-ng: ensure error return is actually returned

Dan Carpenter (1):
      mm/mempolicy.c: fix out of bounds write in mpol_parse_str()

Dirk Behme (1):
      arm64: kbuild: remove compressed images on 'make ARCH=arm64 (dist)clean'

Eric Dumazet (1):
      net_sched: ematch: reject invalid TCF_EM_SIMPLE

Fenghua Yu (1):
      drivers/net/b44: Change to non-atomic bit operations on pwol_mask

Finn Thain (4):
      net/sonic: Add mutual exclusion for accessing shared state
      net/sonic: Use MMIO accessors
      net/sonic: Fix receive buffer handling
      net/sonic: Quiesce SONIC before re-initializing descriptor memory

Greg Kroah-Hartman (1):
      Linux 4.4.213

Hannes Reinecke (1):
      scsi: fnic: do not queue commands during fwreset

Hans Verkuil (2):
      media: gspca: zero usb_buf
      media: dvb-usb/dvb-usb-urb.c: initialize actlen to 0

Hayes Wang (1):
      r8152: get default setting of WOL before initializing

Herbert Xu (2):
      crypto: af_alg - Use bh_lock_sock in sk_destruct
      crypto: pcrypt - Fix user-after-free on module unload

Jan Kara (1):
      reiserfs: Fix memory leak of journal device string

Johan Hovold (9):
      orinoco_usb: fix interface sanity check
      rsi_91x_usb: fix interface sanity check
      USB: serial: ir-usb: add missing endpoint sanity check
      USB: serial: ir-usb: fix link-speed handling
      USB: serial: ir-usb: fix IrLAP framing
      ath9k: fix storage endpoint lookup
      brcmfmac: fix interface sanity check
      rtl8xxxu: fix interface sanity check
      zd1211rw: fix storage endpoint lookup

Josef Bacik (1):
      btrfs: do not zero f_bavail if we have available space

Krzysztof Kozlowski (1):
      net: wan: sdla: Fix cast from pointer to integer of different size

Laura Abbott (1):
      usb-storage: Disable UAS on JMicron SATA enclosure

Lee Jones (1):
      media: si470x-i2c: Move free() past last use of 'radio'

Lubomir Rintel (1):
      clk: mmp2: Fix the order of timer mux parents

Luis de Bethencourt (1):
      btrfs: fix mixed block count of available space

Madalin Bucur (1):
      net/fsl: treat fsl,erratum-a011043

Malcolm Priestley (3):
      staging: vt6656: correct packet types for CTS protect, mode.
      staging: vt6656: use NULLFUCTION stack on mac80211
      staging: vt6656: Fix false Tx excessive retries reporting.

Manish Chopra (1):
      qlcnic: Fix CPU soft lockup while collecting firmware dump

Michael Ellerman (2):
      airo: Fix possible info leak in AIROOLDIOCTL/SIOCDEVPRIVATE
      airo: Add missing CAP_NET_ADMIN check in AIROOLDIOCTL/SIOCDEVPRIVATE

Nicolas Dichtel (1):
      vti[6]: fix packet tx through bpf_redirect()

Praveen Chaudhary (1):
      net: Fix skb->csum update in inet_proto_csum_replace16().

Radoslaw Tyl (1):
      ixgbevf: Remove limit of 10 entries for unicast filter list

Sean Young (1):
      media: digitv: don't continue if remote control state can't be read

Takashi Iwai (1):
      ALSA: pcm: Add missing copy ops check before clearing buffer

Vasily Averin (2):
      seq_tab_next() should increase position index
      l2t_seq_next should increase position index

Zhenzhong Duan (1):
      ttyprintk: fix a potential deadlock in interrupt context issue

