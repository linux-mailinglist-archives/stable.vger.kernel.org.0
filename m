Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D85953C475C
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:27:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237022AbhGLGc1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:32:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:52480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236353AbhGLGaE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:30:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A18BA6101E;
        Mon, 12 Jul 2021 06:27:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626071233;
        bh=RluHPmQu0Y6jEKZbePgmw2tEMh6QFWwcknq5SN/WRSY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Zpt+hKF90Fj+MWIKQud7XVEmaBEZW087eikgfMqjVNZ5Xyh8+Kd7JJK+LSG7hkJ16
         sXKp34VXYoVqbyMOwQShWA/VgXRqwKhext1RO4o4Ke98GVqirrFny8p6lTwMwadsU/
         DrhpU+5UFz2Cr9f/c9+2Wc94b/FDITRS0x86BlK0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 330/348] extcon: max8997: Add missing modalias string
Date:   Mon, 12 Jul 2021 08:11:54 +0200
Message-Id: <20210712060747.932380741@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060659.886176320@linuxfoundation.org>
References: <20210712060659.886176320@linuxfoundation.org>
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
index ac1633adb55d..cac36ef59e45 100644
--- a/drivers/extcon/extcon-max8997.c
+++ b/drivers/extcon/extcon-max8997.c
@@ -784,3 +784,4 @@ module_platform_driver(max8997_muic_driver);
 MODULE_DESCRIPTION("Maxim MAX8997 Extcon driver");
 MODULE_AUTHOR("Donggeun Kim <dg77.kim@samsung.com>");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:max8997-muic");
-- 
2.30.2



