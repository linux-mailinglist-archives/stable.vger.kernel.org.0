Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A9BD207696
	for <lists+stable@lfdr.de>; Wed, 24 Jun 2020 17:05:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404340AbgFXPEr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jun 2020 11:04:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404341AbgFXPEp (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Jun 2020 11:04:45 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9581C061798
        for <stable@vger.kernel.org>; Wed, 24 Jun 2020 08:04:43 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id g75so2635597wme.5
        for <stable@vger.kernel.org>; Wed, 24 Jun 2020 08:04:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=N4d9MV/8IVDi6H6NDx3txaJsaoNizmHMUDUqyGZyRwc=;
        b=emOdUiDeUe+KFeHCqP/4Vwih/dwJXxtgOfA8pOQGoiPOx4UIAFEj52mjFAk5DhMU86
         gT5Wkp7zH2kxwdj2nAgh4si1eNBmRt6zQrHV/KaItnIMe2juaJ0mQG5otPsahO1pCdPJ
         uNv7FOOfhL9aTrRneY9in0QBdNS0svXag+qoK1jXiCuIROyJEZl6vCMGfgtx9e1iQCaZ
         fTogXsdUIy5yY0iXLhZIm6MgIN9gDmrnno6dwDdaJSxcXxVh5LP/EdDdXAVtip1VfRmS
         Qvg6LFloU7LYSBu/IitxhtD60aQwVHctr3SlOUisidawyOoQ3WVkyHKCgnAfwUkNPuA6
         Jdqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=N4d9MV/8IVDi6H6NDx3txaJsaoNizmHMUDUqyGZyRwc=;
        b=S9xO5XmMAxv5FheEeQ2rLz1msmuABPWOOjN/ROB6OvMQ/cRqLwhKKKiejgY5Bbug+9
         aY1pogxTF7G8LZ9xFnCfL6EGWtlEmYnI4I8tWeyAvdYcQore4sGUr5E5aI72hF4RhykI
         scUcfQZwnAILiRuVodylRLC7VTJD+TX7zlMD5t/05hhl6Ui3JV89EbKgacmoIdpa5V82
         Ule7pd5QS7uZ1G+JmheUZevcUnPkAb0nMKcaXi6D8OS3xXtG0gPQAcZxZKeykMnc5OSG
         Uze1gUyluXNReDs/+DPzOUgFR7hYOdU3F/h2AKuQcSoNUxStqHTvjccTygZ0FZpZHtpU
         P1WQ==
X-Gm-Message-State: AOAM5323Y8zu6NSD2Zfx4x9zMOCJyZrHEpBvL9F98hKe6Lpawbg+8HNT
        ckXEDeY5OPCyE239dB/8ESZ9PA==
X-Google-Smtp-Source: ABdhPJygPsccHa5jOlhVGhJlJB4d/4S7eDfjo8Nvz6itCY61Cz7n4glf/TvzYk4QWergu4UvpagYdQ==
X-Received: by 2002:a05:600c:204d:: with SMTP id p13mr29834871wmg.88.1593011082536;
        Wed, 24 Jun 2020 08:04:42 -0700 (PDT)
Received: from localhost.localdomain ([2.27.35.144])
        by smtp.gmail.com with ESMTPSA id f186sm8200319wmf.29.2020.06.24.08.04.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jun 2020 08:04:41 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     daniel.thompson@linaro.org, jingoohan1@gmail.com,
        dri-devel@lists.freedesktop.org, linux-fbdev@vger.kernel.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>, stable@vger.kernel.org,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Jamey Hicks <jamey.hicks@hp.com>,
        Andrew Zabolotny <zap@homelink.ru>
Subject: [PATCH 2/8] backlight: lcd: Add missing kerneldoc entry for 'struct device parent'
Date:   Wed, 24 Jun 2020 15:57:15 +0100
Message-Id: <20200624145721.2590327-3-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200624145721.2590327-1-lee.jones@linaro.org>
References: <20200624145721.2590327-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This has been missing since the conversion to 'struct device' in 2007.

Cc: <stable@vger.kernel.org>
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: Jamey Hicks <jamey.hicks@hp.com>
Cc: Andrew Zabolotny <zap@homelink.ru>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/video/backlight/lcd.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/video/backlight/lcd.c b/drivers/video/backlight/lcd.c
index 78b0333586258..db56e465aaff3 100644
--- a/drivers/video/backlight/lcd.c
+++ b/drivers/video/backlight/lcd.c
@@ -179,6 +179,7 @@ ATTRIBUTE_GROUPS(lcd_device);
  * lcd_device_register - register a new object of lcd_device class.
  * @name: the name of the new object(must be the same as the name of the
  *   respective framebuffer device).
+ * @parent: pointer to the parent's struct device .
  * @devdata: an optional pointer to be stored in the device. The
  *   methods may retrieve it by using lcd_get_data(ld).
  * @ops: the lcd operations structure.
-- 
2.25.1

