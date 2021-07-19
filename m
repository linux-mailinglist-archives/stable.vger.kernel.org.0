Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AE9E3CE4B8
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:35:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346748AbhGSPpz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:45:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:35796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347527AbhGSPle (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:41:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 00F9761241;
        Mon, 19 Jul 2021 16:21:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626711690;
        bh=9zY3xMgQT4AeEHLyvTQjoZoyHJvvalLEv9eMVRj/HMk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z/dvQQlu8FRCdqY2hMZiYlEW5DsPYUo8jw3fEZPJDMEq5unOIH9RUhPZWi72nAFzw
         ij4MCSgckx5W4rKp/w3NiIxUXYW8nVoXcL+TQVn+ss4HTjPGCdBEXvAOfPWNSFmGfZ
         q9t6z/bw+BXTGC9IqvbvmJ2k9gSe7MVZ5Qw6I6T8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Robinson <pbrobinson@gmail.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 097/292] gpio: pca953x: Add support for the On Semi pca9655
Date:   Mon, 19 Jul 2021 16:52:39 +0200
Message-Id: <20210719144945.689521591@linuxfoundation.org>
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



