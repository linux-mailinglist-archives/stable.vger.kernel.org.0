Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE6BE40D8F9
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 13:44:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235696AbhIPLpW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 07:45:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:38790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233746AbhIPLpW (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 07:45:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8A10A60E08;
        Thu, 16 Sep 2021 11:44:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631792642;
        bh=iuTjmrwOGJF/U+hat8dUHCJ3nWJYekvOf9ANTIFJEng=;
        h=From:To:Cc:Subject:Date:From;
        b=IRquZnLh6vPrnLhHruYLFsSAP+OJRYyK9+ceu1XhnEoFaCarH2x6OV6E25Slqp3aH
         Dv0IjDiEDkBKbkLQsuNOnK1WW7UVNHARRlZFJLgpo4gY98pT67nYDdFz4vit81ZxFd
         Mqx/TPDJVJQIax1obt4iv/25FPxtYUgLuy+1yrE0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.13.18
Date:   Thu, 16 Sep 2021 13:43:58 +0200
Message-Id: <163179261684117@kroah.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.13.18 kernel.

This, and the other stable kernels released today, consist of only some
reverts to solve some reported problems with the last round of stable
releases.  Upgrading is not required, but highly recommended.

The updated 5.13.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.13.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                       |    2 +-
 include/linux/time64.h         |    9 ++-------
 kernel/time/posix-cpu-timers.c |    2 ++
 net/bluetooth/hci_core.c       |    8 --------
 4 files changed, 5 insertions(+), 16 deletions(-)

Greg Kroah-Hartman (3):
      Revert "posix-cpu-timers: Force next expiration recalc after itimer reset"
      Revert "time: Handle negative seconds correctly in timespec64_to_ns()"
      Linux 5.13.18

Sasha Levin (1):
      Revert "Bluetooth: Move shutdown callback before flushing tx and rx queue"

