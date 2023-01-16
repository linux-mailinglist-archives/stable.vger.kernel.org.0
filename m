Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6ED5166C460
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 16:54:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230293AbjAPPyR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 10:54:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230357AbjAPPyQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 10:54:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 369DC1D905;
        Mon, 16 Jan 2023 07:54:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ABDA66103F;
        Mon, 16 Jan 2023 15:54:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68A31C433D2;
        Mon, 16 Jan 2023 15:54:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673884453;
        bh=fPXjgwMK638vGHGtVXeFZrbKg7J4FwyLHCCWLHriTv0=;
        h=From:To:Cc:Subject:Date:From;
        b=tgcNH+gfvm0lCywJ1Jgq4onbbRbpn59NjtczRvFrWkH0kai0NJRU/HDFr27EzzOPp
         tM9IqlfsiteUiwOxdoQGKDdMZKmY8aJ6BjnbJEms+KHdegA1YCKjfLnP+PKosFosCB
         uivorwDveGm+UH/S5OvAL2eOPiomSxAAGNXqKZ44=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: [PATCH 6.1 000/183] 6.1.7-rc1 review
Date:   Mon, 16 Jan 2023 16:48:43 +0100
Message-Id: <20230116154803.321528435@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.7-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.1.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.1.7-rc1
X-KernelTest-Deadline: 2023-01-18T15:48+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 6.1.7 release.
There are 183 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 18 Jan 2023 15:47:28 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.7-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.1.7-rc1

Mario Limonciello <mario.limonciello@amd.com>
    pinctrl: amd: Add dynamic debugging for active GPIOs

Ferry Toth <ftoth@exalondelft.nl>
    Revert "usb: ulpi: defer ulpi_register on ulpi_read_id timeout"

Jens Axboe <axboe@kernel.dk>
    block: handle bio_split_to_limits() NULL return

Jens Axboe <axboe@kernel.dk>
    io_uring/io-wq: only free worker if it was allocated for creation

Jens Axboe <axboe@kernel.dk>
    io_uring/io-wq: free worker if task_work creation is canceled

Nathan Chancellor <nathan@kernel.org>
    drm/i915: Fix CFI violations in gt_sysfs

Jens Axboe <axboe@kernel.dk>
    io_uring/poll: attempt request issue after racy poll wakeup

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: lock overflowing for IOPOLL

Johan Hovold <johan+linaro@kernel.org>
    efi: fix NULL-deref in init error path

Jaroslav Kysela <perex@perex.cz>
    ALSA: usb-audio: Fix possible NULL pointer dereference in snd_usb_pcm_has_fixed_rate()

Miaoqian Lin <linmq006@gmail.com>
    platform/x86/amd: Fix refcount leak in amd_pmc_probe

Maximilian Luz <luzmaximilian@gmail.com>
    platform/surface: aggregator: Add missing call to ssam_request_sync_free()

Jakub Kicinski <kuba@kernel.org>
    bnxt: make sure we return pages to the pool

Jie Wang <wangjie125@huawei.com>
    net: hns3: fix wrong use of rss size during VF rss config

Clément Léger <clement.leger@bootlin.com>
    net: lan966x: check for ptp to be enabled in lan966x_ptp_deinit()

Christopher S Hall <christopher.s.hall@intel.com>
    igc: Fix PPS delta between two synchronized end-points

Leo Yan <leo.yan@linaro.org>
    perf kmem: Support field "node" in evsel__process_alloc_event() coping with recent tracepoint restructuring

Leo Yan <leo.yan@linaro.org>
    perf kmem: Support legacy tracepoints

Ian Rogers <irogers@google.com>
    perf build: Properly guard libbpf includes

Hariprasad Kelam <hkelam@marvell.com>
    octeontx2-pf: Fix resource leakage in VF driver unbind

Guillaume Nault <gnault@redhat.com>
    selftests/net: l2_tos_ttl_inherit.sh: Ensure environment cleanup on failure.

Guillaume Nault <gnault@redhat.com>
    selftests/net: l2_tos_ttl_inherit.sh: Run tests in their own netns.

Guillaume Nault <gnault@redhat.com>
    selftests/net: l2_tos_ttl_inherit.sh: Set IPv6 addresses with "nodad".

Emeel Hakim <ehakim@nvidia.com>
    net/mlx5e: Fix macsec possible null dereference when updating MAC security entity (SecY)

Emeel Hakim <ehakim@nvidia.com>
    net/mlx5e: Fix macsec ssci attribute handling in offload path

Gavin Li <gavinl@nvidia.com>
    net/mlx5e: Don't support encap rules with gbp option

Rahul Rameshbabu <rrameshbabu@nvidia.com>
    net/mlx5: Fix ptp max frequency adjustment range

