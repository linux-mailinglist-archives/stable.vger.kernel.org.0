Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 279154CF6F3
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 10:43:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232153AbiCGJnk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 04:43:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240469AbiCGJlE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 04:41:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9B9E6392;
        Mon,  7 Mar 2022 01:37:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7DC6161224;
        Mon,  7 Mar 2022 09:37:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2C42C340F6;
        Mon,  7 Mar 2022 09:37:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646645823;
        bh=hSbctW6m/fdUFj7mzsLUQdpRoF3/lLS+LPkU2/9m9MQ=;
        h=From:To:Cc:Subject:Date:From;
        b=pfp22FlCuisCJrPhUs2Tiy0SjzktWFptVjkzq5l+XFMlUlYA6RBTiOB/gKrV3jol4
         Lr+WcNic7BH3BzILeiaBij1ZbLOZ8SYRRBQhDuXVqXFq+VhMAJbjlV53OaThWfdftP
         N0Y+3zNqBzGbrfjfXHiK9w65c+RWT9LuwYFms3tU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Subject: [PATCH 5.15 000/262] 5.15.27-rc1 review
Date:   Mon,  7 Mar 2022 10:15:44 +0100
Message-Id: <20220307091702.378509770@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.27-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.15.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.15.27-rc1
X-KernelTest-Deadline: 2022-03-09T09:17+00:00
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

This is the start of the stable review cycle for the 5.15.27 release.
There are 262 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 09 Mar 2022 09:16:25 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.27-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.15.27-rc1

Like Xu <likexu@tencent.com>
    KVM: x86/mmu: Passing up the error state of mmu_alloc_shadow_roots()

Yun Zhou <yun.zhou@windriver.com>
    proc: fix documentation and description of pagemap

Jiri Bohac <jbohac@suse.cz>
    Revert "xfrm: xfrm_state_mtu should return at least 1280 for ipv6"

Josef Bacik <josef@toxicpanda.com>
    btrfs: do not start relocation until in progress drops are done

Filipe Manana <fdmanana@suse.com>
    btrfs: add missing run of delayed items after unlink during log replay

Sidong Yang <realwakka@gmail.com>
    btrfs: qgroup: fix deadlock between rescan worker and remove qgroup

Josef Bacik <josef@toxicpanda.com>
    btrfs: do not WARN_ON() if we have PageError set

Omar Sandoval <osandov@fb.com>
    btrfs: fix relocation crash due to premature return from btrfs_commit_transaction()

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

Lukas Bulwahn <lukas.bulwahn@gmail.com>
    MAINTAINERS: adjust file entry for of_net.c after movement

Dan Carpenter <dan.carpenter@oracle.com>
    iavf: missing unlocks in iavf_watchdog_task()

Stefan Assmann <sassmann@kpanic.de>
    iavf: do not override the adapter state in the watchdog task (again)

Ong Boon Leong <boon.leong.ong@intel.com>
    net: stmmac: perserve TX and RX coalesce value during XDP setup

Amit Cohen <amcohen@nvidia.com>
    selftests: mlxsw: resource_scale: Fix return value

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dcb: disable softirqs in dcbnl_flush_dev()

Qiang Yu <qiang.yu@amd.com>
    drm/amdgpu: fix suspend/resume hang regression

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    nl80211: Handle nla_memdup failures in handle_nan_filter

Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
    MIPS: ralink: mt7621: use bitwise NOT instead of logical

Sasha Neftin <sasha.neftin@intel.com>
    e1000e: Fix possible HW unit hang after an s0ix exit

Douglas Anderson <dianders@chromium.org>
    drm/bridge: ti-sn65dsi86: Properly undo autosuspend

Vinay Belgaumkar <vinay.belgaumkar@intel.com>
    drm/i915/guc/slpc: Correct the param count for unset param

Slawomir Laba <slawomirx.laba@intel.com>
    iavf: Fix __IAVF_RESETTING state usage

Slawomir Laba <slawomirx.laba@intel.com>
    iavf: Fix race in init state

Slawomir Laba <slawomirx.laba@intel.com>
    iavf: Fix locking for VIRTCHNL_OP_GET_OFFLOAD_VLAN_V2_CAPS

Slawomir Laba <slawomirx.laba@intel.com>
    iavf: Fix init state closure on remove

Slawomir Laba <slawomirx.laba@intel.com>
    iavf: Add waiting so the port is initialized in remove

Przemyslaw Patynowski <przemyslawx.patynowski@intel.com>
    iavf: Fix kernel BUG in free_msi_irqs

Karen Sornek <karen.sornek@intel.com>
    iavf: Add helper function to go from pci_dev to adapter

Slawomir Laba <slawomirx.laba@intel.com>
    iavf: Rework mutexes for better synchronisation

Jedrzej Jagielski <jedrzej.jagielski@intel.com>
    iavf: Add trace while removing device

Mateusz Palczewski <mateusz.palczewski@intel.com>
    iavf: Combine init and watchdog state machines

Mateusz Palczewski <mateusz.palczewski@intel.com>
    iavf: Add __IAVF_INIT_FAILED state

Mateusz Palczewski <mateusz.palczewski@intel.com>
    iavf: Refactor iavf state machine tracking

Casper Andersson <casper.casan@gmail.com>
    net: sparx5: Fix add vlan when invalid operation

Jia-Ju Bai <baijiaju1990@gmail.com>
    net: chelsio: cxgb3: check the return value of pci_find_capability()

Sukadev Bhattiprolu <sukadev@linux.ibm.com>
    ibmvnic: complete init_done on transport events

Sukadev Bhattiprolu <sukadev@linux.ibm.com>
    ibmvnic: define flush_reset_queue helper

Sukadev Bhattiprolu <sukadev@linux.ibm.com>
    ibmvnic: initialize rc before completing wait

