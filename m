Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 344DE506E5
	for <lists+stable@lfdr.de>; Mon, 24 Jun 2019 12:06:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729372AbfFXKCb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jun 2019 06:02:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:33638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729384AbfFXKC3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Jun 2019 06:02:29 -0400
Received: from localhost (f4.8f.5177.ip4.static.sl-reverse.com [119.81.143.244])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1EE68208E3;
        Mon, 24 Jun 2019 10:02:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561370547;
        bh=5yU7w0VWL4ZckwQT6RD0XEBi5ssadiQBz/6aJL1f9KA=;
        h=From:To:Cc:Subject:Date:From;
        b=GG/yKpgpEFDq7VkxxSACZ3Vvmd6Fj4i0Dz0y1qnLljXc0VCkCWosNgbcN06YT4hzv
         wpE/5XO4G97kbtQ5LWjhKScZ405avVdJ3iP35Iu9NauXVRXUs+N8dfP5dMoeD+yINO
         862gSOimuxLZ/Ez8u+6SppzGht9DNKbsgrLkn2nY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.19 00/90] 4.19.56-stable review
Date:   Mon, 24 Jun 2019 17:55:50 +0800
Message-Id: <20190624092313.788773607@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.56-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.56-rc1
X-KernelTest-Deadline: 2019-06-26T09:23+00:00
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.19.56 release.
There are 90 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed 26 Jun 2019 09:22:03 AM UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.56-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.19.56-rc1

James Morse <james.morse@arm.com>
    x86/resctrl: Don't stop walking closids when a locksetup group is found

Jouni Malinen <j@w1.fi>
    mac80211: Do not use stack memory with scatterlist for GMAC

Andy Strohman <andrew@andrewstrohman.com>
    nl80211: fix station_info pertid memory leak

Yu Wang <yyuwang@codeaurora.org>
    mac80211: handle deauthentication/disassociation from TDLS peer

Manikanta Pubbisetty <mpubbise@codeaurora.org>
    {nl,mac}80211: allow 4addr AP operation on crypto controlled devices

Johannes Berg <johannes.berg@intel.com>
    mac80211: drop robust management frames from unknown TA

Eric Biggers <ebiggers@google.com>
    cfg80211: fix memory leak of wiphy device name

Steve French <stfrench@microsoft.com>
    SMB3: retry on STATUS_INSUFFICIENT_RESOURCES instead of failing write

Marcel Holtmann <marcel@holtmann.org>
    Bluetooth: Fix regression with minimum encryption key size alignment

Marcel Holtmann <marcel@holtmann.org>
    Bluetooth: Align minimum encryption key size for LE and BR/EDR connections

Gao Xiang <gaoxiang25@huawei.com>
    staging: erofs: add requirements field in superblock

Thomas Hellstrom <thellstrom@vmware.com>
    drm/vmwgfx: Use the backdoor port if the HB port is not available

Anisse Astier <aastier@freebox.fr>
    arm64: ssbd: explicitly depend on <linux/prctl.h>

Anisse Astier <aastier@freebox.fr>
    arm64/sve: <uapi/asm/ptrace.h> should not depend on <uapi/linux/prctl.h>

Faiz Abbas <faiz_abbas@ti.com>
    ARM: dts: am57xx-idk: Remove support for voltage switching for SD card

Faiz Abbas <faiz_abbas@ti.com>
    ARM: dts: dra76x: Update MMC2_HS200_MANUAL1 iodelay values

Fabio Estevam <festevam@gmail.com>
    ARM: imx: cpuidle-imx6sx: Restrict the SW2ISO increase to i.MX6SX

Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
    powerpc/bpf: use unsigned division instruction for 64-bit operations

ShihPo Hung <shihpo.hung@sifive.com>
    riscv: mm: synchronize MMU after pte change

Willem de Bruijn <willemb@google.com>
    can: purge socket error queue on sock destruct

Joakim Zhang <qiangqing.zhang@nxp.com>
    can: flexcan: fix timeout when set small bitrate

