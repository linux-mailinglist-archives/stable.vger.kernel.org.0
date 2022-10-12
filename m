Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5180F5FC2FA
	for <lists+stable@lfdr.de>; Wed, 12 Oct 2022 11:21:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229827AbiJLJVE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Oct 2022 05:21:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230042AbiJLJUn (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Oct 2022 05:20:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24E761FCC7;
        Wed, 12 Oct 2022 02:20:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 54C0361458;
        Wed, 12 Oct 2022 09:20:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63C43C433D6;
        Wed, 12 Oct 2022 09:20:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665566436;
        bh=XWw8XCHuQXpkgycSftHqKf9QCv4fVQvY4Jt//oLXv3A=;
        h=From:To:Cc:Subject:Date:From;
        b=McSHSqtoXucT7OTU6SY2UnblscP3n8qrgRebct2SKJnvY0ZRRhFPB6XpIKbpZaMOe
         I+rJ5dj0ALTsPYsNSW/H2WMX+7888VSWK6P8e1V95ydFFAv2PBy2FN+W7pS3sLkEHp
         z2SDMIBQsUAIZuuzEz/uJUcugLsNrYWWjBe1bOiM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 6.0.1
Date:   Wed, 12 Oct 2022 11:21:19 +0200
Message-Id: <166556647915255@kroah.com>
X-Mailer: git-send-email 2.38.0
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

I'm announcing the release of the 6.0.1 kernel.

All users of the 6.0 kernel series must upgrade.

The updated 6.0.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-6.0.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/process/code-of-conduct-interpretation.rst |    2 
 Makefile                                                 |    6 +-
 arch/riscv/kernel/cpu.c                                  |    2 
 arch/sparc/include/asm/smp_32.h                          |   15 ++---
 arch/sparc/kernel/leon_smp.c                             |   12 ++--
 arch/sparc/kernel/sun4d_smp.c                            |   12 ++--
 arch/sparc/kernel/sun4m_smp.c                            |   10 ++-
 arch/sparc/mm/srmmu.c                                    |   29 +++++------
 drivers/gpio/gpiolib-acpi.c                              |   38 +++++++++++++--
 drivers/hwmon/aquacomputer_d5next.c                      |    2 
 drivers/net/ethernet/mediatek/mtk_ppe.c                  |    2 
 drivers/usb/mon/mon_bin.c                                |    5 +
 drivers/usb/serial/ftdi_sio.c                            |    3 -
 fs/coredump.c                                            |    3 -
 fs/inode.c                                               |    7 +-
 include/net/xsk_buff_pool.h                              |    2 
 kernel/bpf/helpers.c                                     |   28 +++++------
 kernel/bpf/syscall.c                                     |    2 
 net/bluetooth/hci_core.c                                 |   15 +++++
 net/bluetooth/hci_event.c                                |    6 +-
 net/xdp/xsk.c                                            |    4 -
 net/xdp/xsk_buff_pool.c                                  |    5 +
 scripts/Makefile.extrawarn                               |    1 
 security/Kconfig.hardening                               |   14 +++--
 24 files changed, 140 insertions(+), 85 deletions(-)

Al Viro (1):
      fix coredump breakage

Aleksa Savic (1):
      hwmon: (aquacomputer_d5next) Fix Quadro fan speed offsets

Bart Van Assche (1):
      sparc: Unbreak the build

Daniel Golle (1):
      net: ethernet: mtk_eth_soc: fix state in __mtk_foe_entry_clear

Dongliang Mu (1):
      fs: fix UAF/GPF bug in nilfs_mdt_destroy

Greg Kroah-Hartman (1):
      Linux 6.0.1

Jalal Mostafa (1):
      xsk: Inherit need_wakeup flag for shared sockets

Johan Hovold (1):
      USB: serial: ftdi_sio: fix 300 bps rate for SIO

Jules Irenge (1):
      bpf: Fix resetting logic for unreferenced kptrs

Kees Cook (1):
      hardening: Remove Clang's enable flag for -ftrivial-auto-var-init=zero

Kumar Kartikeya Dwivedi (1):
      bpf: Gate dynptr API behind CAP_BPF

Mario Limonciello (2):
      gpiolib: acpi: Add support to ignore programming an interrupt
      gpiolib: acpi: Add a quirk for Asus UM325UAZ

Palmer Dabbelt (1):
      RISC-V: Print SSTC in canonical order

Sami Tolvanen (1):
      Makefile.extrawarn: Move -Wcast-function-type-strict to W=1

Shuah Khan (1):
      docs: update mediator information in CoC docs

Tadeusz Struk (1):
      usb: mon: make mmapped memory read only

Tetsuo Handa (1):
      Bluetooth: use hdev->workqueue when queuing hdev->{cmd,ncmd}_timer works

