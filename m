Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 622193C3BAA
	for <lists+stable@lfdr.de>; Sun, 11 Jul 2021 13:08:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231567AbhGKLLO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Jul 2021 07:11:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:43532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231197AbhGKLLO (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 11 Jul 2021 07:11:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4F982611CB;
        Sun, 11 Jul 2021 11:08:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626001706;
        bh=syiZqEH3TEtBFqGui6PiXQuliqRXv4HiftJ/7fbiLCU=;
        h=From:To:Cc:Subject:Date:From;
        b=rt2uTDYVrEKmdXc6YQiNKZ03v++KuW8lkJfR7nlqbFYxyimf4BTKl6+YnB/Tzuwcr
         UUgsjaiHbFKr0eQ/DfUujv26/xq4UJyEYN2DiD/X7Z2DNiOUl68Qmpf+llIi2zwQX1
         6bZgYevyysdOw7N0vB5SYc0y1CFJS41B4jl1H/GQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.4.275
Date:   Sun, 11 Jul 2021 13:08:23 +0200
Message-Id: <1626001702192152@kroah.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.4.275 kernel.

All users of the 4.4 kernel series must upgrade.

The updated 4.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                             |    2 +-
 arch/arm/probes/kprobes/core.c       |    6 ++++++
 drivers/gpu/drm/nouveau/nouveau_bo.c |    4 ++--
 drivers/scsi/sr.c                    |    2 ++
 drivers/xen/events/events_base.c     |   23 +++++++++++++++++++----
 5 files changed, 30 insertions(+), 7 deletions(-)

Christian König (1):
      drm/nouveau: fix dma_address check for CPU/GPU sync

Greg Kroah-Hartman (1):
      Linux 4.4.275

Juergen Gross (1):
      xen/events: reset active flag for lateeoi events later

ManYi Li (1):
      scsi: sr: Return appropriate error code when disk is ejected

Masami Hiramatsu (1):
      arm: kprobes: Allow to handle reentered kprobe on single-stepping

