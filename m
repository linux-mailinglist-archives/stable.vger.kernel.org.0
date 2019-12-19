Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7901C126AFC
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 19:53:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730136AbfLSSwy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 13:52:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:47568 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730097AbfLSSwu (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Dec 2019 13:52:50 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5C0D9227BF;
        Thu, 19 Dec 2019 18:52:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576781568;
        bh=woKZccQoLBP0IUC8gc0C/WI+qpKovcccYv2xm7A8gQk=;
        h=From:To:Cc:Subject:Date:From;
        b=Jj4LDf3Quxpb3mxrsw/ORipN82URt/8BaCqgK6A1kwkki/WFa4c7WxqtQwTDnwCPO
         qb7j1/PRnuVyXHJNMo/9wAPJD7oazcKgEYZuVJ3JCOxrvR2iRytBWzqRNEEw1mggki
         XqwKjUPEqfEGYbuDoCzKseA5v30QbKr0CfgiQsao=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.19 00/47] 4.19.91-stable review
Date:   Thu, 19 Dec 2019 19:34:14 +0100
Message-Id: <20191219182857.659088743@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.91-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.91-rc1
X-KernelTest-Deadline: 2019-12-21T18:29+00:00
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.19.91 release.
There are 47 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat, 21 Dec 2019 18:24:44 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.91-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.19.91-rc1

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: fix USB3 device initiated resume race with roothub autosuspend

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: fix r1xx/r2xx register checker for POT textures

Roman Bolshakov <r.bolshakov@yadro.com>
    scsi: qla2xxx: Change discovery state before PLOGI

Bart Van Assche <bvanassche@acm.org>
    scsi: iscsi: Fix a potential deadlock in the timeout handler

Hou Tao <houtao1@huawei.com>
    dm btree: increase rebalance threshold in __rebalance2()

Mike Snitzer <snitzer@redhat.com>
    dm mpath: remove harmful bio-based optimization

Martin Blumenstingl <martin.blumenstingl@googlemail.com>
    drm: meson: venc: cvbs: fix CVBS mode matching

Navid Emamdoost <navid.emamdoost@gmail.com>
    dma-buf: Fix memory leak in sync_file_merge()

Jiang Yi <giangyi@amazon.com>
    vfio/pci: call irq_bypass_unregister_producer() before freeing irq

Dmitry Osipenko <digetx@gmail.com>
    ARM: tegra: Fix FLOW_CTLR_HALT register clobbering by tegra_resume()

Lihua Yao <ylhuajnu@outlook.com>
    ARM: dts: s3c64xx: Fix init order of clock providers

Pavel Shilovsky <pshilov@microsoft.com>
    CIFS: Close open handle after interrupted close

Pavel Shilovsky <pshilov@microsoft.com>
    CIFS: Respect O_SYNC and O_DIRECT flags during reconnect

Long Li <longli@microsoft.com>
    cifs: Don't display RDMA transport on reconnect

Long Li <longli@microsoft.com>
    cifs: smbd: Return -EINVAL when the number of iovs exceeds SMBDIRECT_MAX_SGE

Long Li <longli@microsoft.com>
    cifs: smbd: Add messages on RDMA session destroy and reconnection

Long Li <longli@microsoft.com>
    cifs: smbd: Return -EAGAIN when transport is reconnecting

Bjorn Andersson <bjorn.andersson@linaro.org>
    rpmsg: glink: Free pending deferred work on remove

Bjorn Andersson <bjorn.andersson@linaro.org>
    rpmsg: glink: Don't send pending rx_done during remove

Chris Lew <clew@codeaurora.org>
    rpmsg: glink: Fix rpmsg_register_device err handling

Chris Lew <clew@codeaurora.org>
    rpmsg: glink: Put an extra reference during cleanup

Arun Kumar Neelakantam <aneela@codeaurora.org>
    rpmsg: glink: Fix use after free in open_ack TIMEOUT case

Arun Kumar Neelakantam <aneela@codeaurora.org>
    rpmsg: glink: Fix reuse intents memory leak issue

Chris Lew <clew@codeaurora.org>
    rpmsg: glink: Set tail pointer to 0 at end of FIFO

Max Filippov <jcmvbkbc@gmail.com>
    xtensa: fix TLB sanity checker

George Cherian <george.cherian@marvell.com>
    PCI: Apply Cavium ACS quirk to ThunderX2 and ThunderX3

Jian-Hong Pan <jian-hong@endlessm.com>
    PCI/MSI: Fix incorrect MSI-X masking on resume

Steffen Liebergeld <steffen.liebergeld@kernkonzept.com>
    PCI: Fix Intel ACS quirk UPDCR register address

Lukas Wunner <lukas@wunner.de>
    PCI: pciehp: Avoid returning prematurely from sysfs requests

Dexuan Cui <decui@microsoft.com>
    PCI/PM: Always return devices to D0 when thawing

Chaotian Jing <chaotian.jing@mediatek.com>
    mmc: block: Add CMD13 polling for MMC IOCTLS with R1B response

