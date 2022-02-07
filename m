Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B2F44AC136
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 15:31:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240669AbiBGOXM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 09:23:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232268AbiBGOEr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 09:04:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44881C043181;
        Mon,  7 Feb 2022 06:04:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DCFB3B81369;
        Mon,  7 Feb 2022 14:04:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BBCAC340EF;
        Mon,  7 Feb 2022 14:04:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644242680;
        bh=7Q9gyPNvG2b5EKb0/m4NzA0fFB9Mqcpkkeonwz4DyCM=;
        h=From:To:Cc:Subject:Date:From;
        b=Iijs29mJbWX646m9VY8yhHoTQz0eIfVDz3FTt9QBgVJRlBqLPaGfQbqdUTMN66ev4
         3Q3v5Boce/Y3KZECPBPB0GSXT5wJ2rEkvhLYUiOwje5kupiIYZs9OeSt+Ncpn0r9HT
         qtutYTqWITwrVlthqW1sRSYXCyPhXOP4aM7gslPE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Subject: [PATCH 5.15 000/111] 5.15.22-rc2 review
Date:   Mon,  7 Feb 2022 15:04:35 +0100
Message-Id: <20220207133903.595766086@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.22-rc2.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.15.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.15.22-rc2
X-KernelTest-Deadline: 2022-02-09T13:39+00:00
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

This is the start of the stable review cycle for the 5.15.22 release.
There are 111 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 09 Feb 2022 13:38:43 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.22-rc2.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.15.22-rc2

Florian Westphal <fw@strlen.de>
    selftests: netfilter: check stateless nat udp checksum fixup

Florian Westphal <fw@strlen.de>
    selftests: nft_concat_range: add test for reload with no element add/del

Yang Li <yang.lee@linux.alibaba.com>
    gpio: mpc8xxx: Fix an ignored error return from platform_get_irq()

Yang Li <yang.lee@linux.alibaba.com>
    gpio: idt3243x: Fix an ignored error return from platform_get_irq()

Arnaldo Carvalho de Melo <acme@redhat.com>
    tools include UAPI: Sync sound/asound.h copy with the kernel sources

Waiman Long <longman@redhat.com>
    cgroup/cpuset: Fix "suspicious RCU usage" lockdep warning

Arınç ÜNAL <arinc.unal@arinc9.com>
    net: dsa: mt7530: make NET_DSA_MT7530 select MEDIATEK_GE_PHY

Xin Yin <yinxin.x@bytedance.com>
    ext4: fix incorrect type issue during replay_del_range

Ritesh Harjani <riteshh@linux.ibm.com>
    ext4: fix error handling in ext4_fc_record_modified_inode()

Ritesh Harjani <riteshh@linux.ibm.com>
    ext4: fix error handling in ext4_restore_inline_data()

Xin Yin <yinxin.x@bytedance.com>
    ext4: modify the logic of ext4_mb_new_blocks_simple

Xin Yin <yinxin.x@bytedance.com>
    ext4: prevent used blocks from being allocated during fast commit replay

Sergey Shtylyov <s.shtylyov@omp.ru>
    EDAC/xgene: Fix deferred probing

Sergey Shtylyov <s.shtylyov@omp.ru>
    EDAC/altera: Fix deferred probing

Peter Zijlstra <peterz@infradead.org>
    x86/perf: Default set FREEZE_ON_SMI for all

Tristan Hume <tristan@thume.ca>
    perf/x86/intel/pt: Fix crash with stop filters in single-range mode

Ian Rogers <irogers@google.com>
    perf stat: Fix display of grouped aliased events

Marco Elver <elver@google.com>
    perf: Copy perf_event_attr::sig_data on modification

Mark Rutland <mark.rutland@arm.com>
    kvm/arm64: rework guest entry logic

Mark Rutland <mark.rutland@arm.com>
    kvm: add guest_state_{enter,exit}_irqoff()

Riwen Lu <luriwen@kylinos.cn>
    rtc: cmos: Evaluate century appropriate

Sasha Neftin <sasha.neftin@intel.com>
    e1000e: Separate ADP board type from TGP

Nathan Chancellor <nathan@kernel.org>
    tools/resolve_btfids: Do not print any commands when building silently

Muhammad Usama Anjum <usama.anjum@collabora.com>
    selftests: futex: Use variable MAKE instead of make

Muhammad Usama Anjum <usama.anjum@collabora.com>
    selftests/exec: Remove pipe from TEST_GEN_FILES

Hou Tao <hotforest@gmail.com>
    bpf: Use VM_MAP instead of VM_ALLOC for ringbuf

