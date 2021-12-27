Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BB9247FE39
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 16:27:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231526AbhL0P1W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 10:27:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231370AbhL0P1W (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 10:27:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A85D8C06173E;
        Mon, 27 Dec 2021 07:27:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E6458B80E51;
        Mon, 27 Dec 2021 15:27:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC65EC36AE7;
        Mon, 27 Dec 2021 15:27:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640618838;
        bh=Z69vXPzNQyUfCdiutVPArek5rByxJhRtBBcz6CgkwSM=;
        h=From:To:Cc:Subject:Date:From;
        b=eXuhMJeWCU4I80lSIcN8bkE6MiLhPtBna2RFA+fXL+y5D1JVvgGuWIAQGI+CyYLOW
         Jd4DWJEhhTW5hvIrg0/VmssSvbwPa5yTuidBrTYcY73+1DhVYTGdsqsIiB64OBvCa1
         bMHF8d/4hcKp2n2gZ58OirT5P75sABUQ54QN3nXA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 4.4 00/17] 4.4.297-rc1 review
Date:   Mon, 27 Dec 2021 16:26:55 +0100
Message-Id: <20211227151315.962187770@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.297-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.4.297-rc1
X-KernelTest-Deadline: 2021-12-29T15:13+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.4.297 release.
There are 17 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 29 Dec 2021 15:13:09 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.297-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.4.297-rc1

Rémi Denis-Courmont <remi@remlab.net>
    phonet/pep: refuse to enable an unbound pipe

Lin Ma <linma@zju.edu.cn>
    hamradio: improve the incomplete fix to avoid NPD

Lin Ma <linma@zju.edu.cn>
    hamradio: defer ax25 kfree after unregister_netdev

Lin Ma <linma@zju.edu.cn>
    ax25: NPD bug when detaching AX25 device

Samuel Čavoj <samuel@cavoj.net>
    Input: i8042 - enable deferred probe quirk for ASUS UM325UA

Juergen Gross <jgross@suse.com>
    xen/blkfront: fix bug in backported patch

Ard Biesheuvel <ardb@kernel.org>
    ARM: 9169/1: entry: fix Thumb2 bug in iWMMXt exception handling

Colin Ian King <colin.i.king@gmail.com>
    ALSA: drivers: opl3: Fix incorrect use of vp->state

Xiaoke Wang <xkernel.wang@foxmail.com>
    ALSA: jack: Check the return value of kstrdup()

Guenter Roeck <linux@roeck-us.net>
    hwmon: (lm90) Fix usage of CONFIG2 register in detect function

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    drivers: net: smc911x: Check for error irq

Fernando Fernandez Mancera <ffmancera@riseup.net>
    bonding: fix ad_actor_system option setting to default

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    qlcnic: potential dereference null pointer of rx_queue->page_ring

José Expósito <jose.exposito89@gmail.com>
    IB/qib: Fix memory leak in qib_user_sdma_queue_pkts()

Benjamin Tissoires <benjamin.tissoires@redhat.com>
    HID: holtek: fix mouse probing

Jimmy Assarsson <extja@kvaser.com>
    can: kvaser_usb: get CAN clock frequency from device

Greg Jesionowski <jesionowskigreg@gmail.com>
    net: usb: lan78xx: add Allied Telesis AT29M2-AF


-------------

Diffstat:

 Documentation/networking/bonding.txt               | 11 +++---
 Makefile                                           |  4 +--
 arch/arm/kernel/entry-armv.S                       |  8 ++---
 drivers/block/xen-blkfront.c                       |  4 ---
 drivers/hid/hid-holtek-mouse.c                     | 15 ++++++++
 drivers/hwmon/lm90.c                               |  5 ++-
 drivers/infiniband/hw/qib/qib_user_sdma.c          |  2 +-
 drivers/input/serio/i8042-x86ia64io.h              |  7 ++++
 drivers/net/bonding/bond_options.c                 |  2 +-
 drivers/net/can/usb/kvaser_usb.c                   | 41 +++++++++++++++++++---
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_sriov.h  |  2 +-
 .../ethernet/qlogic/qlcnic/qlcnic_sriov_common.c   | 12 +++++--
 .../net/ethernet/qlogic/qlcnic/qlcnic_sriov_pf.c   |  4 ++-
 drivers/net/ethernet/smsc/smc911x.c                |  5 +++
 drivers/net/hamradio/mkiss.c                       |  5 +--
 drivers/net/usb/lan78xx.c                          |  6 ++++
 net/ax25/af_ax25.c                                 |  4 ++-
 net/phonet/pep.c                                   |  2 ++
 sound/core/jack.c                                  |  4 +++
 sound/drivers/opl3/opl3_midi.c                     |  2 +-
 20 files changed, 110 insertions(+), 35 deletions(-)


