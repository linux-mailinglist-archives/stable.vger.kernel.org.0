Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3E783E255A
	for <lists+stable@lfdr.de>; Fri,  6 Aug 2021 10:20:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242868AbhHFITp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Aug 2021 04:19:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:49068 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244076AbhHFISe (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 6 Aug 2021 04:18:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 374826120F;
        Fri,  6 Aug 2021 08:18:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628237896;
        bh=ezieQ8IoVR0D/G8ChF9rSrfAccx9aT4VBjwCOrO+AsM=;
        h=From:To:Cc:Subject:Date:From;
        b=ayTsTgCrw60Yceeuyo94nswOgIL/gMj3+bu11iB3QSbCgjlOVVqYbQk3Uae04WMZX
         gi15tTgET0jDU6skRQEaUCyeK2z8pRfDdjHxONLpPk6vCjOx1QH55vHvZumr/lcmBt
         U0Wdo2Y+f4ObDBYX+9ZlZ7NGYbZOU8Es2lEYUOVI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 5.4 00/23] 5.4.139-rc1 review
Date:   Fri,  6 Aug 2021 10:16:32 +0200
Message-Id: <20210806081112.104686873@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.139-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.139-rc1
X-KernelTest-Deadline: 2021-08-08T08:11+00:00
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.4.139 release.
There are 23 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun, 08 Aug 2021 08:11:03 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.139-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.4.139-rc1

Daniel Borkmann <daniel@iogearbox.net>
    bpf, selftests: Adjust few selftest outcomes wrt unreachable code

John Fastabend <john.fastabend@gmail.com>
    bpf, selftests: Add a verifier test for assigning 32bit reg states to 64bit ones

John Fastabend <john.fastabend@gmail.com>
    bpf: Test_verifier, add alu32 bounds tracking tests

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Fix leakage under speculation on mispredicted branches

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Do not mark insn as seen under speculative path verification

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Inherit expanded/patched seen count from old aux data

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "watchdog: iTCO_wdt: Account for rebooting on second timeout"

Cristian Marussi <cristian.marussi@arm.com>
    firmware: arm_scmi: Add delayed response status check

Sudeep Holla <sudeep.holla@arm.com>
    firmware: arm_scmi: Ensure drivers provide a probe function

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "Bluetooth: Shutdown controller after workqueues are flushed or cancelled"

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "spi: mediatek: fix fifo rx mode"

Linus Torvalds <torvalds@linux-foundation.org>
    ACPI: fix NULL pointer dereference

Keith Busch <kbusch@kernel.org>
    nvme: fix nvme_setup_command metadata trace event

Pravin B Shelar <pshelar@ovn.org>
    net: Fix zero-copy head len calculation.

Jia He <justin.he@arm.com>
    qed: fix possible unpaired spin_{un}lock_bh in _qed_mcp_cmd_and_union()

Takashi Iwai <tiwai@suse.de>
    r8152: Fix potential PM refcount imbalance

Kyle Russell <bkylerussell@gmail.com>
    ASoC: tlv320aic31xx: fix reversed bclk/wclk master bits

Alain Volmat <alain.volmat@foss.st.com>
    spi: stm32h7: fix full duplex irq handler handling

Axel Lin <axel.lin@ingics.com>
    regulator: rt5033: Fix n_voltages settings for BUCK and LDO

Filipe Manana <fdmanana@suse.com>
    btrfs: fix lost inode on log replay after mix of fsync, rename and inode eviction

Filipe Manana <fdmanana@suse.com>
    btrfs: fix race causing unnecessary inode logging during link and rename

Filipe Manana <fdmanana@suse.com>
    btrfs: do not commit logs and transactions during link and rename operations

Randy Dunlap <rdunlap@infradead.org>
    btrfs: delete duplicated words + other fixes in comments


-------------

Diffstat:

 Makefile                                           |   4 +-
 drivers/firmware/arm_scmi/bus.c                    |   3 +
 drivers/firmware/arm_scmi/driver.c                 |   8 +-
 drivers/net/ethernet/qlogic/qed/qed_mcp.c          |  23 +++--
 drivers/net/usb/r8152.c                            |   3 +-
 drivers/nvme/host/trace.h                          |   6 +-
 drivers/spi/spi-mt65xx.c                           |  16 +--
 drivers/spi/spi-stm32.c                            |  15 +--
 drivers/watchdog/iTCO_wdt.c                        |  12 +--
 fs/btrfs/block-group.c                             |   2 +-
 fs/btrfs/ctree.c                                   |   2 +-
 fs/btrfs/disk-io.c                                 |   2 +-
 fs/btrfs/extent_io.c                               |   2 +-
 fs/btrfs/free-space-cache.c                        |   2 +-
 fs/btrfs/inode.c                                   | 115 +++------------------
 fs/btrfs/qgroup.c                                  |   2 +-
 fs/btrfs/tree-log.c                                | 107 +++++++++----------
 fs/btrfs/tree-log.h                                |  14 +--
 include/acpi/acpi_bus.h                            |   3 +-
 include/linux/mfd/rt5033-private.h                 |   4 +-
 kernel/bpf/verifier.c                              |  65 ++++++++++--
 net/bluetooth/hci_core.c                           |  16 +--
 net/core/skbuff.c                                  |   5 +-
 sound/soc/codecs/tlv320aic31xx.h                   |   4 +-
 tools/testing/selftests/bpf/test_verifier.c        |   2 +-
 tools/testing/selftests/bpf/verifier/bounds.c      |  65 ++++++++++++
 tools/testing/selftests/bpf/verifier/dead_code.c   |   2 +
 tools/testing/selftests/bpf/verifier/jmp32.c       |  22 ++++
 tools/testing/selftests/bpf/verifier/jset.c        |  10 +-
 tools/testing/selftests/bpf/verifier/unpriv.c      |   2 +
 .../selftests/bpf/verifier/value_ptr_arith.c       |   7 +-
 31 files changed, 295 insertions(+), 250 deletions(-)


