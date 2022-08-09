Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5205458DE2C
	for <lists+stable@lfdr.de>; Tue,  9 Aug 2022 20:12:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345356AbiHISMj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Aug 2022 14:12:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345148AbiHISKE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Aug 2022 14:10:04 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 003DB2A27D;
        Tue,  9 Aug 2022 11:04:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id A643CCE18C6;
        Tue,  9 Aug 2022 18:04:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6C5BC433B5;
        Tue,  9 Aug 2022 18:03:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660068239;
        bh=cYQNhOoTlCgWZwWP7xAPmvtSkECzdZg+hySvuD5gb4U=;
        h=From:To:Cc:Subject:Date:From;
        b=aVFc+7CDs5cDNMvhEKR2+d6kMKmim4Clm52b35qnE5RbR5jXirtRE+EsRvjehIZjB
         QQegZKsOmy5pWtGpCF2/aATELDl/6p9pm7DeCgJbtODljYvdAta66CNFE9UKBWZzGE
         btdUnE6YlgNkCU4LyKR5099+SFV/ghNLDbPnCtxs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Subject: [PATCH 5.10 00/23] 5.10.136-rc1 review
Date:   Tue,  9 Aug 2022 20:00:18 +0200
Message-Id: <20220809175512.853274191@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.136-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.136-rc1
X-KernelTest-Deadline: 2022-08-11T17:55+00:00
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

This is the start of the stable review cycle for the 5.10.136 release.
There are 23 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 11 Aug 2022 17:55:02 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.136-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.10.136-rc1

Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
    x86/speculation: Add LFENCE to RSB fill sequence

Daniel Sneddon <daniel.sneddon@linux.intel.com>
    x86/speculation: Add RSB VM Exit protections

Ning Qiang <sohu0106@126.com>
    macintosh/adb: fix oob read in do_adb_query() function

Hilda Wu <hildawu@realtek.com>
    Bluetooth: btusb: Add Realtek RTL8852C support ID 0x13D3:0x3586

Hilda Wu <hildawu@realtek.com>
    Bluetooth: btusb: Add Realtek RTL8852C support ID 0x13D3:0x3587

Hilda Wu <hildawu@realtek.com>
    Bluetooth: btusb: Add Realtek RTL8852C support ID 0x0CB8:0xC558

Hilda Wu <hildawu@realtek.com>
    Bluetooth: btusb: Add Realtek RTL8852C support ID 0x04C5:0x1675

Hilda Wu <hildawu@realtek.com>
    Bluetooth: btusb: Add Realtek RTL8852C support ID 0x04CA:0x4007

Aaron Ma <aaron.ma@canonical.com>
    Bluetooth: btusb: Add support of IMC Networks PID 0x3568

Hakan Jansson <hakan.jansson@infineon.com>
    Bluetooth: hci_bcm: Add DT compatible for CYW55572

Ahmad Fatoum <a.fatoum@pengutronix.de>
    Bluetooth: hci_bcm: Add BCM4349B1 variant

Raghavendra Rao Ananta <rananta@google.com>
    selftests: KVM: Handle compiler optimizations in ucall

Dmitry Klochkov <kdmitry556@gmail.com>
    tools/kvm_stat: fix display of error when multiple processes are found

GUO Zihua <guozihua@huawei.com>
    crypto: arm64/poly1305 - fix a read out-of-bound

Tony Luck <tony.luck@intel.com>
    ACPI: APEI: Better fix to avoid spamming the console with old error logs

Werner Sembach <wse@tuxedocomputers.com>
    ACPI: video: Shortening quirk list by identifying Clevo by board_name only

Werner Sembach <wse@tuxedocomputers.com>
    ACPI: video: Force backlight native for some TongFang devices

George Kennedy <george.kennedy@oracle.com>
    tun: avoid double free in tun_free_netdev

Jakub Sitnicki <jakub@cloudflare.com>
    selftests/bpf: Check dst_port only on the client socket

Jakub Sitnicki <jakub@cloudflare.com>
    selftests/bpf: Extend verifier and bpf_sock tests for dst_port loads

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    ath9k_htc: fix NULL pointer dereference at ath9k_htc_tx_get_packet()

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    ath9k_htc: fix NULL pointer dereference at ath9k_htc_rxep()

Ben Hutchings <ben@decadent.org.uk>
    x86/speculation: Make all RETbleed mitigations 64-bit only


-------------

Diffstat:

 Documentation/admin-guide/hw-vuln/spectre.rst      |   8 ++
 Makefile                                           |   4 +-
 arch/arm64/crypto/poly1305-glue.c                  |   2 +-
 arch/x86/Kconfig                                   |   8 +-
 arch/x86/include/asm/cpufeatures.h                 |   2 +
 arch/x86/include/asm/msr-index.h                   |   4 +
 arch/x86/include/asm/nospec-branch.h               |  21 +++-
 arch/x86/kernel/cpu/bugs.c                         |  86 +++++++++++-----
 arch/x86/kernel/cpu/common.c                       |  12 ++-
 arch/x86/kvm/vmx/vmenter.S                         |   8 +-
 drivers/acpi/apei/bert.c                           |  31 ++++--
 drivers/acpi/video_detect.c                        |  55 ++++++----
 drivers/bluetooth/btbcm.c                          |   2 +
 drivers/bluetooth/btusb.c                          |  15 +++
 drivers/bluetooth/hci_bcm.c                        |   2 +
 drivers/macintosh/adb.c                            |   2 +-
 drivers/net/tun.c                                  | 114 +++++++++++----------
 drivers/net/wireless/ath/ath9k/htc.h               |   2 +
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c      |  13 +++
 drivers/net/wireless/ath/ath9k/wmi.c               |   4 +
 tools/arch/x86/include/asm/cpufeatures.h           |   1 +
 tools/arch/x86/include/asm/msr-index.h             |   4 +
 tools/include/uapi/linux/bpf.h                     |   3 +-
 tools/kvm/kvm_stat/kvm_stat                        |   3 +-
 .../testing/selftests/bpf/prog_tests/sock_fields.c |  60 +++++++----
 .../testing/selftests/bpf/progs/test_sock_fields.c |  45 ++++++++
 tools/testing/selftests/bpf/verifier/sock.c        |  81 ++++++++++++++-
 tools/testing/selftests/kvm/lib/aarch64/ucall.c    |   9 +-
 28 files changed, 451 insertions(+), 150 deletions(-)


