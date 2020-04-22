Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45DAC1B3F7D
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 12:39:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728059AbgDVKiJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 06:38:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:58404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729680AbgDVKWI (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Apr 2020 06:22:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0286A20784;
        Wed, 22 Apr 2020 10:21:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587550918;
        bh=WoMBVJhpXRSmUWp44m30nf5+66JksdOn3ZtOkZrVbeU=;
        h=From:To:Cc:Subject:Date:From;
        b=SLstquyHQme36n9s7MRTukxSoY6Ri7JhAlmGYw9yqkoisIRKJB+g2JdhxgPn5dPiV
         YvjDvPtHgPhEyWK8wY5wFVqj5IOGk9XGLQ3qeEuYgF6Ch9S6HJQER61cCyHoJAaqXh
         DV6/HrluTsMZTLIeMC47efCRpc/L/mpQj2V6h9Qo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 5.6 000/166] 5.6.7-rc1 review
Date:   Wed, 22 Apr 2020 11:55:27 +0200
Message-Id: <20200422095047.669225321@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-5.6.7-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.6.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.6.7-rc1
X-KernelTest-Deadline: 2020-04-24T09:51+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.6.7 release.
There are 166 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 24 Apr 2020 09:48:23 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.6.7-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.6.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.6.7-rc1

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

Colin Ian King <colin.king@canonical.com>
    iio: st_sensors: handle memory allocation failure to fix null pointer dereference

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

Aurelien Aptel <aaptel@suse.com>
    cifs: ignore cached share root handle closing errors

Florian Fainelli <f.fainelli@gmail.com>
    net: dsa: bcm_sf2: Fix overflow checks

Ben Skeggs <bskeggs@redhat.com>
    drm/nouveau/gr/gp107,gp108: implement workaround for HW hanging during init

Yicheng Li <yichengli@chromium.org>
    platform/chrome: cros_ec: Query EC protocol version if EC transitions between RO/RW

Chao Yu <chao@kernel.org>
    f2fs: fix to wait all node page writeback

Eric Biggers <ebiggers@google.com>
    f2fs: fix leaking uninitialized memory in compressed clusters

Adrian Huang <ahuang12@lenovo.com>
    iommu/amd: Fix the configuration of GCR3 table root pointer

Dan Carpenter <dan.carpenter@oracle.com>
    libnvdimm: Out of bounds read in __nd_ioctl()

Jeffery Miller <jmiller@neverware.com>
    power: supply: axp288_fuel_gauge: Broaden vendor check for Intel Compute Sticks.

Guo Ren <guoren@linux.alibaba.com>
    csky: Fixup init_fpu compile warning with __init

Yuantian Tang <andy.tang@nxp.com>
    thermal: qoriq: Fix a compiling issue

Chuck Lever <chuck.lever@oracle.com>
    sunrpc: Fix gss_unwrap_resp_integ() again

Jan Kara <jack@suse.cz>
    ext2: fix debug reference to ext2_xattr_cache

Jacob Pan <jacob.jun.pan@linux.intel.com>
    iommu/vt-d: Fix page request descriptor size

Qian Cai <cai@lca.pw>
    iommu/vt-d: Silence RCU-list debugging warning in dmar_find_atsr()

Jaegeuk Kim <jaegeuk@kernel.org>
    f2fs: skip GC when section is full

Chao Yu <chao@kernel.org>
    f2fs: fix to account compressed blocks in f2fs_compressed_blocks()

Randy Dunlap <rdunlap@infradead.org>
    ext2: fix empty body warnings when -Wextra is used

David Hildenbrand <david@redhat.com>
    virtio-balloon: Switch back to OOM handler for VIRTIO_BALLOON_F_DEFLATE_ON_OOM

Olga Kornievskaia <olga.kornievskaia@gmail.com>
    SUNRPC: fix krb5p mount to provide large enough buffer in rq_rcvsize

Jacob Pan <jacob.jun.pan@linux.intel.com>
    iommu/vt-d: Fix mm reference leak

Jacob Pan <jacob.jun.pan@linux.intel.com>
    iommu/vt-d: Add build dependency on IOASID

Jean-Philippe Brucker <jean-philippe@linaro.org>
    iommu/virtio: Fix freeing of incomplete domains

Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
    drm/vc4: Fix HDMI mode validation

