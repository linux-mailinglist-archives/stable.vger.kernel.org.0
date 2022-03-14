Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 234904D8289
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 13:04:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240463AbiCNMFT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 08:05:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240325AbiCNMEj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 08:04:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCD75193E8;
        Mon, 14 Mar 2022 05:01:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E943FB80DC2;
        Mon, 14 Mar 2022 12:01:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95DC3C340E9;
        Mon, 14 Mar 2022 12:01:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647259298;
        bh=F4WV0wBDjeZ4sAOKDItEv5yVVQPKuJ3u1f0WICDpBa8=;
        h=From:To:Cc:Subject:Date:From;
        b=Z7zcTm1qXovlJyRP/CJi/sqF3mYZPuTd3ENljgCySvDNJsJiZS6xJ3bhZSwCZIK2b
         22jrYQkz2nQ09F4UvHajgXxRpESn4zOuRN675rmd9+f39ibU/9fji4rkHN14S+YD78
         lIT5CZw4R/FhBB+l/clZoFtFWAOwQa1T4GKCP9w8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Subject: [PATCH 5.10 00/71] 5.10.106-rc1 review
Date:   Mon, 14 Mar 2022 12:52:53 +0100
Message-Id: <20220314112737.929694832@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.106-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.106-rc1
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

This is the start of the stable review cycle for the 5.10.106 release.
There are 71 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 16 Mar 2022 11:27:22 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.106-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.10.106-rc1

David Howells <dhowells@redhat.com>
    watch_queue: Fix filter limit check

Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
    ARM: fix Thumb2 regression with Spectre BHB

Josh Triplett <josh@joshtriplett.org>
    ext4: add check to prevent attempting to resize an fs with sparse_super2

Li Huafei <lihuafei1@huawei.com>
    x86/traps: Mark do_int3() NOKPROBE_SYMBOL

Ross Philipson <ross.philipson@oracle.com>
    x86/boot: Add setup_indirect support in early_memremap_is_setup_data()

Ross Philipson <ross.philipson@oracle.com>
    x86/boot: Fix memremap of setup_indirect structures

David Howells <dhowells@redhat.com>
    watch_queue: Make comment about setting ->defunct more accurate

David Howells <dhowells@redhat.com>
    watch_queue: Fix lack of barrier/sync/lock between post and read

David Howells <dhowells@redhat.com>
    watch_queue: Free the alloc bitmap when the watch_queue is torn down

David Howells <dhowells@redhat.com>
    watch_queue: Fix the alloc bitmap size to reflect notes allocated

David Howells <dhowells@redhat.com>
    watch_queue: Fix to always request a pow-of-2 pipe ring size

David Howells <dhowells@redhat.com>
    watch_queue: Fix to release page in ->release()

David Howells <dhowells@redhat.com>
    watch_queue, pipe: Free watchqueue state after clearing pipe ring

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

Hans de Goede <hdegoede@redhat.com>
    staging: rtl8723bs: Fix access-point mode deadlock

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

Shreeya Patel <shreeya.patel@collabora.com>
    gpio: Return EPROBE_DEFER if gc->to_irq is NULL

Vikash Chandola <vikash.chandola@linux.intel.com>
    hwmon: (pmbus) Clear pmbus fault/warning bits after read

suresh kumar <suresh2514@gmail.com>
    net-sysfs: add check for netdevice being present to speed_show

Jon Lin <jon.lin@rock-chips.com>
    spi: rockchip: terminate dma transmission when slave abort

Jon Lin <jon.lin@rock-chips.com>
    spi: rockchip: Fix error in getting num-cs property

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

Roi Dayan <roid@nvidia.com>
    net/mlx5e: Lag, Only handle events from highest priority multipath entry

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

Tung Nguyen <tung.q.nguyen@dektech.com.au>
    tipc: fix incorrect order of state message data sanity check

Miaoqian Lin <linmq006@gmail.com>
    ethernet: Fix error handling in xemaclite_of_probe

