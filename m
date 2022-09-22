Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B8735E6E28
	for <lists+stable@lfdr.de>; Thu, 22 Sep 2022 23:19:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231124AbiIVVTS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Sep 2022 17:19:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230189AbiIVVTR (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Sep 2022 17:19:17 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8666110B2C
        for <stable@vger.kernel.org>; Thu, 22 Sep 2022 14:19:15 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id c7so10404065pgt.11
        for <stable@vger.kernel.org>; Thu, 22 Sep 2022 14:19:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=1TPEKw6ZfZxcb8OW9aQyQDFvakhQrH+jPbGOfotODj8=;
        b=KhuQv1RlE5pzhaW2Ncp6oBIPecXlXGSFNtn6DBktCsSr5GPX9VKESG1uMfTxlILqzu
         IqDd2Xik6SSw8k6Z46JnVXkRAUpvG1QxwzLaH6lulE2cccjex0siS8xDsk7hhIL/KPLY
         JcSK/6Uz+LO8yi4QEr6UG3H3jKj0zn+PgtYV0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=1TPEKw6ZfZxcb8OW9aQyQDFvakhQrH+jPbGOfotODj8=;
        b=o2EIpBoylK4KmOYZWIi5JOlD9m0BtznK9NShVIORZnviCjs7CrRr0zfiSpq9waCzXk
         xo40REUY5FfvxflcsKCOta/P3C78OoPd+I1R7JikzpwlVthciCZpsEJbMcCMOJJh3c9i
         pRxzParBVd3VUElvDXuqv2h+1zKzLbgg4WBLILqP3HwPBAHYQASHuQgkbHSwjcwcjKty
         dPA9iL59stKJ1EU0jcrg8raJ9nL7HIoCXMQ1MW6PpQdvzxUFQQUWCCnJPiam8Vw9DPqt
         XUkAgZpk0ROuG//rzQkD7QGq+OBZk/a/u4W3QjoYwh5ja0q7B/nU3cs0I3dTBXi8WrSs
         TYKA==
X-Gm-Message-State: ACrzQf34zQrOrs8tauj6ua7CeTJ/ZboavEMk3ZygoDYsdmv/w/nHqFN2
        i9oTzRBmLvqJ9eDLfBaAFa8w8LlU4dZl5rRv
X-Google-Smtp-Source: AMsMyM6FtVEeH1ZubQUxEbxyq00UIUEPr3QFAZezIGRjNY1VCOqbP9csB0lrQZyDQ6RjLgknmW/sDQ==
X-Received: by 2002:a63:6c01:0:b0:429:ea6e:486d with SMTP id h1-20020a636c01000000b00429ea6e486dmr4643809pgc.247.1663881554644;
        Thu, 22 Sep 2022 14:19:14 -0700 (PDT)
Received: from tictac2.mtv.corp.google.com ([2620:15c:202:201:5321:6ad9:3932:13d8])
        by smtp.gmail.com with ESMTPSA id a7-20020a170902710700b00176ae5c0f38sm4549579pll.178.2022.09.22.14.19.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Sep 2022 14:19:14 -0700 (PDT)
From:   Douglas Anderson <dianders@chromium.org>
To:     stable@vger.kernel.org, gregkh@linuxfoundation.org
Cc:     Alex Elder <elder@linaro.org>, swboyd@chromium.org,
        Mike Tipton <mdtipton@codeaurora.org>,
        Georgi Djakov <djakov@kernel.org>,
        Douglas Anderson <dianders@chromium.org>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Georgi Djakov <georgi.djakov@linaro.org>,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
Subject: [5.10 PATCH] interconnect: qcom: icc-rpmh: Add BCMs to commit list in pre_aggregate
Date:   Thu, 22 Sep 2022 14:18:03 -0700
Message-Id: <20220922141725.5.10.1.I791715539cae1355e21827ca738b0b523a4a0f53@changeid>
X-Mailer: git-send-email 2.37.3.998.g577e59143f-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Tipton <mdtipton@codeaurora.org>

commit b95b668eaaa2574e8ee72f143c52075e9955177e upstream.

We're only adding BCMs to the commit list in aggregate(), but there are
cases where pre_aggregate() is called without subsequently calling
aggregate(). In particular, in icc_sync_state() when a node with initial
BW has zero requests. Since BCMs aren't added to the commit list in
these cases, we don't actually send the zero BW request to HW. So the
resources remain on unnecessarily.

Add BCMs to the commit list in pre_aggregate() instead, which is always
called even when there are no requests.

Signed-off-by: Mike Tipton <mdtipton@codeaurora.org>
[georgi: remove icc_sync_state for platforms with incomplete support]
Link: https://lore.kernel.org/r/20211125174751.25317-1-djakov@kernel.org
Signed-off-by: Georgi Djakov <djakov@kernel.org>
[dianders: dropped sm8350.c which isn't present in 5.10]
Signed-off-by: Douglas Anderson <dianders@chromium.org>
---
This should have been included in Alex Elder's request for patches
picked to 5.10 [1] but it was missed. Let's finally pick it up.

[1] https://lore.kernel.org/r/20220608205415.185248-3-elder@linaro.org

 drivers/interconnect/qcom/icc-rpmh.c | 10 +++++-----
 drivers/interconnect/qcom/sm8150.c   |  1 -
 drivers/interconnect/qcom/sm8250.c   |  1 -
 3 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/interconnect/qcom/icc-rpmh.c b/drivers/interconnect/qcom/icc-rpmh.c
index f6fae64861ce..27cc5f03611c 100644
--- a/drivers/interconnect/qcom/icc-rpmh.c
+++ b/drivers/interconnect/qcom/icc-rpmh.c
@@ -20,13 +20,18 @@ void qcom_icc_pre_aggregate(struct icc_node *node)
 {
 	size_t i;
 	struct qcom_icc_node *qn;
+	struct qcom_icc_provider *qp;
 
 	qn = node->data;
+	qp = to_qcom_provider(node->provider);
 
 	for (i = 0; i < QCOM_ICC_NUM_BUCKETS; i++) {
 		qn->sum_avg[i] = 0;
 		qn->max_peak[i] = 0;
 	}
+
+	for (i = 0; i < qn->num_bcms; i++)
+		qcom_icc_bcm_voter_add(qp->voter, qn->bcms[i]);
 }
 EXPORT_SYMBOL_GPL(qcom_icc_pre_aggregate);
 
@@ -44,10 +49,8 @@ int qcom_icc_aggregate(struct icc_node *node, u32 tag, u32 avg_bw,
 {
 	size_t i;
 	struct qcom_icc_node *qn;
-	struct qcom_icc_provider *qp;
 
 	qn = node->data;
-	qp = to_qcom_provider(node->provider);
 
 	if (!tag)
 		tag = QCOM_ICC_TAG_ALWAYS;
@@ -67,9 +70,6 @@ int qcom_icc_aggregate(struct icc_node *node, u32 tag, u32 avg_bw,
 	*agg_avg += avg_bw;
 	*agg_peak = max_t(u32, *agg_peak, peak_bw);
 
-	for (i = 0; i < qn->num_bcms; i++)
-		qcom_icc_bcm_voter_add(qp->voter, qn->bcms[i]);
-
 	return 0;
 }
 EXPORT_SYMBOL_GPL(qcom_icc_aggregate);
diff --git a/drivers/interconnect/qcom/sm8150.c b/drivers/interconnect/qcom/sm8150.c
index c76b2c7f9b10..b936196c229c 100644
--- a/drivers/interconnect/qcom/sm8150.c
+++ b/drivers/interconnect/qcom/sm8150.c
@@ -627,7 +627,6 @@ static struct platform_driver qnoc_driver = {
 	.driver = {
 		.name = "qnoc-sm8150",
 		.of_match_table = qnoc_of_match,
-		.sync_state = icc_sync_state,
 	},
 };
 module_platform_driver(qnoc_driver);
diff --git a/drivers/interconnect/qcom/sm8250.c b/drivers/interconnect/qcom/sm8250.c
index cc558fec74e3..40820043c8d3 100644
--- a/drivers/interconnect/qcom/sm8250.c
+++ b/drivers/interconnect/qcom/sm8250.c
@@ -643,7 +643,6 @@ static struct platform_driver qnoc_driver = {
 	.driver = {
 		.name = "qnoc-sm8250",
 		.of_match_table = qnoc_of_match,
-		.sync_state = icc_sync_state,
 	},
 };
 module_platform_driver(qnoc_driver);
-- 
2.37.3.998.g577e59143f-goog

