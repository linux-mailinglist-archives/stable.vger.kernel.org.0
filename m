Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 269E223464
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 14:42:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389311AbfETM00 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 08:26:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:41724 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389302AbfETM0V (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 May 2019 08:26:21 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 33EED20815;
        Mon, 20 May 2019 12:26:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558355180;
        bh=5U2Qi4hUO+btsEG2iOxnN1AZ0UWngn9LklTiFp9O8wU=;
        h=From:To:Cc:Subject:Date:From;
        b=pIC8XHpkDI48xIAN4ccRSG2aa1JZ7/J4zg3ZJOGZxHb9Ii23Hp9t0dqM+NXoGyr8s
         n9LHQTAb2FwDzCAGM6opYDMhJoSx5FTAcFB/yKZl58ood+ieY9+MqDbGqPtR4yxVkd
         VK0sRcDxdik5OfhM3f6NzI487HlCJRbtX8B2sPc8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 5.0 000/123] 5.0.18-stable review
Date:   Mon, 20 May 2019 14:13:00 +0200
Message-Id: <20190520115245.439864225@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-5.0.18-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.0.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.0.18-rc1
X-KernelTest-Deadline: 2019-05-22T11:52+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.0.18 release.
There are 123 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed 22 May 2019 11:50:46 AM UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.0.18-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.0.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.0.18-rc1

Andreas Dilger <adilger@dilger.ca>
    ext4: don't update s_rev_level if not required

zhangyi (F) <yi.zhang@huawei.com>
    ext4: fix compile error when using BUFFER_TRACE

Theodore Ts'o <tytso@mit.edu>
    ext4: fix block validity checks for journal inodes using indirect blocks

Colin Ian King <colin.king@canonical.com>
    ext4: unsigned int compared against zero

Martin Schwidefsky <schwidefsky@de.ibm.com>
    s390/mm: convert to the generic get_user_pages_fast code

Martin Schwidefsky <schwidefsky@de.ibm.com>
    s390/mm: make the pxd_offset functions more robust

Eric Dumazet <edumazet@google.com>
    iov_iter: optimize page_copy_sane()

Dan Williams <dan.j.williams@intel.com>
    libnvdimm/namespace: Fix label tracking error

Roger Pau Monne <roger.pau@citrix.com>
    xen/pvh: correctly setup the PV EFI interface for dom0

Roger Pau Monne <roger.pau@citrix.com>
    xen/pvh: set xen_domain_type to HVM in xen_pvh_init

Masahiro Yamada <yamada.masahiro@socionext.com>
    kbuild: turn auto.conf.cmd into a mandatory include file

Sean Christopherson <sean.j.christopherson@intel.com>
    KVM: lapic: Busy wait for timer to expire when using hv_timer

Sean Christopherson <sean.j.christopherson@intel.com>
    KVM: x86: Skip EFER vs. guest CPUID checks for host-initiated writes

Peter Xu <peterx@redhat.com>
    KVM: Fix the bitmap range to copy during clear dirty

Chengguang Xu <cgxu519@gmail.com>
    jbd2: fix potential double free

Michał Wadowski <wadosm@gmail.com>
    ALSA: hda/realtek - Fix for Lenovo B50-70 inverted internal microphone bug

Kailang Yang <kailang@realtek.com>
    ALSA: hda/realtek - Fixup headphone noise via runtime suspend

Jeremy Soller <jeremy@system76.com>
    ALSA: hda/realtek - Corrected fixup for System76 Gazelle (gaze14)

Jan Kara <jack@suse.cz>
    ext4: avoid panic during forced reboot due to aborted journal

Sahitya Tummala <stummala@codeaurora.org>
    ext4: fix use-after-free in dx_release()

Lukas Czerner <lczerner@redhat.com>
    ext4: fix data corruption caused by overlapping unaligned and aligned IO

Sriram Rajagopalan <sriramr@arista.com>
    ext4: zero out the unused memory region in the extent tree block

Anup Patel <Anup.Patel@wdc.com>
    tty: Don't force RISCV SBI console as preferred console

Jiufei Xue <jiufei.xue@linux.alibaba.com>
    fs/writeback.c: use rcu_barrier() to wait for inflight wb switches going into workqueue when umount