Vincent Whitchurch <vincent.whitchurch@axis.com>
    net: stmmac: only enable DMA interrupts when ready

Ong Boon Leong <boon.leong.ong@intel.com>
    net: stmmac: enhance XDP ZC driver level switching performance

Vincent Mailhol <mailhol.vincent@wanadoo.fr>
    can: etas_es58x: change opened_channel_cnt's type from atomic_t to u8

Thierry Reding <treding@nvidia.com>
    ARM: tegra: Move panels to AUX bus

Eric Dumazet <edumazet@google.com>
    netfilter: nf_tables: prefer kfree_rcu(ptr, rcu) variant

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

Chuanhong Guo <gch981213@gmail.com>
    MIPS: ralink: mt7621: do memory detection on KSEG1

Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
    iommu/amd: Fix I/O page table memory leak

Matthew Wilcox (Oracle) <willy@infradead.org>
    iommu/amd: Use put_pages_list

Robin Murphy <robin.murphy@arm.com>
    iommu/amd: Simplify pagetable freeing

Robin Murphy <robin.murphy@arm.com>
    arm64: dts: juno: Remove GICv2m dma-range

Peter Zijlstra <peterz@infradead.org>
    sched: Fix yet more sched_fork() races

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

Mat Martineau <mathew.j.martineau@linux.intel.com>
    mptcp: Correctly set DATA_FIN timeout when number of retransmits is large

Randy Dunlap <rdunlap@infradead.org>
    ARM: 9182/1: mmu: fix returns from early_param() and __setup() functions

Randy Dunlap <rdunlap@infradead.org>
    mips: setup: fix setnocoherentio() boolean setting

Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
    ARM: Fix kgdb breakpoint for Thumb2

Corinna Vinschen <vinschen@redhat.com>
    igc: igc_read_phy_reg_gpy: drop premature return

Brian Norris <briannorris@chromium.org>
    arm64: dts: rockchip: Switch RK3399-Gru DP to SPDIF output

Miaoqian Lin <linmq006@gmail.com>
    iommu/tegra-smmu: Fix missing put_device() call in tegra_smmu_find

Vincent Mailhol <mailhol.vincent@wanadoo.fr>
    can: gs_usb: change active_channels's type from atomic_t to u8

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    auxdisplay: lcd2s: Use proper API to free the instance of charlcd object

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    auxdisplay: lcd2s: Fix memory leak in ->remove()

Fabio Estevam <festevam@denx.de>
    ASoC: cs4265: Fix the duplicated control name

Alyssa Ross <hi@alyssa.is>
    firmware: arm_scmi: Remove space in MODULE_ALIAS name

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    auxdisplay: lcd2s: Fix lcd2s_redefine_char() feature

Jann Horn <jannh@google.com>
    efivars: Respect "block" flag in efivar_entry_set_safe()

Slawomir Laba <slawomirx.laba@intel.com>
    iavf: Fix deadlock in iavf_reset_task

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

Filipe Manana <fdmanana@suse.com>
    btrfs: fix ENOSPC failure when attempting direct IO write into NOCOW range

D. Wythe <alibuda@linux.alibaba.com>
    net/smc: fix unexpected SMC_CLC_DECL_ERR_REGRMB error cause by server

D. Wythe <alibuda@linux.alibaba.com>
    net/smc: fix unexpected SMC_CLC_DECL_ERR_REGRMB error generated by client

D. Wythe <alibuda@linux.alibaba.com>
    net/smc: fix connection leak

Alex Elder <elder@linaro.org>
    net: ipa: add an interconnect dependency

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

Yu Kuai <yukuai3@huawei.com>
    blktrace: fix use after free for struct blk_trace

Deren Wu <deren.wu@mediatek.com>
    mac80211: fix EAPoL rekey fail in 802.3 rx path

Nicolas Cavallari <nicolas.cavallari@green-communications.fr>
    thermal: core: Fix TZ_GET_TRIP NULL pointer dereference

Marek Marczykowski-Górecki <marmarek@invisiblethingslab.com>
    xen/netfront: destroy queues before real_num_tx_queues is zeroed

Leo (Hanghong) Ma <hanghong.ma@amd.com>
    drm/amd/display: Reduce dmesg error to a debug print

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/i915: s/JSP2/ICP2/ PCH

Lennert Buytenhek <buytenh@wantstofly.org>
    iommu/amd: Recover from event log overflow

Adrian Huang <ahuang12@lenovo.com>
    iommu/vt-d: Fix double list_add when enabling VMD in scalable mode

Marek Vasut <marex@denx.de>
    ASoC: ops: Shift tested values in snd_soc_put_volsw() by +min

Randy Dunlap <rdunlap@infradead.org>
    iwlwifi: mvm: check debugfs_dir ptr before use

Alexandre Ghiti <alexandre.ghiti@canonical.com>
    riscv: Fix config KASAN && DEBUG_VIRTUAL

Alexandre Ghiti <alexandre.ghiti@canonical.com>
    riscv: Fix config KASAN && SPARSEMEM && !SPARSE_VMEMMAP

Sunil V L <sunilvl@ventanamicro.com>
    riscv/efi_stub: Fix get_boot_hartid_from_fdt() return value

Eric W. Biederman <ebiederm@xmission.com>
    ucounts: Fix systemd LimitNPROC with private users regression

Zhen Ni <nizhen@uniontech.com>
    ALSA: intel_hdmi: Fix reference to PCM buffer address

Arnd Bergmann <arnd@arndb.de>
    net: of: fix stub of_net helpers for CONFIG_NET=n

Pali Rohár <pali@kernel.org>
    PCI: mvebu: Fix device enumeration regression

Michel Dänzer <mdaenzer@redhat.com>
    drm/amd/display: For vblank_disable_immediate, check PSR is really used

