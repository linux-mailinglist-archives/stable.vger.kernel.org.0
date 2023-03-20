Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F04D6C084A
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 02:09:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230519AbjCTBJi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 19 Mar 2023 21:09:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231292AbjCTBJH (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 19 Mar 2023 21:09:07 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE9B12203E;
        Sun, 19 Mar 2023 18:00:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id BFA58CE1018;
        Mon, 20 Mar 2023 00:54:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D51DC433A0;
        Mon, 20 Mar 2023 00:54:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679273661;
        bh=E7EQYQXRaLRNx1bbv4x7/S3qJQ4eXr3q7YX+k86XXQk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sqiRRIfJcbWBo0BaRVOdgPyJDz0/HjqcxB/PbS1GWvjj3azZz6Du5AtEQ2QRI1HOp
         ygcg8eNeU/WymeY1Itox3r3yD3GdWyGWL2haydev7OTENJwp9VjBaZg04y8onQkASY
         YUBvp/CS9Cgmoa9HEKl7ncHXlvxKbPbhnnkRjRTCim/wI8HP9TjDTy+eGaWJK2SZqW
         lXmzV6pCPGkzNQViWHN54EE1qpf93q2iFh2mSHlLBx1fc0mG8jIaYb+zB3lRj3aVw3
         K5V28ZHyRLyZEUkV7/ROPeuhUX1HAIKnyJKbskhU68cFmC9Bk/dEmUYhnVIUHZ4/Cc
         TqXjAdK9GwN1A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Rafa=C5=82=20Szalecki?= <perexist7@gmail.com>,
        Bastien Nocera <hadess@hadess.net>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>,
        jikos@kernel.org, benjamin.tissoires@redhat.com,
        linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 04/29] HID: logitech-hidpp: Add support for Logitech MX Master 3S mouse
Date:   Sun, 19 Mar 2023 20:53:46 -0400
Message-Id: <20230320005413.1428452-4-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230320005413.1428452-1-sashal@kernel.org>
References: <20230320005413.1428452-1-sashal@kernel.org>
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
index fdb66dc065822..e906ee375298a 100644
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

