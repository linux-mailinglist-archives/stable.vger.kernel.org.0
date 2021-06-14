Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA8CD3A61CC
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 12:50:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233657AbhFNKvt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 06:51:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:51420 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233598AbhFNKty (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 06:49:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 02D0861418;
        Mon, 14 Jun 2021 10:38:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623667103;
        bh=oKtC4ODZ3ct2OkMjB5z9u4wK8vHfBSk+i1Gkpk0XhXs=;
        h=From:To:Cc:Subject:Date:From;
        b=ayEog0NmMYUIneaPPdTHK9euSvURI5AHH9+ae0Ij9xtjDARDGcOKf3YlSqLhjHyyN
         t9Va3+VKS65fddfAHt40884+lEp3T1Yx7tcAqbuMDur60rkZu5jvziDiPzY/zYfmd9
         le3CodzlfCRDRXLfkyu6K2Y8Lyx+lA163Sr/OAis=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 5.4 00/84] 5.4.126-rc1 review
Date:   Mon, 14 Jun 2021 12:26:38 +0200
Message-Id: <20210614102646.341387537@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.126-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.126-rc1
X-KernelTest-Deadline: 2021-06-16T10:26+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.4.126 release.
There are 84 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 16 Jun 2021 10:26:30 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.126-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.4.126-rc1

Liangyan <liangyan.peng@linux.alibaba.com>
    tracing: Correct the length check which causes memory corruption

Steven Rostedt (VMware) <rostedt@goodmis.org>
    ftrace: Do not blindly read the ip address in ftrace_bug()

Ming Lei <ming.lei@redhat.com>
    scsi: core: Only put parent device if host state differs from SHOST_CREATED

Ming Lei <ming.lei@redhat.com>
    scsi: core: Put .shost_dev in failure path if host state changes to RUNNING

Ming Lei <ming.lei@redhat.com>
    scsi: core: Fix failure handling of scsi_add_host_with_dma()

Ming Lei <ming.lei@redhat.com>
    scsi: core: Fix error handling of scsi_host_alloc()

Dai Ngo <dai.ngo@oracle.com>
    NFSv4: nfs4_proc_set_acl needs to restore NFS_CAP_UIDGID_NOMAP on error.

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFSv4: Fix second deadlock in nfs4_evict_inode()

Anna Schumaker <Anna.Schumaker@Netapp.com>
    NFS: Fix use-after-free in nfs4_init_client()

Paolo Bonzini <pbonzini@redhat.com>
    kvm: fix previous commit for 32-bit builds

Leo Yan <leo.yan@linaro.org>
    perf session: Correct buffer copying when peeking events

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFSv4: Fix deadlock between nfs4_evict_inode() and nfs4_opendata_get_inode()

Dan Carpenter <dan.carpenter@oracle.com>
    NFS: Fix a potential NULL dereference in nfs_get_client()

Alaa Hleihel <alaa@nvidia.com>
    IB/mlx5: Fix initializing CQ fragments buffer

Sean Christopherson <seanjc@google.com>
    KVM: x86: Ensure liveliness of nested VM-Enter fail tracepoint message

Vincent Guittot <vincent.guittot@linaro.org>
    sched/fair: Make sure to update tg contrib for blocked load

Marco Elver <elver@google.com>
    perf: Fix data race between pin_count increment/decrement

Nathan Chancellor <nathan@kernel.org>
    vmlinux.lds.h: Avoid orphan section with !SMP

Shay Drory <shayd@nvidia.com>
    RDMA/mlx4: Do not map the core_clock page to user space unless enabled

Kamal Heib <kamalheib1@gmail.com>
    RDMA/ipoib: Fix warning caused by destroying non-initial netns

Bjorn Andersson <bjorn.andersson@linaro.org>
    usb: typec: mux: Fix copy-paste mistake in typec_mux_match

Dmitry Osipenko <digetx@gmail.com>
    regulator: max77620: Use device_set_of_node_from_dev()

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    regulator: core: resolve supply for boot-on/always-on regulators

Maciej Żenczykowski <maze@google.com>
    usb: fix various gadget panics on 10gbps cabling

Maciej Żenczykowski <maze@google.com>
    usb: fix various gadgets null ptr deref on 10gbps cabling.

Linyu Yuan <linyyuan@codeaurora.com>
    usb: gadget: eem: fix wrong eem header operation

Stefan Agner <stefan@agner.ch>
    USB: serial: cp210x: fix alternate function for CP2102N QFN20

