Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8DDDF236D3
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 15:17:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730650AbfETMRI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 08:17:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:57918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387446AbfETMRF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 May 2019 08:17:05 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 372C0214DA;
        Mon, 20 May 2019 12:17:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558354624;
        bh=pMhJBov8FCnLw4exJBoL5XcFYktewII0T/VxOTtlouk=;
        h=From:To:Cc:Subject:Date:From;
        b=uhNEl19iJ3DKhAB6vjafMkn8H6iZ1nW+F4ldpqHu7597agDWnI4jlveJs8lPT7/9s
         nFl6hgntXufWSaf3vfPvkPykj4BvJecqM64CN/K+OCj40pMkdk2+DL9fssDhQrjKMs
         jnh651swNvIDjM1uc/Wng+l8ldwgQTavKiI10t2E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.9 00/44] 4.9.178-stable review
Date:   Mon, 20 May 2019 14:13:49 +0200
Message-Id: <20190520115230.720347034@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.178-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.9.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.9.178-rc1
X-KernelTest-Deadline: 2019-05-22T11:52+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.9.178 release.
There are 44 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed 22 May 2019 11:50:58 AM UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.178-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.9.178-rc1

Sean Christopherson <sean.j.christopherson@intel.com>
    KVM: x86: Skip EFER vs. guest CPUID checks for host-initiated writes

Michał Wadowski <wadosm@gmail.com>
    ALSA: hda/realtek - Fix for Lenovo B50-70 inverted internal microphone bug

Lukas Czerner <lczerner@redhat.com>
    ext4: fix data corruption caused by overlapping unaligned and aligned IO

Sriram Rajagopalan <sriramr@arista.com>
    ext4: zero out the unused memory region in the extent tree block

Jiufei Xue <jiufei.xue@linux.alibaba.com>
    fs/writeback.c: use rcu_barrier() to wait for inflight wb switches going into workqueue when umount

Tejun Heo <tj@kernel.org>
    writeback: synchronize sync(2) against cgroup writeback membership switches

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    fib_rules: fix error in backport of e9919a24d302 ("fib_rules: return 0...")

Eric Biggers <ebiggers@google.com>
    crypto: arm/aes-neonbs - don't access already-freed walk.iv

Eric Biggers <ebiggers@google.com>
    crypto: salsa20 - don't access already-freed walk.iv

Eric Biggers <ebiggers@google.com>
    crypto: gcm - fix incompatibility between "gcm" and "gcm_base"

Wei Yongjun <weiyongjun1@huawei.com>
    crypto: gcm - Fix error return code in crypto_gcm_create_common()

Kamlakant Patel <kamlakantp@marvell.com>
    ipmi:ssif: compare block number correctly for multi-part return messages

Coly Li <colyli@suse.de>
    bcache: never set KEY_PTRS of journal key to 0 in journal_reclaim()

Liang Chen <liangchen.linux@gmail.com>
    bcache: fix a race between cache register and cacheset unregister

Filipe Manana <fdmanana@suse.com>
    Btrfs: do not start a transaction at iterate_extent_inodes()

Debabrata Banerjee <dbanerje@akamai.com>
    ext4: fix ext4_show_options for file systems w/o journal

Kirill Tkhai <ktkhai@virtuozzo.com>
    ext4: actually request zeroing of inode table after grow

Jiufei Xue <jiufei.xue@linux.alibaba.com>
    jbd2: check superblock mapped prior to committing

Sergei Trofimovich <slyfox@gentoo.org>
    tty/vt: fix write/write race in ioctl(KDSKBSENT) handler

Dmitry Osipenko <digetx@gmail.com>
    mfd: max77620: Fix swapped FPS_PERIOD_MAX_US values

Steve Twiss <stwiss.opensource@diasemi.com>
    mfd: da9063: Fix OTP control register names to match datasheets for DA9063/63L

Shuning Zhang <sunny.s.zhang@oracle.com>
    ocfs2: fix ocfs2 read inode data panic in ocfs2_iget

Jiri Kosina <jkosina@suse.cz>
    mm/mincore.c: make mincore() more conservative

Curtis Malainey <cujomalainey@chromium.org>
    ASoC: RT5677-SPI: Disable 16Bit SPI Transfers

Jon Hunter <jonathanh@nvidia.com>
    ASoC: max98090: Fix restore of DAPM Muxes

Kailang Yang <kailang@realtek.com>
    ALSA: hda/realtek - EAPD turn on later

Hui Wang <hui.wang@canonical.com>
    ALSA: hda/hdmi - Consider eld_valid when reporting jack event

Hui Wang <hui.wang@canonical.com>
    ALSA: hda/hdmi - Read the pin sense from register when repolling

Wenwen Wang <wang6495@umn.edu>
    ALSA: usb-audio: Fix a memory leak bug

