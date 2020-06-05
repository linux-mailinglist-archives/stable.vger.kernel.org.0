Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB30D1EFAC5
	for <lists+stable@lfdr.de>; Fri,  5 Jun 2020 16:20:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728966AbgFEOUf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Jun 2020 10:20:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:51938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728374AbgFEOUc (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Jun 2020 10:20:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A59732074B;
        Fri,  5 Jun 2020 14:20:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591366831;
        bh=umiSH6ioX2bIsjS5nGw2vO3OqCRPvDFXaBKXrrMWYEg=;
        h=From:To:Cc:Subject:Date:From;
        b=nlLs3qrxqWVa6Sljx78Qopo7F8/pGpBEfNop2Gmh1EpwimK+k/zqHqTSdmBgsKEI3
         KklpEP4CpB7D89+Hth8DrpvKbBBhjunozQjho+B8dleUgGL7+H7jUDPNjIKbmLEKL5
         9ZLtZ2oQYZEUpBx2rTWqwS6/md/bKQG41y0VxmII=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.19 00/28] 4.19.127-rc1 review
Date:   Fri,  5 Jun 2020 16:15:02 +0200
Message-Id: <20200605140252.338635395@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.127-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.127-rc1
X-KernelTest-Deadline: 2020-06-07T14:02+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.19.127 release.
There are 28 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun, 07 Jun 2020 13:54:56 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.127-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.19.127-rc1

Dinghao Liu <dinghao.liu@zju.edu.cn>
    net: smsc911x: Fix runtime PM imbalance on error

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

Atsushi Nemoto <atsushi.nemoto@sord.co.jp>
    i2c: altera: Fix race between xfer_msg and isr thread

Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
    evm: Fix RCU list related warnings

Vineet Gupta <vgupta@synopsys.com>
    ARC: [plat-eznps]: Restrict to CONFIG_ISA_ARCOMPACT

Eugeniy Paltsev <Eugeniy.Paltsev@synopsys.com>
    ARC: Fix ICCM & DCCM runtime size checks

Vasily Gorbik <gor@linux.ibm.com>
    s390/ftrace: save traced function caller

Xinwei Kong <kong.kongxinwei@hisilicon.com>
    spi: dw: use "smp_mb()" to avoid sending spi data error

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

Jérôme Pouiller <jerome.pouiller@silabs.com>
    mmc: fix compilation of user API

Daniel Axtens <dja@axtens.net>
    kernel/relay.c: handle alloc_percpu returning NULL in relay_open

Giuseppe Marco Randazzo <gmrandazzo@gmail.com>
    p54usb: add AirVasT USB stick device-id

Julian Sax <jsbc@gmx.de>
    HID: i2c-hid: add Schneider SCL142ALM to descriptor override

Scott Shumate <scott.shumate@gmail.com>
    HID: sony: Fix for broken buttons on DS3 USB dongles

Fan Yang <Fan_Yang@sjtu.edu.cn>
    mm: Fix mremap not considering huge pmd devmap

Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
    libnvdimm: Fix endian conversion issues 

Tejun Heo <tj@kernel.org>
    Revert "cgroup: Add memory barriers to plug cgroup_rstat_updated() race window"


-------------

Diffstat:

 Makefile                                           |  4 +--
 arch/arc/kernel/setup.c                            |  5 +--
 arch/arc/plat-eznps/Kconfig                        |  1 +
 arch/powerpc/platforms/powernv/opal-imc.c          | 39 +++++++++-------------
 arch/s390/kernel/mcount.S                          |  1 +
 arch/s390/mm/hugetlbpage.c                         |  9 +++--
 arch/x86/include/asm/pgtable.h                     |  1 +
 arch/x86/mm/mmio-mod.c                             |  4 +--
 drivers/block/null_blk_zoned.c                     |  4 +++
 drivers/gpu/drm/drm_edid.c                         |  3 +-
 drivers/gpu/drm/i915/intel_dp.c                    |  7 ++--
 drivers/gpu/drm/i915/intel_dp_mst.c                | 22 ++++++++----
 drivers/hid/hid-sony.c                             | 17 ++++++++++
 drivers/hid/i2c-hid/i2c-hid-dmi-quirks.c           |  8 +++++
 drivers/i2c/busses/i2c-altera.c                    | 10 +++++-
 drivers/net/dsa/mt7530.c                           | 11 ++++--
 drivers/net/dsa/mt7530.h                           |  6 ++++
 drivers/net/ethernet/apple/bmac.c                  |  2 +-
 drivers/net/ethernet/freescale/ucc_geth.c          | 13 ++++----
 drivers/net/ethernet/smsc/smsc911x.c               |  9 ++---
 .../net/ethernet/stmicro/stmmac/dwmac-ipq806x.c    | 13 ++++++++
 drivers/net/wireless/cisco/airo.c                  | 12 +++++++
 drivers/net/wireless/intersil/p54/p54usb.c         |  1 +
 drivers/nvdimm/btt.c                               |  8 ++---
 drivers/nvdimm/namespace_devs.c                    |  7 ++--
 drivers/scsi/hisi_sas/hisi_sas_main.c              |  3 +-
 drivers/scsi/ufs/ufshcd.c                          |  1 +
 drivers/spi/spi-dw.c                               |  3 ++
 include/uapi/linux/mmc/ioctl.h                     |  1 +
 kernel/cgroup/rstat.c                              | 16 ++-------
 kernel/relay.c                                     |  5 +++
 mm/mremap.c                                        |  2 +-
 security/integrity/evm/evm_crypto.c                |  2 +-
 security/integrity/evm/evm_main.c                  |  4 +--
 security/integrity/evm/evm_secfs.c                 |  9 ++++-
 35 files changed, 178 insertions(+), 85 deletions(-)