Michael Chan <michael.chan@broadcom.com>
    bnxt_en: Fix occasional ethtool -t loopback test failures

Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
    drm/amd/display: Fix stream->link_enc unassigned during stream removal

Steve French <stfrench@microsoft.com>
    cifs: fix confusing unneeded warning message on smb2.1 and earlier

Shyam Prasad N <sprasad@microsoft.com>
    cifs: protect session channel fields with chan_lock

AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
    drm/mediatek: mtk_dsi: Avoid EPROBE_DEFER loop with external bridge

Enric Balletbo i Serra <enric.balletbo@collabora.com>
    drm/mediatek: mtk_dsi: Reset the dsi0 hardware

Cai Huoqing <cai.huoqing@linux.dev>
    net: ethernet: litex: Add the dependency on HAS_IOMEM

Jakub Kicinski <kuba@kernel.org>
    of: net: move of_net under net/

Sukadev Bhattiprolu <sukadev@linux.ibm.com>
    ibmvnic: don't release napi in __ibmvnic_open()

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dsa: seville: register the mdiobus under devres

Colin Foster <colin.foster@in-advantage.com>
    net: dsa: ocelot: seville: utilize of_mdiobus_register

Tao Liu <xliutaox@google.com>
    gve: Recording rx queue before sending to napi

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/i915: Disable DRRS on IVB/HSW port != A

José Roberto de Souza <jose.souza@intel.com>
    drm/i915/display: Move DRRS code its own file

Jani Nikula <jani.nikula@intel.com>
    drm/i915/display: split out dpt out of intel_display.c

Palmer Dabbelt <palmer@rivosinc.com>
    riscv/mm: Add XIP_FIXUP for phys_ram_base

Alexander Stein <alexander.stein@ew.tq-group.com>
    drm: mxsfb: Fix NULL pointer dereference

Guido Günther <agx@sigxcpu.org>
    drm: mxsfb: Set fallback bus format when the bridge doesn't provide one

Agustin Gutierrez <agustin.gutierrez@amd.com>
    drm/amd/display: Update watermark values for DCN301

He Fengqing <hefengqing@huawei.com>
    bpf: Fix possible race in inc_misses_counter

Eric Dumazet <edumazet@google.com>
    bpf: Use u64_stats_t in struct bpf_prog_stats

Raed Salem <raeds@nvidia.com>
    net/mlx5e: IPsec: Fix crypto offload for non TCP/UDP encapsulated traffic

Raed Salem <raeds@nvidia.com>
    net/mlx5e: IPsec: Refactor checksum code in tx data path

Kiran Kumar K <kirankumark@marvell.com>
    octeontx2-af: Add KPU changes to parse NGIO as separate layer

Kiran Kumar K <kirankumark@marvell.com>
    octeontx2-af: Adjust LA pointer for cpt parse header

Geetha sowjanya <gakula@marvell.com>
    octeontx2-af: cn10k: Use appropriate register for LMAC enable

Hariprasad Kelam <hkelam@marvell.com>
    octeontx2-af: cn10k: RPM hardware timestamp configuration

Harman Kalra <hkalra@marvell.com>
    octeontx2-af: Reset PTP config in FLR handler

Kiran Kumar K <kirankumark@marvell.com>
    octeontx2-af: Optimize KPU1 processing for variable-length headers

Moshe Tal <moshet@nvidia.com>
    ethtool: Fix link extended state for big endian

Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>
    drm/amd/display: Wrap dcn301_calculate_wm_and_dlg for FPU.

Qingqing Zhuo <Qingqing.Zhuo@amd.com>
    drm/amd/display: move FPU associated DCN301 code to DML folder

Qingqing Zhuo <qingqing.zhuo@amd.com>
    drm/amd/display: move FPU associated DSC code to DML folder

Nikola Cornij <nikola.cornij@amd.com>
    drm/amd/display: Use adjusted DCN301 watermarks

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu: filter out radeon secondary ids as well

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu: filter out radeon PCI device IDs

Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
    drm/amdgpu/display: Only set vblank_disable_immediate when PSR is not enabled

Sean Christopherson <seanjc@google.com>
    hugetlbfs: fix off-by-one error in hugetlb_vmdelete_list()

Waiman Long <longman@redhat.com>
    selftests/vm: make charge_reserved_hugetlb.sh work with existing cgroup setting

Andrey Konovalov <andreyknvl@gmail.com>
    kasan: fix quarantine conflicting with init_on_free

Kefeng Wang <wangkefeng.wang@huawei.com>
    mm: defer kmemleak object creation of module_alloc()

Xiaoke Wang <xkernel.wang@foxmail.com>
    tracing/probes: check the return value of kstrndup() for pbuf

Xiaoke Wang <xkernel.wang@foxmail.com>
    tracing/uprobes: Check the return value of kstrdup() for tu->filename

Weizhao Ouyang <o451686892@gmail.com>
    dma-buf: cma_heap: Fix mutex locking section

Tom Rix <trix@redhat.com>
    i3c: master: dw: check return of dw_i3c_master_get_free_pos()

Guchun Chen <guchun.chen@amd.com>
    drm/amdgpu: use spin_lock_irqsave to avoid deadlock by local interrupt

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    drm/amdkfd: Check for null pointer after calling kmemdup

Wesley Sheng <wesley.sheng@microchip.com>
    ntb_hw_switchtec: Fix bug with more than 32 partitions

Jeremy Pallotta <jmpallotta@gmail.com>
    ntb_hw_switchtec: Fix pff ioread to read into mmio_part_cfg_all

Liu Ying <victor.liu@nxp.com>
    drm/atomic: Check new_crtc_state->active to determine if CRTC needs disable in self refresh mode

Miaoqian Lin <linmq006@gmail.com>
    drm/sun4i: dw-hdmi: Fix missing put_device() call in sun8i_hdmi_phy_get