Haiyue Wang <haiyue.wang@intel.com>
    gve: fix the wrong AdminQ buffer queue index check

Dai Ngo <dai.ngo@oracle.com>
    nfsd: nfsd4_setclientid_confirm mistakenly expires confirmed client.

John Meneghini <jmeneghi@redhat.com>
    scsi: bnx2fc: Make bnx2fc_recv_frame() mp safe

Florian Fainelli <f.fainelli@gmail.com>
    pinctrl: bcm2835: Fix a few error paths

Łukasz Bartosik <lb@semihalf.com>
    pinctrl: intel: fix unexpected interrupt

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    pinctrl: intel: Fix a glitch when updating IRQ flags on a preconfigured line

Andre Przywara <andre.przywara@arm.com>
    pinctrl: sunxi: Fix H616 I2S3 pin data

Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
    ASoC: codecs: wcd938x: fix return value of mixer put function

Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
    ASoC: codecs: lpass-rx-macro: fix sidetone register offsets

Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
    ASoC: codecs: wcd938x: fix incorrect used of portid

Dan Carpenter <dan.carpenter@oracle.com>
    ASoC: max9759: fix underflow in speaker_gain_control_put()

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    ASoC: cpcap: Check for NULL pointer after calling of_get_child_by_name

Robert Hancock <robert.hancock@calian.com>
    ASoC: simple-card: fix probe failure on platform component

Robert Hancock <robert.hancock@calian.com>
    ASoC: xilinx: xlnx_formatter_pcm: Make buffer bytes multiple of period bytes

Miaoqian Lin <linmq006@gmail.com>
    ASoC: fsl: Add missing error handling in pcm030_fabric_probe

Mario Limonciello <mario.limonciello@amd.com>
    drm/amd: avoid suspend on dGPUs w/ s2idle support when runtime PM enabled

Dan Carpenter <dan.carpenter@oracle.com>
    drm/i915/overlay: Prevent divide by zero bugs in scaling

Anitha Chrisanthus <anitha.chrisanthus@intel.com>
    drm/kmb: Fix for build errors with Warray-bounds

Yannick Vignon <yannick.vignon@nxp.com>
    net: stmmac: ensure PTP time register reads are consistent

Camel Guo <camelg@axis.com>
    net: stmmac: dump gmac4 DMA registers correctly

Lior Nahmanson <liorna@nvidia.com>
    net: macsec: Verify that send_sci is on when setting Tx sci explicitly

Lior Nahmanson <liorna@nvidia.com>
    net: macsec: Fix offload support for NETDEV_UNREGISTER event

Jisheng Zhang <jszhang@kernel.org>
    net: stmmac: properly handle with runtime pm in stmmac_dvr_remove()

Yuji Ishikawa <yuji2.ishikawa@toshiba.co.jp>
    net: stmmac: dwmac-visconti: No change to ETHER_CLOCK_SEL for unexpected speed request.

Wen Gu <guwen@linux.alibaba.com>
    net/smc: Forward wakeup to smc socket waitqueue after fallback

Miquel Raynal <miquel.raynal@bootlin.com>
    net: ieee802154: Return meaningful error codes from the netlink helpers

Phil Sutter <phil@nwl.cc>
    netfilter: nft_reject_bridge: Fix for missing reply from prerouting

Miquel Raynal <miquel.raynal@bootlin.com>
    net: ieee802154: ca8210: Stop leaking skb's

Miquel Raynal <miquel.raynal@bootlin.com>
    net: ieee802154: mcr20a: Fix lifs/sifs periods

Miquel Raynal <miquel.raynal@bootlin.com>
    net: ieee802154: hwsim: Ensure proper channel selection at probe time

Mark Zhang <markzhang@nvidia.com>
    IB/cm: Release previously acquired reference counter in the cm_id_priv

Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>
    IB/hfi1: Fix tstats alloc and dealloc

Xin Xiong <xiongx18@fudan.edu.cn>
    spi: uniphier: fix reference count leak in uniphier_spi_probe()

Miaoqian Lin <linmq006@gmail.com>
    spi: meson-spicc: add IRQ check in meson_spicc_probe

Benjamin Gaignard <benjamin.gaignard@collabora.com>
    spi: mediatek: Avoid NULL pointer crash in interrupt

Kamal Dasu <kdasu.kdev@gmail.com>
    spi: bcm-qspi: check for valid cs before applying chip select

Joerg Roedel <jroedel@suse.de>
    iommu/amd: Fix loop timeout issue in iommu_ga_log_enable()

