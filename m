Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6725F5404EC
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 19:19:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345813AbiFGRTw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 13:19:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345820AbiFGRTc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 13:19:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A83C1059E2;
        Tue,  7 Jun 2022 10:19:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6494A618DC;
        Tue,  7 Jun 2022 17:19:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD9A5C341CD;
        Tue,  7 Jun 2022 17:19:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654622360;
        bh=EbMzFF+73Jafp072HrFzBTCE0e9uRG1cRsJqVwdTg6M=;
        h=From:To:Cc:Subject:Date:From;
        b=UVY1r5fdTmPcrpeohtu1ybHXtF5JUGIlZick48qurX2Ga0S/Am8UBa4kb6q7njTut
         5m7vxsVb+rVpkJtJo3PGj5IUL0OWPIwxz7u7/kG1afrvuPggGQvi48Cam43x1rIjmp
         hrnzx8brZgwaw0RSxNSdbFXsq/LjB8i0C86VDwJQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Subject: [PATCH 5.10 000/452] 5.10.121-rc1 review
Date:   Tue,  7 Jun 2022 18:57:37 +0200
Message-Id: <20220607164908.521895282@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.121-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.121-rc1
X-KernelTest-Deadline: 2022-06-09T16:49+00:00
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

This is the start of the stable review cycle for the 5.10.121 release.
There are 452 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 09 Jun 2022 16:48:02 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.121-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.10.121-rc1

Jia-Ju Bai <baijiaju1990@gmail.com>
    md: bcache: check the return value of kzalloc() in detached_dev_do_request()

Eric Biggers <ebiggers@google.com>
    ext4: only allow test_dummy_encryption when supported

Maciej W. Rozycki <macro@orcam.me.uk>
    MIPS: IP30: Remove incorrect `cpu_has_fpu' override

Maciej W. Rozycki <macro@orcam.me.uk>
    MIPS: IP27: Remove incorrect `cpu_has_fpu' override

Xiao Yang <yangx.jy@fujitsu.com>
    RDMA/rxe: Generate a completion for unsupported/invalid opcode

Jason A. Donenfeld <Jason@zx2c4.com>
    Revert "random: use static branch for crng_ready()"

Jan Kara <jack@suse.cz>
    block: fix bio_clone_blkg_association() to associate with proper blkcg_gq

Jan Kara <jack@suse.cz>
    bfq: Make sure bfqg for which we are queueing requests is online

Jan Kara <jack@suse.cz>
    bfq: Get rid of __bio_blkcg() usage

Jan Kara <jack@suse.cz>
    bfq: Remove pointless bfq_init_rq() calls

Jan Kara <jack@suse.cz>
    bfq: Drop pointless unlock-lock pair

Jan Kara <jack@suse.cz>
    bfq: Avoid merging queues with different parents

Daniel Lezcano <daniel.lezcano@linaro.org>
    thermal/core: Fix memory leak in the error path

Ziyang Xuan <william.xuanziyang@huawei.com>
    thermal/core: fix a UAF bug in __thermal_cooling_device_register()

Waiman Long <longman@redhat.com>
    kseltest/cgroup: Make test_stress.sh work if run interactively

Dave Chinner <dchinner@redhat.com>
    xfs: assert in xfs_btree_del_cursor should take into account error

Brian Foster <bfoster@redhat.com>
    xfs: consider shutdown in bmapbt cursor delete assert

Darrick J. Wong <djwong@kernel.org>
    xfs: force log and push AIL to clear pinned inodes when aborting mount

Brian Foster <bfoster@redhat.com>
    xfs: restore shutdown check in mapped write fault path

Darrick J. Wong <djwong@kernel.org>
    xfs: fix incorrect root dquot corruption error when switching group/project quota types

Darrick J. Wong <djwong@kernel.org>
    xfs: fix chown leaking delalloc quota blocks when fssetxattr fails

Brian Foster <bfoster@redhat.com>
    xfs: sync lazy sb accounting on quiesce of read-only mounts

Jeffrey Mitchell <jeffrey.mitchell@starlab.io>
    xfs: set inode size after creating symlink

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

Arnd Bergmann <arnd@arndb.de>
    ARM: pxa: maybe fix gpio lookup tables

Jonathan Bakker <xc-racer2@live.ca>
    ARM: dts: s5pv210: Remove spi-cs-high on panel in Aries

Johan Hovold <johan+linaro@kernel.org>
    phy: qcom-qmp: fix struct clk leak on probe errors

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

Mike Kravetz <mike.kravetz@oracle.com>
    hugetlb: fix huge_pmd_unshare address update

Christophe de Dinechin <dinechin@redhat.com>
    nodemask.h: fix compilation error with GCC12

Xiaomeng Tong <xiam0nd.tong@gmail.com>
    iommu/msm: Fix an incorrect NULL check on list iterator

Song Liu <song@kernel.org>
    ftrace: Clean up hash direct_functions on register failures

Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
    kexec_file: drop weak attribute from arch_kexec_apply_relocations[_add]

Vincent Whitchurch <vincent.whitchurch@axis.com>
    um: Fix out-of-bounds read in LDT setup

Johannes Berg <johannes.berg@intel.com>
    um: chan_user: Fix winch_tramp() return value

Felix Fietkau <nbd@nbd.name>
    mac80211: upgrade passive scan to active scan on DFS channels after beacon rx

Dimitri John Ledkov <dimitri.ledkov@canonical.com>
    cfg80211: declare MODULE_FIRMWARE for regulatory.db

Max Filippov <jcmvbkbc@gmail.com>
    irqchip: irq-xtensa-mx: fix initial IRQ affinity

Pali Rohár <pali@kernel.org>
    irqchip/armada-370-xp: Do not touch Performance Counter Overflow on A375, A38x, A39x

Guo Ren <guoren@linux.alibaba.com>
    csky: patch_text: Fixup last cpu should be master

Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
    RDMA/hfi1: Fix potential integer multiplication overflow errors

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

Dave Airlie <airlied@redhat.com>
    drm/amdgpu/cs: make commands with 0 chunks illegal behaviour.

Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
    scsi: ufs: qcom: Add a readl() to make sure ref_clk gets enabled

Xiaomeng Tong <xiam0nd.tong@gmail.com>
    scsi: dc395x: Fix a missing check on list iterator

Junxiao Bi via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
    ocfs2: dlmfs: fix error handling of user_dlm_destroy_lock

Alexander Aring <aahringo@redhat.com>
    dlm: fix missing lkb refcount handling

Alexander Aring <aahringo@redhat.com>
    dlm: fix plock invalid read

Nico Boehr <nrb@linux.ibm.com>
    s390/perf: obtain sie_block from the right address

Rei Yamamoto <yamamoto.rei@jp.fujitsu.com>
    mm, compaction: fast_find_migrateblock() should return pfn in the target zone

Johan Hovold <johan+linaro@kernel.org>
    PCI: qcom: Fix unbalanced PHY init on probe errors

Johan Hovold <johan+linaro@kernel.org>
    PCI: qcom: Fix runtime PM imbalance on probe errors

Bjorn Helgaas <bhelgaas@google.com>
    PCI/PM: Fix bridge_d3_blacklist[] Elo i2 overwrite of Gigabyte X299

Keita Suzuki <keitasuzuki.park@sslab.ics.keio.ac.jp>
    tracing: Fix potential double free in create_var_ref()

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

Ye Bin <yebin10@huawei.com>
    ext4: fix warning in ext4_handle_inode_extension

Ye Bin <yebin10@huawei.com>
    ext4: fix use-after-free in ext4_rename_dir_prepare

Jan Kara <jack@suse.cz>
    bfq: Track whether bfq_group is still online

Jan Kara <jack@suse.cz>
    bfq: Update cgroup information before merging bio

Jan Kara <jack@suse.cz>
    bfq: Split shared queues on move between cgroups

Aditya Garg <gargaditya08@live.com>
    efi: Do not import certificates from UEFI Secure Boot for T2 Macs

Zhihao Cheng <chengzhihao1@huawei.com>
    fs-writeback: writeback_sb_inodes：Recalculate 'wrote' according skipped pages

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    iwlwifi: mvm: fix assert 1F04 upon reconfig

Johannes Berg <johannes.berg@intel.com>
    wifi: mac80211: fix use-after-free in chanctx code

Chao Yu <chao@kernel.org>
    f2fs: fix to do sanity check for inline inode

Chao Yu <chao@kernel.org>
    f2fs: fix fallocate to use file_modified to update permissions consistently

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

Zhengjun Xing <zhengjun.xing@linux.intel.com>
    perf jevents: Fix event syntax error caused by ExtSel

Leo Yan <leo.yan@linaro.org>
    perf c2c: Use stdio interface if slang is not supported

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

Amelie Delaunay <amelie.delaunay@st.com>
    dmaengine: stm32-mdma: rework interrupt handler

Amelie Delaunay <amelie.delaunay@foss.st.com>
    dmaengine: stm32-mdma: remove GISR1 register

