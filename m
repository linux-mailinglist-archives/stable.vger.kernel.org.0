Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAD8B4D8430
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 13:22:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241634AbiCNMXS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 08:23:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241991AbiCNMSk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 08:18:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B10CE3B294;
        Mon, 14 Mar 2022 05:13:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3A28DB80D24;
        Mon, 14 Mar 2022 12:13:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FA2AC340E9;
        Mon, 14 Mar 2022 12:13:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647259994;
        bh=OTspB8jGi90tCKJpani19RDmQ7o6fPaJ3+0caHcUoJo=;
        h=From:To:Cc:Subject:Date:From;
        b=xNetI5jhK8AGZlaC5Q2g6XSpTa5qTSwJ3Yy3VadHH1GgIwcxyEWz7M9RC0uaztJN0
         p+2j2j+XV6ldrXKyfwB0A1AxHG8Rlcgb+Ml6ihkfvHhgsWpeI0eeTD/mLhMHHOZjNR
         pfwrPgvjxRHKPOlZKir/cT2yJYdincKgvTnkkKP4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Subject: [PATCH 5.16 000/121] 5.16.15-rc1 review
Date:   Mon, 14 Mar 2022 12:53:03 +0100
Message-Id: <20220314112744.120491875@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.16.15-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.16.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.16.15-rc1
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

This is the start of the stable review cycle for the 5.16.15 release.
There are 121 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 16 Mar 2022 11:27:22 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.16.15-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.16.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.16.15-rc1

Niklas Cassel <niklas.cassel@wdc.com>
    riscv: dts: k210: fix broken IRQs on hart1

Filipe Manana <fdmanana@suse.com>
    btrfs: make send work with concurrent block group relocation

Zhengjun Xing <zhengjun.xing@linux.intel.com>
    perf parse: Fix event parser error for hybrid systems

Thomas Zimmermann <tzimmermann@suse.de>
    drm/panel: Select DRM_DP_HELPER for DRM_PANEL_EDP

Li Huafei <lihuafei1@huawei.com>
    x86/traps: Mark do_int3() NOKPROBE_SYMBOL

Jarkko Sakkinen <jarkko@kernel.org>
    x86/sgx: Free backing memory after faulting the enclave page

Peter Zijlstra <peterz@infradead.org>
    x86/module: Fix the paravirt vs alternative order

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

David Howells <dhowells@redhat.com>
    watch_queue: Fix filter limit check

Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
    ARM: fix Thumb2 regression with Spectre BHB

Dima Chumak <dchumak@nvidia.com>
    net/mlx5: Fix offloading with ESWITCH_IPV4_TTL_MODIFY_ENABLE

Michael S. Tsirkin <mst@redhat.com>
    virtio: acknowledge all features before access

Michael S. Tsirkin <mst@redhat.com>
    virtio: unexport virtio_finalize_features

Halil Pasic <pasic@linux.ibm.com>
    swiotlb: rework "fix info leak with DMA_FROM_DEVICE"

Paul Semel <semelpaul@gmail.com>
    arm64: kasan: fix include error in MTE functions

Catalin Marinas <catalin.marinas@arm.com>
    arm64: Ensure execute-only permissions are not allowed without EPAN

Pali Rohár <pali@kernel.org>
    arm64: dts: marvell: armada-37xx: Remap IO space to bus address 0x0

Daniel Bristot de Oliveira <bristot@kernel.org>
    tracing/osnoise: Do not unregister events twice

Nicolas Saenz Julienne <nsaenzju@redhat.com>
    tracing/osnoise: Force quiescent states while tracing

Emil Renner Berthing <kernel@esmil.dk>
    riscv: Fix auipc+jalr relocation range checks

Rong Chen <rong.chen@amlogic.com>
    mmc: meson: Fix usage of meson_mmc_post_req()

Jisheng Zhang <jszhang@kernel.org>
    riscv: alternative only works on !XIP_KERNEL

Robert Hancock <robert.hancock@calian.com>
    net: macb: Fix lost RX packet wakeup race in NAPI receive

