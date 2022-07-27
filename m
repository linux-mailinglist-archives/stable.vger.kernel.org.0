Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C72B583018
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 19:33:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242348AbiG0Rcz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 13:32:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242395AbiG0RcL (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 13:32:11 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68A054E63E;
        Wed, 27 Jul 2022 09:48:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id D3AC4CE2309;
        Wed, 27 Jul 2022 16:47:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86183C433C1;
        Wed, 27 Jul 2022 16:47:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658940477;
        bh=iQPl6Lm8ybCCVPLvEJm6OrVihH8xDY1aEt24GhIAi78=;
        h=From:To:Cc:Subject:Date:From;
        b=yfclsDHlZNdP3REzRVfLy/BcDpyeq7wTs2c37F/lpTULkpMLgaQd3rJHwnX4sOnHL
         xMvenLxND71URCyvNdTqnD2QvzZbgK53E3QMXBV4tzzOI0W9W6Nd1V4HOF6AMbFwNm
         AEpRuGs5yRgjeqzJZHL3emWzHHGdZkdbwAZFZgZg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Subject: [PATCH 5.18 000/158] 5.18.15-rc1 review
Date:   Wed, 27 Jul 2022 18:11:04 +0200
Message-Id: <20220727161021.428340041@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.18.15-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.18.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.18.15-rc1
X-KernelTest-Deadline: 2022-07-29T16:10+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.18.15 release.
There are 158 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 29 Jul 2022 16:09:50 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.18.15-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.18.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.18.15-rc1

Linus Torvalds <torvalds@linux-foundation.org>
    watch-queue: remove spurious double semicolon

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    ASoC: SOF: Intel: disable IMR boot when resuming from ACPI S4 and S5 states

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    ASoC: SOF: pm: add definitions for S4 and S5 states

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    ASoC: SOF: pm: add explicit behavior for ACPI S1 and S2

Linus Torvalds <torvalds@linux-foundation.org>
    watchqueue: make sure to serialize 'wqueue->defunct' properly

Kees Cook <keescook@chromium.org>
    x86/alternative: Report missing return thunk details

Peter Zijlstra <peterz@infradead.org>
    x86/amd: Use IBPB for firmware calls

Sungjong Seo <sj1557.seo@samsung.com>
    exfat: use updated exfat_chain directly during renaming

Yuezhang Mo <Yuezhang.Mo@sony.com>
    exfat: fix referencing wrong parent directory information after renaming

Giovanni Cabiddu <giovanni.cabiddu@intel.com>
    crypto: qat - re-enable registration of algorithms

Giovanni Cabiddu <giovanni.cabiddu@intel.com>
    crypto: qat - add param check for DH

Giovanni Cabiddu <giovanni.cabiddu@intel.com>
    crypto: qat - add param check for RSA

Giovanni Cabiddu <giovanni.cabiddu@intel.com>
    crypto: qat - remove dma_free_coherent() for DH

Giovanni Cabiddu <giovanni.cabiddu@intel.com>
    crypto: qat - remove dma_free_coherent() for RSA

Giovanni Cabiddu <giovanni.cabiddu@intel.com>
    crypto: qat - fix memory leak in RSA

Giovanni Cabiddu <giovanni.cabiddu@intel.com>
    crypto: qat - add backlog mechanism

Giovanni Cabiddu <giovanni.cabiddu@intel.com>
    crypto: qat - refactor submission logic

Giovanni Cabiddu <giovanni.cabiddu@intel.com>
    crypto: qat - use pre-allocated buffers in datapath

Giovanni Cabiddu <giovanni.cabiddu@intel.com>
    crypto: qat - set to zero DH parameters before free

Alexander Aring <aahringo@redhat.com>
    dlm: fix pending remove if msg allocation fails

Herve Codina <herve.codina@bootlin.com>
    clk: lan966x: Fix the lan966x clock gate register address

Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
    x86/bugs: Warn when "ibrs" mitigation is selected on Enhanced IBRS parts

Kan Liang <kan.liang@linux.intel.com>
    perf/x86/intel/lbr: Fix unchecked MSR access error on HSW

Juri Lelli <juri.lelli@redhat.com>
    sched/deadline: Fix BUG_ON condition for deboosted tasks

Eric Dumazet <edumazet@google.com>
    bpf: Make sure mac_header was set before using it

Wang Cheng <wanngchenng@gmail.com>
    mm/mempolicy: fix uninit-value in mpol_rebind_policy()

Alexey Kardashevskiy <aik@ozlabs.ru>
    KVM: Don't null dereference ops->destroy

Marc Kleine-Budde <mkl@pengutronix.de>
    spi: bcm2835: bcm2835_spi_handle_err(): fix NULL pointer deref for non DMA transfers

Gavin Shan <gshan@redhat.com>
    KVM: selftests: Fix target thread to be migrated in rseq_test

Srinivas Neeli <srinivas.neeli@xilinx.com>
    gpio: gpio-xilinx: Fix integer overflow

Kent Gibson <warthog618@gmail.com>
    selftests: gpio: fix include path to kernel headers for out of tree builds

Oz Shlomo <ozsh@nvidia.com>
    net/sched: cls_api: Fix flow action initialization

Kuniyuki Iwashima <kuniyu@amazon.com>
    tcp: Fix data-races around sysctl_tcp_max_reordering.

Kuniyuki Iwashima <kuniyu@amazon.com>
    tcp: Fix a data-race around sysctl_tcp_abort_on_overflow.

Kuniyuki Iwashima <kuniyu@amazon.com>
    tcp: Fix a data-race around sysctl_tcp_rfc1337.

Kuniyuki Iwashima <kuniyu@amazon.com>
    tcp: Fix a data-race around sysctl_tcp_stdurg.

Kuniyuki Iwashima <kuniyu@amazon.com>
    tcp: Fix a data-race around sysctl_tcp_retrans_collapse.

Kuniyuki Iwashima <kuniyu@amazon.com>
    tcp: Fix data-races around sysctl_tcp_slow_start_after_idle.

Kuniyuki Iwashima <kuniyu@amazon.com>
    tcp: Fix a data-race around sysctl_tcp_thin_linear_timeouts.

Kuniyuki Iwashima <kuniyu@amazon.com>
    tcp: Fix data-races around sysctl_tcp_recovery.

Kuniyuki Iwashima <kuniyu@amazon.com>
    tcp: Fix a data-race around sysctl_tcp_early_retrans.

Kuniyuki Iwashima <kuniyu@amazon.com>
    tcp: Fix data-races around sysctl knobs related to SYN option.

Kuniyuki Iwashima <kuniyu@amazon.com>
    udp: Fix a data-race around sysctl_udp_l3mdev_accept.

Kuniyuki Iwashima <kuniyu@amazon.com>
    ip: Fix data-races around sysctl_ip_prot_sock.

Kuniyuki Iwashima <kuniyu@amazon.com>
    ipv4: Fix data-races around sysctl_fib_multipath_hash_fields.

Kuniyuki Iwashima <kuniyu@amazon.com>
    ipv4: Fix data-races around sysctl_fib_multipath_hash_policy.

Kuniyuki Iwashima <kuniyu@amazon.com>
    ipv4: Fix a data-race around sysctl_fib_multipath_use_neigh.

Liang He <windhl@126.com>
    can: rcar_canfd: Add missing of_node_put() in rcar_canfd_probe()

Liang He <windhl@126.com>
    drm/imx/dcss: Add missing of_node_put() in fail path

Nícolas F. R. A. Prado <nfraprado@collabora.com>
    drm/panel-edp: Fix variable typo when saving hpd absent delay from DT

Taehee Yoo <ap420073@gmail.com>
    amt: do not use amt->nr_tunnels outside of lock

Taehee Yoo <ap420073@gmail.com>
    amt: drop unexpected multicast data

Taehee Yoo <ap420073@gmail.com>
    amt: drop unexpected query message

Taehee Yoo <ap420073@gmail.com>
    amt: drop unexpected advertisement message

Taehee Yoo <ap420073@gmail.com>
    amt: add missing regeneration nonce logic in request logic

Taehee Yoo <ap420073@gmail.com>
    amt: use READ_ONCE() in amt module

Taehee Yoo <ap420073@gmail.com>
    amt: remove unnecessary locks

Taehee Yoo <ap420073@gmail.com>
    amt: use workqueue for gateway side message handling

Oleksij Rempel <linux@rempel-privat.de>
    net: dsa: vitesse-vsc73xx: silent spi_device_id warnings

Oleksij Rempel <linux@rempel-privat.de>
    net: dsa: sja1105: silent spi_device_id warnings

Hristo Venev <hristo@venev.name>
    be2net: Fix buffer overflow in be_get_module_eeprom

Haibo Chen <haibo.chen@nxp.com>
    gpio: pca953x: use the correct register address when regcache sync during init

Haibo Chen <haibo.chen@nxp.com>
    gpio: pca953x: use the correct range when do regmap sync

Haibo Chen <haibo.chen@nxp.com>
    gpio: pca953x: only use single read/write for No AI mode

Wong Vee Khee <vee.khee.wong@linux.intel.com>
    net: stmmac: remove redunctant disable xPCS EEE call

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dsa: fix NULL pointer dereference in dsa_port_reset_vlan_filtering

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dsa: move reset of VLAN filtering to dsa_port_switchdev_unsync_attrs

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dsa: fix dsa_port_vlan_filtering when global

Piotr Skajewski <piotrx.skajewski@intel.com>
    ixgbe: Add locking to prevent panic when setting sriov_numvfs to zero

Dawid Lukwinski <dawid.lukwinski@intel.com>
    i40e: Fix erroneous adapter reinitialization during recovery process

Horatiu Vultur <horatiu.vultur@microchip.com>
    net: lan966x: Fix usage of lan966x->mac_lock when used by FDB

Horatiu Vultur <horatiu.vultur@microchip.com>
    net: lan966x: Fix usage of lan966x->mac_lock inside lan966x_mac_irq_handler

Horatiu Vultur <horatiu.vultur@microchip.com>
    net: lan966x: Fix usage of lan966x->mac_lock when entry is removed

Horatiu Vultur <horatiu.vultur@microchip.com>
    net: lan966x: Fix usage of lan966x->mac_lock when entry is added

Horatiu Vultur <horatiu.vultur@microchip.com>
    net: lan966x: Fix taking rtnl_lock while holding spin_lock

Vladimir Oltean <vladimir.oltean@nxp.com>
    pinctrl: armada-37xx: make irq_lock a raw spinlock to avoid invalid wait context

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    pinctrl: armada-37xx: Reuse GPIO fwnode in armada_37xx_irqchip_register()

Mario Limonciello <mario.limonciello@amd.com>
    ACPI: CPPC: Don't require flexible address space if X86_FEATURE_CPPC is supported

Przemyslaw Patynowski <przemyslawx.patynowski@intel.com>
    iavf: Fix missing state logs

Przemyslaw Patynowski <przemyslawx.patynowski@intel.com>
    iavf: Fix handling of dummy receive descriptors

Przemyslaw Patynowski <przemyslawx.patynowski@intel.com>
    iavf: Disallow changing rx/tx-frames and rx/tx-frames-irq

Przemyslaw Patynowski <przemyslawx.patynowski@intel.com>
    iavf: Fix VLAN_V2 addition/rejection

Kuniyuki Iwashima <kuniyu@amazon.com>
    tcp: Fix data-races around sysctl_tcp_fastopen_blackhole_timeout.

Kuniyuki Iwashima <kuniyu@amazon.com>
    tcp: Fix data-races around sysctl_tcp_fastopen.

Kuniyuki Iwashima <kuniyu@amazon.com>
    tcp: Fix data-races around sysctl_max_syn_backlog.

Kuniyuki Iwashima <kuniyu@amazon.com>
    tcp: Fix a data-race around sysctl_tcp_tw_reuse.

Kuniyuki Iwashima <kuniyu@amazon.com>
    tcp: Fix a data-race around sysctl_tcp_notsent_lowat.

Kuniyuki Iwashima <kuniyu@amazon.com>
    tcp: Fix data-races around some timeout sysctl knobs.

Kuniyuki Iwashima <kuniyu@amazon.com>
    tcp: Fix data-races around sysctl_tcp_reordering.

Kuniyuki Iwashima <kuniyu@amazon.com>
    tcp: Fix data-races around sysctl_tcp_migrate_req.

Kuniyuki Iwashima <kuniyu@amazon.com>
    tcp: Fix data-races around sysctl_tcp_syncookies.

Kuniyuki Iwashima <kuniyu@amazon.com>
    tcp: Fix data-races around sysctl_tcp_syn(ack)?_retries.

Kuniyuki Iwashima <kuniyu@amazon.com>
    tcp: Fix data-races around keepalive sysctl knobs.

Kuniyuki Iwashima <kuniyu@amazon.com>
    igmp: Fix data-races around sysctl_igmp_qrv.

Kuniyuki Iwashima <kuniyu@amazon.com>
    igmp: Fix data-races around sysctl_igmp_max_msf.

Kuniyuki Iwashima <kuniyu@amazon.com>
    igmp: Fix a data-race around sysctl_igmp_max_memberships.

Kuniyuki Iwashima <kuniyu@amazon.com>
    igmp: Fix data-races around sysctl_igmp_llm_reports.

Maksym Glubokiy <maksym.glubokiy@plvision.eu>
    net: prestera: acl: use proper mask for port selector

Tariq Toukan <tariqt@nvidia.com>
    net/tls: Fix race in TLS device down flow

Junxiao Chang <junxiao.chang@intel.com>
    net: stmmac: fix dma queue left shift overflow issue

Horatiu Vultur <horatiu.vultur@microchip.com>
    pinctrl: ocelot: Fix pincfg

Horatiu Vultur <horatiu.vultur@microchip.com>
    pinctrl: ocelot: Fix pincfg for lan966x

Adrian Hunter <adrian.hunter@intel.com>
    perf tests: Fix Convert perf time to TSC test for hybrid

Adrian Hunter <adrian.hunter@intel.com>
    perf tests: Stop Convert perf time to TSC test opening events twice

Robert Hancock <robert.hancock@calian.com>
    i2c: cadence: Change large transfer count reset logic to be unconditional

Vadim Pasternak <vadimp@nvidia.com>
    i2c: mlxcpld: Fix register setting for 400KHz frequency

Kuniyuki Iwashima <kuniyu@amazon.com>
    tcp/udp: Make early_demux back namespacified.

Liang He <windhl@126.com>
    net: dsa: microchip: ksz_common: Fix refcount leak bug

Biao Huang <biao.huang@mediatek.com>
    net: stmmac: fix unbalanced ptp clock issue in suspend/resume flow

Biao Huang <biao.huang@mediatek.com>
    net: stmmac: fix pm runtime issue in stmmac_dvr_remove()

Biao Huang <biao.huang@mediatek.com>
    stmmac: dwmac-mediatek: fix clock issue

Kuniyuki Iwashima <kuniyu@amazon.com>
    tcp: Fix a data-race around sysctl_tcp_probe_interval.

Kuniyuki Iwashima <kuniyu@amazon.com>
    tcp: Fix a data-race around sysctl_tcp_probe_threshold.

Kuniyuki Iwashima <kuniyu@amazon.com>
    tcp: Fix a data-race around sysctl_tcp_mtu_probe_floor.

Kuniyuki Iwashima <kuniyu@amazon.com>
    tcp: Fix data-races around sysctl_tcp_min_snd_mss.

Kuniyuki Iwashima <kuniyu@amazon.com>
    tcp: Fix data-races around sysctl_tcp_base_mss.

Kuniyuki Iwashima <kuniyu@amazon.com>
    tcp: Fix data-races around sysctl_tcp_mtu_probing.

Kuniyuki Iwashima <kuniyu@amazon.com>
    tcp: Fix data-races around sysctl_tcp_l3mdev_accept.

Eric Dumazet <edumazet@google.com>
    tcp: sk->sk_bound_dev_if once in inet_request_bound_dev_if()

Kuniyuki Iwashima <kuniyu@amazon.com>
    tcp/dccp: Fix a data-race around sysctl_tcp_fwmark_accept.

Kuniyuki Iwashima <kuniyu@amazon.com>
    ip: Fix a data-race around sysctl_fwmark_reflect.

Kuniyuki Iwashima <kuniyu@amazon.com>
    ip: Fix a data-race around sysctl_ip_autobind_reuse.

Kuniyuki Iwashima <kuniyu@amazon.com>
    ip: Fix data-races around sysctl_ip_nonlocal_bind.

Kuniyuki Iwashima <kuniyu@amazon.com>
    ip: Fix data-races around sysctl_ip_fwd_update_priority.

Kuniyuki Iwashima <kuniyu@amazon.com>
    ip: Fix data-races around sysctl_ip_fwd_use_pmtu.

Kuniyuki Iwashima <kuniyu@amazon.com>
    ip: Fix data-races around sysctl_ip_no_pmtu_disc.

Lennert Buytenhek <buytenh@wantstofly.org>
    igc: Reinstate IGC_REMOVED logic and implement it properly

Sasha Neftin <sasha.neftin@intel.com>
    Revert "e1000e: Fix possible HW unit hang after an s0ix exit"

Sasha Neftin <sasha.neftin@intel.com>
    e1000e: Enable GPT clock before sending message to CSME

Peter Zijlstra <peterz@infradead.org>
    perf/core: Fix data race between perf_event_set_output() and perf_mmap_close()

William Dean <williamsukatube@gmail.com>
    pinctrl: sunplus: Add check for kcalloc

William Dean <williamsukatube@gmail.com>
    pinctrl: ralink: Check for null return of devm_kcalloc

Arınç ÜNAL <arinc.unal@arinc9.com>
    pinctrl: ralink: rename pinctrl-rt2880 to pinctrl-ralink

Arınç ÜNAL <arinc.unal@arinc9.com>
    pinctrl: ralink: rename MT7628(an) functions to MT76X8

Mustafa Ismail <mustafa.ismail@intel.com>
    RDMA/irdma: Fix sleep from invalid context BUG

Mustafa Ismail <mustafa.ismail@intel.com>
    RDMA/irdma: Do not advertise 1GB page size for x722

Miaoqian Lin <linmq006@gmail.com>
    power/reset: arm-versatile: Fix refcount leak in versatile_reboot_probe

Gao Chao <gaochao49@huawei.com>
    power: supply: ab8500_fg: add missing destroy_workqueue in ab8500_fg_probe

Hangyu Hua <hbh25y@gmail.com>
    xfrm: xfrm_policy: fix a possible double xfrm_pols_put() in xfrm_bundle_lookup()

Kuniyuki Iwashima <kuniyu@amazon.com>
    ip: Fix data-races around sysctl_ip_default_ttl.

Hayes Wang <hayeswang@realtek.com>
    r8152: fix a WOL issue

Jeffrey Hugo <quic_jhugo@quicinc.com>
    PCI: hv: Fix interrupt mapping for multi-MSI

Jeffrey Hugo <quic_jhugo@quicinc.com>
    PCI: hv: Reuse existing IRTE allocation in compose_msi_msg()

Jeffrey Hugo <quic_jhugo@quicinc.com>
    PCI: hv: Fix hv_arch_irq_unmask() for multi-MSI

Jeffrey Hugo <quic_jhugo@quicinc.com>
    PCI: hv: Fix multi-MSI to allow more than one MSI vector

Daniele Palmas <dnlplm@gmail.com>
    bus: mhi: host: pci_generic: add Telit FN990

Daniele Palmas <dnlplm@gmail.com>
    bus: mhi: host: pci_generic: add Telit FN980 v1 hardware revision

Jose Alonso <joalonsof@gmail.com>
    net: usb: ax88179_178a needs FLAG_SEND_ZLP

Dmitry Osipenko <dmitry.osipenko@collabora.com>
    drm/scheduler: Don't kill jobs in interrupt context

Stylon Wang <stylon.wang@amd.com>
    drm/amd/display: Fix new dmub notification enabling in DM

Christian König <christian.koenig@amd.com>
    drm/ttm: fix locking in vmap/vunmap TTM GEM helpers

Sascha Hauer <s.hauer@pengutronix.de>
    mtd: rawnand: gpmi: Set WAIT_FOR_READY timeout based on program/erase times

Tony Lindgren <tony@atomide.com>
    mmc: sdhci-omap: Fix a lockdep warning for PM runtime init

Eric Snowberg <eric.snowberg@oracle.com>
    lockdown: Fix kexec lockdown bypass with ima policy

Ido Schimmel <idosch@nvidia.com>
    mlxsw: spectrum_router: Fix IPv4 nexthop gateway indication

Ben Dooks <ben.dooks@codethink.co.uk>
    riscv: add as-options for modules with assembly compontents

Fabien Dessenne <fabien.dessenne@foss.st.com>
    pinctrl: stm32: fix optional IRQ support to gpios

Vladimir Oltean <vladimir.oltean@nxp.com>
    pinctrl: armada-37xx: use raw spinlocks for regmap to avoid invalid wait context


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/riscv/Makefile                                |   1 +
 arch/x86/events/intel/lbr.c                        |  19 +-
 arch/x86/include/asm/cpufeatures.h                 |   1 +
 arch/x86/include/asm/nospec-branch.h               |   2 +
 arch/x86/kernel/alternative.c                      |   4 +-
 arch/x86/kernel/cpu/bugs.c                         |  14 +-
 drivers/acpi/cppc_acpi.c                           |   6 +-
 drivers/bus/mhi/host/pci_generic.c                 |  79 ++++++
 drivers/clk/clk-lan966x.c                          |   2 +-
 drivers/crypto/qat/qat_4xxx/adf_drv.c              |   7 -
 drivers/crypto/qat/qat_common/Makefile             |   1 +
 drivers/crypto/qat/qat_common/adf_transport.c      |  11 +
 drivers/crypto/qat/qat_common/adf_transport.h      |   1 +
 .../crypto/qat/qat_common/adf_transport_internal.h |   1 +
 drivers/crypto/qat/qat_common/qat_algs.c           | 138 +++++-----
 drivers/crypto/qat/qat_common/qat_algs_send.c      |  86 ++++++
 drivers/crypto/qat/qat_common/qat_algs_send.h      |  11 +
 drivers/crypto/qat/qat_common/qat_asym_algs.c      | 304 ++++++++++-----------
 drivers/crypto/qat/qat_common/qat_crypto.c         |  10 +-
 drivers/crypto/qat/qat_common/qat_crypto.h         |  39 +++
 drivers/gpio/gpio-pca953x.c                        |  22 +-
 drivers/gpio/gpio-xilinx.c                         |   2 +-
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |  27 +-
 drivers/gpu/drm/drm_gem_ttm_helper.c               |   9 +-
 drivers/gpu/drm/imx/dcss/dcss-dev.c                |   3 +
 drivers/gpu/drm/panel/panel-edp.c                  |   2 +-
 drivers/gpu/drm/scheduler/sched_entity.c           |   6 +-
 drivers/i2c/busses/i2c-cadence.c                   |  30 +-
 drivers/i2c/busses/i2c-mlxcpld.c                   |   2 +-
 drivers/infiniband/hw/irdma/cm.c                   |  50 ----
 drivers/infiniband/hw/irdma/i40iw_hw.c             |   1 +
 drivers/infiniband/hw/irdma/icrdma_hw.c            |   1 +
 drivers/infiniband/hw/irdma/irdma.h                |   1 +
 drivers/infiniband/hw/irdma/verbs.c                |   4 +-
 drivers/mmc/host/sdhci-omap.c                      |  14 +-
 drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c         |   6 +-
 drivers/net/amt.c                                  | 243 ++++++++++++----
 drivers/net/can/rcar/rcar_canfd.c                  |   1 +
 drivers/net/dsa/microchip/ksz_common.c             |   5 +-
 drivers/net/dsa/sja1105/sja1105_main.c             |  16 ++
 drivers/net/dsa/vitesse-vsc73xx-spi.c              |  10 +
 .../chelsio/inline_crypto/chtls/chtls_cm.c         |   6 +-
 drivers/net/ethernet/emulex/benet/be_cmds.c        |  10 +-
 drivers/net/ethernet/emulex/benet/be_cmds.h        |   2 +-
 drivers/net/ethernet/emulex/benet/be_ethtool.c     |  31 ++-
 drivers/net/ethernet/intel/e1000e/hw.h             |   1 -
 drivers/net/ethernet/intel/e1000e/ich8lan.c        |   4 -
 drivers/net/ethernet/intel/e1000e/ich8lan.h        |   1 -
 drivers/net/ethernet/intel/e1000e/netdev.c         |  30 +-
 drivers/net/ethernet/intel/i40e/i40e_main.c        |  13 +-
 drivers/net/ethernet/intel/iavf/iavf.h             |  14 +-
 drivers/net/ethernet/intel/iavf/iavf_ethtool.c     |  10 -
 drivers/net/ethernet/intel/iavf/iavf_main.c        |  11 +-
 drivers/net/ethernet/intel/iavf/iavf_txrx.c        |   7 +-
 drivers/net/ethernet/intel/iavf/iavf_virtchnl.c    |  65 ++++-
 drivers/net/ethernet/intel/igc/igc_main.c          |   3 +
 drivers/net/ethernet/intel/igc/igc_regs.h          |   5 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe.h           |   1 +
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c      |   3 +
 drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c     |   6 +
 .../ethernet/marvell/prestera/prestera_flower.c    |   6 +-
 .../net/ethernet/mellanox/mlxsw/spectrum_router.c  |   9 +-
 .../net/ethernet/microchip/lan966x/lan966x_mac.c   | 112 +++++---
 drivers/net/ethernet/netronome/nfp/flower/action.c |   2 +-
 .../net/ethernet/stmicro/stmmac/dwmac-mediatek.c   |  49 ++--
 drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c  |   3 +
 .../net/ethernet/stmicro/stmmac/stmmac_ethtool.c   |   8 -
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |  22 +-
 .../net/ethernet/stmicro/stmmac/stmmac_platform.c  |   8 +-
 drivers/net/usb/ax88179_178a.c                     |  26 +-
 drivers/net/usb/r8152.c                            |  16 +-
 drivers/pci/controller/pci-hyperv.c                |  99 +++++--
 drivers/pinctrl/mvebu/pinctrl-armada-37xx.c        |  79 +++---
 drivers/pinctrl/pinctrl-ocelot.c                   | 214 +++++++++------
 drivers/pinctrl/ralink/Kconfig                     |  16 +-
 drivers/pinctrl/ralink/Makefile                    |   2 +-
 drivers/pinctrl/ralink/pinctrl-mt7620.c            | 252 ++++++++---------
 drivers/pinctrl/ralink/pinctrl-mt7621.c            |  30 +-
 .../ralink/{pinctrl-rt2880.c => pinctrl-ralink.c}  |  92 ++++---
 .../pinctrl/ralink/{pinmux.h => pinctrl-ralink.h}  |  16 +-
 drivers/pinctrl/ralink/pinctrl-rt288x.c            |  20 +-
 drivers/pinctrl/ralink/pinctrl-rt305x.c            |  44 +--
 drivers/pinctrl/ralink/pinctrl-rt3883.c            |  28 +-
 drivers/pinctrl/stm32/pinctrl-stm32.c              |  18 +-
 drivers/pinctrl/sunplus/sppctl.c                   |   3 +
 drivers/power/reset/arm-versatile-reboot.c         |   1 +
 drivers/power/supply/ab8500_fg.c                   |   9 +-
 drivers/spi/spi-bcm2835.c                          |  12 +-
 fs/dlm/lock.c                                      |   3 +-
 fs/exfat/namei.c                                   |  31 +--
 include/drm/gpu_scheduler.h                        |   4 +-
 include/net/amt.h                                  |  20 ++
 include/net/inet_hashtables.h                      |   2 +-
 include/net/inet_sock.h                            |  12 +-
 include/net/ip.h                                   |   6 +-
 include/net/protocol.h                             |   4 -
 include/net/route.h                                |   2 +-
 include/net/tcp.h                                  |  20 +-
 include/net/udp.h                                  |   4 +-
 kernel/bpf/core.c                                  |   8 +-
 kernel/events/core.c                               |  45 ++-
 kernel/sched/deadline.c                            |   5 +-
 kernel/watch_queue.c                               |  53 ++--
 mm/mempolicy.c                                     |   2 +-
 net/core/filter.c                                  |   4 +-
 net/core/secure_seq.c                              |   4 +-
 net/core/sock_reuseport.c                          |   4 +-
 net/dsa/port.c                                     |  63 ++++-
 net/dsa/switch.c                                   |  58 ----
 net/ipv4/af_inet.c                                 |  18 +-
 net/ipv4/fib_semantics.c                           |   2 +-
 net/ipv4/icmp.c                                    |   2 +-
 net/ipv4/igmp.c                                    |  49 ++--
 net/ipv4/inet_connection_sock.c                    |   5 +-
 net/ipv4/ip_forward.c                              |   2 +-
 net/ipv4/ip_input.c                                |  37 ++-
 net/ipv4/ip_sockglue.c                             |   8 +-
 net/ipv4/netfilter/nf_reject_ipv4.c                |   4 +-
 net/ipv4/proc.c                                    |   2 +-
 net/ipv4/route.c                                   |  10 +-
 net/ipv4/syncookies.c                              |   9 +-
 net/ipv4/sysctl_net_ipv4.c                         |  65 +----
 net/ipv4/tcp.c                                     |  13 +-
 net/ipv4/tcp_fastopen.c                            |   9 +-
 net/ipv4/tcp_input.c                               |  51 ++--
 net/ipv4/tcp_ipv4.c                                |   2 +-
 net/ipv4/tcp_metrics.c                             |   3 +-
 net/ipv4/tcp_minisocks.c                           |   4 +-
 net/ipv4/tcp_output.c                              |  29 +-
 net/ipv4/tcp_recovery.c                            |   6 +-
 net/ipv4/tcp_timer.c                               |  30 +-
 net/ipv6/af_inet6.c                                |   2 +-
 net/ipv6/ip6_input.c                               |  23 +-
 net/ipv6/syncookies.c                              |   3 +-
 net/ipv6/tcp_ipv6.c                                |   9 +-
 net/ipv6/udp.c                                     |   9 +-
 net/netfilter/nf_synproxy_core.c                   |   2 +-
 net/sched/cls_api.c                                |  16 +-
 net/sctp/protocol.c                                |   2 +-
 net/smc/smc_llc.c                                  |   2 +-
 net/tls/tls_device.c                               |   8 +-
 net/xfrm/xfrm_policy.c                             |   5 +-
 net/xfrm/xfrm_state.c                              |   2 +-
 security/integrity/ima/ima_policy.c                |   4 +
 sound/soc/sof/intel/hda-loader.c                   |   3 +-
 sound/soc/sof/pm.c                                 |  21 +-
 sound/soc/sof/sof-priv.h                           |   2 +
 tools/perf/tests/perf-time-to-tsc.c                |  27 +-
 tools/testing/selftests/gpio/Makefile              |   2 +-
 tools/testing/selftests/kvm/rseq_test.c            |   8 +-
 virt/kvm/kvm_main.c                                |   5 +-
 152 files changed, 2065 insertions(+), 1419 deletions(-)


