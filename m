Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D199D5B7398
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 17:13:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235626AbiIMPMu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 11:12:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232878AbiIMPLU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 11:11:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A7DA7822D;
        Tue, 13 Sep 2022 07:32:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4EDFD614BF;
        Tue, 13 Sep 2022 14:16:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 265B8C433D6;
        Tue, 13 Sep 2022 14:16:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663078610;
        bh=RvzFN+BKuTRyLd25klzt2Kcs+XJxSjGl1pHq2iMvsc8=;
        h=From:To:Cc:Subject:Date:From;
        b=pBylTuXtMA8rdlzvIz560IJ1K5vu/aW/xqXYOJAxdqDb3QYKQI/ns1EPswh1ZIVYP
         oKRxM6ktUhV0StDCFPCI5Y/UO808V+Dgak3dTma8E1F8b+VwYQFOJ4tQNG7JdGol1j
         YU32Hdl6YdMP8OeAvVsOqP3LAoTJGcJWrMk6TJpo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Subject: [PATCH 5.15 000/121] 5.15.68-rc1 review
Date:   Tue, 13 Sep 2022 16:03:11 +0200
Message-Id: <20220913140357.323297659@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.68-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.15.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.15.68-rc1
X-KernelTest-Deadline: 2022-09-15T14:04+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.15.68 release.
There are 121 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 15 Sep 2022 14:03:27 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.68-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.15.68-rc1

Claudiu Beznea <claudiu.beznea@microchip.com>
    ARM: at91: ddr: remove CONFIG_SOC_SAMA7 dependency

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf machine: Use path__join() to compose a path instead of snprintf(dir, '/', filename)

Neil Armstrong <narmstrong@baylibre.com>
    drm/bridge: display-connector: implement bus fmts callbacks

Ionela Voinescu <ionela.voinescu@arm.com>
    arm64: errata: add detection for AMEVCNTR01 incrementing incorrectly

Lu Baolu <baolu.lu@linux.intel.com>
    iommu/vt-d: Correctly calculate sagaw value of IOMMU

Mark Brown <broonie@kernel.org>
    arm64/bti: Disable in kernel BTI when cross section thunks are broken

Sasha Levin <sashal@kernel.org>
    Revert "arm64: kasan: Revert "arm64: mte: reset the page tag in page->flags""

Eliav Farber <farbere@amazon.com>
    hwmon: (mr75203) enable polling for all VM channels

Eliav Farber <farbere@amazon.com>
    hwmon: (mr75203) fix multi-channel voltage reading

Eliav Farber <farbere@amazon.com>
    hwmon: (mr75203) fix voltage equation for negative source input

Eliav Farber <farbere@amazon.com>
    hwmon: (mr75203) update pvt->v_num and vm_num to the actual number of used sensors

Eliav Farber <farbere@amazon.com>
    hwmon: (mr75203) fix VM sensor allocation when "intel,vm-map" not defined

Alexander Gordeev <agordeev@linux.ibm.com>
    s390/boot: fix absolute zero lowcore corruption on boot

John Sperbeck <jsperbeck@google.com>
    iommu/amd: use full 64-bit value in build_completion_wait()

Chao Gao <chao.gao@intel.com>
    swiotlb: avoid potential left shift overflow

Przemyslaw Patynowski <przemyslawx.patynowski@intel.com>
    i40e: Fix ADQ rate limiting for PF

Przemyslaw Patynowski <przemyslawx.patynowski@intel.com>
    i40e: Refactor tc mqprio checks

Masahiro Yamada <masahiroy@kernel.org>
    kbuild: disable header exports for UML in a straightforward way

Yang Ling <gnaygnil@gmail.com>
    MIPS: loongson32: ls1c: Fix hang during startup

Nathan Chancellor <nathan@kernel.org>
    ASoC: mchp-spdiftx: Fix clang -Wbitfield-constant-conversion

Claudiu Beznea <claudiu.beznea@microchip.com>
    ASoC: mchp-spdiftx: remove references to mchp_i2s_caps

Alexandru Gagniuc <mr.nuke.me@gmail.com>
    hwmon: (tps23861) fix byte order in resistance register

Zhengjun Xing <zhengjun.xing@linux.intel.com>
    perf script: Fix Cannot print 'iregs' field for hybrid systems

