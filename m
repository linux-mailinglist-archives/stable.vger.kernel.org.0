Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2E184CA293
	for <lists+stable@lfdr.de>; Wed,  2 Mar 2022 11:55:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241260AbiCBKzN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Mar 2022 05:55:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241177AbiCBKyV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Mar 2022 05:54:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4BC442A1D;
        Wed,  2 Mar 2022 02:53:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 20D5C61736;
        Wed,  2 Mar 2022 10:53:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10888C004E1;
        Wed,  2 Mar 2022 10:53:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646218392;
        bh=3kVpVOqAsFMHQoSPSlPiV8kOm/5fHxUt1Z3AxGzveoo=;
        h=From:To:Cc:Subject:Date:From;
        b=f4zsFlTTQ79wbgkaeDq7u9T2Y3Z5+UwjRNH/5C1yJDSkAJA+nj2AzUmg8Ei7zxTEl
         iFWsrKXdiK6+x4g3joBxyg1sxpYOuAi38wT0CFLaF+lz2mcKZKRJL0oijiJ2AGmdxu
         WqP3dgslr0rAPBDYQHS12CRppQak35zVlwEjMhXo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.16.12
Date:   Wed,  2 Mar 2022 11:52:59 +0100
Message-Id: <164621837913616@kroah.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.16.12 kernel.

All users of the 5.16 kernel series must upgrade.

