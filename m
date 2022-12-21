Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF9AD65349F
	for <lists+stable@lfdr.de>; Wed, 21 Dec 2022 18:10:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234073AbiLURJW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Dec 2022 12:09:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234589AbiLURJR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Dec 2022 12:09:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A45721AA39;
        Wed, 21 Dec 2022 09:09:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4133161874;
        Wed, 21 Dec 2022 17:09:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55C55C433EF;
        Wed, 21 Dec 2022 17:09:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1671642555;
        bh=wSTYubRBxF2E/svtoZSQEY8V3Xpq7fKv9QSV/aPUK9E=;
        h=From:To:Cc:Subject:Date:From;
        b=GTB3cCN8oyMVlhx3Zp1vQborXQ9Rh6s+kbOpBshicpAtRZGJQX9lUQzWmL8qZcmWi
         +avt2mXfK9XtchraCcf/4Xbu/nUmsWOiuv1VEsyj8Ze6Sb4NL8gqokaXzSsTZf9SYP
         rYuNZyLJfWES36q16fjWV0nviRnmP5mlg8GbDrXg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 6.0.15
Date:   Wed, 21 Dec 2022 18:09:11 +0100
Message-Id: <1671642552184152@kroah.com>
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

I'm announcing the release of the 6.0.15 kernel.

All users of the 6.0 kernel series must upgrade.

The updated 6.0.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-6.0.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/security/keys/trusted-encrypted.rst                  |    3 
 Makefile                                                           |    2 
 drivers/net/ethernet/intel/igb/igb_main.c                          |    2 
 drivers/net/loopback.c                                             |    2 
 drivers/pci/controller/pcie-mt7621.c                               |    3 
 drivers/usb/dwc3/dwc3-pci.c                                        |    2 
 drivers/usb/gadget/function/f_uvc.c                                |    5 
 drivers/usb/host/xhci-pci.c                                        |    4 
 drivers/usb/serial/cp210x.c                                        |    2 
 drivers/usb/serial/f81232.c                                        |   12 -
 drivers/usb/serial/f81534.c                                        |   12 -
 drivers/usb/serial/option.c                                        |    3 
 drivers/usb/typec/ucsi/ucsi.c                                      |   17 +
 drivers/usb/typec/ucsi/ucsi.h                                      |    1 
 fs/udf/inode.c                                                     |   76 +++----
 fs/udf/truncate.c                                                  |   48 +---
 include/linux/module.h                                             |    9 
 kernel/module/kallsyms.c                                           |    2 
 kernel/trace/bpf_trace.c                                           |   98 +++++++++-
 kernel/trace/ftrace.c                                              |   16 +
 net/bluetooth/l2cap_core.c                                         |    3 
 security/keys/encrypted-keys/encrypted.c                           |    6 
 sound/pci/hda/patch_realtek.c                                      |    2 
 tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.c              |   24 ++
 tools/testing/selftests/bpf/prog_tests/kprobe_multi_testmod_test.c |   89 +++++++++
 tools/testing/selftests/bpf/prog_tests/module_attach.c             |    7 
 tools/testing/selftests/bpf/progs/kprobe_multi.c                   |   50 +++++
 tools/testing/selftests/bpf/progs/test_module_attach.c             |    6 
 tools/testing/selftests/bpf/trace_helpers.c                        |   20 +-
 tools/testing/selftests/bpf/trace_helpers.h                        |    2 
 tools/testing/selftests/net/toeplitz.sh                            |    2 
 31 files changed, 410 insertions(+), 120 deletions(-)

Andy Chi (1):
      ALSA: hda/realtek: fix mute/micmute LEDs for a HP ProBook

Bruno Thomsen (1):
      USB: serial: cp210x: add Kamstrup RF sniffer PIDs

Duke Xin (1):
      USB: serial: option: add Quectel EM05-G modem

Greg Kroah-Hartman (1):
      Linux 6.0.15

Heikki Krogerus (1):
      usb: typec: ucsi: Resume in separate work

Jan Kara (4):
      udf: Discard preallocation before extending file with a hole
      udf: Fix preallocation discarding at indirect extent boundary
      udf: Do not bother looking for prealloc extents if i_lenExtents matches i_size
      udf: Fix extending file within last block

Jiri Olsa (8):
      kallsyms: Make module_kallsyms_on_each_symbol generally available
      ftrace: Add support to resolve module symbols in ftrace_lookup_symbols
      bpf: Rename __bpf_kprobe_multi_cookie_cmp to bpf_kprobe_multi_addrs_cmp
      bpf: Take module reference on kprobe_multi link
      selftests/bpf: Add load_kallsyms_refresh function
      selftests/bpf: Add bpf_testmod_fentry_* functions
      selftests/bpf: Add kprobe_multi check to module attach test
      selftests/bpf: Add kprobe_multi kmod attach api tests

Johan Hovold (2):
      USB: serial: f81232: fix division by zero on line-speed change
      USB: serial: f81534: fix division by zero on line-speed change

John Thomson (1):
      PCI: mt7621: Add sentinel to quirks table

Nikolaus Voss (1):
      KEYS: encrypted: fix key instantiation with user-provided data

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

