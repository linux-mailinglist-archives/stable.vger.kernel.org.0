Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 586D338A498
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 12:06:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235220AbhETKGs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 06:06:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:36564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235389AbhETKE6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 06:04:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 636926142A;
        Thu, 20 May 2021 09:40:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621503647;
        bh=fE8jg5uAIRl/bt8t+FQsXsgY5X3KlleAIN93G7Ume60=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xecR4VJOuyt2c35Ow6spDMn/Aa5u5GTnBZaQeqb+KjUACs7qVHQY4YI9bFB4F7POe
         kYuEHTffeTgdkqyW8lP5cK1bs8O4tIllrYQHjkGJ86dGrCwww+HtkeFiddqV4XlNVh
         mkkL7OgZcUjKgUQWR7wzxBBOZ1nd/GZ/QjoIN4dk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wolfram Sang <wsa@kernel.org>,
        =?UTF-8?q?Bence=20Cs=C3=B3k=C3=A1s?= <bence98@sch.bme.hu>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 316/425] i2c: Add I2C_AQ_NO_REP_START adapter quirk
Date:   Thu, 20 May 2021 11:21:25 +0200
Message-Id: <20210520092141.819465740@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092131.308959589@linuxfoundation.org>
References: <20210520092131.308959589@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



