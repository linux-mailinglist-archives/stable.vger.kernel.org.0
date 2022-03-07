Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41EE14CF8C9
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 11:01:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238621AbiCGKCY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 05:02:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240511AbiCGKBE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 05:01:04 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BCDF2D1F5;
        Mon,  7 Mar 2022 01:49:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 649C9B810A8;
        Mon,  7 Mar 2022 09:49:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 520B6C340F3;
        Mon,  7 Mar 2022 09:49:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646646577;
        bh=f4V1+gZWxqK7df53+M/Do4gL4OvFQ/PSVVrGTHAoLc0=;
        h=From:To:Cc:Subject:Date:From;
        b=JPJYbsLIHPe4jDK452MnfJUo+MZkW+DPGbD7MjizJ4e50J8PSdQBCYfR1j6DFmLvd
         hqJrKkZX44W9GyUwDeti4OhRiBUgTqI7d02o7++wOOxipMnMv7g7/M8Rq33EQoWQgU
         T6R7EI8O9YuZebF9tC3IETag3Tb28O9BJ1fcOnfQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Subject: [PATCH 5.16 000/186] 5.16.13-rc1 review
Date:   Mon,  7 Mar 2022 10:17:18 +0100
Message-Id: <20220307091654.092878898@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.16.13-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.16.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.16.13-rc1
X-KernelTest-Deadline: 2022-03-09T09:16+00:00
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

This is the start of the stable review cycle for the 5.16.13 release.
There are 186 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 09 Mar 2022 09:16:25 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.16.13-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.16.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.16.13-rc1

Like Xu <likexu@tencent.com>
    KVM: x86/mmu: Passing up the error state of mmu_alloc_shadow_roots()

Heiko Carstens <hca@linux.ibm.com>
    s390/ftrace: fix ftrace_caller/ftrace_regs_caller generation

Heiko Carstens <hca@linux.ibm.com>
    s390/ftrace: fix arch_ftrace_get_regs implementation

Dexuan Cui <decui@microsoft.com>
    x86/kvmclock: Fix Hyper-V Isolated VM's boot issue when vCPUs > 64

Yun Zhou <yun.zhou@windriver.com>
    proc: fix documentation and description of pagemap

Jiri Bohac <jbohac@suse.cz>
    Revert "xfrm: xfrm_state_mtu should return at least 1280 for ipv6"

Josef Bacik <josef@toxicpanda.com>
    btrfs: do not start relocation until in progress drops are done

Filipe Manana <fdmanana@suse.com>
    btrfs: fallback to blocking mode when doing async dio over multiple extents

Filipe Manana <fdmanana@suse.com>
    btrfs: add missing run of delayed items after unlink during log replay

Sidong Yang <realwakka@gmail.com>
    btrfs: qgroup: fix deadlock between rescan worker and remove qgroup

Josef Bacik <josef@toxicpanda.com>
    btrfs: do not WARN_ON() if we have PageError set

Qu Wenruo <wqu@suse.com>
    btrfs: subpage: fix a wrong check on subpage->writers

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

Ong Boon Leong <boon.leong.ong@intel.com>
    net: stmmac: perserve TX and RX coalesce value during XDP setup

Amit Cohen <amcohen@nvidia.com>
    selftests: mlxsw: resource_scale: Fix return value

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dcb: disable softirqs in dcbnl_flush_dev()

Qiang Yu <qiang.yu@amd.com>
    drm/amdgpu: fix suspend/resume hang regression

Jonathan Lemon <jonathan.lemon@gmail.com>
    ptp: ocp: Add ptp_ocp_adjtime_coarse for large adjustments

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

Slawomir Laba <slawomirx.laba@intel.com>
    iavf: Rework mutexes for better synchronisation

Jedrzej Jagielski <jedrzej.jagielski@intel.com>
    iavf: Add trace while removing device

Casper Andersson <casper.casan@gmail.com>
    net: sparx5: Fix add vlan when invalid operation

Jia-Ju Bai <baijiaju1990@gmail.com>
    net: chelsio: cxgb3: check the return value of pci_find_capability()

Sukadev Bhattiprolu <sukadev@linux.ibm.com>
    ibmvnic: Allow queueing resets during probe

