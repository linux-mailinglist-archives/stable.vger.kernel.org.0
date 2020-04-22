Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 864721B4065
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 12:46:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730173AbgDVKpx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 06:45:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:54056 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729539AbgDVKRp (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Apr 2020 06:17:45 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 864512070B;
        Wed, 22 Apr 2020 10:17:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587550663;
        bh=0/IIGQx9AjEvJSZQZW2XVoJ5DUoXpqIOruNkAhVbtLw=;
        h=From:To:Cc:Subject:Date:From;
        b=EQThf6UeIkZUa+lpumxsKeZUxc/pwW5Gt5PsVWJ+7btTFzaoUmh5qiiEUpJeOEDt7
         bo672VxbFVXgELnzjZ8BV/KpPif0AIfa/ArASlJtAWk05ROfaY1imnXKp99WXZepJ1
         SpfcfTH1VT6uxUBDkSm91Za+TxgkooCbi/98jpBs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 5.4 000/118] 5.4.35-rc1 review
Date:   Wed, 22 Apr 2020 11:56:01 +0200
Message-Id: <20200422095031.522502705@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-5.4.35-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.35-rc1
X-KernelTest-Deadline: 2020-04-24T09:50+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.4.35 release.
There are 118 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 24 Apr 2020 09:48:23 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.35-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.4.35-rc1

Daniel Borkmann <daniel@iogearbox.net>
    bpf, test_verifier: switch bpf_get_stack's 0 s> r8 test

John Fastabend <john.fastabend@gmail.com>
    bpf: Test_progs, add test to catch retval refine error handling

John Fastabend <john.fastabend@gmail.com>
    bpf: Test_verifier, bpf_get_stack return value add <0

Daniel Borkmann <daniel@iogearbox.net>
    bpf: fix buggy r0 retval refinement for tracing helpers

Waiman Long <longman@redhat.com>
    KEYS: Don't write out to userspace while holding key semaphore

Wen Yang <wenyang@linux.alibaba.com>
    mtd: phram: fix a double free issue in error path

Dan Carpenter <dan.carpenter@oracle.com>
    mtd: lpddr: Fix a double free in probe()

Jonathan Neuschäfer <j.neuschaefer@gmx.net>
    docs: Fix path to MTD command line partition parser

Frieder Schrempf <frieder.schrempf@kontron.de>
    mtd: spinand: Explicitly use MTD_OPS_RAW to write the bad block marker to OOB

Christophe Kerello <christophe.kerello@st.com>
    mtd: rawnand: free the nand_device object

Paul E. McKenney <paulmck@kernel.org>
    locktorture: Print ratio of acquisitions, not failures

Stephen Rothwell <sfr@canb.auug.org.au>
    tty: evh_bytechan: Fix out of bounds accesses

Nathan Chancellor <natechancellor@gmail.com>
    fbmem: Adjust indentation in fb_prepare_logo and fb_blank

Maxime Roussin-Bélanger <maxime.roussinbelanger@gmail.com>
    iio: si1133: read 24-bit signed integer for measurement

Jernej Skrabec <jernej.skrabec@siol.net>
    ARM: dts: sunxi: Fix DE2 clocks register range

Dan Carpenter <dan.carpenter@oracle.com>
    fbdev: potential information leak in do_fb_ioctl()

Grygorii Strashko <grygorii.strashko@ti.com>
    dma-debug: fix displaying of dma allocation type

Florian Fainelli <f.fainelli@gmail.com>
    net: dsa: bcm_sf2: Fix overflow checks

Ben Skeggs <bskeggs@redhat.com>
    drm/nouveau/gr/gp107,gp108: implement workaround for HW hanging during init

Chao Yu <chao@kernel.org>
    f2fs: fix to wait all node page writeback

Adrian Huang <ahuang12@lenovo.com>
    iommu/amd: Fix the configuration of GCR3 table root pointer

Dan Carpenter <dan.carpenter@oracle.com>
    libnvdimm: Out of bounds read in __nd_ioctl()

