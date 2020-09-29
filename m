Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBD3A27CCF2
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 14:40:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727495AbgI2LOh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:14:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:57924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729111AbgI2LOf (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:14:35 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1F3A121D46;
        Tue, 29 Sep 2020 11:14:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601378074;
        bh=SUsGi52iwz/b8+clppZmZarS0BghQQJ738U/7mWT4xg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=elOXzD6KMmTUvoSVukZLYkXNLkbKYGKa7v7EP2yfb5552UhMacZq1E5H8sWpJsuzI
         NLTtNZiB0S3tj3+FFbxZpZB9xN5UtF85m8KB8/Ci8z8oypxoxG4Jln7sLeQLsGdebH
         XF9CbUCPPrT9Og9GC8Pc21eAYvZauIJHaDCH9m/o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mert Dirik <mertdirik@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 051/166] ar5523: Add USB ID of SMCWUSBT-G2 wireless adapter
Date:   Tue, 29 Sep 2020 12:59:23 +0200
Message-Id: <20200929105937.752327535@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105935.184737111@linuxfoundation.org>
References: <20200929105935.184737111@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mert Dirik <mertdirik@gmail.com>

[ Upstream commit 5b362498a79631f283578b64bf6f4d15ed4cc19a ]

Add the required USB ID for running SMCWUSBT-G2 wireless adapter (SMC
"EZ Connect g").

This device uses ar5523 chipset and requires firmware to be loaded. Even
though pid of the device is 4507, this patch adds it as 4506 so that
AR5523_DEVICE_UG macro can set the AR5523_FLAG_PRE_FIRMWARE flag for pid
4507.

Signed-off-by: Mert Dirik <mertdirik@gmail.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ar5523/ar5523.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/ath/ar5523/ar5523.c b/drivers/net/wireless/ath/ar5523/ar5523.c
index ad4a1efc57c97..e1a1d27427cc9 100644
--- a/drivers/net/wireless/ath/ar5523/ar5523.c
+++ b/drivers/net/wireless/ath/ar5523/ar5523.c
@@ -1771,6 +1771,8 @@ static const struct usb_device_id ar5523_id_table[] = {
 	AR5523_DEVICE_UX(0x0846, 0x4300),	/* Netgear / WG111U */
 	AR5523_DEVICE_UG(0x0846, 0x4250),	/* Netgear / WG111T */
 	AR5523_DEVICE_UG(0x0846, 0x5f00),	/* Netgear / WPN111 */
+	AR5523_DEVICE_UG(0x083a, 0x4506),	/* SMC / EZ Connect
+						   SMCWUSBT-G2 */
 	AR5523_DEVICE_UG(0x157e, 0x3006),	/* Umedia / AR5523_1 */
 	AR5523_DEVICE_UX(0x157e, 0x3205),	/* Umedia / AR5523_2 */
 	AR5523_DEVICE_UG(0x157e, 0x3006),	/* Umedia / TEW444UBEU */
-- 
2.25.1