Miaoqian Lin <linmq006@gmail.com>
    video: fbdev: clcdfb: Fix refcount leak in clcdfb_of_vram_setup

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFSv4/pNFS: Do not fail I/O when we fail to allocate the pNFS layout

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFS: Don't report errors from nfs_pageio_complete() more than once

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFS: Do not report flush errors in nfs_write_end()

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFS: fsync() should report filesystem errors over EINTR/ERESTARTSYS

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFS: Do not report EINTR/ERESTARTSYS as mapping errors

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    dmaengine: idxd: Fix the error handling path in idxd_cdev_register()

Nathan Chancellor <nathan@kernel.org>
    i2c: at91: Initialize dma_buf in at91_twi_xfer()

Guenter Roeck <linux@roeck-us.net>
    MIPS: Loongson: Use hwmon_device_register_with_groups() to register hwmon

Rex-BC Chen <rex-bc.chen@mediatek.com>
    cpufreq: mediatek: Unregister platform device on exit

Jia-Wei Chang <jia-wei.chang@mediatek.com>
    cpufreq: mediatek: Use module_init and add module_exit

Qinglang Miao <miaoqinglang@huawei.com>
    cpufreq: mediatek: add missing platform_driver_unregister() on error in mtk_cpufreq_driver_init

Michael Walle <michael@walle.cc>
    i2c: at91: use dma safe buffers

Yong Wu <yong.wu@mediatek.com>
    iommu/mediatek: Add list_del in mtk_iommu_remove

Jakob Koschel <jakobkoschel@gmail.com>
    f2fs: fix dereference of stale list iterator after loop body

Dan Carpenter <dan.carpenter@oracle.com>
    OPP: call of_node_put() on error path in _bandwidth_supported()

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    Input: stmfts - do not leave device disabled in stmfts_input_open

Douglas Miller <doug.miller@cornelisnetworks.com>
    RDMA/hfi1: Prevent use of lock before it is initialized

Björn Ardö <bjorn.ardo@axis.com>
    mailbox: forward the hrtimer if not queued and under a lock

Yang Yingliang <yangyingliang@huawei.com>
    mfd: davinci_voicecodec: Fix possible null-ptr-deref davinci_vc_probe()

Miaoqian Lin <linmq006@gmail.com>
    powerpc/fsl_rio: Fix refcount leak in fsl_rio_setup

Randy Dunlap <rdunlap@infradead.org>
    macintosh: via-pmu and via-cuda need RTC_LIB

Kajol Jain <kjain@linux.ibm.com>
    powerpc/perf: Fix the threshold compare group constraint for power9

Michael Ellerman <mpe@ellerman.id.au>
    powerpc/64: Only WARN if __pa()/__va() called with bad addresses

Yang Yingliang <yangyingliang@huawei.com>
    hwrng: omap3-rom - fix using wrong clk_disable() in omap_rom_rng_runtime_resume()

Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
    PCI/AER: Clear MULTI_ERR_COR/UNCOR_RCV bits

Miaoqian Lin <linmq006@gmail.com>
    Input: sparcspkr - fix refcount leak in bbc_beep_probe

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    crypto: cryptd - Protect per-CPU resource by disabling BH.

Corentin Labbe <clabbe@baylibre.com>
    crypto: sun8i-ss - handle zero sized sg

Corentin Labbe <clabbe@baylibre.com>
    crypto: sun8i-ss - rework handling of IV

Qi Zheng <zhengqi.arch@bytedance.com>
    tty: fix deadlock caused by calling printk() under tty_port->lock

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

Randy Dunlap <rdunlap@infradead.org>
    powerpc/4xx/cpm: Fix return value of __setup() handler

Randy Dunlap <rdunlap@infradead.org>
    powerpc/idle: Fix return value of __setup() handler

Yang Yingliang <yangyingliang@huawei.com>
    pinctrl: renesas: core: Fix possible null-ptr-deref in sh_pfc_map_resources()

Randy Dunlap <rdunlap@infradead.org>
    powerpc/8xx: export 'cpm_setbrg' for modules

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    drivers/base/memory: fix an unlikely reference counting issue in __add_memory_block()

Muchun Song <songmuchun@bytedance.com>
    dax: fix cache flush on PMD-mapped pages

Miaohe Lin <linmiaohe@huawei.com>
    drivers/base/node.c: fix compaction sysfs file leak

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    pinctrl: mvebu: Fix irq_of_parse_and_map() return value

Dan Williams <dan.j.williams@intel.com>
    nvdimm: Allow overwrite in the presence of disabled dimms

Dan Williams <dan.j.williams@intel.com>
    nvdimm: Fix firmware activation deadlock scenarios

Cristian Marussi <cristian.marussi@arm.com>
    firmware: arm_scmi: Fix list protocols enumeration in the base protocol

Gustavo A. R. Silva <gustavoars@kernel.org>
    scsi: fcoe: Fix Wstringop-overflow warnings in fcoe_wwn_from_mac()

Lv Ruyi <lv.ruyi@zte.com.cn>
    mfd: ipaq-micro: Fix error check return value of platform_get_irq()

Hari Bathini <hbathini@linux.ibm.com>
    powerpc/fadump: fix PT_LOAD segment for boot memory area

Chuanhong Guo <gch981213@gmail.com>
    arm: mediatek: select arch timer for mt7629

Stefan Wahren <stefan.wahren@i2se.com>
    pinctrl: bcm2835: implement hook for missing gpio-ranges

Stefan Wahren <stefan.wahren@i2se.com>
    gpiolib: of: Introduce hook for missing gpio-ranges

Corentin Labbe <clabbe@baylibre.com>
    crypto: marvell/cesa - ECB does not IV

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

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    memory: samsung: exynos5422-dmc: Avoid some over memory allocation

Shawn Lin <shawn.lin@rock-chips.com>
    arm64: dts: rockchip: Move drive-impedance-ohm to emmc phy on rk3399

liuyacan <liuyacan@corp.netease.com>
    net/smc: postpone sk_refcnt increment in connect()

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    hinic: Avoid some over memory allocation

Gustavo A. R. Silva <gustavoars@kernel.org>
    net: huawei: hinic: Use devm_kcalloc() instead of devm_kzalloc()

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

Yongzhi Liu <lyz_cs@pku.edu.cn>
    hv_netvsc: Fix potential dereference of NULL pointer

Jakub Kicinski <kuba@kernel.org>
    net: stmmac: fix out-of-bounds access in a selftest

Gustavo A. R. Silva <gustavoars@kernel.org>
    net: stmmac: selftests: Use kcalloc() instead of kzalloc()

Alexey Khoroshilov <khoroshilov@ispras.ru>
    ASoC: max98090: Move check for invalid values before casting in max98090_put_enab_tlv()

Duoming Zhou <duoming@zju.edu.cn>
    NFC: hci: fix sleep in atomic context bugs in nfc_hci_hcp_message_tx

Yang Yingliang <yangyingliang@huawei.com>
    ASoC: wm2000: fix missing clk_disable_unprepare() on error in wm2000_anc_transition()

Miaoqian Lin <linmq006@gmail.com>
    thermal/drivers/imx_sc_thermal: Fix refcount leak in imx_sc_thermal_probe

Yang Yingliang <yangyingliang@huawei.com>
    thermal/core: Fix memory leak in __thermal_cooling_device_register()

Daniel Lezcano <daniel.lezcano@linaro.org>
    thermal/drivers/core: Use a char pointer for the cooling device name

Zheng Yongjun <zhengyongjun3@huawei.com>
    thermal/drivers/broadcom: Fix potential NULL dereference in sr_thermal_probe

Stefan Wahren <stefan.wahren@i2se.com>
    thermal/drivers/bcm2711: Don't clamp temperature at zero

Nathan Chancellor <nathan@kernel.org>
    drm/i915: Fix CFI violation with show_dynamic_id()

Abhinav Kumar <quic_abhinavk@quicinc.com>
    drm/msm/dpu: handle pm_runtime_get_sync() errors in bind path

Lai Jiangshan <jiangshan.ljs@antgroup.com>
    x86/sev: Annotate stack change in the #VC handler

Hangyu Hua <hbh25y@gmail.com>
    drm: msm: fix possible memory leak in mdp5_crtc_cursor_set()

Miaoqian Lin <linmq006@gmail.com>
    drm/msm/a6xx: Fix refcount leak in a6xx_gpu_init

Eric Biggers <ebiggers@google.com>
    ext4: reject the 'commit' option on ext2 filesystems

Jonas Karlman <jonas@kwiboo.se>
    media: rkvdec: h264: Fix bit depth wrap in pps packet

Nicolas Dufresne <nicolas.dufresne@collabora.com>
    media: rkvdec: h264: Fix dpb_valid implementation

Nicolas Dufresne <nicolas.dufresne@collabora.com>
    media: rkvdec: Stop overclocking the decoder

