Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1BAD32C9B
	for <lists+stable@lfdr.de>; Mon,  3 Jun 2019 11:18:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727896AbfFCJKE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jun 2019 05:10:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:54172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728009AbfFCJKD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Jun 2019 05:10:03 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B2CA627E29;
        Mon,  3 Jun 2019 09:10:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559553002;
        bh=C92oLd7+HTi/bOLg2xc1mG/eUMOdj/TgmnTvOmkL0dg=;
        h=From:To:Cc:Subject:Date:From;
        b=DueJqw7d9vUF87a4JcFiL9XK8uVzPfFty9yVrf+jie7RF3OfeaGeKFp74H4L6dMtG
         TFPSLK610Z8gJI9tmlhknAlDWoYIePtIIoHRTIiPkDFCfNw1SvlLc6u5EY4PHgK4Lm
         dzevha+mAizVERn1MsRqn0IU8SmheEJfOz02VPbI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.19 00/32] 4.19.48-stable review
Date:   Mon,  3 Jun 2019 11:07:54 +0200
Message-Id: <20190603090308.472021390@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.48-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.48-rc1
X-KernelTest-Deadline: 2019-06-05T09:03+00:00
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.19.48 release.
There are 32 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed 05 Jun 2019 09:02:49 AM UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.48-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.19.48-rc1

Junwei Hu <hujunwei4@huawei.com>
    tipc: fix modprobe tipc failed after switch order of device registration

David S. Miller <davem@davemloft.net>
    Revert "tipc: fix modprobe tipc failed after switch order of device registration"

Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
    xen/pciback: Don't disable PCI_COMMAND on PCI device reset.

Masahiro Yamada <yamada.masahiro@socionext.com>
    jump_label: move 'asm goto' support test to Kconfig

Masahiro Yamada <yamada.masahiro@socionext.com>
    compiler.h: give up __compiletime_assert_fallback()

ndesaulniers@google.com <ndesaulniers@google.com>
    include/linux/compiler*.h: define asm_volatile_goto

Daniel Axtens <dja@axtens.net>
    crypto: vmx - ghash: do nosimd fallback manually

Jakub Kicinski <jakub.kicinski@netronome.com>
    net/tls: don't ignore netdev notifications if no TLS features

Jakub Kicinski <jakub.kicinski@netronome.com>
    net/tls: fix state removal with feature flags off

Michael Chan <michael.chan@broadcom.com>
    bnxt_en: Fix aggregation buffer leak under OOM condition.

Weifeng Voon <weifeng.voon@intel.com>
    net: stmmac: dma channel control register need to be init first

Saeed Mahameed <saeedm@mellanox.com>
    net/mlx5e: Disable rxhash when CQE compress is enabled

Parav Pandit <parav@mellanox.com>
    net/mlx5: Allocate root ns memory using kzalloc to match kfree

Chris Packham <chris.packham@alliedtelesis.co.nz>
    tipc: Avoid copying bytes beyond the supplied data

Parav Pandit <parav@mellanox.com>
    net/mlx5: Avoid double free in fs init error unwinding path

Kloetzke Jan <Jan.Kloetzke@preh.de>
    usbnet: fix kernel crash after disconnect

Jisheng Zhang <Jisheng.Zhang@synaptics.com>
    net: stmmac: fix reset gpio free missing

Vlad Buslov <vladbu@mellanox.com>
    net: sched: don't use tc_action->order during action dump

Russell King <rmk+kernel@armlinux.org.uk>
    net: phy: marvell10g: report if the PHY fails to boot firmware

Antoine Tenart <antoine.tenart@bootlin.com>
    net: mvpp2: fix bad MVPP2_TXQ_SCHED_TOKEN_CNTR_REG queue value

Jisheng Zhang <Jisheng.Zhang@synaptics.com>
    net: mvneta: Fix err code path of probe

Eric Dumazet <edumazet@google.com>
    net-gro: fix use-after-free read in napi_gro_frags()

Andy Duan <fugang.duan@nxp.com>
    net: fec: fix the clk mismatch in failed_reset path

Rasmus Villemoes <rasmus.villemoes@prevas.dk>
    net: dsa: mv88e6xxx: fix handling of upper half of STATS_TYPE_PORT

Eric Dumazet <edumazet@google.com>
    llc: fix skb leak in llc_build_and_send_ui_pkt()

David Ahern <dsahern@gmail.com>
    ipv6: Fix redirect with VRF

Mike Manning <mmanning@vyatta.att-mail.com>
    ipv6: Consider sk_bound_dev_if when binding a raw socket to an address

Eric Dumazet <edumazet@google.com>
    ipv4/igmp: fix build error if !CONFIG_IP_MULTICAST

