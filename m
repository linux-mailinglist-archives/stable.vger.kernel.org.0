Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B455272EE8
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 18:53:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730040AbgIUQw4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 12:52:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:56180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729080AbgIUQsk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 12:48:40 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0CE6F2388B;
        Mon, 21 Sep 2020 16:48:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600706917;
        bh=1rg+//fUzfLbWfcSQfExaRR+tUmAoVdKPRsl2zzUav8=;
        h=From:To:Cc:Subject:Date:From;
        b=oK8uuaMqvqO23GudAwTj/dpxtjh0ABmnpVCtij3rrWxqZkD0ZlgW/Laf7BMrGdEma
         I9FJ2G/K41bF+yCYGX4jL69Sq/uTht6gbKRohQYVS91gVWJRaJNOZWEUQeaUSQwlRM
         Bj+cYR0D070HO966SDpMh0FeCj5+PpCAVwAQ8Hz4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        pavel@denx.de, stable@vger.kernel.org
Subject: [PATCH 5.4 00/72] 5.4.67-rc1 review
Date:   Mon, 21 Sep 2020 18:30:39 +0200
Message-Id: <20200921163121.870386357@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-5.4.67-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.67-rc1
X-KernelTest-Deadline: 2020-09-23T16:31+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.4.67 release.
There are 72 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 23 Sep 2020 16:31:02 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.67-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.4.67-rc1

Jan Kara <jack@suse.cz>
    dax: Fix compilation for CONFIG_DAX && !CONFIG_FS_DAX

Jan Kara <jack@suse.cz>
    dm: Call proper helper to determine dax support

Pavel Tatashin <pasha.tatashin@soleen.com>
    mm/memory_hotplug: drain per-cpu pages again during memory offline

Dan Williams <dan.j.williams@intel.com>
    dm/dax: Fix table reference counts

Christophe Leroy <christophe.leroy@csgroup.eu>
    selftests/vm: fix display of page size in map_hugetlb

Alexey Kardashevskiy <aik@ozlabs.ru>
    powerpc/dma: Fix dma_map_ops::get_required_mask

Quentin Perret <qperret@google.com>
    ehci-hcd: Move include to keep CRC stable

Harald Freudenberger <freude@linux.ibm.com>
    s390/zcrypt: fix kmalloc 256k failure

Arvind Sankar <nivedita@alum.mit.edu>
    x86/boot/compressed: Disable relocation relaxation

Tobias Diedrich <tobiasdiedrich@gmail.com>
    serial: 8250_pci: Add Realtek 816a and 816b

Hans de Goede <hdegoede@redhat.com>
    Input: i8042 - add Entroware Proteus EL07R4 to nomux and reset lists

Vincent Huang <vincent.huang@tw.synaptics.com>
    Input: trackpoint - add new trackpoint variant IDs

Sunghyun Jin <mcsmonk@gmail.com>
    percpu: fix first chunk size calculation for populated bitmap

Hui Wang <hui.wang@canonical.com>
    ALSA: hda/realtek - The Mic on a RedmiBook doesn't work

Luke D Jones <luke@ljones.dev>
    ALSA: hda: fixup headset for ASUS GX502 laptop

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "ALSA: hda - Fix silent audio output and corrupted input on MSI X570-A PRO"

Volker Rümelin <vr_qemu@t-online.de>
    i2c: i801: Fix resume bug

Heikki Krogerus <heikki.krogerus@linux.intel.com>
    usb: typec: ucsi: Prevent mode overrun

Oliver Neukum <oneukum@suse.com>
    usblp: fix race between disconnect() and read()

Oliver Neukum <oneukum@suse.com>
    USB: UAS: fix disconnect by unplugging a hub

Penghao <penghao@uniontech.com>
    USB: quirks: Add USB_QUIRK_IGNORE_REMOTE_WAKEUP quirk for BYD zhaoxin notebook

Chris Wilson <chris@chris-wilson.co.uk>
    drm/i915: Filter wake_flags passed to default_wake_function

