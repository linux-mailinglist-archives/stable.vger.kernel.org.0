Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B737C37452E
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 19:50:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237419AbhEEREJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 13:04:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:49796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237738AbhEERBF (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 May 2021 13:01:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8591A619E6;
        Wed,  5 May 2021 16:40:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620232828;
        bh=fE8jg5uAIRl/bt8t+FQsXsgY5X3KlleAIN93G7Ume60=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=amgc2EP8GfGEPfzpOacA7gE9tX+SEQrh1iAINIyXgjP0jU1mPF7egClWyQ7fPdEfp
         S6u3BW08wQ1er7eHB2hZ76tmg8jez0sL/VHaKRPUq26pNIFKAYKy1mQK8bh0+0EJvQ
         Qy+Wzg+MNzDgmfC7IYF0ne9QFohEMwf6lXLiK5f/p7bFmGhehgLn3iVT7+k+z5RR9x
         j2ap66fgI1k2DYis9GbBEEOAYOq//Q4VcEX5IVwHvpgBHyLT4mb+LZ1UoroYJMIgb4
         KXhDSG1bRaZ8V8O1noFlTzShxK47I+yE/zPzJBOn42GngaY3jXbvItMEwlQVpi6LGx
         l6+tXMy2ejSxQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Bence=20Cs=C3=B3k=C3=A1s?= <bence98@sch.bme.hu>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>,
        linux-i2c@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 16/32] i2c: Add I2C_AQ_NO_REP_START adapter quirk
Date:   Wed,  5 May 2021 12:39:48 -0400
Message-Id: <20210505164004.3463707-16-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210505164004.3463707-1-sashal@kernel.org>
References: <20210505164004.3463707-1-sashal@kernel.org>
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
index 7e748648c7d3..6fda0458745d 100644
--- a/include/linux/i2c.h
+++ b/include/linux/i2c.h
@@ -662,6 +662,8 @@ struct i2c_adapter_quirks {
 #define I2C_AQ_NO_ZERO_LEN_READ		BIT(5)
 #define I2C_AQ_NO_ZERO_LEN_WRITE	BIT(6)
 #define I2C_AQ_NO_ZERO_LEN		(I2C_AQ_NO_ZERO_LEN_READ | I2C_AQ_NO_ZERO_LEN_WRITE)
+/* adapter cannot do repeated START */
+#define I2C_AQ_NO_REP_START		BIT(7)
 
 /*
  * i2c_adapter is the structure used to identify a physical i2c bus along
-- 
2.30.2

