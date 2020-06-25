Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 574642099F8
	for <lists+stable@lfdr.de>; Thu, 25 Jun 2020 08:46:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390108AbgFYGq0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Jun 2020 02:46:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389962AbgFYGqZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Jun 2020 02:46:25 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 195A2C061573
        for <stable@vger.kernel.org>; Wed, 24 Jun 2020 23:46:25 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id a6so4611139wrm.4
        for <stable@vger.kernel.org>; Wed, 24 Jun 2020 23:46:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=L7/cDxvGdffp0R1d8Bbrv1z7a+JwOkzEK0KwjgT2NxE=;
        b=BCmUEtT5UTfVuC8CblpswRBGT7MKphCIGdncmeha98yeFZF1RxkE4l+xGv/tGqHYum
         OA7y8Haiw+RQimK4Bda7ht6soHr43nbRuSKpQJKow84aunLep803VCuEqWLD4Pw5JD0X
         96eXzyQsx45dx26MXUnpGnDy3jpxvAk/wDI/hOHxeUYKXagFUmKRFRU2OagSbsHl0qGt
         3hqH62/Q/B/G57ZQng+i5vaGJeaL08Uf6dM6WYvSIGm4WjFfLQhGVxxCjI7i1u91A4xL
         YpMRNTBntLVloYGvv2ibyEIZ80NwV+J19HiToZeKVO4vSmFhN16plNct104f+WeRmk81
         jkJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=L7/cDxvGdffp0R1d8Bbrv1z7a+JwOkzEK0KwjgT2NxE=;
        b=Q3N8SdrnQKXKMsX46W9kHEQqgEh5EgUnbB8Bb/RzbIJjHs5jQkl3QaUjmRKQb52avu
         S/A05fzUHpywr5FK6W83yipDblr8oGBm9H1mSNV6z1r5tnn2RzXyuq7+2fbC4+TQGtzJ
         t3jZYK6hNvcXalRZHtawCRRALDk0wZmjyM/H1knp3MWQ2twQbxF+oTG9ibYQMXM4mLxT
         uhNImdPLPrfTo/NpA1fE+yzr/EcrIJIFTZZAFWZ3K51G+fc6BfKbbtjFngd5niWu1Z88
         uRTs9Ps18M8fFTjN3nDOm7TlCozHmvw2BV2KQ6VK9NUUIqyYy9/RSw3EfaG8vS0VfoQg
         nFrQ==
X-Gm-Message-State: AOAM5311n0LvJy+N2SPX4wBhZpumTF6MVJLaknQERQJM9M96RDK5YeII
        IXvp/VA9zpTwBRU/H+8HWsAJqw==
X-Google-Smtp-Source: ABdhPJwYRYFfBlmw34OzXGBG+xQkUxeApPE1s2gVR8CHohOClUiwjOu3so0VAMYdMW4pAEGmwpbrDQ==
X-Received: by 2002:adf:8b18:: with SMTP id n24mr37002049wra.372.1593067583753;
        Wed, 24 Jun 2020 23:46:23 -0700 (PDT)
Received: from localhost.localdomain ([2.27.35.144])
        by smtp.gmail.com with ESMTPSA id c20sm27235363wrb.65.2020.06.24.23.46.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jun 2020 23:46:23 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, patches@opensource.cirrus.com
Subject: [PATCH 01/10] mfd: wm8350-core: Supply description wm8350_reg_{un}lock args
Date:   Thu, 25 Jun 2020 07:46:10 +0100
Message-Id: <20200625064619.2775707-2-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200625064619.2775707-1-lee.jones@linaro.org>
References: <20200625064619.2775707-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Kerneldoc syntax is used, but not complete.  Descriptions required.

Prevents warnings like:

 drivers/mfd/wm8350-core.c:136: warning: Function parameter or member 'wm8350' not described in 'wm8350_reg_lock'
 drivers/mfd/wm8350-core.c:165: warning: Function parameter or member 'wm8350' not described in 'wm8350_reg_unlock'

Cc: <stable@vger.kernel.org>
Cc: patches@opensource.cirrus.com
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mfd/wm8350-core.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/mfd/wm8350-core.c b/drivers/mfd/wm8350-core.c
index 42b16503e6cd1..fbc77b218215c 100644
--- a/drivers/mfd/wm8350-core.c
+++ b/drivers/mfd/wm8350-core.c
@@ -131,6 +131,8 @@ EXPORT_SYMBOL_GPL(wm8350_block_write);
  * The WM8350 has a hardware lock which can be used to prevent writes to
  * some registers (generally those which can cause particularly serious
  * problems if misused).  This function enables that lock.
+ *
+ * @wm8350: pointer to local driver data structure
  */
 int wm8350_reg_lock(struct wm8350 *wm8350)
 {
@@ -160,6 +162,8 @@ EXPORT_SYMBOL_GPL(wm8350_reg_lock);
  * problems if misused).  This function disables that lock so updates
  * can be performed.  For maximum safety this should be done only when
  * required.
+ *
+ * @wm8350: pointer to local driver data structure
  */
 int wm8350_reg_unlock(struct wm8350 *wm8350)
 {
-- 
2.25.1