Alan Maguire <alan.maguire@oracle.com>
    um: falloc.h needs to be directly included for older libc

Prashant Malani <pmalani@chromium.org>
    mfd: cros_ec: Check DT node for usbpd-notify add

Luis Henriques <lhenriques@suse.com>
    ceph: re-org copy_file_range and fix some error paths

Bob Moore <robert.moore@intel.com>
    ACPICA: Fixes for acpiExec namespace init file

Chao Yu <chao@kernel.org>
    f2fs: fix potential deadlock on compressed quota file

Chao Yu <chao@kernel.org>
    f2fs: fix NULL pointer dereference in f2fs_write_begin()

Chao Yu <chao@kernel.org>
    f2fs: fix NULL pointer dereference in f2fs_verity_work()

Chao Yu <chao@kernel.org>
    f2fs: fix potential .flags overflow on 32bit architecture

Chao Yu <chao@kernel.org>
    f2fs: compress: fix to call missing destroy_compress_ctx()

Guo Ren <guoren@linux.alibaba.com>
    csky: Fixup get wrong psr value from phyical reg

Gayatri Kammela <gayatri.kammela@intel.com>
    ACPI: Update Tiger Lake ACPI device IDs

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

Davide Caratti <dcaratti@redhat.com>
    macsec: fix NULL dereference in macsec_upd_offload()

Christophe Leroy <christophe.leroy@c-s.fr>
    mm/hugetlb: fix build failure with HUGETLB_PAGE but not HUGEBTLBFS

Gayatri Kammela <gayatri.kammela@intel.com>
    platform/x86: intel-hid: fix: Update Tiger Lake ACPI device ID

Rob Herring <robh@kernel.org>
    dt-bindings: thermal: tsens: Fix nvmem-cell-names schema

Bhawanpreet Lakha <Bhawanpreet.Lakha@amd.com>
    drm/amd/display: Don't try hdcp1.4 when content_type is set to type1

Miroslav Benes <mbenes@suse.cz>
    x86/xen: Make the boot CPU idle task reliable

Long Li <longli@microsoft.com>
    cifs: Allocate encryption header through kmalloc

Gabriel Krisman Bertazi <krisman@collabora.com>
    um: ubd: Prevent buffer overrun on command completion

Eric Sandeen <sandeen@redhat.com>
    ext4: do not commit super on read-only bdev

Liwei Song <liwei.song@windriver.com>
    nfsroot: set tcp as the default transport protocol

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

Willy Wolff <willy.mh.wolff.ml@gmail.com>
    thermal/drivers/cpufreq_cooling: Fix return of cpufreq_set_cur_state

Alex Smith <alex.smith@imgtec.com>
    MIPS: DTS: CI20: add DT node for IR sensor

Alexander Gordeev <agordeev@linux.ibm.com>
    s390/cpuinfo: fix wrong output when CPU0 is offline

Sahitya Tummala <stummala@codeaurora.org>
    f2fs: Add a new CP flag to help fsck fix resize SPO issues

Sahitya Tummala <stummala@codeaurora.org>
    f2fs: Fix mount failure due to SPO after a successful online resize FS

Chao Yu <chao@kernel.org>
    f2fs: fix to update f2fs_super_block fields under sb_lock

Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
    NFS: direct.c: Fix memory leak of dreq when nfs_get_lock_context fails

Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
    phy: uniphier-usb3ss: Add Pro5 support

Amit Kucheria <amit.kucheria@linaro.org>
    drivers: thermal: tsens: Release device in success path

Chao Yu <chao@kernel.org>
    f2fs: fix to show norecovery mount option

Michael Roth <mdroth@linux.vnet.ibm.com>
    KVM: PPC: Book3S HV: Fix H_CEDE return code for nested guests

Darrick J. Wong <darrick.wong@oracle.com>
    xfs: fix incorrect test in xfs_alloc_ag_vextent_lastblock

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

Amit Kucheria <amit.kucheria@linaro.org>
    arm64: dts: marvell: Fix cpu compatible for AP807-quad

Russell King <rmk+kernel@armlinux.org.uk>
    arm64: dts: clearfog-gt-8k: set gigabit PHY reset deassert delay

Tomasz Maciej Nowak <tmn505@gmail.com>
    arm64: dts: marvell: espressobin: add ethernet alias

