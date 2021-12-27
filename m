Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E16AC480393
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 20:04:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232109AbhL0TEQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 14:04:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231991AbhL0TEG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 14:04:06 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 468E7C061401;
        Mon, 27 Dec 2021 11:04:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 068E9B81131;
        Mon, 27 Dec 2021 19:04:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CC42C36AE7;
        Mon, 27 Dec 2021 19:04:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640631843;
        bh=N0ntzL9n7F6zaBmZ69d2Pbj6alcZMcct6lCVxquk40A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W/4DiIsiEP3jCIXLiyyd0ZnVCGGExnU+s/Yx0U9JY5YRWxIvd7haI1lOwRxkEnsXf
         bq4btiBqY5aHva7LPtXu2Tnq3CKEOLl86v2536nQY3NM1V0fUdPxLY1mDJz3PnnkVw
         j2ilY6AtBBHKz6F2A3PNY38yEs57GDk2diPWI+8oXlFJYrTl6zx/KH8hOWeZk6OXsH
         d5z4NWLs7crjR/wwUjYiikb90P7O0ZB4d4RF6KA/MA4IhTkLBDAQQT9rKyypFxYHCa
         8vqoofEflLrMLf24VmB1s2RtYpx2IKE1Vo4oixIIumD53GjXRCXCtrZQEcjiKI3XhT
         OvCf1InjJfRKQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>, hadess@hadess.net,
        linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 07/26] Input: goodix - add id->model mapping for the "9111" model
Date:   Mon, 27 Dec 2021 14:03:08 -0500
Message-Id: <20211227190327.1042326-7-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227190327.1042326-1-sashal@kernel.org>
References: <20211227190327.1042326-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 81e818869be522bc8fa6f7df1b92d7e76537926c ]

Add d->model mapping for the "9111" model, this fixes uses using
a wrong config_len of 240 bytes while the "9111" model uses
only 186 bytes of config.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20211206164747.197309-2-hdegoede@redhat.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/touchscreen/goodix.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/input/touchscreen/goodix.c b/drivers/input/touchscreen/goodix.c
index 4f53d3c57e698..5051a1766aac6 100644
--- a/drivers/input/touchscreen/goodix.c
+++ b/drivers/input/touchscreen/goodix.c
@@ -162,6 +162,7 @@ static const struct goodix_chip_id goodix_chip_ids[] = {
 	{ .id = "911", .data = &gt911_chip_data },
 	{ .id = "9271", .data = &gt911_chip_data },
 	{ .id = "9110", .data = &gt911_chip_data },
+	{ .id = "9111", .data = &gt911_chip_data },
 	{ .id = "927", .data = &gt911_chip_data },
 	{ .id = "928", .data = &gt911_chip_data },
 
-- 
2.34.1

