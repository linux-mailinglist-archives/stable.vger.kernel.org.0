Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 943A667E1EE
	for <lists+stable@lfdr.de>; Fri, 27 Jan 2023 11:40:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232246AbjA0Kkr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Jan 2023 05:40:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231592AbjA0Kkl (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 Jan 2023 05:40:41 -0500
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D725166C8
        for <stable@vger.kernel.org>; Fri, 27 Jan 2023 02:40:35 -0800 (PST)
Received: by mail-wm1-x334.google.com with SMTP id q10-20020a1cf30a000000b003db0edfdb74so5248902wmq.1
        for <stable@vger.kernel.org>; Fri, 27 Jan 2023 02:40:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZtVH5VgAz17FnfQMHHRW9JT+QmfExCAJP9BmlGuNLdk=;
        b=fjlWBHiEpuzwg1d05jkEHFOO/cM62PXN6MfAnanzh0WVouI5K1EP7NIOujlWeVVYCC
         VTuLyWEhTIzqC3hAyKNAwnmCTQ5eRY7vFVirjg0hREvRyKVjhzWj9yIXnz/b6lQc/W5j
         PX2rlZJ39UP/UoVz0nyQOznwoiCKMsrlO466j4HC45x9tA+lR1Ny8DmOEDSwqoIRV+3D
         95C4Jl3SVb676lJRQV8DU9g5FjtdoRrwTiU7feUCX4Kj3qjoSz5Tt4SsUXW2JOYw/d8A
         DINQcgY3wNLzxl3XVv6BSs1fv6y0zZhBWVtcgTL0fHh4s52Y+V8X4xLoRU+fYWGThbe7
         y57w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZtVH5VgAz17FnfQMHHRW9JT+QmfExCAJP9BmlGuNLdk=;
        b=saBkbZ6sbBD2kVJrnrxoHCJstXikU4aVD67bFQDj/rwlBVlouJ8tKgbjxf4Z5qfyaH
         H1zV4cWZGUlksItkeRCenhknc1G+OhjRsiIddQI8HDXmCWGtkOk5rLs+RWtOecSNRGxC
         HCsWHk0tBN4Slgfe1o3qDh2zYVwXhnw0Bkw9qbFhrBymJ1yeeaZX1aa/l+6+80/xbOri
         1uIMouw7sx9QHRzIga72T8Y8TJ0CKKE6r1KCq/0uwY6uDLpxJ3P35rO05ZK4AsbMrkjl
         YQUvD+LgE5yvxGWZvevQ0stTxoN9CwZh2oKtceGHnbxFmjCZN3ALj4b5Efb5I3vAcqaG
         qMtA==
X-Gm-Message-State: AFqh2koTWslCHiN4tjpxIFKbjvLimlE0DeCAsOIaT/38tit85h6UWZYf
        xwNZgAnn6ensXwzpmtavcQZJBg==
X-Google-Smtp-Source: AMrXdXujOH1FICldoJBBlDeyyg+bBCWxSi9/IVCvoRonFZa9zNcHu5DcrRA/1HLPmcSEZw1egKb3/g==
X-Received: by 2002:a05:600c:1d22:b0:3d9:6bc3:b8b9 with SMTP id l34-20020a05600c1d2200b003d96bc3b8b9mr39648893wms.9.1674816034077;
        Fri, 27 Jan 2023 02:40:34 -0800 (PST)
Received: from localhost.localdomain ([5.133.47.210])
        by smtp.gmail.com with ESMTPSA id q9-20020a1ce909000000b003dc34edacf8sm1619787wmc.31.2023.01.27.02.40.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Jan 2023 02:40:33 -0800 (PST)
From:   Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
To:     gregkh@linuxfoundation.org
Cc:     linux-kernel@vger.kernel.org,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Dan Carpenter <error27@gmail.com>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH 09/10] nvmem: core: fix return value
Date:   Fri, 27 Jan 2023 10:40:14 +0000
Message-Id: <20230127104015.23839-10-srinivas.kandagatla@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230127104015.23839-1-srinivas.kandagatla@linaro.org>
References: <20230127104015.23839-1-srinivas.kandagatla@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>

Dan Carpenter points out that the return code was not set in commit
60c8b4aebd8e ("nvmem: core: fix cleanup after dev_set_name()"), but
this is not the only issue - we also need to zero wp_gpio to prevent
gpiod_put() being called on an error value.

Cc: stable@vger.kernel.org
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <error27@gmail.com>
Fixes: 60c8b4aebd8e ("nvmem: core: fix cleanup after dev_set_name()")
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
---
 drivers/nvmem/core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/nvmem/core.c b/drivers/nvmem/core.c
index 563116405b3d..34ee9d36ee7b 100644
--- a/drivers/nvmem/core.c
+++ b/drivers/nvmem/core.c
@@ -783,6 +783,7 @@ struct nvmem_device *nvmem_register(const struct nvmem_config *config)
 						    GPIOD_OUT_HIGH);
 	if (IS_ERR(nvmem->wp_gpio)) {
 		rval = PTR_ERR(nvmem->wp_gpio);
+		nvmem->wp_gpio = NULL;
 		goto err_put_device;
 	}
 
-- 
2.25.1

