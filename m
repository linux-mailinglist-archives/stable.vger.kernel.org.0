Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7630528DE5D
	for <lists+stable@lfdr.de>; Wed, 14 Oct 2020 12:12:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729804AbgJNKM3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Oct 2020 06:12:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:33356 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729720AbgJNKM3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Oct 2020 06:12:29 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C939121527;
        Wed, 14 Oct 2020 10:12:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602670347;
        bh=25EnkoiWgWdijx6Wpz9oT1PtWwcogpRfdCFeGYczmdw=;
        h=From:To:Cc:Subject:Date:From;
        b=H8oU9g+ZYIlSJ/aFySqzJS8c5pNItRplAqKfVIzd6q2BlEJSAFLBgCEn6/RCt++LF
         DZvthrR7oAgMFmZG/62/YeOtdVX1dnlpZuvbn8JEdbrvJe32f127mafnDH5mhLh3LC
         8S6W7V0NIjRuZR8k/5CEWvO4fg0VwbA1+60zqBno=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.8.15
Date:   Wed, 14 Oct 2020 12:12:56 +0200
Message-Id: <1602670376150118@kroah.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.8.15 kernel.

All users of the 5.8 kernel series must upgrade.

The updated 5.8.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.8.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                                |    2 
 arch/arm64/crypto/aes-neonbs-core.S                     |    4 
 arch/riscv/mm/init.c                                    |    1 
 block/partitions/ibm.c                                  |    7 
 block/scsi_ioctl.c                                      |    1 
 drivers/gpio/gpiolib.c                                  |    2 
 drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c                 |    1 
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_hdcp.c  |    2 
 drivers/gpu/drm/amd/powerplay/hwmgr/smu10_hwmgr.c       |   10 
 drivers/gpu/drm/nouveau/nouveau_mem.c                   |    2 
 drivers/gpu/drm/nouveau/nvkm/engine/device/base.c       |    1 
 drivers/i2c/busses/i2c-meson.c                          |   52 -
 drivers/i2c/busses/i2c-owl.c                            |    6 
 drivers/input/misc/ati_remote2.c                        |    4 
 drivers/iommu/intel/iommu.c                             |    4 
 drivers/mmc/core/queue.c                                |    2 
 drivers/net/bonding/bond_main.c                         |    1 
 drivers/net/dsa/ocelot/felix_vsc9959.c                  |   35 
 drivers/net/ethernet/cavium/octeon/octeon_mgmt.c        |    6 
 drivers/net/ethernet/huawei/hinic/Kconfig               |    1 
 drivers/net/ethernet/huawei/hinic/hinic_hw_api_cmd.c    |   27 
 drivers/net/ethernet/huawei/hinic/hinic_hw_api_cmd.h    |    4 
 drivers/net/ethernet/huawei/hinic/hinic_hw_cmdq.c       |    2 
 drivers/net/ethernet/huawei/hinic/hinic_hw_cmdq.h       |    2 
 drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c        |   12 
 drivers/net/ethernet/huawei/hinic/hinic_hw_eqs.c        |   39 
 drivers/net/ethernet/huawei/hinic/hinic_hw_eqs.h        |    6 
 drivers/net/ethernet/huawei/hinic/hinic_hw_if.c         |   23 
 drivers/net/ethernet/huawei/hinic/hinic_hw_if.h         |   10 
 drivers/net/ethernet/huawei/hinic/hinic_hw_mbox.c       |    2 
 drivers/net/ethernet/huawei/hinic/hinic_hw_mgmt.c       |    1 
 drivers/net/ethernet/huawei/hinic/hinic_port.c          |   68 -
 drivers/net/ethernet/huawei/hinic/hinic_sriov.c         |   18 
 drivers/net/ethernet/intel/iavf/iavf_main.c             |   49 -
 drivers/net/ethernet/intel/ice/ice_lib.c                |   20 
 drivers/net/ethernet/intel/ice/ice_lib.h                |    6 
 drivers/net/ethernet/intel/ice/ice_main.c               |   13 
 drivers/net/ethernet/marvell/mvneta.c                   |   13 
 drivers/net/ethernet/marvell/octeontx2/af/mbox.c        |   12 
 drivers/net/ethernet/marvell/octeontx2/af/mbox.h        |    1 
 drivers/net/ethernet/marvell/octeontx2/af/rvu.h         |    3 
 drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c     |    5 
 drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c     |   26 
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c    |   16 
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c  |    1 
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c    |    4 
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c           |  181 +++-
 drivers/net/ethernet/mellanox/mlx5/core/en.h            |    8 
 drivers/net/ethernet/mellanox/mlx5/core/en/port.c       |    3 
 drivers/net/ethernet/mellanox/mlx5/core/en/rep/neigh.c  |   81 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_fs.c         |   14 
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c       |   74 +
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.h        |    6 
 drivers/net/ethernet/mellanox/mlx5/core/eq.c            |   42 +
 drivers/net/ethernet/mellanox/mlx5/core/lib/eq.h        |    2 
 drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c       |    2 
 drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_tcam.c |    3 
 drivers/net/ethernet/mscc/Makefile                      |    2 
 drivers/net/ethernet/mscc/ocelot.c                      |   43 -
 drivers/net/ethernet/mscc/ocelot_board.c                |  626 ---------------
 drivers/net/ethernet/mscc/ocelot_vsc7514.c              |  639 ++++++++++++++++
 drivers/net/ethernet/realtek/r8169_main.c               |   11 
 drivers/net/ethernet/renesas/ravb_main.c                |  110 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c       |    1 
 drivers/net/ethernet/stmicro/stmmac/stmmac.h            |    2 
 drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c    |   27 
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c       |   23 
 drivers/net/macsec.c                                    |    4 
 drivers/net/phy/Kconfig                                 |    1 
 drivers/net/phy/realtek.c                               |   31 
 drivers/net/team/team.c                                 |    3 
 drivers/net/usb/ax88179_178a.c                          |    1 
 drivers/net/usb/rtl8150.c                               |   16 
 drivers/net/virtio_net.c                                |    8 
 drivers/net/vmxnet3/vmxnet3_drv.c                       |    5 
 drivers/net/vmxnet3/vmxnet3_ethtool.c                   |   28 
 drivers/net/vmxnet3/vmxnet3_int.h                       |    4 
 drivers/nvme/host/core.c                                |    4 
 drivers/nvme/host/tcp.c                                 |    7 
 drivers/platform/olpc/olpc-ec.c                         |    4 
 drivers/platform/x86/Kconfig                            |    2 
 drivers/platform/x86/asus-nb-wmi.c                      |   32 
 drivers/platform/x86/asus-wmi.c                         |   16 
 drivers/platform/x86/asus-wmi.h                         |    1 
 drivers/platform/x86/intel-vbtn.c                       |   64 +
 drivers/platform/x86/thinkpad_acpi.c                    |    6 
 drivers/tty/vt/selection.c                              |    2 
 drivers/vhost/vdpa.c                                    |  122 +--
 drivers/vhost/vhost.c                                   |   12 
 drivers/video/console/newport_con.c                     |    7 
 drivers/video/fbdev/core/fbcon.c                        |   12 
 drivers/video/fbdev/core/fbcon.h                        |    7 
 drivers/video/fbdev/core/fbcon_rotate.c                 |    1 
 drivers/video/fbdev/core/tileblit.c                     |    1 
 fs/afs/inode.c                                          |   47 -
 fs/afs/internal.h                                       |    1 
 fs/afs/write.c                                          |   11 
 fs/btrfs/dev-replace.c                                  |    6 
 fs/btrfs/volumes.c                                      |   13 
 fs/btrfs/volumes.h                                      |    3 
 fs/cifs/smb2ops.c                                       |    2 
 fs/exfat/cache.c                                        |   11 
 fs/exfat/exfat_fs.h                                     |    3 
 fs/exfat/inode.c                                        |    2 
 fs/exfat/super.c                                        |    5 
 fs/io_uring.c                                           |   19 
 fs/pipe.c                                               |   11 
 fs/splice.c                                             |   20 
 include/asm-generic/vmlinux.lds.h                       |    2 
 include/linux/font.h                                    |   13 
 include/linux/khugepaged.h                              |    5 
 include/linux/mlx5/driver.h                             |    2 
 include/linux/net.h                                     |   16 
 include/linux/pagemap.h                                 |    3 
 include/linux/watch_queue.h                             |    6 
 include/net/act_api.h                                   |    2 
 include/net/netlink.h                                   |    3 
 include/net/xfrm.h                                      |   16 
 include/soc/mscc/ocelot.h                               |    1 
 kernel/bpf/sysfs_btf.c                                  |    6 
 kernel/bpf/verifier.c                                   |    8 
 kernel/events/core.c                                    |    5 
 kernel/umh.c                                            |    9 
 lib/fonts/font_10x18.c                                  |    9 
 lib/fonts/font_6x10.c                                   |    9 
 lib/fonts/font_6x11.c                                   |    9 
 lib/fonts/font_7x14.c                                   |    9 
 lib/fonts/font_8x16.c                                   |    9 
 lib/fonts/font_8x8.c                                    |    9 
 lib/fonts/font_acorn_8x8.c                              |    9 
 lib/fonts/font_mini_4x6.c                               |    8 
 lib/fonts/font_pearl_8x8.c                              |    9 
 lib/fonts/font_sun12x22.c                               |    9 
 lib/fonts/font_sun8x16.c                                |    7 
 lib/fonts/font_ter16x32.c                               |    9 
 mm/khugepaged.c                                         |   25 
 mm/page_alloc.c                                         |    3 
 net/bridge/br_fdb.c                                     |    2 
 net/core/skbuff.c                                       |    4 
 net/ipv4/tcp.c                                          |    3 
 net/ipv4/tcp_ipv4.c                                     |    6 
 net/netlink/genetlink.c                                 |    9 
 net/netlink/policy.c                                    |   24 
 net/openvswitch/conntrack.c                             |   22 
 net/qrtr/ns.c                                           |   34 
 net/rxrpc/conn_event.c                                  |    6 
 net/rxrpc/key.c                                         |   20 
 net/sched/act_api.c                                     |   52 -
 net/sched/act_bpf.c                                     |    4 
 net/sched/act_connmark.c                                |    1 
 net/sched/act_csum.c                                    |    3 
 net/sched/act_ct.c                                      |    2 
 net/sched/act_ctinfo.c                                  |    3 
 net/sched/act_gact.c                                    |    2 
 net/sched/act_gate.c                                    |    3 
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
 net/tls/tls_sw.c                                        |    9 
 net/wireless/nl80211.c                                  |    3 
 net/xdp/xsk.c                                           |   17 
 net/xfrm/espintcp.c                                     |    6 
 net/xfrm/xfrm_interface.c                               |    2 
 net/xfrm/xfrm_state.c                                   |   42 -
 175 files changed, 2142 insertions(+), 1379 deletions(-)

