Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAE663C3BD0
	for <lists+stable@lfdr.de>; Sun, 11 Jul 2021 13:22:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232679AbhGKLYe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Jul 2021 07:24:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:45126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232718AbhGKLYe (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 11 Jul 2021 07:24:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 454186121E;
        Sun, 11 Jul 2021 11:21:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626002507;
        bh=pEBQuiYjo/xtO5EydGk0IA+q+EOm3AqGl4c8P0RH/Qg=;
        h=From:To:Cc:Subject:Date:From;
        b=XazSU8kCRvpFSHzqTmNKAZpgZKX3p3v8VRUt8YzRvuQCVZZ/AOg3tkUcZZ0FGnyN5
         PGUO4dOC21eXOOpi0vD4aslFCUPbUlY+sfjbfykSeT4MY7JYYA0NJ1GDUJDIqJN/bm
         a6qeb4fWhCayM3cn2GkX+FKDsvScbCEriEYU3G7A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.12.16
Date:   Sun, 11 Jul 2021 13:21:42 +0200
Message-Id: <1626002501134199@kroah.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.12.16 kernel.

All users of the 5.12 kernel series must upgrade.

The updated 5.12.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.12.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                           |    2 
 arch/hexagon/Makefile                              |    6 
 arch/hexagon/include/asm/futex.h                   |    4 
 arch/hexagon/include/asm/timex.h                   |    3 
 arch/hexagon/kernel/hexagon_ksyms.c                |    8 
 arch/hexagon/kernel/ptrace.c                       |    4 
 arch/hexagon/lib/Makefile                          |    3 
 arch/hexagon/lib/divsi3.S                          |   67 ++++++
 arch/hexagon/lib/memcpy_likely_aligned.S           |   56 +++++
 arch/hexagon/lib/modsi3.S                          |   46 ++++
 arch/hexagon/lib/udivsi3.S                         |   38 +++
 arch/hexagon/lib/umodsi3.S                         |   36 +++
 drivers/net/wireless/mediatek/mt76/dma.c           |   47 ++--
 drivers/net/wireless/mediatek/mt76/mt76.h          |    8 
 drivers/net/wireless/mediatek/mt76/mt7921/init.c   |    3 
 drivers/net/wireless/mediatek/mt76/mt7921/mac.c    |  209 +++++++++++++++------
 drivers/net/wireless/mediatek/mt76/mt7921/main.c   |   38 ++-
 drivers/net/wireless/mediatek/mt76/mt7921/mcu.c    |   36 ++-
 drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h |    6 
 drivers/net/wireless/mediatek/mt76/mt7921/regs.h   |    4 
 20 files changed, 507 insertions(+), 117 deletions(-)

Greg Kroah-Hartman (1):
      Linux 5.12.16

Lorenzo Bianconi (7):
      mt76: mt7921: check mcu returned values in mt7921_start
      mt76: mt7921: introduce mt7921_run_firmware utility routine.
      mt76: mt7921: introduce __mt7921_start utility routine
      mt76: dma: introduce mt76_dma_queue_reset routine
      mt76: dma: export mt76_dma_rx_cleanup routine
      mt76: mt7921: add wifi reset support
      mt76: mt7921: get rid of mcu_reset function pointer

Sean Wang (1):
      mt76: mt7921: abort uncompleted scan by wifi reset

Sid Manning (3):
      Hexagon: fix build errors
      Hexagon: add target builtins to kernel
      Hexagon: change jumps to must-extend in futex_atomic_*