Jeffery Miller <jmiller@neverware.com>
    power: supply: axp288_fuel_gauge: Broaden vendor check for Intel Compute Sticks.

Guo Ren <guoren@linux.alibaba.com>
    csky: Fixup init_fpu compile warning with __init

Chuck Lever <chuck.lever@oracle.com>
    sunrpc: Fix gss_unwrap_resp_integ() again

Jan Kara <jack@suse.cz>
    ext2: fix debug reference to ext2_xattr_cache

Jacob Pan <jacob.jun.pan@linux.intel.com>
    iommu/vt-d: Fix page request descriptor size

Qian Cai <cai@lca.pw>
    iommu/vt-d: Silence RCU-list debugging warning in dmar_find_atsr()

Randy Dunlap <rdunlap@infradead.org>
    ext2: fix empty body warnings when -Wextra is used

Olga Kornievskaia <olga.kornievskaia@gmail.com>
    SUNRPC: fix krb5p mount to provide large enough buffer in rq_rcvsize

Jacob Pan <jacob.jun.pan@linux.intel.com>
    iommu/vt-d: Fix mm reference leak

Jean-Philippe Brucker <jean-philippe@linaro.org>
    iommu/virtio: Fix freeing of incomplete domains

Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
    drm/vc4: Fix HDMI mode validation

Alan Maguire <alan.maguire@oracle.com>
    um: falloc.h needs to be directly included for older libc

Bob Moore <robert.moore@intel.com>
    ACPICA: Fixes for acpiExec namespace init file

Chao Yu <chao@kernel.org>
    f2fs: fix NULL pointer dereference in f2fs_write_begin()

Guo Ren <guoren@linux.alibaba.com>
    csky: Fixup get wrong psr value from phyical reg

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFS: Fix memory leaks in nfs_pageio_stop_mirroring()

Jack Zhang <Jack.Zhang1@amd.com>
    drm/amdkfd: kfree the wrong pointer

Guo Ren <guoren@linux.alibaba.com>
    csky: Fixup cpu speculative execution to IO area

Qian Cai <cai@lca.pw>
    x86: ACPI: fix CPU hotplug deadlock

Ricardo Ribalda Delgado <ribalda@kernel.org>
    leds: core: Fix warning message when init_data

Karol Herbst <kherbst@redhat.com>
    drm/nouveau: workaround runpm fail by disabling PCI power management on certain intel bridges

David Hildenbrand <david@redhat.com>
    KVM: s390: vsie: Fix possible race when shadowing region 3 tables

Vegard Nossum <vegard.nossum@oracle.com>
    compiler.h: fix error in BUILD_BUG_ON() reporting

Qian Cai <cai@lca.pw>
    percpu_counter: fix a data race at vm_committed_as

Steven Price <steven.price@arm.com>
    include/linux/swapops.h: correct guards for non_swap_entry()

Ralph Campbell <rcampbell@nvidia.com>
    drm/nouveau/svm: fix vma range check for migration

Ralph Campbell <rcampbell@nvidia.com>
    drm/nouveau/svm: check for SVM initialized before migrating

Christophe Leroy <christophe.leroy@c-s.fr>
    mm/hugetlb: fix build failure with HUGETLB_PAGE but not HUGEBTLBFS

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

Alexey Kardashevskiy <aik@ozlabs.ru>
    powerpc/prom_init: Pass the "os-term" message to hypervisor

Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
    btrfs: add RCU locks around block group initialization

Domenico Andreoli <domenico.andreoli@linux.com>
    hibernate: Allow uswsusp to write to swap

Alexander Gordeev <agordeev@linux.ibm.com>
    s390/cpuinfo: fix wrong output when CPU0 is offline

Sahitya Tummala <stummala@codeaurora.org>
    f2fs: Add a new CP flag to help fsck fix resize SPO issues

Sahitya Tummala <stummala@codeaurora.org>
    f2fs: Fix mount failure due to SPO after a successful online resize FS

Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
    NFS: direct.c: Fix memory leak of dreq when nfs_get_lock_context fails

Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
    phy: uniphier-usb3ss: Add Pro5 support

