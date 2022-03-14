Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 830524D8221
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 12:59:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240056AbiCNMA0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 08:00:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240140AbiCNMAN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 08:00:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB5E93FBCB;
        Mon, 14 Mar 2022 04:58:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0096E61297;
        Mon, 14 Mar 2022 11:58:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74D58C36AE3;
        Mon, 14 Mar 2022 11:58:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647259087;
        bh=hqtXnyRkYrQ/hO99ch/tNc8/pB0OFOVx1F0VjSmcBtY=;
        h=From:To:Cc:Subject:Date:From;
        b=aWkon5pJm1dtxG8Zu/+2+rHSNLWyob8Yxu7f4N327nZ+VIQ4GLOs87t04TLuR8dw4
         I/YfUJX/0tCVf5/lI2JcTzcC2VZR0NQ+B/LOqU3XnrIuTQSKa4UAtLLZTO/PF+x2df
         sVpnW7oMNS5f51ilG6AO/24RuDTaw5/EiO065Q0k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Subject: [PATCH 5.4 00/43] 5.4.185-rc1 review
Date:   Mon, 14 Mar 2022 12:53:11 +0100
Message-Id: <20220314112734.415677317@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.185-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.185-rc1
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

This is the start of the stable review cycle for the 5.4.185 release.
There are 43 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 16 Mar 2022 11:27:22 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.185-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.4.185-rc1

Krish Sadhukhan <krish.sadhukhan@oracle.com>
    KVM: SVM: Don't flush cache if hardware enforces cache coherency across encryption domains

Krish Sadhukhan <krish.sadhukhan@oracle.com>
    x86/mm/pat: Don't flush cache if hardware enforces cache coherency across encryption domnains

Krish Sadhukhan <krish.sadhukhan@oracle.com>
    x86/cpu: Add hardware-enforced cache coherency as a CPUID feature

Borislav Petkov <bp@suse.de>
    x86/cpufeatures: Mark two free bits in word 3

Josh Triplett <josh@joshtriplett.org>
    ext4: add check to prevent attempting to resize an fs with sparse_super2

Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
    ARM: fix Thumb2 regression with Spectre BHB

Michael S. Tsirkin <mst@redhat.com>
    virtio: acknowledge all features before access

Michael S. Tsirkin <mst@redhat.com>
    virtio: unexport virtio_finalize_features

Pali Rohár <pali@kernel.org>
    arm64: dts: marvell: armada-37xx: Remap IO space to bus address 0x0

Emil Renner Berthing <kernel@esmil.dk>
    riscv: Fix auipc+jalr relocation range checks

Rong Chen <rong.chen@amlogic.com>
    mmc: meson: Fix usage of meson_mmc_post_req()

Robert Hancock <robert.hancock@calian.com>
    net: macb: Fix lost RX packet wakeup race in NAPI receive

Dan Carpenter <dan.carpenter@oracle.com>
    staging: gdm724x: fix use after free in gdm_lte_rx()

Miklos Szeredi <mszeredi@redhat.com>
    fuse: fix pipe buffer lifetime for direct_io

Randy Dunlap <rdunlap@infradead.org>
    ARM: Spectre-BHB: provide empty stub for non-config

Mike Kravetz <mike.kravetz@oracle.com>
    selftests/memfd: clean up mapping in mfd_fail_write

Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
    selftest/vm: fix map_fixed_noreplace test failure

Sven Schnelle <svens@linux.ibm.com>
    tracing: Ensure trace buffer is at least 4096 bytes large

Niels Dossche <dossche.niels@gmail.com>
    ipv6: prevent a possible race condition with lifetimes

Marek Marczykowski-Górecki <marmarek@invisiblethingslab.com>
    Revert "xen-netback: Check for hotplug-status existence before watching"

Marek Marczykowski-Górecki <marmarek@invisiblethingslab.com>
    Revert "xen-netback: remove 'hotplug-status' once it has served its purpose"

suresh kumar <suresh2514@gmail.com>
    net-sysfs: add check for netdevice being present to speed_show

Kumar Kartikeya Dwivedi <memxor@gmail.com>
    selftests/bpf: Add test for bpf_timer overwriting crash

Jeremy Linton <jeremy.linton@arm.com>
    net: bcmgenet: Don't claim WOL when its not available

Eric Dumazet <edumazet@google.com>
    sctp: fix kernel-infoleak for SCTP sockets

Clément Léger <clement.leger@bootlin.com>
    net: phy: DP83822: clear MISR2 register to disable interrupts

Miaoqian Lin <linmq006@gmail.com>
    gianfar: ethtool: Fix refcount leak in gfar_get_ts_info

Mark Featherston <mark@embeddedTS.com>
    gpio: ts4900: Do not set DAT and OE together

