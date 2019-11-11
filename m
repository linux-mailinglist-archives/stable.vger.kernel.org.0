Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF279F7ACB
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 19:29:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726973AbfKKS3z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:29:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:45942 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726896AbfKKS3z (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:29:55 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BAB35214E0;
        Mon, 11 Nov 2019 18:29:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573496992;
        bh=N5GmlVgNi5jqYXq3ZDUKcqcYA7xQw0pizdMAwF1ezps=;
        h=From:To:Cc:Subject:Date:From;
        b=ebAlt6hLJsVMwgT120fHlLmaRewlDos59C4/rlF6O9DInmET9tyT8LEq4SvS5ngzq
         m0gVbMi5YBXM4tAVy9tr70eLNLn7lhBCe9/8hZ+EfdzIR/B7zbEMzEtn91q8zc6EPE
         hAH+BOxWjyfWthHvVGGE8SDvF6vFvtrz/o6tlgis=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.4 00/43] 4.4.201-stable review
Date:   Mon, 11 Nov 2019 19:28:14 +0100
Message-Id: <20191111181246.772983347@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.201-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.4.201-rc1
X-KernelTest-Deadline: 2019-11-13T18:13+00:00
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.4.201 release.
There are 43 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 13 Nov 2019 18:08:44 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.201-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.4.201-rc1

Tejun Heo <tj@kernel.org>
    cgroup,writeback: don't switch wbs immediately on dead wbs if the memcg is dead

Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
    mm/filemap.c: don't initiate writeback if mapping has no dirty pages

Joakim Zhang <qiangqing.zhang@nxp.com>
    can: flexcan: disable completely the ECC mechanism

Wenwen Wang <wenwen@cs.uga.edu>
    e1000: fix memory leaks

Manfred Rudigier <manfred.rudigier@omicronenergy.com>
    igb: Fix constant media auto sense switching when no cable is connected

Trond Myklebust <trondmy@gmail.com>
    NFSv4: Don't allow a cached open with a revoked delegation

Jiangfeng Xiao <xiaojiangfeng@huawei.com>
    net: hisilicon: Fix "Trying to free already-free IRQ"

Nicholas Piggin <npiggin@gmail.com>
    scsi: qla2xxx: stop timer in shutdown path

Alan Stern <stern@rowland.harvard.edu>
    USB: Skip endpoints with 0 maxpacket length

Kim Phillips <kim.phillips@amd.com>
    perf/x86/amd/ibs: Fix reading of the IBS OpData register and thus precise RIP validity

Peter Chen <peter.chen@nxp.com>
    usb: gadget: configfs: fix concurrent issue between composite APIs

Chandana Kishori Chiluveru <cchiluve@codeaurora.org>
    usb: gadget: composite: Fix possible double free memory bug

Cristian Birsan <cristian.birsan@microchip.com>
    usb: gadget: udc: atmel: Fix interrupt storm in FIFO mode.

Nikhil Badola <nikhil.badola@freescale.com>
    usb: fsl: Check memory resource before releasing it

Taehee Yoo <ap420073@gmail.com>
    bonding: fix unexpected IFF_BONDING bit unset

Eric Dumazet <edumazet@google.com>
    ipvs: move old_secure_tcp into struct netns_ipvs

Daniel Wagner <dwagner@suse.de>
    scsi: lpfc: Honor module parameter lpfc_use_adisc

Hannes Reinecke <hare@suse.com>
    scsi: qla2xxx: fixup incorrect usage of host_byte

Vidya Sagar <vidyas@nvidia.com>
    PCI: tegra: Enable Relaxed Ordering only for Tegra20 & Tegra30

Al Viro <viro@zeniv.linux.org.uk>
    configfs: fix a deadlock in configfs_symlink()

Gustavo A. R. Silva <garsilva@embeddedor.com>
    drivers: usb: usbip: Add missing break statement to switch

Johan Hovold <johan@kernel.org>
    can: peak_usb: fix slab info leak

Navid Emamdoost <navid.emamdoost@gmail.com>
    can: gs_usb: gs_can_open(): prevent memory leak

Stephane Grosjean <s.grosjean@peak-system.com>
    can: peak_usb: fix a potential out-of-sync while decoding packets

Kurt Van Dijck <dev.kurt@vandijck-laurijssen.be>
    can: c_can: c_can_poll(): only read status register after status IRQ

Johan Hovold <johan@kernel.org>
    can: usb_8dev: fix use-after-free on disconnect

Dan Carpenter <dan.carpenter@oracle.com>
    netfilter: ipset: Fix an error code in ip_set_sockfn_get()

Lukas Wunner <lukas@wunner.de>
    netfilter: nf_tables: Align nft_expr private data to 64-bit

Alexandru Ardelean <alexandru.ardelean@analog.com>
    iio: imu: adis16480: make sure provided frequency is positive

