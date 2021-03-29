Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E591C34C6F3
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:12:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232572AbhC2ILK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:11:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:54086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232663AbhC2IKa (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:10:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4A3BA61481;
        Mon, 29 Mar 2021 08:10:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617005429;
        bh=62QVEbroNMzCrjQrgGEozezDsRbKEuTH4LbWoXT03G0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KIrcjZ0B4FMUFersPRzGAkEalLtbn54OHT3z4vdI59Ry3rUGaBWi6M3qGopQYtksa
         q71MmBgeDPesPOlUr3AteDDkAtE9ricrvc/dahl9dfhOST5iQ4W6MHXidZeDcvHyYu
         5P2GslhDxCgEEnM/9F2AtRXk7UCVqk861gWFZBLs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Stephane Grosjean <s.grosjean@peak-system.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 43/72] can: peak_usb: add forgotten supported devices
Date:   Mon, 29 Mar 2021 09:58:19 +0200
Message-Id: <20210329075611.710415404@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075610.300795746@linuxfoundation.org>
References: <20210329075610.300795746@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stephane Grosjean <s.grosjean@peak-system.com>

[ Upstream commit 59ec7b89ed3e921cd0625a8c83f31a30d485fdf8 ]

Since the peak_usb driver also supports the CAN-USB interfaces
"PCAN-USB X6" and "PCAN-Chip USB" from PEAK-System GmbH, this patch adds
their names to the list of explicitly supported devices.

Fixes: ea8b65b596d7 ("can: usb: Add support of PCAN-Chip USB stamp module")
Fixes: f00b534ded60 ("can: peak: Add support for PCAN-USB X6 USB interface")
Link: https://lore.kernel.org/r/20210309082128.23125-3-s.grosjean@peak-system.com
Signed-off-by: Stephane Grosjean <s.grosjean@peak-system.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/usb/peak_usb/pcan_usb_fd.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/can/usb/peak_usb/pcan_usb_fd.c b/drivers/net/can/usb/peak_usb/pcan_usb_fd.c
index 40ac37fe9dcd..1649687ab924 100644
--- a/drivers/net/can/usb/peak_usb/pcan_usb_fd.c
+++ b/drivers/net/can/usb/peak_usb/pcan_usb_fd.c
@@ -26,6 +26,8 @@
 
 MODULE_SUPPORTED_DEVICE("PEAK-System PCAN-USB FD adapter");
 MODULE_SUPPORTED_DEVICE("PEAK-System PCAN-USB Pro FD adapter");
+MODULE_SUPPORTED_DEVICE("PEAK-System PCAN-Chip USB");
+MODULE_SUPPORTED_DEVICE("PEAK-System PCAN-USB X6 adapter");
 
 #define PCAN_USBPROFD_CHANNEL_COUNT	2
 #define PCAN_USBFD_CHANNEL_COUNT	1
-- 
2.30.1