Tommi Rantala <tommi.t.rantala@nokia.com>
    xfs: fix regression in "cleanup xfs_dir2_block_getdents"

Darrick J. Wong <darrick.wong@oracle.com>
    xfs: fix use-after-free when aborting corrupt attr inactivation

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

Dmitry Osipenko <digetx@gmail.com>
    memory: tegra: Correct debugfs clk rate-range on Tegra124

Dmitry Osipenko <digetx@gmail.com>
    memory: tegra: Correct debugfs clk rate-range on Tegra30

Dmitry Osipenko <digetx@gmail.com>
    memory: tegra: Correct debugfs clk rate-range on Tegra20

Dave Jiang <dave.jiang@intel.com>
    dmaengine: idxd: reflect shadow copy of traffic class programming

Johan Jonker <jbx6244@gmail.com>
    ARM: dts: rockchip: fix vqmmc-supply property name for rk3188-bqedison2qc

Chao Yu <chao@kernel.org>
    f2fs: fix to avoid use-after-free in f2fs_write_multi_pages()

Jaegeuk Kim <jaegeuk@kernel.org>
    f2fs: fix wrong check on F2FS_IOC_FSSETXATTR

Brian Foster <bfoster@redhat.com>
    xfs: fix iclog release error check race with shutdown

Andrii Nakryiko <andriin@fb.com>
    bpf: Reliably preserve btf_trace_xxx types

Sahitya Tummala <stummala@codeaurora.org>
    f2fs: fix the panic in do_checkpoint()

Chao Yu <chao@kernel.org>
    f2fs: fix to avoid potential deadlock

Torsten Duwe <duwe@suse.de>
    s390/crypto: explicitly memzero stack key material in aes_s390.c

Aya Levin <ayal@mellanox.com>
    net/mlx5e: Enforce setting of a single FEC mode

Eneas U de Queiroz <cotequeiroz@gmail.com>
    crypto: qce - use cryptlen when adding extra sgl

Anson Huang <Anson.Huang@nxp.com>
    clk: imx: pll14xx: Add new frequency entries for pll1443x table

Claudiu Beznea <claudiu.beznea@microchip.com>
    clk: at91: usb: continue if clk_hw_round_rate() return zero

Stephen Boyd <sboyd@kernel.org>
    clk: Don't cache errors from clk_ops::get_phase()

Bob Peterson <rpeterso@redhat.com>
    gfs2: clear ail1 list when gfs2 withdraws

xinhui pan <xinhui.pan@amd.com>
    drm/ttm: flush the fence on the bo after we individualize the reservation object

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
    x86/Hyper-V: Free hv_panic_page when fail to register kmsg dump

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

Ilya Dryomov <idryomov@gmail.com>
    rbd: don't test rbd_dev->opts in rbd_dev_image_release()

Ilya Dryomov <idryomov@gmail.com>
    rbd: call rbd_dev_unprobe() after unwatching and flushing notifies

Ilya Dryomov <idryomov@gmail.com>
    rbd: avoid a deadlock on header_rwsem when flushing notifies

Zenghui Yu <yuzenghui@huawei.com>
    irqchip/mbigen: Free msi_desc on device teardown

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: report EOPNOTSUPP on unsupported flags/object type

Slava Bacherikov <slava@bacher09.org>
    kbuild, btf: Fix dependencies for DEBUG_INFO_BTF

Martin Fuzzey <martin.fuzzey@flowbird.group>
    ARM: dts: imx6: Use gpc for FEC interrupt controller to fix wake on LAN.

Andrii Nakryiko <andriin@fb.com>
    bpf: Prevent re-mmap()'ing BPF map as writable for initially r/o mapping

Luke Nelson <lukenels@cs.washington.edu>
    arm, bpf: Fix bugs with ALU64 {RSH, ARSH} BPF_K shift by 0

Andrey Ignatov <rdna@fb.com>
    libbpf: Fix bpf_get_link_xdp_id flags handling

Li RongQing <lirongqing@baidu.com>
    xsk: Fix out of boundary write in __xsk_rcv_memcpy

Michael Walle <michael@walle.cc>
    watchdog: sp805: fix restart handler

Roman Gushchin <guro@fb.com>
    ext4: use non-movable memory for superblock readahead

Takashi Iwai <tiwai@suse.de>
    ALSA: hda: Honor PM disablement in PM freeze and thaw_noirq ops

