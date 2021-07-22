Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10D6A3D2827
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 18:37:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230366AbhGVPza (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 11:55:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:59034 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232701AbhGVPzB (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 11:55:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D4C2D6135B;
        Thu, 22 Jul 2021 16:35:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626971736;
        bh=5MZGAo6Fp6LDU2M3AioL/gDEt29UNo6GhUvcMd4bkTc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LAZ51ahcf/2WAz5JFWEuBSnWVhR+KzYm7w4cEif+uJzBe1dOdBKkEuRYe8trvH+3W
         XHqB6i/oCXubIfqXCvt7jQJYpXX4YHJcIzVGIsrVhBNLGdHwU0jn+hXROHfo4Zu1ly
         ExSJkHSRShJfpvO5kZwcZYILGCA/kRHxffFGh/dc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Gregory CLEMENT <gregory.clement@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 46/71] firmware: turris-mox-rwtm: add marvell,armada-3700-rwtm-firmware compatible string
Date:   Thu, 22 Jul 2021 18:31:21 +0200
Message-Id: <20210722155619.400397378@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210722155617.865866034@linuxfoundation.org>
References: <20210722155617.865866034@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pali Rohár <pali@kernel.org>

[ Upstream commit 90ae47215de3fec862aeb1a0f0e28bb505ab1351 ]

Add more generic compatible string 'marvell,armada-3700-rwtm-firmware' for
this driver, since it can also be used on other Armada 3720 devices.

Current compatible string 'cznic,turris-mox-rwtm' is kept for backward
compatibility.

Signed-off-by: Pali Rohár <pali@kernel.org>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Gregory CLEMENT <gregory.clement@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/turris-mox-rwtm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/firmware/turris-mox-rwtm.c b/drivers/firmware/turris-mox-rwtm.c
index 9a6cf5af27a3..0779513ac8d4 100644
--- a/drivers/firmware/turris-mox-rwtm.c
+++ b/drivers/firmware/turris-mox-rwtm.c
@@ -401,6 +401,7 @@ static int turris_mox_rwtm_remove(struct platform_device *pdev)
 
 static const struct of_device_id turris_mox_rwtm_match[] = {
 	{ .compatible = "cznic,turris-mox-rwtm", },
+	{ .compatible = "marvell,armada-3700-rwtm-firmware", },
 	{ },
 };
 
-- 
2.30.2



