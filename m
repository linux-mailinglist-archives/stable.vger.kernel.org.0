Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19C1424BB4E
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 14:27:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729988AbgHTJwi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 05:52:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:33598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729700AbgHTJwX (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:52:23 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3EB01207FB;
        Thu, 20 Aug 2020 09:52:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597917141;
        bh=siRMzQ4SIJIZOQQUX3gcgAK2Cqtit1FJO4z26cwuqZs=;
        h=From:To:Cc:Subject:Date:From;
        b=xaDRe00bgvDD/mWcqkoYtqFty/TGgaKrFcv9q7GlqgmtohjwncQ2I9SGxsSiIAE0y
         IuJ6h42Kkt0915lAKJVET8dnnD9vQlQ7elKCExJEBVn57zo+mZxckSdoAM1iCtYGbA
         KXNj38bPqDEK3p+/pysLaQNrMIbF5APqOSbWEGvY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.19 00/92] 4.19.141-rc1 review
Date:   Thu, 20 Aug 2020 11:20:45 +0200
Message-Id: <20200820091537.490965042@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.141-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.141-rc1
X-KernelTest-Deadline: 2020-08-22T09:15+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.19.141 release.
There are 92 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat, 22 Aug 2020 09:15:09 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.141-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.19.141-rc1

Sandeep Raghuraman <sandy.8925@gmail.com>
    drm/amdgpu: Fix bug where DPM is not enabled after hibernate and resume

Marius Iacob <themariusus@gmail.com>
    drm: Added orientation quirk for ASUS tablet model T103HAF

Denis Efremov <efremov@linux.com>
    drm/radeon: fix fb_div check in ni_init_smc_spll_table()

Tomasz Maciej Nowak <tmn505@gmail.com>
    arm64: dts: marvell: espressobin: add ethernet alias

Hugh Dickins <hughd@google.com>
    khugepaged: retract_page_tables() remember to test exit

Geert Uytterhoeven <geert+renesas@glider.be>
    sh: landisk: Add missing initialization of sh_io_port_base

Daniel Díaz <daniel.diaz@linaro.org>
    tools build feature: Quote CC and CXX for their arguments

Vincent Whitchurch <vincent.whitchurch@axis.com>
    perf bench mem: Always memset source before memcpy

Dinghao Liu <dinghao.liu@zju.edu.cn>
    ALSA: echoaudio: Fix potential Oops in snd_echo_resume()

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    mfd: dln2: Run event handler loop under spinlock

Tiezhu Yang <yangtiezhu@loongson.cn>
    test_kmod: avoid potential double free in trigger_config_run_type()

Colin Ian King <colin.king@canonical.com>
    fs/ufs: avoid potential u32 multiplication overflow

Eric Biggers <ebiggers@google.com>
    fs/minix: remove expected error message in block_to_path()

Eric Biggers <ebiggers@google.com>
    fs/minix: fix block limit check for V1 filesystems

Eric Biggers <ebiggers@google.com>
    fs/minix: set s_maxbytes correctly

Jeffrey Mitchell <jeffrey.mitchell@starlab.io>
    nfs: Fix getxattr kernel panic and memory overflow

Wang Hai <wanghai38@huawei.com>
    net: qcom/emac: add missed clk_disable_unprepare in error path of emac_clks_phase1_init

Dan Carpenter <dan.carpenter@oracle.com>
    drm/vmwgfx: Fix two list_for_each loop exit tests

Dan Carpenter <dan.carpenter@oracle.com>
    drm/vmwgfx: Use correct vmw_legacy_display_unit pointer

Colin Ian King <colin.king@canonical.com>
    Input: sentelic - fix error return when fsp_reg_write fails

Krzysztof Sobota <krzysztof.sobota@nokia.com>
    watchdog: initialize device before misc_register

Ewan D. Milne <emilne@redhat.com>
    scsi: lpfc: nvmet: Avoid hang / use-after-free again when destroying targetport

Stafford Horne <shorne@gmail.com>
    openrisc: Fix oops caused when dumping stack

Wolfram Sang <wsa+renesas@sang-engineering.com>
    i2c: rcar: avoid race when unregistering slave

Thomas Hebb <tommyhebb@gmail.com>
    tools build feature: Use CC and CXX from parent

Rayagonda Kokatanur <rayagonda.kokatanur@broadcom.com>
    pwm: bcm-iproc: handle clk_get_rate() return

Xu Wang <vulab@iscas.ac.cn>
    clk: clk-atlas6: fix return value check in atlas6_clk_init()

Wolfram Sang <wsa+renesas@sang-engineering.com>
    i2c: rcar: slave: only send STOP event when we have been addressed

Liu Yi L <yi.l.liu@intel.com>
    iommu/vt-d: Enforce PASID devTLB field mask

