Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 487F510188F
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 07:11:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727726AbfKSFZX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:25:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:42682 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727684AbfKSFZW (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:25:22 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2B70A21823;
        Tue, 19 Nov 2019 05:25:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574141121;
        bh=OVrIbVCAkUxIXhK+atxs9e/hAi56a9ksTK9A2USy0Vs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XEP3S0TXw5y2Mc4hOX9HdzUHmxlH4KEYFI+oI1vupi2lZl6AHOjAaYgIyGfQzUjZ1
         E/AUkDmtlggMPIDseT8ZgjKlTYFTf63dlKxRjcDUNF4jxyB4BcYjYMgSscXHJhWE1i
         Hp4muusYo04RLjkLenD1/Q5YPZCXAsvWgzBkVjLo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 050/422] rtc: rv8803: fix the rv8803 id in the OF table
Date:   Tue, 19 Nov 2019 06:14:07 +0100
Message-Id: <20191119051403.083563966@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051400.261610025@linuxfoundation.org>
References: <20191119051400.261610025@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexandre Belloni <alexandre.belloni@bootlin.com>

[ Upstream commit c856618d20662695fcdb47bf4d560dc457662aec ]

The ID for RV8803 must be rv_8803

Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-rv8803.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/rtc/rtc-rv8803.c b/drivers/rtc/rtc-rv8803.c
index 29fc3d2103923..17ccef5d5db1a 100644
--- a/drivers/rtc/rtc-rv8803.c
+++ b/drivers/rtc/rtc-rv8803.c
@@ -623,7 +623,7 @@ MODULE_DEVICE_TABLE(i2c, rv8803_id);
 static const struct of_device_id rv8803_of_match[] = {
 	{
 		.compatible = "microcrystal,rv8803",
-		.data = (void *)rx_8900
+		.data = (void *)rv_8803
 	},
 	{
 		.compatible = "epson,rx8900",
-- 
2.20.1