The updated 5.16.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.16.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                                       |    2 
 arch/parisc/kernel/unaligned.c                                 |   14 -
 arch/riscv/configs/nommu_k210_sdcard_defconfig                 |    2 
 arch/riscv/kernel/Makefile                                     |    2 
 arch/riscv/kernel/entry.S                                      |   10 
 arch/riscv/kernel/trace_irq.c                                  |   27 ++
 arch/riscv/kernel/trace_irq.h                                  |   11 
 arch/x86/kvm/mmu/mmu.c                                         |   13 +
 arch/x86/kvm/svm/svm.c                                         |   19 +
 block/fops.c                                                   |    2 
 drivers/ata/pata_hpt37x.c                                      |   14 +
 drivers/base/dd.c                                              |    5 
 drivers/base/regmap/regmap-irq.c                               |   20 -
 drivers/clk/ingenic/jz4725b-cgu.c                              |    3 
 drivers/clk/qcom/gcc-msm8994.c                                 |  106 --------
 drivers/gpio/gpio-rockchip.c                                   |   56 ++--
 drivers/gpio/gpio-tegra186.c                                   |   14 -
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c                        |    3 
 drivers/gpu/drm/amd/amdgpu/soc15.c                             |    9 
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c              |   17 -
 drivers/gpu/drm/amd/display/dc/clk_mgr/dcn30/dcn30_clk_mgr.c   |    2 
 drivers/gpu/drm/amd/display/dc/core/dc.c                       |    7 
 drivers/gpu/drm/amd/display/dc/core/dc_resource.c              |    4 
 drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c        |   32 ++
 drivers/gpu/drm/drm_edid.c                                     |    2 
 drivers/gpu/drm/i915/display/intel_bw.c                        |   18 +
 drivers/gpu/drm/i915/display/intel_bw.h                        |    8 
 drivers/gpu/drm/i915/display/intel_snps_phy.c                  |    2 
 drivers/gpu/drm/i915/display/intel_tc.c                        |   26 +-
 drivers/gpu/drm/i915/intel_pm.c                                |   22 -
 drivers/gpu/drm/vc4/vc4_crtc.c                                 |    8 
 drivers/gpu/host1x/syncpt.c                                    |   19 -
 drivers/hwmon/hwmon.c                                          |   14 -
 drivers/iio/accel/bmc150-accel-core.c                          |    5 
 drivers/iio/accel/fxls8962af-core.c                            |   12 -
 drivers/iio/accel/fxls8962af-i2c.c                             |    2 
 drivers/iio/accel/fxls8962af-spi.c                             |    2 
 drivers/iio/accel/fxls8962af.h                                 |    3 
 drivers/iio/accel/kxcjk-1013.c                                 |    5 
 drivers/iio/accel/mma9551.c                                    |    5 
 drivers/iio/accel/mma9553.c                                    |    5 
 drivers/iio/adc/ad7124.c                                       |    2 
 drivers/iio/adc/men_z188_adc.c                                 |    9 
 drivers/iio/adc/ti-tsc2046.c                                   |    4 
 drivers/iio/gyro/bmg160_core.c                                 |    5 
 drivers/iio/imu/adis16480.c                                    |    7 
 drivers/iio/imu/kmx61.c                                        |    5 
 drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c                   |    6 
 drivers/iio/magnetometer/bmc150_magn.c                         |    5 
 drivers/infiniband/core/cma.c                                  |   40 ++-
 drivers/infiniband/hw/qib/qib_sysfs.c                          |    2 
 drivers/infiniband/ulp/rtrs/rtrs-clt.c                         |   39 +--
 drivers/infiniband/ulp/srp/ib_srp.c                            |    6 
 drivers/mtd/mtdcore.c                                          |    2 
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c               |    3 
 drivers/net/ethernet/broadcom/bnxt/bnxt.c                      |   47 ++-
 drivers/net/ethernet/broadcom/bnxt/bnxt.h                      |    1 
 drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c              |   39 ++-
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c              |   17 +
 drivers/net/ethernet/broadcom/bnxt/bnxt_hwrm.c                 |   12 -
 drivers/net/ethernet/broadcom/bnxt/bnxt_hwrm.h                 |    2 
 drivers/net/ethernet/ibm/ibmvnic.c                             |    6 
 drivers/net/ethernet/intel/i40e/i40e_main.c                    |   12 -
 drivers/net/ethernet/intel/ice/ice.h                           |    1 
 drivers/net/ethernet/intel/ice/ice_common.c                    |    2 
 drivers/net/ethernet/intel/ice/ice_main.c                      |    2 
 drivers/net/ethernet/intel/ice/ice_ptp.c                       |    5 
 drivers/net/ethernet/intel/ice/ice_tc_lib.c                    |    4 
 drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c               |   42 ++-
 drivers/net/ethernet/marvell/mv643xx_eth.c                     |   24 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_mplsoudp.c   |   28 --
 drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c           |    2 
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c                |    3 
 drivers/net/ethernet/mellanox/mlx5/core/en_selftest.c          |    1 
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c                |   12 +
 drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c     |    4 
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c              |    2 
 drivers/net/ethernet/mellanox/mlx5/core/lib/fs_chains.c        |    3 
 drivers/net/ethernet/mellanox/mlx5/core/main.c                 |    4 
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_icm_pool.c |  120 ++++++----
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c  |   20 -
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c      |   32 ++
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h    |   10 
 drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c       |   33 ++
 drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5dr.h      |    5 
 drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c        |    4 
 drivers/net/ethernet/xilinx/ll_temac_main.c                    |    2 
 drivers/net/mdio/mdio-ipq4019.c                                |    6 
 drivers/net/usb/cdc_ether.c                                    |   12 +
 drivers/net/usb/cdc_ncm.c                                      |    8 
 drivers/net/usb/sr9700.c                                       |    2 
 drivers/net/usb/zaurus.c                                       |   12 +
 drivers/nvme/host/core.c                                       |    6 
 drivers/nvmem/core.c                                           |    2 
 drivers/pci/controller/pci-mvebu.c                             |    3 
 drivers/pinctrl/pinctrl-k210.c                                 |    4 
 drivers/platform/surface/surface3_power.c                      |   13 -
 drivers/spi/spi-zynq-qspi.c                                    |    3 
 drivers/staging/fbtft/fb_st7789v.c                             |    2 
 drivers/thermal/intel/int340x_thermal/int3400_thermal.c        |    4 
 drivers/tty/n_gsm.c                                            |   61 +++--
 drivers/tty/serial/sc16is7xx.c                                 |    3 
 drivers/usb/dwc2/core.h                                        |    2 
 drivers/usb/dwc2/drd.c                                         |    6 
 drivers/usb/dwc3/dwc3-pci.c                                    |   17 +
 drivers/usb/dwc3/gadget.c                                      |    2 
 drivers/usb/gadget/function/rndis.c                            |    8 
 drivers/usb/gadget/function/rndis.h                            |    1 
 drivers/usb/gadget/udc/udc-xilinx.c                            |    6 
 drivers/usb/host/xhci.c                                        |   28 +-
 drivers/usb/serial/ch341.c                                     |    1 
 drivers/usb/serial/option.c                                    |   12 +
 drivers/usb/typec/tipd/core.c                                  |    7 
 drivers/vhost/vsock.c                                          |   21 +
 fs/btrfs/ctree.h                                               |    2 
 fs/btrfs/file.c                                                |   97 ++------
 fs/btrfs/inode.c                                               |    4 
 fs/btrfs/ioctl.c                                               |   81 +++++-
 fs/btrfs/lzo.c                                                 |   11 
 fs/btrfs/tree-checker.c                                        |   15 +
 fs/configfs/dir.c                                              |   14 +
 fs/io_uring.c                                                  |   24 +-
 fs/tracefs/inode.c                                             |    5 
 include/linux/bpf.h                                            |    9 
 include/linux/nvmem-provider.h                                 |    4 
 include/linux/skmsg.h                                          |    6 
 include/linux/slab.h                                           |    3 
 include/net/checksum.h                                         |   50 ++--
 include/net/netfilter/nf_tables.h                              |    2 
 include/net/netfilter/nf_tables_offload.h                      |    2 
 include/net/sock.h                                             |    9 
 kernel/bpf/btf.c                                               |   97 ++++++--
 kernel/bpf/syscall.c                                           |    3 
 kernel/cgroup/cgroup-v1.c                                      |    6 
 kernel/cgroup/cpuset.c                                         |    2 
 kernel/trace/trace_events_trigger.c                            |   59 ++++
 mm/filemap.c                                                   |    8 
 mm/hugetlb.c                                                   |   11 
 mm/memblock.c                                                  |   10 
 net/can/j1939/transport.c                                      |    2 
 net/core/filter.c                                              |    3 
 net/core/skbuff.c                                              |   12 -
 net/core/sock.c                                                |   10 
 net/dsa/master.c                                               |    7 
 net/dsa/port.c                                                 |   20 +
 net/ipv4/af_inet.c                                             |    5 
 net/ipv4/ip_output.c                                           |    2 
 net/ipv4/ping.c                                                |    1 
 net/ipv4/udp_tunnel_nic.c                                      |    2 
 net/ipv6/ip6_offload.c                                         |    2 
 net/ipv6/ip6_output.c                                          |    2 
 net/mptcp/mib.c                                                |    2 
 net/mptcp/mib.h                                                |    2 
 net/mptcp/pm.c                                                 |    8 
 net/mptcp/pm_netlink.c                                         |   19 +
 net/netfilter/nf_tables_api.c                                  |   16 +
 net/netfilter/nf_tables_offload.c                              |    3 
 net/netfilter/nft_dup_netdev.c                                 |    6 
 net/netfilter/nft_fwd_netdev.c                                 |    6 
 net/netfilter/nft_immediate.c                                  |   12 -
 net/netfilter/xt_socket.c                                      |    4 
 net/openvswitch/actions.c                                      |   46 +++
 net/sched/act_ct.c                                             |    5 
 net/smc/smc_pnet.c                                             |   42 +--
 net/smc/smc_pnet.h                                             |    2 
 net/tipc/name_table.c                                          |    2 
 net/tipc/socket.c                                              |    2 
 security/selinux/ima.c                                         |    4 
 tools/perf/util/data.c                                         |    7 
 tools/perf/util/evlist-hybrid.c                                |    4 
 tools/testing/selftests/bpf/progs/test_sockmap_kern.h          |   26 +-
 tools/testing/selftests/net/mptcp/diag.sh                      |   44 +++
 tools/testing/selftests/net/mptcp/mptcp_join.sh                |   15 +
 173 files changed, 1535 insertions(+), 784 deletions(-)

