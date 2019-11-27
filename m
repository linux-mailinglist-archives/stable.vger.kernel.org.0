Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2BEBF10AB17
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 08:22:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726526AbfK0HWh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 02:22:37 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:36380 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726514AbfK0HWh (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Nov 2019 02:22:37 -0500
Received: by mail-wr1-f68.google.com with SMTP id z3so25354672wru.3
        for <stable@vger.kernel.org>; Tue, 26 Nov 2019 23:22:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=VwBKkPsx+uAn3PLEG6SoAp/dys1syHkjUrLSI7HsUI8=;
        b=KRe3O4Q61K5kdzoe0dhCoyP8+/eLnCNn/Te7RNzrVTVlCrhTVXPq/h6FI62HJ8KzKC
         fTwHBDfuh/XIr5bJjayKTVD/O6cp0bTocq5OS87Gv3ofMILZ4WpwTsUKMVdSQrGy3F1J
         pILHQOc+0/+vAEkFZPFR1LiOM1veR9Aa/b86tb+lF1uY/UOr2+6zoBDJKilwqs3/3fF7
         RWKBeZE0yoF00+LUnuXjCsbG6P+GAUdjIRHpARkMOp1JdwpKTl9SFoqcxS/k8X0lNmie
         pTKjg2poRyjSobOe+6mPvUyuYkIKAcncsoqA4BONO9+ZPWtCtsMbJ+9yOJAzNbAy589C
         0iCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VwBKkPsx+uAn3PLEG6SoAp/dys1syHkjUrLSI7HsUI8=;
        b=pmrYa3EbPz+XDs5s/0QqPq4j8AQq8F7H6uk9aH2/tAK3P2ZJ/hhQB56IjhaQbPR5MK
         Ug0I618AFe5cgGcB4Nb127NbyPMme/MSdwV8JJFvUNCTtRU53VDtbSLrnpiYkxPeT9ZN
         D1LBIMQwRPTUwMvZybgxuaGbjUVN6nBA7i2CO2GMJ87q9jZwpBbybt0bY67rM0VkodiH
         EmJFDNrEzZUHJoVQgAqRbrYpW40rPdbnFDqESIztakBalPcSZN8wuKZpDmB6XvORfCb9
         EFtZ4WWdR5UYDXUNVUj6MXTHSApZf2qYOijNDmaaR+DWrxmp9guzgiq8d4jkS3mtnRFe
         pWqA==
X-Gm-Message-State: APjAAAVJCURogLDdJj+4+NXTwr6h7mE0eclDpP1M2kQOLfEclZfF5h0D
        6OYX0k9gac2uSx0DB6ixuvFaeorTa3Q=
X-Google-Smtp-Source: APXvYqxbz8s/HCKNfnp+bxQNcF9H8TUBtkyfWOhMlSClKrnaNB4VUfrvBkw420LLGYUzpi/mD0n/IQ==
X-Received: by 2002:a5d:460b:: with SMTP id t11mr42320051wrq.185.1574839354817;
        Tue, 26 Nov 2019 23:22:34 -0800 (PST)
Received: from localhost.localdomain ([95.149.164.101])
        by smtp.gmail.com with ESMTPSA id g21sm19605289wrb.48.2019.11.26.23.22.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Nov 2019 23:22:34 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Subject: [PATCH 5.3 2/2] can: dev: can_dellink(): remove return at end of void function
Date:   Wed, 27 Nov 2019 07:22:19 +0000
Message-Id: <20191127072219.30798-2-lee.jones@linaro.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127072219.30798-1-lee.jones@linaro.org>
References: <20191127072219.30798-1-lee.jones@linaro.org>
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
index 99fa712b48b3..8ada8e7326f9 100644
--- a/drivers/net/can/dev.c
+++ b/drivers/net/can/dev.c
@@ -1210,7 +1210,6 @@ static int can_newlink(struct net *src_net, struct net_device *dev,
 
 static void can_dellink(struct net_device *dev, struct list_head *head)
 {
-	return;
 }
 
 static struct rtnl_link_ops can_link_ops __read_mostly = {
-- 
2.24.0

