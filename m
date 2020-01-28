Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B134314BB61
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:46:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726646AbgA1OIy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:08:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:57082 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728583AbgA1OIw (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:08:52 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7850F2468D;
        Tue, 28 Jan 2020 14:08:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580220531;
        bh=WjEpRz12C9cCpyFWPKhpFphlyEXN/4W5dysrJJDEsqE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1RPCrqgX2pkWbZo+0LSzcPrbPp2SXQLTHJ13f9z+ME/EQFIroaYpyQhHzp3g+D7tU
         436pW47+EqQEcn1IS+Oj38unIPURl7/3zUCb3wPhO8Es4i5KuQ0NCyxoJqD34QSVAM
         8Pgl+YBslw21bEVO1GiZKJC4zFUMw0IJZudbXBqc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Simon Horman <horms+renesas@verge.net.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 045/183] pinctrl: sh-pfc: r8a7791: Fix scifb2_data_c pin group
Date:   Tue, 28 Jan 2020 15:04:24 +0100
Message-Id: <20200128135834.467899123@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135829.486060649@linuxfoundation.org>
References: <20200128135829.486060649@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit a4b0350047f1b10207e25e72d7cd3f7826e93769 ]

The entry for "scifb2_data_c" in the SCIFB2 pin group array contains a
typo, thus the group cannot be selected.

Fixes: 5088451962389924 ("pinctrl: sh-pfc: r8a7791 PFC support")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Simon Horman <horms+renesas@verge.net.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/sh-pfc/pfc-r8a7791.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/sh-pfc/pfc-r8a7791.c b/drivers/pinctrl/sh-pfc/pfc-r8a7791.c
index f94e34e7f0b01..b2f8898ddb2c8 100644
--- a/drivers/pinctrl/sh-pfc/pfc-r8a7791.c
+++ b/drivers/pinctrl/sh-pfc/pfc-r8a7791.c
@@ -4967,7 +4967,7 @@ static const char * const scifb2_groups[] = {
 	"scifb2_data_b",
 	"scifb2_clk_b",
 	"scifb2_ctrl_b",
-	"scifb0_data_c",
+	"scifb2_data_c",
 	"scifb2_clk_c",
 	"scifb2_data_d",
 };
-- 
2.20.1



