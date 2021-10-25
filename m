Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD01A43A030
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 21:27:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234819AbhJYT3W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 15:29:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:46520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235085AbhJYT0n (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 15:26:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7C160610A5;
        Mon, 25 Oct 2021 19:23:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635189813;
        bh=2Gj1+51QJMm5WRnQtuubYAz8yVywlBM388LYrxNGplE=;
        h=From:To:Cc:Subject:Date:From;
        b=V9r83wSIQIRzNs/J1U/S9h3GuGZpuMZ9/4fAUFjNatJ4jGn7Qv3w8xv3ZpmEx2776
         9UxaQr1Ok8OpB6D0MOPhCBQ7eImBMgyruGIvd2aUQljmwZEpw7VSROSKuppXJVxPcq
         0nJQqe2dnhCPom60OUQIiofCPa+kMcKz/EpX643M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 4.19 00/37] 4.19.214-rc1 review
Date:   Mon, 25 Oct 2021 21:14:25 +0200
Message-Id: <20211025190926.680827862@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.214-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.214-rc1
X-KernelTest-Deadline: 2021-10-27T19:09+00:00
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.19.214 release.
There are 37 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 27 Oct 2021 19:07:44 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.214-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.19.214-rc1

Nick Desaulniers <ndesaulniers@google.com>
    ARM: 9122/1: select HAVE_FUTEX_CMPXCHG

Steven Rostedt (VMware) <rostedt@goodmis.org>
    tracing: Have all levels of checks prevent recursion

Yanfei Xu <yanfei.xu@windriver.com>
    net: mdiobus: Fix memory leak in __mdiobus_register

Oliver Neukum <oneukum@suse.com>
    usbnet: sanity check for maxpacket

Dexuan Cui <decui@microsoft.com>
    scsi: core: Fix shost->cmd_per_lun calculation in scsi_add_host_with_dma()

Kai Vehmanen <kai.vehmanen@linux.intel.com>
    ALSA: hda: avoid write to STATESTS if controller is in reset

Prashant Malani <pmalani@chromium.org>
    platform/x86: intel_scu_ipc: Update timeout value in comment

Zheyu Ma <zheyuma97@gmail.com>
    isdn: mISDN: Fix sleeping function called from invalid context

Herve Codina <herve.codina@bootlin.com>
    ARM: dts: spear3xx: Fix gmac node

Herve Codina <herve.codina@bootlin.com>
    net: stmmac: add support for dwmac 3.40a

Filipe Manana <fdmanana@suse.com>
    btrfs: deal with errors when checking if a dir entry exists during log replay

Brendan Higgins <brendanhiggins@google.com>
    gcc-plugins/structleak: add makefile var for disabling structleak

Vegard Nossum <vegard.nossum@gmail.com>
    netfilter: Kconfig: use 'default y' instead of 'm' for bool config option

Xiaolong Huang <butterflyhuangxx@gmail.com>
    isdn: cpai: check ctr->cnr to avoid array index out of bound

Lin Ma <linma@zju.edu.cn>
    nfc: nci: fix the UAF of rf_conn_info object

Miaohe Lin <linmiaohe@huawei.com>
    mm, slub: fix mismatch between reconstructed freelist depth and cnt

Takashi Iwai <tiwai@suse.de>
    ASoC: DAPM: Fix missing kctl change notifications

Steven Clarkson <sc@lambdal.com>
    ALSA: hda/realtek: Add quirk for Clevo PC50HS

Brendan Grieve <brendan@grieve.com.au>
    ALSA: usb-audio: Provide quirk for Sennheiser GSP670 Headset

Matthew Wilcox (Oracle) <willy@infradead.org>
    vfs: check fd has read access in kernel_read_file_from_fd()

Lukas Bulwahn <lukas.bulwahn@gmail.com>
    elfcore: correct reference to CONFIG_UML

Valentin Vidic <vvidic@valentin-vidic.from.hr>
    ocfs2: mount fails with buffer overflow in strlen

Jan Kara <jack@suse.cz>
    ocfs2: fix data corruption after conversion from inline format

Zheyu Ma <zheyuma97@gmail.com>
    can: peak_pci: peak_pci_remove(): fix UAF

Stephane Grosjean <s.grosjean@peak-system.com>
    can: peak_usb: pcan_usb_fd_decode_status(): fix back to ERROR_ACTIVE state notification

Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
    can: rcar_can: fix suspend/resume

