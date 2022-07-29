Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F9665852D7
	for <lists+stable@lfdr.de>; Fri, 29 Jul 2022 17:37:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237837AbiG2Phd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Jul 2022 11:37:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237740AbiG2PhM (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Jul 2022 11:37:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A53B986C25;
        Fri, 29 Jul 2022 08:37:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3519DB8281C;
        Fri, 29 Jul 2022 15:37:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38125C433C1;
        Fri, 29 Jul 2022 15:37:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1659109028;
        bh=8TpTtmn8Ozmp7DSz49UpPY1/ynkxfJ67LREsA+cbzf4=;
        h=From:To:Cc:Subject:Date:From;
        b=I8DhuTaeu94czpKNR9QbLEXERQNs8BtpxBFg5PT6O42nieo7sY1TdKaP1wYs1k7AR
         x41gnGA8+4BwLYA/K59vz0j/HrwXmKBMV4PoA3e9e/LMjVZnJCX1W4QmUYJlAjir6O
         SeZcAvh1s42j6QvIHPxuK3xcrg8wuHmQdaEfmSKs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.15.58
Date:   Fri, 29 Jul 2022 17:37:00 +0200
Message-Id: <165910902019237@kroah.com>
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

I'm announcing the release of the 5.15.58 kernel.

All users of the 5.15 kernel series must upgrade.

The updated 5.15.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.15.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/admin-guide/sysctl/vm.rst                     |    2 
 Makefile                                                    |    2 
 arch/alpha/kernel/srmcons.c                                 |    2 
 arch/riscv/Makefile                                         |    1 
 arch/um/drivers/virtio_uml.c                                |   81 +-
 arch/x86/entry/entry_32.S                                   |   35 
 arch/x86/include/asm/asm.h                                  |   85 +-
 arch/x86/include/asm/cpufeatures.h                          |    1 
 arch/x86/include/asm/extable.h                              |   44 -
 arch/x86/include/asm/extable_fixup_types.h                  |   58 +
 arch/x86/include/asm/fpu/internal.h                         |    4 
 arch/x86/include/asm/futex.h                                |   28 
 arch/x86/include/asm/insn-eval.h                            |    2 
 arch/x86/include/asm/mshyperv.h                             |    7 
 arch/x86/include/asm/msr.h                                  |   30 
 arch/x86/include/asm/nospec-branch.h                        |    2 
 arch/x86/include/asm/segment.h                              |    2 
 arch/x86/include/asm/uaccess.h                              |  142 +++
 arch/x86/kernel/alternative.c                               |    4 
 arch/x86/kernel/cpu/bugs.c                                  |   14 
 arch/x86/kernel/cpu/mce/core.c                              |   40 -
 arch/x86/kernel/cpu/mce/internal.h                          |   10 
 arch/x86/kernel/cpu/mce/severity.c                          |   23 
 arch/x86/kvm/x86.c                                          |   35 
 arch/x86/lib/insn-eval.c                                    |   71 +
 arch/x86/mm/extable.c                                       |  193 ++---
 arch/x86/net/bpf_jit_comp.c                                 |   11 
 drivers/accessibility/speakup/spk_ttyio.c                   |    4 
 drivers/bus/mhi/pci_generic.c                               |   79 ++
 drivers/crypto/qat/qat_4xxx/adf_drv.c                       |    7 
 drivers/crypto/qat/qat_common/Makefile                      |    1 
 drivers/crypto/qat/qat_common/adf_transport.c               |   11 
 drivers/crypto/qat/qat_common/adf_transport.h               |    1 
 drivers/crypto/qat/qat_common/adf_transport_internal.h      |    1 
 drivers/crypto/qat/qat_common/qat_algs.c                    |  138 ++-
 drivers/crypto/qat/qat_common/qat_algs_send.c               |   86 ++
 drivers/crypto/qat/qat_common/qat_algs_send.h               |   11 
 drivers/crypto/qat/qat_common/qat_asym_algs.c               |  304 ++++----
 drivers/crypto/qat/qat_common/qat_crypto.c                  |   10 
 drivers/crypto/qat/qat_common/qat_crypto.h                  |   39 +
 drivers/gpio/gpio-pca953x.c                                 |   22 
 drivers/gpio/gpio-xilinx.c                                  |    2 
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c           |  446 ++++++++++--
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h           |   97 ++
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c |   17 
 drivers/gpu/drm/amd/display/dc/core/dc.c                    |   24 
 drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c            |   89 +-
 drivers/gpu/drm/amd/display/dc/dc_link.h                    |    9 
 drivers/gpu/drm/drm_gem_ttm_helper.c                        |    9 
 drivers/gpu/drm/imx/dcss/dcss-dev.c                         |    3 
 drivers/i2c/busses/i2c-cadence.c                            |   30 
 drivers/i2c/busses/i2c-mlxcpld.c                            |    2 
 drivers/infiniband/hw/irdma/cm.c                            |   50 -
 drivers/infiniband/hw/irdma/i40iw_hw.c                      |    1 
 drivers/infiniband/hw/irdma/icrdma_hw.c                     |    1 
 drivers/infiniband/hw/irdma/irdma.h                         |    1 
 drivers/infiniband/hw/irdma/verbs.c                         |    4 
 drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c                  |   28 
 drivers/net/dsa/microchip/ksz_common.c                      |    5 
 drivers/net/dsa/sja1105/sja1105_main.c                      |   16 
 drivers/net/dsa/vitesse-vsc73xx-spi.c                       |   10 
 drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c |    8 
 drivers/net/ethernet/emulex/benet/be_cmds.c                 |   10 
 drivers/net/ethernet/emulex/benet/be_cmds.h                 |    2 
 drivers/net/ethernet/emulex/benet/be_ethtool.c              |   31 
 drivers/net/ethernet/intel/e1000e/hw.h                      |    1 
 drivers/net/ethernet/intel/e1000e/ich8lan.c                 |    4 
 drivers/net/ethernet/intel/e1000e/ich8lan.h                 |    1 
 drivers/net/ethernet/intel/e1000e/netdev.c                  |   30 
 drivers/net/ethernet/intel/i40e/i40e_main.c                 |   13 
 drivers/net/ethernet/intel/iavf/iavf_txrx.c                 |    5 
 drivers/net/ethernet/intel/igc/igc_main.c                   |    3 
 drivers/net/ethernet/intel/igc/igc_regs.h                   |    5 
 drivers/net/ethernet/intel/ixgbe/ixgbe.h                    |    1 
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c               |    3 
 drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c              |    6 
 drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c       |    9 
 drivers/net/ethernet/netronome/nfp/flower/action.c          |    2 
 drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c           |    3 
 drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c        |    8 
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c           |   22 
 drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c       |    8 
 drivers/net/tun.c                                           |    5 
 drivers/net/usb/ax88179_178a.c                              |   20 
 drivers/net/usb/r8152.c                                     |   16 
 drivers/net/wireless/intel/iwlwifi/fw/uefi.h                |    5 
 drivers/net/wireless/mediatek/mt76/mac80211.c               |    2 
 drivers/net/wireless/mediatek/mt76/mt76.h                   |    2 
 drivers/net/wireless/mediatek/mt76/mt7603/main.c            |    2 
 drivers/net/wireless/mediatek/mt76/mt7615/main.c            |    2 
 drivers/net/wireless/mediatek/mt76/mt76x02_util.c           |    4 
 drivers/net/wireless/mediatek/mt76/mt7915/main.c            |    2 
 drivers/net/wireless/mediatek/mt76/mt7921/main.c            |    2 
 drivers/net/wireless/mediatek/mt76/mt7921/mcu.c             |   30 
 drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h          |    1 
 drivers/net/wireless/mediatek/mt76/mt7921/pci.c             |   30 
 drivers/net/wireless/mediatek/mt76/mt7921/regs.h            |   22 
 drivers/net/wireless/mediatek/mt76/tx.c                     |    9 
 drivers/nvme/host/core.c                                    |   19 
 drivers/pci/controller/pci-hyperv.c                         |  106 ++
 drivers/pinctrl/mvebu/pinctrl-armada-37xx.c                 |   97 +-
 drivers/pinctrl/ralink/Kconfig                              |   16 
 drivers/pinctrl/ralink/Makefile                             |    2 
 drivers/pinctrl/ralink/pinctrl-mt7620.c                     |  252 +++---
 drivers/pinctrl/ralink/pinctrl-mt7621.c                     |   30 
 drivers/pinctrl/ralink/pinctrl-ralink.c                     |  351 +++++++++
 drivers/pinctrl/ralink/pinctrl-ralink.h                     |   53 +
 drivers/pinctrl/ralink/pinctrl-rt2880.c                     |  349 ---------
 drivers/pinctrl/ralink/pinctrl-rt288x.c                     |   20 
 drivers/pinctrl/ralink/pinctrl-rt305x.c                     |   44 -
 drivers/pinctrl/ralink/pinctrl-rt3883.c                     |   28 
 drivers/pinctrl/ralink/pinmux.h                             |   53 -
 drivers/pinctrl/stm32/pinctrl-stm32.c                       |   18 
 drivers/power/reset/arm-versatile-reboot.c                  |    1 
 drivers/s390/char/keyboard.h                                |    4 
 drivers/scsi/megaraid/megaraid_sas_base.c                   |    3 
 drivers/scsi/ufs/ufshcd.c                                   |    2 
 drivers/spi/spi-bcm2835.c                                   |   12 
 drivers/tty/goldfish.c                                      |    2 
 drivers/tty/moxa.c                                          |    4 
 drivers/tty/pty.c                                           |   14 
 drivers/tty/serial/lpc32xx_hs.c                             |    2 
 drivers/tty/serial/mvebu-uart.c                             |   25 
 drivers/tty/tty.h                                           |    3 
 drivers/tty/tty_buffer.c                                    |   66 +
 drivers/tty/vt/keyboard.c                                   |    6 
 drivers/tty/vt/vt.c                                         |    2 
 drivers/usb/host/xhci-dbgcap.c                              |  135 +--
 drivers/usb/host/xhci-dbgcap.h                              |   13 
 drivers/usb/host/xhci-dbgtty.c                              |   22 
 drivers/usb/host/xhci.c                                     |    6 
 fs/dlm/lock.c                                               |    3 
 fs/exfat/namei.c                                            |   31 
 fs/proc/proc_sysctl.c                                       |    2 
 fs/xfs/libxfs/xfs_ag.h                                      |   36 
 fs/xfs/libxfs/xfs_btree_staging.c                           |    4 
 fs/xfs/xfs_ioctl.c                                          |    2 
 fs/xfs/xfs_ioctl.h                                          |    5 
 include/linux/bitfield.h                                    |   19 
 include/linux/skbuff.h                                      |   47 +
 include/linux/sysctl.h                                      |   13 
 include/linux/tty_flip.h                                    |    1 
 include/net/bluetooth/bluetooth.h                           |   65 +
 include/net/inet_hashtables.h                               |    2 
 include/net/inet_sock.h                                     |   12 
 include/net/ip.h                                            |    6 
 include/net/netns/ipv4.h                                    |    1 
 include/net/route.h                                         |    2 
 include/net/tcp.h                                           |   18 
 include/net/udp.h                                           |    2 
 include/trace/events/skb.h                                  |   48 +
 kernel/bpf/core.c                                           |    8 
 kernel/events/core.c                                        |   45 -
 kernel/sched/deadline.c                                     |    5 
 kernel/sysctl.c                                             |   44 -
 kernel/trace/Makefile                                       |    1 
 kernel/trace/ftrace.c                                       |    6 
 kernel/trace/pid_list.c                                     |  160 ++++
 kernel/trace/pid_list.h                                     |   13 
 kernel/trace/trace.c                                        |   84 --
 kernel/trace/trace.h                                        |   14 
 kernel/trace/trace_events.c                                 |   13 
 kernel/watch_queue.c                                        |   53 -
 mm/mempolicy.c                                              |    2 
 net/batman-adv/bridge_loop_avoidance.c                      |    2 
 net/bluetooth/rfcomm/core.c                                 |   50 +
 net/bluetooth/rfcomm/sock.c                                 |   46 -
 net/bluetooth/sco.c                                         |   30 
 net/core/dev.c                                              |    3 
 net/core/drop_monitor.c                                     |   10 
 net/core/filter.c                                           |    4 
 net/core/secure_seq.c                                       |    4 
 net/core/skbuff.c                                           |   12 
 net/core/sock_reuseport.c                                   |    4 
 net/ipv4/af_inet.c                                          |    4 
 net/ipv4/fib_semantics.c                                    |    2 
 net/ipv4/icmp.c                                             |    2 
 net/ipv4/igmp.c                                             |   25 
 net/ipv4/inet_connection_sock.c                             |    5 
 net/ipv4/ip_forward.c                                       |    2 
 net/ipv4/ip_input.c                                         |   26 
 net/ipv4/ip_sockglue.c                                      |    8 
 net/ipv4/netfilter/nf_reject_ipv4.c                         |    4 
 net/ipv4/proc.c                                             |    2 
 net/ipv4/route.c                                            |   10 
 net/ipv4/syncookies.c                                       |   11 
 net/ipv4/sysctl_net_ipv4.c                                  |    8 
 net/ipv4/tcp.c                                              |   13 
 net/ipv4/tcp_fastopen.c                                     |    9 
 net/ipv4/tcp_input.c                                        |   53 -
 net/ipv4/tcp_ipv4.c                                         |   77 +-
 net/ipv4/tcp_metrics.c                                      |    3 
 net/ipv4/tcp_minisocks.c                                    |    4 
 net/ipv4/tcp_output.c                                       |   31 
 net/ipv4/tcp_recovery.c                                     |    6 
 net/ipv4/tcp_timer.c                                        |   30 
 net/ipv4/udp.c                                              |   10 
 net/ipv6/af_inet6.c                                         |    2 
 net/ipv6/syncookies.c                                       |    3 
 net/netfilter/core.c                                        |    3 
 net/netfilter/nf_synproxy_core.c                            |    2 
 net/sctp/protocol.c                                         |    2 
 net/smc/smc_llc.c                                           |    2 
 net/tls/tls_device.c                                        |    8 
 net/xfrm/xfrm_policy.c                                      |    5 
 net/xfrm/xfrm_state.c                                       |    2 
 scripts/sorttable.c                                         |    4 
 security/integrity/ima/ima_policy.c                         |    4 
 tools/perf/tests/perf-time-to-tsc.c                         |   18 
 tools/testing/selftests/kvm/rseq_test.c                     |    8 
 tools/testing/selftests/vm/mremap_test.c                    |   53 -
 virt/kvm/kvm_main.c                                         |    5 
 212 files changed, 3729 insertions(+), 2245 deletions(-)

Adrian Hunter (1):
      perf tests: Fix Convert perf time to TSC test for hybrid

Alex Deucher (1):
      drm/amdgpu/display: add quirk handling for stutter mode

Alexander Aring (1):
      dlm: fix pending remove if msg allocation fails

Alexey Kardashevskiy (1):
      KVM: Don't null dereference ops->destroy

Andy Shevchenko (3):
      pinctrl: armada-37xx: Use temporary variable for struct device
      pinctrl: armada-37xx: Make use of the devm_platform_ioremap_resource()
      pinctrl: armada-37xx: Convert to use dev_err_probe()

Arınç ÜNAL (2):
      pinctrl: ralink: rename MT7628(an) functions to MT76X8
      pinctrl: ralink: rename pinctrl-rt2880 to pinctrl-ralink

Ben Dooks (1):
      riscv: add as-options for modules with assembly compontents

Biao Huang (2):
      net: stmmac: fix pm runtime issue in stmmac_dvr_remove()
      net: stmmac: fix unbalanced ptp clock issue in suspend/resume flow

Bjorn Andersson (1):
      scsi: ufs: core: Drop loglevel of WriteBoost message

Brian Foster (4):
      xfs: fold perag loop iteration logic into helper function
      xfs: rename the next_agno perag iteration variable
      xfs: terminate perag iteration reliably on agcount
      xfs: fix perag reference leak on iteration race with growfs

Christian König (1):
      drm/ttm: fix locking in vmap/vunmap TTM GEM helpers

Christoph Hellwig (1):
      nvme: check for duplicate identifiers earlier

Christophe JAILLET (1):
      mt76: mt7921: Fix the error handling path of mt7921_pci_probe()

Dan Carpenter (2):
      xfs: prevent a WARN_ONCE() in xfs_ioc_attr_list()
      drm/amdgpu: Off by one in dm_dmub_outbox1_low_irq()

Daniele Palmas (2):
      bus: mhi: host: pci_generic: add Telit FN980 v1 hardware revision
      bus: mhi: host: pci_generic: add Telit FN990

Dario Binacchi (1):
      mtd: rawnand: gpmi: validate controller clock rate

Darrick J. Wong (1):
      xfs: fix maxlevels comparisons in the btree staging code

Dawid Lukwinski (1):
      i40e: Fix erroneous adapter reinitialization during recovery process

Dongli Zhang (1):
      net: tun: split run_ebpf_filter() and pskb_trim() into different "if statement"

Eric Dumazet (3):
      ipv4/tcp: do not use per netns ctl sockets
      tcp: sk->sk_bound_dev_if once in inet_request_bound_dev_if()
      bpf: Make sure mac_header was set before using it

Eric Snowberg (1):
      lockdown: Fix kexec lockdown bypass with ima policy

Fabien Dessenne (1):
      pinctrl: stm32: fix optional IRQ support to gpios

Fangzhi Zuo (1):
      drm/amd/display: Ignore First MST Sideband Message Return Error

Felix Fietkau (1):
      mt76: fix use-after-free by removing a non-RCU wcid pointer

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
      Linux 5.15.58

Haibo Chen (3):
      gpio: pca953x: only use single read/write for No AI mode
      gpio: pca953x: use the correct range when do regmap sync
      gpio: pca953x: use the correct register address when regcache sync during init

Hangyu Hua (1):
      xfrm: xfrm_policy: fix a possible double xfrm_pols_put() in xfrm_bundle_lookup()

Hayden Goodfellow (1):
      drm/amd/display: Fix wrong format specifier in amdgpu_dm.c

Hayes Wang (1):
      r8152: fix a WOL issue

Hristo Venev (1):
      be2net: Fix buffer overflow in be_get_module_eeprom

Ido Schimmel (1):
      mlxsw: spectrum_router: Fix IPv4 nexthop gateway indication

Israel Rukshin (1):
      nvme: fix block device naming collision

Jan Beulich (1):
      x86: drop bogus "cc" clobber from __try_cmpxchg_user_asm()

Jeffrey Hugo (4):
      PCI: hv: Fix multi-MSI to allow more than one MSI vector
      PCI: hv: Fix hv_arch_irq_unmask() for multi-MSI
      PCI: hv: Reuse existing IRTE allocation in compose_msi_msg()
      PCI: hv: Fix interrupt mapping for multi-MSI

Jiri Slaby (5):
      tty: drivers/tty/, stop using tty_schedule_flip()
      tty: the rest, stop using tty_schedule_flip()
      tty: drop tty_schedule_flip()
      tty: extract tty_flip_buffer_commit() from tty_flip_buffer_push()
      tty: use new tty_insert_flip_string_and_push_buffer() in pty_write()

Johannes Berg (2):
      iwlwifi: fw: uefi: add missing include guards
      um: virtio_uml: Fix broken device handling in time-travel

Jose Alonso (1):
      net: usb: ax88179_178a needs FLAG_SEND_ZLP

José Expósito (1):
      drm/amd/display: invalid parameter check in dmub_hpd_callback

Jude Shih (1):
      drm/amd/display: Support for DMUB HPD interrupt handling

Junxiao Chang (1):
      net: stmmac: fix dma queue left shift overflow issue

Juri Lelli (1):
      sched/deadline: Fix BUG_ON condition for deboosted tasks

Kees Cook (1):
      x86/alternative: Report missing return thunk details

Kishon Vijay Abraham I (1):
      xhci: Set HCD flag to defer primary roothub registration

Kuniyuki Iwashima (45):
      ip: Fix data-races around sysctl_ip_default_ttl.
      tcp: Fix data-races around sysctl_tcp_ecn.
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
      igmp: Fix data-races around sysctl_igmp_llm_reports.
      igmp: Fix a data-race around sysctl_igmp_max_memberships.
      igmp: Fix data-races around sysctl_igmp_max_msf.
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

Liang He (2):
      net: dsa: microchip: ksz_common: Fix refcount leak bug
      drm/imx/dcss: Add missing of_node_put() in fail path

Linus Torvalds (2):
      watchqueue: make sure to serialize 'wqueue->defunct' properly
      watch-queue: remove spurious double semicolon

Luiz Augusto von Dentz (7):
      Bluetooth: Add bt_skb_sendmsg helper
      Bluetooth: Add bt_skb_sendmmsg helper
      Bluetooth: SCO: Replace use of memcpy_from_msg with bt_skb_sendmsg
      Bluetooth: RFCOMM: Replace use of memcpy_from_msg with bt_skb_sendmmsg
      Bluetooth: Fix passing NULL to PTR_ERR
      Bluetooth: SCO: Fix sco_send_frame returning skb->len
      Bluetooth: Fix bt_skb_sendmmsg not allocating partial chunks

Marc Kleine-Budde (1):
      spi: bcm2835: bcm2835_spi_handle_err(): fix NULL pointer deref for non DMA transfers

Mathias Nyman (3):
      xhci: dbc: refactor xhci_dbc_init()
      xhci: dbc: create and remove dbc structure in dbgtty driver.
      xhci: dbc: Rename xhci_dbc_init and xhci_dbc_exit

Maxim Levitsky (1):
      KVM: x86: fix typo in __try_cmpxchg_user causing non-atomicness

Menglong Dong (8):
      net: skb: introduce kfree_skb_reason()
      net: skb: use kfree_skb_reason() in tcp_v4_rcv()
      net: skb: use kfree_skb_reason() in __udp4_lib_rcv()
      net: socket: rename SKB_DROP_REASON_SOCKET_FILTER
      net: skb_drop_reason: add document for drop reasons
      net: netfilter: use kfree_drop_reason() for NF_DROP
      net: ipv4: use kfree_skb_reason() in ip_rcv_core()
      net: ipv4: use kfree_skb_reason() in ip_rcv_finish_core()

Miaoqian Lin (1):
      power/reset: arm-versatile: Fix refcount leak in versatile_reboot_probe

Ming Lei (1):
      scsi: megaraid: Clear READ queue map's nr_queues

Mustafa Ismail (2):
      RDMA/irdma: Do not advertise 1GB page size for x722
      RDMA/irdma: Fix sleep from invalid context BUG

Nicholas Kazlauskas (4):
      drm/amd/display: Reset DMCUB before HW init
      drm/amd/display: Optimize bandwidth on following fast update
      drm/amd/display: Fix surface optimization regression on Carrizo
      drm/amd/display: Don't lock connection_mutex for DMUB HPD

Nick Desaulniers (1):
      x86/extable: Prefer local labels in .set directives

Oleksandr Tymoshenko (2):
      Revert "selftest/vm: verify remap destination address in mremap_test"
      Revert "selftest/vm: verify mmap addr in mremap_test"

Oleksij Rempel (2):
      net: dsa: sja1105: silent spi_device_id warnings
      net: dsa: vitesse-vsc73xx: silent spi_device_id warnings

Pali Rohár (1):
      serial: mvebu-uart: correctly report configured baudrate value

Pawan Gupta (1):
      x86/bugs: Warn when "ibrs" mitigation is selected on Enhanced IBRS parts

Peter Zijlstra (9):
      perf/core: Fix data race between perf_event_set_output() and perf_mmap_close()
      x86/uaccess: Implement macros for CMPXCHG on user addresses
      bitfield.h: Fix "type of reg too small for mask" test
      x86/entry_32: Remove .fixup usage
      x86/extable: Extend extable functionality
      x86/msr: Remove .fixup usage
      x86/futex: Remove .fixup usage
      x86/amd: Use IBPB for firmware calls
      x86/entry_32: Fix segment exceptions

Piotr Skajewski (1):
      ixgbe: Add locking to prevent panic when setting sriov_numvfs to zero

Przemyslaw Patynowski (1):
      iavf: Fix handling of dummy receive descriptors

Robert Hancock (1):
      i2c: cadence: Change large transfer count reset logic to be unconditional

Sascha Hauer (1):
      mtd: rawnand: gpmi: Set WAIT_FOR_READY timeout based on program/erase times

Sasha Neftin (2):
      e1000e: Enable GPT clock before sending message to CSME
      Revert "e1000e: Fix possible HW unit hang after an s0ix exit"

Sean Christopherson (1):
      KVM: x86: Use __try_cmpxchg_user() to emulate atomic accesses

Sean Wang (4):
      Revert "mt76: mt7921: Fix the error handling path of mt7921_pci_probe()"
      Revert "mt76: mt7921e: fix possible probe failure after reboot"
      mt76: mt7921: use physical addr to unify register access
      mt76: mt7921e: fix possible probe failure after reboot

Sebastian Andrzej Siewior (1):
      batman-adv: Use netif_rx_any_context() any.

Srinivas Neeli (1):
      gpio: gpio-xilinx: Fix integer overflow

Steven Rostedt (Google) (1):
      tracing: Have event format check not flag %p* on __get_dynamic_array()

Steven Rostedt (VMware) (1):
      tracing: Place trace_pid_list logic into abstract functions

Sungjong Seo (1):
      exfat: use updated exfat_chain directly during renaming

Suren Baghdasaryan (1):
      mm/pagealloc: sysctl: change watermark_scale_factor max limit to 30%

Tariq Toukan (1):
      net/tls: Fix race in TLS device down flow

Thomas Gleixner (5):
      x86/extable: Tidy up redundant handler functions
      x86/extable: Get rid of redundant macros
      x86/mce: Deduplicate exception handling
      x86/extable: Rework the exception table mechanics
      x86/extable: Provide EX_TYPE_DEFAULT_MCE_SAFE and EX_TYPE_FAULT_MCE_SAFE

Vadim Pasternak (1):
      i2c: mlxcpld: Fix register setting for 400KHz frequency

Vincent Whitchurch (1):
      um: virtio_uml: Allow probing from devicetree

Vladimir Oltean (1):
      pinctrl: armada-37xx: use raw spinlocks for regmap to avoid invalid wait context

Wang Cheng (1):
      mm/mempolicy: fix uninit-value in mpol_rebind_policy()

Wayne Lin (2):
      drm/amd/display: Add option to defer works of hpd_rx_irq
      drm/amd/display: Fork thread to offload work of hpd_rx_irq

William Dean (1):
      pinctrl: ralink: Check for null return of devm_kcalloc

Wong Vee Khee (1):
      net: stmmac: remove redunctant disable xPCS EEE call

Wonhyuk Yang (1):
      tracing: Fix return value of trace_pid_write()

Xiaoming Ni (1):
      sysctl: move some boundary constants from sysctl.c to sysctl_vals

Yuezhang Mo (1):
      exfat: fix referencing wrong parent directory information after renaming