Chuck Lever <chuck.lever@oracle.com>
    SUNRPC: Fix sockaddr handling in svcsock_accept_class trace points

Chuck Lever <chuck.lever@oracle.com>
    SUNRPC: Fix sockaddr handling in the svc_xprt_create_error trace point

Matthew Auld <matthew.auld@intel.com>
    drm/i915: don't call free_mmap_offset when purging

Vitaly Kuznetsov <vkuznets@redhat.com>
    x86/hyperv: Properly deal with empty cpumasks in hyperv_flush_tlb_multi()

J. Bruce Fields <bfields@redhat.com>
    nfsd: fix crash on COPY_NOTIFY with special stateid

Chuck Lever <chuck.lever@oracle.com>
    Revert "nfsd: skip some unnecessary stats in the v4 case"

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Fix verifier returned in stable WRITEs

Pali Rohár <pali@kernel.org>
    PCI: mvebu: Fix support for DEVCAP2, DEVCTL2 and LNKCTL2 registers on emulated bridge

Pali Rohár <pali@kernel.org>
    PCI: mvebu: Fix support for PCI_EXP_RTSTA on emulated bridge

Pali Rohár <pali@kernel.org>
    PCI: mvebu: Fix support for PCI_EXP_DEVCTL on emulated bridge

Pali Rohár <pali@kernel.org>
    PCI: mvebu: Fix support for PCI_BRIDGE_CTL_BUS_RESET on emulated bridge

Pali Rohár <pali@kernel.org>
    PCI: mvebu: Setup PCIe controller to Root Complex mode

Pali Rohár <pali@kernel.org>
    PCI: mvebu: Fix configuring secondary bus of PCIe Root Port via emulated bridge

Pali Rohár <pali@kernel.org>
    PCI: mvebu: Fix support for bus mastering and PCI_COMMAND on emulated bridge

Pali Rohár <pali@kernel.org>
    PCI: mvebu: Do not modify PCI IO type bits in conf_write

Pali Rohár <pali@kernel.org>
    PCI: mvebu: Check for errors from pci_bridge_emul_init() call

Dario Binacchi <dariobin@libero.it>
    Input: ti_am335x_tsc - fix STEPCONFIG setup for Z2

Dario Binacchi <dariobin@libero.it>
    Input: ti_am335x_tsc - set ADCREFM for X configuration

Beau Belgrave <beaub@linux.microsoft.com>
    tracing: Do not let synth_events block other dyn_event systems during create

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    i3c/master/mipi-i3c-hci: Fix a potentially infinite loop in 'hci_dat_v1_get_index()'

Jamie Iles <quic_jiles@quicinc.com>
    i3c: fix incorrect address slot lookup on 64-bit

Hou Wenlong <houwenlong93@linux.alibaba.com>
    KVM: x86: Exit to userspace if emulation prepared a completion callback

Sean Christopherson <seanjc@google.com>
    KVM: x86: Handle 32-bit wrap of EIP for EMULTYPE_SKIP with flat code seg

Lai Jiangshan <laijs@linux.alibaba.com>
    KVM: X86: Ensure that dirty PDPTRs are loaded

Sean Christopherson <seanjc@google.com>
    KVM: VMX: Read Posted Interrupt "control" exactly once per loop iteration

Sean Christopherson <seanjc@google.com>
    KVM: s390: Ensure kvm_arch_no_poll() is read once when blocking vCPU

Paolo Bonzini <pbonzini@redhat.com>
    KVM: VMX: Don't unblock vCPU w/ Posted IRQ if IRQs are disabled in guest

Pali Rohár <pali@kernel.org>
    PCI: aardvark: Fix checking for MEM resource type

Tim Harvey <tharvey@gateworks.com>
    PCI: dwc: Do not remap invalid res

Marek Vasut <marek.vasut+renesas@gmail.com>
    PCI: rcar: Check if device is runtime suspended instead of __clk_is_enabled()

Jianjun Wang <jianjun.wang@mediatek.com>
    PCI: mediatek-gen3: Disable DVFSRC voltage request

Eric W. Biederman <ebiederm@xmission.com>
    signal: In get_signal test for signal_group_exit every time through the loop

Huang Pei <huangpei@loongson.cn>
    MIPS: fix local_{add,sub}_return on MIPS64

Hou Tao <houtao1@huawei.com>
    bpf, arm64: Use emit_addr_mov_i64() for BPF_PSEUDO_FUNC

Tudor Ambarus <tudor.ambarus@microchip.com>
    mtd: spi-nor: Fix mtd size for s3an flashes

Andrii Nakryiko <andrii@kernel.org>
    tools/resolve_btf_ids: Close ELF file on error

Hao Xu <haoxu@linux.alibaba.com>
    io_uring: fix no lock protection for ctx->cq_extra

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Fix zero-length NFSv3 WRITEs

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Have legacy NFSD WRITE decoders use xdr_stream_subsegment()

Eric Dumazet <edumazet@google.com>
    ipv6: fix skb drops in igmp6_event_query() and igmp6_event_report()

Steven Rostedt <rostedt@goodmis.org>
    tracing: Add ustring operation to filtering string pointers

Qiang Yu <qiang.yu@amd.com>
    drm/amdgpu: check vm ready by amdgpu_vm->evicting flag

Sergey Shtylyov <s.shtylyov@omp.ru>
    ata: pata_hpt37x: fix PCI clock detection

Tadeusz Struk <tadeusz.struk@linaro.org>
    sched/fair: Fix fault in reweight_entity

Xin Yin <yinxin.x@bytedance.com>
    ext4: fast commit may miss file actions

Xin Yin <yinxin.x@bytedance.com>
    ext4: fast commit may not fallback for ineligible commit

