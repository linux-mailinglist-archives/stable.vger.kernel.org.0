Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C3BB4C8FA2
	for <lists+stable@lfdr.de>; Tue,  1 Mar 2022 17:03:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235927AbiCAQEO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Mar 2022 11:04:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235833AbiCAQEO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Mar 2022 11:04:14 -0500
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83FE14F470
        for <stable@vger.kernel.org>; Tue,  1 Mar 2022 08:03:32 -0800 (PST)
Received: by mail-pf1-x432.google.com with SMTP id x18so14623760pfh.5
        for <stable@vger.kernel.org>; Tue, 01 Mar 2022 08:03:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=B4HQIz/J+/sI71tT6M7lHjdtrG3oK0wX/s2SF3OsKnU=;
        b=aowF1TXHFNf7eJTjRZ26E0NXWUb3EGwH6HbbBJ4OscsFDFILj2zOO4aQNgZtO/4dFU
         hHZ00gVBBnrHq3nHc6qg0FGCGUfUi/T8klS+ggk8PCWA1tBS4wjNX16pbxfqF/cGSrO6
         l2+x7ZBlfmGQv00GhtDtkyWskn749KVXGwmeNHGr5kyerqB/8INFYy+z5LS6Im43Lbv6
         c9j7I7zGN2W35iYE+jvsQ3LoLIGhGR0TJXW+835JDEtJKue5vSyXhhJJza7vF2ZVjGrM
         vQYRyvFSmioy5ALOVMooI2gWZBB9I7fg75U8Vugsetm7uXi2n9YAsyWebYafaj6MXCbT
         ZhJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=B4HQIz/J+/sI71tT6M7lHjdtrG3oK0wX/s2SF3OsKnU=;
        b=54k7sMcMaB3nNkAAmct5duK2AQ4Vqtkq0hljs1mePpvpC7nP4WdDmbUJMiW2N5ufLo
         pJ/p9/HuWCJ1h2FkiJ7G7lVrOv7n+c2fsEf+aX+U5NFBL5aBl6TinFNPqh2GQAhjze74
         FsePYY8UqqA8hsTxOxhXYhrhjM92vAoUxB2j/DkniW9Hen7t661I6KBubaiuURMUyH0F
         U1YMwm2JXhLFG7miZavPVQmV8Fj8TRBFNStT4apgieHbSVamiPgIZHAbRCG24Wi/O25M
         SQIghihwobDmxCqsJXvxiHdxbZmLi4gzBYEyEl5UlI5KHv2QkWYObY/vxyV1K85oSLfk
         wIsA==
X-Gm-Message-State: AOAM530eKLIY1/LjwqtyDCeHvQdHu/MSI+zMHpXY/wVSDHQSZHoZwRaN
        TniGbYAkb/BPnwdjqNEw1rS2oVR2Q3Ch
X-Google-Smtp-Source: ABdhPJwvjGMPRRuS7LuU6p4RW3QzqXOQ5EpNjPObcQeqyvk1jyQJUwRuAGvp2nj5uA+ZiButi7/7Gg==
X-Received: by 2002:a62:cdc3:0:b0:4e0:e439:ed2d with SMTP id o186-20020a62cdc3000000b004e0e439ed2dmr27896929pfg.39.1646150611723;
        Tue, 01 Mar 2022 08:03:31 -0800 (PST)
Received: from localhost.localdomain ([117.207.25.80])
        by smtp.gmail.com with ESMTPSA id m17-20020a17090a859100b001bc20ddcc67sm2489530pjn.34.2022.03.01.08.03.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Mar 2022 08:03:31 -0800 (PST)
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     gregkh@linuxfoundation.org
Cc:     mhi@lists.linux.dev, quic_hemantk@quicinc.com,
        quic_bbhatt@quicinc.com, elder@linaro.org,
        paul.davey@alliedtelesis.co.nz,
        Manivannan Sadhasivam <mani@kernel.org>,
        Hemant Kumar <hemantk@codeaurora.org>, stable@vger.kernel.org,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Subject: [PATCH 02/10] bus: mhi: Fix pm_state conversion to string
Date:   Tue,  1 Mar 2022 21:33:00 +0530
Message-Id: <20220301160308.107452-3-manivannan.sadhasivam@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220301160308.107452-1-manivannan.sadhasivam@linaro.org>
References: <20220301160308.107452-1-manivannan.sadhasivam@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul Davey <paul.davey@alliedtelesis.co.nz>

On big endian architectures the mhi debugfs files which report pm state
give "Invalid State" for all states.  This is caused by using
find_last_bit which takes an unsigned long* while the state is passed in
as an enum mhi_pm_state which will be of int size.

Fix by using __fls to pass the value of state instead of find_last_bit.

Also the current API expects "mhi_pm_state" enumerator as the function
argument but the function only works with bitmasks. So as Alex suggested,
let's change the argument to u32 to avoid confusion.

Fixes: a6e2e3522f29 ("bus: mhi: core: Add support for PM state transitions")
Signed-off-by: Paul Davey <paul.davey@alliedtelesis.co.nz>
Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>
Reviewed-by: Hemant Kumar <hemantk@codeaurora.org>
Reviewed-by: Alex Elder <elder@linaro.org>
Cc: stable@vger.kernel.org
[mani: changed the function argument to u32]
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
---
 drivers/bus/mhi/core/init.c     | 10 ++++++----
 drivers/bus/mhi/core/internal.h |  2 +-
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/bus/mhi/core/init.c b/drivers/bus/mhi/core/init.c
index 046f407dc5d6..09394a1c29ec 100644
--- a/drivers/bus/mhi/core/init.c
+++ b/drivers/bus/mhi/core/init.c
@@ -77,12 +77,14 @@ static const char * const mhi_pm_state_str[] = {
 	[MHI_PM_STATE_LD_ERR_FATAL_DETECT] = "Linkdown or Error Fatal Detect",
 };
 
-const char *to_mhi_pm_state_str(enum mhi_pm_state state)
+const char *to_mhi_pm_state_str(u32 state)
 {
-	unsigned long pm_state = state;
-	int index = find_last_bit(&pm_state, 32);
+	int index;
 
-	if (index >= ARRAY_SIZE(mhi_pm_state_str))
+	if (state)
+		index = __fls(state);
+
+	if (!state || index >= ARRAY_SIZE(mhi_pm_state_str))
 		return "Invalid State";
 
 	return mhi_pm_state_str[index];
diff --git a/drivers/bus/mhi/core/internal.h b/drivers/bus/mhi/core/internal.h
index e2e10474a9d9..3508cbbf555d 100644
--- a/drivers/bus/mhi/core/internal.h
+++ b/drivers/bus/mhi/core/internal.h
@@ -622,7 +622,7 @@ void mhi_free_bhie_table(struct mhi_controller *mhi_cntrl,
 enum mhi_pm_state __must_check mhi_tryset_pm_state(
 					struct mhi_controller *mhi_cntrl,
 					enum mhi_pm_state state);
-const char *to_mhi_pm_state_str(enum mhi_pm_state state);
+const char *to_mhi_pm_state_str(u32 state);
 int mhi_queue_state_transition(struct mhi_controller *mhi_cntrl,
 			       enum dev_st_transition state);
 void mhi_pm_st_worker(struct work_struct *work);
-- 
2.25.1