Dragos Tatulea <dtatulea@nvidia.com>
    net/mlx5e: IPoIB, Fix child PKEY interface stats on rx path

Dragos Tatulea <dtatulea@nvidia.com>
    net/mlx5e: IPoIB, Block PKEY interfaces with less rx queues than parent

Dragos Tatulea <dtatulea@nvidia.com>
    net/mlx5e: IPoIB, Block queue count configuration when sub interfaces are present

Roy Novich <royno@nvidia.com>
    net/mlx5e: Verify dev is present for fix features ndo

Moshe Shemesh <moshe@nvidia.com>
    net/mlx5: Fix command stats access after free

Ariel Levkovich <lariel@nvidia.com>
    net/mlx5e: TC, Keep mod hdr actions after mod hdr alloc

Ariel Levkovich <lariel@nvidia.com>
    net/mlx5: check attr pointer validity before dereferencing it

Heiner Kallweit <hkallweit1@gmail.com>
    Revert "r8169: disable detection of chip version 36"

Ido Schimmel <idosch@nvidia.com>
    net/sched: act_mpls: Fix warning during failed attribute validation

Zack Rusin <zackr@vmware.com>
    drm/vmwgfx: Remove rcu locks from user resources

Maaz Mombasawala <mombasawalam@vmware.com>
    drm/vmwgfx: Remove vmwgfx_hashtab

Maaz Mombasawala <mombasawalam@vmware.com>
    drm/vmwgfx: Refactor ttm reference object hashtable to use linux/hashtable.

Maaz Mombasawala <mombasawalam@vmware.com>
    drm/vmwgfx: Refactor resource validation hashtable to use linux/hashtable implementation.

Maaz Mombasawala <mombasawalam@vmware.com>
    drm/vmwgfx: Remove ttm object hashtable

Maaz Mombasawala <mombasawalam@vmware.com>
    drm/vmwgfx: Refactor resource manager's hashtable to use linux/hashtable implementation.

Zack Rusin <zackr@vmware.com>
    drm/vmwgfx: Write the driver id registers

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    ice: Add check for kzalloc

Yuan Can <yuancan@huawei.com>
    ice: Fix potential memory leak in ice_gnss_tty_write()

Luben Tuikov <luben.tuikov@amd.com>
    drm/amdgpu: Fix potential NULL dereference

Willy Tarreau <w@1wt.eu>
    tools/nolibc: fix the O_* fcntl/open macro definitions for riscv

Willy Tarreau <w@1wt.eu>
    tools/nolibc: restore mips branch ordering in the _start block

Stephan Gerhold <stephan@gerhold.net>
    ASoC: qcom: Fix building APQ8016 machine driver without SOUNDWIRE

Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>
    af_unix: selftest: Fix the size of the parameter to connect()

Eric Dumazet <edumazet@google.com>
    gro: take care of DODGY packets

Richard Gobert <richardbgobert@gmail.com>
    gro: avoid checking for a failed search

Minsuk Kang <linuxlovemin@yonsei.ac.kr>
    nfc: pn533: Wait for out_urb's completion in pn533_usb_send_frame()

Roger Pau Monne <roger.pau@citrix.com>
    hvc/xen: lock console list traversal

Tejun Heo <tj@kernel.org>
    block: Drop spurious might_sleep() from blk_put_queue()

Christoph Hellwig <hch@lst.de>
    block: mark blk_put_queue as potentially blocking

Christoph Hellwig <hch@lst.de>
    block: untangle request_queue refcounting from sysfs

Christoph Hellwig <hch@lst.de>
    block: fix error unwinding in blk_register_queue

Christoph Hellwig <hch@lst.de>
    block: factor out a blk_debugfs_remove helper

Christoph Hellwig <hch@lst.de>
    blk-crypto: pass a gendisk to blk_crypto_sysfs_{,un}register

Christoph Hellwig <hch@lst.de>
    blk-mq: move the srcu_struct used for quiescing to the tagset

Yair Podemsky <ypodemsk@redhat.com>
    sched/core: Fix arch_scale_freq_tick() on tickless systems

Angela Czubak <aczubak@marvell.com>
    octeontx2-af: Fix LMAC config in cgx_lmac_rx_tx_enable

Jeff Layton <jlayton@kernel.org>
    nfsd: fix handling of cached open files in nfsd4_open codepath

Jeff Layton <jlayton@kernel.org>
    nfsd: rework refcounting in filecache

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Add an nfsd_file_fsync tracepoint

Jeff Layton <jlayton@kernel.org>
    nfsd: reorganize filecache.c

Jeff Layton <jlayton@kernel.org>
    nfsd: remove the pages_flushed statistic from filecache

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Add an NFSD_FILE_GC flag to enable nfsd_file garbage collection

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Revert "NFSD: NFSv4 CLOSE should release an nfsd_file immediately"

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Pass the target nfsd_file to nfsd_commit()

