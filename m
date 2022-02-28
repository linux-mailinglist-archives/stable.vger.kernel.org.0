Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B35AB4C7487
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 18:45:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234174AbiB1Rpl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 12:45:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239576AbiB1RoW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 12:44:22 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E8F988792;
        Mon, 28 Feb 2022 09:36:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2DCA7614C9;
        Mon, 28 Feb 2022 17:36:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2CC0C340E7;
        Mon, 28 Feb 2022 17:36:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646069795;
        bh=vwY1nBA75FkuSbg46uHg9u1XOFqtEOFKcPn2tnd9h0o=;
        h=From:To:Cc:Subject:Date:From;
        b=muAMgLcLUwlymHcFleTeHYID2Pcjy0ZRGubiowVP56r8zbPN4G9Dbt/EsfL9j4+2o
         cx5GuvqehvuwXxr0GiAT0LDGHTb6q1dX/AIrhDQEqjUqQ+JeAt8jffp/nkzYO/jwze
         kY5Xa3BhWqLseEhsQ9g1CaviltygCqsKpbu8EhFk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Subject: [PATCH 5.15 000/139] 5.15.26-rc1 review
Date:   Mon, 28 Feb 2022 18:22:54 +0100
Message-Id: <20220228172347.614588246@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.26-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.15.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.15.26-rc1
X-KernelTest-Deadline: 2022-03-02T17:24+00:00
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

This is the start of the stable review cycle for the 5.15.26 release.
There are 139 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 02 Mar 2022 17:20:16 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.26-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.15.26-rc1

Jacob Keller <jacob.e.keller@intel.com>
    ice: fix concurrent reset and removal of VFs

Brett Creeley <brett.creeley@intel.com>
    ice: Fix race conditions between virtchnl handling and VF ndo ops

Miaohe Lin <linmiaohe@huawei.com>
    memblock: use kfree() to release kmalloced memblock regions

Marc Zyngier <maz@kernel.org>
    gpio: tegra186: Fix chip_data type confusion

Sean Anderson <seanga2@gmail.com>
    pinctrl: k210: Fix bias-pull-up

Dan Carpenter <dan.carpenter@oracle.com>
    pinctrl: fix loop in k210_pinconf_get_drive()

daniel.starke@siemens.com <daniel.starke@siemens.com>
    tty: n_gsm: fix deadlock in gsmtty_open()

daniel.starke@siemens.com <daniel.starke@siemens.com>
    tty: n_gsm: fix wrong modem processing in convergence layer type 2

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

Damien Le Moal <damien.lemoal@opensource.wdc.com>
    riscv: fix nommu_k210_sdcard_defconfig

Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>
    IB/qib: Fix duplicate sysfs directory name

Jens Axboe <axboe@kernel.dk>
    tps6598x: clear int mask on probe failure

Oliver Graute <oliver.graute@kococonnector.com>
    staging: fbtft: fb_st7789v: reset display before initialization

Chuansheng Liu <chuansheng.liu@intel.com>
    thermal: int340x: fix memory leak in int3400_notify()

Jason Gunthorpe <jgg@ziepe.ca>
    RDMA/cma: Do not change route.addr.src_addr outside state checks

Dāvis Mosāns <davispuh@gmail.com>
    btrfs: prevent copying too big compressed lzo segment

Mårten Lindahl <marten.lindahl@axis.com>
    driver core: Free DMA range map when device is released

Christophe Kerello <christophe.kerello@foss.st.com>
    mtd: core: Fix a conflict between MTD and NVMEM on wp-gpios property

Christophe Kerello <christophe.kerello@foss.st.com>
    nvmem: core: Fix a conflict between MTD and NVMEM on wp-gpios property

Hongyu Xie <xiehongyu1@kylinos.cn>
    xhci: Prevent futile URB re-submissions due to incorrect return value.

Puma Hsu <pumahsu@google.com>
    xhci: re-initialize the HC during resume if HCE was set

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    usb: dwc3: gadget: Let the interrupt handler disable bottom halves.

Hans de Goede <hdegoede@redhat.com>
    usb: dwc3: pci: Fix Bay Trail phy GPIO mappings

Hans de Goede <hdegoede@redhat.com>
    usb: dwc3: pci: Add "snps,dis_u2_susphy_quirk" for Intel Bay Trail

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

Sean Nyekjaer <sean@geanix.com>
    iio: accel: fxls8962af: add padding to regmap for SPI