Li Bin <huawei.libin@huawei.com>
    scsi: sg: add sg_remove_request in sg_common_write

Josh Poimboeuf <jpoimboe@redhat.com>
    objtool: Fix switch table detection in .text.unlikely

Luke Nelson <lukenels@cs.washington.edu>
    arm, bpf: Fix offset overflow for BPF_MEM BPF_DW

Stefano Brivio <sbrivio@redhat.com>
    netfilter: nft_set_rbtree: Drop spurious condition for overlap detection on insertion


-------------

Diffstat:

 Documentation/admin-guide/kernel-parameters.txt    |   2 +-
 .../bindings/pci/nvidia,tegra194-pcie.txt          |   2 +-
 .../devicetree/bindings/thermal/qcom-tsens.yaml    |   9 +-
 Makefile                                           |   4 +-
 arch/arm/boot/dts/imx6qdl.dtsi                     |   5 +-
 arch/arm/boot/dts/imx6qp.dtsi                      |   1 -
 arch/arm/boot/dts/rk3188-bqedison2qc.dts           |  29 ++--
 arch/arm/boot/dts/sun8i-a83t.dtsi                  |   2 +-
 arch/arm/boot/dts/sun8i-r40.dtsi                   |   2 +-
 arch/arm/boot/dts/sun8i-v3s.dtsi                   |   2 +-
 arch/arm/boot/dts/sunxi-h3-h5.dtsi                 |   2 +-
 arch/arm/net/bpf_jit_32.c                          |  52 ++++---
 arch/arm64/boot/dts/allwinner/sun50i-a64.dtsi      |   2 +-
 .../boot/dts/marvell/armada-3720-espressobin.dtsi  |   6 +
 .../dts/marvell/armada-8040-clearfog-gt-8k.dts     |   1 +
 arch/arm64/boot/dts/marvell/armada-ap807-quad.dtsi |   8 +-
 arch/arm64/boot/dts/nvidia/tegra194.dtsi           | 111 ++++++++++++-
 arch/csky/abiv1/inc/abi/entry.h                    |   5 +-
 arch/csky/abiv2/fpu.c                              |   5 -
 arch/csky/abiv2/inc/abi/entry.h                    |   7 +-
 arch/csky/abiv2/inc/abi/fpu.h                      |   3 +-
 arch/csky/include/asm/processor.h                  |   1 +
 arch/csky/kernel/head.S                            |   5 +
 arch/csky/kernel/setup.c                           |  63 ++------
 arch/csky/kernel/smp.c                             |   6 +
 arch/csky/kernel/traps.c                           |  11 +-
 arch/csky/mm/fault.c                               |   7 +
 arch/mips/boot/dts/ingenic/ci20.dts                |   5 +
 arch/powerpc/kernel/prom_init.c                    |   3 +
 arch/powerpc/kvm/book3s_hv.c                       |   1 +
 arch/powerpc/platforms/maple/setup.c               |  34 ++--
 arch/s390/crypto/aes_s390.c                        |   3 +
 arch/s390/kernel/perf_cpum_sf.c                    |   4 +-
 arch/s390/kernel/processor.c                       |   5 +-
 arch/s390/mm/gmap.c                                |   1 +
 arch/um/drivers/ubd_kern.c                         |   4 +-
 arch/um/os-Linux/file.c                            |   1 +
 arch/x86/hyperv/hv_init.c                          |   6 +-
 arch/x86/kernel/acpi/cstate.c                      |   3 +-
 arch/x86/kernel/cpu/mshyperv.c                     |  10 ++
 arch/x86/xen/xen-head.S                            |   8 +-
 block/bfq-cgroup.c                                 |  73 +++++----
 block/bfq-iosched.c                                |   2 -
 block/bfq-iosched.h                                |   1 +
 drivers/acpi/acpica/acnamesp.h                     |   2 +
 drivers/acpi/acpica/dbinput.c                      |  16 +-
 drivers/acpi/acpica/dswexec.c                      |  33 ++++
 drivers/acpi/acpica/dswload.c                      |   2 -
 drivers/acpi/acpica/dswload2.c                     |  35 +++++
 drivers/acpi/acpica/nsnames.c                      |   6 +-
 drivers/acpi/acpica/utdelete.c                     |   9 +-
 drivers/acpi/device_pm.c                           |   2 +-
 drivers/acpi/dptf/dptf_power.c                     |   2 +-
 drivers/acpi/dptf/int340x_thermal.c                |   8 +-
 drivers/acpi/processor_throttling.c                |   7 -
 drivers/block/rbd.c                                |  27 ++--
 drivers/clk/at91/clk-usb.c                         |   3 +
 drivers/clk/clk.c                                  |  48 ++++--
 drivers/clk/imx/clk-pll14xx.c                      |   2 +
 drivers/clk/tegra/clk-tegra-pmc.c                  |  12 +-
 drivers/crypto/qce/dma.c                           |  11 +-
 drivers/crypto/qce/dma.h                           |   2 +-
 drivers/crypto/qce/skcipher.c                      |   5 +-
 drivers/dma/idxd/device.c                          |   4 +-
 drivers/gpu/drm/amd/amdkfd/kfd_device.c            |   4 +-
 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_hdcp.c |   8 +-
 drivers/gpu/drm/nouveau/nouveau_drm.c              |  63 ++++++++
 drivers/gpu/drm/nouveau/nouveau_drv.h              |   2 +
 drivers/gpu/drm/nouveau/nouveau_svm.c              |   6 +
 drivers/gpu/drm/nouveau/nvkm/engine/gr/gf100.c     |  26 ++++
 drivers/gpu/drm/ttm/ttm_bo.c                       |   4 +-
 drivers/gpu/drm/vc4/vc4_hdmi.c                     |  20 ++-
 drivers/hv/channel_mgmt.c                          |   3 +
 drivers/hv/vmbus_drv.c                             |  62 +++++---
 drivers/iio/common/st_sensors/st_sensors_core.c    |   4 +
 drivers/iio/light/si1133.c                         |  37 +++--
 drivers/iommu/Kconfig                              |   1 +
 drivers/iommu/amd_iommu_types.h                    |   2 +-
 drivers/iommu/intel-iommu.c                        |   3 +-
 drivers/iommu/intel-svm.c                          |   9 +-
 drivers/iommu/virtio-iommu.c                       |  16 +-
 drivers/irqchip/irq-mbigen.c                       |   8 +-
 drivers/leds/led-class.c                           |   2 +-
 drivers/memory/tegra/tegra124-emc.c                |   5 +
 drivers/memory/tegra/tegra20-emc.c                 |   5 +
 drivers/memory/tegra/tegra30-emc.c                 |   5 +
 drivers/mfd/cros_ec_dev.c                          |   2 +-
 drivers/mtd/devices/phram.c                        |  15 +-
 drivers/mtd/lpddr/lpddr_cmds.c                     |   1 -
 drivers/mtd/nand/raw/nand_base.c                   |   2 +
 drivers/mtd/nand/spi/core.c                        |   1 +
 drivers/net/dsa/bcm_sf2_cfp.c                      |   9 +-
 .../net/ethernet/mellanox/mlx5/core/en_ethtool.c   |   4 +
 drivers/net/macsec.c                               |   3 +
 drivers/nvdimm/bus.c                               |   6 +-
 drivers/of/overlay.c                               |   2 +
 drivers/of/unittest.c                              |  16 +-
 drivers/phy/socionext/phy-uniphier-usb3ss.c        |   4 +
 drivers/platform/chrome/cros_ec.c                  |  30 ++++
 drivers/platform/x86/intel-hid.c                   |   2 +-
 drivers/power/supply/axp288_fuel_gauge.c           |   4 +-
 drivers/power/supply/bq27xxx_battery.c             |   5 +-
 drivers/rtc/rtc-88pm860x.c                         |  14 +-
 drivers/scsi/sg.c                                  |   4 +-
 drivers/soc/imx/gpc.c                              |  24 +--
 drivers/thermal/Kconfig                            |   1 +
 drivers/thermal/cpufreq_cooling.c                  |   6 +-
 drivers/thermal/qcom/tsens-common.c                |   6 +-
 drivers/tty/ehv_bytechan.c                         |  21 ++-
 drivers/video/fbdev/core/fbmem.c                   |  38 ++---
 drivers/virtio/virtio_balloon.c                    | 107 ++++++-------
 drivers/watchdog/sp805_wdt.c                       |   4 +
 fs/afs/dir.c                                       | 108 ++++++++-----
 fs/afs/dir_silly.c                                 |  22 ++-
 fs/afs/fsclient.c                                  |  27 ++--
 fs/afs/yfsclient.c                                 |  20 +--
 fs/block_dev.c                                     |   4 +-
 fs/btrfs/block-group.c                             |   2 +
 fs/buffer.c                                        |  11 ++
 fs/ceph/file.c                                     | 173 ++++++++++++---------
 fs/cifs/smb2misc.c                                 |  14 ++
 fs/cifs/transport.c                                |  28 ++--
 fs/ext2/xattr.c                                    |   8 +-
 fs/ext4/inode.c                                    |   2 +-
 fs/ext4/super.c                                    |   5 +-
 fs/f2fs/checkpoint.c                               |  24 +--
 fs/f2fs/compress.c                                 |  63 ++++++--
 fs/f2fs/data.c                                     |  35 ++++-
 fs/f2fs/f2fs.h                                     | 102 ++++++------
 fs/f2fs/file.c                                     |  13 +-
 fs/f2fs/gc.c                                       |  27 +++-
 fs/f2fs/inode.c                                    |   2 +-
 fs/f2fs/node.c                                     |   7 +-
 fs/f2fs/super.c                                    |  14 +-
 fs/gfs2/log.c                                      |  17 +-
 fs/nfs/callback_proc.c                             |   2 +
 fs/nfs/direct.c                                    |   2 +
 fs/nfs/inode.c                                     |  10 +-
 fs/nfs/nfs4file.c                                  |   3 +
 fs/nfs/nfsroot.c                                   |   2 +-
 fs/nfs/pagelist.c                                  |  17 +-
 fs/xfs/libxfs/xfs_alloc.c                          |   2 +-
 fs/xfs/xfs_attr_inactive.c                         |   2 +-
 fs/xfs/xfs_dir2_readdir.c                          |  12 +-
 fs/xfs/xfs_log.c                                   |  13 +-
 include/acpi/processor.h                           |   8 +
 include/asm-generic/mshyperv.h                     |   2 +-
 include/keys/big_key-type.h                        |   2 +-
 include/keys/user-type.h                           |   3 +-
 include/linux/buffer_head.h                        |   8 +
 include/linux/compiler.h                           |   2 +-
 include/linux/f2fs_fs.h                            |   1 +
 include/linux/hugetlb.h                            |  19 +--
 include/linux/key-type.h                           |   2 +-
 include/linux/percpu_counter.h                     |   4 +-
 include/linux/platform_data/cros_ec_proto.h        |   4 +
 include/linux/swapops.h                            |   3 +-
 include/trace/bpf_probe.h                          |  18 ++-
 kernel/bpf/syscall.c                               |  16 +-
 kernel/bpf/verifier.c                              |  45 ++++--
 kernel/dma/coherent.c                              |  13 +-
 kernel/dma/debug.c                                 |   9 +-
 kernel/locking/locktorture.c                       |   8 +-
 lib/Kconfig.debug                                  |   2 +
 net/dns_resolver/dns_key.c                         |   2 +-
 net/netfilter/nf_tables_api.c                      |   4 +-
 net/netfilter/nft_set_rbtree.c                     |  23 ++-
 net/rxrpc/key.c                                    |  27 ++--
 net/sunrpc/auth_gss/auth_gss.c                     |  80 +++++++---
 net/xdp/xdp_umem.c                                 |   5 +-
 net/xdp/xsk.c                                      |   5 +-
 security/keys/big_key.c                            |  11 +-
 security/keys/encrypted-keys/encrypted.c           |   7 +-
 security/keys/keyctl.c                             |  73 +++++++--
 security/keys/keyring.c                            |   6 +-
 security/keys/request_key_auth.c                   |   7 +-
 security/keys/trusted-keys/trusted_tpm1.c          |  14 +-
 security/keys/user_defined.c                       |   5 +-
 sound/pci/hda/hda_intel.c                          |  23 ++-
 tools/lib/bpf/netlink.c                            |   2 +-
 tools/objtool/check.c                              |   5 +-
 .../selftests/bpf/prog_tests/get_stack_raw_tp.c    |   5 +
 .../selftests/bpf/progs/test_get_stack_rawtp_err.c |  26 ++++
 .../testing/selftests/bpf/verifier/bpf_get_stack.c |   8 +-
 184 files changed, 1755 insertions(+), 924 deletions(-)


