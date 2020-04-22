Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37FDB1B3D55
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 12:14:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729473AbgDVKOF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 06:14:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:48330 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726398AbgDVKOE (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Apr 2020 06:14:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 550C12075A;
        Wed, 22 Apr 2020 10:14:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587550442;
        bh=a83MRuGGaAAXdOnRx4YwFGaTpo16fLEHl26N2kPTVpk=;
        h=From:To:Cc:Subject:Date:From;
        b=xeXBDuymwTmobT69KEyOtjs+9d++/uxrVbY5mww7OqggZaSauQpMHFJ+zUxYe4p2L
         QN3wFBC15saGi2kaB+FuxwYFoaA3aoLbuFOz4ghNGpTQ1hIzVYu6XpoKzsYAF9w2QL
         ZaTq4mokr5BHy6kcg1Bz06+GnC+R32IueZtKsN9E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.19 00/64] 4.19.118-rc1 review
Date:   Wed, 22 Apr 2020 11:56:44 +0200
Message-Id: <20200422095008.799686511@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.118-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.118-rc1
X-KernelTest-Deadline: 2020-04-24T09:50+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.19.118 release.
There are 64 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 24 Apr 2020 09:48:23 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.118-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.19.118-rc1

Daniel Borkmann <daniel@iogearbox.net>
    bpf: fix buggy r0 retval refinement for tracing helpers

Waiman Long <longman@redhat.com>
    KEYS: Don't write out to userspace while holding key semaphore

Wen Yang <wenyang@linux.alibaba.com>
    mtd: phram: fix a double free issue in error path

Dan Carpenter <dan.carpenter@oracle.com>
    mtd: lpddr: Fix a double free in probe()

Frieder Schrempf <frieder.schrempf@kontron.de>
    mtd: spinand: Explicitly use MTD_OPS_RAW to write the bad block marker to OOB

Paul E. McKenney <paulmck@kernel.org>
    locktorture: Print ratio of acquisitions, not failures

Stephen Rothwell <sfr@canb.auug.org.au>
    tty: evh_bytechan: Fix out of bounds accesses

Maxime Roussin-Bélanger <maxime.roussinbelanger@gmail.com>
    iio: si1133: read 24-bit signed integer for measurement

Dan Carpenter <dan.carpenter@oracle.com>
    fbdev: potential information leak in do_fb_ioctl()

Florian Fainelli <f.fainelli@gmail.com>
    net: dsa: bcm_sf2: Fix overflow checks

Chao Yu <yuchao0@huawei.com>
    f2fs: fix to wait all node page writeback

Adrian Huang <ahuang12@lenovo.com>
    iommu/amd: Fix the configuration of GCR3 table root pointer

Dan Carpenter <dan.carpenter@oracle.com>
    libnvdimm: Out of bounds read in __nd_ioctl()

Jeffery Miller <jmiller@neverware.com>
    power: supply: axp288_fuel_gauge: Broaden vendor check for Intel Compute Sticks.

Jan Kara <jack@suse.cz>
    ext2: fix debug reference to ext2_xattr_cache

Randy Dunlap <rdunlap@infradead.org>
    ext2: fix empty body warnings when -Wextra is used

Jacob Pan <jacob.jun.pan@linux.intel.com>
    iommu/vt-d: Fix mm reference leak

Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
    drm/vc4: Fix HDMI mode validation

Chao Yu <yuchao0@huawei.com>
    f2fs: fix NULL pointer dereference in f2fs_write_begin()

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFS: Fix memory leaks in nfs_pageio_stop_mirroring()

Jack Zhang <Jack.Zhang1@amd.com>
    drm/amdkfd: kfree the wrong pointer

Qian Cai <cai@lca.pw>
    x86: ACPI: fix CPU hotplug deadlock

David Hildenbrand <david@redhat.com>
    KVM: s390: vsie: Fix possible race when shadowing region 3 tables

Vegard Nossum <vegard.nossum@oracle.com>
    compiler.h: fix error in BUILD_BUG_ON() reporting

Qian Cai <cai@lca.pw>
    percpu_counter: fix a data race at vm_committed_as

Steven Price <steven.price@arm.com>
    include/linux/swapops.h: correct guards for non_swap_entry()

Long Li <longli@microsoft.com>
    cifs: Allocate encryption header through kmalloc

Gabriel Krisman Bertazi <krisman@collabora.com>
    um: ubd: Prevent buffer overrun on command completion

Eric Sandeen <sandeen@redhat.com>
    ext4: do not commit super on read-only bdev

Thomas Richter <tmricht@linux.ibm.com>
    s390/cpum_sf: Fix wrong page count in error message

