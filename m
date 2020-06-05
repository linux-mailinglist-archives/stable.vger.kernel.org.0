Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3CD21EFAEE
	for <lists+stable@lfdr.de>; Fri,  5 Jun 2020 16:22:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728202AbgFEOTI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Jun 2020 10:19:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:49836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728218AbgFEOTH (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Jun 2020 10:19:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 229DF208C9;
        Fri,  5 Jun 2020 14:19:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591366746;
        bh=4AYNGIO5deJtJgXi/C/P/lMeFY5cGq1Z30gv5VQkU7Q=;
        h=From:To:Cc:Subject:Date:From;
        b=jba43IaNfZzRMuakr3O2gj/DUbHFwnLhTNTyjvKW+fLVX/iRyr771voDapKCgflTj
         fV8kdUiSlPs/H79aZDDf9Vdqc3z1yAOqcJJI00ukt3G/RVezSWvkGccjAZUYcgBhuY
         BzMysRnjDytHePrfl0Fa+yzZZ0Wy/OFJRT6QIYf4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 5.4 00/38] 5.4.45-rc1 review
Date:   Fri,  5 Jun 2020 16:14:43 +0200
Message-Id: <20200605140252.542768750@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-5.4.45-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.45-rc1
X-KernelTest-Deadline: 2020-06-07T14:02+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.4.45 release.
There are 38 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun, 07 Jun 2020 13:54:56 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.45-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.4.45-rc1

Dinghao Liu <dinghao.liu@zju.edu.cn>
    net: smsc911x: Fix runtime PM imbalance on error

Amit Cohen <amitc@mellanox.com>
    selftests: mlxsw: qos_mc_aware: Specify arping timeout as an integer

Jonathan McDowell <noodles@earth.li>
    net: ethernet: stmmac: Enable interface clocks on probe for IPQ806x

Valentin Longchamp <valentin@longchamp.me>
    net/ethernet/freescale: rework quiesce/activate for ucc_geth

Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
    null_blk: return error for invalid zone size

Gerald Schaefer <gerald.schaefer@de.ibm.com>
    s390/mm: fix set_huge_pte_at() for empty ptes

Jan Schmidt <jan@centricular.com>
    drm/edid: Add Oculus Rift S to non-desktop list

Jeremy Kerr <jk@ozlabs.org>
    net: bmac: Fix read of MAC address from ROM

Nathan Chancellor <natechancellor@gmail.com>
    x86/mmiotrace: Use cpumask_available() for cpumask_var_t variables

Jens Axboe <axboe@kernel.dk>
    io_uring: initialize ctx->sqo_wait earlier

Atsushi Nemoto <atsushi.nemoto@sord.co.jp>
    i2c: altera: Fix race between xfer_msg and isr thread

Can Guo <cang@codeaurora.org>
    scsi: pm: Balance pm_only counter of request queue during system resume

Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
    evm: Fix RCU list related warnings

Vineet Gupta <vgupta@synopsys.com>
    ARC: [plat-eznps]: Restrict to CONFIG_ISA_ARCOMPACT

Eugeniy Paltsev <Eugeniy.Paltsev@synopsys.com>
    ARC: Fix ICCM & DCCM runtime size checks

Michal Kalderon <michal.kalderon@marvell.com>
    RDMA/qedr: Fix synchronization methods and memory leaks in qedr

Michal Kalderon <michal.kalderon@marvell.com>
    RDMA/qedr: Fix qpids xarray api used

Vasily Gorbik <gor@linux.ibm.com>
    s390/ftrace: save traced function caller

Jaroslav Kysela <perex@perex.cz>
    ASoC: intel - fix the card names

Xinwei Kong <kong.kongxinwei@hisilicon.com>
    spi: dw: use "smp_mb()" to avoid sending spi data error

Christopher M. Riedl <cmr@informatik.wtf>
    powerpc/xmon: Restrict when kernel is locked down

Anju T Sudhakar <anju@linux.vnet.ibm.com>
    powerpc/powernv: Avoid re-registration of imc debugfs directory

Xiang Chen <chenxiang66@hisilicon.com>
    scsi: hisi_sas: Check sas_port before using it

Lucas De Marchi <lucas.demarchi@intel.com>
    drm/i915: fix port checks for MST support on gen >= 11

Dan Carpenter <dan.carpenter@oracle.com>
    airo: Fix read overflows sending packets

DENG Qingfang <dqfext@gmail.com>
    net: dsa: mt7530: set CPU port to fallback mode

Can Guo <cang@codeaurora.org>
    scsi: ufs: Release clock if DMA map fails

Sakari Ailus <sakari.ailus@linux.intel.com>
    media: staging: ipu3-imgu: Move alignment attribute to field

Sakari Ailus <sakari.ailus@linux.intel.com>
    media: Revert "staging: imgu: Address a compiler warning on alignment"

