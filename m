Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21C376948B5
	for <lists+stable@lfdr.de>; Mon, 13 Feb 2023 15:52:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230428AbjBMOw5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Feb 2023 09:52:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229929AbjBMOwz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Feb 2023 09:52:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 874861BAD9;
        Mon, 13 Feb 2023 06:52:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 19822B8125B;
        Mon, 13 Feb 2023 14:52:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55609C433D2;
        Mon, 13 Feb 2023 14:52:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676299947;
        bh=sk6Y9b+0Hfa9jYKBccHR7iQGo48orAbYDH+PqsRn2WI=;
        h=From:To:Cc:Subject:Date:From;
        b=Kc5ZbTvYaVhC7iDw3ekmT+hiYrxdsjravpDQ9t/ZHLJdKlOJhlaK5rZ+7DgoTXDBG
         JgTR6LtTCvCvxDTed+NOjriaqricKrINH8lWwm8NvrPXwwvl9pXH0/4aGU4jPzf8Ak
         vH32uX1C6wjaKkf2wVoPhj6+ce2f79H1LCakB2gA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: [PATCH 6.1 000/114] 6.1.12-rc1 review
Date:   Mon, 13 Feb 2023 15:47:15 +0100
Message-Id: <20230213144742.219399167@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.12-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.1.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.1.12-rc1
X-KernelTest-Deadline: 2023-02-15T14:47+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 6.1.12 release.
There are 114 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 15 Feb 2023 14:46:51 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.12-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.1.12-rc1

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/i915: Fix VBT DSI DVO port handling

Aravind Iddamsetty <aravind.iddamsetty@intel.com>
    drm/i915: Initialize the obj flags for shmem objects

Rob Clark <robdclark@chromium.org>
    drm/i915: Move fd_install after last use of fence

Melissa Wen <mwen@igalia.com>
    drm/amd/display: fix cursor offset on rotation 180

Alex Deucher <alexander.deucher@amd.com>
    drm/amd/display: properly handling AGP aperture in vm setup

Jane Jian <Jane.Jian@amd.com>
    drm/amdgpu/smu: skip pptable init under sriov

Guilherme G. Piccoli <gpiccoli@igalia.com>
    drm/amdgpu/fence: Fix oops due to non-matching drm_sched init/fini

Evan Quan <evan.quan@amd.com>
    drm/amd/pm: bump SMU 13.0.7 driver_if header version

Kent Russell <kent.russell@amd.com>
    drm/amdgpu: Add unique_id support for GC 11.0.1/2

Evan Quan <evan.quan@amd.com>
    drm/amd/pm: bump SMU 13.0.0 driver_if header version

Darren Hart <darren@os.amperecomputing.com>
    arm64: efi: Force the use of SetVirtualAddressMap() on eMAG and Altra Max machines

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

Yafang Shao <laoar.shao@gmail.com>
    tracing: Fix TASK_COMM_LEN in trace event format file

Friedrich Vock <friedrich.vock@gmx.de>
    drm/amdgpu: Use the TGID for trace_amdgpu_vm_update_ptes

Nicholas Piggin <npiggin@gmail.com>
    powerpc/64s/interrupt: Fix interrupt exit race with security mitigation switch

Guo Ren <guoren@kernel.org>
    riscv: kprobe: Fixup misaligned load text

Guo Ren <guoren@kernel.org>
    riscv: Fixup race condition on PG_dcache_clean in flush_icache_pte

Dan Williams <dan.j.williams@intel.com>
    nvdimm: Support sizeof(struct page) > MAX_STRUCT_PAGE_SIZE

Xiubo Li <xiubli@redhat.com>
    ceph: flush cap releases when the session is flushed

Evan Quan <evan.quan@amd.com>
    drm/amd/pm: add SMU 13.0.7 missing GetPptLimit message mapping

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    pinctrl: qcom: sm8450-lpass-lpi: correct swr_rx_data group

Paul Cercueil <paul@crapouillou.net>
    clk: ingenic: jz4760: Update M/N/OD calculation algorithm

Dan Williams <dan.j.williams@intel.com>
    cxl/region: Fix passthrough-decoder detection

Fan Ni <fan.ni@samsung.com>
    cxl/region: Fix null pointer dereference for resetting decoder

Prashant Malani <pmalani@chromium.org>
    usb: typec: altmodes/displayport: Fix probe pin assign check

Mark Pearson <mpearson-lenovo@squebb.ca>
    usb: core: add quirk for Alcor Link AK9563 smartcard reader

Anand Jain <anand.jain@oracle.com>
    btrfs: free device in btrfs_close_devices for a single device filesystem