Alexey Bayduraev (1):
      perf data: Fix double free in perf_session__delete()

Aneesh Kumar K.V (1):
      mm/hugetlb: fix kernel crash with hugetlb mremap

Ariel Levkovich (1):
      net/mlx5: Fix wrong limitation of metadata match on ecpf

Bart Van Assche (1):
      RDMA/ib_srp: Fix a deadlock

Baruch Siach (1):
      net: mdio-ipq4019: add delay after clock enable

Bas Nieuwenhuizen (1):
      drm/amd/display: Protect update_bw_bounding_box FPU code.

Changbin Du (1):
      riscv: fix oops caused by irqsoff latency tracer

Chen Gong (1):
      drm/amdgpu: do not enable asic reset for raven2

ChenXiaoSong (1):
      configfs: fix a race in configfs_{,un}register_subsystem()

Chris Mi (1):
      net/mlx5: Fix tc max supported prio for nic mode

Christoph Hellwig (1):
      nvme: also mark passthrough-only namespaces ready in nvme_update_ns_info

Christophe JAILLET (2):
      nfp: flower: Fix a potential leak in nfp_tunnel_add_shared_mac()
      iio: adc: men_z188_adc: Fix a resource leak in an error handling path

Christophe Kerello (2):
      nvmem: core: Fix a conflict between MTD and NVMEM on wp-gpios property
      mtd: core: Fix a conflict between MTD and NVMEM on wp-gpios property

