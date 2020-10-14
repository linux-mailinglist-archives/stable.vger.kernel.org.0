Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0868028DE5F
	for <lists+stable@lfdr.de>; Wed, 14 Oct 2020 12:12:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729351AbgJNKM3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Oct 2020 06:12:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:33322 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729718AbgJNKM0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Oct 2020 06:12:26 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5DD0020848;
        Wed, 14 Oct 2020 10:12:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602670344;
        bh=rPzgjaUn1/Y3CPDQPYgLfx/BoHvCo/VsJjReHjO5oNI=;
        h=From:To:Cc:Subject:Date:From;
        b=0xBCa7Xm8fj9NUAu+7u7QhUTpGtP62WNpA/CB1lk/pzNso0aAD7b35W0GOiBkT2Hr
         jvm7DGUP/E2woClmD90wWEYKQah9AQxx3ovb495X/vAelsjtJxa6cg4z9lHKs36j3V
         u10nEa5umD1Jdr335pokpKryRVc5lFgcBYE8Zi0g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.4.71
Date:   Wed, 14 Oct 2020 12:12:51 +0200
Message-Id: <160267037186253@kroah.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.4.71 kernel.

All users of the 5.4 kernel series must upgrade.

The updated 5.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                                |    2 
 arch/arm64/boot/dts/altera/socfpga_stratix10_socdk.dts  |    1 
 drivers/base/dd.c                                       |    5 
 drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c                 |    1 
 drivers/gpu/drm/nouveau/nouveau_mem.c                   |    2 
 drivers/i2c/busses/i2c-i801.c                           |    1 
 drivers/i2c/busses/i2c-meson.c                          |   42 ++++--
 drivers/i2c/busses/i2c-owl.c                            |    6 
 drivers/input/misc/ati_remote2.c                        |    4 
 drivers/iommu/intel-iommu.c                             |    4 
 drivers/mmc/core/queue.c                                |    2 
 drivers/net/bonding/bond_main.c                         |    1 
 drivers/net/ethernet/cavium/octeon/octeon_mgmt.c        |    6 
 drivers/net/ethernet/intel/iavf/iavf_main.c             |   49 ++-----
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c           |  109 ++++++++++-----
 drivers/net/ethernet/mellanox/mlx5/core/en.h            |    8 +
 drivers/net/ethernet/mellanox/mlx5/core/en_fs.c         |   14 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c       |   74 ++++++++++
 drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c       |    2 
 drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_tcam.c |    3 
 drivers/net/ethernet/realtek/r8169_main.c               |    4 
 drivers/net/ethernet/renesas/ravb_main.c                |  110 ++++++++--------
 drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c    |   15 --
 drivers/net/macsec.c                                    |    4 
 drivers/net/phy/Kconfig                                 |    1 
 drivers/net/team/team.c                                 |    3 
 drivers/net/usb/ax88179_178a.c                          |    1 
 drivers/net/usb/rtl8150.c                               |   16 +-
 drivers/net/virtio_net.c                                |    8 +
 drivers/nvme/host/core.c                                |    4 
 drivers/nvme/host/tcp.c                                 |    7 -
 drivers/platform/olpc/olpc-ec.c                         |    4 
 drivers/platform/x86/Kconfig                            |    1 
 drivers/platform/x86/intel-vbtn.c                       |   64 +++++++--
 drivers/platform/x86/thinkpad_acpi.c                    |    6 
 drivers/vhost/vhost.c                                   |   12 -
 drivers/video/console/newport_con.c                     |    7 -
 drivers/video/fbdev/core/fbcon.c                        |   12 +
 drivers/video/fbdev/core/fbcon.h                        |    7 -
 drivers/video/fbdev/core/fbcon_rotate.c                 |    1 
 drivers/video/fbdev/core/tileblit.c                     |    1 
 fs/btrfs/ctree.h                                        |    2 
 fs/btrfs/extent-tree.c                                  |   41 ++++-
 fs/btrfs/file.c                                         |   23 ++-
 fs/btrfs/inode.c                                        |   44 +++++-
 fs/btrfs/send.c                                         |   19 ++
 fs/btrfs/volumes.c                                      |    8 -
 fs/cifs/smb2ops.c                                       |    2 
 fs/io_uring.c                                           |   58 +++++---
 include/asm-generic/vmlinux.lds.h                       |    2 
 include/linux/font.h                                    |   13 +
 include/linux/khugepaged.h                              |    5 
 include/linux/mlx5/driver.h                             |    2 
 include/linux/net.h                                     |   16 ++
 include/net/act_api.h                                   |    2 
 include/net/xfrm.h                                      |   16 --
 kernel/bpf/sysfs_btf.c                                  |    6 
 kernel/events/core.c                                    |    5 
 kernel/umh.c                                            |    9 +
 lib/fonts/font_10x18.c                                  |    9 -
 lib/fonts/font_6x10.c                                   |    9 -
 lib/fonts/font_6x11.c                                   |    9 -
 lib/fonts/font_7x14.c                                   |    9 -
 lib/fonts/font_8x16.c                                   |    9 -
 lib/fonts/font_8x8.c                                    |    9 -
 lib/fonts/font_acorn_8x8.c                              |    9 -
 lib/fonts/font_mini_4x6.c                               |    8 -
 lib/fonts/font_pearl_8x8.c                              |    9 -
 lib/fonts/font_sun12x22.c                               |    9 -
 lib/fonts/font_sun8x16.c                                |    7 -
 lib/fonts/font_ter16x32.c                               |    9 -
 mm/khugepaged.c                                         |   25 +++
 mm/page_alloc.c                                         |    3 
 net/core/skbuff.c                                       |    4 
 net/ipv4/tcp.c                                          |    3 
 net/ipv4/tcp_ipv4.c                                     |    6 
 net/openvswitch/conntrack.c                             |   22 +--
 net/rxrpc/conn_event.c                                  |    6 
 net/rxrpc/key.c                                         |   20 ++
 net/sched/act_api.c                                     |   52 ++++---
 net/sched/act_bpf.c                                     |    4 
 net/sched/act_connmark.c                                |    1 
 net/sched/act_csum.c                                    |    3 
 net/sched/act_ct.c                                      |    2 
 net/sched/act_ctinfo.c                                  |    3 
 net/sched/act_gact.c                                    |    2 
 net/sched/act_ife.c                                     |    3 
 net/sched/act_ipt.c                                     |    2 
 net/sched/act_mirred.c                                  |    2 
 net/sched/act_mpls.c                                    |    2 
 net/sched/act_nat.c                                     |    3 
 net/sched/act_pedit.c                                   |    2 
 net/sched/act_police.c                                  |    2 
 net/sched/act_sample.c                                  |    2 
 net/sched/act_simple.c                                  |    2 
 net/sched/act_skbedit.c                                 |    2 
 net/sched/act_skbmod.c                                  |    2 
 net/sched/act_tunnel_key.c                              |    3 
 net/sched/act_vlan.c                                    |    2 
 net/sctp/auth.c                                         |    1 
 net/tls/tls_sw.c                                        |    9 +
 net/wireless/nl80211.c                                  |    3 
 net/xfrm/xfrm_interface.c                               |    2 
 net/xfrm/xfrm_state.c                                   |   42 +++++-
 tools/perf/builtin-top.c                                |    4 
 tools/perf/tests/topology.c                             |   12 -
 106 files changed, 812 insertions(+), 448 deletions(-)