Cosmin Tanislav <demonsingur@gmail.com>
    iio: adc: ad7124: fix mask used for setting AIN_BUFP & AIN_BUFM bits

Oleksij Rempel <linux@rempel-privat.de>
    iio: adc: tsc2046: fix memory corruption by preventing array overflow

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    iio: adc: men_z188_adc: Fix a resource leak in an error handling path

Nuno Sá <nuno.sa@analog.com>
    iio:imu:adis16480: fix buffering for devices with no burst mode

Steven Rostedt (Google) <rostedt@goodmis.org>
    tracing: Have traceon and traceoff trigger honor the instance

Daniel Bristot de Oliveira <bristot@kernel.org>
    tracing: Dump stacktrace trigger to the corresponding instance

Bart Van Assche <bvanassche@acm.org>
    RDMA/ib_srp: Fix a deadlock

ChenXiaoSong <chenxiaosong2@huawei.com>
    configfs: fix a race in configfs_{,un}register_subsystem()

Michael Chan <michael.chan@broadcom.com>
    bnxt_en: Increase firmware message response DMA wait time

Md Haris Iqbal <haris.iqbal@ionos.com>
    RDMA/rtrs-clt: Move free_permit from free_clt to rtrs_clt_close

Md Haris Iqbal <haris.iqbal@ionos.com>
    RDMA/rtrs-clt: Fix possible double free in error case

Eric Dumazet <edumazet@google.com>
    net-timestamp: convert sk->sk_tskey to atomic_t

Prasad Kumpatla <quic_pkumpatl@quicinc.com>
    regmap-irq: Update interrupt clear register for proper reset

Samuel Holland <samuel@sholland.org>
    gpio: rockchip: Reset int_bothedge when changing trigger

Zhou Qingyang <zhou1615@umn.edu>
    spi: spi-zynq-qspi: Fix a NULL pointer dereference in zynq_qspi_exec_mem_op()

Maher Sanalla <msanalla@nvidia.com>
    net/mlx5: Update log_max_qp value to be 17 at most

Tariq Toukan <tariqt@nvidia.com>
    net/mlx5e: kTLS, Use CHECKSUM_UNNECESSARY for device-offloaded packets

Maor Dickman <maord@nvidia.com>
    net/mlx5e: MPLSoUDP decap, fix check for unsupported matches

Yevgeny Kliteynik <kliteyn@nvidia.com>
    net/mlx5: DR, Fix the threshold that defines when pool sync is initiated

Ariel Levkovich <lariel@nvidia.com>
    net/mlx5: Fix wrong limitation of metadata match on ecpf

Maor Gottlieb <maorg@nvidia.com>
    net/mlx5: Fix possible deadlock on rule deletion

Yevgeny Kliteynik <kliteyn@nvidia.com>
    net/mlx5: DR, Don't allow match on IP w/o matching on full ethertype/ip_version

Sukadev Bhattiprolu <sukadev@linux.ibm.com>
    ibmvnic: schedule failover only if vioctl fails

Yevgeny Kliteynik <kliteyn@nvidia.com>
    net/mlx5: DR, Cache STE shadow memory

Dan Carpenter <dan.carpenter@oracle.com>
    udp_tunnel: Fix end of loop test in udp_tunnel_nic_unregister()

Hans de Goede <hdegoede@redhat.com>
    surface: surface3_power: Fix battery readings on batteries without a serial number

Fabio M. De Francesco <fmdefrancesco@gmail.com>
    net/smc: Use a mutex for locking "struct smc_pnettable"

Florian Westphal <fw@strlen.de>
    netfilter: nf_tables: fix memory leak during stateful obj update

Baruch Siach <baruch.siach@siklu.com>
    net: mdio-ipq4019: add delay after clock enable

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    nfp: flower: Fix a potential leak in nfp_tunnel_add_shared_mac()

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: unregister flowtable hooks on netns exit

Christophe Leroy <christophe.leroy@csgroup.eu>
    net: Force inlining of checksum functions in net/checksum.h

Xiaoke Wang <xkernel.wang@foxmail.com>
    net: ll_temac: check the return value of devm_kmalloc()

Paul Blakey <paulb@nvidia.com>
    net/sched: act_ct: Fix flow table lookup after ct clear or switching zones

Matt Roper <matthew.d.roper@intel.com>
    drm/i915/dg2: Print PHY name properly on calibration error

