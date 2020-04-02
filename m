Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F9FE19C9B0
	for <lists+stable@lfdr.de>; Thu,  2 Apr 2020 21:16:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729549AbgDBTQ6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Apr 2020 15:16:58 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:50272 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388571AbgDBTQ6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Apr 2020 15:16:58 -0400
Received: by mail-wm1-f66.google.com with SMTP id t128so4662320wma.0
        for <stable@vger.kernel.org>; Thu, 02 Apr 2020 12:16:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VpbOaOtIIxM0qlnpSC/R72ufsSNvdYgk1tUvm25+WkY=;
        b=ViZxw2ffnRsvv/6mq2hQHzwWaZj5ZhCT9B52pphcZe+5dVuqm5GAoKuwl6qPz5WZaS
         PmBpJ4k5WKnTlliKsRJTRQ2GiRUWwxPky0wBigzSCeAHFzR0onNWUDdZpDJSCp6rLhHG
         7x0EB50JrlT8HLSmvPHdeO4zhKSpTlsGmBHvFxTkT1Nm19uHuyqhOz6On8B630dDoYHM
         p9Xmk+iD0KcTeNvF1yefo595cA37JMw8ZPvYetmUlR4yPwnNL4KAfbB1nNA16vbX/4md
         DeSY9+xYyGv4uXQNvNmBFZxyDXhXwZt5/NDF78A9KBPNbZSWvQRnsaaw7B2arLz5k69X
         XoyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VpbOaOtIIxM0qlnpSC/R72ufsSNvdYgk1tUvm25+WkY=;
        b=EmQgrBmaHFuN+rL2OQmVMcj422jZcUeEEWkxvpu4z0s3T5MBPE6Yd2I4cTRyoB6Bcf
         sMKzzqTD5KOCFgYvT/dn/sLHpMr0zNi0CjQaNBX/WhRg26UxJndp+kxWf+zPKhC5jolg
         b3J+NKReqvwzx84XK+COMDXAroKLex1fSAHy9B4a2yEr0Kbbw/C8kQpAdA/FzTUB/BVe
         5IXNM5dyDLwB+ijCzs1YcdnoBiMloQe5Kc6y0T1knblTSI1qHibM4frdwXJdC6s6ItXC
         OJ2w+T7M8UwM6dsyYkzYh9Hrnc6oAJr7zJWMpY06NttY9DwhJqbWdXABPxlzVopnLcJx
         GCdQ==
X-Gm-Message-State: AGi0PuazWX9F//CLuOwq8rAEqdqgvCTWVg/hZm/YkzNtO4x5Ldt/p5zj
        6Rh6ZQPabhAmP9UzChIXkuApuEMoZr/Qjg==
X-Google-Smtp-Source: APiQypLzMVlDe74yfO+6SwIbYVWCAgDIvdeOiPUMdRyi3vLxn/m1IIBSSUpL4pbaYTN1IGqLpZEOFw==
X-Received: by 2002:a7b:c145:: with SMTP id z5mr4833855wmi.55.1585855015091;
        Thu, 02 Apr 2020 12:16:55 -0700 (PDT)
Received: from localhost.localdomain ([95.149.164.95])
        by smtp.gmail.com with ESMTPSA id y1sm879050wmd.14.2020.04.02.12.16.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2020 12:16:54 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Subject: [PATCH 4.9 01/24] clk: qcom: rcg: Return failure for RCG update
Date:   Thu,  2 Apr 2020 20:17:24 +0100
Message-Id: <20200402191747.789097-1-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Taniya Das <tdas@codeaurora.org>

[ Upstream commit 21ea4b62e1f3dc258001a68da98c9663a9dbd6c7 ]

In case of update config failure, return -EBUSY, so that consumers could
handle the failure gracefully.

Signed-off-by: Taniya Das <tdas@codeaurora.org>
Link: https://lkml.kernel.org/r/1557339895-21952-2-git-send-email-tdas@codeaurora.org
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/clk/qcom/clk-rcg2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/qcom/clk-rcg2.c b/drivers/clk/qcom/clk-rcg2.c
index d8601b138dc1e..29abb600d7e15 100644
--- a/drivers/clk/qcom/clk-rcg2.c
+++ b/drivers/clk/qcom/clk-rcg2.c
@@ -107,7 +107,7 @@ static int update_config(struct clk_rcg2 *rcg)
 	}
 
 	WARN(1, "%s: rcg didn't update its configuration.", name);
-	return 0;
+	return -EBUSY;
 }
 
 static int clk_rcg2_set_parent(struct clk_hw *hw, u8 index)
-- 
2.25.1

