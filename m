Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E86984C73BF
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 18:38:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233718AbiB1Rix (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 12:38:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238572AbiB1RiA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 12:38:00 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE0D556C25;
        Mon, 28 Feb 2022 09:33:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3EBC3614BB;
        Mon, 28 Feb 2022 17:33:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AFC1C340E7;
        Mon, 28 Feb 2022 17:33:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646069600;
        bh=I0xdECe77va4vYq1Y2k7r7jvEKGFHlXbBYaVXZbs5kg=;
        h=From:To:Cc:Subject:Date:From;
        b=zS31SbM+BS/3zsI9wRUwR21WDP14kC/PQABMsiP+KygK9YIviwIEOfKzSPVzhwQCt
         0oF/Ynfqi3+K/wfZpXZYjAgg50h/B2JncF1VT1rm6ponk4vaJPc4BEUbQt+nS6CaLu
         MWBp052kob7Ww0N5WYNXTS/VFi5BPPJNgP6sjK80=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Subject: [PATCH 5.10 00/80] 5.10.103-rc1 review
Date:   Mon, 28 Feb 2022 18:23:41 +0100
Message-Id: <20220228172311.789892158@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.103-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.103-rc1
X-KernelTest-Deadline: 2022-03-02T17:23+00:00
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

This is the start of the stable review cycle for the 5.10.103 release.
There are 80 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 02 Mar 2022 17:20:16 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.103-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.10.103-rc1

Miaohe Lin <linmiaohe@huawei.com>
    memblock: use kfree() to release kmalloced memblock regions

Marc Zyngier <maz@kernel.org>
    gpio: tegra186: Fix chip_data type confusion

daniel.starke@siemens.com <daniel.starke@siemens.com>
    tty: n_gsm: fix deadlock in gsmtty_open()

daniel.starke@siemens.com <daniel.starke@siemens.com>
    tty: n_gsm: fix wrong tty control line for flow control

daniel.starke@siemens.com <daniel.starke@siemens.com>
    tty: n_gsm: fix NULL pointer access due to DLCI release

daniel.starke@siemens.com <daniel.starke@siemens.com>
    tty: n_gsm: fix proper link termination after failed open

daniel.starke@siemens.com <daniel.starke@siemens.com>
    tty: n_gsm: fix encoding of control signal octet bit DV

Changbin Du <changbin.du@intel.com>
    riscv: fix oops caused by irqsoff latency tracer

Chuansheng Liu <chuansheng.liu@intel.com>
    thermal: int340x: fix memory leak in int3400_notify()

Jason Gunthorpe <jgg@ziepe.ca>
    RDMA/cma: Do not change route.addr.src_addr outside state checks

Mårten Lindahl <marten.lindahl@axis.com>
    driver core: Free DMA range map when device is released

Hongyu Xie <xiehongyu1@kylinos.cn>
    xhci: Prevent futile URB re-submissions due to incorrect return value.

Puma Hsu <pumahsu@google.com>
    xhci: re-initialize the HC during resume if HCE was set

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    usb: dwc3: gadget: Let the interrupt handler disable bottom halves.

Hans de Goede <hdegoede@redhat.com>
    usb: dwc3: pci: Fix Bay Trail phy GPIO mappings

Fabrice Gasnier <fabrice.gasnier@foss.st.com>
    usb: dwc2: drd: fix soft connect when gadget is unconfigured

Daniele Palmas <dnlplm@gmail.com>
    USB: serial: option: add Telit LE910R1 compositions

Slark Xiao <slark_xiao@163.com>
    USB: serial: option: add support for DW5829e

Steven Rostedt (Google) <rostedt@goodmis.org>
    tracefs: Set the group ownership in apply_options() not parse_options()

Szymon Heidrich <szymon.heidrich@gmail.com>
    USB: gadget: validate endpoint index for xilinx udc

Daehwan Jung <dh10.jung@samsung.com>
    usb: gadget: rndis: add spinlock for rndis response list

Dmytro Bagrii <dimich.dmb@gmail.com>
    Revert "USB: serial: ch341: add new Product ID for CH341A"

Sergey Shtylyov <s.shtylyov@omp.ru>
    ata: pata_hpt37x: disable primary channel on HPT371

Phil Elwell <phil@raspberrypi.com>
    sc16is7xx: Fix for incorrect data being transmitted

Miaoqian Lin <linmq006@gmail.com>
    iio: Fix error handling for PM

Lorenzo Bianconi <lorenzo@kernel.org>
    iio: imu: st_lsm6dsx: wait for settling time in st_lsm6dsx_read_oneshot

Cosmin Tanislav <demonsingur@gmail.com>
    iio: adc: ad7124: fix mask used for setting AIN_BUFP & AIN_BUFM bits

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    iio: adc: men_z188_adc: Fix a resource leak in an error handling path

Steven Rostedt (Google) <rostedt@goodmis.org>
    tracing: Have traceon and traceoff trigger honor the instance

Bart Van Assche <bvanassche@acm.org>
    RDMA/ib_srp: Fix a deadlock

ChenXiaoSong <chenxiaosong2@huawei.com>
    configfs: fix a race in configfs_{,un}register_subsystem()

Md Haris Iqbal <haris.iqbal@ionos.com>
    RDMA/rtrs-clt: Move free_permit from free_clt to rtrs_clt_close

Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
    RDMA/rtrs-clt: Kill wait_for_inflight_permits

Md Haris Iqbal <haris.iqbal@ionos.com>
    RDMA/rtrs-clt: Fix possible double free in error case

Prasad Kumpatla <quic_pkumpatl@quicinc.com>
    regmap-irq: Update interrupt clear register for proper reset

Zhou Qingyang <zhou1615@umn.edu>
    spi: spi-zynq-qspi: Fix a NULL pointer dereference in zynq_qspi_exec_mem_op()

Tariq Toukan <tariqt@nvidia.com>
    net/mlx5e: kTLS, Use CHECKSUM_UNNECESSARY for device-offloaded packets

Ariel Levkovich <lariel@nvidia.com>
    net/mlx5: Fix wrong limitation of metadata match on ecpf

Maor Gottlieb <maorg@nvidia.com>
    net/mlx5: Fix possible deadlock on rule deletion

Dan Carpenter <dan.carpenter@oracle.com>
    udp_tunnel: Fix end of loop test in udp_tunnel_nic_unregister()

Hans de Goede <hdegoede@redhat.com>
    surface: surface3_power: Fix battery readings on batteries without a serial number

Fabio M. De Francesco <fmdefrancesco@gmail.com>
    net/smc: Use a mutex for locking "struct smc_pnettable"

Florian Westphal <fw@strlen.de>
    netfilter: nf_tables: fix memory leak during stateful obj update

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    nfp: flower: Fix a potential leak in nfp_tunnel_add_shared_mac()

Christophe Leroy <christophe.leroy@csgroup.eu>
    net: Force inlining of checksum functions in net/checksum.h

Xiaoke Wang <xkernel.wang@foxmail.com>
    net: ll_temac: check the return value of devm_kmalloc()

Paul Blakey <paulb@nvidia.com>
    net/sched: act_ct: Fix flow table lookup after ct clear or switching zones

Gal Pressman <gal@nvidia.com>
    net/mlx5e: Fix wrong return value on ioctl EEPROM query failure

Maxime Ripard <maxime@cerno.tech>
    drm/edid: Always set RGB444

Paul Blakey <paulb@nvidia.com>
    openvswitch: Fix setting ipv6 fields causing hw csum failure

Tao Liu <thomas.liu@ucloud.cn>
    gso: do not skip outer ip header in case of ipip and net_failover

Dan Carpenter <dan.carpenter@oracle.com>
    tipc: Fix end of loop tests for list_for_each_entry()

Eric Dumazet <edumazet@google.com>
    net: __pskb_pull_tail() & pskb_carve_frag_list() drop_monitor friends

Eric Dumazet <edumazet@google.com>
    io_uring: add a schedule point in io_add_buffers()

Eric Dumazet <edumazet@google.com>
    bpf: Add schedule points in batch ops

Felix Maurer <fmaurer@redhat.com>
    selftests: bpf: Check bpf_msg_push_data return value

Felix Maurer <fmaurer@redhat.com>
    bpf: Do not try bpf_msg_push_data with len 0

Guenter Roeck <linux@roeck-us.net>
    hwmon: Handle failure to register sensor with thermal zone correctly

Somnath Kotur <somnath.kotur@broadcom.com>
    bnxt_en: Fix active FEC reporting to ethtool

Manish Chopra <manishc@marvell.com>
    bnx2x: fix driver load from initrd

Alexey Bayduraev <alexey.v.bayduraev@linux.intel.com>
    perf data: Fix double free in perf_session__delete()

Xin Long <lucien.xin@gmail.com>
    ping: remove pr_err from ping_lookup

Jens Wiklander <jens.wiklander@linaro.org>
    optee: use driver internal tee_context for some rpc

Jens Wiklander <jens.wiklander@linaro.org>
    tee: export teedev_open() and teedev_close_context()

Brian Geffon <bgeffon@google.com>
    x86/fpu: Correct pkru/xstate inconsistency

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables_offload: incorrect flow offload action array size

Oliver Neukum <oneukum@suse.com>
    CDC-NCM: avoid overflow in sanity checking

Oliver Neukum <oneukum@suse.com>
    USB: zaurus: support another broken Zaurus

Oliver Neukum <oneukum@suse.com>
    sr9700: sanity check for packet length

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/i915: Correctly populate use_sagv_wm for all pipes

Qiang Yu <qiang.yu@amd.com>
    drm/amdgpu: check vm ready by amdgpu_vm->evicting flag

Evan Quan <evan.quan@amd.com>
    drm/amdgpu: disable MMHUB PG for Picasso

Liang Zhang <zhangliang5@huawei.com>
    KVM: x86/mmu: make apf token non-zero to fix bug

Helge Deller <deller@gmx.de>
    parisc/unaligned: Fix ldw() and stw() unalignment handlers

Helge Deller <deller@gmx.de>
    parisc/unaligned: Fix fldd and fstd unaligned handlers on 32-bit kernel

Stefano Garzarella <sgarzare@redhat.com>
    vhost/vsock: don't check owner in vhost_vsock_stop() while releasing

Siarhei Volkau <lis8215@gmail.com>
    clk: jz4725b: fix mmc0 clock gating

Su Yue <l@damenly.su>
    btrfs: tree-checker: check item_size for dev_item

Su Yue <l@damenly.su>
    btrfs: tree-checker: check item_size for inode_item

Zhang Qiao <zhangqiao22@huawei.com>
    cgroup/cpuset: Fix a race between cpuset_attach() and cpu hotplug


-------------

Diffstat:

 Makefile                                           |  4 +-
 arch/parisc/kernel/unaligned.c                     | 14 +++---
 arch/riscv/kernel/Makefile                         |  2 +
 arch/riscv/kernel/entry.S                          | 10 ++--
 arch/riscv/kernel/trace_irq.c                      | 27 +++++++++++
 arch/riscv/kernel/trace_irq.h                      | 11 +++++
 arch/x86/include/asm/fpu/internal.h                | 13 +++--
 arch/x86/kernel/process_32.c                       |  6 +--
 arch/x86/kernel/process_64.c                       |  6 +--
 arch/x86/kvm/mmu/mmu.c                             | 13 ++++-
 drivers/ata/pata_hpt37x.c                          | 14 ++++++
 drivers/base/dd.c                                  |  5 ++
 drivers/base/regmap/regmap-irq.c                   | 20 +++-----
 drivers/clk/ingenic/jz4725b-cgu.c                  |  3 +-
 drivers/gpio/gpio-tegra186.c                       | 14 ++++--
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c             |  9 +++-
 drivers/gpu/drm/amd/amdgpu/soc15.c                 |  5 +-
 drivers/gpu/drm/drm_edid.c                         |  2 +-
 drivers/gpu/drm/i915/intel_pm.c                    | 22 ++++-----
 drivers/hwmon/hwmon.c                              | 14 +++---
 drivers/iio/accel/bmc150-accel-core.c              |  5 +-
 drivers/iio/accel/kxcjk-1013.c                     |  5 +-
 drivers/iio/accel/mma9551.c                        |  5 +-
 drivers/iio/accel/mma9553.c                        |  5 +-
 drivers/iio/adc/ad7124.c                           |  2 +-
 drivers/iio/adc/men_z188_adc.c                     |  9 +++-
 drivers/iio/gyro/bmg160_core.c                     |  5 +-
 drivers/iio/imu/kmx61.c                            |  5 +-
 drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c       |  6 ++-
 drivers/iio/magnetometer/bmc150_magn.c             |  5 +-
 drivers/infiniband/core/cma.c                      | 40 +++++++++-------
 drivers/infiniband/ulp/rtrs/rtrs-clt.c             | 56 +++++++++++-----------
 drivers/infiniband/ulp/srp/ib_srp.c                |  6 ++-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c   |  3 ++
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c  |  3 ++
 .../net/ethernet/mellanox/mlx5/core/en_ethtool.c   |  2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c    |  3 +-
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c |  4 --
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c  |  2 +
 .../ethernet/netronome/nfp/flower/tunnel_conf.c    |  4 +-
 drivers/net/ethernet/xilinx/ll_temac_main.c        |  2 +
 drivers/net/usb/cdc_ether.c                        | 12 +++++
 drivers/net/usb/cdc_ncm.c                          |  8 ++--
 drivers/net/usb/sr9700.c                           |  2 +-
 drivers/net/usb/zaurus.c                           | 12 +++++
 drivers/platform/x86/surface3_power.c              | 13 +++--
 drivers/spi/spi-zynq-qspi.c                        |  3 ++
 drivers/tee/optee/core.c                           |  8 ++++
 drivers/tee/optee/optee_private.h                  |  2 +
 drivers/tee/optee/rpc.c                            |  8 ++--
 drivers/tee/tee_core.c                             |  6 ++-
 .../intel/int340x_thermal/int3400_thermal.c        |  4 ++
 drivers/tty/n_gsm.c                                | 22 ++++++---
 drivers/tty/serial/sc16is7xx.c                     |  3 ++
 drivers/usb/dwc2/core.h                            |  2 +
 drivers/usb/dwc2/drd.c                             |  6 ++-
 drivers/usb/dwc3/dwc3-pci.c                        |  4 +-
 drivers/usb/dwc3/gadget.c                          |  2 +
 drivers/usb/gadget/function/rndis.c                |  8 ++++
 drivers/usb/gadget/function/rndis.h                |  1 +
 drivers/usb/gadget/udc/udc-xilinx.c                |  6 +++
 drivers/usb/host/xhci.c                            | 28 +++++++----
 drivers/usb/serial/ch341.c                         |  1 -
 drivers/usb/serial/option.c                        | 12 +++++
 drivers/vhost/vsock.c                              | 21 +++++---
 fs/btrfs/tree-checker.c                            | 15 ++++++
 fs/configfs/dir.c                                  | 14 ++++++
 fs/io_uring.c                                      |  1 +
 fs/tracefs/inode.c                                 |  5 +-
 include/linux/tee_drv.h                            | 14 ++++++
 include/net/checksum.h                             | 48 +++++++++++--------
 include/net/netfilter/nf_tables.h                  |  2 +-
 include/net/netfilter/nf_tables_offload.h          |  2 -
 kernel/bpf/syscall.c                               |  3 ++
 kernel/cgroup/cpuset.c                             |  2 +
 kernel/trace/trace_events_trigger.c                | 52 +++++++++++++++++---
 mm/memblock.c                                      | 10 +++-
 net/core/filter.c                                  |  3 ++
 net/core/skbuff.c                                  |  4 +-
 net/ipv4/af_inet.c                                 |  5 +-
 net/ipv4/ping.c                                    |  1 -
 net/ipv4/udp_tunnel_nic.c                          |  2 +-
 net/ipv6/ip6_offload.c                             |  2 +
 net/netfilter/nf_tables_api.c                      | 13 +++--
 net/netfilter/nf_tables_offload.c                  |  3 +-
 net/netfilter/nft_dup_netdev.c                     |  6 +++
 net/netfilter/nft_fwd_netdev.c                     |  6 +++
 net/netfilter/nft_immediate.c                      | 12 ++++-
 net/openvswitch/actions.c                          | 46 ++++++++++++++----
 net/sched/act_ct.c                                 |  5 --
 net/smc/smc_pnet.c                                 | 42 ++++++++--------
 net/smc/smc_pnet.h                                 |  2 +-
 net/tipc/name_table.c                              |  2 +-
 net/tipc/socket.c                                  |  2 +-
 tools/perf/util/data.c                             |  7 ++-
 .../selftests/bpf/progs/test_sockmap_kern.h        | 26 ++++++----
 96 files changed, 672 insertions(+), 270 deletions(-)