Filipe Manana <fdmanana@suse.com>
    btrfs: simplify update of last_dir_index_offset when logging a directory

Matthieu Baerts <matthieu.baerts@tessares.net>
    selftests: mptcp: stop tests earlier

Paolo Abeni <pabeni@redhat.com>
    selftests: mptcp: allow more slack for slow test-case

Paolo Abeni <pabeni@redhat.com>
    mptcp: be careful on subflow status propagation on errors

Paolo Abeni <pabeni@redhat.com>
    mptcp: do not wait for bare sockets' timeout

Alan Stern <stern@rowland.harvard.edu>
    net: USB: Fix wrong-direction WARNING in plusb.c

ZhaoLong Wang <wangzhaolong1@huawei.com>
    cifs: Fix use-after-free in rdata->read_into_pages()

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    pinctrl: intel: Restore the pins that used to be in Direct IRQ mode

Joel Stanley <joel@jms.id.au>
    pinctrl: aspeed: Revert "Force to disable the function's signal"

Serge Semin <Sergey.Semin@baikalelectronics.ru>
    spi: dw: Fix wrong FIFO level setting for long xfers

Maxim Korotkov <korotkov.maxim.s@gmail.com>
    pinctrl: single: fix potential NULL dereference

Joel Stanley <joel@jms.id.au>
    pinctrl: aspeed: Fix confusing types in return value

Guodong Liu <Guodong.Liu@mediatek.com>
    pinctrl: mediatek: Fix the drive register definition of some Pins

Geert Uytterhoeven <geert+renesas@glider.be>
    clk: microchip: mpfs-ccc: Use devm_kasprintf() for allocating formatted strings

Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>
    ASoC: topology: Return -ENOMEM on memory allocation failure

Shengjiu Wang <shengjiu.wang@nxp.com>
    ASoC: fsl_sai: fix getting version from VERID

Daniel Beer <daniel.beer@igorinstitute.com>
    ASoC: tas5805m: add missing page switch.

Daniel Beer <daniel.beer@igorinstitute.com>
    ASoC: tas5805m: rework to avoid scheduling while atomic.

Chen-Yu Tsai <wenst@chromium.org>
    arm64: dts: mediatek: mt8195: Fix vdosys* compatible strings

Liu Shixin <liushixin2@huawei.com>
    riscv: stacktrace: Fix missing the first frame

Dan Carpenter <error27@gmail.com>
    ALSA: pci: lx6464es: fix a debug loop

Dan Johansen <strit@manjaro.org>
    arm64: dts: rockchip: set sdmmc0 speed to sd-uhs-sdr50 on rock-3a

Arnaud Ferraris <arnaud.ferraris@collabora.com>
    arm64: dts: rockchip: fix input enable pinconf on rk3399

Hangbin Liu <liuhangbin@gmail.com>
    selftests: forwarding: lib: quote the sysctl values

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: mscc: ocelot: fix all IPv6 getting trapped to CPU when PTP timestamping is used

Pietro Borrello <borrello@diag.uniroma1.it>
    rds: rds_rm_zerocopy_callback() use list_first_entry()

Ido Schimmel <idosch@nvidia.com>
    selftests: Fix failing VXLAN VNI filtering test

Kevin Yang <yyd@google.com>
    txhash: fix sk->sk_txrehash default

Tariq Toukan <tariqt@nvidia.com>
    net: ethernet: mtk_eth_soc: fix wrong parameters order in __xdp_rxq_info_reg()

Sasha Neftin <sasha.neftin@intel.com>
    igc: Add ndo_tx_timeout support

Shay Drory <shayd@nvidia.com>
    net/mlx5: Serialize module cleanup with reload and remove

Shay Drory <shayd@nvidia.com>
    net/mlx5: fw_tracer, Zero consumer index when reloading the tracer

Shay Drory <shayd@nvidia.com>
    net/mlx5: fw_tracer, Clear load bit when freeing string DBs buffers

Maher Sanalla <msanalla@nvidia.com>
    net/mlx5: Expose SF firmware pages counter

Maher Sanalla <msanalla@nvidia.com>
    net/mlx5: Store page counters in a single array

Dragos Tatulea <dtatulea@nvidia.com>
    net/mlx5e: IPoIB, Show unknown speed instead of error

Amir Tzin <amirtz@nvidia.com>
    net/mlx5e: Fix crash unsetting rx-vlan-filter in switchdev mode

Vlad Buslov <vladbu@nvidia.com>
    net/mlx5: Bridge, fix ageing of peer FDB entries