Cai Huoqing <caihuoqing@baidu.com>
    media: staging: media: rkvdec: Make use of the helper function devm_platform_ioremap_resource()

Dongliang Mu <mudongliangabcd@gmail.com>
    media: ov7670: remove ov7670_power_off from ov7670_remove

Miaoqian Lin <linmq006@gmail.com>
    ASoC: ti: j721e-evm: Fix refcount leak in j721e_soc_probe_*

Zheng Bin <zhengbin13@huawei.com>
    net: hinic: add missing destroy_workqueue in hinic_pf_to_mgmt_init

Eric Dumazet <edumazet@google.com>
    sctp: read sk->sk_bound_dev_if once in sctp_rcv()

Paul Moore <paul@paul-moore.com>
    lsm,selinux: pass flowi_common instead of flowi to the LSM hooks

Geert Uytterhoeven <geert@linux-m68k.org>
    m68k: math-emu: Fix dependencies of math emulation support

Keith Busch <kbusch@kernel.org>
    nvme: set dma alignment to dword

Niels Dossche <dossche.niels@gmail.com>
    Bluetooth: use hdev lock for accept_list and reject_list in conn req

Archie Pusaka <apusaka@chromium.org>
    Bluetooth: use inclusive language when filtering devices

Archie Pusaka <apusaka@chromium.org>
    Bluetooth: use inclusive language in HCI role comments

Sathish Narasimman <sathish.narasimman@intel.com>
    Bluetooth: LL privacy allow RPA

Bhaskar Chowdhury <unixbhaskar@gmail.com>
    Bluetooth: L2CAP: Rudimentary typo fixes

Howard Chung <howardchung@google.com>
    Bluetooth: Interleave with allowlist scan

Ying Hsu <yinghsu@chromium.org>
    Bluetooth: fix dangling sco_conn and use-after-free in sco_sock_timeout

Michael Rodin <mrodin@de.adit-jv.com>
    media: vsp1: Fix offset calculation for plane cropping

Pavel Skripkin <paskripkin@gmail.com>
    media: pvrusb2: fix array-index-out-of-bounds in pvr2_i2c_core_init

Miaoqian Lin <linmq006@gmail.com>
    media: exynos4-is: Change clk_disable to clk_disable_unprepare

Miaoqian Lin <linmq006@gmail.com>
    media: st-delta: Fix PM disable depth imbalance in delta_probe

Miaoqian Lin <linmq006@gmail.com>
    media: exynos4-is: Fix PM disable depth imbalance in fimc_is_probe

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    media: aspeed: Fix an error handling path in aspeed_video_probe()

Josh Poimboeuf <jpoimboe@kernel.org>
    scripts/faddr2line: Fix overlapping text section failures

Phil Auld <pauld@redhat.com>
    kselftest/cgroup: fix test_stress.sh to use OUTPUT dir

Miaoqian Lin <linmq006@gmail.com>
    ASoC: samsung: Fix refcount leak in aries_audio_probe

Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
    ASoC: samsung: Use dev_err_probe() helper

Miaoqian Lin <linmq006@gmail.com>
    regulator: pfuze100: Fix refcount leak in pfuze_parse_regulators_dt

Miaoqian Lin <linmq006@gmail.com>
    ASoC: mxs-saif: Fix refcount leak in mxs_saif_probe

Miaoqian Lin <linmq006@gmail.com>
    ASoC: fsl: Fix refcount leak in imx_sgtl5000_probe

Baochen Qiang <quic_bqiang@quicinc.com>
    ath11k: Don't check arvif->is_started before sending management frames

Ravi Bangoria <ravi.bangoria@amd.com>
    perf/amd/ibs: Use interrupt regs ip for stack unwinding

Konrad Dybcio <konrad.dybcio@somainline.org>
    regulator: qcom_smd: Fix up PM8950 regulator configuration

Viresh Kumar <viresh.kumar@linaro.org>
    Revert "cpufreq: Fix possible race in cpufreq online error path"

Yang Yingliang <yangyingliang@huawei.com>
    spi: spi-fsl-qspi: check return value after calling platform_get_resource_byname()

Andreas Gruenbacher <agruenba@redhat.com>
    iomap: iomap_write_failed fix

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

Christoph Hellwig <hch@lst.de>
    virtio_blk: fix the discard_granularity and discard_alignment queue limits

James Clark <james.clark@arm.com>
    perf tools: Use Python devtools for version autodetection rather than runtime

Yang Yingliang <yangyingliang@huawei.com>
    drm/rockchip: vop: fix possible null-ptr-deref in vop_bind()

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
    mtd: rawnand: cadence: fix possible null-ptr-deref in cadence_nand_dt_probe()

Matthieu Baerts <matthieu.baerts@tessares.net>
    x86/pm: Fix false positive kmemleak report in msr_build_context()

Chen-Tsung Hsieh <chentsung@chromium.org>
    mtd: spi-nor: core: Check written SR value in spi_nor_write_16bit_sr_and_check()

Andrii Nakryiko <andrii@kernel.org>
    libbpf: Fix logic for finding matching program for CO-RE relocation

Colin Ian King <colin.i.king@gmail.com>
    selftests/resctrl: Fix null pointer dereference on open failed

Kiwoong Kim <kwmad.kim@samsung.com>
    scsi: ufs: core: Exclude UECxx from SFR dump list

Bart Van Assche <bvanassche@acm.org>
    scsi: ufs: qcom: Fix ufs_qcom_resume()

Kuogee Hsieh <quic_khsieh@quicinc.com>
    drm/msm/dpu: adjust display_v_end for eDP and DP

Nuno Sá <nuno.sa@analog.com>
    of: overlay: do not break notify on NOTIFY_{OK|STOP}

Amir Goldstein <amir73il@gmail.com>
    fsnotify: fix wrong lockdep annotations

Amir Goldstein <amir73il@gmail.com>
    inotify: show inotify mask flags in proc fdinfo

Colin Ian King <colin.i.king@gmail.com>
    ALSA: pcm: Check for null pointer of pointer substream before dereferencing it

Marek Vasut <marex@denx.de>
    drm/panel: simple: Add missing bus flags for Innolux G070Y2-L01

Chen-Yu Tsai <wenst@chromium.org>
    media: hantro: Empty encoder capture buffers by default

Dan Carpenter <dan.carpenter@oracle.com>
    ath9k_htc: fix potential out of bounds access with invalid rxstatus->rs_keyix

Schspa Shi <schspa@gmail.com>
    cpufreq: Fix possible race in cpufreq online error path

Zheng Yongjun <zhengyongjun3@huawei.com>
    spi: img-spfi: Fix pm_runtime_get_sync() error checking

Chengming Zhou <zhouchengming@bytedance.com>
    sched/fair: Fix cfs_rq_clock_pelt() for throttled cfs_rq

Miaoqian Lin <linmq006@gmail.com>
    drm/bridge: Fix error handling in analogix_dp_probe

Miaoqian Lin <linmq006@gmail.com>
    HID: elan: Fix potential double free in elan_input_configured

Jonathan Teh <jonathan.teh@outlook.com>
    HID: hid-led: fix maximum brightness for Dream Cheeky

Zheyu Ma <zheyuma97@gmail.com>
    mtd: rawnand: denali: Use managed device resources

Tyler Hicks <tyhicks@linux.microsoft.com>
    EDAC/dmc520: Don't print an error for each unconfigured interrupt line

Arnd Bergmann <arnd@arndb.de>
    drbd: fix duplicate array initializer

Christoph Hellwig <hch@lst.de>
    target: remove an incorrect unmap zeroes data deduction

Jan Kiszka <jan.kiszka@siemens.com>
    efi: Add missing prototype for efi_capsule_setup_info

Lin Ma <linma@zju.edu.cn>
    NFC: NULL out the dev->rfkill to prevent UAF

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

Yuntao Wang <ytcoode@gmail.com>
    bpf: Fix excessive memory allocation in stack_map_alloc()

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

Paul Cercueil <paul@crapouillou.net>
    drm/ingenic: Reset pixclock rate when parent clock rate changes

Ammar Faizi <ammarfaizi2@gnuweeb.org>
    x86/delay: Fix the wrong asm constraint in delay_loop()

Miaoqian Lin <linmq006@gmail.com>
    ASoC: mediatek: Fix missing of_node_put in mt2701_wm8960_machine_probe

Miaoqian Lin <linmq006@gmail.com>
    ASoC: mediatek: Fix error handling in mt8173_max98090_dev_probe

Kuldeep Singh <singh.kuldeep87k@gmail.com>
    spi: qcom-qspi: Add minItems to interconnect-names

Lucas Stach <l.stach@pengutronix.de>
    drm/bridge: adv7511: clean up CEC adapter when probe fails

Jani Nikula <jani.nikula@intel.com>
    drm/edid: fix invalid EDID extension block filtering

Wenli Looi <wlooi@ucalgary.ca>
    ath9k: fix ar9003_get_eepmisc

