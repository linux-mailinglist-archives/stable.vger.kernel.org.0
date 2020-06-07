Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A2771F0B44
	for <lists+stable@lfdr.de>; Sun,  7 Jun 2020 15:10:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726584AbgFGNKu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Jun 2020 09:10:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726474AbgFGNKt (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Jun 2020 09:10:49 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4AC3C08C5C2;
        Sun,  7 Jun 2020 06:10:48 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id mb16so15239746ejb.4;
        Sun, 07 Jun 2020 06:10:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MX/EH+yzBWn8lnHAP2qqU7wLOvhFMWrYnulg7lebjTQ=;
        b=JGqSh7xTSGCTwmqWpyH/EIVvTtUeUXKSxUMfRnj6g/gwjiAaArfRvidbM2j0z4WyOT
         wbW4ie4YzmfYHakTxXFxI5C5zi72vDOI4Pyfrj4cgxBuFcI3KG2sOtOUaxsxKQsgB6TJ
         91ZWDQ8Y+PNEU5ywTs0sZn3z+5caW7aYdrmfYWmpK23ptI9YDYPVLOESJyGt2jKNgSZs
         yykodSmV5tdyB3ZTtesh8G2TSZErmyjtuKjz7BsiYR8bJN1AygZz+fT+TdsjKs8FPE52
         6XztjgET/aA25rcb31+cUJ2oXMB0DDxx7VOsKRU7iVqB1ymopCtSxiBKemE9U9b/+AVr
         3R3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MX/EH+yzBWn8lnHAP2qqU7wLOvhFMWrYnulg7lebjTQ=;
        b=tIe6lAghfcAcRTPDyEf6JNMjYvMAN0nVC2UqJct+7TA2EUY/5AjQteYQx7bRgRAI9J
         g8k33BV4hWvTF+jB+g7BMt1tkGROzJwhAwx29afgSpJtrcO0Wo/dh3Ymki414v3mcP8i
         8FwZ44snx05j4rZUeRidsEmF3dX+kH8HsVVa49/S7vKJ60qGdT7f/aprvIwhRS8yi+ld
         xePTjeipgUSiBOh9oDaYlJQoCxQMrsMUNcBNouK9NUM26sbbdsSglZg+1wIxm1d1ZCBm
         wYgApsKPRMcKgLQHl3IcVaUhNpAmZMGfzB73/WhqMxQmn+3gqXI89LjjIbvTCIB6A6zI
         agTw==
X-Gm-Message-State: AOAM533NJ54gtKXs1R1RrMrmr2h8JF6HutXDezSCBC3gHW3+/lVj1rqT
        ml8BIPh81cE6aE2JeaD7ZEk=
X-Google-Smtp-Source: ABdhPJxEtsz38SPAOEW5T1+qoTrex7tTi646pKzpoR2FsB/ZnUnvaE0pGvgUiWZvL9LpswLvEtD0ow==
X-Received: by 2002:a17:906:b1c3:: with SMTP id bv3mr17354363ejb.292.1591535447335;
        Sun, 07 Jun 2020 06:10:47 -0700 (PDT)
Received: from localhost.localdomain (p200300f137189200428d5cfffeb99db8.dip0.t-ipconnect.de. [2003:f1:3718:9200:428d:5cff:feb9:9db8])
        by smtp.googlemail.com with ESMTPSA id v24sm8437933ejf.20.2020.06.07.06.10.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Jun 2020 06:10:46 -0700 (PDT)
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To:     tsbogend@alpha.franken.de, hauke@hauke-m.de,
        linux-mips@vger.kernel.org
Cc:     john@phrozen.org, linux-kernel@vger.kernel.org,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        stable@vger.kernel.org
Subject: [PATCH] MIPS: lantiq: xway: sysctrl: fix the GPHY clock alias names
Date:   Sun,  7 Jun 2020 15:10:23 +0200
Message-Id: <20200607131023.3136390-1-martin.blumenstingl@googlemail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The dt-bindings for the GSWIP describe that the node should be named
"switch". Use the same name in sysctrl.c so the GSWIP driver can
actually find the "gphy0" and "gphy1" clocks.

Fixes: 14fceff4771e51 ("net: dsa: Add Lantiq / Intel DSA driver for vrx200")
Cc: stable@vger.kernel.org
Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
 arch/mips/lantiq/xway/sysctrl.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/mips/lantiq/xway/sysctrl.c b/arch/mips/lantiq/xway/sysctrl.c
index aa37545ebe8f..b10342018d19 100644
--- a/arch/mips/lantiq/xway/sysctrl.c
+++ b/arch/mips/lantiq/xway/sysctrl.c
@@ -514,8 +514,8 @@ void __init ltq_soc_init(void)
 		clkdev_add_pmu("1e10b308.eth", NULL, 0, 0, PMU_SWITCH |
 			       PMU_PPE_DP | PMU_PPE_TC);
 		clkdev_add_pmu("1da00000.usif", "NULL", 1, 0, PMU_USIF);
-		clkdev_add_pmu("1e108000.gswip", "gphy0", 0, 0, PMU_GPHY);
-		clkdev_add_pmu("1e108000.gswip", "gphy1", 0, 0, PMU_GPHY);
+		clkdev_add_pmu("1e108000.switch", "gphy0", 0, 0, PMU_GPHY);
+		clkdev_add_pmu("1e108000.switch", "gphy1", 0, 0, PMU_GPHY);
 		clkdev_add_pmu("1e103100.deu", NULL, 1, 0, PMU_DEU);
 		clkdev_add_pmu("1e116000.mei", "afe", 1, 2, PMU_ANALOG_DSL_AFE);
 		clkdev_add_pmu("1e116000.mei", "dfe", 1, 0, PMU_DFE);
@@ -538,8 +538,8 @@ void __init ltq_soc_init(void)
 				PMU_SWITCH | PMU_PPE_DPLUS | PMU_PPE_DPLUM |
 				PMU_PPE_EMA | PMU_PPE_TC | PMU_PPE_SLL01 |
 				PMU_PPE_QSB | PMU_PPE_TOP);
-		clkdev_add_pmu("1e108000.gswip", "gphy0", 0, 0, PMU_GPHY);
-		clkdev_add_pmu("1e108000.gswip", "gphy1", 0, 0, PMU_GPHY);
+		clkdev_add_pmu("1e108000.switch", "gphy0", 0, 0, PMU_GPHY);
+		clkdev_add_pmu("1e108000.switch", "gphy1", 0, 0, PMU_GPHY);
 		clkdev_add_pmu("1e103000.sdio", NULL, 1, 0, PMU_SDIO);
 		clkdev_add_pmu("1e103100.deu", NULL, 1, 0, PMU_DEU);
 		clkdev_add_pmu("1e116000.mei", "dfe", 1, 0, PMU_DFE);
-- 
2.27.0

