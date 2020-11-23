Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C8332C0720
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 13:44:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731985AbgKWMhn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 07:37:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:49852 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731981AbgKWMhm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:37:42 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1ED892076E;
        Mon, 23 Nov 2020 12:37:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606135060;
        bh=0LRfqDYjziXAuIpjvJLLp/ikPqxdv7i5/GDhApY3MoA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PU34X++bO/P/j31BudyfPIB10bapQwU4lpu9FMIwqFn9PGphZTMUNV1GPllKCSCH6
         RJBCCXEZPC/YOWBehnq3o++nlr89BHnIOZunI6zL7ggC+bOxXSTTBBmtE0iQGYCIny
         +plng+s9LsO4cSvgJMGBR6g5kRpSy72yZYKCFlWE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Michael Hennerich <michael.hennerich@analog.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 060/158] Input: adxl34x - clean up a data type in adxl34x_probe()
Date:   Mon, 23 Nov 2020 13:21:28 +0100
Message-Id: <20201123121822.835087869@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121819.943135899@linuxfoundation.org>
References: <20201123121819.943135899@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 33b6c39e747c552fa770eecebd1776f1f4a222b1 ]

The "revid" is used to store negative error codes so it should be an int
type.

Fixes: e27c729219ad ("Input: add driver for ADXL345/346 Digital Accelerometers")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Michael Hennerich <michael.hennerich@analog.com>
Link: https://lore.kernel.org/r/20201026072824.GA1620546@mwanda
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/misc/adxl34x.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/input/misc/adxl34x.c b/drivers/input/misc/adxl34x.c
index 5fe92d4ba3f0c..4cc4e8ff42b33 100644
--- a/drivers/input/misc/adxl34x.c
+++ b/drivers/input/misc/adxl34x.c
@@ -696,7 +696,7 @@ struct adxl34x *adxl34x_probe(struct device *dev, int irq,
 	struct input_dev *input_dev;
 	const struct adxl34x_platform_data *pdata;
 	int err, range, i;
-	unsigned char revid;
+	int revid;
 
 	if (!irq) {
 		dev_err(dev, "no IRQ?\n");
-- 
2.27.0



