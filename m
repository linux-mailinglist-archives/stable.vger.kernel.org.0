Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FFBA209A04
	for <lists+stable@lfdr.de>; Thu, 25 Jun 2020 08:47:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390194AbgFYGqy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Jun 2020 02:46:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390141AbgFYGqi (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Jun 2020 02:46:38 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62043C0613ED
        for <stable@vger.kernel.org>; Wed, 24 Jun 2020 23:46:38 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id q5so4599739wru.6
        for <stable@vger.kernel.org>; Wed, 24 Jun 2020 23:46:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bh7BIJEoFgjXHqYRkwppX22NHiJGTlWMxnnDJ2K7EXk=;
        b=glb++HtS7oZWTpXDAzu7GckwXl1mrcYHW8RG3vTiRLcrJP0l7bKna80fqlxmkNdFuI
         WtsEu8LgvypecW54tymX3u8xbDuWXwH15K8LxtUmwAnB5XGefq2pMyX5ndzdlS78CuO6
         X8YwtelBuFGRwp5DX/Lg1xCuSkc+Gue1l6Ue7pWro9xfXnmYiRXceFTqupqzt+vGtjDT
         +jbyK+D9fFbDRc+8XfgTfi+DfbyNx+U0gVeA3dnVYIMm4bPGVm/BWPyspiJbOZd5LODD
         3QuaAbe8tuiikxunA1ERhVLZ1r718Dkld9We079Otb5DKfuJKCICePZjxmw2lQLBaD1m
         DHsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bh7BIJEoFgjXHqYRkwppX22NHiJGTlWMxnnDJ2K7EXk=;
        b=TrMGfdEcly5tLHcc1YqRQEi4Dfb9U9j2NKh6sMUl2iEI0LEgxJgWzdoLm8HrngfvLf
         9Rv0P7N8ahWVoH8PJRP8zvu4EmURnyqTkQ1w3rRf00AxUmBrARmLp/0Had2RtsTW1qYc
         sOW4U7r2rN5aJ2d5bXCWviSPHW3n3pxkwZ7MhUXltexfQto89OuNBa8PpC9HhCianB9/
         ywe2vGP6CBj6Dhw7zDDXO7QWocFGDIsuv6uX0Ymbc4kcU4M+0wqnZAbNWtL+jF0Aj4LV
         /DUkZN+7LB0RBAgpswMus73LunfTQF3KZxbNYQ5BqHDdQy02ScN2JqvC94K1IkenBdHU
         s4Uw==
X-Gm-Message-State: AOAM532/VMQjqDVZgdM2uFMmpvmMAvTuFmcT7xsQL6basz5BSoHPIZxW
        U1Ogj8CxOJlum/l3o59P0E9UdA==
X-Google-Smtp-Source: ABdhPJz7hX/Z2JM0lOGHssb5FyeBBY2iFs7Z9tsdVrKKfbPW5vOlTRxleyhOq9BreaGxFEv4RwYsQA==
X-Received: by 2002:a5d:6802:: with SMTP id w2mr8325231wru.88.1593067597162;
        Wed, 24 Jun 2020 23:46:37 -0700 (PDT)
Received: from localhost.localdomain ([2.27.35.144])
        by smtp.gmail.com with ESMTPSA id c20sm27235363wrb.65.2020.06.24.23.46.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jun 2020 23:46:36 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Thor Thayer <thor.thayer@linux.intel.com>
Subject: [PATCH 10/10] mfd: altera-sysmgr: Supply descriptions for 'np' and 'property' function args
Date:   Thu, 25 Jun 2020 07:46:19 +0100
Message-Id: <20200625064619.2775707-11-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200625064619.2775707-1-lee.jones@linaro.org>
References: <20200625064619.2775707-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Kerneldoc syntax is used, but not complete.  Arg descriptions are required.

Fixes the following W=1 build warnings:

 drivers/mfd/altera-sysmgr.c:95: warning: Function parameter or member 'np' not described in 'altr_sysmgr_regmap_lookup_by_phandle'
 drivers/mfd/altera-sysmgr.c:95: warning: Function parameter or member 'property' not described in 'altr_sysmgr_regmap_lookup_by_phandle'

Cc: <stable@vger.kernel.org>
Cc: Thor Thayer <thor.thayer@linux.intel.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mfd/altera-sysmgr.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/mfd/altera-sysmgr.c b/drivers/mfd/altera-sysmgr.c
index 83f0765f819b0..41076d121dd54 100644
--- a/drivers/mfd/altera-sysmgr.c
+++ b/drivers/mfd/altera-sysmgr.c
@@ -89,6 +89,9 @@ static struct regmap_config altr_sysmgr_regmap_cfg = {
  * altr_sysmgr_regmap_lookup_by_phandle
  * Find the sysmgr previous configured in probe() and return regmap property.
  * Return: regmap if found or error if not found.
+ *
+ * @np: Pointer to device's Device Tree node
+ * @property: Device Tree property name which references the sysmgr
  */
 struct regmap *altr_sysmgr_regmap_lookup_by_phandle(struct device_node *np,
 						    const char *property)
-- 
2.25.1