Sukadev Bhattiprolu <sukadev@linux.ibm.com>
    ibmvnic: clear fop when retrying probe

Sukadev Bhattiprolu <sukadev@linux.ibm.com>
    ibmvnic: init init_done_rc earlier

Dany Madden <drt@linux.ibm.com>
    ibmvnic: Update driver return codes

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

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: Fix bt_skb_sendmmsg not allocating partial chunks

Thierry Reding <treding@nvidia.com>
    ARM: tegra: Move panels to AUX bus

Eric Dumazet <edumazet@google.com>
    netfilter: nf_tables: prefer kfree_rcu(ptr, rcu) variant

Laurent Pinchart <laurent.pinchart@ideasonboard.com>
    soc: imx: gpcv2: Fix clock disabling imbalance in error path

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

Adam Ford <aford173@gmail.com>
    arm64: dts: imx8mm: Fix VPU Hanging

Peter Geis <pgwipeout@gmail.com>
    arm64: dts: rockchip: fix Quartz64-A ddr regulator voltage

Robin Murphy <robin.murphy@arm.com>
    arm64: dts: juno: Remove GICv2m dma-range

Frank Wunderlich <frank-w@public-files.de>
    arm64: dts: rockchip: drop pclk_xpcs from gmac0 on rk3568

Peter Zijlstra <peterz@infradead.org>
    sched: Fix yet more sched_fork() races

Heiko Carstens <hca@linux.ibm.com>
    s390/extable: fix exception table sorting

Alexander Egorenkov <egorenar@linux.ibm.com>
    s390/setup: preserve memory at OLDMEM_BASE and OLDMEM_SIZE

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

Svenning Sørensen <sss@secomea.com>
    net: dsa: microchip: fix bridging with more than two member ports

Mario Limonciello <mario.limonciello@amd.com>
    platform/x86: amd-pmc: Set QOS during suspend on CZN w/ timer wakeup

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

Alex Elder <elder@linaro.org>
    net: ipa: fix a build dependency

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

Kees Cook <keescook@chromium.org>
    binfmt_elf: Avoid total_mapping_size for ET_EXEC

Eric W. Biederman <ebiederm@xmission.com>
    ucounts: Fix systemd LimitNPROC with private users regression

Zhen Ni <nizhen@uniontech.com>
    ALSA: intel_hdmi: Fix reference to PCM buffer address

Qu Wenruo <wqu@suse.com>
    btrfs: defrag: don't use merged extent map for their generation check

Qu Wenruo <wqu@suse.com>
    btrfs: defrag: bring back the old file extent search behavior

Eric Dumazet <edumazet@google.com>
    ipv6: fix skb drops in igmp6_event_query() and igmp6_event_report()

Steven Rostedt <rostedt@goodmis.org>
    tracing: Add ustring operation to filtering string pointers

Qiang Yu <qiang.yu@amd.com>
    drm/amdgpu: check vm ready by amdgpu_vm->evicting flag

Sergey Shtylyov <s.shtylyov@omp.ru>
    ata: pata_hpt37x: fix PCI clock detection

Aaron Lewis <aaronlewis@google.com>
    KVM: x86: Add KVM_CAP_ENABLE_CAP to x86

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

James Morse <james.morse@arm.com>
    KVM: arm64: Workaround Cortex-A510's single-step and PAC trap errata

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

Kai Vehmanen <kai.vehmanen@linux.intel.com>
    ASoC: rt5682s: do not block workqueue if card is unbound

Eric Anholt <eric@anholt.net>
    i2c: bcm2835: Avoid clock stretching timeouts

JaeMan Park <jaeman@google.com>
    mac80211_hwsim: initialize ieee80211_tx_info at hw_scan_work

Benjamin Beichler <benjamin.beichler@uni-rostock.de>
    mac80211_hwsim: report NOACK frames in tx_status


-------------

