Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB278106C60
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 11:51:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730094AbfKVKvj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 05:51:39 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:40483 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730090AbfKVKvi (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 Nov 2019 05:51:38 -0500
Received: by mail-wr1-f65.google.com with SMTP id 4so4727750wro.7
        for <stable@vger.kernel.org>; Fri, 22 Nov 2019 02:51:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=Yu9KDyxptDwqLuTA7xTY8BCLlGAehUEuHl2YkpDAZ2k=;
        b=An5nyaCmsN9LwBfK8eEqIspPgSCpP3ohEiPD6soKUiKPOBmAHxNQ9H6EhnAGlcejny
         ofUkeAVk6jcom/azjeO5xz/WxymV0FwLcQ8XfBZssXrL4XprsIjeqlqvQ7ckOOBpSkS+
         t8IMhzGmYBLxH53RTHGPbCfkFxxa3u2eskJlJ5m4B+IdLB5sD8D/YrkdW1bjW256n39x
         X/S5ecqVFBRpe6yPPQ23Lfk24+w5sV1JS4L379yQPLhOzz8JT1t6sZMA84xEbGIg2D3L
         OLdQ12hlxGVu2WvABBPPeVBHXFiHe4bFT+LL5DqDqFTgvDz+6wZsOBaYWSVj/AbeChYx
         ReBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Yu9KDyxptDwqLuTA7xTY8BCLlGAehUEuHl2YkpDAZ2k=;
        b=D9QwuLwIF30rrihdBQ5Hqr7XjoX0+OniaKk9zhowhkR/zyWYzjqcno3+d/aK876KnK
         1hKxI5jbly1RMwK7bi/gJJrH+yBHLJkex89P/VWfVb5uzUFAWxsdJDyCoW2IUdhIzRqw
         pFFyNNESv5EQMcr1emdiiVUpjcix2+dZcLxd8tbJ/yE/Rm52vMJ7HbdrhmKhlCqa1/m8
         QQTep8xmVY+6/jn1SYMxA4fqiBLtn2ZyKxOpZMcmPLBswgevDVcVzvT5pXfemQG9JQai
         pkFbAuajjYbTK+nIK9kya8EhfjmfBvPhD2cRLzMVGsaJCaR2h9wT19Y/Uku5mfLBlbjn
         WtoQ==
X-Gm-Message-State: APjAAAWaWOgUnBoup129WZ6QNIFdhiSTCLNF5ZxAGX+NwGG9wR3WrCjc
        6MDkTyctVnhn7o3cl1IZGh/Kjwty/aY=
X-Google-Smtp-Source: APXvYqzskB7w/ZUEwGXza8F8mhF1rEifxn2VeJUvj6rUvyYTEM2ozXD5D4SL9BTtX4Rrz2KGExXAqg==
X-Received: by 2002:adf:a551:: with SMTP id j17mr15993927wrb.18.1574419896440;
        Fri, 22 Nov 2019 02:51:36 -0800 (PST)
Received: from localhost.localdomain ([2.27.35.135])
        by smtp.gmail.com with ESMTPSA id w4sm2894338wmk.29.2019.11.22.02.51.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Nov 2019 02:51:36 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org, gregkh@google.com, stable@vger.kernel.org
Subject: [PATCH 4.4 2/9] can: dev: can_dellink(): remove return at end of void function
Date:   Fri, 22 Nov 2019 10:51:06 +0000
Message-Id: <20191122105113.11213-2-lee.jones@linaro.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122105113.11213-1-lee.jones@linaro.org>
References: <20191122105113.11213-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Kleine-Budde <mkl@pengutronix.de>

[ Upstream commit d36673f5918c8fd3533f7c0d4bac041baf39c7bb ]

This patch remove the return at the end of the void function
can_dellink().

Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/net/can/dev.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/can/dev.c b/drivers/net/can/dev.c
index 9dd968ee792e..e0d067701edc 100644
--- a/drivers/net/can/dev.c
+++ b/drivers/net/can/dev.c
@@ -1041,7 +1041,6 @@ static int can_newlink(struct net *src_net, struct net_device *dev,
 
 static void can_dellink(struct net_device *dev, struct list_head *head)
 {
-	return;
 }
 
 static struct rtnl_link_ops can_link_ops __read_mostly = {
-- 
2.24.0