Johan Hovold <johan@kernel.org>
    USB: serial: quatech2: fix control-request directions

Alexandre GRIVEAUX <agriveaux@deutnet.info>
    USB: serial: omninet: add device id for Zyxel Omni 56K Plus

George McCollister <george.mccollister@gmail.com>
    USB: serial: ftdi_sio: add NovaTech OrionMX product ID

Wesley Cheng <wcheng@codeaurora.org>
    usb: gadget: f_fs: Ensure io_completion_wq is idle during unbind

Mayank Rana <mrana@codeaurora.org>
    usb: typec: ucsi: Clear PPM capability data in ucsi_init() error path

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    usb: typec: wcove: Use LE to CPU conversion when accessing msg->header

Thomas Petazzoni <thomas.petazzoni@bootlin.com>
    usb: musb: fix MUSB_QUIRK_B_DISCONNECT_99 handling

Marian-Cristian Rotariu <marian.c.rotariu@gmail.com>
    usb: dwc3: ep0: fix NULL pointer exception

Jack Pham <jackp@codeaurora.org>
    usb: dwc3: debugfs: Add and remove endpoint dirs dynamically

Kyle Tso <kyletso@google.com>
    usb: pd: Set PD_T_SINK_WAIT_CAP to 310ms

Maciej Żenczykowski <maze@google.com>
    usb: f_ncm: only first packet of aggregate needs to start timer

Maciej Żenczykowski <maze@google.com>
    USB: f_ncm: ncm_bitrate (speed) is unsigned

Alexander Kuznetsov <wwfq@yandex-team.ru>
    cgroup1: don't allow '\n' in renaming

Nikolay Borisov <nborisov@suse.com>
    btrfs: promote debugging asserts to full-fledged checks in validate_super

Ritesh Harjani <riteshh@linux.ibm.com>
    btrfs: return value from btrfs_mark_extent_written() in case of error

Wenli Looi <wlooi@ucalgary.ca>
    staging: rtl8723bs: Fix uninitialized variables

Paolo Bonzini <pbonzini@redhat.com>
    kvm: avoid speculation-based attacks from out-of-range memslot accesses

Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>
    drm: Lock pointer access in drm_master_release()

Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>
    drm: Fix use-after-free read in drm_getunique()

Lukas Wunner <lukas@wunner.de>
    spi: bcm2835: Fix out-of-bounds access with more than 4 slaves

Arvind Sankar <nivedita@alum.mit.edu>
    x86/boot: Add .text.* to setup.ld

Chris Packham <chris.packham@alliedtelesis.co.nz>
    i2c: mpc: implement erratum A-004447 workaround

Chris Packham <chris.packham@alliedtelesis.co.nz>
    i2c: mpc: Make use of i2c_recover_bus()

Lukas Wunner <lukas@wunner.de>
    spi: Cleanup on failure of initial setup

Saravana Kannan <saravanak@google.com>
    spi: Don't have controller clean up spi device before driver unbind

Chris Packham <chris.packham@alliedtelesis.co.nz>
    powerpc/fsl: set fsl,i2c-erratum-a004447 flag for P1010 i2c controllers

Chris Packham <chris.packham@alliedtelesis.co.nz>
    powerpc/fsl: set fsl,i2c-erratum-a004447 flag for P2041 i2c controllers

Sagi Grimberg <sagi@grimberg.me>
    nvme-tcp: remove incorrect Kconfig dep in BLK_DEV_NVME

Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
    bnx2x: Fix missing error code in bnx2x_iov_init_one()

John Keeping <john@metanate.com>
    dm verity: fix require_signatures module_param permissions

Tiezhu Yang <yangtiezhu@loongson.cn>
    MIPS: Fix kernel hang under FUNCTION_GRAPH_TRACER and PREEMPT_TRACER

Hannes Reinecke <hare@suse.de>
    nvme-fabrics: decode host pathing error for connect

George McCollister <george.mccollister@gmail.com>
    net: dsa: microchip: enable phy errata workaround on 9567

Saubhik Mukherjee <saubhik.mukherjee@gmail.com>
    net: appletalk: cops: Fix data race in cops_probe1

Zong Li <zong.li@sifive.com>
    net: macb: ensure the device is available before accessing GEMGXL control registers

Dmitry Bogdanov <d.bogdanov@yadro.com>
    scsi: target: qla2xxx: Wait for stop_phase1 at WWN removal

Yang Yingliang <yangyingliang@huawei.com>
    scsi: hisi_sas: Drop free_irq() of devm_request_irq() allocated irq

