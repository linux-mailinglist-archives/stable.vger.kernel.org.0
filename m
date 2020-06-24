Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDC8B2076BE
	for <lists+stable@lfdr.de>; Wed, 24 Jun 2020 17:10:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404390AbgFXPHl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jun 2020 11:07:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404262AbgFXPHY (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Jun 2020 11:07:24 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0F1DC061796
        for <stable@vger.kernel.org>; Wed, 24 Jun 2020 08:07:23 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id h15so2631311wrq.8
        for <stable@vger.kernel.org>; Wed, 24 Jun 2020 08:07:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=iBe/FTv7QFeWNcu1NrkE8EgReU1liqjk61nWnJ+d1XE=;
        b=B+Hgbe6AnZtssQEQLO8+i8LkJ9djlesDYCv5WY7N1bZuonlujQTgxUVX+EIDPO9kgQ
         5AKudORu/oeiJMDAlTmAdQnVSJtqifT2wniOLK3q1GFfQk93QfIsuzrKKUAJz+R1dzcR
         suKJvwEPmlDTzNaH7TNLdu1QwMrKr6R6f0HGqXMtOHIuPYgZ/bfkULjSw9PNFIctmDEE
         P9MNElqmSRzhWWNxy9kXXWmZrxts/dMGERsWqgdpr7/2Q/j5WLhhJJ9Qjt92oI8GBpVN
         1o+nBw/CBOEzI7oFe9mzJ7P343F/2Dh04W8EOjuETfcBeVenRb9twG5OwYOW87+Zz/XU
         XelA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=iBe/FTv7QFeWNcu1NrkE8EgReU1liqjk61nWnJ+d1XE=;
        b=hrNqyWMoXUTn8lAG7KmWb1CFkYPIOAT73hr8/Mt1PjWGmk8X4NZszAxaxFOC09u3iA
         frsdnRetCvMM2LsylrA4RKT98PX8beVrRMaBZHi36eUq+o1tKe4SDH7BDavQX1VXeLFI
         9de1kuyZTaBptq2jBmoPsTzLipDHvo3hkDeSPZoW5sawz5wnGbeyAgHFb+hELJZXxM9F
         vdqxYRtoH1BUiEgq6o7ALtU3mWd9wXPF+SPRXa4+3nW4GH2ia/sCzDEqiINPD1UQ6e5+
         Dd6bOxQXAPpQJfT7Fu7Pubzxnb8HUvcktWLZN/EN5X2jta5GdMcEh10VlWtbcigrHNI+
         iIsg==
X-Gm-Message-State: AOAM530ls/1NssSq1qqR/5aInGq0hJYegAZZcN2VGe4iroEjDsK3B8H5
        Y7/GhRFdXkJsjVxue6/WgFMe6A==
X-Google-Smtp-Source: ABdhPJwq4TiHFC0om0P4LKPqRz2iWzOotH8E+e4+wuBw1cN25FayJM197IkFVa1gMyGlfOZuFjvacA==
X-Received: by 2002:adf:ef89:: with SMTP id d9mr17946513wro.124.1593011242694;
        Wed, 24 Jun 2020 08:07:22 -0700 (PDT)
Received: from localhost.localdomain ([2.27.35.144])
        by smtp.gmail.com with ESMTPSA id h14sm11543361wrt.36.2020.06.24.08.07.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jun 2020 08:07:22 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        patches@opensource.cirrus.com
Subject: [PATCH 09/10] mfd: wm8400-core: Supply description for wm8400_reset_codec_reg_cache's arg
Date:   Wed, 24 Jun 2020 16:07:03 +0100
Message-Id: <20200624150704.2729736-10-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200624150704.2729736-1-lee.jones@linaro.org>
References: <20200624150704.2729736-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Kerneldoc syntax is used, but not complete.  Descriptions required.

Prevents warnings like:

 drivers/mfd/wm8400-core.c:113: warning: Function parameter or member 'wm8400' not described in 'wm8400_reset_codec_reg_cache'

Cc: <stable@vger.kernel.org>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: patches@opensource.cirrus.com
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mfd/wm8400-core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/mfd/wm8400-core.c b/drivers/mfd/wm8400-core.c
index 3055d6f47afcc..0fe32a05421be 100644
--- a/drivers/mfd/wm8400-core.c
+++ b/drivers/mfd/wm8400-core.c
@@ -108,6 +108,8 @@ static const struct regmap_config wm8400_regmap_config = {
 /**
  * wm8400_reset_codec_reg_cache - Reset cached codec registers to
  * their default values.
+ *
+ * @wm8400: pointer to local driver data structure
  */
 void wm8400_reset_codec_reg_cache(struct wm8400 *wm8400)
 {
-- 
2.25.1

