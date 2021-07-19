Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBAA33CE52C
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:40:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347173AbhGSPsA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:48:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:45594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348485AbhGSPn7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:43:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 136CD61415;
        Mon, 19 Jul 2021 16:22:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626711766;
        bh=jMFI/X6JpYIAKQaFGTECmFNli5C5t3TD6BOf/RpICe0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CQs2bB80F1TBCJBoi0NbK2Cni4/4CNUDAVDhDTG4DVwrm1rKsCj0Cq1kzPmO/4RCc
         Ume7977i7/QFOsO3Smr+DrS2Kqg6gwkVgNEjQvXHeRIZiWEkj8fPReBjQZd6NpTM7c
         Bmr3a9FqzYPkPGRuS0xmyM1FEScYyUIqrkfoxO08=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Zou Wei <zou_wei@huawei.com>, Pavel Machek <pavel@ucw.cz>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 125/292] leds: turris-omnia: add missing MODULE_DEVICE_TABLE
Date:   Mon, 19 Jul 2021 16:53:07 +0200
Message-Id: <20210719144946.593228708@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144942.514164272@linuxfoundation.org>
References: <20210719144942.514164272@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zou Wei <zou_wei@huawei.com>

[ Upstream commit 9d0150db97583cfbb6b44cbe02241a1a48f90210 ]

This patch adds missing MODULE_DEVICE_TABLE definition which generates
correct modalias for automatic loading of this driver when it is built
as an external module.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zou Wei <zou_wei@huawei.com>
Signed-off-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/leds/leds-turris-omnia.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/leds/leds-turris-omnia.c b/drivers/leds/leds-turris-omnia.c
index 2f9a289ab245..1adfed1c0619 100644
--- a/drivers/leds/leds-turris-omnia.c
+++ b/drivers/leds/leds-turris-omnia.c
@@ -274,6 +274,7 @@ static const struct i2c_device_id omnia_id[] = {
 	{ "omnia", 0 },
 	{ }
 };
+MODULE_DEVICE_TABLE(i2c, omnia_id);
 
 static struct i2c_driver omnia_leds_driver = {
 	.probe		= omnia_leds_probe,
-- 
2.30.2



