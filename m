Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09E18E69A0
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:38:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728437AbfJ0VDr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:03:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:49146 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728427AbfJ0VDq (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:03:46 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A55C720B7C;
        Sun, 27 Oct 2019 21:03:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572210225;
        bh=u5RG92b4Q/dlgOtWm5/mKfmwRpm7C73H80D+iV1C9R8=;
        h=From:To:Cc:Subject:Date:From;
        b=xKlE9yK5dUpyJLay2JcpdTGKXfsgvM/6Z917Mnh7gVf3rcp668wE3FfJUreqMFRHf
         7Zo2xQPhEdp9VOUDySRTBVZ0qKzBzpW69V5kx2pC71dsZIA60Lnm7pYf1v7Wd/iDb6
         3pWKGkpWidn7G7wQfsk86KrutPTwAuZBM+m/81Xw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.4 00/41] 4.4.198-stable review
Date:   Sun, 27 Oct 2019 22:00:38 +0100
Message-Id: <20191027203056.220821342@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.198-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.4.198-rc1
X-KernelTest-Deadline: 2019-10-29T20:31+00:00
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.4.198 release.
There are 41 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Tue 29 Oct 2019 08:27:02 PM UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.198-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.4.198-rc1

Greg KH <gregkh@linuxfoundation.org>
    RDMA/cxgb4: Do not dma memory off of the stack

Kees Cook <keescook@chromium.org>
    net: sched: Fix memory exposure from short TCA_U32_SEL

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    PCI: PM: Fix pci_power_up()

Juergen Gross <jgross@suse.com>
    xen/netback: fix error path of xenvif_connect_data()

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    cpufreq: Avoid cpufreq_suspend() deadlock on system shutdown

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    memstick: jmb38x_ms: Fix an error handling path in 'jmb38x_ms_probe()'

Qu Wenruo <wqu@suse.com>
    btrfs: block-group: Fix a memory leak due to missing btrfs_put_block_group()

Roberto Bergantinos Corpas <rbergant@redhat.com>
    CIFS: avoid using MID 0xFFFF

Helge Deller <deller@gmx.de>
    parisc: Fix vmap memory leak in ioremap()/iounmap()

Max Filippov <jcmvbkbc@gmail.com>
    xtensa: drop EXPORT_SYMBOL for outs*/ins*

Qian Cai <cai@lca.pw>
    mm/slub: fix a deadlock in show_slab_objects()

Steffen Maier <maier@linux.ibm.com>
    scsi: zfcp: fix reaction on bit error threshold notification

Kai-Heng Feng <kai.heng.feng@canonical.com>
    drm/edid: Add 6 bpc quirk for SDC panel in Lenovo G50

Will Deacon <will@kernel.org>
    mac80211: Reject malformed SSID elements

Will Deacon <will@kernel.org>
    cfg80211: wext: avoid copying malformed SSIDs

Junya Monden <jmonden@jp.adit-jv.com>
    ASoC: rsnd: Reinitialize bit clock inversion flag for every format setting

Yufen Yu <yuyufen@huawei.com>
    scsi: core: try to get module before removing device

Johan Hovold <johan@kernel.org>
    USB: ldusb: fix read info leaks

Johan Hovold <johan@kernel.org>
    USB: usblp: fix use-after-free on disconnect

Johan Hovold <johan@kernel.org>
    USB: ldusb: fix memleak on disconnect

Johan Hovold <johan@kernel.org>
    USB: serial: ti_usb_3410_5052: fix port-close races

Gustavo A. R. Silva <gustavo@embeddedor.com>
    usb: udc: lpc32xx: fix bad bit shift operation

Johan Hovold <johan@kernel.org>
    USB: legousbtower: fix memleak on disconnect

Matthew Wilcox (Oracle) <willy@infradead.org>
    memfd: Fix locking when tagging pins

Stefano Brivio <sbrivio@redhat.com>
    ipv4: Return -ENETUNREACH if we can't create route but saddr is valid

Eric Dumazet <edumazet@google.com>
    net: avoid potential infinite loop in tc_ctl_action()

Xin Long <lucien.xin@gmail.com>
    sctp: change sctp_prot .no_autobind with true

Florian Fainelli <f.fainelli@gmail.com>
    net: bcmgenet: Set phydev->dev_flags only for internal PHYs

Florian Fainelli <f.fainelli@gmail.com>
    net: bcmgenet: Fix RGMII_MODE_EN value for GENET v1/2/3

Alessio Balsini <balsini@android.com>
    loop: Add LOOP_SET_DIRECT_IO to compat ioctl

