Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E83D106F27
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 12:14:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727933AbfKVLN4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 06:13:56 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:39927 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728688AbfKVKyf (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 Nov 2019 05:54:35 -0500
Received: by mail-wr1-f65.google.com with SMTP id y11so4952703wrt.6
        for <stable@vger.kernel.org>; Fri, 22 Nov 2019 02:54:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=VwBKkPsx+uAn3PLEG6SoAp/dys1syHkjUrLSI7HsUI8=;
        b=HwUI9fFJNxtsdpCg4xWYfU+iP6+/7PY7fRxLe9CFgOAZH3ipTuPM/YizuXCsWyBZbI
         IA418LsnFx1W+AbVLqumG7RgwXrYbQ+W8ZjN0ixmrYLHfoGAsXBF785tnFgaQDy92cpw
         cbhi/Ppm+FQTL/vGswBETufWftjRQqA8DNh2jGevORLSsC6f9RICdw/ui3FJ0HYN/EvX
         Zf+JlWy3kltJAOWj96DsfW9qLDKUF7misDpqFoyE0If6mMuJG4y6gY6gxGKAvJQiVOLl
         Zn4sScjafXQ+gB94B4DvG06kofpo8hWDFPoZiRi0yzz7pRcppi9eq/iv2plU1oHu9YLT
         3iRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VwBKkPsx+uAn3PLEG6SoAp/dys1syHkjUrLSI7HsUI8=;
        b=beBSgAFjQ6q5/c1g8ZuR0PuaBdCCCe778/0hyfp4XJwUhilHglDlqiURCAz4wcQBJW
         5NmmoOL9yG1ZrJuAOzHm5HdcRunVjE6BZBks7G4/AXg6YUsoZSXVGtBj6L3GQqU2tKkl
         pHUaxqLKqZhMlFhHRyChEgexbf20a6jvgXMT8am8IoAgY81JAt9vAeYFPLP1hmrWUaNf
         W9zXPec+BUA6V3+j+77ycicvUdi4UDMZBUqIdOvq8juTMJP5zl0zkRinrlDbf8mlC6lN
         Vif1XOtIol8rou3tyFe2tpIlBNFbAv1MDGzpKVMVLip6jFLS0VhwtKpHH9sN0/vvdJbK
         z+sw==
X-Gm-Message-State: APjAAAUEn3VYWvIvzvL7rOHzejweFQsB/7J793WBEVuoYQu3erlu9v7j
        0DCwcMbkwyxgOese00/ldunS+LLSmEY=
X-Google-Smtp-Source: APXvYqx+T2PA0558XdCsocg7zfPctzdNNfMxTQdjwQhec4VvLB07gj/hBC3n4k2WVcv9Lw+4/vycmg==
X-Received: by 2002:adf:f987:: with SMTP id f7mr17030957wrr.284.1574420073541;
        Fri, 22 Nov 2019 02:54:33 -0800 (PST)
Received: from localhost.localdomain ([2.27.35.135])
        by smtp.gmail.com with ESMTPSA id p14sm7498912wrq.72.2019.11.22.02.54.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Nov 2019 02:54:33 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org, gregkh@google.com, stable@vger.kernel.org
Subject: [PATCH 5.3 2/2] can: dev: can_dellink(): remove return at end of void function
Date:   Fri, 22 Nov 2019 10:54:17 +0000
Message-Id: <20191122105417.11503-2-lee.jones@linaro.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122105417.11503-1-lee.jones@linaro.org>
References: <20191122105417.11503-1-lee.jones@linaro.org>
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

