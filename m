Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E6A23D28FA
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 19:05:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233406AbhGVQAK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 12:00:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:37072 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234000AbhGVP7q (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 11:59:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 88A1D60FDA;
        Thu, 22 Jul 2021 16:40:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626972020;
        bh=yaQgK6GymNvrNWCEIGwTdHdJfoB1jL7xOuc5pkRee2M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P0qDcXIIiCot0Npzvqw/N5GFluVMjWt9hWiJZHaB0jZ9tB8LsRktHb/eohqkQWaTo
         WrTEpi/jdIDimSUcUrQjvlqn4EEVJLTITSbYFtLVnZt61cFxCPssauyyp2A1FO2CyU
         vQI7LEqkBXQrAesjzCF7BeaQYwyhg8Q/zcyZz/qw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Gregory CLEMENT <gregory.clement@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 081/125] firmware: turris-mox-rwtm: add marvell,armada-3700-rwtm-firmware compatible string
Date:   Thu, 22 Jul 2021 18:31:12 +0200
Message-Id: <20210722155627.385637177@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210722155624.672583740@linuxfoundation.org>
References: <20210722155624.672583740@linuxfoundation.org>
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
index 03f1eac9ad69..0bef988580ad 100644
--- a/drivers/firmware/turris-mox-rwtm.c
+++ b/drivers/firmware/turris-mox-rwtm.c
@@ -569,6 +569,7 @@ static int turris_mox_rwtm_remove(struct platform_device *pdev)
 
 static const struct of_device_id turris_mox_rwtm_match[] = {
 	{ .compatible = "cznic,turris-mox-rwtm", },
+	{ .compatible = "marvell,armada-3700-rwtm-firmware", },
 	{ },
 };
 
-- 
2.30.2