Harshad Shirwadkar <harshadshirwadkar@gmail.com>
    ext4: simplify updating of fast commit stats

Harshad Shirwadkar <harshadshirwadkar@gmail.com>
    ext4: drop ineligible txn start stop APIs

Valentin Caron <valentin.caron@foss.st.com>
    serial: stm32: prevent TDR register overwrite when sending x_char

Masami Hiramatsu <mhiramat@kernel.org>
    arm64: Mark start_backtrace() notrace and NOKPROBE_SYMBOL

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

Haimin Zhang <tcs.kernel@gmail.com>
    block-map: add __GFP_ZERO flag for alloc_page in function bio_copy_kern

Daniele Palmas <dnlplm@gmail.com>
    net: usb: cdc_mbim: avoid altsetting toggling for Telit FN990

Wolfram Sang <wsa@kernel.org>
    i2c: qup: allow COMPILE_TEST

Wolfram Sang <wsa@kernel.org>
    i2c: imx: allow COMPILE_TEST

Wolfram Sang <wsa@kernel.org>
    i2c: cadence: allow COMPILE_TEST

Yongzhi Liu <lyz_cs@pku.edu.cn>
    dmaengine: shdma: Fix runtime PM imbalance on error

Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
    selftests/ftrace: Do not trace do_softirq because of PREEMPT_RT

Evan Quan <evan.quan@amd.com>
    drm/amd/pm: correct UMD pstate clocks for Dimgrey Cavefish and Beige Goby

Sherry Yang <sherry.yang@oracle.com>
    selftests/seccomp: Fix seccomp failure by adding missing headers

Ronnie Sahlberg <lsahlber@redhat.com>
    cifs: modefromsids must add an ACE for authenticated users

Basavaraj Natikar <Basavaraj.Natikar@amd.com>
    HID: amd_sfh: Add interrupt handler to process interrupts

Basavaraj Natikar <Basavaraj.Natikar@amd.com>
    HID: amd_sfh: Add functionality to clear interrupts

Basavaraj Natikar <Basavaraj.Natikar@amd.com>
    HID: amd_sfh: Handle amd_sfh work buffer in PM ops

Ronnie Sahlberg <lsahlber@redhat.com>
    cifs: fix double free race when mount fails in cifs_get_root()

Ronnie Sahlberg <lsahlber@redhat.com>
    cifs: do not use uninitialized data in the owner/group sid

Hangyu Hua <hbh25y@gmail.com>
    tipc: fix a bit overflow in tipc_crypto_key_rcv()

Ming Lei <ming.lei@redhat.com>
    block: loop:use kstatfs.f_bsize of backing file to set discard granularity

Marc Zyngier <maz@kernel.org>
    KVM: arm64: vgic: Read HW interrupt pending state from the HW