Toke Høiland-Jørgensen <toke@toke.dk>
    sch_sfb: Also store skb len before calling child enqueue

Sindhu-Devale <sindhu.devale@intel.com>
    RDMA/irdma: Report RNR NAK generation in device caps

Sindhu-Devale <sindhu.devale@intel.com>
    RDMA/irdma: Return correct WC error for bind operation failure

Sindhu-Devale <sindhu.devale@intel.com>
    RDMA/irdma: Report the correct max cqes from query device

Dennis Maisenbacher <dennis.maisenbacher@wdc.com>
    nvmet: fix mar and mor off-by-one errors

Neal Cardwell <ncardwell@google.com>
    tcp: fix early ETIMEDOUT after spurious non-SACK RTO

Sagi Grimberg <sagi@grimberg.me>
    nvme-tcp: fix regression that causes sporadic requests to time out

Sagi Grimberg <sagi@grimberg.me>
    nvme-tcp: fix UAF when detecting digest errors

Gao Xiang <hsiangkao@linux.alibaba.com>
    erofs: fix pcluster use-after-free on UP platforms

Chris Mi <cmi@nvidia.com>
    RDMA/mlx5: Set local port to one when accessing counters

Yishai Hadas <yishaih@nvidia.com>
    IB/core: Fix a nested dead lock as part of ODP flow

David Lebrun <dlebrun@google.com>
    ipv6: sr: fix out-of-bounds read when setting HMAC data.

Linus Walleij <linus.walleij@linaro.org>
    RDMA/siw: Pass a pointer to virt_to_page()

Paul Durrant <pdurrant@amazon.com>
    xen-netback: only remove 'hotplug-status' when the vif is actually destroyed

Csókás Bence <csokas.bence@prolan.hu>
    net: fec: Use a spinlock to guard `fep->ptp_clk_on`

Ivan Vecera <ivecera@redhat.com>
    iavf: Detach device during reset task

Ivan Vecera <ivecera@redhat.com>
    i40e: Fix kernel crash during module removal

Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
    ice: use bitmap_free instead of devm_kfree

Eric Dumazet <edumazet@google.com>
    tcp: TX zerocopy should not sense pfmemalloc status

Pavel Begunkov <asml.silence@gmail.com>
    net: introduce __skb_fill_page_desc_noacc

Dan Carpenter <dan.carpenter@oracle.com>
    tipc: fix shift wrapping bug in map_get()

Toke Høiland-Jørgensen <toke@toke.dk>
    sch_sfb: Don't assume the skb is still around after enqueueing to child

Heiner Kallweit <hkallweit1@gmail.com>
    Revert "net: phy: meson-gxl: improve link-up behavior"

David Howells <dhowells@redhat.com>
    afs: Use the operation issue time instead of the reply time for callbacks

David Howells <dhowells@redhat.com>
    rxrpc: Fix an insufficiently large sglist in rxkad_verify_packet_2()

David Howells <dhowells@redhat.com>
    rxrpc: Fix ICMP/ICMP6 error handling

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Register card again for iface over delayed_register option

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Inform the delayed registration more properly

yangx.jy@fujitsu.com <yangx.jy@fujitsu.com>
    RDMA/srp: Set scmnd->result only when scmnd is not NULL

David Leadbeater <dgl@dgl.cx>
    netfilter: nf_conntrack_irc: Fix forged IP logic

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: clean up hook list when offload flags check fails

Harsh Modi <harshmodi@google.com>
    netfilter: br_netfilter: Drop dst references before setting.

Claudiu Beznea <claudiu.beznea@microchip.com>
    ARM: dts: at91: sama5d2_icp: don't keep vdd_other enabled all the time

Claudiu Beznea <claudiu.beznea@microchip.com>
    ARM: dts: at91: sama5d27_wlsom1: don't keep ldo2 enabled all the time

Claudiu Beznea <claudiu.beznea@microchip.com>
    ARM: dts: at91: sama5d2_icp: specify proper regulator output ranges

Claudiu Beznea <claudiu.beznea@microchip.com>
    ARM: dts: at91: sama5d27_wlsom1: specify proper regulator output ranges

Claudiu Beznea <claudiu.beznea@microchip.com>
    ARM: at91: pm: fix DDR recalibration when resuming from backup and self-refresh

