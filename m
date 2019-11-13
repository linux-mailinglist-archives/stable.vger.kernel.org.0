Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19ADCFA25E
	for <lists+stable@lfdr.de>; Wed, 13 Nov 2019 03:04:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729588AbfKMCCT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 21:02:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:58780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730991AbfKMCCS (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Nov 2019 21:02:18 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B0493204EC;
        Wed, 13 Nov 2019 02:02:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573610538;
        bh=fI/sHNHGSc0l4/Uf78vJqDg2ySHPHwPPg75JGYqJpZw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v9F8WepgKhJhIq5QTk/HqjPKm3fFKnsAHMftfuNnozDuHjRbGAkxLEXUPEW58sO+5
         9FKSKkZSn7pZzWmFSvmom1hcFQKE1/qi6N21R/ILRKn+u8assKFQh/NMPEVGI5Nisx
         kDMSerqOqT6IqoEyr5afZfTkYlADjkVCWHfzMS5I=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Martin Kepplinger <martink@posteo.de>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>, linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 27/48] Input: st1232 - set INPUT_PROP_DIRECT property
Date:   Tue, 12 Nov 2019 21:01:10 -0500
Message-Id: <20191113020131.13356-27-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191113020131.13356-1-sashal@kernel.org>
References: <20191113020131.13356-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Martin Kepplinger <martink@posteo.de>

[ Upstream commit 20bbb312079494a406c10c90932e3c80837c9d94 ]

This is how userspace checks for touchscreen devices most reliably.

Signed-off-by: Martin Kepplinger <martink@posteo.de>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/touchscreen/st1232.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/input/touchscreen/st1232.c b/drivers/input/touchscreen/st1232.c
index e943678ce54cd..f1c574d6be17f 100644
--- a/drivers/input/touchscreen/st1232.c
+++ b/drivers/input/touchscreen/st1232.c
@@ -203,6 +203,7 @@ static int st1232_ts_probe(struct i2c_client *client,
 	input_dev->id.bustype = BUS_I2C;
 	input_dev->dev.parent = &client->dev;
 
+	__set_bit(INPUT_PROP_DIRECT, input_dev->propbit);
 	__set_bit(EV_SYN, input_dev->evbit);
 	__set_bit(EV_KEY, input_dev->evbit);
 	__set_bit(EV_ABS, input_dev->evbit);
-- 
2.20.1

