Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E76D4ABA6E
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 12:28:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383712AbiBGLX1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 06:23:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236876AbiBGLK6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 06:10:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1562DC0401C0;
        Mon,  7 Feb 2022 03:10:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9CE4461261;
        Mon,  7 Feb 2022 11:10:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50E36C004E1;
        Mon,  7 Feb 2022 11:10:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644232256;
        bh=xLCuewTVYwiwGxcUkIzTEdLtR80kHLoDcOsrAWZPSPA=;
        h=From:To:Cc:Subject:Date:From;
        b=vBu3tWUQ6CbpjTxbIV6GYMUn+9cyAX5oWtqMKcqqZN2ZX4obNwBvSJ5iszRrcE7VK
         G70Klr789PM3fe8JHcyMV1Y+jH6jj/qayj4t4lVZAPh3GSGKX488fyk4e0+pFVx3SW
         SAySKPQZSpnTfTET8v8ZRdxxYuY64mDgGMunbrQk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Subject: [PATCH 4.14 00/69] 4.14.265-rc1 review
Date:   Mon,  7 Feb 2022 12:05:22 +0100
Message-Id: <20220207103755.604121441@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.265-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.14.265-rc1
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

This is the start of the stable review cycle for the 4.14.265 release.
There are 69 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 09 Feb 2022 10:37:42 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.265-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.14.265-rc1

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

Miaoqian Lin <linmq006@gmail.com>
    ASoC: fsl: Add missing error handling in pcm030_fabric_probe

Dan Carpenter <dan.carpenter@oracle.com>
    drm/i915/overlay: Prevent divide by zero bugs in scaling

Lior Nahmanson <liorna@nvidia.com>
    net: macsec: Verify that send_sci is on when setting Tx sci explicitly

Miquel Raynal <miquel.raynal@bootlin.com>
    net: ieee802154: Return meaningful error codes from the netlink helpers

Miquel Raynal <miquel.raynal@bootlin.com>
    net: ieee802154: ca8210: Stop leaking skb's

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

Martin K. Petersen <martin.petersen@oracle.com>
    block: bio-integrity: Advance seed correctly for larger interval sizes

Nick Lopez <github@glowingmonkey.org>
    drm/nouveau: fix off by one in BIOS boundary checking

Mark Brown <broonie@kernel.org>
    ASoC: ops: Reject out of bounds values in snd_soc_put_xr_sx()

Mark Brown <broonie@kernel.org>
    ASoC: ops: Reject out of bounds values in snd_soc_put_volsw_sx()

Mark Brown <broonie@kernel.org>
    ASoC: ops: Reject out of bounds values in snd_soc_put_volsw()

Paul Moore <paul@paul-moore.com>
    audit: improve audit queue handling when "audit=1" on cmdline

Eric Dumazet <edumazet@google.com>
    af_packet: fix data-race in packet_setsockopt / packet_setsockopt

Eric Dumazet <edumazet@google.com>
    rtnetlink: make sure to refresh master_dev/m_ops in __rtnl_newlink()

Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
    net: amd-xgbe: Fix skb data length underflow

Raju Rangoju <Raju.Rangoju@amd.com>
    net: amd-xgbe: ensure to reset the tx_timer_active flag

Georgi Valkov <gvalkov@abv.bg>
    ipheth: fix EOVERFLOW in ipheth_rcvbulk_callback

Florian Westphal <fw@strlen.de>
    netfilter: nat: limit port clash resolution attempts

Florian Westphal <fw@strlen.de>
    netfilter: nat: remove l4 protocol port rovers

Daniel Borkmann <daniel@iogearbox.net>
    bpf: fix truncated jump targets on heavy expansions

Eric Dumazet <edumazet@google.com>
    ipv4: tcp: send zero IPID in SYNACK messages

Eric Dumazet <edumazet@google.com>
    ipv4: raw: lock the socket in raw_bind()

Hangyu Hua <hbh25y@gmail.com>
    yam: fix a memory leak in yam_siocdevprivate()

Sukadev Bhattiprolu <sukadev@linux.ibm.com>
    ibmvnic: don't spin in tasklet

José Expósito <jose.exposito89@gmail.com>
    drm/msm/dsi: invalid parameter check in msm_dsi_phy_enable

