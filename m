Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA6B14A4124
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:02:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358578AbiAaLCW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:02:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358549AbiAaLBM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:01:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F8C6C0617BF;
        Mon, 31 Jan 2022 02:59:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6542DB82A57;
        Mon, 31 Jan 2022 10:59:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67408C340E8;
        Mon, 31 Jan 2022 10:59:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643626796;
        bh=CY4iVw/Fve4jTp/tVg9Hofq5cgBqELC0WKP1Hef4X5o=;
        h=From:To:Cc:Subject:Date:From;
        b=UdF2S80t+IZzxDQMyr+UAtoT0oCPNtCBlSTwJdsttAVP4+cDRQVvUZUwylnAw1Inl
         o6ctEDzWHEmq23aDWEzWIw0Yh/meaR7c7w8sGl7JpxkL1SA4UikDgrZ0dNDClwpnHm
         zjYqKGvNjmn/1ip6gHS7w5A6omBxYxdCS1dCo//c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com
Subject: [PATCH 5.4 00/64] 5.4.176-rc1 review
Date:   Mon, 31 Jan 2022 11:55:45 +0100
Message-Id: <20220131105215.644174521@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.176-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.176-rc1
X-KernelTest-Deadline: 2022-02-02T10:52+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.4.176 release.
There are 64 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 02 Feb 2022 10:51:59 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.176-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.4.176-rc1

OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
    block: Fix wrong offset in bio_truncate()

Amir Goldstein <amir73il@gmail.com>
    fsnotify: invalidate dcache before IN_DELETE event

Marc Kleine-Budde <mkl@pengutronix.de>
    dt-bindings: can: tcan4x5x: fix mram-cfg RX FIFO config

Eric Dumazet <edumazet@google.com>
    ipv4: remove sparse error in ip_neigh_gw4()

Eric Dumazet <edumazet@google.com>
    ipv4: tcp: send zero IPID in SYNACK messages

Eric Dumazet <edumazet@google.com>
    ipv4: raw: lock the socket in raw_bind()

Yufeng Mo <moyufeng@huawei.com>
    net: hns3: handle empty unknown interrupt for VF

Hangyu Hua <hbh25y@gmail.com>
    yam: fix a memory leak in yam_siocdevprivate()

Miaoqian Lin <linmq006@gmail.com>
    drm/msm/hdmi: Fix missing put_device() call in msm_hdmi_get_phy

Sukadev Bhattiprolu <sukadev@linux.ibm.com>
    ibmvnic: don't spin in tasklet

Sukadev Bhattiprolu <sukadev@linux.ibm.com>
    ibmvnic: init ->running_cap_crqs early

Guenter Roeck <linux@roeck-us.net>
    hwmon: (lm90) Mark alert as broken for MAX6654

David Howells <dhowells@redhat.com>
    rxrpc: Adjust retransmission backoff

Marek Behún <kabel@kernel.org>
    phylib: fix potential use-after-free

Robert Hancock <robert.hancock@calian.com>
    net: phy: broadcom: hook up soft_reset for BCM54616S

Florian Westphal <fw@strlen.de>
    netfilter: conntrack: don't increment invalid counter on NF_REPEAT

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFS: Ensure the server has an up to date ctime before renaming

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFS: Ensure the server has an up to date ctime before hardlinking

Eric Dumazet <edumazet@google.com>
    ipv6: annotate accesses to fn->fn_sernum

José Expósito <jose.exposito89@gmail.com>
    drm/msm/dsi: invalid parameter check in msm_dsi_phy_enable

Miaoqian Lin <linmq006@gmail.com>
    drm/msm/dsi: Fix missing put_device() call in dsi_get_phy

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

Guenter Roeck <linux@roeck-us.net>
    hwmon: (lm90) Mark alert as broken for MAX6680

Guenter Roeck <linux@roeck-us.net>
    hwmon: (lm90) Mark alert as broken for MAX6646/6647/6649

Congyu Liu <liu3101@purdue.edu>
    net: fix information leakage in /proc/net/ptype

sparkhuang <huangshaobo6@huawei.com>
    ARM: 9170/1: fix panic when kasan and kprobe are enabled

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

Sylwester Dziedziuch <sylwesterx.dziedziuch@intel.com>
    i40e: Fix queues reservation for XDP

Jedrzej Jagielski <jedrzej.jagielski@intel.com>
    i40e: Fix issue when maximum queues is exceeded

Jedrzej Jagielski <jedrzej.jagielski@intel.com>
    i40e: Increase delay to 1 s after global EMP reset

Christophe Leroy <christophe.leroy@csgroup.eu>
    powerpc/32: Fix boot failure with GCC latent entropy plugin

Marek Behún <kabel@kernel.org>
    net: sfp: ignore disabled SFP node

Sing-Han Chen <singhanc@nvidia.com>
    ucsi_ccg: Check DEV_INT bit only when starting CCG4

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

Robert Hancock <robert.hancock@calian.com>
    serial: 8250: of: Fix mapped region size when using reg-offset property

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nft_payload: do not update layer 4 checksum when mangling fragments

