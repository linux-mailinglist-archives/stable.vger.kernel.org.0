Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D75646CF94
	for <lists+stable@lfdr.de>; Wed,  8 Dec 2021 09:57:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230019AbhLHJBW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Dec 2021 04:01:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229996AbhLHJBV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Dec 2021 04:01:21 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC05EC0617A1
        for <stable@vger.kernel.org>; Wed,  8 Dec 2021 00:57:49 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id np3so1438290pjb.4
        for <stable@vger.kernel.org>; Wed, 08 Dec 2021 00:57:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1EzMU1kpZf0bNg61CaR9yKQ9ZNHq6WXaiAA1psC5/yI=;
        b=AgpOPNIEZLpQH0s7NeLG68U79wF1of/nvkIn1bOSSn16ocuEh6HZ6Kf/zPjwrgwNiJ
         BQgAKYC5ZG6h1pmqNvVCScZPqJ8jjlXZBaOO8EmqTUM6+ePBQHWswF2oNY0ZSfn3vtb2
         f6mAazl/Qb/iZiIqTWtzGJki+kb0xOM0BGzpFxHXBKyfdVlM9KjB26c97U8HUq/ohLn5
         PwCkWpdXHb2gq1HMyI6UzmXJJbLTHZ0jTesDKO13EG5q4rodUb9kx3Qfe+yu2Y/oqvS/
         Dl/LgNzysrAAnxhQ+qtTuU6qYmENEutwnTM8lFYPzxVyJ4HtGmvdGzV2PceHeUHRayBD
         kh9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1EzMU1kpZf0bNg61CaR9yKQ9ZNHq6WXaiAA1psC5/yI=;
        b=rHPBQYVB3jkn1wUpb06cJegzSfFp0ZyQ9f66/sFzw4uKXq7kms8IsXSOczpYBt2v9k
         LaAJMq82wfEyKbX1x0t/30f/b0HnptT7SiFfbqiOIsfQ9etIUkgwBiQ0DldhwLBZ1P9E
         6+W4g+IEsNHNjUfLlLV1eAXQAVv9F+PfZkQ8C7GI5XlmzZ2xK5Lot86puUZQsDuZGN7j
         I/uBNBNadxk5WgBofsJoBlkbZw/gue111UTmuCCwtri7E0L6ksXQx8keFrbSEf0q83+9
         lXD6uuewXAZ6Qjwzsm8XC7kbL5PUN6WlK2NWkER43JB34JuVggYQ97Cbderbf3Sjsll1
         cbzQ==
X-Gm-Message-State: AOAM5313119NrlyI9RC+XHt8xG7ZQH5kC6VnrpiIYNg6a2sDsrs+2rjt
        T1d3z8FBPmajW+xFN9LW8Xzd
X-Google-Smtp-Source: ABdhPJxZI4pTJ7WlnK0xCbgwlNFyX2LzGi4PCg1p5Zh8m90wYE+o+TINUlIZ1HsMZNn/XvE78NEnIA==
X-Received: by 2002:a17:902:7c8a:b0:143:bb4a:7bb3 with SMTP id y10-20020a1709027c8a00b00143bb4a7bb3mr58485986pll.46.1638953869226;
        Wed, 08 Dec 2021 00:57:49 -0800 (PST)
Received: from localhost.localdomain ([117.202.189.59])
        by smtp.gmail.com with ESMTPSA id oa17sm2055470pjb.37.2021.12.08.00.57.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Dec 2021 00:57:48 -0800 (PST)
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     gregkh@linuxfoundation.org
Cc:     mhi@lists.linux.dev, hemantk@codeaurora.org, bbhatt@codeaurora.org,
        loic.poulain@linaro.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, ath11k@lists.infradead.org,
        linux-wireless@vger.kernel.org, kvalo@codeaurora.org,
        stable@vger.kernel.org, Pengyu Ma <mapengyu@gmail.com>,
        Kalle Valo <kvalo@kernel.org>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Subject: [PATCH 1/1] bus: mhi: core: Add support for forced PM resume
Date:   Wed,  8 Dec 2021 14:27:35 +0530
Message-Id: <20211208085735.196394-2-manivannan.sadhasivam@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211208085735.196394-1-manivannan.sadhasivam@linaro.org>
References: <20211208085735.196394-1-manivannan.sadhasivam@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Loic Poulain <loic.poulain@linaro.org>

For whatever reason, some devices like QCA6390, WCN6855 using ath11k
are not in M3 state during PM resume, but still functional. The
mhi_pm_resume should then not fail in those cases, and let the higher
level device specific stack continue resuming process.

Add a new parameter to mhi_pm_resume, to force resuming, whatever the
current MHI state is. This fixes a regression with non functional
ath11k WiFi after suspend/resume cycle on some machines.

Bug report: https://bugzilla.kernel.org/show_bug.cgi?id=214179