Dan Carpenter <dan.carpenter@oracle.com>
    staging: gdm724x: fix use after free in gdm_lte_rx()

Hans de Goede <hdegoede@redhat.com>
    staging: rtl8723bs: Fix access-point mode deadlock

Miklos Szeredi <mszeredi@redhat.com>
    fuse: fix pipe buffer lifetime for direct_io

Miklos Szeredi <mszeredi@redhat.com>
    fuse: fix fileattr op failure

Randy Dunlap <rdunlap@infradead.org>
    ARM: Spectre-BHB: provide empty stub for non-config

Mike Kravetz <mike.kravetz@oracle.com>
    selftests/memfd: clean up mapping in mfd_fail_write

Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
    selftest/vm: fix map_fixed_noreplace test failure

Christophe Leroy <christophe.leroy@csgroup.eu>
    tracing: Fix selftest config check for function graph start up test

Daniel Bristot de Oliveira <bristot@kernel.org>
    tracing/osnoise: Make osnoise_main to sleep for microseconds

Sven Schnelle <svens@linux.ibm.com>
    tracing: Ensure trace buffer is at least 4096 bytes large

Niels Dossche <dossche.niels@gmail.com>
    ipv6: prevent a possible race condition with lifetimes

Marek Marczykowski-Górecki <marmarek@invisiblethingslab.com>
    Revert "xen-netback: Check for hotplug-status existence before watching"

Marek Marczykowski-Górecki <marmarek@invisiblethingslab.com>
    Revert "xen-netback: remove 'hotplug-status' once it has served its purpose"

Guchun Chen <guchun.chen@amd.com>
    drm/amdgpu: bypass tiling flag check in virtual display case (v2)

Shreeya Patel <shreeya.patel@collabora.com>
    gpio: Return EPROBE_DEFER if gc->to_irq is NULL

Alex Deucher <alexander.deucher@amd.com>
    PCI: Mark all AMD Navi10 and Navi14 GPU ATS as broken

Varun Prakash <varun@chelsio.com>
    nvme-tcp: send H2CData PDUs based on MAXH2CDATA

Vikash Chandola <vikash.chandola@linux.intel.com>
    hwmon: (pmbus) Clear pmbus fault/warning bits after read

suresh kumar <suresh2514@gmail.com>
    net-sysfs: add check for netdevice being present to speed_show

Duoming Zhou <duoming@zju.edu.cn>
    drivers: hamradio: 6pack: fix UAF bug caused by mod_timer()

Wanpeng Li <wanpengli@tencent.com>
    x86/kvm: Don't use pv tlb/ipi/sched_yield if on 1 vCPU

Nikhil Gupta <nikhil.gupta@nxp.com>
    of/fdt: move elfcorehdr reservation early for crash dump kernel

Maxime Ripard <maxime@cerno.tech>
    drm/vc4: hdmi: Unregister codec device on unbind

Jon Lin <jon.lin@rock-chips.com>
    spi: rockchip: terminate dma transmission when slave abort

Jon Lin <jon.lin@rock-chips.com>
    spi: rockchip: Fix error in getting num-cs property

Anton Romanov <romanton@google.com>
    kvm: x86: Disable KVM_HC_CLOCK_PAIRING if tsc is in always catchup mode

Wanpeng Li <wanpengli@tencent.com>
    KVM: Fix lockdep false negative during host resume

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    pinctrl: tigerlake: Revert "Add Alder Lake-M ACPI ID"

Heikki Krogerus <heikki.krogerus@linux.intel.com>
    usb: dwc3: pci: add support for the Intel Raptor Lake-S

Halil Pasic <pasic@linux.ibm.com>
    swiotlb: fix info leak with DMA_FROM_DEVICE

Kumar Kartikeya Dwivedi <memxor@gmail.com>
    selftests/bpf: Add test for bpf_timer overwriting crash

Heiner Kallweit <hkallweit1@gmail.com>
    net: phy: meson-gxl: improve link-up behavior

Jeremy Linton <jeremy.linton@arm.com>
    net: bcmgenet: Don't claim WOL when its not available