Aaron Ma (1):
      platform/x86: thinkpad_acpi: re-initialize ACPI buffer size when reuse

Alexey Kardashevskiy (1):
      tty/vt: Do not warn when huge selection requested

Anant Thazhemadam (3):
      net: wireless: nl80211: fix out-of-bounds access in nl80211_del_key()
      net: team: fix memory leak in __team_options_register
      net: usb: rtl8150: set random MAC address when set_ethernet_addr() fails

Andy Shevchenko (1):
      gpiolib: Disable compat ->read() code in UML case

Antony Antony (4):
      xfrm: clone XFRMA_SET_MARK in xfrm_do_migrate
      xfrm: clone XFRMA_REPLAY_ESN_VAL in xfrm_do_migrate
      xfrm: clone XFRMA_SEC_CTX in xfrm_do_migrate
      xfrm: clone whole liftime_cur structure in xfrm_do_migrate

Atish Patra (1):
      RISC-V: Make sure memblock reserves the memory containing DT

Aya Levin (5):
      net/mlx5e: Add resiliency in Striding RQ mode for packets larger than MTU
      net/mlx5e: Fix return status when setting unsupported FEC mode
      net/mlx5e: Fix VLAN cleanup flow
      net/mlx5e: Fix VLAN create flow
      net/mlx5e: Fix driver's declaration to support GRE offload