Adham Faris <afaris@nvidia.com>
    net/mlx5e: Update rx ring hw mtu upon each rx-fcs flag change

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: mscc: ocelot: fix VCAP filters not matching on MAC with "protocol 802.1Q"

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dsa: mt7530: don't change PVC_EG_TAG when CPU port becomes VLAN-aware

Zhang Changzhong <zhangchangzhong@huawei.com>
    ice: switch: fix potential memleak in ice_add_adv_recipe()

Brett Creeley <brett.creeley@intel.com>
    ice: Fix disabling Rx VLAN filtering with port VLAN enabled

Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
    ice: Do not use WQ_MEM_RECLAIM flag for workqueue

Dave Airlie <airlied@redhat.com>
    nvidiafb: detect the hardware support before removing console.

Will Deacon <will@kernel.org>
    cpuset: Call set_cpus_allowed_ptr() with appropriate mask for task

Ryan Neph <ryanneph@chromium.org>
    drm/virtio: exbuf->fence_fd unmodified on interrupted wait

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/i915: Don't do the WM0->WM1 copy w/a if WM1 is already enabled

Mario Limonciello <mario.limonciello@amd.com>
    HID: amd_sfh: if no sensors are enabled, clean up

Casper Andersson <casper.casan@gmail.com>
    net: microchip: sparx5: fix PTP init/deinit not checking all ports

Herton R. Krzesinski <herton@redhat.com>
    uapi: add missing ip/ipv6 header dependencies for linux/stddef.h

Douglas Anderson <dianders@chromium.org>
    cpufreq: qcom-hw: Fix cpufreq_driver->get() for non-LMH systems

Allen Hubbe <allen.hubbe@amd.com>
    ionic: missed doorbell workaround

Neel Patel <neel@pensando.io>
    ionic: refactor use of ionic_rx_fill()

Neel Patel <neel.patel@amd.com>
    ionic: clean interrupt before enabling queue to avoid credit race

Heiner Kallweit <hkallweit1@gmail.com>
    net: phy: meson-gxl: use MMD access dummy stubs for GXL, internal PHY

Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
    net: macb: Perform zynqmp dynamic configuration only for SGMII interface

Qi Zheng <zhengqi.arch@bytedance.com>
    bonding: fix error checking in bond_debug_reregister()

Clément Léger <clement.leger@bootlin.com>
    net: phylink: move phy_device_free() to correctly release phy device

Michal Suchanek <msuchanek@suse.de>
    of: Make OF framebuffer device names unique

Christian Hopps <chopps@chopps.org>
    xfrm: fix bug with DSCP copy to v6 from v4 tunnel

Yang Yingliang <yangyingliang@huawei.com>
    RDMA/usnic: use iommu_map_atomic() under spin_lock()

Nikita Zhandarovich <n.zhandarovich@fintech.ru>
    RDMA/irdma: Fix potential NULL-ptr-dereference

Eric Dumazet <edumazet@google.com>
    xfrm: annotate data-race around use_time

Dragos Tatulea <dtatulea@nvidia.com>
    IB/IPoIB: Fix legacy IPoIB due to wrong number of queues

Eric Dumazet <edumazet@google.com>
    xfrm/compat: prevent potential spectre v1 gadget in xfrm_xlate32_attr()

Dean Luick <dean.luick@cornelisnetworks.com>
    IB/hfi1: Restore allocated resources on failed copyout

Anastasia Belova <abelova@astralinux.ru>
    xfrm: compat: change expression for switch in xfrm_xlate64

Bastien Nocera <hadess@hadess.net>
    HID: logitech: Disable hi-res scrolling on USB

Devid Antonio Filoni <devid.filoni@egluetechnologies.com>
    can: j1939: do not wait 250 ms if the same addr was already claimed

Mark Brown <broonie@kernel.org>
    of/address: Return an error when no valid dma-ranges are found

Shiju Jose <shiju.jose@huawei.com>
    tracing: Fix poll() and select() do not work on per_cpu trace_pipe and trace_pipe_raw

Bjorn Helgaas <bhelgaas@google.com>
    Revert "PCI/ASPM: Refactor L1 PM Substates Control Register programming"

Bjorn Helgaas <bhelgaas@google.com>
    Revert "PCI/ASPM: Save L1 PM Substates Capability for suspend/resume"

Andy Chi <andy.chi@canonical.com>
    ALSA: hda/realtek: fix mute/micmute LEDs don't work for a HP platform.

Stefan Binding <sbinding@opensource.cirrus.com>
    ALSA: hda/realtek: Add quirk for ASUS UM3402 using CS35L41

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