Jiaxun Yang <jiaxun.yang@flygoat.com>
    MIPS: elf_hwcap: Export userspace ASEs

Jiaxun Yang <jiaxun.yang@flygoat.com>
    MIPS: Treat Loongson Extensions as ASEs

Jacob Keller <jacob.e.keller@intel.com>
    namespace: fix namespace.pl script to support relative paths

Yizhuo <yzhai003@ucr.edu>
    net: hisilicon: Fix usage of uninitialized variable in function mdio_sc_cfg_reg_write()

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    mips: Loongson: Fix the link time qualifier of 'serial_exit()'

Miaoqing Pan <miaoqing@codeaurora.org>
    nl80211: fix null pointer dereference

Peter Ujfalusi <peter.ujfalusi@ti.com>
    ARM: dts: am4372: Set memory bandwidth limit for DISPC

Tony Lindgren <tony@atomide.com>
    ARM: OMAP2+: Fix missing reset done flag for am3 and am43

Quinn Tran <qutran@marvell.com>
    scsi: qla2xxx: Fix unbound sleep in fcport delete path.

Xiang Chen <chenxiang66@hisilicon.com>
    scsi: megaraid: disable device when probe failed after enabled device

Stanley Chu <stanley.chu@mediatek.com>
    scsi: ufs: skip shutdown if hba is not powered


-------------

Diffstat:

 Makefile                                           |  4 ++--
 arch/arm/boot/dts/am4372.dtsi                      |  2 ++
 .../mach-omap2/omap_hwmod_33xx_43xx_ipblock_data.c |  3 ++-
 arch/mips/include/asm/cpu-features.h               |  8 +++++++
 arch/mips/include/asm/cpu.h                        |  2 ++
 arch/mips/include/uapi/asm/hwcap.h                 | 11 +++++++++
 arch/mips/kernel/cpu-probe.c                       | 27 +++++++++++++++++++++
 arch/mips/kernel/proc.c                            |  2 ++
 arch/mips/loongson64/common/serial.c               |  2 +-
 arch/parisc/mm/ioremap.c                           | 12 ++++++----
 arch/xtensa/kernel/xtensa_ksyms.c                  |  7 ------
 drivers/base/core.c                                |  3 +++
 drivers/block/loop.c                               |  1 +
 drivers/cpufreq/cpufreq.c                          | 10 --------
 drivers/gpu/drm/drm_edid.c                         |  3 +++
 drivers/infiniband/hw/cxgb4/mem.c                  | 28 +++++++++++++---------
 drivers/memstick/host/jmb38x_ms.c                  |  2 +-
 drivers/net/ethernet/broadcom/genet/bcmgenet.h     |  1 +
 drivers/net/ethernet/broadcom/genet/bcmmii.c       | 11 ++++++---
 drivers/net/ethernet/hisilicon/hns_mdio.c          |  6 ++++-
 drivers/net/xen-netback/interface.c                |  1 -
 drivers/pci/pci.c                                  | 24 +++++++++----------
 drivers/s390/scsi/zfcp_fsf.c                       | 16 ++++++++++---
 drivers/scsi/megaraid.c                            |  4 ++--
 drivers/scsi/qla2xxx/qla_target.c                  |  4 ++++
 drivers/scsi/scsi_sysfs.c                          | 11 ++++++++-
 drivers/scsi/ufs/ufshcd.c                          |  3 +++
 drivers/usb/class/usblp.c                          |  4 +++-
 drivers/usb/gadget/udc/lpc32xx_udc.c               |  6 ++---
 drivers/usb/misc/ldusb.c                           | 20 +++++++++-------
 drivers/usb/misc/legousbtower.c                    |  5 +---
 drivers/usb/serial/ti_usb_3410_5052.c              | 10 +++-----
 fs/btrfs/extent-tree.c                             |  1 +
 fs/cifs/smb1ops.c                                  |  3 +++
 mm/shmem.c                                         | 20 +++++++++-------
 mm/slub.c                                          | 13 ++++++++--
 net/ipv4/route.c                                   |  9 ++++---
 net/mac80211/mlme.c                                |  5 ++--
 net/sched/act_api.c                                | 12 ++++++----
 net/sched/cls_u32.c                                |  8 +++++--
 net/sctp/socket.c                                  |  4 ++--
 net/wireless/nl80211.c                             |  3 +++
 net/wireless/wext-sme.c                            |  8 +++++--
 scripts/namespace.pl                               | 13 +++++-----
 sound/soc/sh/rcar/core.c                           |  1 +
 45 files changed, 235 insertions(+), 118 deletions(-)