Chaitanya Kulkarni (1):
      nvme-core: put ctrl ref when module ref get fail

Christoph Hellwig (1):
      partitions/ibm: fix non-DASD devices

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

Daniel Borkmann (1):
      bpf: Fix scalar32_min_max_or bounds tracking

David Howells (5):
      rxrpc: Downgrade the BUG() for unsupported token type in rxrpc_read()
      rxrpc: Fix some missing _bh annotations on locking conn->state_lock
      rxrpc: The server keyring isn't network-namespaced
      rxrpc: Fix server keyring leak
      afs: Fix deadlock between writeback and truncate

Dinghao Liu (1):
      Platform: OLPC: Fix memleak in olpc_ec_probe

Dumitru Ceara (1):
      openvswitch: handle DNAT tuple collision

Eran Ben Elisha (4):
      net/mlx5: Fix a race when moving command interface to polling mode
      net/mlx5: Avoid possible free of command entry while timeout comp handler
      net/mlx5: poll cmd EQ in case of command timeout
      net/mlx5: Add retry mechanism to the command entry index allocation

Eric Dumazet (5):
      macsec: avoid use-after-free in macsec_handle_frame()
      sctp: fix sctp_auth_init_hmacs() error path
      team: set dev->needed_headroom in team_setup_by_port()
      bonding: set dev->needed_headroom in bond_setup_by_slave()
      tcp: fix receive window update in tcp_add_backlog()