Jérôme Pouiller <jerome.pouiller@silabs.com>
    mmc: fix compilation of user API

Daniel Axtens <dja@axtens.net>
    kernel/relay.c: handle alloc_percpu returning NULL in relay_open

Matthew Garrett <matthewgarrett@google.com>
    mt76: mt76x02u: Add support for newer versions of the XBox One wifi adapter

Giuseppe Marco Randazzo <gmrandazzo@gmail.com>
    p54usb: add AirVasT USB stick device-id

Julian Sax <jsbc@gmx.de>
    HID: i2c-hid: add Schneider SCL142ALM to descriptor override

Benjamin Tissoires <benjamin.tissoires@redhat.com>
    HID: multitouch: enable multi-input as a quirk for some devices

Scott Shumate <scott.shumate@gmail.com>
    HID: sony: Fix for broken buttons on DS3 USB dongles

Fan Yang <Fan_Yang@sjtu.edu.cn>
    mm: Fix mremap not considering huge pmd devmap

Tejun Heo <tj@kernel.org>
    Revert "cgroup: Add memory barriers to plug cgroup_rstat_updated() race window"


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/arc/kernel/setup.c                            |   5 +-
 arch/arc/plat-eznps/Kconfig                        |   1 +
 arch/powerpc/platforms/powernv/opal-imc.c          |  39 +++---
 arch/powerpc/xmon/xmon.c                           | 103 +++++++++++---
 arch/s390/kernel/mcount.S                          |   1 +
 arch/s390/mm/hugetlbpage.c                         |   9 +-
 arch/x86/include/asm/pgtable.h                     |   1 +
 arch/x86/mm/mmio-mod.c                             |   4 +-
 drivers/block/null_blk_zoned.c                     |   4 +
 drivers/gpu/drm/drm_edid.c                         |   3 +-
 drivers/gpu/drm/i915/display/intel_dp.c            |   7 +-
 drivers/gpu/drm/i915/display/intel_dp_mst.c        |  22 ++-
 drivers/hid/hid-multitouch.c                       |  26 ++++
 drivers/hid/hid-sony.c                             |  17 +++
 drivers/hid/i2c-hid/i2c-hid-dmi-quirks.c           |   8 ++
 drivers/i2c/busses/i2c-altera.c                    |  10 +-
 drivers/infiniband/hw/qedr/main.c                  |   2 +-
 drivers/infiniband/hw/qedr/qedr.h                  |  23 +++-
 drivers/infiniband/hw/qedr/qedr_iw_cm.c            | 148 ++++++++++++++-------
 drivers/infiniband/hw/qedr/verbs.c                 |  64 +++++----
 drivers/net/dsa/mt7530.c                           |  11 +-
 drivers/net/dsa/mt7530.h                           |   6 +
 drivers/net/ethernet/apple/bmac.c                  |   2 +-
 drivers/net/ethernet/freescale/ucc_geth.c          |  13 +-
 drivers/net/ethernet/smsc/smsc911x.c               |   9 +-
 .../net/ethernet/stmicro/stmmac/dwmac-ipq806x.c    |  13 ++
 drivers/net/wireless/cisco/airo.c                  |  12 ++
 drivers/net/wireless/intersil/p54/p54usb.c         |   1 +
 drivers/net/wireless/mediatek/mt76/mt76x02.h       |   1 +
 drivers/net/wireless/mediatek/mt76/mt76x2/usb.c    |   1 +
 drivers/scsi/hisi_sas/hisi_sas_main.c              |   3 +-
 drivers/scsi/scsi_pm.c                             |  10 +-
 drivers/scsi/ufs/ufshcd.c                          |   1 +
 drivers/spi/spi-dw.c                               |   3 +
 drivers/staging/media/ipu3/include/intel-ipu3.h    |   7 +-
 fs/io_uring.c                                      |   2 +-
 include/linux/security.h                           |   2 +
 include/uapi/linux/mmc/ioctl.h                     |   1 +
 kernel/cgroup/rstat.c                              |  16 +--
 kernel/relay.c                                     |   5 +
 mm/mremap.c                                        |   2 +-
 security/integrity/evm/evm_crypto.c                |   2 +-
 security/integrity/evm/evm_main.c                  |   4 +-
 security/integrity/evm/evm_secfs.c                 |   9 +-
 security/lockdown/lockdown.c                       |   2 +
 .../soc/intel/boards/kbl_rt5663_rt5514_max98927.c  |   2 +-
 sound/soc/intel/boards/skl_hda_dsp_generic.c       |   2 +-
 sound/soc/intel/boards/sof_rt5682.c                |   2 +-
 .../selftests/drivers/net/mlxsw/qos_mc_aware.sh    |   2 +-
 50 files changed, 461 insertions(+), 186 deletions(-)


