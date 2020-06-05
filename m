Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EC961EFB28
	for <lists+stable@lfdr.de>; Fri,  5 Jun 2020 16:24:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728584AbgFEOYK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Jun 2020 10:24:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:47234 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728503AbgFEORj (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Jun 2020 10:17:39 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 51403208A7;
        Fri,  5 Jun 2020 14:17:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591366657;
        bh=KuM00xLFfoG74Xvx4vIE9Zct9PBeEM8CrdFJOL21yu0=;
        h=From:To:Cc:Subject:Date:From;
        b=JRz85cajWsioE/VS6CzWKow0TFfEGXv3hY9QALXFQ23qJ+ioEH8gLaLvYsuFXmYMe
         eL5nlX1ITILfgtTSncGzVB+OWY36oScPGOgSPncSn4ywj1HqRRXaop2U9M01Zc3/qx
         1pVeplE8gamgvUYbGCzwRMh60tsqk80u6Yvq0teI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 5.6 00/43] 5.6.17-rc1 review
Date:   Fri,  5 Jun 2020 16:14:30 +0200
Message-Id: <20200605140152.493743366@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-5.6.17-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.6.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.6.17-rc1
X-KernelTest-Deadline: 2020-06-07T14:01+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.6.17 release.
There are 43 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun, 07 Jun 2020 13:54:56 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.6.17-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.6.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.6.17-rc1

Dan Carpenter <dan.carpenter@oracle.com>
    airo: Fix read overflows sending packets

DENG Qingfang <dqfext@gmail.com>
    net: dsa: mt7530: set CPU port to fallback mode

Sakari Ailus <sakari.ailus@linux.intel.com>
    media: staging: ipu3-imgu: Move alignment attribute to field

Sakari Ailus <sakari.ailus@linux.intel.com>
    media: Revert "staging: imgu: Address a compiler warning on alignment"

Jérôme Pouiller <jerome.pouiller@silabs.com>
    mmc: fix compilation of user API

Daniel Axtens <dja@axtens.net>
    kernel/relay.c: handle alloc_percpu returning NULL in relay_open

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: api - Fix use-after-free and race in crypto_spawn_alg

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

Dinghao Liu <dinghao.liu@zju.edu.cn>
    net: smsc911x: Fix runtime PM imbalance on error

Tiezhu Yang <yangtiezhu@loongson.cn>
    net: Fix return value about devm_platform_ioremap_resource()

Amit Cohen <amitc@mellanox.com>
    selftests: mlxsw: qos_mc_aware: Specify arping timeout as an integer

Jonathan McDowell <noodles@earth.li>
    net: ethernet: stmmac: Enable interface clocks on probe for IPQ806x

Valentin Longchamp <valentin@longchamp.me>
    net/ethernet/freescale: rework quiesce/activate for ucc_geth

Wei Yongjun <weiyongjun1@huawei.com>
    net: ethernet: ti: fix some return value check of cpsw_ale_create()

Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
    null_blk: return error for invalid zone size

Jason A. Donenfeld <Jason@zx2c4.com>
    wireguard: selftests: use newer iproute2 for gcc-10

Kefeng Wang <wangkefeng.wang@huawei.com>
    riscv: Fix print_vm_layout build error if NOMMU

Vladimir Stempen <vladimir.stempen@amd.com>
    drm/amd/display: DP training to set properly SCRAMBLING_DISABLE

Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
    io_uring: reset -EBUSY error when io sq thread is waken up

Gerald Schaefer <gerald.schaefer@de.ibm.com>
    s390/mm: fix set_huge_pte_at() for empty ptes

Jan Schmidt <jan@centricular.com>
    drm/edid: Add Oculus Rift S to non-desktop list

Jeremy Kerr <jk@ozlabs.org>
    net: bmac: Fix read of MAC address from ROM

Nathan Chancellor <natechancellor@gmail.com>
    x86/mmiotrace: Use cpumask_available() for cpumask_var_t variables

Leon Romanovsky <leon@kernel.org>
    net: phy: propagate an error back to the callers of phy_sfp_probe

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: fix FORCE_ASYNC req preparation

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: don't prepare DRAIN reqs twice

Jens Axboe <axboe@kernel.dk>
    io_uring: initialize ctx->sqo_wait earlier

Atsushi Nemoto <atsushi.nemoto@sord.co.jp>
    i2c: altera: Fix race between xfer_msg and isr thread

Peter Ujfalusi <peter.ujfalusi@ti.com>
    dmaengine: ti: k3-udma: Fix TR mode flags for slave_sg and memcpy

Vitaly Kuznetsov <vkuznets@redhat.com>
    x86/hyperv: Properly suspend/resume reenlightenment notifications

Dave Young <dyoung@redhat.com>
    efi/earlycon: Fix early printk for wider fonts

