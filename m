Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C0D231A0261
	for <lists+stable@lfdr.de>; Tue,  7 Apr 2020 02:05:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727469AbgDGADX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Apr 2020 20:03:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:38682 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726339AbgDGADS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 Apr 2020 20:03:18 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 84C0B2080C;
        Tue,  7 Apr 2020 00:03:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586217798;
        bh=1Lqk+doDrlT/SrI8d8AftpDemtX1pC+rrvgWeYNetTI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j9f/Zkbr7Kgu6gnRTNs3OKHc39jlGjWPUTV1TJ24Eww3EHmN1mvOUKPjCIzEEKuUw
         mQv4z10/9RYFEfyMDmCB9au5Y+KHBsiwwSv/D35qnKwZQ0H9a4yrZgtMUFPyA4lctI
         /dE2JZHZ6rT8gbAAwJFX1bcW3WNdMoJKQ0wTGWOk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alain Volmat <avolmat@me.com>,
        Patrice Chotard <patrice.chotard@st.com>,
        Wolfram Sang <wsa@the-dreams.de>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-i2c@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 4/4] i2c: st: fix missing struct parameter description
Date:   Mon,  6 Apr 2020 20:03:12 -0400
Message-Id: <20200407000312.17447-4-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200407000312.17447-1-sashal@kernel.org>
References: <20200407000312.17447-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alain Volmat <avolmat@me.com>

[ Upstream commit f491c6687332920e296d0209e366fe2ca7eab1c6 ]

Fix a missing struct parameter description to allow
warning free W=1 compilation.

Signed-off-by: Alain Volmat <avolmat@me.com>
Reviewed-by: Patrice Chotard <patrice.chotard@st.com>
Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-st.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/i2c/busses/i2c-st.c b/drivers/i2c/busses/i2c-st.c
index 25020ec777c97..ee0a7d3dd0c65 100644
--- a/drivers/i2c/busses/i2c-st.c
+++ b/drivers/i2c/busses/i2c-st.c
@@ -399,6 +399,7 @@ static void st_i2c_wr_fill_tx_fifo(struct st_i2c_dev *i2c_dev)
 /**
  * st_i2c_rd_fill_tx_fifo() - Fill the Tx FIFO in read mode
  * @i2c_dev: Controller's private data
+ * @max: Maximum amount of data to fill into the Tx FIFO
  *
  * This functions fills the Tx FIFO with fixed pattern when
  * in read mode to trigger clock.
-- 
2.20.1

