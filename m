Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 594BE40D901
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 13:45:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237719AbhIPLqZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 07:46:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:39730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238147AbhIPLqY (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 07:46:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F150D60FDA;
        Thu, 16 Sep 2021 11:45:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631792704;
        bh=d6bfgwU9MNCRxX3jxcY/xcUtdYmu6o5jBAP7DlGBtxo=;
        h=From:To:Cc:Subject:Date:From;
        b=EH0uuIa9/cklJ94rbpRMAp2amRHughqLG1N7ZP2XIO6tLTd931ejeiH1qZGNA2cCi
         yz7F1Lxok0zVwfzyKxcxsjiLvN1M3z6USlUS33zEBePSuogV8uRPaw0ZXAVLjLVKoz
         /sQM9ooW/OZQGIX3Ixu7U/YJR5ZZFgMoTXBdcgE4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.4.147
Date:   Thu, 16 Sep 2021 13:44:55 +0200
Message-Id: <16317926868288@kroah.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.4.147 kernel.

This, and the other stable kernels released today, consist of only some
reverts to solve some reported problems with the last round of stable
releases.  Upgrading is not required, but highly recommended.


The updated 5.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                       |    2 +-
 drivers/block/nbd.c            |   10 ----------
 include/linux/time64.h         |    9 ++-------
 kernel/time/posix-cpu-timers.c |    2 ++
 net/bluetooth/hci_core.c       |    8 --------
 5 files changed, 5 insertions(+), 26 deletions(-)

Greg Kroah-Hartman (4):
      Revert "block: nbd: add sanity check for first_minor"
      Revert "posix-cpu-timers: Force next expiration recalc after itimer reset"
      Revert "time: Handle negative seconds correctly in timespec64_to_ns()"
      Linux 5.4.147

Sasha Levin (1):
      Revert "Bluetooth: Move shutdown callback before flushing tx and rx queue"