Eric Biggers <ebiggers@google.com>
    crypto: ccm - fix incompatibility between "ccm" and "ccm_base"

Kamlakant Patel <kamlakantp@marvell.com>
    ipmi:ssif: compare block number correctly for multi-part return messages

Coly Li <colyli@suse.de>
    bcache: never set KEY_PTRS of journal key to 0 in journal_reclaim()

Liang Chen <liangchen.linux@gmail.com>
    bcache: fix a race between cache register and cacheset unregister

Filipe Manana <fdmanana@suse.com>
    Btrfs: fix race between send and deduplication that lead to failures and crashes

Filipe Manana <fdmanana@suse.com>
    Btrfs: do not start a transaction at iterate_extent_inodes()

Filipe Manana <fdmanana@suse.com>
    Btrfs: do not start a transaction during fiemap

Filipe Manana <fdmanana@suse.com>
    Btrfs: send, flush dellaloc in order to avoid data loss

Nikolay Borisov <nborisov@suse.com>
    btrfs: Honour FITRIM range constraints during free space trim

Nikolay Borisov <nborisov@suse.com>
    btrfs: Correctly free extent buffer in case btree_read_extent_buffer_pages fails

Qu Wenruo <wqu@suse.com>
    btrfs: Check the first key and level for cached extent buffer

Debabrata Banerjee <dbanerje@akamai.com>
    ext4: fix ext4_show_options for file systems w/o journal

Kirill Tkhai <ktkhai@virtuozzo.com>
    ext4: actually request zeroing of inode table after grow

Barret Rhoden <brho@google.com>
    ext4: fix use-after-free race with debug_want_extra_isize

Pan Bian <bianpan2016@163.com>
    ext4: avoid drop reference to iloc.bh twice

Theodore Ts'o <tytso@mit.edu>
    ext4: ignore e_value_offs for xattrs with value-in-ea-inode

Theodore Ts'o <tytso@mit.edu>
    ext4: protect journal inode's blocks using block_validity

Jan Kara <jack@suse.cz>
    ext4: make sanity check in mballoc more strict

Jiufei Xue <jiufei.xue@linux.alibaba.com>
    jbd2: check superblock mapped prior to committing

Sergei Trofimovich <slyfox@gentoo.org>
    tty/vt: fix write/write race in ioctl(KDSKBSENT) handler

Yifeng Li <tomli@tomli.me>
    tty: vt.c: Fix TIOCL_BLANKSCREEN console blanking if blankinterval == 0

Chris Packham <chris.packham@alliedtelesis.co.nz>
    mtd: maps: Allow MTD_PHYSMAP with MTD_RAM

Chris Packham <chris.packham@alliedtelesis.co.nz>
    mtd: maps: physmap: Store gpio_values correctly

Alexander Sverdlin <alexander.sverdlin@nokia.com>
    mtd: spi-nor: intel-spi: Avoid crossing 4K address boundary on read/write

Dmitry Osipenko <digetx@gmail.com>
    mfd: max77620: Fix swapped FPS_PERIOD_MAX_US values

Steve Twiss <stwiss.opensource@diasemi.com>
    mfd: da9063: Fix OTP control register names to match datasheets for DA9063/63L

Rajat Jain <rajatja@google.com>
    ACPI: PM: Set enable_for_wake for wakeup GPEs during suspend-to-idle

Andrea Arcangeli <aarcange@redhat.com>
    userfaultfd: use RCU to free the task struct when fork fails

Shuning Zhang <sunny.s.zhang@oracle.com>
    ocfs2: fix ocfs2 read inode data panic in ocfs2_iget

Mike Kravetz <mike.kravetz@oracle.com>
    hugetlb: use same fault hash key for shared and private mappings

Kai Shen <shenkai8@huawei.com>
    mm/hugetlb.c: don't put_page in lock of hugetlb_lock

Dan Williams <dan.j.williams@intel.com>
    mm/huge_memory: fix vmf_insert_pfn_{pmd, pud}() crash, handle unaligned addresses

Jiri Kosina <jkosina@suse.cz>
    mm/mincore.c: make mincore() more conservative

Ofir Drang <ofir.drang@arm.com>
    crypto: ccree - handle tee fips error during power management resume

