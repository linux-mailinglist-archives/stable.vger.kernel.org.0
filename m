Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECB8A48124E
	for <lists+stable@lfdr.de>; Wed, 29 Dec 2021 12:49:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236468AbhL2Lto (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Dec 2021 06:49:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235849AbhL2Lto (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Dec 2021 06:49:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97F0BC06173E;
        Wed, 29 Dec 2021 03:49:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 33C3461451;
        Wed, 29 Dec 2021 11:49:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EAAFC36AE7;
        Wed, 29 Dec 2021 11:49:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640778582;
        bh=XXDa4c6mBNAd3oRF/1XxbltR0dS5i74yORl5goSuZU8=;
        h=From:To:Cc:Subject:Date:From;
        b=VkwMs5DhxZ1tFwjkQJnP9X9VxvZP+MX2aiO8DA6Doh//wPIVF/R7O785POCp3q+qo
         ozH4y1Op/q/jdGOTfp9BaugDjaN2SHhEhfEK9zK+hM531E+xMvvuKdSIoPgdd3lHHg
         lOGXlY947euIsdNkUFxcYLCCS4GePdXMOG01DwTI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.4.169
Date:   Wed, 29 Dec 2021 12:49:35 +0100
Message-Id: <164077857661164@kroah.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.4.169 kernel.

All users of the 5.4 kernel series must upgrade.

The updated 5.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/admin-guide/kernel-parameters.txt                |    8 
 Documentation/hwmon/lm90.rst                                   |   33 +
 Documentation/networking/bonding.txt                           |   11 
 Makefile                                                       |    2 
 arch/arm/kernel/entry-armv.S                                   |    8 
 arch/arm64/boot/dts/allwinner/sun50i-h5-orangepi-zero-plus.dts |    2 
 arch/parisc/kernel/syscall.S                                   |    2 
 arch/x86/include/asm/pgtable.h                                 |    4 
 drivers/char/ipmi/ipmi_msghandler.c                            |   21 -
 drivers/char/ipmi/ipmi_ssif.c                                  |    7 
 drivers/hid/hid-holtek-mouse.c                                 |   15 
 drivers/hwmon/Kconfig                                          |    9 
 drivers/hwmon/lm90.c                                           |  200 +++++++---
 drivers/infiniband/hw/qib/qib_user_sdma.c                      |    2 
 drivers/input/mouse/elantech.c                                 |    8 
 drivers/input/touchscreen/atmel_mxt_ts.c                       |    2 
 drivers/mmc/core/core.c                                        |    7 
 drivers/mmc/core/core.h                                        |    1 
 drivers/mmc/core/host.c                                        |    9 
 drivers/mmc/host/sdhci-tegra.c                                 |   43 +-
 drivers/net/bonding/bond_options.c                             |    2 
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_sriov.h              |    2 
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_sriov_common.c       |   12 
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_sriov_pf.c           |    4 
 drivers/net/ethernet/sfc/falcon/rx.c                           |    5 
 drivers/net/ethernet/smsc/smc911x.c                            |    5 
 drivers/net/fjes/fjes_main.c                                   |    5 
 drivers/net/hamradio/mkiss.c                                   |    5 
 drivers/net/usb/lan78xx.c                                      |    6 
 drivers/pinctrl/mediatek/pinctrl-mtk-common-v2.c               |    8 
 drivers/pinctrl/stm32/pinctrl-stm32.c                          |    8 
 drivers/spi/spi-armada-3700.c                                  |    2 
 drivers/tee/optee/shm_pool.c                                   |    6 
 drivers/tty/serial/8250/8250_fintek.c                          |   19 
 drivers/usb/gadget/function/u_ether.c                          |   15 
 fs/f2fs/xattr.c                                                |   11 
 include/linux/virtio_net.h                                     |   25 +
 mm/mempolicy.c                                                 |    5 
 net/ax25/af_ax25.c                                             |    4 
 net/netfilter/nfnetlink_log.c                                  |    3 
 net/netfilter/nfnetlink_queue.c                                |    3 
 net/phonet/pep.c                                               |    2 
 sound/core/jack.c                                              |    4 
 sound/drivers/opl3/opl3_midi.c                                 |    2 
 sound/pci/hda/patch_realtek.c                                  |    1 
 45 files changed, 385 insertions(+), 173 deletions(-)

Andrea Righi (1):
      Input: elantech - fix stack out of bound access in elantech_change_report_id()

Andrew Cooper (1):
      x86/pkey: Fix undefined behaviour with PKRU_WD_BIT

Andrey Ryabinin (1):
      mm: mempolicy: fix THP allocations escaping mempolicy restrictions

Ard Biesheuvel (1):
      ARM: 9169/1: entry: fix Thumb2 bug in iWMMXt exception handling

Benjamin Tissoires (1):
      HID: holtek: fix mouse probing

Bradley Scott (1):
      ALSA: hda/realtek: Amp init fixup for HP ZBook 15 G6

Chao Yu (1):
      f2fs: fix to do sanity check on last xattr entry in __f2fs_setxattr()

Colin Ian King (1):
      ALSA: drivers: opl3: Fix incorrect use of vp->state

Dongliang Mu (1):
      spi: change clk_disable_unprepare to clk_unprepare

Fabien Dessenne (1):
      pinctrl: stm32: consider the GPIO offset to expose all the GPIO lines

Fernando Fernandez Mancera (1):
      bonding: fix ad_actor_system option setting to default

Greg Jesionowski (1):
      net: usb: lan78xx: add Allied Telesis AT29M2-AF

Greg Kroah-Hartman (1):
      Linux 5.4.169

Guenter Roeck (6):
      hwmon: (lm90) Fix usage of CONFIG2 register in detect function
      hwmon: (lm90) Add basic support for TI TMP461
      hwmon: (lm90) Introduce flag indicating extended temperature support
      hwmon: (lm90) Drop critical attribute support for MAX6654
      hwmom: (lm90) Fix citical alarm status for MAX6680/MAX6681
      hwmon: (lm90) Do not report 'busy' status bit as alarm

Guodong Liu (1):
      pinctrl: mediatek: fix global-out-of-bounds issue

Ignacy Gawędzki (1):
      netfilter: fix regression in looped (broad|multi)cast's MAC handling

Ji-Ze Hong (Peter Hong) (1):
      serial: 8250_fintek: Fix garbled text for console

Jiasheng Jiang (4):
      qlcnic: potential dereference null pointer of rx_queue->page_ring
      fjes: Check for error irq
      drivers: net: smc911x: Check for error irq
      sfc: falcon: Check null pointer of rx_queue->page_ring

John David Anglin (1):
      parisc: Correct completer in lws start

Josh Lehan (1):
      hwmon: (lm90) Add max6654 support to lm90 driver

José Expósito (2):
      IB/qib: Fix memory leak in qib_user_sdma_queue_pkts()
      Input: atmel_mxt_ts - fix double free in mxt_read_info_block

Lin Ma (3):
      ax25: NPD bug when detaching AX25 device
      hamradio: defer ax25 kfree after unregister_netdev
      hamradio: improve the incomplete fix to avoid NPD

Marian Postevca (1):
      usb: gadget: u_ether: fix race in setting MAC address in setup phase

Mian Yousaf Kaukab (1):
      ipmi: ssif: initialize ssif_info->client early

Prathamesh Shete (1):
      mmc: sdhci-tegra: Fix switch to HS400ES mode

Robert Marko (1):
      arm64: dts: allwinner: orangepi-zero-plus: fix PHY mode

Rémi Denis-Courmont (1):
      phonet/pep: refuse to enable an unbound pipe

Sean Christopherson (1):
      KVM: VMX: Fix stale docs for kvm-intel.emulate_invalid_guest_state

Sumit Garg (1):
      tee: optee: Fix incorrect page free bug

Thadeu Lima de Souza Cascardo (2):
      ipmi: bail out if init_srcu_struct fails
      ipmi: fix initialization when workqueue allocation fails

Ulf Hansson (1):
      mmc: core: Disable card detect during shutdown

Willem de Bruijn (2):
      net: accept UFOv6 packages in virtio_net_hdr_to_skb
      net: skip virtio_net_hdr_set_proto if protocol already set

Wu Bo (1):
      ipmi: Fix UAF when uninstall ipmi_si and ipmi_msghandler module

Xiaoke Wang (1):
      ALSA: jack: Check the return value of kstrdup()