Michael Kelley <mikelley@microsoft.com>
    hv_netvsc: Allocate memory in netvsc_dma_map() with GFP_ATOMIC


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/arm64/boot/dts/amlogic/meson-axg.dtsi         |   4 +-
 arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi  |   6 +-
 arch/arm64/boot/dts/amlogic/meson-gx.dtsi          |   6 +-
 arch/arm64/boot/dts/mediatek/mt8195.dtsi           |   4 +-
 arch/arm64/boot/dts/rockchip/rk3399.dtsi           |   2 -
 arch/arm64/boot/dts/rockchip/rk3568-rock-3a.dts    |   2 +-
 arch/powerpc/kernel/interrupt.c                    |   6 +-
 arch/riscv/kernel/probes/kprobes.c                 |   8 +-
 arch/riscv/kernel/stacktrace.c                     |   3 +-
 arch/riscv/mm/cacheflush.c                         |   4 +-
 drivers/clk/ingenic/jz4760-cgu.c                   |  18 ++-
 drivers/clk/microchip/clk-mpfs-ccc.c               |  10 +-
 drivers/cpufreq/qcom-cpufreq-hw.c                  |  24 ++--
 drivers/cxl/core/region.c                          |  12 +-
 drivers/firmware/efi/libstub/arm64-stub.c          |   9 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_fence.c          |   8 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm_pt.c          |   2 +-
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |  42 ++++---
 .../drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c  |   2 +-
 drivers/gpu/drm/amd/pm/amdgpu_pm.c                 |   2 +
 .../pm/swsmu/inc/pmfw_if/smu13_driver_if_v13_0_0.h |   5 +-
 .../pm/swsmu/inc/pmfw_if/smu13_driver_if_v13_0_7.h |  29 ++---
 drivers/gpu/drm/amd/pm/swsmu/inc/smu_v13_0.h       |   4 +-
 .../gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c   |   6 +
 .../gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c   |   1 +
 drivers/gpu/drm/i915/display/intel_bios.c          |  33 ++++--
 drivers/gpu/drm/i915/display/skl_watermark.c       |   3 +-
 drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c     |  14 +--
 drivers/gpu/drm/i915/gem/i915_gem_shmem.c          |   2 +-
 drivers/gpu/drm/virtio/virtgpu_ioctl.c             |   5 +-
 drivers/hid/amd-sfh-hid/amd_sfh_client.c           |  13 +-
 drivers/hid/amd-sfh-hid/amd_sfh_hid.h              |   1 +
 drivers/hid/hid-logitech-hidpp.c                   |   3 +-
 drivers/infiniband/hw/hfi1/file_ops.c              |   7 +-
 drivers/infiniband/hw/irdma/cm.c                   |   3 +
 drivers/infiniband/hw/usnic/usnic_uiom.c           |   8 +-
 drivers/infiniband/ulp/ipoib/ipoib_main.c          |   8 ++
 drivers/net/bonding/bond_debugfs.c                 |   2 +-
 drivers/net/dsa/mt7530.c                           |  26 ++--
 drivers/net/ethernet/cadence/macb_main.c           |  31 ++---
 drivers/net/ethernet/intel/ice/ice_main.c          |   2 +-
 drivers/net/ethernet/intel/ice/ice_switch.c        |   2 +-
 .../net/ethernet/intel/ice/ice_vf_vsi_vlan_ops.c   |  16 ++-
 drivers/net/ethernet/intel/igc/igc_main.c          |  25 +++-
 drivers/net/ethernet/mediatek/mtk_eth_soc.c        |   4 +-
 drivers/net/ethernet/mellanox/mlx5/core/debugfs.c  |   5 +-
 .../ethernet/mellanox/mlx5/core/diag/fw_tracer.c   |   3 +-
 drivers/net/ethernet/mellanox/mlx5/core/ecpf.c     |   2 +-
 .../ethernet/mellanox/mlx5/core/en/rep/bridge.c    |   4 -
 drivers/net/ethernet/mellanox/mlx5/core/en_fs.c    |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |  90 +++-----------
 .../net/ethernet/mellanox/mlx5/core/esw/bridge.c   |   2 +-
 .../ethernet/mellanox/mlx5/core/ipoib/ethtool.c    |  13 +-
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |  14 +--
 .../net/ethernet/mellanox/mlx5/core/pagealloc.c    |  37 +++---
 drivers/net/ethernet/mellanox/mlx5/core/sriov.c    |   2 +-
 drivers/net/ethernet/microchip/sparx5/sparx5_ptp.c |   4 +-
 drivers/net/ethernet/mscc/ocelot_flower.c          |  24 ++--
 drivers/net/ethernet/mscc/ocelot_ptp.c             |   8 +-
 drivers/net/ethernet/pensando/ionic/ionic_dev.c    |   9 +-
 drivers/net/ethernet/pensando/ionic/ionic_dev.h    |  12 ++
 drivers/net/ethernet/pensando/ionic/ionic_lif.c    |  56 ++++++++-
 drivers/net/ethernet/pensando/ionic/ionic_lif.h    |   2 +
 drivers/net/ethernet/pensando/ionic/ionic_main.c   |  29 +++++
 drivers/net/ethernet/pensando/ionic/ionic_txrx.c   | 110 +++++++++++++++--
 drivers/net/hyperv/netvsc.c                        |   2 +-
 drivers/net/phy/meson-gxl.c                        |   2 +
 drivers/net/phy/phylink.c                          |   5 +-
 drivers/net/usb/plusb.c                            |   4 +-
 drivers/nvdimm/Kconfig                             |  19 +++
 drivers/nvdimm/nd.h                                |   2 +-
 drivers/nvdimm/pfn_devs.c                          |  42 ++++---
 drivers/of/address.c                               |  21 +++-
 drivers/of/platform.c                              |  12 +-
 drivers/pci/pci.c                                  |   7 --
 drivers/pci/pci.h                                  |   4 -
 drivers/pci/pcie/aspm.c                            | 111 ++++++-----------
 drivers/pinctrl/aspeed/pinctrl-aspeed.c            |  13 +-
 drivers/pinctrl/intel/pinctrl-intel.c              |  16 ++-
 drivers/pinctrl/mediatek/pinctrl-mt8195.c          |   4 +-
 drivers/pinctrl/pinctrl-single.c                   |   2 +
 drivers/pinctrl/qcom/pinctrl-sm8450-lpass-lpi.c    |   2 +-
 drivers/spi/spi-dw-core.c                          |   2 +-
 drivers/usb/core/quirks.c                          |   3 +
 drivers/usb/typec/altmodes/displayport.c           |   8 +-
 drivers/video/fbdev/nvidia/nvidia.c                |  81 +++++++------
 fs/btrfs/tree-log.c                                |  23 +++-
 fs/btrfs/tree-log.h                                |   2 -
 fs/btrfs/volumes.c                                 |  22 +++-
 fs/btrfs/zlib.c                                    |   2 +-
 fs/ceph/mds_client.c                               |   6 +
 fs/cifs/file.c                                     |   4 +-
 include/linux/mlx5/driver.h                        |  13 +-
 include/linux/trace_events.h                       |   1 +
 include/trace/stages/stage4_event_fields.h         |   3 +-
 include/uapi/drm/virtgpu_drm.h                     |   1 +
 include/uapi/linux/ip.h                            |   1 +
 include/uapi/linux/ipv6.h                          |   1 +
 kernel/cgroup/cpuset.c                             |  18 +--
 kernel/locking/rtmutex.c                           |   5 +-
 kernel/trace/trace.c                               |   3 -
 kernel/trace/trace.h                               |   1 +
 kernel/trace/trace_events.c                        |  39 ++++--
 kernel/trace/trace_export.c                        |   3 +-
 mm/page_alloc.c                                    |   5 +-
 net/can/j1939/address-claim.c                      |  40 +++++++
 net/core/sock.c                                    |   3 +-
 net/ipv4/af_inet.c                                 |   1 +
 net/ipv4/inet_connection_sock.c                    |   3 -
 net/ipv6/af_inet6.c                                |   1 +
 net/mptcp/protocol.c                               |   9 ++
 net/mptcp/subflow.c                                |  10 +-
 net/rds/message.c                                  |   6 +-
 net/xfrm/xfrm_compat.c                             |   4 +-
 net/xfrm/xfrm_input.c                              |   3 +-
 net/xfrm/xfrm_policy.c                             |  11 +-
 net/xfrm/xfrm_state.c                              |  10 +-
 sound/pci/hda/patch_realtek.c                      |   9 ++
 sound/pci/lx6464es/lx_core.c                       |  11 +-
 sound/soc/codecs/tas5805m.c                        | 131 ++++++++++++++-------
 sound/soc/fsl/fsl_sai.c                            |   1 +
 sound/soc/soc-topology.c                           |   8 +-
 sound/synth/emux/emux_nrpn.c                       |   3 +
 tools/testing/selftests/net/forwarding/lib.sh      |   4 +-
 tools/testing/selftests/net/mptcp/mptcp_join.sh    |  22 +++-
 .../selftests/net/test_vxlan_vnifiltering.sh       |  18 +--
 127 files changed, 1079 insertions(+), 603 deletions(-)


