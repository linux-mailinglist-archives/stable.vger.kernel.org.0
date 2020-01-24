Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA873147B08
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 10:40:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730743AbgAXJkW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 04:40:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:37714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731041AbgAXJkV (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 04:40:21 -0500
Received: from localhost (unknown [145.15.244.15])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3D9742087E;
        Fri, 24 Jan 2020 09:40:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579858820;
        bh=TWoRDpwZvRipbJUFqnEf8OEHQIHpv21Q8sPzcDoVIz8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DG1ZPmpx3UAKx/fLDtfGFkhDCaQh01AnZG48VXNRA3VQPibGZ4E7tfnnlRFY14dRT
         VQCW+kz8tyOZQgSMzBB00DTN4zOuSsUyOboNxCRLdrnqCqi5NPWV6b0br7LKa3oRrF
         Fir2OVU5bjyOpuhxXwZYTQUEpEVU8S0FVIuokyCM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 065/102] power: supply: bd70528: Add MODULE_ALIAS to allow module auto loading
Date:   Fri, 24 Jan 2020 10:31:06 +0100
Message-Id: <20200124092816.197109313@linuxfoundation.org>
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

[ Upstream commit 9480029fe5c24d482efad38dc631bd555fc7afe2 ]

The bd70528 charger driver is probed by MFD driver. Add MODULE_ALIAS
in order to allow udev to load the module when MFD sub-device cell for
charger is added.

Fixes: f8c7f7ddd8ef0 ("power: supply: Initial support for ROHM BD70528 PMIC charger block")
Signed-off-by: Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/bd70528-charger.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/power/supply/bd70528-charger.c b/drivers/power/supply/bd70528-charger.c
index 1bb32b7226d74..b8e1ec106627f 100644
--- a/drivers/power/supply/bd70528-charger.c
+++ b/drivers/power/supply/bd70528-charger.c
@@ -741,3 +741,4 @@ module_platform_driver(bd70528_power);
 MODULE_AUTHOR("Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>");
 MODULE_DESCRIPTION("BD70528 power-supply driver");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:bd70528-power");
-- 
2.20.1



