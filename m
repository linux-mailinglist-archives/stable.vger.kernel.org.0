Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEEB94D8185
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 12:44:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239563AbiCNLme (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 07:42:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239531AbiCNLmO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 07:42:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A3EDB36;
        Mon, 14 Mar 2022 04:39:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C31D161181;
        Mon, 14 Mar 2022 11:39:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85B7EC340E9;
        Mon, 14 Mar 2022 11:39:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647257966;
        bh=sOhKJ71cBuAaHt/m6ItAfjP8NGCJvnBshMw8AZjg6kc=;
        h=From:To:Cc:Subject:Date:From;
        b=hgD+dhOL9EEIN0DA+2Q5sIhmzv0zOPMP8mvsUWHk61hS2LX18Vh/CMx+Qvu7JTDRJ
         W2MwZrP1UyOSsTE64pS3DLuHyuPj7XhEmvqFsTksrVgusjlaKuS4QOQ0NKnNd+u3bv
         8MDgaAopzLYJZfABsZdk1juAkSf/ow5HTDNHBYak=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Subject: [PATCH 4.19 00/30] 4.19.235-rc1 review
Date:   Mon, 14 Mar 2022 12:34:18 +0100
Message-Id: <20220314112731.785042288@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.235-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.235-rc1
X-KernelTest-Deadline: 2022-03-16T11:27+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.19.235 release.
There are 30 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 16 Mar 2022 11:27:22 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.235-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.19.235-rc1

Valentin Schneider <valentin.schneider@arm.com>
    ia64: ensure proper NUMA distance and possible map initialization

Dietmar Eggemann <dietmar.eggemann@arm.com>
    sched/topology: Fix sched_domain_topology_level alloc in sched_init_numa()

Valentin Schneider <valentin.schneider@arm.com>
    sched/topology: Make sched_init_numa() use a set for the deduplicating sort

Qu Wenruo <wqu@suse.com>
    btrfs: unlock newly allocated extent buffer after error

Josh Triplett <josh@joshtriplett.org>
    ext4: add check to prevent attempting to resize an fs with sparse_super2

Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
    ARM: fix Thumb2 regression with Spectre BHB

Michael S. Tsirkin <mst@redhat.com>
    virtio: acknowledge all features before access

Michael S. Tsirkin <mst@redhat.com>
    virtio: unexport virtio_finalize_features

James Morse <james.morse@arm.com>
    KVM: arm64: Reset PMC_EL0 to avoid a panic() on systems with no PMU

Emil Renner Berthing <kernel@esmil.dk>
    riscv: Fix auipc+jalr relocation range checks

Robert Hancock <robert.hancock@calian.com>
    net: macb: Fix lost RX packet wakeup race in NAPI receive

Dan Carpenter <dan.carpenter@oracle.com>
    staging: gdm724x: fix use after free in gdm_lte_rx()

Randy Dunlap <rdunlap@infradead.org>
    ARM: Spectre-BHB: provide empty stub for non-config

Mike Kravetz <mike.kravetz@oracle.com>
    selftests/memfd: clean up mapping in mfd_fail_write

Sven Schnelle <svens@linux.ibm.com>
    tracing: Ensure trace buffer is at least 4096 bytes large

Marek Marczykowski-Górecki <marmarek@invisiblethingslab.com>
    Revert "xen-netback: Check for hotplug-status existence before watching"

Marek Marczykowski-Górecki <marmarek@invisiblethingslab.com>
    Revert "xen-netback: remove 'hotplug-status' once it has served its purpose"

suresh kumar <suresh2514@gmail.com>
    net-sysfs: add check for netdevice being present to speed_show

Eric Dumazet <edumazet@google.com>
    sctp: fix kernel-infoleak for SCTP sockets

Clément Léger <clement.leger@bootlin.com>
    net: phy: DP83822: clear MISR2 register to disable interrupts

Miaoqian Lin <linmq006@gmail.com>
    gianfar: ethtool: Fix refcount leak in gfar_get_ts_info

Mark Featherston <mark@embeddedTS.com>
    gpio: ts4900: Do not set DAT and OE together

Pavel Skripkin <paskripkin@gmail.com>
    NFC: port100: fix use-after-free in port100_send_complete

Mohammad Kabat <mohammadkab@nvidia.com>
    net/mlx5: Fix size field in bufferx_reg struct

Duoming Zhou <duoming@zju.edu.cn>
    ax25: Fix NULL pointer dereference in ax25_kill_by_device

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    net: ethernet: lpc_eth: Handle error for clk_enable

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    net: ethernet: ti: cpts: Handle error for clk_enable

Miaoqian Lin <linmq006@gmail.com>
    ethernet: Fix error handling in xemaclite_of_probe

Tom Rix <trix@redhat.com>
    qed: return status of qed_iov_get_link

Jia-Ju Bai <baijiaju1990@gmail.com>
    net: qlogic: check the return value of dma_alloc_coherent() in qed_vf_hw_prepare()


-------------

Diffstat:

 Makefile                                         |  4 +-
 arch/arm/include/asm/spectre.h                   |  6 ++
 arch/arm/kernel/entry-armv.S                     |  4 +-
 arch/arm64/kvm/sys_regs.c                        |  4 +-
 arch/ia64/kernel/acpi.c                          |  7 +-
 arch/riscv/kernel/module.c                       | 21 +++--
 drivers/gpio/gpio-ts4900.c                       | 24 ++++--
 drivers/net/ethernet/cadence/macb_main.c         | 25 +++++-
 drivers/net/ethernet/freescale/gianfar_ethtool.c |  1 +
 drivers/net/ethernet/nxp/lpc_eth.c               |  5 +-
 drivers/net/ethernet/qlogic/qed/qed_sriov.c      | 18 +++--
 drivers/net/ethernet/qlogic/qed/qed_vf.c         |  7 ++
 drivers/net/ethernet/ti/cpts.c                   |  4 +-
 drivers/net/ethernet/xilinx/xilinx_emaclite.c    |  4 +-
 drivers/net/phy/dp83822.c                        |  2 +-
 drivers/net/xen-netback/xenbus.c                 | 13 ++--
 drivers/nfc/port100.c                            |  2 +
 drivers/staging/gdm724x/gdm_lte.c                |  5 +-
 drivers/virtio/virtio.c                          | 40 +++++-----
 fs/btrfs/extent-tree.c                           |  1 +
 fs/ext4/resize.c                                 |  5 ++
 include/linux/mlx5/mlx5_ifc.h                    |  4 +-
 include/linux/topology.h                         |  1 +
 include/linux/virtio.h                           |  1 -
 include/linux/virtio_config.h                    |  3 +-
 kernel/sched/topology.c                          | 99 ++++++++++++------------
 kernel/trace/trace.c                             | 10 ++-
 net/ax25/af_ax25.c                               |  7 ++
 net/core/net-sysfs.c                             |  2 +-
 net/sctp/diag.c                                  |  9 +--
 tools/testing/selftests/memfd/memfd_test.c       |  1 +
 31 files changed, 215 insertions(+), 124 deletions(-)


