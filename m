Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 192D187BFB
	for <lists+stable@lfdr.de>; Fri,  9 Aug 2019 15:49:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407183AbfHINq7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Aug 2019 09:46:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:36788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2407169AbfHINq4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Aug 2019 09:46:56 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 906AE217F4;
        Fri,  9 Aug 2019 13:46:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565358415;
        bh=u3Ix3IFwQLRFKVaIdupUE+8P+maUiVt7S38iCrW3uDs=;
        h=From:To:Cc:Subject:Date:From;
        b=KP29PuqfTggxokfMmHnBlMg5XtFFYXm3P0sWjD/65TlJuL4KwmUkX0AZFjSdvphDy
         D+tBejQ4DuMzSCtC6bNYGVfaUN6o+TMYxKjewuHHPaRmOJjfiuQh8rdqnwUwczRc3D
         KU8AcDooz1KXLxr1qVH8dy2QxbHz3FB6B6TVnDWA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.9 00/32] 4.9.189-stable review
Date:   Fri,  9 Aug 2019 15:45:03 +0200
Message-Id: <20190809133922.945349906@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.189-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.9.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.9.189-rc1
X-KernelTest-Deadline: 2019-08-11T13:39+00:00
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.9.189 release.
There are 32 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun 11 Aug 2019 01:38:45 PM UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.189-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.9.189-rc1

Thomas Gleixner <tglx@linutronix.de>
    x86/speculation/swapgs: Exclude ATOMs from speculation through SWAPGS

Josh Poimboeuf <jpoimboe@redhat.com>
    x86/entry/64: Use JMP instead of JMPQ

Josh Poimboeuf <jpoimboe@redhat.com>
    x86/speculation: Enable Spectre v1 swapgs mitigations

Josh Poimboeuf <jpoimboe@redhat.com>
    x86/speculation: Prepare entry code for Spectre v1 swapgs mitigations

Ben Hutchings <ben@decadent.org.uk>
    x86: cpufeatures: Sort feature word 7

Lukas Wunner <lukas@wunner.de>
    spi: bcm2835: Fix 3-wire mode if DMA is enabled

xiao jin <jin.xiao@intel.com>
    block: blk_init_allocated_queue() set q->fq as NULL in the fail case

Sudarsana Reddy Kalluru <skalluru@marvell.com>
    bnx2x: Disable multi-cos feature.

Cong Wang <xiyou.wangcong@gmail.com>
    ife: error out when nla attributes are empty

Haishuang Yan <yanhaishuang@cmss.chinamobile.com>
    ip6_tunnel: fix possible use-after-free on xmit

Arnd Bergmann <arnd@arndb.de>
    compat_ioctl: pppoe: fix PPPOEIOCSFWD handling

Taras Kondratiuk <takondra@cisco.com>
    tipc: compat: allow tipc commands without arguments

Jia-Ju Bai <baijiaju1990@gmail.com>
    net: sched: Fix a possible null-pointer dereference in dequeue_func()

Mark Zhang <markz@mellanox.com>
    net/mlx5: Use reversed order when unregister devices

Jiri Pirko <jiri@mellanox.com>
    net: fix ifindex collision during namespace removal

Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
    net: bridge: mcast: don't delete permanent entries when fast leave is enabled

Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
    net: bridge: delete local fdb on device init failure

Gustavo A. R. Silva <gustavo@embeddedor.com>
    atm: iphase: Fix Spectre v1 vulnerability

Ilya Dryomov <idryomov@gmail.com>
    libceph: use kbasename() and kill ceph_file_part()

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

Eric Dumazet <edumazet@google.com>
    tcp: be more careful in tcp_fragment()

Will Deacon <will@kernel.org>
    arm64: cpufeature: Fix feature comparison for CTR_EL0.{CWG,ERG}

Will Deacon <will.deacon@arm.com>
    arm64: cpufeature: Fix CTR_EL0 field definitions

Adam Ford <aford173@gmail.com>
    ARM: dts: logicpd-som-lv: Fix Audio Mute

Adam Ford <aford173@gmail.com>
    ARM: dts: Add pinmuxing for i2c2 and i2c3 for LogicPD torpedo

Adam Ford <aford173@gmail.com>
    ARM: dts: Add pinmuxing for i2c2 and i2c3 for LogicPD SOM-LV

Hannes Reinecke <hare@suse.de>
    scsi: fcoe: Embed fc_rport_priv in fcoe_rport structure


-------------

Diffstat:

 Documentation/kernel-parameters.txt             |   9 +-
 Makefile                                        |   4 +-
 arch/arm/boot/dts/logicpd-som-lv.dtsi           |  18 ++++
 arch/arm/boot/dts/logicpd-torpedo-som.dtsi      |  16 ++++
 arch/arm64/include/asm/cpufeature.h             |   7 +-
 arch/arm64/kernel/cpufeature.c                  |  14 +++-
 arch/x86/entry/calling.h                        |  18 ++++
 arch/x86/entry/entry_64.S                       |  21 ++++-
 arch/x86/include/asm/cpufeatures.h              |   8 +-
 arch/x86/kernel/cpu/bugs.c                      | 105 ++++++++++++++++++++++--
 arch/x86/kernel/cpu/common.c                    |  42 ++++++----
 block/blk-core.c                                |   1 +
 drivers/atm/iphase.c                            |   8 +-
 drivers/hid/hid-ids.h                           |   1 +
 drivers/hid/usbhid/hid-quirks.c                 |   1 +
 drivers/hid/wacom_wac.c                         |  12 +--
 drivers/infiniband/core/addr.c                  |  15 ++--
 drivers/infiniband/core/sa_query.c              |  10 +--
 drivers/infiniband/hw/ocrdma/ocrdma_ah.c        |   5 +-
 drivers/infiniband/hw/ocrdma/ocrdma_hw.c        |   5 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/dev.c   |   2 +-
 drivers/net/ppp/pppoe.c                         |   3 +
 drivers/net/ppp/pppox.c                         |  13 +++
 drivers/net/ppp/pptp.c                          |   3 +
 drivers/scsi/fcoe/fcoe_ctlr.c                   |  51 +++++-------
 drivers/scsi/libfc/fc_rport.c                   |   5 +-
 drivers/spi/spi-bcm2835.c                       |   3 +-
 fs/compat_ioctl.c                               |   3 -
 include/linux/ceph/ceph_debug.h                 |   6 +-
 include/linux/if_pppox.h                        |   3 +
 include/net/tcp.h                               |  17 ++++
 include/scsi/libfcoe.h                          |   1 +
 net/bridge/br_multicast.c                       |   3 +
 net/bridge/br_vlan.c                            |   5 ++
 net/ceph/ceph_common.c                          |  13 ---
 net/core/dev.c                                  |   2 +
 net/ipv4/tcp_output.c                           |  11 ++-
 net/ipv6/ip6_tunnel.c                           |   8 +-
 net/l2tp/l2tp_ppp.c                             |   3 +
 net/sched/act_ife.c                             |   3 +
 net/sched/sch_codel.c                           |   6 +-
 net/tipc/netlink_compat.c                       |  11 ++-
 tools/objtool/check.c                           |   2 +
 44 files changed, 363 insertions(+), 136 deletions(-)