Maxime Ripard <maxime@cerno.tech>
    drm/vc4: crtc: Fix runtime_pm reference counting

Gal Pressman <gal@nvidia.com>
    net/mlx5e: Fix wrong return value on ioctl EEPROM query failure

Maxime Ripard <maxime@cerno.tech>
    drm/edid: Always set RGB444

Paul Blakey <paulb@nvidia.com>
    openvswitch: Fix setting ipv6 fields causing hw csum failure

Mauri Sandberg <maukka@ext.kapsi.fi>
    net: mv643xx_eth: process retval from of_get_mac_address

Tao Liu <thomas.liu@ucloud.cn>
    gso: do not skip outer ip header in case of ipip and net_failover

Dan Carpenter <dan.carpenter@oracle.com>
    tipc: Fix end of loop tests for list_for_each_entry()

Christoph Hellwig <hch@lst.de>
    nvme: also mark passthrough-only namespaces ready in nvme_update_ns_info

Eric Dumazet <edumazet@google.com>
    net: __pskb_pull_tail() & pskb_carve_frag_list() drop_monitor friends

Eric Dumazet <edumazet@google.com>
    io_uring: add a schedule point in io_add_buffers()

Eric Dumazet <edumazet@google.com>
    bpf: Add schedule points in batch ops

Yonghong Song <yhs@fb.com>
    bpf: Fix a bpf_timer initialization issue

Felix Maurer <fmaurer@redhat.com>
    selftests: bpf: Check bpf_msg_push_data return value

Felix Maurer <fmaurer@redhat.com>
    bpf: Do not try bpf_msg_push_data with len 0

Kumar Kartikeya Dwivedi <memxor@gmail.com>
    bpf: Fix crash due to incorrect copy_map_value

Meir Lichtinger <meirl@nvidia.com>
    net/mlx5: Update the list of the PCI supported devices

Tom Rix <trix@redhat.com>
    ice: initialize local variable 'tlv'

Tom Rix <trix@redhat.com>
    ice: check the return of ice_ptp_gettimex64

Chris Mi <cmi@nvidia.com>
    net/mlx5: Fix tc max supported prio for nic mode

Guenter Roeck <linux@roeck-us.net>
    hwmon: Handle failure to register sensor with thermal zone correctly

Pavan Chebbi <pavan.chebbi@broadcom.com>
    bnxt_en: Fix incorrect multicast rx mask setting when not requested

Michael Chan <michael.chan@broadcom.com>
    bnxt_en: Fix offline ethtool selftest with RDMA enabled

Somnath Kotur <somnath.kotur@broadcom.com>
    bnxt_en: Fix active FEC reporting to ethtool

Manish Chopra <manishc@marvell.com>
    bnx2x: fix driver load from initrd

Paolo Abeni <pabeni@redhat.com>
    selftests: mptcp: be more conservative with cookie MPJ limits

Paolo Abeni <pabeni@redhat.com>
    selftests: mptcp: fix diag instability

Paolo Abeni <pabeni@redhat.com>
    mptcp: add mibs counter for ignored incoming options

Paolo Abeni <pabeni@redhat.com>
    mptcp: fix race in incoming ADD_ADDR option processing

Alexey Bayduraev <alexey.v.bayduraev@linux.intel.com>
    perf data: Fix double free in perf_session__delete()

Zhengjun Xing <zhengjun.xing@linux.intel.com>
    perf evlist: Fix failed to use cpu list for uncore events

Mikko Perttunen <mperttunen@nvidia.com>
    gpu: host1x: Always return syncpoint value when waiting

Mateusz Palczewski <mateusz.palczewski@intel.com>
    Revert "i40e: Fix reset bw limit when DCB enabled with 1 TC"

Xin Long <lucien.xin@gmail.com>
    ping: remove pr_err from ping_lookup

Jens Wiklander <jens.wiklander@linaro.org>
    optee: use driver internal tee_context for some rpc

Jens Wiklander <jens.wiklander@linaro.org>
    tee: export teedev_open() and teedev_close_context()

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables_offload: incorrect flow offload action array size

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: xt_socket: missing ifdef CONFIG_IP6_NF_IPTABLES dependency

Eric Dumazet <edumazet@google.com>
    netfilter: xt_socket: fix a typo in socket_mt_destroy()

Oliver Neukum <oneukum@suse.com>
    CDC-NCM: avoid overflow in sanity checking