Greentime Hu <greentime.hu@sifive.com>
    riscv: Add sfence.vma after early page table changes

Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
    i2c: mxs: use MXS_DMA_CTRL_WAIT4END instead of DMA_CTRL_ACK

Joao Martins <joao.m.martins@oracle.com>
    iommu/amd: Fix potential @entry null deref

Ilias Apalodimas <ilias.apalodimas@linaro.org>
    arm64: bpf: Fix branch offset in JIT

Yu Kuai <yukuai3@huawei.com>
    drm/mediatek: Add missing put_device() call in mtk_hdmi_dt_parse_pdata()

Yu Kuai <yukuai3@huawei.com>
    drm/mediatek: Add exception handing in mtk_drm_probe() if component init fail

Thomas Bogendoerfer <tsbogend@alpha.franken.de>
    MIPS: SNI: Fix spurious interrupts

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    fbcon: Fix user font detection test at fbcon_resize().

Namhyung Kim <namhyung@kernel.org>
    perf test: Free formats for perf pmu parse test

Namhyung Kim <namhyung@kernel.org>
    perf parse-event: Fix memory leak in evsel->unit

Namhyung Kim <namhyung@kernel.org>
    perf evlist: Fix cpu/thread map leak

Thomas Bogendoerfer <tsbogend@alpha.franken.de>
    MIPS: SNI: Fix MIPS_L1_CACHE_SHIFT

Jiri Olsa <jolsa@kernel.org>
    perf test: Fix the "signal" test inline assembly

Michael Kelley <mikelley@microsoft.com>
    Drivers: hv: vmbus: Add timeout to vmbus_wait_for_unload

Marc Zyngier <maz@kernel.org>
    arm64: Allow CPUs unffected by ARM erratum 1418040 to come in late

Dan Carpenter <dan.carpenter@oracle.com>
    scsi: libsas: Fix error path in sas_notify_lldd_dev_found()

Dexuan Cui <decui@microsoft.com>
    Drivers: hv: vmbus: hibernation: do not hang forever in vmbus_bus_resume()

Jerome Brunet <jbrunet@baylibre.com>
    ASoC: meson: axg-toddr: fix channel order on g12 platforms

Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
    powerpc/book3s64/radix: Fix boot failure with large amount of guest memory

Dinghao Liu <dinghao.liu@zju.edu.cn>
    ASoC: qcom: common: Fix refcount imbalance on error

Stephan Gerhold <stephan@gerhold.net>
    ASoC: qcom: Set card->owner to avoid warnings

Nathan Chancellor <natechancellor@gmail.com>
    clk: rockchip: Fix initialization of mux_pll_src_4plls_p

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    clk: davinci: Use the correct size when allocating memory

Huacai Chen <chenhc@lemote.com>
    KVM: MIPS: Change the definition of kvm type

Gustav Wiklander <gustavwi@axis.com>
    spi: Fix memory leak on splited transfers

Evan Nimmo <evan.nimmo@alliedtelesis.co.nz>
    i2c: algo: pca: Reapply i2c bus settings after reset

Gabriel Krisman Bertazi <krisman@collabora.com>
    f2fs: Return EOF on unaligned end of file DIO read

Sahitya Tummala <stummala@codeaurora.org>
    f2fs: fix indefinite loop scanning for free nid

Omar Sandoval <osandov@fb.com>
    block: only call sched requeue_request() for scheduled requests

David Milburn <dmilburn@redhat.com>
    nvme-tcp: cancel async events before freeing event struct

David Milburn <dmilburn@redhat.com>
    nvme-rdma: cancel async events before freeing event struct

David Milburn <dmilburn@redhat.com>
    nvme-fc: cancel async events before freeing event struct

Stafford Horne <shorne@gmail.com>
    openrisc: Fix cache API compile issue when not inlining

Ronnie Sahlberg <lsahlber@redhat.com>
    cifs: fix DFS mount with cifsacl/modefromsid