Tung Nguyen <tung.q.nguyen@dektech.com.au>
    tipc: fix unexpected link reset due to discovery messages

Biao Huang <biao.huang@mediatek.com>
    stmmac: dwmac-mediatek: remove the dwmac_fix_mac_speed

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Relax hw constraints for implicit fb sync

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Make sure to stop endpoints before closing EPs

Arnd Bergmann <arnd@arndb.de>
    mtd: cfi: allow building spi-intel standalone

Mikhail Zhilkin <csharper2005@gmail.com>
    mtd: parsers: scpart: fix __udivdi3 undefined on mips

Emanuele Ghidoli <emanuele.ghidoli@toradex.com>
    ASoC: wm8904: fix wrong outputs volume after power reactivation

Miaoqian Lin <linmq006@gmail.com>
    drm/msm/dpu: Fix memory leak in msm_mdss_parse_data_bus_icc_path

Yang Li <yang.lee@linux.alibaba.com>
    drm/msm/dpu: Fix some kernel-doc comments

Arnd Bergmann <arnd@arndb.de>
    ASoC: Intel: sof-nau8825: fix module alias overflow

Brent Lu <brent.lu@intel.com>
    ASoC: Intel: sof_nau8825: support rt1015p speaker amplifier

Arnd Bergmann <arnd@arndb.de>
    ASoC: Intel: fix sof-nau8825 link failure

Peter Wang <peter.wang@mediatek.com>
    scsi: ufs: core: WLUN suspend SSU/enter hibern8 fail recovery

Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
    scsi: mpi3mr: Refer CONFIG_SCSI_MPI3MR in Makefile

Michael Kelley <mikelley@microsoft.com>
    scsi: storvsc: Fix swiotlb bounce buffer leak in confidential VM

Ricardo Ribalda <ribalda@chromium.org>
    regulator: da9211: Use irq handler when ready

Peter Newman <peternewman@google.com>
    x86/resctrl: Fix event counts regression in reused RMIDs

Peter Newman <peternewman@google.com>
    x86/resctrl: Fix task CLOSID/RMID update race

Juergen Gross <jgross@suse.com>
    x86/pat: Fix pat_x_mtrr_type() for MTRR disabled case

Eliav Farber <farbere@amazon.com>
    EDAC/device: Fix period calculation in edac_device_reset_delay_period()

Peter Zijlstra <peterz@infradead.org>
    x86/boot: Avoid using Intel mnemonics in AT&T syntax asm

Kajol Jain <kjain@linux.ibm.com>
    powerpc/imc-pmu: Fix use of mutex in IRQs disabled section

Florian Westphal <fw@strlen.de>
    selftests: netfilter: fix transaction test script timeout handling

Gavrilov Ilia <Ilia.Gavrilov@infotecs.ru>
    netfilter: ipset: Fix overflow before widen in the bitmap_ip_create() function.

Waiman Long <longman@redhat.com>
    sched/core: Fix use-after-free bug in dup_user_cpus_ptr()

Robin Murphy <robin.murphy@arm.com>
    iommu/arm-smmu: Report IOMMU_CAP_CACHE_COHERENCY even betterer

Vladimir Oltean <vladimir.oltean@nxp.com>
    iommu/arm-smmu: Don't unregister on shutdown

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    iommu/mediatek-v1: Fix an error handling path in mtk_iommu_v1_probe()

Vladimir Oltean <vladimir.oltean@nxp.com>
    iommu/arm-smmu-v3: Don't unregister on shutdown

Yunfei Wang <yf.wang@mediatek.com>
    iommu/iova: Fix alloc iova overflows issue

Aaron Thompson <dev@aaront.org>
    mm: Always release pages to the buddy allocator in memblock_free_late().

Saleemkhan Jamadar <saleemkhan.jamadar@amd.com>
    drm/amdgpu: enable VCN DPG for GC IP v11.0.4

Saleemkhan Jamadar <saleemkhan.jamadar@amd.com>
    drm/amdgpu: Enable pg/cg flags on GC11_0_4 for VCN

Yifan Zhang <yifan1.zhang@amd.com>
    drm/amdgpu: add soc21 common ip block support for GC 11.0.4

Evan Quan <evan.quan@amd.com>
    drm/amd/pm: enable GPO dynamic control support for SMU13.0.7

Evan Quan <evan.quan@amd.com>
    drm/amd/pm: enable GPO dynamic control support for SMU13.0.0

Candice Li <candice.li@amd.com>
    drm/amd/pm: Enable bad memory page/channel recording support for smu v13_0_0

Kenneth Feng <kenneth.feng@amd.com>
    drm/amd/pm: enable mode1 reset on smu_v13_0_10

Ferry Toth <ftoth@exalondelft.nl>
    usb: ulpi: defer ulpi_register on ulpi_read_id timeout