Peng Li <lipeng321@huawei.com>
    net: hns3: disable sriov before unload hclge layer

Guangbin Huang <huangguangbin2@huawei.com>
    net: hns3: add limit ets dwrr bandwidth cannot be 0

Randy Dunlap <rdunlap@infradead.org>
    NIOS2: irqflags: rename a redefined register name

Vegard Nossum <vegard.nossum@oracle.com>
    lan78xx: select CRC32

Antoine Tenart <atenart@kernel.org>
    netfilter: ipvs: make global sysctl readonly in non-init netns

Shengjiu Wang <shengjiu.wang@nxp.com>
    ASoC: wm8960: Fix clock configuration on slave mode

Gerald Schaefer <gerald.schaefer@linux.ibm.com>
    dma-debug: fix sg checks in debug_dma_map_sg()

Benjamin Coddington <bcodding@redhat.com>
    NFSD: Keep existing listeners on portlist error

Guenter Roeck <linux@roeck-us.net>
    xtensa: xtfpga: Try software restart before simulating CPU reset

Max Filippov <jcmvbkbc@gmail.com>
    xtensa: xtfpga: use CONFIG_USE_OF instead of CONFIG_OF

Eugen Hristev <eugen.hristev@microchip.com>
    ARM: dts: at91: sama5d2_som1_ek: disable ISC node by default


-------------

Diffstat:

 Makefile                                           |  4 +-
 arch/arm/Kconfig                                   |  1 +
 arch/arm/boot/dts/at91-sama5d27_som1_ek.dts        |  1 -
 arch/arm/boot/dts/spear3xx.dtsi                    |  2 +-
 arch/nios2/include/asm/irqflags.h                  |  4 +-
 arch/nios2/include/asm/registers.h                 |  2 +-
 arch/xtensa/platforms/xtfpga/setup.c               | 12 ++--
 drivers/isdn/capi/kcapi.c                          |  5 ++
 drivers/isdn/hardware/mISDN/netjet.c               |  2 +-
 drivers/net/can/rcar/rcar_can.c                    | 20 ++++---
 drivers/net/can/sja1000/peak_pci.c                 |  9 ++-
 drivers/net/can/usb/peak_usb/pcan_usb_fd.c         |  5 +-
 drivers/net/ethernet/hisilicon/hns3/hnae3.c        | 21 +++++++
 drivers/net/ethernet/hisilicon/hns3/hnae3.h        |  1 +
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c |  9 +++
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    |  1 +
 .../net/ethernet/stmicro/stmmac/dwmac-generic.c    |  1 +
 .../net/ethernet/stmicro/stmmac/stmmac_platform.c  |  8 +++
 drivers/net/phy/mdio_bus.c                         |  1 +
 drivers/net/usb/Kconfig                            |  1 +
 drivers/net/usb/usbnet.c                           |  4 ++
 drivers/platform/x86/intel_scu_ipc.c               |  2 +-
 drivers/scsi/hosts.c                               |  3 +-
 fs/btrfs/tree-log.c                                | 47 ++++++++++------
 fs/exec.c                                          |  2 +-
 fs/nfsd/nfsctl.c                                   |  5 +-
 fs/ocfs2/alloc.c                                   | 46 ++++------------
 fs/ocfs2/super.c                                   | 14 +++--
 include/linux/elfcore.h                            |  2 +-
 kernel/dma/debug.c                                 | 12 ++--
 kernel/trace/ftrace.c                              |  4 +-
 kernel/trace/trace.h                               | 64 +++++++---------------
 kernel/trace/trace_functions.c                     |  2 +-
 mm/slub.c                                          | 11 +++-
 net/netfilter/Kconfig                              |  2 +-
 net/netfilter/ipvs/ip_vs_ctl.c                     |  5 ++
 net/nfc/nci/rsp.c                                  |  2 +
 scripts/Makefile.gcc-plugins                       |  4 ++
 sound/hda/hdac_controller.c                        |  5 +-
 sound/pci/hda/patch_realtek.c                      |  1 +
 sound/soc/codecs/wm8960.c                          | 13 ++++-
 sound/soc/soc-dapm.c                               | 13 +++--
 sound/usb/quirks-table.h                           | 32 +++++++++++
 43 files changed, 250 insertions(+), 155 deletions(-)