Oliver Neukum <oneukum@suse.com>
    USB: zaurus: support another broken Zaurus

Oliver Neukum <oneukum@suse.com>
    sr9700: sanity check for packet length

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/i915: Fix bw atomic check when switching between SAGV vs. no SAGV

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/i915: Correctly populate use_sagv_wm for all pipes

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/i915: Widen the QGV point mask

Qiang Yu <qiang.yu@amd.com>
    drm/amdgpu: check vm ready by amdgpu_vm->evicting flag

Chen Gong <curry.gong@amd.com>
    drm/amdgpu: do not enable asic reset for raven2

Evan Quan <evan.quan@amd.com>
    drm/amdgpu: disable MMHUB PG for Picasso

Mario Limonciello <mario.limonciello@amd.com>
    drm/amd: Check if ASPM is enabled from PCIe subsystem

Evan Quan <evan.quan@amd.com>
    drm/amd/pm: fix some OEM SKU specific stability issues

Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>
    drm/amd/display: Protect update_bw_bounding_box FPU code.

Liang Zhang <zhangliang5@huawei.com>
    KVM: x86/mmu: make apf token non-zero to fix bug

Helge Deller <deller@gmx.de>
    parisc/unaligned: Fix ldw() and stw() unalignment handlers

Helge Deller <deller@gmx.de>
    parisc/unaligned: Fix fldd and fstd unaligned handlers on 32-bit kernel

Stefano Garzarella <sgarzare@redhat.com>
    vhost/vsock: don't check owner in vhost_vsock_stop() while releasing

Ondrej Mosnacek <omosnace@redhat.com>
    selinux: fix misuse of mutex_is_locked()

Dylan Yudaken <dylany@fb.com>
    io_uring: disallow modification of rsrc_data during quiesce

Jens Axboe <axboe@kernel.dk>
    io_uring: don't convert to jiffies for waiting on timeouts

Siarhei Volkau <lis8215@gmail.com>
    clk: jz4725b: fix mmc0 clock gating

Su Yue <l@damenly.su>
    btrfs: tree-checker: check item_size for dev_item

Su Yue <l@damenly.su>
    btrfs: tree-checker: check item_size for inode_item

Andy Lutomirski <luto@kernel.org>
    x86/ptrace: Fix xfpregs_set()'s incorrect xmm clearing

Michal Koutný <mkoutny@suse.com>
    cgroup-v1: Correct privileges check in release_agent writes

Zhang Qiao <zhangqiao22@huawei.com>
    cgroup/cpuset: Fix a race between cpuset_attach() and cpu hotplug

