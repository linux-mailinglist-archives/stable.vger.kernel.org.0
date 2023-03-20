Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 981C26C06F1
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 01:53:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229632AbjCTAxJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 19 Mar 2023 20:53:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229538AbjCTAxH (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 19 Mar 2023 20:53:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22C121A48A;
        Sun, 19 Mar 2023 17:53:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 83FC46114C;
        Mon, 20 Mar 2023 00:53:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BAC5C433D2;
        Mon, 20 Mar 2023 00:53:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679273585;
        bh=Xsolz83rCXsNcwOTYnTFqWA0Fsn4iBJ44RuNqsIKNGU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Oh802y01hz7cdtawNpGBDo4l5PSi25cYkabpxKUHHXoQjAWUZw0Ko9jFI7lqMnQBj
         voQOKhfgkBju5jWA7PmGX27Fum62syS/N9qWXGjMoGr0n7n5EvLdcKTulIUP7TN/dP
         2E87Fiufsw+jU9rvuQmh/a/749wgfaycC1oK60aG2+g6iIZeyM2a8s3p+HbaRPdt6V
         r7+hOJpwLIeFZ0W/iTnRrV/bwC6WunIo3gD4EipBvkQDbjh4rpsVVNKl1XQfDZmkke
         j9cfbzQsfWKgXtJ9pD2vrfRwtyscluZXRWVNE4n5AaUHVo1WSyRREvTJMQptBbWhLp
         llaO5heUxeAtw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Rafa=C5=82=20Szalecki?= <perexist7@gmail.com>,
        Bastien Nocera <hadess@hadess.net>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>,
        jikos@kernel.org, benjamin.tissoires@redhat.com,
        linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 6.2 04/30] HID: logitech-hidpp: Add support for Logitech MX Master 3S mouse
Date:   Sun, 19 Mar 2023 20:52:29 -0400
Message-Id: <20230320005258.1428043-4-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230320005258.1428043-1-sashal@kernel.org>
References: <20230320005258.1428043-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rafał Szalecki <perexist7@gmail.com>

[ Upstream commit db50f7a3983f0154e730f1147ef729e0c5c2f90c ]

Add signature for the Logitech MX Master 3S mouse over Bluetooth.

Signed-off-by: Rafał Szalecki <perexist7@gmail.com>
Reviewed-by: Bastien Nocera <hadess@hadess.net>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-logitech-hidpp.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/hid/hid-logitech-hidpp.c b/drivers/hid/hid-logitech-hidpp.c
index 5efc591a02a03..3c00e6ac8e76a 100644
--- a/drivers/hid/hid-logitech-hidpp.c
+++ b/drivers/hid/hid-logitech-hidpp.c
@@ -4378,6 +4378,8 @@ static const struct hid_device_id hidpp_devices[] = {
 	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_LOGITECH, 0xb01e) },
 	{ /* MX Master 3 mouse over Bluetooth */
 	  HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_LOGITECH, 0xb023) },
+	{ /* MX Master 3S mouse over Bluetooth */
+	  HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_LOGITECH, 0xb034) },
 	{}
 };
 
-- 
2.39.2

