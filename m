Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AF2B3C5599
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:55:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231891AbhGLILL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 04:11:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:55668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353798AbhGLIDA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 04:03:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4A3E861D08;
        Mon, 12 Jul 2021 07:57:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626076656;
        bh=7s6jwE2R2Sqduc8Q6/MC9g6PoEYP6QAsTKTDzzRvWas=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vxAupky08j2q/AOGx2xzdMWyoRxtiRwve2RwQuHp9SAQT8/YqfwWAOtfVYV9QEfR9
         74zPhbbpef8v9yxQlGimsqgwyVpoZMgU38vGrNLx+uk7roI+9YIIR5ZlK0kDH7NJxw
         THr0pOZCpIWV7744xxHFc4xM5QEFk36eagzLphWw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 736/800] extcon: max8997: Add missing modalias string
Date:   Mon, 12 Jul 2021 08:12:39 +0200
Message-Id: <20210712061045.071715656@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Szyprowski <m.szyprowski@samsung.com>

[ Upstream commit dc11fc2991e9efbceef93912b83e333d2835fb19 ]

The platform device driver name is "max8997-muic", so advertise it
properly in the modalias string. This fixes automated module loading when
this driver is compiled as a module.

Fixes: b76668ba8a77 ("Extcon: add MAX8997 extcon driver")
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/extcon/extcon-max8997.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/extcon/extcon-max8997.c b/drivers/extcon/extcon-max8997.c
index c15a612067af..5c3cdb725514 100644
--- a/drivers/extcon/extcon-max8997.c
+++ b/drivers/extcon/extcon-max8997.c
@@ -788,3 +788,4 @@ module_platform_driver(max8997_muic_driver);
 MODULE_DESCRIPTION("Maxim MAX8997 Extcon driver");
 MODULE_AUTHOR("Donggeun Kim <dg77.kim@samsung.com>");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:max8997-muic");
-- 
2.30.2



