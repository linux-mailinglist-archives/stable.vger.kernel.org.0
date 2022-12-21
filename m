Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E37426534A6
	for <lists+stable@lfdr.de>; Wed, 21 Dec 2022 18:11:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230395AbiLURKN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Dec 2022 12:10:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234633AbiLURKD (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Dec 2022 12:10:03 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D782619C31;
        Wed, 21 Dec 2022 09:10:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 949E5B81BDE;
        Wed, 21 Dec 2022 17:10:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC013C433D2;
        Wed, 21 Dec 2022 17:09:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1671642600;
        bh=Po5ONB5J1yO54AAvewuVsz6JuhbcXL3PQz4ZYaoqXEg=;
        h=From:To:Cc:Subject:Date:From;
        b=sZAQsd+Mv3/CND4zWAsJ5R2CKxgoKG4aMXxgt/SUzzfJoSxBdrAX98QYwGmrd+OrF
         RDGXk8YYhFaMZ2IxTNq5dYaibh++4ZQOiYFUladS9QtFGWlOqAx5uweJoVlacc2l8P
         6dU3DSSTFe8aABtUCIP9Rf7ntxrLJ2tHESO3f5VE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 6.1.1
Date:   Wed, 21 Dec 2022 18:09:56 +0100
Message-Id: <1671642581139108@kroah.com>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 6.1.1 kernel.

All users of the 6.1 kernel series must upgrade.

The updated 6.1.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-6.1.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/security/keys/trusted-encrypted.rst |    3 
 Makefile                                          |    2 
 arch/mips/include/asm/mach-ralink/mt7621.h        |    4 
 arch/mips/ralink/mt7621.c                         |   97 ++++++++++----
 arch/x86/entry/vdso/vdso.lds.S                    |    2 
 drivers/irqchip/irq-ls-extirq.c                   |    2 
 drivers/net/ethernet/intel/igb/igb_main.c         |    2 
 drivers/pci/controller/pcie-mt7621.c              |    3 
 drivers/staging/r8188eu/core/rtw_led.c            |   25 ---
 drivers/usb/dwc3/dwc3-pci.c                       |    2 
 drivers/usb/gadget/function/f_uvc.c               |    5 
 drivers/usb/host/xhci-pci.c                       |    4 
 drivers/usb/serial/cp210x.c                       |    2 
 drivers/usb/serial/f81232.c                       |   12 +
 drivers/usb/serial/f81534.c                       |   12 +
 drivers/usb/serial/option.c                       |    3 
 drivers/usb/typec/ucsi/ucsi.c                     |   17 ++
 drivers/usb/typec/ucsi/ucsi.h                     |    1 
 fs/cifs/cifsglob.h                                |   68 ++++++++++
 fs/cifs/cifsproto.h                               |    4 
 fs/cifs/misc.c                                    |    4 
 fs/cifs/smb2ops.c                                 |  143 ++++++++++------------
 fs/udf/inode.c                                    |   76 +++++------
 fs/udf/truncate.c                                 |   48 ++-----
 security/keys/encrypted-keys/encrypted.c          |    6 
 sound/pci/hda/patch_realtek.c                     |    2 
 tools/lib/bpf/btf_dump.c                          |    2 
 27 files changed, 317 insertions(+), 234 deletions(-)

Andy Chi (1):
      ALSA: hda/realtek: fix mute/micmute LEDs for a HP ProBook

Bruno Thomsen (1):
      USB: serial: cp210x: add Kamstrup RF sniffer PIDs

David Michael (1):
      libbpf: Fix uninitialized warning in btf_dump_dump_type_data

Duke Xin (1):
      USB: serial: option: add Quectel EM05-G modem

Greg Kroah-Hartman (1):
      Linux 6.1.1

Heikki Krogerus (1):
      usb: typec: ucsi: Resume in separate work

Jan Kara (4):
      udf: Discard preallocation before extending file with a hole
      udf: Fix preallocation discarding at indirect extent boundary
      udf: Do not bother looking for prealloc extents if i_lenExtents matches i_size
      udf: Fix extending file within last block

Johan Hovold (2):
      USB: serial: f81232: fix division by zero on line-speed change
      USB: serial: f81534: fix division by zero on line-speed change

John Thomson (4):
      PCI: mt7621: Add sentinel to quirks table
      mips: ralink: mt7621: define MT7621_SYSC_BASE with __iomem
      mips: ralink: mt7621: soc queries and tests as functions
      mips: ralink: mt7621: do not use kzalloc too early

Martin Kaiser (1):
      staging: r8188eu: fix led register settings

Nathan Chancellor (1):
      x86/vdso: Conditionally export __vdso_sgx_enter_enclave()

Nikolaus Voss (1):
      KEYS: encrypted: fix key instantiation with user-provided data

Paulo Alcantara (1):
      cifs: fix oops during encryption

Reka Norman (1):
      xhci: Apply XHCI_RESET_TO_DEFAULT quirk to ADL-N

Sean Anderson (1):
      irqchip/ls-extirq: Fix endianness detection

Shruthi Sanil (1):
      usb: dwc3: pci: Update PCIe device ID for USB3 controller on CPU sub-system for Raptor Lake

Szymon Heidrich (1):
      usb: gadget: uvc: Prevent buffer overflow in setup handler

Tony Nguyen (1):
      igb: Initialize mailbox message for VF reset

