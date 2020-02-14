Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D216115EF7A
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 18:48:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388957AbgBNP7h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 10:59:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:44486 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388953AbgBNP7f (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 10:59:35 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5C99A24688;
        Fri, 14 Feb 2020 15:59:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581695975;
        bh=k1sVeab+9d4zC3g2vP/8WxrH+7ZK4bXHgO/WnXajlcc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ogECddBm/4fFmzr+L+3bUSr7wuvziLWXZXZpveO+V4i3ZRPdivSVfdsAWwsg5oGxO
         JDHXb5cb6tZm+df1cgp4bk1CDxv6o9uZ+bl+FF+Z9uFhuQmbwkvDCkVKTMoJq9lb7L
         jtvDtKHkEEL0i42jR+H6wEjnkw5mLGRYsu1GlW/0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Raul E Rangel <rrangel@chromium.org>,
        Enric Balletbo i Serra <enric.balletbo@collabora.com>,
        Wolfram Sang <wsa@the-dreams.de>,
        Sasha Levin <sashal@kernel.org>, linux-i2c@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 501/542] i2c: cros-ec-tunnel: Fix ACPI identifier
Date:   Fri, 14 Feb 2020 10:48:13 -0500
Message-Id: <20200214154854.6746-501-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214154854.6746-1-sashal@kernel.org>
References: <20200214154854.6746-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Raul E Rangel <rrangel@chromium.org>

[ Upstream commit b49f8e0e7bd17b968129790e40f9e2566f4f95ec ]

The initial patch was using the incorrect identifier.

Fixes: 9af1563a5486 ("i2c: cros-ec-tunnel: Make the device acpi compatible")
Signed-off-by: Raul E Rangel <rrangel@chromium.org>
Acked-by: Enric Balletbo i Serra <enric.balletbo@collabora.com>
Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-cros-ec-tunnel.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/i2c/busses/i2c-cros-ec-tunnel.c b/drivers/i2c/busses/i2c-cros-ec-tunnel.c
index 8a2db3ac3b3c7..790ea3fda693b 100644
--- a/drivers/i2c/busses/i2c-cros-ec-tunnel.c
+++ b/drivers/i2c/busses/i2c-cros-ec-tunnel.c
@@ -299,7 +299,7 @@ static const struct of_device_id cros_ec_i2c_of_match[] = {
 MODULE_DEVICE_TABLE(of, cros_ec_i2c_of_match);
 
 static const struct acpi_device_id cros_ec_i2c_tunnel_acpi_id[] = {
-	{ "GOOG001A", 0 },
+	{ "GOOG0012", 0 },
 	{ }
 };
 MODULE_DEVICE_TABLE(acpi, cros_ec_i2c_tunnel_acpi_id);
-- 
2.20.1

