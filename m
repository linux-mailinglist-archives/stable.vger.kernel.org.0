Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5163223E8B4
	for <lists+stable@lfdr.de>; Fri,  7 Aug 2020 10:15:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727095AbgHGIPh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Aug 2020 04:15:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:59910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727077AbgHGIPf (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 7 Aug 2020 04:15:35 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4C05E206B5;
        Fri,  7 Aug 2020 08:15:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596788134;
        bh=cNfG/Dow0XCKN1R+W+pxC2tXZM3EcMUir6KPv7WAako=;
        h=From:To:Cc:Subject:Date:From;
        b=jVhLEEaJbqyixbaB+eR9g+bxbvUGZ0hmkSYks0v5gd+45ZE7qb1xDxlFbwE7B+cid
         iO8LnFjDJGWFs1UC8buUglbExjpz/ic/iNc5O6veS6HKLq5QyTC3eXUFOlhkHufuJu
         /xlVW+m0XgL9KnJ+VvQcKs2u+AhZsdILnGqhIkx4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.7.14
Date:   Fri,  7 Aug 2020 10:15:42 +0200
Message-Id: <1596788142150248@kroah.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.7.14 kernel.

All users of the 5.7 kernel series must upgrade.

The updated 5.7.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.7.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                              |    2 
 arch/arm/include/asm/percpu.h         |    2 
 arch/arm64/include/asm/archrandom.h   |    1 
 arch/arm64/include/asm/pointer_auth.h |    8 +++
 arch/arm64/kernel/kaslr.c             |    2 
 drivers/char/random.c                 |    1 
 include/linux/prandom.h               |   78 ++++++++++++++++++++++++++++++++++
 include/linux/random.h                |   63 +--------------------------
 kernel/time/timer.c                   |    8 +++
 lib/random32.c                        |    2 
 10 files changed, 103 insertions(+), 64 deletions(-)

Greg Kroah-Hartman (1):
      Linux 5.7.14

Grygorii Strashko (1):
      ARM: percpu.h: fix build error

Linus Torvalds (3):
      random32: remove net_rand_state from the latent entropy gcc plugin
      random32: move the pseudo-random 32-bit definitions to prandom.h
      random: random.h should include archrandom.h, not the other way around

Marc Zyngier (1):
      arm64: Workaround circular dependency in pointer_auth.h

Willy Tarreau (2):
      random32: update the net random state on interrupt and activity
      random: fix circular include dependency on arm64 after addition of percpu.h

