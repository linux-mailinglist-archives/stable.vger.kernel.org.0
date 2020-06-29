Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2AC220DC6F
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 22:17:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728970AbgF2UPO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 16:15:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:40556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732829AbgF2TaR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 15:30:17 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1DE7F25279;
        Mon, 29 Jun 2020 15:36:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593444986;
        bh=aHJvosfP7d43KJpeh6puslOWNdY/vjt/a2wFCH5S5XQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Pn1ZGXT2iE4RAPytg64WWr3pnDeRP4ZPwQmiVTnf3gLfSuMpooFi3UyNxmmsWG3Dz
         79lZmh/uyNg1rt19tosd8aDLlcfBDmHKPDWpBMLgmGAl0jC/mBWAcwljbsBhTZhWZs
         9cfjCtIIox6ZSTkjBFyMQPsU49cokNNc0wS5Hlwo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Eddie James <eajames@linux.ibm.com>, Joel Stanley <joel@jms.id.au>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 086/131] i2c: fsi: Fix the port number field in status register
Date:   Mon, 29 Jun 2020 11:34:17 -0400
Message-Id: <20200629153502.2494656-87-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629153502.2494656-1-sashal@kernel.org>
References: <20200629153502.2494656-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.131-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.131-rc1
X-KernelTest-Deadline: 2020-07-01T15:34+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eddie James <eajames@linux.ibm.com>

[ Upstream commit 502035e284cc7e9efef22b01771d822d49698ab9 ]

The port number field in the status register was not correct, so fix it.

Fixes: d6ffb6300116 ("i2c: Add FSI-attached I2C master algorithm")
Signed-off-by: Eddie James <eajames@linux.ibm.com>
Signed-off-by: Joel Stanley <joel@jms.id.au>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-fsi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/i2c/busses/i2c-fsi.c b/drivers/i2c/busses/i2c-fsi.c
index 1e2be2219a602..46aef609fb708 100644
--- a/drivers/i2c/busses/i2c-fsi.c
+++ b/drivers/i2c/busses/i2c-fsi.c
@@ -98,7 +98,7 @@
 #define I2C_STAT_DAT_REQ	BIT(25)
 #define I2C_STAT_CMD_COMP	BIT(24)
 #define I2C_STAT_STOP_ERR	BIT(23)
-#define I2C_STAT_MAX_PORT	GENMASK(19, 16)
+#define I2C_STAT_MAX_PORT	GENMASK(22, 16)
 #define I2C_STAT_ANY_INT	BIT(15)
 #define I2C_STAT_SCL_IN		BIT(11)
 #define I2C_STAT_SDA_IN		BIT(10)
-- 
2.25.1

