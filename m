Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1369A3CE1F1
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:13:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347026AbhGSP2b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:28:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:43082 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239968AbhGSPZ4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:25:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 401D9600EF;
        Mon, 19 Jul 2021 16:06:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626710795;
        bh=9zY3xMgQT4AeEHLyvTQjoZoyHJvvalLEv9eMVRj/HMk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kuFfJVCEM23RDj82tFLSPLL5h1bI+ZwTt6MvWxwEtrjG21I7Tt6fuZlwZQ3W+zm4R
         bhfY0bfswnuSnpKDiQxkkbNH8fKnDy1j3nu5L86Q/JmSQFCd1R0dwKjrxMDC95mKly
         ve1zyjfvNVULSJu3g4+WV3LrIUZn9ChGVAzjyJDU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Robinson <pbrobinson@gmail.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 111/351] gpio: pca953x: Add support for the On Semi pca9655
Date:   Mon, 19 Jul 2021 16:50:57 +0200
Message-Id: <20210719144948.159945657@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144944.537151528@linuxfoundation.org>
References: <20210719144944.537151528@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



