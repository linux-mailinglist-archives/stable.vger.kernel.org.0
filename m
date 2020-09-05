Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFE2025E6D7
	for <lists+stable@lfdr.de>; Sat,  5 Sep 2020 11:48:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728364AbgIEJsX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Sep 2020 05:48:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:42232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728302AbgIEJsW (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 5 Sep 2020 05:48:22 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 975FD206B8;
        Sat,  5 Sep 2020 09:48:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599299300;
        bh=uuMz4WhT3tqk46fMByrUIdU3be3K/ICKQ9c9Mbrc10Q=;
        h=From:To:Cc:Subject:Date:From;
        b=LmhIfoKWRKGuErCL9YpkipyEiyj4nu2z9D2FKCoCuRwRSN7oytelsQtOsjA+MeqUi
         XyWLmV4Xi/x+9lKmcLXz7+PfyGcD4O6UQec+1f7vU179kjgZDwVaypecEN95dg8s1Q
         qtlLd/09tY6JuGblIafCbHsLDoz9hbmSHOkKSN5k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.8.7
Date:   Sat,  5 Sep 2020 11:48:35 +0200
Message-Id: <1599299316180106@kroah.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.8.7 kernel.

All users of the 5.8 kernel series must upgrade.

The updated 5.8.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.8.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/devicetree/bindings/mmc/nvidia,tegra20-sdhci.txt |   32 ++++
 Makefile                                                       |    2 
 arch/arm64/boot/dts/nvidia/tegra186.dtsi                       |   20 +--
 arch/arm64/boot/dts/nvidia/tegra194.dtsi                       |   15 +-
 arch/arm64/boot/dts/nvidia/tegra210.dtsi                       |   20 +--
 arch/arm64/include/asm/kvm_asm.h                               |   43 ++++++
 arch/arm64/kernel/vmlinux.lds.S                                |    8 +
 arch/arm64/kvm/hyp/entry.S                                     |   15 +-
 arch/arm64/kvm/hyp/hyp-entry.S                                 |   65 ++++++----
 arch/arm64/kvm/hyp/switch.c                                    |   39 +++++-
 drivers/hid/hid-core.c                                         |   15 ++
 drivers/hid/hid-input.c                                        |    4 
 drivers/hid/hid-multitouch.c                                   |    2 
 drivers/media/v4l2-core/v4l2-ioctl.c                           |   50 ++++---
 drivers/mmc/host/sdhci-tegra.c                                 |    2 
 drivers/target/target_core_user.c                              |   11 +
 include/linux/hid.h                                            |   42 ++++--
 mm/gup.c                                                       |    2 
 net/netfilter/nft_set_rbtree.c                                 |   23 ++-
 net/wireless/nl80211.c                                         |    2 
 tools/perf/Documentation/perf-record.txt                       |    4 
 tools/perf/Documentation/perf-stat.txt                         |    4 
 tools/testing/selftests/x86/test_vsyscall.c                    |   22 +++
 23 files changed, 325 insertions(+), 117 deletions(-)

Andy Lutomirski (1):
      selftests/x86/test_vsyscall: Improve the process_vm_readv() test

Bodo Stroesser (1):
      scsi: target: tcmu: Optimize use of flush_dcache_page

Dave Hansen (1):
      mm: fix pin vs. gup mismatch with gate pages

Greg Kroah-Hartman (1):
      Linux 5.8.7

James Morse (2):
      KVM: arm64: Add kvm_extable for vaxorcism code
      KVM: arm64: Survive synchronous exceptions caused by AT instructions

Johannes Berg (1):
      nl80211: fix NL80211_ATTR_HE_6GHZ_CAPABILITY usage

Kim Phillips (1):
      perf record/stat: Explicitly call out event modifiers in the documentation

Marc Zyngier (2):
      HID: core: Correctly handle ReportSize being zero
      HID: core: Sanitize event code and type when mapping input

Peilin Ye (1):
      media: media/v4l2-core: Fix kernel-infoleak in video_put_user()

Sowjanya Komatineni (6):
      dt-bindings: mmc: tegra: Add tmclk for Tegra210 and later
      arm64: tegra: Add missing timeout clock to Tegra194 SDMMC nodes
      arm64: tegra: Add missing timeout clock to Tegra186 SDMMC nodes
      arm64: tegra: Add missing timeout clock to Tegra210 SDMMC
      sdhci: tegra: Remove SDHCI_QUIRK_DATA_TIMEOUT_USES_SDCLK for Tegra210
      sdhci: tegra: Remove SDHCI_QUIRK_DATA_TIMEOUT_USES_SDCLK for Tegra186

Stefano Brivio (1):
      netfilter: nft_set_rbtree: Handle outcomes of tree rotations in overlap detection

