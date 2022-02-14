Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD67D4B460F
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 10:33:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243204AbiBNJ3M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 04:29:12 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243007AbiBNJ27 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 04:28:59 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 183FD60A97;
        Mon, 14 Feb 2022 01:28:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AD43360F6F;
        Mon, 14 Feb 2022 09:28:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B622C340E9;
        Mon, 14 Feb 2022 09:28:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644830930;
        bh=pctznUB60Kwv58EBGgOgXAvfVVyXYnIT+Vvb1HCwFEQ=;
        h=From:To:Cc:Subject:Date:From;
        b=urrGeb/k2QLuIA0M73+AabDErfLFhu9JOh2DbJ0cEd3dZXEYVyBCOID5qmj2YTkjc
         ll/bexNh5+Ja4ewY0JkdTYaM+C/u9T6U9ia3XTPf+H177oa4QFoEYAeHf72k55xxXe
         JIsDL0dN81rdZkObPo+//xn7bpcqTD7p2U1ZETVc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Subject: [PATCH 4.9 00/34] 4.9.302-rc1 review
Date:   Mon, 14 Feb 2022 10:25:26 +0100
Message-Id: <20220214092445.946718557@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.302-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.9.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.9.302-rc1
X-KernelTest-Deadline: 2022-02-16T09:24+00:00
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

This is the start of the stable review cycle for the 4.9.302 release.
There are 34 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 16 Feb 2022 09:24:36 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.302-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.9.302-rc1

Armin Wolf <W_Armin@gmx.de>
    hwmon: (dell-smm) Speed up setting of fan speed

Johan Hovold <johan@kernel.org>
    USB: serial: cp210x: add CPI Bulk Coin Recycler id

Johan Hovold <johan@kernel.org>
    USB: serial: cp210x: add NCR Retail IO box id

Stephan Brunner <s.brunner@stephan-brunner.net>
    USB: serial: ch341: add support for GW Instek USB2.0-Serial devices

Pawel Dembicki <paweldembicki@gmail.com>
    USB: serial: option: add ZTE MF286D modem

Cameron Williams <cang1@live.co.uk>
    USB: serial: ftdi_sio: add support for Brainboxes US-159/235/320

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    usb: gadget: rndis: check size of RNDIS_MSG_SET command

Szymon Heidrich <szymon.heidrich@gmail.com>
    USB: gadget: validate interface OS descriptor requests

Udipto Goswami <quic_ugoswami@quicinc.com>
    usb: dwc3: gadget: Prevent core from processing stale TRBs

TATSUKAWA KOSUKE (立川 江介) <tatsu-ab1@nec.com>
    n_tty: wake up poll(POLLRDNORM) on receiving data

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Add kconfig knob for disabling unpriv bpf by default

Jakob Koschel <jakobkoschel@gmail.com>
    vt_ioctl: add array_index_nospec to VT_ACTIVATE

Jakob Koschel <jakobkoschel@gmail.com>
    vt_ioctl: fix array_index_nospec in vt_setactivate

Jon Maloy <jmaloy@redhat.com>
    tipc: rate limit warning for received illegal binding update

Antoine Tenart <atenart@kernel.org>
    net: fix a memleak when uncloning an skb dst and its metadata

Antoine Tenart <atenart@kernel.org>
    net: do not keep the dst cache when uncloning an skb dst and its metadata

Eric Dumazet <edumazet@google.com>
    ipmr,ip6mr: acquire RTNL before calling ip[6]mr_free_table() on failure path

Mahesh Bandewar <maheshb@google.com>
    bonding: pair enable_port with slave_arr_updates

Fabio Estevam <festevam@gmail.com>
    ARM: dts: imx6qdl-udoo: Properly describe the SD card detect

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    staging: fbtft: Fix error path in fbtft_driver_module_init()

Fabio Estevam <festevam@gmail.com>
    ARM: dts: imx23-evk: Remove MX23_PAD_SSP1_DETECT from hog group

Amelie Delaunay <amelie.delaunay@foss.st.com>
    usb: dwc2: gadget: don't try to disable ep0 in dwc2_hsotg_suspend

