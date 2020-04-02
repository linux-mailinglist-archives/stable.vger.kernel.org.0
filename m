Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9F8019C998
	for <lists+stable@lfdr.de>; Thu,  2 Apr 2020 21:13:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389376AbgDBTNS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Apr 2020 15:13:18 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:37320 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388766AbgDBTNS (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Apr 2020 15:13:18 -0400
Received: by mail-wm1-f67.google.com with SMTP id j19so4940414wmi.2
        for <stable@vger.kernel.org>; Thu, 02 Apr 2020 12:13:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=b9U0M3sx67B1Gb7lifHPL1pZ9q1gXirVR2CbXmiCZYc=;
        b=gLCAIEbr/NIZ8tuWHgwnkc8dFjRhukku+JVuBLnZlDQFHRACrfFEUurlE9FXn4CzdQ
         G0k4T311cr5OL6lb9oPUjqP21SRucaTl7Cu5GWl/rYhTW8UDBzkwPoCjR94N7o/jcNbM
         Hp/xGUkxutidmkCYopet4iTnVx8sQTi0vMctej+i/NTWbrdHLYeBtzRmiUAGZXp47yby
         vChs7n38ElBnuVHEqcQgMfCe5F1VFH/Apt2xQy2smEmU+YvEwdFrzpd5cn5iK2Xp3JgA
         0X9ilT56O8iK4TnkC0ZrvmXjqAogTl8OcJOw4awG+oTEMSr04L9tth//sd60lTiIhkF8
         GXjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=b9U0M3sx67B1Gb7lifHPL1pZ9q1gXirVR2CbXmiCZYc=;
        b=H22PjvmGnfAW8m8+DNjo/815P+aogChO9Jpx8a3TOM1BOA1WFATDfUjyuP1G+ic7T+
         GpDv5gmCEWpDpP/D30U1y8taiF+CF1RWUIW3n61000/vNsqggml8790u9DftiWIx7yph
         f4j9SVrFk2CXMj9pOnepqnOZvbupIgEDQSmYgLEKTCSBMiPxUNqBmQYiA/HSnx82Uj38
         BNI+ZRqvvLqlXIDNXWqmNsQOPhl26iYxwgBEISrVPHbp0Fg9pn8QRpag8p+UPDm5bmwO
         yYiuFdSQX7N1L5uklwjoMSNG13NZZPIDs10T1cRa+644S6DJd4EdWGwuY9T3x20NvDHi
         vK1w==
X-Gm-Message-State: AGi0PuYUWmbja7JhqpvvUQ+7vGMFEzmrc7xtPaQW6lz4zQkvqDjUIRsW
        +CVM4E1zTI0uenPsHD6cbkWdETUDwcvAQw==
X-Google-Smtp-Source: APiQypKp1hAHw4V9h2KiMMDjZUkCDIyn5KUYFJd1DL5runi3P8SncLqDhi7pL70/iehxyrQD5dyRhQ==
X-Received: by 2002:a05:600c:da:: with SMTP id u26mr5142877wmm.117.1585854796210;
        Thu, 02 Apr 2020 12:13:16 -0700 (PDT)
Received: from localhost.localdomain ([95.149.164.95])
        by smtp.gmail.com with ESMTPSA id y12sm5511514wrn.55.2020.04.02.12.13.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2020 12:13:15 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Subject: [PATCH 4.14 17/33] scsi: ufs: ufs-qcom: remove broken hci version quirk
Date:   Thu,  2 Apr 2020 20:13:37 +0100
Message-Id: <20200402191353.787836-17-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200402191353.787836-1-lee.jones@linaro.org>
References: <20200402191353.787836-1-lee.jones@linaro.org>
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

