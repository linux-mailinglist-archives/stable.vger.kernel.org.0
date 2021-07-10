Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB2983C3136
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 04:48:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232530AbhGJCk4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 22:40:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:56638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234133AbhGJChm (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 22:37:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D9745613C5;
        Sat, 10 Jul 2021 02:34:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625884497;
        bh=4TsRwoe2ro7D8QzGFv+I3O7ZQ9kjnMVzdT1a+YTSFPg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dc82UtGolpQ3dxeUe4JpvAwUPkyHG3M2nkDziusTS6KR7TDInaF36kDL4UQLeU1LH
         yuuL/yZTwaHmteuu8PGN3nVYxq+2EiIHBpW7eTmSwq2wSkU4UVMv9rR2Jt2kyYPBGS
         YiQsGaZa8sZ9Wz0tMDsKA7NAS3nsLfLShhT9LBGPCZ/j17YSC4GTUrWyexsbgnATCX
         fYPjUyKThI0UJrGzFxS8ZmYVjcG+SIch2YFv4KpAfCzb5+65aLqVeYeUeHFvpA1CMk
         q+mkbPq4VKi6YZZzFBE8yIdDBgKKIdg8Q8lK8e+WHpVmcPzG7fDDztSZqWgrnoLCBp
         AGUwrMuMRWz7Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Peter Robinson <pbrobinson@gmail.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Sasha Levin <sashal@kernel.org>, linux-gpio@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 26/39] gpio: pca953x: Add support for the On Semi pca9655
Date:   Fri,  9 Jul 2021 22:31:51 -0400
Message-Id: <20210710023204.3171428-26-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710023204.3171428-1-sashal@kernel.org>
References: <20210710023204.3171428-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Robinson <pbrobinson@gmail.com>

[ Upstream commit 6d49b3a0f351925b5ea5047166c112b7590b918a ]

The On Semi pca9655 is a 16 bit variant of the On Semi pca9654 GPIO
expander, with 16 GPIOs and interrupt functionality.

Signed-off-by: Peter Robinson <pbrobinson@gmail.com>
[Bartosz: fixed indentation as noted by Andy]
Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-pca953x.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpio/gpio-pca953x.c b/drivers/gpio/gpio-pca953x.c
index 0232c25a1586..dc4088a47ab2 100644
--- a/drivers/gpio/gpio-pca953x.c
+++ b/drivers/gpio/gpio-pca953x.c
@@ -980,6 +980,7 @@ static const struct of_device_id pca953x_dt_ids[] = {
 	{ .compatible = "ti,tca6424", .data = OF_953X(24, PCA_INT), },
 
 	{ .compatible = "onnn,pca9654", .data = OF_953X( 8, PCA_INT), },
+	{ .compatible = "onnn,pca9655", .data = OF_953X(16, PCA_INT), },
 
 	{ .compatible = "exar,xra1202", .data = OF_953X( 8, 0), },
 	{ }
-- 
2.30.2