Christophe Leroy (1):
      net: Force inlining of checksum functions in net/checksum.h

Chuansheng Liu (1):
      thermal: int340x: fix memory leak in int3400_notify()

Cosmin Tanislav (1):
      iio: adc: ad7124: fix mask used for setting AIN_BUFP & AIN_BUFM bits

Daehwan Jung (1):
      usb: gadget: rndis: add spinlock for rndis response list

Damien Le Moal (1):
      riscv: fix nommu_k210_sdcard_defconfig

Dan Carpenter (3):
      tipc: Fix end of loop tests for list_for_each_entry()
      udp_tunnel: Fix end of loop test in udp_tunnel_nic_unregister()
      pinctrl: fix loop in k210_pinconf_get_drive()

Daniel Bristot de Oliveira (1):
      tracing: Dump stacktrace trigger to the corresponding instance

Daniele Palmas (1):
      USB: serial: option: add Telit LE910R1 compositions

Dmytro Bagrii (1):
      Revert "USB: serial: ch341: add new Product ID for CH341A"

Dylan Yudaken (1):
      io_uring: disallow modification of rsrc_data during quiesce

Dāvis Mosāns (1):
      btrfs: prevent copying too big compressed lzo segment

Eric Dumazet (6):
      netfilter: xt_socket: fix a typo in socket_mt_destroy()
      bpf: Add schedule points in batch ops
      io_uring: add a schedule point in io_add_buffers()
      net: __pskb_pull_tail() & pskb_carve_frag_list() drop_monitor friends
      net: use sk_is_tcp() in more places
      net-timestamp: convert sk->sk_tskey to atomic_t

Evan Quan (2):
      drm/amd/pm: fix some OEM SKU specific stability issues
      drm/amdgpu: disable MMHUB PG for Picasso

Fabio M. De Francesco (1):
      net/smc: Use a mutex for locking "struct smc_pnettable"

Fabrice Gasnier (1):
      usb: dwc2: drd: fix soft connect when gadget is unconfigured

Felix Maurer (2):
      bpf: Do not try bpf_msg_push_data with len 0
      selftests: bpf: Check bpf_msg_push_data return value

Florian Westphal (1):
      netfilter: nf_tables: fix memory leak during stateful obj update

Gal Pressman (1):
      net/mlx5e: Fix wrong return value on ioctl EEPROM query failure

Greg Kroah-Hartman (2):
      slab: remove __alloc_size attribute from __kmalloc_track_caller
      Linux 5.16.12

Guenter Roeck (1):
      hwmon: Handle failure to register sensor with thermal zone correctly

Hans de Goede (3):
      surface: surface3_power: Fix battery readings on batteries without a serial number
      usb: dwc3: pci: Add "snps,dis_u2_susphy_quirk" for Intel Bay Trail
      usb: dwc3: pci: Fix Bay Trail phy GPIO mappings

Helge Deller (2):
      parisc/unaligned: Fix fldd and fstd unaligned handlers on 32-bit kernel
      parisc/unaligned: Fix ldw() and stw() unalignment handlers

Hongyu Xie (1):
      xhci: Prevent futile URB re-submissions due to incorrect return value.

Imre Deak (1):
      drm/i915: Disconnect PHYs left connected by BIOS on disabled ports

Jacob Keller (1):
      ice: fix concurrent reset and removal of VFs

Jason Gunthorpe (1):
      RDMA/cma: Do not change route.addr.src_addr outside state checks

Jens Axboe (2):
      io_uring: don't convert to jiffies for waiting on timeouts
      tps6598x: clear int mask on probe failure

Kalesh AP (2):
      bnxt_en: Fix devlink fw_activate
      bnxt_en: Restore the resets_reliable flag in bnxt_open()

Konrad Dybcio (1):
      clk: qcom: gcc-msm8994: Remove NoC clocks

Kumar Kartikeya Dwivedi (3):
      bpf: Fix crash due to incorrect copy_map_value
      bpf: Extend kfunc with PTR_TO_CTX, PTR_TO_MEM argument support
      bpf: Fix crash due to out of bounds access into reg2btf_ids.

