Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B86723744E9
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 19:49:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236407AbhEERCz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 13:02:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:44942 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237060AbhEEQ5T (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 May 2021 12:57:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3A90761990;
        Wed,  5 May 2021 16:39:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620232762;
        bh=lOLb1U/LFndGyUS9pSV47msKFv/hC0kgXkafKNJFgBg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EVYQu6RSZUmKT/edLggMNnDvR/xz4xAbs8KuGiMXCeixPT1UY4XJBG3RCqga3dMeX
         bmRHoe7FFzciOVNgWThVb10+9KCyn+Nm7xA+Z0S8XuJVEONiDIda+orKbeulCFM2rR
         744oR1Jbv4Xwj54jfOmuTeUpN/gjcoAt12N9brHxpgXUFDTmFWn6hpOL0qgLVpcJ3m
         IUNVxa0fpdPKMoKXb/54V+9N9Q6+bHaBn2esIh3dEb4nPi4R8jDcTj3EgLO+MEZuag
         Fs97BzYM0rtoh7PGjrKwxsyvfZHHLNps9rhOnTZUGX6aFG6ee5/s1y6HejDX43o69U
         d8DjqRuqCDjzA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Bence=20Cs=C3=B3k=C3=A1s?= <bence98@sch.bme.hu>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>,
        linux-i2c@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 18/46] i2c: Add I2C_AQ_NO_REP_START adapter quirk
Date:   Wed,  5 May 2021 12:38:28 -0400
Message-Id: <20210505163856.3463279-18-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210505163856.3463279-1-sashal@kernel.org>
References: <20210505163856.3463279-1-sashal@kernel.org>
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
index 1361637c369d..af2b799d7a66 100644
--- a/include/linux/i2c.h
+++ b/include/linux/i2c.h
@@ -677,6 +677,8 @@ struct i2c_adapter_quirks {
 #define I2C_AQ_NO_ZERO_LEN_READ		BIT(5)
 #define I2C_AQ_NO_ZERO_LEN_WRITE	BIT(6)
 #define I2C_AQ_NO_ZERO_LEN		(I2C_AQ_NO_ZERO_LEN_READ | I2C_AQ_NO_ZERO_LEN_WRITE)
+/* adapter cannot do repeated START */
+#define I2C_AQ_NO_REP_START		BIT(7)
 
 /*
  * i2c_adapter is the structure used to identify a physical i2c bus along
-- 
2.30.2

