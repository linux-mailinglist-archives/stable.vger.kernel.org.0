Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EBEF1B6599
	for <lists+stable@lfdr.de>; Thu, 23 Apr 2020 22:40:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726637AbgDWUkY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 16:40:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726183AbgDWUkY (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Apr 2020 16:40:24 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CCCEC09B042
        for <stable@vger.kernel.org>; Thu, 23 Apr 2020 13:40:23 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id b11so8233110wrs.6
        for <stable@vger.kernel.org>; Thu, 23 Apr 2020 13:40:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/hkstutUKkzAeVkb8A6CMmZCBPtBnLhhXsPrhwYxTuA=;
        b=RP13O6RyAg51iKwhAiHK9NBWC6OAiagMGTL0dHdzMSZMasf6D8uKatMb1p3TgTw5+9
         hu69D6G8GS8aO4zoNg2jrOANVAaINkxPwzpufAXwKUxit77hykhSqMtB6snpfm0F81hd
         UmmzrCJuZ0S7w3lC9XM4vWvWUpwWLSA4qBmdUUKFuNAF6md66FZSn4lelg0Z+RvTGyQv
         JXuLDV+W4OYYzs72yt0EgGSZkbB1dxu8smW0BEWcfF7XhEThos8mE1JHJc/pkLyLLyR8
         j1orLJzNept+xjBQNR5GMY+RHpSoUoinF/HDHfP9BCQLthN6tH1g9vnprCdmPP+LcYJi
         9hwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/hkstutUKkzAeVkb8A6CMmZCBPtBnLhhXsPrhwYxTuA=;
        b=bA5zEL0VplLm06SPcQ4mAqdV3GiFx1+Bw8y0+dJI0nIDzRg1Fh4sOjmBCMwLYhoEBG
         xYHEs5pwLJs5hOW/8yxcJBJLBq7SrkaOHUNVBVFJ+7WUzJDUYh5k/BRzQC56K9LhDh8z
         DCI3DdNdMafrx4g3TsFQJE3MREFXpUAyVEBzhQcRkd1vUafeP2uxO62jfaBto63APqG+
         St906KrRTc9dtWYk3slPxdeetrkt3wDFr1rbFuszDqWM6BGnSwuQuf37U8BYCjAvzh30
         QrOy0YpK96rPsnynNlxcPbaeqUGlaKMoFq6K0ipehknt/fxaO3NN4ufnGn2X8+1SMG2X
         iZMw==
X-Gm-Message-State: AGi0PuY3blAz/+DN1DI7aMK3Hplh6reNtU6cg7gDKHJZcVFjj8qUvt51
        ardMZYryLP+WmENdRDCZj3vd7QSbYN4=
X-Google-Smtp-Source: APiQypKBN71lAXe1lmBGeAW3QmJygSRproa4ywleUYk72xrQFS47TFCTuFtI9CzCJjSeH9xTiUF1iQ==
X-Received: by 2002:adf:82b1:: with SMTP id 46mr6465870wrc.44.1587674421980;
        Thu, 23 Apr 2020 13:40:21 -0700 (PDT)
Received: from localhost.localdomain ([2.31.163.63])
        by smtp.gmail.com with ESMTPSA id u17sm5933726wra.63.2020.04.23.13.40.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Apr 2020 13:40:21 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Cc:     Markus Elfring <elfring@users.sourceforge.net>,
        Christophe Leroy <christophe.leroy@c-s.fr>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 4.4 04/16] crypto: talitos - Delete an error message for a failed memory allocation in talitos_edesc_alloc()
Date:   Thu, 23 Apr 2020 21:40:02 +0100
Message-Id: <20200423204014.784944-5-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200423204014.784944-1-lee.jones@linaro.org>
References: <20200423204014.784944-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>

[ Upstream commit 0108aab1161532c9b62a0d05b8115f4d0b529831 ]

Omit an extra message for a memory allocation failure in this function.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
Reviewed-by: Christophe Leroy <christophe.leroy@c-s.fr>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/crypto/talitos.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index 1c8857e7db894..f3d0a33f4ddb4 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -1287,7 +1287,6 @@ static struct talitos_edesc *talitos_edesc_alloc(struct device *dev,
 		if (iv_dma)
 			dma_unmap_single(dev, iv_dma, ivsize, DMA_TO_DEVICE);
 
-		dev_err(dev, "could not allocate edescriptor\n");
 		return ERR_PTR(-ENOMEM);
 	}
 
-- 
2.25.1

