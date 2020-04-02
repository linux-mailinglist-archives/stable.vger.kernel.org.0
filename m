Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E443C19C9D6
	for <lists+stable@lfdr.de>; Thu,  2 Apr 2020 21:20:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389467AbgDBTSL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Apr 2020 15:18:11 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:40214 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389416AbgDBTSL (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Apr 2020 15:18:11 -0400
Received: by mail-wr1-f66.google.com with SMTP id s8so3463378wrt.7
        for <stable@vger.kernel.org>; Thu, 02 Apr 2020 12:18:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=/hkstutUKkzAeVkb8A6CMmZCBPtBnLhhXsPrhwYxTuA=;
        b=SirPeW88Y+RmRS4g5/o4h4SDKotBXDTA2jrWGJfjAKJ0v+2ktQPbdvgZ1MtP3sX03C
         EFGlikfkKn47NjdZH8MytmYDJdwqTRZHmY4/goaIb5eWYC7eRcbRU99a3mkSKc5LaM0s
         6RDWoCazZ1ZgXLL0ZyqJ/qD5/1BCmIOjsm0n33uX569WPRrbOtx8X8RDI9hjX75nCfHA
         S7vWEnUMuoBYm4QPcr/fcyAkR+AIMCkS1UDCAmB/osMiTPGpCONHXcubjyixNC+oeo1f
         jyso/67wBp+QDe8SJAun0RiowBSJk0qU4761gWJIs5V9ACm/t7bxv0yNdC4y4TjtxVIV
         eQjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/hkstutUKkzAeVkb8A6CMmZCBPtBnLhhXsPrhwYxTuA=;
        b=coBRROhS2z9w9g1OD5WgMoZg0DiXaVHkKaGX98e1bz86pYTDVbkmcTGLRbyWvdJNRC
         X8BEMRWScE1utjmYXdlUkk0spsEal62OUxehrRWJOVkOwn7gxdit7F2wG9tBfHiyddDr
         50zxVwXq9CzkXTzUyMv0tfQdgdEsf8wjrZx09iTazqCrWWvv6ZaZA4zmWv+IjtFVdj8k
         CC2yNPtm6bXgufIe/o36gPQQqzWeK07SRGvpnId4ogpwdm2L+xpF+4E+jW/KSBK4g7WT
         FVwZ/ekIsTloHdSdXz/mAEt+yHiw+cUS1Wa0OE8PVA9gzM/4wlCU8asKRapJfKIX4YPO
         t6dQ==
X-Gm-Message-State: AGi0PubWp05+ZsCs/Q4v18ZT9wdyZrch1YZu7OeTl4Wa5AMVNMNSoHFq
        XDpwx7LXA/BYSIC9LsBxY5A8JhoHK9QNxw==
X-Google-Smtp-Source: APiQypLv29wdtwmz+9Szuj6cHMsXUqk95Z/3tq+mcwH9JIFT0TGbqwnx4WMMeES6U+E6plEnAxNj8A==
X-Received: by 2002:a5d:50d1:: with SMTP id f17mr5225942wrt.150.1585855088096;
        Thu, 02 Apr 2020 12:18:08 -0700 (PDT)
Received: from localhost.localdomain ([95.149.164.95])
        by smtp.gmail.com with ESMTPSA id l10sm8622707wrq.95.2020.04.02.12.18.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2020 12:18:07 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Subject: [PATCH 4.4 06/20] crypto: talitos - Delete an error message for a failed memory allocation in talitos_edesc_alloc()
Date:   Thu,  2 Apr 2020 20:18:42 +0100
Message-Id: <20200402191856.789622-6-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200402191856.789622-1-lee.jones@linaro.org>
References: <20200402191856.789622-1-lee.jones@linaro.org>
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

