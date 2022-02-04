Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 808704A96B5
	for <lists+stable@lfdr.de>; Fri,  4 Feb 2022 10:28:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358546AbiBDJ2l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Feb 2022 04:28:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358088AbiBDJ1E (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Feb 2022 04:27:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5548C061381;
        Fri,  4 Feb 2022 01:26:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 69622616A4;
        Fri,  4 Feb 2022 09:26:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B49B8C004E1;
        Fri,  4 Feb 2022 09:26:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643966777;
        bh=xNCQ2dH1d5kmHgKYprim3nCVQSlvgOlxcm6fcs9EWlk=;
        h=From:To:Cc:Subject:Date:From;
        b=EjNDX/qDxiyDVAYiCMA7f0kvCVq3ASUqwVm1riDfMnNZo+mPLo+bErwFYJMxge0aU
         ntDTZ3AUbIEl6YuHX8mzOPlEpnIT9yEv2mc25gil401YzYeHfMMn1qXeP3fCdB/dqM
         3GJma/9Dz9u2EIahp/ovQ08x9nNDuv5pa4dLdEL4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Subject: [PATCH 5.16 00/43] 5.16.6-rc1 review
Date:   Fri,  4 Feb 2022 10:22:07 +0100
Message-Id: <20220204091917.166033635@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.16.6-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.16.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.16.6-rc1
X-KernelTest-Deadline: 2022-02-06T09:19+00:00
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.16.6 release.
There are 43 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun, 06 Feb 2022 09:19:05 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.16.6-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.16.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.16.6-rc1

Eric Dumazet <edumazet@google.com>
    tcp: add missing tcp_skb_can_collapse() test in tcp_shift_skb_data()

Eric Dumazet <edumazet@google.com>
    tcp: fix mem under-charging with zerocopy sendmsg()

Eric Dumazet <edumazet@google.com>
    af_packet: fix data-race in packet_setsockopt / packet_setsockopt

Sasha Neftin <sasha.neftin@intel.com>
    e1000e: Handshake with CSME starts from ADL platforms

Tianchen Ding <dtcccc@linux.alibaba.com>
    cpuset: Fix the bug that subpart_cpus updated wrongly in update_cpumask()

He Fengqing <hefengqing@huawei.com>
    bpf: Fix possible race in inc_misses_counter

Alex Elder <elder@linaro.org>
    net: ipa: request IPA register values be retained

Eric Dumazet <edumazet@google.com>
    rtnetlink: make sure to refresh master_dev/m_ops in __rtnl_newlink()

Eric Dumazet <edumazet@google.com>
    net: sched: fix use-after-free in tc_new_tfilter()

Dan Carpenter <dan.carpenter@oracle.com>
    fanotify: Fix stale file descriptor in copy_event_to_user()

Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
    net: amd-xgbe: Fix skb data length underflow

Raju Rangoju <Raju.Rangoju@amd.com>
    net: amd-xgbe: ensure to reset the tx_timer_active flag

Karen Sornek <karen.sornek@intel.com>
    i40e: Fix reset path while removing the driver

Jedrzej Jagielski <jedrzej.jagielski@intel.com>
    i40e: Fix reset bw limit when DCB enabled with 1 TC

Georgi Valkov <gvalkov@abv.bg>
    ipheth: fix EOVERFLOW in ipheth_rcvbulk_callback

Roi Dayan <roid@nvidia.com>
    net/mlx5e: Avoid implicit modify hdr for decap drop rule

Maor Dickman <maord@nvidia.com>
    net/mlx5: E-Switch, Fix uninitialized variable modact

Khalid Manaa <khalidm@nvidia.com>
    net/mlx5e: Fix broken SKB allocation in HW-GRO

Khalid Manaa <khalidm@nvidia.com>
    net/mlx5e: Fix wrong calculation of header index in HW_GRO

Kees Cook <keescook@chromium.org>
    net/mlx5e: Avoid field-overflowing memcpy()

Roi Dayan <roid@nvidia.com>
    net/mlx5: Bridge, Fix devlink deadlock on net namespace deletion

Maxim Mikityanskiy <maximmi@nvidia.com>
    net/mlx5e: Don't treat small ceil values as unlimited in HTB offload

Dima Chumak <dchumak@nvidia.com>
    net/mlx5: Fix offloading with ESWITCH_IPV4_TTL_MODIFY_ENABLE

Roi Dayan <roid@nvidia.com>
    net/mlx5e: TC, Reject rules with forward and drop actions

Gal Pressman <gal@nvidia.com>
    net/mlx5e: Fix module EEPROM query

Maher Sanalla <msanalla@nvidia.com>
    net/mlx5: Use del_timer_sync in fw reset flow of halting poll

Maor Dickman <maord@nvidia.com>
    net/mlx5e: Fix handling of wrong devices during bond netevent

Vlad Buslov <vladbu@nvidia.com>
    net/mlx5: Bridge, ensure dev_name is null-terminated

Vlad Buslov <vladbu@nvidia.com>
    net/mlx5: Bridge, take rtnl lock in init error handler

Roi Dayan <roid@nvidia.com>
    net/mlx5e: TC, Reject rules with drop and modify hdr action

Raed Salem <raeds@nvidia.com>
    net/mlx5e: IPsec: Fix tunnel mode crypto offload for non TCP/UDP traffic

Raed Salem <raeds@nvidia.com>
    net/mlx5e: IPsec: Fix crypto offload for non TCP/UDP encapsulated traffic

J. Bruce Fields <bfields@redhat.com>
    lockd: fix failure to cleanup client locks

J. Bruce Fields <bfields@redhat.com>
    lockd: fix server crash on reboot of client holding lock

Miklos Szeredi <mszeredi@redhat.com>
    ovl: don't fail copy up if no fileattr support on upper

Jonathan McDowell <noodles@earth.li>
    net: phy: Fix qca8081 with speeds lower than 2.5Gb/s

John Hubbard <jhubbard@nvidia.com>
    Revert "mm/gup: small refactoring: simplify try_grab_page()"

Eric W. Biederman <ebiederm@xmission.com>
    cgroup-v1: Require capabilities to set release_agent

Maxime Ripard <maxime@cerno.tech>
    drm/vc4: hdmi: Make sure the device is powered with CEC

Alex Elder <elder@linaro.org>
    net: ipa: prevent concurrent replenish

Alex Elder <elder@linaro.org>
    net: ipa: use a bitmap for endpoint replenish_enabled

Paolo Abeni <pabeni@redhat.com>
    selftests: mptcp: fix ipv6 routing setup

Lukas Wunner <lukas@wunner.de>
    PCI: pciehp: Fix infinite loop in IRQ handler upon power fault


-------------

Diffstat:

 Makefile                                           |  4 +-
 drivers/gpu/drm/vc4/vc4_hdmi.c                     | 25 ++++++-----
 drivers/net/ethernet/amd/xgbe/xgbe-drv.c           | 14 +++++-
 drivers/net/ethernet/intel/e1000e/netdev.c         |  6 ++-
 drivers/net/ethernet/intel/i40e/i40e.h             |  1 +
 drivers/net/ethernet/intel/i40e/i40e_main.c        | 31 ++++++++++++-
 drivers/net/ethernet/mellanox/mlx5/core/en.h       |  6 +--
 drivers/net/ethernet/mellanox/mlx5/core/en/qos.c   |  3 +-
 .../net/ethernet/mellanox/mlx5/core/en/rep/bond.c  | 32 ++++++-------
 .../ethernet/mellanox/mlx5/core/en/rep/bridge.c    |  6 ++-
 drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h  |  5 +++
 drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c   |  4 +-
 .../mellanox/mlx5/core/en_accel/ipsec_rxtx.c       | 13 +++++-
 .../mellanox/mlx5/core/en_accel/ipsec_rxtx.h       |  9 ++--
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c    | 30 ++++++++-----
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    | 15 ++++++-
 .../net/ethernet/mellanox/mlx5/core/esw/bridge.c   |  4 ++
 .../mlx5/core/esw/diag/bridge_tracepoint.h         |  2 +-
 drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c |  2 +-
 .../ethernet/mellanox/mlx5/core/lib/fs_chains.c    |  9 ++--
 drivers/net/ethernet/mellanox/mlx5/core/port.c     |  9 ++--
 drivers/net/ipa/ipa_endpoint.c                     | 21 +++++++--
 drivers/net/ipa/ipa_endpoint.h                     | 17 ++++++-
 drivers/net/ipa/ipa_power.c                        | 52 ++++++++++++++++++++++
 drivers/net/ipa/ipa_power.h                        |  7 +++
 drivers/net/ipa/ipa_uc.c                           |  5 +++
 drivers/net/phy/at803x.c                           | 26 +++++------
 drivers/net/usb/ipheth.c                           |  6 +--
 drivers/pci/hotplug/pciehp_hpc.c                   |  7 +--
 fs/lockd/svcsubs.c                                 | 18 ++++----
 fs/notify/fanotify/fanotify_user.c                 |  6 +--
 fs/overlayfs/copy_up.c                             | 12 ++++-
 kernel/bpf/trampoline.c                            |  5 ++-
 kernel/cgroup/cgroup-v1.c                          | 14 ++++++
 kernel/cgroup/cpuset.c                             |  3 +-
 mm/gup.c                                           | 35 ++++++++++++---
 net/core/rtnetlink.c                               |  6 ++-
 net/ipv4/tcp.c                                     |  7 ++-
 net/ipv4/tcp_input.c                               |  2 +
 net/packet/af_packet.c                             |  8 +++-
 net/sched/cls_api.c                                | 11 +++--
 tools/testing/selftests/net/mptcp/mptcp_join.sh    |  5 ++-
 42 files changed, 374 insertions(+), 129 deletions(-)


