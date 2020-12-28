Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 287582E66E9
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 17:19:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732539AbgL1NOl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:14:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:42530 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732536AbgL1NOk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:14:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E42E7206ED;
        Mon, 28 Dec 2020 13:14:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609161265;
        bh=tZLxZH4cyKufoUnY3XgpIsCpAIjqtnkauSsq28gBUXk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wnJ9IFYkIbwUdw0+GiJMSFvGo58Zl51sfX2+qrwu+2G9hst/B+/imkEMBKEBWfIU0
         /hVj6f/q3m/Qq5JrMVzJ5+fE631Wb7AYBVV/vChhUSZF5WXdfsRLNR48a0kTY2H575
         gptnG2mGeeS2MWxvfV8uesKl8+V/gY79ovsZYAKQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 157/242] extcon: max77693: Fix modalias string
Date:   Mon, 28 Dec 2020 13:49:22 +0100
Message-Id: <20201228124912.431361391@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124904.654293249@linuxfoundation.org>
References: <20201228124904.654293249@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Szyprowski <m.szyprowski@samsung.com>

[ Upstream commit e1efdb604f5c9903a5d92ef42244009d3c04880f ]

The platform device driver name is "max77693-muic", so advertise it
properly in the modalias string. This fixes automated module loading when
this driver is compiled as a module.

Fixes: db1b9037424b ("extcon: MAX77693: Add extcon-max77693 driver to support Maxim MAX77693 MUIC device")
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/extcon/extcon-max77693.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/extcon/extcon-max77693.c b/drivers/extcon/extcon-max77693.c
index 7a58568090474..8ea33946b4b25 100644
--- a/drivers/extcon/extcon-max77693.c
+++ b/drivers/extcon/extcon-max77693.c
@@ -1275,4 +1275,4 @@ module_platform_driver(max77693_muic_driver);
 MODULE_DESCRIPTION("Maxim MAX77693 Extcon driver");
 MODULE_AUTHOR("Chanwoo Choi <cw00.choi@samsung.com>");
 MODULE_LICENSE("GPL");
-MODULE_ALIAS("platform:extcon-max77693");
+MODULE_ALIAS("platform:max77693-muic");
-- 
2.27.0