Nathan Chancellor <natechancellor@gmail.com>
    powerpc/maple: Fix declaration made after definition

Alexander Gordeev <agordeev@linux.ibm.com>
    s390/cpuinfo: fix wrong output when CPU0 is offline

Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
    NFS: direct.c: Fix memory leak of dreq when nfs_get_lock_context fails

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFSv4/pnfs: Return valid stateids in nfs_layout_find_inode_by_stateid()

Alexandre Belloni <alexandre.belloni@bootlin.com>
    rtc: 88pm860x: fix possible race condition

Lucas Stach <l.stach@pengutronix.de>
    soc: imx: gpc: fix power up sequencing

Sowjanya Komatineni <skomatineni@nvidia.com>
    clk: tegra: Fix Tegra PMC clock out parents

Dmitry Osipenko <digetx@gmail.com>
    power: supply: bq27xxx_battery: Silence deferred-probe error

Claudiu Beznea <claudiu.beznea@microchip.com>
    clk: at91: usb: continue if clk_hw_round_rate() return zero

Tianyu Lan <Tianyu.Lan@microsoft.com>
    x86/Hyper-V: Report crash data in die() when panic_on_oops is set

Tianyu Lan <Tianyu.Lan@microsoft.com>
    x86/Hyper-V: Report crash register data when sysctl_record_panic_msg is not set

Tianyu Lan <Tianyu.Lan@microsoft.com>
    x86/Hyper-V: Trigger crash enlightenment only once during system crash.

Tianyu Lan <Tianyu.Lan@microsoft.com>
    x86/Hyper-V: Free hv_panic_page when fail to register kmsg dump

Tianyu Lan <Tianyu.Lan@microsoft.com>
    x86/Hyper-V: Unload vmbus channel in hv panic callback

Magnus Karlsson <magnus.karlsson@intel.com>
    xsk: Add missing check on user supplied headroom size

Ilya Dryomov <idryomov@gmail.com>
    rbd: call rbd_dev_unprobe() after unwatching and flushing notifies

Ilya Dryomov <idryomov@gmail.com>
    rbd: avoid a deadlock on header_rwsem when flushing notifies

Nathan Chancellor <natechancellor@gmail.com>
    video: fbdev: sis: Remove unnecessary parentheses and commented code

ndesaulniers@google.com <ndesaulniers@google.com>
    lib/raid6: use vdupq_n_u8 to avoid endianness warnings

Tianyu Lan <Tianyu.Lan@microsoft.com>
    x86/Hyper-V: Report crash register data or kmsg before running crash kernel

Frank Rowand <frank.rowand@sony.com>
    of: overlay: kmemleak in dup_and_fixup_symbol_prop()

Frank Rowand <frank.rowand@sony.com>
    of: unittest: kmemleak in of_unittest_overlay_high_level()

Frank Rowand <frank.rowand@sony.com>
    of: unittest: kmemleak in of_unittest_platform_populate()

Frank Rowand <frank.rowand@sony.com>
    of: unittest: kmemleak on changeset destroy

Takashi Iwai <tiwai@suse.de>
    ALSA: hda: Don't release card at firmware loading error

Zenghui Yu <yuzenghui@huawei.com>
    irqchip/mbigen: Free msi_desc on device teardown

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: report EOPNOTSUPP on unsupported flags/object type

Martin Fuzzey <martin.fuzzey@flowbird.group>
    ARM: dts: imx6: Use gpc for FEC interrupt controller to fix wake on LAN.

Luke Nelson <lukenels@cs.washington.edu>
    arm, bpf: Fix bugs with ALU64 {RSH, ARSH} BPF_K shift by 0

Michael Walle <michael@walle.cc>
    watchdog: sp805: fix restart handler

Roman Gushchin <guro@fb.com>
    ext4: use non-movable memory for superblock readahead

Li Bin <huawei.libin@huawei.com>
    scsi: sg: add sg_remove_request in sg_common_write

Josh Poimboeuf <jpoimboe@redhat.com>
    objtool: Fix switch table detection in .text.unlikely

Luke Nelson <lukenels@cs.washington.edu>
    arm, bpf: Fix offset overflow for BPF_MEM BPF_DW


-------------