Flora Cui (1):
      drm/amd/display: fix return value check for hdcp_work

Geert Uytterhoeven (1):
      Revert "ravb: Fixed to be able to unload modules"

Geetha sowjanya (1):
      octeontx2-pf: Fix TCP/UDP checksum offload for IPv6 frames

Greg Kroah-Hartman (1):
      Linux 5.8.15

Greg Kurz (2):
      vhost: Don't call access_ok() when using IOTLB
      vhost: Use vhost_get_used_size() in vhost_vring_set_addr()

Guillaume Nault (1):
      net/core: check length before updating Ethertype in skb_mpls_{push,pop}

Hans de Goede (3):
      platform/x86: intel-vbtn: Fix SW_TABLET_MODE always reporting 1 on the HP Pavilion 11 x360
      platform/x86: asus-wmi: Fix SW_TABLET_MODE always reporting 1 on many different models
      platform/x86: intel-vbtn: Switch to an allow-list for SW_TABLET_MODE reporting

Hariprasad Kelam (2):
      octeontx2-pf: Fix the device state on error
      octeontx2-pf: Fix synchnorization issue in mbox

Heiner Kallweit (2):
      r8169: consider that PHY reset may still be in progress after applying firmware
      r8169: fix RTL8168f/RTL8411 EPHY config

Herbert Xu (1):
      xfrm: Use correct address family in xfrm_state_find

Hugh Dickins (1):
      mm/khugepaged: fix filemap page_to_pgoff(page) != offset

Ido Schimmel (1):
      mlxsw: spectrum_acl: Fix mlxsw_sp_acl_tcam_group_add()'s error path

Ivan Khoronzhuk (1):
      net: ethernet: cavium: octeon_mgmt: use phy_start and phy_stop

Jacob Keller (2):
      ice: fix memory leak if register_netdev_fails
      ice: fix memory leak in ice_vsi_setup

Jens Axboe (1):
      io_uring: fix potential ABBA deadlock in ->show_fdinfo()

Jeremy Linton (1):
      crypto: arm64: Use x16 with indirect branch to bti_c

Jerome Brunet (2):
      i2c: meson: fix clock setting overwrite
      i2c: meson: keep peripheral clock enabled

Johannes Berg (1):
      netlink: fix policy dump leak

Josef Bacik (2):
      btrfs: move btrfs_scratch_superblocks into btrfs_dev_replace_finishing
      btrfs: move btrfs_rm_dev_replace_free_srcdev outside of all locks

Kajol Jain (1):
      perf: Fix task_function_call() error handling

Karol Herbst (2):
      drm/nouveau/device: return error for unknown chipsets
      drm/nouveau/mem: guard against NULL pointer access in mem_del

Linus Torvalds (2):
      usermodehelper: reset umask to default before executing user process
      splice: teach splice pipe reading about empty pipe buffers

Lu Baolu (1):
      iommu/vt-d: Fix lockdep splat in iommu_flush_dev_iotlb()

Luo bin (2):
      hinic: add log in exception handling processes
      hinic: fix wrong return value of mac-set cmd

