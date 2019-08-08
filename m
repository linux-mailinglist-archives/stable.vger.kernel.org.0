Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 57770869D7
	for <lists+stable@lfdr.de>; Thu,  8 Aug 2019 21:11:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405478AbfHHTLZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Aug 2019 15:11:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:45974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405476AbfHHTLZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 8 Aug 2019 15:11:25 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 221202173E;
        Thu,  8 Aug 2019 19:11:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565291483;
        bh=/uu9e5gNxHHedZgQxb6JDIVEsarNFGlltB2IAoxex0E=;
        h=From:To:Cc:Subject:Date:From;
        b=Cg/alxv3uXe986ZRNDbVUSW8h3poDpk4om6WPYubhGDq5TNuCOK5KEIn1bYRXo5hG
         2+3GfhApkZMd217z2/kHPTnS+92/y600xyKHVKiX6urbSd8Jrjm2bd2btvu6y8mFpA
         uhiwzvFpnckZQHi8Pi0GlsbXjq/CYd3/oUl7OX9Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.14 00/33] 4.14.138-stable review
Date:   Thu,  8 Aug 2019 21:05:07 +0200
Message-Id: <20190808190453.582417307@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.138-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.14.138-rc1
X-KernelTest-Deadline: 2019-08-10T19:04+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.14.138 release.
There are 33 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat 10 Aug 2019 07:03:19 PM UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.138-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.14.138-rc1

Lukas Wunner <lukas@wunner.de>
    spi: bcm2835: Fix 3-wire mode if DMA is enabled

Tejun Heo <tj@kernel.org>
    cgroup: Fix css_task_iter_advance_css_set() cset skip condition

Tejun Heo <tj@kernel.org>
    cgroup: css_task_iter_skip()'d iterators must be advanced before accessed

Tejun Heo <tj@kernel.org>
    cgroup: Include dying leaders with live threads in PROCS iterations

Tejun Heo <tj@kernel.org>
    cgroup: Implement css_task_iter_skip()

Tejun Heo <tj@kernel.org>
    cgroup: Call cgroup_release() before __exit_signal()

Sudarsana Reddy Kalluru <skalluru@marvell.com>
    bnx2x: Disable multi-cos feature.

Matteo Croce <mcroce@redhat.com>
    mvpp2: refactor MTU change code

Alexis Bauvin <abauvin@scaleway.com>
    tun: mark small packets as owned by the tap sock

Ariel Levkovich <lariel@mellanox.com>
    net/mlx5e: Prevent encap flow counter update async to user query

Arnd Bergmann <arnd@arndb.de>
    compat_ioctl: pppoe: fix PPPOEIOCSFWD handling

Taras Kondratiuk <takondra@cisco.com>
    tipc: compat: allow tipc commands without arguments

Johan Hovold <johan@kernel.org>
    NFC: nfcmrvl: fix gpio-handling regression

Jia-Ju Bai <baijiaju1990@gmail.com>
    net: sched: Fix a possible null-pointer dereference in dequeue_func()

René van Dorst <opensource@vdorst.com>
    net: phylink: Fix flow control for fixed-link

Mark Zhang <markz@mellanox.com>
    net/mlx5: Use reversed order when unregister devices

Jiri Pirko <jiri@mellanox.com>
    net: fix ifindex collision during namespace removal

Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
    net: bridge: mcast: don't delete permanent entries when fast leave is enabled

Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
    net: bridge: delete local fdb on device init failure

Haishuang Yan <yanhaishuang@cmss.chinamobile.com>
    ip6_tunnel: fix possible use-after-free on xmit

Cong Wang <xiyou.wangcong@gmail.com>
    ife: error out when nla attributes are empty

Gustavo A. R. Silva <gustavo@embeddedor.com>
    atm: iphase: Fix Spectre v1 vulnerability

Josh Poimboeuf <jpoimboe@redhat.com>
    objtool: Add rewind_stack_do_exit() to the noreturn list

Josh Poimboeuf <jpoimboe@redhat.com>
    objtool: Add machine_real_restart() to the noreturn list

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    IB: directly cast the sockaddr union to aockaddr