Colin Ian King <colin.king@canonical.com>
    iommu/omap: Check for failure of a call to omap_iommu_dump_ctx

Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
    selftests/powerpc: ptrace-pkey: Don't update expected UAMOR value

Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
    selftests/powerpc: ptrace-pkey: Update the test to mark an invalid pkey correctly

Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
    selftests/powerpc: ptrace-pkey: Rename variables to make it easier to follow code

Ming Lei <ming.lei@redhat.com>
    dm rq: don't call blk_mq_queue_stopped() in dm_stop_queue()

Steve Longerbeam <slongerbeam@gmail.com>
    gpu: ipu-v3: image-convert: Combine rotate/no-rotate irq handlers

Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
    mmc: renesas_sdhi_internal_dmac: clean up the code for dma complete

Johan Hovold <johan@kernel.org>
    USB: serial: ftdi_sio: fix break and sysrq handling

Johan Hovold <johan@kernel.org>
    USB: serial: ftdi_sio: clean up receive processing

Johan Hovold <johan@kernel.org>
    USB: serial: ftdi_sio: make process-packet buffer unsigned

Paul Kocialkowski <paul.kocialkowski@bootlin.com>
    media: rockchip: rga: Only set output CSC mode for RGB input

Paul Kocialkowski <paul.kocialkowski@bootlin.com>
    media: rockchip: rga: Introduce color fmt macros and refactor CSC mode logic

Jason Gunthorpe <jgg@nvidia.com>
    RDMA/ipoib: Fix ABBA deadlock with ipoib_reap_ah()

Kamal Heib <kamalheib1@gmail.com>
    RDMA/ipoib: Return void from ipoib_ib_dev_stop()

Charles Keepax <ckeepax@opensource.cirrus.com>
    mfd: arizona: Ensure 32k clock is put on driver unbind and error

Liu Ying <victor.liu@nxp.com>
    drm/imx: imx-ldb: Disable both channels for split mode in enc->disable()

Sibi Sankar <sibis@codeaurora.org>
    remoteproc: qcom: q6v5: Update running state before requesting stop

Adrian Hunter <adrian.hunter@intel.com>
    perf intel-pt: Fix FUP packet state

Kees Cook <keescook@chromium.org>
    module: Correctly truncate sysfs sections output

Anton Blanchard <anton@ozlabs.org>
    pseries: Fix 64 bit logical memory block panic

Ahmad Fatoum <a.fatoum@pengutronix.de>
    watchdog: f71808e_wdt: clear watchdog timeout occurred flag

Ahmad Fatoum <a.fatoum@pengutronix.de>
    watchdog: f71808e_wdt: remove use of wrong watchdog_info option

Ahmad Fatoum <a.fatoum@pengutronix.de>
    watchdog: f71808e_wdt: indicate WDIOF_CARDRESET support in watchdog_info.options

Steven Rostedt (VMware) <rostedt@goodmis.org>
    tracing: Use trace_sched_process_free() instead of exit() for pid tracing

Kevin Hao <haokexin@gmail.com>
    tracing/hwlat: Honor the tracing_cpumask

Muchun Song <songmuchun@bytedance.com>
    kprobes: Fix NULL pointer dereference at kprobe_ftrace_handler

Chengming Zhou <zhouchengming@bytedance.com>
    ftrace: Setup correct FTRACE_FL_REGS flags for module

Michal Koutný <mkoutny@suse.com>
    mm/page_counter.c: fix protection usage propagation

Junxiao Bi <junxiao.bi@oracle.com>
    ocfs2: change slot number type s16 to u16

Mikulas Patocka <mpatocka@redhat.com>
    ext2: fix missing percpu_counter_inc

Huacai Chen <chenhc@lemote.com>
    MIPS: CPU#0 is not hotpluggable

Lukas Wunner <lukas@wunner.de>
    driver core: Avoid binding drivers to dead devices

Johannes Berg <johannes.berg@intel.com>
    mac80211: fix misplaced while instead of if

Coly Li <colyli@suse.de>
    bcache: fix overflow in offset_to_stripe()

Coly Li <colyli@suse.de>
    bcache: allocate meta data pages as compound pages

ChangSyun Peng <allenpeng@synology.com>
    md/raid5: Fix Force reconstruct-write io stuck in degraded raid5

Kees Cook <keescook@chromium.org>
    net/compat: Add missing sock updates for SCM_RIGHTS

Jonathan McDowell <noodles@earth.li>
    net: stmmac: dwmac1000: provide multicast filter fallback

Jonathan McDowell <noodles@earth.li>
    net: ethernet: stmmac: Disable hardware multicast filter

Eugeniu Rosca <erosca@de.adit-jv.com>
    media: vsp1: dl: Fix NULL pointer dereference on unbind

Michael Ellerman <mpe@ellerman.id.au>
    powerpc: Fix circular dependency between percpu.h and mmu.h