Matthew Wilcox (Oracle) <willy@infradead.org>
    mm/filemap: Fix handling of THPs in generic_file_buffered_read()


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/parisc/kernel/unaligned.c                     |  14 +--
 arch/riscv/configs/nommu_k210_sdcard_defconfig     |   2 +-
 arch/riscv/kernel/Makefile                         |   2 +
 arch/riscv/kernel/entry.S                          |  10 +-
 arch/riscv/kernel/trace_irq.c                      |  27 +++++
 arch/riscv/kernel/trace_irq.h                      |  11 ++
 arch/x86/kernel/fpu/regset.c                       |   9 +-
 arch/x86/kernel/ptrace.c                           |   4 +-
 arch/x86/kvm/mmu/mmu.c                             |  13 ++-
 drivers/ata/pata_hpt37x.c                          |  14 +++
 drivers/base/dd.c                                  |   5 +
 drivers/base/regmap/regmap-irq.c                   |  20 ++--
 drivers/clk/ingenic/jz4725b-cgu.c                  |   3 +-
 drivers/gpio/gpio-rockchip.c                       |  56 +++++-----
 drivers/gpio/gpio-tegra186.c                       |  14 ++-
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c            |   3 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c             |   9 +-
 drivers/gpu/drm/amd/amdgpu/soc15.c                 |   9 +-
 .../amd/display/dc/clk_mgr/dcn30/dcn30_clk_mgr.c   |   2 +
 drivers/gpu/drm/amd/display/dc/core/dc.c           |   7 +-
 .../drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c    |  32 +++++-
 drivers/gpu/drm/drm_edid.c                         |   2 +-
 drivers/gpu/drm/i915/display/intel_bw.c            |  18 +++-
 drivers/gpu/drm/i915/display/intel_bw.h            |   8 +-
 drivers/gpu/drm/i915/display/intel_snps_phy.c      |   2 +-
 drivers/gpu/drm/i915/intel_pm.c                    |  22 ++--
 drivers/gpu/drm/vc4/vc4_crtc.c                     |   8 +-
 drivers/gpu/host1x/syncpt.c                        |  19 +---
 drivers/hwmon/hwmon.c                              |  14 +--
 drivers/iio/accel/bmc150-accel-core.c              |   5 +-
 drivers/iio/accel/fxls8962af-core.c                |  12 ++-
 drivers/iio/accel/fxls8962af-i2c.c                 |   2 +-
 drivers/iio/accel/fxls8962af-spi.c                 |   2 +-
 drivers/iio/accel/fxls8962af.h                     |   3 +-
 drivers/iio/accel/kxcjk-1013.c                     |   5 +-
 drivers/iio/accel/mma9551.c                        |   5 +-
 drivers/iio/accel/mma9553.c                        |   5 +-
 drivers/iio/adc/ad7124.c                           |   2 +-
 drivers/iio/adc/men_z188_adc.c                     |   9 +-
 drivers/iio/adc/ti-tsc2046.c                       |   4 +-
 drivers/iio/gyro/bmg160_core.c                     |   5 +-
 drivers/iio/imu/adis16480.c                        |   7 +-
 drivers/iio/imu/kmx61.c                            |   5 +-
 drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c       |   6 +-
 drivers/iio/magnetometer/bmc150_magn.c             |   5 +-
 drivers/infiniband/core/cma.c                      |  40 ++++---
 drivers/infiniband/hw/qib/qib_sysfs.c              |   2 +-
 drivers/infiniband/ulp/rtrs/rtrs-clt.c             |  39 +++----
 drivers/infiniband/ulp/srp/ib_srp.c                |   6 +-
 drivers/mtd/mtdcore.c                              |   2 +
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c   |   3 +
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |  23 ++--
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c  |  15 ++-
 drivers/net/ethernet/broadcom/bnxt/bnxt_hwrm.c     |  12 ++-
 drivers/net/ethernet/broadcom/bnxt/bnxt_hwrm.h     |   2 +-
 drivers/net/ethernet/ibm/ibmvnic.c                 |   6 +-
 drivers/net/ethernet/intel/i40e/i40e_main.c        |  12 +--
 drivers/net/ethernet/intel/ice/ice.h               |   1 -
 drivers/net/ethernet/intel/ice/ice_common.c        |   2 +-
 drivers/net/ethernet/intel/ice/ice_main.c          |   2 +
 drivers/net/ethernet/intel/ice/ice_ptp.c           |   5 +-
 drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c   |  65 ++++++++---
 drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h   |   5 +
 drivers/net/ethernet/marvell/mv643xx_eth.c         |  24 +++--
 .../mellanox/mlx5/core/en/tc_tun_mplsoudp.c        |  28 ++---
 .../net/ethernet/mellanox/mlx5/core/en_ethtool.c   |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c    |   3 +-
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c |   4 -
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c  |   2 +
 .../ethernet/mellanox/mlx5/core/lib/fs_chains.c    |   3 +
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |   4 +-
 .../mellanox/mlx5/core/steering/dr_icm_pool.c      | 120 ++++++++++++++-------
 .../mellanox/mlx5/core/steering/dr_matcher.c       |  20 +---
 .../ethernet/mellanox/mlx5/core/steering/dr_ste.c  |  32 +++++-
 .../mellanox/mlx5/core/steering/dr_types.h         |  10 ++
 .../ethernet/mellanox/mlx5/core/steering/mlx5dr.h  |   5 +
 .../ethernet/netronome/nfp/flower/tunnel_conf.c    |   4 +-
 drivers/net/ethernet/xilinx/ll_temac_main.c        |   2 +
 drivers/net/mdio/mdio-ipq4019.c                    |   6 +-
 drivers/net/usb/cdc_ether.c                        |  12 +++
 drivers/net/usb/cdc_ncm.c                          |   8 +-
 drivers/net/usb/sr9700.c                           |   2 +-
 drivers/net/usb/zaurus.c                           |  12 +++
 drivers/nvme/host/core.c                           |   6 +-
 drivers/nvmem/core.c                               |   2 +-
 drivers/pinctrl/pinctrl-k210.c                     |   4 +-
 drivers/platform/surface/surface3_power.c          |  13 ++-
 drivers/spi/spi-zynq-qspi.c                        |   3 +
 drivers/staging/fbtft/fb_st7789v.c                 |   2 +
 drivers/tee/optee/core.c                           |   8 ++
 drivers/tee/optee/optee_private.h                  |   2 +
 drivers/tee/optee/rpc.c                            |   8 +-
 drivers/tee/tee_core.c                             |   6 +-
 .../intel/int340x_thermal/int3400_thermal.c        |   4 +
 drivers/tty/n_gsm.c                                |  45 +++++---
 drivers/tty/serial/sc16is7xx.c                     |   3 +
 drivers/usb/dwc2/core.h                            |   2 +
 drivers/usb/dwc2/drd.c                             |   6 +-
 drivers/usb/dwc3/dwc3-pci.c                        |  17 ++-
 drivers/usb/dwc3/gadget.c                          |   2 +
 drivers/usb/gadget/function/rndis.c                |   8 ++
 drivers/usb/gadget/function/rndis.h                |   1 +
 drivers/usb/gadget/udc/udc-xilinx.c                |   6 ++
 drivers/usb/host/xhci.c                            |  28 +++--
 drivers/usb/serial/ch341.c                         |   1 -
 drivers/usb/serial/option.c                        |  12 +++
 drivers/usb/typec/tipd/core.c                      |   7 +-
 drivers/vhost/vsock.c                              |  21 ++--
 fs/btrfs/lzo.c                                     |  11 ++
 fs/btrfs/tree-checker.c                            |  15 +++
 fs/configfs/dir.c                                  |  14 +++
 fs/io_uring.c                                      |  24 +++--
 fs/tracefs/inode.c                                 |   5 +-
 include/linux/bpf.h                                |   9 +-
 include/linux/nvmem-provider.h                     |   4 +-
 include/linux/tee_drv.h                            |  14 +++
 include/net/checksum.h                             |  50 +++++----
 include/net/netfilter/nf_tables.h                  |   2 +-
 include/net/netfilter/nf_tables_offload.h          |   2 -
 include/net/sock.h                                 |   4 +-
 kernel/bpf/syscall.c                               |   3 +
 kernel/cgroup/cgroup-v1.c                          |   6 +-
 kernel/cgroup/cpuset.c                             |   2 +
 kernel/trace/trace_events_trigger.c                |  59 ++++++++--
 mm/filemap.c                                       |   8 +-
 mm/memblock.c                                      |  10 +-
 net/can/j1939/transport.c                          |   2 +-
 net/core/filter.c                                  |   3 +
 net/core/skbuff.c                                  |   6 +-
 net/core/sock.c                                    |   4 +-
 net/ipv4/af_inet.c                                 |   5 +-
 net/ipv4/ip_output.c                               |   2 +-
 net/ipv4/ping.c                                    |   1 -
 net/ipv4/udp_tunnel_nic.c                          |   2 +-
 net/ipv6/ip6_offload.c                             |   2 +
 net/ipv6/ip6_output.c                              |   2 +-
 net/mptcp/mib.c                                    |   2 +
 net/mptcp/mib.h                                    |   2 +
 net/mptcp/pm.c                                     |   8 +-
 net/mptcp/pm_netlink.c                             |  19 +++-
 net/netfilter/nf_tables_api.c                      |  16 ++-
 net/netfilter/nf_tables_offload.c                  |   3 +-
 net/netfilter/nft_dup_netdev.c                     |   6 ++
 net/netfilter/nft_fwd_netdev.c                     |   6 ++
 net/netfilter/nft_immediate.c                      |  12 ++-
 net/netfilter/xt_socket.c                          |   4 +-
 net/openvswitch/actions.c                          |  46 ++++++--
 net/sched/act_ct.c                                 |   5 -
 net/smc/smc_pnet.c                                 |  42 ++++----
 net/smc/smc_pnet.h                                 |   2 +-
 net/tipc/name_table.c                              |   2 +-
 net/tipc/socket.c                                  |   2 +-
 security/selinux/ima.c                             |   4 +-
 tools/perf/util/data.c                             |   7 +-
 tools/perf/util/evlist-hybrid.c                    |   4 +-
 .../selftests/bpf/progs/test_sockmap_kern.h        |  26 +++--
 tools/testing/selftests/net/mptcp/diag.sh          |  44 ++++++--
 tools/testing/selftests/net/mptcp/mptcp_join.sh    |  15 ++-
 159 files changed, 1232 insertions(+), 523 deletions(-)


