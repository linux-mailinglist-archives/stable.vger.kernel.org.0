Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D353F3C2E5E
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 04:27:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233677AbhGJC04 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 22:26:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:42484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233527AbhGJC02 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 22:26:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D33D6613DC;
        Sat, 10 Jul 2021 02:23:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625883820;
        bh=9zY3xMgQT4AeEHLyvTQjoZoyHJvvalLEv9eMVRj/HMk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oqQKoGjyAMhWm8ep3NJEDlHBRh4/Nsb1mg++EpIiIyf1GzamUe5cG5vuI6nkPEC8+
         K/ZwRAbormKnWXk65PfduSghYTA8JmbK+/jnKyiFthXoZ3sjfK6aVnr0PWVpC8bvRg
         OcZ723UuDQRcvl0mOElXYnum4/td58DqAgnYRRPf8Qf0HZKOyHgoQlI3u80lSZ4M9U
         oSeEyxI54vWjVkVpkpIKMGcm0Z2zdxHJhUKJtYxkORahXfpkaV3b51wo3C58MkYvzW
         XO362AMxP9ua1to2Yc8Xb8IuFgTy7QnQkoPN2U3zWL8BbZs381X5+38XL2lKkkWxeC
         Sn2p5RXAqbZdA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Peter Robinson <pbrobinson@gmail.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Sasha Levin <sashal@kernel.org>, linux-gpio@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 069/104] gpio: pca953x: Add support for the On Semi pca9655
Date:   Fri,  9 Jul 2021 22:21:21 -0400
Message-Id: <20210710022156.3168825-69-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710022156.3168825-1-sashal@kernel.org>
References: <20210710022156.3168825-1-sashal@kernel.org>
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
index c91d05651596..f5cfc0698799 100644
--- a/drivers/gpio/gpio-pca953x.c
+++ b/drivers/gpio/gpio-pca953x.c
@@ -1241,6 +1241,7 @@ static const struct of_device_id pca953x_dt_ids[] = {
 
 	{ .compatible = "onnn,cat9554", .data = OF_953X( 8, PCA_INT), },
 	{ .compatible = "onnn,pca9654", .data = OF_953X( 8, PCA_INT), },
+	{ .compatible = "onnn,pca9655", .data = OF_953X(16, PCA_INT), },
 
 	{ .compatible = "exar,xra1202", .data = OF_953X( 8, 0), },
 	{ }
-- 
2.30.2

