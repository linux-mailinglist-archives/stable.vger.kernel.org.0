Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F62010AB04
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 08:21:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726281AbfK0HVx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 02:21:53 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:37400 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726260AbfK0HVx (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Nov 2019 02:21:53 -0500
Received: by mail-wm1-f66.google.com with SMTP id f129so6162934wmf.2
        for <stable@vger.kernel.org>; Tue, 26 Nov 2019 23:21:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Yu9KDyxptDwqLuTA7xTY8BCLlGAehUEuHl2YkpDAZ2k=;
        b=fLu9uh0iUpaS33IDv+MTle941viXGSA0Nu4lAgbCfX8WtNyd3OWT5WhaTh74z2Kpow
         44oTX680QS8X5O1RsAWX0adi2rdUzM6JTLBYM9lWWx48kWyNXGcpKe49HBZSc9COM7+a
         cQeUj3h6YgcMKj4xKaglM3aduAM21l/gUGX/CXienLEiMVHa8fuoI99I5UGxJQvzpIhM
         fCbWDkdYnksU7cbAHWNheJr6W4ilbphOC2LzXwPqn0TMdfQOEUrNab9ygC/6bOS77SP8
         7YwJcT2nuJgNcVuc0ytXCis+qjxYRuHu4ZfcJYwFdYxTAXgPSZplv77TGfYreJLMd3Bv
         dneA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Yu9KDyxptDwqLuTA7xTY8BCLlGAehUEuHl2YkpDAZ2k=;
        b=e3pbXvc2gxuKz2Ucn8pGwsoTTp8sFAyYQ7QxPVOUtDZ9QJ+BPxt0gu6gNQRu/cbvD/
         XrUy6JZpmfjkjvahUqFfJWtEgOaHFB1bG8bph4KCvS77TXuYp+W96gbjYcRxBRacG0lC
         JGgzmp35d8IjwKtnd/K4y6texyD7bYRM4XOoW7u8HF5kS47QpxaT6pLZZsJ9B2ea6a5g
         VGsj+YPqIuTO7V/Ojsmn7gr135wk9qU84gCOV2VPgptmsh2tkkk9aVeNLpPFEVNutbWI
         2aw0vLglQxWV1rOANkLEnwYyxoHRM70l5r3J9g7azRZWXuLt0yhG5Ba/NnJvYYeaAE1V
         MRyQ==
X-Gm-Message-State: APjAAAV9YlPrgX6OiRjFudT6tyzYDkJKR58LUjE3ZxT1Z/2BHPAl0dIt
        Yct1Cdsr8OWVrPWd2Yog7u14Z7L+z28=
X-Google-Smtp-Source: APXvYqwnSt7Y6w07px+7ff/Q+e/iAKhcHKi/YtRq/f6i/scu+p4eAQJzfRfqjrH5tEfb//KVoK2jSw==
X-Received: by 2002:a1c:3d08:: with SMTP id k8mr2615871wma.119.1574839310071;
        Tue, 26 Nov 2019 23:21:50 -0800 (PST)
Received: from localhost.localdomain ([95.149.164.101])
        by smtp.gmail.com with ESMTPSA id y6sm18151872wrn.21.2019.11.26.23.21.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Nov 2019 23:21:49 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Subject: [PATCH 4.4 1/6] can: dev: can_dellink(): remove return at end of void function
Date:   Wed, 27 Nov 2019 07:21:19 +0000
Message-Id: <20191127072124.30445-1-lee.jones@linaro.org>
X-Mailer: git-send-email 2.24.0
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

