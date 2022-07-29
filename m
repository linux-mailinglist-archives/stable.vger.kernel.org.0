Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F9A85852DB
	for <lists+stable@lfdr.de>; Fri, 29 Jul 2022 17:38:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237785AbiG2PiG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Jul 2022 11:38:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237786AbiG2PhW (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Jul 2022 11:37:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1466D87226;
        Fri, 29 Jul 2022 08:37:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8305461CCC;
        Fri, 29 Jul 2022 15:37:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F6D2C433C1;
        Fri, 29 Jul 2022 15:37:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1659109039;
        bh=Tflfs4Ng8P8wF4moAR7sQp0wvjyUYpoEgMgSaDj6wKU=;
        h=From:To:Cc:Subject:Date:From;
        b=MO4xOGV/O4S5L9z3/2TMx2TmfQHkS5JRFDhiehyWlGnvqDfGdPz5meVR8tD5UGmfp
         HYVHD3JMIJHy70pabaEKX4jjWln2CsuR4pLJQSjgfJQgoRmol9vLn7paNg4O/HTkqn
         W385oSgbTHXN7fNHQVFCfg17i4kLAoCHtH8uj61c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.18.15
Date:   Fri, 29 Jul 2022 17:37:05 +0200
Message-Id: <1659109025232@kroah.com>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
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

I'm announcing the release of the 5.18.15 kernel.

All users of the 5.18 kernel series must upgrade.

The updated 5.18.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.18.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                                    |    2 
 arch/riscv/Makefile                                         |    1 
 arch/x86/events/intel/lbr.c                                 |   19 
 arch/x86/include/asm/cpufeatures.h                          |    1 
 arch/x86/include/asm/nospec-branch.h                        |    2 
 arch/x86/kernel/alternative.c                               |    4 
 arch/x86/kernel/cpu/bugs.c                                  |   14 
 drivers/acpi/cppc_acpi.c                                    |    6 
 drivers/bus/mhi/host/pci_generic.c                          |   79 ++
 drivers/clk/clk-lan966x.c                                   |    2 
 drivers/crypto/qat/qat_4xxx/adf_drv.c                       |    7 
 drivers/crypto/qat/qat_common/Makefile                      |    1 
 drivers/crypto/qat/qat_common/adf_transport.c               |   11 
 drivers/crypto/qat/qat_common/adf_transport.h               |    1 
 drivers/crypto/qat/qat_common/adf_transport_internal.h      |    1 
 drivers/crypto/qat/qat_common/qat_algs.c                    |  138 ++--
 drivers/crypto/qat/qat_common/qat_algs_send.c               |   86 ++
 drivers/crypto/qat/qat_common/qat_algs_send.h               |   11 
 drivers/crypto/qat/qat_common/qat_asym_algs.c               |  304 +++++-----
 drivers/crypto/qat/qat_common/qat_crypto.c                  |   10 
 drivers/crypto/qat/qat_common/qat_crypto.h                  |   39 +
 drivers/gpio/gpio-pca953x.c                                 |   22 
 drivers/gpio/gpio-xilinx.c                                  |    2 
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c           |   27 
 drivers/gpu/drm/drm_gem_ttm_helper.c                        |    9 
 drivers/gpu/drm/imx/dcss/dcss-dev.c                         |    3 
 drivers/gpu/drm/panel/panel-edp.c                           |    2 
 drivers/gpu/drm/scheduler/sched_entity.c                    |    6 
 drivers/i2c/busses/i2c-cadence.c                            |   30 -
 drivers/i2c/busses/i2c-mlxcpld.c                            |    2 
 drivers/infiniband/hw/irdma/cm.c                            |   50 -
 drivers/infiniband/hw/irdma/i40iw_hw.c                      |    1 
 drivers/infiniband/hw/irdma/icrdma_hw.c                     |    1 
 drivers/infiniband/hw/irdma/irdma.h                         |    1 
 drivers/infiniband/hw/irdma/verbs.c                         |    4 
 drivers/mmc/host/sdhci-omap.c                               |   14 
 drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c                  |    6 
 drivers/net/amt.c                                           |  243 ++++++--
 drivers/net/can/rcar/rcar_canfd.c                           |    1 
 drivers/net/dsa/microchip/ksz_common.c                      |    5 
 drivers/net/dsa/sja1105/sja1105_main.c                      |   16 
 drivers/net/dsa/vitesse-vsc73xx-spi.c                       |   10 
 drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c |    6 
 drivers/net/ethernet/emulex/benet/be_cmds.c                 |   10 
 drivers/net/ethernet/emulex/benet/be_cmds.h                 |    2 
 drivers/net/ethernet/emulex/benet/be_ethtool.c              |   31 -
 drivers/net/ethernet/intel/e1000e/hw.h                      |    1 
 drivers/net/ethernet/intel/e1000e/ich8lan.c                 |    4 
 drivers/net/ethernet/intel/e1000e/ich8lan.h                 |    1 
 drivers/net/ethernet/intel/e1000e/netdev.c                  |   30 -
 drivers/net/ethernet/intel/i40e/i40e_main.c                 |   13 
 drivers/net/ethernet/intel/iavf/iavf.h                      |   14 
 drivers/net/ethernet/intel/iavf/iavf_ethtool.c              |   10 
 drivers/net/ethernet/intel/iavf/iavf_main.c                 |   11 
 drivers/net/ethernet/intel/iavf/iavf_txrx.c                 |    7 
 drivers/net/ethernet/intel/iavf/iavf_virtchnl.c             |   65 ++
 drivers/net/ethernet/intel/igc/igc_main.c                   |    3 
 drivers/net/ethernet/intel/igc/igc_regs.h                   |    5 
 drivers/net/ethernet/intel/ixgbe/ixgbe.h                    |    1 
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c               |    3 
 drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c              |    6 
 drivers/net/ethernet/marvell/prestera/prestera_flower.c     |    6 
 drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c       |    9 
 drivers/net/ethernet/microchip/lan966x/lan966x_mac.c        |  112 ++-
 drivers/net/ethernet/netronome/nfp/flower/action.c          |    2 
 drivers/net/ethernet/stmicro/stmmac/dwmac-mediatek.c        |   49 -
 drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c           |    3 
 drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c        |    8 
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c           |   22 
 drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c       |    8 
 drivers/net/usb/ax88179_178a.c                              |   26 
 drivers/net/usb/r8152.c                                     |   16 
 drivers/pci/controller/pci-hyperv.c                         |   99 ++-
 drivers/pinctrl/mvebu/pinctrl-armada-37xx.c                 |   79 +-
 drivers/pinctrl/pinctrl-ocelot.c                            |  214 ++++---
 drivers/pinctrl/ralink/Kconfig                              |   16 
 drivers/pinctrl/ralink/Makefile                             |    2 
 drivers/pinctrl/ralink/pinctrl-mt7620.c                     |  252 ++++----
 drivers/pinctrl/ralink/pinctrl-mt7621.c                     |   30 -
 drivers/pinctrl/ralink/pinctrl-ralink.c                     |  351 ++++++++++++
 drivers/pinctrl/ralink/pinctrl-ralink.h                     |   53 +
 drivers/pinctrl/ralink/pinctrl-rt2880.c                     |  349 -----------
 drivers/pinctrl/ralink/pinctrl-rt288x.c                     |   20 
 drivers/pinctrl/ralink/pinctrl-rt305x.c                     |   44 -
 drivers/pinctrl/ralink/pinctrl-rt3883.c                     |   28 
 drivers/pinctrl/ralink/pinmux.h                             |   53 -
 drivers/pinctrl/stm32/pinctrl-stm32.c                       |   18 
 drivers/pinctrl/sunplus/sppctl.c                            |    3 
 drivers/power/reset/arm-versatile-reboot.c                  |    1 
 drivers/power/supply/ab8500_fg.c                            |    9 
 drivers/spi/spi-bcm2835.c                                   |   12 
 fs/dlm/lock.c                                               |    3 
 fs/exfat/namei.c                                            |   31 -
 include/drm/gpu_scheduler.h                                 |    4 
 include/net/amt.h                                           |   20 
 include/net/inet_hashtables.h                               |    2 
 include/net/inet_sock.h                                     |   12 
 include/net/ip.h                                            |    6 
 include/net/protocol.h                                      |    4 
 include/net/route.h                                         |    2 
 include/net/tcp.h                                           |   20 
 include/net/udp.h                                           |    4 
 kernel/bpf/core.c                                           |    8 
 kernel/events/core.c                                        |   45 +
 kernel/sched/deadline.c                                     |    5 
 kernel/watch_queue.c                                        |   53 +
 mm/mempolicy.c                                              |    2 
 net/core/filter.c                                           |    4 
 net/core/secure_seq.c                                       |    4 
 net/core/sock_reuseport.c                                   |    4 
 net/dsa/port.c                                              |   63 ++
 net/dsa/switch.c                                            |   58 -
 net/ipv4/af_inet.c                                          |   18 
 net/ipv4/fib_semantics.c                                    |    2 
 net/ipv4/icmp.c                                             |    2 
 net/ipv4/igmp.c                                             |   49 -
 net/ipv4/inet_connection_sock.c                             |    5 
 net/ipv4/ip_forward.c                                       |    2 
 net/ipv4/ip_input.c                                         |   37 -
 net/ipv4/ip_sockglue.c                                      |    8 
 net/ipv4/netfilter/nf_reject_ipv4.c                         |    4 
 net/ipv4/proc.c                                             |    2 
 net/ipv4/route.c                                            |   10 
 net/ipv4/syncookies.c                                       |    9 
 net/ipv4/sysctl_net_ipv4.c                                  |   65 --
 net/ipv4/tcp.c                                              |   13 
 net/ipv4/tcp_fastopen.c                                     |    9 
 net/ipv4/tcp_input.c                                        |   51 +
 net/ipv4/tcp_ipv4.c                                         |    2 
 net/ipv4/tcp_metrics.c                                      |    3 
 net/ipv4/tcp_minisocks.c                                    |    4 
 net/ipv4/tcp_output.c                                       |   29 
 net/ipv4/tcp_recovery.c                                     |    6 
 net/ipv4/tcp_timer.c                                        |   30 -
 net/ipv6/af_inet6.c                                         |    2 
 net/ipv6/ip6_input.c                                        |   23 
 net/ipv6/syncookies.c                                       |    3 
 net/ipv6/tcp_ipv6.c                                         |    9 
 net/ipv6/udp.c                                              |    9 
 net/netfilter/nf_synproxy_core.c                            |    2 
 net/sched/cls_api.c                                         |   16 
 net/sctp/protocol.c                                         |    2 
 net/smc/smc_llc.c                                           |    2 
 net/tls/tls_device.c                                        |    8 
 net/xfrm/xfrm_policy.c                                      |    5 
 net/xfrm/xfrm_state.c                                       |    2 
 security/integrity/ima/ima_policy.c                         |    4 
 sound/soc/sof/intel/hda-loader.c                            |    3 
 sound/soc/sof/pm.c                                          |   21 
 sound/soc/sof/sof-priv.h                                    |    2 
 tools/perf/tests/perf-time-to-tsc.c                         |   27 
 tools/testing/selftests/gpio/Makefile                       |    2 
 tools/testing/selftests/kvm/rseq_test.c                     |    8 
 virt/kvm/kvm_main.c                                         |    5 
 154 files changed, 2413 insertions(+), 1767 deletions(-)

Adrian Hunter (2):
      perf tests: Stop Convert perf time to TSC test opening events twice
      perf tests: Fix Convert perf time to TSC test for hybrid

Alexander Aring (1):
      dlm: fix pending remove if msg allocation fails

Alexey Kardashevskiy (1):
      KVM: Don't null dereference ops->destroy

Andy Shevchenko (1):
      pinctrl: armada-37xx: Reuse GPIO fwnode in armada_37xx_irqchip_register()

Arınç ÜNAL (2):
      pinctrl: ralink: rename MT7628(an) functions to MT76X8
      pinctrl: ralink: rename pinctrl-rt2880 to pinctrl-ralink

Ben Dooks (1):
      riscv: add as-options for modules with assembly compontents

Biao Huang (3):
      stmmac: dwmac-mediatek: fix clock issue
      net: stmmac: fix pm runtime issue in stmmac_dvr_remove()
      net: stmmac: fix unbalanced ptp clock issue in suspend/resume flow

Christian König (1):
      drm/ttm: fix locking in vmap/vunmap TTM GEM helpers

Daniele Palmas (2):
      bus: mhi: host: pci_generic: add Telit FN980 v1 hardware revision
      bus: mhi: host: pci_generic: add Telit FN990

Dawid Lukwinski (1):
      i40e: Fix erroneous adapter reinitialization during recovery process

Dmitry Osipenko (1):
      drm/scheduler: Don't kill jobs in interrupt context

Eric Dumazet (2):
      tcp: sk->sk_bound_dev_if once in inet_request_bound_dev_if()
      bpf: Make sure mac_header was set before using it

Eric Snowberg (1):
      lockdown: Fix kexec lockdown bypass with ima policy

Fabien Dessenne (1):
      pinctrl: stm32: fix optional IRQ support to gpios

Gao Chao (1):
      power: supply: ab8500_fg: add missing destroy_workqueue in ab8500_fg_probe

Gavin Shan (1):
      KVM: selftests: Fix target thread to be migrated in rseq_test

Giovanni Cabiddu (10):
      crypto: qat - set to zero DH parameters before free
      crypto: qat - use pre-allocated buffers in datapath
      crypto: qat - refactor submission logic
      crypto: qat - add backlog mechanism
      crypto: qat - fix memory leak in RSA
      crypto: qat - remove dma_free_coherent() for RSA
      crypto: qat - remove dma_free_coherent() for DH
      crypto: qat - add param check for RSA
      crypto: qat - add param check for DH
      crypto: qat - re-enable registration of algorithms

Greg Kroah-Hartman (1):
      Linux 5.18.15

Haibo Chen (3):
      gpio: pca953x: only use single read/write for No AI mode
      gpio: pca953x: use the correct range when do regmap sync
      gpio: pca953x: use the correct register address when regcache sync during init

Hangyu Hua (1):
      xfrm: xfrm_policy: fix a possible double xfrm_pols_put() in xfrm_bundle_lookup()

Hayes Wang (1):
      r8152: fix a WOL issue

Herve Codina (1):
      clk: lan966x: Fix the lan966x clock gate register address

Horatiu Vultur (7):
      pinctrl: ocelot: Fix pincfg for lan966x
      pinctrl: ocelot: Fix pincfg
      net: lan966x: Fix taking rtnl_lock while holding spin_lock
      net: lan966x: Fix usage of lan966x->mac_lock when entry is added
      net: lan966x: Fix usage of lan966x->mac_lock when entry is removed
      net: lan966x: Fix usage of lan966x->mac_lock inside lan966x_mac_irq_handler
      net: lan966x: Fix usage of lan966x->mac_lock when used by FDB

Hristo Venev (1):
      be2net: Fix buffer overflow in be_get_module_eeprom

Ido Schimmel (1):
      mlxsw: spectrum_router: Fix IPv4 nexthop gateway indication

Jeffrey Hugo (4):
      PCI: hv: Fix multi-MSI to allow more than one MSI vector
      PCI: hv: Fix hv_arch_irq_unmask() for multi-MSI
      PCI: hv: Reuse existing IRTE allocation in compose_msi_msg()
      PCI: hv: Fix interrupt mapping for multi-MSI

Jose Alonso (1):
      net: usb: ax88179_178a needs FLAG_SEND_ZLP

Junxiao Chang (1):
      net: stmmac: fix dma queue left shift overflow issue

Juri Lelli (1):
      sched/deadline: Fix BUG_ON condition for deboosted tasks

Kan Liang (1):
      perf/x86/intel/lbr: Fix unchecked MSR access error on HSW

Kees Cook (1):
      x86/alternative: Report missing return thunk details

Kent Gibson (1):
      selftests: gpio: fix include path to kernel headers for out of tree builds

Kuniyuki Iwashima (46):
      ip: Fix data-races around sysctl_ip_default_ttl.
      ip: Fix data-races around sysctl_ip_no_pmtu_disc.
      ip: Fix data-races around sysctl_ip_fwd_use_pmtu.
      ip: Fix data-races around sysctl_ip_fwd_update_priority.
      ip: Fix data-races around sysctl_ip_nonlocal_bind.
      ip: Fix a data-race around sysctl_ip_autobind_reuse.
      ip: Fix a data-race around sysctl_fwmark_reflect.
      tcp/dccp: Fix a data-race around sysctl_tcp_fwmark_accept.
      tcp: Fix data-races around sysctl_tcp_l3mdev_accept.
      tcp: Fix data-races around sysctl_tcp_mtu_probing.
      tcp: Fix data-races around sysctl_tcp_base_mss.
      tcp: Fix data-races around sysctl_tcp_min_snd_mss.
      tcp: Fix a data-race around sysctl_tcp_mtu_probe_floor.
      tcp: Fix a data-race around sysctl_tcp_probe_threshold.
      tcp: Fix a data-race around sysctl_tcp_probe_interval.
      tcp/udp: Make early_demux back namespacified.
      igmp: Fix data-races around sysctl_igmp_llm_reports.
      igmp: Fix a data-race around sysctl_igmp_max_memberships.
      igmp: Fix data-races around sysctl_igmp_max_msf.
      igmp: Fix data-races around sysctl_igmp_qrv.
      tcp: Fix data-races around keepalive sysctl knobs.
      tcp: Fix data-races around sysctl_tcp_syn(ack)?_retries.
      tcp: Fix data-races around sysctl_tcp_syncookies.
      tcp: Fix data-races around sysctl_tcp_migrate_req.
      tcp: Fix data-races around sysctl_tcp_reordering.
      tcp: Fix data-races around some timeout sysctl knobs.
      tcp: Fix a data-race around sysctl_tcp_notsent_lowat.
      tcp: Fix a data-race around sysctl_tcp_tw_reuse.
      tcp: Fix data-races around sysctl_max_syn_backlog.
      tcp: Fix data-races around sysctl_tcp_fastopen.
      tcp: Fix data-races around sysctl_tcp_fastopen_blackhole_timeout.
      ipv4: Fix a data-race around sysctl_fib_multipath_use_neigh.
      ipv4: Fix data-races around sysctl_fib_multipath_hash_policy.
      ipv4: Fix data-races around sysctl_fib_multipath_hash_fields.
      ip: Fix data-races around sysctl_ip_prot_sock.
      udp: Fix a data-race around sysctl_udp_l3mdev_accept.
      tcp: Fix data-races around sysctl knobs related to SYN option.
      tcp: Fix a data-race around sysctl_tcp_early_retrans.
      tcp: Fix data-races around sysctl_tcp_recovery.
      tcp: Fix a data-race around sysctl_tcp_thin_linear_timeouts.
      tcp: Fix data-races around sysctl_tcp_slow_start_after_idle.
      tcp: Fix a data-race around sysctl_tcp_retrans_collapse.
      tcp: Fix a data-race around sysctl_tcp_stdurg.
      tcp: Fix a data-race around sysctl_tcp_rfc1337.
      tcp: Fix a data-race around sysctl_tcp_abort_on_overflow.
      tcp: Fix data-races around sysctl_tcp_max_reordering.

Lennert Buytenhek (1):
      igc: Reinstate IGC_REMOVED logic and implement it properly

Liang He (3):
      net: dsa: microchip: ksz_common: Fix refcount leak bug
      drm/imx/dcss: Add missing of_node_put() in fail path
      can: rcar_canfd: Add missing of_node_put() in rcar_canfd_probe()

Linus Torvalds (2):
      watchqueue: make sure to serialize 'wqueue->defunct' properly
      watch-queue: remove spurious double semicolon

Maksym Glubokiy (1):
      net: prestera: acl: use proper mask for port selector

Marc Kleine-Budde (1):
      spi: bcm2835: bcm2835_spi_handle_err(): fix NULL pointer deref for non DMA transfers

Mario Limonciello (1):
      ACPI: CPPC: Don't require flexible address space if X86_FEATURE_CPPC is supported

Miaoqian Lin (1):
      power/reset: arm-versatile: Fix refcount leak in versatile_reboot_probe

Mustafa Ismail (2):
      RDMA/irdma: Do not advertise 1GB page size for x722
      RDMA/irdma: Fix sleep from invalid context BUG

Nícolas F. R. A. Prado (1):
      drm/panel-edp: Fix variable typo when saving hpd absent delay from DT

Oleksij Rempel (2):
      net: dsa: sja1105: silent spi_device_id warnings
      net: dsa: vitesse-vsc73xx: silent spi_device_id warnings

Oz Shlomo (1):
      net/sched: cls_api: Fix flow action initialization

Pawan Gupta (1):
      x86/bugs: Warn when "ibrs" mitigation is selected on Enhanced IBRS parts

Peter Zijlstra (2):
      perf/core: Fix data race between perf_event_set_output() and perf_mmap_close()
      x86/amd: Use IBPB for firmware calls

Pierre-Louis Bossart (3):
      ASoC: SOF: pm: add explicit behavior for ACPI S1 and S2
      ASoC: SOF: pm: add definitions for S4 and S5 states
      ASoC: SOF: Intel: disable IMR boot when resuming from ACPI S4 and S5 states

Piotr Skajewski (1):
      ixgbe: Add locking to prevent panic when setting sriov_numvfs to zero

Przemyslaw Patynowski (4):
      iavf: Fix VLAN_V2 addition/rejection
      iavf: Disallow changing rx/tx-frames and rx/tx-frames-irq
      iavf: Fix handling of dummy receive descriptors
      iavf: Fix missing state logs

Robert Hancock (1):
      i2c: cadence: Change large transfer count reset logic to be unconditional

Sascha Hauer (1):
      mtd: rawnand: gpmi: Set WAIT_FOR_READY timeout based on program/erase times

Sasha Neftin (2):
      e1000e: Enable GPT clock before sending message to CSME
      Revert "e1000e: Fix possible HW unit hang after an s0ix exit"

Srinivas Neeli (1):
      gpio: gpio-xilinx: Fix integer overflow

Stylon Wang (1):
      drm/amd/display: Fix new dmub notification enabling in DM

Sungjong Seo (1):
      exfat: use updated exfat_chain directly during renaming

Taehee Yoo (8):
      amt: use workqueue for gateway side message handling
      amt: remove unnecessary locks
      amt: use READ_ONCE() in amt module
      amt: add missing regeneration nonce logic in request logic
      amt: drop unexpected advertisement message
      amt: drop unexpected query message
      amt: drop unexpected multicast data
      amt: do not use amt->nr_tunnels outside of lock

Tariq Toukan (1):
      net/tls: Fix race in TLS device down flow

Tony Lindgren (1):
      mmc: sdhci-omap: Fix a lockdep warning for PM runtime init

Vadim Pasternak (1):
      i2c: mlxcpld: Fix register setting for 400KHz frequency

Vladimir Oltean (5):
      pinctrl: armada-37xx: use raw spinlocks for regmap to avoid invalid wait context
      pinctrl: armada-37xx: make irq_lock a raw spinlock to avoid invalid wait context
      net: dsa: fix dsa_port_vlan_filtering when global
      net: dsa: move reset of VLAN filtering to dsa_port_switchdev_unsync_attrs
      net: dsa: fix NULL pointer dereference in dsa_port_reset_vlan_filtering

Wang Cheng (1):
      mm/mempolicy: fix uninit-value in mpol_rebind_policy()

William Dean (2):
      pinctrl: ralink: Check for null return of devm_kcalloc
      pinctrl: sunplus: Add check for kcalloc

Wong Vee Khee (1):
      net: stmmac: remove redunctant disable xPCS EEE call

Yuezhang Mo (1):
      exfat: fix referencing wrong parent directory information after renaming

