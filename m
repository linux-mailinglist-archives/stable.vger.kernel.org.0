Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DC2F2076C3
	for <lists+stable@lfdr.de>; Wed, 24 Jun 2020 17:10:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404243AbgFXPHq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jun 2020 11:07:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404187AbgFXPHT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Jun 2020 11:07:19 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65D52C061573
        for <stable@vger.kernel.org>; Wed, 24 Jun 2020 08:07:19 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id z13so2640718wrw.5
        for <stable@vger.kernel.org>; Wed, 24 Jun 2020 08:07:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=C0YMw50ghAnk+HJlng7jm1/7u29zz1+p4P4aWF+LxTM=;
        b=kDV2gBawSXjgK3E9pSWH7A3EwP21b+YwX9fkeeuRcMt8E5kiFMZWVW0uYtCNOKcJuj
         IlqNWloTM+FAEb+U0biu0LntpBbm0JAACtz0XyTEmV/gKbjUFfaJRomKsF4zGlZT6I6p
         LWpzY3Sh6pcWRuViXK7g/WZpDc1qvOlw/ZeK6Ed8mKvL+wr7SabH/mKNbAPxWZApEJFa
         gnE8MA+E6U/pAaKDfv5CX9jACfdEpHTXEEfxN3ZvrkXac3mtnPw7zaScjyiQv+xl5GaK
         nJtMTi3C+ufi2umQbtp/YQ4YV/LWR8gsuIQXPdgTB0GBXH/9BabuZmOM7P9L0JNXcm1i
         8fDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=C0YMw50ghAnk+HJlng7jm1/7u29zz1+p4P4aWF+LxTM=;
        b=C9OqMAfYD0pDrvxmwlnkeZhlXQxrK5K2f7ODkOVjVHb+1+tcHpKls1l2ucNKcW4RCn
         CuYKTdp4RmgKqlKSm/DBJJDr72poSBSZ6O69iYih3O7hN2IGy2ICMdoKc3PoJ6XobOP6
         soQ/WXW0HstfXVyYHYpil+/XAbXH+cEWwK2lAJQmTWNjAz8ZO713ojCdl62LrzdZlqw8
         jAkdOnCtpoUybkbocZoUBrtozriMYU1PTV/Lj2UGJUI8nUfG8Gop89aB/SZ+AVv1bekR
         UWdGM8iseOhytXlyyaTYQdq6G86yn3nLKioTFyOm4reG9QRWEvLL9ueHZCL9b9iSFDR4
         ELeQ==
X-Gm-Message-State: AOAM533oV/DlKqhZb+kOVI3Q+2IU4akGxXRmQwOXAoYaHixrA2OFxNZU
        qO0YMRel/EDeqw/gxCOItZmJsA==
X-Google-Smtp-Source: ABdhPJw7fzjIBqiuXbknQUNCT1qFwoGdpdovl6TpOoVdAxH9PdAL4zXdFmFzQ0XUdcgHG+7Xx0AVNg==
X-Received: by 2002:a5d:4611:: with SMTP id t17mr30149480wrq.243.1593011238093;
        Wed, 24 Jun 2020 08:07:18 -0700 (PDT)
Received: from localhost.localdomain ([2.27.35.144])
        by smtp.gmail.com with ESMTPSA id h14sm11543361wrt.36.2020.06.24.08.07.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jun 2020 08:07:17 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Orson Zhai <orsonzhai@gmail.com>,
        Baolin Wang <baolin.wang7@gmail.com>,
        Chunyan Zhang <zhang.lyra@gmail.com>
Subject: [PATCH 05/10] mfd: sprd-sc27xx-spi: Fix symbol 'sprd_pmic_detect_charger_type' was not declared warning
Date:   Wed, 24 Jun 2020 16:06:59 +0100
Message-Id: <20200624150704.2729736-6-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200624150704.2729736-1-lee.jones@linaro.org>
References: <20200624150704.2729736-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Sparse reports:

 drivers/mfd/sprd-sc27xx-spi.c:59:23: warning: symbol 'sprd_pmic_detect_charger_type' was not declared. Should it be static?

... due to a missing header file.

Cc: <stable@vger.kernel.org>
Cc: Orson Zhai <orsonzhai@gmail.com>
Cc: Baolin Wang <baolin.wang7@gmail.com>
Cc: Chunyan Zhang <zhang.lyra@gmail.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mfd/sprd-sc27xx-spi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mfd/sprd-sc27xx-spi.c b/drivers/mfd/sprd-sc27xx-spi.c
index 33336cde47243..c305e941e435c 100644
--- a/drivers/mfd/sprd-sc27xx-spi.c
+++ b/drivers/mfd/sprd-sc27xx-spi.c
@@ -7,6 +7,7 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/mfd/core.h>
+#include <linux/mfd/sc27xx-pmic.h>
 #include <linux/of_device.h>
 #include <linux/regmap.h>
 #include <linux/spi/spi.h>
-- 
2.25.1

