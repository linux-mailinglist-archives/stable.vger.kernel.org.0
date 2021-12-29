Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA8FD48121D
	for <lists+stable@lfdr.de>; Wed, 29 Dec 2021 12:44:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239984AbhL2Loj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Dec 2021 06:44:39 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:41954 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239968AbhL2Loi (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Dec 2021 06:44:38 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3E9706149B;
        Wed, 29 Dec 2021 11:44:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27258C36AE9;
        Wed, 29 Dec 2021 11:44:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640778277;
        bh=VIT1wG8k+KKH9LoOnKmMpUrYgPJstFUITaxgR8FNUQA=;
        h=From:To:Cc:Subject:Date:From;
        b=TNESxpbr4E2kcKyeIYuX4kncr5FP4J5YL7IGZmormdjr/0tnignsrovu7h7SCK1wA
         GVj2pYoNTjKeiZvZY+10asthkRDequjsqmAqanEUDwx2HI2AfW6LEhQjtsACfC1Wlb
         nrBrIPJiaA901Ca2eNgvktl5oplgp8YCilJruD3Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.14.260
Date:   Wed, 29 Dec 2021 12:44:30 +0100
Message-Id: <164077827161125@kroah.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.14.260 kernel.

All users of the 4.14 kernel series must upgrade.

The updated 4.14.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.14.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/admin-guide/kernel-parameters.txt          |    8 ++
 Documentation/networking/bonding.txt                     |   11 ++--
 Makefile                                                 |    2 
 arch/arm/kernel/entry-armv.S                             |    8 +-
 arch/x86/include/asm/pgtable.h                           |    4 -
 drivers/hid/hid-holtek-mouse.c                           |   15 +++++
 drivers/hwmon/lm90.c                                     |    8 +-
 drivers/infiniband/hw/qib/qib_user_sdma.c                |    2 
 drivers/input/touchscreen/atmel_mxt_ts.c                 |    2 
 drivers/net/bonding/bond_options.c                       |    2 
 drivers/net/can/usb/kvaser_usb.c                         |   41 +++++++++++++--
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_sriov.h        |    2 
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_sriov_common.c |   12 +++-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_sriov_pf.c     |    4 +
 drivers/net/ethernet/sfc/falcon/rx.c                     |    5 +
 drivers/net/ethernet/smsc/smc911x.c                      |    5 +
 drivers/net/fjes/fjes_main.c                             |    5 +
 drivers/net/hamradio/mkiss.c                             |    5 +
 drivers/net/usb/lan78xx.c                                |    6 ++
 drivers/pinctrl/stm32/pinctrl-stm32.c                    |    8 +-
 drivers/spi/spi-armada-3700.c                            |    2 
 drivers/usb/gadget/function/u_ether.c                    |   15 +----
 fs/f2fs/xattr.c                                          |    9 ++-
 include/linux/virtio_net.h                               |   25 ++++++++-
 net/ax25/af_ax25.c                                       |    4 +
 net/netfilter/nfnetlink_log.c                            |    3 -
 net/netfilter/nfnetlink_queue.c                          |    3 -
 net/phonet/pep.c                                         |    2 
 sound/core/jack.c                                        |    4 +
 sound/drivers/opl3/opl3_midi.c                           |    2 
 30 files changed, 167 insertions(+), 57 deletions(-)

Andrew Cooper (1):
      x86/pkey: Fix undefined behaviour with PKRU_WD_BIT

Ard Biesheuvel (1):
      ARM: 9169/1: entry: fix Thumb2 bug in iWMMXt exception handling

Benjamin Tissoires (1):
      HID: holtek: fix mouse probing

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
      Linux 4.14.260

Guenter Roeck (2):
      hwmon: (lm90) Fix usage of CONFIG2 register in detect function
      hwmon: (lm90) Do not report 'busy' status bit as alarm

Ignacy Gawędzki (1):
      netfilter: fix regression in looped (broad|multi)cast's MAC handling

Jiasheng Jiang (4):
      qlcnic: potential dereference null pointer of rx_queue->page_ring
      fjes: Check for error irq
      drivers: net: smc911x: Check for error irq
      sfc: falcon: Check null pointer of rx_queue->page_ring

Jimmy Assarsson (1):
      can: kvaser_usb: get CAN clock frequency from device

José Expósito (2):
      IB/qib: Fix memory leak in qib_user_sdma_queue_pkts()
      Input: atmel_mxt_ts - fix double free in mxt_read_info_block

Lin Ma (3):
      ax25: NPD bug when detaching AX25 device
      hamradio: defer ax25 kfree after unregister_netdev
      hamradio: improve the incomplete fix to avoid NPD

Marian Postevca (1):
      usb: gadget: u_ether: fix race in setting MAC address in setup phase

Rémi Denis-Courmont (1):
      phonet/pep: refuse to enable an unbound pipe

Sean Christopherson (1):
      KVM: VMX: Fix stale docs for kvm-intel.emulate_invalid_guest_state

Willem de Bruijn (2):
      net: accept UFOv6 packages in virtio_net_hdr_to_skb
      net: skip virtio_net_hdr_set_proto if protocol already set

Xiaoke Wang (1):
      ALSA: jack: Check the return value of kstrdup()

