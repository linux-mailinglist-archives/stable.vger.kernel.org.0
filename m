Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0B1C48AFC7
	for <lists+stable@lfdr.de>; Tue, 11 Jan 2022 15:42:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242570AbiAKOl6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Jan 2022 09:41:58 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:53524 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242757AbiAKOlz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Jan 2022 09:41:55 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 379F5B81B3A;
        Tue, 11 Jan 2022 14:41:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C7B9C36AED;
        Tue, 11 Jan 2022 14:41:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641912106;
        bh=rBuDZL5tn5Ee/KDIw4t1dMRa0Z7ileqn+2IcYsmbeHw=;
        h=From:To:Cc:Subject:Date:From;
        b=vkIV0orPY7G4Ld4Uz+wTgfCkX6MOhQAGz4qzw+0PcTg4t0Ldo7BnFT3TcmjNknWY9
         Ttzyfk8Ptk+0b3jYWx17i9XkLJE9JEvYFgIF7jjYpr87R8/8rIrWiT2z/OCpcjL9Qd
         hEBVWz2q6rIxxAMiNaPlYHkzlKBmbFxtOwXg6SIw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.15.14
Date:   Tue, 11 Jan 2022 15:41:38 +0100
Message-Id: <1641912099199218@kroah.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.15.14 kernel.

All users of the 5.15 kernel series must upgrade.

The updated 5.15.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.15.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                              |    2 
 arch/arm/boot/dts/bcm2711.dtsi                        |    2 
 arch/arm/boot/dts/bcm283x.dtsi                        |    2 
 arch/x86/kvm/debugfs.c                                |    3 
 drivers/auxdisplay/charlcd.c                          |    3 
 drivers/edac/i10nm_base.c                             |    9 +
 drivers/gpio/gpio-aspeed-sgpio.c                      |    2 
 drivers/gpu/drm/amd/amdgpu/amdgpu.h                   |    1 
 drivers/gpu/drm/amd/amdgpu/amdgpu_dma_buf.c           |    2 
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c               |   48 ++++++++-
 drivers/gpu/drm/amd/amdgpu/amdgpu_fence.c             |    8 -
 drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c               |    6 +
 drivers/gpu/drm/amd/display/dc/dcn10/dcn10_init.c     |    1 
 drivers/gpu/drm/amd/display/dc/dcn31/dcn31_resource.c |   25 ++++
 drivers/gpu/drm/amd/display/dc/dcn31/dcn31_resource.h |   31 +++++
 drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c             |   15 +-
 drivers/gpu/drm/amd/pm/swsmu/smu12/smu_v12_0.c        |    3 
 drivers/gpu/drm/amd/pm/swsmu/smu13/aldebaran_ppt.c    |    2 
 drivers/i2c/busses/i2c-mpc.c                          |   15 +-
 drivers/i2c/i2c-core-base.c                           |   95 ------------------
 drivers/infiniband/core/uverbs_marshall.c             |    2 
 drivers/infiniband/core/uverbs_uapi.c                 |    3 
 drivers/infiniband/hw/mlx5/mlx5_ib.h                  |    6 -
 drivers/infiniband/hw/mlx5/mr.c                       |   26 ++--
 drivers/input/touchscreen/zinitix.c                   |   18 +--
 drivers/isdn/mISDN/core.c                             |    6 -
 drivers/isdn/mISDN/core.h                             |    4 
 drivers/isdn/mISDN/layer1.c                           |    4 
 drivers/md/raid1.c                                    |    3 
 drivers/net/ethernet/amazon/ena/ena_netdev.c          |   49 +++++----
 drivers/net/ethernet/aquantia/atlantic/aq_ring.c      |    8 +
 drivers/net/ethernet/intel/i40e/i40e_main.c           |   60 +++++++++--
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c    |   40 ++++++-
 drivers/net/ethernet/intel/iavf/iavf_main.c           |    5 
 drivers/net/ethernet/sfc/falcon/rx.c                  |    5 
 drivers/net/ethernet/sfc/rx_common.c                  |    5 
 drivers/net/ieee802154/atusb.c                        |   10 +
 drivers/net/usb/r8152.c                               |    9 +
 drivers/net/usb/rndis_host.c                          |    5 
 drivers/power/reset/ltc2952-poweroff.c                |    4 
 drivers/power/supply/bq25890_charger.c                |    4 
 drivers/power/supply/power_supply_core.c              |    4 
 drivers/reset/reset-rzg2l-usbphy-ctrl.c               |    7 +
 drivers/scsi/libiscsi.c                               |    6 -
 drivers/usb/mtu3/mtu3_gadget.c                        |    4 
 drivers/video/fbdev/core/fbmem.c                      |   47 ++++++++
 fs/xfs/xfs_ioctl.c                                    |    3 
 include/linux/fb.h                                    |    1 
 include/linux/fscache.h                               |    2 
 include/net/sctp/sctp.h                               |    3 
 kernel/cgroup/cgroup-internal.h                       |   19 +++
 kernel/cgroup/cgroup-v1.c                             |   33 +++---
 kernel/cgroup/cgroup.c                                |   88 +++++++++++-----
 kernel/trace/trace.c                                  |    6 -
 net/batman-adv/multicast.c                            |   15 +-
 net/batman-adv/multicast.h                            |   10 +
 net/batman-adv/soft-interface.c                       |    7 -
 net/core/lwtunnel.c                                   |    4 
 net/ipv4/fib_semantics.c                              |   49 ++++++++-
 net/ipv4/udp.c                                        |    2 
 net/ipv6/ip6_vti.c                                    |    2 
 net/ipv6/raw.c                                        |    3 
 net/ipv6/route.c                                      |   32 +++++-
 net/mac80211/ieee80211_i.h                            |   24 ++++
 net/mac80211/mesh.h                                   |   22 ----
 net/mac80211/mesh_pathtbl.c                           |   89 +++++-----------
 net/mac80211/mlme.c                                   |    2 
 net/netrom/af_netrom.c                                |    2 
 net/phonet/pep.c                                      |    1 
 net/sched/sch_qfq.c                                   |    6 -
 net/sctp/diag.c                                       |   46 +++-----
 net/sctp/socket.c                                     |   22 ++--
 net/tipc/socket.c                                     |    2 
 samples/ftrace/ftrace-direct-modify.c                 |    3 
 samples/ftrace/ftrace-direct-too.c                    |    3 
 samples/ftrace/ftrace-direct.c                        |    2 
 tools/testing/selftests/net/udpgro_fwd.sh             |    3 
 tools/testing/selftests/vm/userfaultfd.c              |   16 +--
 tools/testing/selftests/x86/test_vsyscall.c           |    2 
 79 files changed, 736 insertions(+), 407 deletions(-)