Guoqing Jiang <guoqing.jiang@linux.dev>
    iommu/vt-d: Fix potential memory leak in intel_setup_irq_remapping()

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ALSA: hda: Skip codec shutdown in case the codec is not registered

Takashi Iwai <tiwai@suse.de>
    ALSA: hda: Fix signedness of sscanf() arguments

Tom Rix <trix@redhat.com>
    ALSA: usb-audio: initialize variables that could ignore errors

Leon Romanovsky <leon@kernel.org>
    RDMA/mlx4: Don't continue event handler after memory allocation failure

Bernard Metzler <bmt@zurich.ibm.com>
    RDMA/siw: Fix broken RDMA Read Fence/Resume logic.

Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>
    IB/rdmavt: Validate remote_addr during loopback atomic tests

Dan Carpenter <dan.carpenter@oracle.com>
    RDMA/siw: Fix refcounting leak in siw_create_qp()

Leon Romanovsky <leon@kernel.org>
    RDMA/ucma: Protect mc during concurrent multicast leaves

Maor Gottlieb <maorg@nvidia.com>
    RDMA/cma: Use correct address when leaving multicast group

James Morse <james.morse@arm.com>
    KVM: arm64: Stop handle_exit() from handling HVC twice when an SError occurs

James Morse <james.morse@arm.com>
    KVM: arm64: Avoid consuming a stale esr value when SError occur

Guenter Roeck <linux@roeck-us.net>
    Revert "ASoC: mediatek: Check for error clk pointer"

Paolo Abeni <pabeni@redhat.com>
    mptcp: fix msk traversal in mptcp_nl_cmd_set_flags()

Helge Deller <deller@gmx.de>
    fbcon: Add option to enable legacy hardware acceleration

Helge Deller <deller@gmx.de>
    Revert "fbcon: Disable accelerated scrolling"

Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>
    IB/hfi1: Fix AIP early init panic

Jordy Zomer <jordy@pwning.systems>
    dma-buf: heaps: Fix potential spectre v1 gadget

Martin K. Petersen <martin.petersen@oracle.com>
    block: bio-integrity: Advance seed correctly for larger interval sizes

Lang Yu <lang.yu@amd.com>
    mm/kmemleak: avoid scanning potential huge holes

Mike Rapoport <rppt@kernel.org>
    mm/pgtable: define pte_index so that preprocessor could recognize it

Pasha Tatashin <pasha.tatashin@soleen.com>
    mm/debug_vm_pgtable: remove pte entry from the page table

Uday Shankar <ushankar@purestorage.com>
    nvme-fabrics: fix state check in nvmf_ctlr_matches_baseopts()

Aun-Ali Zaidi <admin@kodeit.net>
    drm/amd/display: Force link_rate as LINK_RATE_RBR2 for 2018 15" Apple Retina panels

Paul Hsieh <paul.hsieh@amd.com>
    drm/amd/display: watermark latencies is not enough on DCN31

Evan Quan <evan.quan@amd.com>
    drm/amd/pm: correct the MGpuFanBoost support for Beige Goby

Imre Deak <imre.deak@intel.com>
    drm/i915/adlp: Fix TypeC PHY-ready status readout

Nick Lopez <github@glowingmonkey.org>
    drm/nouveau: fix off by one in BIOS boundary checking

Dominique Martinet <asmadeus@codewreck.org>
    Revert "fs/9p: search open fids first"

Filipe Manana <fdmanana@suse.com>
    btrfs: fix use-after-free after failure to create a snapshot

Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
    btrfs: fix deadlock between quota disable and qgroup rescan worker

Qu Wenruo <wqu@suse.com>
    btrfs: don't start transaction for scrub if the fs is mounted read-only

Christian Lachner <gladiac@gmail.com>
    ALSA: hda/realtek: Fix silent output on Gigabyte X570 Aorus Xtreme after reboot from Windows

Christian Lachner <gladiac@gmail.com>
    ALSA: hda/realtek: Fix silent output on Gigabyte X570S Aorus Master (newer chipset)

Christian Lachner <gladiac@gmail.com>
    ALSA: hda/realtek: Add missing fixup-model entry for Gigabyte X570 ALC1220 quirks

Albert Geantă <albertgeanta@gmail.com>
    ALSA: hda/realtek: Add quirk for ASUS GU603

Takashi Iwai <tiwai@suse.de>
    ALSA: hda: realtek: Fix race at concurrent COEF updates

Takashi Iwai <tiwai@suse.de>
    ALSA: hda: Fix UAF of leds class devs at unbinding

