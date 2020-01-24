Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9ED1D14847C
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:44:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730287AbgAXLKV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:10:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:46052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731494AbgAXLKT (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:10:19 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C2B9720663;
        Fri, 24 Jan 2020 11:10:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579864219;
        bh=dEjCshnAMgQvTt6+U47YF3VdCKBBxdglUNTqHcrCngc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AoansvlGVY4D4C1fQKztHNH/p2JLc/IC57bYLJ0hF7ChbXV8f28pAlNusY3FbnUkH
         jMVXtZInacfbTJ+WowtQSt/n9fEGHTegfX0IcMFc22h13MLnZq+LzxTTTi1sLJEhot
         BFel8ALP3jZxt5nC/yD5447VZeIkQ8/g7EmI7BW0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Simon Horman <horms+renesas@verge.net.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 192/639] pinctrl: sh-pfc: r8a7792: Fix vin1_data18_b pin group
Date:   Fri, 24 Jan 2020 10:26:02 +0100
Message-Id: <20200124093111.140719781@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit b9fd50488b4939ce5b3a026d29e752e17c2d1800 ]

The vin1_data18_b pin group itself is present, but it is not listed in
the VIN1 pin group array, and thus cannot be selected.

Fixes: 7dd74bb1f058786e ("pinctrl: sh-pfc: r8a7792: Add VIN pin groups")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Simon Horman <horms+renesas@verge.net.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/sh-pfc/pfc-r8a7792.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pinctrl/sh-pfc/pfc-r8a7792.c b/drivers/pinctrl/sh-pfc/pfc-r8a7792.c
index cc3597f66605a..46c41ca6ea38b 100644
--- a/drivers/pinctrl/sh-pfc/pfc-r8a7792.c
+++ b/drivers/pinctrl/sh-pfc/pfc-r8a7792.c
@@ -1916,6 +1916,7 @@ static const char * const vin1_groups[] = {
 	"vin1_data8",
 	"vin1_data24_b",
 	"vin1_data20_b",
+	"vin1_data18_b",
 	"vin1_data16_b",
 	"vin1_sync",
 	"vin1_field",
-- 
2.20.1



