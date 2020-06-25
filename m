Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C36E5209A03
	for <lists+stable@lfdr.de>; Thu, 25 Jun 2020 08:47:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390262AbgFYGqx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Jun 2020 02:46:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390194AbgFYGqi (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Jun 2020 02:46:38 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BB4CC061799
        for <stable@vger.kernel.org>; Wed, 24 Jun 2020 23:46:37 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id b6so4579305wrs.11
        for <stable@vger.kernel.org>; Wed, 24 Jun 2020 23:46:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=J2LvBowpzfqfQHnK/gnFZDPalEMEwUf10cp2QuQIuRg=;
        b=MVXl0wtgTNbcqhYy50uwzSMS91a5du9fhzg4oeB/etwz+t21MCLhi+PSWsJnrEyp3H
         37sCoamMGW5zxACUygyfAjblD0iWrElfagnCgzarbJmDFtDaBnfibzhRcELTWRTz6+f7
         dAi5vForunxsCLorBb9k5irOYwFYlroFBnbYQ1jQfAosFB6pAR4irkMzKX7m8YjCMfG/
         CtRLuLArlmcY/lmBV/bEL17oZ9ZujckJiDZXTLnMsNwn3W3g4RPRBmTy3T6cIdrOxqez
         DbK7Q3oChBAP1tW0xprzEo4N3hk/VQGb0VfV/LS1HQKjjxRD12nh6V7Q/w8KLxSkDACU
         DcAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=J2LvBowpzfqfQHnK/gnFZDPalEMEwUf10cp2QuQIuRg=;
        b=bVSz2p9OyQeWYqCHa/P95GqM8lQ0scZMXKtNex4qn6BLto20EM7VYjQXDzhOX4SbJO
         ZzUfZuYwMkc1vxawR7BSaZAH0T8eJRKOJW+BB/XM4NHtkfd8VGkW12yZTXRBYGPRIc0c
         FOTkD817oERtyCZCYrdqmN3YCGabDqX7CNMW61BKxcmamBBeucvs7IqaQ3hkT5bT4S8G
         REMhfZqwnDbTPPYawmq3fxj8KaW936Pu4Wy7nmifQslJtDL7uWFJjlC54qIhEsHoVaGm
         nPgtfDKokbI9obMxrPUlF16T8dS9xh8Mi2puFxUmdUt0hyH4lmQXnTiUP/ZsVLaH57zT
         wQHg==
X-Gm-Message-State: AOAM530LsHje+I+IxUrAOf61BxGe/iNh0pnAxA4OPq7ybnXdhnVc9LAX
        ObfotxtR5GDTDJqpqc4BSc5tAA==
X-Google-Smtp-Source: ABdhPJz8KzvsZKFGSyJkJ71Ru54KSb6+CeeKrbaJt/6Ar9O5KO9HCidzIoTFO4ALy3HXGkPV6umT0A==
X-Received: by 2002:adf:8091:: with SMTP id 17mr33043279wrl.244.1593067596171;
        Wed, 24 Jun 2020 23:46:36 -0700 (PDT)
Received: from localhost.localdomain ([2.27.35.144])
        by smtp.gmail.com with ESMTPSA id c20sm27235363wrb.65.2020.06.24.23.46.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jun 2020 23:46:35 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Ludovic Desroches <ludovic.desroches@microchip.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>
Subject: [PATCH 09/10] mfd: atmel-smc: Add missing colon(s) for 'conf' arguments
Date:   Thu, 25 Jun 2020 07:46:18 +0100
Message-Id: <20200625064619.2775707-10-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200625064619.2775707-1-lee.jones@linaro.org>
References: <20200625064619.2775707-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Kerneldoc valication gets confused if syntax isn't "@.*: ".

Adding the missing colons squashes the following W=1 warnings:

drivers/mfd/atmel-smc.c:247: warning: Function parameter or member 'conf' not described in 'atmel_smc_cs_conf_apply'
drivers/mfd/atmel-smc.c:268: warning: Function parameter or member 'conf' not described in 'atmel_hsmc_cs_conf_apply'

Cc: <stable@vger.kernel.org>
Cc: Nicolas Ferre <nicolas.ferre@microchip.com>
Cc: Alexandre Belloni <alexandre.belloni@bootlin.com>
Cc: Ludovic Desroches <ludovic.desroches@microchip.com>
Cc: Boris Brezillon <boris.brezillon@free-electrons.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mfd/atmel-smc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/atmel-smc.c b/drivers/mfd/atmel-smc.c
index 17bbe9d1fa740..4aac96d213369 100644
--- a/drivers/mfd/atmel-smc.c
+++ b/drivers/mfd/atmel-smc.c
@@ -237,7 +237,7 @@ EXPORT_SYMBOL_GPL(atmel_smc_cs_conf_set_cycle);
  * atmel_smc_cs_conf_apply - apply an SMC CS conf
  * @regmap: the SMC regmap
  * @cs: the CS id
- * @conf the SMC CS conf to apply
+ * @conf: the SMC CS conf to apply
  *
  * Applies an SMC CS configuration.
  * Only valid on at91sam9/avr32 SoCs.
@@ -257,7 +257,7 @@ EXPORT_SYMBOL_GPL(atmel_smc_cs_conf_apply);
  * @regmap: the HSMC regmap
  * @cs: the CS id
  * @layout: the layout of registers
- * @conf the SMC CS conf to apply
+ * @conf: the SMC CS conf to apply
  *
  * Applies an SMC CS configuration.
  * Only valid on post-sama5 SoCs.
-- 
2.25.1

