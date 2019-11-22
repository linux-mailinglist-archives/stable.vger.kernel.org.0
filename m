Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66E5A106C9D
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 11:55:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729586AbfKVKx0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 05:53:26 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:32789 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730199AbfKVKxZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 Nov 2019 05:53:25 -0500
Received: by mail-wr1-f66.google.com with SMTP id w9so8110495wrr.0
        for <stable@vger.kernel.org>; Fri, 22 Nov 2019 02:53:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=Ul0WaU2BK0FC/8xcRvsdqtFzsbZwWd8yC4dUM4MnqUo=;
        b=NxKGbMgLVY7JIz0WHXsGToHLPqRSiYf69i1BBk68y2HSWqdwEOntuXqiuq4NSLutJs
         Rm7jEAAAOXNQzNBhab4roJ68ZEb3PCayuRycIQF30YBgSrNO/EevE1kAGOJ+RWD42EkK
         gfSRIJmGgxgzObWn4eM6yjnPgF2t3aFI3+ylF6GDjt+zmbAEHDvIB3YBdUwNkDrMukZK
         jJXYUG96FkegwJ/cDi/tn4/0yOCdm1Wy7mV1x8GnVoEJvlBy0VcDOKzuDNtywApjFx7a
         hiD8QcZnUxQCSPIEWlRrI9fbbYhANbbeJvx6i9onjWvSiZXn88fgKgQFX763P+kTEnJP
         artA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ul0WaU2BK0FC/8xcRvsdqtFzsbZwWd8yC4dUM4MnqUo=;
        b=sSNgUn3hTHgc09YfTQIgZaEIsYi84AyGQRjeKBaKlnKBsFnG9/L6vmaDG3AgkBCAW+
         9myeewFMvrlGPb+zfdj2Napws1Uz2rb6m9ek00bdnzDtbQT1EBcBJPFFEWjw+O0yyVH3
         lbUBXFSjlQipdwJzAmmSt5O+/tdEJkqdJCa7zw8SDHpCr24/44kR6dEMd2+UKEKI2pWd
         +vqf7K2DpqTzb7kL93iv0tuBxEGWqXiL83pJotcb2DGfK6LKkq5sLPfENBtwduUoASd7
         4M/66Nzr/vSILB3QzMQ76iFOoZRc3sDcsH+Nfje+feQV9y9jduXCq0LVX2U+5rX2iB9A
         EI0Q==
X-Gm-Message-State: APjAAAUfVIvYInXx30maDD3QvlgOEH12cMAMQzF2vUKsOpwQvxVNsFF1
        sNkwguE5xbHQ9HS1/GSRxHj6CA==
X-Google-Smtp-Source: APXvYqxOrnlcXjjDd3C15hLKzM8IRMEuy5tvLJuaS5X6CrLKp/JNR4VzeImnLLiLk8k92MdP6IqtTw==
X-Received: by 2002:a5d:6542:: with SMTP id z2mr17582539wrv.371.1574420003607;
        Fri, 22 Nov 2019 02:53:23 -0800 (PST)
Received: from localhost.localdomain ([2.27.35.135])
        by smtp.gmail.com with ESMTPSA id o1sm7444087wrs.50.2019.11.22.02.53.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Nov 2019 02:53:23 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org, gregkh@google.com, stable@vger.kernel.org
Subject: [PATCH 4.9 2/8] can: dev: can_dellink(): remove return at end of void function
Date:   Fri, 22 Nov 2019 10:52:47 +0000
Message-Id: <20191122105253.11375-2-lee.jones@linaro.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122105253.11375-1-lee.jones@linaro.org>
References: <20191122105253.11375-1-lee.jones@linaro.org>
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
index ffc5467a1ec2..1b3d7ec3462c 100644
--- a/drivers/net/can/dev.c
+++ b/drivers/net/can/dev.c
@@ -1071,7 +1071,6 @@ static int can_newlink(struct net *src_net, struct net_device *dev,
 
 static void can_dellink(struct net_device *dev, struct list_head *head)
 {
-	return;
 }
 
 static struct rtnl_link_ops can_link_ops __read_mostly = {
-- 
2.24.0