ZouMingzhe <mingzhe.zou@easystack.cn>
    scsi: target: iscsi: Make sure the np under each tpg is unique

Olga Kornievskaia <kolga@netapp.com>
    NFSv4 remove zero number of fs_locations entries error check

Xiaoke Wang <xkernel.wang@foxmail.com>
    nfs: nfs4clinet: check the return value of kstrdup()

Olga Kornievskaia <kolga@netapp.com>
    NFSv4 only print the label when its queried

Guillaume Bertholon <guillaume.bertholon@ens.fr>
    Revert "net: axienet: Wait for PhyRstCmplt after core reset"

Guillaume Bertholon <guillaume.bertholon@ens.fr>
    ALSA: line6: Fix misplaced backport of "Fix wrong altsetting for LINE6_PODHD500_1"

Guillaume Bertholon <guillaume.bertholon@ens.fr>
    serial: sh-sci: Fix misplaced backport of "Fix late enablement of AUTORTS"

Guillaume Bertholon <guillaume.bertholon@ens.fr>
    Input: i8042 - Fix misplaced backport of "add ASUS Zenbook Flip to noselftest list"

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Clamp WRITE offsets

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFS: Fix initialisation of nfs_client cl_flags field

Stefan Berger <stefanb@linux.ibm.com>
    ima: Remove ima_policy file before directory

Xiaoke Wang <xkernel.wang@foxmail.com>
    integrity: check the return value of audit_log_start()


-------------

Diffstat:

 Documentation/sysctl/kernel.txt                   | 21 ++++++++++++++++
 Makefile                                          |  4 ++--
 arch/arm/boot/dts/imx23-evk.dts                   |  1 -
 arch/arm/boot/dts/imx6qdl-udoo.dtsi               |  5 +++-
 drivers/hwmon/dell-smm-hwmon.c                    | 12 ++++++----
 drivers/input/serio/i8042-x86ia64io.h             | 11 +++++----
 drivers/net/bonding/bond_3ad.c                    |  3 ++-
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c | 10 --------
 drivers/staging/fbtft/fbtft.h                     |  5 +++-
 drivers/target/iscsi/iscsi_target_tpg.c           |  3 +++
 drivers/tty/n_tty.c                               |  4 ++--
 drivers/tty/serial/sh-sci.c                       |  8 +++----
 drivers/tty/vt/vt_ioctl.c                         |  5 ++--
 drivers/usb/dwc2/gadget.c                         |  2 +-
 drivers/usb/dwc3/gadget.c                         | 13 ++++++++++
 drivers/usb/gadget/composite.c                    |  3 +++
 drivers/usb/gadget/function/rndis.c               |  9 ++++---
 drivers/usb/serial/ch341.c                        |  1 +
 drivers/usb/serial/cp210x.c                       |  2 ++
 drivers/usb/serial/ftdi_sio.c                     |  3 +++
 drivers/usb/serial/ftdi_sio_ids.h                 |  3 +++
 drivers/usb/serial/option.c                       |  2 ++
 fs/nfs/client.c                                   |  2 +-
 fs/nfs/nfs4client.c                               |  5 +++-
 fs/nfs/nfs4state.c                                |  3 +++
 fs/nfs/nfs4xdr.c                                  |  9 ++++---
 fs/nfsd/nfs3proc.c                                |  5 ++++
 fs/nfsd/nfs4proc.c                                |  5 ++--
 include/net/dst_metadata.h                        | 14 ++++++++++-
 init/Kconfig                                      | 10 ++++++++
 kernel/bpf/syscall.c                              |  3 ++-
 kernel/sysctl.c                                   | 29 +++++++++++++++++++----
 net/ipv4/ipmr.c                                   |  2 ++
 net/ipv6/ip6mr.c                                  |  2 ++
 net/tipc/name_distr.c                             |  2 +-
 security/integrity/ima/ima_fs.c                   |  2 +-
 security/integrity/integrity_audit.c              |  2 ++
 sound/usb/line6/podhd.c                           |  4 ++--
 38 files changed, 173 insertions(+), 56 deletions(-)


