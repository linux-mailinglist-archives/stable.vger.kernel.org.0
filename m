Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EB3547F6B0
	for <lists+stable@lfdr.de>; Sun, 26 Dec 2021 13:04:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233383AbhLZMED (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Dec 2021 07:04:03 -0500
Received: from smtp-relay-internal-1.canonical.com ([185.125.188.123]:36052
        "EHLO smtp-relay-internal-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233380AbhLZMEC (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Dec 2021 07:04:02 -0500
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com [209.85.208.200])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id B102C3FFDD
        for <stable@vger.kernel.org>; Sun, 26 Dec 2021 12:04:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1640520241;
        bh=7ZRYcQP4gwZ7osyzmEc94Zg7aNBaID54stiX6ii0ERI=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type;
        b=C5brFjRTtRh8Jfdf8eu9Ei8jXVoouQ+ikrK4MFR94yUsYoazv83u7+a6nQezAGz4x
         u2/QJJT8gPYP5crV3okAhkRNjd49qyeqT4VV+mhC9fqe/EbfKXANNd5yxxjYRH6P4z
         YbemOoWN48Qp0zMZT55M/GeJpdfVWhONOM8U3Arh3yASU0lmdcuOQiDWpt0aZWcR1h
         +4YQEO+PheeYfB1g0Y5eT6vXvzF3tEdQCeW9ldL1vj0bGsYSH4ReuB0Og2s3s8Ayl3
         mhz6elnkpkr7zM6AmPdMTIhIdz2gPfz46F8Wcvv2ibS9dw2gvR7QcWJl4bVy62JIle
         MKbmepNSb59ew==
Received: by mail-lj1-f200.google.com with SMTP id b20-20020a2e9894000000b0022dc5a5f841so769845ljj.2
        for <stable@vger.kernel.org>; Sun, 26 Dec 2021 04:04:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7ZRYcQP4gwZ7osyzmEc94Zg7aNBaID54stiX6ii0ERI=;
        b=0VkSQfvx1AlyfYIKke8YXJZVVxuoTpXSTau/KT0jDn/p/aCds6VM4tlKBnAfqRmqHP
         YF4J3xsraXhtkn7+K/kJPhmb3IJ34ozNyiaL6CkNled7z/VP68gA2rlFWRmX+f1mr4Rw
         p1rKHawg4LMcyi9Phm4Q+BhPAjSDXFZ69XEH34pR0CtflsE1gEsGw2USWLr4Xw69VnVt
         lM6FhDVxKKiR5u7/sC1TYBJBYM/ROgQAqJL9CJyD+qVf2mmQT7rSi4C/cMg+lV10e7Ty
         R/VZUVUqB25Psm/gYMEtYQqw7YNaO8Y14p9CzYidnCGr4wUjjh1qbD55YfIFoMxGktq/
         jOWA==
X-Gm-Message-State: AOAM5335VKETm1e1aQ/bOhtCTl8FAoM/2Lf3vOVpJjhwLAwggsMqqCZx
        ZhH0BONpFGHUleI8EByZwJdWkhUtLnGp9lv93QBPLqfX8K3611yqZLjvoa5f1GAzQ9/fVA9MUCV
        FUEv36ItazTi/za9A7Fj98B1v/gote9trzg==
X-Received: by 2002:a2e:8718:: with SMTP id m24mr4689957lji.306.1640520240965;
        Sun, 26 Dec 2021 04:04:00 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx25kcEr8SE2hE6DjZsPPB2SMeCupPe4TFn7Tj9CgX294X8VTyEvkJQoREMl23Oi+cK2yxXkA==
X-Received: by 2002:a2e:8718:: with SMTP id m24mr4689941lji.306.1640520240712;
        Sun, 26 Dec 2021 04:04:00 -0800 (PST)
Received: from krzk-bin.lan (89-77-68-124.dynamic.chello.pl. [89.77.68.124])
        by smtp.gmail.com with ESMTPSA id cf29sm1348719lfb.262.2021.12.26.04.03.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Dec 2021 04:04:00 -0800 (PST)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        linux-nfc@lists.01.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     "Dmitry V . Levin" <ldv@altlinux.org>,
        Arnd Bergmann <arnd@arndb.de>, stable@vger.kernel.org
Subject: [PATCH] nfc: uapi: use kernel size_t to fix user-space builds
Date:   Sun, 26 Dec 2021 13:03:47 +0100
Message-Id: <20211226120347.77602-1-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Fix user-space builds if it includes /usr/include/linux/nfc.h before
some of other headers:

  /usr/include/linux/nfc.h:281:9: error: unknown type name ‘size_t’
    281 |         size_t service_name_len;
        |         ^~~~~~

Fixes: d646960f7986 ("NFC: Initial LLCP support")
Cc: <stable@vger.kernel.org>
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
---
 include/uapi/linux/nfc.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/uapi/linux/nfc.h b/include/uapi/linux/nfc.h
index f6e3c8c9c744..bb94aac5636c 100644
--- a/include/uapi/linux/nfc.h
+++ b/include/uapi/linux/nfc.h
@@ -278,7 +278,7 @@ struct sockaddr_nfc_llcp {
 	__u8 dsap; /* Destination SAP, if known */
 	__u8 ssap; /* Source SAP to be bound to */
 	char service_name[NFC_LLCP_MAX_SERVICE_NAME]; /* Service name URI */;
-	size_t service_name_len;
+	__kernel_size_t service_name_len;
 };
 
 /* NFC socket protocols */
-- 
2.32.0

