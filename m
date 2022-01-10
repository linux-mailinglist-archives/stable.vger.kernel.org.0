Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8E264891CF
	for <lists+stable@lfdr.de>; Mon, 10 Jan 2022 08:42:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239841AbiAJHgi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jan 2022 02:36:38 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:40088 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240884AbiAJHdK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jan 2022 02:33:10 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D9C7D60B29;
        Mon, 10 Jan 2022 07:33:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 936F6C36AED;
        Mon, 10 Jan 2022 07:33:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641799989;
        bh=bDGUZlQcOaI174GRuW7X+q+dVGiqzGp8ZJ0oC2J7Y7I=;
        h=From:To:Cc:Subject:Date:From;
        b=VgIGVZWZI0qsTBWOFlmia96sCNfORWWxeZteTsWLOfk6VOTvyQEP870gVVnLKThf9
         XR9RvZGSmorq6gx+B26ZGYpUCPFvrDaPYXRO9FkjqDQJpFQoX9i/Uk0wzmcRh896pY
         q2aLEk4eli2tMv8nWjZgB7Bfb3+gJjNqePiUW/ew=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 5.15 00/72] 5.15.14-rc1 review
Date:   Mon, 10 Jan 2022 08:22:37 +0100
Message-Id: <20220110071821.500480371@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.14-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.15.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.15.14-rc1
X-KernelTest-Deadline: 2022-01-12T07:18+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.15.14 release.
There are 72 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 12 Jan 2022 07:18:05 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.14-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.15.14-rc1

Evan Quan <evan.quan@amd.com>
    drm/amd/pm: keep the BACO feature enabled for suspend

Len Brown <len.brown@intel.com>
    Revert "drm/amdgpu: stop scheduler when calling hw_fini (v2)"

Nikita Travkin <nikita@trvn.ru>
    Input: zinitix - make sure the IRQ is allocated before it gets enabled

Phil Elwell <phil@raspberrypi.com>
    ARM: dts: gpio-ranges property is now required

Mike Kravetz <mike.kravetz@oracle.com>
    userfaultfd/selftests: fix hugetlb area allocations

Tamir Duberstein <tamird@gmail.com>
    ipv6: raw: check passed optlen before reading

Lai, Derek <Derek.Lai@amd.com>
    drm/amd/display: Added power down for DCN10

Charlene Liu <Charlene.Liu@amd.com>
    drm/amd/display: fix B0 TMDS deepcolor no dislay issue

wolfgang huang <huangjinhui@kylinos.cn>
    mISDN: change function names to avoid conflicts

Evan Quan <evan.quan@amd.com>
    drm/amdgpu: put SMU into proper state on runpm suspending for BOCO capable platform

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu: always reset the asic in suspend (v2)

Prike Liang <Prike.Liang@amd.com>
    drm/amd/pm: skip setting gfx cgpg in the s0ix suspend-resume

Zekun Shen <bruceshenzk@gmail.com>
    atlantic: Fix buff_ring OOB in aq_ring_rx_clean

yangxingwu <xingwu.yang@gmail.com>
    net: udp: fix alignment problem in udp4_seq_show()

William Zhao <wizhao@redhat.com>
    ip6_vti: initialize __ip6_tnl_parm struct in vti6_siocdevprivate

Lixiaokeng <lixiaokeng@huawei.com>
    scsi: libiscsi: Fix UAF in iscsi_conn_get_param()/iscsi_conn_teardown()

Chunfeng Yun <chunfeng.yun@mediatek.com>
    usb: mtu3: fix interval value for intr and isoc

Lijo Lazar <lijo.lazar@amd.com>
    drm/amd/pm: Fix xgmi link control on aldebaran

Christian König <ckoenig.leichtzumerken@gmail.com>
    drm/amdgpu: fix dropped backing store handling in amdgpu_dma_buf_move_notify

Luiz Sampaio <sampaio.ime@gmail.com>
    auxdisplay: charlcd: checking for pointer reference before dereferencing

