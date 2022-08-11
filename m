Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25C1458FB56
	for <lists+stable@lfdr.de>; Thu, 11 Aug 2022 13:31:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235012AbiHKLbq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Aug 2022 07:31:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234970AbiHKLbg (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Aug 2022 07:31:36 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1C4889923;
        Thu, 11 Aug 2022 04:31:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 9CB02CE215A;
        Thu, 11 Aug 2022 11:31:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BDFDC433D6;
        Thu, 11 Aug 2022 11:31:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660217461;
        bh=gyUu6K+NJg3FDtiEhmJ/2K0yT/5TXGEfqK+6QGcFAAE=;
        h=From:To:Cc:Subject:Date:From;
        b=Hugj2BO3k5UBRdH5GV76sE3cvO5ZwUiu2AahSTRbC+ihe+0c0u33kHgEVZs8D88m/
         FObVRiDtWs1TXl+HoCk/8t+Ap30wVR1MO1SoTttHZiplnHPw2kXvHHfSLyZ3GxaGza
         yTzvvQegt77/6tvhCHLcTG5r/nL9oJ7HYp1A5c9s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.10.136
Date:   Thu, 11 Aug 2022 13:30:57 +0200
Message-Id: <16602174580192@kroah.com>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
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

I'm announcing the release of the 5.10.136 kernel.

All users of the 5.10 kernel series must upgrade.

The updated 5.10.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.10.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/admin-guide/hw-vuln/spectre.rst        |    8 +
 Makefile                                             |    2 
 arch/arm64/crypto/poly1305-glue.c                    |    2 
 arch/x86/Kconfig                                     |    8 -
 arch/x86/include/asm/cpufeatures.h                   |    2 
 arch/x86/include/asm/msr-index.h                     |    4 
 arch/x86/include/asm/nospec-branch.h                 |   21 +++
 arch/x86/kernel/cpu/bugs.c                           |   86 ++++++++++----
 arch/x86/kernel/cpu/common.c                         |   12 +-
 arch/x86/kvm/vmx/vmenter.S                           |    8 -
 drivers/acpi/apei/bert.c                             |   31 +++--
 drivers/acpi/video_detect.c                          |   55 +++++----
 drivers/bluetooth/btbcm.c                            |    2 
 drivers/bluetooth/btusb.c                            |   15 ++
 drivers/bluetooth/hci_bcm.c                          |    2 
 drivers/macintosh/adb.c                              |    2 
 drivers/net/tun.c                                    |  114 +++++++++----------
 drivers/net/wireless/ath/ath9k/htc.h                 |    2 
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c        |   13 ++
 drivers/net/wireless/ath/ath9k/wmi.c                 |    4 
 tools/arch/x86/include/asm/cpufeatures.h             |    1 
 tools/arch/x86/include/asm/msr-index.h               |    4 
 tools/include/uapi/linux/bpf.h                       |    3 
 tools/kvm/kvm_stat/kvm_stat                          |    3 
 tools/testing/selftests/bpf/prog_tests/sock_fields.c |   60 ++++++----
 tools/testing/selftests/bpf/progs/test_sock_fields.c |   45 +++++++
 tools/testing/selftests/bpf/verifier/sock.c          |   81 +++++++++++++
 tools/testing/selftests/kvm/lib/aarch64/ucall.c      |    9 -
 28 files changed, 450 insertions(+), 149 deletions(-)

Aaron Ma (1):
      Bluetooth: btusb: Add support of IMC Networks PID 0x3568

Ahmad Fatoum (1):
      Bluetooth: hci_bcm: Add BCM4349B1 variant

Ben Hutchings (1):
      x86/speculation: Make all RETbleed mitigations 64-bit only

Daniel Sneddon (1):
      x86/speculation: Add RSB VM Exit protections

Dmitry Klochkov (1):
      tools/kvm_stat: fix display of error when multiple processes are found

GUO Zihua (1):
      crypto: arm64/poly1305 - fix a read out-of-bound

George Kennedy (1):
      tun: avoid double free in tun_free_netdev

Greg Kroah-Hartman (1):
      Linux 5.10.136

Hakan Jansson (1):
      Bluetooth: hci_bcm: Add DT compatible for CYW55572

Hilda Wu (5):
      Bluetooth: btusb: Add Realtek RTL8852C support ID 0x04CA:0x4007
      Bluetooth: btusb: Add Realtek RTL8852C support ID 0x04C5:0x1675
      Bluetooth: btusb: Add Realtek RTL8852C support ID 0x0CB8:0xC558
      Bluetooth: btusb: Add Realtek RTL8852C support ID 0x13D3:0x3587
      Bluetooth: btusb: Add Realtek RTL8852C support ID 0x13D3:0x3586

Jakub Sitnicki (2):
      selftests/bpf: Extend verifier and bpf_sock tests for dst_port loads
      selftests/bpf: Check dst_port only on the client socket

Ning Qiang (1):
      macintosh/adb: fix oob read in do_adb_query() function

Pawan Gupta (1):
      x86/speculation: Add LFENCE to RSB fill sequence

Raghavendra Rao Ananta (1):
      selftests: KVM: Handle compiler optimizations in ucall

Tetsuo Handa (2):
      ath9k_htc: fix NULL pointer dereference at ath9k_htc_rxep()
      ath9k_htc: fix NULL pointer dereference at ath9k_htc_tx_get_packet()

Tony Luck (1):
      ACPI: APEI: Better fix to avoid spamming the console with old error logs

Werner Sembach (2):
      ACPI: video: Force backlight native for some TongFang devices
      ACPI: video: Shortening quirk list by identifying Clevo by board_name only

