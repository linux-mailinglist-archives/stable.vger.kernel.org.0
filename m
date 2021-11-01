Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CCC744163A
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 10:21:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232402AbhKAJXa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 05:23:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:58556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232316AbhKAJWp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Nov 2021 05:22:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 27D62611AD;
        Mon,  1 Nov 2021 09:20:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635758401;
        bh=lHpNhNxPiGdL77iG/RG+HgqI7wwiSPgq94ks62tNaUQ=;
        h=From:To:Cc:Subject:Date:From;
        b=aAY6qwssSU6FfSksbMaBrt9sCygkIChU+G2AuKTjNEAc9z23BVoaItsW0GBcBg33J
         4IZ2Jp34CkI8ldP5oEUEvsaDoscCoGacmeWPJmQm5SU6pv4gAgYhnMO0c1nGKQmm6H
         3xm5jv2LOh1fBuzYcOV7tF+KPT5XjuhC5snBEAuk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 4.9 00/20] 4.9.289-rc1 review
Date:   Mon,  1 Nov 2021 10:17:09 +0100
Message-Id: <20211101082444.133899096@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.289-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.9.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.9.289-rc1
X-KernelTest-Deadline: 2021-11-03T08:24+00:00
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.9.289 release.
There are 20 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 03 Nov 2021 08:24:20 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.289-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.9.289-rc1

Xin Long <lucien.xin@gmail.com>
    sctp: add vtag check in sctp_sf_violation

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

Shawn Guo <shawn.guo@linaro.org>
    mmc: sdhci: Map more voltage level to SDHCI_POWER_330

Jaehoon Chung <jh80.chung@samsung.com>
    mmc: dw_mmc: exynos: fix the finding clock sample value

Johan Hovold <johan@kernel.org>
    mmc: vub300: fix control-message timeouts

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
 net/sctp/sm_statefuns.c                |  4 +++
 24 files changed, 123 insertions(+), 50 deletions(-)


