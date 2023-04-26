Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B861D6EF477
	for <lists+stable@lfdr.de>; Wed, 26 Apr 2023 14:40:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240751AbjDZMk0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Apr 2023 08:40:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240993AbjDZMkP (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Apr 2023 08:40:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71AD16591;
        Wed, 26 Apr 2023 05:39:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EBF2063635;
        Wed, 26 Apr 2023 12:39:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00002C4339B;
        Wed, 26 Apr 2023 12:39:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1682512787;
        bh=nUQn8kpTq9zcbQuX9CgRxjxG6mAqTSUUaKYOq75shWg=;
        h=From:To:Cc:Subject:Date:From;
        b=NVjmUu/t+GGyX0uafW/je4wMNNG8TqKidHqlyJCbcTzACR4E3h1AcmjrXWdJtvfa3
         tuC59gPR912FBi54xFp4c/SstzDWvNN9ZShDDQ0su7GV8PiR2NdT8Vwew3GoFB010P
         6ypJEjS8WM52BakoK59G2gRjQgLNZoGmIDDn4U6A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.15.109
Date:   Wed, 26 Apr 2023 14:39:36 +0200
Message-Id: <2023042636-deserving-seltzer-f959@gregkh>
X-Mailer: git-send-email 2.40.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.15.109 kernel.

All users of the 5.15 kernel series must upgrade.

The updated 5.15.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.15.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/kernel-hacking/locking.rst                    |    2 
 Documentation/translations/it_IT/kernel-hacking/locking.rst |    2 
 Makefile                                                    |    2 
 arch/arm/boot/dts/rk3288.dtsi                               |    2 
 arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi           |    3 
 arch/arm64/boot/dts/freescale/imx8mm-evk.dtsi               |    2 
 arch/arm64/boot/dts/qcom/ipq8074-hk01.dts                   |    4 
 arch/mips/kernel/vmlinux.lds.S                              |    2 
 arch/s390/kernel/ptrace.c                                   |    8 
 arch/x86/purgatory/Makefile                                 |    3 
 drivers/counter/104-quad-8.c                                |   29 --
 drivers/gpu/drm/i915/display/intel_dp_aux.c                 |    2 
 drivers/iio/adc/at91-sama5d2_adc.c                          |    2 
 drivers/iio/light/tsl2772.c                                 |    1 
 drivers/input/serio/i8042-x86ia64io.h                       |    8 
 drivers/memstick/core/memstick.c                            |    5 
 drivers/mmc/host/sdhci_am654.c                              |    2 
 drivers/net/bonding/bond_main.c                             |    7 
 drivers/net/dsa/b53/b53_mmap.c                              |   14 +
 drivers/net/ethernet/broadcom/bnxt/bnxt.c                   |    2 
 drivers/net/ethernet/intel/e1000e/netdev.c                  |   51 ++--
 drivers/net/ethernet/intel/i40e/i40e_main.c                 |    9 
 drivers/net/ethernet/mellanox/mlxfw/mlxfw_mfa2_tlv_multi.c  |    2 
 drivers/net/ethernet/mellanox/mlxsw/pci_hw.h                |    2 
 drivers/net/ethernet/sfc/ef100_netdev.c                     |    6 
 drivers/net/ethernet/sfc/efx.c                              |   30 +-
 drivers/net/ethernet/sfc/efx_common.c                       |   12 -
 drivers/net/ethernet/sfc/efx_common.h                       |    6 
 drivers/net/ethernet/sfc/ethtool_common.c                   |    2 
 drivers/net/ethernet/sfc/net_driver.h                       |   50 ++++
 drivers/net/virtio_net.c                                    |    8 
 drivers/net/xen-netback/netback.c                           |    6 
 drivers/nvme/host/tcp.c                                     |   46 ++--
 drivers/platform/x86/gigabyte-wmi.c                         |    2 
 drivers/pwm/pwm-hibvt.c                                     |    1 
 drivers/pwm/pwm-iqs620a.c                                   |    1 
 drivers/pwm/pwm-meson.c                                     |    7 
 drivers/regulator/fan53555.c                                |   13 -
 drivers/scsi/megaraid/megaraid_sas_base.c                   |    2 
 drivers/scsi/scsi.c                                         |   11 -
 drivers/soc/sifive/sifive_l2_cache.c                        |   27 +-
 drivers/spi/spi-rockchip-sfc.c                              |    2 
 fs/fuse/dir.c                                               |    9 
 fs/fuse/file.c                                              |   31 +-
 fs/nilfs2/segment.c                                         |   20 +
 include/linux/skbuff.h                                      |    5 
 include/net/ipv6.h                                          |    2 
 include/net/netfilter/nf_tables.h                           |    4 
 include/net/udp.h                                           |    2 
 include/net/udplite.h                                       |    8 
 include/trace/events/f2fs.h                                 |    2 
 kernel/bpf/verifier.c                                       |   15 +
 kernel/locking/rtmutex.c                                    |   55 ++++-
 kernel/locking/rtmutex_api.c                                |    6 
 kernel/sched/core.c                                         |   10 
 kernel/sched/fair.c                                         |  128 ++++++++++--
 kernel/sched/sched.h                                        |   61 +++++
 kernel/sys.c                                                |   69 +++---
 mm/khugepaged.c                                             |    4 
 mm/page_alloc.c                                             |   19 +
 net/bridge/br_netfilter_hooks.c                             |   17 +
 net/dccp/dccp.h                                             |    1 
 net/dccp/ipv6.c                                             |   15 -
 net/dccp/proto.c                                            |    8 
 net/ipv4/udp.c                                              |    9 
 net/ipv4/udplite.c                                          |    8 
 net/ipv6/af_inet6.c                                         |   15 +
 net/ipv6/ipv6_sockglue.c                                    |   20 -
 net/ipv6/ping.c                                             |    6 
 net/ipv6/raw.c                                              |    2 
 net/ipv6/rpl.c                                              |    3 
 net/ipv6/tcp_ipv6.c                                         |    8 
 net/ipv6/udp.c                                              |   17 +
 net/ipv6/udp_impl.h                                         |    1 
 net/ipv6/udplite.c                                          |    9 
 net/l2tp/l2tp_ip6.c                                         |    2 
 net/mptcp/protocol.c                                        |    7 
 net/netfilter/nf_tables_api.c                               |   67 +++++-
 net/netfilter/nft_lookup.c                                  |   36 ---
 net/sched/sch_qfq.c                                         |   13 -
 net/sctp/socket.c                                           |   29 +-
 scripts/asn1_compiler.c                                     |    2 
 sound/soc/fsl/fsl_asrc_dma.c                                |   11 -
 tools/testing/selftests/sigaltstack/current_stack_pointer.h |   23 ++
 tools/testing/selftests/sigaltstack/sas.c                   |    7 
 85 files changed, 819 insertions(+), 365 deletions(-)

Aleksandr Loktionov (2):
      i40e: fix accessing vsi->active_filters without holding lock
      i40e: fix i40e_setup_misc_vector() error handling

Alexander Aring (1):
      net: rpl: fix rpl header size calculation

Alyssa Ross (1):
      purgatory: fix disabling debug info

Bhavya Kapoor (1):
      mmc: sdhci_am654: Set HIGH_SPEED_ENA for SDR12 and SDR25

Brian Masney (1):
      iio: light: tsl2772: fix reading proximity-diodes from device tree

Cristian Ciocaltea (2):
      regulator: fan53555: Explicitly include bits header
      regulator: fan53555: Fix wrong TCS_SLEW_MASK

Damien Le Moal (1):
      scsi: core: Improve scsi_vpd_inquiry() checks

Dan Carpenter (1):
      iio: adc: at91-sama5d2_adc: fix an error code in at91_adc_allocate_trigger()

Daniel Borkmann (1):
      bpf: Fix incorrect verifier pruning due to missing register precision taints

Ding Hui (1):
      sfc: Fix use-after-free due to selftest_work

Dmitry Baryshkov (1):
      arm64: dts: qcom: ipq8074-hk01: enable QMP device, not the PHY node

Douglas Raillard (1):
      f2fs: Fix f2fs_truncate_partial_nodes ftrace event

Ekaterina Orlova (1):
      ASN.1: Fix check for strdup() success

Florian Westphal (2):
      netfilter: br_netfilter: fix recent physdev match breakage
      netfilter: nf_tables: fix ifdef to also consider nf_tables=m

Frank Crawford (1):
      platform/x86 (gigabyte-wmi): Add support for A320M-S2H V2

Greg Kroah-Hartman (2):
      memstick: fix memory leak if card device is never registered
      Linux 5.15.109

Gwangun Jung (1):
      net: sched: sch_qfq: prevent slab-out-of-bounds in qfq_activate_agg

Hans de Goede (1):
      platform/x86: gigabyte-wmi: add support for X570S AORUS ELITE

Heiko Carstens (1):
      s390/ptrace: fix PTRACE_GET_LAST_BREAK error handling

Ido Schimmel (2):
      bonding: Fix memory leak when changing bond type to Ethernet
      mlxsw: pci: Fix possible crash during initialization

Jiachen Zhang (1):
      fuse: always revalidate rename target dentry

Jianqun Xu (1):
      ARM: dts: rockchip: fix a typo error for rk3288 spdif node

Jiaxun Yang (1):
      MIPS: Define RUNTIME_DISCARD_EXIT in LD script

Jonathan Cooper (1):
      sfc: Split STATE_READY in to STATE_NET_DOWN and STATE_NET_UP.

Jonathan Denose (1):
      Input: i8042 - add quirk for Fujitsu Lifebook A574/H

Juergen Gross (1):
      xen/netback: use same error messages for same errors

Kuniyuki Iwashima (5):
      udp: Call inet6_destroy_sock() in setsockopt(IPV6_ADDRFORM).
      tcp/udp: Call inet6_destroy_sock() in IPv6 sk->sk_destruct().
      inet6: Remove inet6_destroy_sock() in sk->sk_prot->destroy().
      dccp: Call inet6_destroy_sock() via sk->sk_destruct().
      sctp: Call inet6_destroy_sock() via sk->sk_destruct().

Li Lanzhe (1):
      spi: spi-rockchip: Fix missing unwind goto in rockchip_sfc_probe()

Marc Gonzalez (1):
      arm64: dts: meson-g12-common: specify full DMC range

Mel Gorman (2):
      rtmutex: Add acquire semantics for rtmutex lock acquisition slow path
      mm: page_alloc: skip regions with hugetlbfs pages when allocating 1G pages

Michael Chan (1):
      bnxt_en: Do not initialize PTP on older P3/P4 chips

Miklos Szeredi (2):
      fuse: fix attr version comparison in fuse_read_update_size()
      fuse: fix deadlock between atomic O_TRUNC and page invalidation

Nick Desaulniers (1):
      selftests: sigaltstack: fix -Wuninitialized

Nikita Zhandarovich (2):
      mlxfw: fix null-ptr-deref in mlxfw_mfa2_tlv_next()
      ASoC: fsl_asrc_dma: fix potential null-ptr-deref

Ondrej Mosnacek (1):
      kernel/sys.c: fix and improve control flow in __sys_setres[ug]id()

Pablo Neira Ayuso (2):
      netfilter: nf_tables: validate catch-all set elements
      netfilter: nf_tables: tighten netlink attribute requirements for catch-all elements

Peng Fan (1):
      arm64: dts: imx8mm-evk: correct pmic clock source

Peter Xu (1):
      mm/khugepaged: check again on anon uffd-wp during isolation

Qais Yousef (7):
      sched/uclamp: Fix fits_capacity() check in feec()
      sched/uclamp: Make cpu_overutilized() use util_fits_cpu()
      sched/uclamp: Cater for uclamp in find_energy_efficient_cpu()'s early exit condition
      sched/fair: Detect capacity inversion
      sched/fair: Consider capacity inversion in util_fits_cpu()
      sched/uclamp: Fix a uninitialized variable warnings
      sched/fair: Fixes for capacity inversion detection

Ryusuke Konishi (1):
      nilfs2: initialize unused bytes in segment summary blocks

Sagi Grimberg (1):
      nvme-tcp: fix a possible UAF when failing to allocate an io queue

Salvatore Bonaccorso (1):
      docs: futex: Fix kernel-doc references after code split-up preparation

Sebastian Basierski (1):
      e1000e: Disable TSO on i219-LM card to increase speed

Tetsuo Handa (1):
      mm/page_alloc: fix potential deadlock on zonelist_update_seq seqlock

Tomas Henzl (1):
      scsi: megaraid_sas: Fix fw_crash_buffer_show()

Uwe Kleine-König (3):
      pwm: meson: Explicitly set .polarity in .get_state()
      pwm: iqs620a: Explicitly set .polarity in .get_state()
      pwm: hibvt: Explicitly set .polarity in .get_state()

Ville Syrjälä (1):
      drm/i915: Fix fast wake AUX sync len

William Breathitt Gray (1):
      counter: 104-quad-8: Fix race condition between FLAG and CNTR reads

Xuan Zhuo (1):
      virtio_net: bugfix overflow inside xdp_linearize_page()

Yang Yingliang (3):
      soc: sifive: l2_cache: fix missing iounmap() in error path in sifive_l2_init()
      soc: sifive: l2_cache: fix missing free_irq() in error path in sifive_l2_init()
      soc: sifive: l2_cache: fix missing of_node_put() in sifive_l2_init()

Álvaro Fernández Rojas (1):
      net: dsa: b53: mmap: add phy ops

