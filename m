Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F3DC20769A
	for <lists+stable@lfdr.de>; Wed, 24 Jun 2020 17:05:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404370AbgFXPEy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jun 2020 11:04:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404184AbgFXPEw (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Jun 2020 11:04:52 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51951C061796
        for <stable@vger.kernel.org>; Wed, 24 Jun 2020 08:04:52 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id u26so4711310wmn.1
        for <stable@vger.kernel.org>; Wed, 24 Jun 2020 08:04:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kCGt1BLBXUDbnvT6cymu5MVAxH+kTuMsl5c+6aP/lLY=;
        b=jMGyaf2YOvnwdGALr7/G0emGXXMlzRVlYnFPWVRjaQMIqVwugRAnJc3hlq5hiW8h5c
         UlNYM5fXvpEjkCbgvKcR0hRU6Z7v6cS74QrqdBYQQwaf72KYCZRj32ckrnmu0aG5wzCh
         oQv/67iegU98VlySub1xjGVNx32ddSLk55uKDXkUIrvbzXltQVC60J2oVznaWMR03k3X
         c88NZ/cwdn2lcyWwoIaMvjTZKlgnZ3OueIPy8vYEViLHA8IFnXW05jOkLP4xaKWjAreX
         6dOPEbwj+fmCGzpLHvYH0loVrVQGULW0wojhwots1TLiid7Psoh58sITpdd5KWwWa8ll
         /faw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kCGt1BLBXUDbnvT6cymu5MVAxH+kTuMsl5c+6aP/lLY=;
        b=bY5yCM+7+1cR8rnvEiGjXMnvzpu9o6AqPG1X4zknk7zRwCn/Y9ObJiTZwUh+BCHd4j
         tHve+q+uulbZ+Z6ewEUERewrpdJ7rtiTRZC2lHUJqt0oK9sDzviigdo591o+1i2JaJWn
         HDuui/FWjF4vF+85ffnDis5tXVn0BSa5LCVJxgHXzJuX71oIp37OPufkDA30FXUJim91
         GMjjiDpwN9PscuYl4idw43GNQj1k0KV3IpvVk5GrOpIhI3O7htH5rCYSo4/Gu8zt/rcL
         nGTbEXOTtdQY+semkY9JjogQw+QH/MqaJb6RJPS9OIEEGwfYSONFBRXW2XnfizB4tfNf
         ijrQ==
X-Gm-Message-State: AOAM530zXoVIAnoTYoleGXGrVHz3vG7MlYGrrJ6Bo8JeHNpiMWo64+gC
        7VBOHvUUmMmvkdyGcWwM3ddt9gIpkSU=
X-Google-Smtp-Source: ABdhPJwGu9kMwIGOcSohIfYJ+NIxZfevAbg2JhUjdK0aeG9zHaTGKntdmr01NhaUWdU13TxN2I2yTw==
X-Received: by 2002:a1c:a5d6:: with SMTP id o205mr20552487wme.125.1593011091041;
        Wed, 24 Jun 2020 08:04:51 -0700 (PDT)
Received: from localhost.localdomain ([2.27.35.144])
        by smtp.gmail.com with ESMTPSA id f186sm8200319wmf.29.2020.06.24.08.04.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jun 2020 08:04:50 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     daniel.thompson@linaro.org, jingoohan1@gmail.com,
        dri-devel@lists.freedesktop.org, linux-fbdev@vger.kernel.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>, stable@vger.kernel.org,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        linux-arm-msm@vger.kernel.org
Subject: [PATCH 8/8] backlight: qcom-wled: Remove unused configs for LED3 and LED4
Date:   Wed, 24 Jun 2020 15:57:21 +0100
Message-Id: <20200624145721.2590327-9-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200624145721.2590327-1-lee.jones@linaro.org>
References: <20200624145721.2590327-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Fixes W=1 warnings:

 drivers/video/backlight/qcom-wled.c:1294:34: warning: ‘wled4_string_cfg’ defined but not used [-Wunused-const-variable=]
 1294 | static const struct wled_var_cfg wled4_string_cfg = {
 | ^~~~~~~~~~~~~~~~
 drivers/video/backlight/qcom-wled.c:1290:34: warning: ‘wled3_string_cfg’ defined but not used [-Wunused-const-variable=]
 1290 | static const struct wled_var_cfg wled3_string_cfg = {
 | ^~~~~~~~~~~~~~~~

Cc: <stable@vger.kernel.org>
Cc: Andy Gross <agross@kernel.org>
Cc: Bjorn Andersson <bjorn.andersson@linaro.org>
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: linux-arm-msm@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/video/backlight/qcom-wled.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/video/backlight/qcom-wled.c b/drivers/video/backlight/qcom-wled.c
index 4c8c34b994414..c25c31199952c 100644
--- a/drivers/video/backlight/qcom-wled.c
+++ b/drivers/video/backlight/qcom-wled.c
@@ -1287,14 +1287,6 @@ static const struct wled_var_cfg wled4_string_i_limit_cfg = {
 	.size = ARRAY_SIZE(wled4_string_i_limit_values),
 };
 
-static const struct wled_var_cfg wled3_string_cfg = {
-	.size = 8,
-};
-
-static const struct wled_var_cfg wled4_string_cfg = {
-	.size = 16,
-};
-
 static const struct wled_var_cfg wled5_mod_sel_cfg = {
 	.size = 2,
 };
-- 
2.25.1

