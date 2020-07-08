Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73CB9218BE2
	for <lists+stable@lfdr.de>; Wed,  8 Jul 2020 17:44:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730755AbgGHPms (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jul 2020 11:42:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:49468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730653AbgGHPmH (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 8 Jul 2020 11:42:07 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B8851207DF;
        Wed,  8 Jul 2020 15:42:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594222927;
        bh=D/Eush0zwrRAESt/++OQbx7+J6f0APoivtHQWJ8KTC0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PzJXjs+WwCDCffW9oNG6rjkwaBTNOQ5/Xf7BOwyukzXIHG3b+py0RoOnxWXXBzyEY
         8seppYyas8nHwrTmERgnf+GeVb3BUbNKboJbT1KYl3PKqiI3crzI4DwhXMxyDQvnzP
         vWgKmEq3/tuAnT8FYCaZKB0hAvoz8P/Cl2/Gvd8c=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>,
        linux-i2c@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 8/8] i2c: eg20t: Load module automatically if ID matches
Date:   Wed,  8 Jul 2020 11:41:56 -0400
Message-Id: <20200708154157.3200116-8-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200708154157.3200116-1-sashal@kernel.org>
References: <20200708154157.3200116-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 5f90786b31fb7d1e199a8999d46c4e3aea672e11 ]

The driver can't be loaded automatically because it misses
module alias to be provided. Add corresponding MODULE_DEVICE_TABLE()
call to the driver.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-eg20t.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/i2c/busses/i2c-eg20t.c b/drivers/i2c/busses/i2c-eg20t.c
index 231675b10376a..44025507b8f7b 100644
--- a/drivers/i2c/busses/i2c-eg20t.c
+++ b/drivers/i2c/busses/i2c-eg20t.c
@@ -188,6 +188,7 @@ static const struct pci_device_id pch_pcidev_id[] = {
 	{ PCI_VDEVICE(ROHM, PCI_DEVICE_ID_ML7831_I2C), 1, },
 	{0,}
 };
+MODULE_DEVICE_TABLE(pci, pch_pcidev_id);
 
 static irqreturn_t pch_i2c_handler(int irq, void *pData);
 
-- 
2.25.1

