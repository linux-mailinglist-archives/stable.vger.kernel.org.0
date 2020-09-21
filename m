Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3BD0272D93
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 18:41:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729136AbgIUQlT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 12:41:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:44604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728342AbgIUQlP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 12:41:15 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4DFAA23998;
        Mon, 21 Sep 2020 16:41:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600706473;
        bh=Rt9kIydEDh/QHN8Jt7Bj6F2ab8R2vvQQ/8pcavkdEmg=;
        h=From:To:Cc:Subject:Date:From;
        b=Kf9XxzSxakiI+76UCl94NMKAXrkpqEENJlA/9wlbRlk0/T2sNrPTe4q87Ag9Hnv0E
         yId34TquiSvlN4mLnkZvNubOYfgM1mo3XQAHcyL0Hu/Yb+4ebO6cgC7pfdVzXtDse6
         M8GOieSJxyXApZnoNpxaRJhYhr5eylGdpgBDjog8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        pavel@denx.de, stable@vger.kernel.org
Subject: [PATCH 4.19 00/49] 4.19.147-rc1 review
Date:   Mon, 21 Sep 2020 18:27:44 +0200
Message-Id: <20200921162034.660953761@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.147-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.147-rc1
X-KernelTest-Deadline: 2020-09-23T16:20+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.19.147 release.
There are 49 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 23 Sep 2020 16:20:12 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.147-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.19.147-rc1

Adam Borowski <kilobyte@angband.pl>
    x86/defconfig: Enable CONFIG_USB_XHCI_HCD=y

Alexey Kardashevskiy <aik@ozlabs.ru>
    powerpc/dma: Fix dma_map_ops::get_required_mask

Quentin Perret <qperret@google.com>
    ehci-hcd: Move include to keep CRC stable

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

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "ALSA: hda - Fix silent audio output and corrupted input on MSI X570-A PRO"

Volker Rümelin <vr_qemu@t-online.de>
    i2c: i801: Fix resume bug

Oliver Neukum <oneukum@suse.com>
    usblp: fix race between disconnect() and read()

Oliver Neukum <oneukum@suse.com>
    USB: UAS: fix disconnect by unplugging a hub

Penghao <penghao@uniontech.com>
    USB: quirks: Add USB_QUIRK_IGNORE_REMOTE_WAKEUP quirk for BYD zhaoxin notebook

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

Thomas Bogendoerfer <tsbogend@alpha.franken.de>
    MIPS: SNI: Fix MIPS_L1_CACHE_SHIFT

Jiri Olsa <jolsa@kernel.org>
    perf test: Fix the "signal" test inline assembly

Michael Kelley <mikelley@microsoft.com>
    Drivers: hv: vmbus: Add timeout to vmbus_wait_for_unload

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

David Milburn <dmilburn@redhat.com>
    nvme-rdma: cancel async events before freeing event struct

David Milburn <dmilburn@redhat.com>
    nvme-fc: cancel async events before freeing event struct

Stafford Horne <shorne@gmail.com>
    openrisc: Fix cache API compile issue when not inlining

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

Haiyang Zhang <haiyangz@microsoft.com>
    hv_netvsc: Remove "unlikely" from netvsc_select_queue

Miaohe Lin <linmiaohe@huawei.com>
    net: handle the return value of pskb_carve_frag_list() correctly

Naresh Kumar PBS <nareshkumar.pbs@broadcom.com>
    RDMA/bnxt_re: Restrict the max_gids to 256

Bob Peterson <rpeterso@redhat.com>
    gfs2: initialize transaction tr_ailX_lists earlier

Quinn Tran <quinn.tran@cavium.com>
    scsi: qla2xxx: Reduce holding sess_lock to prevent CPU lock-up

Quinn Tran <quinn.tran@cavium.com>
    scsi: qla2xxx: Move rport registration out of internal work_list

Quinn Tran <quinn.tran@cavium.com>
    scsi: qla2xxx: Update rscn_rcvd field to more meaningful scan_needed

Daniel Mack <daniel@zonque.org>
    dsa: Allow forwarding of redirected IGMP traffic


-------------

