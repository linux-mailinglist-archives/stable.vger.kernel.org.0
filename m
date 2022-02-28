Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A8604C6CE0
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 13:44:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236584AbiB1Mor (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 07:44:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234419AbiB1Mol (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 07:44:41 -0500
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEBE34705E
        for <stable@vger.kernel.org>; Mon, 28 Feb 2022 04:44:02 -0800 (PST)
Received: by mail-pg1-x52e.google.com with SMTP id c1so11247279pgk.11
        for <stable@vger.kernel.org>; Mon, 28 Feb 2022 04:44:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LWisg6Oh4GHR/KswpTeQPwr12khSI6Ztj7YPF2Wfszg=;
        b=qDj++Gwu/eEmp4bsP/+3bcnFlobpxn6RDmubKL2qGHAOl6r/F2Pkd/2ynCN7nKVazW
         UyKF2hUaVknYV8Y/e5JVOXyGgVnOa5+YwUu6qpLHuuuaHlQmo3701W9NuNMJbPoW+ojj
         Wu8k/aJuc0HKP0C16YHrOFE9qsdBKXiEj+Jb1ihpYbI/+r9/bJE4ENH7O7p2yt8bkqNB
         p38oINaJc6rqfFbqi2Ta4zAiZ7L8h6aNnqf6ra0kXVPAhsWVyJRJWj0h/1Aiv3ysi/4m
         PtH03h9MOqq3BYmv0hiNGTWcGj3taADffjbJ+QUklZ90ClyyRzIVNPloYhRpTSA/Njkx
         kSrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LWisg6Oh4GHR/KswpTeQPwr12khSI6Ztj7YPF2Wfszg=;
        b=E0qwuw+5mElnMw/ORe2KiW0ULyb/LfjlsSm9QQQ9LQeNO/EPcLzUmplPQiYMLKfmuP
         8kUDmcan9BgfRxy4XcHdrb8RDaM4O73GuG/TZ1fVz0sB2cuVogxJkpExyvS9icR/uB4Y
         EGZCMQ8k+9/M0/nvImNDaPf76LKAz3RwV8AmTs2GZ5aTyDS2pEP4UWdth92VsVjZCN6Y
         Mf/IrZfhYXm8OtLfPd776ojjhzSZ0Bo50LHEu2U3KWrMO+hjxYDQug2dXvszkNoUGUoN
         7L9omwUGyIYFj3U+zMH7U6uicuE4ftMICp7QlTe/yEz84rTY2S6DCFDjrgTjvBxxmLhk
         9mvQ==
X-Gm-Message-State: AOAM531pPDQooX2s0L6gZO/8Bx+G6vqRuOqxBhDGvAd55iXcqNa9nQNf
        6HYxb6MJH7kfDpjfMVLIEPxY
X-Google-Smtp-Source: ABdhPJzKALtNtDDKSCZIDUXyMPg2/CMPUVBFtex+Uxa8tG1IHypCujeOrqq3UuuIi/ORjx7A14s2jQ==
X-Received: by 2002:a62:ab09:0:b0:4e0:d967:318f with SMTP id p9-20020a62ab09000000b004e0d967318fmr21755203pff.86.1646052242367;
        Mon, 28 Feb 2022 04:44:02 -0800 (PST)
Received: from localhost.localdomain ([117.207.25.37])
        by smtp.gmail.com with ESMTPSA id y12-20020a056a00190c00b004f39e28fb87sm14256737pfi.98.2022.02.28.04.43.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Feb 2022 04:44:02 -0800 (PST)
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     mhi@lists.linux.dev
Cc:     quic_hemantk@quicinc.com, quic_bbhatt@quicinc.com,
        quic_jhugo@quicinc.com, vinod.koul@linaro.org,
        bjorn.andersson@linaro.org, dmitry.baryshkov@linaro.org,
        quic_vbadigan@quicinc.com, quic_cang@quicinc.com,
        quic_skananth@quicinc.com, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, elder@linaro.org,
        Paul Davey <paul.davey@alliedtelesis.co.nz>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Hemant Kumar <hemantk@codeaurora.org>, stable@vger.kernel.org,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Subject: [PATCH v4 01/27] bus: mhi: Fix pm_state conversion to string
Date:   Mon, 28 Feb 2022 18:13:18 +0530
Message-Id: <20220228124344.77359-2-manivannan.sadhasivam@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220228124344.77359-1-manivannan.sadhasivam@linaro.org>
References: <20220228124344.77359-1-manivannan.sadhasivam@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
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

