Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 603B227CD8C
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 14:45:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733086AbgI2Mo5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 08:44:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:47412 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728700AbgI2LIY (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:08:24 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AEE62221F0;
        Tue, 29 Sep 2020 11:08:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601377694;
        bh=KuIx02ZLQcHtYc60sO8az7nsmu847tanrJ4N/NEnmhk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T9J15szYM3SmYBEpX3suLjno9Ma2dm0IQt3fuE5xmk6OadozOEAfcQDxU0NrypMC5
         UcAvlkJWIKjjrwOeGgeikBiFwBypNb0sehUsW6s31UOOFNLdBcaz5EI29gGDorXgLQ
         4mDqAhkEJHTpQ8KOLR6Vm6YkPLH3XfopDtsYtBsQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mert Dirik <mertdirik@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 038/121] ar5523: Add USB ID of SMCWUSBT-G2 wireless adapter
Date:   Tue, 29 Sep 2020 12:59:42 +0200
Message-Id: <20200929105932.074216967@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105930.172747117@linuxfoundation.org>
References: <20200929105930.172747117@linuxfoundation.org>
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
index e492c7f0d311a..9f4ee1d125b68 100644
--- a/drivers/net/wireless/ath/ar5523/ar5523.c
+++ b/drivers/net/wireless/ath/ar5523/ar5523.c
@@ -1769,6 +1769,8 @@ static struct usb_device_id ar5523_id_table[] = {
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