Claudiu Beznea <claudiu.beznea@microchip.com>
    ARM: at91: pm: fix self-refresh for sama7g5

Ajay.Kathat@microchip.com <Ajay.Kathat@microchip.com>
    wifi: wilc1000: fix DMA on stack objects

Wenpeng Liang <liangwenpeng@huawei.com>
    RDMA/hns: Fix wrong fixed value of qp->rq.wqe_shift

Chengchang Tang <tangchengchang@huawei.com>
    RDMA/hns: Fix supported page size

Liang He <windhl@126.com>
    soc: brcmstb: pm-arm: Fix refcount leak and __iomem leak bugs

Michael Guralnik <michaelgur@nvidia.com>
    RDMA/cma: Fix arguments order in net device validation

Jens Wiklander <jens.wiklander@linaro.org>
    tee: fix compiler warning in tee_shm_register()

Andrew Halaney <ahalaney@redhat.com>
    regulator: core: Clean up on enable failure

Marek Vasut <marex@denx.de>
    soc: imx: gpcv2: Assert reset before ungating clock

Marco Felsch <m.felsch@pengutronix.de>
    ARM: dts: imx6qdl-kontron-samx6i: remove duplicated node

Jack Wang <jinpu.wang@ionos.com>
    RDMA/rtrs-srv: Pass the correct number of entries for dma mapped SGL

Jack Wang <jinpu.wang@ionos.com>
    RDMA/rtrs-clt: Use the right sg_cnt after ib_dma_map_sg

Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
    ASoC: qcom: sm8250: add missing module owner

Geert Uytterhoeven <geert@linux-m68k.org>
    riscv: dts: microchip: mpfs: Fix reference clock node

Tejun Heo <tj@kernel.org>
    cgroup: Fix threadgroup_rwsem <-> cpus_read_lock() deadlock

Tejun Heo <tj@kernel.org>
    cgroup: Elide write-locking threadgroup_rwsem when updating csses on an empty subtree

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFS: Fix another fsync() issue after a server reboot

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFS: Save some space in the inode

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFS: Further optimisations for 'ls -l'

Yang Yingliang <yangyingliang@huawei.com>
    scsi: lpfc: Add missing destroy_workqueue() in error path

Sreekanth Reddy <sreekanth.reddy@broadcom.com>
    scsi: mpt3sas: Fix use-after-free warning

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/i915: Implement WaEdpLinkRateDataReload

Bart Van Assche <bvanassche@acm.org>
    nvmet: fix a use-after-free

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    drm/amd/display: fix memory leak when using debugfs_lookup()

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    sched/debug: fix dentry leak in update_sched_domain_debugfs

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    debugfs: add debugfs_lookup_and_remove()

Christian A. Ehrhardt <lk@c--e.de>
    kprobes: Prohibit probes in gate area

Alex Williamson <alex.williamson@redhat.com>
    vfio/type1: Unpin zero pages

Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
    btrfs: zoned: set pseudo max append zone limit in zone emulation mode

Masami Hiramatsu (Google) <mhiramat@kernel.org>
    tracing: Fix to check event_mutex is held while accessing trigger list

Dongxiang Ke <kdx.glider@gmail.com>
    ALSA: usb-audio: Fix an out-of-bounds bug in __snd_usb_parse_audio_interface()

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Split endpoint setups for hw_params and prepare

Pattara Teerapong <pteerapong@chromium.org>
    ALSA: aloop: Fix random zeros in capture data when using jiffies timer

Tasos Sahanidis <tasos@tasossah.com>
    ALSA: emu10k1: Fix out of bounds access in snd_emu10k1_pcm_channel_alloc()

Takashi Iwai <tiwai@suse.de>
    ALSA: pcm: oss: Fix race at SNDCTL_DSP_SYNC

Qu Huang <jinsdb@126.com>
    drm/amdgpu: mmVM_L2_CNTL3 register not initialized correctly

Yang Yingliang <yangyingliang@huawei.com>
    fbdev: chipsfb: Add missing pci_disable_device() in chipsfb_pci_init()

Shigeru Yoshida <syoshida@redhat.com>
    fbdev: fbcon: Destroy mutex on freeing struct fb_info

David Sloan <david.sloan@eideticom.com>
    md: Flush workqueue md_rdev_misc_wq in md_alloc()