Chao Yu <chao@kernel.org>
    f2fs: fix to show norecovery mount option

Michael Roth <mdroth@linux.vnet.ibm.com>
    KVM: PPC: Book3S HV: Fix H_CEDE return code for nested guests

Johan Jonker <jbx6244@gmail.com>
    ARM: dts: rockchip: fix lvds-encoder ports subnode for rk3188-bqedison2qc

Murphy Zhou <jencce.kernel@gmail.com>
    NFSv4.2: error out when relink swapfile

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFSv4/pnfs: Return valid stateids in nfs_layout_find_inode_by_stateid()

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFS: alloc_nfs_open_context() must use the file cred when available

Alexandre Belloni <alexandre.belloni@bootlin.com>
    rtc: 88pm860x: fix possible race condition

Kevin Grandemange <kevin.grandemange@allegrodvt.com>
    dma-coherent: fix integer overflow in the reserved-memory dma allocation

Lucas Stach <l.stach@pengutronix.de>
    soc: imx: gpc: fix power up sequencing

Russell King <rmk+kernel@armlinux.org.uk>
    arm64: dts: clearfog-gt-8k: set gigabit PHY reset deassert delay

Jon Hunter <jonathanh@nvidia.com>
    arm64: tegra: Fix Tegra194 PCIe compatible string

Vidya Sagar <vidyas@nvidia.com>
    arm64: tegra: Add PCIe endpoint controllers nodes for Tegra194

Sowjanya Komatineni <skomatineni@nvidia.com>
    clk: tegra: Fix Tegra PMC clock out parents

Dmitry Osipenko <digetx@gmail.com>
    power: supply: bq27xxx_battery: Silence deferred-probe error

Jernej Skrabec <jernej.skrabec@siol.net>
    arm64: dts: allwinner: a64: Fix display clock register range

Johan Jonker <jbx6244@gmail.com>
    ARM: dts: rockchip: fix vqmmc-supply property name for rk3188-bqedison2qc

Sahitya Tummala <stummala@codeaurora.org>
    f2fs: fix the panic in do_checkpoint()

Aya Levin <ayal@mellanox.com>
    net/mlx5e: Enforce setting of a single FEC mode

Claudiu Beznea <claudiu.beznea@microchip.com>
    clk: at91: usb: continue if clk_hw_round_rate() return zero

Stephen Boyd <sboyd@kernel.org>
    clk: Don't cache errors from clk_ops::get_phase()

xinhui pan <xinhui.pan@amd.com>
    drm/ttm: flush the fence on the bo after we individualize the reservation object

Tianyu Lan <Tianyu.Lan@microsoft.com>
    x86/Hyper-V: Free hv_panic_page when fail to register kmsg dump

Ilya Dryomov <idryomov@gmail.com>
    rbd: call rbd_dev_unprobe() after unwatching and flushing notifies

Ilya Dryomov <idryomov@gmail.com>
    rbd: avoid a deadlock on header_rwsem when flushing notifies

Paolo Valente <paolo.valente@linaro.org>
    block, bfq: invoke flush_idle_tree after reparent_active_queues in pd_offline

Paolo Valente <paolo.valente@linaro.org>
    block, bfq: make reparent_leaf_entity actually work only on leaf entities

Paolo Valente <paolo.valente@linaro.org>
    block, bfq: turn put_queue into release_process_ref in __bfq_bic_change_cgroup

David Howells <dhowells@redhat.com>
    afs: Fix race between post-modification dir edit and readdir/d_revalidate

David Howells <dhowells@redhat.com>
    afs: Fix afs_d_validate() to set the right directory version

David Howells <dhowells@redhat.com>
    afs: Fix rename operation status delivery

David Howells <dhowells@redhat.com>
    afs: Fix decoding of inline abort codes from version 1 status records

David Howells <dhowells@redhat.com>
    afs: Fix missing XDR advance in xdr_decode_{AFS,YFS}FSFetchStatus()

Tianyu Lan <Tianyu.Lan@microsoft.com>
    x86/Hyper-V: Report crash data in die() when panic_on_oops is set