Diffstat:

 Makefile                                 |   4 +-
 arch/mips/Kconfig                        |   1 +
 arch/mips/kvm/mips.c                     |   2 +
 arch/mips/sni/a20r.c                     |   9 ++-
 arch/openrisc/mm/cache.c                 |   2 +-
 arch/powerpc/kernel/dma-iommu.c          |   3 +-
 arch/x86/boot/compressed/Makefile        |   2 +
 arch/x86/configs/i386_defconfig          |   1 +
 arch/x86/configs/x86_64_defconfig        |   1 +
 drivers/clk/davinci/pll.c                |   2 +-
 drivers/clk/rockchip/clk-rk3228.c        |   2 +-
 drivers/gpu/drm/mediatek/mtk_drm_drv.c   |   7 ++-
 drivers/gpu/drm/mediatek/mtk_hdmi.c      |  26 +++++---
 drivers/hv/channel_mgmt.c                |   7 ++-
 drivers/i2c/algos/i2c-algo-pca.c         |  35 +++++++----
 drivers/i2c/busses/i2c-i801.c            |  21 ++++---
 drivers/infiniband/hw/bnxt_re/qplib_sp.c |   2 +-
 drivers/infiniband/hw/bnxt_re/qplib_sp.h |   1 +
 drivers/input/mouse/trackpoint.c         |  10 +--
 drivers/input/mouse/trackpoint.h         |  10 +--
 drivers/input/serio/i8042-x86ia64io.h    |  16 +++++
 drivers/net/hyperv/netvsc_drv.c          |   2 +-
 drivers/nvme/host/fc.c                   |   1 +
 drivers/nvme/host/rdma.c                 |   1 +
 drivers/rapidio/Kconfig                  |   2 +-
 drivers/regulator/pwm-regulator.c        |   2 +-
 drivers/scsi/libfc/fc_disc.c             |   2 -
 drivers/scsi/lpfc/lpfc_els.c             |   4 +-
 drivers/scsi/pm8001/pm8001_sas.c         |   2 +-
 drivers/scsi/qla2xxx/qla_def.h           |  10 +--
 drivers/scsi/qla2xxx/qla_gbl.h           |   5 +-
 drivers/scsi/qla2xxx/qla_gs.c            |  30 +++++----
 drivers/scsi/qla2xxx/qla_init.c          | 101 +++++++++++++++++++++++--------
 drivers/scsi/qla2xxx/qla_os.c            |  29 +++++----
 drivers/scsi/qla2xxx/qla_target.c        |  85 +++++++++++++++++++++-----
 drivers/spi/spi-loopback-test.c          |   2 +-
 drivers/spi/spi.c                        |   9 ++-
 drivers/tty/serial/8250/8250_pci.c       |  11 ++++
 drivers/usb/class/usblp.c                |   5 ++
 drivers/usb/core/quirks.c                |   4 ++
 drivers/usb/host/ehci-hcd.c              |   1 +
 drivers/usb/host/ehci-hub.c              |   1 -
 drivers/usb/storage/uas.c                |  14 ++++-
 drivers/video/fbdev/core/fbcon.c         |   2 +-
 fs/f2fs/data.c                           |   3 +
 fs/f2fs/node.c                           |   3 +
 fs/gfs2/glops.c                          |   2 +
 fs/gfs2/log.c                            |   2 -
 fs/gfs2/trans.c                          |   2 +
 fs/nfs/nfs4proc.c                        |  11 +++-
 include/linux/i2c-algo-pca.h             |  15 +++++
 include/uapi/linux/kvm.h                 |   5 +-
 mm/percpu.c                              |   2 +-
 net/core/skbuff.c                        |  10 ++-
 net/dsa/tag_edsa.c                       |  37 ++++++++++-
 net/sunrpc/rpcb_clnt.c                   |   4 +-
 sound/pci/hda/patch_realtek.c            |   1 -
 sound/soc/qcom/apq8016_sbc.c             |   1 +
 sound/soc/qcom/apq8096.c                 |   1 +
 sound/soc/qcom/sdm845.c                  |   1 +
 sound/soc/qcom/storm.c                   |   1 +
 tools/perf/tests/bp_signal.c             |   5 +-
 tools/perf/tests/pmu.c                   |   1 +
 tools/perf/util/pmu.c                    |  11 ++++
 tools/perf/util/pmu.h                    |   1 +
 65 files changed, 458 insertions(+), 150 deletions(-)


