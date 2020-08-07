Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D88C223E8B3
	for <lists+stable@lfdr.de>; Fri,  7 Aug 2020 10:15:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726968AbgHGIPe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Aug 2020 04:15:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:59838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726542AbgHGIPd (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 7 Aug 2020 04:15:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DD914206B5;
        Fri,  7 Aug 2020 08:15:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596788132;
        bh=VqR6xRHxrgmi5uNY5OfMM9CaVzwkSaXlI+4YDYijYv0=;
        h=From:To:Cc:Subject:Date:From;
        b=y6PNu4QHVS7CDjpVSu+lEIJxctkTtQkdogihrv3K+TsSOcP7vGuJLRAXJVQcwK60R
         JY1qWGtb2YjZuVT3l7j/kQM3ldOBQOAoPARPgEwIeeNPERHl6SXy9xEbfiHeibhaUD
         8/KT+p63gW1sy5vUtQ+6TNzT8zaUgJI/G4nwhCBw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.4.57
Date:   Fri,  7 Aug 2020 10:15:34 +0200
Message-Id: <1596788134201181@kroah.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.4.57 kernel.

All users of the 5.4 kernel series must upgrade.

The updated 5.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                |    2 
 arch/arm/include/asm/percpu.h           |    2 
 arch/arm64/include/asm/pointer_auth.h   |    8 ++-
 drivers/char/random.c                   |    1 
 fs/ext4/inode.c                         |    5 ++
 include/linux/bpf.h                     |   13 ++++-
 include/linux/prandom.h                 |   78 ++++++++++++++++++++++++++++++++
 include/linux/random.h                  |   63 +------------------------
 include/linux/skmsg.h                   |   13 +++++
 kernel/bpf/syscall.c                    |    4 -
 kernel/time/timer.c                     |    8 +++
 lib/random32.c                          |    2 
 net/core/sock_map.c                     |   50 ++++++++++++++++++--
 tools/testing/selftests/bpf/test_maps.c |   12 ++--
 14 files changed, 184 insertions(+), 77 deletions(-)

Greg Kroah-Hartman (1):
      Linux 5.4.57

Grygorii Strashko (1):
      ARM: percpu.h: fix build error

Jiang Ying (1):
      ext4: fix direct I/O read error

Linus Torvalds (2):
      random32: remove net_rand_state from the latent entropy gcc plugin
      random32: move the pseudo-random 32-bit definitions to prandom.h

Lorenz Bauer (2):
      selftests: bpf: Fix detach from sockmap tests
      bpf: sockmap: Require attach_bpf_fd when detaching a program

Marc Zyngier (1):
      arm64: Workaround circular dependency in pointer_auth.h

Willy Tarreau (2):
      random32: update the net random state on interrupt and activity
      random: fix circular include dependency on arm64 after addition of percpu.h