Jianglei Nie <niejianglei2021@163.com>
    net: arc_emac: Fix use after free in arc_mdio_probe()

Eric Dumazet <edumazet@google.com>
    sctp: fix kernel-infoleak for SCTP sockets

Clément Léger <clement.leger@bootlin.com>
    net: phy: DP83822: clear MISR2 register to disable interrupts

Miaoqian Lin <linmq006@gmail.com>
    gianfar: ethtool: Fix refcount leak in gfar_get_ts_info

Linus Torvalds <torvalds@linux-foundation.org>
    mm: gup: make fault_in_safe_writeable() use fixup_user_fault()

Mark Featherston <mark@embeddedTS.com>
    gpio: ts4900: Do not set DAT and OE together

Guillaume Nault <gnault@redhat.com>
    selftests: pmtu.sh: Kill nettest processes launched in subshell.

Guillaume Nault <gnault@redhat.com>
    selftests: pmtu.sh: Kill tcpdump processes launched by subshell.

Pavel Skripkin <paskripkin@gmail.com>
    NFC: port100: fix use-after-free in port100_send_complete

Ben Ben-Ishay <benishay@nvidia.com>
    net/mlx5e: SHAMPO, reduce TIR indication

Roi Dayan <roid@nvidia.com>
    net/mlx5e: Lag, Only handle events from highest priority multipath entry

Moshe Shemesh <moshe@nvidia.com>
    net/mlx5: Fix a race on command flush flow

Mohammad Kabat <mohammadkab@nvidia.com>
    net/mlx5: Fix size field in bufferx_reg struct

Duoming Zhou <duoming@zju.edu.cn>
    ax25: Fix NULL pointer dereference in ax25_kill_by_device

Miaoqian Lin <linmq006@gmail.com>
    net: marvell: prestera: Add missing of_node_put() in prestera_switch_set_base_mac_addr

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

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    ice: Don't use GFP_KERNEL in atomic context

Dave Ertman <david.m.ertman@intel.com>
    ice: Fix error with handling of bonding MTU

Jacob Keller <jacob.e.keller@intel.com>
    ice: stop disabling VFs due to PF error responses

Jacob Keller <jacob.e.keller@intel.com>
    i40e: stop disabling VFs due to PF error responses

Michal Maloszewski <michal.maloszewski@intel.com>
    iavf: Fix handling of vlan strip virtual channel messages

Joel Stanley <joel@jms.id.au>
    ARM: dts: aspeed: Fix AST2600 quad spi group

Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
    net: dsa: mt7530: fix incorrect test in mt753x_phylink_validate()

Jernej Skrabec <jernej.skrabec@gmail.com>
    drm/sun4i: mixer: Fix P010 and P210 format numbers

Jouni Högander <jouni.hogander@intel.com>
    drm/i915/psr: Set "SF Partial Frame Enable" also on full update

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    gpiolib: acpi: Convert ACPI value of debounce to microseconds

Fabio Estevam <festevam@denx.de>
    smsc95xx: Ignore -ENODEV errors when device is unplugged

Tom Rix <trix@redhat.com>
    qed: return status of qed_iov_get_link

Eric Dumazet <edumazet@google.com>
    net: gro: move skb_gro_receive_list to udp_offload.c

Steffen Klassert <steffen.klassert@secunet.com>
    esp: Fix BEET mode inter address family tunneling on GSO

Steffen Klassert <steffen.klassert@secunet.com>
    esp: Fix possible buffer overflow in ESP transformation

Jia-Ju Bai <baijiaju1990@gmail.com>
    net: qlogic: check the return value of dma_alloc_coherent() in qed_vf_hw_prepare()

Jia-Ju Bai <baijiaju1990@gmail.com>
    isdn: hfcpci: check the return value of dma_set_mask() in setup_hw()

Zhang Min <zhang.min9@zte.com.cn>
    vdpa: fix use-after-free on vp_vdpa_remove

Xie Yongji <xieyongji@bytedance.com>
    virtio-blk: Remove BUG_ON() in virtio_queue_rq()

