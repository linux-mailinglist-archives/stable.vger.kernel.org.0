Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 299291B4313
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 13:20:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726821AbgDVLUX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 07:20:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726809AbgDVLUW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Apr 2020 07:20:22 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ACD9C03C1A8
        for <stable@vger.kernel.org>; Wed, 22 Apr 2020 04:20:22 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id j2so1909336wrs.9
        for <stable@vger.kernel.org>; Wed, 22 Apr 2020 04:20:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NOfGgcTiWADSg1kaZeJWpioqsrn+8/pbHvDt5GKLgns=;
        b=M2XylByeilRldT27eCzzcVYoKl7S7d8LFXqVBiwq7f9ZJcVTMfvybTTz1vQ99PA+Zh
         Qa4/bydA6nrCFWozdX/laOENufcTFuOYdZ81cpCZbP9Y1emnnxqkVQlh1SMdk5/I5iSp
         zOQtMfJhj9CBZRMpEik00HP18/FzS+x2TuBuk306o7qyLdioYa6BT0eOXHU0mEDh3tlZ
         vudII/r+onS7AgXfF92MbuPiDFahb34c7XrWBf6yRqvbSfXDv25F7gVuxUZJuD/jCXng
         8uOg84Z+dVKoPB2fr4hvTtt1aZRmtrGCyQzWXzaYU+8Uoiq/oNB0UgYzITnrpg8NXYEX
         vZYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NOfGgcTiWADSg1kaZeJWpioqsrn+8/pbHvDt5GKLgns=;
        b=Oeyc6CawfaMmkF6uGw49GhY9i9Z771ui0iiKMl8SxDq3/8L5KLHR27xpJwqYtsCkk6
         5QXwMFwZPuZr26h9deWTEYWELqU/9e+xY03c7T9Ku5swrnyhGYARMlLnXG/KIIihj6jc
         zzQFClvCzzcyFgeG6EP1sQP5YsufyOW2Jr37blQP4+pDOm8elyU0HBGfe4iqzpbjy9+C
         fzCURmP8qDzDGlELFvXRoLkyy7RwwAIQE25XIZaL4dkwk7GAJdco6fc9rT/fBiC1wRO5
         FARvDDhlPG7+uZL/KfIw/H1k/jXJWfk1j96EAeoHD0UhWajXVZJL9fAqwsQuYV7aDZw2
         /Dlg==
X-Gm-Message-State: AGi0PuYy7sEcdyeOJ8WctMfCF5vDKgYKuXUxOlmAX15Bh1vp0C94/JNS
        4o6jNPA5eMITbWfJNjGQ5QKj3jdTYjQ=
X-Google-Smtp-Source: APiQypIVA5h+bM6Hwe+ax3mQTmy8+O9Vabcgh8Wq09Fo//nuY1fDvSns5awejItArzVfAVxnftW3jA==
X-Received: by 2002:adf:e586:: with SMTP id l6mr25053936wrm.184.1587554420947;
        Wed, 22 Apr 2020 04:20:20 -0700 (PDT)
Received: from localhost.localdomain ([2.31.163.63])
        by smtp.gmail.com with ESMTPSA id n6sm8247255wrs.81.2020.04.22.04.20.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Apr 2020 04:20:20 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Cc:     Subhash Jadavani <subhashj@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 4.9 14/21] scsi: ufs: ufs-qcom: remove broken hci version quirk
Date:   Wed, 22 Apr 2020 12:19:50 +0100
Message-Id: <20200422111957.569589-15-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200422111957.569589-1-lee.jones@linaro.org>
References: <20200422111957.569589-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Subhash Jadavani <subhashj@codeaurora.org>

[ Upstream commit 69a6fff068567469c0ef1156ae5ac8d3d71701f0 ]

UFSHCD_QUIRK_BROKEN_UFS_HCI_VERSION is only applicable for QCOM UFS host
controller version 2.x.y and this has been fixed from version 3.x.y
onwards, hence this change removes this quirk for version 3.x.y onwards.

[mkp: applied by hand]

Signed-off-by: Subhash Jadavani <subhashj@codeaurora.org>
Signed-off-by: Asutosh Das <asutoshd@codeaurora.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/ufs/ufs-qcom.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufs-qcom.c b/drivers/scsi/ufs/ufs-qcom.c
index 51d559214db60..1fe193590b8bd 100644
--- a/drivers/scsi/ufs/ufs-qcom.c
+++ b/drivers/scsi/ufs/ufs-qcom.c
@@ -1094,7 +1094,7 @@ static void ufs_qcom_advertise_quirks(struct ufs_hba *hba)
 		hba->quirks |= UFSHCD_QUIRK_BROKEN_LCC;
 	}
 
-	if (host->hw_ver.major >= 0x2) {
+	if (host->hw_ver.major == 0x2) {
 		hba->quirks |= UFSHCD_QUIRK_BROKEN_UFS_HCI_VERSION;
 
 		if (!ufs_qcom_cap_qunipro(host))
-- 
2.25.1

