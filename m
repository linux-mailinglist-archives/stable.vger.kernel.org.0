Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC36C4B3717
	for <lists+stable@lfdr.de>; Sat, 12 Feb 2022 19:22:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229587AbiBLSVx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 12 Feb 2022 13:21:53 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:44742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229598AbiBLSVw (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 12 Feb 2022 13:21:52 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 121FB5418E
        for <stable@vger.kernel.org>; Sat, 12 Feb 2022 10:21:48 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id n19-20020a17090ade9300b001b9892a7bf9so2592649pjv.5
        for <stable@vger.kernel.org>; Sat, 12 Feb 2022 10:21:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=x7DQ/ZJ2gQOCs8afpwgV3IUsPGlYg0pNNMCW2zNhUO8=;
        b=WYLrcsL4z93Z79+6TZmR1sVn94tNgubl+JfaCtqejObohJL+hcAyUh2RWSDzlpwEr+
         1lsptBo9XrX0q94C9ENxJCybs2WAo4k5EOvR2VFZV6JhrIxtDcaX6hlxryb1/gWwI5c9
         3JyBQDEXfL5LwEbsdEbQj1/4nfsSZ3/ZEEEtdOaZhYjrLXIEkCGc8l2X3KYPqgAgR2re
         piR+uv8ZxFo9C1Z9rN07f1KomwTl/RO2BMuQZI3tvXo1XOg8+GVlyCxfbP0kEYpBk8L5
         1tjo/7gSqaywFI9hP8JPaAgTNsNA8v7gZC2cRTgu5CweLwyer/c1iy2df/nq9sJ9W0q1
         zPKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=x7DQ/ZJ2gQOCs8afpwgV3IUsPGlYg0pNNMCW2zNhUO8=;
        b=ZltlAJpG12pF/bjW/uTwCbDL/oKB4F2Won/lWOwr/ChwwJFwzC9dtloZ2JIfLxsWzD
         3htuhMaVgBf71J24W01fF3C37RuVJfquYFg1quDshpOSFSU3BlF3Dg+49B4YO9F760In
         z5aIOd1UUF7V7vOa4fV0mNTTpHuQ21Iei8lR+L7qTtJ592Qkc16QSp5M4ZqTBeIoM7C/
         Ww+L//GVoI/Ee5AVAJxj4YtjhD+v1drOoSNakjyssrSbwKhkFIPPnFRauDJRdFiZ+8gA
         ug5aCaM5Zv/6hiVW7yQ3ZsYtloOrfywpsmipM2g99uzKiEoS/84aHvsdBxxDxprLrrFb
         Hocw==
X-Gm-Message-State: AOAM532zIiTG4ZV3DEta3r9Q+V5Z4oP7kVtbu3K72+98Lmv2uQy/Yw5V
        Nh9xQiIn+3OERhyem1n8YEeC
X-Google-Smtp-Source: ABdhPJwjJuEzA3rG6VR1TZ2r3vKn3OMJXR3L5Y4wVNt3Gz785c7ZEDqOc9RN+ePb0Lq/fNq4vW0iPw==
X-Received: by 2002:a17:902:bcca:: with SMTP id o10mr6894783pls.147.1644690107434;
        Sat, 12 Feb 2022 10:21:47 -0800 (PST)
Received: from localhost.localdomain ([27.111.75.57])
        by smtp.gmail.com with ESMTPSA id g12sm14961987pfj.148.2022.02.12.10.21.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Feb 2022 10:21:47 -0800 (PST)
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
Subject: [PATCH v3 01/25] bus: mhi: Fix pm_state conversion to string
Date:   Sat, 12 Feb 2022 23:50:53 +0530
Message-Id: <20220212182117.49438-2-manivannan.sadhasivam@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220212182117.49438-1-manivannan.sadhasivam@linaro.org>
References: <20220212182117.49438-1-manivannan.sadhasivam@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
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

Fixes: a6e2e3522f29 ("bus: mhi: core: Add support for PM state transitions")
Signed-off-by: Paul Davey <paul.davey@alliedtelesis.co.nz>
Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>
Reviewed-by: Hemant Kumar <hemantk@codeaurora.org>
Cc: stable@vger.kernel.org
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
---
 drivers/bus/mhi/core/init.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/bus/mhi/core/init.c b/drivers/bus/mhi/core/init.c
index 046f407dc5d6..af484b03558a 100644
--- a/drivers/bus/mhi/core/init.c
+++ b/drivers/bus/mhi/core/init.c
@@ -79,10 +79,12 @@ static const char * const mhi_pm_state_str[] = {
 
 const char *to_mhi_pm_state_str(enum mhi_pm_state state)
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
-- 
2.25.1