Tianyu Lan <Tianyu.Lan@microsoft.com>
    x86/Hyper-V: Report crash register data when sysctl_record_panic_msg is not set

Tianyu Lan <Tianyu.Lan@microsoft.com>
    x86/Hyper-V: Report crash register data or kmsg before running crash kernel

Tianyu Lan <Tianyu.Lan@microsoft.com>
    x86/Hyper-V: Trigger crash enlightenment only once during system crash.

Tianyu Lan <Tianyu.Lan@microsoft.com>
    x86/Hyper-V: Unload vmbus channel in hv panic callback

Frank Rowand <frank.rowand@sony.com>
    of: overlay: kmemleak in dup_and_fixup_symbol_prop()

Frank Rowand <frank.rowand@sony.com>
    of: unittest: kmemleak in of_unittest_overlay_high_level()

Frank Rowand <frank.rowand@sony.com>
    of: unittest: kmemleak in of_unittest_platform_populate()

Frank Rowand <frank.rowand@sony.com>
    of: unittest: kmemleak on changeset destroy

Magnus Karlsson <magnus.karlsson@intel.com>
    xsk: Add missing check on user supplied headroom size

Takashi Iwai <tiwai@suse.de>
    ALSA: hda: Don't release card at firmware loading error

Zenghui Yu <yuzenghui@huawei.com>
    irqchip/mbigen: Free msi_desc on device teardown

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: report EOPNOTSUPP on unsupported flags/object type

Slava Bacherikov <slava@bacher09.org>
    kbuild, btf: Fix dependencies for DEBUG_INFO_BTF

Martin Fuzzey <martin.fuzzey@flowbird.group>
    ARM: dts: imx6: Use gpc for FEC interrupt controller to fix wake on LAN.

Takashi Iwai <tiwai@suse.de>
    ALSA: hda: Honor PM disablement in PM freeze and thaw_noirq ops

Li Bin <huawei.libin@huawei.com>
    scsi: sg: add sg_remove_request in sg_common_write

Josh Poimboeuf <jpoimboe@redhat.com>
    objtool: Fix switch table detection in .text.unlikely

Luke Nelson <lukenels@cs.washington.edu>
    arm, bpf: Fix offset overflow for BPF_MEM BPF_DW

Luke Nelson <lukenels@cs.washington.edu>
    arm, bpf: Fix bugs with ALU64 {RSH, ARSH} BPF_K shift by 0

Li RongQing <lirongqing@baidu.com>
    xsk: Fix out of boundary write in __xsk_rcv_memcpy

Michael Walle <michael@walle.cc>
    watchdog: sp805: fix restart handler

Roman Gushchin <guro@fb.com>
    ext4: use non-movable memory for superblock readahead


-------------

