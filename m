Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA2D66EF471
	for <lists+stable@lfdr.de>; Wed, 26 Apr 2023 14:40:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240953AbjDZMju (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Apr 2023 08:39:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240948AbjDZMjq (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Apr 2023 08:39:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 934F65FCC;
        Wed, 26 Apr 2023 05:39:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1D7E76362A;
        Wed, 26 Apr 2023 12:39:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 263C6C433EF;
        Wed, 26 Apr 2023 12:39:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1682512776;
        bh=PPVu80i/ogbe68BGFo1gtzzL/T/vQ7L794XU/VY3Qrk=;
        h=From:To:Cc:Subject:Date:From;
        b=U0iG0MC7r6uLyuOOjYnbaZKBoegBphjqMADEuRSrAovhKbFEOYNKxs42M3mBIiFe6
         amfd/RiFbFN3SYRbtw/Abv9w3eaSeJadJt6kGpl7eRN7OyQzr4feSXn8KiIOWURF+j
         /tyuqzCO0wDmAetgGfphM7mRnsFQaUSq/0bami20=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.4.242
Date:   Wed, 26 Apr 2023 14:39:22 +0200
Message-Id: <2023042622-dictator-pony-1616@gregkh>
X-Mailer: git-send-email 2.40.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.4.242 kernel.

All users of the 5.4 kernel series must upgrade.

The updated 5.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                                    |    2 
 arch/arm/boot/dts/rk3288.dtsi                               |    2 
 arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi           |    3 
 arch/mips/kernel/vmlinux.lds.S                              |    2 
 arch/s390/kernel/ptrace.c                                   |    8 -
 arch/x86/purgatory/Makefile                                 |    5 -
 drivers/iio/adc/at91-sama5d2_adc.c                          |    2 
 drivers/iio/light/tsl2772.c                                 |    1 
 drivers/input/serio/i8042-x86ia64io.h                       |    8 +
 drivers/memstick/core/memstick.c                            |    5 -
 drivers/mmc/host/sdhci_am654.c                              |    2 
 drivers/net/dsa/b53/b53_mmap.c                              |   14 +++
 drivers/net/ethernet/intel/e1000e/netdev.c                  |   51 ++++++------
 drivers/net/ethernet/intel/i40e/i40e_main.c                 |    9 +-
 drivers/net/ethernet/mellanox/mlxfw/mlxfw_mfa2_tlv_multi.c  |    2 
 drivers/net/virtio_net.c                                    |    8 +
 drivers/net/xen-netback/netback.c                           |    6 -
 drivers/nvme/host/tcp.c                                     |   46 ++++++----
 drivers/pwm/pwm-meson.c                                     |    7 +
 drivers/regulator/fan53555.c                                |   11 +-
 drivers/scsi/megaraid/megaraid_sas_base.c                   |    2 
 drivers/scsi/scsi.c                                         |   11 ++
 fs/ext4/inline.c                                            |   11 +-
 fs/ext4/xattr.c                                             |   26 ------
 fs/ext4/xattr.h                                             |    6 -
 fs/nilfs2/segment.c                                         |   20 ++++
 fs/xfs/libxfs/xfs_attr_leaf.c                               |    8 +
 include/linux/skbuff.h                                      |    5 -
 include/net/ipv6.h                                          |    2 
 include/net/udp.h                                           |    2 
 include/net/udplite.h                                       |    8 -
 include/trace/events/f2fs.h                                 |    2 
 kernel/bpf/verifier.c                                       |   15 +++
 net/bridge/br_netfilter_hooks.c                             |   17 ++--
 net/dccp/dccp.h                                             |    1 
 net/dccp/ipv6.c                                             |   15 +--
 net/dccp/proto.c                                            |    8 +
 net/ipv4/udp.c                                              |    9 +-
 net/ipv4/udplite.c                                          |    8 +
 net/ipv6/af_inet6.c                                         |   15 +++
 net/ipv6/ipv6_sockglue.c                                    |   20 +---
 net/ipv6/ping.c                                             |    6 -
 net/ipv6/raw.c                                              |    2 
 net/ipv6/tcp_ipv6.c                                         |    8 -
 net/ipv6/udp.c                                              |   17 +++-
 net/ipv6/udp_impl.h                                         |    1 
 net/ipv6/udplite.c                                          |    9 +-
 net/l2tp/l2tp_ip6.c                                         |    2 
 net/sched/sch_qfq.c                                         |   13 +--
 net/sctp/socket.c                                           |   29 ++++--
 scripts/asn1_compiler.c                                     |    2 
 tools/testing/selftests/sigaltstack/current_stack_pointer.h |   23 +++++
 tools/testing/selftests/sigaltstack/sas.c                   |    7 -
 53 files changed, 328 insertions(+), 196 deletions(-)

Aleksandr Loktionov (2):
      i40e: fix accessing vsi->active_filters without holding lock
      i40e: fix i40e_setup_misc_vector() error handling

Baokun Li (1):
      ext4: fix use-after-free in ext4_xattr_set_entry

Bhavya Kapoor (1):
      mmc: sdhci_am654: Set HIGH_SPEED_ENA for SDR12 and SDR25

Brian Masney (1):
      iio: light: tsl2772: fix reading proximity-diodes from device tree

Cristian Ciocaltea (1):
      regulator: fan53555: Explicitly include bits header

Damien Le Moal (1):
      scsi: core: Improve scsi_vpd_inquiry() checks

Dan Carpenter (1):
      iio: adc: at91-sama5d2_adc: fix an error code in at91_adc_allocate_trigger()

Daniel Borkmann (1):
      bpf: Fix incorrect verifier pruning due to missing register precision taints

Douglas Raillard (1):
      f2fs: Fix f2fs_truncate_partial_nodes ftrace event

Ekaterina Orlova (1):
      ASN.1: Fix check for strdup() success

Florian Westphal (2):
      netfilter: br_netfilter: fix recent physdev match breakage
      netfilter: nf_tables: fix ifdef to also consider nf_tables=m

Gao Xiang (1):
      xfs: fix forkoff miscalculation related to XFS_LITINO(mp)

Greg Kroah-Hartman (2):
      memstick: fix memory leak if card device is never registered
      Linux 5.4.242

Gwangun Jung (1):
      net: sched: sch_qfq: prevent slab-out-of-bounds in qfq_activate_agg

Heiko Carstens (1):
      s390/ptrace: fix PTRACE_GET_LAST_BREAK error handling

Jianqun Xu (1):
      ARM: dts: rockchip: fix a typo error for rk3288 spdif node

Jiaxun Yang (1):
      MIPS: Define RUNTIME_DISCARD_EXIT in LD script

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

Marc Gonzalez (1):
      arm64: dts: meson-g12-common: specify full DMC range

Nick Desaulniers (1):
      selftests: sigaltstack: fix -Wuninitialized

Nikita Zhandarovich (1):
      mlxfw: fix null-ptr-deref in mlxfw_mfa2_tlv_next()

Pingfan Liu (1):
      x86/purgatory: Don't generate debug info for purgatory.ro

Ritesh Harjani (1):
      ext4: remove duplicate definition of ext4_xattr_ibody_inline_set()

Ryusuke Konishi (1):
      nilfs2: initialize unused bytes in segment summary blocks

Sagi Grimberg (1):
      nvme-tcp: fix a possible UAF when failing to allocate an io queue

Sebastian Basierski (1):
      e1000e: Disable TSO on i219-LM card to increase speed

Tomas Henzl (1):
      scsi: megaraid_sas: Fix fw_crash_buffer_show()

Tudor Ambarus (1):
      Revert "ext4: fix use-after-free in ext4_xattr_set_entry"

Uwe Kleine-König (1):
      pwm: meson: Explicitly set .polarity in .get_state()

Xuan Zhuo (1):
      virtio_net: bugfix overflow inside xdp_linearize_page()

Álvaro Fernández Rojas (1):
      net: dsa: b53: mmap: add phy ops