Fixes: 020d3b26c07a ("bus: mhi: Early MHI resume failure in non M3 state")
Cc: stable@vger.kernel.org #5.13
Link: https://lore.kernel.org/regressions/871r5p0x2u.fsf@codeaurora.org/
Reported-by: Kalle Valo <kvalo@codeaurora.org>
Reported-by: Pengyu Ma <mapengyu@gmail.com>
Tested-by: Kalle Valo <kvalo@kernel.org>
Acked-by: Kalle Valo <kvalo@kernel.org>
Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
[mani: Added comment, bug report, reported-by tags and CCed stable]
Link: https://lore.kernel.org/r/20211206161059.107007-1-manivannan.sadhasivam@linaro.org
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
---
 drivers/bus/mhi/core/pm.c             | 10 +++++++---
 drivers/bus/mhi/pci_generic.c         |  2 +-
 drivers/net/wireless/ath/ath11k/mhi.c |  6 +++++-
 include/linux/mhi.h                   |  3 ++-
 4 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/drivers/bus/mhi/core/pm.c b/drivers/bus/mhi/core/pm.c
index fb99e3727155..8a486374d57a 100644
--- a/drivers/bus/mhi/core/pm.c
+++ b/drivers/bus/mhi/core/pm.c
@@ -881,7 +881,7 @@ int mhi_pm_suspend(struct mhi_controller *mhi_cntrl)
 }
 EXPORT_SYMBOL_GPL(mhi_pm_suspend);
 
-int mhi_pm_resume(struct mhi_controller *mhi_cntrl)
+int mhi_pm_resume(struct mhi_controller *mhi_cntrl, bool force)
 {
 	struct mhi_chan *itr, *tmp;
 	struct device *dev = &mhi_cntrl->mhi_dev->dev;
@@ -898,8 +898,12 @@ int mhi_pm_resume(struct mhi_controller *mhi_cntrl)
 	if (MHI_PM_IN_ERROR_STATE(mhi_cntrl->pm_state))
 		return -EIO;
 
-	if (mhi_get_mhi_state(mhi_cntrl) != MHI_STATE_M3)
-		return -EINVAL;
+	if (mhi_get_mhi_state(mhi_cntrl) != MHI_STATE_M3) {
+		dev_warn(dev, "Resuming from non M3 state (%s)\n",
+			 TO_MHI_STATE_STR(mhi_get_mhi_state(mhi_cntrl)));
+		if (!force)
+			return -EINVAL;
+	}
 
 	/* Notify clients about exiting LPM */
 	list_for_each_entry_safe(itr, tmp, &mhi_cntrl->lpm_chans, node) {
diff --git a/drivers/bus/mhi/pci_generic.c b/drivers/bus/mhi/pci_generic.c
index 4c577a731709..3394819e8115 100644
--- a/drivers/bus/mhi/pci_generic.c
+++ b/drivers/bus/mhi/pci_generic.c
@@ -962,7 +962,7 @@ static int __maybe_unused mhi_pci_runtime_resume(struct device *dev)
 		return 0; /* Nothing to do at MHI level */
 
 	/* Exit M3, transition to M0 state */
-	err = mhi_pm_resume(mhi_cntrl);
+	err = mhi_pm_resume(mhi_cntrl, false);
 	if (err) {
 		dev_err(&pdev->dev, "failed to resume device: %d\n", err);
 		goto err_recovery;
diff --git a/drivers/net/wireless/ath/ath11k/mhi.c b/drivers/net/wireless/ath/ath11k/mhi.c
index 26c7ae242db6..f1f2fa2d690d 100644
--- a/drivers/net/wireless/ath/ath11k/mhi.c
+++ b/drivers/net/wireless/ath/ath11k/mhi.c
@@ -533,7 +533,11 @@ static int ath11k_mhi_set_state(struct ath11k_pci *ab_pci,
 		ret = mhi_pm_suspend(ab_pci->mhi_ctrl);
 		break;
 	case ATH11K_MHI_RESUME:
-		ret = mhi_pm_resume(ab_pci->mhi_ctrl);
+		/* Do force MHI resume as some devices like QCA6390, WCN6855
+		 * are not in M3 state but they are functional. So just ignore
+		 * the MHI state while resuming.
+		 */
+		ret = mhi_pm_resume(ab_pci->mhi_ctrl, true);
 		break;
 	case ATH11K_MHI_TRIGGER_RDDM:
 		ret = mhi_force_rddm_mode(ab_pci->mhi_ctrl);
diff --git a/include/linux/mhi.h b/include/linux/mhi.h
index 723985879035..102303288cee 100644
--- a/include/linux/mhi.h
+++ b/include/linux/mhi.h
@@ -660,8 +660,9 @@ int mhi_pm_suspend(struct mhi_controller *mhi_cntrl);
 /**
  * mhi_pm_resume - Resume MHI from suspended state
  * @mhi_cntrl: MHI controller
+ * @force: Force resuming to M0 irrespective of the device MHI state
  */
-int mhi_pm_resume(struct mhi_controller *mhi_cntrl);
+int mhi_pm_resume(struct mhi_controller *mhi_cntrl, bool force);
 
 /**
  * mhi_download_rddm_image - Download ramdump image from device for
-- 
2.25.1

