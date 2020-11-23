Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10D972C0696
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 13:43:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731109AbgKWMch (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 07:32:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:43900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729564AbgKWMcf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:32:35 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C6DC920728;
        Mon, 23 Nov 2020 12:32:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606134755;
        bh=MBo+IX/ML+jkCXfW30TJxNyDNIrE5kK8+sEyXfS/fdo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YOvRqqrcXvFwNeRHzdb6Mm+WY/pI23nQVbPqE4VkLdVRtdoSavQzNqdVt6aBjtCPy
         sxT3kS74DUoLAq+Ccesohv+dfDQByiA9IU8p4LfI7HCpj4SXMNlzkqkaH4uKcX9clY
         qtmebNNcMmW5kStbVT2vPivdJHIkvp8wHVgcWcmA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Michael Hennerich <michael.hennerich@analog.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 40/91] Input: adxl34x - clean up a data type in adxl34x_probe()
Date:   Mon, 23 Nov 2020 13:22:00 +0100
Message-Id: <20201123121811.262599370@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121809.285416732@linuxfoundation.org>
References: <20201123121809.285416732@linuxfoundation.org>
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
index a3e79bf5a04b0..3695dd7dbb9b4 100644
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



