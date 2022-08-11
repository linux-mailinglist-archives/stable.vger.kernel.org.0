Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C1D858FB7A
	for <lists+stable@lfdr.de>; Thu, 11 Aug 2022 13:38:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234922AbiHKLi2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Aug 2022 07:38:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234929AbiHKLi1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Aug 2022 07:38:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12D4D6069A;
        Thu, 11 Aug 2022 04:38:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A0B32612CD;
        Thu, 11 Aug 2022 11:38:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3B47C433D7;
        Thu, 11 Aug 2022 11:38:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660217905;
        bh=yARjn/HjbZsThUt1LQoeyfu/Y3PzCm7SMoHLC8IjpHI=;
        h=From:To:Cc:Subject:Date:From;
        b=TvwtII5T9gFiTh1/pQVvAYwZvmKKMHyyQMjCrGZlIMZ1XJed+0FKbsCuwsMrqKAEc
         h83FJeXXfoIvMOCeq/s2FYoMptyWk/BpxI8FSXclEgZmADXIZI+YU8ZeIrBMUehOHQ
         3cq3EIqNW+8bxYgmmC5FkhNAort3gRhHUUB4dA1c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.19.1
Date:   Thu, 11 Aug 2022 13:38:21 +0200
Message-Id: <166021787318847@kroah.com>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.19.1 kernel.

All users of the 5.19 kernel series must upgrade.

The updated 5.19.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.19.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/admin-guide/hw-vuln/spectre.rst                 |    8 
 Documentation/devicetree/bindings/net/broadcom-bluetooth.yaml |    1 
 Makefile                                                      |    2 
 arch/arm64/crypto/poly1305-glue.c                             |    2 
 arch/arm64/include/asm/kernel-pgtable.h                       |    4 
 arch/arm64/kernel/head.S                                      |    2 
 arch/x86/include/asm/cpufeatures.h                            |    2 
 arch/x86/include/asm/msr-index.h                              |    4 
 arch/x86/include/asm/nospec-branch.h                          |   21 ++
 arch/x86/kernel/cpu/bugs.c                                    |   86 +++++++---
 arch/x86/kernel/cpu/common.c                                  |   12 +
 arch/x86/kvm/vmx/vmenter.S                                    |    8 
 block/blk-ioc.c                                               |    2 
 block/ioprio.c                                                |    4 
 drivers/acpi/apei/bert.c                                      |   31 ++-
 drivers/acpi/video_detect.c                                   |   55 ++++--
 drivers/ata/sata_mv.c                                         |    2 
 drivers/bluetooth/btbcm.c                                     |    2 
 drivers/bluetooth/btusb.c                                     |   15 +
 drivers/bluetooth/hci_bcm.c                                   |    2 
 drivers/bluetooth/hci_qca.c                                   |    2 
 drivers/macintosh/adb.c                                       |    2 
 include/linux/ioprio.h                                        |    2 
 tools/arch/x86/include/asm/cpufeatures.h                      |    1 
 tools/arch/x86/include/asm/msr-index.h                        |    4 
 tools/vm/slabinfo.c                                           |   26 ++-
 26 files changed, 231 insertions(+), 71 deletions(-)

Aaron Ma (1):
      Bluetooth: btusb: Add support of IMC Networks PID 0x3568

Ahmad Fatoum (2):
      Bluetooth: hci_bcm: Add BCM4349B1 variant
      dt-bindings: bluetooth: broadcom: Add BCM4349B1 DT binding

Andrew Lunn (1):
      ata: sata_mv: Fixes expected number of resources now IRQs are gone

Daniel Sneddon (1):
      x86/speculation: Add RSB VM Exit protections

GUO Zihua (1):
      crypto: arm64/poly1305 - fix a read out-of-bound

Greg Kroah-Hartman (1):
      Linux 5.19.1

Hakan Jansson (1):
      Bluetooth: hci_bcm: Add DT compatible for CYW55572

Hilda Wu (5):
      Bluetooth: btusb: Add Realtek RTL8852C support ID 0x04CA:0x4007
      Bluetooth: btusb: Add Realtek RTL8852C support ID 0x04C5:0x1675
      Bluetooth: btusb: Add Realtek RTL8852C support ID 0x0CB8:0xC558
      Bluetooth: btusb: Add Realtek RTL8852C support ID 0x13D3:0x3587
      Bluetooth: btusb: Add Realtek RTL8852C support ID 0x13D3:0x3586

Jan Kara (1):
      block: fix default IO priority handling again

Ning Qiang (1):
      macintosh/adb: fix oob read in do_adb_query() function

Pawan Gupta (1):
      x86/speculation: Add LFENCE to RSB fill sequence

Peter Collingbourne (1):
      arm64: set UXN on swapper page tables

Sai Teja Aluvala (1):
      Bluetooth: hci_qca: Return wakeup for qca_wakeup

Stéphane Graber (1):
      tools/vm/slabinfo: Handle files in debugfs

Tony Luck (1):
      ACPI: APEI: Better fix to avoid spamming the console with old error logs

Werner Sembach (2):
      ACPI: video: Force backlight native for some TongFang devices
      ACPI: video: Shortening quirk list by identifying Clevo by board_name only