Chris Wilson <chris.p.wilson@intel.com>
    drm/i915/gt: Cleanup partial engine discovery failures

Daniil Tatianin <d-tatianin@yandex-team.ru>
    iavf/iavf_main: actually log ->src mask when talking about it

Herbert Xu <herbert@gondor.apana.org.au>
    ipv6: raw: Deduct extension header length in rawv6_push_pending_frames

Yang Yingliang <yangyingliang@huawei.com>
    ixgbe: fix pci device refcount leak

Hans de Goede <hdegoede@redhat.com>
    platform/x86: sony-laptop: Don't turn off 0x153 keyboard backlight during probe

Konrad Dybcio <konrad.dybcio@linaro.org>
    dt-bindings: msm/dsi: Don't require vcca-supply on 14nm PHY

Konrad Dybcio <konrad.dybcio@linaro.org>
    dt-bindings: msm/dsi: Don't require vdds-supply on 10nm PHY

Kuogee Hsieh <quic_khsieh@quicinc.com>
    drm/msm/dp: do not complete dp_aux_cmd_fifo_tx() if irq is not for aux transfer

Hans de Goede <hdegoede@redhat.com>
    platform/x86: ideapad-laptop: Add Legion 5 15ARH05 DMI id to set_fn_lock_led_list[]

Liu Shixin <liushixin2@huawei.com>
    arm64/mm: fix incorrect file_map_count for invalid pmd

Zenghui Yu <yuzenghui@huawei.com>
    arm64: ptrace: Use ARM64_SME to guard the SME register enumerations

Bryan O'Donoghue <bryan.odonoghue@linaro.org>
    dt-bindings: msm: dsi-phy-28nm: Add missing qcom, dsi-phy-regulator-ldo-mode

Liu Shixin <liushixin2@huawei.com>
    arm64/mm: add pud_user_exec() check in pud_user_accessible_page()

Mark Brown <broonie@kernel.org>
    arm64/signal: Always accept SVE signal frames on SME only systems

Bryan O'Donoghue <bryan.odonoghue@linaro.org>
    dt-bindings: msm: dsi-controller-main: Fix description of core clock

Bryan O'Donoghue <bryan.odonoghue@linaro.org>
    dt-bindings: msm: dsi-controller-main: Fix power-domain constraint

Mark Brown <broonie@kernel.org>
    arm64/signal: Always allocate SVE signal frames on SME only systems

Konrad Dybcio <konrad.dybcio@linaro.org>
    drm/msm/adreno: Make adreno quirks not overwrite each other

Marc Zyngier <maz@kernel.org>
    firmware/psci: Don't register with debugfs if PSCI isn't available

Will Deacon <will@kernel.org>
    firmware/psci: Fix MEM_PROTECT_RANGE function numbers

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    drm/msm: another fix for the headless Adreno GPU

Bryan O'Donoghue <bryan.odonoghue@linaro.org>
    dt-bindings: msm: dsi-controller-main: Fix operating-points-v2 constraint

Hans de Goede <hdegoede@redhat.com>
    platform/x86: dell-privacy: Fix SW_CAMERA_LENS_COVER reporting

Thomas Weißschuh <linux@weissschuh.net>
    platform/x86: asus-wmi: Don't load fan curves without fan

Mark Pearson <mpearson-lenovo@squebb.ca>
    platform/x86: thinkpad_acpi: Fix profile mode display in AMT mode

Hans de Goede <hdegoede@redhat.com>
    platform/x86: int3472/discrete: Ensure the clk/power enable pins are in output mode

Maximilian Luz <luzmaximilian@gmail.com>
    platform/surface: aggregator: Ignore command messages not intended for us

Hans de Goede <hdegoede@redhat.com>
    platform/x86: dell-privacy: Only register SW_CAMERA_LENS_COVER if present

Hans de Goede <hdegoede@redhat.com>
    ACPI: video: Allow selecting NVidia-WMI-EC or Apple GMUX backlight from the cmdline

ChiYuan Huang <cy_huang@richtek.com>
    ASoC: rt9120: Make dev PM runtime bind AsoC component PM

Jens Axboe <axboe@kernel.dk>
    io_uring/fdinfo: include locked hash table in fdinfo output

Paulo Alcantara <pc@cjr.nz>
    cifs: fix double free on failed kerberos auth

Paulo Alcantara <pc@cjr.nz>
    cifs: do not query ifaces on smb1 mounts

Paulo Alcantara <pc@cjr.nz>
    cifs: fix file info setting in cifs_open_file()

Paulo Alcantara <pc@cjr.nz>
    cifs: fix file info setting in cifs_query_path_info()

Volker Lendecke <vl@samba.org>
    cifs: Fix uninitialized memory read for smb311 posix symlink create

