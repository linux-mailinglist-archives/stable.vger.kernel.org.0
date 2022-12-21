Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 032A865346C
	for <lists+stable@lfdr.de>; Wed, 21 Dec 2022 17:55:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234686AbiLUQz0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Dec 2022 11:55:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234626AbiLUQzT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Dec 2022 11:55:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3619224F20;
        Wed, 21 Dec 2022 08:55:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E3059B81BDC;
        Wed, 21 Dec 2022 16:55:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A196C433F0;
        Wed, 21 Dec 2022 16:55:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1671641714;
        bh=bSb6aBwZneBTXQUdFqxyG50BJVSEDCMHqt75l03IzBE=;
        h=From:To:Cc:Subject:Date:From;
        b=phPkCZJQiSVu/9ASmhQmlpLLIdY1uMsBSc4vi0kQ0zvVhVWsH22ieSvBhemLhx51I
         9xGztJcdKmFuWJEl1cDbSCCOnF1gMvMKWvhUdMAfv5trGjnZ3f5NkZTvHeF+9CgFUJ
         nIeVSFHayq8U5P8vZc8VnpQ02OYpbyBZ30/P6EkA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.15.85
Date:   Wed, 21 Dec 2022 17:55:07 +0100
Message-Id: <167164170822885@kroah.com>
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

I'm announcing the release of the 5.15.85 kernel.

All users of the 5.15 kernel series must upgrade.

The updated 5.15.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.15.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                  |    2 
 drivers/hid/hid-uclogic-core.c            |    1 
 drivers/net/ethernet/intel/igb/igb_main.c |    2 
 drivers/net/loopback.c                    |    2 
 drivers/usb/dwc3/dwc3-pci.c               |    2 
 drivers/usb/gadget/function/f_uvc.c       |    5 +
 drivers/usb/host/xhci-pci.c               |    4 +
 drivers/usb/serial/cp210x.c               |    2 
 drivers/usb/serial/f81232.c               |   12 ++--
 drivers/usb/serial/f81534.c               |   12 ++--
 drivers/usb/serial/option.c               |    3 +
 fs/udf/inode.c                            |   76 +++++++++++++-----------------
 fs/udf/truncate.c                         |   48 +++++-------------
 net/bluetooth/l2cap_core.c                |    3 -
 tools/testing/selftests/net/toeplitz.sh   |    2 
 15 files changed, 82 insertions(+), 94 deletions(-)

Bruno Thomsen (1):
      USB: serial: cp210x: add Kamstrup RF sniffer PIDs

Duke Xin (1):
      USB: serial: option: add Quectel EM05-G modem

Greg Kroah-Hartman (1):
      Linux 5.15.85

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

Shruthi Sanil (1):
      usb: dwc3: pci: Update PCIe device ID for USB3 controller on CPU sub-system for Raptor Lake

Sungwoo Kim (1):
      Bluetooth: L2CAP: Fix u8 overflow

Szymon Heidrich (1):
      usb: gadget: uvc: Prevent buffer overflow in setup handler

Tiezhu Yang (1):
      selftests: net: Use "grep -E" instead of "egrep"

Tony Nguyen (1):
      igb: Initialize mailbox message for VF reset