Xie Yongji <xieyongji@bytedance.com>
    virtio-blk: Don't use MAX_DISCARD_SEGMENTS if max_discard_seg is zero

Anirudh Rayabharam <mail@anirudhrb.com>
    vhost: fix hung thread due to erroneous iotlb entries

Alexey Khoroshilov <khoroshilov@ispras.ru>
    mISDN: Fix memory leak in dsp_pipeline_build()

Heiner Kallweit <hkallweit1@gmail.com>
    net: phy: meson-gxl: fix interrupt handling in forced mode

Xie Yongji <xieyongji@bytedance.com>
    vduse: Fix returning wrong type in vduse_domain_alloc_iova()

Si-Wei Liu <si-wei.liu@oracle.com>
    vdpa/mlx5: add validation for VIRTIO_NET_CTRL_MQ_VQ_PAIRS_SET command

Tung Nguyen <tung.q.nguyen@dektech.com.au>
    tipc: fix kernel panic when enabling bearer

Pali Rohár <pali@kernel.org>
    arm64: dts: armada-3720-turris-mox: Add missing ethernet0 alias

Jia-Ju Bai <baijiaju1990@gmail.com>
    HID: nintendo: check the return value of alloc_workqueue()

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    HID: vivaldi: fix sysfs attributes leak

AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
    soc: mediatek: mt8192-mmsys: Fix dither to dsi0 path's input sel

Taniya Das <tdas@codeaurora.org>
    clk: qcom: dispcc: Update the transition delay for MDSS GDSC

Taniya Das <tdas@codeaurora.org>
    clk: qcom: gdsc: Add support to update GDSC transition delay

Maxime Ripard <maxime@cerno.tech>
    ARM: boot: dts: bcm2711: Fix HVS register range

Pavel Skripkin <paskripkin@gmail.com>
    HID: hid-thrustmaster: fix OOB read in thrustmaster_interrupts

Jiri Kosina <jkosina@suse.cz>
    HID: elo: Revert USB reference counting

Bjorn Andersson <bjorn.andersson@linaro.org>
    arm64: dts: qcom: sm8350: Correct UFS symbol clocks

