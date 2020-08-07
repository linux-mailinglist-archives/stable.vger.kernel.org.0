Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5B3723E8A4
	for <lists+stable@lfdr.de>; Fri,  7 Aug 2020 10:15:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726428AbgHGIPH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Aug 2020 04:15:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:59166 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726382AbgHGIPH (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 7 Aug 2020 04:15:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4AF16221E5;
        Fri,  7 Aug 2020 08:15:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596788106;
        bh=GEpRruLfz3323Dj33FBXvW9djkVkixGRQbT9OQbjvvo=;
        h=From:To:Cc:Subject:Date:From;
        b=vT07ljnhqbBidIjcWYH6dDRz3g4B4R3Q/ucN5ZJff9d6CJXdJmxwDf4F8E6v4NqBg
         gzPkJPoIQQ910deCMrSH6OBDsYpHbdfokJiTwozjXP5Hx+lSv3YzJoJvv6cXfMsgTm
         3TW/r464JheBTH6QsxbQkrZxIpwG5JLLeqKroEXE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.14.193
Date:   Fri,  7 Aug 2020 10:15:19 +0200
Message-Id: <159678811916430@kroah.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.14.193 kernel.

All users of the 4.14 kernel series must upgrade.

The updated 4.14.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.14.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                           |    2 
 arch/arm/include/asm/percpu.h      |    2 
 arch/arm/kernel/head-common.S      |    1 
 drivers/char/random.c              |    1 
 drivers/scsi/libsas/sas_ata.c      |    1 
 drivers/scsi/libsas/sas_discover.c |   32 ++++++---------
 drivers/scsi/libsas/sas_expander.c |    8 ++-
 drivers/scsi/libsas/sas_internal.h |    1 
 drivers/scsi/libsas/sas_port.c     |    3 -
 fs/ext4/inode.c                    |    5 ++
 include/linux/prandom.h            |   78 +++++++++++++++++++++++++++++++++++++
 include/linux/random.h             |   63 +----------------------------
 include/scsi/libsas.h              |    3 -
 include/scsi/scsi_transport_sas.h  |    1 
 kernel/time/timer.c                |    8 +++
 lib/random32.c                     |    2 
 16 files changed, 123 insertions(+), 88 deletions(-)

Geert Uytterhoeven (1):
      ARM: 8702/1: head-common.S: Clear lr before jumping to start_kernel()

Greg Kroah-Hartman (2):
      Revert "scsi: libsas: direct call probe and destruct"
      Linux 4.14.193

Grygorii Strashko (1):
      ARM: percpu.h: fix build error

Jiang Ying (1):
      ext4: fix direct I/O read error

Linus Torvalds (2):
      random32: remove net_rand_state from the latent entropy gcc plugin
      random32: move the pseudo-random 32-bit definitions to prandom.h

Willy Tarreau (2):
      random32: update the net random state on interrupt and activity
      random: fix circular include dependency on arm64 after addition of percpu.h