Ofir Drang <ofir.drang@arm.com>
    crypto: ccree - add function to handle cryptocell tee fips error

Ofir Drang <ofir.drang@arm.com>
    crypto: ccree - HOST_POWER_DOWN_EN should be the last CC access during suspend

Ofir Drang <ofir.drang@arm.com>
    crypto: ccree - pm resume first enable the source clk

Gilad Ben-Yossef <gilad@benyossef.com>
    crypto: ccree - don't map AEAD key and IV on stack

Gilad Ben-Yossef <gilad@benyossef.com>
    crypto: ccree - use correct internal state sizes for export

Gilad Ben-Yossef <gilad@benyossef.com>
    crypto: ccree - don't map MAC key on stack

Gilad Ben-Yossef <gilad@benyossef.com>
    crypto: ccree - fix mem leak on error path

Gilad Ben-Yossef <gilad@benyossef.com>
    crypto: ccree - remove special handling of chained sg

Daniel Borkmann <daniel@iogearbox.net>
    bpf, arm64: remove prefetch insn in xadd mapping

Libin Yang <libin.yang@intel.com>
    ASoC: codec: hdac_hdmi add device_link to card device

S.j. Wang <shengjiu.wang@nxp.com>
    ASoC: fsl_esai: Fix missing break in switch statement

Curtis Malainey <cujomalainey@chromium.org>
    ASoC: RT5677-SPI: Disable 16Bit SPI Transfers

Jon Hunter <jonathanh@nvidia.com>
    ASoC: max98090: Fix restore of DAPM Muxes

Jeremy Soller <jeremy@system76.com>
    ALSA: hdea/realtek - Headset fixup for System76 Gazelle (gaze14)

Kailang Yang <kailang@realtek.com>
    ALSA: hda/realtek - EAPD turn on later

Hui Wang <hui.wang@canonical.com>
    ALSA: hda/hdmi - Consider eld_valid when reporting jack event

Hui Wang <hui.wang@canonical.com>
    ALSA: hda/hdmi - Read the pin sense from register when repolling

Wenwen Wang <wang6495@umn.edu>
    ALSA: usb-audio: Fix a memory leak bug

Takashi Iwai <tiwai@suse.de>
    ALSA: line6: toneport: Fix broken usage of timer for delayed execution

Adrian Hunter <adrian.hunter@intel.com>
    mmc: sdhci-pci: Fix BYT OCP setting

Raul E Rangel <rrangel@chromium.org>
    mmc: core: Fix tag set memory leak

Sowjanya Komatineni <skomatineni@nvidia.com>
    mmc: tegra: fix ddr signaling for non-ddr modes

Eric Biggers <ebiggers@google.com>
    crypto: arm64/aes-neonbs - don't access already-freed walk.iv

Eric Biggers <ebiggers@google.com>
    crypto: arm/aes-neonbs - don't access already-freed walk.iv

Horia Geantă <horia.geanta@nxp.com>
    crypto: caam/qi2 - generate hash keys in-place

Horia Geantă <horia.geanta@nxp.com>
    crypto: caam/qi2 - fix DMA mapping of stack memory

Horia Geantă <horia.geanta@nxp.com>
    crypto: caam/qi2 - fix zero-length buffer DMA mapping

Zhang Zhijie <zhangzj@rock-chips.com>
    crypto: rockchip - update IV buffer to contain the next IV

Eric Biggers <ebiggers@google.com>
    crypto: gcm - fix incompatibility between "gcm" and "gcm_base"

Eric Biggers <ebiggers@google.com>
    crypto: arm64/gcm-aes-ce - fix no-NEON fallback code

Eric Biggers <ebiggers@google.com>
    crypto: x86/crct10dif-pcl - fix use via crypto_shash_digest()

Eric Biggers <ebiggers@google.com>
    crypto: crct10dif-generic - fix use via crypto_shash_digest()

Eric Biggers <ebiggers@google.com>
    crypto: skcipher - don't WARN on unprocessed data after slow walk step

Daniel Axtens <dja@axtens.net>
    crypto: vmx - fix copy-paste error in CTR mode

Singh, Brijesh <brijesh.singh@amd.com>
    crypto: ccp - Do not free psp_master when PLATFORM_INIT fails

Eric Biggers <ebiggers@google.com>
    crypto: chacha20poly1305 - set cra_name correctly