Luis Henriques <lhenriques@suse.com>
    ceph: fix use-after-free in __ceph_remove_cap()

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: fix si_enable_smc_cac() failed issue

Jiri Olsa <jolsa@kernel.org>
    perf tools: Fix time sorting

Kevin Hao <haokexin@gmail.com>
    dump_stack: avoid the livelock of the dump_lock

Michal Hocko <mhocko@suse.com>
    mm, vmstat: hide /proc/pagetypeinfo from normal users

Mel Gorman <mgorman@techsingularity.net>
    mm, meminit: recalculate pcpu batch and high limits after init completes

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/ca0132 - Fix possible workqueue stall

Takashi Sakamoto <o-takashi@sakamocchi.jp>
    ALSA: bebob: fix to detect configured source of sampling clock for Focusrite Saffire Pro i/o series

Pan Bian <bianpan2016@163.com>
    nfc: netlink: fix double device reference drop

Manish Chopra <manishc@marvell.com>
    qede: fix NULL pointer deref in __qede_remove()

Pan Bian <bianpan2016@163.com>
    NFC: st21nfca: fix double free

Pan Bian <bianpan2016@163.com>
    NFC: fdp: fix incorrect free object

Eric Dumazet <edumazet@google.com>
    net: fix data-race in neigh_event_send()

Oliver Neukum <oneukum@suse.com>
    CDC-NCM: handle incomplete transfer of MTU


-------------

Diffstat:

 Makefile                                         |   4 +-
 arch/x86/kernel/cpu/perf_event_amd_ibs.c         |   2 +-
 drivers/gpu/drm/radeon/si_dpm.c                  |   1 +
 drivers/iio/imu/adis16480.c                      |   5 +-
 drivers/net/bonding/bond_main.c                  |   6 +-
 drivers/net/can/c_can/c_can.c                    |  25 ++++--
 drivers/net/can/c_can/c_can.h                    |   1 +
 drivers/net/can/flexcan.c                        |   1 +
 drivers/net/can/usb/gs_usb.c                     |   1 +
 drivers/net/can/usb/peak_usb/pcan_usb.c          |  17 ++--
 drivers/net/can/usb/peak_usb/pcan_usb_core.c     |   2 +-
 drivers/net/can/usb/usb_8dev.c                   |   3 +-
 drivers/net/ethernet/hisilicon/hip04_eth.c       |   1 -
 drivers/net/ethernet/intel/e1000/e1000_ethtool.c |   7 +-
 drivers/net/ethernet/intel/igb/igb_main.c        |   3 +-
 drivers/net/ethernet/qlogic/qede/qede_main.c     |  12 ++-
 drivers/net/usb/cdc_ncm.c                        |   6 +-
 drivers/nfc/fdp/i2c.c                            |   2 +-
 drivers/nfc/st21nfca/core.c                      |   1 +
 drivers/pci/host/pci-tegra.c                     |   7 +-
 drivers/scsi/lpfc/lpfc_nportdisc.c               |   4 +-
 drivers/scsi/qla2xxx/qla_bsg.c                   |   6 +-
 drivers/scsi/qla2xxx/qla_os.c                    |   4 +
 drivers/usb/core/config.c                        |   5 ++
 drivers/usb/gadget/composite.c                   |   4 +
 drivers/usb/gadget/configfs.c                    | 110 +++++++++++++++++++++--
 drivers/usb/gadget/udc/atmel_usba_udc.c          |   6 +-
 drivers/usb/gadget/udc/fsl_udc_core.c            |   2 +-
 drivers/usb/usbip/vhci_hcd.c                     |   1 +
 fs/ceph/caps.c                                   |  10 +--
 fs/configfs/symlink.c                            |  33 ++++++-
 fs/fs-writeback.c                                |   9 +-
 fs/nfs/delegation.c                              |  10 +++
 fs/nfs/delegation.h                              |   1 +
 fs/nfs/nfs4proc.c                                |   7 +-
 include/net/ip_vs.h                              |   1 +
 include/net/neighbour.h                          |   4 +-
 include/net/netfilter/nf_tables.h                |   3 +-
 lib/dump_stack.c                                 |   7 +-
 mm/filemap.c                                     |   3 +-
 mm/page_alloc.c                                  |  10 ++-
 mm/vmstat.c                                      |   2 +-
 net/netfilter/ipset/ip_set_core.c                |   8 +-
 net/netfilter/ipvs/ip_vs_ctl.c                   |  15 ++--
 net/nfc/netlink.c                                |   2 -
 sound/firewire/bebob/bebob_focusrite.c           |   3 +
 sound/pci/hda/patch_ca0132.c                     |   2 +-
 tools/perf/util/hist.c                           |   2 +-
 48 files changed, 298 insertions(+), 83 deletions(-)


