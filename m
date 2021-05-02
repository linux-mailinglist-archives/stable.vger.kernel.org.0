Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB69A370AF1
	for <lists+stable@lfdr.de>; Sun,  2 May 2021 11:52:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231284AbhEBJwE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 2 May 2021 05:52:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:35146 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230222AbhEBJwC (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 2 May 2021 05:52:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 80990611F1;
        Sun,  2 May 2021 09:51:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1619949071;
        bh=IMlHwTOF5/kiHbNkUaue1IvRQIr7hXHc/hrwddPJgkM=;
        h=From:To:Cc:Subject:Date:From;
        b=I3rYTeVrEQy9BnNWAJWR2jBCtx2sKawJr6k2MtowKSvYnW8VgvBXC0nIpDYIqJt5k
         J3Tsp+97vw9YxRJFkT3g1rZ05/b98XFwW+z7oECqoMhyyjBoG1UV/WTxWfkANd5faK
         uSGx+aVwb8/LuyxLKZRWA6v5wrNuw4eIGAvMJhCM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.10.34
Date:   Sun,  2 May 2021 11:51:05 +0200
Message-Id: <161994906655242@kroah.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.10.34 kernel.

All users of the 5.10 kernel series must upgrade.

The updated 5.10.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.10.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                          |    2 +-
 drivers/misc/mei/hw-me-regs.h                     |    1 +
 drivers/misc/mei/pci-me.c                         |    1 +
 drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c |    7 ++++---
 4 files changed, 7 insertions(+), 4 deletions(-)

Greg Kroah-Hartman (1):
      Linux 5.10.34

Jiri Kosina (1):
      iwlwifi: Fix softirq/hardirq disabling in iwl_pcie_gen2_enqueue_hcmd()

Tomas Winkler (1):
      mei: me: add Alder Lake P device id.

