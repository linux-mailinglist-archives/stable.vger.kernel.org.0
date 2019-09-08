Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6AD69ACEC5
	for <lists+stable@lfdr.de>; Sun,  8 Sep 2019 15:01:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726722AbfIHNBL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Sep 2019 09:01:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:57242 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729464AbfIHMn2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 8 Sep 2019 08:43:28 -0400
Received: from localhost (unknown [62.28.240.114])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0DA042190F;
        Sun,  8 Sep 2019 12:43:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567946607;
        bh=PnhBP1vWNikRpYfJVvJEstJmOEjb/LN9D5E85rcI69w=;
        h=From:To:Cc:Subject:Date:From;
        b=uPeEueIlzSgUwhDsPYJx/I5G5cW8EbAztWFMFFxMdLPw6+ueB90NmkjMqeZE4fnoJ
         JVlx5t/PEKIdt6OJWeBzOh8XglSZImd/upQhR/unV5nSJ2tE163bwxTzBfqTsi1rH5
         y/Y9beqJiCjieSK3jMUjtoRF3Q+nY6UGrKDaGBpc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.4 00/23] 4.4.192-stable review
Date:   Sun,  8 Sep 2019 13:41:35 +0100
Message-Id: <20190908121052.898169328@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.192-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.4.192-rc1
X-KernelTest-Deadline: 2019-09-10T12:11+00:00
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.4.192 release.
There are 23 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Tue 10 Sep 2019 12:09:36 PM UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.192-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.4.192-rc1

Chen-Yu Tsai <wens@csie.org>
    net: stmmac: dwmac-rk: Don't fail if phy regulator is absent

Feng Sun <loyou85@gmail.com>
    net: fix skb use after free in netpoll

Linus Torvalds <torvalds@linux-foundation.org>
    Revert "x86/apic: Include the LDR when clearing out APIC registers"

Martin Sperl <kernel@martin.sperl.org>
    spi: bcm2835aux: fix corruptions for longer spi transfers

Martin Sperl <kernel@martin.sperl.org>
    spi: bcm2835aux: remove dangerous uncontrolled read of fifo

Martin Sperl <kernel@martin.sperl.org>
    spi: bcm2835aux: unifying code between polling and interrupt driven code

Rob Herring <robh@kernel.org>
    spi: bcm2835aux: ensure interrupts are enabled for shared handler

Luis Henriques <lhenriques@suse.com>
    libceph: allow ceph_buffer_put() to receive a NULL ceph_buffer

Andrew Jones <drjones@redhat.com>
    KVM: arm/arm64: Only skip MMIO insn once

Luis Henriques <lhenriques@suse.com>
    ceph: fix buffer free while holding i_ceph_lock in __ceph_setxattr()

Wenwen Wang <wenwen@cs.uga.edu>
    IB/mlx4: Fix memory leaks

Vitaly Kuznetsov <vkuznets@redhat.com>
    Tools: hv: kvp: eliminate 'may be used uninitialized' warning

Tho Vu <tho.vu.wh@rvc.renesas.com>
    ravb: Fix use-after-free ravb_tstamp_skb

Wenwen Wang <wenwen@cs.uga.edu>
    wimax/i2400m: fix a memory leak bug

Wenwen Wang <wenwen@cs.uga.edu>
    net: kalmia: fix memory leaks

Wenwen Wang <wenwen@cs.uga.edu>
    cx82310_eth: fix a memory leak bug

Wenwen Wang <wenwen@cs.uga.edu>
    net: myri10ge: fix memory leaks

Wenwen Wang <wenwen@cs.uga.edu>
    cxgb4: fix a memory leak bug

YueHaibing <yuehaibing@huawei.com>
    gpio: Fix build error of function redefinition

Thomas Falcon <tlfalcon@linux.ibm.com>
    ibmveth: Convert multicast list size for little-endian system

Matthias Kaehlcke <mka@chromium.org>
    Bluetooth: btqca: Add a short delay before downloading the NVM

Nathan Chancellor <natechancellor@gmail.com>
    net: tc35815: Explicitly check NET_IP_ALIGN is not zero in tc35815_rx

Fuqian Huang <huangfq.daxian@gmail.com>
    net: tundra: tsi108: use spin_lock_irqsave instead of spin_lock_irq in IRQ context


-------------

Diffstat:

 Makefile                                           |  4 +-
 arch/arm/kvm/mmio.c                                |  7 +++
 arch/x86/kernel/apic/apic.c                        |  4 --
 drivers/bluetooth/btqca.c                          |  3 ++
 drivers/infiniband/hw/mlx4/mad.c                   |  4 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c |  4 +-
 drivers/net/ethernet/ibm/ibmveth.c                 |  9 ++--
 drivers/net/ethernet/myricom/myri10ge/myri10ge.c   |  2 +-
 drivers/net/ethernet/renesas/ravb_main.c           |  8 ++-
 drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c     |  6 +--
 drivers/net/ethernet/toshiba/tc35815.c             |  2 +-
 drivers/net/ethernet/tundra/tsi108_eth.c           |  5 +-
 drivers/net/usb/cx82310_eth.c                      |  3 +-
 drivers/net/usb/kalmia.c                           |  6 +--
 drivers/net/wimax/i2400m/fw.c                      |  4 +-
 drivers/spi/spi-bcm2835aux.c                       | 57 ++++++++--------------
 fs/ceph/xattr.c                                    |  8 ++-
 include/linux/ceph/buffer.h                        |  3 +-
 include/linux/gpio.h                               | 24 ---------
 net/core/netpoll.c                                 |  6 +--
 tools/hv/hv_kvp_daemon.c                           |  2 +-
 21 files changed, 75 insertions(+), 96 deletions(-)


