Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69A3D4CA268
	for <lists+stable@lfdr.de>; Wed,  2 Mar 2022 11:46:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241090AbiCBKrA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Mar 2022 05:47:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241059AbiCBKrA (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Mar 2022 05:47:00 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAD29BECD4;
        Wed,  2 Mar 2022 02:46:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 83135B81F85;
        Wed,  2 Mar 2022 10:46:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4EC0C004E1;
        Wed,  2 Mar 2022 10:46:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646217974;
        bh=EpgDwSjMnpbY6F9Nw8DO91696Ulkl1WroebqJybzuAU=;
        h=From:To:Cc:Subject:Date:From;
        b=bpKqO9wt0Y62kUAzIm0ubR8XEygoNvHg8LW8HOEcAEZLt5syPdfQtWYt/XkOlFlH1
         5IKOE3rUf9FNnuWULLY5CLVov2OpIoXQH1ohK6wTa4w3Hct4JX0miSoHMn2nIuIY/u
         Z+Tf2FV7EX1XghP2C4ALfHEIUJu5kvoYFU5a9+QU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.9.304
Date:   Wed,  2 Mar 2022 11:46:09 +0100
Message-Id: <1646217970226114@kroah.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.9.304 kernel.

All users of the 4.9 kernel series must upgrade.

The updated 4.9.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.9.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                             |    2 
 arch/parisc/kernel/unaligned.c                       |   14 +--
 drivers/ata/pata_hpt37x.c                            |   14 +++
 drivers/gpu/drm/drm_edid.c                           |    2 
 drivers/iio/adc/men_z188_adc.c                       |    9 ++
 drivers/infiniband/ulp/srp/ib_srp.c                  |    6 +
 drivers/mtd/nand/brcmnand/brcmnand.c                 |    2 
 drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c |    2 
 drivers/net/usb/cdc_ether.c                          |   12 +++
 drivers/net/usb/sr9700.c                             |    2 
 drivers/net/usb/zaurus.c                             |   12 +++
 drivers/tty/n_gsm.c                                  |    4 -
 drivers/tty/serial/8250/8250_of.c                    |   30 +++++--
 drivers/usb/dwc3/gadget.c                            |    2 
 drivers/usb/gadget/function/rndis.c                  |    8 ++
 drivers/usb/gadget/function/rndis.h                  |    1 
 drivers/usb/gadget/udc/udc-xilinx.c                  |    6 +
 drivers/usb/host/xhci.c                              |    9 +-
 drivers/usb/serial/ch341.c                           |    1 
 drivers/usb/serial/option.c                          |   12 +++
 drivers/vhost/vsock.c                                |   21 +++--
 fs/configfs/dir.c                                    |   14 +++
 fs/file.c                                            |   73 ++++++++++++++-----
 fs/tracefs/inode.c                                   |    5 -
 include/net/checksum.h                               |    5 +
 mm/memblock.c                                        |   10 ++
 net/core/skbuff.c                                    |    4 -
 net/ipv4/af_inet.c                                   |    5 +
 net/ipv6/ip6_offload.c                               |    2 
 net/openvswitch/actions.c                            |   46 +++++++++--
 30 files changed, 268 insertions(+), 67 deletions(-)

Alexey Khoroshilov (1):
      serial: 8250: fix error handling in of_platform_serial_probe()

Bart Van Assche (1):
      RDMA/ib_srp: Fix a deadlock

ChenXiaoSong (1):
      configfs: fix a race in configfs_{,un}register_subsystem()

Christophe JAILLET (1):
      iio: adc: men_z188_adc: Fix a resource leak in an error handling path

Daehwan Jung (1):
      usb: gadget: rndis: add spinlock for rndis response list

Daniele Palmas (1):
      USB: serial: option: add Telit LE910R1 compositions

Dmytro Bagrii (1):
      Revert "USB: serial: ch341: add new Product ID for CH341A"

Eric Dumazet (1):
      net: __pskb_pull_tail() & pskb_carve_frag_list() drop_monitor friends

Gal Pressman (1):
      net/mlx5e: Fix wrong return value on ioctl EEPROM query failure

Greg Kroah-Hartman (1):
      Linux 4.9.304

Helge Deller (2):
      parisc/unaligned: Fix fldd and fstd unaligned handlers on 32-bit kernel
      parisc/unaligned: Fix ldw() and stw() unalignment handlers

Hongyu Xie (1):
      xhci: Prevent futile URB re-submissions due to incorrect return value.

Linus Torvalds (1):
      fget: clarify and improve __fget_files() implementation

Maxime Ripard (1):
      drm/edid: Always set RGB444

Miaohe Lin (1):
      memblock: use kfree() to release kmalloced memblock regions

Oliver Neukum (2):
      sr9700: sanity check for packet length
      USB: zaurus: support another broken Zaurus

Paul Blakey (1):
      openvswitch: Fix setting ipv6 fields causing hw csum failure

Robert Hancock (1):
      serial: 8250: of: Fix mapped region size when using reg-offset property

Sebastian Andrzej Siewior (1):
      usb: dwc3: gadget: Let the interrupt handler disable bottom halves.

Sergey Shtylyov (1):
      ata: pata_hpt37x: disable primary channel on HPT371

Slark Xiao (1):
      USB: serial: option: add support for DW5829e

Stefano Garzarella (1):
      vhost/vsock: don't check owner in vhost_vsock_stop() while releasing

Steven Rostedt (Google) (1):
      tracefs: Set the group ownership in apply_options() not parse_options()

Szymon Heidrich (1):
      USB: gadget: validate endpoint index for xilinx udc

Tao Liu (1):
      gso: do not skip outer ip header in case of ipip and net_failover

daniel.starke@siemens.com (2):
      tty: n_gsm: fix encoding of control signal octet bit DV
      tty: n_gsm: fix proper link termination after failed open

david regan (1):
      mtd: rawnand: brcmnand: Fixed incorrect sub-page ECC status

