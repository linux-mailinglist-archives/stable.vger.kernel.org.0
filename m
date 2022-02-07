Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 855EF4ABBA7
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 12:39:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384676AbiBGL3e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 06:29:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383125AbiBGLVj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 06:21:39 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C438C0401E8;
        Mon,  7 Feb 2022 03:21:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BC1CBB81158;
        Mon,  7 Feb 2022 11:21:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04E47C004E1;
        Mon,  7 Feb 2022 11:21:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644232886;
        bh=3ck1RY+c+f5VBPQEGjjri2O6FOVonneYEmi+6F1/7uo=;
        h=From:To:Cc:Subject:Date:From;
        b=TGY9Us4Yp4WIs1OB/ucasHs1gjh5+mIJ3j0lXAF0L+HxYHGXNUeTctebNNfY2jzZx
         HTcE7opRU8FYa4m89+vuo5vhGKfzQa7CU2pkV2C3TxFZVaIdzGE5t/iq9iJN2pETs+
         3TWULDGQDkN43Bw4FsgAOFFtyrIg856KEXywiPwk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Subject: [PATCH 5.10 00/74] 5.10.99-rc1 review
Date:   Mon,  7 Feb 2022 12:05:58 +0100
Message-Id: <20220207103757.232676988@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.99-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.99-rc1
X-KernelTest-Deadline: 2022-02-09T10:37+00:00
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

This is the start of the stable review cycle for the 5.10.99 release.
There are 74 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 09 Feb 2022 10:37:42 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.99-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.10.99-rc1

Florian Westphal <fw@strlen.de>
    selftests: nft_concat_range: add test for reload with no element add/del

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

Helge Deller <deller@gmx.de>
    fbcon: Add option to enable legacy hardware acceleration

Helge Deller <deller@gmx.de>
    Revert "fbcon: Disable accelerated scrolling"

Riwen Lu <luriwen@kylinos.cn>
    rtc: cmos: Evaluate century appropriate

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

Dan Carpenter <dan.carpenter@oracle.com>
    ASoC: max9759: fix underflow in speaker_gain_control_put()

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    ASoC: cpcap: Check for NULL pointer after calling of_get_child_by_name

Robert Hancock <robert.hancock@calian.com>
    ASoC: xilinx: xlnx_formatter_pcm: Make buffer bytes multiple of period bytes

Miaoqian Lin <linmq006@gmail.com>
    ASoC: fsl: Add missing error handling in pcm030_fabric_probe

Dan Carpenter <dan.carpenter@oracle.com>
    drm/i915/overlay: Prevent divide by zero bugs in scaling

Yannick Vignon <yannick.vignon@nxp.com>
    net: stmmac: ensure PTP time register reads are consistent

Camel Guo <camelg@axis.com>
    net: stmmac: dump gmac4 DMA registers correctly

Lior Nahmanson <liorna@nvidia.com>
    net: macsec: Verify that send_sci is on when setting Tx sci explicitly

Lior Nahmanson <liorna@nvidia.com>
    net: macsec: Fix offload support for NETDEV_UNREGISTER event

Miquel Raynal <miquel.raynal@bootlin.com>
    net: ieee802154: Return meaningful error codes from the netlink helpers

Miquel Raynal <miquel.raynal@bootlin.com>
    net: ieee802154: ca8210: Stop leaking skb's

Miquel Raynal <miquel.raynal@bootlin.com>
    net: ieee802154: mcr20a: Fix lifs/sifs periods

Miquel Raynal <miquel.raynal@bootlin.com>
    net: ieee802154: hwsim: Ensure proper channel selection at probe time

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

Leon Romanovsky <leon@kernel.org>
    RDMA/mlx4: Don't continue event handler after memory allocation failure

Bernard Metzler <bmt@zurich.ibm.com>
    RDMA/siw: Fix broken RDMA Read Fence/Resume logic.

Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>
    IB/rdmavt: Validate remote_addr during loopback atomic tests

Leon Romanovsky <leon@kernel.org>
    RDMA/ucma: Protect mc during concurrent multicast leaves

Maor Gottlieb <maorg@nvidia.com>
    RDMA/cma: Use correct address when leaving multicast group

Yutian Yang <nglaive@gmail.com>
    memcg: charge fs_context and legacy_fs_context

Guenter Roeck <linux@roeck-us.net>
    Revert "ASoC: mediatek: Check for error clk pointer"

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

Nick Lopez <github@glowingmonkey.org>
    drm/nouveau: fix off by one in BIOS boundary checking

Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
    btrfs: fix deadlock between quota disable and qgroup rescan worker

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

Paul Moore <paul@paul-moore.com>
    audit: improve audit queue handling when "audit=1" on cmdline

Vratislav Bendel <vbendel@redhat.com>
    selinux: fix double free of cond_list on error paths


-------------

