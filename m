Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A603EA140
	for <lists+stable@lfdr.de>; Wed, 30 Oct 2019 17:10:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727041AbfJ3QAX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Oct 2019 12:00:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:57300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728043AbfJ3Pzo (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 30 Oct 2019 11:55:44 -0400
Received: from sasha-vm.mshome.net (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DE1A6217D9;
        Wed, 30 Oct 2019 15:55:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572450943;
        bh=+r78vgMnDR87npOWjtfsxJzphjSo8BM6zb8n59LRG3M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UIsrDZOtwV2SKdI78zQ8+dRWEv7MK+Q8PztIoNb1F6tkTwQWqjUd/JthhTL0r0liA
         DcwHz3MRenEtoiY6ChvoHSDzAkRDN/SAfLfA/NQ8bt1y+0uz+lTQ1fI9NL7QR8KTVZ
         0ATs14SZFE7c76C9q+TycV+8I259/oU+WiXAENRI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alain Volmat <alain.volmat@st.com>,
        Pierre-Yves MORDRET <pierre-yves.mordret@st.com>,
        Wolfram Sang <wsa@the-dreams.de>,
        Sasha Levin <sashal@kernel.org>, linux-i2c@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 34/38] i2c: stm32f7: remove warning when compiling with W=1
Date:   Wed, 30 Oct 2019 11:54:02 -0400
Message-Id: <20191030155406.10109-34-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191030155406.10109-1-sashal@kernel.org>
References: <20191030155406.10109-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alain Volmat <alain.volmat@st.com>

[ Upstream commit 348e46fbb4cdb2aead79aee1fd8bb25ec5fd25db ]

Remove the following warning:

drivers/i2c/busses/i2c-stm32f7.c:315:
warning: cannot understand function prototype:
'struct stm32f7_i2c_spec i2c_specs[] =

Replace a comment starting with /** by simply /* to avoid having
it interpreted as a kernel-doc comment.

Fixes: aeb068c57214 ("i2c: i2c-stm32f7: add driver")
Signed-off-by: Alain Volmat <alain.volmat@st.com>
Reviewed-by: Pierre-Yves MORDRET <pierre-yves.mordret@st.com>
Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-stm32f7.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/i2c/busses/i2c-stm32f7.c b/drivers/i2c/busses/i2c-stm32f7.c
index 362b23505f214..f4e3613f9361b 100644
--- a/drivers/i2c/busses/i2c-stm32f7.c
+++ b/drivers/i2c/busses/i2c-stm32f7.c
@@ -297,7 +297,7 @@ struct stm32f7_i2c_dev {
 	bool use_dma;
 };
 
-/**
+/*
  * All these values are coming from I2C Specification, Version 6.0, 4th of
  * April 2014.
  *
-- 
2.20.1