Michael Ellerman <mpe@ellerman.id.au>
    powerpc: Allow 4224 bytes of stack expansion for the signal frame

Paul Aurich <paul@darkrain42.org>
    cifs: Fix leak when handling lease break for cached root fid

Max Filippov <jcmvbkbc@gmail.com>
    xtensa: fix xtensa_pmu_setup prototype

Alexandru Ardelean <alexandru.ardelean@analog.com>
    iio: dac: ad5592r: fix unbalanced mutex unlocks in ad5592r_read_raw()

Christian Eggers <ceggers@arri.de>
    dt-bindings: iio: io-channel-mux: Fix compatible string in example code

Pavel Machek <pavel@denx.de>
    btrfs: fix return value mixup in btrfs_get_extent

Filipe Manana <fdmanana@suse.com>
    btrfs: fix memory leaks after failure to lookup checksums during inode logging

Josef Bacik <josef@toxicpanda.com>
    btrfs: only search for left_info if there is no right_info in try_merge_free_space

David Sterba <dsterba@suse.com>
    btrfs: fix messages after changing compression level by remount

Josef Bacik <josef@toxicpanda.com>
    btrfs: open device without device_list_mutex

Anand Jain <anand.jain@oracle.com>
    btrfs: don't traverse into the seed devices in show_devname

Tom Rix <trix@redhat.com>
    btrfs: ref-verify: fix memory leak in add_block_entry

Qu Wenruo <wqu@suse.com>
    btrfs: don't allocate anonymous block device for user invisible roots

Qu Wenruo <wqu@suse.com>
    btrfs: free anon block device right after subvolume deletion

Bjorn Helgaas <bhelgaas@google.com>
    PCI: Probe bridge window attributes once at enumeration-time

Ansuel Smith <ansuelsmth@gmail.com>
    PCI: qcom: Add support for tx term offset for rev 2.1.0

Ansuel Smith <ansuelsmth@gmail.com>
    PCI: qcom: Define some PARF params needed for ipq8064 SoC

Rajat Jain <rajatja@google.com>
    PCI: Add device even if driver attach failed

Kai-Heng Feng <kai.heng.feng@canonical.com>
    PCI: Mark AMD Navi10 GPU rev 0x00 ATS as broken

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    PCI: hotplug: ACPI: Fix context refcounting in acpiphp_grab_context()

Thomas Gleixner <tglx@linutronix.de>
    genirq/affinity: Make affinity setting if activated opt-in

Steve French <stfrench@microsoft.com>
    smb3: warn on confusing error scenario with sec=krb5


-------------

