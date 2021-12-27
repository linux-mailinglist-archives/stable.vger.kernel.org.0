Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7C8E4803CD
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 20:05:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232462AbhL0TFq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 14:05:46 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:40648 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232476AbhL0TFS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 14:05:18 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6811760FB2;
        Mon, 27 Dec 2021 19:05:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E9E2C36AEE;
        Mon, 27 Dec 2021 19:05:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640631917;
        bh=ECiiiM453iFAuJfjyDbx3kx0HLj9SbSvM2QjwUrtfDQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ePcKP7jYBrbOf8GquW2uUxsH0TuvBw+qYnPMKOS/ure68BZw5Kp9hxX45hF+MZrbK
         7qrwLsyDMsMpqxzBxlQ7KKU+0KldDbI9FX8CqlZZUzjobzmY4I5UYHehnoqFvua1jp
         Zi55OPJHgcCS9m1AgpHBDuBkRJ4DCoS9IZw0cr40hb0uOqC9C4Zxx/d45BMhJWe/Vk
         AKF9qTgPxlOEHccYMvf62NGZS8YbSbuGdmq75EQIYLiHwYW/omlVaJjZbwXEUJxWM7
         R5Sz7Q3TeMqh+XVuHL/xHsh3D/MP9qyhoiLuCsgrJzjVifBbD3dfiBu2BdrRXt0x0P
         5QcaLuMrka8aw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>, hadess@hadess.net,
        linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 04/14] Input: goodix - add id->model mapping for the "9111" model
Date:   Mon, 27 Dec 2021 14:04:42 -0500
Message-Id: <20211227190452.1042714-4-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227190452.1042714-1-sashal@kernel.org>
References: <20211227190452.1042714-1-sashal@kernel.org>
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
index a06385c55af2a..5fc789f717c8a 100644
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

