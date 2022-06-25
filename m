Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BE6D55AA6D
	for <lists+stable@lfdr.de>; Sat, 25 Jun 2022 15:19:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233054AbiFYNTY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 Jun 2022 09:19:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233018AbiFYNTY (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 25 Jun 2022 09:19:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26CD21EAF0;
        Sat, 25 Jun 2022 06:19:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B32FEB80A07;
        Sat, 25 Jun 2022 13:19:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 062D8C341C6;
        Sat, 25 Jun 2022 13:19:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656163160;
        bh=LUM41O6bixzRip+lcCUoc1sv8GpEiXsdrfc0bQKiFhs=;
        h=From:To:Cc:Subject:Date:From;
        b=ZxyuiY0pcVAFzQ53GC9GGUaT1jI6F0sp8OzP0kCIgP4UdwEzLljxbfTUJQkO11UAB
         NASu/DsT8xTHSuo7Cg/7JEXPG2f1KWkuamVOCKvVAnbM90hDBEsxlHOb57QtiAkacS
         fYQDddiVf456nO5pkdX28y1Qlo91DJsl7fBDl7F8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.4.201
Date:   Sat, 25 Jun 2022 15:19:16 +0200
Message-Id: <1656163156109178@kroah.com>
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

I'm announcing the release of the 5.4.201 kernel.

All users of the 5.4 kernel series must upgrade.

The updated 5.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/hwmon/hwmon-kernel-api.rst |    2 
 Makefile                                 |    2 
 arch/arm64/mm/cache.S                    |    2 
 arch/s390/mm/pgtable.c                   |    2 
 drivers/hwmon/hwmon.c                    |   16 +++---
 drivers/md/dm-table.c                    |   32 -------------
 drivers/md/dm.c                          |   73 ++-----------------------------
 drivers/usb/gadget/function/u_ether.c    |   11 +++-
 include/linux/device-mapper.h            |    1 
 net/ipv4/inet_hashtables.c               |   31 +++++++++----
 10 files changed, 53 insertions(+), 119 deletions(-)

Christian Borntraeger (1):
      s390/mm: use non-quiescing sske for KVM switch to keyed guest

Eric Dumazet (1):
      tcp: add some entropy in __inet_hash_connect()

Greg Kroah-Hartman (2):
      Revert "hwmon: Make chip parameter for with_info API mandatory"
      Linux 5.4.201

Marian Postevca (1):
      usb: gadget: u_ether: fix regression in setting fixed MAC address

Mike Snitzer (1):
      dm: remove special-casing of bio-based immutable singleton target on NVMe

Will Deacon (1):
      arm64: mm: Don't invalidate FROM_DEVICE buffers at start of DMA transfer

Willy Tarreau (5):
      tcp: use different parts of the port_offset for index and offset
      tcp: add small random increments to the source port
      tcp: dynamically allocate the perturb table used by source ports
      tcp: increase source port perturb table to 2^16
      tcp: drop the hash_32() part from the index calculation

