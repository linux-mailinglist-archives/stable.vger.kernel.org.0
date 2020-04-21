Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A19E1B2667
	for <lists+stable@lfdr.de>; Tue, 21 Apr 2020 14:41:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728899AbgDUMlD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Apr 2020 08:41:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728915AbgDUMlC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Apr 2020 08:41:02 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92054C061A10
        for <stable@vger.kernel.org>; Tue, 21 Apr 2020 05:41:01 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id u127so3516521wmg.1
        for <stable@vger.kernel.org>; Tue, 21 Apr 2020 05:41:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=b9U0M3sx67B1Gb7lifHPL1pZ9q1gXirVR2CbXmiCZYc=;
        b=vGohs4E03peZwz1hFcr6NA31HpugyE4+F1ssTFPWuPQOiwhIDYhWEEuZU1szJNsLNW
         PFGDb5KUtm/hdH3o3haaneVED1YJLye+LgnZB0V8KvIU7anUDN0hQl5JLPlglu63bcrc
         AHA1DU+EO/uMJbegHJUQxNKUw6E6PTI7ufzdx3MSuGVlS3Yo2Hqeq71mKOs7emPIGxLj
         5Rl5z1izrKQPpQmxK5b9wW7BHEu2YcReVbLvGpZWVbyzG1jLMIgdD8NIyMp0CrcP/WtU
         +EyK6UwELiStEOZyGgk9lTcP9oSiAKPn1U87m7Z63TbvouESdb+VWEctBWM2bXjdQl6z
         VUmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=b9U0M3sx67B1Gb7lifHPL1pZ9q1gXirVR2CbXmiCZYc=;
        b=uX3GDf6x0+l4oSa0NMhTAFTI5XWpzAsXgx7BLMdvThOisjGLf/+pTAwKVcx4cF0JM6
         YsXwSdbPEfYMg3NQJCt/pwM8icSqkUz0tuDm/4HCfmOQe2kuTzaPV6w3vnE19j4Qoi6R
         grRgjtpBZUzjuyhUkBU0Fl36TjlchRG1EU639uMo/LssvVrgpBQPfI+U4G2eBFFnszar
         DS9BDYPW5IPXERNo+CO1loAzmqhiOz0AzEaSYkR5NzwgcTwS0fSU48YPNwL9KTQzZcOU
         TiC4XKhEXfrRcbzILeJXxSlkVOZHOoNou/fpxbbe+sbziLoI5O9Qyb+N3SYvheEjFi3+
         S/Wg==
X-Gm-Message-State: AGi0PuaFEKf9WNlpZZVD5bctMAvQlgRTNw9VcsaOhlpWUOIHKYwp3/fr
        NEe5tKlytIYjEuThTjPOqrh73u+C0m8=
X-Google-Smtp-Source: APiQypKWBLB4fKH3xpUaQ0c3shhEfuAzko1WiiferLjjGbk4SbKD7YGwfEEYCQyV9Ib0XmR2Dz5MIg==
X-Received: by 2002:a7b:c931:: with SMTP id h17mr5033926wml.105.1587472860164;
        Tue, 21 Apr 2020 05:41:00 -0700 (PDT)
Received: from localhost.localdomain ([2.31.163.63])
        by smtp.gmail.com with ESMTPSA id u3sm3408232wrt.93.2020.04.21.05.40.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Apr 2020 05:40:59 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Cc:     Subhash Jadavani <subhashj@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 4.14 11/24] scsi: ufs: ufs-qcom: remove broken hci version quirk
Date:   Tue, 21 Apr 2020 13:40:04 +0100
Message-Id: <20200421124017.272694-12-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200421124017.272694-1-lee.jones@linaro.org>
References: <20200421124017.272694-1-lee.jones@linaro.org>
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
index c87d770b519a7..f2b8de195d8af 100644
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

