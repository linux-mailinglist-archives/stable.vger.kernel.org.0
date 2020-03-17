Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 779F918818B
	for <lists+stable@lfdr.de>; Tue, 17 Mar 2020 12:20:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726490AbgCQLEp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 07:04:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:45152 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726760AbgCQLEo (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Mar 2020 07:04:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 54FDF20719;
        Tue, 17 Mar 2020 11:04:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584443083;
        bh=YeOkMtyWLIEoF9MWDXRDRMp7xN/CAzz3pEq7S4IaUVE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HP8wc9g5nRItd3oVufnpRc6YC8vh1I7Om6b5IivCTDozNGvN3Dj2woVHVF72zp6dG
         AXeNFGapbsUkiJJHKkV+xpZ6V6wKqdQJX1UVpxtdCF+YlTYNG2jl9zFAsHnkkrWOup
         LVClKV04y+FJqMnPVUvcFReAHLqi6O7/Mx2K5Z2w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mathias Kresin <dev@kresin.me>,
        Thomas Langer <thomas.langer@intel.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 5.4 073/123] pinctrl: falcon: fix syntax error
Date:   Tue, 17 Mar 2020 11:55:00 +0100
Message-Id: <20200317103314.963790552@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200317103307.343627747@linuxfoundation.org>
References: <20200317103307.343627747@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mathias Kresin <dev@kresin.me>

commit d62e7fbea4951c124a24176da0c7bf3003ec53d4 upstream.

Add the missing semicolon after of_node_put to get the file compiled.

Fixes: f17d2f54d36d ("pinctrl: falcon: Add of_node_put() before return")
Cc: stable@vger.kernel.org # v5.4+
Signed-off-by: Mathias Kresin <dev@kresin.me>
Link: https://lore.kernel.org/r/20200305182245.9636-1-dev@kresin.me
Acked-by: Thomas Langer <thomas.langer@intel.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pinctrl/pinctrl-falcon.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/pinctrl/pinctrl-falcon.c
+++ b/drivers/pinctrl/pinctrl-falcon.c
@@ -451,7 +451,7 @@ static int pinctrl_falcon_probe(struct p
 		falcon_info.clk[*bank] = clk_get(&ppdev->dev, NULL);
 		if (IS_ERR(falcon_info.clk[*bank])) {
 			dev_err(&ppdev->dev, "failed to get clock\n");
-			of_node_put(np)
+			of_node_put(np);
 			return PTR_ERR(falcon_info.clk[*bank]);
 		}
 		falcon_info.membase[*bank] = devm_ioremap_resource(&pdev->dev,