Anssi Hannula <anssi.hannula@bitwise.fi>
    can: xilinx_can: use correct bittiming_const for CAN FD core

Naohiro Aota <naohiro.aota@wdc.com>
    btrfs: start readahead also in seed devices

Jaesoo Lee <jalee@purestorage.com>
    nvme: Fix u32 overflow in the number of namespace list calculation

Dave Martin <Dave.Martin@arm.com>
    arm64: Silence gcc warnings about arch ABI drift

Robert Hancock <hancock@sedsystems.ca>
    hwmon: (pmbus/core) Treat parameters as paged if on multiple pages

Eduardo Valentin <eduval@amazon.com>
    hwmon: (core) add thermal sensors only if dev->of_node is present

Alexandra Winter <wintera@linux.ibm.com>
    s390/qeth: fix VLAN attribute in bridge_hostnotify udev event

Miaohe Lin <linmiaohe@huawei.com>
    net: ipvlan: Fix ipvlan device tso disabled while NETIF_F_IP_CSUM is set

Dan Carpenter <dan.carpenter@oracle.com>
    scsi: smartpqi: unlock on error in pqi_submit_raid_request_synchronous()

Avri Altman <avri.altman@wdc.com>
    scsi: ufs: Check that space was properly alloced in copy_query_response

George G. Davis <george_davis@mentor.com>
    scripts/checkstack.pl: Fix arm64 wrong or unknown architecture

Minwoo Im <minwoo.im.dev@gmail.com>
    nvmet: fix data_len to 0 for bdev-backed write_zeroes

Robin Murphy <robin.murphy@arm.com>
    drm/arm/hdlcd: Allow a bit of clock tolerance

Robin Murphy <robin.murphy@arm.com>
    drm/arm/hdlcd: Actually validate CRTC modes

Wen He <wen.he_1@nxp.com>
    drm/arm/mali-dp: Add a loop around the second set CVAL and try 5 times

Sean Wang <sean.wang@mediatek.com>
    net: ethernet: mediatek: Use NET_IP_ALIGN to judge if HW RX_2BYTE_OFFSET is enabled

Sean Wang <sean.wang@mediatek.com>
    net: ethernet: mediatek: Use hw_feature to judge if HWLRO is supported

Young Xiao <92siuyang@gmail.com>
    sparc: perf: fix updated event period in response to PERF_EVENT_IOC_PERIOD

Gen Zhang <blackgod016574@gmail.com>
    mdesc: fix a missing-check bug in get_vdev_port_node_info()

Yonglong Liu <liuyonglong@huawei.com>
    net: hns: Fix loopback test failed at copper ports

Nikita Yushchenko <nikita.yoush@cogentembedded.com>
    net: dsa: mv88e6xxx: avoid error message on remove from VLAN 0

Naresh Kamboju <naresh.kamboju@linaro.org>
    selftests: vm: install test_vmalloc.sh for run_vmtests

Alex Shi <alex.shi@linux.alibaba.com>
    kselftest/cgroup: fix incorrect test_core skip

Alex Shi <alex.shi@linux.alibaba.com>
    kselftest/cgroup: fix unexpected testing failure on test_core

Alex Shi <alex.shi@linux.alibaba.com>
    kselftest/cgroup: fix unexpected testing failure on test_memcontrol

Guenter Roeck <linux@roeck-us.net>
    xtensa: Fix section mismatch between memblock_reserve and mem_reserve

YueHaibing <yuehaibing@huawei.com>
    MIPS: uprobes: remove set but not used variable 'epc'

Kamenee Arumugam <kamenee.arumugam@intel.com>
    IB/hfi1: Validate page aligned for a given virtual address

Mike Marciniszyn <mike.marciniszyn@intel.com>
    IB/{qib, hfi1, rdmavt}: Correct ibv_devinfo max_mr value

Mike Marciniszyn <mike.marciniszyn@intel.com>
    IB/hfi1: Insure freeze_work work_struct is canceled on shutdown

