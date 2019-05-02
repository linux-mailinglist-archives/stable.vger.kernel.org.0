Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 014F511F37
	for <lists+stable@lfdr.de>; Thu,  2 May 2019 17:51:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726566AbfEBPWU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 May 2019 11:22:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:37560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726558AbfEBPWT (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 May 2019 11:22:19 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 79E4620675;
        Thu,  2 May 2019 15:22:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556810538;
        bh=ZdkIgil3bDGk0PV79nCsXlQ1XE1jRu/b1f7xqdy9RP0=;
        h=From:To:Cc:Subject:Date:From;
        b=HjpOZF+WR4eBr2m6/7pFZvBjEeZQXTu8aHB5Bblo1IBrCsgo9kNq6zoFs/KvtgOLH
         Yq+o2lg7DeH+bYKAxThzcwaDy90Ov4UWSXvB9Y0WkQRiycg6XRI8JGNF0HFrIlY6bK
         U40ItY8WMB32qP+XeySTYHahd1ogwCQP+PHtFe/E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.9 00/32] 4.9.173-stable review
Date:   Thu,  2 May 2019 17:20:46 +0200
Message-Id: <20190502143314.649935114@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.173-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.9.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.9.173-rc1
X-KernelTest-Deadline: 2019-05-04T14:33+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.9.173 release.
There are 32 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat 04 May 2019 02:32:02 PM UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.173-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.9.173-rc1

Alex Williamson <alex.williamson@redhat.com>
    vfio/type1: Limit DMA mappings per container

Kangjie Lu <kjlu@umn.edu>
    leds: pca9532: fix a potential NULL pointer dereference

Changbin Du <changbin.du@gmail.com>
    kconfig/[mn]conf: handle backspace (^H) key

Geert Uytterhoeven <geert+renesas@glider.be>
    gpio: of: Fix of_gpiochip_add() error path

raymond pang <raymondpangxd@gmail.com>
    libata: fix using DMA buffers on stack

Steffen Maier <maier@linux.ibm.com>
    scsi: zfcp: reduce flood of fcrscn1 trace records on multi-element RSCN

Al Viro <viro@zeniv.linux.org.uk>
    ceph: fix use-after-free on symlink traversal

Mukesh Ojha <mojha@codeaurora.org>
    usb: u132-hcd: fix resource leak

Kangjie Lu <kjlu@umn.edu>
    scsi: qla4xxx: fix a potential NULL pointer dereference

Wen Yang <wen.yang99@zte.com.cn>
    net: ethernet: ti: fix possible object reference leak

Wen Yang <wen.yang99@zte.com.cn>
    net: ibm: fix possible object reference leak

Wen Yang <wen.yang99@zte.com.cn>
    net: xilinx: fix possible object reference leak

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFS: Fix a typo in nfs_init_timeout_values()

Dan Carpenter <dan.carpenter@oracle.com>
    staging: rtl8712: uninitialized memory in read_bbreg_hdl()

Lukas Wunner <lukas@wunner.de>
    net: ks8851: Set initial carrier state to down

Lukas Wunner <lukas@wunner.de>
    net: ks8851: Delay requesting IRQ until opened

Lukas Wunner <lukas@wunner.de>
    net: ks8851: Reassert reset pin if chip ID check fails

Lukas Wunner <lukas@wunner.de>
    net: ks8851: Dequeue RX packets explicitly

Marco Felsch <m.felsch@pengutronix.de>
    ARM: dts: pfla02: increase phy reset duration

Guido Kiener <guido@kiener-muenchen.de>
    usb: gadget: net2272: Fix net2272_dequeue()

Guido Kiener <guido@kiener-muenchen.de>
    usb: gadget: net2280: Fix net2280_dequeue()

Guido Kiener <guido@kiener-muenchen.de>
    usb: gadget: net2280: Fix overrun of OUT messages

Petr Štetiar <ynezz@true.cz>
    serial: ar933x_uart: Fix build failure with disabled console

Mao Wenan <maowenan@huawei.com>
    sc16is7xx: missing unregister/delete driver on error in sc16is7xx_init()

Xin Long <lucien.xin@gmail.com>
    netfilter: bridge: set skb transport_header before entering NF_INET_PRE_ROUTING

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nft_set_rbtree: check for inactive element after flag mismatch

Aditya Pakki <pakki001@umn.edu>
    qlcnic: Avoid potential NULL pointer dereference

Martin Schwidefsky <schwidefsky@de.ibm.com>
    s390: limit brk randomization to 32MB

Helen Koike <helen.koike@collabora.com>
    ARM: dts: bcm283x: Fix hdmi hpd gpio pull

Hans Verkuil <hverkuil@xs4all.nl>
    media: vivid: check if the cec_adapter is valid

Gustavo A. R. Silva <garsilva@embeddedor.com>
    usbnet: ipheth: fix potential null pointer dereference in ipheth_carrier_set

Alexander Kappner <agk@godking.net>
    usbnet: ipheth: prevent TX queue timeouts when device not ready


-------------

Diffstat:

 Makefile                                           |  4 +--
 arch/arm/boot/dts/bcm2835-rpi-b-rev2.dts           |  2 +-
 arch/arm/boot/dts/imx6qdl-phytec-pfla02.dtsi       |  1 +
 arch/s390/include/asm/elf.h                        | 11 ++++---
 drivers/ata/libata-zpodd.c                         | 34 ++++++++++++++------
 drivers/gpio/gpiolib-of.c                          |  8 ++++-
 drivers/leds/leds-pca9532.c                        |  8 +++--
 drivers/media/platform/vivid/vivid-vid-common.c    |  3 +-
 drivers/net/ethernet/ibm/ehea/ehea_main.c          |  1 +
 drivers/net/ethernet/micrel/ks8851.c               | 36 +++++++++++-----------
 .../net/ethernet/qlogic/qlcnic/qlcnic_ethtool.c    |  2 ++
 drivers/net/ethernet/ti/netcp_ethss.c              |  8 +++--
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c  |  2 ++
 drivers/net/usb/ipheth.c                           | 33 ++++++++++++++------
 drivers/s390/scsi/zfcp_fc.c                        | 21 ++++++++++---
 drivers/scsi/qla4xxx/ql4_os.c                      |  2 ++
 drivers/staging/rtl8712/rtl8712_cmd.c              | 10 +-----
 drivers/staging/rtl8712/rtl8712_cmd.h              |  2 +-
 drivers/tty/serial/ar933x_uart.c                   | 24 +++++----------
 drivers/tty/serial/sc16is7xx.c                     | 12 ++++++--
 drivers/usb/gadget/udc/net2272.c                   |  1 +
 drivers/usb/gadget/udc/net2280.c                   |  8 ++---
 drivers/usb/host/u132-hcd.c                        |  3 ++
 drivers/vfio/vfio_iommu_type1.c                    | 14 +++++++++
 fs/ceph/inode.c                                    |  2 +-
 fs/nfs/client.c                                    |  2 +-
 net/bridge/br_netfilter_hooks.c                    |  1 +
 net/bridge/br_netfilter_ipv6.c                     |  2 ++
 net/netfilter/nft_set_rbtree.c                     |  7 ++---
 scripts/kconfig/lxdialog/inputbox.c                |  3 +-
 scripts/kconfig/nconf.c                            |  2 +-
 scripts/kconfig/nconf.gui.c                        |  3 +-
 32 files changed, 176 insertions(+), 96 deletions(-)