David Ahern <dsahern@kernel.org>
    ipv6: Do cleanup if attribute validation fails in multipath route

David Ahern <dsahern@kernel.org>
    ipv6: Continue processing multipath route even if gateway attribute is invalid

Yauhen Kharuzhy <jekhor@gmail.com>
    power: bq25890: Enable continuous conversion for ADC at charging

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu: disable runpm if we are the primary adapter

Alex Deucher <alexander.deucher@amd.com>
    fbdev: fbmem: add a helper to determine if an aperture is used by a fw fb

Hangyu Hua <hbh25y@gmail.com>
    phonet: refcount leak in pep_sock_accep

Haimin Zhang <tcs_kernel@tencent.com>
    net ticp:fix a kernel-infoleak in __tipc_sendmsg()

Steven Lee <steven_lee@aspeedtech.com>
    gpio: gpio-aspeed-sgpio: Fix wrong hwirq base in irq handler

Thomas Toye <thomas@toye.io>
    rndis_host: support Hytera digital radios

Heiner Kallweit <hkallweit1@gmail.com>
    reset: renesas: Fix Runtime PM usage

Nathan Chancellor <nathan@kernel.org>
    power: reset: ltc2952: Fix use of floating point literals

Linus Walleij <linus.walleij@linaro.org>
    power: supply: core: Break capacity loop

Darrick J. Wong <djwong@kernel.org>
    xfs: map unwritten blocks in XFS_IOC_{ALLOC,FREE}SP just like fallocate

Chris Packham <chris.packham@alliedtelesis.co.nz>
    i2c: mpc: Avoid out of bounds memory access

Wolfram Sang <wsa@kernel.org>
    Revert "i2c: core: support bus regulator controlling in adapter"

Tejun Heo <tj@kernel.org>
    cgroup: Use open-time cgroup namespace for process migration perm checks

Tejun Heo <tj@kernel.org>
    cgroup: Allocate cgroup_file_ctx for kernfs_open_file->priv

Tejun Heo <tj@kernel.org>
    cgroup: Use open-time credentials for process migraton perm checks

Nikunj A Dadhania <nikunj@amd.com>
    KVM: x86: Check for rmaps allocation

Qiuxu Zhuo <qiuxu.zhuo@intel.com>
    EDAC/i10nm: Release mdev/mbase when failing to detect HBM

Song Liu <song@kernel.org>
    md/raid1: fix missing bitmap update w/o WriteMostly devices

Arthur Kiyanovski <akiyano@amazon.com>
    net: ena: Fix error handling when calculating max IO queues number

Arthur Kiyanovski <akiyano@amazon.com>
    net: ena: Fix wrong rx request id by resetting device

Arthur Kiyanovski <akiyano@amazon.com>
    net: ena: Fix undefined state when tx request id is out of bounds

Eric Dumazet <edumazet@google.com>
    sch_qfq: prevent shift-out-of-bounds in qfq_init_qdisc

Linus Lüssing <linus.luessing@c0d3.blue>
    batman-adv: mcast: don't send link-local multicast to mcast routers

Xin Long <lucien.xin@gmail.com>
    sctp: hold endpoint before calling cb in sctp_transport_lookup_process

Jianguo Wu <wujianguo@chinatelecom.cn>
    selftests: net: udpgro_fwd.sh: explicitly checking the available ping feature

David Ahern <dsahern@kernel.org>
    lwtunnel: Validate RTA_ENCAP_TYPE attribute length

David Ahern <dsahern@kernel.org>
    ipv6: Check attribute length for RTA_GATEWAY when deleting multipath route

David Ahern <dsahern@kernel.org>
    ipv6: Check attribute length for RTA_GATEWAY in multipath route

David Ahern <dsahern@kernel.org>
    ipv4: Check attribute length for RTA_FLOW in multipath route

