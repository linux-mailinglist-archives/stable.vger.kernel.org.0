Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 423064D0420
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 17:28:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237709AbiCGQ3n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 11:29:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244177AbiCGQ3m (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 11:29:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC36C583B5;
        Mon,  7 Mar 2022 08:28:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 84A5CB81639;
        Mon,  7 Mar 2022 16:28:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7EDDC340E9;
        Mon,  7 Mar 2022 16:28:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646670524;
        bh=GioW1pHTtvaWQFkIp6/Ap6rArKNuTqOQCVYeg6PxgM0=;
        h=From:To:Cc:Subject:Date:From;
        b=nhwUiqyxNCgT5jV+xtQwqY9ZSk9CaOWHi2c+6JWgGUZZQYO4G2YvLId979NAgt+fN
         wLeaugaXOi5igSU1GdK2Z2nqWrdFdjQ3gYhbx5rHWHuyWksC4zxMXkt5rkWoljwVX3
         OXeM7yWhve1/YJOqC8tAbfZi9VtIJTtKKKy+vhg8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Subject: [PATCH 5.10 000/104] 5.10.104-rc2 review
Date:   Mon,  7 Mar 2022 17:28:41 +0100
Message-Id: <20220307162142.066663718@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.104-rc2.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.104-rc2
X-KernelTest-Deadline: 2022-03-09T16:21+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.10.104 release.
There are 104 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 09 Mar 2022 16:21:24 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.104-rc2.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.10.104-rc2

Jiri Bohac <jbohac@suse.cz>
    Revert "xfrm: xfrm_state_mtu should return at least 1280 for ipv6"

Filipe Manana <fdmanana@suse.com>
    btrfs: add missing run of delayed items after unlink during log replay

Sidong Yang <realwakka@gmail.com>
    btrfs: qgroup: fix deadlock between rescan worker and remove qgroup

Filipe Manana <fdmanana@suse.com>
    btrfs: fix lost prealloc extents beyond eof after full fsync

Randy Dunlap <rdunlap@infradead.org>
    tracing: Fix return value of __setup handlers

Steven Rostedt (Google) <rostedt@goodmis.org>
    tracing/histogram: Fix sorting on old "cpu" value

William Mahon <wmahon@chromium.org>
    HID: add mapping for KEY_ALL_APPLICATIONS

William Mahon <wmahon@chromium.org>
    HID: add mapping for KEY_DICTATE

David Gow <davidgow@google.com>
    Input: samsung-keypad - properly state IOMEM dependency

Hans de Goede <hdegoede@redhat.com>
    Input: elan_i2c - fix regulator enable count imbalance after suspend/resume

Hans de Goede <hdegoede@redhat.com>
    Input: elan_i2c - move regulator_[en|dis]able() out of elan_[en|dis]able_power()

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dcb: disable softirqs in dcbnl_flush_dev()

Qiang Yu <qiang.yu@amd.com>
    drm/amdgpu: fix suspend/resume hang regression

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    nl80211: Handle nla_memdup failures in handle_nan_filter

Mateusz Palczewski <mateusz.palczewski@intel.com>
    iavf: Refactor iavf state machine tracking

Jia-Ju Bai <baijiaju1990@gmail.com>
    net: chelsio: cxgb3: check the return value of pci_find_capability()

Sukadev Bhattiprolu <sukadev@linux.ibm.com>
    ibmvnic: complete init_done on transport events

Thierry Reding <treding@nvidia.com>
    ARM: tegra: Move panels to AUX bus

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    soc: fsl: qe: Check of ioremap return value

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    soc: fsl: guts: Add a missing memory allocation failure check

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    soc: fsl: guts: Revert commit 3c0d64e867ed

Anthoine Bourgeois <anthoine.bourgeois@gmail.com>
    ARM: dts: Use 32KiHz oscillator on devkit8000

Anthoine Bourgeois <anthoine.bourgeois@gmail.com>
    ARM: dts: switch timer config to common devkit8000 devicetree

Heiko Carstens <hca@linux.ibm.com>
    s390/extable: fix exception table sorting

Hugh Dickins <hughd@google.com>
    memfd: fix F_SEAL_WRITE after shmem huge page allocated

Sukadev Bhattiprolu <sukadev@linux.ibm.com>
    ibmvnic: free reset-work-item when flushing

Sasha Neftin <sasha.neftin@intel.com>
    igc: igc_write_phy_reg_gpy: drop premature return

Samuel Holland <samuel@sholland.org>
    pinctrl: sunxi: Use unique lockdep classes for IRQs

Amit Cohen <amcohen@nvidia.com>
    selftests: mlxsw: tc_police_scale: Make test more robust

Randy Dunlap <rdunlap@infradead.org>
    ARM: 9182/1: mmu: fix returns from early_param() and __setup() functions

Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
    ARM: Fix kgdb breakpoint for Thumb2

Corinna Vinschen <vinschen@redhat.com>
    igc: igc_read_phy_reg_gpy: drop premature return

Brian Norris <briannorris@chromium.org>
    arm64: dts: rockchip: Switch RK3399-Gru DP to SPDIF output

Vincent Mailhol <mailhol.vincent@wanadoo.fr>
    can: gs_usb: change active_channels's type from atomic_t to u8

Fabio Estevam <festevam@denx.de>
    ASoC: cs4265: Fix the duplicated control name

Alyssa Ross <hi@alyssa.is>
    firmware: arm_scmi: Remove space in MODULE_ALIAS name

Jann Horn <jannh@google.com>
    efivars: Respect "block" flag in efivar_entry_set_safe()

Maciej Fijalkowski <maciej.fijalkowski@intel.com>
    ixgbe: xsk: change !netif_carrier_ok() handling in ixgbe_xmit_zc()

Zheyu Ma <zheyuma97@gmail.com>
    net: arcnet: com20020: Fix null-ptr-deref in com20020pci_probe()

Sukadev Bhattiprolu <sukadev@linux.ibm.com>
    ibmvnic: register netdev after init of adapter

Randy Dunlap <rdunlap@infradead.org>
    net: sxgbe: fix return value of __setup handler

Slawomir Laba <slawomirx.laba@intel.com>
    iavf: Fix missing check for running netdev

Johannes Berg <johannes.berg@intel.com>
    mac80211: treat some SAE auth steps as final

Randy Dunlap <rdunlap@infradead.org>
    net: stmmac: fix return value of __setup handler

Nicolas Escande <nico.escande@gmail.com>
    mac80211: fix forwarded mesh frames AC & queue selection

Valentin Schneider <valentin.schneider@arm.com>
    ia64: ensure proper NUMA distance and possible map initialization

Dietmar Eggemann <dietmar.eggemann@arm.com>
    sched/topology: Fix sched_domain_topology_level alloc in sched_init_numa()

Valentin Schneider <valentin.schneider@arm.com>
    sched/topology: Make sched_init_numa() use a set for the deduplicating sort

Jacob Keller <jacob.e.keller@intel.com>
    ice: fix concurrent reset and removal of VFs

Brett Creeley <brett.creeley@intel.com>
    ice: Fix race conditions between virtchnl handling and VF ndo ops

Frederic Weisbecker <frederic@kernel.org>
    rcu/nocb: Fix missed nocb_timer requeue

D. Wythe <alibuda@linux.alibaba.com>
    net/smc: fix unexpected SMC_CLC_DECL_ERR_REGRMB error cause by server

D. Wythe <alibuda@linux.alibaba.com>
    net/smc: fix unexpected SMC_CLC_DECL_ERR_REGRMB error generated by client

D. Wythe <alibuda@linux.alibaba.com>
    net/smc: fix connection leak

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dcb: flush lingering app table entries for unregistered devices

j.nixdorf@avm.de <j.nixdorf@avm.de>
    net: ipv6: ensure we call ipv6_mc_down() at most once

Sven Eckelmann <sven@narfation.org>
    batman-adv: Don't expect inter-netns unique iflink indices

Sven Eckelmann <sven@narfation.org>
    batman-adv: Request iflink once in batadv_get_real_netdevice

Sven Eckelmann <sven@narfation.org>
    batman-adv: Request iflink once in batadv-on-batadv check

Florian Westphal <fw@strlen.de>
    netfilter: nf_queue: handle socket prefetch

Florian Westphal <fw@strlen.de>
    netfilter: nf_queue: fix possible use-after-free

Florian Westphal <fw@strlen.de>
    netfilter: nf_queue: don't assume sk is full socket

lena wang <lena.wang@mediatek.com>
    net: fix up skbs delta_truesize in UDP GRO frag_list

Sasha Neftin <sasha.neftin@intel.com>
    e1000e: Correct NVM checksum verification flow

Leon Romanovsky <leon@kernel.org>
    xfrm: enforce validity of offload input flags

Antony Antony <antony.antony@secunet.com>
    xfrm: fix the if_id check in changelink

Eric Dumazet <edumazet@google.com>
    bpf, sockmap: Do not ignore orig_len parameter

Eric Dumazet <edumazet@google.com>
    netfilter: fix use-after-free in __nf_register_net_hook()

Jiri Bohac <jbohac@suse.cz>
    xfrm: fix MTU regression

Daniel Borkmann <daniel@iogearbox.net>
    mm: Consider __GFP_NOWARN flag for oversized kvmalloc() calls

Dave Jiang <dave.jiang@intel.com>
    ntb: intel: fix port config status offset for SPR

Nicolas Cavallari <nicolas.cavallari@green-communications.fr>
    thermal: core: Fix TZ_GET_TRIP NULL pointer dereference

Marek Marczykowski-Górecki <marmarek@invisiblethingslab.com>
    xen/netfront: destroy queues before real_num_tx_queues is zeroed

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/i915: s/JSP2/ICP2/ PCH

Lennert Buytenhek <buytenh@wantstofly.org>
    iommu/amd: Recover from event log overflow

Marek Vasut <marex@denx.de>
    ASoC: ops: Shift tested values in snd_soc_put_volsw() by +min

Alexandre Ghiti <alexandre.ghiti@canonical.com>
    riscv: Fix config KASAN && DEBUG_VIRTUAL

Alexandre Ghiti <alexandre.ghiti@canonical.com>
    riscv: Fix config KASAN && SPARSEMEM && !SPARSE_VMEMMAP

Sunil V L <sunilvl@ventanamicro.com>
    riscv/efi_stub: Fix get_boot_hartid_from_fdt() return value

Zhen Ni <nizhen@uniontech.com>
    ALSA: intel_hdmi: Fix reference to PCM buffer address

Steven Rostedt <rostedt@goodmis.org>
    tracing: Add ustring operation to filtering string pointers

Qiang Yu <qiang.yu@amd.com>
    drm/amdgpu: check vm ready by amdgpu_vm->evicting flag

Sergey Shtylyov <s.shtylyov@omp.ru>
    ata: pata_hpt37x: fix PCI clock detection

Valentin Caron <valentin.caron@foss.st.com>
    serial: stm32: prevent TDR register overwrite when sending x_char

Steven Rostedt <rostedt@goodmis.org>
    tracing: Add test for user space strings when filtering on string pointers

Christophe Vu-Brugier <christophe.vu-brugier@seagate.com>
    exfat: fix i_blocks for files truncated over 4 GiB

Christophe Vu-Brugier <christophe.vu-brugier@seagate.com>
    exfat: reuse exfat_inode_info variable instead of calling EXFAT_I()

Hangyu Hua <hbh25y@gmail.com>
    usb: gadget: clear related members when goto fail

Hangyu Hua <hbh25y@gmail.com>
    usb: gadget: don't release an existing dev->buf

Daniele Palmas <dnlplm@gmail.com>
    net: usb: cdc_mbim: avoid altsetting toggling for Telit FN990

Wolfram Sang <wsa@kernel.org>
    i2c: qup: allow COMPILE_TEST

Wolfram Sang <wsa@kernel.org>
    i2c: cadence: allow COMPILE_TEST

Yongzhi Liu <lyz_cs@pku.edu.cn>
    dmaengine: shdma: Fix runtime PM imbalance on error

Sherry Yang <sherry.yang@oracle.com>
    selftests/seccomp: Fix seccomp failure by adding missing headers

Ronnie Sahlberg <lsahlber@redhat.com>
    cifs: fix double free race when mount fails in cifs_get_root()

Hangyu Hua <hbh25y@gmail.com>
    tipc: fix a bit overflow in tipc_crypto_key_rcv()

Marc Zyngier <maz@kernel.org>
    KVM: arm64: vgic: Read HW interrupt pending state from the HW

José Expósito <jose.exposito89@gmail.com>
    Input: clear BTN_RIGHT/MIDDLE on buttonpads

Oliver Barta <oliver.barta@aptiv.com>
    regulator: core: fix false positive in regulator_late_cleanup()

Kai Vehmanen <kai.vehmanen@linux.intel.com>
    ASoC: rt5682: do not block workqueue if card is unbound

Kai Vehmanen <kai.vehmanen@linux.intel.com>
    ASoC: rt5668: do not block workqueue if card is unbound

Eric Anholt <eric@anholt.net>
    i2c: bcm2835: Avoid clock stretching timeouts

JaeMan Park <jaeman@google.com>
    mac80211_hwsim: initialize ieee80211_tx_info at hw_scan_work

Benjamin Beichler <benjamin.beichler@uni-rostock.de>
    mac80211_hwsim: report NOACK frames in tx_status


-------------

Diffstat:

 Documentation/trace/events.rst                     |  19 ++++
 Makefile                                           |   4 +-
 arch/arm/boot/dts/omap3-devkit8000-common.dtsi     |  18 ++++
 arch/arm/boot/dts/omap3-devkit8000.dts             |  33 -------
 arch/arm/boot/dts/tegra124-nyan-big.dts            |  15 +--
 arch/arm/boot/dts/tegra124-nyan-blaze.dts          |  15 +--
 arch/arm/boot/dts/tegra124-venice2.dts             |  14 +--
 arch/arm/kernel/kgdb.c                             |  36 +++++--
 arch/arm/mm/mmu.c                                  |   2 +
 arch/arm64/boot/dts/rockchip/rk3399-gru.dtsi       |  17 +++-
 arch/arm64/kvm/vgic/vgic-mmio.c                    |   2 +
 arch/ia64/kernel/acpi.c                            |   7 +-
 arch/riscv/mm/Makefile                             |   3 +
 arch/riscv/mm/kasan_init.c                         |   3 +-
 arch/s390/include/asm/extable.h                    |   9 +-
 drivers/ata/pata_hpt37x.c                          |   4 +-
 drivers/clocksource/timer-ti-dm-systimer.c         |   3 +-
 drivers/dma/sh/shdma-base.c                        |   4 +-
 drivers/firmware/arm_scmi/driver.c                 |   2 +-
 drivers/firmware/efi/libstub/riscv-stub.c          |  17 ++--
 drivers/firmware/efi/vars.c                        |   5 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c             |  10 +-
 drivers/gpu/drm/i915/intel_pch.c                   |   2 +-
 drivers/gpu/drm/i915/intel_pch.h                   |   2 +-
 drivers/hid/hid-debug.c                            |   5 +-
 drivers/hid/hid-input.c                            |   3 +
 drivers/i2c/busses/Kconfig                         |   4 +-
 drivers/i2c/busses/i2c-bcm2835.c                   |  11 +++
 drivers/input/input.c                              |   6 ++
 drivers/input/keyboard/Kconfig                     |   2 +-
 drivers/input/mouse/elan_i2c_core.c                |  64 +++++-------
 drivers/iommu/amd/amd_iommu.h                      |   1 +
 drivers/iommu/amd/amd_iommu_types.h                |   1 +
 drivers/iommu/amd/init.c                           |  10 ++
 drivers/iommu/amd/iommu.c                          |  10 +-
 drivers/net/arcnet/com20020-pci.c                  |   3 +
 drivers/net/can/usb/gs_usb.c                       |  10 +-
 drivers/net/ethernet/chelsio/cxgb3/t3_hw.c         |   2 +
 drivers/net/ethernet/ibm/ibmvnic.c                 |  21 +++-
 drivers/net/ethernet/intel/e1000e/ich8lan.c        |   4 +-
 drivers/net/ethernet/intel/iavf/iavf.h             |  10 ++
 drivers/net/ethernet/intel/iavf/iavf_main.c        |  44 +++++----
 drivers/net/ethernet/intel/iavf/iavf_virtchnl.c    |   2 +-
 drivers/net/ethernet/intel/ice/ice_main.c          |   2 +
 drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c   |  58 +++++++++--
 drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h   |   5 +
 drivers/net/ethernet/intel/igc/igc_phy.c           |   4 -
 drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c       |   6 +-
 drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c    |   6 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |   6 +-
 drivers/net/usb/cdc_mbim.c                         |   5 +
 drivers/net/wireless/mac80211_hwsim.c              |  13 +++
 drivers/net/xen-netfront.c                         |  39 +++++---
 drivers/ntb/hw/intel/ntb_hw_gen4.c                 |  17 +++-
 drivers/ntb/hw/intel/ntb_hw_gen4.h                 |  16 +++
 drivers/pinctrl/sunxi/pinctrl-sunxi.c              |   9 ++
 drivers/regulator/core.c                           |  13 +--
 drivers/soc/fsl/guts.c                             |  14 ++-
 drivers/soc/fsl/qe/qe_io.c                         |   2 +
 drivers/thermal/thermal_netlink.c                  |   5 +-
 drivers/tty/serial/stm32-usart.c                   |  12 +++
 drivers/usb/gadget/legacy/inode.c                  |  10 +-
 fs/btrfs/qgroup.c                                  |   9 +-
 fs/btrfs/tree-log.c                                |  61 +++++++++---
 fs/cifs/cifsfs.c                                   |   1 +
 fs/exfat/file.c                                    |  18 ++--
 fs/exfat/inode.c                                   |  13 ++-
 fs/exfat/namei.c                                   |   6 +-
 fs/exfat/super.c                                   |  10 +-
 include/linux/topology.h                           |   1 +
 include/net/netfilter/nf_queue.h                   |   2 +-
 include/net/xfrm.h                                 |   1 -
 include/uapi/linux/input-event-codes.h             |   4 +-
 include/uapi/linux/xfrm.h                          |   6 ++
 kernel/rcu/tree_plugin.h                           |   7 +-
 kernel/sched/topology.c                            |  99 +++++++++----------
 kernel/trace/trace.c                               |   4 +-
 kernel/trace/trace_events_filter.c                 | 107 +++++++++++++++++++--
 kernel/trace/trace_events_hist.c                   |   6 +-
 kernel/trace/trace_kprobe.c                        |   2 +-
 mm/memfd.c                                         |  40 +++++---
 mm/util.c                                          |   4 +-
 net/batman-adv/hard-interface.c                    |  29 ++++--
 net/core/skbuff.c                                  |   2 +-
 net/core/skmsg.c                                   |   2 +-
 net/dcb/dcbnl.c                                    |  44 +++++++++
 net/ipv4/esp4.c                                    |   2 +-
 net/ipv6/addrconf.c                                |   8 +-
 net/ipv6/esp6.c                                    |   2 +-
 net/ipv6/ip6_output.c                              |  11 ++-
 net/mac80211/ieee80211_i.h                         |   2 +-
 net/mac80211/mlme.c                                |  16 ++-
 net/mac80211/rx.c                                  |   4 +-
 net/netfilter/core.c                               |   5 +-
 net/netfilter/nf_queue.c                           |  36 ++++++-
 net/netfilter/nfnetlink_queue.c                    |  12 ++-
 net/smc/af_smc.c                                   |  10 +-
 net/smc/smc_core.c                                 |   5 +-
 net/tipc/crypto.c                                  |   2 +-
 net/wireless/nl80211.c                             |  12 +++
 net/xfrm/xfrm_device.c                             |   6 +-
 net/xfrm/xfrm_interface.c                          |   2 +-
 net/xfrm/xfrm_state.c                              |  14 +--
 sound/soc/codecs/cs4265.c                          |   3 +-
 sound/soc/codecs/rt5668.c                          |  12 ++-
 sound/soc/codecs/rt5682.c                          |  12 ++-
 sound/soc/soc-ops.c                                |   4 +-
 sound/x86/intel_hdmi_audio.c                       |   2 +-
 .../selftests/drivers/net/mlxsw/tc_police_scale.sh |   3 +-
 tools/testing/selftests/seccomp/Makefile           |   2 +-
 110 files changed, 947 insertions(+), 419 deletions(-)


