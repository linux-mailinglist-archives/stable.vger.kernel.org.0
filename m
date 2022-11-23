Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A16A635E92
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 13:58:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238272AbiKWMxr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 07:53:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238545AbiKWMwu (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 07:52:50 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 205088B849;
        Wed, 23 Nov 2022 04:45:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BAC24B81F3A;
        Wed, 23 Nov 2022 12:45:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E0C6C433D6;
        Wed, 23 Nov 2022 12:45:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669207501;
        bh=pjV+YzoeVY7nvyOqe8WbShBBG5zI+yI93RPzfb2bX6A=;
        h=From:To:Cc:Subject:Date:From;
        b=NoYdPI8YEfHHuewTa/FlWKV+fPYRUDxhV/+wQNorRG/ylYQcDSxiI+G4KxIqrbPg7
         Bphbm6oDEE7nj+t/uyXl33wntzawuO8G/fWVmtNJOAI99MFek3bFRFPXcg1LIYmJ9g
         uyTEM6gq3E5kjZdx21PPzs7hHNf7XZeEX4C88GGcEJs18AMxZUyoK448wBhjqeU1hx
         g5dWqoDuCS/Ui81HwJAXCg/t7GgESEDP6goO6WDp+cX6XW6FAuyRXIp39b98gFbIj6
         YDulRJvehMuWebBXL3sa4tynRBWCR0qWPdU3Vkh7rPpAg9g9e96IVbizeMq1BH9oTL
         lk3p8IaZ+Wq/Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Aman Dhoot <amandhoot12@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>, markpearson@lenovo.com,
        lyude@redhat.com, wsa+renesas@sang-engineering.com,
        snafu109@gmail.com, linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 01/11] Input: synaptics - switch touchpad on HP Laptop 15-da3001TU to RMI mode
Date:   Wed, 23 Nov 2022 07:44:46 -0500
Message-Id: <20221123124458.266492-1-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aman Dhoot <amandhoot12@gmail.com>

[ Upstream commit ac5408991ea6b06e29129b4d4861097c4c3e0d59 ]

The device works fine in native RMI mode, there is no reason to use legacy
PS/2 mode with it.

Signed-off-by: Aman Dhoot <amandhoot12@gmail.com>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/mouse/synaptics.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/input/mouse/synaptics.c b/drivers/input/mouse/synaptics.c
index c6d393114502..7dc8ca5fd75f 100644
--- a/drivers/input/mouse/synaptics.c
+++ b/drivers/input/mouse/synaptics.c
@@ -192,6 +192,7 @@ static const char * const smbus_pnp_ids[] = {
 	"SYN3221", /* HP 15-ay000 */
 	"SYN323d", /* HP Spectre X360 13-w013dx */
 	"SYN3257", /* HP Envy 13-ad105ng */
+	"SYN3286", /* HP Laptop 15-da3001TU */
 	NULL
 };
 
-- 
2.35.1

