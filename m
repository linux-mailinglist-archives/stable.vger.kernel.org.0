Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B85C25D9FE
	for <lists+stable@lfdr.de>; Fri,  4 Sep 2020 15:36:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730506AbgIDNer (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Sep 2020 09:34:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:37286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730438AbgIDNeX (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 4 Sep 2020 09:34:23 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AC1AE20FC3;
        Fri,  4 Sep 2020 13:30:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599226237;
        bh=Mltcje2cYJZbQgRJ0aYkUfX0QeKmubShe9fSHCTVT/g=;
        h=From:To:Cc:Subject:Date:From;
        b=lDt/Rrd688Kxl+rnnHIQV5vPlaThtd0P4LLIOfE/V7HJlPWowDH7hxjxqWOXlDMQe
         o8Ox8rLr8FbTR9uB9qa9db4Se0esrm/DsQ6IN86DZXpnAHEtj5VKiyBbbYN4WZdKtI
         QhWBs7AUC+/VdalsJT+XnVeUCZ0TB5dVLqD0kYwA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 5.8 00/17] 5.8.7-rc1 review
Date:   Fri,  4 Sep 2020 15:29:59 +0200
Message-Id: <20200904120257.983551609@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-5.8.7-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.8.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.8.7-rc1
X-KernelTest-Deadline: 2020-09-06T12:02+00:00
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.8.7 release.
There are 17 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun, 06 Sep 2020 12:02:48 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.8.7-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.8.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.8.7-rc1

Bodo Stroesser <bstroesser@ts.fujitsu.com>
    scsi: target: tcmu: Optimize use of flush_dcache_page

Johannes Berg <johannes.berg@intel.com>
    nl80211: fix NL80211_ATTR_HE_6GHZ_CAPABILITY usage

Sowjanya Komatineni <skomatineni@nvidia.com>
    sdhci: tegra: Remove SDHCI_QUIRK_DATA_TIMEOUT_USES_SDCLK for Tegra186

Sowjanya Komatineni <skomatineni@nvidia.com>
    sdhci: tegra: Remove SDHCI_QUIRK_DATA_TIMEOUT_USES_SDCLK for Tegra210

Sowjanya Komatineni <skomatineni@nvidia.com>
    arm64: tegra: Add missing timeout clock to Tegra210 SDMMC

Sowjanya Komatineni <skomatineni@nvidia.com>
    arm64: tegra: Add missing timeout clock to Tegra186 SDMMC nodes

Sowjanya Komatineni <skomatineni@nvidia.com>
    arm64: tegra: Add missing timeout clock to Tegra194 SDMMC nodes

Sowjanya Komatineni <skomatineni@nvidia.com>
    dt-bindings: mmc: tegra: Add tmclk for Tegra210 and later

James Morse <james.morse@arm.com>
    KVM: arm64: Survive synchronous exceptions caused by AT instructions

James Morse <james.morse@arm.com>
    KVM: arm64: Add kvm_extable for vaxorcism code

Peilin Ye <yepeilin.cs@gmail.com>
    media: media/v4l2-core: Fix kernel-infoleak in video_put_user()

Kim Phillips <kim.phillips@amd.com>
    perf record/stat: Explicitly call out event modifiers in the documentation

Andy Lutomirski <luto@kernel.org>
    selftests/x86/test_vsyscall: Improve the process_vm_readv() test

Dave Hansen <dave.hansen@linux.intel.com>
    mm: fix pin vs. gup mismatch with gate pages

Stefano Brivio <sbrivio@redhat.com>
    netfilter: nft_set_rbtree: Handle outcomes of tree rotations in overlap detection

Marc Zyngier <maz@kernel.org>
    HID: core: Sanitize event code and type when mapping input

Marc Zyngier <maz@kernel.org>
    HID: core: Correctly handle ReportSize being zero


-------------

Diffstat:

 .../bindings/mmc/nvidia,tegra20-sdhci.txt          | 32 ++++++++++-
 Makefile                                           |  4 +-
 arch/arm64/boot/dts/nvidia/tegra186.dtsi           | 20 ++++---
 arch/arm64/boot/dts/nvidia/tegra194.dtsi           | 15 +++--
 arch/arm64/boot/dts/nvidia/tegra210.dtsi           | 20 ++++---
 arch/arm64/include/asm/kvm_asm.h                   | 43 ++++++++++++++
 arch/arm64/kernel/vmlinux.lds.S                    |  8 +++
 arch/arm64/kvm/hyp/entry.S                         | 15 +++--
 arch/arm64/kvm/hyp/hyp-entry.S                     | 65 ++++++++++++++--------
 arch/arm64/kvm/hyp/switch.c                        | 39 +++++++++++--
 drivers/hid/hid-core.c                             | 15 ++++-
 drivers/hid/hid-input.c                            |  4 ++
 drivers/hid/hid-multitouch.c                       |  2 +
 drivers/media/v4l2-core/v4l2-ioctl.c               | 50 +++++++++--------
 drivers/mmc/host/sdhci-tegra.c                     |  2 -
 drivers/target/target_core_user.c                  | 11 ++--
 include/linux/hid.h                                | 42 +++++++++-----
 mm/gup.c                                           |  2 +-
 net/netfilter/nft_set_rbtree.c                     | 23 +++++---
 net/wireless/nl80211.c                             |  2 +-
 tools/perf/Documentation/perf-record.txt           |  4 ++
 tools/perf/Documentation/perf-stat.txt             |  4 ++
 tools/testing/selftests/x86/test_vsyscall.c        | 22 +++++++-
 23 files changed, 326 insertions(+), 118 deletions(-)


