Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBFB02E42FB
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:34:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407198AbgL1Nw6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:52:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:52752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406434AbgL1Nux (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:50:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 77D0E22BEF;
        Mon, 28 Dec 2020 13:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609163413;
        bh=TYGqGoHWcQkY9WzaNVv33lvZzYth66cp92ZyHGd365Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=laShKtCW2BIkHidSZUvsV0elFEd2+ECw6woi13SlJYbdsI/lAc/Xn23L9WpdCYPMx
         R31KMEAATXwMNAu4zzyyuN+vbwLK5SPrp0nIl3cQ7BE2oT69lqXjbxw8/8uQnFcDm+
         ihhDAAs5GnEikIOYGWH50FyTQPhSWaNtaQpB2gRo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 270/453] extcon: max77693: Fix modalias string
Date:   Mon, 28 Dec 2020 13:48:26 +0100
Message-Id: <20201228124950.222604836@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124937.240114599@linuxfoundation.org>
References: <20201228124937.240114599@linuxfoundation.org>
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
index 32fc5a66ffa98..26c7041f70698 100644
--- a/drivers/extcon/extcon-max77693.c
+++ b/drivers/extcon/extcon-max77693.c
@@ -1277,4 +1277,4 @@ module_platform_driver(max77693_muic_driver);
 MODULE_DESCRIPTION("Maxim MAX77693 Extcon driver");
 MODULE_AUTHOR("Chanwoo Choi <cw00.choi@samsung.com>");
 MODULE_LICENSE("GPL");
-MODULE_ALIAS("platform:extcon-max77693");
+MODULE_ALIAS("platform:max77693-muic");
-- 
2.27.0