Niels Dossche <dossche.niels@gmail.com>
    ath11k: acquire ab->base_lock in unassign when finding the peer by addr

Noralf Trønnes <noralf@tronnes.org>
    dt-bindings: display: sitronix, st7735r: Fix backlight in example

Linus Torvalds <torvalds@linux-foundation.org>
    drm: fix EDID struct for old ARM OABI format

Douglas Miller <doug.miller@cornelisnetworks.com>
    RDMA/hfi1: Prevent panic when SDMA is disabled

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

Vasily Averin <vvs@openvz.org>
    tracing: incorrect isolate_mote_t cast in mm_vmscan_lru_isolate

Yicong Yang <yangyicong@hisilicon.com>
    PCI: Avoid pci_dev_lock() AB/BA deadlock with sriov_numvfs_store()

Peng Wu <wupeng58@huawei.com>
    ARM: hisi: Add missing of_node_put after of_find_compatible_node

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

Zixuan Fu <r33s3n6@gmail.com>
    fs: jfs: fix possible NULL pointer dereference in dbFree()

QintaoShen <unSimple1993@163.com>
    soc: ti: ti_sci_pm_domains: Check for null return of devm_kcalloc

Gilad Ben-Yossef <gilad@benyossef.com>
    crypto: ccree - use fine grained DMA mapping dir

Brian Norris <briannorris@chromium.org>
    PM / devfreq: rk3399_dmc: Disable edev on remove()

Konrad Dybcio <konrad.dybcio@somainline.org>
    arm64: dts: qcom: msm8994: Fix BLSP[12]_DMA channels count

Krzysztof Kozlowski <krzk@kernel.org>
    ARM: dts: s5pv210: align DMA channels with dtschema

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    ARM: dts: ox820: align interrupt controller node name with dtschema

Niels Dossche <dossche.niels@gmail.com>
    IB/rdmavt: add missing locks in rvt_ruc_loopback

Bob Peterson <rpeterso@redhat.com>
    gfs2: use i_lock spin_lock for inode qadata

Yonghong Song <yhs@fb.com>
    selftests/bpf: fix btf_dump/btf_dump due to recent clang change

Jakub Kicinski <kuba@kernel.org>
    eth: tg3: silence the GCC 12 array-bounds warning

David Howells <dhowells@redhat.com>
    rxrpc, afs: Fix selection of abort codes

David Howells <dhowells@redhat.com>
    rxrpc: Return an error to sendmsg if call failed

Geert Uytterhoeven <geert@linux-m68k.org>
    m68k: atari: Make Atari ROM port I/O write macros return void

Borislav Petkov <bp@suse.de>
    x86/microcode: Add explicit CPU vendor dependency

Vincent Mailhol <mailhol.vincent@wanadoo.fr>
    can: mcp251xfd: silence clang's -Wunaligned-access warning

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    ASoC: rt1015p: remove dependency on GPIOLIB

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    ASoC: max98357a: remove dependency on GPIOLIB

Kwanghoon Son <k.son@samsung.com>
    media: exynos4-is: Fix compile warning

Fabio Estevam <festevam@denx.de>
    net: phy: micrel: Allow probing without .driver_data

Xie Yongji <xieyongji@bytedance.com>
    nbd: Fix hung on disconnect request if socket is closed before

Lin Ma <linma@zju.edu.cn>
    ASoC: rt5645: Fix errorenous cleanup order

Smith, Kyle Miller (Nimble Kernel) <kyles@hpe.com>
    nvme-pci: fix a NULL pointer dereference in nvme_alloc_admin_tags

Jason A. Donenfeld <Jason@zx2c4.com>
    openrisc: start CPU timer early in boot

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    media: cec-adap.c: fix is_configuring state

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    media: imon: reorganize serialization

Philipp Zabel <p.zabel@pengutronix.de>
    media: coda: limit frame interval enumeration to supported encoder frame sizes

Hangyu Hua <hbh25y@gmail.com>
    media: rga: fix possible memory leak in rga_probe

Dongliang Mu <mudongliangabcd@gmail.com>
    rtlwifi: Use pr_warn instead of WARN_ONCE

Corey Minyard <cminyard@mvista.com>
    ipmi: Fix pr_fmt to avoid compilation issues

Corey Minyard <cminyard@mvista.com>
    ipmi:ssif: Check for NULL msg when handling events and messages

Mario Limonciello <mario.limonciello@amd.com>
    ACPI: PM: Block ASUS B1400CEAE from suspend to idle by default

Mikulas Patocka <mpatocka@redhat.com>
    dma-debug: change allocation mode from GFP_NOWAIT to GFP_ATIOMIC

Patrice Chotard <patrice.chotard@foss.st.com>
    spi: stm32-qspi: Fix wait_cmd timeout in APM mode

Ravi Bangoria <ravi.bangoria@amd.com>
    perf/amd/ibs: Cascade pmu init functions' return value

Heiko Carstens <hca@linux.ibm.com>
    s390/preempt: disable __preempt_count_add() optimization for PROFILE_ALL_BRANCHES

Eric Dumazet <edumazet@google.com>
    net: remove two BUG() from skb_checksum_help()

Charles Keepax <ckeepax@opensource.cirrus.com>
    ASoC: tscs454: Add endianness flag in snd_soc_component_driver

Dongliang Mu <mudongliangabcd@gmail.com>
    HID: bigben: fix slab-out-of-bounds Write in bigben_probe

Alice Wong <shiwei.wong@amd.com>
    drm/amdgpu/ucode: Remove firmware load type check in amdgpu_ucode_free_bo

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

Luca Weiss <luca.weiss@fairphone.com>
    media: venus: hfi: avoid null dereference in deinit

Thibaut VARÈNE <hacks+kernel@slashdirt.org>
    ath9k: fix QCA9561 PA bias level

Keita Suzuki <keitasuzuki.park@sslab.ics.keio.ac.jp>
    drm/amd/pm: fix double free in si_parse_power_table()

Len Brown <len.brown@intel.com>
    tools/power turbostat: fix ICX DRAM power numbers

Biju Das <biju.das.jz@bp.renesas.com>
    spi: spi-rspi: Remove setting {src,dst}_{addr,addr_width} based on DMA direction

Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>
    ALSA: jack: Access input_dev under mutex

Haowen Bai <baihaowen@meizu.com>
    sfc: ef10: Fix assigning negative value to unsigned variable

Paul E. McKenney <paulmck@kernel.org>
    rcu: Make TASKS_RUDE_RCU select IRQ_WORK

Padmanabha Srinivasaiah <treasure4paddy@gmail.com>
    rcu-tasks: Fix race in schedule and flush work

Liviu Dudau <liviu.dudau@arm.com>
    drm/komeda: return early if drm_universal_plane_init() fails.

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

Nikolay Borisov <nborisov@suse.com>
    selftests/bpf: Fix vfs_link kprobe definition

Liu Zixian <liuzixian4@huawei.com>
    drm/virtio: fix NULL pointer dereference in virtio_gpu_conn_get_modes

Tejas Upadhyay <tejaskumarx.surendrakumar.upadhyay@intel.com>
    iommu/vt-d: Add RPLS to quirk list to skip TE disabling

Qu Wenruo <wqu@suse.com>
    btrfs: repair super block num_devices automatically

Qu Wenruo <wqu@suse.com>
    btrfs: add "0x" prefix for unsupported optional features

Eric W. Biederman <ebiederm@xmission.com>
    ptrace: Reimplement PTRACE_KILL by always sending SIGKILL

Eric W. Biederman <ebiederm@xmission.com>
    ptrace/xtensa: Replace PT_SINGLESTEP with TIF_SINGLESTEP

Eric W. Biederman <ebiederm@xmission.com>
    ptrace/um: Replace PT_DTRACE with TIF_SINGLESTEP

Kan Liang <kan.liang@linux.intel.com>
    perf/x86/intel: Fix event constraints for ICL

Ammar Faizi <ammarfaizi2@gnuweeb.org>
    x86/MCE/AMD: Fix memory leak when threshold_create_bank() fails

Helge Deller <deller@gmx.de>
    parisc/stifb: Keep track of hardware path of graphics card

Peilin Ye <yepeilin.cs@gmail.com>
    Fonts: Make font size unsigned in font_desc

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: Allow host runtime PM as default for Intel Alder Lake N xHCI

Ronnie Sahlberg <lsahlber@redhat.com>
    cifs: when extending a file with falloc we should make files not-sparse

Kishon Vijay Abraham I <kishon@ti.com>
    usb: core: hcd: Add support for deferring roothub registration

Albert Wang <albertccwang@google.com>
    usb: dwc3: gadget: Move null pinter check to proper place

Monish Kumar R <monish.kumar.r@intel.com>
    USB: new quirk for Dell Gen 2 devices

Carl Yin(殷张成) <carl.yin@quectel.com>
    USB: serial: option: add Quectel BG95 modem

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Cancel pending work at closing a MIDI substream