Chaotian Jing <chaotian.jing@mediatek.com>
    mmc: block: Make card_busy_detect() a bit more generic

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "arm64: preempt: Fix big-endian when checking preempt count in assembly"

Guillaume Nault <gnault@redhat.com>
    tcp: Protect accesses to .ts_recent_stamp with {READ,WRITE}_ONCE()

Guillaume Nault <gnault@redhat.com>
    tcp: tighten acceptance of ACKs not matching a child socket

Guillaume Nault <gnault@redhat.com>
    tcp: fix rejected syncookies due to stale timestamps

Huy Nguyen <huyn@mellanox.com>
    net/mlx5e: Query global pause state before setting prio2buffer

Taehee Yoo <ap420073@gmail.com>
    tipc: fix ordering of tipc module init and exit routine

Eric Dumazet <edumazet@google.com>
    tcp: md5: fix potential overestimation of TCP option space

Aaron Conole <aconole@redhat.com>
    openvswitch: support asymmetric conntrack

Mian Yousaf Kaukab <ykaukab@suse.de>
    net: thunderx: start phy before starting autonegotiation

Dust Li <dust.li@linux.alibaba.com>
    net: sched: fix dump qlen for sch_mq/sch_mqprio with NOLOCK subqueues

Grygorii Strashko <grygorii.strashko@ti.com>
    net: ethernet: ti: cpsw: fix extra rx interrupt

Alexander Lobakin <alobakin@dlink.ru>
    net: dsa: fix flow dissection on Tx path

Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
    net: bridge: deny dev_set_mac_address() when unregistering

Vladyslav Tarasiuk <vladyslavt@mellanox.com>
    mqprio: Fix out-of-bounds access in mqprio_dump

Eric Dumazet <edumazet@google.com>
    inet: protect against too small mtu values.


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/arm/boot/dts/s3c6410-mini6410.dts             |   4 +
 arch/arm/boot/dts/s3c6410-smdk6410.dts             |   4 +
 arch/arm/mach-tegra/reset-handler.S                |   6 +-
 arch/arm64/include/asm/assembler.h                 |   8 +-
 arch/arm64/kernel/entry.S                          |   6 +-
 arch/xtensa/mm/tlb.c                               |   4 +-
 drivers/dma-buf/sync_file.c                        |   2 +-
 drivers/gpu/drm/meson/meson_venc_cvbs.c            |  48 ++++---
 drivers/gpu/drm/radeon/r100.c                      |   4 +-
 drivers/gpu/drm/radeon/r200.c                      |   4 +-
 drivers/md/dm-mpath.c                              |  37 +----
 drivers/md/persistent-data/dm-btree-remove.c       |   8 +-
 drivers/mmc/core/block.c                           | 151 ++++++++-------------
 drivers/net/ethernet/cavium/thunder/thunder_bgx.c  |   2 +-
 .../ethernet/mellanox/mlx5/core/en/port_buffer.c   |  27 +++-
 drivers/net/ethernet/ti/cpsw.c                     |   2 +-
 drivers/pci/hotplug/pciehp.h                       |   2 +
 drivers/pci/hotplug/pciehp_ctrl.c                  |   6 +-
 drivers/pci/hotplug/pciehp_hpc.c                   |   2 +
 drivers/pci/msi.c                                  |   2 +-
 drivers/pci/pci-driver.c                           |  17 ++-
 drivers/pci/quirks.c                               |  22 +--
 drivers/rpmsg/qcom_glink_native.c                  |  53 ++++++--
 drivers/rpmsg/qcom_glink_smem.c                    |   2 +-
 drivers/scsi/libiscsi.c                            |   4 +-
 drivers/scsi/qla2xxx/qla_init.c                    |   1 +
 drivers/usb/host/xhci-hub.c                        |   8 ++
 drivers/usb/host/xhci-ring.c                       |   3 +-
 drivers/vfio/pci/vfio_pci_intrs.c                  |   2 +-
 fs/cifs/cifs_debug.c                               |   5 +
 fs/cifs/file.c                                     |   7 +
 fs/cifs/smb2misc.c                                 |  59 ++++++--
 fs/cifs/smb2pdu.c                                  |  16 ++-
 fs/cifs/smb2proto.h                                |   3 +
 fs/cifs/smbdirect.c                                |   8 +-
 fs/cifs/transport.c                                |   7 +-
 include/linux/netdevice.h                          |   5 +
 include/linux/time.h                               |  13 ++
 include/net/ip.h                                   |   5 +
 include/net/tcp.h                                  |  27 ++--
 net/bridge/br_device.c                             |   6 +
 net/core/dev.c                                     |   3 +-
 net/core/flow_dissector.c                          |   5 +-
 net/ipv4/devinet.c                                 |   5 -
 net/ipv4/ip_output.c                               |  13 +-
 net/ipv4/tcp_output.c                              |   5 +-
 net/openvswitch/conntrack.c                        |  11 ++
 net/sched/sch_mq.c                                 |   1 +
 net/sched/sch_mqprio.c                             |   3 +-
 net/tipc/core.c                                    |  29 ++--
 51 files changed, 416 insertions(+), 265 deletions(-)


