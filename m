Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3404B4ABB65
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 12:38:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350649AbiBGL2R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 06:28:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240031AbiBGLT5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 06:19:57 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEB6EC043181;
        Mon,  7 Feb 2022 03:19:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 80D276077B;
        Mon,  7 Feb 2022 11:19:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 315C7C004E1;
        Mon,  7 Feb 2022 11:19:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644232795;
        bh=T8d6pg+SAnRE9VtixxjuM/Wh8N5tWvg2m1IuGyeDoiI=;
        h=From:To:Cc:Subject:Date:From;
        b=eCXaDjfBWhBd36VETtf08bdCEr7Khd7ZgBFuTE+rOmwXP1XMl9meguLVLExE0rE+Z
         +P9dLVU5pgogZH+5YxjK4cJZx1+mhlWMZIGvHJSSiuwUlQT62Of/LwhzoRLdf+0LfK
         dMCU3a0gh189zT2ekZBEDVwbTNxSTVN99aKrvjFk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Subject: [PATCH 5.4 00/44] 5.4.178-rc1 review
Date:   Mon,  7 Feb 2022 12:06:16 +0100
Message-Id: <20220207103753.155627314@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.178-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.178-rc1
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

This is the start of the stable review cycle for the 5.4.178 release.
There are 44 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 09 Feb 2022 10:37:42 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.178-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.4.178-rc1

Waiman Long <longman@redhat.com>
    cgroup/cpuset: Fix "suspicious RCU usage" lockdep warning

Ritesh Harjani <riteshh@linux.ibm.com>
    ext4: fix error handling in ext4_restore_inline_data()

Sergey Shtylyov <s.shtylyov@omp.ru>
    EDAC/xgene: Fix deferred probing

Sergey Shtylyov <s.shtylyov@omp.ru>
    EDAC/altera: Fix deferred probing

Riwen Lu <luriwen@kylinos.cn>
    rtc: cmos: Evaluate century appropriate

Muhammad Usama Anjum <usama.anjum@collabora.com>
    selftests: futex: Use variable MAKE instead of make

Dai Ngo <dai.ngo@oracle.com>
    nfsd: nfsd4_setclientid_confirm mistakenly expires confirmed client.

John Meneghini <jmeneghi@redhat.com>
    scsi: bnx2fc: Make bnx2fc_recv_frame() mp safe

Florian Fainelli <f.fainelli@gmail.com>
    pinctrl: bcm2835: Fix a few error paths

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

Miquel Raynal <miquel.raynal@bootlin.com>
    net: ieee802154: Return meaningful error codes from the netlink helpers

Miquel Raynal <miquel.raynal@bootlin.com>
    net: ieee802154: ca8210: Stop leaking skb's

Miquel Raynal <miquel.raynal@bootlin.com>
    net: ieee802154: mcr20a: Fix lifs/sifs periods

Miquel Raynal <miquel.raynal@bootlin.com>
    net: ieee802154: hwsim: Ensure proper channel selection at probe time

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

Leon Romanovsky <leonro@nvidia.com>
    RDMA/mlx4: Don't continue event handler after memory allocation failure

Bernard Metzler <bmt@zurich.ibm.com>
    RDMA/siw: Fix broken RDMA Read Fence/Resume logic.

Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>
    IB/rdmavt: Validate remote_addr during loopback atomic tests

Yutian Yang <nglaive@gmail.com>
    memcg: charge fs_context and legacy_fs_context

Guenter Roeck <linux@roeck-us.net>
    Revert "ASoC: mediatek: Check for error clk pointer"

Martin K. Petersen <martin.petersen@oracle.com>
    block: bio-integrity: Advance seed correctly for larger interval sizes

Lang Yu <lang.yu@amd.com>
    mm/kmemleak: avoid scanning potential huge holes

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
    ALSA: usb-audio: Simplify quirk entries with a macro

Mark Brown <broonie@kernel.org>
    ASoC: ops: Reject out of bounds values in snd_soc_put_xr_sx()

Mark Brown <broonie@kernel.org>
    ASoC: ops: Reject out of bounds values in snd_soc_put_volsw_sx()

Mark Brown <broonie@kernel.org>
    ASoC: ops: Reject out of bounds values in snd_soc_put_volsw()

Paul Moore <paul@paul-moore.com>
    audit: improve audit queue handling when "audit=1" on cmdline


-------------

Diffstat:

 Makefile                                           |  4 +-
 block/bio-integrity.c                              |  2 +-
 drivers/edac/altera_edac.c                         |  2 +-
 drivers/edac/xgene_edac.c                          |  2 +-
 drivers/gpu/drm/i915/display/intel_overlay.c       |  3 ++
 drivers/gpu/drm/nouveau/nvkm/subdev/bios/base.c    |  2 +-
 drivers/infiniband/hw/mlx4/main.c                  |  2 +-
 drivers/infiniband/sw/rdmavt/qp.c                  |  2 +
 drivers/infiniband/sw/siw/siw.h                    |  7 +--
 drivers/infiniband/sw/siw/siw_qp_rx.c              | 20 +++----
 drivers/iommu/amd_iommu_init.c                     |  2 +
 drivers/iommu/intel_irq_remapping.c                | 13 +++--
 drivers/net/ethernet/stmicro/stmmac/dwmac_dma.h    |  1 +
 .../net/ethernet/stmicro/stmmac/stmmac_ethtool.c   | 19 ++++++-
 .../net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c  | 19 ++++---
 drivers/net/ieee802154/ca8210.c                    |  1 +
 drivers/net/ieee802154/mac802154_hwsim.c           |  1 +
 drivers/net/ieee802154/mcr20a.c                    |  4 +-
 drivers/net/macsec.c                               |  9 ++++
 drivers/pinctrl/bcm/pinctrl-bcm2835.c              | 23 +++++---
 drivers/rtc/rtc-mc146818-lib.c                     |  2 +-
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c                  | 21 +++++---
 drivers/soc/mediatek/mtk-scpsys.c                  | 15 ++----
 drivers/spi/spi-bcm-qspi.c                         |  2 +-
 drivers/spi/spi-meson-spicc.c                      |  5 ++
 drivers/spi/spi-mt65xx.c                           |  2 +-
 fs/btrfs/qgroup.c                                  | 21 +++++++-
 fs/ext4/inline.c                                   | 10 +++-
 fs/fs_context.c                                    |  4 +-
 fs/nfsd/nfs4state.c                                |  4 +-
 kernel/audit.c                                     | 62 +++++++++++++++-------
 kernel/cgroup/cpuset.c                             | 10 ++++
 mm/kmemleak.c                                      | 13 ++---
 net/ieee802154/nl802154.c                          |  8 +--
 sound/pci/hda/patch_realtek.c                      |  6 ++-
 sound/soc/codecs/cpcap.c                           |  2 +
 sound/soc/codecs/max9759.c                         |  3 +-
 sound/soc/fsl/pcm030-audio-fabric.c                | 11 ++--
 sound/soc/soc-ops.c                                | 29 ++++++++--
 sound/soc/xilinx/xlnx_formatter_pcm.c              | 27 ++++++++--
 sound/usb/quirks-table.h                           | 10 ++++
 tools/testing/selftests/futex/Makefile             |  4 +-
 42 files changed, 295 insertions(+), 114 deletions(-)