Guillaume Nault <gnault@redhat.com>
    selftests: pmtu.sh: Kill tcpdump processes launched by subshell.

Pavel Skripkin <paskripkin@gmail.com>
    NFC: port100: fix use-after-free in port100_send_complete

Moshe Shemesh <moshe@nvidia.com>
    net/mlx5: Fix a race on command flush flow

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

Joel Stanley <joel@jms.id.au>
    ARM: dts: aspeed: Fix AST2600 quad spi group

Jernej Skrabec <jernej.skrabec@gmail.com>
    drm/sun4i: mixer: Fix P010 and P210 format numbers

Tom Rix <trix@redhat.com>
    qed: return status of qed_iov_get_link

Jia-Ju Bai <baijiaju1990@gmail.com>
    net: qlogic: check the return value of dma_alloc_coherent() in qed_vf_hw_prepare()

Xie Yongji <xieyongji@bytedance.com>
    virtio-blk: Don't use MAX_DISCARD_SEGMENTS if max_discard_seg is zero

Pali Rohár <pali@kernel.org>
    arm64: dts: armada-3720-turris-mox: Add missing ethernet0 alias

Taniya Das <tdas@codeaurora.org>
    clk: qcom: gdsc: Add support to update GDSC transition delay


-------------

Diffstat:

 Makefile                                           |  4 +-
 arch/arm/boot/dts/aspeed-g6-pinctrl.dtsi           |  2 +-
 arch/arm/include/asm/spectre.h                     |  6 +++
 arch/arm/kernel/entry-armv.S                       |  4 +-
 .../boot/dts/marvell/armada-3720-turris-mox.dts    |  8 +++-
 arch/arm64/boot/dts/marvell/armada-37xx.dtsi       |  2 +-
 arch/riscv/kernel/module.c                         | 21 +++++++--
 arch/x86/include/asm/cpufeatures.h                 |  2 +
 arch/x86/kernel/cpu/scattered.c                    |  1 +
 arch/x86/kvm/svm.c                                 |  3 +-
 arch/x86/mm/pageattr.c                             |  2 +-
 drivers/block/virtio_blk.c                         | 10 +++-
 drivers/clk/qcom/gdsc.c                            | 26 +++++++++--
 drivers/clk/qcom/gdsc.h                            |  8 +++-
 drivers/gpio/gpio-ts4900.c                         | 24 ++++++++--
 drivers/gpu/drm/sun4i/sun8i_mixer.h                |  8 ++--
 drivers/mmc/host/meson-gx-mmc.c                    | 15 +++---
 drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c |  7 +++
 drivers/net/ethernet/cadence/macb_main.c           | 25 +++++++++-
 drivers/net/ethernet/freescale/gianfar_ethtool.c   |  1 +
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c      | 15 +++---
 drivers/net/ethernet/nxp/lpc_eth.c                 |  5 +-
 drivers/net/ethernet/qlogic/qed/qed_sriov.c        | 18 +++++---
 drivers/net/ethernet/qlogic/qed/qed_vf.c           |  7 +++
 drivers/net/ethernet/ti/cpts.c                     |  4 +-
 drivers/net/ethernet/xilinx/xilinx_emaclite.c      |  4 +-
 drivers/net/phy/dp83822.c                          |  2 +-
 drivers/net/xen-netback/xenbus.c                   | 13 ++----
 drivers/nfc/port100.c                              |  2 +
 drivers/staging/gdm724x/gdm_lte.c                  |  5 +-
 drivers/virtio/virtio.c                            | 39 ++++++++--------
 fs/ext4/resize.c                                   |  5 ++
 fs/fuse/dev.c                                      | 12 ++++-
 fs/fuse/file.c                                     |  1 +
 fs/fuse/fuse_i.h                                   |  1 +
 include/linux/mlx5/mlx5_ifc.h                      |  4 +-
 include/linux/virtio.h                             |  1 -
 include/linux/virtio_config.h                      |  3 +-
 kernel/trace/trace.c                               | 10 ++--
 net/ax25/af_ax25.c                                 |  7 +++
 net/core/net-sysfs.c                               |  2 +-
 net/ipv6/addrconf.c                                |  2 +
 net/sctp/diag.c                                    |  9 ++--
 .../testing/selftests/bpf/prog_tests/timer_crash.c | 32 +++++++++++++
 tools/testing/selftests/bpf/progs/timer_crash.c    | 54 ++++++++++++++++++++++
 tools/testing/selftests/memfd/memfd_test.c         |  1 +
 tools/testing/selftests/net/pmtu.sh                |  7 ++-
 tools/testing/selftests/vm/map_fixed_noreplace.c   | 49 +++++++++++++++-----
 48 files changed, 378 insertions(+), 115 deletions(-)