Alex Deucher <alexander.deucher@amd.com>
    Revert "drm/amdgpu: Revert "drm/amdgpu: getting fan speed pwm for vega10 properly""

Ao Zhong <hacc1225@gmail.com>
    drm/amd/display: move remaining FPU code to dml folder

Evan Quan <evan.quan@amd.com>
    drm/amd/pm: add the missing mapping for PPT feature on SMU13.0.0 and 13.0.7

Evan Quan <evan.quan@amd.com>
    drm/amd/pm: correct the reference clock for fan speed(rpm) calculation

YiPeng Chai <YiPeng.Chai@amd.com>
    drm/amdgpu: Fixed bug on error when unloading amdgpu

Mario Limonciello <mario.limonciello@amd.com>
    drm/amd: Delay removal of the firmware framebuffer

Rob Clark <robdclark@chromium.org>
    drm/i915: Fix potential context UAFs

Nirmoy Das <nirmoy.das@intel.com>
    drm/i915: Reserve enough fence slot for i915_vma_unbind_async

Chris Wilson <chris@chris-wilson.co.uk>
    drm/i915/gt: Reset twice

Arunpravin Paneer Selvam <Arunpravin.PaneerSelvam@amd.com>
    drm: Optimize drm buddy top-down allocation method

Guchun Chen <guchun.chen@amd.com>
    drm/amd/pm/smu13: BACO is supported when it's in BACO state

Rob Clark <robdclark@chromium.org>
    drm/virtio: Fix GEM handle creation UAF

Heiko Carstens <hca@linux.ibm.com>
    s390/percpu: add READ_ONCE() to arch_this_cpu_to_op_simple()

Heiko Carstens <hca@linux.ibm.com>
    s390/cpum_sf: add READ_ONCE() semantics to compare and swap loops

Perry Yuan <perry.yuan@amd.com>
    cpufreq: amd-pstate: fix kernel hang issue while amd-pstate unregistering

Catalin Marinas <catalin.marinas@arm.com>
    elfcore: Add a cprm parameter to elf_core_extra_{phdrs,data_size}

Brian Norris <computersforpeace@gmail.com>
    ASoC: qcom: lpass-cpu: Fix fallback SD line index handling

Ivan T. Ivanov <iivanov@suse.de>
    brcmfmac: Prefer DT board type over DMI board type

Alexander Egorenkov <egorenar@linux.ibm.com>
    s390/kexec: fix ipl report address for kdump

Adrian Hunter <adrian.hunter@intel.com>
    perf auxtrace: Fix address filter duplicate symbol selection

Noor Azura Ahmad Tarmizi <noor.azura.ahmad.tarmizi@intel.com>
    net: stmmac: add aux timestamps fifo clearance wait

Hans de Goede <hdegoede@redhat.com>
    ACPI: Fix selecting wrong ACPI fwnode for the iGPU on some Dell laptops

Mark Rutland <mark.rutland@arm.com>
    arm64: cmpxchg_double*: hazard against entire exchange variable

Catalin Marinas <catalin.marinas@arm.com>
    arm64: mte: Avoid the racy walk of the vma list during core dump

Catalin Marinas <catalin.marinas@arm.com>
    arm64: mte: Fix double-freeing of the temporary tag storage during coredump

Jens Axboe <axboe@kernel.dk>
    io_uring/poll: add hash if ready poll request can't complete inline

Jonathan Corbet <corbet@lwn.net>
    docs: Fix the docs build with Sphinx 6.0

Ard Biesheuvel <ardb@kernel.org>
    efi: tpm: Avoid READ_ONCE() for accessing the event log

Ding Hui <dinghui@sangfor.com.cn>
    efi: fix userspace infinite retry read efivars after EFI runtime services page fault

Marc Zyngier <maz@kernel.org>
    KVM: arm64: Fix S1PTW handling on RO memslots

Paolo Bonzini <pbonzini@redhat.com>
    KVM: x86: Do not return host topology information from KVM_GET_SUPPORTED_CPUID

Luka Guzenko <l.guzenko@web.de>
    ALSA: hda/realtek: Enable mute/micmute LEDs on HP Spectre x360 13-aw0xxx

Yuchi Yang <yangyuchi66@gmail.com>
    ALSA: hda/realtek - Turn on power early

Jaroslav Kysela <perex@perex.cz>
    ALSA: usb-audio: Always initialize fixed_rate in snd_usb_find_implicit_fb_sync_format()

Jaroslav Kysela <perex@perex.cz>
    ALSA: control-led: use strscpy in set_led_id()

Takashi Iwai <tiwai@suse.de>
    Revert "ALSA: usb-audio: Drop superfluous interface setup at parsing"

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nft_payload: incorrect arithmetics when fetching VLAN header bits


-------------