Xianting Tian <xianting.tian@linux.alibaba.com>
    drm/msm: Fix wrong size calculation

Jianguo Wu <wujianguo@chinatelecom.cn>
    net-procfs: show net devices bound packet types

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFSv4: nfs_atomic_open() can race when looking up a non-regular file

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFSv4: Handle case where the lookup of a directory fails

Guenter Roeck <linux@roeck-us.net>
    hwmon: (lm90) Reduce maximum conversion rate for G781

Eric Dumazet <edumazet@google.com>
    ipv4: avoid using shared IP generator for connected sockets

Xin Long <lucien.xin@gmail.com>
    ping: fix the sk_bound_dev_if match in ping_lookup

Congyu Liu <liu3101@purdue.edu>
    net: fix information leakage in /proc/net/ptype

Ido Schimmel <idosch@nvidia.com>
    ipv6_tunnel: Rate limit warning messages

John Meneghini <jmeneghi@redhat.com>
    scsi: bnx2fc: Flush destroy_work queue before calling bnx2fc_interface_put()

Matthias Kaehlcke <mka@chromium.org>
    rpmsg: char: Fix race between the release of rpmsg_eptdev and cdev

Sujit Kautkar <sujitka@chromium.org>
    rpmsg: char: Fix race between the release of rpmsg_ctrldev and cdev

Joe Damato <jdamato@fastly.com>
    i40e: fix unsigned stat widths

Jedrzej Jagielski <jedrzej.jagielski@intel.com>
    i40e: Increase delay to 1 s after global EMP reset

Christophe Leroy <christophe.leroy@csgroup.eu>
    lkdtm: Fix content of section containing lkdtm_rodata_do_nothing()

Christophe Leroy <christophe.leroy@csgroup.eu>
    powerpc/32: Fix boot failure with GCC latent entropy plugin

Marek Behún <kabel@kernel.org>
    net: sfp: ignore disabled SFP node

Badhri Jagan Sridharan <badhri@google.com>
    usb: typec: tcpm: Do not disconnect while receiving VBUS off

Alan Stern <stern@rowland.harvard.edu>
    USB: core: Fix hang in usb_kill_urb by adding memory barriers

Pavankumar Kondeti <quic_pkondeti@quicinc.com>
    usb: gadget: f_sourcesink: Fix isoc transfer for USB_SPEED_SUPER_PLUS

Jon Hunter <jonathanh@nvidia.com>
    usb: common: ulpi: Fix crash in ulpi_match()

Alan Stern <stern@rowland.harvard.edu>
    usb-storage: Add unusual-devs entry for VL817 USB-SATA bridge

Cameron Williams <cang1@live.co.uk>
    tty: Add support for Brainboxes UC cards.

daniel.starke@siemens.com <daniel.starke@siemens.com>
    tty: n_gsm: fix SW flow control encoding/handling

Valentin Caron <valentin.caron@foss.st.com>
    serial: stm32: fix software flow control transfer

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nft_payload: do not update layer 4 checksum when mangling fragments

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    PM: wakeup: simplify the output logic of pm_show_wakelocks()

Jan Kara <jack@suse.cz>
    udf: Fix NULL ptr deref when converting from inline format

Jan Kara <jack@suse.cz>
    udf: Restore i_lenAlloc when inode expansion fails

Steffen Maier <maier@linux.ibm.com>
    scsi: zfcp: Fix failed recovery on gone remote port with non-NPIV FCP devices

Vasily Gorbik <gor@linux.ibm.com>
    s390/hypfs: include z/VM guests with access control group set

Brian Gix <brian.gix@intel.com>
    Bluetooth: refactor malicious adv data check


-------------

