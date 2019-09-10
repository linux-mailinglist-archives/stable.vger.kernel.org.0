Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12B4DAE7BE
	for <lists+stable@lfdr.de>; Tue, 10 Sep 2019 12:17:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727046AbfIJKRS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Sep 2019 06:17:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:45542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726353AbfIJKRS (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Sep 2019 06:17:18 -0400
Received: from localhost (110.8.30.213.rev.vodafone.pt [213.30.8.110])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0E69B2081B;
        Tue, 10 Sep 2019 10:17:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568110636;
        bh=6kZKtIQGIAhTPZjJiOCymp6oiDQ1IbRcjg+WwKUlA98=;
        h=Date:From:To:Cc:Subject:From;
        b=FWMixbx8bSWYX38Q4GD876/rCMSSEAOAbP870FAQu9V6jw7fu3aPFxXOc7svCQ145
         6FsbjB+QQyMtLnvasaGhgz447b565FX1+/iFTx6Ka64jv42ee6BeKVEdJ5jK6//JYA
         HyQc3YVKmIJ1ztKOT9tKehRjo123kB47LQGeIi5E=
Date:   Tue, 10 Sep 2019 11:17:13 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.4.192
Message-ID: <20190910101713.GA7074@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.4.192 kernel.

All users of the 4.4 kernel series must upgrade.

The updated 4.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                           |    2 
 arch/arm/kvm/mmio.c                                |    7 ++
 arch/x86/kernel/apic/apic.c                        |    4 -
 drivers/bluetooth/btqca.c                          |    3 +
 drivers/infiniband/hw/mlx4/mad.c                   |    4 -
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c |    4 +
 drivers/net/ethernet/ibm/ibmveth.c                 |    9 +--
 drivers/net/ethernet/myricom/myri10ge/myri10ge.c   |    2 
 drivers/net/ethernet/renesas/ravb_main.c           |    8 ++
 drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c     |    6 --
 drivers/net/ethernet/toshiba/tc35815.c             |    2 
 drivers/net/ethernet/tundra/tsi108_eth.c           |    5 +
 drivers/net/usb/cx82310_eth.c                      |    3 -
 drivers/net/usb/kalmia.c                           |    6 +-
 drivers/net/wimax/i2400m/fw.c                      |    4 +
 drivers/spi/spi-bcm2835aux.c                       |   57 +++++++--------------
 fs/ceph/xattr.c                                    |    8 ++
 include/linux/ceph/buffer.h                        |    3 -
 include/linux/gpio.h                               |   24 --------
 net/core/netpoll.c                                 |    6 +-
 tools/hv/hv_kvp_daemon.c                           |    2 
 21 files changed, 74 insertions(+), 95 deletions(-)

Andrew Jones (1):
      KVM: arm/arm64: Only skip MMIO insn once

Chen-Yu Tsai (1):
      net: stmmac: dwmac-rk: Don't fail if phy regulator is absent

Feng Sun (1):
      net: fix skb use after free in netpoll

Fuqian Huang (1):
      net: tundra: tsi108: use spin_lock_irqsave instead of spin_lock_irq in IRQ context

Greg Kroah-Hartman (1):
      Linux 4.4.192

Linus Torvalds (1):
      Revert "x86/apic: Include the LDR when clearing out APIC registers"

Luis Henriques (2):
      ceph: fix buffer free while holding i_ceph_lock in __ceph_setxattr()
      libceph: allow ceph_buffer_put() to receive a NULL ceph_buffer

Martin Sperl (3):
      spi: bcm2835aux: unifying code between polling and interrupt driven code
      spi: bcm2835aux: remove dangerous uncontrolled read of fifo
      spi: bcm2835aux: fix corruptions for longer spi transfers

Matthias Kaehlcke (1):
      Bluetooth: btqca: Add a short delay before downloading the NVM

Nathan Chancellor (1):
      net: tc35815: Explicitly check NET_IP_ALIGN is not zero in tc35815_rx

Rob Herring (1):
      spi: bcm2835aux: ensure interrupts are enabled for shared handler

Tho Vu (1):
      ravb: Fix use-after-free ravb_tstamp_skb

Thomas Falcon (1):
      ibmveth: Convert multicast list size for little-endian system

Vitaly Kuznetsov (1):
      Tools: hv: kvp: eliminate 'may be used uninitialized' warning

Wenwen Wang (6):
      cxgb4: fix a memory leak bug
      net: myri10ge: fix memory leaks
      cx82310_eth: fix a memory leak bug
      net: kalmia: fix memory leaks
      wimax/i2400m: fix a memory leak bug
      IB/mlx4: Fix memory leaks

YueHaibing (1):
      gpio: Fix build error of function redefinition

