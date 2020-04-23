Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A1951B65A0
	for <lists+stable@lfdr.de>; Thu, 23 Apr 2020 22:40:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726864AbgDWUkd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 16:40:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726183AbgDWUkd (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Apr 2020 16:40:33 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E284DC09B042
        for <stable@vger.kernel.org>; Thu, 23 Apr 2020 13:40:32 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id f13so8188266wrm.13
        for <stable@vger.kernel.org>; Thu, 23 Apr 2020 13:40:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zrPB6cAFd5XV8pyviHVkoiOoCpAxetUL1P7L3ieH4sE=;
        b=mKEgLkWFHibVnCee1zXAPg6qOvKFjI16ZjiwSuHjiiukRj5eDBgsm+OpYKvRLijjj/
         RJ7T13jM2+NsmuEMUCyQBhAk/6Ke6/akT4xqoLDtSlHlzatpBEquAg/6bAkXepMpjS4a
         rJcT9M+1bho17Yqx8jVyAalXg/snCxC6CSvyaneFzpaNfJTAEGOQ4GFoiBZTYsEWJquZ
         Y04CnjNml614rIazT6K5jqRY90rHTYRFwBA/NAKAD0Z8M9iWp1pNAmPi7/Q+YbVIu15Y
         IbGLDk/FET3uqAVcw98gzrb0KU2OfmmKhEtkzt7wQJM5sqE3HtWFOYTh+3+lP3y8zwpp
         KfAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zrPB6cAFd5XV8pyviHVkoiOoCpAxetUL1P7L3ieH4sE=;
        b=ThMblvp3KhrAr8USVZV2hn/vXoEDuMak0mX9vpEPg/QAq3VEcHW3nTOXSNYaeMVuZ7
         L78pkqXvdk3+rXHYCc8hAvnQAGFSKM3WUdKphmu0Lxz4um3RxQ3CKG8Z197M5vQkSIxi
         xQJmXju3BOl0beq+cJGU3cwG9KITyipZfSvsEdojBvZ8xiyHYm8Ckox3I3+h5+dw8CbW
         5TFSEuSQNdSL/g6HYUcCOhTp+io1DH5cnidC/O2sHOSEyITQ+Tbj7winHa5i2ukiSxXS
         hpPmnaAJWqJKDIlxpsovUWLYyUgqC3kfg41sAVTZButqCiOFbP+aERH/Thz5JZGAbRuo
         O54w==
X-Gm-Message-State: AGi0PuZQ747s/jxGYv+jQdG/SCjVH+Eser17AObJYX5yRIuWm90QsSoh
        eAj9Uot+Ckk7zR54ED0P1jq03I4hN/8=
X-Google-Smtp-Source: APiQypLVTNtCD4LDWDjDp/3SJ3J75cU3ItiV3sbah5fvZD+aiiBPARhtn1MajZecs4RwqrSlg74vcw==
X-Received: by 2002:a5d:438c:: with SMTP id i12mr6946976wrq.14.1587674431402;
        Thu, 23 Apr 2020 13:40:31 -0700 (PDT)
Received: from localhost.localdomain ([2.31.163.63])
        by smtp.gmail.com with ESMTPSA id u17sm5933726wra.63.2020.04.23.13.40.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Apr 2020 13:40:30 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Cc:     Subhash Jadavani <subhashj@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 4.4 11/16] scsi: ufs: ufs-qcom: remove broken hci version quirk
Date:   Thu, 23 Apr 2020 21:40:09 +0100
Message-Id: <20200423204014.784944-12-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200423204014.784944-1-lee.jones@linaro.org>
References: <20200423204014.784944-1-lee.jones@linaro.org>
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
index 4b82c3765e013..2b779a55f6999 100644
--- a/drivers/scsi/ufs/ufs-qcom.c
+++ b/drivers/scsi/ufs/ufs-qcom.c
@@ -1032,7 +1032,7 @@ static void ufs_qcom_advertise_quirks(struct ufs_hba *hba)
 		hba->quirks |= UFSHCD_QUIRK_BROKEN_LCC;
 	}
 
-	if (host->hw_ver.major >= 0x2) {
+	if (host->hw_ver.major == 0x2) {
 		hba->quirks |= UFSHCD_QUIRK_BROKEN_UFS_HCI_VERSION;
 
 		if (!ufs_qcom_cap_qunipro(host))
-- 
2.25.1