Matt Wang <wwentao@vmware.com>
    scsi: vmw_pvscsi: Set correct residual data length

Javed Hasan <jhasan@marvell.com>
    scsi: bnx2fc: Return failure if io_req is already in ABTS processing

Rao Shoaib <rao.shoaib@oracle.com>
    RDS tcp loopback connection can hang

Zheyu Ma <zheyuma97@gmail.com>
    net/qla3xxx: fix schedule while atomic in ql_sem_spinlock

Sergey Senozhatsky <senozhatsky@chromium.org>
    wq: handle VM suspension in stall detection

Shakeel Butt <shakeelb@google.com>
    cgroup: disable controllers at parse time

Dan Carpenter <dan.carpenter@oracle.com>
    net: mdiobus: get rid of a BUG_ON()

Johannes Berg <johannes.berg@intel.com>
    netlink: disable IRQs for netlink_lock_table()

Johannes Berg <johannes.berg@intel.com>
    bonding: init notify_work earlier to avoid uninitialized use

Zheyu Ma <zheyuma97@gmail.com>
    isdn: mISDN: netjet: Fix crash in nj_probe:

Chunyan Zhang <chunyan.zhang@unisoc.com>
    spi: sprd: Add missing MODULE_DEVICE_TABLE

Zou Wei <zou_wei@huawei.com>
    ASoC: sti-sas: add missing MODULE_DEVICE_TABLE

Eric Farman <farman@linux.ibm.com>
    vfio-ccw: Serialize FSM IDLE state with I/O completion

Hans de Goede <hdegoede@redhat.com>
    ASoC: Intel: bytcr_rt5640: Add quirk for the Lenovo Miix 3-830 tablet

Hans de Goede <hdegoede@redhat.com>
    ASoC: Intel: bytcr_rt5640: Add quirk for the Glavey TM800A550L tablet

Dinghao Liu <dinghao.liu@zju.edu.cn>
    usb: cdns3: Fix runtime PM imbalance on error

Jeimon <jjjinmeng.zhou@gmail.com>
    net/nfc/rawsock.c: fix a permission check bug

Saravana Kannan <saravanak@google.com>
    spi: Fix spi device unregister flow

Marco Felsch <m.felsch@pengutronix.de>
    ASoC: max98088: fix ni clock divider calculation

Kees Cook <keescook@chromium.org>
    proc: Track /proc/$pid/attr/ opener mm_struct


-------------

