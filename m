Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BAF79236F4
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 15:17:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733087AbfETMSv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 08:18:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:60046 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387745AbfETMSu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 May 2019 08:18:50 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 51CDD20815;
        Mon, 20 May 2019 12:18:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558354729;
        bh=zMPwysYLhPqdWOGHydl+QYkPi+ouF6cCbXt/l0Ms5uc=;
        h=From:To:Cc:Subject:Date:From;
        b=YnQda0LvDgiGm+BgaSx8vHg0sq6Jr+Hm9U5ip2CfYJYldb92RyCqLLY7+rcEg3KXt
         ZZeBBra247IxIAsmP9eWzzJAFMWDIaEpbueOcuZr5M2Nyw1hdCcioGooOKp0oIX6Cl
         Ypo+cnunZ0CNhq4AWuIroNOc/PMgS6o2rIVQuJ3Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.14 00/63] 4.14.121-stable review
Date:   Mon, 20 May 2019 14:13:39 +0200
Message-Id: <20190520115231.137981521@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.121-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.14.121-rc1
X-KernelTest-Deadline: 2019-05-22T11:52+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.14.121 release.
There are 63 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed 22 May 2019 11:50:54 AM UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.121-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.14.121-rc1

zhangyi (F) <yi.zhang@huawei.com>
    ext4: fix compile error when using BUFFER_TRACE

Eric Dumazet <edumazet@google.com>
    iov_iter: optimize page_copy_sane()

Sean Christopherson <sean.j.christopherson@intel.com>
    KVM: x86: Skip EFER vs. guest CPUID checks for host-initiated writes

Michał Wadowski <wadosm@gmail.com>
    ALSA: hda/realtek - Fix for Lenovo B50-70 inverted internal microphone bug

Sahitya Tummala <stummala@codeaurora.org>
    ext4: fix use-after-free in dx_release()

Lukas Czerner <lczerner@redhat.com>
    ext4: fix data corruption caused by overlapping unaligned and aligned IO

Sriram Rajagopalan <sriramr@arista.com>
    ext4: zero out the unused memory region in the extent tree block

Jiufei Xue <jiufei.xue@linux.alibaba.com>
    fs/writeback.c: use rcu_barrier() to wait for inflight wb switches going into workqueue when umount

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    fib_rules: fix error in backport of e9919a24d302 ("fib_rules: return 0...")

Eric Biggers <ebiggers@google.com>
    crypto: ccm - fix incompatibility between "ccm" and "ccm_base"

Eric Biggers <ebiggers@google.com>
    crypto: salsa20 - don't access already-freed walk.iv

Eric Biggers <ebiggers@google.com>
    crypto: arm64/aes-neonbs - don't access already-freed walk.iv

Kamlakant Patel <kamlakantp@marvell.com>
    ipmi:ssif: compare block number correctly for multi-part return messages

Debabrata Banerjee <dbanerje@akamai.com>
    ext4: fix ext4_show_options for file systems w/o journal

Kirill Tkhai <ktkhai@virtuozzo.com>
    ext4: actually request zeroing of inode table after grow

Barret Rhoden <brho@google.com>
    ext4: fix use-after-free race with debug_want_extra_isize

Coly Li <colyli@suse.de>
    bcache: never set KEY_PTRS of journal key to 0 in journal_reclaim()

Liang Chen <liangchen.linux@gmail.com>
    bcache: fix a race between cache register and cacheset unregister

Filipe Manana <fdmanana@suse.com>
    Btrfs: do not start a transaction at iterate_extent_inodes()

Filipe Manana <fdmanana@suse.com>
    Btrfs: do not start a transaction during fiemap

Pan Bian <bianpan2016@163.com>
    ext4: avoid drop reference to iloc.bh twice

Theodore Ts'o <tytso@mit.edu>
    ext4: ignore e_value_offs for xattrs with value-in-ea-inode

Jan Kara <jack@suse.cz>
    ext4: make sanity check in mballoc more strict

Jiufei Xue <jiufei.xue@linux.alibaba.com>
    jbd2: check superblock mapped prior to committing

