Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E77D226B784
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 02:24:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726409AbgIPAYn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 20:24:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:32778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726788AbgIOOTh (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Sep 2020 10:19:37 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0197E22226;
        Tue, 15 Sep 2020 14:16:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600179379;
        bh=SuLOgHthTRxQeRCKj40wD+Cf0PklCMs5S4I2+NC7Q3U=;
        h=From:To:Cc:Subject:Date:From;
        b=CMMUs1z90Qd4VGzCm0ptHbsfmsY2aQZ6kUMvbwokYB7L19lbuBQNCrV0qGFOmPmob
         AwkjuTMcxHLpqowoD6Zmd6CwePeNszL90Tel6OlEDrHjf4eSIzL8xH4tG4D9nHaKmU
         1yX46yekbcnn8Yf7zDqLOYKawn8XhXdjcAG+iysw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        pavel@denx.de, stable@vger.kernel.org
Subject: [PATCH 4.19 00/78] 4.19.146-rc1 review
Date:   Tue, 15 Sep 2020 16:12:25 +0200
Message-Id: <20200915140633.552502750@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.146-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.146-rc1
X-KernelTest-Deadline: 2020-09-17T14:06+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.19.146 release.
There are 78 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 17 Sep 2020 14:06:12 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.146-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.19.146-rc1

Heikki Krogerus <heikki.krogerus@linux.intel.com>
    usb: typec: ucsi: acpi: Check the _DEP dependencies

Mathias Nyman <mathias.nyman@linux.intel.com>
    usb: Fix out of sync data toggle if a configured device is reconfigured

Aleksander Morgado <aleksander@aleksander.es>
    USB: serial: option: add support for SIM7070/SIM7080/SIM7090 modules

Bjørn Mork <bjorn@mork.no>
    USB: serial: option: support dynamic Quectel USB compositions

Patrick Riphagen <patrick.riphagen@xsens.com>
    USB: serial: ftdi_sio: add IDs for Xsens Mti USB converter

Zeng Tao <prime.zeng@hisilicon.com>
    usb: core: fix slab-out-of-bounds Read in read_descriptors

Sivaprakash Murugesan <sivaprak@codeaurora.org>
    phy: qcom-qmp: Use correct values for ipq8074 PCIe Gen2 PHY init

Vaibhav Agarwal <vaibhav.sr@gmail.com>
    staging: greybus: audio: fix uninitialized value issue

Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
    video: fbdev: fix OOB read in vga_8planes_imageblit()

Chris Healy <cphealy@gmail.com>
    ARM: dts: vfxxx: Add syscon compatible with OCOTP

Wanpeng Li <wanpengli@tencent.com>
    KVM: VMX: Don't freeze guest when event delivery causes an APIC-access exit

Linus Torvalds <torvalds@linux-foundation.org>
    fbcon: remove now unusued 'softback_lines' cursor() argument

Linus Torvalds <torvalds@linux-foundation.org>
    fbcon: remove soft scrollback code

Linus Torvalds <torvalds@linux-foundation.org>
    vgacon: remove software scrollback support

Yi Zhang <yi.zhang@redhat.com>
    RDMA/rxe: Fix the parent sysfs read when the interface has 15 chars

Ilya Dryomov <idryomov@gmail.com>
    rbd: require global CAP_SYS_ADMIN for mapping and unmapping

Jordan Crouse <jcrouse@codeaurora.org>
    drm/msm: Disable preemption on all 5xx targets

Linus Walleij <linus.walleij@linaro.org>
    drm/tve200: Stabilize enable/disable

Hou Pu <houpu@bytedance.com>
    scsi: target: iscsi: Fix hang in iscsit_access_np() when getting tpg->np_login_sem

Varun Prakash <varun@chelsio.com>
    scsi: target: iscsi: Fix data digest calculation

Michał Mirosław <mirq-linux@rere.qmqm.pl>
    regulator: push allocation in set_consumer_device_supply() out of lock

Filipe Manana <fdmanana@suse.com>
    btrfs: fix wrong address when faulting in pages in the search ioctl

Josef Bacik <josef@toxicpanda.com>
    btrfs: fix lockdep splat in add_missing_dev

Qu Wenruo <wqu@suse.com>
    btrfs: require only sector size alignment for parent eb bytenr

Rustam Kovhaev <rkovhaev@gmail.com>
    staging: wlan-ng: fix out of bounds read in prism2sta_probe_usb()

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio:accel:mma8452: Fix timestamp alignment and prevent data leak.

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio:accel:mma7455: Fix timestamp alignment and prevent data leak.

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio: accel: kxsd9: Fix alignment of local buffer.

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio:chemical:ccs811: Fix timestamp alignment and prevent data leak.

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio:light:max44000 Fix timestamp alignment and prevent data leak.

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio:magnetometer:ak8975 Fix alignment and data leak issues.

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio:adc:ti-adc081c Fix alignment and data leak issues

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio:adc:max1118 Fix alignment of timestamp and data leak issues

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio:adc:ina2xx Fix timestamp alignment issue.

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio:adc:ti-adc084s021 Fix alignment and data leak issues.

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio:accel:bmc150-accel: Fix timestamp alignment and prevent data leak.

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio:light:ltr501 Fix timestamp alignment issue.

Maxim Kochetkov <fido_max@inbox.ru>
    iio: adc: ti-ads1015: fix conversion when CONFIG_PM is not set

Angelo Compagnucci <angelo.compagnucci@gmail.com>
    iio: adc: mcp3422: fix locking scope

Leon Romanovsky <leonro@nvidia.com>
    gcov: Disable gcov build with GCC 10

Joerg Roedel <jroedel@suse.de>
    iommu/amd: Do not use IOMMUv2 functionality when SME is active

Sandeep Raghuraman <sandy.8925@gmail.com>
    drm/amdgpu: Fix bug in reporting voltage for CIK

Rander Wang <rander.wang@intel.com>
    ALSA: hda: fix a runtime pm issue in SOF when integrated GPU is disabled

Francisco Jerez <currojerez@riseup.net>
    cpufreq: intel_pstate: Fix intel_pstate_get_hwp_max() for turbo disabled

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    cpufreq: intel_pstate: Refuse to turn off with HWP enabled

Evgeniy Didin <Evgeniy.Didin@synopsys.com>
    ARC: [plat-hsdk]: Switch ethernet phy-mode to rgmii-id

Dinghao Liu <dinghao.liu@zju.edu.cn>
    HID: elan: Fix memleak in elan_input_configured

Xie He <xie.he.0141@gmail.com>
    drivers/net/wan/hdlc_cisco: Add hard_header_len

Nirenjan Krishnan <nirenjan@gmail.com>
    HID: quirks: Set INCREMENT_USAGE_ON_DUPLICATE for all Saitek X52 devices

Sagi Grimberg <sagi@grimberg.me>
    nvme-rdma: serialize controller teardown sequences

Sagi Grimberg <sagi@grimberg.me>
    nvme: have nvme_wait_freeze_timeout return if it timed out

Sagi Grimberg <sagi@grimberg.me>
    nvme-fabrics: don't check state NVME_CTRL_NEW for request acceptance

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

Florian Westphal <fw@strlen.de>
    netfilter: conntrack: allow sctp hearbeat after connection re-use

Hanjun Guo <guohanjun@huawei.com>
    dmaengine: acpi: Put the CSRT table after using it

Vineet Gupta <vgupta@synopsys.com>
    ARC: HSDK: wireup perf irq

Florian Fainelli <f.fainelli@gmail.com>
    arm64: dts: ns2: Fixed QSPI compatible string

Florian Fainelli <f.fainelli@gmail.com>
    ARM: dts: BCM5301X: Fixed QSPI compatible string

Florian Fainelli <f.fainelli@gmail.com>
    ARM: dts: NSP: Fixed QSPI compatible string

Florian Fainelli <f.fainelli@gmail.com>
    ARM: dts: bcm: HR2: Fixed QSPI compatible string

Douglas Anderson <dianders@chromium.org>
    mmc: sdhci-msm: Add retries when all tuning phases are found valid

Kamal Heib <kamalheib1@gmail.com>
    RDMA/core: Fix reported speed and width

Luo Jiaxing <luojiaxing@huawei.com>
    scsi: libsas: Set data_dir as DMA_NONE if libata marks qc as NODATA

Angelo Compagnucci <angelo.compagnucci@gmail.com>
    iio: adc: mcp3422: fix locking on error path

Ondrej Jirman <megous@megous.com>
    drm/sun4i: Fix dsi dcs long write function

Selvin Xavier <selvin.xavier@broadcom.com>
    RDMA/bnxt_re: Do not report transparent vlan from QP1

Kamal Heib <kamalheib1@gmail.com>
    RDMA/rxe: Drop pointless checks in rxe_init_ports

Dinghao Liu <dinghao.liu@zju.edu.cn>
    RDMA/rxe: Fix memleak in rxe_mem_init_user

Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
    ARM: dts: ls1021a: fix QuadSPI-memory reg range

Dinh Nguyen <dinguyen@kernel.org>
    ARM: dts: socfpga: fix register entry for timer3 on Arria10

Adam Ford <aford173@gmail.com>
    ARM: dts: logicpd-som-lv-baseboard: Fix broken audio

Adam Ford <aford173@gmail.com>
    ARM: dts: logicpd-torpedo-baseboard: Fix broken audio


-------------

Diffstat:

 Makefile                                         |   4 +-
 arch/arc/boot/dts/hsdk.dts                       |   6 +-
 arch/arc/plat-eznps/include/plat/ctop.h          |   1 -
 arch/arm/boot/dts/bcm-hr2.dtsi                   |   2 +-
 arch/arm/boot/dts/bcm-nsp.dtsi                   |   2 +-
 arch/arm/boot/dts/bcm5301x.dtsi                  |   2 +-
 arch/arm/boot/dts/logicpd-som-lv-baseboard.dtsi  |   2 +
 arch/arm/boot/dts/logicpd-torpedo-baseboard.dtsi |   2 +
 arch/arm/boot/dts/ls1021a.dtsi                   |   2 +-
 arch/arm/boot/dts/socfpga_arria10.dtsi           |   2 +-
 arch/arm/boot/dts/vfxxx.dtsi                     |   2 +-
 arch/arm64/boot/dts/broadcom/northstar2/ns2.dtsi |   2 +-
 arch/powerpc/configs/pasemi_defconfig            |   1 -
 arch/powerpc/configs/ppc6xx_defconfig            |   1 -
 arch/x86/configs/i386_defconfig                  |   1 -
 arch/x86/configs/x86_64_defconfig                |   1 -
 arch/x86/kvm/vmx.c                               |   1 +
 drivers/atm/firestream.c                         |   1 +
 drivers/block/rbd.c                              |  12 +
 drivers/cpufreq/intel_pstate.c                   |  14 +-
 drivers/dma/acpi-dma.c                           |   4 +-
 drivers/gpu/drm/amd/powerplay/hwmgr/smu7_hwmgr.c |   3 +-
 drivers/gpu/drm/msm/adreno/a5xx_gpu.c            |   3 +-
 drivers/gpu/drm/sun4i/sun6i_mipi_dsi.c           |   4 +-
 drivers/gpu/drm/tve200/tve200_display.c          |  22 +-
 drivers/hid/hid-elan.c                           |   2 +
 drivers/hid/hid-ids.h                            |   2 +
 drivers/hid/hid-quirks.c                         |   2 +
 drivers/iio/accel/bmc150-accel-core.c            |  15 +-
 drivers/iio/accel/kxsd9.c                        |  16 +-
 drivers/iio/accel/mma7455_core.c                 |  16 +-
 drivers/iio/accel/mma8452.c                      |  11 +-
 drivers/iio/adc/ina2xx-adc.c                     |  11 +-
 drivers/iio/adc/max1118.c                        |  10 +-
 drivers/iio/adc/mcp3422.c                        |  16 +-
 drivers/iio/adc/ti-adc081c.c                     |  11 +-
 drivers/iio/adc/ti-adc084s021.c                  |  10 +-
 drivers/iio/adc/ti-ads1015.c                     |  10 +
 drivers/iio/chemical/ccs811.c                    |  13 +-
 drivers/iio/light/ltr501.c                       |  15 +-
 drivers/iio/light/max44000.c                     |  12 +-
 drivers/iio/magnetometer/ak8975.c                |  16 +-
 drivers/infiniband/core/verbs.c                  |   2 +-
 drivers/infiniband/hw/bnxt_re/ib_verbs.c         |  21 +-
 drivers/infiniband/sw/rxe/rxe.c                  |   3 -
 drivers/infiniband/sw/rxe/rxe_mr.c               |   1 +
 drivers/infiniband/sw/rxe/rxe_verbs.c            |   2 +-
 drivers/iommu/amd_iommu_v2.c                     |   7 +
 drivers/mmc/host/sdhci-msm.c                     |  18 +-
 drivers/net/wan/hdlc_cisco.c                     |   1 +
 drivers/net/wan/lapbether.c                      |   3 +
 drivers/nfc/st95hf/core.c                        |   2 +-
 drivers/nvme/host/core.c                         |   3 +-
 drivers/nvme/host/fabrics.c                      |   1 -
 drivers/nvme/host/nvme.h                         |   2 +-
 drivers/nvme/host/rdma.c                         |   6 +
 drivers/phy/qualcomm/phy-qcom-qmp.c              |  16 +-
 drivers/phy/qualcomm/phy-qcom-qmp.h              |   2 +
 drivers/regulator/core.c                         |  46 ++--
 drivers/scsi/libsas/sas_ata.c                    |   5 +-
 drivers/staging/greybus/audio_topology.c         |  29 +-
 drivers/staging/wlan-ng/hfa384x_usb.c            |   5 -
 drivers/staging/wlan-ng/prism2usb.c              |  19 +-
 drivers/target/iscsi/iscsi_target.c              |  17 +-
 drivers/target/iscsi/iscsi_target_login.c        |   6 +-
 drivers/target/iscsi/iscsi_target_login.h        |   3 +-
 drivers/target/iscsi/iscsi_target_nego.c         |   3 +-
 drivers/usb/core/message.c                       |  91 +++---
 drivers/usb/core/sysfs.c                         |   5 +
 drivers/usb/serial/ftdi_sio.c                    |   1 +
 drivers/usb/serial/ftdi_sio_ids.h                |   1 +
 drivers/usb/serial/option.c                      |  22 +-
 drivers/usb/typec/ucsi/ucsi_acpi.c               |   4 +
 drivers/video/console/Kconfig                    |  46 ----
 drivers/video/console/vgacon.c                   | 221 +--------------
 drivers/video/fbdev/core/bitblit.c               |  11 +-
 drivers/video/fbdev/core/fbcon.c                 | 334 +----------------------
 drivers/video/fbdev/core/fbcon.h                 |   2 +-
 drivers/video/fbdev/core/fbcon_ccw.c             |  11 +-
 drivers/video/fbdev/core/fbcon_cw.c              |  11 +-
 drivers/video/fbdev/core/fbcon_ud.c              |  11 +-
 drivers/video/fbdev/core/tileblit.c              |   2 +-
 drivers/video/fbdev/vga16fb.c                    |   2 +-
 fs/btrfs/extent-tree.c                           |  19 +-
 fs/btrfs/ioctl.c                                 |   3 +-
 fs/btrfs/print-tree.c                            |  12 +-
 fs/btrfs/volumes.c                               |  10 +
 fs/xfs/libxfs/xfs_attr_leaf.c                    |   4 +-
 include/linux/netfilter/nf_conntrack_sctp.h      |   2 +
 include/soc/nps/common.h                         |   6 +
 kernel/gcov/Kconfig                              |   1 +
 net/netfilter/nf_conntrack_proto_sctp.c          |  39 ++-
 sound/hda/hdac_device.c                          |   2 +
 sound/pci/hda/patch_hdmi.c                       |   5 +
 94 files changed, 507 insertions(+), 879 deletions(-)