Lama Kayal (1):
      net/mlx5e: Add missing increment of count

Liang Zhang (1):
      KVM: x86/mmu: make apf token non-zero to fix bug

Liu Yuntao (1):
      hugetlbfs: fix a truncation issue in hugepages parameter

Lorenzo Bianconi (1):
      iio: imu: st_lsm6dsx: wait for settling time in st_lsm6dsx_read_oneshot

Maher Sanalla (1):
      net/mlx5: Update log_max_qp value to be 17 at most

Manish Chopra (1):
      bnx2x: fix driver load from initrd

Maor Dickman (1):
      net/mlx5e: MPLSoUDP decap, fix check for unsupported matches

Maor Gottlieb (1):
      net/mlx5: Fix possible deadlock on rule deletion

Marc Zyngier (1):
      gpio: tegra186: Fix chip_data type confusion

Mario Limonciello (1):
      drm/amd: Check if ASPM is enabled from PCIe subsystem

Mateusz Palczewski (1):
      Revert "i40e: Fix reset bw limit when DCB enabled with 1 TC"

Matt Roper (1):
      drm/i915/dg2: Print PHY name properly on calibration error

Matthew Wilcox (Oracle) (1):
      mm/filemap: Fix handling of THPs in generic_file_buffered_read()

Mauri Sandberg (1):
      net: mv643xx_eth: process retval from of_get_mac_address

Maxim Levitsky (1):
      KVM: x86: nSVM: disallow userspace setting of MSR_AMD64_TSC_RATIO to non default value when tsc scaling disabled

Maxime Ripard (2):
      drm/edid: Always set RGB444
      drm/vc4: crtc: Fix runtime_pm reference counting

Md Haris Iqbal (2):
      RDMA/rtrs-clt: Fix possible double free in error case
      RDMA/rtrs-clt: Move free_permit from free_clt to rtrs_clt_close

Meir Lichtinger (1):
      net/mlx5: Update the list of the PCI supported devices

Miaohe Lin (1):
      memblock: use kfree() to release kmalloced memblock regions

Miaoqian Lin (1):
      iio: Fix error handling for PM

Michael Chan (3):
      bnxt_en: Fix offline ethtool selftest with RDMA enabled
      bnxt_en: Fix occasional ethtool -t loopback test failures
      bnxt_en: Increase firmware message response DMA wait time

Michal Koutný (1):
      cgroup-v1: Correct privileges check in release_agent writes

Michal Swiatkowski (1):
      ice: fix setting l4 port flag when adding filter

Michel Dänzer (1):
      drm/amd/display: For vblank_disable_immediate, check PSR is really used

Mike Marciniszyn (1):
      IB/qib: Fix duplicate sysfs directory name

Mikko Perttunen (1):
      gpu: host1x: Always return syncpoint value when waiting

Mårten Lindahl (1):
      driver core: Free DMA range map when device is released

Nicholas Kazlauskas (1):
      drm/amd/display: Fix stream->link_enc unassigned during stream removal

Nuno Sá (1):
      iio:imu:adis16480: fix buffering for devices with no burst mode

Oleksij Rempel (1):
      iio: adc: tsc2046: fix memory corruption by preventing array overflow

Oliver Graute (1):
      staging: fbtft: fb_st7789v: reset display before initialization

Oliver Neukum (3):
      sr9700: sanity check for packet length
      USB: zaurus: support another broken Zaurus
      CDC-NCM: avoid overflow in sanity checking

Ondrej Mosnacek (1):
      selinux: fix misuse of mutex_is_locked()

Pablo Neira Ayuso (3):
      netfilter: xt_socket: missing ifdef CONFIG_IP6_NF_IPTABLES dependency
      netfilter: nf_tables_offload: incorrect flow offload action array size
      netfilter: nf_tables: unregister flowtable hooks on netns exit

Pali Rohár (1):
      PCI: mvebu: Fix device enumeration regression

Paolo Abeni (4):
      mptcp: fix race in incoming ADD_ADDR option processing
      mptcp: add mibs counter for ignored incoming options
      selftests: mptcp: fix diag instability
      selftests: mptcp: be more conservative with cookie MPJ limits

Paul Blakey (2):
      openvswitch: Fix setting ipv6 fields causing hw csum failure
      net/sched: act_ct: Fix flow table lookup after ct clear or switching zones

Pavan Chebbi (1):
      bnxt_en: Fix incorrect multicast rx mask setting when not requested