Diffstat:

 .../bindings/display/msm/dsi-controller-main.yaml  |   4 +-
 .../bindings/display/msm/dsi-phy-10nm.yaml         |   1 -
 .../bindings/display/msm/dsi-phy-14nm.yaml         |   1 -
 .../bindings/display/msm/dsi-phy-28nm.yaml         |   4 +
 Documentation/gpu/todo.rst                         |  11 -
 Documentation/sphinx/load_config.py                |   6 +-
 Documentation/virt/kvm/api.rst                     |  14 +
 Makefile                                           |   4 +-
 arch/arm64/include/asm/atomic_ll_sc.h              |   2 +-
 arch/arm64/include/asm/atomic_lse.h                |   2 +-
 arch/arm64/include/asm/kvm_emulate.h               |  22 +-
 arch/arm64/include/asm/pgtable.h                   |   6 +-
 arch/arm64/kernel/elfcore.c                        |  61 ++-
 arch/arm64/kernel/ptrace.c                         |   2 +-
 arch/arm64/kernel/signal.c                         |   9 +-
 arch/ia64/kernel/elfcore.c                         |   4 +-
 arch/powerpc/include/asm/imc-pmu.h                 |   2 +-
 arch/powerpc/perf/imc-pmu.c                        | 136 +++---
 arch/s390/include/asm/cpu_mf.h                     |  31 +-
 arch/s390/include/asm/percpu.h                     |   2 +-
 arch/s390/kernel/machine_kexec_file.c              |   5 +-
 arch/s390/kernel/perf_cpum_sf.c                    | 101 +++--
 arch/x86/boot/bioscall.S                           |   4 +-
 arch/x86/kernel/cpu/resctrl/monitor.c              |  49 ++-
 arch/x86/kernel/cpu/resctrl/rdtgroup.c             |  12 +-
 arch/x86/kvm/cpuid.c                               |  32 +-
 arch/x86/mm/pat/memtype.c                          |   3 +-
 arch/x86/um/elfcore.c                              |   4 +-
 block/blk-core.c                                   |  70 +--
 block/blk-crypto-internal.h                        |  10 +-
 block/blk-crypto-sysfs.c                           |  11 +-
 block/blk-ia-ranges.c                              |   3 +-
 block/blk-merge.c                                  |   4 +-
 block/blk-mq.c                                     |  38 +-
 block/blk-mq.h                                     |  14 +-
 block/blk-sysfs.c                                  | 134 +++---
 block/blk.h                                        |  13 +-
 block/bsg.c                                        |  11 +-
 block/elevator.c                                   |   2 +-
 block/genhd.c                                      |   2 +-
 drivers/acpi/glue.c                                |  14 +-
 drivers/acpi/scan.c                                |   7 +-
 drivers/acpi/video_detect.c                        |   4 +
 drivers/block/drbd/drbd_req.c                      |   2 +
 drivers/block/ps3vram.c                            |   2 +
 drivers/cpufreq/amd-pstate.c                       |   1 +
 drivers/edac/edac_device.c                         |  17 +-
 drivers/edac/edac_module.h                         |   2 +-
 drivers/firmware/efi/efi.c                         |   9 +-
 drivers/firmware/efi/runtime-wrappers.c            |   1 +
 drivers/firmware/psci/psci.c                       |   3 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c         |   8 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c            |   6 -
 drivers/gpu/drm/amd/amdgpu/amdgpu_object.c         |   5 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_vram_mgr.c       |   2 +-
 drivers/gpu/drm/amd/amdgpu/soc21.c                 |  11 +
 .../gpu/drm/amd/display/dc/dcn32/dcn32_resource.c  |   5 +-
 .../gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.c   |   8 +
 .../gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.h   |   3 +
 .../drm/amd/pm/powerplay/hwmgr/vega10_thermal.c    |  25 +-
 drivers/gpu/drm/amd/pm/swsmu/inc/amdgpu_smu.h      |   4 +
 .../amd/pm/swsmu/inc/pmfw_if/smu_v13_0_0_ppsmc.h   |   8 +-
 drivers/gpu/drm/amd/pm/swsmu/inc/smu_types.h       |   5 +-
 drivers/gpu/drm/amd/pm/swsmu/inc/smu_v13_0.h       |   3 +
 drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0.c     |  23 +-
 .../gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c   |  95 +++-
 .../gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c   |   3 +
 drivers/gpu/drm/amd/pm/swsmu/smu_cmn.c             |  18 +
 drivers/gpu/drm/amd/pm/swsmu/smu_cmn.h             |   3 +
 drivers/gpu/drm/drm_buddy.c                        |  81 ++--
 drivers/gpu/drm/i915/gem/i915_gem_context.c        |  24 +-
 drivers/gpu/drm/i915/gt/intel_engine_cs.c          |   7 +-
 drivers/gpu/drm/i915/gt/intel_gt_sysfs.c           |  15 +-
 drivers/gpu/drm/i915/gt/intel_gt_sysfs.h           |   2 +-
 drivers/gpu/drm/i915/gt/intel_gt_sysfs_pm.c        | 461 +++++++++-----------
 drivers/gpu/drm/i915/gt/intel_reset.c              |  34 +-
 drivers/gpu/drm/i915/i915_vma.c                    |   2 +-
 drivers/gpu/drm/msm/adreno/adreno_gpu.h            |  10 +-
 .../gpu/drm/msm/disp/dpu1/dpu_encoder_phys_wb.c    |   3 +-
 drivers/gpu/drm/msm/dp/dp_aux.c                    |   4 +
 drivers/gpu/drm/msm/msm_drv.c                      |   2 +-
 drivers/gpu/drm/msm/msm_mdss.c                     |   6 +-
 drivers/gpu/drm/virtio/virtgpu_ioctl.c             |  19 +-
 drivers/gpu/drm/vmwgfx/Makefile                    |   2 +-
 drivers/gpu/drm/vmwgfx/ttm_object.c                | 156 +++----
 drivers/gpu/drm/vmwgfx/ttm_object.h                |  32 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_bo.c                 |  38 --
 drivers/gpu/drm/vmwgfx/vmwgfx_cmdbuf_res.c         |  62 ++-
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.c                |  71 ++-
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.h                |  29 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c            | 190 ++++----
 drivers/gpu/drm/vmwgfx/vmwgfx_hashtab.c            | 199 ---------
 drivers/gpu/drm/vmwgfx/vmwgfx_hashtab.h            |  83 ----
 drivers/gpu/drm/vmwgfx/vmwgfx_resource.c           |  33 --
 drivers/gpu/drm/vmwgfx/vmwgfx_validation.c         |  55 ++-
 drivers/gpu/drm/vmwgfx/vmwgfx_validation.h         |  26 +-
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c        |   4 +-
 drivers/iommu/arm/arm-smmu/arm-smmu.c              |  32 +-
 drivers/iommu/iova.c                               |   4 +-
 drivers/iommu/mtk_iommu_v1.c                       |   4 +-
 drivers/md/dm.c                                    |   2 +
 drivers/md/md.c                                    |   2 +
 drivers/mtd/parsers/scpart.c                       |   2 +-
 drivers/mtd/spi-nor/core.c                         |   1 +
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |   4 +-
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  |   2 +-
 drivers/net/ethernet/intel/iavf/iavf_main.c        |   2 +-
 drivers/net/ethernet/intel/ice/ice_gnss.c          |  24 +-
 drivers/net/ethernet/intel/igc/igc_defines.h       |   2 +
 drivers/net/ethernet/intel/igc/igc_ptp.c           |  10 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_phy.c       |  14 +-
 drivers/net/ethernet/marvell/octeontx2/af/cgx.c    |   4 +-
 drivers/net/ethernet/marvell/octeontx2/af/cgx.h    |   1 -
 .../net/ethernet/marvell/octeontx2/nic/otx2_vf.c   |   2 +
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c      |  13 +-
 .../ethernet/mellanox/mlx5/core/en/tc_tun_vxlan.c  |   2 +
 .../ethernet/mellanox/mlx5/core/en_accel/macsec.c  |  19 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |   3 +
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c    |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    |   5 +-
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c |   2 +-
 .../ethernet/mellanox/mlx5/core/ipoib/ethtool.c    |  16 +-
 .../net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c  |  38 ++
 .../net/ethernet/mellanox/mlx5/core/ipoib/ipoib.h  |   6 +
 .../ethernet/mellanox/mlx5/core/ipoib/ipoib_vlan.c |  18 +-
 .../net/ethernet/mellanox/mlx5/core/lib/clock.c    |   2 +-
 .../net/ethernet/microchip/lan966x/lan966x_ptp.c   |   3 +
 drivers/net/ethernet/realtek/r8169_main.c          |   5 +-
 .../net/ethernet/stmicro/stmmac/dwmac-mediatek.c   |  26 --
 drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c   |   5 +-
 .../net/wireless/broadcom/brcm80211/brcmfmac/of.c  |   5 +-
 drivers/nfc/pn533/usb.c                            |  44 +-
 drivers/nvme/host/multipath.c                      |   2 +
 drivers/pinctrl/pinctrl-amd.c                      |  10 +-
 drivers/platform/surface/aggregator/controller.c   |   4 +-
 .../surface/aggregator/ssh_request_layer.c         |  14 +
 drivers/platform/x86/amd/pmc.c                     |   2 +-
 drivers/platform/x86/asus-wmi.c                    |   3 +
 drivers/platform/x86/dell/dell-wmi-privacy.c       |  41 +-
 drivers/platform/x86/ideapad-laptop.c              |   6 +
 .../platform/x86/intel/int3472/clk_and_regulator.c |   3 +
 drivers/platform/x86/intel/int3472/discrete.c      |   4 +
 drivers/platform/x86/sony-laptop.c                 |  21 +-
 drivers/platform/x86/thinkpad_acpi.c               |  23 +-
 drivers/regulator/da9211-regulator.c               |  11 +-
 drivers/s390/block/dcssblk.c                       |   2 +
 drivers/scsi/mpi3mr/Makefile                       |   2 +-
 drivers/scsi/storvsc_drv.c                         |   3 +
 drivers/tty/hvc/hvc_xen.c                          |  46 +-
 drivers/ufs/core/ufshcd.c                          |  26 ++
 fs/binfmt_elf.c                                    |   4 +-
 fs/binfmt_elf_fdpic.c                              |   4 +-
 fs/cifs/connect.c                                  |   9 +-
 fs/cifs/link.c                                     |   1 +
 fs/cifs/smb1ops.c                                  |  63 +--
 fs/cifs/smb2pdu.c                                  |   5 +-
 fs/nfsd/filecache.c                                | 484 ++++++++++++---------
 fs/nfsd/filecache.h                                |   9 +-
 fs/nfsd/nfs3proc.c                                 |  10 +-
 fs/nfsd/nfs4proc.c                                 |  11 +-
 fs/nfsd/nfs4state.c                                |  20 +-
 fs/nfsd/trace.h                                    | 129 +++---
 fs/nfsd/vfs.c                                      |  19 +-
 fs/nfsd/vfs.h                                      |   3 +-
 include/acpi/acpi_bus.h                            |   3 +-
 include/linux/blk-mq.h                             |   4 +
 include/linux/blkdev.h                             |  15 +-
 include/linux/elfcore.h                            |   8 +-
 include/linux/mlx5/driver.h                        |   2 +-
 include/linux/mtd/spi-nor.h                        |   1 -
 include/linux/tpm_eventlog.h                       |   4 +-
 include/uapi/linux/psci.h                          |   4 +-
 io_uring/fdinfo.c                                  |  12 +-
 io_uring/io-wq.c                                   |   6 +
 io_uring/poll.c                                    |  50 ++-
 io_uring/rw.c                                      |   6 +-
 kernel/sched/core.c                                |  41 +-
 mm/memblock.c                                      |   8 +-
 net/core/gro.c                                     |  71 +--
 net/ipv6/raw.c                                     |   4 +
 net/netfilter/ipset/ip_set_bitmap_ip.c             |   4 +-
 net/netfilter/nft_payload.c                        |   2 +-
 net/sched/act_mpls.c                               |   8 +-
 net/tipc/node.c                                    |  12 +-
 sound/core/control_led.c                           |   5 +-
 sound/pci/hda/patch_realtek.c                      |  53 ++-
 sound/soc/codecs/rt9120.c                          |  12 +
 sound/soc/codecs/wm8904.c                          |   7 +
 sound/soc/intel/boards/Kconfig                     |   1 +
 sound/soc/intel/boards/sof_nau8825.c               |  22 +-
 sound/soc/intel/common/soc-acpi-intel-adl-match.c  |  18 +-
 sound/soc/qcom/Kconfig                             |  21 +-
 sound/soc/qcom/Makefile                            |   2 +
 sound/soc/qcom/common.c                            | 114 -----
 sound/soc/qcom/common.h                            |  10 -
 sound/soc/qcom/lpass-cpu.c                         |   5 +-
 sound/soc/qcom/sc8280xp.c                          |   1 +
 sound/soc/qcom/sdw.c                               | 123 ++++++
 sound/soc/qcom/sdw.h                               |  18 +
 sound/soc/qcom/sm8250.c                            |   1 +
 sound/usb/implicit.c                               |   3 +-
 sound/usb/pcm.c                                    |  16 +-
 sound/usb/stream.c                                 |   6 +
 tools/include/nolibc/arch-mips.h                   |   2 +
 tools/include/nolibc/arch-riscv.h                  |  14 +-
 tools/perf/builtin-kmem.c                          |  65 ++-
 tools/perf/builtin-trace.c                         |   2 +
 tools/perf/util/auxtrace.c                         |   2 +-
 tools/perf/util/bpf_counter.h                      |   6 +
 tools/testing/memblock/internal.h                  |   4 +
 .../testing/selftests/net/af_unix/test_unix_oob.c  |   2 +-
 tools/testing/selftests/net/l2_tos_ttl_inherit.sh  | 202 +++++----
 .../selftests/netfilter/nft_trans_stress.sh        |  16 +-
 tools/testing/selftests/netfilter/settings         |   1 +
 214 files changed, 2806 insertions(+), 2326 deletions(-)