Eric Dumazet <edumazet@google.com>
    ipv4/igmp: fix another memory leak in igmpv3_del_delrec()

Eric Dumazet <edumazet@google.com>
    inet: switch IP ID generator to siphash

Raju Rangoju <rajur@chelsio.com>
    cxgb4: offload VLAN flows regardless of VLAN ethtype

Jarod Wilson <jarod@redhat.com>
    bonding/802.3ad: fix slave link initialization transition states


-------------

Diffstat:

 Makefile                                           |  11 +-
 arch/Kconfig                                       |   1 +
 arch/arm/kernel/jump_label.c                       |   4 -
 arch/arm64/kernel/jump_label.c                     |   4 -
 arch/mips/kernel/jump_label.c                      |   4 -
 arch/powerpc/include/asm/asm-prototypes.h          |   2 +-
 arch/powerpc/kernel/jump_label.c                   |   2 -
 arch/powerpc/platforms/powernv/opal-tracepoints.c  |   2 +-
 arch/powerpc/platforms/powernv/opal-wrappers.S     |   2 +-
 arch/powerpc/platforms/pseries/hvCall.S            |   4 +-
 arch/powerpc/platforms/pseries/lpar.c              |   2 +-
 arch/s390/kernel/Makefile                          |   3 +-
 arch/s390/kernel/jump_label.c                      |   4 -
 arch/sparc/kernel/Makefile                         |   2 +-
 arch/sparc/kernel/jump_label.c                     |   4 -
 arch/x86/Makefile                                  |   2 +-
 arch/x86/entry/calling.h                           |   2 +-
 arch/x86/include/asm/cpufeature.h                  |   2 +-
 arch/x86/include/asm/jump_label.h                  |  13 --
 arch/x86/include/asm/rmwcc.h                       |   6 +-
 arch/x86/kernel/Makefile                           |   3 +-
 arch/x86/kernel/jump_label.c                       |   4 -
 arch/x86/kvm/emulate.c                             |   2 +-
 drivers/crypto/vmx/ghash.c                         | 212 +++++++++------------
 drivers/net/bonding/bond_main.c                    |  15 +-
 drivers/net/dsa/mv88e6xxx/chip.c                   |   2 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |   2 +
 .../net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c   |   5 +-
 drivers/net/ethernet/freescale/fec_main.c          |   2 +-
 drivers/net/ethernet/marvell/mvneta.c              |   4 +-
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c    |  10 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |  13 ++
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c  |   6 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |   8 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c  |   3 +-
 drivers/net/phy/marvell10g.c                       |  13 ++
 drivers/net/usb/usbnet.c                           |   6 +
 drivers/xen/xen-pciback/pciback_ops.c              |   2 -
 include/linux/compiler.h                           |  17 +-
 include/linux/compiler_types.h                     |   4 +
 include/linux/dynamic_debug.h                      |   6 +-
 include/linux/jump_label.h                         |  22 +--
 include/linux/jump_label_ratelimit.h               |   8 +-
 include/linux/module.h                             |   2 +-
 include/linux/netfilter.h                          |   4 +-
 include/linux/netfilter_ingress.h                  |   2 +-
 include/linux/siphash.h                            |   5 +
 include/net/netns/ipv4.h                           |   2 +
 include/uapi/linux/tipc_config.h                   |  10 +-
 init/Kconfig                                       |   3 +
 kernel/jump_label.c                                |  10 +-
 kernel/module.c                                    |   2 +-
 kernel/sched/core.c                                |   2 +-
 kernel/sched/debug.c                               |   4 +-
 kernel/sched/fair.c                                |   6 +-
 kernel/sched/sched.h                               |   6 +-
 lib/dynamic_debug.c                                |   2 +-
 net/core/dev.c                                     |   8 +-
 net/ipv4/igmp.c                                    |  47 +++--
 net/ipv4/route.c                                   |  12 +-
 net/ipv6/output_core.c                             |  30 +--
 net/ipv6/raw.c                                     |   2 +
 net/ipv6/route.c                                   |   6 +
 net/llc/llc_output.c                               |   2 +
 net/netfilter/core.c                               |   6 +-
 net/sched/act_api.c                                |   3 +-
 net/tipc/core.c                                    |  32 ++--
 net/tipc/subscr.h                                  |   5 +-
 net/tipc/topsrv.c                                  |  14 +-
 net/tls/tls_device.c                               |   9 +-
 scripts/gcc-goto.sh                                |   2 +-
 tools/arch/x86/include/asm/rmwcc.h                 |   6 +-
 72 files changed, 338 insertions(+), 351 deletions(-)


