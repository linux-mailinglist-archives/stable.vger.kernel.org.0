Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8649814BA6F
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:39:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728696AbgA1OiX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:38:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:42868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730557AbgA1OSp (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:18:45 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5C89D24690;
        Tue, 28 Jan 2020 14:18:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580221124;
        bh=Gy61lJNjfXtdKm2b3rJsnE7QTY9RZ0Pcx8tVpo4S7Yk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vGbVXg9ClrT1mcYIaSoZeTSHlArQKeBy+1JBKDcU8MJyDH+dzMK5zfkxfSitxuekl
         ak4ABDL/nheCwEGfhpKjqYqJVpIwYq1EIeIHmIhVAaS2BuKk04TMUhjlTw6HSn3wcI
         3lxz5a8+IVXUvikVJxGiSrynLhDIc6Kmi9fJ+6Ws=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Simon Horman <horms+renesas@verge.net.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 071/271] pinctrl: sh-pfc: sh73a0: Fix fsic_spdif pin groups
Date:   Tue, 28 Jan 2020 15:03:40 +0100
Message-Id: <20200128135857.872350252@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135852.449088278@linuxfoundation.org>
References: <20200128135852.449088278@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index f8fbedb46585d..6dca760f9f280 100644
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