Phil Elwell (1):
      sc16is7xx: Fix for incorrect data being transmitted

Prasad Kumpatla (1):
      regmap-irq: Update interrupt clear register for proper reset

Puma Hsu (1):
      xhci: re-initialize the HC during resume if HCE was set

Qu Wenruo (6):
      btrfs: defrag: don't try to merge regular extents with preallocated extents
      btrfs: defrag: don't defrag extents which are already at max capacity
      btrfs: defrag: remove an ambiguous condition for rejection
      btrfs: defrag: allow defrag_one_cluster() to skip large extent which is not a target
      btrfs: autodefrag: only scan one inode once
      btrfs: reduce extent threshold for autodefrag

Roi Dayan (2):
      net/mlx5e: TC, Reject rules with forward and drop actions
      net/mlx5e: TC, Reject rules with drop and modify hdr action

Samuel Holland (1):
      gpio: rockchip: Reset int_bothedge when changing trigger

Sean Anderson (1):
      pinctrl: k210: Fix bias-pull-up

Sean Nyekjaer (1):
      iio: accel: fxls8962af: add padding to regmap for SPI

Sebastian Andrzej Siewior (1):
      usb: dwc3: gadget: Let the interrupt handler disable bottom halves.

Sergey Shtylyov (1):
      ata: pata_hpt37x: disable primary channel on HPT371

Siarhei Volkau (1):
      clk: jz4725b: fix mmc0 clock gating

Slark Xiao (1):
      USB: serial: option: add support for DW5829e

Somnath Kotur (1):
      bnxt_en: Fix active FEC reporting to ethtool

Stefano Garzarella (2):
      vhost/vsock: don't check owner in vhost_vsock_stop() while releasing
      block: clear iocb->private in blkdev_bio_end_io_async()

Steven Rostedt (Google) (2):
      tracing: Have traceon and traceoff trigger honor the instance
      tracefs: Set the group ownership in apply_options() not parse_options()

Su Yue (2):
      btrfs: tree-checker: check item_size for inode_item
      btrfs: tree-checker: check item_size for dev_item

Sukadev Bhattiprolu (1):
      ibmvnic: schedule failover only if vioctl fails

Szymon Heidrich (1):
      USB: gadget: validate endpoint index for xilinx udc

Tao Liu (1):
      gso: do not skip outer ip header in case of ipip and net_failover

Tariq Toukan (1):
      net/mlx5e: kTLS, Use CHECKSUM_UNNECESSARY for device-offloaded packets

Tom Rix (2):
      ice: check the return of ice_ptp_gettimex64
      ice: initialize local variable 'tlv'

Ville Syrjälä (3):
      drm/i915: Widen the QGV point mask
      drm/i915: Correctly populate use_sagv_wm for all pipes
      drm/i915: Fix bw atomic check when switching between SAGV vs. no SAGV

Vladimir Oltean (1):
      net: dsa: avoid call to __dev_set_promiscuity() while rtnl_mutex isn't held

Xiaoke Wang (1):
      net: ll_temac: check the return value of devm_kmalloc()

Xin Long (1):
      ping: remove pr_err from ping_lookup

Yevgeny Kliteynik (4):
      net/mlx5: DR, Cache STE shadow memory
      net/mlx5: DR, Don't allow match on IP w/o matching on full ethertype/ip_version
      net/mlx5: DR, Fix the threshold that defines when pool sync is initiated
      net/mlx5: DR, Fix slab-out-of-bounds in mlx5_cmd_dr_create_fte

Yonghong Song (1):
      bpf: Fix a bpf_timer initialization issue

Zhang Qiao (1):
      cgroup/cpuset: Fix a race between cpuset_attach() and cpu hotplug

Zhengjun Xing (1):
      perf evlist: Fix failed to use cpu list for uncore events

Zhou Qingyang (1):
      spi: spi-zynq-qspi: Fix a NULL pointer dereference in zynq_qspi_exec_mem_op()

daniel.starke@siemens.com (7):
      tty: n_gsm: fix encoding of control signal octet bit DV
      tty: n_gsm: fix encoding of command/response bit
      tty: n_gsm: fix proper link termination after failed open
      tty: n_gsm: fix NULL pointer access due to DLCI release
      tty: n_gsm: fix wrong tty control line for flow control
      tty: n_gsm: fix wrong modem processing in convergence layer type 2
      tty: n_gsm: fix deadlock in gsmtty_open()

