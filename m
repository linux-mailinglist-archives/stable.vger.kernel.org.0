Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC137126AC1
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 19:50:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730015AbfLSSuk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 13:50:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:44510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730008AbfLSSug (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Dec 2019 13:50:36 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A628D2064B;
        Thu, 19 Dec 2019 18:50:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576781435;
        bh=Qv7E2OuioSDxlU0VReXiZmlP7tE7UmrfQyW9nm3JkpA=;
        h=From:To:Cc:Subject:Date:From;
        b=TiIdvOKrTb7Bvu+TvWOP7p8HdFnDBgiV08d5824kN++F6IEFQaJDWxdVcZM0PTY7g
         zCR7r1qJO/2Sga4mJ/feig/efuKgrz4q8ig3XE0WpOGc3SIca4gPn1QJJR2a2YQqT9
         jBaiiP5JLNKBzMBzSQdlBs/OTHOkdwJGceYoZsy0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.14 00/36] 4.14.160-stable review
Date:   Thu, 19 Dec 2019 19:34:17 +0100
Message-Id: <20191219182848.708141124@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.160-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.14.160-rc1
X-KernelTest-Deadline: 2019-12-21T18:29+00:00
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.14.160 release.
There are 36 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat, 21 Dec 2019 18:24:44 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.160-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.14.160-rc1

Aaro Koskinen <aaro.koskinen@nokia.com>
    net: stmmac: don't stop NAPI processing when dropping a packet

Aaro Koskinen <aaro.koskinen@nokia.com>
    net: stmmac: use correct DMA buffer size in the RX descriptor

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: fix USB3 device initiated resume race with roothub autosuspend

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: fix r1xx/r2xx register checker for POT textures

Bart Van Assche <bvanassche@acm.org>
    scsi: iscsi: Fix a potential deadlock in the timeout handler

Hou Tao <houtao1@huawei.com>
    dm btree: increase rebalance threshold in __rebalance2()

Navid Emamdoost <navid.emamdoost@gmail.com>
    dma-buf: Fix memory leak in sync_file_merge()

Jiang Yi <giangyi@amazon.com>
    vfio/pci: call irq_bypass_unregister_producer() before freeing irq

Dmitry Osipenko <digetx@gmail.com>
    ARM: tegra: Fix FLOW_CTLR_HALT register clobbering by tegra_resume()

Lihua Yao <ylhuajnu@outlook.com>
    ARM: dts: s3c64xx: Fix init order of clock providers

Pavel Shilovsky <pshilov@microsoft.com>
    CIFS: Respect O_SYNC and O_DIRECT flags during reconnect

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

Dexuan Cui <decui@microsoft.com>
    PCI/PM: Always return devices to D0 when thawing

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "regulator: Defer init completion for a while after late_initcall"

Ivan Bornyakov <brnkv.i1@gmail.com>
    nvme: host: core: fix precedence of ternary operator

Eric Dumazet <edumazet@google.com>
    inet: protect against too small mtu values.

Guillaume Nault <gnault@redhat.com>
    tcp: Protect accesses to .ts_recent_stamp with {READ,WRITE}_ONCE()

Guillaume Nault <gnault@redhat.com>
    tcp: tighten acceptance of ACKs not matching a child socket

Guillaume Nault <gnault@redhat.com>
    tcp: fix rejected syncookies due to stale timestamps

Taehee Yoo <ap420073@gmail.com>
    tipc: fix ordering of tipc module init and exit routine

Eric Dumazet <edumazet@google.com>
    tcp: md5: fix potential overestimation of TCP option space

Aaron Conole <aconole@redhat.com>
    openvswitch: support asymmetric conntrack

Mian Yousaf Kaukab <ykaukab@suse.de>
    net: thunderx: start phy before starting autonegotiation

Grygorii Strashko <grygorii.strashko@ti.com>
    net: ethernet: ti: cpsw: fix extra rx interrupt

Alexander Lobakin <alobakin@dlink.ru>
    net: dsa: fix flow dissection on Tx path

Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
    net: bridge: deny dev_set_mac_address() when unregistering


-------------

Diffstat:

 Makefile                                           |  4 +-
 arch/arm/boot/dts/s3c6410-mini6410.dts             |  4 ++
 arch/arm/boot/dts/s3c6410-smdk6410.dts             |  4 ++
 arch/arm/mach-tegra/reset-handler.S                |  6 +--
 arch/xtensa/mm/tlb.c                               |  4 +-
 drivers/dma-buf/sync_file.c                        |  2 +-
 drivers/gpu/drm/radeon/r100.c                      |  4 +-
 drivers/gpu/drm/radeon/r200.c                      |  4 +-
 drivers/md/persistent-data/dm-btree-remove.c       |  8 +++-
 drivers/net/ethernet/cavium/thunder/thunder_bgx.c  |  2 +-
 drivers/net/ethernet/stmicro/stmmac/common.h       |  2 +-
 drivers/net/ethernet/stmicro/stmmac/descs_com.h    | 22 +++++----
 drivers/net/ethernet/stmicro/stmmac/dwmac4_descs.c |  2 +-
 drivers/net/ethernet/stmicro/stmmac/enh_desc.c     | 10 ++--
 drivers/net/ethernet/stmicro/stmmac/norm_desc.c    | 10 ++--
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  | 22 +++++----
 drivers/net/ethernet/ti/cpsw.c                     |  2 +-
 drivers/nvme/host/core.c                           |  4 +-
 drivers/pci/msi.c                                  |  2 +-
 drivers/pci/pci-driver.c                           | 17 ++++---
 drivers/pci/quirks.c                               | 22 +++++----
 drivers/regulator/core.c                           | 42 +++++------------
 drivers/rpmsg/qcom_glink_native.c                  | 53 +++++++++++++++++-----
 drivers/rpmsg/qcom_glink_smem.c                    |  2 +-
 drivers/scsi/libiscsi.c                            |  4 +-
 drivers/usb/host/xhci-hub.c                        |  8 ++++
 drivers/usb/host/xhci-ring.c                       |  6 +--
 drivers/vfio/pci/vfio_pci_intrs.c                  |  2 +-
 fs/cifs/file.c                                     |  7 +++
 include/linux/netdevice.h                          |  5 ++
 include/linux/time.h                               | 13 ++++++
 include/net/ip.h                                   |  5 ++
 include/net/tcp.h                                  | 18 ++++++--
 net/bridge/br_device.c                             |  6 +++
 net/core/dev.c                                     |  3 +-
 net/core/flow_dissector.c                          |  5 +-
 net/ipv4/devinet.c                                 |  5 --
 net/ipv4/ip_output.c                               | 14 ++++--
 net/ipv4/tcp_output.c                              |  5 +-
 net/openvswitch/conntrack.c                        | 11 +++++
 net/tipc/core.c                                    | 29 ++++++------
 41 files changed, 257 insertions(+), 143 deletions(-)


