Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F4FD5B4A1A
	for <lists+stable@lfdr.de>; Sat, 10 Sep 2022 23:26:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231260AbiIJV0y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Sep 2022 17:26:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231261AbiIJVZp (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Sep 2022 17:25:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5951452FD4;
        Sat, 10 Sep 2022 14:21:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2116460EF8;
        Sat, 10 Sep 2022 21:19:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 992ADC4347C;
        Sat, 10 Sep 2022 21:19:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662844777;
        bh=iPJdzqZkaPbbW0M+Sk9HKES9lv2O1Zy8J6UuE8E/eg4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MSeuLqFs7q/+PfiFp0kNpg6giQs/mnA+nI+WZmXTc6KvaNORHM9CsX+AtX3IExQOn
         sX4Y5Ao/vd9BImsuj15swP2sicvufwBUeW8fBbiAQC5crpGjZK1f46wB5ObcbReuZw
         iX29ezBScXPOHSXyC9nShjmmHS223Z9/38yK7BZlNYtJ6fFu8V/nuQFF813WXNHoqr
         d9HiUvwD2Yf4WVLCiXwHrdBhbVLFuWbxvQa0hsDNp5SX6TxG2mFGJTiYuP42QD66nu
         q7j2k+/7i6RJedEwzsWY0IitmU6Bd8osqrZ063PCD6JOSfnhGCvwp1VsoRn5xZu38F
         HUFmq66iNAM0g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hu Xiaoying <huxiaoying@kylinos.cn>,
        Matthias Kaehlcke <mka@chromium.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org,
        usb-storage@lists.one-eyed-alien.net
Subject: [PATCH AUTOSEL 4.19 8/8] usb: storage: Add ASUS <0x0b05:0x1932> to IGNORE_UAS
Date:   Sat, 10 Sep 2022 17:19:21 -0400
Message-Id: <20220910211921.70891-8-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220910211921.70891-1-sashal@kernel.org>
References: <20220910211921.70891-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hu Xiaoying <huxiaoying@kylinos.cn>

[ Upstream commit c61feaee68b9735be06f162bc046c7f1959efb0c ]

USB external storage device(0x0b05:1932), use gnome-disk-utility tools
to test usb write  < 30MB/s.
if does not to load module of uas for this device, can increase the
write speed from 20MB/s to >40MB/s.

Suggested-by: Matthias Kaehlcke <mka@chromium.org>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Hu Xiaoying <huxiaoying@kylinos.cn>
Link: https://lore.kernel.org/r/20220901045737.3438046-1-huxiaoying@kylinos.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/storage/unusual_uas.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/usb/storage/unusual_uas.h b/drivers/usb/storage/unusual_uas.h
index 2f72753c3e225..0b37c8e550e7d 100644
--- a/drivers/usb/storage/unusual_uas.h
+++ b/drivers/usb/storage/unusual_uas.h
@@ -62,6 +62,13 @@ UNUSUAL_DEV(0x0984, 0x0301, 0x0128, 0x0128,
 		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
 		US_FL_IGNORE_UAS),
 
+/* Reported-by: Tom Hu <huxiaoying@kylinos.cn> */
+UNUSUAL_DEV(0x0b05, 0x1932, 0x0000, 0x9999,
+		"ASUS",
+		"External HDD",
+		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
+		US_FL_IGNORE_UAS),
+
 /* Reported-by: David Webb <djw@noc.ac.uk> */
 UNUSUAL_DEV(0x0bc2, 0x331a, 0x0000, 0x9999,
 		"Seagate",
-- 
2.35.1