Diffstat:

 Documentation/gpu/todo.rst                         | 18 -----
 Makefile                                           |  4 +-
 arch/x86/events/intel/core.c                       | 13 ++++
 arch/x86/events/intel/pt.c                         |  5 +-
 block/bio-integrity.c                              |  2 +-
 drivers/dma-buf/dma-heap.c                         |  2 +
 drivers/edac/altera_edac.c                         |  2 +-
 drivers/edac/xgene_edac.c                          |  2 +-
 drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c   | 20 +++++
 drivers/gpu/drm/i915/display/intel_overlay.c       |  3 +
 drivers/gpu/drm/nouveau/nvkm/subdev/bios/base.c    |  2 +-
 drivers/infiniband/core/cma.c                      | 22 +++---
 drivers/infiniband/core/ucma.c                     | 34 ++++++---
 drivers/infiniband/hw/hfi1/ipoib_main.c            | 13 +---
 drivers/infiniband/hw/mlx4/main.c                  |  2 +-
 drivers/infiniband/sw/rdmavt/qp.c                  |  2 +
 drivers/infiniband/sw/siw/siw.h                    |  7 +-
 drivers/infiniband/sw/siw/siw_qp_rx.c              | 20 ++---
 drivers/iommu/amd/init.c                           |  2 +
 drivers/iommu/intel/irq_remapping.c                | 13 +++-
 drivers/net/dsa/Kconfig                            |  1 +
 drivers/net/ethernet/google/gve/gve_adminq.c       |  2 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac_dma.h    |  1 +
 .../net/ethernet/stmicro/stmmac/stmmac_ethtool.c   | 19 ++++-
 .../net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c  | 19 +++--
 drivers/net/ieee802154/ca8210.c                    |  1 +
 drivers/net/ieee802154/mac802154_hwsim.c           |  1 +
 drivers/net/ieee802154/mcr20a.c                    |  4 +-
 drivers/net/macsec.c                               | 33 +++++---
 drivers/nvme/host/fabrics.h                        |  1 +
 drivers/pinctrl/bcm/pinctrl-bcm2835.c              | 23 ++++--
 drivers/pinctrl/intel/pinctrl-intel.c              | 64 +++++++++-------
 drivers/rtc/rtc-mc146818-lib.c                     |  2 +-
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c                  | 21 +++--
 drivers/soc/mediatek/mtk-scpsys.c                  | 15 +---
 drivers/spi/spi-bcm-qspi.c                         |  2 +-
 drivers/spi/spi-meson-spicc.c                      |  5 ++
 drivers/spi/spi-mt65xx.c                           |  2 +-
 drivers/spi/spi-uniphier.c                         | 18 ++++-
 drivers/video/console/Kconfig                      | 20 +++++
 drivers/video/fbdev/core/fbcon.c                   | 68 ++++++++++++++---
 drivers/video/fbdev/core/fbcon.h                   | 15 +++-
 drivers/video/fbdev/core/fbcon_ccw.c               | 10 +--
 drivers/video/fbdev/core/fbcon_cw.c                | 10 +--
 drivers/video/fbdev/core/fbcon_rotate.h            |  4 +-
 drivers/video/fbdev/core/fbcon_ud.c                | 20 ++---
 fs/btrfs/qgroup.c                                  | 21 ++++-
 fs/ext4/ext4.h                                     |  3 +
 fs/ext4/extents.c                                  |  4 +
 fs/ext4/fast_commit.c                              | 89 ++++++++++++----------
 fs/ext4/inline.c                                   | 10 ++-
 fs/ext4/mballoc.c                                  | 26 ++++---
 fs/fs_context.c                                    |  4 +-
 fs/nfsd/nfs4state.c                                |  4 +-
 include/linux/pgtable.h                            |  1 +
 kernel/audit.c                                     | 62 ++++++++++-----
 kernel/bpf/ringbuf.c                               |  2 +-
 kernel/cgroup/cpuset.c                             | 10 +++
 mm/debug_vm_pgtable.c                              |  2 +
 mm/kmemleak.c                                      | 13 ++--
 net/ieee802154/nl802154.c                          |  8 +-
 security/selinux/ss/conditional.c                  |  3 +-
 sound/pci/hda/hda_generic.c                        | 17 ++++-
 sound/pci/hda/hda_generic.h                        |  3 +
 sound/pci/hda/patch_realtek.c                      | 67 +++++++++++++---
 sound/soc/codecs/cpcap.c                           |  2 +
 sound/soc/codecs/max9759.c                         |  3 +-
 sound/soc/fsl/pcm030-audio-fabric.c                | 11 ++-
 sound/soc/soc-ops.c                                | 29 ++++++-
 sound/soc/xilinx/xlnx_formatter_pcm.c              | 27 ++++++-
 sound/usb/quirks-table.h                           |  2 +-
 tools/bpf/resolve_btfids/Makefile                  |  6 +-
 tools/perf/util/stat-display.c                     | 19 ++---
 tools/testing/selftests/exec/Makefile              |  2 +-
 tools/testing/selftests/futex/Makefile             |  4 +-
 .../selftests/netfilter/nft_concat_range.sh        | 72 ++++++++++++++++-
 76 files changed, 772 insertions(+), 323 deletions(-)