David Ahern <dsahern@kernel.org>
    ipv4: Check attribute length for RTA_GATEWAY in multipath route

Jiri Olsa <jolsa@redhat.com>
    ftrace/samples: Add missing prototypes direct functions

Jedrzej Jagielski <jedrzej.jagielski@intel.com>
    i40e: Fix incorrect netdev's real number of RX/TX queues

Mateusz Palczewski <mateusz.palczewski@intel.com>
    i40e: Fix for displaying message regarding NVM version

Di Zhu <zhudi2@huawei.com>
    i40e: fix use-after-free in i40e_sync_filters_subtask()

Martin Habets <habetsm.xilinx@gmail.com>
    sfc: The RX page_ring is optional

Pavel Skripkin <paskripkin@gmail.com>
    mac80211: mesh: embedd mesh_paths and mpp_paths into ieee80211_if_mesh

Tom Rix <trix@redhat.com>
    mac80211: initialize variable have_higher_than_11mbit

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    RDMA/uverbs: Check for null return of kmalloc_array

Christoph Hellwig <hch@lst.de>
    netrom: fix copying in user data in nr_setsockopt

Aaron Ma <aaron.ma@canonical.com>
    Revert "net: usb: r8152: Add MAC passthrough support for more Lenovo Docks"

Leon Romanovsky <leon@kernel.org>
    RDMA/core: Don't infoleak GRH fields

Karen Sornek <karen.sornek@intel.com>
    iavf: Fix limit of total number of queues to active queues of VF

Mateusz Palczewski <mateusz.palczewski@intel.com>
    i40e: Fix to not show opcode msg on unsuccessful VF MAC change

Pavel Skripkin <paskripkin@gmail.com>
    ieee802154: atusb: fix uninit value in atusb_set_extended_addr

Maor Gottlieb <maorg@nvidia.com>
    Revert "RDMA/mlx5: Fix releasing unallocated memory in dereg MR flow"

Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
    tracing: Tag trace_percpu_buffer as a percpu pointer

Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
    tracing: Fix check for trace_percpu_buffer validity in get_trace_buf()

Shuah Khan <skhan@linuxfoundation.org>
    selftests: x86: fix [-Wstringop-overread] warn in test_process_vm_readv()

Dominique Martinet <asmadeus@codewreck.org>
    fscache_cookie_enabled: check cookie is valid before accessing it


-------------

