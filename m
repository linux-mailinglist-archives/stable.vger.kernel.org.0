Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAC9527883A
	for <lists+stable@lfdr.de>; Fri, 25 Sep 2020 14:53:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729111AbgIYMxt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Sep 2020 08:53:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:59796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729463AbgIYMxt (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 25 Sep 2020 08:53:49 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8810C2072E;
        Fri, 25 Sep 2020 12:53:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601038428;
        bh=0OkYoDs1ugbiT31AeL4IkC64vqrPbsA/yvdVIf/97H8=;
        h=From:To:Cc:Subject:Date:From;
        b=B8NgXMWF2Qa5dHsf9cS6HH+zAOa8eKgpZKUC/COCjXufJ1l6rdIKe4ewALVKEaPox
         ViDv/nCuij2qpyo7eEIQEHOg0OvYzqDdAOSxkXyLEvDSjVNDtk4bluTXNv/FtxmOLn
         j/8obGwSZKzTpCdvLNo+7bYD3ylCoU18o4cUS9aw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        pavel@denx.de, stable@vger.kernel.org
Subject: [PATCH 4.19 00/37] 4.19.148-rc1 review
Date:   Fri, 25 Sep 2020 14:48:28 +0200
Message-Id: <20200925124720.972208530@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.148-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.148-rc1
X-KernelTest-Deadline: 2020-09-27T12:47+00:00
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.19.148 release.
There are 37 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun, 27 Sep 2020 12:47:02 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.148-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.19.148-rc1

Lukas Wunner <lukas@wunner.de>
    serial: 8250: Avoid error message on reprobe

Priyaranjan Jha <priyarjha@google.com>
    tcp_bbr: adapt cwnd based on ack aggregation estimation

Priyaranjan Jha <priyarjha@google.com>
    tcp_bbr: refactor bbr_target_cwnd() for general inflight provisioning

Xunlei Pang <xlpang@linux.alibaba.com>
    mm: memcg: fix memcg reclaim soft lockup

Masahiro Yamada <masahiroy@kernel.org>
    kbuild: support LLVM=1 to switch the default tools to Clang/LLVM

Masahiro Yamada <masahiroy@kernel.org>
    kbuild: replace AS=clang with LLVM_IAS=1

Masahiro Yamada <masahiroy@kernel.org>
    kbuild: remove AS variable

Dmitry Golovin <dima@golovin.in>
    x86/boot: kbuild: allow readelf executable to be specified

Masahiro Yamada <masahiroy@kernel.org>
    net: wan: wanxl: use $(M68KCC) instead of $(M68KAS) for rebuilding firmware

Masahiro Yamada <masahiroy@kernel.org>
    net: wan: wanxl: use allow to pass CROSS_COMPILE_M68k for rebuilding firmware

Fangrui Song <maskray@google.com>
    Documentation/llvm: fix the name of llvm-size

Nick Desaulniers <ndesaulniers@google.com>
    Documentation/llvm: add documentation on building w/ Clang/LLVM

Vasily Gorbik <gor@linux.ibm.com>
    kbuild: add OBJSIZE variable for the size tool

Nick Desaulniers <ndesaulniers@google.com>
    MAINTAINERS: add CLANG/LLVM BUILD SUPPORT info

David Ahern <dsahern@kernel.org>
    ipv4: Update exception handling for multipath routes via same device

Eric Dumazet <edumazet@google.com>
    net: add __must_check to skb_put_padto()

Eric Dumazet <edumazet@google.com>
    net: qrtr: check skb_put_padto() return value

Florian Fainelli <f.fainelli@gmail.com>
    net: phy: Avoid NPD upon phy_detach() when driver is unbound

Michael Chan <michael.chan@broadcom.com>
    bnxt_en: Protect bnxt_set_eee() and bnxt_set_pauseparam() with mutex.

Edwin Peer <edwin.peer@broadcom.com>
    bnxt_en: return proper error codes in bnxt_show_temp

Xin Long <lucien.xin@gmail.com>
    tipc: use skb_unshare() instead in tipc_buf_append()

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    tipc: fix shutdown() of connection oriented socket

Peilin Ye <yepeilin.cs@gmail.com>
    tipc: Fix memory leak in tipc_group_create_member()

Jakub Kicinski <kuba@kernel.org>
    nfp: use correct define to return NONE fec

Yunsheng Lin <linyunsheng@huawei.com>
    net: sch_generic: aviod concurrent reset and enqueue op for lockless qdisc

Necip Fazil Yildiran <fazilyildiran@gmail.com>
    net: ipv6: fix kconfig dependency warning for IPV6_SEG6_HMAC

Linus Walleij <linus.walleij@linaro.org>
    net: dsa: rtl8366: Properly clear member config

Petr Machata <petrm@nvidia.com>
    net: DCB: Validate DCB_ATTR_DCB_BUFFER argument

Eric Dumazet <edumazet@google.com>
    ipv6: avoid lockdep issue in fib6_del()

Wei Wang <weiwan@google.com>
    ip: fix tos reflection in ack and reset packets

Dan Carpenter <dan.carpenter@oracle.com>
    hdlc_ppp: add range checks in ppp_cp_parse_cr()

Mark Gray <mark.d.gray@redhat.com>
    geneve: add transport ports in route lookup for geneve

Ganji Aravind <ganji.aravind@chelsio.com>
    cxgb4: Fix offset when clearing filter byte counters

Ralph Campbell <rcampbell@nvidia.com>
    mm/thp: fix __split_huge_pmd_locked() for migration PMD

Muchun Song <songmuchun@bytedance.com>
    kprobes: fix kill kprobe which has been marked as gone

Rustam Kovhaev <rkovhaev@gmail.com>
    KVM: fix memory leak in kvm_io_bus_unregister_dev()

Mark Salyzyn <salyzyn@android.com>
    af_key: pfkey_dump needs parameter validation


-------------

Diffstat:

 Documentation/kbuild/llvm.rst                      |  87 ++++++++++
 MAINTAINERS                                        |   9 ++
 Makefile                                           |  40 +++--
 arch/x86/boot/compressed/Makefile                  |   2 +-
 drivers/net/dsa/rtl8366.c                          |  20 ++-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |  19 ++-
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c  |  31 ++--
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c  |   9 +-
 .../net/ethernet/netronome/nfp/nfp_net_ethtool.c   |   4 +-
 drivers/net/geneve.c                               |  37 +++--
 drivers/net/phy/phy_device.c                       |   3 +-
 drivers/net/wan/Kconfig                            |   2 +-
 drivers/net/wan/Makefile                           |  12 +-
 drivers/net/wan/hdlc_ppp.c                         |  16 +-
 drivers/tty/serial/8250/8250_core.c                |  11 +-
 include/linux/skbuff.h                             |   7 +-
 include/net/inet_connection_sock.h                 |   4 +-
 kernel/kprobes.c                                   |   9 +-
 mm/huge_memory.c                                   |  40 +++--
 mm/vmscan.c                                        |   8 +
 net/dcb/dcbnl.c                                    |   8 +
 net/ipv4/ip_output.c                               |   3 +-
 net/ipv4/route.c                                   |  11 +-
 net/ipv4/tcp_bbr.c                                 | 180 ++++++++++++++++++---
 net/ipv6/Kconfig                                   |   1 +
 net/ipv6/ip6_fib.c                                 |  13 +-
 net/key/af_key.c                                   |   7 +
 net/qrtr/qrtr.c                                    |  20 +--
 net/sched/sch_generic.c                            |  49 ++++--
 net/tipc/group.c                                   |  14 +-
 net/tipc/msg.c                                     |   3 +-
 net/tipc/socket.c                                  |   5 +-
 tools/objtool/Makefile                             |   6 +
 virt/kvm/kvm_main.c                                |  21 +--
 34 files changed, 550 insertions(+), 161 deletions(-)


