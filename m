Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14D5D209A08
	for <lists+stable@lfdr.de>; Thu, 25 Jun 2020 08:47:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390167AbgFYGqf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Jun 2020 02:46:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390139AbgFYGqd (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Jun 2020 02:46:33 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 125C1C061796
        for <stable@vger.kernel.org>; Wed, 24 Jun 2020 23:46:33 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id l17so4430290wmj.0
        for <stable@vger.kernel.org>; Wed, 24 Jun 2020 23:46:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zFD+XYh0LbdyDPIgjJ6ML5H3hXoar7p4uFfuKLbk0ZA=;
        b=jAVR5eoyrmVKjLEHNqfjCNWanaCYTE8ppNlexuZG9che0RL0uhWQj0j1YU5wDQgiB2
         XxrXcc5uE085/9qsTkTpk2XicffwrBGGolaOz3pSHPcANX/VXJO3NcsEvj/CjpkIDpYq
         Q3uXB5Y94Cd9PoRDMEZTfc2n3h2txHH6s5g64wtshhSl8eZGhOHM5VvLNYbdwtut8zjf
         SHmv0HSTQc3SOI81N9Hl/EIU4+S2YDJJin++zw4JooKAF6IG7Tz/GhIVJ2tlE5mHG9XM
         kU1qAEaskZkY0Jz/u9LZHE9tEDf4/lcq6JOS+Bt0SaLzhLaG1eGh1Rb50sae3rOuvipu
         FWZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zFD+XYh0LbdyDPIgjJ6ML5H3hXoar7p4uFfuKLbk0ZA=;
        b=Mrpq1D79qfd66A5wjaNhT8JxJ9IKWsiQX82zu6lYETupSOs1JNCYn6YjJ44jmO3/YQ
         6srQhvWWOFvxnyOJCOdPBClII0jsGeaPr6PGr3O88GIx7t+M9nmN2fGeEhTawMkq8IuA
         +759DFkoldgp/z0UHxBTTVnF7ELpiQsPY0qmBloDdvTfGNW0H5Zohjhm+UUlzJgErEz7
         V69NqrWqPQrBXsLfY3rNI1rAcnkpJSddUTk5aeiiXf9Uebm/dIgJmu15DjzCxunym8Di
         uFdXqEGKYBeS02CVLAIf9JzeafGk90JCyAQSIFC5fqE77lHQU6httefzqCzKtBnWtygu
         OVjw==
X-Gm-Message-State: AOAM531IAYP78MF/lgSlcSyQP+vG8y0UwSAkxAxd1yDRVv/GwxNnVgB1
        6RK6qPD3VO4WSlTmnqMeHlResA==
X-Google-Smtp-Source: ABdhPJwMgZfQzBCeFoiLZTJnp/x4vgmn7WMj1vkUKS/+Lm7IeVtJH2PwgM57kLDLfxA35mh6mWhlMA==
X-Received: by 2002:a1c:dfd6:: with SMTP id w205mr1785713wmg.118.1593067591825;
        Wed, 24 Jun 2020 23:46:31 -0700 (PDT)
Received: from localhost.localdomain ([2.27.35.144])
        by smtp.gmail.com with ESMTPSA id c20sm27235363wrb.65.2020.06.24.23.46.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jun 2020 23:46:31 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Tony Lindgren <tony@atomide.com>,
        Keshava Munegowda <keshava_mgowda@ti.com>,
        Roger Quadros <rogerq@ti.com>, linux-omap@vger.kernel.org
Subject: [PATCH 05/10] mfd: omap-usb-host: Remove invalid use of kerneldoc syntax
Date:   Thu, 25 Jun 2020 07:46:14 +0100
Message-Id: <20200625064619.2775707-6-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200625064619.2775707-1-lee.jones@linaro.org>
References: <20200625064619.2775707-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Kerneldoc is for documenting function arguments and return values.

Prevents warnings like:

 drivers/mfd/omap-usb-host.c:128: warning: cannot understand function prototype: 'const char * const port_modes[] = '

Cc: <stable@vger.kernel.org>
Cc: Tony Lindgren <tony@atomide.com>
Cc: Keshava Munegowda <keshava_mgowda@ti.com>
Cc: Roger Quadros <rogerq@ti.com>
Cc: linux-omap@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mfd/omap-usb-host.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/omap-usb-host.c b/drivers/mfd/omap-usb-host.c
index 1f4f01b02d98c..f56cdf3149dc0 100644
--- a/drivers/mfd/omap-usb-host.c
+++ b/drivers/mfd/omap-usb-host.c
@@ -120,7 +120,7 @@ static inline u32 usbhs_read(void __iomem *base, u32 reg)
 
 /*-------------------------------------------------------------------------*/
 
-/**
+/*
  * Map 'enum usbhs_omap_port_mode' found in <linux/platform_data/usb-omap.h>
  * to the device tree binding portN-mode found in
  * 'Documentation/devicetree/bindings/mfd/omap-usb-host.txt'
-- 
2.25.1