Diffstat:

 Makefile                                        |   4 +-
 arch/powerpc/kernel/Makefile                    |   1 +
 arch/powerpc/lib/Makefile                       |   3 +
 arch/s390/hypfs/hypfs_vm.c                      |   6 +-
 block/bio-integrity.c                           |   2 +-
 drivers/edac/altera_edac.c                      |   2 +-
 drivers/edac/xgene_edac.c                       |   2 +-
 drivers/gpu/drm/i915/intel_overlay.c            |   3 +
 drivers/gpu/drm/msm/dsi/phy/dsi_phy.c           |   4 +-
 drivers/gpu/drm/msm/msm_drv.c                   |   2 +-
 drivers/gpu/drm/nouveau/nvkm/subdev/bios/base.c |   2 +-
 drivers/hwmon/lm90.c                            |   2 +-
 drivers/infiniband/hw/mlx4/main.c               |   2 +-
 drivers/iommu/amd_iommu_init.c                  |   2 +
 drivers/iommu/intel_irq_remapping.c             |  13 ++-
 drivers/misc/Makefile                           |   2 +-
 drivers/net/ethernet/amd/xgbe/xgbe-drv.c        |  14 +++-
 drivers/net/ethernet/ibm/ibmvnic.c              |   6 --
 drivers/net/ethernet/intel/i40e/i40e.h          |   8 +-
 drivers/net/ethernet/intel/i40e/i40e_debugfs.c  |   2 +-
 drivers/net/ethernet/intel/i40e/i40e_main.c     |  16 ++--
 drivers/net/hamradio/yam.c                      |   4 +-
 drivers/net/ieee802154/ca8210.c                 |   1 +
 drivers/net/macsec.c                            |   9 +++
 drivers/net/phy/phylink.c                       |   5 ++
 drivers/net/usb/ipheth.c                        |   6 +-
 drivers/rpmsg/rpmsg_char.c                      |  22 +-----
 drivers/rtc/rtc-mc146818-lib.c                  |   2 +-
 drivers/s390/scsi/zfcp_fc.c                     |  13 ++-
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c               |  41 +++++-----
 drivers/spi/spi-bcm-qspi.c                      |   2 +-
 drivers/spi/spi-meson-spicc.c                   |   5 ++
 drivers/spi/spi-mt65xx.c                        |   2 +-
 drivers/staging/typec/tcpm.c                    |   3 +-
 drivers/tty/n_gsm.c                             |   4 +-
 drivers/tty/serial/8250/8250_pci.c              | 100 +++++++++++++++++++++++-
 drivers/tty/serial/stm32-usart.c                |   2 +-
 drivers/usb/common/ulpi.c                       |   7 +-
 drivers/usb/core/hcd.c                          |  14 ++++
 drivers/usb/core/urb.c                          |  12 +++
 drivers/usb/gadget/function/f_sourcesink.c      |   1 +
 drivers/usb/storage/unusual_devs.h              |  10 +++
 fs/ext4/inline.c                                |  10 ++-
 fs/nfs/dir.c                                    |  18 +++++
 fs/nfsd/nfs4state.c                             |   4 +-
 fs/udf/inode.c                                  |   9 +--
 include/linux/netdevice.h                       |   1 +
 include/net/ip.h                                |  21 +++--
 include/net/netfilter/nf_nat_l4proto.h          |   2 +-
 kernel/audit.c                                  |  62 ++++++++++-----
 kernel/bpf/core.c                               |  59 ++++++++++++--
 kernel/power/wakelock.c                         |  12 +--
 net/bluetooth/hci_event.c                       |  10 +--
 net/core/filter.c                               |  11 ++-
 net/core/net-procfs.c                           |  38 ++++++++-
 net/core/rtnetlink.c                            |   6 +-
 net/ieee802154/nl802154.c                       |   8 +-
 net/ipv4/ip_output.c                            |  11 ++-
 net/ipv4/ping.c                                 |   3 +-
 net/ipv4/raw.c                                  |   5 +-
 net/ipv6/ip6_tunnel.c                           |   8 +-
 net/netfilter/nf_nat_proto_common.c             |  36 ++++++---
 net/netfilter/nf_nat_proto_dccp.c               |   5 +-
 net/netfilter/nf_nat_proto_sctp.c               |   5 +-
 net/netfilter/nf_nat_proto_tcp.c                |   5 +-
 net/netfilter/nf_nat_proto_udp.c                |  10 +--
 net/netfilter/nft_payload.c                     |   3 +
 net/packet/af_packet.c                          |  10 ++-
 sound/soc/fsl/pcm030-audio-fabric.c             |  11 ++-
 sound/soc/soc-ops.c                             |  29 ++++++-
 tools/testing/selftests/futex/Makefile          |   4 +-
 71 files changed, 562 insertions(+), 217 deletions(-)


