Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56D334811D9
	for <lists+stable@lfdr.de>; Wed, 29 Dec 2021 12:08:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235436AbhL2LIu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Dec 2021 06:08:50 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:58744 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235159AbhL2LIu (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Dec 2021 06:08:50 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 30E356147C;
        Wed, 29 Dec 2021 11:08:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDF3BC36AE9;
        Wed, 29 Dec 2021 11:08:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640776129;
        bh=SNECSc/0PJTJ1SrEjp/7neE80HMdIt7pUEARcUR9KAo=;
        h=From:To:Cc:Subject:Date:From;
        b=WhjgqIuDYsauS8+CtZ18ZFXds01bubRAc0Up4BXE5FFmG36BJvLpgJvLBSxfXJ0KO
         h6It1yIuou5F5h/UvyeadL9bLgbEY5a1pZ941J8MY0dC89+zDQ59g3Qp0Cwbt3MclN
         a8klVLGnRaLBYlLURhSqCH66I7O/qUWbna8xWoFA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.4.297
Date:   Wed, 29 Dec 2021 12:08:45 +0100
Message-Id: <164077612524245@kroah.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.4.297 kernel.

All users of the 4.4 kernel series must upgrade.

The updated 4.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/networking/bonding.txt                     |   11 ++--
 Makefile                                                 |    2 
 arch/arm/kernel/entry-armv.S                             |    8 +-
 drivers/block/xen-blkfront.c                             |    4 -
 drivers/hid/hid-holtek-mouse.c                           |   15 +++++
 drivers/hwmon/lm90.c                                     |    5 -
 drivers/infiniband/hw/qib/qib_user_sdma.c                |    2 
 drivers/net/bonding/bond_options.c                       |    2 
 drivers/net/can/usb/kvaser_usb.c                         |   41 +++++++++++++--
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_sriov.h        |    2 
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_sriov_common.c |   12 +++-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_sriov_pf.c     |    4 +
 drivers/net/ethernet/smsc/smc911x.c                      |    5 +
 drivers/net/hamradio/mkiss.c                             |    5 +
 drivers/net/usb/lan78xx.c                                |    6 ++
 net/ax25/af_ax25.c                                       |    4 +
 net/phonet/pep.c                                         |    2 
 sound/core/jack.c                                        |    4 +
 sound/drivers/opl3/opl3_midi.c                           |    2 
 19 files changed, 102 insertions(+), 34 deletions(-)

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
      Linux 4.4.297

Guenter Roeck (1):
      hwmon: (lm90) Fix usage of CONFIG2 register in detect function

Jiasheng Jiang (2):
      qlcnic: potential dereference null pointer of rx_queue->page_ring
      drivers: net: smc911x: Check for error irq

Jimmy Assarsson (1):
      can: kvaser_usb: get CAN clock frequency from device

José Expósito (1):
      IB/qib: Fix memory leak in qib_user_sdma_queue_pkts()

Juergen Gross (1):
      xen/blkfront: fix bug in backported patch

Lin Ma (3):
      ax25: NPD bug when detaching AX25 device
      hamradio: defer ax25 kfree after unregister_netdev
      hamradio: improve the incomplete fix to avoid NPD

Rémi Denis-Courmont (1):
      phonet/pep: refuse to enable an unbound pipe

Xiaoke Wang (1):
      ALSA: jack: Check the return value of kstrdup()