Aaron Ma (1):
      Revert "net: usb: r8152: Add MAC passthrough support for more Lenovo Docks"

Alex Deucher (3):
      fbdev: fbmem: add a helper to determine if an aperture is used by a fw fb
      drm/amdgpu: disable runpm if we are the primary adapter
      drm/amdgpu: always reset the asic in suspend (v2)

Arthur Kiyanovski (3):
      net: ena: Fix undefined state when tx request id is out of bounds
      net: ena: Fix wrong rx request id by resetting device
      net: ena: Fix error handling when calculating max IO queues number

Charlene Liu (1):
      drm/amd/display: fix B0 TMDS deepcolor no dislay issue

Chris Packham (1):
      i2c: mpc: Avoid out of bounds memory access

Christian König (1):
      drm/amdgpu: fix dropped backing store handling in amdgpu_dma_buf_move_notify

Christoph Hellwig (1):
      netrom: fix copying in user data in nr_setsockopt

Chunfeng Yun (1):
      usb: mtu3: fix interval value for intr and isoc

Darrick J. Wong (1):
      xfs: map unwritten blocks in XFS_IOC_{ALLOC,FREE}SP just like fallocate

David Ahern (7):
      ipv4: Check attribute length for RTA_GATEWAY in multipath route
      ipv4: Check attribute length for RTA_FLOW in multipath route
      ipv6: Check attribute length for RTA_GATEWAY in multipath route
      ipv6: Check attribute length for RTA_GATEWAY when deleting multipath route
      lwtunnel: Validate RTA_ENCAP_TYPE attribute length
      ipv6: Continue processing multipath route even if gateway attribute is invalid
      ipv6: Do cleanup if attribute validation fails in multipath route

Di Zhu (1):
      i40e: fix use-after-free in i40e_sync_filters_subtask()

Dominique Martinet (1):
      fscache_cookie_enabled: check cookie is valid before accessing it

Eric Dumazet (1):
      sch_qfq: prevent shift-out-of-bounds in qfq_init_qdisc

Evan Quan (2):
      drm/amdgpu: put SMU into proper state on runpm suspending for BOCO capable platform
      drm/amd/pm: keep the BACO feature enabled for suspend