Laurent Pinchart <laurent.pinchart@ideasonboard.com>
    rapidio: Replace 'select' DMAENGINES 'with depends on'

J. Bruce Fields <bfields@redhat.com>
    SUNRPC: stop printk reading past end of string

Chuck Lever <chuck.lever@oracle.com>
    NFS: Zero-stateid SETATTR should first return delegation

Vincent Whitchurch <vincent.whitchurch@axis.com>
    spi: spi-loopback-test: Fix out-of-bounds read

Vincent Whitchurch <vincent.whitchurch@axis.com>
    regulator: pwm: Fix machine constraints application

James Smart <james.smart@broadcom.com>
    scsi: lpfc: Fix FLOGI/PLOGI receive race condition in pt2pt discovery

Javed Hasan <jhasan@marvell.com>
    scsi: libfc: Fix for double free()

Dinghao Liu <dinghao.liu@zju.edu.cn>
    scsi: pm8001: Fix memleak in pm8001_exec_internal_task_abort

Olga Kornievskaia <kolga@netapp.com>
    NFSv4.1 handle ERR_DELAY error reclaiming locking state on delegation recall

Prateek Sood <prsood@codeaurora.org>
    firmware_loader: fix memory leak for paged buffer

Haiyang Zhang <haiyangz@microsoft.com>
    hv_netvsc: Remove "unlikely" from netvsc_select_queue

Miaohe Lin <linmiaohe@huawei.com>
    net: handle the return value of pskb_carve_frag_list() correctly

Daniel Mack <daniel@zonque.org>
    dsa: Allow forwarding of redirected IGMP traffic

Sasha Neftin <sasha.neftin@intel.com>
    e1000e: Add support for Comet Lake

Naresh Kumar PBS <nareshkumar.pbs@broadcom.com>
    RDMA/bnxt_re: Restrict the max_gids to 256

Bob Peterson <rpeterso@redhat.com>
    gfs2: initialize transaction tr_ailX_lists earlier


-------------