Diffstat:

 Makefile                                          |  4 +-
 arch/mips/lib/mips-atomic.c                       | 12 +--
 arch/powerpc/boot/dts/fsl/p1010si-post.dtsi       |  8 ++
 arch/powerpc/boot/dts/fsl/p2041si-post.dtsi       | 16 ++++
 arch/x86/boot/setup.ld                            |  2 +-
 arch/x86/kvm/trace.h                              |  6 +-
 drivers/gpu/drm/drm_auth.c                        |  3 +-
 drivers/gpu/drm/drm_ioctl.c                       |  9 ++-
 drivers/i2c/busses/i2c-mpc.c                      | 95 ++++++++++++++++++++++-
 drivers/infiniband/hw/mlx4/main.c                 |  5 +-
 drivers/infiniband/hw/mlx5/cq.c                   |  9 +--
 drivers/infiniband/ulp/ipoib/ipoib_netlink.c      |  1 +
 drivers/isdn/hardware/mISDN/netjet.c              |  1 -
 drivers/md/dm-verity-verify-sig.c                 |  2 +-
 drivers/net/appletalk/cops.c                      |  4 +-
 drivers/net/bonding/bond_main.c                   |  2 +-
 drivers/net/dsa/microchip/ksz9477.c               |  1 +
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c |  4 +-
 drivers/net/ethernet/cadence/macb_main.c          |  3 +
 drivers/net/ethernet/mellanox/mlx4/fw.c           |  3 +
 drivers/net/ethernet/mellanox/mlx4/fw.h           |  1 +
 drivers/net/ethernet/mellanox/mlx4/main.c         |  6 ++
 drivers/net/ethernet/qlogic/qla3xxx.c             |  2 +-
 drivers/net/phy/mdio_bus.c                        |  3 +-
 drivers/nvme/host/Kconfig                         |  3 +-
 drivers/nvme/host/fabrics.c                       |  5 ++
 drivers/regulator/core.c                          |  6 ++
 drivers/regulator/max77620-regulator.c            |  7 ++
 drivers/s390/cio/vfio_ccw_drv.c                   | 12 ++-
 drivers/scsi/bnx2fc/bnx2fc_io.c                   |  1 +
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c            |  8 +-
 drivers/scsi/hosts.c                              | 47 ++++++-----
 drivers/scsi/qla2xxx/qla_target.c                 |  2 +
 drivers/scsi/vmw_pvscsi.c                         |  8 +-
 drivers/spi/spi-bcm2835.c                         | 10 ++-
 drivers/spi/spi-bitbang.c                         | 18 ++++-
 drivers/spi/spi-fsl-spi.c                         |  4 +
 drivers/spi/spi-omap-uwire.c                      |  9 ++-
 drivers/spi/spi-omap2-mcspi.c                     | 39 ++++++----
 drivers/spi/spi-pxa2xx.c                          |  9 ++-
 drivers/spi/spi-sprd.c                            |  1 +
 drivers/spi/spi.c                                 | 20 +++--
 drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c |  2 +-
 drivers/usb/cdns3/gadget.c                        |  4 +-
 drivers/usb/dwc3/debug.h                          |  3 +
 drivers/usb/dwc3/debugfs.c                        | 21 +----
 drivers/usb/dwc3/ep0.c                            |  3 +
 drivers/usb/dwc3/gadget.c                         |  3 +
 drivers/usb/gadget/config.c                       |  8 ++
 drivers/usb/gadget/function/f_ecm.c               |  2 +-
 drivers/usb/gadget/function/f_eem.c               |  6 +-
 drivers/usb/gadget/function/f_fs.c                |  3 +
 drivers/usb/gadget/function/f_hid.c               |  3 +-
 drivers/usb/gadget/function/f_loopback.c          |  2 +-
 drivers/usb/gadget/function/f_ncm.c               | 10 +--
 drivers/usb/gadget/function/f_printer.c           |  3 +-
 drivers/usb/gadget/function/f_rndis.c             |  2 +-
 drivers/usb/gadget/function/f_serial.c            |  2 +-
 drivers/usb/gadget/function/f_sourcesink.c        |  3 +-
 drivers/usb/gadget/function/f_subset.c            |  2 +-
 drivers/usb/gadget/function/f_tcm.c               |  3 +-
 drivers/usb/musb/musb_core.c                      |  3 +-
 drivers/usb/serial/cp210x.c                       | 20 ++++-
 drivers/usb/serial/ftdi_sio.c                     |  1 +
 drivers/usb/serial/ftdi_sio_ids.h                 |  1 +
 drivers/usb/serial/omninet.c                      |  2 +
 drivers/usb/serial/quatech2.c                     |  6 +-
 drivers/usb/typec/mux.c                           |  2 +-
 drivers/usb/typec/tcpm/wcove.c                    |  2 +-
 drivers/usb/typec/ucsi/ucsi.c                     |  1 +
 fs/btrfs/disk-io.c                                | 26 +++++--
 fs/btrfs/file.c                                   |  4 +-
 fs/nfs/client.c                                   |  2 +-
 fs/nfs/nfs4_fs.h                                  |  1 +
 fs/nfs/nfs4client.c                               |  2 +-
 fs/nfs/nfs4proc.c                                 | 29 ++++++-
 fs/proc/base.c                                    |  9 ++-
 include/asm-generic/vmlinux.lds.h                 |  1 +
 include/linux/kvm_host.h                          | 10 ++-
 include/linux/mlx4/device.h                       |  1 +
 include/linux/usb/pd.h                            |  2 +-
 kernel/cgroup/cgroup-v1.c                         |  4 +
 kernel/cgroup/cgroup.c                            | 13 ++--
 kernel/events/core.c                              |  2 +
 kernel/sched/fair.c                               |  2 +-
 kernel/trace/ftrace.c                             |  8 +-
 kernel/trace/trace.c                              |  2 +-
 kernel/workqueue.c                                | 12 ++-
 net/netlink/af_netlink.c                          |  6 +-
 net/nfc/rawsock.c                                 |  2 +-
 net/rds/connection.c                              | 23 ++++--
 net/rds/tcp.c                                     |  4 +-
 net/rds/tcp.h                                     |  3 +-
 net/rds/tcp_listen.c                              |  6 ++
 sound/soc/codecs/max98088.c                       | 13 +++-
 sound/soc/codecs/sti-sas.c                        |  1 +
 sound/soc/intel/boards/bytcr_rt5640.c             | 25 ++++++
 tools/perf/util/session.c                         |  1 +
 98 files changed, 561 insertions(+), 187 deletions(-)


