Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EEA4370AF9
	for <lists+stable@lfdr.de>; Sun,  2 May 2021 11:52:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232056AbhEBJwN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 2 May 2021 05:52:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:35276 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231818AbhEBJwN (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 2 May 2021 05:52:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8847C610FA;
        Sun,  2 May 2021 09:51:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1619949081;
        bh=ultN/83bCi1Igl+seIwFt8KSbu/xF873vtNVyJwtw4U=;
        h=From:To:Cc:Subject:Date:From;
        b=El1b7wP3m0Ma7tTYZpJ1paIhV05NF9bGgIx9La4omTymOgllDsq8MV3ZGOn412esG
         Cy8RejMGcVbbD2EmbibMrNnM/amhn2G2HTIH5+NEew+QygqpGLG4eEx5cEbRFfI6OQ
         futKtCu48kvQrzW2gEKobAJrvTW9NKzi5SDlJdmU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.12.1
Date:   Sun,  2 May 2021 11:51:15 +0200
Message-Id: <1619949076103205@kroah.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.12.1 kernel.

All users of the 5.12 kernel series must upgrade.

The updated 5.12.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.12.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                          |    2 -
 drivers/misc/mei/hw-me-regs.h                     |    1 
 drivers/misc/mei/pci-me.c                         |    1 
 drivers/net/usb/hso.c                             |    2 -
 drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c |    7 +++---
 drivers/usb/class/cdc-acm.c                       |    3 +-
 net/wireless/core.c                               |   21 +++++++++++++++----
 net/wireless/nl80211.c                            |   24 +++++++++++++++++-----
 8 files changed, 46 insertions(+), 15 deletions(-)

Greg Kroah-Hartman (1):
      Linux 5.12.1

Jiri Kosina (1):
      iwlwifi: Fix softirq/hardirq disabling in iwl_pcie_gen2_enqueue_hcmd()

Johan Hovold (1):
      net: hso: fix NULL-deref on disconnect regression

Johannes Berg (1):
      cfg80211: fix locking in netlink owner interface destruction

Oliver Neukum (1):
      USB: CDC-ACM: fix poison/unpoison imbalance

Tomas Winkler (1):
      mei: me: add Alder Lake P device id.

