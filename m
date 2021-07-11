Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC95D3C3BCA
	for <lists+stable@lfdr.de>; Sun, 11 Jul 2021 13:21:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232658AbhGKLY1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Jul 2021 07:24:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:45014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232648AbhGKLY1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 11 Jul 2021 07:24:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 23AE361222;
        Sun, 11 Jul 2021 11:21:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626002499;
        bh=0N+CIs0iz9nTrCeEix8DpHxst2MOYws2aQjsR+PvT3M=;
        h=From:To:Cc:Subject:Date:From;
        b=anp4JH7CqlxIOcK5RZ76PBYvIZArIIVXgwWxYUvwOJIW4v4ye6dlMbeRHfGRJS/sB
         WRrKsftdCYX1WbR4lZ4C6jK6ja47LDWBI1RB3VM9Lxktu5WIx6OR4Wl1NQAG+E0kQp
         HZ2EQcXI/kfNH87EMAD9RE++fGvM1maFlGGpzNCQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.10.49
Date:   Sun, 11 Jul 2021 13:21:36 +0200
Message-Id: <16260024956466@kroah.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.10.49 kernel.

All users of the 5.10 kernel series must upgrade.

The updated 5.10.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.10.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                 |    2 
 arch/hexagon/Makefile                    |    6 +-
 arch/hexagon/include/asm/futex.h         |    4 -
 arch/hexagon/include/asm/timex.h         |    3 -
 arch/hexagon/kernel/hexagon_ksyms.c      |    8 +--
 arch/hexagon/kernel/ptrace.c             |    4 -
 arch/hexagon/lib/Makefile                |    3 -
 arch/hexagon/lib/divsi3.S                |   67 +++++++++++++++++++++++++++++++
 arch/hexagon/lib/memcpy_likely_aligned.S |   56 +++++++++++++++++++++++++
 arch/hexagon/lib/modsi3.S                |   46 +++++++++++++++++++++
 arch/hexagon/lib/udivsi3.S               |   38 +++++++++++++++++
 arch/hexagon/lib/umodsi3.S               |   36 ++++++++++++++++
 arch/powerpc/kvm/book3s_hv.c             |    4 +
 drivers/media/usb/uvc/uvc_driver.c       |   32 ++++++++++++++
 drivers/xen/events/events_base.c         |   23 ++++++++--
 15 files changed, 314 insertions(+), 18 deletions(-)

Fabiano Rosas (1):
      KVM: PPC: Book3S HV: Save and restore FSCR in the P9 path

Greg Kroah-Hartman (1):
      Linux 5.10.49

Juergen Gross (1):
      xen/events: reset active flag for lateeoi events later

Laurent Pinchart (1):
      media: uvcvideo: Support devices that report an OT as an entity source

Sid Manning (3):
      Hexagon: fix build errors
      Hexagon: add target builtins to kernel
      Hexagon: change jumps to must-extend in futex_atomic_*

