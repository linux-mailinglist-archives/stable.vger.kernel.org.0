Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 991E837424F
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 18:47:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235434AbhEEQq1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 12:46:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:49544 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235344AbhEEQny (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 May 2021 12:43:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E698261883;
        Wed,  5 May 2021 16:35:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620232512;
        bh=IMJ8hZyHaeaxYIxJ3ChM/Z56gbfXgXe0IxNM/jf0ZWY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UXkfui240w7rQiMSkBVEGStGVIb2PHyhILezE6whZTVdcIivsX7kwcTK22nNi2GU6
         2UYQ1yKIC9b0TP3x4OK4v232H6rfd1EKSIEXRvi3zC/YtWjp+LxllFIoIPLFWtgElA
         FeMMXxMMtWMqbSARluxDwGFbXscM0YXWOWMxfqlvD3JKhQHnXxzB1xL9vRUVqjE/HP
         PNjtej5w8b0jbd+bd8MLMwaIZyhufWXpesXj+NvZr2j2AQdAWepDJ2EWMUzlycVp9E
         teawpj9sI6MyZnLv0XIfe1cFTeGNmVHKIEg7dwYrzXi6XDPM6UH9qwT//h5xyMoZWP
         CXIZGu8Kmfung==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Bence=20Cs=C3=B3k=C3=A1s?= <bence98@sch.bme.hu>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>,
        linux-i2c@vger.kernel.org
Subject: [PATCH AUTOSEL 5.11 041/104] i2c: Add I2C_AQ_NO_REP_START adapter quirk
Date:   Wed,  5 May 2021 12:33:10 -0400
Message-Id: <20210505163413.3461611-41-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210505163413.3461611-1-sashal@kernel.org>
References: <20210505163413.3461611-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bence Csókás <bence98@sch.bme.hu>

[ Upstream commit aca01415e076aa96cca0f801f4420ee5c10c660d ]

This quirk signifies that the adapter cannot do a repeated
START, it always issues a STOP condition after transfers.

Suggested-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Bence Csókás <bence98@sch.bme.hu>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/i2c.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/i2c.h b/include/linux/i2c.h
index 56622658b215..a670ae129f4b 100644
--- a/include/linux/i2c.h
+++ b/include/linux/i2c.h
@@ -687,6 +687,8 @@ struct i2c_adapter_quirks {
 #define I2C_AQ_NO_ZERO_LEN_READ		BIT(5)
 #define I2C_AQ_NO_ZERO_LEN_WRITE	BIT(6)
 #define I2C_AQ_NO_ZERO_LEN		(I2C_AQ_NO_ZERO_LEN_READ | I2C_AQ_NO_ZERO_LEN_WRITE)
+/* adapter cannot do repeated START */
+#define I2C_AQ_NO_REP_START		BIT(7)
 
 /*
  * i2c_adapter is the structure used to identify a physical i2c bus along
-- 
2.30.2

