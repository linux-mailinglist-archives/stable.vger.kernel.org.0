Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09ED4273071
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 19:05:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729615AbgIURFD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 13:05:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:33694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728814AbgIUQet (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 12:34:49 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C379623998;
        Mon, 21 Sep 2020 16:34:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600706088;
        bh=pOlhGH2JvSn+VPzt/7in6KDso3ruzdBeOirVH0JIi9A=;
        h=From:To:Cc:Subject:Date:From;
        b=XM4ldkaBDPBsdM682vQ9Mwg3sV6ptRcFYg1HXd2A+Y4OjtjAuw08KEFyGzAwQXyZW
         3rP6SqAb3PVC7GPj+2sACyLC7qpPP+FHXHA6dUp+I9mBqY2z1cVykJP/mRqxFCvpzr
         tjvBWOTneJF1Pf/KGHc6Ws+vlkk19XZ5tG45kNg8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        pavel@denx.de, stable@vger.kernel.org
Subject: [PATCH 4.9 00/70] 4.9.237-rc1 review
Date:   Mon, 21 Sep 2020 18:27:00 +0200
Message-Id: <20200921162035.136047591@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.237-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.9.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.9.237-rc1
X-KernelTest-Deadline: 2020-09-23T16:20+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.9.237 release.
There are 70 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 23 Sep 2020 16:20:12 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.237-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.9.237-rc1

Adam Borowski <kilobyte@angband.pl>
    x86/defconfig: Enable CONFIG_USB_XHCI_HCD=y

Alexey Kardashevskiy <aik@ozlabs.ru>
    powerpc/dma: Fix dma_map_ops::get_required_mask

Quentin Perret <qperret@google.com>
    ehci-hcd: Move include to keep CRC stable

Tobias Diedrich <tobiasdiedrich@gmail.com>
    serial: 8250_pci: Add Realtek 816a and 816b

Hans de Goede <hdegoede@redhat.com>
    Input: i8042 - add Entroware Proteus EL07R4 to nomux and reset lists

Oliver Neukum <oneukum@suse.com>
    usblp: fix race between disconnect() and read()

Oliver Neukum <oneukum@suse.com>
    USB: UAS: fix disconnect by unplugging a hub

Penghao <penghao@uniontech.com>
    USB: quirks: Add USB_QUIRK_IGNORE_REMOTE_WAKEUP quirk for BYD zhaoxin notebook

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

Michael Kelley <mikelley@microsoft.com>
    Drivers: hv: vmbus: Add timeout to vmbus_wait_for_unload

Nathan Chancellor <natechancellor@gmail.com>
    clk: rockchip: Fix initialization of mux_pll_src_4plls_p

Evan Nimmo <evan.nimmo@alliedtelesis.co.nz>
    i2c: algo: pca: Reapply i2c bus settings after reset

Laurent Pinchart <laurent.pinchart@ideasonboard.com>
    rapidio: Replace 'select' DMAENGINES 'with depends on'

J. Bruce Fields <bfields@redhat.com>
    SUNRPC: stop printk reading past end of string

Vincent Whitchurch <vincent.whitchurch@axis.com>
    spi: spi-loopback-test: Fix out-of-bounds read

James Smart <james.smart@broadcom.com>
    scsi: lpfc: Fix FLOGI/PLOGI receive race condition in pt2pt discovery

Dinghao Liu <dinghao.liu@zju.edu.cn>
    scsi: pm8001: Fix memleak in pm8001_exec_internal_task_abort

Olga Kornievskaia <kolga@netapp.com>
    NFSv4.1 handle ERR_DELAY error reclaiming locking state on delegation recall

Miaohe Lin <linmiaohe@huawei.com>
    net: handle the return value of pskb_carve_frag_list() correctly

Peter Oberparleiter <oberpar@linux.ibm.com>
    gcov: add support for GCC 10.1

Yi Zhang <yi.zhang@redhat.com>
    RDMA/rxe: Fix the parent sysfs read when the interface has 15 chars

Bart Van Assche <bart.vanassche@sandisk.com>
    IB/rxe: Remove a pointless indirection layer

Mathias Nyman <mathias.nyman@linux.intel.com>
    usb: Fix out of sync data toggle if a configured device is reconfigured

Aleksander Morgado <aleksander@aleksander.es>
    USB: serial: option: add support for SIM7070/SIM7080/SIM7090 modules

Patrick Riphagen <patrick.riphagen@xsens.com>
    USB: serial: ftdi_sio: add IDs for Xsens Mti USB converter

Zeng Tao <prime.zeng@hisilicon.com>
    usb: core: fix slab-out-of-bounds Read in read_descriptors

Vaibhav Agarwal <vaibhav.sr@gmail.com>
    staging: greybus: audio: fix uninitialized value issue

Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
    video: fbdev: fix OOB read in vga_8planes_imageblit()

Wanpeng Li <wanpengli@tencent.com>
    KVM: VMX: Don't freeze guest when event delivery causes an APIC-access exit

Linus Torvalds <torvalds@linux-foundation.org>
    vgacon: remove software scrollback support

Linus Torvalds <torvalds@linux-foundation.org>
    fbcon: remove now unusued 'softback_lines' cursor() argument

Linus Torvalds <torvalds@linux-foundation.org>
    fbcon: remove soft scrollback code

Ilya Dryomov <idryomov@gmail.com>
    rbd: require global CAP_SYS_ADMIN for mapping and unmapping

Hou Pu <houpu@bytedance.com>
    scsi: target: iscsi: Fix hang in iscsit_access_np() when getting tpg->np_login_sem

Varun Prakash <varun@chelsio.com>
    scsi: target: iscsi: Fix data digest calculation

Michał Mirosław <mirq-linux@rere.qmqm.pl>
    regulator: push allocation in set_consumer_device_supply() out of lock

Filipe Manana <fdmanana@suse.com>
    btrfs: fix wrong address when faulting in pages in the search ioctl

Rustam Kovhaev <rkovhaev@gmail.com>
    staging: wlan-ng: fix out of bounds read in prism2sta_probe_usb()

Johan Hovold <johan@kernel.org>
    USB: core: add helpers to retrieve endpoints

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio:accel:mma8452: Fix timestamp alignment and prevent data leak.

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio:accel:mma7455: Fix timestamp alignment and prevent data leak.

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio: accel: kxsd9: Fix alignment of local buffer.

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio:light:max44000 Fix timestamp alignment and prevent data leak.

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio:magnetometer:ak8975 Fix alignment and data leak issues.

Sandhya Bankar <bankarsandhya512@gmail.com>
    drivers: iio: magnetometer: Fix sparse endianness warnings cast to restricted __be16

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio:adc:ti-adc081c Fix alignment and data leak issues

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio:adc:ina2xx Fix timestamp alignment issue.

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio:accel:bmc150-accel: Fix timestamp alignment and prevent data leak.

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio:light:ltr501 Fix timestamp alignment issue.

Maxim Kochetkov <fido_max@inbox.ru>
    iio: adc: ti-ads1015: fix conversion when CONFIG_PM is not set

Angelo Compagnucci <angelo.compagnucci@gmail.com>
    iio: adc: mcp3422: fix locking on error path

Angelo Compagnucci <angelo.compagnucci@gmail.com>
    iio: adc: mcp3422: fix locking scope

Leon Romanovsky <leonro@nvidia.com>
    gcov: Disable gcov build with GCC 10

Rander Wang <rander.wang@intel.com>
    ALSA: hda: fix a runtime pm issue in SOF when integrated GPU is disabled

Xie He <xie.he.0141@gmail.com>
    drivers/net/wan/hdlc_cisco: Add hard_header_len

Vineet Gupta <vgupta@synopsys.com>
    irqchip/eznps: Fix build error for !ARC700 builds

Darrick J. Wong <darrick.wong@oracle.com>
    xfs: initialize the shortform attr header padding entry

Xie He <xie.he.0141@gmail.com>
    drivers/net/wan/lapbether: Set network_header before transmitting

Mohan Kumar <mkumard@nvidia.com>
    ALSA: hda: Fix 2 channel swapping for Tegra

Dinghao Liu <dinghao.liu@zju.edu.cn>
    firestream: Fix memleak in fs_open

Dinghao Liu <dinghao.liu@zju.edu.cn>
    NFC: st95hf: Fix memleak in st95hf_in_send_cmd

Xie He <xie.he.0141@gmail.com>
    drivers/net/wan/lapbether: Added needed_tailroom

Luo Jiaxing <luojiaxing@huawei.com>
    scsi: libsas: Set data_dir as DMA_NONE if libata marks qc as NODATA

Kamal Heib <kamalheib1@gmail.com>
    RDMA/rxe: Drop pointless checks in rxe_init_ports

Dinghao Liu <dinghao.liu@zju.edu.cn>
    RDMA/rxe: Fix memleak in rxe_mem_init_user

Dinh Nguyen <dinguyen@kernel.org>
    ARM: dts: socfpga: fix register entry for timer3 on Arria10


-------------

Diffstat:

 Makefile                                  |   4 +-
 arch/arc/plat-eznps/include/plat/ctop.h   |   1 -
 arch/arm/boot/dts/socfpga_arria10.dtsi    |   2 +-
 arch/mips/Kconfig                         |   1 +
 arch/mips/sni/a20r.c                      |   9 +-
 arch/powerpc/configs/pasemi_defconfig     |   1 -
 arch/powerpc/configs/ppc6xx_defconfig     |   1 -
 arch/powerpc/kernel/dma-iommu.c           |   3 +-
 arch/x86/configs/i386_defconfig           |   2 +-
 arch/x86/configs/x86_64_defconfig         |   2 +-
 arch/x86/kvm/vmx.c                        |   1 +
 drivers/atm/firestream.c                  |   1 +
 drivers/block/rbd.c                       |  12 ++
 drivers/clk/rockchip/clk-rk3228.c         |   2 +-
 drivers/gpu/drm/mediatek/mtk_drm_drv.c    |   7 +-
 drivers/hv/channel_mgmt.c                 |   7 +-
 drivers/i2c/algos/i2c-algo-pca.c          |  35 ++--
 drivers/iio/accel/bmc150-accel-core.c     |  15 +-
 drivers/iio/accel/kxsd9.c                 |  16 +-
 drivers/iio/accel/mma7455_core.c          |  16 +-
 drivers/iio/accel/mma8452.c               |  11 +-
 drivers/iio/adc/ina2xx-adc.c              |  11 +-
 drivers/iio/adc/mcp3422.c                 |  16 +-
 drivers/iio/adc/ti-adc081c.c              |  11 +-
 drivers/iio/adc/ti-ads1015.c              |  10 +
 drivers/iio/light/ltr501.c                |  15 +-
 drivers/iio/light/max44000.c              |  12 +-
 drivers/iio/magnetometer/ak8975.c         |  26 ++-
 drivers/infiniband/sw/rxe/rxe.c           |   5 +-
 drivers/infiniband/sw/rxe/rxe_loc.h       |  20 +-
 drivers/infiniband/sw/rxe/rxe_mcast.c     |   4 +-
 drivers/infiniband/sw/rxe/rxe_mr.c        |   1 +
 drivers/infiniband/sw/rxe/rxe_net.c       |  43 ++--
 drivers/infiniband/sw/rxe/rxe_req.c       |   4 +-
 drivers/infiniband/sw/rxe/rxe_resp.c      |   4 +-
 drivers/infiniband/sw/rxe/rxe_verbs.c     |  10 +-
 drivers/infiniband/sw/rxe/rxe_verbs.h     |  22 --
 drivers/input/serio/i8042-x86ia64io.h     |  16 ++
 drivers/net/wan/hdlc_cisco.c              |   1 +
 drivers/net/wan/lapbether.c               |   3 +
 drivers/nfc/st95hf/core.c                 |   2 +-
 drivers/rapidio/Kconfig                   |   2 +-
 drivers/regulator/core.c                  |  46 ++--
 drivers/scsi/libsas/sas_ata.c             |   5 +-
 drivers/scsi/lpfc/lpfc_els.c              |   4 +-
 drivers/scsi/pm8001/pm8001_sas.c          |   2 +-
 drivers/spi/spi-loopback-test.c           |   2 +-
 drivers/staging/greybus/audio_topology.c  |  29 +--
 drivers/staging/wlan-ng/hfa384x_usb.c     |   5 -
 drivers/staging/wlan-ng/prism2usb.c       |  19 +-
 drivers/target/iscsi/iscsi_target.c       |  17 +-
 drivers/target/iscsi/iscsi_target_login.c |   6 +-
 drivers/target/iscsi/iscsi_target_login.h |   3 +-
 drivers/target/iscsi/iscsi_target_nego.c  |   3 +-
 drivers/tty/serial/8250/8250_pci.c        |  11 +
 drivers/usb/class/usblp.c                 |   5 +
 drivers/usb/core/message.c                |  91 ++++----
 drivers/usb/core/quirks.c                 |   4 +
 drivers/usb/core/sysfs.c                  |   5 +
 drivers/usb/core/usb.c                    |  83 ++++++++
 drivers/usb/host/ehci-hcd.c               |   1 +
 drivers/usb/host/ehci-hub.c               |   1 -
 drivers/usb/serial/ftdi_sio.c             |   1 +
 drivers/usb/serial/ftdi_sio_ids.h         |   1 +
 drivers/usb/serial/option.c               |   2 +
 drivers/usb/storage/uas.c                 |  14 +-
 drivers/video/console/Kconfig             |  25 ---
 drivers/video/console/bitblit.c           |  11 +-
 drivers/video/console/fbcon.c             | 336 +-----------------------------
 drivers/video/console/fbcon.h             |   2 +-
 drivers/video/console/fbcon_ccw.c         |  11 +-
 drivers/video/console/fbcon_cw.c          |  11 +-
 drivers/video/console/fbcon_ud.c          |  11 +-
 drivers/video/console/tileblit.c          |   2 +-
 drivers/video/console/vgacon.c            | 159 +-------------
 drivers/video/fbdev/vga16fb.c             |   2 +-
 fs/btrfs/ioctl.c                          |   3 +-
 fs/nfs/nfs4proc.c                         |   7 +-
 fs/xfs/libxfs/xfs_attr_leaf.c             |   4 +-
 include/linux/i2c-algo-pca.h              |  15 ++
 include/linux/usb.h                       |  35 ++++
 include/soc/nps/common.h                  |   6 +
 kernel/gcov/gcc_4_7.c                     |   4 +-
 net/core/skbuff.c                         |  10 +-
 net/sunrpc/rpcb_clnt.c                    |   4 +-
 sound/hda/hdac_device.c                   |   2 +
 sound/pci/hda/patch_hdmi.c                |   5 +
 tools/perf/tests/pmu.c                    |   1 +
 tools/perf/util/pmu.c                     |  11 +
 tools/perf/util/pmu.h                     |   1 +
 90 files changed, 595 insertions(+), 830 deletions(-)