Aaron Ma (1):
      platform/x86: thinkpad_acpi: re-initialize ACPI buffer size when reuse

Anant Thazhemadam (3):
      net: wireless: nl80211: fix out-of-bounds access in nl80211_del_key()
      net: team: fix memory leak in __team_options_register
      net: usb: rtl8150: set random MAC address when set_ethernet_addr() fails

Antony Antony (4):
      xfrm: clone XFRMA_SET_MARK in xfrm_do_migrate
      xfrm: clone XFRMA_REPLAY_ESN_VAL in xfrm_do_migrate
      xfrm: clone XFRMA_SEC_CTX in xfrm_do_migrate
      xfrm: clone whole liftime_cur structure in xfrm_do_migrate

Aya Levin (4):
      net/mlx5e: Add resiliency in Striding RQ mode for packets larger than MTU
      net/mlx5e: Fix VLAN cleanup flow
      net/mlx5e: Fix VLAN create flow
      net/mlx5e: Fix driver's declaration to support GRE offload

Chaitanya Kulkarni (1):
      nvme-core: put ctrl ref when module ref get fail

Coly Li (4):
      net: introduce helper sendpage_ok() in include/linux/net.h
      tcp: use sendpage_ok() to detect misused .sendpage
      nvme-tcp: check page by sendpage_ok() before calling kernel_sendpage()
      mmc: core: don't set limits.discard_granularity as 0

Cong Wang (2):
      net_sched: defer tcf_idr_insert() in tcf_action_init_1()
      net_sched: commit action insertions together

Cristian Ciocaltea (1):
      i2c: owl: Clear NACK and BUS error bits

David Howells (4):
      rxrpc: Downgrade the BUG() for unsupported token type in rxrpc_read()
      rxrpc: Fix some missing _bh annotations on locking conn->state_lock
      rxrpc: The server keyring isn't network-namespaced
      rxrpc: Fix server keyring leak

Dinghao Liu (1):
      Platform: OLPC: Fix memleak in olpc_ec_probe

Dinh Nguyen (1):
      arm64: dts: stratix10: add status to qspi dts node

Dumitru Ceara (1):
      openvswitch: handle DNAT tuple collision

Eran Ben Elisha (1):
      net/mlx5: Avoid possible free of command entry while timeout comp handler