Sergei Trofimovich <slyfox@gentoo.org>
    tty/vt: fix write/write race in ioctl(KDSKBSENT) handler

Yifeng Li <tomli@tomli.me>
    tty: vt.c: Fix TIOCL_BLANKSCREEN console blanking if blankinterval == 0

Alexander Sverdlin <alexander.sverdlin@nokia.com>
    mtd: spi-nor: intel-spi: Avoid crossing 4K address boundary on read/write

Dmitry Osipenko <digetx@gmail.com>
    mfd: max77620: Fix swapped FPS_PERIOD_MAX_US values

Steve Twiss <stwiss.opensource@diasemi.com>
    mfd: da9063: Fix OTP control register names to match datasheets for DA9063/63L

Andrea Arcangeli <aarcange@redhat.com>
    userfaultfd: use RCU to free the task struct when fork fails

Shuning Zhang <sunny.s.zhang@oracle.com>
    ocfs2: fix ocfs2 read inode data panic in ocfs2_iget

Jiri Kosina <jkosina@suse.cz>
    mm/mincore.c: make mincore() more conservative

Daniel Borkmann <daniel@iogearbox.net>
    bpf, arm64: remove prefetch insn in xadd mapping

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
    crypto: arm/aes-neonbs - don't access already-freed walk.iv

Zhang Zhijie <zhangzj@rock-chips.com>
    crypto: rockchip - update IV buffer to contain the next IV

Eric Biggers <ebiggers@google.com>
    crypto: gcm - fix incompatibility between "gcm" and "gcm_base"

Eric Biggers <ebiggers@google.com>
    crypto: x86/crct10dif-pcl - fix use via crypto_shash_digest()

Eric Biggers <ebiggers@google.com>
    crypto: crct10dif-generic - fix use via crypto_shash_digest()

Eric Biggers <ebiggers@google.com>
    crypto: skcipher - don't WARN on unprocessed data after slow walk step

Daniel Axtens <dja@axtens.net>
    crypto: vmx - fix copy-paste error in CTR mode

Eric Biggers <ebiggers@google.com>
    crypto: chacha20poly1305 - set cra_name correctly

Peter Zijlstra <peterz@infradead.org>
    sched/x86: Save [ER]FLAGS on context switch

Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
    arm64: Save and restore OSDLR_EL1 across suspend/resume

Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
    arm64: Clear OSDLR_EL1 on CPU boot

Vincenzo Frascino <vincenzo.frascino@arm.com>
    arm64: compat: Reduce address limit

Gustavo A. R. Silva <gustavo@embeddedor.com>
    power: supply: axp288_charger: Fix unchecked return value

Wen Yang <wen.yang99@zte.com.cn>
    ARM: exynos: Fix a leaked reference by adding missing of_node_put

Sylwester Nawrocki <s.nawrocki@samsung.com>
    ARM: dts: exynos: Fix audio (microphone) routing on Odroid XU3

Stuart Menefy <stuart.menefy@mathembedded.com>
    ARM: dts: exynos: Fix interrupt for shared EINTs on Exynos5260

Josh Poimboeuf <jpoimboe@redhat.com>
    objtool: Fix function fallthrough detection

Andy Lutomirski <luto@kernel.org>
    x86/speculation/mds: Improve CPU buffer clear documentation

Andy Lutomirski <luto@kernel.org>
    x86/speculation/mds: Revert CPU buffer clear on double fault exit

Dexuan Cui <decui@microsoft.com>
    PCI: hv: Add pci_destroy_slot() in pci_devices_present_work(), if necessary

Dexuan Cui <decui@microsoft.com>
    PCI: hv: Add hv_pci_remove_slots() when we unload the driver

Dexuan Cui <decui@microsoft.com>
    PCI: hv: Fix a memory leak in hv_eject_device_work()

Waiman Long <longman@redhat.com>
    locking/rwsem: Prevent decrement of reader count before increment

Sasha Levin <sashal@kernel.org>
    net: core: another layer of lists, around PF_MEMALLOC skb handling


-------------

