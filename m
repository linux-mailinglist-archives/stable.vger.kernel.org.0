Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 106F36A95FF
	for <lists+stable@lfdr.de>; Fri,  3 Mar 2023 12:23:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230365AbjCCLXt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Mar 2023 06:23:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbjCCLXs (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Mar 2023 06:23:48 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF4E84ECD7;
        Fri,  3 Mar 2023 03:23:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 37DF4617D5;
        Fri,  3 Mar 2023 11:23:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42C5DC433D2;
        Fri,  3 Mar 2023 11:23:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1677842621;
        bh=RwPHKo3+LNBQKiwbI2kyOzufW3Va4B3xKhjt+nv43jY=;
        h=From:To:Cc:Subject:Date:From;
        b=a9xxNpGyiDuocTTs6P5VV4kIz5pI9PiBP3UJyLS4FqpXclfJFQAsgLmW3atYUjlJ8
         KwawPuwaQA2T8DdOeB9i39+FBBiqPjjNzDwRHpMweV6Gd8jtSXBa6926xEBnNzi9B3
         BbssKaBuwbqMR6G2M0GxNEKNCE06Zrp46IoV7UEQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.19.275
Date:   Fri,  3 Mar 2023 12:23:38 +0100
Message-Id: <1677842618121251@kroah.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.19.275 kernel.

All users of the 4.19 kernel series must upgrade.

The updated 4.19.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.19.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                  |    2 +-
 arch/arm/boot/dts/rk3288.dtsi             |    1 +
 drivers/acpi/nfit/core.c                  |    2 +-
 drivers/dma/sh/rcar-dmac.c                |    5 ++++-
 drivers/infiniband/hw/hfi1/user_exp_rcv.c |    9 ++-------
 drivers/tty/vt/vc_screen.c                |    7 ++++---
 drivers/usb/core/hub.c                    |    5 ++---
 drivers/usb/core/sysfs.c                  |    5 -----
 drivers/usb/serial/option.c               |    4 ++++
 fs/btrfs/send.c                           |    6 +++---
 net/caif/caif_socket.c                    |    1 +
 net/core/stream.c                         |    1 -
 12 files changed, 23 insertions(+), 25 deletions(-)

Alan Stern (1):
      USB: core: Don't hold device lock while reading the "descriptors" sysfs file

David Sterba (1):
      btrfs: send: limit number of clones and allocated memory size

Dean Luick (1):
      IB/hfi1: Assign npages earlier

Florian Zumbiehl (1):
      USB: serial: option: add support for VW/Skoda "Carstick LTE"

Greg Kroah-Hartman (1):
      Linux 4.19.275

Jiasheng Jiang (1):
      dmaengine: sh: rcar-dmac: Check for error num after dma_set_max_seg_size

Johan Jonker (1):
      ARM: dts: rockchip: add power-domains property to dp node on rk3288

Kuniyuki Iwashima (1):
      net: Remove WARN_ON_ONCE(sk->sk_forward_alloc) from sk_stream_kill_queues().

Thomas Weißschuh (1):
      vc_screen: don't clobber return value in vcs_read

Vishal Verma (1):
      ACPI: NFIT: fix a potential deadlock during NFIT teardown

