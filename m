Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21F56370AF4
	for <lists+stable@lfdr.de>; Sun,  2 May 2021 11:52:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231789AbhEBJwJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 2 May 2021 05:52:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:35200 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230222AbhEBJwH (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 2 May 2021 05:52:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D32DC6121E;
        Sun,  2 May 2021 09:51:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1619949076;
        bh=EsZT6hbPkJas/bQWSZHHkwz6fJFPVKZb+VBENnLJt04=;
        h=From:To:Cc:Subject:Date:From;
        b=PmTvlN1I0EZ1bq4oMk1WOxQg1C6bFn4xOgNmuJtSuPg1aRNwkle318HGviYdU8XR5
         xgldOFu7mefFC94xW+RS9Doit7+ne/1UWxLfxB14N6IdGmZNKHjgtT7lVrSivgpg0G
         j/b5QmQJQ8FV9xRnlnLC+gl5uVDuqTV2ZnXdohP8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.11.18
Date:   Sun,  2 May 2021 11:51:11 +0200
Message-Id: <161994907115454@kroah.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.11.18 kernel.

All users of the 5.11 kernel series must upgrade.

The updated 5.11.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.11.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                          |    2 +-
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |    4 ++--
 drivers/misc/mei/hw-me-regs.h                     |    1 +
 drivers/misc/mei/pci-me.c                         |    1 +
 drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c |    7 ++++---
 5 files changed, 9 insertions(+), 6 deletions(-)

Greg Kroah-Hartman (1):
      Linux 5.11.18

Jiri Kosina (1):
      iwlwifi: Fix softirq/hardirq disabling in iwl_pcie_gen2_enqueue_hcmd()

Qingqing Zhuo (1):
      drm/amd/display: Update modifier list for gfx10_3

Tomas Winkler (1):
      mei: me: add Alder Lake P device id.