Can Guo <cang@codeaurora.org>
    scsi: pm: Balance pm_only counter of request queue during system resume

Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
    evm: Fix RCU list related warnings

Heinrich Schuchardt <xypron.glpk@gmx.de>
    efi/libstub: Avoid returning uninitialized data from setup_graphics()

Vineet Gupta <vgupta@synopsys.com>
    ARC: [plat-eznps]: Restrict to CONFIG_ISA_ARCOMPACT

Eugeniy Paltsev <Eugeniy.Paltsev@synopsys.com>
    ARC: Fix ICCM & DCCM runtime size checks

Tejun Heo <tj@kernel.org>
    Revert "cgroup: Add memory barriers to plug cgroup_rstat_updated() race window"

Andy Lutomirski <luto@kernel.org>
    x86/syscalls: Revert "x86/syscalls: Make __X32_SYSCALL_BIT be unsigned long"


-------------

Diffstat:

 Makefile                                           |  4 ++--
 arch/arc/kernel/setup.c                            |  5 ++--
 arch/arc/plat-eznps/Kconfig                        |  1 +
 arch/riscv/mm/init.c                               |  2 +-
 arch/s390/mm/hugetlbpage.c                         |  9 ++++---
 arch/x86/hyperv/hv_init.c                          | 19 +++++++++++++--
 arch/x86/include/asm/pgtable.h                     |  1 +
 arch/x86/include/uapi/asm/unistd.h                 | 11 +++++++--
 arch/x86/mm/mmio-mod.c                             |  4 ++--
 crypto/algapi.c                                    | 22 ++++++++++++-----
 crypto/api.c                                       |  3 ++-
 crypto/internal.h                                  |  1 +
 drivers/block/null_blk_zoned.c                     |  4 ++++
 drivers/dma/ti/k3-udma.c                           |  6 +++--
 drivers/firmware/efi/earlycon.c                    | 14 ++++++-----
 drivers/firmware/efi/libstub/arm-stub.c            |  6 ++++-
 drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c   | 27 +++++++++++++++++++++
 drivers/gpu/drm/drm_edid.c                         |  3 ++-
 drivers/hid/hid-multitouch.c                       | 26 ++++++++++++++++++++
 drivers/hid/hid-sony.c                             | 17 +++++++++++++
 drivers/hid/i2c-hid/i2c-hid-dmi-quirks.c           |  8 +++++++
 drivers/i2c/busses/i2c-altera.c                    | 10 +++++++-
 drivers/net/can/ifi_canfd/ifi_canfd.c              |  5 +++-
 drivers/net/can/sun4i_can.c                        |  2 +-
 drivers/net/dsa/b53/b53_srab.c                     |  2 +-
 drivers/net/dsa/mt7530.c                           | 11 ++++++---
 drivers/net/dsa/mt7530.h                           |  6 +++++
 drivers/net/ethernet/apple/bmac.c                  |  2 +-
 drivers/net/ethernet/freescale/ucc_geth.c          | 13 +++++-----
 drivers/net/ethernet/marvell/pxa168_eth.c          |  2 +-
 drivers/net/ethernet/smsc/smsc911x.c               |  9 +++----
 .../net/ethernet/stmicro/stmmac/dwmac-ipq806x.c    | 13 ++++++++++
 drivers/net/ethernet/ti/cpsw_ale.c                 |  2 +-
 drivers/net/ethernet/ti/cpsw_priv.c                |  4 ++--
 drivers/net/ethernet/ti/netcp_ethss.c              |  4 ++--
 drivers/net/phy/phy_device.c                       |  4 ++--
 drivers/net/wireless/cisco/airo.c                  | 12 ++++++++++
 drivers/net/wireless/intersil/p54/p54usb.c         |  1 +
 drivers/net/wireless/mediatek/mt76/mt76x02.h       |  1 +
 drivers/net/wireless/mediatek/mt76/mt76x2/usb.c    |  1 +
 drivers/scsi/scsi_pm.c                             | 10 ++++++--
 drivers/staging/media/ipu3/include/intel-ipu3.h    |  7 +++---
 fs/io_uring.c                                      | 28 ++++++++++++++--------
 include/uapi/linux/mmc/ioctl.h                     |  1 +
 kernel/cgroup/rstat.c                              | 16 +++----------
 kernel/relay.c                                     |  5 ++++
 mm/mremap.c                                        |  2 +-
 security/integrity/evm/evm_crypto.c                |  2 +-
 security/integrity/evm/evm_main.c                  |  4 ++--
 security/integrity/evm/evm_secfs.c                 |  9 ++++++-
 tools/arch/x86/include/uapi/asm/unistd.h           |  2 +-
 .../selftests/drivers/net/mlxsw/qos_mc_aware.sh    |  2 +-
 tools/testing/selftests/wireguard/qemu/Makefile    |  2 +-
 53 files changed, 294 insertions(+), 93 deletions(-)


