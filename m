Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F9E23C306E
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 04:47:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234298AbhGJCff (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 22:35:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:53138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234845AbhGJCeT (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 22:34:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C4EF7613C9;
        Sat, 10 Jul 2021 02:31:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625884295;
        bh=KSb5fyDRzgf/RSbM09GKm1qwFWLZ1xYtmQj6I0EBBqc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PJAfAMMtRLK7tZ+beHYWH/fTIw5UyMUCYB5ZwGmUmsaJjnSm4HYIAf7AW8qjwr7RL
         qSLk+7nVWk0ZPqfVLihAXjQdmxyB6ivKgmvAC2nVi9ODWO5ZSJNLxPQdDXy01/Voz1
         w2lQwhNVOod44Db3gkgT3oHC2eakc8CFsA5Q3m/c43zQU9D8Wv0eYmY2qiJ4LZ/Lz1
         WsRnHcs91BYCzJB3nfE7sYBmofG7amZTY9jwdlvb++z4uhQY35/AI3wfbGcfFKxUpb
         i81vSzoB6OKQLFGI6jThQQVQsWMtLsW4bYGLSnY7qzYtgCEA7m2QLEYIoDD4dwU9iB
         2W4//FZgTMxBw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Peter Robinson <pbrobinson@gmail.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Sasha Levin <sashal@kernel.org>, linux-gpio@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 41/63] gpio: pca953x: Add support for the On Semi pca9655
Date:   Fri,  9 Jul 2021 22:26:47 -0400
Message-Id: <20210710022709.3170675-41-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710022709.3170675-1-sashal@kernel.org>
References: <20210710022709.3170675-1-sashal@kernel.org>
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
index 9a24dce3c262..d9193ffa17a1 100644
--- a/drivers/gpio/gpio-pca953x.c
+++ b/drivers/gpio/gpio-pca953x.c
@@ -1272,6 +1272,7 @@ static const struct of_device_id pca953x_dt_ids[] = {
 
 	{ .compatible = "onnn,cat9554", .data = OF_953X( 8, PCA_INT), },
 	{ .compatible = "onnn,pca9654", .data = OF_953X( 8, PCA_INT), },
+	{ .compatible = "onnn,pca9655", .data = OF_953X(16, PCA_INT), },
 
 	{ .compatible = "exar,xra1202", .data = OF_953X( 8, 0), },
 	{ }
-- 
2.30.2

