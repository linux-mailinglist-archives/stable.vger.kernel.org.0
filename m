Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E38605852D0
	for <lists+stable@lfdr.de>; Fri, 29 Jul 2022 17:37:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236984AbiG2Ph3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Jul 2022 11:37:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237236AbiG2PhI (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Jul 2022 11:37:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 135A686C0E;
        Fri, 29 Jul 2022 08:37:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9429CB8283F;
        Fri, 29 Jul 2022 15:37:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D50DDC433C1;
        Fri, 29 Jul 2022 15:36:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1659109019;
        bh=2MBNzet9AbeGiILVPT9CY5a1SsTx+MbXXaEpYofTgVk=;
        h=From:To:Cc:Subject:Date:From;
        b=NyvhHFDNXLXvAhnnyXGH5UhZ8U80IXyUxCd85/EwZEVezuyudXms1w/HvA2eQkobD
         8I6JGpT295KuAITb8O/iHxG14wH4S3sPZ/VC/AA09zd4VItFFyfNPOGFtSwjxOHPJu
         EzeajnHsJU3YIbzZ9icA35xvL2mgQjrFnICPktkM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.10.134
Date:   Fri, 29 Jul 2022 17:36:55 +0200
Message-Id: <165910901581134@kroah.com>
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

I'm announcing the release of the 5.10.134 kernel.

All users of the 5.10 kernel series must upgrade.

The updated 5.10.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.10.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/networking/netdevices.rst                     |  171 ++++++++
 Makefile                                                    |    2 
 arch/alpha/kernel/srmcons.c                                 |    2 
 arch/m68k/Kconfig.bus                                       |    2 
 arch/riscv/Makefile                                         |    1 
 arch/x86/include/asm/cpufeatures.h                          |    1 
 arch/x86/include/asm/mshyperv.h                             |    7 
 arch/x86/include/asm/nospec-branch.h                        |    2 
 arch/x86/kernel/alternative.c                               |    4 
 arch/x86/kernel/cpu/bugs.c                                  |   14 
 drivers/accessibility/speakup/spk_ttyio.c                   |    4 
 drivers/gpio/gpio-pca953x.c                                 |   22 -
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c           |   33 +
 drivers/gpu/drm/imx/dcss/dcss-dev.c                         |    3 
 drivers/gpu/drm/imx/dcss/dcss-plane.c                       |    2 
 drivers/i2c/busses/i2c-cadence.c                            |   30 -
 drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c |    6 
 drivers/net/ethernet/emulex/benet/be_cmds.c                 |   10 
 drivers/net/ethernet/emulex/benet/be_cmds.h                 |    2 
 drivers/net/ethernet/emulex/benet/be_ethtool.c              |   31 -
 drivers/net/ethernet/intel/i40e/i40e_main.c                 |   13 
 drivers/net/ethernet/intel/iavf/iavf_txrx.c                 |    5 
 drivers/net/ethernet/intel/igc/igc_main.c                   |    3 
 drivers/net/ethernet/intel/igc/igc_regs.h                   |    5 
 drivers/net/ethernet/intel/ixgbe/ixgbe.h                    |    1 
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c               |    3 
 drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c              |    6 
 drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c       |    5 
 drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c           |    3 
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c           |   17 
 drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c       |    8 
 drivers/net/usb/ax88179_178a.c                              |   20 -
 drivers/pci/controller/pci-hyperv.c                         |   99 ++++-
 drivers/pinctrl/stm32/pinctrl-stm32.c                       |   18 
 drivers/power/reset/arm-versatile-reboot.c                  |    1 
 drivers/s390/char/keyboard.h                                |    4 
 drivers/spi/spi-bcm2835.c                                   |   12 
 drivers/staging/mt7621-pinctrl/pinctrl-rt2880.c             |    2 
 drivers/tty/cyclades.c                                      |    6 
 drivers/tty/goldfish.c                                      |    2 
 drivers/tty/moxa.c                                          |    4 
 drivers/tty/pty.c                                           |   14 
 drivers/tty/serial/lpc32xx_hs.c                             |    2 
 drivers/tty/serial/mvebu-uart.c                             |   25 -
 drivers/tty/tty_buffer.c                                    |   66 ++-
 drivers/tty/vt/keyboard.c                                   |    6 
 drivers/tty/vt/vt.c                                         |    2 
 drivers/xen/gntdev.c                                        |    3 
 fs/dlm/lock.c                                               |    3 
 fs/io_uring.c                                               |    2 
 include/linux/bitfield.h                                    |   19 
 include/linux/tty_flip.h                                    |    4 
 include/net/bluetooth/bluetooth.h                           |   65 +++
 include/net/inet_sock.h                                     |    5 
 include/net/ip.h                                            |    6 
 include/net/tcp.h                                           |   18 
 include/net/udp.h                                           |    2 
 kernel/bpf/core.c                                           |    8 
 kernel/events/core.c                                        |   45 +-
 kernel/sched/deadline.c                                     |    5 
 kernel/watch_queue.c                                        |   53 +-
 mm/mempolicy.c                                              |    2 
 net/8021q/vlan.c                                            |    4 
 net/bluetooth/rfcomm/core.c                                 |   50 ++
 net/bluetooth/rfcomm/sock.c                                 |   46 --
 net/bluetooth/sco.c                                         |   30 -
 net/core/dev.c                                              |  233 +++++-------
 net/core/filter.c                                           |    4 
 net/core/rtnetlink.c                                        |   23 -
 net/core/secure_seq.c                                       |    4 
 net/ipv4/af_inet.c                                          |    4 
 net/ipv4/fib_semantics.c                                    |    2 
 net/ipv4/icmp.c                                             |    2 
 net/ipv4/igmp.c                                             |   25 -
 net/ipv4/inet_connection_sock.c                             |    2 
 net/ipv4/ip_forward.c                                       |    2 
 net/ipv4/ip_sockglue.c                                      |    6 
 net/ipv4/route.c                                            |    2 
 net/ipv4/syncookies.c                                       |    9 
 net/ipv4/sysctl_net_ipv4.c                                  |    6 
 net/ipv4/tcp.c                                              |   10 
 net/ipv4/tcp_fastopen.c                                     |    9 
 net/ipv4/tcp_input.c                                        |   51 +-
 net/ipv4/tcp_ipv4.c                                         |    2 
 net/ipv4/tcp_metrics.c                                      |    3 
 net/ipv4/tcp_minisocks.c                                    |    2 
 net/ipv4/tcp_output.c                                       |   29 -
 net/ipv4/tcp_recovery.c                                     |    6 
 net/ipv4/tcp_timer.c                                        |   20 -
 net/ipv6/af_inet6.c                                         |    2 
 net/ipv6/syncookies.c                                       |    3 
 net/sctp/protocol.c                                         |    2 
 net/smc/smc_llc.c                                           |    2 
 net/tls/tls_device.c                                        |    8 
 net/xfrm/xfrm_policy.c                                      |    5 
 net/xfrm/xfrm_state.c                                       |    2 
 security/integrity/ima/ima_policy.c                         |    4 
 sound/core/memalloc.c                                       |    1 
 virt/kvm/kvm_main.c                                         |    5 
 99 files changed, 1009 insertions(+), 552 deletions(-)

Alex Deucher (1):
      drm/amdgpu/display: add quirk handling for stutter mode

Alexander Aring (1):
      dlm: fix pending remove if msg allocation fails

Alexey Kardashevskiy (1):
      KVM: Don't null dereference ops->destroy

Ben Dooks (1):
      riscv: add as-options for modules with assembly compontents

Biao Huang (1):
      net: stmmac: fix unbalanced ptp clock issue in suspend/resume flow

Dawid Lukwinski (1):
      i40e: Fix erroneous adapter reinitialization during recovery process

Demi Marie Obenour (1):
      xen/gntdev: Ignore failure to unmap INVALID_GRANT_HANDLE

Eric Dumazet (1):
      bpf: Make sure mac_header was set before using it

Eric Snowberg (1):
      lockdown: Fix kexec lockdown bypass with ima policy

Fabien Dessenne (1):
      pinctrl: stm32: fix optional IRQ support to gpios

Greg Kroah-Hartman (2):
      Revert "m68knommu: only set CONFIG_ISA_DMA_API for ColdFire sub-arch"
      Linux 5.10.134

Haibo Chen (3):
      gpio: pca953x: only use single read/write for No AI mode
      gpio: pca953x: use the correct range when do regmap sync
      gpio: pca953x: use the correct register address when regcache sync during init

Hangyu Hua (1):
      xfrm: xfrm_policy: fix a possible double xfrm_pols_put() in xfrm_bundle_lookup()

Hristo Venev (1):
      be2net: Fix buffer overflow in be_get_module_eeprom

Ido Schimmel (1):
      mlxsw: spectrum_router: Fix IPv4 nexthop gateway indication

Jakub Kicinski (7):
      docs: net: explain struct net_device lifetime
      net: make free_netdev() more lenient with unregistering devices
      net: make sure devices go through netdev_wait_all_refs
      net: move net_set_todo inside rollback_registered()
      net: inline rollback_registered()
      net: move rollback_registered_many()
      net: inline rollback_registered_many()

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

Jose Alonso (1):
      net: usb: ax88179_178a needs FLAG_SEND_ZLP

Junxiao Chang (1):
      net: stmmac: fix dma queue left shift overflow issue

Juri Lelli (1):
      sched/deadline: Fix BUG_ON condition for deboosted tasks

Kees Cook (1):
      x86/alternative: Report missing return thunk details

Kuniyuki Iwashima (37):
      ip: Fix data-races around sysctl_ip_no_pmtu_disc.
      ip: Fix data-races around sysctl_ip_fwd_use_pmtu.
      ip: Fix data-races around sysctl_ip_fwd_update_priority.
      ip: Fix data-races around sysctl_ip_nonlocal_bind.
      ip: Fix a data-race around sysctl_ip_autobind_reuse.
      ip: Fix a data-race around sysctl_fwmark_reflect.
      tcp/dccp: Fix a data-race around sysctl_tcp_fwmark_accept.
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
      tcp: Fix data-races around sysctl_tcp_syncookies.
      tcp: Fix data-races around sysctl_tcp_reordering.
      tcp: Fix data-races around some timeout sysctl knobs.
      tcp: Fix a data-race around sysctl_tcp_notsent_lowat.
      tcp: Fix a data-race around sysctl_tcp_tw_reuse.
      tcp: Fix data-races around sysctl_max_syn_backlog.
      tcp: Fix data-races around sysctl_tcp_fastopen.
      tcp: Fix data-races around sysctl_tcp_fastopen_blackhole_timeout.
      ipv4: Fix a data-race around sysctl_fib_multipath_use_neigh.
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
      tcp: Fix data-races around sysctl_tcp_max_reordering.

Lee Jones (1):
      io_uring: Use original task for req identity in io_identity_cow()

Lennert Buytenhek (1):
      igc: Reinstate IGC_REMOVED logic and implement it properly

Liang He (1):
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

Miaoqian Lin (1):
      power/reset: arm-versatile: Fix refcount leak in versatile_reboot_probe

Pali Rohár (1):
      serial: mvebu-uart: correctly report configured baudrate value

Pawan Gupta (1):
      x86/bugs: Warn when "ibrs" mitigation is selected on Enhanced IBRS parts

Peter Zijlstra (3):
      perf/core: Fix data race between perf_event_set_output() and perf_mmap_close()
      bitfield.h: Fix "type of reg too small for mask" test
      x86/amd: Use IBPB for firmware calls

Piotr Skajewski (1):
      ixgbe: Add locking to prevent panic when setting sriov_numvfs to zero

Przemyslaw Patynowski (1):
      iavf: Fix handling of dummy receive descriptors

Robert Hancock (1):
      i2c: cadence: Change large transfer count reset logic to be unconditional

Takashi Iwai (1):
      ALSA: memalloc: Align buffer allocations in page size

Tariq Toukan (1):
      net/tls: Fix race in TLS device down flow

Wang Cheng (1):
      mm/mempolicy: fix uninit-value in mpol_rebind_policy()

Wang ShaoBo (1):
      drm/imx/dcss: fix unused but set variable warnings

William Dean (1):
      pinctrl: ralink: Check for null return of devm_kcalloc