Diffstat:

 Documentation/admin-guide/kernel-parameters.txt    |   2 +-
 .../bindings/pci/nvidia,tegra194-pcie.txt          |   2 +-
 Makefile                                           |   4 +-
 arch/arm/boot/dts/imx6qdl.dtsi                     |   5 +-
 arch/arm/boot/dts/imx6qp.dtsi                      |   1 -
 arch/arm/boot/dts/rk3188-bqedison2qc.dts           |  29 +++---
 arch/arm/boot/dts/sun8i-a83t.dtsi                  |   2 +-
 arch/arm/boot/dts/sun8i-r40.dtsi                   |   2 +-
 arch/arm/boot/dts/sun8i-v3s.dtsi                   |   2 +-
 arch/arm/boot/dts/sunxi-h3-h5.dtsi                 |   2 +-
 arch/arm/net/bpf_jit_32.c                          |  52 ++++++----
 arch/arm64/boot/dts/allwinner/sun50i-a64.dtsi      |   2 +-
 .../dts/marvell/armada-8040-clearfog-gt-8k.dts     |   1 +
 arch/arm64/boot/dts/nvidia/tegra194.dtsi           | 111 +++++++++++++++++++--
 arch/csky/abiv1/inc/abi/entry.h                    |   5 +-
 arch/csky/abiv2/fpu.c                              |   5 -
 arch/csky/abiv2/inc/abi/entry.h                    |   7 +-
 arch/csky/abiv2/inc/abi/fpu.h                      |   3 +-
 arch/csky/include/asm/processor.h                  |   1 +
 arch/csky/kernel/head.S                            |   5 +
 arch/csky/kernel/setup.c                           |  63 +++---------
 arch/csky/kernel/smp.c                             |   6 ++
 arch/csky/kernel/traps.c                           |  11 +-
 arch/csky/mm/fault.c                               |   7 ++
 arch/powerpc/kernel/prom_init.c                    |   3 +
 arch/powerpc/kvm/book3s_hv.c                       |   1 +
 arch/powerpc/platforms/maple/setup.c               |  34 +++----
 arch/s390/kernel/perf_cpum_sf.c                    |   1 +
 arch/s390/kernel/processor.c                       |   5 +-
 arch/s390/mm/gmap.c                                |   1 +
 arch/um/drivers/ubd_kern.c                         |   4 +-
 arch/um/os-Linux/file.c                            |   1 +
 arch/x86/hyperv/hv_init.c                          |   6 +-
 arch/x86/kernel/acpi/cstate.c                      |   3 +-
 arch/x86/kernel/cpu/mshyperv.c                     |  10 ++
 block/bfq-cgroup.c                                 |  73 ++++++++------
 block/bfq-iosched.c                                |   2 -
 block/bfq-iosched.h                                |   1 +
 drivers/acpi/acpica/acnamesp.h                     |   2 +
 drivers/acpi/acpica/dbinput.c                      |  16 ++-
 drivers/acpi/acpica/dswexec.c                      |  33 ++++++
 drivers/acpi/acpica/dswload.c                      |   2 -
 drivers/acpi/acpica/dswload2.c                     |  35 +++++++
 drivers/acpi/acpica/nsnames.c                      |   6 +-
 drivers/acpi/acpica/utdelete.c                     |   9 +-
 drivers/acpi/processor_throttling.c                |   7 --
 drivers/block/rbd.c                                |  25 +++--
 drivers/clk/at91/clk-usb.c                         |   3 +
 drivers/clk/clk.c                                  |  48 ++++++---
 drivers/clk/tegra/clk-tegra-pmc.c                  |  12 +--
 drivers/gpu/drm/amd/amdkfd/kfd_device.c            |   4 +-
 drivers/gpu/drm/nouveau/nouveau_drm.c              |  63 ++++++++++++
 drivers/gpu/drm/nouveau/nouveau_drv.h              |   2 +
 drivers/gpu/drm/nouveau/nouveau_svm.c              |   6 ++
 drivers/gpu/drm/nouveau/nvkm/engine/gr/gf100.c     |  26 +++++
 drivers/gpu/drm/ttm/ttm_bo.c                       |   4 +-
 drivers/gpu/drm/vc4/vc4_hdmi.c                     |  20 +++-
 drivers/hv/channel_mgmt.c                          |   3 +
 drivers/hv/vmbus_drv.c                             |  62 ++++++++----
 drivers/iio/light/si1133.c                         |  37 ++++---
 drivers/iommu/amd_iommu_types.h                    |   2 +-
 drivers/iommu/intel-iommu.c                        |   3 +-
 drivers/iommu/intel-svm.c                          |   9 +-
 drivers/iommu/virtio-iommu.c                       |  16 +--
 drivers/irqchip/irq-mbigen.c                       |   8 +-
 drivers/leds/led-class.c                           |   2 +-
 drivers/mtd/devices/phram.c                        |  15 +--
 drivers/mtd/lpddr/lpddr_cmds.c                     |   1 -
 drivers/mtd/nand/raw/nand_base.c                   |   2 +
 drivers/mtd/nand/spi/core.c                        |   1 +
 drivers/net/dsa/bcm_sf2_cfp.c                      |   9 +-
 .../net/ethernet/mellanox/mlx5/core/en_ethtool.c   |   4 +
 drivers/nvdimm/bus.c                               |   6 +-
 drivers/of/overlay.c                               |   2 +
 drivers/of/unittest.c                              |  16 ++-
 drivers/phy/socionext/phy-uniphier-usb3ss.c        |   4 +
 drivers/power/supply/axp288_fuel_gauge.c           |   4 +-
 drivers/power/supply/bq27xxx_battery.c             |   5 +-
 drivers/rtc/rtc-88pm860x.c                         |  14 +--
 drivers/scsi/sg.c                                  |   4 +-
 drivers/soc/imx/gpc.c                              |  24 +++--
 drivers/tty/ehv_bytechan.c                         |  21 +++-
 drivers/video/fbdev/core/fbmem.c                   |  38 +++----
 drivers/watchdog/sp805_wdt.c                       |   4 +
 fs/afs/dir.c                                       | 108 ++++++++++++--------
 fs/afs/dir_silly.c                                 |  22 ++--
 fs/afs/fsclient.c                                  |  27 +++--
 fs/afs/yfsclient.c                                 |  20 ++--
 fs/block_dev.c                                     |   4 +-
 fs/btrfs/block-group.c                             |   2 +
 fs/buffer.c                                        |  11 ++
 fs/cifs/transport.c                                |  28 ++++--
 fs/ext2/xattr.c                                    |   8 +-
 fs/ext4/inode.c                                    |   2 +-
 fs/ext4/super.c                                    |   5 +-
 fs/f2fs/checkpoint.c                               |  24 +++--
 fs/f2fs/f2fs.h                                     |   3 +-
 fs/f2fs/gc.c                                       |   6 ++
 fs/f2fs/node.c                                     |   7 +-
 fs/f2fs/super.c                                    |  14 ++-
 fs/nfs/callback_proc.c                             |   2 +
 fs/nfs/direct.c                                    |   2 +
 fs/nfs/inode.c                                     |  10 +-
 fs/nfs/nfs4file.c                                  |   3 +
 fs/nfs/pagelist.c                                  |  17 ++--
 include/acpi/processor.h                           |   8 ++
 include/asm-generic/mshyperv.h                     |   2 +-
 include/keys/big_key-type.h                        |   2 +-
 include/keys/user-type.h                           |   3 +-
 include/linux/buffer_head.h                        |   8 ++
 include/linux/compiler.h                           |   2 +-
 include/linux/f2fs_fs.h                            |   1 +
 include/linux/hugetlb.h                            |  19 ++--
 include/linux/key-type.h                           |   2 +-
 include/linux/percpu_counter.h                     |   4 +-
 include/linux/swapops.h                            |   3 +-
 kernel/bpf/verifier.c                              |  45 +++++++--
 kernel/dma/coherent.c                              |  13 +--
 kernel/dma/debug.c                                 |   9 +-
 kernel/locking/locktorture.c                       |   8 +-
 lib/Kconfig.debug                                  |   2 +
 net/dns_resolver/dns_key.c                         |   2 +-
 net/netfilter/nf_tables_api.c                      |   4 +-
 net/rxrpc/key.c                                    |  27 ++---
 net/sunrpc/auth_gss/auth_gss.c                     |  80 +++++++++++----
 net/xdp/xdp_umem.c                                 |   5 +-
 net/xdp/xsk.c                                      |   5 +-
 security/keys/big_key.c                            |  11 +-
 security/keys/encrypted-keys/encrypted.c           |   7 +-
 security/keys/keyctl.c                             |  73 +++++++++++---
 security/keys/keyring.c                            |   6 +-
 security/keys/request_key_auth.c                   |   7 +-
 security/keys/trusted.c                            |  14 +--
 security/keys/user_defined.c                       |   5 +-
 sound/pci/hda/hda_intel.c                          |  23 ++---
 tools/objtool/check.c                              |   5 +-
 .../selftests/bpf/prog_tests/get_stack_raw_tp.c    |   5 +
 .../selftests/bpf/progs/test_get_stack_rawtp_err.c |  26 +++++
 .../testing/selftests/bpf/verifier/bpf_get_stack.c |   8 +-
 139 files changed, 1263 insertions(+), 620 deletions(-)