Diffstat:

 Makefile                                   |  4 +-
 arch/arm64/kernel/cpu_errata.c             |  8 ++-
 arch/arm64/net/bpf_jit_comp.c              | 43 +++++++++++-----
 arch/mips/Kconfig                          |  1 +
 arch/mips/kvm/mips.c                       |  2 +
 arch/mips/sni/a20r.c                       |  9 +++-
 arch/openrisc/mm/cache.c                   |  2 +-
 arch/powerpc/include/asm/book3s/64/mmu.h   | 10 ++--
 arch/powerpc/kernel/dma-iommu.c            |  3 +-
 arch/powerpc/mm/book3s64/radix_pgtable.c   | 15 ------
 arch/powerpc/mm/init_64.c                  | 11 ++++-
 arch/riscv/mm/init.c                       |  7 ++-
 arch/x86/boot/compressed/Makefile          |  2 +
 block/bfq-iosched.c                        | 12 -----
 block/blk-mq-sched.h                       |  2 +-
 drivers/base/firmware_loader/firmware.h    |  2 +
 drivers/base/firmware_loader/main.c        | 17 ++++---
 drivers/clk/davinci/pll.c                  |  2 +-
 drivers/clk/rockchip/clk-rk3228.c          |  2 +-
 drivers/dax/super.c                        |  4 ++
 drivers/gpu/drm/i915/i915_sw_fence.c       | 10 ++--
 drivers/gpu/drm/mediatek/mtk_drm_drv.c     |  7 ++-
 drivers/gpu/drm/mediatek/mtk_hdmi.c        | 26 +++++++---
 drivers/hv/channel_mgmt.c                  |  7 ++-
 drivers/hv/vmbus_drv.c                     |  9 +++-
 drivers/i2c/algos/i2c-algo-pca.c           | 35 ++++++++-----
 drivers/i2c/busses/i2c-i801.c              | 21 +++++---
 drivers/i2c/busses/i2c-mxs.c               | 10 ++--
 drivers/infiniband/hw/bnxt_re/qplib_sp.c   |  2 +-
 drivers/infiniband/hw/bnxt_re/qplib_sp.h   |  1 +
 drivers/input/mouse/trackpoint.c           | 10 ++--
 drivers/input/mouse/trackpoint.h           | 10 ++--
 drivers/input/serio/i8042-x86ia64io.h      | 16 ++++++
 drivers/iommu/amd_iommu.c                  |  4 +-
 drivers/md/dm-table.c                      | 10 ++--
 drivers/md/dm.c                            |  5 +-
 drivers/net/ethernet/intel/e1000e/hw.h     |  6 +++
 drivers/net/ethernet/intel/e1000e/netdev.c |  6 +++
 drivers/net/hyperv/netvsc_drv.c            |  2 +-
 drivers/nvme/host/fc.c                     |  1 +
 drivers/nvme/host/rdma.c                   |  1 +
 drivers/nvme/host/tcp.c                    |  1 +
 drivers/rapidio/Kconfig                    |  2 +-
 drivers/regulator/pwm-regulator.c          |  2 +-
 drivers/s390/crypto/zcrypt_ccamisc.c       |  8 +--
 drivers/scsi/libfc/fc_disc.c               |  2 -
 drivers/scsi/libsas/sas_discover.c         |  3 +-
 drivers/scsi/lpfc/lpfc_els.c               |  4 +-
 drivers/scsi/pm8001/pm8001_sas.c           |  2 +-
 drivers/spi/spi-loopback-test.c            |  2 +-
 drivers/spi/spi.c                          |  9 +++-
 drivers/tty/serial/8250/8250_pci.c         | 11 +++++
 drivers/usb/class/usblp.c                  |  5 ++
 drivers/usb/core/quirks.c                  |  4 ++
 drivers/usb/host/ehci-hcd.c                |  1 +
 drivers/usb/host/ehci-hub.c                |  1 -
 drivers/usb/storage/uas.c                  | 14 +++++-
 drivers/usb/typec/ucsi/ucsi.c              | 22 ++++++---
 drivers/video/fbdev/core/fbcon.c           |  2 +-
 fs/cifs/inode.c                            |  4 ++
 fs/f2fs/data.c                             |  3 ++
 fs/f2fs/node.c                             |  3 ++
 fs/gfs2/glops.c                            |  2 +
 fs/gfs2/log.c                              |  2 -
 fs/gfs2/trans.c                            |  2 +
 fs/nfs/nfs4proc.c                          | 11 ++++-
 include/linux/dax.h                        | 21 +++++++-
 include/linux/i2c-algo-pca.h               | 15 ++++++
 include/uapi/linux/kvm.h                   |  5 +-
 mm/memory_hotplug.c                        | 14 ++++++
 mm/page_isolation.c                        |  8 +++
 mm/percpu.c                                |  2 +-
 net/core/skbuff.c                          | 10 ++--
 net/dsa/tag_edsa.c                         | 37 ++++++++++++--
 net/sunrpc/rpcb_clnt.c                     |  4 +-
 sound/pci/hda/patch_realtek.c              | 79 +++++++++++++++++++++++++++++-
 sound/soc/meson/axg-toddr.c                | 24 ++++++++-
 sound/soc/qcom/apq8016_sbc.c               |  1 +
 sound/soc/qcom/apq8096.c                   |  1 +
 sound/soc/qcom/common.c                    |  6 ++-
 sound/soc/qcom/sdm845.c                    |  1 +
 sound/soc/qcom/storm.c                     |  1 +
 tools/perf/tests/bp_signal.c               |  5 +-
 tools/perf/tests/pmu.c                     |  1 +
 tools/perf/util/evlist.c                   | 11 +++--
 tools/perf/util/parse-events.c             |  2 +-
 tools/perf/util/pmu.c                      | 11 +++++
 tools/perf/util/pmu.h                      |  1 +
 tools/testing/selftests/vm/map_hugetlb.c   |  2 +-
 89 files changed, 569 insertions(+), 172 deletions(-)