Konrad Dybcio <konrad.dybcio@somainline.org>
    arm64: dts: qcom: sm8350: Describe GCC dependency clocks


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/arm/boot/dts/aspeed-g6-pinctrl.dtsi           |   2 +-
 arch/arm/boot/dts/bcm2711.dtsi                     |   1 +
 arch/arm/include/asm/spectre.h                     |   6 +
 arch/arm/kernel/entry-armv.S                       |   4 +-
 arch/arm64/Kconfig                                 |   3 -
 .../boot/dts/marvell/armada-3720-turris-mox.dts    |   8 +-
 arch/arm64/boot/dts/marvell/armada-37xx.dtsi       |   2 +-
 arch/arm64/boot/dts/qcom/sm8350.dtsi               |  48 ++-
 arch/arm64/include/asm/mte-kasan.h                 |   1 +
 arch/arm64/include/asm/pgtable-prot.h              |   4 +-
 arch/arm64/include/asm/pgtable.h                   |  11 -
 arch/arm64/mm/mmap.c                               |  17 +
 arch/riscv/Kconfig.erratas                         |   1 +
 arch/riscv/Kconfig.socs                            |   4 +-
 arch/riscv/boot/dts/canaan/k210.dtsi               |   3 +-
 arch/riscv/kernel/module.c                         |  21 +-
 arch/x86/kernel/cpu/sgx/encl.c                     |  57 +++-
 arch/x86/kernel/e820.c                             |  41 ++-
 arch/x86/kernel/kdebugfs.c                         |  37 ++-
 arch/x86/kernel/ksysfs.c                           |  77 ++++-
 arch/x86/kernel/kvm.c                              |   9 +-
 arch/x86/kernel/module.c                           |  13 +-
 arch/x86/kernel/setup.c                            |  34 +-
 arch/x86/kernel/traps.c                            |   1 +
 arch/x86/kvm/x86.c                                 |   7 +
 arch/x86/mm/ioremap.c                              |  57 +++-
 drivers/block/virtio_blk.c                         |  20 +-
 drivers/clk/qcom/dispcc-sc7180.c                   |   5 +-
 drivers/clk/qcom/dispcc-sc7280.c                   |   5 +-
 drivers/clk/qcom/dispcc-sm8250.c                   |   5 +-
 drivers/clk/qcom/gdsc.c                            |  26 +-
 drivers/clk/qcom/gdsc.h                            |   8 +-
 drivers/gpio/gpio-ts4900.c                         |  24 +-
 drivers/gpio/gpiolib-acpi.c                        |   6 +-
 drivers/gpio/gpiolib.c                             |  20 ++
 drivers/gpu/drm/amd/amdgpu/amdgpu_display.c        |   2 +-
 drivers/gpu/drm/i915/display/intel_psr.c           |  16 +-
 drivers/gpu/drm/i915/i915_reg.h                    |   1 +
 drivers/gpu/drm/panel/Kconfig                      |   1 +
 drivers/gpu/drm/sun4i/sun8i_mixer.h                |   8 +-
 drivers/gpu/drm/vc4/vc4_hdmi.c                     |   8 +
 drivers/gpu/drm/vc4/vc4_hdmi.h                     |   1 +
 drivers/hid/hid-elo.c                              |   7 +-
 drivers/hid/hid-nintendo.c                         |   4 +
 drivers/hid/hid-thrustmaster.c                     |   6 +
 drivers/hid/hid-vivaldi.c                          |   2 +-
 drivers/hwmon/pmbus/pmbus_core.c                   |   5 +
 drivers/isdn/hardware/mISDN/hfcpci.c               |   6 +-
 drivers/isdn/mISDN/dsp_pipeline.c                  |   6 +-
 drivers/mmc/host/meson-gx-mmc.c                    |  15 +-
 drivers/net/dsa/mt7530.c                           |   2 +-
 drivers/net/ethernet/arc/emac_mdio.c               |   5 +-
 drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c |   7 +
 drivers/net/ethernet/cadence/macb_main.c           |  25 +-
 drivers/net/ethernet/freescale/gianfar_ethtool.c   |   1 +
 drivers/net/ethernet/intel/i40e/i40e_debugfs.c     |   6 +-
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c |  57 +---
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.h |   5 -
 drivers/net/ethernet/intel/iavf/iavf_virtchnl.c    |  40 +++
 drivers/net/ethernet/intel/ice/ice.h               |   1 +
 drivers/net/ethernet/intel/ice/ice_ethtool.c       |   2 +-
 drivers/net/ethernet/intel/ice/ice_main.c          |  31 +-
 drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c   |  18 --
 drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h   |   3 -
 .../net/ethernet/marvell/prestera/prestera_main.c  |   1 +
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c      |  15 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/tir.c   |   3 -
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |   3 +-
 drivers/net/ethernet/mellanox/mlx5/core/lag/mp.c   |  11 +-
 .../ethernet/mellanox/mlx5/core/lib/fs_chains.c    |   3 -
 drivers/net/ethernet/nxp/lpc_eth.c                 |   5 +-
 drivers/net/ethernet/qlogic/qed/qed_sriov.c        |  18 +-
 drivers/net/ethernet/qlogic/qed/qed_vf.c           |   7 +
 drivers/net/ethernet/ti/cpts.c                     |   4 +-
 drivers/net/ethernet/xilinx/xilinx_emaclite.c      |   4 +-
 drivers/net/hamradio/6pack.c                       |   4 +-
 drivers/net/phy/dp83822.c                          |   2 +-
 drivers/net/phy/meson-gxl.c                        |  31 +-
 drivers/net/usb/smsc95xx.c                         |  28 +-
 drivers/net/xen-netback/xenbus.c                   |  14 +-
 drivers/nfc/port100.c                              |   2 +
 drivers/nvme/host/tcp.c                            |  63 +++-
 drivers/of/fdt.c                                   |   2 +-
 drivers/pci/quirks.c                               |  14 +-
 drivers/pinctrl/intel/pinctrl-tigerlake.c          |   1 -
 drivers/soc/mediatek/mt8192-mmsys.h                |   3 +-
 drivers/spi/spi-rockchip.c                         |  13 +-
 drivers/staging/gdm724x/gdm_lte.c                  |   5 +-
 drivers/staging/rtl8723bs/core/rtw_mlme_ext.c      |   7 +-
 drivers/staging/rtl8723bs/core/rtw_recv.c          |  10 +-
 drivers/staging/rtl8723bs/core/rtw_sta_mgt.c       |  22 +-
 drivers/staging/rtl8723bs/core/rtw_xmit.c          |  16 +-
 drivers/staging/rtl8723bs/hal/rtl8723bs_xmit.c     |   2 +
 drivers/usb/dwc3/dwc3-pci.c                        |   4 +
 drivers/vdpa/mlx5/net/mlx5_vnet.c                  |  16 +
 drivers/vdpa/vdpa_user/iova_domain.c               |   2 +-
 drivers/vdpa/virtio_pci/vp_vdpa.c                  |   2 +-
 drivers/vhost/iotlb.c                              |  11 +
 drivers/vhost/vhost.c                              |   5 +
 drivers/virtio/virtio.c                            |  40 +--
 fs/btrfs/block-group.c                             |   9 +-
 fs/btrfs/ctree.c                                   |  98 ++++--
 fs/btrfs/ctree.h                                   |  14 +-
 fs/btrfs/disk-io.c                                 |   4 +-
 fs/btrfs/relocation.c                              |  13 -
 fs/btrfs/send.c                                    | 357 ++++++++++++++++++---
 fs/btrfs/transaction.c                             |   4 +
 fs/fuse/dev.c                                      |  12 +-
 fs/fuse/file.c                                     |   1 +
 fs/fuse/fuse_i.h                                   |   1 +
 fs/fuse/ioctl.c                                    |   9 +-
 fs/pipe.c                                          |  11 +-
 include/linux/mlx5/mlx5_ifc.h                      |   5 +-
 include/linux/netdevice.h                          |   1 -
 include/linux/nvme-tcp.h                           |   1 +
 include/linux/virtio.h                             |   1 -
 include/linux/virtio_config.h                      |   3 +-
 include/linux/watch_queue.h                        |   3 +-
 include/net/esp.h                                  |   2 +
 kernel/dma/swiotlb.c                               |  22 +-
 kernel/trace/trace.c                               |  10 +-
 kernel/trace/trace_osnoise.c                       |  84 +++--
 kernel/trace/trace_selftest.c                      |   6 +-
 kernel/watch_queue.c                               |  15 +-
 mm/gup.c                                           |  57 ++--
 net/ax25/af_ax25.c                                 |   7 +
 net/core/net-sysfs.c                               |   2 +-
 net/core/skbuff.c                                  |  26 --
 net/ipv4/esp4.c                                    |   5 +
 net/ipv4/esp4_offload.c                            |   3 +
 net/ipv4/udp_offload.c                             |  27 ++
 net/ipv6/addrconf.c                                |   2 +
 net/ipv6/esp6.c                                    |   5 +
 net/ipv6/esp6_offload.c                            |   3 +
 net/sctp/diag.c                                    |   9 +-
 net/tipc/bearer.c                                  |  12 +-
 net/tipc/link.c                                    |   9 +-
 tools/perf/util/parse-events.c                     |   6 +-
 .../testing/selftests/bpf/prog_tests/timer_crash.c |  32 ++
 tools/testing/selftests/bpf/progs/timer_crash.c    |  54 ++++
 tools/testing/selftests/memfd/memfd_test.c         |   1 +
 tools/testing/selftests/net/pmtu.sh                |  21 +-
 tools/testing/selftests/vm/map_fixed_noreplace.c   |  49 ++-
 virt/kvm/kvm_main.c                                |   4 +-
 145 files changed, 1650 insertions(+), 646 deletions(-)


