Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88F3687C05
	for <lists+stable@lfdr.de>; Fri,  9 Aug 2019 15:49:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406700AbfHINtU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Aug 2019 09:49:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:36006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2436474AbfHINqY (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Aug 2019 09:46:24 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A303821880;
        Fri,  9 Aug 2019 13:46:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565358384;
        bh=pDnEv89MTmjq9zqtFA/aMxeIGaNa/R9eyQsnDJUV+9c=;
        h=From:To:Cc:Subject:Date:From;
        b=wjMaAWhGsu6iZlXOl0UCjuyufA4phMi4j03vkrW5NL86n5rT0Tuvcod9K4cBRJIdW
         IWSx8vk46lfICL6Sw7AeSrvX2+6W1DOMhwXGQ/VZazD2mKtrHl5JFTjdb9CxgG5/78
         ssUeIxjGt2w3WnEwyl/sdHC11vGNX+JcAQhm0YEU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.4 00/21] 4.4.189-stable review
Date:   Fri,  9 Aug 2019 15:45:04 +0200
Message-Id: <20190809134241.565496442@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.189-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.4.189-rc1
X-KernelTest-Deadline: 2019-08-11T13:42+00:00
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.4.189 release.
There are 21 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun 11 Aug 2019 01:42:28 PM UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.189-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.4.189-rc1

Thomas Gleixner <tglx@linutronix.de>
    x86/speculation/swapgs: Exclude ATOMs from speculation through SWAPGS

Josh Poimboeuf <jpoimboe@redhat.com>
    x86/entry/64: Use JMP instead of JMPQ

Josh Poimboeuf <jpoimboe@redhat.com>
    x86/speculation: Enable Spectre v1 swapgs mitigations

Josh Poimboeuf <jpoimboe@redhat.com>
    x86/speculation: Prepare entry code for Spectre v1 swapgs mitigations

Wanpeng Li <wanpeng.li@hotmail.com>
    x86/entry/64: Fix context tracking state warning when load_gs_index fails

Ben Hutchings <ben@decadent.org.uk>
    x86: cpufeatures: Sort feature word 7

Lukas Wunner <lukas@wunner.de>
    spi: bcm2835: Fix 3-wire mode if DMA is enabled

xiao jin <jin.xiao@intel.com>
    block: blk_init_allocated_queue() set q->fq as NULL in the fail case

Arnd Bergmann <arnd@arndb.de>
    compat_ioctl: pppoe: fix PPPOEIOCSFWD handling

Sudarsana Reddy Kalluru <skalluru@marvell.com>
    bnx2x: Disable multi-cos feature.

Mark Zhang <markz@mellanox.com>
    net/mlx5: Use reversed order when unregister devices

Jia-Ju Bai <baijiaju1990@gmail.com>
    net: sched: Fix a possible null-pointer dereference in dequeue_func()

Taras Kondratiuk <takondra@cisco.com>
    tipc: compat: allow tipc commands without arguments

Jiri Pirko <jiri@mellanox.com>
    net: fix ifindex collision during namespace removal

Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
    net: bridge: delete local fdb on device init failure

Gustavo A. R. Silva <gustavo@embeddedor.com>
    atm: iphase: Fix Spectre v1 vulnerability

Eric Dumazet <edumazet@google.com>
    tcp: be more careful in tcp_fragment()

Sebastian Parschauer <s.parschauer@gmx.de>
    HID: Add quirk for HP X1200 PIXART OEM mouse

Phil Turnbull <phil.turnbull@oracle.com>
    netfilter: nfnetlink_acct: validate NFACCT_QUOTA parameter

Will Deacon <will@kernel.org>
    arm64: cpufeature: Fix feature comparison for CTR_EL0.{CWG,ERG}

Will Deacon <will.deacon@arm.com>
    arm64: cpufeature: Fix CTR_EL0 field definitions


-------------

Diffstat:

 Documentation/kernel-parameters.txt             |   7 +-
 Makefile                                        |   4 +-
 arch/arm64/include/asm/cpufeature.h             |   7 +-
 arch/arm64/kernel/cpufeature.c                  |  14 +++-
 arch/x86/entry/calling.h                        |  19 +++++
 arch/x86/entry/entry_64.S                       |  25 +++++-
 arch/x86/include/asm/cpufeatures.h              |  10 ++-
 arch/x86/kernel/cpu/bugs.c                      | 105 ++++++++++++++++++++++--
 arch/x86/kernel/cpu/common.c                    |  42 ++++++----
 block/blk-core.c                                |   1 +
 drivers/atm/iphase.c                            |   8 +-
 drivers/hid/hid-ids.h                           |   1 +
 drivers/hid/usbhid/hid-quirks.c                 |   1 +
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/main.c  |   2 +-
 drivers/net/ppp/pppoe.c                         |   3 +
 drivers/net/ppp/pppox.c                         |  13 +++
 drivers/net/ppp/pptp.c                          |   3 +
 drivers/spi/spi-bcm2835.c                       |   3 +-
 fs/compat_ioctl.c                               |   3 -
 include/linux/if_pppox.h                        |   3 +
 include/net/tcp.h                               |  17 ++++
 net/bridge/br_vlan.c                            |   5 ++
 net/core/dev.c                                  |   2 +
 net/ipv4/tcp_output.c                           |  11 ++-
 net/l2tp/l2tp_ppp.c                             |   3 +
 net/netfilter/nfnetlink_acct.c                  |   2 +
 net/sched/sch_codel.c                           |   3 +-
 net/tipc/netlink_compat.c                       |  11 ++-
 29 files changed, 272 insertions(+), 58 deletions(-)


