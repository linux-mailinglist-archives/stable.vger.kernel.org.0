Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83D345410E2
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 21:31:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355489AbiFGTaA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 15:30:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346748AbiFGT2W (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 15:28:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 530511A29FF;
        Tue,  7 Jun 2022 11:11:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E461AB82239;
        Tue,  7 Jun 2022 18:11:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 902A4C385A2;
        Tue,  7 Jun 2022 18:11:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654625496;
        bh=4aRWKjGWeeUXp3OcfzDU+lembzE7bHH394tgZ6p9AhQ=;
        h=From:To:Cc:Subject:Date:From;
        b=LbWPkb1EadmrorrGxWdvaXywdoDxk+3I6R7gHnTnLPZgr5D1SPkkOmALJESgDAXHZ
         nCMfjCm7O0Kcxlf/QAM0Y6Q36llcPzw2vGRH57DSUkcLMQSi3J6AV0CNUO0JhXlt99
         URWlaJsUOBBLZ+BT42LwMTI9SONKkbo75YZEvocM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Subject: [PATCH 5.17 000/772] 5.17.14-rc1 review
Date:   Tue,  7 Jun 2022 18:53:12 +0200
Message-Id: <20220607164948.980838585@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.17.14-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.17.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.17.14-rc1
X-KernelTest-Deadline: 2022-06-09T16:50+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.17.14 release.
There are 772 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 09 Jun 2022 16:48:02 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.17.14-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.17.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.17.14-rc1

Tony Lindgren <tony@atomide.com>
    tty: n_gsm: Fix packet data hex dump output

Jia-Ju Bai <baijiaju1990@gmail.com>
    md: bcache: check the return value of kzalloc() in detached_dev_do_request()

Xiao Ni <xni@redhat.com>
    md: fix double free of io_acct_set bioset

Xiao Ni <xni@redhat.com>
    md: Don't set mddev private to NULL in raid0 pers->free

Namjae Jeon <linkinjeon@kernel.org>
    fs/ntfs3: Fix invalid free in log_replay

Christian Brauner <brauner@kernel.org>
    exportfs: support idmapped mounts

Christian Brauner <brauner@kernel.org>
    fs: add two trivial lookup helpers

Eric Biggers <ebiggers@google.com>
    ext4: only allow test_dummy_encryption when supported

Maciej W. Rozycki <macro@orcam.me.uk>
    MIPS: IP30: Remove incorrect `cpu_has_fpu' override

Maciej W. Rozycki <macro@orcam.me.uk>
    MIPS: IP27: Remove incorrect `cpu_has_fpu' override

Xiao Yang <yangx.jy@fujitsu.com>
    RDMA/rxe: Generate a completion for unsupported/invalid opcode

Yixing Liu <liuyixing1@huawei.com>
    RDMA/hns: Remove the num_cqc_timer variable

Dan Carpenter <dan.carpenter@oracle.com>
    staging: r8188eu: delete rtw_wx_read/write32()

Jason A. Donenfeld <Jason@zx2c4.com>
    Revert "random: use static branch for crng_ready()"

David Gow <davidgow@google.com>
    list: test: Add a test for list_is_head()

Zhengjun Xing <zhengjun.xing@linux.intel.com>
    perf evlist: Extend arch_evsel__must_be_in_group to support hybrid systems

Waiman Long <longman@redhat.com>
    kseltest/cgroup: Make test_stress.sh work if run interactively

Alex Elder <elder@linaro.org>
    net: ipa: fix page free in ipa_endpoint_replenish_one()

Alex Elder <elder@linaro.org>
    net: ipa: fix page free in ipa_endpoint_trans_release()

Johan Hovold <johan+linaro@kernel.org>
    phy: qcom-qmp: fix reset-controller leak on probe errors

Mao Jinlong <quic_jinlmao@quicinc.com>
    coresight: core: Fix coresight device probe failure issue

Tejun Heo <tj@kernel.org>
    blk-iolatency: Fix inflight count imbalances and IO hangs on offline

Eugenio Pérez <eperezma@redhat.com>
    vdpasim: allow to enable a vq repeatedly

Dinh Nguyen <dinguyen@kernel.org>
    dt-bindings: gpio: altera: correct interrupt-cells

Akira Yokosawa <akiyks@gmail.com>
    docs/conf.py: Cope with removal of language=None in Sphinx 5.0.0

Steve French <stfrench@microsoft.com>
    SMB3: EBADF/EIO errors in rename/open caused by race condition in smb2_compound_op

Luís Henriques <lhenriques@suse.de>
    ceph: fix decoding of client session messages flags

Arnd Bergmann <arnd@arndb.de>
    ARM: pxa: maybe fix gpio lookup tables

Jonathan Bakker <xc-racer2@live.ca>
    ARM: dts: s5pv210: Remove spi-cs-high on panel in Aries

Johan Hovold <johan+linaro@kernel.org>
    phy: qcom-qmp: fix struct clk leak on probe errors

Diogo Ivo <diogo.ivo@tecnico.ulisboa.pt>
    clk: tegra: Add missing reset deassertion

Diogo Ivo <diogo.ivo@tecnico.ulisboa.pt>
    arm64: tegra: Add missing DFLL reset on Tegra210

Kathiravan T <quic_kathirav@quicinc.com>
    arm64: dts: qcom: ipq8074: fix the sleep clock frequency

Xiaomeng Tong <xiam0nd.tong@gmail.com>
    gma500: fix an incorrect NULL check on list iterator

Xiaomeng Tong <xiam0nd.tong@gmail.com>
    tilcdc: tilcdc_external: fix an incorrect NULL check on list iterator

Jiri Slaby <jirislaby@kernel.org>
    serial: pch: don't overwrite xmit->buf[0] by x_char

Coly Li <colyli@suse.de>
    bcache: avoid journal no-space deadlock by reserving 1 journal bucket

Coly Li <colyli@suse.de>
    bcache: remove incremental dirty sector counting for bch_sectors_dirty_init()

Coly Li <colyli@suse.de>
    bcache: improve multithreaded bch_sectors_dirty_init()

Coly Li <colyli@suse.de>
    bcache: improve multithreaded bch_btree_check()

Xiaomeng Tong <xiam0nd.tong@gmail.com>
    stm: ltdc: fix two incorrect NULL checks on list iterator

Xiaomeng Tong <xiam0nd.tong@gmail.com>
    carl9170: tx: fix an incorrect use of list iterator

Mark Brown <broonie@kernel.org>
    ASoC: rt5514: Fix event generation for "DSP Voice Wake Up" control

Alexander Wetzel <alexander@wetzel-home.de>
    rtl818x: Prevent using not initialized queues

Yi Yang <yiyang13@huawei.com>
    xtensa/simdisk: fix proc_read_simdisk()

Miaohe Lin <linmiaohe@huawei.com>
    mm/memremap: fix missing call to untrack_pfn() in pagemap_range()

Mike Kravetz <mike.kravetz@oracle.com>
    hugetlb: fix huge_pmd_unshare address update

Christophe de Dinechin <dinechin@redhat.com>
    nodemask.h: fix compilation error with GCC12

Mel Gorman <mgorman@techsingularity.net>
    mm/page_alloc: always attempt to allocate at least one page during bulk allocation

Dong Aisheng <aisheng.dong@nxp.com>
    Revert "mm/cma.c: remove redundant cma_mutex lock"

Yunfei Wang <yf.wang@mediatek.com>
    iommu/dma: Fix iova map result check bug

Xiaomeng Tong <xiam0nd.tong@gmail.com>
    iommu/msm: Fix an incorrect NULL check on list iterator

Hyunchul Lee <hyc.lee@gmail.com>
    ksmbd: fix outstanding credits related bugs

Song Liu <song@kernel.org>
    ftrace: Clean up hash direct_functions on register failures

Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
    kexec_file: drop weak attribute from arch_kexec_apply_relocations[_add]

Vincent Whitchurch <vincent.whitchurch@axis.com>
    um: Fix out-of-bounds read in LDT setup

Johannes Berg <johannes.berg@intel.com>
    um: chan_user: Fix winch_tramp() return value

Johannes Berg <johannes.berg@intel.com>
    um: Use asm-generic/dma-mapping.h

Johannes Berg <johannes.berg@intel.com>
    um: virtio_uml: Fix broken device handling in time-travel

Felix Fietkau <nbd@nbd.name>
    mac80211: upgrade passive scan to active scan on DFS channels after beacon rx

Dimitri John Ledkov <dimitri.ledkov@canonical.com>
    cfg80211: declare MODULE_FIRMWARE for regulatory.db

Felix Fietkau <nbd@nbd.name>
    mt76: fix use-after-free by removing a non-RCU wcid pointer

Kant Fan <kant@allwinnertech.com>
    thermal: devfreq_cooling: use local ops instead of global ops

Max Filippov <jcmvbkbc@gmail.com>
    irqchip: irq-xtensa-mx: fix initial IRQ affinity

Pali Rohár <pali@kernel.org>
    irqchip/armada-370-xp: Do not touch Performance Counter Overflow on A375, A38x, A39x

Guo Ren <guoren@kernel.org>
    csky: patch_text: Fixup last cpu should be master

Bean Huo <beanhuo@micron.com>
    mmc: core: Allows to override the timeout value for ioctl() path

Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
    RDMA/hfi1: Fix potential integer multiplication overflow errors

Puyou Lu <puyou.lu@gmail.com>
    lib/string_helpers: fix not adding strarray to device's resource list

Sean Christopherson <seanjc@google.com>
    Kconfig: Add option for asm goto w/ tied outputs to workaround clang-13 bug

GUO Zihua <guozihua@huawei.com>
    ima: remove the IMA_TEMPLATE Kconfig option

Nicolas Dufresne <nicolas.dufresne@collabora.com>
    media: coda: Add more H264 levels for CODA960

Nicolas Dufresne <nicolas.dufresne@collabora.com>
    media: coda: Fix reported H264 profile

Tokunori Ikegami <ikegami.t@gmail.com>
    mtd: cfi_cmdset_0002: Use chip_ready() for write on S29GL064N

Tokunori Ikegami <ikegami.t@gmail.com>
    mtd: cfi_cmdset_0002: Move and rename chip_check/chip_ready/chip_good_for_write

Xiaomeng Tong <xiam0nd.tong@gmail.com>
    md: fix an incorrect NULL check in md_reload_sb

Xiaomeng Tong <xiam0nd.tong@gmail.com>
    md: fix an incorrect NULL check in does_sb_need_changing

Jani Nikula <jani.nikula@intel.com>
    drm/i915/dsi: fix VBT send packet port selection for ICL+

Brian Norris <briannorris@chromium.org>
    drm/bridge: analogix_dp: Grab runtime PM reference for DP-AUX

Xiaomeng Tong <xiam0nd.tong@gmail.com>
    drm/nouveau/kms/nv50-: atom: fix an incorrect NULL check on list iterator

Xiaomeng Tong <xiam0nd.tong@gmail.com>
    drm/nouveau/clk: Fix an incorrect NULL check on list iterator

Lucas Stach <l.stach@pengutronix.de>
    drm/etnaviv: check for reaped mapping in etnaviv_iommu_unmap_gem

Lyude Paul <lyude@redhat.com>
    drm/nouveau/subdev/bus: Ratelimit logging for fault errors

Dave Airlie <airlied@redhat.com>
    drm/amdgpu/cs: make commands with 0 chunks illegal behaviour.

Mickaël Salaün <mic@digikod.net>
    landlock: Fix same-layer rule unions

Mickaël Salaün <mic@digikod.net>
    landlock: Create find_rule() from unmask_layers()

Mickaël Salaün <mic@digikod.net>
    landlock: Reduce the maximum number of layers to 16

Mickaël Salaün <mic@digikod.net>
    landlock: Define access_mask_t to enforce a consistent access mask size

Mickaël Salaün <mic@digikod.net>
    selftests/landlock: Test landlock_create_ruleset(2) argument check ordering

Mickaël Salaün <mic@digikod.net>
    landlock: Change landlock_restrict_self(2) check ordering

Mickaël Salaün <mic@digikod.net>
    landlock: Change landlock_add_rule(2) argument check ordering

Mickaël Salaün <mic@digikod.net>
    selftests/landlock: Add tests for O_PATH

Mickaël Salaün <mic@digikod.net>
    selftests/landlock: Fully test file rename with "remove" access

Mickaël Salaün <mic@digikod.net>
    selftests/landlock: Extend access right tests to directories

Mickaël Salaün <mic@digikod.net>
    selftests/landlock: Add tests for unknown access rights

Mickaël Salaün <mic@digikod.net>
    selftests/landlock: Extend tests for minimal valid attribute size

Mickaël Salaün <mic@digikod.net>
    selftests/landlock: Make tests build with old libc

Mickaël Salaün <mic@digikod.net>
    landlock: Fix landlock_add_rule(2) documentation

Mickaël Salaün <mic@digikod.net>
    samples/landlock: Format with clang-format

Mickaël Salaün <mic@digikod.net>
    samples/landlock: Add clang-format exceptions

Mickaël Salaün <mic@digikod.net>
    selftests/landlock: Format with clang-format

Mickaël Salaün <mic@digikod.net>
    selftests/landlock: Normalize array assignment

Mickaël Salaün <mic@digikod.net>
    selftests/landlock: Add clang-format exceptions

Mickaël Salaün <mic@digikod.net>
    landlock: Format with clang-format

Mickaël Salaün <mic@digikod.net>
    landlock: Add clang-format exceptions

Manivannan Sadhasivam <mani@kernel.org>
    scsi: ufs: qcom: Add a readl() to make sure ref_clk gets enabled

Xiaomeng Tong <xiam0nd.tong@gmail.com>
    scsi: dc395x: Fix a missing check on list iterator

Junxiao Bi via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
    ocfs2: dlmfs: fix error handling of user_dlm_destroy_lock

Alexander Aring <aahringo@redhat.com>
    dlm: fix missing lkb refcount handling

Alexander Aring <aahringo@redhat.com>
    dlm: fix wake_up() calls for pending remove

Dan Carpenter <dan.carpenter@oracle.com>
    dlm: uninitialized variable on error in dlm_listen_for_all()

Alexander Aring <aahringo@redhat.com>
    dlm: fix plock invalid read

Sven Schnelle <svens@linux.ibm.com>
    s390/stp: clock_delta should be signed

Nico Boehr <nrb@linux.ibm.com>
    s390/perf: obtain sie_block from the right address

Rei Yamamoto <yamamoto.rei@jp.fujitsu.com>
    mm, compaction: fast_find_migrateblock() should return pfn in the target zone

Damien Le Moal <damien.lemoal@opensource.wdc.com>
    block: Fix potential deadlock in blk_ia_range_sysfs_show()

Denis Efremov <denis.e.efremov@oracle.com>
    staging: r8188eu: prevent ->Ssid overflow in rtw_wx_set_scan()

Johan Hovold <johan+linaro@kernel.org>
    PCI: qcom: Fix unbalanced PHY init on probe errors

Johan Hovold <johan+linaro@kernel.org>
    PCI: qcom: Fix runtime PM imbalance on probe errors

Bjorn Helgaas <bhelgaas@google.com>
    PCI/PM: Fix bridge_d3_blacklist[] Elo i2 overwrite of Gigabyte X299

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu: add beige goby PCI ID

Gautam Menghani <gautammenghani201@gmail.com>
    tracing: Initialize integer variable to prevent garbage return value

Wonhyuk Yang <vvghjk1234@gmail.com>
    tracing: Fix return value of trace_pid_write()

Keita Suzuki <keitasuzuki.park@sslab.ics.keio.ac.jp>
    tracing: Fix potential double free in create_var_ref()

Laurent Vivier <laurent@vivier.eu>
    tty: goldfish: Introduce gf_ioread32()/gf_iowrite32()

Sakari Ailus <sakari.ailus@linux.intel.com>
    ACPI: property: Release subnode properties with data nodes

Jan Kara <jack@suse.cz>
    ext4: avoid cycles in directory h-tree

Jan Kara <jack@suse.cz>
    ext4: verify dir block before splitting it

Baokun Li <libaokun1@huawei.com>
    ext4: fix bug_on in __es_tree_search

Theodore Ts'o <tytso@mit.edu>
    ext4: filter out EXT4_FC_REPLAY from on-disk superblock field s_state

Ye Bin <yebin10@huawei.com>
    ext4: fix bug_on in ext4_writepages

Eric Biggers <ebiggers@google.com>
    ext4: fix memory leak in parse_apply_sb_mount_options()

Ye Bin <yebin10@huawei.com>
    ext4: fix warning in ext4_handle_inode_extension

Baokun Li <libaokun1@huawei.com>
    ext4: fix race condition between ext4_write and ext4_convert_inline_data

Ojaswin Mujoo <ojaswin@linux.ibm.com>
    ext4: fix journal_ioprio mount option handling

Ye Bin <yebin10@huawei.com>
    ext4: fix use-after-free in ext4_rename_dir_prepare

Dmitry Monakhov <dmtrmonakhov@yandex-team.ru>
    ext4: mark group as trimmed only if it was fully scanned

Jan Kara <jack@suse.cz>
    bfq: Make sure bfqg for which we are queueing requests is online

Jan Kara <jack@suse.cz>
    bfq: Get rid of __bio_blkcg() usage

Jan Kara <jack@suse.cz>
    bfq: Track whether bfq_group is still online

Jan Kara <jack@suse.cz>
    bfq: Remove pointless bfq_init_rq() calls

Jan Kara <jack@suse.cz>
    bfq: Drop pointless unlock-lock pair

Jan Kara <jack@suse.cz>
    bfq: Update cgroup information before merging bio

Jan Kara <jack@suse.cz>
    bfq: Split shared queues on move between cgroups

Jan Kara <jack@suse.cz>
    bfq: Avoid merging queues with different parents

Jan Kara <jack@suse.cz>
    bfq: Avoid false marking of bic as stably merged

Aditya Garg <gargaditya08@live.com>
    efi: Do not import certificates from UEFI Secure Boot for T2 Macs

Zhihao Cheng <chengzhihao1@huawei.com>
    fs-writeback: writeback_sb_inodes：Recalculate 'wrote' according skipped pages

Johannes Berg <johannes.berg@intel.com>
    iwlwifi: mei: fix potential NULL-ptr deref

Avraham Stern <avraham.stern@intel.com>
    iwlwifi: mei: clear the sap data header before sending

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    iwlwifi: mvm: fix assert 1F04 upon reconfig

Johannes Berg <johannes.berg@intel.com>
    iwlwifi: fw: init SAR GEO table only if data is present

Johannes Berg <johannes.berg@intel.com>
    wifi: mac80211: fix use-after-free in chanctx code

Peter Zijlstra <peterz@infradead.org>
    objtool: Fix symbol creation

Mikulas Patocka <mpatocka@redhat.com>
    objtool: Fix objtool regression on x32 systems

Chao Yu <chao@kernel.org>
    f2fs: fix to do sanity check for inline inode

Chao Yu <chao@kernel.org>
    f2fs: fix fallocate to use file_modified to update permissions consistently

Eric Biggers <ebiggers@google.com>
    f2fs: don't use casefolded comparison for "." and ".."

Chao Yu <chao@kernel.org>
    f2fs: fix to do sanity check on total_data_blocks

Jaegeuk Kim <jaegeuk@kernel.org>
    f2fs: don't need inode lock for system hidden quota

Chao Yu <chao@kernel.org>
    f2fs: fix deadloop in foreground GC

Chao Yu <chao@kernel.org>
    f2fs: fix to clear dirty inode in f2fs_evict_inode()

Chao Yu <chao@kernel.org>
    f2fs: fix to do sanity check on block address in f2fs_do_zero_range()

Chao Yu <chao@kernel.org>
    f2fs: fix to avoid f2fs_bug_on() in dec_valid_node_count()

Olga Kornievskaia <kolga@netapp.com>
    NFSv4.1 mark qualified async operations as MOVEABLE tasks

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFS: Convert GFP_NOFS to GFP_KERNEL

Benjamin Coddington <bcodding@redhat.com>
    NFSv4: Fix free of uninitialized nfs4_label on referral lookup.

Javier Martinez Canillas <javierm@redhat.com>
    video: fbdev: vesafb: Fix a use-after-free due early fb_info cleanup

Zhengjun Xing <zhengjun.xing@linux.intel.com>
    perf jevents: Fix event syntax error caused by ExtSel

Daniel Bristot de Oliveira <bristot@kernel.org>
    tracing/timerlat: Notify IRQ new max latency only if stop tracing is set

Daniel Bristot de Oliveira <bristot@kernel.org>
    rtla: Fix __set_sched_attr error message

John Kacur <jkacur@redhat.com>
    rtla: Minor grammar fix for rtla README

John Kacur <jkacur@redhat.com>
    rtla: Don't overwrite existing directory mode

Leo Yan <leo.yan@linaro.org>
    perf c2c: Use stdio interface if slang is not supported

Jiri Olsa <jolsa@kernel.org>
    perf build: Fix btf__load_from_kernel_by_id() feature check

Tiezhu Yang <yangtiezhu@loongson.cn>
    MIPS: RALINK: Define pci_remap_iospace under CONFIG_PCI_DRIVERS_GENERIC

Palmer Dabbelt <palmer@rivosinc.com>
    RISC-V: Fix the XIP build

Li Huafei <lihuafei1@huawei.com>
    tracing: Reset the function filter after completing trampoline/graph selftest

Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
    i2c: rcar: fix PM ref counts in probe error paths

Tali Perry <tali.perry1@gmail.com>
    i2c: npcm: Handle spurious interrupts

Tyrone Ting <kfting@nuvoton.com>
    i2c: npcm: Correct register access width

Tali Perry <tali.perry1@gmail.com>
    i2c: npcm: Fix timeout calculation

Joerg Roedel <jroedel@suse.de>
    iommu/amd: Increase timeout waiting for GA log enablement

Amelie Delaunay <amelie.delaunay@foss.st.com>
    dmaengine: stm32-mdma: fix chan initialization in stm32_mdma_irq_handler()

Amelie Delaunay <amelie.delaunay@foss.st.com>
    dmaengine: stm32-mdma: remove GISR1 register

Miaoqian Lin <linmq006@gmail.com>
    video: fbdev: clcdfb: Fix refcount leak in clcdfb_of_vram_setup

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFS: Further fixes to the writeback error handling

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFSv4/pNFS: Do not fail I/O when we fail to allocate the pNFS layout

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFS: Don't report errors from nfs_pageio_complete() more than once

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFS: Do not report flush errors in nfs_write_end()

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFS: Don't report ENOSPC write errors twice

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFS: fsync() should report filesystem errors over EINTR/ERESTARTSYS

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFS: Do not report EINTR/ERESTARTSYS as mapping errors

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    dmaengine: idxd: Fix the error handling path in idxd_cdev_register()

Nathan Chancellor <nathan@kernel.org>
    i2c: at91: Initialize dma_buf in at91_twi_xfer()

Miles Chen <miles.chen@mediatek.com>
    iommu/mediatek: Fix NULL pointer dereference when printing dev_name

Guenter Roeck <linux@roeck-us.net>
    MIPS: Loongson: Use hwmon_device_register_with_groups() to register hwmon

Jean-Philippe Brucker <jean-philippe@linaro.org>
    iommu/arm-smmu-v3-sva: Fix mm use-after-free

Rex-BC Chen <rex-bc.chen@mediatek.com>
    cpufreq: mediatek: Unregister platform device on exit

Jia-Wei Chang <jia-wei.chang@mediatek.com>
    cpufreq: mediatek: Use module_init and add module_exit

Michael Walle <michael@walle.cc>
    i2c: at91: use dma safe buffers

Yong Wu <yong.wu@mediatek.com>
    iommu/mediatek: Add mutex for m4u_group and m4u_dom in data

Yong Wu <yong.wu@mediatek.com>
    iommu/mediatek: Remove clk_disable in mtk_iommu_remove

Yong Wu <yong.wu@mediatek.com>
    iommu/mediatek: Add list_del in mtk_iommu_remove

Yong Wu <yong.wu@mediatek.com>
    iommu/mediatek: Fix 2 HW sharing pgtable issue

Mario Limonciello <mario.limonciello@amd.com>
    iommu/amd: Enable swiotlb in all cases

Guo Ren <guoren@kernel.org>
    riscv: Fixup difference with defconfig

Jakob Koschel <jakobkoschel@gmail.com>
    f2fs: fix dereference of stale list iterator after loop body

Chao Yu <chao@kernel.org>
    f2fs: fix to do sanity check on inline_dots inode

Dan Carpenter <dan.carpenter@oracle.com>
    OPP: call of_node_put() on error path in _bandwidth_supported()

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    Input: stmfts - do not leave device disabled in stmfts_input_open

Wanpeng Li <wanpengli@tencent.com>
    KVM: LAPIC: Drop pending LAPIC timer injection when canceling the timer

Hector Martin <marcan@marcan.st>
    pinctrl: apple: Use a raw spinlock for the regmap

Douglas Miller <doug.miller@cornelisnetworks.com>
    RDMA/hfi1: Prevent use of lock before it is initialized

Björn Ardö <bjorn.ardo@axis.com>
    mailbox: forward the hrtimer if not queued and under a lock

Julian Schroeder <jumaco@amazon.com>
    nfsd: destroy percpu stats counters after reply cache shutdown

Yang Yingliang <yangyingliang@huawei.com>
    mfd: davinci_voicecodec: Fix possible null-ptr-deref davinci_vc_probe()

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    gpio: sim: Use correct order for the parameters of devm_kcalloc()

Christophe Leroy <christophe.leroy@csgroup.eu>
    powerpc/fsl_book3e: Don't set rodata RO too early

Miaoqian Lin <linmq006@gmail.com>
    powerpc/fsl_rio: Fix refcount leak in fsl_rio_setup

Miaoqian Lin <linmq006@gmail.com>
    powerpc/xive: Fix refcount leak in xive_spapr_init

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    powerpc/xive: Add some error handling code to 'xive_spapr_init()'

Randy Dunlap <rdunlap@infradead.org>
    macintosh: via-pmu and via-cuda need RTC_LIB

Kajol Jain <kjain@linux.ibm.com>
    powerpc/perf: Fix the threshold compare group constraint for power9

Kajol Jain <kjain@linux.ibm.com>
    powerpc/perf: Fix the threshold compare group constraint for power10

Russell Currey <ruscur@russell.cc>
    powerpc/powernv: Get STF barrier requirements from device-tree

Russell Currey <ruscur@russell.cc>
    powerpc/powernv: Get L1D flush requirements from device-tree

Michael Ellerman <mpe@ellerman.id.au>
    powerpc/64: Only WARN if __pa()/__va() called with bad addresses

Mario Limonciello <mario.limonciello@amd.com>
    mailbox: pcc: Fix an invalid-load caught by the address sanitizer

Kan Liang <kan.liang@linux.intel.com>
    perf stat: Always keep perf metrics topdown events in a group

Ian Rogers <irogers@google.com>
    perf evlist: Keep topdown counters in weak group

Yang Yingliang <yangyingliang@huawei.com>
    hwrng: omap3-rom - fix using wrong clk_disable() in omap_rom_rng_runtime_resume()

Daire McNamara <daire.mcnamara@microchip.com>
    PCI: microchip: Fix potential race in interrupt handling

Fabiano Rosas <farosas@linux.ibm.com>
    KVM: PPC: Book3S HV: Fix vcore_blocked tracepoint

Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
    PCI/AER: Clear MULTI_ERR_COR/UNCOR_RCV bits

Miaoqian Lin <linmq006@gmail.com>
    Input: sparcspkr - fix refcount leak in bbc_beep_probe

Jane Chu <jane.chu@oracle.com>
    mce: fix set_mce_nospec to always unmap the whole page

Jane Chu <jane.chu@oracle.com>
    x86/mce: relocate set{clear}_mce_nospec() functions

Mina Almasry <almasrymina@google.com>
    hugetlbfs: fix hugetlbfs_statfs() locking

Eugen Hristev <eugen.hristev@microchip.com>
    ARM: dts: at91: sama7g5: remove interrupt-parent from gic node

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    crypto: cryptd - Protect per-CPU resource by disabling BH.

Corentin Labbe <clabbe@baylibre.com>
    crypto: sun8i-ss - handle zero sized sg

Corentin Labbe <clabbe@baylibre.com>
    crypto: sun8i-ss - rework handling of IV

Qi Zheng <zhengqi.arch@bytedance.com>
    tty: fix deadlock caused by calling printk() under tty_port->lock

Alexey Dobriyan <adobriyan@gmail.com>
    module: fix [e_shstrndx].sh_size=0 OOB access

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    module.h: simplify MODULE_IMPORT_NS

AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
    PCI: mediatek-gen3: Assert resets to ensure expected init state

Francesco Dolcini <francesco.dolcini@toradex.com>
    PCI: imx6: Fix PERST# start-up sequence

Waiman Long <longman@redhat.com>
    ipc/mqueue: use get_tree_nodev() in mqueue_get_tree()

Alexey Dobriyan <adobriyan@gmail.com>
    proc: fix dentry/inode overinstantiating under /proc/${pid}/net

Charles Keepax <ckeepax@opensource.cirrus.com>
    ASoC: atmel-classd: Remove endianness flag on class d component

Charles Keepax <ckeepax@opensource.cirrus.com>
    ASoC: atmel-pdmic: Remove endianness flag on pdmic component

Robert Marko <robert.marko@sartura.hr>
    arm64: dts: marvell: espressobin-ultra: enable front USB3 port

Robert Marko <robert.marko@sartura.hr>
    arm64: dts: marvell: espressobin-ultra: fix SPI-NOR config

Yangyang Li <liyangyang20@huawei.com>
    RDMA/hns: Add the detection for CMDQ status in the device initialization process

Randy Dunlap <rdunlap@infradead.org>
    powerpc/4xx/cpm: Fix return value of __setup() handler

Randy Dunlap <rdunlap@infradead.org>
    powerpc/idle: Fix return value of __setup() handler

Yang Yingliang <yangyingliang@huawei.com>
    pinctrl: renesas: core: Fix possible null-ptr-deref in sh_pfc_map_resources()

Geert Uytterhoeven <geert+renesas@glider.be>
    pinctrl: renesas: r8a779a0: Fix GPIO function on I2C-capable pins

Randy Dunlap <rdunlap@infradead.org>
    powerpc/8xx: export 'cpm_setbrg' for modules

Lv Ruyi <lv.ruyi@zte.com.cn>
    drm/msm/dpu: fix error check return value of irq_of_parse_and_map()

Kuniyuki Iwashima <kuniyu@amazon.co.jp>
    list: fix a data-race around ep->rdllist

Heming Zhao via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
    ocfs2: fix mounting crash if journal is not alloced

Sudeep Holla <sudeep.holla@arm.com>
    firmware: arm_ffa: Remove incorrect assignment of driver_data

Sudeep Holla <sudeep.holla@arm.com>
    firmware: arm_ffa: Fix uuid parameter to ffa_partition_probe

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    drivers/base/memory: fix an unlikely reference counting issue in __add_memory_block()

Muchun Song <songmuchun@bytedance.com>
    dax: fix cache flush on PMD-mapped pages

Miaohe Lin <linmiaohe@huawei.com>
    drivers/base/node.c: fix compaction sysfs file leak

Jacky Li <jackyli@google.com>
    crypto: ccp - Fix the INIT_EX data file open failure

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    pinctrl: mvebu: Fix irq_of_parse_and_map() return value

Dan Williams <dan.j.williams@intel.com>
    nvdimm: Allow overwrite in the presence of disabled dimms

Dan Williams <dan.j.williams@intel.com>
    nvdimm: Fix firmware activation deadlock scenarios

Cristian Marussi <cristian.marussi@arm.com>
    firmware: arm_scmi: Fix list protocols enumeration in the base protocol

Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
    ASoC: sh: rz-ssi: Release the DMA channels in rz_ssi_probe() error path

Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
    ASoC: sh: rz-ssi: Propagate error codes returned from platform_get_irq_byname()

Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
    arm64: dts: ti: k3-am64-mcu: remove incorrect UART base clock rates

QintaoShen <unSimple1993@163.com>
    soc: bcm: Check for NULL return of devm_kzalloc()

Gustavo A. R. Silva <gustavoars@kernel.org>
    scsi: fcoe: Fix Wstringop-overflow warnings in fcoe_wwn_from_mac()

Lv Ruyi <lv.ruyi@zte.com.cn>
    mfd: ipaq-micro: Fix error check return value of platform_get_irq()

Hari Bathini <hbathini@linux.ibm.com>
    powerpc/fadump: fix PT_LOAD segment for boot memory area

Andrea Parri (Microsoft) <parri.andrea@gmail.com>
    Drivers: hv: vmbus: Fix handling of messages with transaction ID of zero

Vinod Koul <vkoul@kernel.org>
    arm64: dts: qcom: qrb5165-rb5: Fix can-clock node name

Fabien Parent <fparent@baylibre.com>
    pinctrl: mediatek: mt8195: enable driver on mtk platforms

Caleb Connolly <kc@postmarketos.org>
    pinctrl/rockchip: support deferring other gpio params

Chuanhong Guo <gch981213@gmail.com>
    arm: mediatek: select arch timer for mt7629

Chia-I Wu <olvaffe@gmail.com>
    drm/msm: return the average load over the polling period

Chia-I Wu <olvaffe@gmail.com>
    drm/msm: simplify gpu_busy callback

Stefan Wahren <stefan.wahren@i2se.com>
    pinctrl: bcm2835: implement hook for missing gpio-ranges

Stefan Wahren <stefan.wahren@i2se.com>
    gpiolib: of: Introduce hook for missing gpio-ranges

Corentin Labbe <clabbe@baylibre.com>
    crypto: marvell/cesa - ECB does not IV

Vladis Dronov <vdronov@redhat.com>
    hwrng: cn10k - Make check_rng_health() return an error code

Vladis Dronov <vdronov@redhat.com>
    hwrng: cn10k - Optimize cn10k_rng_read()

Hangyu Hua <hbh25y@gmail.com>
    misc: ocxl: fix possible double free in ocxl_file_register_afu

Stefan Wahren <stefan.wahren@i2se.com>
    ARM: dts: bcm2835-rpi-b: Fix GPIO line names

Phil Elwell <phil@raspberrypi.com>
    ARM: dts: bcm2837-rpi-3-b-plus: Fix GPIO line name of power LED

Phil Elwell <phil@raspberrypi.com>
    ARM: dts: bcm2837-rpi-cm3-io3: Fix GPIO line names for SMPS I2C

Phil Elwell <phil@raspberrypi.com>
    ARM: dts: bcm2835-rpi-zero-w: Fix GPIO line name for Wifi/BT

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    ARM: dts: qcom: sdx55: remove wrong unit address from RPMH RSC clocks

Bryan O'Donoghue <bryan.odonoghue@linaro.org>
    dt-bindings: soc: qcom: smd-rpm: Fix missing MSM8936 compatible

Marek Vasut <marex@denx.de>
    ARM: dts: stm32: Fix PHY post-reset delay on Avenger96

Marc Kleine-Budde <mkl@pengutronix.de>
    can: xilinx_can: mark bit timing constants as const

Guenter Roeck <linux@roeck-us.net>
    platform/chrome: Re-introduce cros_ec_cmd_xfer and use it for ioctls

Max Krummenacher <max.krummenacher@toradex.com>
    ARM: dts: imx6dl-colibri: Fix I2C pinmuxing

Tzung-Bi Shih <tzungbi@kernel.org>
    platform/chrome: cros_ec: fix error handling in cros_ec_register()

Giovanni Cabiddu <giovanni.cabiddu@intel.com>
    crypto: qat - set COMPRESSION capability for DH895XCC

Giovanni Cabiddu <giovanni.cabiddu@intel.com>
    crypto: qat - set CIPHER capability for DH895XCC

Sean Christopherson <seanjc@google.com>
    KVM: nVMX: Clear IDT vectoring on nested VM-Exit for double/triple fault

Sean Christopherson <seanjc@google.com>
    KVM: nVMX: Leave most VM-Exit info fields unmodified on failed VM-Entry

Bjorn Andersson <bjorn.andersson@linaro.org>
    soc: qcom: llcc: Add MODULE_DEVICE_TABLE()

Thorsten Scherer <t.scherer@eckelmann.de>
    ARM: dts: ci4x10: Adapt to changes in imx6qdl.dtsi regarding fec clocks

Jiantao Zhang <water.zhangjiantao@huawei.com>
    PCI: dwc: Fix setting error return on MSI DMA mapping failure

Miaoqian Lin <linmq006@gmail.com>
    PCI: mediatek: Fix refcount leak in mtk_pcie_subsys_powerup()

Dan Carpenter <dan.carpenter@oracle.com>
    PCI: rockchip: Fix find_first_zero_bit() limit

Dan Carpenter <dan.carpenter@oracle.com>
    PCI: cadence: Fix find_first_zero_bit() limit

Miaoqian Lin <linmq006@gmail.com>
    soc: qcom: smsm: Fix missing of_node_put() in smsm_parse_ipc

Miaoqian Lin <linmq006@gmail.com>
    soc: qcom: smp2p: Fix missing of_node_put() in smp2p_parse_ipc

Andre Przywara <andre.przywara@arm.com>
    ARM: dts: suniv: F1C100: fix watchdog compatible

Rafał Miłecki <rafal@milecki.pl>
    ARM: dts: BCM5301X: Update pin controller node name

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    memory: samsung: exynos5422-dmc: Avoid some over memory allocation

Mario Limonciello <mario.limonciello@amd.com>
    PCI/ACPI: Allow D3 only if Root Port can signal and wake from D3

Allen-KH Cheng <allen-kh.cheng@mediatek.com>
    arm64: dts: mt8192: Fix nor_flash status disable typo

Shawn Lin <shawn.lin@rock-chips.com>
    arm64: dts: rockchip: Move drive-impedance-ohm to emmc phy on rk3399

liuyacan <liuyacan@corp.netease.com>
    Revert "net/smc: fix listen processing for SMC-Rv2"

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: hci_conn: Fix hci_connect_le_sync

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: hci_sync: Cleanup hci_conn if it cannot be aborted

Robin Murphy <robin.murphy@arm.com>
    dma-direct: don't over-decrypt memory

liuyacan <liuyacan@corp.netease.com>
    net/smc: fix listen processing for SMC-Rv2

liuyacan <liuyacan@corp.netease.com>
    net/smc: postpone sk_refcnt increment in connect()

Randy Dunlap <rdunlap@infradead.org>
    net: dsa: restrict SMSC_LAN9303_I2C kconfig

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    hinic: Avoid some over memory allocation

David Howells <dhowells@redhat.com>
    rxrpc: Fix decision on when to generate an IDLE ACK

David Howells <dhowells@redhat.com>
    rxrpc: Don't let ack.previousPacket regress

David Howells <dhowells@redhat.com>
    rxrpc: Fix overlapping ACK accounting

David Howells <dhowells@redhat.com>
    rxrpc: Don't try to resend the request if we're receiving the reply

David Howells <dhowells@redhat.com>
    rxrpc: Fix listen() setting the bar too high for the prealloc rings

David Howells <dhowells@redhat.com>
    rxrpc: Fix locking issue

Adam Wujek <dev_public@wujek.eu>
    hwmon: (pmbus) Check PEC support before reading other registers

Yongzhi Liu <lyz_cs@pku.edu.cn>
    hv_netvsc: Fix potential dereference of NULL pointer

Taehee Yoo <ap420073@gmail.com>
    amt: fix memory leak for advertisement message

Taehee Yoo <ap420073@gmail.com>
    amt: fix gateway mode stuck

Jakub Kicinski <kuba@kernel.org>
    net: stmmac: fix out-of-bounds access in a selftest

Kan Liang <kan.liang@linux.intel.com>
    perf parse-events: Support different format of the topdown event name

Alexey Khoroshilov <khoroshilov@ispras.ru>
    ASoC: max98090: Move check for invalid values before casting in max98090_put_enab_tlv()

Hangbin Liu <liuhangbin@gmail.com>
    bonding: fix missed rcu protection

Duoming Zhou <duoming@zju.edu.cn>
    NFC: hci: fix sleep in atomic context bugs in nfc_hci_hcp_message_tx

John Garry <john.garry@huawei.com>
    scsi: hisi_sas: Fix rescan after deleting a disk

Harini Katakam <harini.katakam@xilinx.com>
    net: macb: Fix PTP one step sync support

Ulf Hansson <ulf.hansson@linaro.org>
    PM: domains: Fix initialization of genpd's next_wakeup

Yang Yingliang <yangyingliang@huawei.com>
    ASoC: wm2000: fix missing clk_disable_unprepare() on error in wm2000_anc_transition()

Jan Kara <jack@suse.cz>
    bfq: Allow current waker to defend against a tentative one

Jan Kara <jack@suse.cz>
    bfq: Relax waker detection for shared queues

Miaoqian Lin <linmq006@gmail.com>
    thermal/drivers/imx_sc_thermal: Fix refcount leak in imx_sc_thermal_probe

Yang Yingliang <yangyingliang@huawei.com>
    thermal/core: Fix memory leak in __thermal_cooling_device_register()

Zheng Yongjun <zhengyongjun3@huawei.com>
    thermal/drivers/broadcom: Fix potential NULL dereference in sr_thermal_probe

Stefan Wahren <stefan.wahren@i2se.com>
    thermal/drivers/bcm2711: Don't clamp temperature at zero

Nathan Chancellor <nathan@kernel.org>
    drm/i915: Fix CFI violation with show_dynamic_id()

Abhinav Kumar <quic_abhinavk@quicinc.com>
    drm/msm/dpu: handle pm_runtime_get_sync() errors in bind path

Hangbin Liu <liuhangbin@gmail.com>
    selftests/bpf: Add missed ima_setup.sh in Makefile

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    drm/msm: don't free the IRQ if it was not requested

Lai Jiangshan <jiangshan.ljs@antgroup.com>
    x86/sev: Annotate stack change in the #VC handler

Hangyu Hua <hbh25y@gmail.com>
    drm: msm: fix possible memory leak in mdp5_crtc_cursor_set()

Miaoqian Lin <linmq006@gmail.com>
    drm/msm/a6xx: Fix refcount leak in a6xx_gpu_init

Eric Biggers <ebiggers@google.com>
    ext4: reject the 'commit' option on ext2 filesystems

Moshe Tal <moshet@nvidia.com>
    net/mlx5e: Correct the calculation of max channels for rep

Gao Xiang <hsiangkao@linux.alibaba.com>
    erofs: fix buffer copy overflow of ztailpacking feature

Miaoqian Lin <linmq006@gmail.com>
    regulator: scmi: Fix refcount leak in scmi_regulator_probe

Jonas Karlman <jonas@kwiboo.se>
    media: rkvdec: h264: Fix bit depth wrap in pps packet

Nicolas Dufresne <nicolas.dufresne@collabora.com>
    media: rkvdec: h264: Fix dpb_valid implementation

Nicolas Dufresne <nicolas.dufresne@collabora.com>
    media: rkvdec: Stop overclocking the decoder

Yang Yingliang <yangyingliang@huawei.com>
    media: i2c: ov5648: fix wrong pointer passed to IS_ERR() and PTR_ERR()

Dongliang Mu <mudongliangabcd@gmail.com>
    media: ov7670: remove ov7670_power_off from ov7670_remove

Andre Przywara <andre.przywara@arm.com>
    kselftest/arm64: bti: force static linking

Miaoqian Lin <linmq006@gmail.com>
    ASoC: ti: j721e-evm: Fix refcount leak in j721e_soc_probe_*

Zheng Bin <zhengbin13@huawei.com>
    net: hinic: add missing destroy_workqueue in hinic_pf_to_mgmt_init

Eric Dumazet <edumazet@google.com>
    sctp: read sk->sk_bound_dev_if once in sctp_rcv()

Geert Uytterhoeven <geert@linux-m68k.org>
    m68k: math-emu: Fix dependencies of math emulation support

Keith Busch <kbusch@kernel.org>
    nvme: set dma alignment to dword

Mark Rutland <mark.rutland@arm.com>
    irqchip/gic-v3: Fix priority mask handling

Mark Rutland <mark.rutland@arm.com>
    irqchip/gic-v3: Refactor ISB + EOIR at ack time

Mark Rutland <mark.rutland@arm.com>
    irqchip/gic-v3: Ensure pseudo-NMIs have an ISB between ack and handling

Dylan Yudaken <dylany@fb.com>
    io_uring: only wake when the correct events are set

Jens Axboe <axboe@kernel.dk>
    io_uring: fix assuming triggered poll waitqueue is the single poll

Jens Axboe <axboe@kernel.dk>
    io_uring: cache poll/double-poll state with a request flag

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: avoid io-wq -EAGAIN looping for !IOPOLL

Yunfei Dong <yunfei.dong@mediatek.com>
    media: mediatek: vcodec: Fix v4l2 compliance decoder cmd test fail

Sean Wang <sean.wang@mediatek.com>
    Bluetooth: btmtksdio: fix use-after-free at btmtksdio_recv_event

Niels Dossche <dossche.niels@gmail.com>
    Bluetooth: protect le accept and resolv lists with hdev->lock

Niels Dossche <dossche.niels@gmail.com>
    Bluetooth: use hdev lock for accept_list and reject_list in conn req

Niels Dossche <dossche.niels@gmail.com>
    Bluetooth: use hdev lock in activate_scan for hci_is_adv_monitoring

Ying Hsu <yinghsu@chromium.org>
    Bluetooth: fix dangling sco_conn and use-after-free in sco_sock_timeout

Benjamin Gaignard <benjamin.gaignard@collabora.com>
    media: hantro: HEVC: Fix tile info buffer value computation

Eugen Hristev <eugen.hristev@microchip.com>
    media: atmel: atmel-sama5d2-isc: fix wrong mask in YUYV format check

Michael Rodin <mrodin@de.adit-jv.com>
    media: vsp1: Fix offset calculation for plane cropping

Pavel Skripkin <paskripkin@gmail.com>
    media: pvrusb2: fix array-index-out-of-bounds in pvr2_i2c_core_init

Miaoqian Lin <linmq006@gmail.com>
    media: exynos4-is: Change clk_disable to clk_disable_unprepare

Laurentiu Palcu <laurentiu.palcu@oss.nxp.com>
    media: i2c: rdacm2x: properly set subdev entity function

Miaoqian Lin <linmq006@gmail.com>
    media: atmel: atmel-isc: Fix PM disable depth imbalance in atmel_isc_probe

Miaoqian Lin <linmq006@gmail.com>
    media: st-delta: Fix PM disable depth imbalance in delta_probe

Peter Chiu <chui-hao.chiu@mediatek.com>
    mt76: mt7915: fix twt table_mask to u16 in mt7915_dev

Felix Fietkau <nbd@nbd.name>
    mt76: fix tx status related use-after-free race on station removal

Felix Fietkau <nbd@nbd.name>
    mt76: do not attempt to reorder received 802.3 packets without agg session

Sean Wang <sean.wang@mediatek.com>
    mt76: mt7921: fix kernel crash at mt7921_pci_remove

Deren Wu <deren.wu@mediatek.com>
    mt76: fix antenna config missing in 6G cap

Lorenzo Bianconi <lorenzo@kernel.org>
    mt76: mt7915: do not pass data pointer to mt7915_mcu_muru_debug_set

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    mt76: mt7921: Fix the error handling path of mt7921_pci_probe()

Miaoqian Lin <linmq006@gmail.com>
    media: exynos4-is: Fix PM disable depth imbalance in fimc_is_probe

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    media: aspeed: Fix an error handling path in aspeed_video_probe()

Josh Poimboeuf <jpoimboe@kernel.org>
    scripts/faddr2line: Fix overlapping text section failures

Phil Auld <pauld@redhat.com>
    kselftest/cgroup: fix test_stress.sh to use OUTPUT dir

Bart Van Assche <bvanassche@acm.org>
    block: Fix the bio.bi_opf comment

Miaoqian Lin <linmq006@gmail.com>
    ASoC: samsung: Fix refcount leak in aries_audio_probe

Christoph Hellwig <hch@lst.de>
    dma-direct: don't fail on highmem CMA pages in dma_direct_alloc_pages

Pierre Gondois <Pierre.Gondois@arm.com>
    PM: EM: Decrement policy counter

Miaoqian Lin <linmq006@gmail.com>
    regulator: pfuze100: Fix refcount leak in pfuze_parse_regulators_dt

Miaoqian Lin <linmq006@gmail.com>
    ASoC: mxs-saif: Fix refcount leak in mxs_saif_probe

Miaoqian Lin <linmq006@gmail.com>
    ASoC: imx-hdmi: Fix refcount leak in imx_hdmi_probe

Miaoqian Lin <linmq006@gmail.com>
    ASoC: fsl: Fix refcount leak in imx_sgtl5000_probe

Basavaraj Natikar <Basavaraj.Natikar@amd.com>
    HID: amd_sfh: Modify the hid name

Basavaraj Natikar <Basavaraj.Natikar@amd.com>
    HID: amd_sfh: Modify the bus name

Ajay Singh <ajay.kathat@microchip.com>
    wilc1000: fix crash observed in AP mode with cfg80211_register_netdevice()

Baochen Qiang <quic_bqiang@quicinc.com>
    ath11k: Don't check arvif->is_started before sending management frames

Ravi Bangoria <ravi.bangoria@amd.com>
    perf/amd/ibs: Use interrupt regs ip for stack unwinding

Jerome Marchand <jmarchan@redhat.com>
    samples: bpf: Don't fail for a missing VMLINUX_BTF when VMLINUX_H is provided

Konrad Dybcio <konrad.dybcio@somainline.org>
    regulator: qcom_smd: Fix up PM8950 regulator configuration

Viresh Kumar <viresh.kumar@linaro.org>
    Revert "cpufreq: Fix possible race in cpufreq online error path"

Andrii Nakryiko <andrii@kernel.org>
    selftests/bpf: Prevent skeleton generation race

Yang Yingliang <yangyingliang@huawei.com>
    spi: spi-fsl-qspi: check return value after calling platform_get_resource_byname()

Andreas Gruenbacher <agruenba@redhat.com>
    iomap: iomap_write_failed fix

Mark Rutland <mark.rutland@arm.com>
    arm64: stackleak: fix current_top_of_stack()

Xiaomeng Tong <xiam0nd.tong@gmail.com>
    media: uvcvideo: Fix missing check to determine if element is found in list

Dan Carpenter <dan.carpenter@oracle.com>
    drm/msm: return an error pointer in msm_gem_prime_get_sg_table()

Jessica Zhang <quic_jesszhan@quicinc.com>
    drm/msm/mdp5: Return error code in mdp5_mixer_release when deadlock is detected

Jessica Zhang <quic_jesszhan@quicinc.com>
    drm/msm/mdp5: Return error code in mdp5_pipe_release when deadlock is detected

Kuogee Hsieh <quic_khsieh@quicinc.com>
    drm/msm/dp: fix event thread stuck in wait_event after kthread_stop()

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    drm/msm/dsi: fix address for second DSI PHY on SDM660

Vinod Polimera <quic_vpolimer@quicinc.com>
    drm/msm/disp/dpu1: avoid clearing hw interrupts if hw_intr is null during drm uninit

Zev Weiss <zev@bewilderbeest.net>
    regulator: core: Fix enable_count imbalance with EXCLUSIVE_GET

Tong Tiangen <tongtiangen@huawei.com>
    arm64: fix types in copy_highpage()

Randy Dunlap <rdunlap@infradead.org>
    x86/mm: Cleanup the control_va_addr_alignment() __setup handler

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    irqchip/aspeed-scu-ic: Fix irq_of_parse_and_map() return value

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    irqchip/aspeed-i2c-ic: Fix irq_of_parse_and_map() return value

Daniel Thompson <daniel.thompson@linaro.org>
    irqchip/exiu: Fix acknowledgment of edge triggered interrupts

Randy Dunlap <rdunlap@infradead.org>
    x86: Fix return value of __setup handlers

Johannes Berg <johannes.berg@intel.com>
    nl80211: don't hold RTNL in color change request

Christoph Hellwig <hch@lst.de>
    virtio_blk: fix the discard_granularity and discard_alignment queue limits

James Clark <james.clark@arm.com>
    perf tools: Use Python devtools for version autodetection rather than runtime

Ian Abbott <abbotti@mev.co.uk>
    spi: cadence-quadspi: fix Direct Access Mode disable for SoCFPGA

Yang Yingliang <yangyingliang@huawei.com>
    drm/rockchip: vop: fix possible null-ptr-deref in vop_bind()

Daniel Latypov <dlatypov@google.com>
    kunit: fix debugfs code to use enum kunit_status, not bool

Jagan Teki <jagan@amarulasolutions.com>
    drm/panel: panel-simple: Fix proper bpc for AM-1280800N3TZQW-T00H

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    drm/msm: add missing include to msm_drv.c

Lv Ruyi <lv.ruyi@zte.com.cn>
    drm/msm/hdmi: fix error check return value of irq_of_parse_and_map()

Yang Yingliang <yangyingliang@huawei.com>
    drm/msm/hdmi: check return value after calling platform_get_resource_byname()

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    drm/msm/dsi: fix error checks and return values for DSI xmit functions

Kuogee Hsieh <quic_khsieh@quicinc.com>
    drm/msm/dp: do not stop transmitting phy test pattern during DP phy compliance test

Kuogee Hsieh <quic_khsieh@quicinc.com>
    drm/msm/dp: reset DP controller before transmit phy test pattern

Lv Ruyi <lv.ruyi@zte.com.cn>
    drm/msm/dp: fix error check return value of irq_of_parse_and_map()

Kuogee Hsieh <quic_khsieh@quicinc.com>
    drm/msm/dp: stop event kernel thread when DP unbind

Vinod Polimera <quic_vpolimer@quicinc.com>
    drm/msm/disp/dpu1: set vbif hw config to NULL to avoid use after memory free during pm runtime resume

Yang Jihong <yangjihong1@huawei.com>
    perf tools: Add missing headers needed by util/data.h

Nicolas Frattaroli <frattaroli.nicolas@gmail.com>
    ASoC: rk3328: fix disabling mclk on pclk probe failure

Josh Poimboeuf <jpoimboe@redhat.com>
    x86/speculation: Add missing prototype for unpriv_ebpf_notify()

Yang Yingliang <yangyingliang@huawei.com>
    mtd: rawnand: intel: fix possible null-ptr-deref in ebu_nand_probe()

Yang Yingliang <yangyingliang@huawei.com>
    mtd: rawnand: cadence: fix possible null-ptr-deref in cadence_nand_dt_probe()

Matthieu Baerts <matthieu.baerts@tessares.net>
    x86/pm: Fix false positive kmemleak report in msr_build_context()

Chen-Tsung Hsieh <chentsung@chromium.org>
    mtd: spi-nor: core: Check written SR value in spi_nor_write_16bit_sr_and_check()

Andrii Nakryiko <andrii@kernel.org>
    libbpf: Fix logic for finding matching program for CO-RE relocation

Colin Ian King <colin.king@intel.com>
    selftests/resctrl: Fix null pointer dereference on open failed

Colin Ian King <colin.king@intel.com>
    drm/v3d: Fix null pointer dereference of pointer perfmon

Kiwoong Kim <kwmad.kim@samsung.com>
    scsi: ufs: core: Exclude UECxx from SFR dump list

Bart Van Assche <bvanassche@acm.org>
    scsi: ufs: qcom: Fix ufs_qcom_resume()

Dan Carpenter <dan.carpenter@oracle.com>
    scsi: iscsi: Fix harmless double shift bug

Kuogee Hsieh <quic_khsieh@quicinc.com>
    drm/msm/dpu: adjust display_v_end for eDP and DP

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    drm/msm: properly add and remove internal bridges

Yuanchu Xie <yuanchu@google.com>
    selftests/damon: add damon to selftests root Makefile

Nuno Sá <nuno.sa@analog.com>
    of: overlay: do not break notify on NOTIFY_{OK|STOP}

Luca Ceresoli <luca.ceresoli@bootlin.com>
    spi: rockchip: fix missing error on unsupported SPI_CS_HIGH

Jon Lin <jon.lin@rock-chips.com>
    spi: rockchip: Preset cs-high and clk polarity in setup progress

Jon Lin <jon.lin@rock-chips.com>
    spi: rockchip: Stop spi slave dma receiver when cs inactive

Amir Goldstein <amir73il@gmail.com>
    fsnotify: fix wrong lockdep annotations

Amir Goldstein <amir73il@gmail.com>
    inotify: show inotify mask flags in proc fdinfo

Bjørn Mork <bjorn@mork.no>
    mtdblock: warn if opened on NAND

Colin Ian King <colin.king@intel.com>
    ALSA: pcm: Check for null pointer of pointer substream before dereferencing it

Marek Vasut <marex@denx.de>
    drm/panel: simple: Add missing bus flags for Innolux G070Y2-L01

Chen-Yu Tsai <wenst@chromium.org>
    media: hantro: Empty encoder capture buffers by default

Laurentiu Palcu <laurentiu.palcu@oss.nxp.com>
    media: i2c: max9286: fix kernel oops when removing module

Jacopo Mondi <jacopo+renesas@jmondi.org>
    media: i2c: max9286: Use "maxim,gpio-poc" property

Dan Carpenter <dan.carpenter@oracle.com>
    ath9k_htc: fix potential out of bounds access with invalid rxstatus->rs_keyix

John Ogness <john.ogness@linutronix.de>
    printk: wake waiters for safe and NMI contexts

John Ogness <john.ogness@linutronix.de>
    printk: add missing memory barrier to wake_up_klogd()

John Ogness <john.ogness@linutronix.de>
    printk: use atomic updates for klogd work

Schspa Shi <schspa@gmail.com>
    cpufreq: Fix possible race in cpufreq online error path

Zheng Yongjun <zhengyongjun3@huawei.com>
    spi: img-spfi: Fix pm_runtime_get_sync() error checking

Chengming Zhou <zhouchengming@bytedance.com>
    sched/psi: report zeroes for CPU full at the system level

Chengming Zhou <zhouchengming@bytedance.com>
    sched/fair: Fix cfs_rq_clock_pelt() for throttled cfs_rq

Marco Elver <elver@google.com>
    signal: Deliver SIGTRAP on perf event asynchronously if blocked

Nícolas F. R. A. Prado <nfraprado@collabora.com>
    drm/mediatek: dpi: Use mt8183 output formats for mt8192

Wei Yongjun <weiyongjun1@huawei.com>
    regulator: da9121: Fix uninit-value in da9121_assign_chip_model()

Miaoqian Lin <linmq006@gmail.com>
    drm/bridge: Fix error handling in analogix_dp_probe

Miaoqian Lin <linmq006@gmail.com>
    HID: elan: Fix potential double free in elan_input_configured

Jonathan Teh <jonathan.teh@outlook.com>
    HID: hid-led: fix maximum brightness for Dream Cheeky

Zheyu Ma <zheyuma97@gmail.com>
    mtd: rawnand: denali: Use managed device resources

Nícolas F. R. A. Prado <nfraprado@collabora.com>
    drm/bridge: anx7625: Use uint8 for lane-swing arrays

Tyler Hicks <tyhicks@linux.microsoft.com>
    EDAC/dmc520: Don't print an error for each unconfigured interrupt line

Arnd Bergmann <arnd@arndb.de>
    drbd: fix duplicate array initializer

Christoph Hellwig <hch@lst.de>
    target: remove an incorrect unmap zeroes data deduction

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    device property: Allow error pointer to be passed to fwnode APIs

Jan Kiszka <jan.kiszka@siemens.com>
    efi: Add missing prototype for efi_capsule_setup_info

Javier Martinez Canillas <javierm@redhat.com>
    efi: Allow to enable EFI runtime services by default on RT

Lin Ma <linma@zju.edu.cn>
    NFC: NULL out the dev->rfkill to prevent UAF

Lv Ruyi <lv.ruyi@zte.com.cn>
    ixp4xx_eth: fix error check return value of platform_get_irq()

Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
    net: dsa: mt7530: 1G can also support 1000BASE-X link mode

Paul E. McKenney <paulmck@kernel.org>
    scftorture: Fix distribution of short handler delays

Miaoqian Lin <linmq006@gmail.com>
    spi: spi-ti-qspi: Fix return value handling of wait_for_completion_timeout

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    drm: mali-dp: potential dereference of null pointer

Zhou Qingyang <zhou1615@umn.edu>
    drm/komeda: Fix an undefined behavior bug in komeda_plane_add()

Johannes Berg <johannes.berg@intel.com>
    nl80211: show SSID for P2P_GO interfaces

Paolo Abeni <pabeni@redhat.com>
    mptcp: reset the packet scheduler on PRIO change

Paolo Abeni <pabeni@redhat.com>
    mptcp: reset the packet scheduler on incoming MP_PRIO

Paolo Abeni <pabeni@redhat.com>
    mptcp: optimize release_cb for the common case

Maciej W. Rozycki <macro@orcam.me.uk>
    x86/PCI: Fix ALi M1487 (IBC) PIRQ router link value interpretation

Andrii Nakryiko <andrii@kernel.org>
    libbpf: Don't error out on CO-RE relos for overriden weak subprogs

Maxime Ripard <maxime@cerno.tech>
    drm/vc4: txp: Force alpha to be 0xff if it's disabled

Maxime Ripard <maxime@cerno.tech>
    drm/vc4: txp: Don't set TXP_VSTART_AT_EOF

Maxime Ripard <maxime@cerno.tech>
    drm/vc4: hvs: Reset muxes at probe time

Miles Chen <miles.chen@mediatek.com>
    drm/mediatek: Fix mtk_cec_mask()

Maxime Ripard <maxime@cerno.tech>
    drm/vc4: hvs: Fix frame count register readout

Maxime Ripard <maxime@cerno.tech>
    drm/vc4: kms: Take old state core clock rate into account

Chen-Yu Tsai <wenst@chromium.org>
    drm/mediatek: Fix DPI component detection for MT8192

Rex-BC Chen <rex-bc.chen@mediatek.com>
    drm/mediatek: Add vblank register/unregister callback functions

Ammar Faizi <ammarfaizi2@gnuweeb.org>
    x86/delay: Fix the wrong asm constraint in delay_loop()

Miaoqian Lin <linmq006@gmail.com>
    ASoC: mediatek: Fix missing of_node_put in mt2701_wm8960_machine_probe

Miaoqian Lin <linmq006@gmail.com>
    ASoC: mediatek: Fix error handling in mt8173_max98090_dev_probe

Hui Wang <hui.wang@canonical.com>
    ASoC: cs35l41: Fix an out-of-bounds access in otp_packed_element_t

Kuldeep Singh <singh.kuldeep87k@gmail.com>
    spi: qcom-qspi: Add minItems to interconnect-names

Chuanhong Guo <gch981213@gmail.com>
    mtd: spinand: gigadevice: fix Quad IO for GD5F1GQ5UExxG

Marek Vasut <marex@denx.de>
    drm: bridge: icn6211: Fix HFP_HSW_HBP_HI and HFP_MIN handling

Marek Vasut <marex@denx.de>
    drm: bridge: icn6211: Fix register layout

Lucas Stach <l.stach@pengutronix.de>
    drm/bridge: adv7511: clean up CEC adapter when probe fails

Jani Nikula <jani.nikula@intel.com>
    drm/edid: fix invalid EDID extension block filtering

Wenli Looi <wlooi@ucalgary.ca>
    ath9k: fix ar9003_get_eepmisc

Nicolas Belin <nbelin@baylibre.com>
    drm: bridge: it66121: Fix the register page length

Niels Dossche <dossche.niels@gmail.com>
    ath11k: acquire ab->base_lock in unassign when finding the peer by addr

Zack Rusin <zackr@vmware.com>
    drm/vmwgfx: Fix an invalid read

Noralf Trønnes <noralf@tronnes.org>
    dt-bindings: display: sitronix, st7735r: Fix backlight in example

Wan Jiabing <wanjiabing@vivo.com>
    drm/omap: fix NULL but dereferenced coccicheck error

Nikita Yushchenko <nikita.yoush@cogentembedded.com>
    drm/bridge_connector: enable HPD by default if supported

Linus Torvalds <torvalds@linux-foundation.org>
    drm: fix EDID struct for old ARM OABI format

Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
    Input: gpio-keys - cancel delayed work only in case of GPIO

Shyam Prasad N <sprasad@microsoft.com>
    cifs: do not use tcpStatus after negotiate completes

Douglas Miller <doug.miller@cornelisnetworks.com>
    RDMA/hfi1: Prevent panic when SDMA is disabled

Steve French <stfrench@microsoft.com>
    smb3: check for null tcon

Vasily Averin <vvs@openvz.org>
    fanotify: fix incorrect fmode_t casts

Peng Wu <wupeng58@huawei.com>
    powerpc/iommu: Add missing of_node_put in iommu_init_early_dart

Finn Thain <fthain@linux-m68k.org>
    macintosh/via-pmu: Fix build failure when CONFIG_INPUT is disabled

Lv Ruyi <lv.ruyi@zte.com.cn>
    powerpc/powernv: fix missing of_node_put in uv_init()

Lv Ruyi <lv.ruyi@zte.com.cn>
    powerpc/xics: fix refcount leak in icp_opal_init()

Haren Myneni <haren@linux.ibm.com>
    powerpc/powernv/vas: Assign real address to rx_fifo in vas_rx_win_attr

Enzo Matsumiya <ematsumiya@suse.de>
    cifs: return ENOENT for DFS lookup_cache_entry()

Vasily Averin <vvs@openvz.org>
    tracing: incorrect isolate_mote_t cast in mm_vmscan_lru_isolate

Matthew Wilcox (Oracle) <willy@infradead.org>
    alpha: fix alloc_zeroed_user_highpage_movable()

Nicholas Piggin <npiggin@gmail.com>
    KVM: PPC: Book3S HV Nested: L2 LPCR should inherit L1 LPES setting

Parshuram Thombare <pthombar@cadence.com>
    PCI: cadence: Clear FLR in device capabilities register

Yicong Yang <yangyicong@hisilicon.com>
    PCI: Avoid pci_dev_lock() AB/BA deadlock with sriov_numvfs_store()

Laurent Dufour <ldufour@linux.ibm.com>
    powerpc/rtas: Keep MSR[RI] set when calling RTAS

Conor Dooley <conor.dooley@microchip.com>
    PCI: microchip: Add missing chained_irq_enter()/exit() calls

Viresh Kumar <viresh.kumar@linaro.org>
    cpufreq: Avoid unnecessary frequency updates due to mismatch

Peng Wu <wupeng58@huawei.com>
    ARM: hisi: Add missing of_node_put after of_find_compatible_node

Vijaya Krishna Nivarthi <quic_vnivarth@quicinc.com>
    arm64: dts: qcom: sc7280-idp: Configure CTS pin to bias-bus-hold for bluetooth

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    ARM: dts: exynos: add atmel,24c128 fallback to Samsung EEPROM

Peng Wu <wupeng58@huawei.com>
    ARM: versatile: Add missing of_node_put in dcscb_init

Yang Yingliang <yangyingliang@huawei.com>
    pinctrl: renesas: rzn1: Fix possible null-ptr-deref in sh_pfc_map_resources()

OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
    fat: add ratelimit to fat*_ent_bread()

Hari Bathini <hbathini@linux.ibm.com>
    powerpc/fadump: Fix fadump to work with a different endian capture kernel

Janusz Krzysztofik <jmkrzyszt@gmail.com>
    ARM: OMAP1: clock: Fix UART rate reporting algorithm

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Move generic implicit fb quirk entries into quirks.c

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Add quirk bits for enabling/disabling generic implicit fb

Joel Selvaraj <jo@jsfamily.in>
    arm64: dts: qcom: sdm845-xiaomi-beryllium: fix typo in panel's vddio-supply property

Zixuan Fu <r33s3n6@gmail.com>
    fs: jfs: fix possible NULL pointer dereference in dbFree()

QintaoShen <unSimple1993@163.com>
    soc: ti: ti_sci_pm_domains: Check for null return of devm_kcalloc

Marco Chiappero <marco.chiappero@intel.com>
    crypto: qat - fix off-by-one error in PFVF debug print

Gilad Ben-Yossef <gilad@benyossef.com>
    crypto: ccree - use fine grained DMA mapping dir

Brian Norris <briannorris@chromium.org>
    PM / devfreq: rk3399_dmc: Disable edev on remove()

Konrad Dybcio <konrad.dybcio@somainline.org>
    arm64: dts: qcom: msm8994: Fix BLSP[12]_DMA channels count

Konrad Dybcio <konrad.dybcio@somainline.org>
    arm64: dts: qcom: msm8994: Fix the cont_splash_mem address

Mario Limonciello <mario.limonciello@amd.com>
    ASoC: amd: Add driver data to acp6x machine driver

Krzysztof Kozlowski <krzk@kernel.org>
    ARM: dts: s5pv210: align DMA channels with dtschema

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    ARM: dts: socfpga: align interrupt controller node name with dtschema

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    ARM: dts: ox820: align interrupt controller node name with dtschema

Mika Westerberg <mika.westerberg@linux.intel.com>
    PCI/ASPM: Make Intel DG2 L1 acceptable latency unlimited

Niels Dossche <dossche.niels@gmail.com>
    IB/rdmavt: add missing locks in rvt_ruc_loopback

Daniel Latypov <dlatypov@google.com>
    kunit: fix executor OOM error handling logic on non-UML

Bodo Stroesser <bostroesser@gmail.com>
    scsi: target: tcmu: Avoid holding XArray lock when calling lock_page

Bob Peterson <rpeterso@redhat.com>
    gfs2: use i_lock spin_lock for inode qadata

Yonghong Song <yhs@fb.com>
    selftests/bpf: fix btf_dump/btf_dump due to recent clang change

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    char: tpm: cr50_i2c: Suppress duplicated error message in .remove()

Jakub Kicinski <kuba@kernel.org>
    eth: tg3: silence the GCC 12 array-bounds warning

David Howells <dhowells@redhat.com>
    afs: Adjust ACK interpretation to try and cope with NAT

David Howells <dhowells@redhat.com>
    rxrpc, afs: Fix selection of abort codes

David Howells <dhowells@redhat.com>
    rxrpc: Return an error to sendmsg if call failed

Geert Uytterhoeven <geert@linux-m68k.org>
    m68k: atari: Make Atari ROM port I/O write macros return void

Yuntao Wang <ytcoode@gmail.com>
    selftests/bpf: Add missing trampoline program type to trampoline_count test

Alex Elder <elder@linaro.org>
    net: ipa: ignore endianness if there is no header

Borislav Petkov <bp@suse.de>
    x86/microcode: Add explicit CPU vendor dependency

Vincent Mailhol <mailhol.vincent@wanadoo.fr>
    can: mcp251xfd: silence clang's -Wunaligned-access warning

Chaitanya Kulkarni <kch@nvidia.com>
    nvme: set non-mdts limits in nvme_scan_work

Pierre Gondois <Pierre.Gondois@arm.com>
    ACPI: CPPC: Assume no transition latency if no PCCT

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    ASoC: rt1015p: remove dependency on GPIOLIB

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    ASoC: max98357a: remove dependency on GPIOLIB

Laibin Qiu <qiulaibin@huawei.com>
    blk-throttle: Set BIO_THROTTLED when bio has been throttled

Andre Przywara <andre.przywara@arm.com>
    of/fdt: Ignore disabled memory nodes

Ping-Ke Shih <pkshih@realtek.com>
    rtw89: cfo: check mac_id to avoid out-of-bounds

Nicolas Dufresne <nicolas.dufresne@collabora.com>
    media: hantro: Stop using H.264 parameter pic_num

Kwanghoon Son <k.son@samsung.com>
    media: exynos4-is: Fix compile warning

Fabio Estevam <festevam@denx.de>
    net: phy: micrel: Allow probing without .driver_data

Daniel Latypov <dlatypov@google.com>
    kunit: tool: make parser stop overwriting status of suites w/ no_tests

Omar Sandoval <osandov@fb.com>
    btrfs: fix anon_dev leak in create_subvol()

Sathishkumar S <sathishkumar.sundararaju@amd.com>
    drm/amd/pm: update smartshift powerboost calc for smu13

Sathishkumar S <sathishkumar.sundararaju@amd.com>
    drm/amd/pm: update smartshift powerboost calc for smu12

Xie Yongji <xieyongji@bytedance.com>
    nbd: Fix hung on disconnect request if socket is closed before

Lin Ma <linma@zju.edu.cn>
    ASoC: rt5645: Fix errorenous cleanup order

Smith, Kyle Miller (Nimble Kernel) <kyles@hpe.com>
    nvme-pci: fix a NULL pointer dereference in nvme_alloc_admin_tags

Jason A. Donenfeld <Jason@zx2c4.com>
    openrisc: start CPU timer early in boot

Zijun Hu <quic_zijuhu@quicinc.com>
    Bluetooth: btusb: Set HCI_QUIRK_BROKEN_ERR_DATA_REPORTING for QCA

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: btusb: Set HCI_QUIRK_BROKEN_ENHANCED_SETUP_SYNC_CONN for QCA

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: HCI: Add HCI_QUIRK_BROKEN_ENHANCED_SETUP_SYNC_CONN quirk

Lukas Wunner <lukas@wunner.de>
    usbnet: Run unregister_netdev() before unbind() again

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    media: cec-adap.c: fix is_configuring state

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    media: imon: reorganize serialization

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    media: ccs-core.c: fix failure to call clk_disable_unprepare

Benjamin Gaignard <benjamin.gaignard@collabora.com>
    media: hantro: HEVC: unconditionnaly set pps_{cb/cr}_qp_offset values

Philipp Zabel <p.zabel@pengutronix.de>
    media: coda: limit frame interval enumeration to supported encoder frame sizes

Hangyu Hua <hbh25y@gmail.com>
    media: rga: fix possible memory leak in rga_probe

Felix Fietkau <nbd@nbd.name>
    mt76: fix encap offload ethernet type check

Felix Fietkau <nbd@nbd.name>
    mt76: mt7921: accept rx frames with non-standard VHT MCS10-11

Dongliang Mu <mudongliangabcd@gmail.com>
    rtlwifi: Use pr_warn instead of WARN_ONCE

Daniel Latypov <dlatypov@google.com>
    kunit: bail out of test filtering logic quicker if OOM

Corey Minyard <cminyard@mvista.com>
    ipmi: Fix pr_fmt to avoid compilation issues

Corey Minyard <cminyard@mvista.com>
    ipmi: Add an intializer for ipmi_smi_msg struct

Corey Minyard <cminyard@mvista.com>
    ipmi:ssif: Check for NULL msg when handling events and messages

Mario Limonciello <mario.limonciello@amd.com>
    ACPI: PM: Block ASUS B1400CEAE from suspend to idle by default

Zheng Bin <zhengbin13@huawei.com>
    ASoC: SOF: amd: add missing platform_device_unregister in acp_pci_rn_probe

Mikulas Patocka <mpatocka@redhat.com>
    dma-debug: change allocation mode from GFP_NOWAIT to GFP_ATIOMIC

Patrice Chotard <patrice.chotard@foss.st.com>
    spi: stm32-qspi: Fix wait_cmd timeout in APM mode

Hao Jia <jiahao.os@bytedance.com>
    sched/core: Avoid obvious double update_rq_clock warning

Ravi Bangoria <ravi.bangoria@amd.com>
    perf/amd/ibs: Cascade pmu init functions' return value

Heiko Carstens <hca@linux.ibm.com>
    s390/preempt: disable __preempt_count_add() optimization for PROFILE_ALL_BRANCHES

Eric Dumazet <edumazet@google.com>
    net: remove two BUG() from skb_checksum_help()

James Smart <jsmart2021@gmail.com>
    scsi: lpfc: Alter FPIN stat accounting logic

Xiang Chen <chenxiang66@hisilicon.com>
    scsi: hisi_sas: Undo RPM resume for failed notify phy event for v3 HW

Gavin Li <gavinl@nvidia.com>
    net/mlx5: Increase FW pre-init timeout for health recovery

Charles Keepax <ckeepax@opensource.cirrus.com>
    ASoC: tscs454: Add endianness flag in snd_soc_component_driver

Zhen Lei <thunder.leizhen@huawei.com>
    of: Support more than one crash kernel regions for kexec -s

Thierry Reding <treding@nvidia.com>
    drm/tegra: gem: Do not try to dereference ERR_PTR()

Dongliang Mu <mudongliangabcd@gmail.com>
    HID: bigben: fix slab-out-of-bounds Write in bigben_probe

Nícolas F. R. A. Prado <nfraprado@collabora.com>
    regulator: mt6315: Enforce regulator-compatible, not name

Alice Wong <shiwei.wong@amd.com>
    drm/amdgpu/ucode: Remove firmware load type check in amdgpu_ucode_free_bo

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/psp: move PSP memory alloc from hw_init to sw_init

Petr Machata <petrm@nvidia.com>
    mlxsw: Treat LLDP packets as control

Petr Machata <petrm@nvidia.com>
    mlxsw: spectrum_dcb: Do not warn about priority changes

Mark Brown <broonie@kernel.org>
    ASoC: dapm: Don't fold register value changes into notifications

Mark Bloch <mbloch@nvidia.com>
    net/mlx5: fs, delete the FTE when there are no rules attached to it

jianghaoran <jianghaoran@kylinos.cn>
    ipv6: Don't send rs packets to the interface of ARPHRD_TUNNEL

Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
    scsi: target: tcmu: Fix possible data corruption

Wen Gong <quic_wgong@quicinc.com>
    ath11k: fix warning of not found station for bssid in message

Max Filippov <jcmvbkbc@gmail.com>
    xtensa: move trace_hardirqs_off call back to entry.S

Jessica Zhang <quic_jesszhan@quicinc.com>
    drm/msm/dpu: Clean up CRC debug logs

Lv Ruyi <lv.ruyi@zte.com.cn>
    drm: msm: fix error check return value of irq_of_parse_and_map()

Alexandru Elisei <alexandru.elisei@arm.com>
    arm64: compat: Do not treat syscall number as ESR_ELx for a bad syscall

Abhishek Kumar <kuabhs@chromium.org>
    ath10k: skip ath10k_halt during suspend for driver state RESTARTING

Evan Quan <evan.quan@amd.com>
    drm/amd/pm: fix the compile warning

Steven Price <steven.price@arm.com>
    drm/plane: Move range check for format_count earlier

Hans de Goede <hdegoede@redhat.com>
    ASoC: Intel: bytcr_rt5640: Add quirk for the HP Pro Tablet 408

Hari Chandrakanthan <quic_haric@quicinc.com>
    ath11k: disable spectral scan during spectral deinit

James Smart <jsmart2021@gmail.com>
    scsi: lpfc: Fix resource leak in lpfc_sli4_send_seq_to_ulp()

Minghao Chi <chi.minghao@zte.com.cn>
    scsi: ufs: Use pm_runtime_resume_and_get() instead of pm_runtime_get_sync()

Haohui Mai <ricetons@gmail.com>
    drm/amdgpu/sdma: Fix incorrect calculations of the wptr of the doorbells

Lv Ruyi <lv.ruyi@zte.com.cn>
    scsi: megaraid: Fix error check return value of register_chrdev()

Vignesh Raghavendra <vigneshr@ti.com>
    drivers: mmc: sdhci_am654: Add the quirk to set TESTCD bit

Aidan MacDonald <aidanmacdonald.0x0@gmail.com>
    mmc: jz4740: Apply DMA engine limits to maximum segment size

Heming Zhao <heming.zhao@suse.com>
    md/bitmap: don't set sb values if can't pass sanity check

Zheyu Ma <zheyuma97@gmail.com>
    media: cx25821: Fix the warning when removing the module

Zheyu Ma <zheyuma97@gmail.com>
    media: pci: cx23885: Fix the error handling in cx23885_initdev()

Vikash Garodia <quic_vgarodia@quicinc.com>
    media: venus: do not queue internal buffers from previous sequence

Luca Weiss <luca.weiss@fairphone.com>
    media: venus: hfi: avoid null dereference in deinit

Sakari Ailus <sakari.ailus@linux.intel.com>
    media: Revert "media: dw9768: activate runtime PM and turn off device"

Thibaut VARÈNE <hacks+kernel@slashdirt.org>
    ath9k: fix QCA9561 PA bias level

Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
    ASoC: rsnd: care return value from rsnd_node_fixed_index()

Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
    ASoC: rsnd: care default case on rsnd_ssiu_busif_err_status_clear()

Keita Suzuki <keitasuzuki.park@sslab.ics.keio.ac.jp>
    drm/amd/pm: fix double free in si_parse_power_table()

Ulf Hansson <ulf.hansson@linaro.org>
    cpuidle: PSCI: Improve support for suspend-to-RAM for PSCI OSI mode

James Smart <jsmart2021@gmail.com>
    scsi: lpfc: Fix call trace observed during I/O with CMF enabled

James Smart <jsmart2021@gmail.com>
    scsi: lpfc: Fix SCSI I/O completion and abort handler deadlock

James Smart <jsmart2021@gmail.com>
    scsi: lpfc: Move cfg_log_verbose check before calling lpfc_dmp_dbg()

Eric Dumazet <edumazet@google.com>
    tcp: consume incoming skb leading to a reset

Len Brown <len.brown@intel.com>
    tools/power turbostat: fix ICX DRAM power numbers

Biju Das <biju.das.jz@bp.renesas.com>
    spi: spi-rspi: Remove setting {src,dst}_{addr,addr_width} based on DMA direction

Po-Hao Huang <phhuang@realtek.com>
    rtw88: 8821c: fix debugfs rssi value

Po-Hao Huang <phhuang@realtek.com>
    rtw88: fix incorrect frequency reported

Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>
    ALSA: jack: Access input_dev under mutex

Haowen Bai <baihaowen@meizu.com>
    sfc: ef10: Fix assigning negative value to unsigned variable

Paul E. McKenney <paulmck@kernel.org>
    rcu: Make TASKS_RUDE_RCU select IRQ_WORK

Paul E. McKenney <paulmck@kernel.org>
    rcu-tasks: Handle sparse cpu_possible_mask in rcu_tasks_invoke_cbs()

Padmanabha Srinivasaiah <treasure4paddy@gmail.com>
    rcu-tasks: Fix race in schedule and flush work

Saaem Rizvi <syerizvi@amd.com>
    drm/amd/display: Disabling Z10 on DCN31

Liviu Dudau <liviu.dudau@arm.com>
    drm/komeda: return early if drm_universal_plane_init() fails.

Peter Seiderer <ps.report@gmx.net>
    mac80211: minstrel_ht: fix where rate stats are stored (fixes debugfs output)

Runqing Yang <rainkin1993@gmail.com>
    libbpf: Fix a bug with checking bpf_probe_read_kernel() support in old kernels

Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
    ACPICA: Avoid cache flush inside virtual machines

Mike Travis <mike.travis@hpe.com>
    x86/platform/uv: Update TSC sync state for UV5

Daniel Vetter <daniel.vetter@ffwll.ch>
    fbcon: Consistently protect deferred_takeover with console_lock()

Niels Dossche <dossche.niels@gmail.com>
    ipv6: fix locking issues with loops over idev->addr_list

Haowen Bai <baihaowen@meizu.com>
    ipw2x00: Fix potential NULL dereference in libipw_xmit()

Haowen Bai <baihaowen@meizu.com>
    b43: Fix assigning negative value to unsigned variable

Haowen Bai <baihaowen@meizu.com>
    b43legacy: Fix assigning negative value to unsigned variable

Niels Dossche <dossche.niels@gmail.com>
    mwifiex: add mutex lock for call in mwifiex_dfs_chan_sw_work_queue

Karthikeyan Kathirvel <quic_kathirve@quicinc.com>
    ath11k: Change max no of active probe SSID and BSSID to fw capability

Quentin Monnet <quentin@isovalent.com>
    selftests/bpf: Fix parsing of prog types in UAPI hdr for bpftool sync

Nikolay Borisov <nborisov@suse.com>
    selftests/bpf: Fix vfs_link kprobe definition

Liu Zixian <liuzixian4@huawei.com>
    drm/virtio: fix NULL pointer dereference in virtio_gpu_conn_get_modes

Wen Gong <quic_wgong@quicinc.com>
    ath11k: fix the warning of dev_wake in mhi_pm_disable_transition()

Zack Rusin <zackr@vmware.com>
    drm/vmwgfx: validate the screen formats

Tejas Upadhyay <tejaskumarx.surendrakumar.upadhyay@intel.com>
    iommu/vt-d: Add RPLS to quirk list to skip TE disabling

Naohiro Aota <naohiro.aota@wdc.com>
    btrfs: zoned: fix comparison of alloc_offset vs meta_write_pointer

Naohiro Aota <naohiro.aota@wdc.com>
    btrfs: zoned: finish block group when there are no more allocatable bytes left

Naohiro Aota <naohiro.aota@wdc.com>
    btrfs: zoned: zone finish unused block group

Naohiro Aota <naohiro.aota@wdc.com>
    btrfs: zoned: properly finish block group on metadata write

Qu Wenruo <wqu@suse.com>
    btrfs: fix the error handling for submit_extent_page() for btrfs_do_readpage()

Qu Wenruo <wqu@suse.com>
    btrfs: repair super block num_devices automatically

Qu Wenruo <wqu@suse.com>
    btrfs: return correct error number for __extent_writepage_io()

Qu Wenruo <wqu@suse.com>
    btrfs: add "0x" prefix for unsupported optional features

Eric W. Biederman <ebiederm@xmission.com>
    ptrace: Reimplement PTRACE_KILL by always sending SIGKILL

Eric W. Biederman <ebiederm@xmission.com>
    ptrace/xtensa: Replace PT_SINGLESTEP with TIF_SINGLESTEP

Eric W. Biederman <ebiederm@xmission.com>
    ptrace/um: Replace PT_DTRACE with TIF_SINGLESTEP

Eric W. Biederman <ebiederm@xmission.com>
    kthread: Don't allocate kthread_struct for init and umh

Kristen Carlson Accardi <kristen@linux.intel.com>
    x86/sgx: Set active memcg prior to shmem allocation

Baoquan He <bhe@redhat.com>
    x86/kexec: fix memory leak of elf header buffer

Kan Liang <kan.liang@linux.intel.com>
    perf/x86/intel: Fix event constraints for ICL

Ammar Faizi <ammarfaizi2@gnuweeb.org>
    x86/MCE/AMD: Fix memory leak when threshold_create_bank() fails

Michael Niewöhner <linux@mniewoehner.de>
    platform/x86: intel-hid: fix _DSM function index handling

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: Allow host runtime PM as default for Intel Alder Lake N xHCI

Ronnie Sahlberg <lsahlber@redhat.com>
    cifs: when extending a file with falloc we should make files not-sparse

Ronnie Sahlberg <lsahlber@redhat.com>
    cifs: fix potential double free during failed mount

Paulo Alcantara <pc@cjr.nz>
    cifs: fix ntlmssp on old servers

Enzo Matsumiya <ematsumiya@suse.de>
    cifs: don't call cifs_dfs_query_info_nonascii_quirk() if nodfs was set

Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
    fs/ntfs3: Restore ntfs_xattr_get_acl and ntfs_xattr_set_acl functions

Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
    fs/ntfs3: Update i_ctime when xattr is added

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    fs/ntfs3: Fix some memory leaks in an error handling path of 'log_replay()'

Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
    fs/ntfs3: In function ntfs_set_acl_ex do not change inode->i_mode if called from function ntfs_init_acl

Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
    fs/ntfs3: Check new size for limits

Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
    fs/ntfs3: Keep preallocated only if option prealloc enabled

Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
    fs/ntfs3: Fix fiemap + fix shrink file size (to remove preallocated space)

Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
    fs/ntfs3: Update valid size if -EIOCBQUEUED

Kishon Vijay Abraham I <kishon@ti.com>
    usb: core: hcd: Add support for deferring roothub registration

Albert Wang <albertccwang@google.com>
    usb: dwc3: gadget: Move null pinter check to proper place

Linus Walleij <linus.walleij@linaro.org>
    usb: isp1760: Fix out-of-bounds array access

Monish Kumar R <monish.kumar.r@intel.com>
    USB: new quirk for Dell Gen 2 devices

Carl Yin(殷张成) <carl.yin@quectel.com>
    USB: serial: option: add Quectel BG95 modem

Johan Hovold <johan@kernel.org>
    USB: serial: pl2303: fix type detection for odd device

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Cancel pending work at closing a MIDI substream

Marios Levogiannis <marios.levogiannis@gmail.com>
    ALSA: hda/realtek - Fix microphone noise on ASUS TUF B550M-PLUS

Rik van der Kemp <rik@upto11.nl>
    ALSA: hda/realtek: Enable 4-speaker output for Dell XPS 15 9520 laptop

Kailang Yang <kailang@realtek.com>
    ALSA: hda/realtek - Add new type for ALC245

Nathan Chancellor <nathan@kernel.org>
    riscv: Move alternative length validation into subsection

Tobias Klauser <tklauser@distanz.ch>
    riscv: Wire up memfd_secret in UAPI header

Samuel Holland <samuel@sholland.org>
    riscv: Fix irq_work when SMP is disabled

Alexandre Ghiti <alexandre.ghiti@canonical.com>
    riscv: Initialize thread pointer before calling C functions

Xianting Tian <xianting.tian@linux.alibaba.com>
    RISC-V: Mark IORESOURCE_EXCLUSIVE for reserved mem instead of IORESOURCE_BUSY

Helge Deller <deller@gmx.de>
    parisc/stifb: Keep track of hardware path of graphics card

Helge Deller <deller@gmx.de>
    parisc/stifb: Implement fb_is_primary_device()

Niklas Cassel <niklas.cassel@wdc.com>
    binfmt_flat: do not stop relocating GOT entries prematurely on riscv

Stephen Boyd <swboyd@chromium.org>
    arm64: Initialize jump labels before setup_machine_fdt()


-------------

Diffstat:

 Documentation/accounting/psi.rst                   |   9 +-
 Documentation/conf.py                              |   2 +-
 .../bindings/display/sitronix,st7735r.yaml         |   1 +
 .../devicetree/bindings/gpio/gpio-altera.txt       |   5 +-
 .../bindings/regulator/mt6315-regulator.yaml       |   2 +-
 .../devicetree/bindings/soc/qcom/qcom,smd-rpm.yaml |   1 +
 .../bindings/spi/qcom,spi-qcom-qspi.yaml           |   1 +
 Documentation/sound/alsa-configuration.rst         |   4 +-
 Documentation/userspace-api/landlock.rst           |   4 +-
 Makefile                                           |   4 +-
 arch/alpha/include/asm/page.h                      |   2 +-
 arch/arm/boot/dts/bcm2835-rpi-b.dts                |  13 +-
 arch/arm/boot/dts/bcm2835-rpi-zero-w.dts           |  22 +-
 arch/arm/boot/dts/bcm2837-rpi-3-b-plus.dts         |   2 +-
 arch/arm/boot/dts/bcm2837-rpi-cm3-io3.dts          |   4 +-
 arch/arm/boot/dts/bcm5301x.dtsi                    |   2 +-
 arch/arm/boot/dts/exynos5250-smdk5250.dts          |   4 +-
 arch/arm/boot/dts/imx6dl-eckelmann-ci4x10.dts      |   6 +-
 arch/arm/boot/dts/imx6qdl-colibri.dtsi             |   6 +-
 arch/arm/boot/dts/ox820.dtsi                       |   2 +-
 arch/arm/boot/dts/qcom-sdx65.dtsi                  |   2 +-
 arch/arm/boot/dts/s5pv210-aries.dtsi               |   3 +-
 arch/arm/boot/dts/s5pv210.dtsi                     |  12 +-
 arch/arm/boot/dts/sama7g5.dtsi                     |   1 -
 arch/arm/boot/dts/socfpga.dtsi                     |   2 +-
 arch/arm/boot/dts/socfpga_arria10.dtsi             |   2 +-
 arch/arm/boot/dts/stm32mp15xx-dhcor-avenger96.dtsi |   1 +
 arch/arm/boot/dts/suniv-f1c100s.dtsi               |   4 +-
 arch/arm/include/asm/arch_gicv3.h                  |   7 +-
 arch/arm/kernel/signal.c                           |   1 +
 arch/arm/mach-hisi/platsmp.c                       |   4 +
 arch/arm/mach-mediatek/Kconfig                     |   1 +
 arch/arm/mach-omap1/clock.c                        |   2 +-
 arch/arm/mach-pxa/cm-x300.c                        |   8 +-
 arch/arm/mach-pxa/magician.c                       |   2 +-
 arch/arm/mach-pxa/tosa.c                           |   4 +-
 arch/arm/mach-vexpress/dcscb.c                     |   1 +
 arch/arm64/Kconfig.platforms                       |   1 +
 .../dts/marvell/armada-3720-espressobin-ultra.dts  |   5 -
 arch/arm64/boot/dts/mediatek/mt8192.dtsi           |   2 +-
 arch/arm64/boot/dts/nvidia/tegra210.dtsi           |   5 +-
 arch/arm64/boot/dts/qcom/ipq8074.dtsi              |   2 +-
 arch/arm64/boot/dts/qcom/msm8994.dtsi              |   8 +-
 arch/arm64/boot/dts/qcom/qrb5165-rb5.dts           |   2 +-
 arch/arm64/boot/dts/qcom/sc7280-idp.dtsi           |  18 +-
 .../boot/dts/qcom/sdm845-xiaomi-beryllium.dts      |   2 +-
 arch/arm64/boot/dts/rockchip/rk3399.dtsi           |   2 +-
 arch/arm64/boot/dts/ti/k3-am64-mcu.dtsi            |   2 -
 arch/arm64/include/asm/arch_gicv3.h                |   6 -
 arch/arm64/include/asm/processor.h                 |  10 +-
 arch/arm64/kernel/setup.c                          |   7 +-
 arch/arm64/kernel/signal.c                         |   1 +
 arch/arm64/kernel/signal32.c                       |   1 +
 arch/arm64/kernel/sys_compat.c                     |   2 +-
 arch/arm64/mm/copypage.c                           |   4 +-
 arch/csky/kernel/probes/kprobes.c                  |   2 +-
 arch/m68k/Kconfig.cpu                              |   2 +-
 arch/m68k/include/asm/raw_io.h                     |   6 +-
 arch/m68k/kernel/signal.c                          |   1 +
 .../include/asm/mach-ip27/cpu-feature-overrides.h  |   1 -
 .../include/asm/mach-ip30/cpu-feature-overrides.h  |   1 -
 arch/mips/include/asm/mach-ralink/spaces.h         |   2 +
 arch/openrisc/include/asm/timex.h                  |   1 +
 arch/openrisc/kernel/head.S                        |   9 +
 arch/parisc/include/asm/fb.h                       |   4 +
 arch/powerpc/include/asm/page.h                    |   7 +-
 arch/powerpc/include/asm/vas.h                     |   2 +-
 arch/powerpc/kernel/entry_64.S                     |  24 +-
 arch/powerpc/kernel/fadump.c                       |   8 +-
 arch/powerpc/kernel/idle.c                         |   2 +-
 arch/powerpc/kernel/rtas.c                         |   9 +
 arch/powerpc/kvm/book3s_hv.c                       |  12 +-
 arch/powerpc/kvm/book3s_hv_nested.c                |   3 +-
 arch/powerpc/kvm/trace_hv.h                        |   8 +-
 arch/powerpc/mm/nohash/fsl_book3e.c                |  15 +-
 arch/powerpc/perf/isa207-common.c                  |  12 +-
 arch/powerpc/platforms/4xx/cpm.c                   |   2 +-
 arch/powerpc/platforms/8xx/cpm1.c                  |   1 +
 arch/powerpc/platforms/powernv/opal-fadump.c       |  94 +--
 arch/powerpc/platforms/powernv/opal-fadump.h       |  10 +-
 arch/powerpc/platforms/powernv/setup.c             |   9 +
 arch/powerpc/platforms/powernv/ultravisor.c        |   1 +
 arch/powerpc/platforms/powernv/vas-fault.c         |   2 +-
 arch/powerpc/platforms/powernv/vas-window.c        |   4 +-
 arch/powerpc/platforms/powernv/vas.h               |   2 +-
 arch/powerpc/sysdev/dart_iommu.c                   |   6 +-
 arch/powerpc/sysdev/fsl_rio.c                      |   2 +
 arch/powerpc/sysdev/xics/icp-opal.c                |   1 +
 arch/powerpc/sysdev/xive/spapr.c                   |  43 +-
 arch/riscv/Makefile                                |   4 +
 arch/riscv/include/asm/alternative-macros.h        |   4 +-
 arch/riscv/include/asm/irq_work.h                  |   2 +-
 arch/riscv/include/asm/unistd.h                    |   1 -
 arch/riscv/include/uapi/asm/unistd.h               |   1 +
 arch/riscv/kernel/head.S                           |   1 +
 arch/riscv/kernel/setup.c                          |   4 +-
 arch/riscv/mm/init.c                               |   2 +-
 arch/s390/include/asm/cio.h                        |   2 +-
 arch/s390/include/asm/kexec.h                      |  10 +
 arch/s390/include/asm/preempt.h                    |  15 +-
 arch/s390/kernel/perf_event.c                      |   2 +-
 arch/s390/kernel/time.c                            |   8 +-
 arch/sparc/kernel/signal32.c                       |   1 +
 arch/sparc/kernel/signal_64.c                      |   1 +
 arch/um/drivers/chan_user.c                        |   9 +-
 arch/um/drivers/virtio_uml.c                       |  33 +-
 arch/um/include/asm/Kbuild                         |   1 +
 arch/um/include/asm/thread_info.h                  |   2 +
 arch/um/kernel/exec.c                              |   2 +-
 arch/um/kernel/process.c                           |   2 +-
 arch/um/kernel/ptrace.c                            |   8 +-
 arch/um/kernel/signal.c                            |   4 +-
 arch/x86/Kconfig                                   |   4 +-
 arch/x86/entry/entry_64.S                          |   1 +
 arch/x86/entry/vdso/vma.c                          |   2 +-
 arch/x86/events/amd/ibs.c                          |  55 +-
 arch/x86/events/intel/core.c                       |   2 +-
 arch/x86/include/asm/acenv.h                       |  14 +-
 arch/x86/include/asm/kexec.h                       |   8 +
 arch/x86/include/asm/set_memory.h                  |  52 --
 arch/x86/include/asm/suspend_32.h                  |   2 +-
 arch/x86/include/asm/suspend_64.h                  |  12 +-
 arch/x86/kernel/apic/apic.c                        |   2 +-
 arch/x86/kernel/apic/x2apic_uv_x.c                 |   8 +-
 arch/x86/kernel/cpu/intel.c                        |   2 +-
 arch/x86/kernel/cpu/mce/amd.c                      |  32 +-
 arch/x86/kernel/cpu/mce/core.c                     |   6 +-
 arch/x86/kernel/cpu/sgx/encl.c                     | 105 ++-
 arch/x86/kernel/cpu/sgx/encl.h                     |   7 +-
 arch/x86/kernel/cpu/sgx/main.c                     |   9 +-
 arch/x86/kernel/machine_kexec_64.c                 |  12 +-
 arch/x86/kernel/signal_compat.c                    |   2 +
 arch/x86/kernel/step.c                             |   3 +-
 arch/x86/kernel/sys_x86_64.c                       |   7 +-
 arch/x86/kvm/lapic.c                               |   1 +
 arch/x86/kvm/vmx/nested.c                          |  45 +-
 arch/x86/kvm/vmx/vmcs.h                            |   5 +
 arch/x86/lib/delay.c                               |   4 +-
 arch/x86/mm/pat/memtype.c                          |   2 +-
 arch/x86/mm/pat/set_memory.c                       |  49 +-
 arch/x86/pci/irq.c                                 |  19 +-
 arch/x86/um/ldt.c                                  |   6 +-
 arch/xtensa/kernel/entry.S                         |  19 +-
 arch/xtensa/kernel/ptrace.c                        |   4 +-
 arch/xtensa/kernel/signal.c                        |   4 +-
 arch/xtensa/kernel/traps.c                         |  11 +-
 arch/xtensa/platforms/iss/simdisk.c                |  18 +-
 block/bfq-cgroup.c                                 | 111 +--
 block/bfq-iosched.c                                |  64 +-
 block/bfq-iosched.h                                |   7 +-
 block/blk-ia-ranges.c                              |   7 +-
 block/blk-iolatency.c                              | 122 ++--
 block/blk-throttle.c                               |   3 +-
 crypto/cryptd.c                                    |  23 +-
 drivers/acpi/cppc_acpi.c                           |  17 +-
 drivers/acpi/property.c                            |  18 +-
 drivers/acpi/sleep.c                               |  12 +
 drivers/base/memory.c                              |   5 +-
 drivers/base/node.c                                |   1 +
 drivers/base/power/domain.c                        |   1 +
 drivers/base/property.c                            |  89 +--
 drivers/block/drbd/drbd_main.c                     |  11 +-
 drivers/block/nbd.c                                |  13 +-
 drivers/block/virtio_blk.c                         |   7 +-
 drivers/bluetooth/btmtksdio.c                      |   3 +-
 drivers/bluetooth/btusb.c                          |   6 +
 drivers/char/hw_random/cn10k-rng.c                 |  31 +-
 drivers/char/hw_random/omap3-rom-rng.c             |   2 +-
 drivers/char/ipmi/ipmi_msghandler.c                |   4 +-
 drivers/char/ipmi/ipmi_poweroff.c                  |   4 +-
 drivers/char/ipmi/ipmi_ssif.c                      |  23 +
 drivers/char/ipmi/ipmi_watchdog.c                  |  14 +-
 drivers/char/random.c                              |  12 +-
 drivers/char/tpm/tpm_tis_i2c_cr50.c                |   4 +-
 drivers/clk/tegra/clk-dfll.c                       |  12 +
 drivers/cpufreq/cpufreq.c                          |  11 +
 drivers/cpufreq/mediatek-cpufreq.c                 |  18 +-
 drivers/cpuidle/cpuidle-psci.c                     |  46 ++
 .../crypto/allwinner/sun8i-ss/sun8i-ss-cipher.c    | 115 ++--
 drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c  |  30 +-
 drivers/crypto/allwinner/sun8i-ss/sun8i-ss-hash.c  |  10 +-
 drivers/crypto/allwinner/sun8i-ss/sun8i-ss.h       |  14 +-
 drivers/crypto/ccp/sev-dev.c                       |  30 +-
 drivers/crypto/ccree/cc_buffer_mgr.c               |  27 +-
 drivers/crypto/marvell/cesa/cipher.c               |   1 -
 drivers/crypto/nx/nx-common-powernv.c              |   2 +-
 drivers/crypto/qat/qat_common/adf_pfvf_pf_proto.c  |   2 +-
 .../crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c |  13 +-
 drivers/devfreq/rk3399_dmc.c                       |   2 +
 drivers/dma/idxd/cdev.c                            |   8 +-
 drivers/dma/stm32-mdma.c                           |  23 +-
 drivers/edac/dmc520_edac.c                         |   2 +-
 drivers/firmware/arm_ffa/driver.c                  |   4 +-
 drivers/firmware/arm_scmi/base.c                   |   2 +-
 drivers/firmware/efi/Kconfig                       |  15 +
 drivers/firmware/efi/efi.c                         |   2 +-
 drivers/gpio/gpio-rockchip.c                       |  24 +-
 drivers/gpio/gpio-sim.c                            |   4 +-
 drivers/gpio/gpiolib-of.c                          |   5 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c             |   2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c            |   1 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c            |  95 ++-
 drivers/gpu/drm/amd/amdgpu/amdgpu_ucode.c          |   3 +-
 drivers/gpu/drm/amd/amdgpu/sdma_v4_0.c             |   4 +-
 drivers/gpu/drm/amd/amdgpu/sdma_v5_0.c             |   8 +-
 drivers/gpu/drm/amd/amdgpu/sdma_v5_2.c             |   8 +-
 .../gpu/drm/amd/display/dc/dcn31/dcn31_resource.c  |   1 +
 drivers/gpu/drm/amd/pm/powerplay/kv_dpm.c          |  14 +-
 drivers/gpu/drm/amd/pm/powerplay/si_dpm.c          |   8 +-
 drivers/gpu/drm/amd/pm/swsmu/smu12/renoir_ppt.c    |  60 +-
 .../gpu/drm/amd/pm/swsmu/smu13/yellow_carp_ppt.c   |  62 +-
 drivers/gpu/drm/arm/display/komeda/komeda_plane.c  |  10 +-
 drivers/gpu/drm/arm/malidp_crtc.c                  |   5 +-
 drivers/gpu/drm/bridge/adv7511/adv7511_drv.c       |   1 +
 drivers/gpu/drm/bridge/analogix/analogix_dp_core.c |  31 +-
 drivers/gpu/drm/bridge/analogix/anx7625.c          |  12 +-
 drivers/gpu/drm/bridge/analogix/anx7625.h          |   4 +-
 drivers/gpu/drm/bridge/chipone-icn6211.c           | 155 ++++-
 drivers/gpu/drm/bridge/ite-it66121.c               |   2 +-
 drivers/gpu/drm/drm_bridge_connector.c             |   4 +-
 drivers/gpu/drm/drm_edid.c                         |   6 +-
 drivers/gpu/drm/drm_plane.c                        |  14 +-
 drivers/gpu/drm/etnaviv/etnaviv_mmu.c              |   6 +
 drivers/gpu/drm/gma500/psb_intel_display.c         |   7 +-
 drivers/gpu/drm/i915/display/intel_dsi_vbt.c       |  33 +-
 drivers/gpu/drm/i915/i915_perf.c                   |   4 +-
 drivers/gpu/drm/i915/i915_perf_types.h             |   2 +-
 drivers/gpu/drm/mediatek/mtk_cec.c                 |   2 +-
 drivers/gpu/drm/mediatek/mtk_disp_drv.h            |  16 +-
 drivers/gpu/drm/mediatek/mtk_disp_ovl.c            |  22 +-
 drivers/gpu/drm/mediatek/mtk_disp_rdma.c           |  20 +-
 drivers/gpu/drm/mediatek/mtk_dpi.c                 |   4 +-
 drivers/gpu/drm/mediatek/mtk_drm_crtc.c            |  14 +-
 drivers/gpu/drm/mediatek/mtk_drm_ddp_comp.c        |   4 +
 drivers/gpu/drm/mediatek/mtk_drm_ddp_comp.h        |  29 +-
 drivers/gpu/drm/mediatek/mtk_drm_drv.c             |   2 +
 drivers/gpu/drm/msm/adreno/a5xx_gpu.c              |  19 +-
 drivers/gpu/drm/msm/adreno/a6xx_gpu.c              |  16 +-
 drivers/gpu/drm/msm/disp/dpu1/dpu_crtc.c           |   3 +-
 drivers/gpu/drm/msm/disp/dpu1/dpu_hw_interrupts.c  |   3 +
 drivers/gpu/drm/msm/disp/dpu1/dpu_hw_intf.c        |   1 +
 drivers/gpu/drm/msm/disp/dpu1/dpu_hw_lm.c          |   2 +-
 drivers/gpu/drm/msm/disp/dpu1/dpu_kms.c            |  10 +-
 drivers/gpu/drm/msm/disp/mdp5/mdp5_crtc.c          |  14 +-
 drivers/gpu/drm/msm/disp/mdp5/mdp5_kms.c           |   6 +-
 drivers/gpu/drm/msm/disp/mdp5/mdp5_mixer.c         |  15 +-
 drivers/gpu/drm/msm/disp/mdp5/mdp5_mixer.h         |   4 +-
 drivers/gpu/drm/msm/disp/mdp5/mdp5_pipe.c          |  15 +-
 drivers/gpu/drm/msm/disp/mdp5/mdp5_pipe.h          |   2 +-
 drivers/gpu/drm/msm/disp/mdp5/mdp5_plane.c         |  20 +-
 drivers/gpu/drm/msm/dp/dp_ctrl.c                   |  16 +-
 drivers/gpu/drm/msm/dp/dp_display.c                |  55 +-
 drivers/gpu/drm/msm/dp/dp_drm.c                    |   4 +
 drivers/gpu/drm/msm/dsi/dsi_host.c                 |  21 +-
 drivers/gpu/drm/msm/dsi/dsi_manager.c              |   3 +
 drivers/gpu/drm/msm/dsi/phy/dsi_phy_14nm.c         |   2 +-
 drivers/gpu/drm/msm/hdmi/hdmi.c                    |  10 +-
 drivers/gpu/drm/msm/hdmi/hdmi_bridge.c             |   3 +
 drivers/gpu/drm/msm/msm_drv.c                      |  11 +-
 drivers/gpu/drm/msm/msm_gem_prime.c                |   2 +-
 drivers/gpu/drm/msm/msm_gpu.h                      |  12 +-
 drivers/gpu/drm/msm/msm_gpu_devfreq.c              |  90 ++-
 drivers/gpu/drm/msm/msm_kms.h                      |   1 +
 drivers/gpu/drm/nouveau/dispnv50/atom.h            |   6 +-
 drivers/gpu/drm/nouveau/dispnv50/crc.c             |  27 +-
 drivers/gpu/drm/nouveau/include/nvkm/core/subdev.h |   2 +
 drivers/gpu/drm/nouveau/nvkm/subdev/bus/gf100.c    |  14 +-
 drivers/gpu/drm/nouveau/nvkm/subdev/bus/nv31.c     |   6 +-
 drivers/gpu/drm/nouveau/nvkm/subdev/bus/nv50.c     |   6 +-
 drivers/gpu/drm/nouveau/nvkm/subdev/clk/base.c     |   6 +-
 drivers/gpu/drm/omapdrm/omap_overlay.c             |   2 +-
 drivers/gpu/drm/panel/panel-simple.c               |   3 +-
 drivers/gpu/drm/rockchip/rockchip_drm_vop.c        |   2 +-
 drivers/gpu/drm/stm/ltdc.c                         |  16 +-
 drivers/gpu/drm/tegra/gem.c                        |   1 +
 drivers/gpu/drm/tilcdc/tilcdc_external.c           |   8 +-
 drivers/gpu/drm/v3d/v3d_perfmon.c                  |   3 +-
 drivers/gpu/drm/vc4/vc4_crtc.c                     |   2 +-
 drivers/gpu/drm/vc4/vc4_drv.h                      |   1 +
 drivers/gpu/drm/vc4/vc4_hvs.c                      |  49 +-
 drivers/gpu/drm/vc4/vc4_kms.c                      |   5 +-
 drivers/gpu/drm/vc4/vc4_regs.h                     |  12 +-
 drivers/gpu/drm/vc4/vc4_txp.c                      |   8 +-
 drivers/gpu/drm/virtio/virtgpu_display.c           |   2 +
 drivers/gpu/drm/vmwgfx/vmwgfx_kms.c                |  30 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_kms.h                |   1 -
 drivers/gpu/drm/vmwgfx/vmwgfx_resource.c           |  14 +-
 drivers/hid/amd-sfh-hid/amd_sfh_hid.c              |   4 +-
 drivers/hid/amd-sfh-hid/amd_sfh_hid.h              |   2 +-
 drivers/hid/hid-bigbenff.c                         |   6 +
 drivers/hid/hid-elan.c                             |   2 -
 drivers/hid/hid-led.c                              |   2 +-
 drivers/hv/channel.c                               |   6 +-
 drivers/hwmon/pmbus/pmbus_core.c                   |  28 +-
 drivers/hwtracing/coresight/coresight-core.c       |  33 +-
 drivers/i2c/busses/i2c-at91-master.c               |  11 +
 drivers/i2c/busses/i2c-npcm7xx.c                   | 103 ++-
 drivers/i2c/busses/i2c-rcar.c                      |  15 +-
 drivers/infiniband/hw/hfi1/file_ops.c              |   2 +
 drivers/infiniband/hw/hfi1/init.c                  |   2 +-
 drivers/infiniband/hw/hfi1/sdma.c                  |  12 +-
 drivers/infiniband/hw/hns/hns_roce_device.h        |   7 +-
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c         |  24 +-
 drivers/infiniband/hw/hns/hns_roce_hw_v2.h         |   2 +-
 drivers/infiniband/hw/hns/hns_roce_main.c          |   2 +-
 drivers/infiniband/sw/rdmavt/qp.c                  |   6 +-
 drivers/infiniband/sw/rxe/rxe_req.c                |   2 +-
 drivers/input/keyboard/gpio_keys.c                 |   2 +-
 drivers/input/misc/sparcspkr.c                     |   1 +
 drivers/input/touchscreen/stmfts.c                 |  16 +-
 drivers/iommu/amd/init.c                           |   2 +-
 drivers/iommu/amd/iommu.c                          |   7 -
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c    |  13 +-
 drivers/iommu/dma-iommu.c                          |   7 +-
 drivers/iommu/intel/iommu.c                        |   2 +-
 drivers/iommu/msm_iommu.c                          |  11 +-
 drivers/iommu/mtk_iommu.c                          |  30 +-
 drivers/iommu/mtk_iommu.h                          |   2 +
 drivers/iommu/mtk_iommu_v1.c                       |   7 +
 drivers/irqchip/irq-armada-370-xp.c                |  11 +-
 drivers/irqchip/irq-aspeed-i2c-ic.c                |   4 +-
 drivers/irqchip/irq-aspeed-scu-ic.c                |   4 +-
 drivers/irqchip/irq-gic-v3.c                       | 183 +++--
 drivers/irqchip/irq-sni-exiu.c                     |  25 +-
 drivers/irqchip/irq-xtensa-mx.c                    |  18 +-
 drivers/macintosh/Kconfig                          |   6 +
 drivers/macintosh/Makefile                         |   3 +-
 drivers/macintosh/via-pmu.c                        |   2 +-
 drivers/mailbox/mailbox.c                          |  19 +-
 drivers/mailbox/pcc.c                              |   2 +-
 drivers/md/bcache/btree.c                          |  58 +-
 drivers/md/bcache/btree.h                          |   2 +-
 drivers/md/bcache/journal.c                        |  31 +-
 drivers/md/bcache/journal.h                        |   2 +
 drivers/md/bcache/request.c                        |   6 +
 drivers/md/bcache/super.c                          |   1 +
 drivers/md/bcache/writeback.c                      | 101 +--
 drivers/md/bcache/writeback.h                      |   2 +-
 drivers/md/md-bitmap.c                             |  44 +-
 drivers/md/md.c                                    |  22 +-
 drivers/md/raid0.c                                 |   1 -
 drivers/media/cec/core/cec-adap.c                  |   6 +-
 drivers/media/i2c/ccs/ccs-core.c                   |   7 +-
 drivers/media/i2c/dw9768.c                         |   6 -
 drivers/media/i2c/max9286.c                        | 137 ++--
 drivers/media/i2c/ov5648.c                         |   4 +-
 drivers/media/i2c/ov7670.c                         |   1 -
 drivers/media/i2c/rdacm20.c                        |   2 +-
 drivers/media/i2c/rdacm21.c                        |   2 +-
 drivers/media/pci/cx23885/cx23885-core.c           |   6 +-
 drivers/media/pci/cx25821/cx25821-core.c           |   2 +-
 drivers/media/platform/aspeed-video.c              |   4 +-
 drivers/media/platform/atmel/atmel-sama5d2-isc.c   |   7 +-
 drivers/media/platform/coda/coda-common.c          |  35 +-
 drivers/media/platform/exynos4-is/fimc-is.c        |   6 +-
 drivers/media/platform/exynos4-is/fimc-isp-video.h |   2 +-
 drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.c |  13 +-
 .../media/platform/mtk-vcodec/mtk_vcodec_dec_drv.c |   3 +
 drivers/media/platform/qcom/venus/helpers.c        |  34 +-
 drivers/media/platform/qcom/venus/hfi.c            |   3 +
 drivers/media/platform/rockchip/rga/rga.c          |   6 +-
 drivers/media/platform/sti/delta/delta-v4l2.c      |   6 +-
 drivers/media/platform/vsp1/vsp1_rpf.c             |   6 +-
 drivers/media/rc/imon.c                            |  99 ++-
 drivers/media/usb/pvrusb2/pvrusb2-hdw.c            |   7 +-
 drivers/media/usb/uvc/uvc_v4l2.c                   |  20 +-
 drivers/memory/samsung/exynos5422-dmc.c            |   5 +-
 drivers/mfd/davinci_voicecodec.c                   |   6 +-
 drivers/mfd/ipaq-micro.c                           |   2 +-
 drivers/misc/ocxl/file.c                           |   2 +
 drivers/mmc/core/block.c                           |   8 +-
 drivers/mmc/host/jz4740_mmc.c                      |  20 +
 drivers/mmc/host/sdhci_am654.c                     |  23 +-
 drivers/mtd/chips/cfi_cmdset_0002.c                | 103 ++-
 drivers/mtd/mtdblock.c                             |   8 +-
 drivers/mtd/nand/raw/cadence-nand-controller.c     |   5 +-
 drivers/mtd/nand/raw/denali_pci.c                  |  15 +-
 drivers/mtd/nand/raw/intel-nand-controller.c       |   2 +-
 drivers/mtd/nand/spi/gigadevice.c                  |  10 +-
 drivers/mtd/spi-nor/core.c                         |   9 +
 drivers/net/amt.c                                  |  11 +-
 drivers/net/bonding/bond_main.c                    |  15 +-
 drivers/net/can/spi/mcp251xfd/mcp251xfd.h          |   2 +-
 drivers/net/can/xilinx_can.c                       |   4 +-
 drivers/net/dsa/Kconfig                            |   3 +-
 drivers/net/dsa/mt7530.c                           |  14 +-
 drivers/net/ethernet/broadcom/Makefile             |   5 +
 drivers/net/ethernet/cadence/macb_main.c           |  40 +-
 drivers/net/ethernet/cadence/macb_ptp.c            |   4 +-
 drivers/net/ethernet/huawei/hinic/hinic_hw_mgmt.c  |   2 +
 drivers/net/ethernet/huawei/hinic/hinic_hw_wq.c    |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/devlink.c  |   4 +-
 drivers/net/ethernet/mellanox/mlx5/core/en.h       |   1 +
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |   9 +
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   |  10 +-
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c  |  10 +-
 drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/lib/tout.c |   1 +
 drivers/net/ethernet/mellanox/mlx5/core/lib/tout.h |   1 +
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |  23 +-
 .../net/ethernet/mellanox/mlx5/core/mlx5_core.h    |   2 +-
 drivers/net/ethernet/mellanox/mlxsw/spectrum_dcb.c |  13 -
 .../net/ethernet/mellanox/mlxsw/spectrum_trap.c    |   2 +-
 drivers/net/ethernet/sfc/ef10.c                    |   2 +-
 .../net/ethernet/stmicro/stmmac/stmmac_selftests.c |  13 +-
 drivers/net/ethernet/xscale/ptp_ixp46x.c           |   2 +-
 drivers/net/hyperv/netvsc_drv.c                    |   5 +-
 drivers/net/ipa/ipa_endpoint.c                     |  36 +-
 drivers/net/phy/micrel.c                           |  11 +-
 drivers/net/usb/asix_devices.c                     |   6 +-
 drivers/net/usb/smsc95xx.c                         |   3 +-
 drivers/net/usb/usbnet.c                           |   6 +-
 drivers/net/wireless/ath/ath10k/mac.c              |  20 +-
 drivers/net/wireless/ath/ath11k/mac.c              |  16 +-
 drivers/net/wireless/ath/ath11k/pci.c              |  12 +-
 drivers/net/wireless/ath/ath11k/spectral.c         |  17 +-
 drivers/net/wireless/ath/ath11k/wmi.c              |  11 +-
 drivers/net/wireless/ath/ath11k/wmi.h              |  12 +-
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c     |   2 +-
 drivers/net/wireless/ath/ath9k/ar9003_phy.h        |   2 +-
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c      |   8 +
 drivers/net/wireless/ath/carl9170/tx.c             |   3 +
 drivers/net/wireless/broadcom/b43/phy_n.c          |   2 +-
 drivers/net/wireless/broadcom/b43legacy/phy.c      |   2 +-
 drivers/net/wireless/intel/ipw2x00/libipw_tx.c     |   2 +-
 drivers/net/wireless/intel/iwlwifi/fw/acpi.c       |   3 +
 drivers/net/wireless/intel/iwlwifi/mei/main.c      |   3 +
 drivers/net/wireless/intel/iwlwifi/mvm/power.c     |   3 +
 drivers/net/wireless/marvell/mwifiex/11h.c         |   2 +
 drivers/net/wireless/mediatek/mt76/agg-rx.c        |   5 +-
 drivers/net/wireless/mediatek/mt76/mac80211.c      |   8 +-
 drivers/net/wireless/mediatek/mt76/mt76.h          |   2 +-
 drivers/net/wireless/mediatek/mt76/mt7603/main.c   |   2 +-
 drivers/net/wireless/mediatek/mt76/mt7615/main.c   |   2 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_util.c  |   4 +-
 .../net/wireless/mediatek/mt76/mt7915/debugfs.c    |   2 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mac.c    |   4 +-
 drivers/net/wireless/mediatek/mt76/mt7915/main.c   |   2 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mt7915.h |   2 +-
 drivers/net/wireless/mediatek/mt76/mt7921/mac.c    |   6 +-
 drivers/net/wireless/mediatek/mt76/mt7921/main.c   |   2 +-
 drivers/net/wireless/mediatek/mt76/mt7921/pci.c    |  10 +-
 drivers/net/wireless/mediatek/mt76/tx.c            |  11 +-
 drivers/net/wireless/microchip/wilc1000/mon.c      |   4 +-
 drivers/net/wireless/realtek/rtl818x/rtl8180/dev.c |   8 +-
 drivers/net/wireless/realtek/rtlwifi/usb.c         |   2 +-
 drivers/net/wireless/realtek/rtw88/rtw8821c.c      |   4 +
 drivers/net/wireless/realtek/rtw88/rx.c            |   3 +-
 drivers/net/wireless/realtek/rtw89/phy.c           |   5 +
 drivers/nfc/st21nfca/se.c                          |  17 +-
 drivers/nfc/st21nfca/st21nfca.h                    |   1 +
 drivers/nvdimm/core.c                              |   9 -
 drivers/nvdimm/pmem.c                              |  30 +-
 drivers/nvdimm/security.c                          |   5 -
 drivers/nvme/host/core.c                           |  21 +-
 drivers/nvme/host/pci.c                            |   1 +
 drivers/of/fdt.c                                   |   3 +
 drivers/of/kexec.c                                 |   9 +
 drivers/of/overlay.c                               |   4 +-
 drivers/opp/of.c                                   |   2 +-
 drivers/pci/controller/cadence/pci-j721e.c         |   3 +
 drivers/pci/controller/cadence/pcie-cadence-ep.c   |  21 +-
 drivers/pci/controller/cadence/pcie-cadence.h      |   3 +
 drivers/pci/controller/dwc/pci-imx6.c              |  23 +-
 drivers/pci/controller/dwc/pcie-designware-host.c  |   3 +-
 drivers/pci/controller/dwc/pcie-qcom.c             |   9 +-
 drivers/pci/controller/pcie-mediatek-gen3.c        |   8 +
 drivers/pci/controller/pcie-mediatek.c             |   1 +
 drivers/pci/controller/pcie-microchip-host.c       |  16 +-
 drivers/pci/controller/pcie-rockchip-ep.c          |   3 +-
 drivers/pci/pci-acpi.c                             |  41 +-
 drivers/pci/pci.c                                  |  12 +-
 drivers/pci/pcie/aer.c                             |   7 +-
 drivers/pci/quirks.c                               |  47 ++
 drivers/phy/qualcomm/phy-qcom-qmp.c                |  11 +-
 drivers/pinctrl/bcm/pinctrl-bcm2835.c              |  18 +
 drivers/pinctrl/mediatek/Kconfig                   |   1 +
 drivers/pinctrl/mvebu/pinctrl-armada-37xx.c        |   2 +-
 drivers/pinctrl/pinctrl-apple-gpio.c               |   1 +
 drivers/pinctrl/pinctrl-rockchip.c                 |  54 +-
 drivers/pinctrl/pinctrl-rockchip.h                 |   7 +-
 drivers/pinctrl/renesas/core.c                     |   7 +-
 drivers/pinctrl/renesas/pfc-r8a779a0.c             |  29 +
 drivers/pinctrl/renesas/pinctrl-rzn1.c             |  10 +-
 drivers/platform/chrome/cros_ec.c                  |  16 +-
 drivers/platform/chrome/cros_ec_chardev.c          |   2 +-
 drivers/platform/chrome/cros_ec_proto.c            |  50 +-
 drivers/platform/mips/cpu_hwmon.c                  | 127 ++--
 drivers/platform/x86/intel/hid.c                   |   2 +-
 drivers/regulator/core.c                           |   7 +-
 drivers/regulator/da9121-regulator.c               |   2 +
 drivers/regulator/pfuze100-regulator.c             |   2 +
 drivers/regulator/qcom_smd-regulator.c             |  35 +-
 drivers/regulator/scmi-regulator.c                 |   2 +-
 drivers/s390/cio/chsc.c                            |   4 +-
 drivers/scsi/dc395x.c                              |  15 +-
 drivers/scsi/fcoe/fcoe_ctlr.c                      |   2 +-
 drivers/scsi/hisi_sas/hisi_sas_main.c              |  47 +-
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c             |  10 +-
 drivers/scsi/lpfc/lpfc_els.c                       |  49 +-
 drivers/scsi/lpfc/lpfc_init.c                      |  51 +-
 drivers/scsi/lpfc/lpfc_logmsg.h                    |   6 +-
 drivers/scsi/lpfc/lpfc_scsi.c                      |  37 +-
 drivers/scsi/lpfc/lpfc_sli.c                       |   6 +-
 drivers/scsi/megaraid.c                            |   2 +-
 drivers/scsi/ufs/ti-j721e-ufs.c                    |   6 +-
 drivers/scsi/ufs/ufs-qcom.c                        |  14 +-
 drivers/scsi/ufs/ufshcd.c                          |   7 +-
 drivers/soc/bcm/bcm63xx/bcm-pmb.c                  |   3 +
 drivers/soc/qcom/llcc-qcom.c                       |   1 +
 drivers/soc/qcom/smp2p.c                           |   1 +
 drivers/soc/qcom/smsm.c                            |   1 +
 drivers/soc/ti/ti_sci_pm_domains.c                 |   2 +
 drivers/spi/spi-cadence-quadspi.c                  |   2 +-
 drivers/spi/spi-fsl-qspi.c                         |   4 +
 drivers/spi/spi-img-spfi.c                         |   2 +-
 drivers/spi/spi-rockchip.c                         | 113 +++-
 drivers/spi/spi-rspi.c                             |  15 +-
 drivers/spi/spi-stm32-qspi.c                       |   3 +-
 drivers/spi/spi-ti-qspi.c                          |   5 +-
 drivers/staging/media/hantro/hantro_g2_hevc_dec.c  |  11 +-
 drivers/staging/media/hantro/hantro_h264.c         |   2 -
 drivers/staging/media/hantro/hantro_v4l2.c         |   8 +-
 drivers/staging/media/rkvdec/rkvdec-h264.c         |  37 +-
 drivers/staging/media/rkvdec/rkvdec.c              |   6 -
 drivers/staging/r8188eu/os_dep/ioctl_linux.c       |  98 +--
 drivers/target/target_core_device.c                |   1 -
 drivers/target/target_core_user.c                  |  50 +-
 drivers/thermal/broadcom/bcm2711_thermal.c         |   5 +-
 drivers/thermal/broadcom/sr-thermal.c              |   3 +
 drivers/thermal/devfreq_cooling.c                  |  25 +-
 drivers/thermal/imx_sc_thermal.c                   |   6 +-
 drivers/thermal/thermal_core.c                     |   1 +
 drivers/tty/goldfish.c                             |  20 +-
 drivers/tty/n_gsm.c                                |  31 +-
 drivers/tty/serial/pch_uart.c                      |  27 +-
 drivers/tty/tty_buffer.c                           |   3 +-
 drivers/usb/core/hcd.c                             |  29 +-
 drivers/usb/core/quirks.c                          |   3 +
 drivers/usb/dwc3/gadget.c                          |   6 +-
 drivers/usb/host/xhci-pci.c                        |   2 +
 drivers/usb/isp1760/isp1760-core.c                 |   8 +
 drivers/usb/serial/option.c                        |   2 +
 drivers/usb/serial/pl2303.c                        |   3 +
 drivers/vdpa/vdpa_sim/vdpa_sim.c                   |   5 +-
 drivers/video/console/sticon.c                     |   5 +-
 drivers/video/console/sticore.c                    |  32 +-
 drivers/video/fbdev/amba-clcd.c                    |   5 +-
 drivers/video/fbdev/core/fbcon.c                   |   5 +-
 drivers/video/fbdev/sticore.h                      |   3 +
 drivers/video/fbdev/stifb.c                        |   4 +-
 drivers/video/fbdev/vesafb.c                       |   5 +-
 fs/afs/misc.c                                      |   5 +-
 fs/afs/rotate.c                                    |   4 +
 fs/afs/rxrpc.c                                     |   8 +-
 fs/afs/write.c                                     |   1 +
 fs/binfmt_flat.c                                   |  27 +-
 fs/btrfs/block-group.c                             |   8 +
 fs/btrfs/block-group.h                             |   2 +
 fs/btrfs/disk-io.c                                 |   4 +-
 fs/btrfs/extent_io.c                               |  27 +-
 fs/btrfs/extent_io.h                               |   1 -
 fs/btrfs/ioctl.c                                   |  49 +-
 fs/btrfs/volumes.c                                 |   8 +-
 fs/btrfs/zoned.c                                   |  44 +-
 fs/btrfs/zoned.h                                   |   5 +
 fs/ceph/mds_client.c                               |  14 +-
 fs/cifs/cifsfs.c                                   |  10 +-
 fs/cifs/cifsglob.h                                 |  15 +-
 fs/cifs/connect.c                                  |  67 +-
 fs/cifs/dfs_cache.c                                |   6 +-
 fs/cifs/fs_context.c                               |  29 +-
 fs/cifs/fs_context.h                               |   2 +-
 fs/cifs/misc.c                                     |   7 +-
 fs/cifs/sess.c                                     |   6 +-
 fs/cifs/smb2inode.c                                |   2 -
 fs/cifs/smb2ops.c                                  |   9 +-
 fs/cifs/smb2pdu.c                                  |   3 +-
 fs/cifs/smb2transport.c                            |   3 +-
 fs/dax.c                                           |   3 +-
 fs/dlm/lock.c                                      |  15 +-
 fs/dlm/lowcomms.c                                  |   2 +-
 fs/dlm/plock.c                                     |  12 +-
 fs/erofs/decompressor.c                            |   5 +-
 fs/exec.c                                          |   6 +-
 fs/exportfs/expfs.c                                |   5 +-
 fs/ext4/ext4.h                                     |   6 -
 fs/ext4/extents.c                                  |  20 +-
 fs/ext4/inline.c                                   |  12 +
 fs/ext4/inode.c                                    |  13 +-
 fs/ext4/mballoc.c                                  |  18 +-
 fs/ext4/namei.c                                    |  84 ++-
 fs/ext4/super.c                                    |  87 ++-
 fs/f2fs/dir.c                                      |   3 +-
 fs/f2fs/f2fs.h                                     |  29 +-
 fs/f2fs/file.c                                     |  20 +-
 fs/f2fs/hash.c                                     |  11 +-
 fs/f2fs/inline.c                                   |  29 +-
 fs/f2fs/inode.c                                    |  19 +-
 fs/f2fs/namei.c                                    |   7 +
 fs/f2fs/segment.c                                  |  42 +-
 fs/f2fs/segment.h                                  |  33 +-
 fs/f2fs/super.c                                    |   6 +-
 fs/fat/fatent.c                                    |   7 +-
 fs/fs-writeback.c                                  |  13 +-
 fs/gfs2/quota.c                                    |  32 +-
 fs/hugetlbfs/inode.c                               |   4 +-
 fs/io_uring.c                                      |  45 +-
 fs/iomap/buffered-io.c                             |   3 +-
 fs/jfs/jfs_dmap.c                                  |   3 +-
 fs/ksmbd/connection.c                              |   2 +-
 fs/ksmbd/smb2misc.c                                |   2 +-
 fs/ksmbd/smb_common.c                              |   4 +-
 fs/namei.c                                         |  70 +-
 fs/nfs/file.c                                      |  50 +-
 fs/nfs/inode.c                                     |   6 +-
 fs/nfs/nfs4namespace.c                             |   9 +-
 fs/nfs/nfs4proc.c                                  |  56 +-
 fs/nfs/nfs4state.c                                 |  11 +-
 fs/nfs/nfs4xdr.c                                   |   4 +-
 fs/nfs/pagelist.c                                  |   3 +
 fs/nfs/pnfs.c                                      |   6 +-
 fs/nfs/unlink.c                                    |   8 +
 fs/nfs/write.c                                     |  54 +-
 fs/nfsd/nfscache.c                                 |   2 +-
 fs/notify/fanotify/fanotify_user.c                 |   4 +-
 fs/notify/fdinfo.c                                 |  11 +-
 fs/notify/inotify/inotify.h                        |  12 +
 fs/notify/inotify/inotify_user.c                   |   2 +-
 fs/notify/mark.c                                   |   6 +-
 fs/ntfs3/file.c                                    |  12 +-
 fs/ntfs3/frecord.c                                 |  10 +-
 fs/ntfs3/fslog.c                                   |  12 +-
 fs/ntfs3/inode.c                                   |   8 +-
 fs/ntfs3/xattr.c                                   | 112 ++-
 fs/ocfs2/dlmfs/userdlm.c                           |  16 +-
 fs/ocfs2/inode.c                                   |   4 +-
 fs/ocfs2/journal.c                                 |  33 +-
 fs/ocfs2/journal.h                                 |   2 +
 fs/ocfs2/super.c                                   |  15 +
 fs/proc/generic.c                                  |   3 +
 fs/proc/proc_net.c                                 |   3 +
 fs/seq_file.c                                      |  32 +
 include/drm/drm_edid.h                             |   6 +-
 include/linux/blk_types.h                          |   5 +-
 include/linux/bpf.h                                |   4 +-
 include/linux/compat.h                             |   1 +
 include/linux/efi.h                                |   2 +
 include/linux/fwnode.h                             |  10 +-
 include/linux/goldfish.h                           |  15 +-
 include/linux/gpio/driver.h                        |  12 +
 include/linux/ipmi_smi.h                           |   6 +
 include/linux/kexec.h                              |  46 +-
 include/linux/list.h                               |  16 +-
 include/linux/mailbox_controller.h                 |   1 +
 include/linux/module.h                             |   3 +-
 include/linux/mtd/cfi.h                            |   1 +
 include/linux/namei.h                              |   6 +
 include/linux/nfs_fs_sb.h                          |   1 +
 include/linux/nfs_xdr.h                            |   2 +-
 include/linux/nodemask.h                           |  13 +-
 include/linux/platform_data/cros_ec_proto.h        |   3 +
 include/linux/ptp_classify.h                       |   3 +
 include/linux/ptrace.h                             |   7 -
 include/linux/sched/signal.h                       |   2 +-
 include/linux/sched/task.h                         |   2 +
 include/linux/seq_file.h                           |   4 +
 include/linux/set_memory.h                         |  10 +-
 include/linux/usb/hcd.h                            |   2 +
 include/net/bluetooth/hci.h                        |   9 +
 include/net/bluetooth/hci_core.h                   |  10 +-
 include/net/if_inet6.h                             |   8 +
 include/scsi/libfcoe.h                             |   3 +-
 include/scsi/libiscsi.h                            |   6 +-
 include/sound/cs35l41.h                            |   1 -
 include/sound/jack.h                               |   1 +
 include/trace/events/rxrpc.h                       |   2 +-
 include/trace/events/vmscan.h                      |   4 +-
 include/uapi/asm-generic/siginfo.h                 |   7 +
 include/uapi/linux/landlock.h                      |   9 +-
 init/Kconfig                                       |   5 +
 init/main.c                                        |   2 +-
 ipc/mqueue.c                                       |  14 +
 kernel/dma/debug.c                                 |   2 +-
 kernel/dma/direct.c                                |  31 +-
 kernel/events/core.c                               |   4 +-
 kernel/fork.c                                      |  22 +-
 kernel/kexec_file.c                                |  34 -
 kernel/module.c                                    |   4 +
 kernel/power/energy_model.c                        |   2 +
 kernel/printk/printk.c                             |  63 +-
 kernel/ptrace.c                                    |   5 +-
 kernel/rcu/Kconfig                                 |   1 +
 kernel/rcu/tasks.h                                 |   5 +-
 kernel/scftorture.c                                |   5 +-
 kernel/sched/core.c                                |   6 +-
 kernel/sched/deadline.c                            |   5 +-
 kernel/sched/fair.c                                |   8 +-
 kernel/sched/pelt.h                                |   4 +-
 kernel/sched/psi.c                                 |  15 +-
 kernel/sched/rt.c                                  |   5 +-
 kernel/sched/sched.h                               |  32 +-
 kernel/signal.c                                    |  18 +-
 kernel/trace/ftrace.c                              |   5 +-
 kernel/trace/trace.c                               |   6 +-
 kernel/trace/trace_boot.c                          |   2 +-
 kernel/trace/trace_events_hist.c                   |   3 +
 kernel/trace/trace_osnoise.c                       |   9 +-
 kernel/trace/trace_selftest.c                      |   3 +
 kernel/umh.c                                       |   6 +-
 lib/kunit/debugfs.c                                |   2 +-
 lib/kunit/executor.c                               |  32 +-
 lib/kunit/executor_test.c                          |   4 +-
 lib/list-test.c                                    |  19 +
 lib/string_helpers.c                               |   3 +
 mm/cma.c                                           |   4 +-
 mm/compaction.c                                    |   2 +
 mm/hugetlb.c                                       |   9 +-
 mm/memremap.c                                      |   2 +-
 mm/page_alloc.c                                    |   4 +-
 net/bluetooth/hci_conn.c                           |  39 +-
 net/bluetooth/hci_event.c                          |  46 +-
 net/bluetooth/hci_request.c                        |   2 +
 net/bluetooth/hci_sync.c                           |  11 +-
 net/bluetooth/sco.c                                |  23 +-
 net/core/dev.c                                     |   8 +-
 net/ipv4/tcp_input.c                               |  28 +-
 net/ipv6/addrconf.c                                |  33 +-
 net/mac80211/chan.c                                |   7 +-
 net/mac80211/ieee80211_i.h                         |   5 +
 net/mac80211/rc80211_minstrel_ht.c                 |   3 +
 net/mac80211/scan.c                                |  20 +
 net/mptcp/pm.c                                     |  19 +-
 net/mptcp/pm_netlink.c                             |   2 +
 net/mptcp/protocol.c                               |  18 +-
 net/mptcp/protocol.h                               |   1 +
 net/nfc/core.c                                     |   1 +
 net/rxrpc/ar-internal.h                            |  15 +-
 net/rxrpc/call_accept.c                            |   6 +-
 net/rxrpc/call_event.c                             |   7 +-
 net/rxrpc/call_object.c                            |  18 +-
 net/rxrpc/conn_object.c                            |   2 +-
 net/rxrpc/input.c                                  |  58 +-
 net/rxrpc/net_ns.c                                 |   2 +-
 net/rxrpc/output.c                                 |  20 +-
 net/rxrpc/proc.c                                   |  10 +-
 net/rxrpc/recvmsg.c                                |   8 +-
 net/rxrpc/sendmsg.c                                |   6 +
 net/rxrpc/sysctl.c                                 |   4 +-
 net/sctp/input.c                                   |   4 +-
 net/smc/af_smc.c                                   |   2 +-
 net/wireless/nl80211.c                             |   4 +-
 net/wireless/reg.c                                 |   4 +
 samples/bpf/Makefile                               |   9 +-
 samples/landlock/sandboxer.c                       | 104 +--
 scripts/faddr2line                                 | 150 ++--
 security/integrity/ima/Kconfig                     |  14 +-
 .../integrity/platform_certs/keyring_handler.h     |   8 +
 security/integrity/platform_certs/load_uefi.c      |  33 +
 security/landlock/cred.c                           |   4 +-
 security/landlock/cred.h                           |   8 +-
 security/landlock/fs.c                             | 191 ++++--
 security/landlock/fs.h                             |  11 +-
 security/landlock/limits.h                         |   8 +-
 security/landlock/object.c                         |   6 +-
 security/landlock/object.h                         |   6 +-
 security/landlock/ptrace.c                         |  10 +-
 security/landlock/ruleset.c                        |  84 +--
 security/landlock/ruleset.h                        |  35 +-
 security/landlock/syscalls.c                       |  95 +--
 sound/core/jack.c                                  |  34 +-
 sound/core/pcm_memory.c                            |   3 +-
 sound/pci/hda/patch_realtek.c                      |  21 +-
 sound/soc/amd/yc/acp6x-mach.c                      |  29 +-
 sound/soc/atmel/atmel-classd.c                     |   1 -
 sound/soc/atmel/atmel-pdmic.c                      |   1 -
 sound/soc/codecs/Kconfig                           |   2 -
 sound/soc/codecs/cs35l41-lib.c                     |  14 +-
 sound/soc/codecs/max98090.c                        |   6 +-
 sound/soc/codecs/rk3328_codec.c                    |   2 +-
 sound/soc/codecs/rt5514.c                          |   2 +-
 sound/soc/codecs/rt5645.c                          |   7 +-
 sound/soc/codecs/tscs454.c                         |  12 +-
 sound/soc/codecs/wm2000.c                          |   6 +-
 sound/soc/fsl/imx-hdmi.c                           |   1 +
 sound/soc/fsl/imx-sgtl5000.c                       |  14 +-
 sound/soc/intel/boards/bytcr_rt5640.c              |  12 +
 sound/soc/mediatek/mt2701/mt2701-wm8960.c          |   9 +-
 sound/soc/mediatek/mt8173/mt8173-max98090.c        |   5 +-
 sound/soc/mxs/mxs-saif.c                           |   1 +
 sound/soc/samsung/aries_wm8994.c                   |   2 +-
 sound/soc/sh/rcar/core.c                           |  15 +-
 sound/soc/sh/rcar/dma.c                            |   9 +-
 sound/soc/sh/rcar/rsnd.h                           |   2 +-
 sound/soc/sh/rcar/src.c                            |   7 +-
 sound/soc/sh/rcar/ssi.c                            |  14 +-
 sound/soc/sh/rcar/ssiu.c                           |  11 +-
 sound/soc/sh/rz-ssi.c                              |  22 +-
 sound/soc/soc-dapm.c                               |   2 -
 sound/soc/sof/amd/pci-rn.c                         |   1 +
 sound/soc/ti/j721e-evm.c                           |  44 +-
 sound/usb/implicit.c                               |  10 +-
 sound/usb/midi.c                                   |   3 +
 sound/usb/quirks.c                                 |   6 +
 sound/usb/usbaudio.h                               |   6 +
 .../test-libbpf-btf__load_from_kernel_by_id.c      |   5 +-
 tools/lib/bpf/libbpf.c                             |  22 +-
 tools/objtool/check.c                              |   9 +-
 tools/objtool/elf.c                                | 200 ++++--
 tools/objtool/include/objtool/elf.h                |   4 +-
 tools/perf/Makefile.config                         |  39 +-
 tools/perf/arch/x86/util/evlist.c                  |   2 +-
 tools/perf/arch/x86/util/evsel.c                   |  12 +
 tools/perf/builtin-c2c.c                           |   6 +-
 tools/perf/builtin-stat.c                          |   7 +-
 tools/perf/pmu-events/jevents.c                    |   2 +-
 tools/perf/util/data.h                             |   1 +
 tools/perf/util/evlist.c                           |  12 +-
 tools/perf/util/evsel.c                            |  19 +
 tools/perf/util/evsel.h                            |   3 +
 tools/power/x86/turbostat/turbostat.c              |   1 +
 tools/testing/kunit/kunit_parser.py                |   7 +-
 .../test_is_test_passed-no_tests_no_plan.log       |   2 +-
 tools/testing/selftests/Makefile                   |   1 +
 tools/testing/selftests/arm64/bti/Makefile         |   4 +-
 tools/testing/selftests/bpf/Makefile               |  12 +-
 .../selftests/bpf/prog_tests/trampoline_count.c    | 134 ++--
 .../bpf/progs/btf_dump_test_case_syntax.c          |   2 +-
 tools/testing/selftests/bpf/progs/profiler.inc.h   |   5 +-
 .../selftests/bpf/progs/test_trampoline_count.c    |  16 +-
 .../selftests/bpf/test_bpftool_synctypes.py        |   2 +-
 tools/testing/selftests/cgroup/test_stress.sh      |   2 +-
 tools/testing/selftests/landlock/base_test.c       | 177 +++--
 tools/testing/selftests/landlock/common.h          |  66 +-
 tools/testing/selftests/landlock/fs_test.c         | 753 ++++++++++++++-------
 tools/testing/selftests/landlock/ptrace_test.c     |  40 +-
 tools/testing/selftests/resctrl/fill_buf.c         |   4 +-
 tools/tracing/rtla/Makefile                        |   3 +-
 tools/tracing/rtla/README.txt                      |  12 +-
 tools/tracing/rtla/src/utils.c                     |   2 +-
 840 files changed, 8058 insertions(+), 4338 deletions(-)