Diffstat:

 Makefile                                 |  4 +-
 arch/arm/boot/dts/imx6qdl.dtsi           |  5 +--
 arch/arm/boot/dts/imx6qp.dtsi            |  1 -
 arch/arm/net/bpf_jit_32.c                | 52 +++++++++++++++--------
 arch/powerpc/platforms/maple/setup.c     | 34 +++++++--------
 arch/s390/kernel/perf_cpum_sf.c          |  1 +
 arch/s390/kernel/processor.c             |  5 ++-
 arch/s390/mm/gmap.c                      |  1 +
 arch/um/drivers/ubd_kern.c               |  4 +-
 arch/x86/hyperv/hv_init.c                |  6 ++-
 arch/x86/include/asm/mshyperv.h          |  2 +-
 arch/x86/kernel/acpi/cstate.c            |  3 +-
 arch/x86/kernel/cpu/mshyperv.c           | 10 +++++
 drivers/acpi/processor_throttling.c      |  7 ---
 drivers/block/rbd.c                      | 25 +++++++----
 drivers/clk/at91/clk-usb.c               |  3 ++
 drivers/clk/tegra/clk-tegra-pmc.c        | 12 +++---
 drivers/gpu/drm/amd/amdkfd/kfd_device.c  |  4 +-
 drivers/gpu/drm/vc4/vc4_hdmi.c           | 20 +++++++--
 drivers/hv/channel_mgmt.c                |  3 ++
 drivers/hv/vmbus_drv.c                   | 60 +++++++++++++++++++-------
 drivers/iio/light/si1133.c               | 37 ++++++++++------
 drivers/iommu/amd_iommu_types.h          |  2 +-
 drivers/iommu/intel-svm.c                |  7 +--
 drivers/irqchip/irq-mbigen.c             |  8 +++-
 drivers/mtd/devices/phram.c              | 15 ++++---
 drivers/mtd/lpddr/lpddr_cmds.c           |  1 -
 drivers/mtd/nand/spi/core.c              |  1 +
 drivers/net/dsa/bcm_sf2_cfp.c            |  9 ++--
 drivers/nvdimm/bus.c                     |  6 ++-
 drivers/of/overlay.c                     |  2 +
 drivers/of/unittest.c                    | 16 +++++--
 drivers/power/supply/axp288_fuel_gauge.c |  4 +-
 drivers/power/supply/bq27xxx_battery.c   |  5 ++-
 drivers/rtc/rtc-88pm860x.c               | 14 +++---
 drivers/scsi/sg.c                        |  4 +-
 drivers/soc/imx/gpc.c                    | 24 ++++++-----
 drivers/tty/ehv_bytechan.c               | 21 +++++++--
 drivers/video/fbdev/core/fbmem.c         |  2 +-
 drivers/video/fbdev/sis/init301.c        |  4 +-
 drivers/watchdog/sp805_wdt.c             |  4 ++
 fs/buffer.c                              | 11 +++++
 fs/cifs/transport.c                      | 28 +++++++-----
 fs/ext2/xattr.c                          |  8 ++--
 fs/ext4/inode.c                          |  2 +-
 fs/ext4/super.c                          |  5 ++-
 fs/f2fs/node.c                           |  7 +--
 fs/f2fs/super.c                          |  5 ++-
 fs/nfs/callback_proc.c                   |  2 +
 fs/nfs/direct.c                          |  2 +
 fs/nfs/pagelist.c                        | 17 ++++----
 include/acpi/processor.h                 |  8 ++++
 include/keys/big_key-type.h              |  2 +-
 include/keys/user-type.h                 |  3 +-
 include/linux/buffer_head.h              |  8 ++++
 include/linux/compiler.h                 |  2 +-
 include/linux/key-type.h                 |  2 +-
 include/linux/percpu_counter.h           |  4 +-
 include/linux/swapops.h                  |  3 +-
 kernel/bpf/verifier.c                    | 45 +++++++++++++++-----
 kernel/locking/locktorture.c             |  8 ++--
 lib/raid6/neon.uc                        |  5 +--
 lib/raid6/recov_neon_inner.c             |  7 +--
 net/dns_resolver/dns_key.c               |  2 +-
 net/netfilter/nf_tables_api.c            |  4 +-
 net/rxrpc/key.c                          | 27 ++++--------
 net/xdp/xdp_umem.c                       |  5 +--
 security/keys/big_key.c                  | 11 ++---
 security/keys/encrypted-keys/encrypted.c |  7 ++-
 security/keys/keyctl.c                   | 73 +++++++++++++++++++++++++-------
 security/keys/keyring.c                  |  6 +--
 security/keys/request_key_auth.c         |  7 ++-
 security/keys/trusted.c                  | 14 +-----
 security/keys/user_defined.c             |  5 +--
 sound/pci/hda/hda_intel.c                | 19 +++------
 tools/objtool/check.c                    |  5 +--
 76 files changed, 508 insertions(+), 309 deletions(-)


