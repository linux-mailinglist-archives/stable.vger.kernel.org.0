Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 722BF694965
	for <lists+stable@lfdr.de>; Mon, 13 Feb 2023 15:58:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230384AbjBMO6u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Feb 2023 09:58:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231185AbjBMO6l (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Feb 2023 09:58:41 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D5E41DB98;
        Mon, 13 Feb 2023 06:58:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 42D01B81260;
        Mon, 13 Feb 2023 14:57:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FFB3C433EF;
        Mon, 13 Feb 2023 14:57:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676300246;
        bh=HpRbbFtXBloG7Hm9BN5tkn3i1f0dT1AYWXDOeVR0iug=;
        h=From:To:Cc:Subject:Date:From;
        b=iNuLMfCm610Je9gSOcx8KtXFSga3I/F2hMlExxSNJMDuTyuUPOqaH1dHU4pYe+3Ys
         yTLym/KOJiHK/3MpLyeVjwLPcU5rRSlLSlr7LuMMtToAVp19aWYUNpMkeB5G13uPQ7
         dieQ5VsCtsvXRPJ5OdhqLKPViHvZaG7VnAxvXnGg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: [PATCH 5.15 00/67] 5.15.94-rc1 review
Date:   Mon, 13 Feb 2023 15:48:41 +0100
Message-Id: <20230213144732.336342050@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.94-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.15.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.15.94-rc1
X-KernelTest-Deadline: 2023-02-15T14:47+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.15.94 release.
There are 67 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 15 Feb 2023 14:46:51 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.94-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.15.94-rc1

Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
    nvmem: core: fix return value

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/i915: Fix VBT DSI DVO port handling

Aravind Iddamsetty <aravind.iddamsetty@intel.com>
    drm/i915: Initialize the obj flags for shmem objects

Guilherme G. Piccoli <gpiccoli@igalia.com>
    drm/amdgpu/fence: Fix oops due to non-matching drm_sched init/fini

David Chen <david.chen@nutanix.com>
    Fix page corruption caused by racy check in __free_pages

Heiner Kallweit <hkallweit1@gmail.com>
    arm64: dts: meson-axg: Make mmc host controller interrupts level-sensitive

Heiner Kallweit <hkallweit1@gmail.com>
    arm64: dts: meson-g12-common: Make mmc host controller interrupts level-sensitive

Heiner Kallweit <hkallweit1@gmail.com>
    arm64: dts: meson-gx: Make mmc host controller interrupts level-sensitive

Wander Lairson Costa <wander@redhat.com>
    rtmutex: Ensure that the top waiter is always woken up

Nicholas Piggin <npiggin@gmail.com>
    powerpc/64s/interrupt: Fix interrupt exit race with security mitigation switch

Guo Ren <guoren@linux.alibaba.com>
    riscv: Fixup race condition on PG_dcache_clean in flush_icache_pte

Xiubo Li <xiubli@redhat.com>
    ceph: flush cap releases when the session is flushed

Paul Cercueil <paul@crapouillou.net>
    clk: ingenic: jz4760: Update M/N/OD calculation algorithm

Prashant Malani <pmalani@chromium.org>
    usb: typec: altmodes/displayport: Fix probe pin assign check

Mark Pearson <mpearson-lenovo@squebb.ca>
    usb: core: add quirk for Alcor Link AK9563 smartcard reader

Anand Jain <anand.jain@oracle.com>
    btrfs: free device in btrfs_close_devices for a single device filesystem

Paolo Abeni <pabeni@redhat.com>
    mptcp: be careful on subflow status propagation on errors

Alan Stern <stern@rowland.harvard.edu>
    net: USB: Fix wrong-direction WARNING in plusb.c

ZhaoLong Wang <wangzhaolong1@huawei.com>
    cifs: Fix use-after-free in rdata->read_into_pages()

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    pinctrl: intel: Restore the pins that used to be in Direct IRQ mode

Serge Semin <Sergey.Semin@baikalelectronics.ru>
    spi: dw: Fix wrong FIFO level setting for long xfers

Maxim Korotkov <korotkov.maxim.s@gmail.com>
    pinctrl: single: fix potential NULL dereference

Joel Stanley <joel@jms.id.au>
    pinctrl: aspeed: Fix confusing types in return value

Guodong Liu <Guodong.Liu@mediatek.com>
    pinctrl: mediatek: Fix the drive register definition of some Pins

Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>
    ASoC: topology: Return -ENOMEM on memory allocation failure

Liu Shixin <liushixin2@huawei.com>
    riscv: stacktrace: Fix missing the first frame

Dan Carpenter <error27@gmail.com>
    ALSA: pci: lx6464es: fix a debug loop

Hangbin Liu <liuhangbin@gmail.com>
    selftests: forwarding: lib: quote the sysctl values

Pietro Borrello <borrello@diag.uniroma1.it>
    rds: rds_rm_zerocopy_callback() use list_first_entry()

Sasha Neftin <sasha.neftin@intel.com>
    igc: Add ndo_tx_timeout support

Shay Drory <shayd@nvidia.com>
    net/mlx5: Serialize module cleanup with reload and remove

Shay Drory <shayd@nvidia.com>
    net/mlx5: fw_tracer, Zero consumer index when reloading the tracer

Shay Drory <shayd@nvidia.com>
    net/mlx5: fw_tracer, Clear load bit when freeing string DBs buffers

Dragos Tatulea <dtatulea@nvidia.com>
    net/mlx5e: IPoIB, Show unknown speed instead of error

Vlad Buslov <vladbu@nvidia.com>
    net/mlx5: Bridge, fix ageing of peer FDB entries

Adham Faris <afaris@nvidia.com>
    net/mlx5e: Update rx ring hw mtu upon each rx-fcs flag change

Maxim Mikityanskiy <maximmi@nvidia.com>
    net/mlx5e: Introduce the mlx5e_flush_rq function

Maxim Mikityanskiy <maximmi@nvidia.com>
    net/mlx5e: Move repeating clear_bit in mlx5e_rx_reporter_err_rq_cqe_recover

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: mscc: ocelot: fix VCAP filters not matching on MAC with "protocol 802.1Q"

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dsa: mt7530: don't change PVC_EG_TAG when CPU port becomes VLAN-aware

Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
    ice: Do not use WQ_MEM_RECLAIM flag for workqueue

Herton R. Krzesinski <herton@redhat.com>
    uapi: add missing ip/ipv6 header dependencies for linux/stddef.h

Neel Patel <neel.patel@amd.com>
    ionic: clean interrupt before enabling queue to avoid credit race

Heiner Kallweit <hkallweit1@gmail.com>
    net: phy: meson-gxl: use MMD access dummy stubs for GXL, internal PHY

Qi Zheng <zhengqi.arch@bytedance.com>
    bonding: fix error checking in bond_debug_reregister()

Clément Léger <clement.leger@bootlin.com>
    net: phylink: move phy_device_free() to correctly release phy device

Christian Hopps <chopps@chopps.org>
    xfrm: fix bug with DSCP copy to v6 from v4 tunnel

Yang Yingliang <yangyingliang@huawei.com>
    RDMA/usnic: use iommu_map_atomic() under spin_lock()

Nikita Zhandarovich <n.zhandarovich@fintech.ru>
    RDMA/irdma: Fix potential NULL-ptr-dereference

Dragos Tatulea <dtatulea@nvidia.com>
    IB/IPoIB: Fix legacy IPoIB due to wrong number of queues

Eric Dumazet <edumazet@google.com>
    xfrm/compat: prevent potential spectre v1 gadget in xfrm_xlate32_attr()

Dean Luick <dean.luick@cornelisnetworks.com>
    IB/hfi1: Restore allocated resources on failed copyout

Anastasia Belova <abelova@astralinux.ru>
    xfrm: compat: change expression for switch in xfrm_xlate64

Devid Antonio Filoni <devid.filoni@egluetechnologies.com>
    can: j1939: do not wait 250 ms if the same addr was already claimed

Mark Brown <broonie@kernel.org>
    of/address: Return an error when no valid dma-ranges are found

Shiju Jose <shiju.jose@huawei.com>
    tracing: Fix poll() and select() do not work on per_cpu trace_pipe and trace_pipe_raw

Elvis Angelaccio <elvis.angelaccio@kde.org>
    ALSA: hda/realtek: Enable mute/micmute LEDs on HP Elitebook, 645 G9

Guillaume Pinot <texitoi@texitoi.eu>
    ALSA: hda/realtek: Fix the speaker output on Samsung Galaxy Book2 Pro 360

Artemii Karasev <karasev@ispras.ru>
    ALSA: emux: Avoid potential array out-of-bound in snd_emux_xg_control()

Edson Juliano Drosdeck <edson.drosdeck@gmail.com>
    ALSA: hda/realtek: Add Positivo N14KP6-TG

Alexander Potapenko <glider@google.com>
    btrfs: zlib: zero-initialize zlib workspace

Josef Bacik <josef@toxicpanda.com>
    btrfs: limit device extents to the device size

Mike Kravetz <mike.kravetz@oracle.com>
    migrate: hugetlb: check for hugetlb shared PMD in node migration

Miaohe Lin <linmiaohe@huawei.com>
    mm/migration: return errno when isolate_huge_page failed

Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
    nvmem: core: fix registration vs use race

Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
    nvmem: core: fix cleanup after dev_set_name()

Gaosheng Cui <cuigaosheng1@huawei.com>
    nvmem: core: add error handling for dev_set_name


-------------

Diffstat:

 Makefile                                           |  4 +-
 arch/arm64/boot/dts/amlogic/meson-axg.dtsi         |  4 +-
 arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi  |  6 +-
 arch/arm64/boot/dts/amlogic/meson-gx.dtsi          |  6 +-
 arch/powerpc/kernel/interrupt.c                    |  6 +-
 arch/riscv/kernel/stacktrace.c                     |  3 +-
 arch/riscv/mm/cacheflush.c                         |  4 +-
 drivers/clk/ingenic/jz4760-cgu.c                   | 18 ++--
 drivers/gpu/drm/amd/amdgpu/amdgpu_fence.c          |  8 +-
 drivers/gpu/drm/i915/display/intel_bios.c          | 33 +++++---
 drivers/gpu/drm/i915/gem/i915_gem_shmem.c          |  2 +-
 drivers/infiniband/hw/hfi1/file_ops.c              |  7 +-
 drivers/infiniband/hw/irdma/cm.c                   |  3 +
 drivers/infiniband/hw/usnic/usnic_uiom.c           |  8 +-
 drivers/infiniband/ulp/ipoib/ipoib_main.c          |  8 ++
 drivers/net/bonding/bond_debugfs.c                 |  2 +-
 drivers/net/dsa/mt7530.c                           | 26 ++++--
 drivers/net/ethernet/intel/ice/ice_main.c          |  2 +-
 drivers/net/ethernet/intel/igc/igc_main.c          | 25 +++++-
 .../ethernet/mellanox/mlx5/core/diag/fw_tracer.c   |  3 +-
 drivers/net/ethernet/mellanox/mlx5/core/en.h       |  2 +-
 .../ethernet/mellanox/mlx5/core/en/rep/bridge.c    |  4 -
 .../ethernet/mellanox/mlx5/core/en/reporter_rx.c   | 30 +------
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  | 98 ++++++++--------------
 .../net/ethernet/mellanox/mlx5/core/esw/bridge.c   |  2 +-
 .../ethernet/mellanox/mlx5/core/ipoib/ethtool.c    | 13 ++-
 drivers/net/ethernet/mellanox/mlx5/core/main.c     | 14 ++--
 drivers/net/ethernet/mscc/ocelot_flower.c          | 24 +++---
 drivers/net/ethernet/pensando/ionic/ionic_lif.c    | 15 +++-
 drivers/net/phy/meson-gxl.c                        |  2 +
 drivers/net/phy/phylink.c                          |  5 +-
 drivers/net/usb/plusb.c                            |  4 +-
 drivers/nvmem/core.c                               | 41 ++++-----
 drivers/of/address.c                               | 21 +++--
 drivers/pinctrl/aspeed/pinctrl-aspeed.c            |  2 +-
 drivers/pinctrl/intel/pinctrl-intel.c              | 16 +++-
 drivers/pinctrl/mediatek/pinctrl-mt8195.c          |  4 +-
 drivers/pinctrl/pinctrl-single.c                   |  2 +
 drivers/spi/spi-dw-core.c                          |  2 +-
 drivers/usb/core/quirks.c                          |  3 +
 drivers/usb/typec/altmodes/displayport.c           |  8 +-
 fs/btrfs/volumes.c                                 | 22 ++++-
 fs/btrfs/zlib.c                                    |  2 +-
 fs/ceph/mds_client.c                               |  6 ++
 fs/cifs/file.c                                     |  4 +-
 include/linux/hugetlb.h                            |  6 +-
 include/uapi/linux/ip.h                            |  1 +
 include/uapi/linux/ipv6.h                          |  1 +
 kernel/locking/rtmutex.c                           |  5 +-
 kernel/trace/trace.c                               |  3 -
 mm/gup.c                                           |  2 +-
 mm/hugetlb.c                                       | 11 ++-
 mm/memory-failure.c                                |  2 +-
 mm/memory_hotplug.c                                |  2 +-
 mm/mempolicy.c                                     |  5 +-
 mm/migrate.c                                       |  7 +-
 mm/page_alloc.c                                    |  5 +-
 net/can/j1939/address-claim.c                      | 40 +++++++++
 net/mptcp/subflow.c                                | 10 ++-
 net/rds/message.c                                  |  6 +-
 net/xfrm/xfrm_compat.c                             |  4 +-
 net/xfrm/xfrm_input.c                              |  3 +-
 sound/pci/hda/patch_realtek.c                      |  3 +
 sound/pci/lx6464es/lx_core.c                       | 11 ++-
 sound/soc/soc-topology.c                           |  8 +-
 sound/synth/emux/emux_nrpn.c                       |  3 +
 tools/testing/selftests/net/forwarding/lib.sh      |  4 +-
 67 files changed, 398 insertions(+), 268 deletions(-)