Diffstat:

 Documentation/x86/mds.rst                          | 44 +++-------------
 Makefile                                           |  4 +-
 arch/arm/boot/dts/exynos5260.dtsi                  |  2 +-
 arch/arm/boot/dts/exynos5422-odroidxu3-audio.dtsi  |  2 +-
 arch/arm/crypto/aes-neonbs-glue.c                  |  2 +
 arch/arm/mach-exynos/firmware.c                    |  1 +
 arch/arm/mach-exynos/suspend.c                     |  2 +
 arch/arm64/crypto/aes-neonbs-glue.c                |  2 +
 arch/arm64/include/asm/processor.h                 |  8 +++
 arch/arm64/kernel/debug-monitors.c                 |  1 +
 arch/arm64/mm/proc.S                               | 34 ++++++------
 arch/arm64/net/bpf_jit.h                           |  6 ---
 arch/arm64/net/bpf_jit_comp.c                      |  1 -
 arch/x86/crypto/crct10dif-pclmul_glue.c            | 13 ++---
 arch/x86/entry/entry_32.S                          |  2 +
 arch/x86/entry/entry_64.S                          |  2 +
 arch/x86/include/asm/switch_to.h                   |  1 +
 arch/x86/kernel/process_32.c                       |  7 +++
 arch/x86/kernel/process_64.c                       |  8 +++
 arch/x86/kernel/traps.c                            |  8 ---
 arch/x86/kvm/x86.c                                 | 37 ++++++++-----
 crypto/ccm.c                                       | 44 +++++++---------
 crypto/chacha20poly1305.c                          |  4 +-
 crypto/crct10dif_generic.c                         | 11 ++--
 crypto/gcm.c                                       | 34 ++++--------
 crypto/salsa20_generic.c                           |  2 +-
 crypto/skcipher.c                                  |  9 +++-
 drivers/char/ipmi/ipmi_ssif.c                      |  6 ++-
 drivers/crypto/rockchip/rk3288_crypto_ablkcipher.c | 25 ++++++---
 drivers/crypto/vmx/aesp8-ppc.pl                    |  4 +-
 drivers/md/bcache/journal.c                        | 11 ++--
 drivers/md/bcache/super.c                          |  2 +-
 drivers/mtd/spi-nor/intel-spi.c                    |  8 +++
 drivers/pci/host/pci-hyperv.c                      | 21 ++++++++
 drivers/power/supply/axp288_charger.c              |  4 ++
 drivers/tty/vt/keyboard.c                          | 33 +++++++++---
 drivers/tty/vt/vt.c                                |  2 -
 fs/btrfs/backref.c                                 | 34 +++++++-----
 fs/ext4/extents.c                                  | 17 +++++-
 fs/ext4/file.c                                     |  7 +++
 fs/ext4/inode.c                                    |  2 +-
 fs/ext4/ioctl.c                                    |  2 +-
 fs/ext4/mballoc.c                                  |  2 +-
 fs/ext4/namei.c                                    |  5 +-
 fs/ext4/resize.c                                   |  1 +
 fs/ext4/super.c                                    | 60 +++++++++++++---------
 fs/ext4/xattr.c                                    |  2 +-
 fs/fs-writeback.c                                  | 11 ++--
 fs/jbd2/journal.c                                  |  4 ++
 fs/ocfs2/export.c                                  | 30 ++++++++++-
 include/linux/list.h                               | 30 +++++++++++
 include/linux/mfd/da9063/registers.h               |  6 +--
 include/linux/mfd/max77620.h                       |  4 +-
 kernel/fork.c                                      | 31 ++++++++++-
 kernel/locking/rwsem-xadd.c                        | 44 +++++++++++-----
 lib/iov_iter.c                                     | 17 +++++-
 mm/mincore.c                                       | 23 ++++++++-
 net/core/fib_rules.c                               |  1 +
 sound/pci/hda/patch_hdmi.c                         | 11 +++-
 sound/pci/hda/patch_realtek.c                      |  5 +-
 sound/soc/codecs/max98090.c                        | 12 ++---
 sound/soc/codecs/rt5677-spi.c                      | 35 ++++++-------
 sound/usb/mixer.c                                  |  2 +
 tools/objtool/check.c                              |  3 +-
 64 files changed, 527 insertions(+), 281 deletions(-)


