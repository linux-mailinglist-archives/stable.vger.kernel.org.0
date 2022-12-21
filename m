Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0B4C653463
	for <lists+stable@lfdr.de>; Wed, 21 Dec 2022 17:55:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230144AbiLUQzL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Dec 2022 11:55:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234352AbiLUQzJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Dec 2022 11:55:09 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B605A24970;
        Wed, 21 Dec 2022 08:55:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6F0D8B81BD8;
        Wed, 21 Dec 2022 16:55:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7072FC433EF;
        Wed, 21 Dec 2022 16:55:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1671641706;
        bh=zMIpGrndxPG0VEHLYWt8z7uKeKf9TUU5w/6EAiB+aZw=;
        h=From:To:Cc:Subject:Date:From;
        b=Eianol1tYawt1zTiKlhnsq5SMhytQ6uJ1aq2nBVfBBe81rYx7be3Q5utJKdlve0Ue
         sF6HqQrjAxbxsiOJ6+zGl64kSGsM6p/8LE9iVwsbu5oMeliEr+DyCdBYW3hbhsgfp2
         E7kT+p8G2c9QJ3DwzKVuyOzIv8XVV7W+mF5hoBY8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.10.161
Date:   Wed, 21 Dec 2022 17:55:01 +0100
Message-Id: <167164170215084@kroah.com>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.10.161 kernel.

All users of the 5.10 kernel series must upgrade.

The updated 5.10.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.10.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                  |    2 
 drivers/hid/hid-ids.h                     |    2 
 drivers/hid/hid-ite.c                     |   26 +++++++++-
 drivers/hid/hid-uclogic-core.c            |    1 
 drivers/net/ethernet/intel/igb/igb_main.c |    2 
 drivers/net/loopback.c                    |    2 
 drivers/usb/gadget/function/f_uvc.c       |    5 +
 drivers/usb/host/xhci-pci.c               |    4 +
 drivers/usb/serial/cp210x.c               |    2 
 drivers/usb/serial/f81232.c               |   12 ++--
 drivers/usb/serial/f81534.c               |   12 ++--
 drivers/usb/serial/option.c               |    3 +
 fs/udf/inode.c                            |   76 +++++++++++++-----------------
 fs/udf/truncate.c                         |   48 +++++-------------
 net/bluetooth/l2cap_core.c                |    3 -
 15 files changed, 106 insertions(+), 94 deletions(-)

Bruno Thomsen (1):
      USB: serial: cp210x: add Kamstrup RF sniffer PIDs

Duke Xin (1):
      USB: serial: option: add Quectel EM05-G modem

Greg Kroah-Hartman (1):
      Linux 5.10.161

Hans de Goede (3):
      HID: ite: Add support for Acer S1002 keyboard-dock
      HID: ite: Enable QUIRK_TOUCHPAD_ON_OFF_REPORT on Acer Aspire Switch 10E
      HID: ite: Enable QUIRK_TOUCHPAD_ON_OFF_REPORT on Acer Aspire Switch V 10

Jan Kara (4):
      udf: Discard preallocation before extending file with a hole
      udf: Fix preallocation discarding at indirect extent boundary
      udf: Do not bother looking for prealloc extents if i_lenExtents matches i_size
      udf: Fix extending file within last block

Johan Hovold (2):
      USB: serial: f81232: fix division by zero on line-speed change
      USB: serial: f81534: fix division by zero on line-speed change

José Expósito (1):
      HID: uclogic: Add HID_QUIRK_HIDINPUT_FORCE quirk

Rasmus Villemoes (1):
      net: loopback: use NET_NAME_PREDICTABLE for name_assign_type

Reka Norman (1):
      xhci: Apply XHCI_RESET_TO_DEFAULT quirk to ADL-N

Sungwoo Kim (1):
      Bluetooth: L2CAP: Fix u8 overflow

Szymon Heidrich (1):
      usb: gadget: uvc: Prevent buffer overflow in setup handler

Tony Nguyen (1):
      igb: Initialize mailbox message for VF reset

