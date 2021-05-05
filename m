Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8BFD37407F
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 18:34:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234484AbhEEQfE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 12:35:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:53294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234210AbhEEQdf (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 May 2021 12:33:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 128CA6141F;
        Wed,  5 May 2021 16:32:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620232345;
        bh=IMJ8hZyHaeaxYIxJ3ChM/Z56gbfXgXe0IxNM/jf0ZWY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=djCaMwS1+EWRvRPrdq7K2wybke2O827UCPNzkFFPxRNE7Rayv0+Zw7cQq2Ipwk9Sb
         8OwiobRMEXYJ7OffbHMC5BFv/4FD8y7UHSWHk8q3//P+p9hE+YN0w8Qsb52tGInwHZ
         iI0V/hAOPJzPLDMXdjN40120pz8fzrM4BRSCQS1Byea4hmJlRCYa5GRubcSlUcM42N
         fJ9i/Q3Kn3TH2iPgAvHHSU3wB/zj/uUrKsqkh9m4VGL3IC3Z4Vc85VuAlwljFEmTc4
         fivcdqB5c7wOXseBZtvYB16QCg+ezGel3reJiNOL4cdU8SHpNwMG4B0x2OVW2Wgmqh
         xehs9pEhaJbZQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Bence=20Cs=C3=B3k=C3=A1s?= <bence98@sch.bme.hu>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>,
        linux-i2c@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 044/116] i2c: Add I2C_AQ_NO_REP_START adapter quirk
Date:   Wed,  5 May 2021 12:30:12 -0400
Message-Id: <20210505163125.3460440-44-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210505163125.3460440-1-sashal@kernel.org>
References: <20210505163125.3460440-1-sashal@kernel.org>
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