Jonas Hahnfeld <hahnjo@hahnjo.de>
    ALSA: usb-audio: Correct quirk for VF0770

Mark Brown <broonie@kernel.org>
    ASoC: ops: Reject out of bounds values in snd_soc_put_xr_sx()

Mark Brown <broonie@kernel.org>
    ASoC: ops: Reject out of bounds values in snd_soc_put_volsw_sx()

Mark Brown <broonie@kernel.org>
    ASoC: ops: Reject out of bounds values in snd_soc_put_volsw()

Dmitry Osipenko <digetx@gmail.com>
    ASoC: hdmi-codec: Fix OOB memory accesses

Patrice Chotard <patrice.chotard@foss.st.com>
    spi: stm32-qspi: Update spi registering

Minghao Chi <chi.minghao@zte.com.cn>
    ipc/sem: do not sleep with a spin lock held

Paul Moore <paul@paul-moore.com>
    audit: improve audit queue handling when "audit=1" on cmdline

Vratislav Bendel <vbendel@redhat.com>
    selinux: fix double free of cond_list on error paths

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/i915: Disable DSB usage for now


-------------

Diffstat:

 Documentation/gpu/todo.rst                         |  21 ---
 Makefile                                           |   4 +-
 arch/arm64/kvm/arm.c                               |  51 ++++---
 arch/arm64/kvm/handle_exit.c                       |   8 ++
 arch/arm64/kvm/hyp/include/hyp/switch.h            |   3 +-
 arch/x86/events/intel/core.c                       |  13 ++
 arch/x86/events/intel/pt.c                         |   5 +-
 block/bio-integrity.c                              |   2 +-
 drivers/dma-buf/dma-heap.c                         |   2 +
 drivers/edac/altera_edac.c                         |   2 +-
 drivers/edac/xgene_edac.c                          |   2 +-
 drivers/gpio/gpio-idt3243x.c                       |   2 +-
 drivers/gpio/gpio-mpc8xxx.c                        |   2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c            |   3 +-
 .../amd/display/dc/clk_mgr/dcn31/dcn31_clk_mgr.c   |  20 +--
 drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c   |  20 +++
 .../drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c    |   6 +-
 drivers/gpu/drm/i915/display/intel_overlay.c       |   3 +
 drivers/gpu/drm/i915/display/intel_tc.c            |   3 +-
 drivers/gpu/drm/i915/i915_pci.c                    |   2 +-
 drivers/gpu/drm/kmb/kmb_plane.c                    |   6 -
 drivers/gpu/drm/nouveau/nvkm/subdev/bios/base.c    |   2 +-
 drivers/infiniband/core/cm.c                       |   2 +-
 drivers/infiniband/core/cma.c                      |  22 +--
 drivers/infiniband/core/ucma.c                     |  34 +++--
 drivers/infiniband/hw/hfi1/ipoib_main.c            |  27 ++--
 drivers/infiniband/hw/mlx4/main.c                  |   2 +-
 drivers/infiniband/sw/rdmavt/qp.c                  |   2 +
 drivers/infiniband/sw/siw/siw.h                    |   7 +-
 drivers/infiniband/sw/siw/siw_qp_rx.c              |  20 +--
 drivers/infiniband/sw/siw/siw_verbs.c              |   3 +-
 drivers/iommu/amd/init.c                           |   2 +
 drivers/iommu/intel/irq_remapping.c                |  13 +-
 drivers/net/dsa/Kconfig                            |   1 +
 drivers/net/ethernet/google/gve/gve_adminq.c       |   2 +-
 drivers/net/ethernet/intel/e1000e/e1000.h          |   4 +-
 drivers/net/ethernet/intel/e1000e/ich8lan.c        |  20 +++
 drivers/net/ethernet/intel/e1000e/netdev.c         |  33 ++---
 .../net/ethernet/stmicro/stmmac/dwmac-visconti.c   |   9 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac_dma.h    |   1 +
 .../net/ethernet/stmicro/stmmac/stmmac_ethtool.c   |  19 ++-
 .../net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c  |  19 ++-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |   6 +-
 drivers/net/ieee802154/ca8210.c                    |   1 +
 drivers/net/ieee802154/mac802154_hwsim.c           |   1 +
 drivers/net/ieee802154/mcr20a.c                    |   4 +-
 drivers/net/macsec.c                               |  33 +++--
 drivers/nvme/host/fabrics.h                        |   1 +
 drivers/pinctrl/bcm/pinctrl-bcm2835.c              |  23 ++--
 drivers/pinctrl/intel/pinctrl-intel.c              |  64 +++++----
 drivers/pinctrl/sunxi/pinctrl-sun50i-h616.c        |   8 +-
 drivers/rtc/rtc-mc146818-lib.c                     |   2 +-
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c                  |  21 +--
 drivers/soc/mediatek/mtk-scpsys.c                  |  15 +-
 drivers/spi/spi-bcm-qspi.c                         |   2 +-
 drivers/spi/spi-meson-spicc.c                      |   5 +
 drivers/spi/spi-mt65xx.c                           |   2 +-
 drivers/spi/spi-stm32-qspi.c                       |  47 +++----
 drivers/spi/spi-uniphier.c                         |  18 ++-
 drivers/video/console/Kconfig                      |  20 +++
 drivers/video/fbdev/core/fbcon.c                   |  68 +++++++--
 drivers/video/fbdev/core/fbcon.h                   |  15 +-
 drivers/video/fbdev/core/fbcon_ccw.c               |  10 +-
 drivers/video/fbdev/core/fbcon_cw.c                |  10 +-
 drivers/video/fbdev/core/fbcon_rotate.h            |   4 +-
 drivers/video/fbdev/core/fbcon_ud.c                |  20 +--
 fs/9p/fid.c                                        |   9 +-
 fs/btrfs/block-group.c                             |  13 ++
 fs/btrfs/ioctl.c                                   |   5 +-
 fs/btrfs/qgroup.c                                  |  21 ++-
 fs/btrfs/transaction.c                             |  24 ++++
 fs/btrfs/transaction.h                             |   2 +
 fs/ext4/ext4.h                                     |   3 +
 fs/ext4/extents.c                                  |   4 +
 fs/ext4/fast_commit.c                              |  89 ++++++------
 fs/ext4/inline.c                                   |  10 +-
 fs/ext4/mballoc.c                                  |  26 ++--
 fs/nfsd/nfs4state.c                                |   4 +-
 include/linux/kvm_host.h                           | 112 ++++++++++++++-
 include/linux/pgtable.h                            |   1 +
 include/uapi/sound/asound.h                        |   4 +-
 ipc/sem.c                                          |   4 +-
 kernel/audit.c                                     |  62 ++++++---
 kernel/bpf/ringbuf.c                               |   2 +-
 kernel/cgroup/cpuset.c                             |  10 ++
 kernel/events/core.c                               |  16 +++
 mm/debug_vm_pgtable.c                              |   2 +
 mm/kmemleak.c                                      |  13 +-
 net/bridge/netfilter/nft_reject_bridge.c           |   8 +-
 net/ieee802154/nl802154.c                          |   8 +-
 net/mptcp/pm_netlink.c                             |  34 +++--
 net/smc/af_smc.c                                   | 133 ++++++++++++++++--
 net/smc/smc.h                                      |  20 ++-
 security/selinux/ss/conditional.c                  |   3 +-
 sound/pci/hda/hda_auto_parser.c                    |   2 +-
 sound/pci/hda/hda_codec.c                          |   4 +
 sound/pci/hda/hda_generic.c                        |  17 ++-
 sound/pci/hda/hda_generic.h                        |   3 +
 sound/pci/hda/patch_realtek.c                      |  67 +++++++--
 sound/soc/codecs/cpcap.c                           |   2 +
 sound/soc/codecs/hdmi-codec.c                      |   2 +-
 sound/soc/codecs/lpass-rx-macro.c                  |   8 +-
 sound/soc/codecs/max9759.c                         |   3 +-
 sound/soc/codecs/wcd938x.c                         |  31 +++--
 sound/soc/fsl/pcm030-audio-fabric.c                |  11 +-
 sound/soc/generic/simple-card.c                    |  26 +++-
 sound/soc/soc-ops.c                                |  29 +++-
 sound/soc/xilinx/xlnx_formatter_pcm.c              |  27 +++-
 sound/usb/mixer.c                                  |   4 +
 sound/usb/quirks-table.h                           |   2 +-
 tools/bpf/resolve_btfids/Makefile                  |   6 +-
 tools/include/uapi/sound/asound.h                  |   4 +-
 tools/perf/util/stat-display.c                     |  19 +--
 tools/testing/selftests/exec/Makefile              |   2 +-
 tools/testing/selftests/futex/Makefile             |   4 +-
 .../selftests/netfilter/nft_concat_range.sh        |  72 +++++++++-
 tools/testing/selftests/netfilter/nft_nat.sh       | 152 +++++++++++++++++++++
 117 files changed, 1470 insertions(+), 493 deletions(-)


