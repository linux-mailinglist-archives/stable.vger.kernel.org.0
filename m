Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F11856A772
	for <lists+stable@lfdr.de>; Thu,  7 Jul 2022 18:08:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235690AbiGGQI1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Jul 2022 12:08:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235661AbiGGQI0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Jul 2022 12:08:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A3A933E27;
        Thu,  7 Jul 2022 09:08:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 42FE9623D3;
        Thu,  7 Jul 2022 16:08:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5214CC341C0;
        Thu,  7 Jul 2022 16:08:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657210100;
        bh=5EnJIFL10in2oed2CtVnmxNJDop7J++6e1s0pL9vB2U=;
        h=From:To:Cc:Subject:Date:From;
        b=rDmDxsU6JjonBj317riU0Ats+LE8NzB15uVnYxr3ckkIp9i85N44Gvjh8FZQ6Yifm
         A3L+l2aC/R1P9CH4Y09TlWzmEjMyMrBkpuP/3A7mN/MU3N/8oFHzxhqWADnqkrxtm7
         ZMS+Lria1wHKknLhchXE+/Z8hrXANTFoIPavE7ww=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.14.287
Date:   Thu,  7 Jul 2022 18:08:13 +0200
Message-Id: <165721009435145@kroah.com>
X-Mailer: git-send-email 2.37.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.14.287 kernel.

All users of the 4.14 kernel series must upgrade.

The updated 4.14.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.14.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                           |    2 
 arch/arm/xen/p2m.c                 |    6 +
 arch/s390/crypto/arch_random.c     |   20 -----
 arch/s390/include/asm/archrandom.h |   32 +++-----
 arch/s390/kernel/setup.c           |    5 +
 drivers/block/xen-blkfront.c       |   49 +++++++-----
 drivers/hwmon/ibmaem.c             |   12 ++-
 drivers/infiniband/hw/qedr/qedr.h  |    1 
 drivers/infiniband/hw/qedr/verbs.c |    4 -
 drivers/md/dm-raid.c               |   34 ++++----
 drivers/md/raid5.c                 |    1 
 drivers/net/bonding/bond_3ad.c     |    3 
 drivers/net/bonding/bond_alb.c     |    2 
 drivers/net/caif/caif_virtio.c     |   10 ++
 drivers/net/usb/ax88179_178a.c     |  101 +++++++++++++++++++------
 drivers/net/usb/qmi_wwan.c         |    2 
 drivers/net/usb/usbnet.c           |    4 -
 drivers/net/xen-netfront.c         |   52 ++++++++++++-
 drivers/nfc/nfcmrvl/i2c.c          |    6 -
 drivers/nfc/nfcmrvl/spi.c          |    6 -
 drivers/nfc/nxp-nci/i2c.c          |    3 
 drivers/nvdimm/bus.c               |    4 -
 drivers/xen/gntdev.c               |  145 ++++++++++++++++++++++++++-----------
 include/linux/skbuff.h             |    1 
 net/core/skbuff.c                  |    9 +-
 net/ipv6/seg6_hmac.c               |    1 
 net/ipv6/sit.c                     |   10 +-
 net/netfilter/nft_set_hash.c       |    2 
 net/rose/rose_timer.c              |   34 ++++----
 net/sunrpc/xdr.c                   |    2 
 30 files changed, 376 insertions(+), 187 deletions(-)

Carlo Lobrano (1):
      net: usb: qmi_wwan: add Telit 0x1060 composition

Chris Ye (1):
      nvdimm: Fix badblocks clear off-by-one error

Chuck Lever (1):
      SUNRPC: Fix READ_PLUS crasher

Daniele Palmas (1):
      net: usb: qmi_wwan: add Telit 0x1070 composition

Demi Marie Obenour (1):
      xen/gntdev: Avoid blocking in unmap_grant_pages()

Duoming Zhou (1):
      net: rose: fix UAF bugs caused by timer handler

Eric Dumazet (1):
      net: bonding: fix possible NULL deref in rlb code

Greg Kroah-Hartman (1):
      Linux 4.14.287

Heinz Mauelshagen (1):
      dm raid: fix accesses beyond end of raid member array

Ilya Lesokhin (1):
      net: Rename and export copy_skb_header

Jason A. Donenfeld (1):
      s390/archrandom: simplify back to earlier design and initialize earlier

Jason Wang (1):
      caif_virtio: fix race between virtio_device_ready() and ndo_open()

Jose Alonso (1):
      net: usb: ax88179_178a: Fix packet receiving

Kamal Heib (1):
      RDMA/qedr: Fix reporting QP timeout attribute

Krzysztof Kozlowski (1):
      nfc: nfcmrvl: Fix irq_of_parse_and_map() return value

Michael Walle (1):
      NFC: nxp-nci: Don't issue a zero length i2c_master_read()

Mikulas Patocka (1):
      dm raid: fix KASAN warning in raid5_add_disks

Oleksandr Tyshchenko (1):
      xen/arm: Fix race in RB-tree based P2M accounting

Oliver Neukum (1):
      usbnet: fix memory allocation in helpers

Pablo Neira Ayuso (1):
      netfilter: nft_dynset: restore set element counter when failing to update

Roger Pau Monne (4):
      xen/blkfront: fix leaking data in shared pages
      xen/netfront: fix leaking data in shared pages
      xen/netfront: force data bouncing when backend is untrusted
      xen/blkfront: force data bouncing when backend is untrusted

Yang Yingliang (1):
      hwmon: (ibmaem) don't call platform_device_del() if platform_device_add() fails

Yevhen Orlov (1):
      net: bonding: fix use-after-free after 802.3ad slave unbind

YueHaibing (1):
      net: ipv6: unexport __init-annotated seg6_hmac_net_init()

katrinzhou (1):
      ipv6/sit: fix ipip6_tunnel_get_prl return value

kernel test robot (1):
      sit: use min

