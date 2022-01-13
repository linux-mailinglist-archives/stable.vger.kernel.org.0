Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F20EC48D600
	for <lists+stable@lfdr.de>; Thu, 13 Jan 2022 11:47:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233029AbiAMKrs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jan 2022 05:47:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232947AbiAMKrs (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Jan 2022 05:47:48 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16F22C061748
        for <stable@vger.kernel.org>; Thu, 13 Jan 2022 02:47:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CAE59B81ECF
        for <stable@vger.kernel.org>; Thu, 13 Jan 2022 10:47:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00D7FC36AE9;
        Thu, 13 Jan 2022 10:47:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1642070865;
        bh=PMNTEkBPUNsCVtUf0cKB2nvcsp9r5ZOQO6qv5wlPRgk=;
        h=Subject:To:Cc:From:Date:From;
        b=L6DGknniphBjf6Ynvf0kCbs7myf5RMkGrOX9jIZB2mIkM8fZBS1PlymDySw+cbZbO
         qKXpXJVXqKyICb0RVek+tTbnphNYSxnz2wgHfgXs4GER3K3OpZggYHCQJFYT+NAz3e
         RiU4gw9Q0YUWz63h251Ups5wd790lL/G1G4j1CqI=
Subject: FAILED: patch "[PATCH] Bluetooth: btbcm: disable read tx power for MacBook Air 8,1" failed to apply to 5.15-stable tree
To:     gargaditya08@live.com, marcel@holtmann.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 13 Jan 2022 11:47:32 +0100
Message-ID: <16420708528155@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 3318ae23bbcb14b7f68e9006756ba6d970955635 Mon Sep 17 00:00:00 2001
From: Aditya Garg <gargaditya08@live.com>
Date: Mon, 3 Jan 2022 13:28:42 +0000
Subject: [PATCH] Bluetooth: btbcm: disable read tx power for MacBook Air 8,1
 and 8,2

The MacBook Air 8,1 and 8,2 also need querying of LE Tx power
to be disabled for Bluetooth to work.

Signed-off-by: Aditya Garg <gargaditya08@live.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Cc: stable@vger.kernel.org

diff --git a/drivers/bluetooth/btbcm.c b/drivers/bluetooth/btbcm.c
index 07fabaa5aa29..d9ceca7a7935 100644
--- a/drivers/bluetooth/btbcm.c
+++ b/drivers/bluetooth/btbcm.c
@@ -363,6 +363,18 @@ static const struct dmi_system_id disable_broken_read_transmit_power[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "MacBookPro16,4"),
 		},
 	},
+	{
+		 .matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Apple Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "MacBookAir8,1"),
+		},
+	},
+	{
+		 .matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Apple Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "MacBookAir8,2"),
+		},
+	},
 	{
 		 .matches = {
 			DMI_MATCH(DMI_BOARD_VENDOR, "Apple Inc."),