Eric Biggers <ebiggers@google.com>
    crypto: x86/crct10dif-pcl - fix use via crypto_shash_digest()

Eric Biggers <ebiggers@google.com>
    crypto: crct10dif-generic - fix use via crypto_shash_digest()

Daniel Axtens <dja@axtens.net>
    crypto: vmx - fix copy-paste error in CTR mode

Eric Biggers <ebiggers@google.com>
    crypto: chacha20poly1305 - set cra_name correctly

Peter Zijlstra <peterz@infradead.org>
    sched/x86: Save [ER]FLAGS on context switch

Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
    arm64: Clear OSDLR_EL1 on CPU boot

Vincenzo Frascino <vincenzo.frascino@arm.com>
    arm64: compat: Reduce address limit

Gustavo A. R. Silva <gustavo@embeddedor.com>
    power: supply: axp288_charger: Fix unchecked return value

Wen Yang <wen.yang99@zte.com.cn>
    ARM: exynos: Fix a leaked reference by adding missing of_node_put

Josh Poimboeuf <jpoimboe@redhat.com>
    objtool: Fix function fallthrough detection

Andy Lutomirski <luto@kernel.org>
    x86/speculation/mds: Improve CPU buffer clear documentation

Andy Lutomirski <luto@kernel.org>
    x86/speculation/mds: Revert CPU buffer clear on double fault exit

Dexuan Cui <decui@microsoft.com>
    PCI: hv: Fix a memory leak in hv_eject_device_work()

Waiman Long <longman@redhat.com>
    locking/rwsem: Prevent decrement of reader count before increment

Sasha Levin <sashal@kernel.org>
    net: core: another layer of lists, around PF_MEMALLOC skb handling


-------------

Diffstat:

 Documentation/x86/mds.rst               | 44 ++++------------------------
 Makefile                                |  4 +--
 arch/arm/crypto/aesbs-glue.c            |  4 +++
 arch/arm/mach-exynos/firmware.c         |  1 +
 arch/arm/mach-exynos/suspend.c          |  2 ++
 arch/arm64/include/asm/processor.h      |  8 ++++++
 arch/arm64/kernel/debug-monitors.c      |  1 +
 arch/x86/crypto/crct10dif-pclmul_glue.c | 13 ++++-----
 arch/x86/entry/entry_32.S               |  2 ++
 arch/x86/entry/entry_64.S               |  2 ++
 arch/x86/include/asm/switch_to.h        |  1 +
 arch/x86/kernel/process_32.c            |  7 +++++
 arch/x86/kernel/process_64.c            |  8 ++++++
 arch/x86/kernel/traps.c                 |  8 ------
 arch/x86/kvm/x86.c                      | 33 ++++++++++++++-------
 crypto/chacha20poly1305.c               |  4 +--
 crypto/crct10dif_generic.c              | 11 +++----
 crypto/gcm.c                            | 36 ++++++++---------------
 crypto/salsa20_generic.c                |  2 +-
 drivers/char/ipmi/ipmi_ssif.c           |  6 +++-
 drivers/crypto/vmx/aesp8-ppc.pl         |  4 +--
 drivers/md/bcache/journal.c             | 11 ++++---
 drivers/md/bcache/super.c               |  2 +-
 drivers/pci/host/pci-hyperv.c           |  1 +
 drivers/power/supply/axp288_charger.c   |  4 +++
 drivers/tty/vt/keyboard.c               | 33 +++++++++++++++++----
 fs/btrfs/backref.c                      | 18 ++++++++----
 fs/ext4/extents.c                       | 17 +++++++++--
 fs/ext4/file.c                          |  7 +++++
 fs/ext4/ioctl.c                         |  2 +-
 fs/ext4/super.c                         |  2 +-
 fs/fs-writeback.c                       | 51 +++++++++++++++++++++++++++++----
 fs/jbd2/journal.c                       |  4 +++
 fs/ocfs2/export.c                       | 30 ++++++++++++++++++-
 include/linux/backing-dev-defs.h        |  1 +
 include/linux/list.h                    | 30 +++++++++++++++++++
 include/linux/mfd/da9063/registers.h    |  6 ++--
 include/linux/mfd/max77620.h            |  4 +--
 kernel/locking/rwsem-xadd.c             | 44 +++++++++++++++++++---------
 mm/backing-dev.c                        |  1 +
 mm/mincore.c                            | 23 ++++++++++++++-
 net/core/fib_rules.c                    |  1 +
 sound/pci/hda/patch_hdmi.c              | 11 +++++--
 sound/pci/hda/patch_realtek.c           |  5 ++--
 sound/soc/codecs/max98090.c             | 12 ++++----
 sound/soc/codecs/rt5677-spi.c           | 35 +++++++++++-----------
 sound/usb/mixer.c                       |  2 ++
 tools/objtool/check.c                   |  3 +-
 48 files changed, 379 insertions(+), 182 deletions(-)


