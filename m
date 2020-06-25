Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54FFC2099FA
	for <lists+stable@lfdr.de>; Thu, 25 Jun 2020 08:46:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390150AbgFYGqb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Jun 2020 02:46:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390139AbgFYGq3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Jun 2020 02:46:29 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BEDCC0613ED
        for <stable@vger.kernel.org>; Wed, 24 Jun 2020 23:46:28 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id r12so4559738wrj.13
        for <stable@vger.kernel.org>; Wed, 24 Jun 2020 23:46:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1zDIqOBuX/K9nmAOrSn0q1L2wjLhGu0LGpqC1FRybjM=;
        b=Y8Xeawii/FenN4QcJc/IU0tymI/82VPhOUVQnNDaPq1E1ZUSPPJGiqS/MwnjdXwHqF
         DvzQqbo+ZusoZvWe7XMRMfOASefHh3I5kfGUIJesheA46gvTr9m5Bqd+xZteU8fuyZhP
         JSMH36/+uTAtUSckplXY/J74fUfskmrkT+h4Rhi+lPqKjkcu4Wns0XCu97A4qjsByUoy
         jz6zZaDVI542NxSheQJrNCq2C4ZWaDr3ZAnsBJYX3DPUVqApykF4HUHAiUYbaN/9wj+i
         v6qGmM7UjH2mb2rrDfpY33gZQo57z3084ZjyupmsBOU9C1cwoWJFWcQi9s8RezQqnSAO
         XnhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1zDIqOBuX/K9nmAOrSn0q1L2wjLhGu0LGpqC1FRybjM=;
        b=ggkaTmvxoeD82/Bv+tUp5AUVBVYGNE34etDpi1dvIsDcNOxsXL+UDub2m0gQdSx9RR
         AwThVt73qfBa8afSKeS9QQBf70BxlxZQIpAby3PYKlRP7aAxEsoYRn5SK4/0FZjnt6jh
         9XpooTkkRDyuNXKF1vJgUSV+L32G7sOyHyClakmze6pVly63D2JCPxoAmIJBqiHmqzvh
         cLb+W3SELp0vxqCKUl/XhK8tTGpN8/R66SxgE0whie0BnXVjFO/UF2qVz224slvRvm2Q
         AuudYfghpk/QJgn08UXDPZJB1ED9B7Nh5Y4iHEH37LCRuVt4JAVDlXGTjblRtoG2Wk7Z
         mF6Q==
X-Gm-Message-State: AOAM530BvntTWDOy0bm0wKSIVGmK1JYJeC21gDZCerUkpInQeujbPgpi
        iLtexd0ijJzFV31nfX7ghuVOVXYwK7U=
X-Google-Smtp-Source: ABdhPJxEEnd+kP3e/yI6hTgHbHGpzO3CUk9z4hOSjDsZ9PiZZ75O0/GISD/HaIfyxC2QMquELbwWWA==
X-Received: by 2002:adf:828b:: with SMTP id 11mr37504223wrc.58.1593067586920;
        Wed, 24 Jun 2020 23:46:26 -0700 (PDT)
Received: from localhost.localdomain ([2.27.35.144])
        by smtp.gmail.com with ESMTPSA id c20sm27235363wrb.65.2020.06.24.23.46.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jun 2020 23:46:26 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 03/10] mfd: db8500-prcmu: Add description for 'reset_reason' in kerneldoc
Date:   Thu, 25 Jun 2020 07:46:12 +0100
Message-Id: <20200625064619.2775707-4-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200625064619.2775707-1-lee.jones@linaro.org>
References: <20200625064619.2775707-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Each function parameter should be documented in kerneldoc format.

Squashes the following W=1 warnings:

 drivers/mfd/db8500-prcmu.c:2281: warning: Function parameter or member 'reset_code' not described in 'db8500_prcmu_system_reset'
 drivers/mfd/db8500-prcmu.c:3012: warning: Function parameter or member 'pdev' not described in 'db8500_prcmu_probe'

Cc: <stable@vger.kernel.org>
Cc: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mfd/db8500-prcmu.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/mfd/db8500-prcmu.c b/drivers/mfd/db8500-prcmu.c
index 0452b43b04232..9b58b02967638 100644
--- a/drivers/mfd/db8500-prcmu.c
+++ b/drivers/mfd/db8500-prcmu.c
@@ -2276,6 +2276,8 @@ bool db8500_prcmu_is_ac_wake_requested(void)
  *
  * Saves the reset reason code and then sets the APE_SOFTRST register which
  * fires interrupt to fw
+ *
+ * @reset_code: The reason for system reset
  */
 void db8500_prcmu_system_reset(u16 reset_code)
 {
-- 
2.25.1