Greg Kroah-Hartman (1):
      Linux 5.15.14

Haimin Zhang (1):
      net ticp:fix a kernel-infoleak in __tipc_sendmsg()

Hangyu Hua (1):
      phonet: refcount leak in pep_sock_accep

Heiner Kallweit (1):
      reset: renesas: Fix Runtime PM usage

Jedrzej Jagielski (1):
      i40e: Fix incorrect netdev's real number of RX/TX queues

Jianguo Wu (1):
      selftests: net: udpgro_fwd.sh: explicitly checking the available ping feature

Jiasheng Jiang (1):
      RDMA/uverbs: Check for null return of kmalloc_array

Jiri Olsa (1):
      ftrace/samples: Add missing prototypes direct functions

Karen Sornek (1):
      iavf: Fix limit of total number of queues to active queues of VF

Lai, Derek (1):
      drm/amd/display: Added power down for DCN10

Len Brown (1):
      Revert "drm/amdgpu: stop scheduler when calling hw_fini (v2)"

Leon Romanovsky (1):
      RDMA/core: Don't infoleak GRH fields

Lijo Lazar (1):
      drm/amd/pm: Fix xgmi link control on aldebaran

Linus Lüssing (1):
      batman-adv: mcast: don't send link-local multicast to mcast routers

Linus Walleij (1):
      power: supply: core: Break capacity loop

Lixiaokeng (1):
      scsi: libiscsi: Fix UAF in iscsi_conn_get_param()/iscsi_conn_teardown()

Luiz Sampaio (1):
      auxdisplay: charlcd: checking for pointer reference before dereferencing

Maor Gottlieb (1):
      Revert "RDMA/mlx5: Fix releasing unallocated memory in dereg MR flow"

Martin Habets (1):
      sfc: The RX page_ring is optional

Mateusz Palczewski (2):
      i40e: Fix to not show opcode msg on unsuccessful VF MAC change
      i40e: Fix for displaying message regarding NVM version

Mike Kravetz (1):
      userfaultfd/selftests: fix hugetlb area allocations

Nathan Chancellor (1):
      power: reset: ltc2952: Fix use of floating point literals

Naveen N. Rao (2):
      tracing: Fix check for trace_percpu_buffer validity in get_trace_buf()
      tracing: Tag trace_percpu_buffer as a percpu pointer

Nikita Travkin (1):
      Input: zinitix - make sure the IRQ is allocated before it gets enabled

Nikunj A Dadhania (1):
      KVM: x86: Check for rmaps allocation

Pavel Skripkin (2):
      ieee802154: atusb: fix uninit value in atusb_set_extended_addr
      mac80211: mesh: embedd mesh_paths and mpp_paths into ieee80211_if_mesh

Phil Elwell (1):
      ARM: dts: gpio-ranges property is now required

Prike Liang (1):
      drm/amd/pm: skip setting gfx cgpg in the s0ix suspend-resume

Qiuxu Zhuo (1):
      EDAC/i10nm: Release mdev/mbase when failing to detect HBM

Shuah Khan (1):
      selftests: x86: fix [-Wstringop-overread] warn in test_process_vm_readv()

Song Liu (1):
      md/raid1: fix missing bitmap update w/o WriteMostly devices

Steven Lee (1):
      gpio: gpio-aspeed-sgpio: Fix wrong hwirq base in irq handler

Tamir Duberstein (1):
      ipv6: raw: check passed optlen before reading

Tejun Heo (3):
      cgroup: Use open-time credentials for process migraton perm checks
      cgroup: Allocate cgroup_file_ctx for kernfs_open_file->priv
      cgroup: Use open-time cgroup namespace for process migration perm checks

Thomas Toye (1):
      rndis_host: support Hytera digital radios

Tom Rix (1):
      mac80211: initialize variable have_higher_than_11mbit

William Zhao (1):
      ip6_vti: initialize __ip6_tnl_parm struct in vti6_siocdevprivate

Wolfram Sang (1):
      Revert "i2c: core: support bus regulator controlling in adapter"

Xin Long (1):
      sctp: hold endpoint before calling cb in sctp_transport_lookup_process

Yauhen Kharuzhy (1):
      power: bq25890: Enable continuous conversion for ADC at charging

Zekun Shen (1):
      atlantic: Fix buff_ring OOB in aq_ring_rx_clean

wolfgang huang (1):
      mISDN: change function names to avoid conflicts

yangxingwu (1):
      net: udp: fix alignment problem in udp4_seq_show()