Mike Marciniszyn <mike.marciniszyn@intel.com>
    IB/rdmavt: Fix alloc_qpn() WARN_ON()

Helge Deller <deller@gmx.de>
    parisc: Fix compiler warnings in float emulation code

YueHaibing <yuehaibing@huawei.com>
    parport: Fix mem leak in parport_register_dev_model

Scott Wood <swood@redhat.com>
    fpga: dfl: Add lockdep classes for pdata->lock

Scott Wood <swood@redhat.com>
    fpga: dfl: afu: Pass the correct device to dma_mapping_error()

Jose Abreu <joabreu@synopsys.com>
    ARC: [plat-hsdk]: Add missing FIFO size entry in GMAC node

Jose Abreu <joabreu@synopsys.com>
    ARC: [plat-hsdk]: Add missing multicast filter bins number to GMAC node

Eric Long <eric.long@unisoc.com>
    dmaengine: sprd: Fix block length overflow

Colin Ian King <colin.king@canonical.com>
    dmaengine: dw-axi-dmac: fix null dereference when pointer first is null

Vineet Gupta <vgupta@synopsys.com>
    ARC: fix build warnings

Douglas Anderson <dianders@chromium.org>
    brcmfmac: sdio: Don't tune while the card is off

Douglas Anderson <dianders@chromium.org>
    brcmfmac: sdio: Disable auto-tuning around commands expected to fail

Jann Horn <jannh@google.com>
    apparmor: enforce nullbyte at end of tag string

John Johansen <john.johansen@canonical.com>
    apparmor: fix PROFILE_MEDIATES for untrusted input

Daniel Smith <danct12@disroot.org>
    Input: silead - add MSSL0017 to acpi_device_id

Andrey Smirnov <andrew.smirnov@gmail.com>
    Input: uinput - add compat ioctl number translation for UI_*_FF_UPLOAD

Alexander Mikhaylenko <exalm7659@gmail.com>
    Input: synaptics - enable SMBus on ThinkPad E480 and E580

Crt Mori <cmo@melexis.com>
    iio: temperature: mlx90632 Relax the compatibility check

Mike Marciniszyn <mike.marciniszyn@intel.com>
    IB/hfi1: Silence txreq allocation warnings

Kaike Wan <kaike.wan@intel.com>
    IB/hfi1: Validate fault injection opcode user input

Mathias Nyman <mathias.nyman@linux.intel.com>
    usb: xhci: Don't try to recover an endpoint if port is in error state.

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: detect USB 3.2 capable host controllers correctly

Peter Chen <peter.chen@nxp.com>
    usb: chipidea: udc: workaround for endpoint conflict issue

Stanley Chu <stanley.chu@mediatek.com>
    scsi: ufs: Avoid runtime suspend possibly being blocked forever

Ulf Hansson <ulf.hansson@linaro.org>
    mmc: core: Prevent processing SDIO IRQs when the card is suspended

Douglas Anderson <dianders@chromium.org>
    mmc: core: Add sdio_retune_hold_now() and sdio_retune_release()

Douglas Anderson <dianders@chromium.org>
    mmc: core: API to temporarily disable retuning for SDIO CRC errors

Raul E Rangel <rrangel@chromium.org>
    mmc: sdhci: sdhci-pci-o2micro: Correctly set bus width when tuning

Harald Freudenberger <freude@linux.ibm.com>
    s390/ap: rework assembler functions to use unions for in/out register variables

Ilya Leoshkevich <iii@linux.ibm.com>
    s390/jump_label: Use "jdd" constraint on gcc9

Arnd Bergmann <arnd@arndb.de>
    ovl: fix bogus -Wmaybe-unitialized warning

Miklos Szeredi <mszeredi@redhat.com>
    ovl: don't fail with disconnected lower NFS

Amir Goldstein <amir73il@gmail.com>
    ovl: detect overlapping layers