Diffstat:

 Makefile                                           |  4 +-
 arch/arm/boot/dts/bcm2711.dtsi                     |  2 +
 arch/arm/boot/dts/bcm283x.dtsi                     |  2 +
 arch/x86/kvm/debugfs.c                             |  3 +
 drivers/auxdisplay/charlcd.c                       |  3 +
 drivers/edac/i10nm_base.c                          |  9 ++
 drivers/gpio/gpio-aspeed-sgpio.c                   |  2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu.h                |  1 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_dma_buf.c        |  2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c            | 48 ++++++++++-
 drivers/gpu/drm/amd/amdgpu/amdgpu_fence.c          |  8 --
 drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c            |  6 ++
 drivers/gpu/drm/amd/display/dc/dcn10/dcn10_init.c  |  1 +
 .../gpu/drm/amd/display/dc/dcn31/dcn31_resource.c  | 25 +++++-
 .../gpu/drm/amd/display/dc/dcn31/dcn31_resource.h  | 31 +++++++
 drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c          | 15 ++--
 drivers/gpu/drm/amd/pm/swsmu/smu12/smu_v12_0.c     |  3 +-
 drivers/gpu/drm/amd/pm/swsmu/smu13/aldebaran_ppt.c |  2 +-
 drivers/i2c/busses/i2c-mpc.c                       | 15 ++--
 drivers/i2c/i2c-core-base.c                        | 95 ----------------------
 drivers/infiniband/core/uverbs_marshall.c          |  2 +-
 drivers/infiniband/core/uverbs_uapi.c              |  3 +
 drivers/infiniband/hw/mlx5/mlx5_ib.h               |  6 +-
 drivers/infiniband/hw/mlx5/mr.c                    | 26 +++---
 drivers/input/touchscreen/zinitix.c                | 18 ++--
 drivers/isdn/mISDN/core.c                          |  6 +-
 drivers/isdn/mISDN/core.h                          |  4 +-
 drivers/isdn/mISDN/layer1.c                        |  4 +-
 drivers/md/raid1.c                                 |  3 +-
 drivers/net/ethernet/amazon/ena/ena_netdev.c       | 49 ++++++-----
 drivers/net/ethernet/aquantia/atlantic/aq_ring.c   |  8 ++
 drivers/net/ethernet/intel/i40e/i40e_main.c        | 60 ++++++++++++--
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c | 40 +++++++--
 drivers/net/ethernet/intel/iavf/iavf_main.c        |  5 +-
 drivers/net/ethernet/sfc/falcon/rx.c               |  5 ++
 drivers/net/ethernet/sfc/rx_common.c               |  5 ++
 drivers/net/ieee802154/atusb.c                     | 10 ++-
 drivers/net/usb/r8152.c                            |  9 +-
 drivers/net/usb/rndis_host.c                       |  5 ++
 drivers/power/reset/ltc2952-poweroff.c             |  4 +-
 drivers/power/supply/bq25890_charger.c             |  4 +-
 drivers/power/supply/power_supply_core.c           |  4 +
 drivers/reset/reset-rzg2l-usbphy-ctrl.c            |  7 +-
 drivers/scsi/libiscsi.c                            |  6 +-
 drivers/usb/mtu3/mtu3_gadget.c                     |  4 +-
 drivers/video/fbdev/core/fbmem.c                   | 47 +++++++++++
 fs/xfs/xfs_ioctl.c                                 |  3 +-
 include/linux/fb.h                                 |  1 +
 include/linux/fscache.h                            |  2 +-
 include/net/sctp/sctp.h                            |  3 +-
 kernel/cgroup/cgroup-internal.h                    | 19 +++++
 kernel/cgroup/cgroup-v1.c                          | 33 ++++----
 kernel/cgroup/cgroup.c                             | 88 +++++++++++++-------
 kernel/trace/trace.c                               |  6 +-
 net/batman-adv/multicast.c                         | 15 ++--
 net/batman-adv/multicast.h                         | 10 ++-
 net/batman-adv/soft-interface.c                    |  7 +-
 net/core/lwtunnel.c                                |  4 +
 net/ipv4/fib_semantics.c                           | 49 +++++++++--
 net/ipv4/udp.c                                     |  2 +-
 net/ipv6/ip6_vti.c                                 |  2 +
 net/ipv6/raw.c                                     |  3 +
 net/ipv6/route.c                                   | 32 +++++++-
 net/mac80211/ieee80211_i.h                         | 24 +++++-
 net/mac80211/mesh.h                                | 22 +----
 net/mac80211/mesh_pathtbl.c                        | 89 +++++++-------------
 net/mac80211/mlme.c                                |  2 +-
 net/netrom/af_netrom.c                             |  2 +-
 net/phonet/pep.c                                   |  1 +
 net/sched/sch_qfq.c                                |  6 +-
 net/sctp/diag.c                                    | 46 +++++------
 net/sctp/socket.c                                  | 22 +++--
 net/tipc/socket.c                                  |  2 +
 samples/ftrace/ftrace-direct-modify.c              |  3 +
 samples/ftrace/ftrace-direct-too.c                 |  3 +
 samples/ftrace/ftrace-direct.c                     |  2 +
 tools/testing/selftests/net/udpgro_fwd.sh          |  3 +-
 tools/testing/selftests/vm/userfaultfd.c           | 16 ++--
 tools/testing/selftests/x86/test_vsyscall.c        |  2 +-
 79 files changed, 737 insertions(+), 408 deletions(-)