Jedrzej Jagielski <jedrzej.jagielski@intel.com>
    ice: Fix curr_link_speed advertised speed

Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
    ice: Rename a couple of variables

Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
    ice: Remove unnecessary checker loop

Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
    ice: Align macro names to the specification

Jacob Keller <jacob.e.keller@intel.com>
    ice: stop disabling VFs due to PF error responses

Jacob Keller <jacob.e.keller@intel.com>
    i40e: stop disabling VFs due to PF error responses

Joel Stanley <joel@jms.id.au>
    ARM: dts: aspeed: Fix AST2600 quad spi group

Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
    net: dsa: mt7530: fix incorrect test in mt753x_phylink_validate()

Jernej Skrabec <jernej.skrabec@gmail.com>
    drm/sun4i: mixer: Fix P010 and P210 format numbers

Tom Rix <trix@redhat.com>
    qed: return status of qed_iov_get_link

Steffen Klassert <steffen.klassert@secunet.com>
    esp: Fix BEET mode inter address family tunneling on GSO

Jia-Ju Bai <baijiaju1990@gmail.com>
    net: qlogic: check the return value of dma_alloc_coherent() in qed_vf_hw_prepare()

Jia-Ju Bai <baijiaju1990@gmail.com>
    isdn: hfcpci: check the return value of dma_set_mask() in setup_hw()

Xie Yongji <xieyongji@bytedance.com>
    virtio-blk: Don't use MAX_DISCARD_SEGMENTS if max_discard_seg is zero

Alexey Khoroshilov <khoroshilov@ispras.ru>
    mISDN: Fix memory leak in dsp_pipeline_build()

Zhen Lei <thunder.leizhen@huawei.com>
    mISDN: Remove obsolete PIPELINE_DEBUG debugging information

Tung Nguyen <tung.q.nguyen@dektech.com.au>
    tipc: fix kernel panic when enabling bearer

Pali Rohár <pali@kernel.org>
    arm64: dts: armada-3720-turris-mox: Add missing ethernet0 alias

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    HID: vivaldi: fix sysfs attributes leak

Taniya Das <tdas@codeaurora.org>
    clk: qcom: gdsc: Add support to update GDSC transition delay

Maxime Ripard <maxime@cerno.tech>
    ARM: boot: dts: bcm2711: Fix HVS register range


-------------

