Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8369713F6E1
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 20:08:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387977AbgAPRBI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 12:01:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:51782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388005AbgAPRBH (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:01:07 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0B3BD20730;
        Thu, 16 Jan 2020 17:01:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194066;
        bh=Z/6Je7W6tQDJpYaxxR+scce6bDJ+iS9rauUEIqMWV8w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bECPDVjFJVAvfEd2NXV5FNxW/DDw07T70MN0ZEpXED+pDrtB2a8pgx3X0h1X/5z+F
         SLLX9zRLPihoRr2OnKpRKN6/lM61V5OCMRz7Zjq/LJWZE8YGl5p/zfAnJWniICmTcf
         UL0Q7XtROrWX3MT03i5Gsto0o3hQU7amEr54AE8A=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Simon Horman <horms+renesas@verge.net.au>,
        Sasha Levin <sashal@kernel.org>,
        linux-renesas-soc@vger.kernel.org, linux-gpio@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 177/671] pinctrl: sh-pfc: sh73a0: Fix fsic_spdif pin groups
Date:   Thu, 16 Jan 2020 11:51:26 -0500
Message-Id: <20200116165940.10720-60-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116165940.10720-1-sashal@kernel.org>
References: <20200116165940.10720-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit 0e6e448bdcf896d001a289a6112a704542d51516 ]

There are two pin groups for the FSIC SPDIF signal, but the FSIC pin
group array lists only one, and it refers to a nonexistent group.

Fixes: 2ecd4154c906b7d6 ("sh-pfc: sh73a0: Add FSI pin groups and functions")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Simon Horman <horms+renesas@verge.net.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/sh-pfc/pfc-sh73a0.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/pinctrl/sh-pfc/pfc-sh73a0.c b/drivers/pinctrl/sh-pfc/pfc-sh73a0.c
index f8fbedb46585..6dca760f9f28 100644
--- a/drivers/pinctrl/sh-pfc/pfc-sh73a0.c
+++ b/drivers/pinctrl/sh-pfc/pfc-sh73a0.c
@@ -3367,7 +3367,8 @@ static const char * const fsic_groups[] = {
 	"fsic_sclk_out",
 	"fsic_data_in",
 	"fsic_data_out",
-	"fsic_spdif",
+	"fsic_spdif_0",
+	"fsic_spdif_1",
 };
 
 static const char * const fsid_groups[] = {
-- 
2.20.1

