Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 347D5481219
	for <lists+stable@lfdr.de>; Wed, 29 Dec 2021 12:44:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239971AbhL2Loc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Dec 2021 06:44:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239968AbhL2Loc (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Dec 2021 06:44:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B90EDC061574;
        Wed, 29 Dec 2021 03:44:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 83378B818B2;
        Wed, 29 Dec 2021 11:44:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAA8DC36AE9;
        Wed, 29 Dec 2021 11:44:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640778269;
        bh=VnnVuT/mtz1X0SOAYW43kwpw4MvWhR+mqID/5hES0v8=;
        h=From:To:Cc:Subject:Date:From;
        b=fv3hgBbkFLZrZYgHStnEW/cEKC1KG0Wm24wsIqDcBbpSyf8yMozgtdr7P5Ba0mHkr
         nqe04A097IQbI1ZW3IvHnDPSZxlehtOV2pNY49/bzoWNDKDQsYaVx1L8vZkcj11TUj
         c2BfHZ0e/IvTwnSjrudF9dBUP54os/09561BFQRk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.9.295
Date:   Wed, 29 Dec 2021 12:44:25 +0100
Message-Id: <16407782652213@kroah.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.9.295 kernel.

All users of the 4.9 kernel series must upgrade.

The updated 4.9.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.9.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/networking/bonding.txt                     |   11 ++--
 Makefile                                                 |    2 
 arch/arm/kernel/entry-armv.S                             |    8 +-
 arch/x86/include/asm/pgtable.h                           |    4 -
 drivers/hid/hid-holtek-mouse.c                           |   15 +++++
 drivers/hwmon/lm90.c                                     |    8 +-
 drivers/infiniband/hw/qib/qib_user_sdma.c                |    2 
 drivers/net/bonding/bond_options.c                       |    2 
 drivers/net/can/usb/kvaser_usb.c                         |   41 +++++++++++++--
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_sriov.h        |    2 
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_sriov_common.c |   12 +++-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_sriov_pf.c     |    4 +
 drivers/net/ethernet/smsc/smc911x.c                      |    5 +
 drivers/net/fjes/fjes_main.c                             |    5 +
 drivers/net/hamradio/mkiss.c                             |    5 +
 drivers/net/usb/lan78xx.c                                |    6 ++
 net/ax25/af_ax25.c                                       |    4 +
 net/phonet/pep.c                                         |    2 
 sound/core/jack.c                                        |    4 +
 sound/drivers/opl3/opl3_midi.c                           |    2 
 20 files changed, 111 insertions(+), 33 deletions(-)

Andrew Cooper (1):
      x86/pkey: Fix undefined behaviour with PKRU_WD_BIT

Ard Biesheuvel (1):
      ARM: 9169/1: entry: fix Thumb2 bug in iWMMXt exception handling

Benjamin Tissoires (1):
      HID: holtek: fix mouse probing

Colin Ian King (1):
      ALSA: drivers: opl3: Fix incorrect use of vp->state

Fernando Fernandez Mancera (1):
      bonding: fix ad_actor_system option setting to default

Greg Jesionowski (1):
      net: usb: lan78xx: add Allied Telesis AT29M2-AF

Greg Kroah-Hartman (1):
      Linux 4.9.295

Guenter Roeck (2):
      hwmon: (lm90) Fix usage of CONFIG2 register in detect function
      hwmon: (lm90) Do not report 'busy' status bit as alarm

Jiasheng Jiang (3):
      qlcnic: potential dereference null pointer of rx_queue->page_ring
      fjes: Check for error irq
      drivers: net: smc911x: Check for error irq

Jimmy Assarsson (1):
      can: kvaser_usb: get CAN clock frequency from device

José Expósito (1):
      IB/qib: Fix memory leak in qib_user_sdma_queue_pkts()

Lin Ma (3):
      ax25: NPD bug when detaching AX25 device
      hamradio: defer ax25 kfree after unregister_netdev
      hamradio: improve the incomplete fix to avoid NPD

Rémi Denis-Courmont (1):
      phonet/pep: refuse to enable an unbound pipe

Xiaoke Wang (1):
      ALSA: jack: Check the return value of kstrdup()

