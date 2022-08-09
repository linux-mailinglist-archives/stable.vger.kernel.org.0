Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D050158DEBE
	for <lists+stable@lfdr.de>; Tue,  9 Aug 2022 20:23:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343802AbiHISXD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Aug 2022 14:23:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343778AbiHISSq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Aug 2022 14:18:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 619472FFD2;
        Tue,  9 Aug 2022 11:07:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CA74EB81908;
        Tue,  9 Aug 2022 18:06:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E127BC433C1;
        Tue,  9 Aug 2022 18:06:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660068412;
        bh=FgMx2k0++9td5Qd6Hgc7T8JaZ8hV1xZfSCu0Pn1+LhE=;
        h=From:To:Cc:Subject:Date:From;
        b=2Q4cMp76wm1r+Nv9E9or2X1wG6jQ96x5ylj3lyCqrz60qH6GedMoAdFQfG2cWcUVb
         tRrY02wZtoCPao7Xy7RBp9Ytp5OUraqN2xF72EImDvFmNALsRDuhBGk4rYXAyVra75
         X9ZWRGh4SH5pQ0lJl+xlXgBA8TZRUTvWZ4r+n2jM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Subject: [PATCH 5.18 00/35] 5.18.17-rc1 review
Date:   Tue,  9 Aug 2022 20:00:29 +0200
Message-Id: <20220809175515.046484486@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.18.17-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.18.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.18.17-rc1
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

This is the start of the stable review cycle for the 5.18.17 release.
There are 35 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 11 Aug 2022 17:55:02 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.18.17-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.18.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.18.17-rc1

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

Naohiro Aota <naohiro.aota@wdc.com>
    btrfs: zoned: drop optimization of zone finish

Naohiro Aota <naohiro.aota@wdc.com>
    btrfs: zoned: fix critical section of relocation inode writeback

Naohiro Aota <naohiro.aota@wdc.com>
    btrfs: zoned: prevent allocation from previous data relocation BG

Peter Collingbourne <pcc@google.com>
    arm64: set UXN on swapper page tables

Mingwei Zhang <mizhang@google.com>
    KVM: x86/svm: add __GFP_ACCOUNT to __sev_dbg_{en,de}crypt_user()

Raghavendra Rao Ananta <rananta@google.com>
    selftests: KVM: Handle compiler optimizations in ucall

Dmitry Klochkov <kdmitry556@gmail.com>
    tools/kvm_stat: fix display of error when multiple processes are found

David Matlack <dmatlack@google.com>
    KVM: selftests: Restrict test region to 48-bit physical addresses when using nested

Maxim Levitsky <mlevitsk@redhat.com>
    KVM: x86: disable preemption around the call to kvm_arch_vcpu_{un|}blocking

Maxim Levitsky <mlevitsk@redhat.com>
    KVM: x86: disable preemption while updating apicv inhibition

Seth Forshee <sforshee@digitalocean.com>
    entry/kvm: Exit to user mode when TIF_NOTIFY_SIGNAL is set

Ben Gardon <bgardon@google.com>
    KVM: x86/MMU: Zap non-leaf SPTEs when disabling dirty logging

Vitaly Kuznetsov <vkuznets@redhat.com>
    KVM: selftests: Make hyperv_clock selftest more stable

Paolo Bonzini <pbonzini@redhat.com>
    KVM: x86: do not set st->preempted when going back to user space

Paolo Bonzini <pbonzini@redhat.com>
    KVM: x86: do not report a vCPU as preempted outside instruction boundaries

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

Ben Hutchings <ben@decadent.org.uk>
    x86/speculation: Make all RETbleed mitigations 64-bit only


-------------

Diffstat:

 Documentation/admin-guide/hw-vuln/spectre.rst      |  8 ++
 .../bindings/net/broadcom-bluetooth.yaml           |  1 +
 Makefile                                           |  4 +-
 arch/arm64/crypto/poly1305-glue.c                  |  2 +-
 arch/arm64/include/asm/kernel-pgtable.h            |  4 +-
 arch/arm64/kernel/head.S                           |  2 +-
 arch/x86/Kconfig                                   |  8 +-
 arch/x86/include/asm/cpufeatures.h                 |  2 +
 arch/x86/include/asm/kvm_host.h                    |  3 +
 arch/x86/include/asm/msr-index.h                   |  4 +
 arch/x86/include/asm/nospec-branch.h               | 21 +++++-
 arch/x86/kernel/cpu/bugs.c                         | 86 ++++++++++++++++------
 arch/x86/kernel/cpu/common.c                       | 12 ++-
 arch/x86/kvm/mmu/tdp_iter.c                        |  9 +++
 arch/x86/kvm/mmu/tdp_iter.h                        |  1 +
 arch/x86/kvm/mmu/tdp_mmu.c                         | 38 ++++++++--
 arch/x86/kvm/svm/sev.c                             |  4 +-
 arch/x86/kvm/svm/svm.c                             |  2 +
 arch/x86/kvm/vmx/vmenter.S                         |  8 +-
 arch/x86/kvm/vmx/vmx.c                             |  1 +
 arch/x86/kvm/x86.c                                 | 50 ++++++++++---
 arch/x86/kvm/xen.h                                 |  6 +-
 block/blk-ioc.c                                    |  2 +
 block/ioprio.c                                     |  4 +-
 drivers/acpi/apei/bert.c                           | 31 ++++++--
 drivers/acpi/video_detect.c                        | 55 +++++++++-----
 drivers/bluetooth/btbcm.c                          |  2 +
 drivers/bluetooth/btusb.c                          | 15 ++++
 drivers/bluetooth/hci_bcm.c                        |  2 +
 drivers/bluetooth/hci_qca.c                        |  2 +-
 drivers/macintosh/adb.c                            |  2 +-
 fs/btrfs/block-group.h                             |  1 +
 fs/btrfs/extent-tree.c                             | 20 ++++-
 fs/btrfs/extent_io.c                               |  3 +-
 fs/btrfs/inode.c                                   |  2 +
 fs/btrfs/zoned.c                                   | 50 +++++++++++--
 fs/btrfs/zoned.h                                   |  5 ++
 include/linux/ioprio.h                             |  2 +-
 kernel/entry/kvm.c                                 |  6 --
 tools/arch/x86/include/asm/cpufeatures.h           |  1 +
 tools/arch/x86/include/asm/msr-index.h             |  4 +
 tools/kvm/kvm_stat/kvm_stat                        |  3 +-
 tools/testing/selftests/kvm/lib/aarch64/ucall.c    |  9 +--
 tools/testing/selftests/kvm/lib/perf_test_util.c   | 18 ++++-
 tools/testing/selftests/kvm/x86_64/hyperv_clock.c  | 10 ++-
 tools/vm/slabinfo.c                                | 26 ++++++-
 virt/kvm/kvm_main.c                                |  8 +-
 47 files changed, 434 insertions(+), 125 deletions(-)