Marios Levogiannis <marios.levogiannis@gmail.com>
    ALSA: hda/realtek - Fix microphone noise on ASUS TUF B550M-PLUS

Rik van der Kemp <rik@upto11.nl>
    ALSA: hda/realtek: Enable 4-speaker output for Dell XPS 15 9520 laptop

Samuel Holland <samuel@sholland.org>
    riscv: Fix irq_work when SMP is disabled

Alexandre Ghiti <alexandre.ghiti@canonical.com>
    riscv: Initialize thread pointer before calling C functions

Helge Deller <deller@gmx.de>
    parisc/stifb: Implement fb_is_primary_device()

Niklas Cassel <niklas.cassel@wdc.com>
    binfmt_flat: do not stop relocating GOT entries prematurely on riscv

Stephen Boyd <swboyd@chromium.org>
    arm64: Initialize jump labels before setup_machine_fdt()


-------------

Diffstat:

 Documentation/conf.py                              |   2 +-
 .../bindings/display/sitronix,st7735r.yaml         |   1 +
 .../devicetree/bindings/gpio/gpio-altera.txt       |   5 +-
 .../bindings/spi/qcom,spi-qcom-qspi.yaml           |   1 +
 Makefile                                           |   4 +-
 arch/arm/boot/dts/bcm2835-rpi-b.dts                |  13 +-
 arch/arm/boot/dts/bcm2835-rpi-zero-w.dts           |  22 +-
 arch/arm/boot/dts/bcm2837-rpi-3-b-plus.dts         |   2 +-
 arch/arm/boot/dts/bcm2837-rpi-cm3-io3.dts          |   4 +-
 arch/arm/boot/dts/exynos5250-smdk5250.dts          |   4 +-
 arch/arm/boot/dts/imx6dl-eckelmann-ci4x10.dts      |   6 +-
 arch/arm/boot/dts/imx6qdl-colibri.dtsi             |   6 +-
 arch/arm/boot/dts/ox820.dtsi                       |   2 +-
 arch/arm/boot/dts/s5pv210-aries.dtsi               |   3 +-
 arch/arm/boot/dts/s5pv210.dtsi                     |  12 +-
 arch/arm/boot/dts/stm32mp15xx-dhcor-avenger96.dtsi |   1 +
 arch/arm/boot/dts/suniv-f1c100s.dtsi               |   4 +-
 arch/arm/mach-hisi/platsmp.c                       |   4 +
 arch/arm/mach-mediatek/Kconfig                     |   1 +
 arch/arm/mach-omap1/clock.c                        |   2 +-
 arch/arm/mach-pxa/cm-x300.c                        |   8 +-
 arch/arm/mach-pxa/magician.c                       |   2 +-
 arch/arm/mach-pxa/tosa.c                           |   4 +-
 arch/arm/mach-vexpress/dcscb.c                     |   1 +
 arch/arm64/Kconfig.platforms                       |   1 +
 arch/arm64/boot/dts/qcom/ipq8074.dtsi              |   2 +-
 arch/arm64/boot/dts/qcom/msm8994.dtsi              |   4 +-
 arch/arm64/boot/dts/rockchip/rk3399.dtsi           |   2 +-
 arch/arm64/kernel/setup.c                          |   7 +-
 arch/arm64/kernel/sys_compat.c                     |   2 +-
 arch/arm64/mm/copypage.c                           |   4 +-
 arch/csky/kernel/probes/kprobes.c                  |   2 +-
 arch/m68k/Kconfig.cpu                              |   2 +-
 arch/m68k/include/asm/raw_io.h                     |   6 +-
 .../include/asm/mach-ip27/cpu-feature-overrides.h  |   1 -
 .../include/asm/mach-ip30/cpu-feature-overrides.h  |   1 -
 arch/openrisc/include/asm/timex.h                  |   1 +
 arch/openrisc/kernel/head.S                        |   9 +
 arch/parisc/include/asm/fb.h                       |   4 +
 arch/powerpc/include/asm/page.h                    |   7 +-
 arch/powerpc/include/asm/vas.h                     |   2 +-
 arch/powerpc/kernel/fadump.c                       |   8 +-
 arch/powerpc/kernel/idle.c                         |   2 +-
 arch/powerpc/perf/isa207-common.c                  |   3 +-
 arch/powerpc/platforms/4xx/cpm.c                   |   2 +-
 arch/powerpc/platforms/8xx/cpm1.c                  |   1 +
 arch/powerpc/platforms/powernv/opal-fadump.c       |  94 +++++----
 arch/powerpc/platforms/powernv/opal-fadump.h       |  10 +-
 arch/powerpc/platforms/powernv/ultravisor.c        |   1 +
 arch/powerpc/platforms/powernv/vas-fault.c         |   2 +-
 arch/powerpc/platforms/powernv/vas-window.c        |   4 +-
 arch/powerpc/platforms/powernv/vas.h               |   2 +-
 arch/powerpc/sysdev/dart_iommu.c                   |   6 +-
 arch/powerpc/sysdev/fsl_rio.c                      |   2 +
 arch/powerpc/sysdev/xics/icp-opal.c                |   1 +
 arch/riscv/include/asm/irq_work.h                  |   2 +-
 arch/riscv/kernel/head.S                           |   1 +
 arch/s390/include/asm/kexec.h                      |  10 +
 arch/s390/include/asm/preempt.h                    |  15 +-
 arch/s390/kernel/perf_event.c                      |   2 +-
 arch/um/drivers/chan_user.c                        |   9 +-
 arch/um/include/asm/thread_info.h                  |   2 +
 arch/um/kernel/exec.c                              |   2 +-
 arch/um/kernel/process.c                           |   2 +-
 arch/um/kernel/ptrace.c                            |   8 +-
 arch/um/kernel/signal.c                            |   4 +-
 arch/x86/Kconfig                                   |   4 +-
 arch/x86/entry/entry_64.S                          |   1 +
 arch/x86/entry/vdso/vma.c                          |   2 +-
 arch/x86/events/amd/ibs.c                          |  55 ++++-
 arch/x86/events/intel/core.c                       |   2 +-
 arch/x86/include/asm/acenv.h                       |  14 +-
 arch/x86/include/asm/kexec.h                       |   8 +
 arch/x86/include/asm/suspend_32.h                  |   2 +-
 arch/x86/include/asm/suspend_64.h                  |  12 +-
 arch/x86/kernel/apic/apic.c                        |   2 +-
 arch/x86/kernel/apic/x2apic_uv_x.c                 |   8 +-
 arch/x86/kernel/cpu/intel.c                        |   2 +-
 arch/x86/kernel/cpu/mce/amd.c                      |  32 +--
 arch/x86/kernel/step.c                             |   3 +-
 arch/x86/kernel/sys_x86_64.c                       |   7 +-
 arch/x86/kvm/vmx/nested.c                          |  45 ++++-
 arch/x86/kvm/vmx/vmcs.h                            |   5 +
 arch/x86/lib/delay.c                               |   4 +-
 arch/x86/mm/pat/memtype.c                          |   2 +-
 arch/x86/um/ldt.c                                  |   6 +-
 arch/xtensa/kernel/ptrace.c                        |   4 +-
 arch/xtensa/kernel/signal.c                        |   4 +-
 arch/xtensa/platforms/iss/simdisk.c                |  18 +-
 block/bfq-cgroup.c                                 | 111 +++++++----
 block/bfq-iosched.c                                |  46 +++--
 block/bfq-iosched.h                                |   6 +-
 block/blk-cgroup.c                                 |   8 +-
 block/blk-iolatency.c                              | 122 ++++++------
 crypto/cryptd.c                                    |  23 +--
 drivers/acpi/property.c                            |  18 +-
 drivers/acpi/sleep.c                               |  12 ++
 drivers/base/memory.c                              |   5 +-
 drivers/base/node.c                                |   1 +
 drivers/block/drbd/drbd_main.c                     |  11 +-
 drivers/block/nbd.c                                |  13 +-
 drivers/block/virtio_blk.c                         |   7 +-
 drivers/char/hw_random/omap3-rom-rng.c             |   2 +-
 drivers/char/ipmi/ipmi_msghandler.c                |   4 +-
 drivers/char/ipmi/ipmi_ssif.c                      |  23 +++
 drivers/char/random.c                              |  12 +-
 drivers/cpufreq/mediatek-cpufreq.c                 |  19 +-
 .../crypto/allwinner/sun8i-ss/sun8i-ss-cipher.c    | 115 +++++++----
 drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c  |  30 ++-
 drivers/crypto/allwinner/sun8i-ss/sun8i-ss-hash.c  |  10 +-
 drivers/crypto/allwinner/sun8i-ss/sun8i-ss.h       |  14 +-
 drivers/crypto/ccree/cc_buffer_mgr.c               |  27 +--
 drivers/crypto/marvell/cesa/cipher.c               |   1 -
 drivers/crypto/nx/nx-common-powernv.c              |   2 +-
 drivers/devfreq/rk3399_dmc.c                       |   2 +
 drivers/dma/idxd/cdev.c                            |   8 +-
 drivers/dma/stm32-mdma.c                           |  87 ++++----
 drivers/edac/dmc520_edac.c                         |   2 +-
 drivers/firmware/arm_scmi/base.c                   |   2 +-
 drivers/gpio/gpiolib-of.c                          |   5 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c             |   2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_ucode.c          |   3 +-
 drivers/gpu/drm/amd/pm/powerplay/kv_dpm.c          |  14 +-
 drivers/gpu/drm/amd/pm/powerplay/si_dpm.c          |   8 +-
 drivers/gpu/drm/arm/display/komeda/komeda_plane.c  |  10 +-
 drivers/gpu/drm/arm/malidp_crtc.c                  |   5 +-
 drivers/gpu/drm/bridge/adv7511/adv7511_drv.c       |   1 +
 drivers/gpu/drm/bridge/analogix/analogix_dp_core.c |  31 ++-
 drivers/gpu/drm/drm_edid.c                         |   6 +-
 drivers/gpu/drm/drm_plane.c                        |  14 +-
 drivers/gpu/drm/etnaviv/etnaviv_mmu.c              |   6 +
 drivers/gpu/drm/gma500/psb_intel_display.c         |   7 +-
 drivers/gpu/drm/i915/display/intel_dsi_vbt.c       |  33 ++-
 drivers/gpu/drm/i915/i915_perf.c                   |   4 +-
 drivers/gpu/drm/i915/i915_perf_types.h             |   2 +-
 drivers/gpu/drm/ingenic/ingenic-drm-drv.c          |  61 +++++-
 drivers/gpu/drm/mediatek/mtk_cec.c                 |   2 +-
 drivers/gpu/drm/msm/adreno/a6xx_gpu.c              |   1 +
 drivers/gpu/drm/msm/disp/dpu1/dpu_hw_intf.c        |   1 +
 drivers/gpu/drm/msm/disp/dpu1/dpu_kms.c            |   8 +-
 drivers/gpu/drm/msm/disp/mdp5/mdp5_crtc.c          |  14 +-
 drivers/gpu/drm/msm/disp/mdp5/mdp5_kms.c           |   6 +-
 drivers/gpu/drm/msm/disp/mdp5/mdp5_mixer.c         |  15 +-
 drivers/gpu/drm/msm/disp/mdp5/mdp5_mixer.h         |   4 +-
 drivers/gpu/drm/msm/disp/mdp5/mdp5_pipe.c          |  15 +-
 drivers/gpu/drm/msm/disp/mdp5/mdp5_pipe.h          |   2 +-
 drivers/gpu/drm/msm/disp/mdp5/mdp5_plane.c         |  20 +-
 drivers/gpu/drm/msm/dp/dp_display.c                |  55 +++--
 drivers/gpu/drm/msm/dsi/dsi_host.c                 |  21 +-
 drivers/gpu/drm/msm/hdmi/hdmi.c                    |  10 +-
 drivers/gpu/drm/msm/msm_drv.c                      |   1 +
 drivers/gpu/drm/msm/msm_gem_prime.c                |   2 +-
 drivers/gpu/drm/nouveau/dispnv50/atom.h            |   6 +-
 drivers/gpu/drm/nouveau/dispnv50/crc.c             |  27 ++-
 drivers/gpu/drm/nouveau/nvkm/subdev/clk/base.c     |   6 +-
 drivers/gpu/drm/panel/panel-simple.c               |   3 +-
 drivers/gpu/drm/rockchip/rockchip_drm_vop.c        |   2 +-
 drivers/gpu/drm/stm/ltdc.c                         |  16 +-
 drivers/gpu/drm/tilcdc/tilcdc_external.c           |   8 +-
 drivers/gpu/drm/vc4/vc4_hvs.c                      |  26 ++-
 drivers/gpu/drm/vc4/vc4_txp.c                      |   8 +-
 drivers/gpu/drm/virtio/virtgpu_display.c           |   2 +
 drivers/hid/hid-bigbenff.c                         |   6 +
 drivers/hid/hid-elan.c                             |   2 -
 drivers/hid/hid-led.c                              |   2 +-
 drivers/hwtracing/coresight/coresight-core.c       |  33 ++-
 drivers/i2c/busses/i2c-at91-master.c               |  11 +
 drivers/i2c/busses/i2c-npcm7xx.c                   | 103 ++++++----
 drivers/i2c/busses/i2c-rcar.c                      |  15 +-
 drivers/infiniband/hw/hfi1/file_ops.c              |   2 +
 drivers/infiniband/hw/hfi1/init.c                  |   2 +-
 drivers/infiniband/hw/hfi1/sdma.c                  |  12 +-
 drivers/infiniband/sw/rdmavt/qp.c                  |   6 +-
 drivers/infiniband/sw/rxe/rxe_req.c                |   2 +-
 drivers/input/misc/sparcspkr.c                     |   1 +
 drivers/input/touchscreen/stmfts.c                 |  16 +-
 drivers/iommu/amd/init.c                           |   2 +-
 drivers/iommu/intel/iommu.c                        |   2 +-
 drivers/iommu/msm_iommu.c                          |  11 +-
 drivers/iommu/mtk_iommu.c                          |   3 +-
 drivers/irqchip/irq-armada-370-xp.c                |  11 +-
 drivers/irqchip/irq-aspeed-i2c-ic.c                |   4 +-
 drivers/irqchip/irq-aspeed-scu-ic.c                |   4 +-
 drivers/irqchip/irq-sni-exiu.c                     |  25 ++-
 drivers/irqchip/irq-xtensa-mx.c                    |  18 +-
 drivers/macintosh/Kconfig                          |   6 +
 drivers/macintosh/Makefile                         |   3 +-
 drivers/macintosh/via-pmu.c                        |   2 +-
 drivers/mailbox/mailbox.c                          |  19 +-
 drivers/md/bcache/btree.c                          |  58 +++---
 drivers/md/bcache/btree.h                          |   2 +-
 drivers/md/bcache/journal.c                        |  31 ++-
 drivers/md/bcache/journal.h                        |   2 +
 drivers/md/bcache/request.c                        |   6 +
 drivers/md/bcache/super.c                          |   1 +
 drivers/md/bcache/writeback.c                      | 101 ++++------
 drivers/md/bcache/writeback.h                      |   2 +-
 drivers/md/md-bitmap.c                             |  44 ++--
 drivers/md/md.c                                    |  18 +-
 drivers/media/cec/core/cec-adap.c                  |   6 +-
 drivers/media/i2c/ov7670.c                         |   1 -
 drivers/media/pci/cx23885/cx23885-core.c           |   6 +-
 drivers/media/pci/cx25821/cx25821-core.c           |   2 +-
 drivers/media/platform/aspeed-video.c              |   4 +-
 drivers/media/platform/coda/coda-common.c          |  35 ++--
 drivers/media/platform/exynos4-is/fimc-is.c        |   6 +-
 drivers/media/platform/exynos4-is/fimc-isp-video.h |   2 +-
 drivers/media/platform/qcom/venus/hfi.c            |   3 +
 drivers/media/platform/rockchip/rga/rga.c          |   6 +-
 drivers/media/platform/sti/delta/delta-v4l2.c      |   6 +-
 drivers/media/platform/vsp1/vsp1_rpf.c             |   6 +-
 drivers/media/rc/imon.c                            |  99 +++++----
 drivers/media/usb/pvrusb2/pvrusb2-hdw.c            |   7 +-
 drivers/media/usb/uvc/uvc_v4l2.c                   |  20 +-
 drivers/memory/samsung/exynos5422-dmc.c            |   5 +-
 drivers/mfd/davinci_voicecodec.c                   |   6 +-
 drivers/mfd/ipaq-micro.c                           |   2 +-
 drivers/misc/ocxl/file.c                           |   2 +
 drivers/mmc/host/jz4740_mmc.c                      |  20 ++
 drivers/mmc/host/sdhci_am654.c                     |  23 ++-
 drivers/mtd/chips/cfi_cmdset_0002.c                | 103 +++++-----
 drivers/mtd/nand/raw/cadence-nand-controller.c     |   5 +-
 drivers/mtd/nand/raw/denali_pci.c                  |  15 +-
 drivers/mtd/spi-nor/core.c                         |   9 +
 drivers/net/can/spi/mcp251xfd/mcp251xfd.h          |   2 +-
 drivers/net/can/xilinx_can.c                       |   4 +-
 drivers/net/dsa/mt7530.c                           |  14 +-
 drivers/net/ethernet/broadcom/Makefile             |   5 +
 .../chelsio/inline_crypto/chtls/chtls_cm.c         |   2 +-
 .../net/ethernet/huawei/hinic/hinic_hw_api_cmd.c   |   5 +-
 drivers/net/ethernet/huawei/hinic/hinic_hw_cmdq.c  |  10 +-
 drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c   |   5 +-
 drivers/net/ethernet/huawei/hinic/hinic_hw_eqs.c   |   9 +-
 drivers/net/ethernet/huawei/hinic/hinic_hw_mgmt.c  |   2 +
 drivers/net/ethernet/huawei/hinic/hinic_hw_wq.c    |  23 +--
 drivers/net/ethernet/huawei/hinic/hinic_main.c     |  10 +-
 drivers/net/ethernet/huawei/hinic/hinic_tx.c       |   9 +-
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c  |  10 +-
 drivers/net/ethernet/mellanox/mlxsw/core_thermal.c |   2 +-
 drivers/net/ethernet/mellanox/mlxsw/spectrum_dcb.c |  13 --
 .../net/ethernet/mellanox/mlxsw/spectrum_trap.c    |   2 +-
 drivers/net/ethernet/sfc/ef10.c                    |   2 +-
 .../net/ethernet/stmicro/stmmac/stmmac_selftests.c |  15 +-
 drivers/net/hyperv/netvsc_drv.c                    |   5 +-
 drivers/net/ipa/ipa_endpoint.c                     |   4 +-
 drivers/net/phy/micrel.c                           |  11 +-
 drivers/net/wireguard/socket.c                     |   4 +-
 drivers/net/wireless/ath/ath10k/mac.c              |  20 +-
 drivers/net/wireless/ath/ath11k/mac.c              |  16 +-
 drivers/net/wireless/ath/ath11k/spectral.c         |  17 +-
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c     |   2 +-
 drivers/net/wireless/ath/ath9k/ar9003_phy.h        |   2 +-
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c      |   8 +
 drivers/net/wireless/ath/carl9170/tx.c             |   3 +
 drivers/net/wireless/broadcom/b43/phy_n.c          |   2 +-
 drivers/net/wireless/broadcom/b43legacy/phy.c      |   2 +-
 drivers/net/wireless/intel/ipw2x00/libipw_tx.c     |   2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/power.c     |   3 +
 drivers/net/wireless/marvell/mwifiex/11h.c         |   2 +
 drivers/net/wireless/realtek/rtl818x/rtl8180/dev.c |   8 +-
 drivers/net/wireless/realtek/rtlwifi/usb.c         |   2 +-
 drivers/nfc/st21nfca/se.c                          |  17 +-
 drivers/nfc/st21nfca/st21nfca.h                    |   1 +
 drivers/nvdimm/core.c                              |   9 -
 drivers/nvdimm/security.c                          |   5 -
 drivers/nvme/host/core.c                           |   2 +-
 drivers/nvme/host/pci.c                            |   1 +
 drivers/of/overlay.c                               |   4 +-
 drivers/opp/of.c                                   |   2 +-
 drivers/pci/controller/cadence/pcie-cadence-ep.c   |   3 +-
 drivers/pci/controller/dwc/pci-imx6.c              |  23 ++-
 drivers/pci/controller/dwc/pcie-designware-host.c  |   3 +-
 drivers/pci/controller/dwc/pcie-qcom.c             |   9 +-
 drivers/pci/controller/pcie-rockchip-ep.c          |   3 +-
 drivers/pci/pci.c                                  |  12 +-
 drivers/pci/pcie/aer.c                             |   7 +-
 drivers/phy/qualcomm/phy-qcom-qmp.c                |  11 +-
 drivers/pinctrl/bcm/pinctrl-bcm2835.c              |  18 ++
 drivers/pinctrl/mvebu/pinctrl-armada-37xx.c        |   2 +-
 drivers/pinctrl/renesas/core.c                     |   7 +-
 drivers/pinctrl/renesas/pinctrl-rzn1.c             |  10 +-
 drivers/platform/chrome/cros_ec.c                  |  16 +-
 drivers/platform/chrome/cros_ec_chardev.c          |   2 +-
 drivers/platform/chrome/cros_ec_proto.c            |  50 ++++-
 drivers/platform/mips/cpu_hwmon.c                  | 127 ++++--------
 drivers/regulator/core.c                           |   7 +-
 drivers/regulator/pfuze100-regulator.c             |   2 +
 drivers/regulator/qcom_smd-regulator.c             |  35 ++--
 drivers/scsi/dc395x.c                              |  15 +-
 drivers/scsi/fcoe/fcoe_ctlr.c                      |   2 +-
 drivers/scsi/lpfc/lpfc_sli.c                       |   6 +-
 drivers/scsi/megaraid.c                            |   2 +-
 drivers/scsi/ufs/ti-j721e-ufs.c                    |   6 +-
 drivers/scsi/ufs/ufs-qcom.c                        |  14 +-
 drivers/scsi/ufs/ufshcd.c                          |   7 +-
 drivers/soc/qcom/llcc-qcom.c                       |   1 +
 drivers/soc/qcom/smp2p.c                           |   1 +
 drivers/soc/qcom/smsm.c                            |   1 +
 drivers/soc/ti/ti_sci_pm_domains.c                 |   2 +
 drivers/spi/spi-fsl-qspi.c                         |   4 +
 drivers/spi/spi-img-spfi.c                         |   2 +-
 drivers/spi/spi-rspi.c                             |  15 +-
 drivers/spi/spi-stm32-qspi.c                       |   3 +-
 drivers/spi/spi-ti-qspi.c                          |   5 +-
 drivers/staging/media/hantro/hantro_v4l2.c         |   8 +-
 drivers/staging/media/rkvdec/rkvdec-h264.c         |  37 +++-
 drivers/staging/media/rkvdec/rkvdec.c              |  10 +-
 drivers/target/target_core_device.c                |   1 -
 drivers/thermal/broadcom/bcm2711_thermal.c         |   5 +-
 drivers/thermal/broadcom/sr-thermal.c              |   3 +
 drivers/thermal/imx_sc_thermal.c                   |   6 +-
 drivers/thermal/thermal_core.c                     |  42 ++--
 drivers/tty/serial/pch_uart.c                      |  27 +--
 drivers/tty/tty_buffer.c                           |   3 +-
 drivers/usb/core/hcd.c                             |  29 ++-
 drivers/usb/core/quirks.c                          |   3 +
 drivers/usb/dwc3/gadget.c                          |   6 +-
 drivers/usb/host/xhci-pci.c                        |   2 +
 drivers/usb/serial/option.c                        |   2 +
 drivers/vdpa/vdpa_sim/vdpa_sim.c                   |   5 +-
 drivers/video/console/sticon.c                     |   5 +-
 drivers/video/console/sticore.c                    |  32 ++-
 drivers/video/fbdev/amba-clcd.c                    |   5 +-
 drivers/video/fbdev/core/fbcon.c                   |   5 +-
 drivers/video/fbdev/sticore.h                      |   3 +
 drivers/video/fbdev/stifb.c                        |   4 +-
 fs/afs/rxrpc.c                                     |   8 +-
 fs/binfmt_flat.c                                   |  27 ++-
 fs/btrfs/disk-io.c                                 |   4 +-
 fs/btrfs/volumes.c                                 |   8 +-
 fs/cifs/smb2inode.c                                |   2 -
 fs/cifs/smb2ops.c                                  |   2 +-
 fs/dax.c                                           |   3 +-
 fs/dlm/lock.c                                      |  11 +-
 fs/dlm/plock.c                                     |  12 +-
 fs/ext4/ext4.h                                     |   6 -
 fs/ext4/extents.c                                  |  10 +-
 fs/ext4/inline.c                                   |  12 ++
 fs/ext4/inode.c                                    |   4 +
 fs/ext4/namei.c                                    |  84 ++++++--
 fs/ext4/super.c                                    |  24 ++-
 fs/f2fs/f2fs.h                                     |  19 +-
 fs/f2fs/file.c                                     |  20 +-
 fs/f2fs/inline.c                                   |  29 ++-
 fs/f2fs/inode.c                                    |  19 +-
 fs/f2fs/segment.c                                  |  42 ++--
 fs/f2fs/segment.h                                  |  33 +--
 fs/f2fs/super.c                                    |   6 +-
 fs/fat/fatent.c                                    |   7 +-
 fs/fs-writeback.c                                  |  13 +-
 fs/gfs2/quota.c                                    |  32 +--
 fs/iomap/buffered-io.c                             |   3 +-
 fs/jfs/jfs_dmap.c                                  |   3 +-
 fs/nfs/file.c                                      |  16 +-
 fs/nfs/pnfs.c                                      |   2 +
 fs/nfs/write.c                                     |  11 +-
 fs/notify/fdinfo.c                                 |  11 +-
 fs/notify/inotify/inotify.h                        |  12 ++
 fs/notify/inotify/inotify_user.c                   |   2 +-
 fs/notify/mark.c                                   |   6 +-
 fs/ocfs2/dlmfs/userdlm.c                           |  16 +-
 fs/proc/generic.c                                  |   3 +
 fs/proc/proc_net.c                                 |   3 +
 fs/xfs/libxfs/xfs_btree.c                          |  35 ++--
 fs/xfs/xfs_dquot.c                                 |  39 +++-
 fs/xfs/xfs_iomap.c                                 |   3 +
 fs/xfs/xfs_log.c                                   |  28 ++-
 fs/xfs/xfs_log.h                                   |   1 +
 fs/xfs/xfs_mount.c                                 |  93 +++++----
 fs/xfs/xfs_qm.c                                    |  92 ++++-----
 fs/xfs/xfs_symlink.c                               |   1 +
 include/drm/drm_edid.h                             |   6 +-
 include/linux/bpf.h                                |   2 +
 include/linux/efi.h                                |   2 +
 include/linux/font.h                               |   2 +-
 include/linux/gpio/driver.h                        |  12 ++
 include/linux/kexec.h                              |  46 ++++-
 include/linux/lsm_hook_defs.h                      |   4 +-
 include/linux/lsm_hooks.h                          |   2 +-
 include/linux/mailbox_controller.h                 |   1 +
 include/linux/mtd/cfi.h                            |   1 +
 include/linux/nodemask.h                           |  13 +-
 include/linux/platform_data/cros_ec_proto.h        |   3 +
 include/linux/ptrace.h                             |   7 -
 include/linux/security.h                           |  23 ++-
 include/linux/thermal.h                            |   2 +-
 include/linux/usb/hcd.h                            |   2 +
 include/net/bluetooth/hci.h                        |  16 +-
 include/net/bluetooth/hci_core.h                   |  18 +-
 include/net/flow.h                                 |  10 +
 include/net/if_inet6.h                             |   8 +
 include/net/route.h                                |   6 +-
 include/scsi/libfcoe.h                             |   3 +-
 include/sound/jack.h                               |   1 +
 include/trace/events/rxrpc.h                       |   2 +-
 include/trace/events/vmscan.h                      |   4 +-
 init/Kconfig                                       |   5 +
 ipc/mqueue.c                                       |  14 ++
 kernel/bpf/stackmap.c                              |   1 -
 kernel/dma/debug.c                                 |   2 +-
 kernel/kexec_file.c                                |  34 ----
 kernel/ptrace.c                                    |   5 +-
 kernel/rcu/Kconfig                                 |   1 +
 kernel/rcu/tasks.h                                 |   3 +
 kernel/scftorture.c                                |   5 +-
 kernel/sched/fair.c                                |   8 +-
 kernel/sched/pelt.h                                |   4 +-
 kernel/sched/sched.h                               |   4 +-
 kernel/trace/ftrace.c                              |   5 +-
 kernel/trace/trace_events_hist.c                   |   3 +
 mm/compaction.c                                    |   2 +
 mm/hugetlb.c                                       |   9 +-
 net/bluetooth/hci_conn.c                           |   8 +-
 net/bluetooth/hci_core.c                           |  27 +--
 net/bluetooth/hci_debugfs.c                        |   8 +-
 net/bluetooth/hci_event.c                          |  91 +++++----
 net/bluetooth/hci_request.c                        | 221 ++++++++++++++++-----
 net/bluetooth/hci_sock.c                           |  12 +-
 net/bluetooth/l2cap_core.c                         |  10 +-
 net/bluetooth/mgmt.c                               |  14 +-
 net/bluetooth/mgmt_config.c                        |  10 +
 net/bluetooth/sco.c                                |  21 +-
 net/bluetooth/smp.c                                |   6 +-
 net/core/dev.c                                     |   8 +-
 net/dccp/ipv4.c                                    |   2 +-
 net/dccp/ipv6.c                                    |   6 +-
 net/ipv4/icmp.c                                    |   4 +-
 net/ipv4/inet_connection_sock.c                    |   4 +-
 net/ipv4/ip_output.c                               |   2 +-
 net/ipv4/ping.c                                    |   2 +-
 net/ipv4/raw.c                                     |   2 +-
 net/ipv4/syncookies.c                              |   2 +-
 net/ipv4/udp.c                                     |   2 +-
 net/ipv6/addrconf.c                                |  33 ++-
 net/ipv6/af_inet6.c                                |   2 +-
 net/ipv6/datagram.c                                |   2 +-
 net/ipv6/icmp.c                                    |   6 +-
 net/ipv6/inet6_connection_sock.c                   |   4 +-
 net/ipv6/netfilter/nf_reject_ipv6.c                |   2 +-
 net/ipv6/ping.c                                    |   2 +-
 net/ipv6/raw.c                                     |   2 +-
 net/ipv6/syncookies.c                              |   2 +-
 net/ipv6/tcp_ipv6.c                                |   4 +-
 net/ipv6/udp.c                                     |   2 +-
 net/l2tp/l2tp_ip6.c                                |   2 +-
 net/mac80211/chan.c                                |   7 +-
 net/mac80211/ieee80211_i.h                         |   5 +
 net/mac80211/scan.c                                |  20 ++
 net/netfilter/nf_synproxy_core.c                   |   2 +-
 net/nfc/core.c                                     |   1 +
 net/rxrpc/ar-internal.h                            |  13 +-
 net/rxrpc/call_event.c                             |   7 +-
 net/rxrpc/conn_object.c                            |   2 +-
 net/rxrpc/input.c                                  |  31 ++-
 net/rxrpc/output.c                                 |  20 +-
 net/rxrpc/recvmsg.c                                |   8 +-
 net/rxrpc/sendmsg.c                                |   6 +
 net/rxrpc/sysctl.c                                 |   4 +-
 net/sctp/input.c                                   |   4 +-
 net/smc/af_smc.c                                   |   2 +-
 net/wireless/nl80211.c                             |   1 +
 net/wireless/reg.c                                 |   4 +
 net/xfrm/xfrm_state.c                              |   6 +-
 scripts/faddr2line                                 | 150 +++++++++-----
 security/integrity/ima/Kconfig                     |  14 +-
 .../integrity/platform_certs/keyring_handler.h     |   8 +
 security/integrity/platform_certs/load_uefi.c      |  33 +++
 security/security.c                                |  17 +-
 security/selinux/hooks.c                           |   4 +-
 security/selinux/include/xfrm.h                    |   2 +-
 security/selinux/xfrm.c                            |  13 +-
 sound/core/jack.c                                  |  34 +++-
 sound/core/pcm_memory.c                            |   3 +-
 sound/pci/hda/patch_realtek.c                      |  11 +
 sound/soc/atmel/atmel-classd.c                     |   1 -
 sound/soc/atmel/atmel-pdmic.c                      |   1 -
 sound/soc/codecs/Kconfig                           |   2 -
 sound/soc/codecs/max98090.c                        |   6 +-
 sound/soc/codecs/rk3328_codec.c                    |   2 +-
 sound/soc/codecs/rt5514.c                          |   2 +-
 sound/soc/codecs/rt5645.c                          |   7 +-
 sound/soc/codecs/tscs454.c                         |  12 +-
 sound/soc/codecs/wm2000.c                          |   6 +-
 sound/soc/fsl/imx-sgtl5000.c                       |  14 +-
 sound/soc/intel/boards/bytcr_rt5640.c              |  12 ++
 sound/soc/mediatek/mt2701/mt2701-wm8960.c          |   9 +-
 sound/soc/mediatek/mt8173/mt8173-max98090.c        |   5 +-
 sound/soc/mxs/mxs-saif.c                           |   1 +
 sound/soc/samsung/aries_wm8994.c                   |  17 +-
 sound/soc/samsung/arndale.c                        |   5 +-
 sound/soc/samsung/littlemill.c                     |   5 +-
 sound/soc/samsung/lowland.c                        |   5 +-
 sound/soc/samsung/odroid.c                         |   4 +-
 sound/soc/samsung/smdk_wm8994.c                    |   4 +-
 sound/soc/samsung/smdk_wm8994pcm.c                 |   4 +-
 sound/soc/samsung/snow.c                           |   9 +-
 sound/soc/samsung/speyside.c                       |   5 +-
 sound/soc/samsung/tm2_wm5110.c                     |   3 +-
 sound/soc/samsung/tobermory.c                      |   5 +-
 sound/soc/soc-dapm.c                               |   2 -
 sound/soc/ti/j721e-evm.c                           |  44 +++-
 sound/usb/midi.c                                   |   3 +
 tools/lib/bpf/libbpf.c                             |  20 +-
 tools/perf/Makefile.config                         |  39 ++--
 tools/perf/builtin-c2c.c                           |   6 +-
 tools/perf/pmu-events/jevents.c                    |   2 +-
 tools/perf/util/data.h                             |   1 +
 tools/power/x86/turbostat/turbostat.c              |   1 +
 .../bpf/progs/btf_dump_test_case_syntax.c          |   2 +-
 tools/testing/selftests/bpf/progs/profiler.inc.h   |   5 +-
 tools/testing/selftests/cgroup/test_stress.sh      |   2 +-
 tools/testing/selftests/resctrl/fill_buf.c         |   4 +-
 512 files changed, 3868 insertions(+), 2289 deletions(-)