lily <floridsleeves@gmail.com>
    net/core/skbuff: Check the return value of skb_copy_bits()

Lukasz Luba <lukasz.luba@arm.com>
    cpufreq: check only freq_table in __resolve_freq()

Florian Westphal <fw@strlen.de>
    netfilter: conntrack: work around exceeded receive window

Mark Brown <broonie@kernel.org>
    arm64/signal: Raise limit on stack frames

Sudeep Holla <sudeep.holla@arm.com>
    arm64: cacheinfo: Fix incorrect assignment of signed error value to unsigned fw_level

Helge Deller <deller@gmx.de>
    parisc: Add runtime check to prevent PA2.0 kernels on PA1.x machines

Li Qiong <liqiong@nfschina.com>
    parisc: ccio-dma: Handle kmalloc failure in ccio_init_resources()

Helge Deller <deller@gmx.de>
    Revert "parisc: Show error if wrong 32/64-bit compiler is being used"

Bart Van Assche <bvanassche@acm.org>
    scsi: ufs: core: Reduce the power mode change timeout

Zhenneng Li <lizhenneng@kylinos.cn>
    drm/radeon: add a force flush to delay work when radeon

Candice Li <candice.li@amd.com>
    drm/amdgpu: Check num_gfx_rings for gfx v9_0 rb setup.

YiPeng Chai <YiPeng.Chai@amd.com>
    drm/amdgpu: Move psp_xgmi_terminate call from amdgpu_xgmi_remove_device to psp_hw_fini

Jeffy Chen <jeffy.chen@rock-chips.com>
    drm/gem: Fix GEM handle release errors

Guixin Liu <kanie@linux.alibaba.com>
    scsi: megaraid_sas: Fix double kfree()

Tony Battersby <tonyb@cybernetics.com>
    scsi: qla2xxx: Disable ATIO interrupt coalesce for quad port ISP27XX

Yee Lee <yee.lee@mediatek.com>
    Revert "mm: kmemleak: take a full lowmem check in kmemleak_*_phys()"

Linus Torvalds <torvalds@linux-foundation.org>
    fs: only do a memory barrier for the first set_buffer_uptodate()

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    net: mvpp2: debugfs: fix memory leak when using debugfs_lookup()

Stanislaw Gruszka <stf_xl@wp.pl>
    wifi: iwlegacy: 4965: corrected fix for potential off-by-one overflow in il4965_rs_fill_link_cmd()

Hyunwoo Kim <imv4bel@gmail.com>
    efi: capsule-loader: Fix use-after-free in efi_capsule_write

Ard Biesheuvel <ardb@kernel.org>
    efi: libstub: Disable struct randomization

Jakub Kicinski <kuba@kernel.org>
    net: wwan: iosm: remove pointless null check


-------------