Diffstat:

 .../bindings/iio/multiplexer/io-channel-mux.txt    |  2 +-
 Makefile                                           |  4 +-
 .../boot/dts/marvell/armada-3720-espressobin.dts   |  6 ++
 arch/mips/kernel/topology.c                        |  2 +-
 arch/openrisc/kernel/stacktrace.c                  | 18 +++++-
 arch/powerpc/include/asm/percpu.h                  |  4 +-
 arch/powerpc/mm/fault.c                            |  7 ++-
 arch/powerpc/platforms/pseries/hotplug-memory.c    |  2 +-
 arch/sh/boards/mach-landisk/setup.c                |  3 +
 arch/x86/kernel/apic/vector.c                      |  4 ++
 arch/xtensa/kernel/perf_event.c                    |  2 +-
 drivers/base/dd.c                                  |  4 +-
 drivers/clk/sirf/clk-atlas6.c                      |  2 +-
 drivers/gpu/drm/amd/powerplay/smumgr/ci_smumgr.c   |  5 +-
 drivers/gpu/drm/drm_panel_orientation_quirks.c     |  6 ++
 drivers/gpu/drm/imx/imx-ldb.c                      |  7 ++-
 drivers/gpu/drm/radeon/ni_dpm.c                    |  2 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_kms.c                |  8 +--
 drivers/gpu/drm/vmwgfx/vmwgfx_ldu.c                |  5 +-
 drivers/gpu/ipu-v3/ipu-image-convert.c             | 58 ++++++-----------
 drivers/i2c/busses/i2c-rcar.c                      | 15 +++--
 drivers/iio/dac/ad5592r-base.c                     |  4 +-
 drivers/infiniband/ulp/ipoib/ipoib.h               |  2 +-
 drivers/infiniband/ulp/ipoib/ipoib_ib.c            | 67 +++++++++-----------
 drivers/infiniband/ulp/ipoib/ipoib_main.c          |  2 +
 drivers/input/mouse/sentelic.c                     |  2 +-
 drivers/iommu/omap-iommu-debug.c                   |  3 +
 drivers/irqchip/irq-gic-v3-its.c                   |  5 +-
 drivers/md/bcache/bcache.h                         |  2 +-
 drivers/md/bcache/bset.c                           |  2 +-
 drivers/md/bcache/btree.c                          |  2 +-
 drivers/md/bcache/journal.c                        |  4 +-
 drivers/md/bcache/super.c                          |  2 +-
 drivers/md/bcache/writeback.c                      | 14 +++--
 drivers/md/bcache/writeback.h                      | 19 +++++-
 drivers/md/dm-rq.c                                 |  3 -
 drivers/md/raid5.c                                 |  3 +-
 drivers/media/platform/rockchip/rga/rga-hw.c       | 29 +++++----
 drivers/media/platform/rockchip/rga/rga-hw.h       |  5 ++
 drivers/media/platform/vsp1/vsp1_dl.c              |  2 +
 drivers/mfd/arizona-core.c                         | 18 ++++++
 drivers/mfd/dln2.c                                 |  4 ++
 drivers/mmc/host/renesas_sdhi_internal_dmac.c      | 18 ++++--
 drivers/net/ethernet/qualcomm/emac/emac.c          | 17 ++++-
 .../net/ethernet/stmicro/stmmac/dwmac-ipq806x.c    |  1 +
 .../net/ethernet/stmicro/stmmac/dwmac1000_core.c   |  3 +
 drivers/pci/bus.c                                  |  6 +-
 drivers/pci/controller/dwc/pcie-qcom.c             | 41 +++++++++++-
 drivers/pci/hotplug/acpiphp_glue.c                 | 14 ++++-
 drivers/pci/probe.c                                | 52 +++++++++++++++
 drivers/pci/quirks.c                               |  5 +-
 drivers/pci/setup-bus.c                            | 45 ++-----------
 drivers/pwm/pwm-bcm-iproc.c                        |  9 ++-
 drivers/remoteproc/qcom_q6v5.c                     |  2 +
 drivers/scsi/lpfc/lpfc_nvmet.c                     |  2 +-
 drivers/usb/serial/ftdi_sio.c                      | 57 ++++++++++-------
 drivers/watchdog/f71808e_wdt.c                     | 13 +++-
 drivers/watchdog/watchdog_dev.c                    | 18 +++---
 fs/btrfs/disk-io.c                                 | 13 +++-
 fs/btrfs/free-space-cache.c                        |  4 +-
 fs/btrfs/inode.c                                   |  4 +-
 fs/btrfs/ref-verify.c                              |  2 +
 fs/btrfs/super.c                                   | 35 +++++------
 fs/btrfs/tree-log.c                                |  8 +--
 fs/btrfs/volumes.c                                 | 21 ++++++-
 fs/cifs/smb2misc.c                                 | 73 +++++++++++++++-------
 fs/cifs/smb2pdu.c                                  |  2 +
 fs/ext2/ialloc.c                                   |  3 +-
 fs/minix/inode.c                                   | 12 ++--
 fs/minix/itree_v1.c                                | 12 ++--
 fs/minix/itree_v2.c                                | 13 ++--
 fs/minix/minix.h                                   |  1 -
 fs/nfs/nfs4proc.c                                  |  2 -
 fs/nfs/nfs4xdr.c                                   |  6 +-
 fs/ocfs2/ocfs2.h                                   |  4 +-
 fs/ocfs2/suballoc.c                                |  4 +-
 fs/ocfs2/super.c                                   |  4 +-
 fs/ufs/super.c                                     |  2 +-
 include/linux/intel-iommu.h                        |  4 +-
 include/linux/irq.h                                | 13 ++++
 include/linux/pci.h                                |  3 +
 include/net/sock.h                                 |  4 ++
 kernel/irq/manage.c                                |  6 +-
 kernel/kprobes.c                                   |  7 +++
 kernel/module.c                                    | 22 ++++++-
 kernel/trace/ftrace.c                              | 15 +++--
 kernel/trace/trace_events.c                        |  4 +-
 kernel/trace/trace_hwlat.c                         |  5 +-
 lib/test_kmod.c                                    |  2 +-
 mm/khugepaged.c                                    | 22 ++++---
 mm/page_counter.c                                  |  6 +-
 net/compat.c                                       |  1 +
 net/core/sock.c                                    | 21 +++++++
 net/mac80211/sta_info.c                            |  2 +-
 sound/pci/echoaudio/echoaudio.c                    |  2 -
 tools/build/Makefile.feature                       |  2 +-
 tools/build/feature/Makefile                       |  2 -
 tools/perf/bench/mem-functions.c                   | 21 ++++---
 .../perf/util/intel-pt-decoder/intel-pt-decoder.c  | 21 +++----
 .../testing/selftests/powerpc/ptrace/ptrace-pkey.c | 55 ++++++++--------
 100 files changed, 715 insertions(+), 413 deletions(-)


