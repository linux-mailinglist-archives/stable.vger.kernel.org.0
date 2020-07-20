Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D09F6226BE9
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:45:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729476AbgGTQp0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 12:45:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:32960 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729847AbgGTPlP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 11:41:15 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E824B20773;
        Mon, 20 Jul 2020 15:41:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595259675;
        bh=1jJqtYt05ZOEPAKdh+DDpoIQtFY9KcGcRX89suQ9w18=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iXn/fpmb0s8Wa/zZCbPToeaysGRKxNz4/dFYPCXo62G//dATxT6rQBfBABIThogVV
         u/dBLyrUzRY9w8H8fp2K7gVuKe/OGO1QFuV4z7r3pLEqo3vB3DDZrqm/NkK1894dzc
         k6IE3Vm47FvJwFGfaU9GwBSGQ+unTD0o7GTWyswk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 40/86] i2c: eg20t: Load module automatically if ID matches
Date:   Mon, 20 Jul 2020 17:36:36 +0200
Message-Id: <20200720152755.184025694@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152753.138974850@linuxfoundation.org>
References: <20200720152753.138974850@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 5ce71ce7b6c43..39f05e784566d 100644
--- a/drivers/i2c/busses/i2c-eg20t.c
+++ b/drivers/i2c/busses/i2c-eg20t.c
@@ -189,6 +189,7 @@ static const struct pci_device_id pch_pcidev_id[] = {
 	{ PCI_VDEVICE(ROHM, PCI_DEVICE_ID_ML7831_I2C), 1, },
 	{0,}
 };
+MODULE_DEVICE_TABLE(pci, pch_pcidev_id);
 
 static irqreturn_t pch_i2c_handler(int irq, void *pData);
 
-- 
2.25.1