Diffstat:

 Documentation/arm64/silicon-errata.rst             |   2 +
 Makefile                                           |   7 +-
 arch/arm/boot/dts/at91-sama5d27_wlsom1.dtsi        |  21 +-
 arch/arm/boot/dts/at91-sama5d2_icp.dts             |  21 +-
 arch/arm/boot/dts/imx6qdl-kontron-samx6i.dtsi      |  10 -
 arch/arm/mach-at91/pm.c                            |  36 ++-
 arch/arm/mach-at91/pm_suspend.S                    |  24 +-
 arch/arm64/Kconfig                                 |  19 ++
 arch/arm64/kernel/cacheinfo.c                      |   6 +-
 arch/arm64/kernel/cpu_errata.c                     |   9 +
 arch/arm64/kernel/cpufeature.c                     |   5 +-
 arch/arm64/kernel/hibernate.c                      |   5 +
 arch/arm64/kernel/mte.c                            |   9 +
 arch/arm64/kernel/signal.c                         |   2 +-
 arch/arm64/kernel/topology.c                       |  32 ++-
 arch/arm64/mm/copypage.c                           |   9 +
 arch/arm64/mm/mteswap.c                            |   9 +
 arch/arm64/tools/cpucaps                           |   1 +
 arch/mips/loongson32/ls1c/board.c                  |   1 -
 arch/parisc/include/asm/bitops.h                   |   8 -
 arch/parisc/kernel/head.S                          |  43 ++-
 .../dts/microchip/microchip-mpfs-icicle-kit.dts    |   4 +
 arch/riscv/boot/dts/microchip/microchip-mpfs.dtsi  |  12 +-
 arch/s390/kernel/nmi.c                             |   2 +-
 arch/s390/kernel/setup.c                           |   1 +
 drivers/cpufreq/cpufreq.c                          |   2 +-
 drivers/firmware/efi/capsule-loader.c              |  31 +--
 drivers/firmware/efi/libstub/Makefile              |   7 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c            |   3 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_xgmi.c           |   2 +-
 drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c              |   3 +-
 drivers/gpu/drm/amd/amdgpu/mmhub_v1_0.c            |   1 +
 .../drm/amd/display/amdgpu_dm/amdgpu_dm_debugfs.c  |   2 +-
 drivers/gpu/drm/bridge/display-connector.c         |  86 ++++++
 drivers/gpu/drm/drm_gem.c                          |  17 +-
 drivers/gpu/drm/drm_internal.h                     |   4 +-
 drivers/gpu/drm/drm_prime.c                        |  20 +-
 .../gpu/drm/i915/display/intel_dp_link_training.c  |  22 ++
 drivers/gpu/drm/radeon/radeon_device.c             |   3 +
 drivers/hwmon/mr75203.c                            |  72 +++--
 drivers/hwmon/tps23861.c                           |  10 +-
 drivers/infiniband/core/cma.c                      |   4 +-
 drivers/infiniband/core/umem_odp.c                 |   2 +-
 drivers/infiniband/hw/hns/hns_roce_hw_v2.h         |   2 +-
 drivers/infiniband/hw/hns/hns_roce_qp.c            |   7 +-
 drivers/infiniband/hw/irdma/uk.c                   |   4 +-
 drivers/infiniband/hw/irdma/verbs.c                |   7 +-
 drivers/infiniband/hw/mlx5/mad.c                   |   6 +
 drivers/infiniband/sw/siw/siw_qp_tx.c              |  18 +-
 drivers/infiniband/ulp/rtrs/rtrs-clt.c             |   9 +-
 drivers/infiniband/ulp/rtrs/rtrs-srv.c             |  14 +-
 drivers/infiniband/ulp/srp/ib_srp.c                |   3 +-
 drivers/iommu/amd/iommu.c                          |   3 +-
 drivers/iommu/intel/iommu.c                        |  28 +-
 drivers/md/md.c                                    |   1 +
 drivers/net/ethernet/freescale/fec.h               |   1 -
 drivers/net/ethernet/freescale/fec_main.c          |  17 +-
 drivers/net/ethernet/freescale/fec_ptp.c           |  28 +-
 drivers/net/ethernet/intel/i40e/i40e.h             |  14 +
 drivers/net/ethernet/intel/i40e/i40e_client.c      |   5 +-
 drivers/net/ethernet/intel/i40e/i40e_ethtool.c     |   2 +-
 drivers/net/ethernet/intel/i40e/i40e_main.c        |  23 +-
 drivers/net/ethernet/intel/i40e/i40e_txrx.c        |   3 +-
 drivers/net/ethernet/intel/iavf/iavf_main.c        |  14 +-
 drivers/net/ethernet/intel/ice/ice_main.c          |   2 +-
 drivers/net/ethernet/marvell/mvpp2/mvpp2_debugfs.c |   4 +-
 drivers/net/phy/meson-gxl.c                        |   8 +-
 drivers/net/wireless/intel/iwlegacy/4965-rs.c      |   5 +-
 drivers/net/wireless/microchip/wilc1000/netdev.h   |   1 +
 drivers/net/wireless/microchip/wilc1000/sdio.c     |  39 ++-
 drivers/net/wireless/microchip/wilc1000/wlan.c     |  15 +-
 drivers/net/wwan/iosm/iosm_ipc_protocol_ops.c      |  10 -
 drivers/net/xen-netback/xenbus.c                   |   2 +-
 drivers/nvme/host/tcp.c                            |   7 +-
 drivers/nvme/target/core.c                         |   6 +-
 drivers/nvme/target/zns.c                          |  17 +-
 drivers/parisc/ccio-dma.c                          |  11 +-
 drivers/regulator/core.c                           |   9 +-
 drivers/scsi/lpfc/lpfc_init.c                      |   5 +-
 drivers/scsi/megaraid/megaraid_sas_fusion.c        |   1 -
 drivers/scsi/mpt3sas/mpt3sas_scsih.c               |   2 +-
 drivers/scsi/qla2xxx/qla_target.c                  |  10 +-
 drivers/scsi/ufs/ufshcd.c                          |   9 +-
 drivers/soc/bcm/brcmstb/pm/pm-arm.c                |  50 +++-
 drivers/soc/imx/gpcv2.c                            |   5 +-
 drivers/tee/tee_shm.c                              |   1 +
 drivers/vfio/vfio_iommu_type1.c                    |  12 +
 drivers/video/fbdev/chipsfb.c                      |   1 +
 drivers/video/fbdev/core/fbsysfs.c                 |   4 +
 fs/afs/flock.c                                     |   2 +-
 fs/afs/fsclient.c                                  |   2 +-
 fs/afs/internal.h                                  |   3 +-
 fs/afs/rxrpc.c                                     |   7 +-
 fs/afs/yfsclient.c                                 |   3 +-
 fs/btrfs/zoned.c                                   |  15 +-
 fs/debugfs/inode.c                                 |  22 ++
 fs/erofs/internal.h                                |  29 --
 fs/nfs/dir.c                                       |  16 +-
 fs/nfs/file.c                                      |  15 +-
 fs/nfs/inode.c                                     |  27 +-
 fs/nfs/write.c                                     |   6 +-
 include/linux/buffer_head.h                        |  11 +
 include/linux/debugfs.h                            |   6 +
 include/linux/nfs_fs.h                             |  48 ++--
 include/linux/skbuff.h                             |  49 +++-
 include/linux/udp.h                                |   1 +
 include/net/udp_tunnel.h                           |   4 +
 include/soc/at91/sama7-ddr.h                       |  12 +-
 kernel/cgroup/cgroup.c                             |  85 ++++--
 kernel/cgroup/cpuset.c                             |   3 +-
 kernel/dma/swiotlb.c                               |   5 +-
 kernel/fork.c                                      |   1 +
 kernel/kprobes.c                                   |   1 +
 kernel/sched/debug.c                               |   2 +-
 kernel/trace/trace_events_trigger.c                |   3 +-
 mm/kmemleak.c                                      |   8 +-
 net/bridge/br_netfilter_hooks.c                    |   2 +
 net/bridge/br_netfilter_ipv6.c                     |   1 +
 net/core/datagram.c                                |   2 +-
 net/core/skbuff.c                                  |   5 +-
 net/ipv4/tcp.c                                     |   2 +-
 net/ipv4/tcp_input.c                               |  25 +-
 net/ipv4/udp.c                                     |   2 +
 net/ipv4/udp_tunnel_core.c                         |   1 +
 net/ipv6/seg6.c                                    |   5 +
 net/ipv6/udp.c                                     |   5 +-
 net/netfilter/nf_conntrack_irc.c                   |   5 +-
 net/netfilter/nf_conntrack_proto_tcp.c             |  31 +++
 net/netfilter/nf_tables_api.c                      |   4 +-
 net/rxrpc/ar-internal.h                            |   1 +
 net/rxrpc/local_object.c                           |   1 +
 net/rxrpc/peer_event.c                             | 293 ++++++++++++++++++---
 net/rxrpc/rxkad.c                                  |   2 +-
 net/sched/sch_sfb.c                                |  13 +-
 net/tipc/monitor.c                                 |   2 +-
 sound/core/oss/pcm_oss.c                           |   6 +-
 sound/drivers/aloop.c                              |   7 +-
 sound/pci/emu10k1/emupcm.c                         |   2 +-
 sound/soc/atmel/mchp-spdiftx.c                     |  10 +-
 sound/soc/qcom/sm8250.c                            |   1 +
 sound/usb/card.c                                   |   2 +-
 sound/usb/endpoint.c                               |  23 +-
 sound/usb/endpoint.h                               |   6 +-
 sound/usb/pcm.c                                    |  14 +-
 sound/usb/quirks.c                                 |   2 +-
 sound/usb/stream.c                                 |   9 +-
 tools/perf/builtin-script.c                        |   3 +
 tools/perf/util/machine.c                          |   3 +-
 148 files changed, 1376 insertions(+), 534 deletions(-)


