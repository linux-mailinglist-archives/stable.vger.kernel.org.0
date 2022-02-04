Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2D494A962A
	for <lists+stable@lfdr.de>; Fri,  4 Feb 2022 10:23:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357669AbiBDJXS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Feb 2022 04:23:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357574AbiBDJWa (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Feb 2022 04:22:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B31E9C06177D;
        Fri,  4 Feb 2022 01:22:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3B6686167B;
        Fri,  4 Feb 2022 09:22:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1D66C004E1;
        Fri,  4 Feb 2022 09:22:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643966549;
        bh=2K9gC4yUG532JTz62a9RvdsmVoylHktm8Gl2k4ykFcU=;
        h=From:To:Cc:Subject:Date:From;
        b=2YBQFnUCDFPx8I66EzG8Ume0qRJFRq1gMwndsNYB9xspcY77m7Wr/icn4u+jUQVrS
         b4sgi2waUxL3bIfUvi6RZES8QLm0mt3TaXKilLb5vH+2vEl/VzXixisjoa7Wd4tray
         crMiXIuVoet9MR3nBHMbYwJ8azzROxs2W5XOhKw8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Subject: [PATCH 5.10 00/25] 5.10.97-rc1 review
Date:   Fri,  4 Feb 2022 10:20:07 +0100
Message-Id: <20220204091914.280602669@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.97-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.97-rc1
X-KernelTest-Deadline: 2022-02-06T09:19+00:00
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.10.97 release.
There are 25 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun, 06 Feb 2022 09:19:05 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.97-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.10.97-rc1

Eric Dumazet <edumazet@google.com>
    tcp: add missing tcp_skb_can_collapse() test in tcp_shift_skb_data()

Eric Dumazet <edumazet@google.com>
    af_packet: fix data-race in packet_setsockopt / packet_setsockopt

Tianchen Ding <dtcccc@linux.alibaba.com>
    cpuset: Fix the bug that subpart_cpus updated wrongly in update_cpumask()

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

Georgi Valkov <gvalkov@abv.bg>
    ipheth: fix EOVERFLOW in ipheth_rcvbulk_callback

Maor Dickman <maord@nvidia.com>
    net/mlx5: E-Switch, Fix uninitialized variable modact

Maher Sanalla <msanalla@nvidia.com>
    net/mlx5: Use del_timer_sync in fw reset flow of halting poll

Maor Dickman <maord@nvidia.com>
    net/mlx5e: Fix handling of wrong devices during bond netevent

Eric W. Biederman <ebiederm@xmission.com>
    cgroup-v1: Require capabilities to set release_agent

Maxime Ripard <maxime@cerno.tech>
    drm/vc4: hdmi: Make sure the device is powered with CEC

Tony Luck <tony.luck@intel.com>
    x86/cpu: Add Xeon Icelake-D to list of CPUs that support PPIN

Tony Luck <tony.luck@intel.com>
    x86/mce: Add Xeon Sapphire Rapids to list of CPUs that support PPIN

Namhyung Kim <namhyung@kernel.org>
    perf/core: Fix cgroup event list management

Peter Zijlstra <peterz@infradead.org>
    perf: Rework perf_event_exit_event()

Suren Baghdasaryan <surenb@google.com>
    psi: Fix uaf issue when psi trigger is destroyed while being polled

Sean Christopherson <seanjc@google.com>
    KVM: x86: Forcibly leave nested virt when SMM state is toggled

Kevin Hilman <khilman@baylibre.com>
    Revert "drivers: bus: simple-pm-bus: Add support for probing simple bus only devices"

Alex Elder <elder@linaro.org>
    net: ipa: prevent concurrent replenish

Alex Elder <elder@linaro.org>
    net: ipa: use a bitmap for endpoint replenish_enabled

Alex Elder <elder@linaro.org>
    net: ipa: fix atomic update in ipa_endpoint_replenish()

Lukas Wunner <lukas@wunner.de>
    PCI: pciehp: Fix infinite loop in IRQ handler upon power fault


-------------

Diffstat:

 Documentation/accounting/psi.rst                   |   3 +-
 Makefile                                           |   4 +-
 arch/x86/include/asm/kvm_host.h                    |   1 +
 arch/x86/kernel/cpu/mce/intel.c                    |   2 +
 arch/x86/kvm/svm/nested.c                          |  10 +-
 arch/x86/kvm/svm/svm.c                             |   2 +-
 arch/x86/kvm/svm/svm.h                             |   2 +-
 arch/x86/kvm/vmx/nested.c                          |   1 +
 arch/x86/kvm/x86.c                                 |   2 +
 drivers/bus/simple-pm-bus.c                        |  39 +-----
 drivers/gpu/drm/vc4/vc4_hdmi.c                     |  25 ++--
 drivers/net/ethernet/amd/xgbe/xgbe-drv.c           |  14 +-
 .../net/ethernet/mellanox/mlx5/core/en/rep/bond.c  |  32 ++---
 drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c |   2 +-
 .../ethernet/mellanox/mlx5/core/lib/fs_chains.c    |   2 +-
 drivers/net/ipa/ipa_endpoint.c                     |  25 ++--
 drivers/net/ipa/ipa_endpoint.h                     |  15 +-
 drivers/net/usb/ipheth.c                           |   6 +-
 drivers/pci/hotplug/pciehp_hpc.c                   |   7 +-
 fs/notify/fanotify/fanotify_user.c                 |   6 +-
 include/linux/perf_event.h                         |   1 +
 include/linux/psi.h                                |   2 +-
 include/linux/psi_types.h                          |   3 -
 kernel/cgroup/cgroup-v1.c                          |  14 ++
 kernel/cgroup/cgroup.c                             |  11 +-
 kernel/cgroup/cpuset.c                             |   3 +-
 kernel/events/core.c                               | 151 ++++++++++++---------
 kernel/sched/psi.c                                 |  66 ++++-----
 net/core/rtnetlink.c                               |   6 +-
 net/ipv4/tcp_input.c                               |   2 +
 net/packet/af_packet.c                             |   8 +-
 net/sched/cls_api.c                                |  11 +-
 32 files changed, 264 insertions(+), 214 deletions(-)