Amir Goldstein <amir73il@gmail.com>
    ovl: make i_ino consistent with st_ino in more cases

Amir Goldstein <amir73il@gmail.com>
    ovl: fix wrong flags check in FS_IOC_FS[SG]ETXATTR ioctls

Amir Goldstein <amir73il@gmail.com>
    ovl: support the FS_IOC_FS[SG]ETXATTR ioctls

Linus Torvalds <torvalds@linux-foundation.org>
    gcc-9: silence 'address-of-packed-member' warning

Allan Xavier <allan.x.xavier@oracle.com>
    objtool: Support per-function rodata sections

Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
    tracing: Silence GCC 9 array bounds warning


-------------

Diffstat:

 Makefile                                           |   6 +-
 arch/arc/boot/dts/hsdk.dts                         |   4 +
 arch/arc/include/asm/cmpxchg.h                     |  14 +-
 arch/arc/mm/tlb.c                                  |  13 +-
 arch/arm/boot/dts/am57xx-idk-common.dtsi           |   1 +
 arch/arm/boot/dts/dra76x-mmc-iodelay.dtsi          |  40 ++---
 arch/arm/mach-imx/cpuidle-imx6sx.c                 |   3 +-
 arch/arm64/Makefile                                |   1 +
 arch/arm64/include/uapi/asm/ptrace.h               |   8 +-
 arch/arm64/kernel/ssbd.c                           |   1 +
 arch/mips/kernel/uprobes.c                         |   3 -
 arch/parisc/math-emu/cnv_float.h                   |   8 +-
 arch/powerpc/include/asm/ppc-opcode.h              |   1 +
 arch/powerpc/net/bpf_jit.h                         |   2 +-
 arch/powerpc/net/bpf_jit_comp64.c                  |   8 +-
 arch/riscv/mm/fault.c                              |  13 ++
 arch/s390/include/asm/ap.h                         |  28 ++--
 arch/s390/include/asm/jump_label.h                 |  14 +-
 arch/sparc/kernel/mdesc.c                          |   2 +
 arch/sparc/kernel/perf_event.c                     |   4 +
 arch/x86/kernel/cpu/intel_rdt_rdtgroup.c           |   2 +-
 arch/xtensa/kernel/setup.c                         |   3 +-
 drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c     |   3 +-
 drivers/dma/sprd-dma.c                             |   2 +-
 drivers/fpga/dfl-afu-dma-region.c                  |   2 +-
 drivers/fpga/dfl.c                                 |  16 +-
 drivers/gpu/drm/arm/hdlcd_crtc.c                   |  14 +-
 drivers/gpu/drm/arm/malidp_drv.c                   |  13 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_msg.c                | 146 +++++++++++++++----
 drivers/hwmon/hwmon.c                              |   2 +-
 drivers/hwmon/pmbus/pmbus_core.c                   |  34 ++++-
 drivers/iio/temperature/mlx90632.c                 |   9 +-
 drivers/infiniband/hw/hfi1/chip.c                  |   1 +
 drivers/infiniband/hw/hfi1/fault.c                 |   5 +
 drivers/infiniband/hw/hfi1/user_exp_rcv.c          |   3 +
 drivers/infiniband/hw/hfi1/verbs.c                 |   2 -
 drivers/infiniband/hw/hfi1/verbs_txreq.c           |   2 +-
 drivers/infiniband/hw/hfi1/verbs_txreq.h           |   3 +-
 drivers/infiniband/hw/qib/qib_verbs.c              |   2 -
 drivers/infiniband/sw/rdmavt/mr.c                  |   2 +
 drivers/infiniband/sw/rdmavt/qp.c                  |   3 +-
 drivers/input/misc/uinput.c                        |  22 ++-
 drivers/input/mouse/synaptics.c                    |   2 +
 drivers/input/touchscreen/silead.c                 |   1 +
 drivers/mmc/core/core.c                            |   5 +-
 drivers/mmc/core/sdio.c                            |  13 +-
 drivers/mmc/core/sdio_io.c                         |  77 ++++++++++
 drivers/mmc/core/sdio_irq.c                        |   4 +
 drivers/mmc/host/sdhci-pci-o2micro.c               |   5 +-
 drivers/net/can/flexcan.c                          |   2 +-
 drivers/net/can/xilinx_can.c                       |   2 +-
 drivers/net/dsa/mv88e6xxx/chip.c                   |   2 +-
 drivers/net/ethernet/hisilicon/hns/hns_ethtool.c   |   4 +
 drivers/net/ethernet/mediatek/mtk_eth_soc.c        |  15 +-
 drivers/net/ipvlan/ipvlan_main.c                   |   2 +-
 .../wireless/broadcom/brcm80211/brcmfmac/sdio.c    |  11 ++
 drivers/nvme/host/core.c                           |   3 +-
 drivers/nvme/target/io-cmd-bdev.c                  |   1 +
 drivers/parport/share.c                            |   2 +
 drivers/s390/net/qeth_l2_main.c                    |   2 +-
 drivers/scsi/smartpqi/smartpqi_init.c              |   6 +-
 drivers/scsi/ufs/ufshcd-pltfrm.c                   |  11 +-
 drivers/scsi/ufs/ufshcd.c                          |   3 +-
 drivers/staging/erofs/erofs_fs.h                   |  13 +-
 drivers/staging/erofs/internal.h                   |   2 +
 drivers/staging/erofs/super.c                      |  19 +++
 drivers/usb/chipidea/udc.c                         |  20 +++
 drivers/usb/host/xhci-ring.c                       |  15 +-
 drivers/usb/host/xhci.c                            |  25 +++-
 drivers/usb/host/xhci.h                            |   9 ++
 fs/btrfs/reada.c                                   |   5 +
 fs/cifs/smb2maperror.c                             |   2 +-
 fs/overlayfs/file.c                                |  96 ++++++++----
 fs/overlayfs/inode.c                               |  60 +++++++-
 fs/overlayfs/namei.c                               |   8 +
 fs/overlayfs/overlayfs.h                           |   3 +
 fs/overlayfs/ovl_entry.h                           |   6 +
 fs/overlayfs/super.c                               | 161 ++++++++++++++++++---
 fs/overlayfs/util.c                                |  12 ++
 include/linux/mmc/host.h                           |   1 +
 include/linux/mmc/sdio_func.h                      |   6 +
 include/net/bluetooth/hci_core.h                   |   3 +
 include/net/cfg80211.h                             |   3 +-
 kernel/trace/trace.c                               |   6 +-
 kernel/trace/trace.h                               |  18 +++
 kernel/trace/trace_kdb.c                           |   6 +-
 net/bluetooth/hci_conn.c                           |  10 +-
 net/bluetooth/l2cap_core.c                         |  33 ++++-
 net/can/af_can.c                                   |   1 +
 net/mac80211/ieee80211_i.h                         |   3 +
 net/mac80211/mlme.c                                |  12 +-
 net/mac80211/rx.c                                  |   2 +
 net/mac80211/tdls.c                                |  23 +++
 net/mac80211/util.c                                |   4 +-
 net/mac80211/wpa.c                                 |   7 +-
 net/wireless/core.c                                |   8 +-
 net/wireless/nl80211.c                             |  12 +-
 scripts/checkstack.pl                              |   2 +-
 security/apparmor/include/policy.h                 |  11 +-
 security/apparmor/policy_unpack.c                  |   2 +-
 tools/objtool/check.c                              |  38 ++++-
 tools/objtool/check.h                              |   4 +-
 tools/objtool/elf.c                                |   1 +
 tools/objtool/elf.h                                |   3 +-
 tools/testing/selftests/cgroup/test_core.c         |   7 +-
 tools/testing/selftests/cgroup/test_memcontrol.c   |   4 +
 tools/testing/selftests/vm/Makefile                |   2 +
 107 files changed, 1079 insertions(+), 247 deletions(-)