Eric Dumazet (5):
      macsec: avoid use-after-free in macsec_handle_frame()
      sctp: fix sctp_auth_init_hmacs() error path
      team: set dev->needed_headroom in team_setup_by_port()
      bonding: set dev->needed_headroom in bond_setup_by_slave()
      tcp: fix receive window update in tcp_add_backlog()

Filipe Manana (3):
      Btrfs: send, allow clone operations within the same file
      Btrfs: send, fix emission of invalid clone operations within the same file
      btrfs: fix RWF_NOWAIT write not failling when we need to cow

Geert Uytterhoeven (1):
      Revert "ravb: Fixed to be able to unload modules"

Greg Kroah-Hartman (1):
      Linux 5.4.71

Greg Kurz (2):
      vhost: Don't call access_ok() when using IOTLB
      vhost: Use vhost_get_used_size() in vhost_vring_set_addr()

Guillaume Nault (1):
      net/core: check length before updating Ethertype in skb_mpls_{push,pop}

Hans de Goede (2):
      platform/x86: intel-vbtn: Fix SW_TABLET_MODE always reporting 1 on the HP Pavilion 11 x360
      platform/x86: intel-vbtn: Switch to an allow-list for SW_TABLET_MODE reporting

Heiner Kallweit (1):
      r8169: fix RTL8168f/RTL8411 EPHY config

Herbert Xu (1):
      xfrm: Use correct address family in xfrm_state_find

Hugh Dickins (1):
      mm/khugepaged: fix filemap page_to_pgoff(page) != offset

Ido Schimmel (1):
      mlxsw: spectrum_acl: Fix mlxsw_sp_acl_tcam_group_add()'s error path

Ivan Khoronzhuk (1):
      net: ethernet: cavium: octeon_mgmt: use phy_start and phy_stop

Jean Delvare (1):
      i2c: i801: Exclude device from suspend direct complete optimization

Jerome Brunet (1):
      i2c: meson: fix clock setting overwrite

Kajol Jain (1):
      perf: Fix task_function_call() error handling

Karol Herbst (1):
      drm/nouveau/mem: guard against NULL pointer access in mem_del

Linus Torvalds (1):
      usermodehelper: reset umask to default before executing user process

Lu Baolu (1):
      iommu/vt-d: Fix lockdep splat in iommu_flush_dev_iotlb()

Maor Gottlieb (1):
      net/mlx5: Fix request_irqs error flow

Marc Dionne (1):
      rxrpc: Fix rxkad token xdr encoding

Muchun Song (3):
      io_uring: Fix missing smp_mb() in io_cancel_async_work()
      io_uring: Fix remove irrelevant req from the task_list
      io_uring: Fix double list add in io_queue_async_work()

Necip Fazil Yildiran (1):
      platform/x86: fix kconfig dependency warning for FUJITSU_LAPTOP

Nicolas Belin (1):
      i2c: meson: fixup rate calculation with filter delay

Peilin Ye (3):
      fbdev, newport_con: Move FONT_EXTRA_WORDS macros into linux/font.h
      Fonts: Support FONT_EXTRA_WORDS macros for built-in fonts
      fbcon: Fix global-out-of-bounds read in fbcon_get_font()

Philip Yang (1):
      drm/amdgpu: prevent double kfree ttm->sg

Qu Wenruo (3):
      btrfs: volumes: Use more straightforward way to calculate map length
      btrfs: Ensure we trim ranges across block group boundary
      btrfs: allow btrfs_truncate_block() to fallback to nocow for data space reservation

Randy Dunlap (1):
      mdio: fix mdio-thunder.c dependency & build error

Rohit Maheshwari (1):
      net/tls: race causes kernel panic

Sabrina Dubroca (1):
      xfrmi: drop ignore_df check before updating pmtu

Sylwester Dziedziuch (1):
      iavf: Fix incorrect adapter get in iavf_resume

Tetsuo Handa (1):
      driver core: Fix probe_count imbalance in really_probe()

Tom Rix (1):
      platform/x86: thinkpad_acpi: initialize tp_nvram_state variable

Tommi Rantala (2):
      perf test session topology: Fix data path
      perf top: Fix stdio interface input handling with glibc 2.28+

Tonghao Zhang (1):
      virtio-net: don't disable guest csum when disable LRO

Tony Ambardar (2):
      bpf: Fix sysfs export of empty BTF section
      bpf: Prevent .BTF section elimination

Vaibhav Gupta (1):
      iavf: use generic power management

Vijay Balakrishna (1):
      mm: khugepaged: recalculate min_free_kbytes after memory hotplug as expected by khugepaged

Vladimir Zapolskiy (1):
      cifs: Fix incomplete memory allocation on setxattr path

Voon Weifeng (1):
      net: stmmac: removed enabling eee in EEE set callback

Wilken Gottwalt (1):
      net: usb: ax88179_178a: fix missing stop entry in driver_info

Xiongfeng Wang (1):
      Input: ati_remote2 - add missing newlines when printing module parameters

Yinyin Zhu (1):
      io_uring: Fix resource leaking when kill the process

