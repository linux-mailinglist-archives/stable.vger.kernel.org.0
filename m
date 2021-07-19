Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A3443CDB19
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:22:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244744AbhGSOkw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:40:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:56022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344029AbhGSOjy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:39:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C144D6112D;
        Mon, 19 Jul 2021 15:20:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626708025;
        bh=so5s9QIfoDE8+8ZjuiUwgMCqr1/3RjEGVOxsxfQ07JA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MTjqJcwO7v9SYfGY9khUPQXPc9VUeb4CaKX2FFySh/o7IUC3FJcpC8u5WglIVYCQ6
         bPgNlEPTqpAkpcdkSMr5PcL1l6SqNdgTmoxpof6xaCEFikbqCMZexjjmgSUMIxEqyL
         zKXyl+Y618+hd8llvvPnCOpqTfgRTESFMaQd6ICA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 152/315] extcon: max8997: Add missing modalias string
Date:   Mon, 19 Jul 2021 16:50:41 +0200
Message-Id: <20210719144947.889945418@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144942.861561397@linuxfoundation.org>
References: <20210719144942.861561397@linuxfoundation.org>
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
index b9b48d45a6dc..17d426829f5d 100644
--- a/drivers/extcon/extcon-max8997.c
+++ b/drivers/extcon/extcon-max8997.c
@@ -783,3 +783,4 @@ module_platform_driver(max8997_muic_driver);
 MODULE_DESCRIPTION("Maxim MAX8997 Extcon driver");
 MODULE_AUTHOR("Donggeun Kim <dg77.kim@samsung.com>");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:max8997-muic");
-- 
2.30.2



