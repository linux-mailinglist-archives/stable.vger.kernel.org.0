Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CA1D41531D
	for <lists+stable@lfdr.de>; Wed, 22 Sep 2021 23:59:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238128AbhIVWAa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Sep 2021 18:00:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237834AbhIVWA3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Sep 2021 18:00:29 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20D67C061574;
        Wed, 22 Sep 2021 14:58:59 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id nn5-20020a17090b38c500b0019af1c4b31fso3413779pjb.3;
        Wed, 22 Sep 2021 14:58:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rMBeU/71xEPqn3ZCfK2c1H6EFmFZ1vtxEagd/NgluDo=;
        b=nJaJX1L1Jc9ae4su39y8VecCuh+/vHKtQhHDFIEl/e/OHm5irOXp0pW/1pjT8n7vZ6
         gO7FOn4jlZEDWeHDtm5aUFzfUPviM7bObmILAY1RGRrAgqP1tZDD0ClK8wkhsyM8fBpL
         rV0xtol3/Cz9KGWMevriO5Joh36NTEFcwYfnp4BMeoi8cnMQYTvPj55Th6HF4gS8J0T+
         CG7Lb/wdVlLkLrnf7thPDtIOgtG0eUlAwPzYWkLstFpO+sm5nMpDoRWymzL5vQ6gLWcJ
         xk0EvEPUJwrIqZgxQye9gIwR3fPw3P3/JRqHgpQ5dh9P7ZN3vOaL2Hnp2WCaIfkXQwzl
         eF+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rMBeU/71xEPqn3ZCfK2c1H6EFmFZ1vtxEagd/NgluDo=;
        b=dzzpcXHrin2q5tUfdghsGMTzhp+CuKePhE1loqfq1dK1wKsPg7Dhz76UTxHD6ScUpK
         LcSN5Rvrvhk4U4iFrVNvSqpUyCD2RrflH+mFlqMMLv1RUd6IWir94LcI5/zLvdG5UsAh
         9y3WazKiq5ou50VbCt/gJNY2iB1iDe/gOmK9ZFOuW/JJ5OhbcPs19b2YkD3Qaf7z1gUK
         KRMuYr8Vl8ByVu7uPqE1RglubHg5uSnlFCZlx01hX7aCmI0W1Wk93+PeYfwHPuJYKQ8J
         BSGpdv+AHy0OF5JjxWwZYIITb+kzyFzbinFR+qIMwfxB5RJmlEKZ8//cA9nUHCOhJG7D
         RuGw==
X-Gm-Message-State: AOAM5338lSS3iwGV1rE7xt5xlSwqynscijmLWhwxaUOq5LXNeTRyuS1o
        TVmC9588NrxDVp9ZSBd3I5vjyaXu4yI=
X-Google-Smtp-Source: ABdhPJzpAheJ6Ku5Z/vFaZMTZsvnC1yk9Gkgs3akEYvrhjtlQLoDpKkSnHu+7wcqZgAsjL0fMArFAA==
X-Received: by 2002:a17:902:e04d:b0:13a:70c9:11b8 with SMTP id x13-20020a170902e04d00b0013a70c911b8mr1164001plx.82.1632347938124;
        Wed, 22 Sep 2021 14:58:58 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id x10sm6516891pjv.57.2021.09.22.14.58.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Sep 2021 14:58:57 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Russell King <linux@armlinux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        linux-arm-kernel@lists.infradead.org (moderated list:ARM PORT)
Subject: [PATCH stable 5.4] ARM: Qualify enabling of swiotlb_init()
Date:   Wed, 22 Sep 2021 14:58:51 -0700
Message-Id: <20210922215851.312769-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit fcf044891c84e38fc90eb736b818781bccf94e38 upstream

We do not need a SWIOTLB unless we have DRAM that is addressable beyond
the arm_dma_limit. Compare max_pfn with arm_dma_pfn_limit to determine
whether we do need a SWIOTLB to be initialized.

Fixes: ad3c7b18c5b3 ("arm: use swiotlb for bounce buffering on LPAE configs")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/arm/mm/init.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/arm/mm/init.c b/arch/arm/mm/init.c
index 0804a6af4a3b..5a3641b5ec2c 100644
--- a/arch/arm/mm/init.c
+++ b/arch/arm/mm/init.c
@@ -469,7 +469,11 @@ static void __init free_highpages(void)
 void __init mem_init(void)
 {
 #ifdef CONFIG_ARM_LPAE
-	swiotlb_init(1);
+	if (swiotlb_force == SWIOTLB_FORCE ||
+	    max_pfn > arm_dma_pfn_limit)
+		swiotlb_init(1);
+	else
+		swiotlb_force = SWIOTLB_NO_FORCE;
 #endif
 
 	set_max_mapnr(pfn_to_page(max_pfn) - mem_map);
-- 
2.25.1

