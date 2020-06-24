Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 643C0207689
	for <lists+stable@lfdr.de>; Wed, 24 Jun 2020 17:04:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404345AbgFXPEq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jun 2020 11:04:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404339AbgFXPEo (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Jun 2020 11:04:44 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2B6FC061795
        for <stable@vger.kernel.org>; Wed, 24 Jun 2020 08:04:43 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id f139so2844660wmf.5
        for <stable@vger.kernel.org>; Wed, 24 Jun 2020 08:04:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2m2sUpZpH0jbtcmYyVNBHchLvKZgU+7xWa4xsqTn03E=;
        b=PruqKI5rmzrEACi4Yw4FtuSd9KORHRlamVPBe3qqmkvNpFexwSdnG4SfgHltKStskh
         mva5w7RUtjo3uJjAaI+cNW5KHVSgyGm6ZovablsXX1U9W9K4v+NyOkE72Byf+dTKKkgE
         KOiaRHTpCyuRsf5J4jAvNqqmU5btGJgwguhNQ1BnWbgdjRr0p5D4jtr91lroWU6vR32F
         GCrDJDEiF8/7dfj64lTWImISFa4Np+pVFYTSpf4pdqvc65aSjeHo5ob/hmAWaljIMH3r
         IggB0GwSnJRl6TjfzWrKX7nxh1UouC0/BKxUinGbWcmXeU2MgDrLsAVtrnjkOC5zhHKr
         ZfEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2m2sUpZpH0jbtcmYyVNBHchLvKZgU+7xWa4xsqTn03E=;
        b=obWS0nLqK5y4obA5Tz0UL/GZp6ha2BvweFyk2WJMFMig25GDGr0bK6qpVOKDBWZ8Ih
         5g15agOJ1N3pPsu5bAp8NKPcp5K++UaKjWYGnSaPyUZ+CrF9BS7o673N6LM3Gps+3q6J
         GLAtSvgCjyddn/p0xfQoLQ23qyFvmRxZSeRBSrQ0b5Iw6IievZTmIXEnRJyIgEWLUzAT
         fpZ/jZdOkGun6PgU++i42dnFF8rMZx8EhI3+dZEs2orKbzCHV5hyvMUrfx1lxjE2x6tN
         zMJB2qEg13xDvkvkh9PwpnkeF0sBpLKvKK+v5hSra2LN2c7Qo7GMfBamblCCacbXfiVe
         j5rA==
X-Gm-Message-State: AOAM530KytPa9leNhiVLedPbXWSJ5ZRLl6olRcq88EvOWUrUW2akY7VC
        oQ39F6LdLOBcT8lc5rOmOEGxPg==
X-Google-Smtp-Source: ABdhPJxniWUuhOK6ni3DT7xPMV5Jy7/0VJHnvI3QDRXhrWY/QDvZQXT5F80At1ygpltfaC/n543E1A==
X-Received: by 2002:a1c:c90a:: with SMTP id f10mr17453319wmb.121.1593011081473;
        Wed, 24 Jun 2020 08:04:41 -0700 (PDT)
Received: from localhost.localdomain ([2.27.35.144])
        by smtp.gmail.com with ESMTPSA id f186sm8200319wmf.29.2020.06.24.08.04.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jun 2020 08:04:40 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     daniel.thompson@linaro.org, jingoohan1@gmail.com,
        dri-devel@lists.freedesktop.org, linux-fbdev@vger.kernel.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>, stable@vger.kernel.org,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: [PATCH 1/8] backlight: lms501kf03: Remove unused const variables
Date:   Wed, 24 Jun 2020 15:57:14 +0100
Message-Id: <20200624145721.2590327-2-lee.jones@linaro.org>
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

W=1 kernel build reports:

 drivers/video/backlight/lms501kf03.c:96:28: warning: ‘seq_sleep_in’ defined but not used [-Wunused-const-variable=]
 96 | static const unsigned char seq_sleep_in[] = {
 | ^~~~~~~~~~~~
 drivers/video/backlight/lms501kf03.c:92:28: warning: ‘seq_up_dn’ defined but not used [-Wunused-const-variable=]
 92 | static const unsigned char seq_up_dn[] = {
 | ^~~~~~~~~

Either 'seq_sleep_in' nor 'seq_up_dn' have been used since the
driver first landed in 2013.

Cc: <stable@vger.kernel.org>
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/video/backlight/lms501kf03.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/video/backlight/lms501kf03.c b/drivers/video/backlight/lms501kf03.c
index 8ae32e3573c1a..c1bd02bb8b2ee 100644
--- a/drivers/video/backlight/lms501kf03.c
+++ b/drivers/video/backlight/lms501kf03.c
@@ -89,14 +89,6 @@ static const unsigned char seq_rgb_gamma[] = {
 	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
 };
 
-static const unsigned char seq_up_dn[] = {
-	0x36, 0x10,
-};
-
-static const unsigned char seq_sleep_in[] = {
-	0x10,
-};
-
 static const unsigned char seq_sleep_out[] = {
 	0x11,
 };
-- 
2.25.1

