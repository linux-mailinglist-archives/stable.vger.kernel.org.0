Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E07510AB0B
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 08:22:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726320AbfK0HWI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 02:22:08 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:38003 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726373AbfK0HWI (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Nov 2019 02:22:08 -0500
Received: by mail-wr1-f68.google.com with SMTP id i12so25434327wro.5
        for <stable@vger.kernel.org>; Tue, 26 Nov 2019 23:22:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=Ul0WaU2BK0FC/8xcRvsdqtFzsbZwWd8yC4dUM4MnqUo=;
        b=Mcv0jv8BKLmOSKZyyRBh6DX1wscLdbqydAWtEU8rZlagKyMYSBZaZw6JdngDoIojma
         iN6tyMxNZYbqEzuF5UwmnYXclzTashowjGZOBMzwF3vcS4P9pL/CC/jzNK3mMMzJj1hY
         nqOorXf6bBBYZhnG0kenwKkM2PTOwcVhRNEiAUw2XkyTaxna0wTOPbxN944so0gQFICR
         +X/GYjAlMYNDMDOamy6bIKiUGxZSeg96+6a8wsUKnVEPs2x13d8qKYdvgCGcZAkz72wv
         yDUZ2WFYl6pB7CmpThyEGpqVVSdyQP8n8dV2WCfWfAU74DDzVhSjKuRJaDPdYKKJ8uko
         3cUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ul0WaU2BK0FC/8xcRvsdqtFzsbZwWd8yC4dUM4MnqUo=;
        b=YQpRjqK/aKmlKhqCNqzOGKOnXamAlFzqQG6UAeDLBMCsTezNBUm4I+QMV/kq5yEuw1
         siHXh8QL7vDTy8KNF8VsF/Z+Beko8AZm7X4k+xVeUc4I/MZb5NNP/WN//nnA2qYmG7/c
         uk0BUpNVN9Bsq3IHWO/6KjbbPtSP1C99Q6osVeJOdvIV3Ox0kRLe+0tSdMrJqAdzz+XR
         nK58tuLYVCQKRNIHSGzvKbxky+x3NpgT50bcPh5Jxhsm3/ZaSXvhBvWqCgZoHHlYDiNO
         ZVWwO0xR67T1deNU7g+oqTUBiplzZ4oBNhQ8e96Rsloju/XlpVAMdAGfFP93ACmMwnJy
         BmLA==
X-Gm-Message-State: APjAAAWUiCmZpi16qNWL+Q3Tezwy9I2W471aFKhn0hnGHTolKNXHGCOb
        n8eOKomqNlwwYjzm/rhQNRZKYhwgY+w=
X-Google-Smtp-Source: APXvYqwdKttvoz1SoIYXyIkasZUw7DNTnKThApQsOOGl/vTWMGno0X2dZVT6UkbXZbJ5UPTwsPvOvQ==
X-Received: by 2002:a5d:65c4:: with SMTP id e4mr43704430wrw.269.1574839324520;
        Tue, 26 Nov 2019 23:22:04 -0800 (PST)
Received: from localhost.localdomain ([95.149.164.101])
        by smtp.gmail.com with ESMTPSA id e16sm17983130wrj.80.2019.11.26.23.22.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Nov 2019 23:22:04 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Subject: [PATCH 4.9 2/6] can: dev: can_dellink(): remove return at end of void function
Date:   Wed, 27 Nov 2019 07:21:40 +0000
Message-Id: <20191127072144.30537-2-lee.jones@linaro.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127072144.30537-1-lee.jones@linaro.org>
References: <20191127072144.30537-1-lee.jones@linaro.org>
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

