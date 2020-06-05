Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 932521EFDF7
	for <lists+stable@lfdr.de>; Fri,  5 Jun 2020 18:29:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726750AbgFEQ0C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Jun 2020 12:26:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726727AbgFEQ0B (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Jun 2020 12:26:01 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D3B2C08C5C2;
        Fri,  5 Jun 2020 09:26:01 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id o6so5377104pgh.2;
        Fri, 05 Jun 2020 09:26:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=FrKureXAugTznm0BDZd4QZA9eNgJhwIv0PlSXJOT72U=;
        b=sTwJSvUcQ20+52QuZlahVZ/PtgEVkSBVPfH530tFTp29oZT9wXxczb8OHoQU8iS0pN
         PSdp+BHmPkExZqmwEdgmyOpz7JgFI1CbCT8HQKSrG21QIMe4qYettibVCVjlmh2vmlVp
         570ZeirjE28Zo41IQk0XELbF4SeVkGf7gTmTNOt+UrMdLt47PFw32aPo1/JrMx5+/3c7
         AhBLnwoCz6GGp7gt/mFR6XL65PLfWOr002c9xWkqRxPDRTJuGfwd3JyWpLxyfq+bctPi
         m4RsGMZ+NWtHITvNy17FEgOcyzoCYScKnh3z9nfM/7SrC9EMgvdCyj9awU1zVCVhR2iy
         j55g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=FrKureXAugTznm0BDZd4QZA9eNgJhwIv0PlSXJOT72U=;
        b=ovRBnLB/R924eIijJRGESn9b+giNlAkHdkyFwqFYbrdt6OGZKK/k1P7lxt6JK8I2Dw
         t8wOVjy63fOYTcOoHUFAQXw1lVEYE42ftQXbLLW7MWHSFwOCchj+f7UxogpVqSiQ04tD
         WBwKLbW+nhiOXF4xwkm8iNlw+UNMLSdvZFGsVNPZnoiCm7ywstSQRN6NkK9v8sVd9YeA
         3frUVfbdAiHzbIIwpd1xtzG4J67OcW20gKDH/x0RF8UfT1eklW4EKXFMiDtDYsN5Uqy/
         P5KNc4F6tYbhQCj/g6tzo6Cje1VW/6NNRb4T5mUApBZONpRVjTxNtih0LIEpL+Yznp+E
         rU3g==
X-Gm-Message-State: AOAM530Q2O40p0bkIN9idn5WdFwzLFTnHuuWRYIPu0Mc59IdwUf80BLu
        0PLpXZNtA9ey1FHU25XT+XePepSE
X-Google-Smtp-Source: ABdhPJzr7d6bll/CqwR+jW9s0alK40zPfr3i3/ktdsLPzXYazAPQVp5BJfS0dLJEvvs1FhpQRG/BoQ==
X-Received: by 2002:aa7:95bd:: with SMTP id a29mr10340370pfk.57.1591374360329;
        Fri, 05 Jun 2020 09:26:00 -0700 (PDT)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id b29sm86205pff.176.2020.06.05.09.25.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Jun 2020 09:25:59 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
X-Google-Original-From: Florian Fainelli <florian.fainelli@broadcom.com>
To:     linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Michael Krufky <mkrufky@linuxtv.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Shuah Khan <shuah@kernel.org>,
        Jaedon Shin <jaedon.shin@gmail.com>,
        Katsuhiro Suzuki <suzuki.katsuhiro@socionext.com>,
        Satendra Singh Thakur <satendra.t@samsung.com>,
        linux-media@vger.kernel.org (open list:MEDIA INPUT INFRASTRUCTURE
        (V4L/DVB)),
        linux-fsdevel@vger.kernel.org (open list:FILESYSTEMS (VFS and
        infrastructure))
Subject: [PATCH stable 4.9 02/21] media: dvb_frontend: initialize variable s with FE_NONE instead of 0
Date:   Fri,  5 Jun 2020 09:24:59 -0700
Message-Id: <20200605162518.28099-3-florian.fainelli@broadcom.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200605162518.28099-1-florian.fainelli@broadcom.com>
References: <20200605162518.28099-1-florian.fainelli@broadcom.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

commit 450694c3b9f47b826a002089c463b9454b4bbe42 upstream

GIT_AUTHOR_NAME=Colin King
GIT_AUTHOR_EMAIL=colin.king@canonical.com

In a previous commit, we added FE_NONE as an unknown fe_status.
Initialize variable s to FE_NONE instead of the more opaque value 0.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
Reviewed-by: Shuah Khan <shuahkh@osg.samsung.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/media/dvb-core/dvb_frontend.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
index 372057cabea4..3b045298546c 100644
--- a/drivers/media/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb-core/dvb_frontend.c
@@ -458,7 +458,7 @@ static int dvb_frontend_swzigzag_autotune(struct dvb_frontend *fe, int check_wra
 
 static void dvb_frontend_swzigzag(struct dvb_frontend *fe)
 {
-	enum fe_status s = 0;
+	enum fe_status s = FE_NONE;
 	int retval = 0;
 	struct dvb_frontend_private *fepriv = fe->frontend_priv;
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache, tmp;
-- 
2.17.1

