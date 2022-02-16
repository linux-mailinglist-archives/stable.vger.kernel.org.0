Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 388294B8814
	for <lists+stable@lfdr.de>; Wed, 16 Feb 2022 13:50:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229479AbiBPMuv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Feb 2022 07:50:51 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232462AbiBPMuv (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Feb 2022 07:50:51 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB3692A4A04;
        Wed, 16 Feb 2022 04:50:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 751C1612DD;
        Wed, 16 Feb 2022 12:50:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31E24C340EF;
        Wed, 16 Feb 2022 12:50:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645015837;
        bh=J5VmsR41qmFAyFefPC95lmWDKqO7gLLmoR98DosdOLM=;
        h=From:To:Cc:Subject:Date:From;
        b=hE2FfU1XZ/gnl7dNm6X0YzMq8l3amHtu/kuGrJ0/BnpfEvjOrEwGR6n6SKpQZ2Iw6
         crSyl2XpntRpa4iNEmjDWwmvrc5G3AY+5Zf6AaiRgK726XDxgh6Iw84KL4ytXmG4ID
         Obmlpa87ZhcmZIs/YPNWVU9zkkt6+s1lE+PdEOHg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.14.267
Date:   Wed, 16 Feb 2022 13:50:30 +0100
Message-Id: <16450158304177@kroah.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.14.267 kernel.

All users of the 4.14 kernel series must upgrade.

The updated 4.14.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.14.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/sysctl/kernel.txt                   |   21 ++++++++
 Makefile                                          |    2 
 arch/arm/boot/dts/imx23-evk.dts                   |    1 
 arch/arm/boot/dts/imx6qdl-udoo.dtsi               |    5 +
 arch/arm/boot/dts/meson.dtsi                      |    8 +--
 drivers/hwmon/dell-smm-hwmon.c                    |   12 +++-
 drivers/mmc/host/sdhci-of-esdhc.c                 |    8 ++-
 drivers/net/bonding/bond_3ad.c                    |    3 -
 drivers/net/ethernet/amd/xgbe/xgbe-pci.c          |    3 +
 drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c |    2 
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c |   10 ---
 drivers/net/phy/marvell.c                         |    7 +-
 drivers/staging/fbtft/fbtft.h                     |    5 +
 drivers/target/iscsi/iscsi_target_tpg.c           |    3 +
 drivers/tty/n_tty.c                               |    4 -
 drivers/tty/vt/vt_ioctl.c                         |    5 +
 drivers/usb/common/ulpi.c                         |   10 ++-
 drivers/usb/dwc2/gadget.c                         |    2 
 drivers/usb/dwc3/gadget.c                         |   13 +++++
 drivers/usb/gadget/composite.c                    |    3 +
 drivers/usb/gadget/function/f_fs.c                |   56 ++++++++++++++++------
 drivers/usb/gadget/function/rndis.c               |    9 ++-
 drivers/usb/serial/ch341.c                        |    1 
 drivers/usb/serial/cp210x.c                       |    2 
 drivers/usb/serial/ftdi_sio.c                     |    3 +
 drivers/usb/serial/ftdi_sio_ids.h                 |    3 +
 drivers/usb/serial/option.c                       |    2 
 fs/nfs/callback.h                                 |    2 
 fs/nfs/callback_proc.c                            |    2 
 fs/nfs/callback_xdr.c                             |   18 +++----
 fs/nfs/client.c                                   |    2 
 fs/nfs/nfs4_fs.h                                  |    3 -
 fs/nfs/nfs4client.c                               |    5 +
 fs/nfs/nfs4namespace.c                            |    4 -
 fs/nfs/nfs4state.c                                |    3 +
 fs/nfs/nfs4xdr.c                                  |    9 +--
 fs/nfsd/nfs3proc.c                                |    5 +
 fs/nfsd/nfs4proc.c                                |    5 +
 include/net/dst_metadata.h                        |   14 +++++
 init/Kconfig                                      |   10 +++
 kernel/bpf/syscall.c                              |    3 -
 kernel/events/core.c                              |    4 -
 kernel/seccomp.c                                  |   10 +++
 kernel/sysctl.c                                   |   29 +++++++++--
 net/ipv4/ipmr.c                                   |    2 
 net/ipv6/ip6mr.c                                  |    2 
 net/tipc/name_distr.c                             |    2 
 security/integrity/ima/ima_fs.c                   |    2 
 security/integrity/ima/ima_template.c             |   10 ++-
 security/integrity/integrity_audit.c              |    2 
 50 files changed, 260 insertions(+), 91 deletions(-)

Amelie Delaunay (1):
      usb: dwc2: gadget: don't try to disable ep0 in dwc2_hsotg_suspend

Antoine Tenart (2):
      net: do not keep the dst cache when uncloning an skb dst and its metadata
      net: fix a memleak when uncloning an skb dst and its metadata

Armin Wolf (1):
      hwmon: (dell-smm) Speed up setting of fan speed

Cameron Williams (1):
      USB: serial: ftdi_sio: add support for Brainboxes US-159/235/320

Chuck Lever (1):
      NFSD: Clamp WRITE offsets

Daniel Borkmann (1):
      bpf: Add kconfig knob for disabling unpriv bpf by default

Eric Dumazet (1):
      ipmr,ip6mr: acquire RTNL before calling ip[6]mr_free_table() on failure path

Fabio Estevam (2):
      ARM: dts: imx23-evk: Remove MX23_PAD_SSP1_DETECT from hog group
      ARM: dts: imx6qdl-udoo: Properly describe the SD card detect

Greg Kroah-Hartman (2):
      usb: gadget: rndis: check size of RNDIS_MSG_SET command
      Linux 4.14.267

Jakob Koschel (2):
      vt_ioctl: fix array_index_nospec in vt_setactivate
      vt_ioctl: add array_index_nospec to VT_ACTIVATE

Jiasheng Jiang (1):
      mmc: sdhci-of-esdhc: Check for error num after setting mask

Jisheng Zhang (1):
      net: stmmac: dwmac-sun8i: use return val of readl_poll_timeout()

Johan Hovold (2):
      USB: serial: cp210x: add NCR Retail IO box id
      USB: serial: cp210x: add CPI Bulk Coin Recycler id

Jon Maloy (1):
      tipc: rate limit warning for received illegal binding update

Kees Cook (1):
      seccomp: Invalidate seccomp mode to catch death failures

Mahesh Bandewar (1):
      bonding: pair enable_port with slave_arr_updates

Martin Blumenstingl (1):
      ARM: dts: meson: Fix the UART compatible strings

Olga Kornievskaia (3):
      NFSv4 only print the label when its queried
      NFSv4 remove zero number of fs_locations entries error check
      NFSv4 expose nfs_parse_server_name function

Pavel Parkhomenko (1):
      net: phy: marvell: Fix MDI-x polarity setting in 88e1118-compatible PHYs

Pawel Dembicki (1):
      USB: serial: option: add ZTE MF286D modem

Raju Rangoju (1):
      net: amd-xgbe: disable interrupts during pci removal

Roberto Sassu (1):
      ima: Allow template selection with ima_template[_fmt]= after ima_hash=

Sasha Levin (1):
      Revert "net: axienet: Wait for PhyRstCmplt after core reset"

Sean Anderson (2):
      usb: ulpi: Move of_node_put to ulpi_dev_release
      usb: ulpi: Call of_node_put correctly

Song Liu (1):
      perf: Fix list corruption in perf_cgroup_switch()

Stefan Berger (1):
      ima: Remove ima_policy file before directory

Stephan Brunner (1):
      USB: serial: ch341: add support for GW Instek USB2.0-Serial devices

Szymon Heidrich (1):
      USB: gadget: validate interface OS descriptor requests

TATSUKAWA KOSUKE (立川 江介) (1):
      n_tty: wake up poll(POLLRDNORM) on receiving data

Trond Myklebust (2):
      NFS: Fix initialisation of nfs_client cl_flags field
      NFSv4.1: Fix uninitialised variable in devicenotify

Udipto Goswami (2):
      usb: f_fs: Fix use-after-free for epfile
      usb: dwc3: gadget: Prevent core from processing stale TRBs

Uwe Kleine-König (1):
      staging: fbtft: Fix error path in fbtft_driver_module_init()

Xiaoke Wang (2):
      integrity: check the return value of audit_log_start()
      nfs: nfs4clinet: check the return value of kstrdup()

ZouMingzhe (1):
      scsi: target: iscsi: Make sure the np under each tpg is unique

