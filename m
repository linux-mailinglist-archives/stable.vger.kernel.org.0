Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 077A855AA95
	for <lists+stable@lfdr.de>; Sat, 25 Jun 2022 15:43:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232960AbiFYNme (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 Jun 2022 09:42:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232238AbiFYNmd (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 25 Jun 2022 09:42:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 223F518B11;
        Sat, 25 Jun 2022 06:42:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AB26A60FED;
        Sat, 25 Jun 2022 13:42:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83C7EC3411C;
        Sat, 25 Jun 2022 13:42:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656164552;
        bh=m4d2TYRHcOtar7ruYQjlDBZYc3wFv0scSsrJvuXGk1E=;
        h=From:To:Cc:Subject:Date:From;
        b=uWfvIgWvnTdf3K5e6H9n60bxnsOm0HDr1B2TdLXxXU9Ic8aPwlkV/bcAuxn6174V8
         XKqIjUVDaQjUYCxCnk8VrhPDrklvNSPtVVQmsOffVZsywkFlhp+ZGhRDm7JP8KqxpQ
         4SBaWddtfbJ30xmjVxLO0YIAP8eQpKhA66ThzfnY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.10.125
Date:   Sat, 25 Jun 2022 15:42:27 +0200
Message-Id: <1656164548242121@kroah.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.10.125 kernel.

All users of the 5.10 kernel series must upgrade.

The updated 5.10.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.10.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                              |    2 
 arch/arm64/mm/cache.S                 |    2 
 arch/s390/mm/pgtable.c                |    2 
 drivers/tty/serial/serial_core.c      |   34 ++++--------
 drivers/usb/gadget/function/u_ether.c |   11 +++-
 fs/io_uring.c                         |   23 +++++---
 fs/zonefs/super.c                     |   92 ++++++++++++++++++++++------------
 net/ipv4/inet_hashtables.c            |   31 ++++++++---
 8 files changed, 122 insertions(+), 75 deletions(-)

Christian Borntraeger (1):
      s390/mm: use non-quiescing sske for KVM switch to keyed guest

Damien Le Moal (1):
      zonefs: fix zonefs_iomap_begin() for reads

Eric Dumazet (1):
      tcp: add some entropy in __inet_hash_connect()

Greg Kroah-Hartman (1):
      Linux 5.10.125

Jens Axboe (1):
      io_uring: add missing item types for various requests

Lukas Wunner (1):
      serial: core: Initialize rs485 RTS polarity already on probe

Marian Postevca (1):
      usb: gadget: u_ether: fix regression in setting fixed MAC address

Will Deacon (1):
      arm64: mm: Don't invalidate FROM_DEVICE buffers at start of DMA transfer

Willy Tarreau (5):
      tcp: use different parts of the port_offset for index and offset
      tcp: add small random increments to the source port
      tcp: dynamically allocate the perturb table used by source ports
      tcp: increase source port perturb table to 2^16
      tcp: drop the hash_32() part from the index calculation

