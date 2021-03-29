Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16D9934C96D
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:32:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232930AbhC2I3o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:29:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:43598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234078AbhC2I1o (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:27:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 00C43619C4;
        Mon, 29 Mar 2021 08:26:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617006402;
        bh=ku5+MQ2Ahs42rKootnHa+yWW/EzfjcQ99FUNe6czjac=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Zlha0N9D7eMC1nfBk39FwBUNNDexniTwfIslAh1pWiFSs8+fPjeq1TPylft4oTMTL
         nNUItbXE59QC1g8+LCMItJs+rOtoGXXQseGEi7UR82N8uZ2YTgj/NspufqXbuFujg8
         W0lsJsT0XAumjyhBgu7moT9aZQga3rHAxZzdjSZ0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Leon Romanovsky <leon@kernel.org>,
        Stephane Grosjean <s.grosjean@peak-system.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 5.10 221/221] can: peak_usb: Revert "can: peak_usb: add forgotten supported devices"
Date:   Mon, 29 Mar 2021 09:59:12 +0200
Message-Id: <20210329075636.516914398@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075629.172032742@linuxfoundation.org>
References: <20210329075629.172032742@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Kleine-Budde <mkl@pengutronix.de>

commit 5d7047ed6b7214fbabc16d8712a822e256b1aa44 upstream.

In commit 6417f03132a6 ("module: remove never implemented
MODULE_SUPPORTED_DEVICE") the MODULE_SUPPORTED_DEVICE macro was
removed from the kerne entirely. Shortly before this patch was applied
mainline the commit 59ec7b89ed3e ("can: peak_usb: add forgotten
supported devices") was added to net/master. As this would result in a
merge conflict, let's revert this patch.

Fixes: 59ec7b89ed3e ("can: peak_usb: add forgotten supported devices")
Link: https://lore.kernel.org/r/20210320192649.341832-1-mkl@pengutronix.de
Suggested-by: Leon Romanovsky <leon@kernel.org>
Cc: Stephane Grosjean <s.grosjean@peak-system.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/usb/peak_usb/pcan_usb_fd.c |    2 --
 1 file changed, 2 deletions(-)

--- a/drivers/net/can/usb/peak_usb/pcan_usb_fd.c
+++ b/drivers/net/can/usb/peak_usb/pcan_usb_fd.c
@@ -18,8 +18,6 @@
 
 MODULE_SUPPORTED_DEVICE("PEAK-System PCAN-USB FD adapter");
 MODULE_SUPPORTED_DEVICE("PEAK-System PCAN-USB Pro FD adapter");
-MODULE_SUPPORTED_DEVICE("PEAK-System PCAN-Chip USB");
-MODULE_SUPPORTED_DEVICE("PEAK-System PCAN-USB X6 adapter");
 
 #define PCAN_USBPROFD_CHANNEL_COUNT	2
 #define PCAN_USBFD_CHANNEL_COUNT	1