Diffstat:

 Makefile                                           |  4 +-
 arch/arm/boot/dts/aspeed-g6-pinctrl.dtsi           |  2 +-
 arch/arm/boot/dts/bcm2711.dtsi                     |  1 +
 arch/arm/include/asm/spectre.h                     |  6 ++
 arch/arm/kernel/entry-armv.S                       |  4 +-
 .../boot/dts/marvell/armada-3720-turris-mox.dts    |  8 ++-
 arch/arm64/boot/dts/marvell/armada-37xx.dtsi       |  2 +-
 arch/riscv/kernel/module.c                         | 21 ++++--
 arch/x86/kernel/e820.c                             | 41 ++++++++----
 arch/x86/kernel/kdebugfs.c                         | 37 ++++++++---
 arch/x86/kernel/ksysfs.c                           | 77 +++++++++++++++++-----
 arch/x86/kernel/setup.c                            | 34 ++++++++--
 arch/x86/kernel/traps.c                            |  1 +
 arch/x86/mm/ioremap.c                              | 57 ++++++++++++++--
 drivers/block/virtio_blk.c                         | 10 ++-
 drivers/clk/qcom/gdsc.c                            | 26 ++++++--
 drivers/clk/qcom/gdsc.h                            |  8 ++-
 drivers/gpio/gpio-ts4900.c                         | 24 +++++--
 drivers/gpio/gpiolib.c                             | 10 +++
 drivers/gpu/drm/sun4i/sun8i_mixer.h                |  8 +--
 drivers/hid/hid-vivaldi.c                          |  2 +-
 drivers/hwmon/pmbus/pmbus_core.c                   |  5 ++
 drivers/isdn/hardware/mISDN/hfcpci.c               |  6 +-
 drivers/isdn/mISDN/dsp_pipeline.c                  | 52 ++-------------
 drivers/mmc/host/meson-gx-mmc.c                    | 15 +++--
 drivers/net/dsa/mt7530.c                           |  2 +-
 drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c |  7 ++
 drivers/net/ethernet/cadence/macb_main.c           | 25 ++++++-
 drivers/net/ethernet/freescale/gianfar_ethtool.c   |  1 +
 drivers/net/ethernet/intel/i40e/i40e_debugfs.c     |  6 +-
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c | 57 ++--------------
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.h |  5 --
 drivers/net/ethernet/intel/ice/ice_adminq_cmd.h    | 10 +--
 drivers/net/ethernet/intel/ice/ice_common.c        | 13 ++--
 drivers/net/ethernet/intel/ice/ice_ethtool.c       | 70 +++++++++-----------
 drivers/net/ethernet/intel/ice/ice_main.c          | 12 ++--
 drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c   | 18 -----
 drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h   |  3 -
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c      | 15 +++--
 drivers/net/ethernet/mellanox/mlx5/core/lag_mp.c   | 11 +++-
 drivers/net/ethernet/nxp/lpc_eth.c                 |  5 +-
 drivers/net/ethernet/qlogic/qed/qed_sriov.c        | 18 +++--
 drivers/net/ethernet/qlogic/qed/qed_vf.c           |  7 ++
 drivers/net/ethernet/ti/cpts.c                     |  4 +-
 drivers/net/ethernet/xilinx/xilinx_emaclite.c      |  4 +-
 drivers/net/phy/dp83822.c                          |  2 +-
 drivers/net/xen-netback/xenbus.c                   | 14 ++--
 drivers/nfc/port100.c                              |  2 +
 drivers/spi/spi-rockchip.c                         | 13 +++-
 drivers/staging/gdm724x/gdm_lte.c                  |  5 +-
 drivers/staging/rtl8723bs/core/rtw_mlme_ext.c      |  7 +-
 drivers/staging/rtl8723bs/core/rtw_recv.c          | 10 ++-
 drivers/staging/rtl8723bs/core/rtw_sta_mgt.c       | 22 +++----
 drivers/staging/rtl8723bs/core/rtw_xmit.c          | 16 +++--
 drivers/staging/rtl8723bs/hal/rtl8723bs_xmit.c     |  2 +
 drivers/virtio/virtio.c                            | 40 ++++++-----
 fs/ext4/resize.c                                   |  5 ++
 fs/fuse/dev.c                                      | 12 +++-
 fs/fuse/file.c                                     |  1 +
 fs/fuse/fuse_i.h                                   |  1 +
 fs/pipe.c                                          | 11 ++--
 include/linux/mlx5/mlx5_ifc.h                      |  4 +-
 include/linux/virtio.h                             |  1 -
 include/linux/virtio_config.h                      |  3 +-
 include/linux/watch_queue.h                        |  3 +-
 kernel/trace/trace.c                               | 10 +--
 kernel/watch_queue.c                               | 15 +++--
 net/ax25/af_ax25.c                                 |  7 ++
 net/core/net-sysfs.c                               |  2 +-
 net/ipv4/esp4_offload.c                            |  3 +
 net/ipv6/addrconf.c                                |  2 +
 net/ipv6/esp6_offload.c                            |  3 +
 net/sctp/diag.c                                    |  9 +--
 net/tipc/bearer.c                                  | 12 ++--
 net/tipc/link.c                                    |  9 +--
 .../testing/selftests/bpf/prog_tests/timer_crash.c | 32 +++++++++
 tools/testing/selftests/bpf/progs/timer_crash.c    | 54 +++++++++++++++
 tools/testing/selftests/memfd/memfd_test.c         |  1 +
 tools/testing/selftests/net/pmtu.sh                |  7 +-
 tools/testing/selftests/vm/map_fixed_noreplace.c   | 49 ++++++++++----
 80 files changed, 744 insertions(+), 399 deletions(-)


