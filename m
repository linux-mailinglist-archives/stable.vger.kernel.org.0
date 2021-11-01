Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29D32441AD2
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 12:43:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232213AbhKALqD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 07:46:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:48282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231485AbhKALqD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Nov 2021 07:46:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5AC8C60FC4;
        Mon,  1 Nov 2021 11:43:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635767010;
        bh=LD98EiANfiQ5gCBNZUHQtxeaR0d6VQm7rkRTGj0rgos=;
        h=From:To:Cc:Subject:Date:From;
        b=wt80p2hH4kHllwSh6V3rHb6AJVDELsMIda2xdCGJss+aZtB/KT3puVyjX3wz4w/gJ
         t89JZAs4wzLcahbEiqdAiT8piVbJ1O8czAfvgnC7AYnFC74oXawAqoXHmBRkn+P15N
         HIKXgJW0MwBNXtKeOnl/TKRUDU9MsV/2N7Lg7ZSE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 4.14 00/25] 4.14.254-rc2 review
Date:   Mon,  1 Nov 2021 12:43:20 +0100
Message-Id: <20211101114159.506284752@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.254-rc2.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.14.254-rc2
X-KernelTest-Deadline: 2021-11-03T11:42+00:00
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.14.254 release.
There are 25 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 03 Nov 2021 11:41:39 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.254-rc2.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.14.254-rc2

Xin Long <lucien.xin@gmail.com>
    sctp: add vtag check in sctp_sf_ootb

Xin Long <lucien.xin@gmail.com>
    sctp: add vtag check in sctp_sf_do_8_5_1_E_sa

Xin Long <lucien.xin@gmail.com>
    sctp: add vtag check in sctp_sf_violation

Xin Long <lucien.xin@gmail.com>
    sctp: fix the processing for COOKIE_ECHO chunk

Xin Long <lucien.xin@gmail.com>
    sctp: use init_tag from inithdr for ABORT chunk

Trevor Woerner <twoerner@gmail.com>
    net: nxp: lpc_eth.c: avoid hang when bringing interface down

Guenter Roeck <linux@roeck-us.net>
    nios2: Make NIOS2_DTB_SOURCE_BOOL depend on !COMPILE_TEST

Pavel Skripkin <paskripkin@gmail.com>
    net: batman-adv: fix error handling

Yang Yingliang <yangyingliang@huawei.com>
    regmap: Fix possible double-free in regcache_rbtree_exit()

Johan Hovold <johan@kernel.org>
    net: lan78xx: fix division by zero in send path

Haibo Chen <haibo.chen@nxp.com>
    mmc: sdhci-esdhc-imx: clear the buffer_read_ready to reset standard tuning circuit

Shawn Guo <shawn.guo@linaro.org>
    mmc: sdhci: Map more voltage level to SDHCI_POWER_330

Jaehoon Chung <jh80.chung@samsung.com>
    mmc: dw_mmc: exynos: fix the finding clock sample value

Johan Hovold <johan@kernel.org>
    mmc: vub300: fix control-message timeouts

Eric Dumazet <edumazet@google.com>
    ipv4: use siphash instead of Jenkins in fnhe_hashfun()

Pavel Skripkin <paskripkin@gmail.com>
    Revert "net: mdiobus: Fix memory leak in __mdiobus_register"

Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
    nfc: port100: fix using -ERRNO as command type mask

Zheyu Ma <zheyuma97@gmail.com>
    ata: sata_mv: Fix the error handling of mv_chip_id()

Wang Hai <wanghai38@huawei.com>
    usbnet: fix error return code in usbnet_probe()

Oliver Neukum <oneukum@suse.com>
    usbnet: sanity check for maxpacket

Nathan Chancellor <natechancellor@gmail.com>
    ARM: 8819/1: Remove '-p' from LDFLAGS

Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
    powerpc/bpf: Fix BPF_MOD when imm == 1

Arnd Bergmann <arnd@arndb.de>
    ARM: 9139/1: kprobes: fix arch_init_kprobes() prototype

Arnd Bergmann <arnd@arndb.de>
    ARM: 9134/1: remove duplicate memcpy() definition

Nick Desaulniers <ndesaulniers@google.com>
    ARM: 9133/1: mm: proc-macros: ensure *_tlb_fns are 4B aligned


-------------

Diffstat:

 Makefile                               |  4 +--
 arch/arm/Makefile                      |  2 +-
 arch/arm/boot/bootp/Makefile           |  2 +-
 arch/arm/boot/compressed/Makefile      |  2 --
 arch/arm/boot/compressed/decompress.c  |  3 ++
 arch/arm/mm/proc-macros.S              |  1 +
 arch/arm/probes/kprobes/core.c         |  2 +-
 arch/nios2/platform/Kconfig.platform   |  1 +
 arch/powerpc/net/bpf_jit_comp64.c      | 10 ++++--
 drivers/ata/sata_mv.c                  |  4 +--
 drivers/base/regmap/regcache-rbtree.c  |  7 ++---
 drivers/mmc/host/dw_mmc-exynos.c       | 14 +++++++++
 drivers/mmc/host/sdhci-esdhc-imx.c     | 17 +++++++++++
 drivers/mmc/host/sdhci.c               |  6 ++++
 drivers/mmc/host/vub300.c              | 18 +++++------
 drivers/net/ethernet/nxp/lpc_eth.c     |  5 ++-
 drivers/net/phy/mdio_bus.c             |  1 -
 drivers/net/usb/lan78xx.c              |  6 ++++
 drivers/net/usb/usbnet.c               |  5 +++
 drivers/nfc/port100.c                  |  4 +--
 net/batman-adv/bridge_loop_avoidance.c |  8 +++--
 net/batman-adv/main.c                  | 56 ++++++++++++++++++++++++----------
 net/batman-adv/network-coding.c        |  4 ++-
 net/batman-adv/translation-table.c     |  4 ++-
 net/ipv4/route.c                       | 12 ++++----
 net/sctp/sm_statefuns.c                | 30 ++++++++++++------
 26 files changed, 162 insertions(+), 66 deletions(-)