Diffstat:

 Documentation/admin-guide/mm/pagemap.rst           |   2 +-
 Documentation/arm64/silicon-errata.rst             |   2 +
 Documentation/trace/events.rst                     |  19 ++
 Documentation/virt/kvm/api.rst                     |   2 +-
 Makefile                                           |   4 +-
 arch/arm/boot/dts/omap3-devkit8000-common.dtsi     |  18 ++
 arch/arm/boot/dts/omap3-devkit8000.dts             |  33 ---
 arch/arm/boot/dts/tegra124-nyan-big.dts            |  15 +-
 arch/arm/boot/dts/tegra124-nyan-blaze.dts          |  15 +-
 arch/arm/boot/dts/tegra124-venice2.dts             |  14 +-
 arch/arm/kernel/kgdb.c                             |  36 ++-
 arch/arm/mm/mmu.c                                  |   2 +
 arch/arm64/Kconfig                                 |  16 ++
 arch/arm64/boot/dts/arm/juno-base.dtsi             |   3 +-
 arch/arm64/boot/dts/freescale/imx8mm.dtsi          |   1 -
 arch/arm64/boot/dts/rockchip/rk3399-gru.dtsi       |  17 +-
 arch/arm64/boot/dts/rockchip/rk3566-quartz64-a.dts |   2 -
 arch/arm64/boot/dts/rockchip/rk3568.dtsi           |   6 +-
 arch/arm64/kernel/cpu_errata.c                     |   8 +
 arch/arm64/kernel/stacktrace.c                     |   3 +-
 arch/arm64/kvm/hyp/include/hyp/switch.h            |  20 +-
 arch/arm64/kvm/vgic/vgic-mmio.c                    |   2 +
 arch/arm64/tools/cpucaps                           |   5 +-
 arch/mips/kernel/setup.c                           |   2 +-
 arch/mips/ralink/mt7621.c                          |  36 +--
 arch/riscv/mm/Makefile                             |   3 +
 arch/riscv/mm/kasan_init.c                         |   3 +-
 arch/s390/include/asm/extable.h                    |   9 +-
 arch/s390/include/asm/ftrace.h                     |  10 +-
 arch/s390/include/asm/ptrace.h                     |   2 +
 arch/s390/kernel/ftrace.c                          |  37 ++-
 arch/s390/kernel/mcount.S                          |   9 +
 arch/s390/kernel/setup.c                           |   2 +
 arch/x86/kernel/kvmclock.c                         |   3 +
 arch/x86/kvm/mmu/mmu.c                             |   2 +-
 arch/x86/kvm/x86.c                                 |   1 +
 block/blk-map.c                                    |   2 +-
 drivers/ata/pata_hpt37x.c                          |   4 +-
 drivers/auxdisplay/lcd2s.c                         |  24 +-
 drivers/block/loop.c                               |   8 +-
 drivers/clocksource/timer-ti-dm-systimer.c         |   3 +-
 drivers/dma/sh/shdma-base.c                        |   4 +-
 drivers/firmware/arm_scmi/driver.c                 |   2 +-
 drivers/firmware/efi/libstub/riscv-stub.c          |  17 +-
 drivers/firmware/efi/vars.c                        |   5 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c             |  10 +-
 drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c   |   4 +-
 .../drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c    |  26 ++-
 .../drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.h    |   8 +
 drivers/gpu/drm/bridge/ti-sn65dsi86.c              |   5 +-
 drivers/gpu/drm/i915/gt/uc/intel_guc_slpc.c        |   2 +-
 drivers/gpu/drm/i915/intel_pch.c                   |   2 +-
 drivers/gpu/drm/i915/intel_pch.h                   |   2 +-
 drivers/hid/amd-sfh-hid/amd_sfh_pcie.c             |  69 +++++-
 drivers/hid/amd-sfh-hid/amd_sfh_pcie.h             |   2 +
 drivers/hid/hid-debug.c                            |   5 +-
 drivers/hid/hid-input.c                            |   3 +
 drivers/i2c/busses/Kconfig                         |   6 +-
 drivers/i2c/busses/i2c-bcm2835.c                   |  11 +
 drivers/input/input.c                              |   6 +
 drivers/input/keyboard/Kconfig                     |   2 +-
 drivers/input/mouse/elan_i2c_core.c                |  64 ++----
 drivers/iommu/amd/amd_iommu.h                      |   1 +
 drivers/iommu/amd/amd_iommu_types.h                |   1 +
 drivers/iommu/amd/init.c                           |  10 +
 drivers/iommu/amd/io_pgtable.c                     | 120 ++++------
 drivers/iommu/amd/iommu.c                          |  10 +-
 drivers/iommu/intel/iommu.c                        |   2 +-
 drivers/iommu/tegra-smmu.c                         |   4 +-
 drivers/net/arcnet/com20020-pci.c                  |   3 +
 drivers/net/can/usb/etas_es58x/es58x_core.c        |   9 +-
 drivers/net/can/usb/etas_es58x/es58x_core.h        |   8 +-
 drivers/net/can/usb/gs_usb.c                       |  10 +-
 drivers/net/dsa/microchip/ksz_common.c             |  26 ++-
 drivers/net/ethernet/chelsio/cxgb3/t3_hw.c         |   2 +
 drivers/net/ethernet/ibm/ibmvnic.c                 | 247 ++++++++++++++++-----
 drivers/net/ethernet/ibm/ibmvnic.h                 |   1 +
 drivers/net/ethernet/intel/e1000e/hw.h             |   1 +
 drivers/net/ethernet/intel/e1000e/ich8lan.c        |   8 +-
 drivers/net/ethernet/intel/e1000e/ich8lan.h        |   1 +
 drivers/net/ethernet/intel/e1000e/netdev.c         |  26 +++
 drivers/net/ethernet/intel/iavf/iavf.h             |   6 +-
 drivers/net/ethernet/intel/iavf/iavf_main.c        | 152 ++++++++-----
 drivers/net/ethernet/intel/iavf/iavf_virtchnl.c    |  14 +-
 drivers/net/ethernet/intel/igc/igc_phy.c           |   4 -
 drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c       |   6 +-
 .../net/ethernet/microchip/sparx5/sparx5_vlan.c    |  20 +-
 drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c    |   6 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac.h       |   4 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  | 170 +++++++++++++-
 drivers/net/ethernet/stmicro/stmmac/stmmac_xdp.c   |   4 +-
 drivers/net/ipa/Kconfig                            |   2 +
 drivers/net/usb/cdc_mbim.c                         |   5 +
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c   |  11 +-
 drivers/net/wireless/mac80211_hwsim.c              |  13 ++
 drivers/net/xen-netfront.c                         |  39 ++--
 drivers/ntb/hw/intel/ntb_hw_gen4.c                 |  17 +-
 drivers/ntb/hw/intel/ntb_hw_gen4.h                 |  16 ++
 drivers/pinctrl/sunxi/pinctrl-sunxi.c              |   9 +
 drivers/platform/x86/amd-pmc.c                     |  34 ++-
 drivers/ptp/ptp_ocp.c                              |  25 ++-
 drivers/regulator/core.c                           |  13 +-
 drivers/soc/fsl/guts.c                             |  14 +-
 drivers/soc/fsl/qe/qe_io.c                         |   2 +
 drivers/soc/imx/gpcv2.c                            |   3 +-
 drivers/thermal/thermal_netlink.c                  |   5 +-
 drivers/tty/serial/stm32-usart.c                   |  12 +
 drivers/usb/gadget/legacy/inode.c                  |  10 +-
 fs/binfmt_elf.c                                    |  25 ++-
 fs/btrfs/ctree.h                                   |  10 +
 fs/btrfs/disk-io.c                                 |  10 +
 fs/btrfs/extent-tree.c                             |  10 +
 fs/btrfs/extent_io.c                               |  16 +-
 fs/btrfs/extent_map.c                              |   2 +
 fs/btrfs/extent_map.h                              |   8 +
 fs/btrfs/inode.c                                   | 170 ++++++++------
 fs/btrfs/ioctl.c                                   | 175 ++++++++++++++-
 fs/btrfs/qgroup.c                                  |   9 +-
 fs/btrfs/relocation.c                              |  13 ++
 fs/btrfs/root-tree.c                               |  15 ++
 fs/btrfs/subpage.c                                 |   2 +-
 fs/btrfs/transaction.c                             |  77 ++++++-
 fs/btrfs/transaction.h                             |   1 +
 fs/btrfs/tree-log.c                                |  61 ++++-
 fs/cifs/cifsacl.c                                  |   9 +-
 fs/cifs/cifsfs.c                                   |   1 +
 fs/exfat/file.c                                    |  18 +-
 fs/exfat/inode.c                                   |  13 +-
 fs/exfat/namei.c                                   |   6 +-
 fs/exfat/super.c                                   |  10 +-
 fs/ext4/ext4.h                                     |  15 +-
 fs/ext4/extents.c                                  |   6 +-
 fs/ext4/fast_commit.c                              | 218 ++++++++----------
 fs/ext4/fast_commit.h                              |  27 +--
 fs/ext4/inode.c                                    |   4 +-
 fs/ext4/ioctl.c                                    |   5 +-
 fs/ext4/namei.c                                    |   4 +-
 fs/ext4/super.c                                    |   3 +-
 fs/ext4/xattr.c                                    |   6 +-
 fs/jbd2/commit.c                                   |   2 +-
 fs/jbd2/journal.c                                  |   2 +-
 fs/proc/task_mmu.c                                 |   3 +-
 include/linux/jbd2.h                               |   2 +-
 include/linux/sched/task.h                         |   4 +-
 include/net/bluetooth/bluetooth.h                  |   3 +-
 include/net/ndisc.h                                |   4 +-
 include/net/netfilter/nf_queue.h                   |   2 +-
 include/net/xfrm.h                                 |   1 -
 include/uapi/linux/input-event-codes.h             |   4 +-
 include/uapi/linux/xfrm.h                          |   6 +
 kernel/fork.c                                      |  13 +-
 kernel/sched/core.c                                |  23 +-
 kernel/trace/blktrace.c                            |  26 ++-
 kernel/trace/trace.c                               |   4 +-
 kernel/trace/trace_events_filter.c                 | 107 ++++++++-
 kernel/trace/trace_events_hist.c                   |   6 +-
 kernel/trace/trace_kprobe.c                        |   2 +-
 kernel/user_namespace.c                            |  14 +-
 mm/memfd.c                                         |  40 +++-
 mm/util.c                                          |   4 +-
 net/batman-adv/hard-interface.c                    |  29 ++-
 net/core/skbuff.c                                  |   2 +-
 net/core/skmsg.c                                   |   2 +-
 net/dcb/dcbnl.c                                    |  44 ++++
 net/ipv4/esp4.c                                    |   2 +-
 net/ipv6/addrconf.c                                |   8 +-
 net/ipv6/esp6.c                                    |   2 +-
 net/ipv6/ip6_output.c                              |  11 +-
 net/ipv6/mcast.c                                   |  32 +--
 net/mac80211/ieee80211_i.h                         |   2 +-
 net/mac80211/mlme.c                                |  16 +-
 net/mac80211/rx.c                                  |  14 +-
 net/mptcp/protocol.c                               |   7 +-
 net/netfilter/core.c                               |   5 +-
 net/netfilter/nf_queue.c                           |  36 ++-
 net/netfilter/nf_tables_api.c                      |   4 +-
 net/netfilter/nfnetlink_queue.c                    |  12 +-
 net/smc/af_smc.c                                   |  10 +-
 net/smc/smc_core.c                                 |   5 +-
 net/tipc/crypto.c                                  |   2 +-
 net/wireless/nl80211.c                             |  12 +
 net/xfrm/xfrm_device.c                             |   6 +-
 net/xfrm/xfrm_interface.c                          |   2 +-
 net/xfrm/xfrm_state.c                              |  14 +-
 sound/soc/codecs/cs4265.c                          |   3 +-
 sound/soc/codecs/rt5668.c                          |  12 +-
 sound/soc/codecs/rt5682.c                          |  12 +-
 sound/soc/codecs/rt5682s.c                         |  12 +-
 sound/soc/soc-ops.c                                |   4 +-
 sound/x86/intel_hdmi_audio.c                       |   2 +-
 .../drivers/net/mlxsw/spectrum/resource_scale.sh   |   2 +-
 .../selftests/drivers/net/mlxsw/tc_police_scale.sh |   3 +-
 .../ftrace/test.d/ftrace/func_set_ftrace_file.tc   |   2 +-
 tools/testing/selftests/seccomp/Makefile           |   2 +-
 194 files changed, 2383 insertions(+), 937 deletions(-)


