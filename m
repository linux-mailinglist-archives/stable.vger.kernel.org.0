Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30570DD467
	for <lists+stable@lfdr.de>; Sat, 19 Oct 2019 00:25:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729237AbfJRWX7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Oct 2019 18:23:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:36922 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729199AbfJRWFH (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 18 Oct 2019 18:05:07 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 28A5922459;
        Fri, 18 Oct 2019 22:05:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571436306;
        bh=G4sDF3vhwbkUaEFN14W+cmsj6eadQ2Ap69Vcige+G98=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zJxyJvi6AgWzLjt+eZnHt6jkobnXr8iNGMq8klw7E37s2P4lNoZSofBpKD43uGXQz
         3kwUOG6CSVBtSfWzkgIBjKyor2BxZQJzOmUU9+dwNMzTLB15UNu22KXPBjEWHEE8LH
         Sjq3EzMtgGyxS0+ONqVBcvsLEGZCUkejbXRklsUM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Marco Felsch <m.felsch@pengutronix.de>, Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>, linux-iio@vger.kernel.org
Subject: [PATCH AUTOSEL 5.3 77/89] iio: light: add missing vcnl4040 of_compatible
Date:   Fri, 18 Oct 2019 18:03:12 -0400
Message-Id: <20191018220324.8165-77-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191018220324.8165-1-sashal@kernel.org>
References: <20191018220324.8165-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marco Felsch <m.felsch@pengutronix.de>

[ Upstream commit 7fd1c2606508eb384992251e87d50591393a48d0 ]

Commit 5a441aade5b3 ("iio: light: vcnl4000 add support for the VCNL4040
proximity and light sensor") added the support for the vcnl4040 but
forgot to add the of_compatible. Fix this by adding it now.

Signed-off-by: Marco Felsch <m.felsch@pengutronix.de>
Fixes: 5a441aade5b3 ("iio: light: vcnl4000 add support for the VCNL4040 proximity and light sensor")
Reviewed-by: Angus Ainslie (Purism) angus@akkea.ca
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/light/vcnl4000.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/iio/light/vcnl4000.c b/drivers/iio/light/vcnl4000.c
index f522cb863e8c8..16dacea9eadfa 100644
--- a/drivers/iio/light/vcnl4000.c
+++ b/drivers/iio/light/vcnl4000.c
@@ -408,6 +408,10 @@ static const struct of_device_id vcnl_4000_of_match[] = {
 		.compatible = "vishay,vcnl4020",
 		.data = (void *)VCNL4010,
 	},
+	{
+		.compatible = "vishay,vcnl4040",
+		.data = (void *)VCNL4040,
+	},
 	{
 		.compatible = "vishay,vcnl4200",
 		.data = (void *)VCNL4200,
-- 
2.20.1