Filipe Manana <fdmanana@suse.com>
    btrfs: get rid of warning on transaction commit when using flushoncommit

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

 Documentation/admin-guide/mm/pagemap.rst           |   2 +-
 Documentation/gpu/i915.rst                         |  14 +-
 Documentation/trace/events.rst                     |  19 +
 MAINTAINERS                                        |   2 +-
 Makefile                                           |   4 +-
 arch/arm/boot/dts/omap3-devkit8000-common.dtsi     |  18 +
 arch/arm/boot/dts/omap3-devkit8000.dts             |  33 -
 arch/arm/boot/dts/tegra124-nyan-big.dts            |  15 +-
 arch/arm/boot/dts/tegra124-nyan-blaze.dts          |  15 +-
 arch/arm/boot/dts/tegra124-venice2.dts             |  14 +-
 arch/arm/kernel/kgdb.c                             |  36 +-
 arch/arm/mm/mmu.c                                  |   2 +
 arch/arm64/boot/dts/arm/juno-base.dtsi             |   3 +-
 arch/arm64/boot/dts/rockchip/rk3399-gru.dtsi       |  17 +-
 arch/arm64/kernel/module.c                         |   4 +-
 arch/arm64/kernel/stacktrace.c                     |   3 +-
 arch/arm64/kvm/vgic/vgic-mmio.c                    |   2 +
 arch/arm64/net/bpf_jit_comp.c                      |   5 +-
 arch/mips/include/asm/local.h                      |   9 +-
 arch/mips/kernel/setup.c                           |   2 +-
 arch/mips/ralink/mt7621.c                          |  36 +-
 arch/riscv/mm/Makefile                             |   3 +
 arch/riscv/mm/init.c                               |   1 +
 arch/riscv/mm/kasan_init.c                         |   3 +-
 arch/s390/include/asm/extable.h                    |   9 +-
 arch/s390/kernel/module.c                          |   5 +-
 arch/s390/kvm/kvm-s390.c                           |   2 +-
 arch/x86/hyperv/mmu.c                              |  19 +-
 arch/x86/kernel/module.c                           |   7 +-
 arch/x86/kvm/mmu/mmu.c                             |   2 +-
 arch/x86/kvm/vmx/posted_intr.c                     |   9 +-
 arch/x86/kvm/x86.c                                 |  11 +-
 block/blk-map.c                                    |   2 +-
 drivers/ata/pata_hpt37x.c                          |   4 +-
 drivers/auxdisplay/lcd2s.c                         |  24 +-
 drivers/block/loop.c                               |   8 +-
 drivers/clocksource/timer-ti-dm-systimer.c         |   3 +-
 drivers/dma-buf/heaps/cma_heap.c                   |   6 +-
 drivers/dma/sh/shdma-base.c                        |   4 +-
 drivers/firmware/arm_scmi/driver.c                 |   2 +-
 drivers/firmware/efi/libstub/riscv-stub.c          |  17 +-
 drivers/firmware/efi/vars.c                        |   5 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c            | 719 ++++++++++++++++++++-
 drivers/gpu/drm/amd/amdgpu/amdgpu_vkms.c           |   5 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c             |  10 +-
 drivers/gpu/drm/amd/amdkfd/kfd_crat.c              |   3 +
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |  12 +-
 .../drm/amd/display/dc/clk_mgr/dcn301/vg_clk_mgr.c |  16 +-
 drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c   |   4 +-
 drivers/gpu/drm/amd/display/dc/core/dc_resource.c  |   3 -
 .../gpu/drm/amd/display/dc/dcn30/dcn30_resource.c  |   2 +
 drivers/gpu/drm/amd/display/dc/dcn301/Makefile     |  26 -
 .../drm/amd/display/dc/dcn301/dcn301_resource.c    | 262 +-------
 .../drm/amd/display/dc/dcn301/dcn301_resource.h    |   3 +
 drivers/gpu/drm/amd/display/dc/dml/Makefile        |   6 +
 .../gpu/drm/amd/display/dc/dml/dcn301/dcn301_fpu.c | 390 +++++++++++
 .../gpu/drm/amd/display/dc/dml/dcn301/dcn301_fpu.h |  42 ++
 .../drm/amd/display/dc/{ => dml}/dsc/qp_tables.h   |   0
 .../gpu/drm/amd/display/dc/dml/dsc/rc_calc_fpu.c   | 291 +++++++++
 .../gpu/drm/amd/display/dc/dml/dsc/rc_calc_fpu.h   |  94 +++
 drivers/gpu/drm/amd/display/dc/dsc/Makefile        |  29 -
 drivers/gpu/drm/amd/display/dc/dsc/rc_calc.c       | 259 --------
 drivers/gpu/drm/amd/display/dc/dsc/rc_calc.h       |  50 +-
 drivers/gpu/drm/amd/display/dc/dsc/rc_calc_dpi.c   |   1 -
 drivers/gpu/drm/amd/display/include/logger_types.h |   3 +
 .../drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c    |  26 +-
 .../drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.h    |   8 +
 drivers/gpu/drm/bridge/ti-sn65dsi86.c              |   5 +-
 drivers/gpu/drm/drm_atomic_helper.c                |   2 +-
 drivers/gpu/drm/i915/Makefile                      |   2 +
 drivers/gpu/drm/i915/display/intel_ddi.c           |   1 +
 drivers/gpu/drm/i915/display/intel_display.c       | 220 +------
 .../gpu/drm/i915/display/intel_display_debugfs.c   |   1 +
 drivers/gpu/drm/i915/display/intel_dp.c            | 467 +------------
 drivers/gpu/drm/i915/display/intel_dp.h            |  11 -
 drivers/gpu/drm/i915/display/intel_dpt.c           | 229 +++++++
 drivers/gpu/drm/i915/display/intel_dpt.h           |  19 +
 drivers/gpu/drm/i915/display/intel_drrs.c          | 485 ++++++++++++++
 drivers/gpu/drm/i915/display/intel_drrs.h          |  32 +
 drivers/gpu/drm/i915/display/intel_frontbuffer.c   |   1 +
 drivers/gpu/drm/i915/gem/i915_gem_pages.c          |   1 -
 drivers/gpu/drm/i915/gt/uc/intel_guc_slpc.c        |   2 +-
 drivers/gpu/drm/i915/intel_pch.c                   |   2 +-
 drivers/gpu/drm/i915/intel_pch.h                   |   2 +-
 drivers/gpu/drm/mediatek/mtk_dsi.c                 | 166 ++---
 drivers/gpu/drm/mxsfb/mxsfb_kms.c                  |  12 +-
 drivers/gpu/drm/sun4i/sun8i_hdmi_phy.c             |   4 +-
 drivers/hid/amd-sfh-hid/amd_sfh_pcie.c             |  69 +-
 drivers/hid/amd-sfh-hid/amd_sfh_pcie.h             |   2 +
 drivers/hid/hid-debug.c                            |   5 +-
 drivers/hid/hid-input.c                            |   3 +
 drivers/i2c/busses/Kconfig                         |   6 +-
 drivers/i2c/busses/i2c-bcm2835.c                   |  11 +
 drivers/i3c/master.c                               |   3 +-
 drivers/i3c/master/dw-i3c-master.c                 |   4 +
 drivers/i3c/master/mipi-i3c-hci/dat_v1.c           |   4 +-
 drivers/input/input.c                              |   6 +
 drivers/input/keyboard/Kconfig                     |   2 +-
 drivers/input/mouse/elan_i2c_core.c                |  64 +-
 drivers/input/touchscreen/ti_am335x_tsc.c          |   8 +-
 drivers/iommu/amd/amd_iommu.h                      |   1 +
 drivers/iommu/amd/amd_iommu_types.h                |   1 +
 drivers/iommu/amd/init.c                           |  10 +
 drivers/iommu/amd/io_pgtable.c                     | 120 ++--
 drivers/iommu/amd/iommu.c                          |  10 +-
 drivers/iommu/intel/iommu.c                        |   2 +-
 drivers/iommu/tegra-smmu.c                         |   4 +-
 drivers/mtd/spi-nor/xilinx.c                       |   3 +-
 drivers/net/arcnet/com20020-pci.c                  |   3 +
 drivers/net/can/usb/etas_es58x/es58x_core.c        |   9 +-
 drivers/net/can/usb/etas_es58x/es58x_core.h        |   8 +-
 drivers/net/can/usb/gs_usb.c                       |  10 +-
 drivers/net/dsa/ocelot/seville_vsc9953.c           |   6 +-
 drivers/net/ethernet/amd/Kconfig                   |   2 +-
 drivers/net/ethernet/arc/Kconfig                   |   4 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |   7 +
 drivers/net/ethernet/broadcom/bnxt/bnxt.h          |   1 +
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c  |   2 +-
 drivers/net/ethernet/chelsio/cxgb3/t3_hw.c         |   2 +
 drivers/net/ethernet/ezchip/Kconfig                |   2 +-
 drivers/net/ethernet/google/gve/gve_rx.c           |   1 +
 drivers/net/ethernet/ibm/ibmvnic.c                 |  54 +-
 drivers/net/ethernet/intel/e1000e/hw.h             |   1 +
 drivers/net/ethernet/intel/e1000e/ich8lan.c        |   8 +-
 drivers/net/ethernet/intel/e1000e/ich8lan.h        |   1 +
 drivers/net/ethernet/intel/e1000e/netdev.c         |  26 +
 drivers/net/ethernet/intel/iavf/iavf.h             |  54 +-
 drivers/net/ethernet/intel/iavf/iavf_main.c        | 357 +++++-----
 drivers/net/ethernet/intel/iavf/iavf_virtchnl.c    |  16 +-
 drivers/net/ethernet/intel/igc/igc_phy.c           |   4 -
 drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c       |   6 +-
 drivers/net/ethernet/litex/Kconfig                 |   2 +-
 drivers/net/ethernet/marvell/octeontx2/af/cgx.c    |  12 +-
 .../ethernet/marvell/octeontx2/af/lmac_common.h    |   8 +
 drivers/net/ethernet/marvell/octeontx2/af/mbox.h   |  61 +-
 drivers/net/ethernet/marvell/octeontx2/af/npc.h    |   9 +-
 .../ethernet/marvell/octeontx2/af/npc_profile.h    | 595 +++++------------
 drivers/net/ethernet/marvell/octeontx2/af/rpm.c    |  56 ++
 drivers/net/ethernet/marvell/octeontx2/af/rpm.h    |   7 +
 drivers/net/ethernet/marvell/octeontx2/af/rvu.h    |   7 +
 .../net/ethernet/marvell/octeontx2/af/rvu_cgx.c    |  23 +-
 .../net/ethernet/marvell/octeontx2/af/rvu_nix.c    |  30 +-
 .../net/ethernet/marvell/octeontx2/af/rvu_npc.c    |  96 +++
 .../mellanox/mlx5/core/en_accel/ipsec_rxtx.h       |  29 +
 drivers/net/ethernet/mellanox/mlx5/core/en_tx.c    |  20 +-
 .../net/ethernet/microchip/sparx5/sparx5_vlan.c    |  20 +-
 drivers/net/ethernet/mscc/Kconfig                  |   2 +-
 drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c    |   6 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac.h       |   4 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  | 170 ++++-
 drivers/net/ethernet/stmicro/stmmac/stmmac_xdp.c   |   4 +-
 drivers/net/ipa/Kconfig                            |   1 +
 drivers/net/usb/cdc_mbim.c                         |   5 +
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c   |  11 +-
 drivers/net/wireless/mac80211_hwsim.c              |  13 +
 drivers/net/xen-netfront.c                         |  39 +-
 drivers/ntb/hw/intel/ntb_hw_gen4.c                 |  17 +-
 drivers/ntb/hw/intel/ntb_hw_gen4.h                 |  16 +
 drivers/ntb/hw/mscc/ntb_hw_switchtec.c             |  16 +-
 drivers/of/Kconfig                                 |   4 -
 drivers/of/Makefile                                |   1 -
 drivers/pci/controller/dwc/pcie-designware.c       |   7 +-
 drivers/pci/controller/pci-aardvark.c              |   6 +-
 drivers/pci/controller/pci-mvebu.c                 | 251 +++++--
 drivers/pci/controller/pcie-mediatek-gen3.c        |   8 +
 drivers/pci/controller/pcie-rcar-host.c            |  10 +-
 drivers/pinctrl/sunxi/pinctrl-sunxi.c              |   9 +
 drivers/regulator/core.c                           |  13 +-
 drivers/soc/fsl/guts.c                             |  14 +-
 drivers/soc/fsl/qe/qe_io.c                         |   2 +
 drivers/thermal/thermal_netlink.c                  |   5 +-
 drivers/tty/serial/stm32-usart.c                   |  12 +
 drivers/usb/gadget/legacy/inode.c                  |  10 +-
 fs/btrfs/ctree.h                                   |  10 +
 fs/btrfs/disk-io.c                                 |  10 +
 fs/btrfs/extent-tree.c                             |  10 +
 fs/btrfs/extent_io.c                               |  16 +-
 fs/btrfs/inode.c                                   | 142 ++--
 fs/btrfs/qgroup.c                                  |   9 +-
 fs/btrfs/relocation.c                              |  13 +
 fs/btrfs/root-tree.c                               |  15 +
 fs/btrfs/transaction.c                             |  77 ++-
 fs/btrfs/transaction.h                             |   1 +
 fs/btrfs/tree-log.c                                |  61 +-
 fs/cifs/cifs_debug.c                               |   2 +
 fs/cifs/cifsacl.c                                  |   9 +-
 fs/cifs/cifsfs.c                                   |   1 +
 fs/cifs/cifsglob.h                                 |   5 +
 fs/cifs/connect.c                                  |  25 +-
 fs/cifs/misc.c                                     |   1 +
 fs/cifs/sess.c                                     |  41 +-
 fs/cifs/transport.c                                |   3 +
 fs/exfat/file.c                                    |  18 +-
 fs/exfat/inode.c                                   |  13 +-
 fs/exfat/namei.c                                   |   6 +-
 fs/exfat/super.c                                   |  10 +-
 fs/ext4/ext4.h                                     |  15 +-
 fs/ext4/extents.c                                  |   6 +-
 fs/ext4/fast_commit.c                              | 218 +++----
 fs/ext4/fast_commit.h                              |  27 +-
 fs/ext4/inode.c                                    |   4 +-
 fs/ext4/ioctl.c                                    |   5 +-
 fs/ext4/namei.c                                    |   4 +-
 fs/ext4/super.c                                    |   3 +-
 fs/ext4/xattr.c                                    |   6 +-
 fs/hugetlbfs/inode.c                               |   7 +-
 fs/io_uring.c                                      |   3 +
 fs/jbd2/commit.c                                   |   2 +-
 fs/jbd2/journal.c                                  |   2 +-
 fs/nfsd/nfs3proc.c                                 |   9 +-
 fs/nfsd/nfs3xdr.c                                  |  56 +-
 fs/nfsd/nfs4proc.c                                 |   3 +-
 fs/nfsd/nfs4state.c                                |   6 +-
 fs/nfsd/nfsproc.c                                  |   8 +-
 fs/nfsd/nfsxdr.c                                   |   9 +-
 fs/nfsd/vfs.c                                      |   4 +
 fs/nfsd/xdr.h                                      |   2 +-
 fs/nfsd/xdr3.h                                     |   2 +-
 fs/proc/task_mmu.c                                 |   3 +-
 include/linux/ethtool.h                            |   2 +-
 include/linux/filter.h                             |  10 +-
 include/linux/jbd2.h                               |   2 +-
 include/linux/kasan.h                              |   4 +-
 include/linux/of_net.h                             |   2 +-
 include/linux/sched/task.h                         |   4 +-
 include/linux/sunrpc/svc.h                         |   3 +-
 include/linux/vmalloc.h                            |   7 +
 include/net/ndisc.h                                |   4 +-
 include/net/netfilter/nf_queue.h                   |   2 +-
 include/net/xfrm.h                                 |   1 -
 include/trace/events/sunrpc.h                      |  13 +-
 include/uapi/linux/input-event-codes.h             |   4 +-
 include/uapi/linux/xfrm.h                          |   6 +
 kernel/bpf/syscall.c                               |  18 +-
 kernel/bpf/trampoline.c                            |  11 +-
 kernel/fork.c                                      |  13 +-
 kernel/sched/core.c                                |  23 +-
 kernel/signal.c                                    |  20 +-
 kernel/trace/blktrace.c                            |  26 +-
 kernel/trace/trace.c                               |   4 +-
 kernel/trace/trace_events_filter.c                 | 107 ++-
 kernel/trace/trace_events_hist.c                   |   6 +-
 kernel/trace/trace_events_synth.c                  |  13 +-
 kernel/trace/trace_kprobe.c                        |   2 +-
 kernel/trace/trace_probe.c                         |   2 +
 kernel/trace/trace_uprobe.c                        |   5 +
 kernel/user_namespace.c                            |  14 +-
 mm/kasan/quarantine.c                              |  11 +
 mm/kasan/shadow.c                                  |   9 +-
 mm/memfd.c                                         |  40 +-
 mm/util.c                                          |   4 +-
 mm/vmalloc.c                                       |   3 +-
 net/batman-adv/hard-interface.c                    |  29 +-
 net/core/Makefile                                  |   1 +
 net/core/net-sysfs.c                               |   2 +-
 {drivers/of => net/core}/of_net.c                  |   0
 net/core/skbuff.c                                  |   2 +-
 net/core/skmsg.c                                   |   2 +-
 net/dcb/dcbnl.c                                    |  44 ++
 net/ipv4/esp4.c                                    |   2 +-
 net/ipv6/addrconf.c                                |   8 +-
 net/ipv6/esp6.c                                    |   2 +-
 net/ipv6/ip6_output.c                              |  11 +-
 net/ipv6/mcast.c                                   |  32 +-
 net/mac80211/ieee80211_i.h                         |   2 +-
 net/mac80211/mlme.c                                |  16 +-
 net/mac80211/rx.c                                  |  14 +-
 net/mptcp/protocol.c                               |   7 +-
 net/netfilter/core.c                               |   5 +-
 net/netfilter/nf_queue.c                           |  36 +-
 net/netfilter/nf_tables_api.c                      |   4 +-
 net/netfilter/nfnetlink_queue.c                    |  12 +-
 net/smc/af_smc.c                                   |  10 +-
 net/smc/smc_core.c                                 |   5 +-
 net/sunrpc/svc.c                                   |  11 +-
 net/sunrpc/svc_xprt.c                              |   2 +-
 net/tipc/crypto.c                                  |   2 +-
 net/wireless/nl80211.c                             |  12 +
 net/xfrm/xfrm_device.c                             |   6 +-
 net/xfrm/xfrm_interface.c                          |   2 +-
 net/xfrm/xfrm_state.c                              |  14 +-
 sound/soc/codecs/cs4265.c                          |   3 +-
 sound/soc/codecs/rt5668.c                          |  12 +-
 sound/soc/codecs/rt5682.c                          |  12 +-
 sound/soc/soc-ops.c                                |   4 +-
 sound/x86/intel_hdmi_audio.c                       |   2 +-
 tools/bpf/resolve_btfids/main.c                    |   5 +-
 .../drivers/net/mlxsw/spectrum/resource_scale.sh   |   2 +-
 .../selftests/drivers/net/mlxsw/tc_police_scale.sh |   3 +-
 .../ftrace/test.d/ftrace/func_set_ftrace_file.tc   |   2 +-
 tools/testing/selftests/seccomp/Makefile           |   2 +-
 .../selftests/vm/charge_reserved_hugetlb.sh        |  34 +-
 .../selftests/vm/hugetlb_reparenting_test.sh       |  21 +-
 tools/testing/selftests/vm/write_hugetlb_memory.sh |   2 +-
 virt/kvm/kvm_main.c                                |   5 +-
 295 files changed, 5465 insertions(+), 3118 deletions(-)