D Scott Phillips <scott@os.amperecomputing.com>
    arm64: errata: Fix exec handling in erratum 1418040 workaround

Lucas Stach <l.stach@pengutronix.de>
    drm/etnaviv: relax submit size limits

Amir Goldstein <amir73il@gmail.com>
    fsnotify: fix fsnotify hooks in pseudo filesystems

Tom Zanussi <zanussi@kernel.org>
    tracing: Don't inc err_log entry count if entry allocation fails

Xiaoke Wang <xkernel.wang@foxmail.com>
    tracing/histogram: Fix a potential memory leak for kstrdup()

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

 .../devicetree/bindings/net/can/tcan4x5x.txt       |   2 +-
 Makefile                                           |   4 +-
 arch/arm/probes/kprobes/Makefile                   |   3 +
 arch/arm64/kernel/process.c                        |  39 +++----
 arch/powerpc/kernel/Makefile                       |   1 +
 arch/powerpc/lib/Makefile                          |   3 +
 arch/s390/hypfs/hypfs_vm.c                         |   6 +-
 block/bio.c                                        |   3 +-
 drivers/gpu/drm/etnaviv/etnaviv_gem_submit.c       |   4 +-
 drivers/gpu/drm/msm/dsi/dsi.c                      |   7 +-
 drivers/gpu/drm/msm/dsi/phy/dsi_phy.c              |   4 +-
 drivers/gpu/drm/msm/hdmi/hdmi.c                    |   7 +-
 drivers/gpu/drm/msm/msm_drv.c                      |   2 +-
 drivers/hwmon/lm90.c                               |   7 +-
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  |   3 +-
 drivers/net/ethernet/ibm/ibmvnic.c                 | 112 +++++++++++++--------
 drivers/net/ethernet/intel/i40e/i40e.h             |   9 +-
 drivers/net/ethernet/intel/i40e/i40e_debugfs.c     |   2 +-
 drivers/net/ethernet/intel/i40e/i40e_main.c        |  44 ++++----
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c |  59 +++++++++++
 drivers/net/hamradio/yam.c                         |   4 +-
 drivers/net/phy/broadcom.c                         |   1 +
 drivers/net/phy/phy_device.c                       |   6 +-
 drivers/net/phy/phylink.c                          |   5 +
 drivers/rpmsg/rpmsg_char.c                         |  22 +---
 drivers/s390/scsi/zfcp_fc.c                        |  13 ++-
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c                  |  20 +---
 drivers/tty/n_gsm.c                                |   4 +-
 drivers/tty/serial/8250/8250_of.c                  |  11 +-
 drivers/tty/serial/8250/8250_pci.c                 | 100 +++++++++++++++++-
 drivers/tty/serial/stm32-usart.c                   |   2 +-
 drivers/usb/common/ulpi.c                          |   7 +-
 drivers/usb/core/hcd.c                             |  14 +++
 drivers/usb/core/urb.c                             |  12 +++
 drivers/usb/gadget/function/f_sourcesink.c         |   1 +
 drivers/usb/storage/unusual_devs.h                 |  10 ++
 drivers/usb/typec/tcpm/tcpm.c                      |   3 +-
 drivers/usb/typec/ucsi/ucsi_ccg.c                  |   2 +-
 fs/btrfs/ioctl.c                                   |   6 +-
 fs/configfs/dir.c                                  |   6 +-
 fs/devpts/inode.c                                  |   2 +-
 fs/namei.c                                         |  10 +-
 fs/nfs/dir.c                                       |  22 ++++
 fs/nfsd/nfsctl.c                                   |   5 +-
 fs/udf/inode.c                                     |   9 +-
 include/linux/fsnotify.h                           |  48 +++++++--
 include/linux/netdevice.h                          |   1 +
 include/net/ip.h                                   |  21 ++--
 include/net/ip6_fib.h                              |   2 +-
 include/net/route.h                                |   2 +-
 kernel/power/wakelock.c                            |  11 +-
 kernel/trace/trace.c                               |   3 +-
 kernel/trace/trace_events_hist.c                   |   1 +
 net/bluetooth/hci_event.c                          |  10 +-
 net/core/net-procfs.c                              |  38 ++++++-
 net/ipv4/ip_output.c                               |  11 +-
 net/ipv4/ping.c                                    |   3 +-
 net/ipv4/raw.c                                     |   5 +-
 net/ipv6/ip6_fib.c                                 |  23 +++--
 net/ipv6/ip6_tunnel.c                              |   8 +-
 net/ipv6/route.c                                   |   2 +-
 net/netfilter/nf_conntrack_core.c                  |   8 +-
 net/netfilter/nft_payload.c                        |   3 +
 net/packet/af_packet.c                             |   2 +
 net/rxrpc/call_event.c                             |   8 +-
 net/rxrpc/output.c                                 |   2 +-
 net/sunrpc/rpc_pipe.c                              |   4 +-
 67 files changed, 589 insertions(+), 245 deletions(-)


