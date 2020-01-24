Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6401E147B05
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 10:40:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732375AbgAXJkP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 04:40:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:37576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732283AbgAXJkO (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 04:40:14 -0500
Received: from localhost (unknown [145.15.244.15])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2121A214AF;
        Fri, 24 Jan 2020 09:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579858813;
        bh=zyHrLvgJxUsFpD6lNVqDuE5w0wAKMj/sUOlqGS1CDgM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NyVXJs9YK6oSKnEm01d9WVIUsh/xXX7b8P45VPOjIvow23XEpzFg0qPzE6AiWN8L1
         ywd+K/LQ73iWflo44aaGETwo6xaQtjb2sV5WEiOgtzpYDBox5tAtRG2sYyf/6Dk1Ji
         7DNpHyZADLoNhvC02N0jtRmuCzgBUpqDCPK4iNps=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 063/102] regulator: bd70528: Add MODULE_ALIAS to allow module auto loading
Date:   Fri, 24 Jan 2020 10:31:04 +0100
Message-Id: <20200124092815.862841603@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124092806.004582306@linuxfoundation.org>
References: <20200124092806.004582306@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>

[ Upstream commit 55d5f62c3fa005a6a8010363d7d1855909ceefbc ]

The bd70528 regulator driver is probed by MFD driver. Add MODULE_ALIAS
in order to allow udev to load the module when MFD sub-device cell for
regulators is added.

Fixes: 99ea37bd1e7d7 ("regulator: bd70528: Support ROHM BD70528 regulator block")
Signed-off-by: Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>
Link: https://lore.kernel.org/r/20191023121452.GA1812@localhost.localdomain
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/bd70528-regulator.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/regulator/bd70528-regulator.c b/drivers/regulator/bd70528-regulator.c
index 6041839ec38ca..5bf8a2dc5fe77 100644
--- a/drivers/regulator/bd70528-regulator.c
+++ b/drivers/regulator/bd70528-regulator.c
@@ -285,3 +285,4 @@ module_platform_driver(bd70528_regulator);
 MODULE_AUTHOR("Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>");
 MODULE_DESCRIPTION("BD70528 voltage regulator driver");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:bd70528-pmic");
-- 
2.20.1



