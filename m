Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 860446C5435
	for <lists+stable@lfdr.de>; Wed, 22 Mar 2023 19:54:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231290AbjCVSx4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Mar 2023 14:53:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230487AbjCVSxu (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Mar 2023 14:53:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A57E1117B;
        Wed, 22 Mar 2023 11:53:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C04FA62286;
        Wed, 22 Mar 2023 18:53:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC997C4339B;
        Wed, 22 Mar 2023 18:53:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679511196;
        bh=O90AUjt6/Pzw9SOtjvZ/hBEFBKDQeQMR1/YQHEl4TkA=;
        h=From:To:Cc:Subject:Date:From;
        b=HVK0/YIDFkTaihATmT82GeqMZ6uBbXi/eM29al/aMrNQ+w6udHw1SZd4IH+ZtPewC
         3mw5dyWKhErSZ3Z1s67Fshq2ZKgGnVA10frynUHmygiOYfUI1lnmCHWvxIV7gVlf87
         DGbWddbiHRlPI0D2fO5KZZS0rUoQ1TDjIpkNkmIo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.14.311
Date:   Wed, 22 Mar 2023 19:52:58 +0100
Message-Id: <167951117945192@kroah.com>
X-Mailer: git-send-email 2.40.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.14.311 kernel.

All users of the 4.14 kernel series must upgrade.

The updated 4.14.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.14.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                  |    2 +-
 drivers/block/sunvdc.c                    |    2 ++
 drivers/gpu/drm/i915/intel_ringbuffer.c   |    5 +++--
 drivers/hid/hid-core.c                    |   18 +++++++++++++-----
 drivers/hid/uhid.c                        |    1 +
 drivers/hwmon/adt7475.c                   |    8 ++++----
 drivers/hwmon/xgene-hwmon.c               |    1 +
 drivers/media/i2c/m5mols/m5mols_core.c    |    2 +-
 drivers/mmc/host/atmel-mci.c              |    3 ---
 drivers/net/ethernet/qlogic/qed/qed_dev.c |    5 +++++
 drivers/net/ethernet/sun/ldmvsw.c         |    3 +++
 drivers/net/ethernet/sun/sunvnet.c        |    3 +++
 drivers/net/phy/smsc.c                    |    5 ++++-
 drivers/net/usb/smsc75xx.c                |    7 +++++++
 drivers/nfc/pn533/usb.c                   |    1 +
 drivers/nfc/st-nci/ndlc.c                 |    6 ++++--
 drivers/nvme/target/core.c                |    4 +++-
 drivers/tty/serial/8250/8250_em.c         |    4 ++--
 drivers/video/fbdev/stifb.c               |   27 +++++++++++++++++++++++++++
 fs/ext4/inode.c                           |   18 ++++++++----------
 fs/ext4/page-io.c                         |   11 ++++++-----
 fs/ext4/xattr.c                           |   11 +++++++++++
 fs/sysfs/file.c                           |    2 +-
 include/linux/hid.h                       |    3 +++
 include/linux/netdevice.h                 |    6 ++++--
 include/linux/sh_intc.h                   |    5 ++++-
 kernel/trace/ftrace.c                     |    3 ++-
 net/ipv4/fib_frontend.c                   |    3 +++
 net/ipv4/ip_tunnel.c                      |   12 ++++++------
 net/ipv4/tcp_output.c                     |    2 +-
 net/ipv6/ip6_tunnel.c                     |    4 ++--
 net/iucv/iucv.c                           |    2 +-
 32 files changed, 137 insertions(+), 52 deletions(-)

Alexandra Winter (1):
      net/iucv: Fix size of interrupt data

Baokun Li (2):
      ext4: fail ext4_iget if special inode unallocated
      ext4: fix task hung in ext4_xattr_delete_inode

Biju Das (1):
      serial: 8250_em: Fix UART port type

Breno Leitao (1):
      tcp: tcp_make_synack() can be called from process context

Chen Zhongjin (1):
      ftrace: Fix invalid address access in lookup_rec() when index is 0

Damien Le Moal (1):
      nvmet: avoid potential UAF in nvmet_req_complete()

Daniil Tatianin (1):
      qed/qed_dev: guard against a possible division by zero

Eric Biggers (2):
      ext4: fix cgroup writeback accounting with fs-layer encryption
      fs: sysfs_emit_at: Remove PAGE_SIZE alignment check

Eric Dumazet (1):
      net: tunnels: annotate lockless accesses to dev->needed_headroom

Fedor Pchelkin (1):
      nfc: pn533: initialize struct pn533_out_arg properly

Greg Kroah-Hartman (1):
      Linux 4.14.311

Heiner Kallweit (1):
      net: phy: smsc: bail out in lan87xx_read_status if genphy_read_status fails

Helge Deller (1):
      fbdev: stifb: Provide valid pixelclock and add fb_check_var() checks

Ido Schimmel (1):
      ipv4: Fix incorrect table ID in IOCTL path

John Harrison (1):
      drm/i915: Don't use stolen memory for ring buffers with LLC

Lee Jones (2):
      HID: core: Provide new max_buffer_size attribute to over-ride the default
      HID: uhid: Over-ride the default maximum data buffer value with our own

Liang He (2):
      block: sunvdc: add check for mdesc_grab() returning NULL
      ethernet: sun: add check for the mdesc_grab()

Linus Torvalds (1):
      media: m5mols: fix off-by-one loop termination error

Michael Karcher (1):
      sh: intc: Avoid spurious sizeof-pointer-div warning

Szymon Heidrich (2):
      net: usb: smsc75xx: Limit packet length to skb->len
      net: usb: smsc75xx: Move packet length check to prevent kernel panic in skb_pull

Tobias Schramm (1):
      mmc: atmel-mci: fix race between stop command and start of next command

Tony O'Brien (2):
      hwmon: (adt7475) Display smoothing attributes in correct order
      hwmon: (adt7475) Fix masking of hysteresis registers

Zheng Wang (2):
      nfc: st-nci: Fix use after free bug in ndlc_remove due to race condition
      hwmon: (xgene) Fix use after free bug in xgene_hwmon_remove due to race condition