Magnus Karlsson (1):
      xsk: Do not discard packet when NETDEV_TX_BUSY

Manivannan Sadhasivam (1):
      net: qrtr: ns: Protect radix_tree_deref_slot() using rcu read locks

Maor Gottlieb (1):
      net/mlx5: Fix request_irqs error flow

Marc Dionne (1):
      rxrpc: Fix rxkad token xdr encoding

Maxim Kochetkov (1):
      net: mscc: ocelot: extend watermark encoding function

Minchan Kim (1):
      mm: validate inode in mapping_set_error()

Namjae Jeon (1):
      exfat: fix use of uninitialized spinlock on error path

Necip Fazil Yildiran (2):
      platform/x86: fix kconfig dependency warning for LG_LAPTOP
      platform/x86: fix kconfig dependency warning for FUJITSU_LAPTOP

Nicolas Belin (1):
      i2c: meson: fixup rate calculation with filter delay

Nikolay Aleksandrov (1):
      net: bridge: fdb: don't flush ext_learn entries

Peilin Ye (4):
      fbdev, newport_con: Move FONT_EXTRA_WORDS macros into linux/font.h
      Fonts: Support FONT_EXTRA_WORDS macros for built-in fonts
      fbcon: Fix global-out-of-bounds read in fbcon_get_font()
      block/scsi-ioctl: Fix kernel-infoleak in scsi_put_cdrom_generic_arg()

Philip Yang (1):
      drm/amdgpu: prevent double kfree ttm->sg

Qian Cai (1):
      pipe: Fix memory leaks in create_pipe_files()

Randy Dunlap (2):
      mdio: fix mdio-thunder.c dependency & build error
      net: hinic: fix DEVLINK build errors

Rohit Maheshwari (1):
      net/tls: race causes kernel panic

Ronak Doshi (1):
      vmxnet3: fix cksum offload issues for non-udp tunnels

Sabrina Dubroca (2):
      xfrmi: drop ignore_df check before updating pmtu
      espintcp: restore IP CB before handing the packet to xfrm

Si-Wei Liu (2):
      vhost-vdpa: fix vhost_vdpa_map() on error condition
      vhost-vdpa: fix page pinning leakage in error path

Subbaraya Sundeep (1):
      octeontx2-af: Fix enable/disable of default NPC entries

Sudheesh Mavila (1):
      drm/amd/pm: Removed fixed clock in auto mode DPM

Sylwester Dziedziuch (1):
      iavf: Fix incorrect adapter get in iavf_resume

Tom Rix (2):
      platform/x86: thinkpad_acpi: initialize tp_nvram_state variable
      net: mvneta: fix double free of txq->buf

Tonghao Zhang (1):
      virtio-net: don't disable guest csum when disable LRO

Tony Ambardar (2):
      bpf: Fix sysfs export of empty BTF section
      bpf: Prevent .BTF section elimination

Vaibhav Gupta (1):
      iavf: use generic power management

Vijay Balakrishna (1):
      mm: khugepaged: recalculate min_free_kbytes after memory hotplug as expected by khugepaged

Vineetha G. Jaya Kumaran (1):
      net: stmmac: Modify configuration method of EEE timers

Vlad Buslov (1):
      net/mlx5e: Fix race condition on nhe->n pointer in neigh update

Vladimir Oltean (3):
      net: mscc: ocelot: rename ocelot_board.c to ocelot_vsc7514.c
      net: mscc: ocelot: split writes to pause frame enable bit and to thresholds
      net: mscc: ocelot: divide watermark value by 60 when writing to SYS_ATOP

Vladimir Zapolskiy (1):
      cifs: Fix incomplete memory allocation on setxattr path

Voon Weifeng (1):
      net: stmmac: removed enabling eee in EEE set callback

Wilken Gottwalt (1):
      net: usb: ax88179_178a: fix missing stop entry in driver_info

Willy Liu (1):
      net: phy: realtek: fix rtl8211e rx/tx delay config

Wong Vee Khee (1):
      net: stmmac: Fix clock handling on remove path

Xiaoliang Yang (1):
      net: dsa: felix: convert TAS link speed based on phylink speed

Xiongfeng Wang (1):
      Input: ati_remote2 - add missing newlines when printing module parameters

