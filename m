Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2858B19AFCC
	for <lists+stable@lfdr.de>; Wed,  1 Apr 2020 18:21:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733233AbgDAQVI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Apr 2020 12:21:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:43926 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733210AbgDAQVH (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Apr 2020 12:21:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8121320857;
        Wed,  1 Apr 2020 16:21:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585758065;
        bh=UmJt/vpTd8/HqoQFGz6homwA/A7dAtSQNP0xxzn5/JY=;
        h=From:To:Cc:Subject:Date:From;
        b=wkYjadIyJEtcY2sqRRRZq/esenjv9K5v4wmoyXlFGd9/sGz7KFa6YiUop/uMSTtfr
         amx1Dm92H0d1JUupyatUFKBfn3aQyEMVB3Yv6hwW6/Oh1DFrwbPHBa/JTMhSz+jcbU
         fCsPzbIcleZNQinVDwSLpDGAcw0FG5yxsI8djQFo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 5.5 00/30] 5.5.15-rc1 review
Date:   Wed,  1 Apr 2020 18:17:04 +0200
Message-Id: <20200401161414.345528747@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-5.5.15-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.5.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.5.15-rc1
X-KernelTest-Deadline: 2020-04-03T16:14+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.5.15 release.
There are 30 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 03 Apr 2020 16:09:36 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.5.15-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.5.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.5.15-rc1

Madalin Bucur <madalin.bucur@oss.nxp.com>
    arm64: dts: ls1046ardb: set RGMII interfaces to RGMII_ID mode

Madalin Bucur <madalin.bucur@oss.nxp.com>
    arm64: dts: ls1043a-rdb: correct RGMII delay mode to rgmii-id

Chen-Yu Tsai <wens@csie.org>
    ARM: dts: sun8i: r40: Move AHCI device node based on address order

Arthur Demchenkov <spinal.by@gmail.com>
    ARM: dts: N900: fix onenand timings

Marco Felsch <m.felsch@pengutronix.de>
    ARM: dts: imx6: phycore-som: fix arm and soc minimum voltage

Nick Hudson <skrll@netbsd.org>
    ARM: bcm2835-rpi-zero-w: Add missing pinctrl name

Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
    ARM: dts: bcm283x: Fix vc4's firmware bus DMA limitations

Sungbo Eo <mans0n@gorani.run>
    ARM: dts: oxnas: Fix clear-mask property

disconnect3d <dominik.b.czarnota@gmail.com>
    perf map: Fix off by one in strncpy() size argument

Ilie Halip <ilie.halip@gmail.com>
    arm64: alternative: fix build with clang integrated assembler

Ilya Dryomov <idryomov@gmail.com>
    libceph: fix alloc_msg_with_page_vector() memory leaks

Tony Lindgren <tony@atomide.com>
    clk: ti: am43xx: Fix clock parent for RTC clock

Leonard Crestez <leonard.crestez@nxp.com>
    clk: imx: Align imx sc clock parent msg structs to 4

Leonard Crestez <leonard.crestez@nxp.com>
    clk: imx: Align imx sc clock msg structs to 4

Marek Vasut <marex@denx.de>
    net: ks8851-ml: Fix IO operations, again

Hans de Goede <hdegoede@redhat.com>
    gpiolib: acpi: Add quirk to ignore EC wakeups on HP x2 10 CHT + AXP288 model

Golan Ben Ami <golan.ben.ami@intel.com>
    iwlwifi: don't send GEO_TX_POWER_LIMIT if no wgds table

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    bpf: Explicitly memset some bpf info structures declared on the stack

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    bpf: Explicitly memset the bpf_attr structure

Georg Müller <georgmueller@gmx.net>
    platform/x86: pmc_atom: Add Lex 2I385SW to critclk_systems DMI table

Eric Biggers <ebiggers@google.com>
    vt: vt_ioctl: fix use-after-free in vt_in_use()

Eric Biggers <ebiggers@google.com>
    vt: vt_ioctl: fix VT_DISALLOCATE freeing in-use virtual console

Eric Biggers <ebiggers@google.com>
    vt: vt_ioctl: remove unnecessary console allocation checks

Jiri Slaby <jslaby@suse.cz>
    vt: switch vt_dont_switch to bool

Jiri Slaby <jslaby@suse.cz>
    vt: ioctl, switch VT_IS_IN_USE and VT_BUSY to inlines

Jiri Slaby <jslaby@suse.cz>
    vt: selection, introduce vc_is_sel

Lanqing Liu <liuhhome@gmail.com>
    serial: sprd: Fix a dereference warning

Johannes Berg <johannes.berg@intel.com>
    mac80211: fix authentication with iwlwifi/mvm

Jouni Malinen <jouni@codeaurora.org>
    mac80211: Check port authorization in the ieee80211_tx_dequeue() case

Daniel Borkmann <daniel@iogearbox.net>
    bpf: update jmp32 test cases to fix range bound deduction


-------------

Diffstat:

 Makefile                                          |  4 +-
 arch/arm/boot/dts/bcm2835-rpi-zero-w.dts          |  1 +
 arch/arm/boot/dts/bcm2835-rpi.dtsi                |  1 +
 arch/arm/boot/dts/imx6qdl-phytec-phycore-som.dtsi |  4 +-
 arch/arm/boot/dts/omap3-n900.dts                  | 44 ++++++++-----
 arch/arm/boot/dts/ox810se.dtsi                    |  4 +-
 arch/arm/boot/dts/ox820.dtsi                      |  4 +-
 arch/arm/boot/dts/sun8i-r40.dtsi                  | 21 +++----
 arch/arm64/boot/dts/freescale/fsl-ls1043a-rdb.dts |  4 +-
 arch/arm64/boot/dts/freescale/fsl-ls1046a-rdb.dts |  4 +-
 arch/arm64/include/asm/alternative.h              |  2 +-
 drivers/clk/imx/clk-scu.c                         |  8 +--
 drivers/clk/ti/clk-43xx.c                         |  2 +-
 drivers/gpio/gpiolib-acpi.c                       | 15 +++++
 drivers/net/ethernet/micrel/ks8851_mll.c          | 56 +++++++++++++++--
 drivers/net/wireless/intel/iwlwifi/fw/acpi.c      | 14 +++--
 drivers/net/wireless/intel/iwlwifi/fw/acpi.h      | 14 +++--
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c       |  9 ++-
 drivers/platform/x86/pmc_atom.c                   |  8 +++
 drivers/tty/serial/sprd_serial.c                  |  3 +-
 drivers/tty/vt/selection.c                        |  5 ++
 drivers/tty/vt/vt.c                               | 30 +++++++--
 drivers/tty/vt/vt_ioctl.c                         | 75 ++++++++++++-----------
 include/linux/ceph/messenger.h                    |  7 ++-
 include/linux/selection.h                         |  4 +-
 include/linux/vt_kern.h                           |  2 +-
 kernel/bpf/btf.c                                  |  3 +-
 kernel/bpf/syscall.c                              |  9 ++-
 net/ceph/messenger.c                              |  9 ++-
 net/ceph/osd_client.c                             | 14 +----
 net/mac80211/tx.c                                 | 20 +++++-
 tools/perf/util/map.c                             |  2 +-
 tools/testing/selftests/bpf/verifier/jmp32.c      |  9 ++-
 33 files changed, 281 insertions(+), 130 deletions(-)