Eric Biggers <ebiggers@google.com>
    crypto: chacha-generic - fix use as arm64 no-NEON fallback

Eric Biggers <ebiggers@google.com>
    crypto: lrw - don't access already-freed walk.iv

Eric Biggers <ebiggers@google.com>
    crypto: salsa20 - don't access already-freed walk.iv

Christian Lamparter <chunkeey@gmail.com>
    crypto: crypto4xx - fix cfb and ofb "overran dst buffer" issues

Christian Lamparter <chunkeey@gmail.com>
    crypto: crypto4xx - fix ctr-aes missing output IV

Yazen Ghannam <yazen.ghannam@amd.com>
    x86/MCE/AMD: Don't report L1 BTB MCA errors on some family 17h models

Yazen Ghannam <yazen.ghannam@amd.com>
    x86/MCE: Group AMD function prototypes in <asm/mce.h>

Shirish S <Shirish.S@amd.com>
    x86/MCE/AMD: Carve out the MC4_MISC thresholding quirk

Shirish S <Shirish.S@amd.com>
    x86/MCE/AMD: Turn off MC4_MISC thresholding on all family 0x15 models

Yazen Ghannam <yazen.ghannam@amd.com>
    x86/MCE: Add an MCE-record filtering function

Peter Zijlstra <peterz@infradead.org>
    sched/x86: Save [ER]FLAGS on context switch

Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
    arm64: Save and restore OSDLR_EL1 across suspend/resume

Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
    arm64: Clear OSDLR_EL1 on CPU boot

Vincenzo Frascino <vincenzo.frascino@arm.com>
    arm64: compat: Reduce address limit

Will Deacon <will.deacon@arm.com>
    arm64: arch_timer: Ensure counter register reads occur with seqlock held

Boyang Zhou <zhouby_cn@126.com>
    arm64: mmap: Ensure file offset is treated as unsigned

Hans de Goede <hdegoede@redhat.com>
    power: supply: axp288_fuel_gauge: Add ACEPC T8 and T11 mini PCs to the blacklist

Gustavo A. R. Silva <gustavo@embeddedor.com>
    power: supply: axp288_charger: Fix unchecked return value

Wen Yang <wen.yang99@zte.com.cn>
    ARM: exynos: Fix a leaked reference by adding missing of_node_put

Christoph Muellner <christoph.muellner@theobroma-systems.com>
    mmc: sdhci-of-arasan: Add DTS property to disable DCMDs.

Sylwester Nawrocki <s.nawrocki@samsung.com>
    ARM: dts: exynos: Fix audio (microphone) routing on Odroid XU3

Stuart Menefy <stuart.menefy@mathembedded.com>
    ARM: dts: exynos: Fix interrupt for shared EINTs on Exynos5260

Christian Lamparter <chunkeey@gmail.com>
    ARM: dts: qcom: ipq4019: enlarge PCIe BAR range

Christoph Muellner <christoph.muellner@theobroma-systems.com>
    arm64: dts: rockchip: Disable DCMDs on RK3399's eMMC controller.

Katsuhiro Suzuki <katsuhiro@katsuster.net>
    arm64: dts: rockchip: fix IO domain voltage setting of APIO5 on rockpro64

Josh Poimboeuf <jpoimboe@redhat.com>
    objtool: Fix function fallthrough detection

Andy Lutomirski <luto@kernel.org>
    x86/speculation/mds: Improve CPU buffer clear documentation

Andy Lutomirski <luto@kernel.org>
    x86/speculation/mds: Revert CPU buffer clear on double fault exit

Waiman Long <longman@redhat.com>
    locking/rwsem: Prevent decrement of reader count before increment


-------------

