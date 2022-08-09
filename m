Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2E1858DEF1
	for <lists+stable@lfdr.de>; Tue,  9 Aug 2022 20:28:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344034AbiHIS2j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Aug 2022 14:28:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344624AbiHISYh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Aug 2022 14:24:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3D6928E2A;
        Tue,  9 Aug 2022 11:08:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7B8CE61001;
        Tue,  9 Aug 2022 18:08:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDB51C43470;
        Tue,  9 Aug 2022 18:08:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660068501;
        bh=06Jpmucij6Rw+WpYa3rdEXJAzQK2/Xjj47zeNjwaM6M=;
        h=From:To:Cc:Subject:Date:From;
        b=tATnr9HhSxn5T2kBf7Aks+dlR1JNlYdwcEDealpFBFfIXVUzCfHYa7kRLOpDy7EBS
         ZnxSqM2/sQ7wJ8OwRUASKZTM8Vgc0zJ2PZV79hRp8l0cd2nBqSEkcMWVT+DXFnwmVP
         ldPCQIPkGA6Lt0apWq0Y6RWy/QDXlr+gVdOnoXvA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Subject: [PATCH 5.19 00/21] 5.19.1-rc1 review
Date:   Tue,  9 Aug 2022 20:00:52 +0200
Message-Id: <20220809175513.345597655@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.19.1-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.19.1-rc1
X-KernelTest-Deadline: 2022-08-11T17:55+00:00
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

This is the start of the stable review cycle for the 5.19.1 release.
There are 21 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 11 Aug 2022 17:55:02 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.19.1-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.19.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.19.1-rc1

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

Ahmad Fatoum <a.fatoum@pengutronix.de>
    dt-bindings: bluetooth: broadcom: Add BCM4349B1 DT binding

Hakan Jansson <hakan.jansson@infineon.com>
    Bluetooth: hci_bcm: Add DT compatible for CYW55572

Ahmad Fatoum <a.fatoum@pengutronix.de>
    Bluetooth: hci_bcm: Add BCM4349B1 variant

Sai Teja Aluvala <quic_saluvala@quicinc.com>
    Bluetooth: hci_qca: Return wakeup for qca_wakeup

Peter Collingbourne <pcc@google.com>
    arm64: set UXN on swapper page tables

Andrew Lunn <andrew@lunn.ch>
    ata: sata_mv: Fixes expected number of resources now IRQs are gone

GUO Zihua <guozihua@huawei.com>
    crypto: arm64/poly1305 - fix a read out-of-bound

Tony Luck <tony.luck@intel.com>
    ACPI: APEI: Better fix to avoid spamming the console with old error logs

Werner Sembach <wse@tuxedocomputers.com>
    ACPI: video: Shortening quirk list by identifying Clevo by board_name only

Werner Sembach <wse@tuxedocomputers.com>
    ACPI: video: Force backlight native for some TongFang devices

Stéphane Graber <stgraber@ubuntu.com>
    tools/vm/slabinfo: Handle files in debugfs

Jan Kara <jack@suse.cz>
    block: fix default IO priority handling again


-------------

Diffstat:

 Documentation/admin-guide/hw-vuln/spectre.rst      |  8 ++
 .../bindings/net/broadcom-bluetooth.yaml           |  1 +
 Makefile                                           |  4 +-
 arch/arm64/crypto/poly1305-glue.c                  |  2 +-
 arch/arm64/include/asm/kernel-pgtable.h            |  4 +-
 arch/arm64/kernel/head.S                           |  2 +-
 arch/x86/include/asm/cpufeatures.h                 |  2 +
 arch/x86/include/asm/msr-index.h                   |  4 +
 arch/x86/include/asm/nospec-branch.h               | 21 +++++-
 arch/x86/kernel/cpu/bugs.c                         | 86 ++++++++++++++++------
 arch/x86/kernel/cpu/common.c                       | 12 ++-
 arch/x86/kvm/vmx/vmenter.S                         |  8 +-
 block/blk-ioc.c                                    |  2 +
 block/ioprio.c                                     |  4 +-
 drivers/acpi/apei/bert.c                           | 31 ++++++--
 drivers/acpi/video_detect.c                        | 55 +++++++++-----
 drivers/ata/sata_mv.c                              |  2 +-
 drivers/bluetooth/btbcm.c                          |  2 +
 drivers/bluetooth/btusb.c                          | 15 ++++
 drivers/bluetooth/hci_bcm.c                        |  2 +
 drivers/bluetooth/hci_qca.c                        |  2 +-
 drivers/macintosh/adb.c                            |  2 +-
 include/linux/ioprio.h                             |  2 +-
 tools/arch/x86/include/asm/cpufeatures.h           |  1 +
 tools/arch/x86/include/asm/msr-index.h             |  4 +
 tools/vm/slabinfo.c                                | 26 ++++++-
 26 files changed, 232 insertions(+), 72 deletions(-)


