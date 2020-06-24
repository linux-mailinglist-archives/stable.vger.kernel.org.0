Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B18B72076C0
	for <lists+stable@lfdr.de>; Wed, 24 Jun 2020 17:10:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404402AbgFXPHm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jun 2020 11:07:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404238AbgFXPHX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Jun 2020 11:07:23 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4980C061797
        for <stable@vger.kernel.org>; Wed, 24 Jun 2020 08:07:22 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id r12so2594762wrj.13
        for <stable@vger.kernel.org>; Wed, 24 Jun 2020 08:07:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HqgBI5p9cdp/gbRtc5/Vf5SqfkaArMfvY8eaitdy6zc=;
        b=lFmz9hEr/UQJ+lwMW8roCnq3g4o/1IdbpIbo0yOY9Gr1j8oubjm/YxUQtoUtEG4z0u
         iDnDFflx74sHdoX4yqDg6oV4pfxet8NvFU2/FHLuALUQr3an4yKs9S+Fs79eIDpc3dcb
         JtXFXWW12p27qVi6qpB5nk9/t1ogYLmnsm7xyLKp4i3FT22qLqFqH+ICOvXShxjlQnys
         fqySQyjcMI+FVhbec+8k44RhRNFhvVdmz31l5lW8qOFH+vEQucZDKToab5H7wXcx15lc
         lpA6UmZdV5LtxK5uhrMDob/Slw1ZsJUiIbWJiEEXLvXoJKmphPdN8AP4XYBMgBlADmQW
         sBBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HqgBI5p9cdp/gbRtc5/Vf5SqfkaArMfvY8eaitdy6zc=;
        b=D7Et4Fa6v4PUqBU78i2T7SINz+WufBhWWlLZ/1Va0OjMnekEb2inM/judIQyiQoV2c
         5xZpCcUcjprURQEem3+46nHLTp1Q0va3Z9ZtL9Pt+QJ9VW1EHDE0mTQgQtTAxXs0nLUy
         TZ4Su4hNbDjK5fjb6AL2Bia/n+JMKWltu/1PlYS2VQk/0Bt3MNwPjfStzWSSr3mtOrQV
         QIkbbpk8n+9bhugoH2FAT4CVXesM6zo7vPk1pT4qrrRoemksvPPuK2GiwQgtHK1kp18N
         8c3JaGEq31T+Ka2ZVikLg3jpNWeedOkrqEq0UleyPixiyIU+BnS/5cnlj7SxEThv0QAx
         8Hrw==
X-Gm-Message-State: AOAM532KaiH8xGoD+j7EYsTaz8+HL9i560MveLky2WS3fJE2/al8BArt
        UT7zxvn9ApOWnReHYkbRKmjsDw==
X-Google-Smtp-Source: ABdhPJwOvWTMTp+xIS2/s8zG18Vu4DqV2sM9Odv7Zzraz2b8w8qwdPgvlZ7TBTtcClG7K1YLPU2I8A==
X-Received: by 2002:a05:6000:10c4:: with SMTP id b4mr18542660wrx.50.1593011241512;
        Wed, 24 Jun 2020 08:07:21 -0700 (PDT)
Received: from localhost.localdomain ([2.27.35.144])
        by smtp.gmail.com with ESMTPSA id h14sm11543361wrt.36.2020.06.24.08.07.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jun 2020 08:07:21 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH 08/10] mfd: tc3589x: Remove invalid use of kerneldoc syntax
Date:   Wed, 24 Jun 2020 16:07:02 +0100
Message-Id: <20200624150704.2729736-9-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200624150704.2729736-1-lee.jones@linaro.org>
References: <20200624150704.2729736-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Kerneldoc is for documenting function arguments and return values.

Prevents warnings like:

 drivers/mfd/tc3589x.c:32: warning: Enum value 'TC3589X_TC35890' not described in enum 'tc3589x_version'
 drivers/mfd/tc3589x.c:32: warning: Enum value 'TC3589X_TC35892' not described in enum 'tc3589x_version'
 drivers/mfd/tc3589x.c:32: warning: Enum value 'TC3589X_TC35893' not described in enum 'tc3589x_version'
 drivers/mfd/tc3589x.c:32: warning: Enum value 'TC3589X_TC35894' not described in enum 'tc3589x_version'
 drivers/mfd/tc3589x.c:32: warning: Enum value 'TC3589X_TC35895' not described in enum 'tc3589x_version'
 drivers/mfd/tc3589x.c:32: warning: Enum value 'TC3589X_TC35896' not described in enum 'tc3589x_version'
 drivers/mfd/tc3589x.c:32: warning: Enum value 'TC3589X_UNKNOWN' not described in enum 'tc3589x_version'

Cc: <stable@vger.kernel.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mfd/tc3589x.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/tc3589x.c b/drivers/mfd/tc3589x.c
index 67c9995bb1aa6..7882a37ffc352 100644
--- a/drivers/mfd/tc3589x.c
+++ b/drivers/mfd/tc3589x.c
@@ -18,7 +18,7 @@
 #include <linux/mfd/tc3589x.h>
 #include <linux/err.h>
 
-/**
+/*
  * enum tc3589x_version - indicates the TC3589x version
  */
 enum tc3589x_version {
-- 
2.25.1