Jason Gunthorpe <jgg@mellanox.com>
    RDMA: Directly cast the sockaddr union to sockaddr

Sebastian Parschauer <s.parschauer@gmx.de>
    HID: Add quirk for HP X1200 PIXART OEM mouse

Aaron Armstrong Skomra <skomra@gmail.com>
    HID: wacom: fix bit shift for Cintiq Companion 2

Will Deacon <will@kernel.org>
    arm64: cpufeature: Fix feature comparison for CTR_EL0.{CWG,ERG}

Eric Dumazet <edumazet@google.com>
    tcp: be more careful in tcp_fragment()

Adam Ford <aford173@gmail.com>
    ARM: dts: Add pinmuxing for i2c2 and i2c3 for LogicPD torpedo

Adam Ford <aford173@gmail.com>
    ARM: dts: Add pinmuxing for i2c2 and i2c3 for LogicPD SOM-LV

Hannes Reinecke <hare@suse.de>
    scsi: fcoe: Embed fc_rport_priv in fcoe_rport structure


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/arm/boot/dts/logicpd-som-lv.dtsi              |  16 ++++
 arch/arm/boot/dts/logicpd-torpedo-som.dtsi         |  16 ++++
 arch/arm64/include/asm/cpufeature.h                |   7 +-
 arch/arm64/kernel/cpufeature.c                     |   8 +-
 drivers/atm/iphase.c                               |   8 +-
 drivers/hid/hid-ids.h                              |   1 +
 drivers/hid/usbhid/hid-quirks.c                    |   1 +
 drivers/hid/wacom_wac.c                            |  12 +--
 drivers/infiniband/core/addr.c                     |  15 ++-
 drivers/infiniband/core/sa_query.c                 |  10 +-
 drivers/infiniband/hw/ocrdma/ocrdma_ah.c           |   5 +-
 drivers/infiniband/hw/ocrdma/ocrdma_hw.c           |   5 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c    |   2 +-
 drivers/net/ethernet/marvell/mvpp2.c               |  41 +++-----
 drivers/net/ethernet/mellanox/mlx5/core/dev.c      |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    |   4 +-
 .../net/ethernet/mellanox/mlx5/core/fs_counters.c  |   5 +
 drivers/net/phy/phylink.c                          |   2 +
 drivers/net/ppp/pppoe.c                            |   3 +
 drivers/net/ppp/pppox.c                            |  13 +++
 drivers/net/ppp/pptp.c                             |   3 +
 drivers/net/tun.c                                  |   1 +
 drivers/nfc/nfcmrvl/main.c                         |   4 +-
 drivers/nfc/nfcmrvl/uart.c                         |   4 +-
 drivers/nfc/nfcmrvl/usb.c                          |   1 +
 drivers/scsi/fcoe/fcoe_ctlr.c                      |  51 ++++------
 drivers/scsi/libfc/fc_rport.c                      |   5 +-
 drivers/spi/spi-bcm2835.c                          |   3 +-
 fs/compat_ioctl.c                                  |   3 -
 include/linux/cgroup-defs.h                        |   1 +
 include/linux/cgroup.h                             |   4 +
 include/linux/if_pppox.h                           |   3 +
 include/linux/mlx5/fs.h                            |   1 +
 include/net/tcp.h                                  |  17 ++++
 include/scsi/libfcoe.h                             |   1 +
 kernel/cgroup/cgroup.c                             | 106 +++++++++++++++------
 kernel/exit.c                                      |   2 +-
 net/bridge/br_multicast.c                          |   3 +
 net/bridge/br_vlan.c                               |   5 +
 net/core/dev.c                                     |   2 +
 net/ipv4/tcp_output.c                              |  11 ++-
 net/ipv6/ip6_tunnel.c                              |   6 +-
 net/l2tp/l2tp_ppp.c                                |   3 +
 net/sched/act_ife.c                                |   3 +
 net/sched/sch_codel.c                              |   6 +-
 net/tipc/netlink_compat.c                          |  11 ++-
 tools/objtool/check.c                              |   2 +
 48 files changed, 293 insertions(+), 149 deletions(-)