Diffstat:

 Documentation/x86/mds.rst                          |  44 +--
 Makefile                                           |   6 +-
 arch/arm/boot/dts/exynos5260.dtsi                  |   2 +-
 arch/arm/boot/dts/exynos5422-odroidxu3-audio.dtsi  |   2 +-
 arch/arm/boot/dts/qcom-ipq4019.dtsi                |   4 +-
 arch/arm/crypto/aes-neonbs-glue.c                  |   2 +
 arch/arm/mach-exynos/firmware.c                    |   1 +
 arch/arm/mach-exynos/suspend.c                     |   2 +
 arch/arm64/boot/dts/rockchip/rk3399-rockpro64.dts  |   2 +-
 arch/arm64/boot/dts/rockchip/rk3399.dtsi           |   1 +
 arch/arm64/crypto/aes-neonbs-glue.c                |   2 +
 arch/arm64/crypto/ghash-ce-glue.c                  |  10 +-
 arch/arm64/include/asm/arch_timer.h                |  33 ++-
 arch/arm64/include/asm/processor.h                 |   8 +
 arch/arm64/kernel/debug-monitors.c                 |   1 +
 arch/arm64/kernel/sys.c                            |   2 +-
 arch/arm64/kernel/vdso/gettimeofday.S              |  15 +-
 arch/arm64/mm/proc.S                               |  34 +--
 arch/arm64/net/bpf_jit.h                           |   6 -
 arch/arm64/net/bpf_jit_comp.c                      |   1 -
 arch/s390/Kconfig                                  |   1 +
 arch/s390/include/asm/pgtable.h                    |  79 ++++--
 arch/s390/mm/Makefile                              |   2 +-
 arch/s390/mm/gup.c                                 | 300 ---------------------
 arch/x86/crypto/crct10dif-pclmul_glue.c            |  13 +-
 arch/x86/entry/entry_32.S                          |   2 +
 arch/x86/entry/entry_64.S                          |   2 +
 arch/x86/include/asm/mce.h                         |  25 +-
 arch/x86/include/asm/switch_to.h                   |   1 +
 arch/x86/kernel/cpu/mce/amd.c                      |  62 +++++
 arch/x86/kernel/cpu/mce/core.c                     |  38 +--
 arch/x86/kernel/cpu/mce/genpool.c                  |   3 +
 arch/x86/kernel/cpu/mce/internal.h                 |   9 +
 arch/x86/kernel/process_32.c                       |   7 +
 arch/x86/kernel/process_64.c                       |   8 +
 arch/x86/kernel/traps.c                            |   8 -
 arch/x86/kvm/lapic.c                               |   2 +-
 arch/x86/kvm/x86.c                                 |  37 ++-
 arch/x86/platform/pvh/enlighten.c                  |   8 +-
 arch/x86/xen/efi.c                                 |  12 +-
 arch/x86/xen/enlighten_pv.c                        |   2 +-
 arch/x86/xen/enlighten_pvh.c                       |   7 +-
 arch/x86/xen/xen-ops.h                             |   4 +-
 crypto/ccm.c                                       |  44 ++-
 crypto/chacha20poly1305.c                          |   4 +-
 crypto/chacha_generic.c                            |   2 +-
 crypto/crct10dif_generic.c                         |  11 +-
 crypto/gcm.c                                       |  34 +--
 crypto/lrw.c                                       |   4 +-
 crypto/salsa20_generic.c                           |   2 +-
 crypto/skcipher.c                                  |   9 +-
 drivers/acpi/sleep.c                               |   4 +
 drivers/char/ipmi/ipmi_ssif.c                      |   6 +-
 drivers/crypto/amcc/crypto4xx_alg.c                |  12 +-
 drivers/crypto/amcc/crypto4xx_core.c               |  31 ++-
 drivers/crypto/caam/caamalg_qi2.c                  | 177 ++++++------
 drivers/crypto/caam/caamalg_qi2.h                  |   2 -
 drivers/crypto/ccp/psp-dev.c                       |   2 +-
 drivers/crypto/ccree/cc_aead.c                     |  11 +-
 drivers/crypto/ccree/cc_buffer_mgr.c               | 113 +++-----
 drivers/crypto/ccree/cc_driver.h                   |   1 +
 drivers/crypto/ccree/cc_fips.c                     |  23 +-
 drivers/crypto/ccree/cc_fips.h                     |   2 +
 drivers/crypto/ccree/cc_hash.c                     |  28 +-
 drivers/crypto/ccree/cc_ivgen.c                    |   9 +-
 drivers/crypto/ccree/cc_pm.c                       |   9 +-
 drivers/crypto/rockchip/rk3288_crypto_ablkcipher.c |  25 +-
 drivers/crypto/vmx/aesp8-ppc.pl                    |   4 +-
 drivers/dax/device.c                               |   6 +-
 drivers/edac/mce_amd.c                             |   4 +-
 drivers/md/bcache/journal.c                        |  11 +-
 drivers/md/bcache/super.c                          |   2 +-
 drivers/mmc/core/queue.c                           |   1 +
 drivers/mmc/host/Kconfig                           |   1 +
 drivers/mmc/host/sdhci-of-arasan.c                 |   5 +-
 drivers/mmc/host/sdhci-pci-core.c                  |  96 +++++++
 drivers/mmc/host/sdhci-tegra.c                     |   1 +
 drivers/mtd/maps/Kconfig                           |   2 +-
 drivers/mtd/maps/physmap-core.c                    |   2 +
 drivers/mtd/spi-nor/intel-spi.c                    |   8 +
 drivers/nvdimm/label.c                             |  29 +-
 drivers/nvdimm/namespace_devs.c                    |  15 ++
 drivers/nvdimm/nd.h                                |   4 +
 drivers/power/supply/axp288_charger.c              |   4 +
 drivers/power/supply/axp288_fuel_gauge.c           |  20 ++
 drivers/tty/hvc/hvc_riscv_sbi.c                    |   1 -
 drivers/tty/vt/keyboard.c                          |  33 ++-
 drivers/tty/vt/vt.c                                |   2 -
 fs/btrfs/backref.c                                 |  34 ++-
 fs/btrfs/ctree.c                                   |  10 +
 fs/btrfs/ctree.h                                   |   6 +
 fs/btrfs/disk-io.c                                 |  27 +-
 fs/btrfs/disk-io.h                                 |   3 +
 fs/btrfs/extent-tree.c                             |  25 +-
 fs/btrfs/ioctl.c                                   |  19 +-
 fs/btrfs/send.c                                    |  62 +++++
 fs/dax.c                                           |   6 +-
 fs/ext4/block_validity.c                           |  54 ++++
 fs/ext4/ext4.h                                     |   6 +-
 fs/ext4/extents.c                                  |  17 +-
 fs/ext4/file.c                                     |   7 +
 fs/ext4/inode.c                                    |   7 +-
 fs/ext4/ioctl.c                                    |   2 +-
 fs/ext4/mballoc.c                                  |   2 +-
 fs/ext4/namei.c                                    |   5 +-
 fs/ext4/resize.c                                   |   1 +
 fs/ext4/super.c                                    |  63 +++--
 fs/ext4/xattr.c                                    |   2 +-
 fs/fs-writeback.c                                  |  11 +-
 fs/hugetlbfs/inode.c                               |   7 +-
 fs/jbd2/journal.c                                  |  53 ++--
 fs/jbd2/revoke.c                                   |  32 ++-
 fs/jbd2/transaction.c                              |   8 +-
 fs/ocfs2/export.c                                  |  30 ++-
 include/linux/huge_mm.h                            |   6 +-
 include/linux/hugetlb.h                            |   4 +-
 include/linux/jbd2.h                               |   8 +-
 include/linux/mfd/da9063/registers.h               |   6 +-
 include/linux/mfd/max77620.h                       |   4 +-
 kernel/fork.c                                      |  31 ++-
 kernel/locking/rwsem-xadd.c                        |  44 ++-
 lib/iov_iter.c                                     |  17 +-
 mm/huge_memory.c                                   |  16 +-
 mm/hugetlb.c                                       |  25 +-
 mm/mincore.c                                       |  23 +-
 mm/userfaultfd.c                                   |   3 +-
 sound/pci/hda/patch_hdmi.c                         |  11 +-
 sound/pci/hda/patch_realtek.c                      |  68 +++--
 sound/soc/codecs/hdac_hdmi.c                       |  11 +
 sound/soc/codecs/max98090.c                        |  12 +-
 sound/soc/codecs/rt5677-spi.c                      |  35 ++-
 sound/soc/fsl/fsl_esai.c                           |   2 +-
 sound/usb/line6/toneport.c                         |  16 +-
 sound/usb/mixer.c                                  |   2 +
 tools/objtool/check.c                              |   3 +-
 virt/kvm/kvm_main.c                                |   2 +-
 136 files changed, 1421 insertions(+), 1053 deletions(-)


