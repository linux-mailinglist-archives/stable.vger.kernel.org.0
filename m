Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5465B19C9DB
	for <lists+stable@lfdr.de>; Thu,  2 Apr 2020 21:20:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389520AbgDBTSR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Apr 2020 15:18:17 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:41393 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389476AbgDBTSR (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Apr 2020 15:18:17 -0400
Received: by mail-wr1-f66.google.com with SMTP id h9so5601881wrc.8
        for <stable@vger.kernel.org>; Thu, 02 Apr 2020 12:18:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=zrPB6cAFd5XV8pyviHVkoiOoCpAxetUL1P7L3ieH4sE=;
        b=bJGBLOqJxH8YRyDxGVy+FYGXtIxurmaQxN6c/PpLYBdMH4hGE03zsh1xUxATaI6Fjn
         /c9diVAn7LlTsv0ipURzPjkqMr2w9mJ2qjeIFhf3UzOjVDg95+plgImAjCYiKCWjr2m9
         C1GL5tsshQ7fxudULjowSHZ9hencyPH62kTxv0K6+pO7hnrzDepPGIn64GyKfx3RtP6Q
         E2ThDZfpcS5a3I4zrgDQBB8flTQlUXAgkexIkXkcKA7WD8IFeIxTl/T2tm6UZUEeRsJ9
         nYF8n6wtp9XKN5AZw0ABaMNt524DDukjhbhyuPJZMW6zAfbL19L7d4yOYciTWkJd+ACy
         2q5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zrPB6cAFd5XV8pyviHVkoiOoCpAxetUL1P7L3ieH4sE=;
        b=l6Tuo50KAXMM+9k/9HRbePB9vk+0oyZzmRmWouI9zySEasZJC+qAtZ4s0Pe4fckPY7
         8cymE9xiQ7z/J0GaDZpfF3h76pJH/mKo+n0R4klyEBvldFDZFqS/97DQZZaOufj6dfJA
         7C+yl5jwsuHmpMz6CziJzOXcQYVvj0Dp1jxTwFmxixt6cONBQADhrIstDdlqSFWopzjc
         WWVuJP1rOSyruq9TVXK/EPfldwbVqHjMOmb7KU/nGXvwIiUX6k4Ma4Yt90jJr3mNaYmP
         cruE8aGCBVJKugSSnVa1n+RGxlF7s0CzrUoGUsgdAfA9AplSTml8f4Gq3s0NtKmarvrn
         a36Q==
X-Gm-Message-State: AGi0PuZ2TpICTyX/39UDyw9Qsejpp+ZSPkuqQ9ZT30PIKWrXD2ehrBej
        X4iy6wySscEU92Xc5+WaTgOC2yCm7RiSaQ==
X-Google-Smtp-Source: APiQypLzkMaYQw7t5x1tA8wTCJUY+p7FE8fKMotAommeTi6fO1wKOjsyroTTpqhW7ZqUUTbl5f/Uow==
X-Received: by 2002:a5d:674f:: with SMTP id l15mr4894399wrw.196.1585855095320;
        Thu, 02 Apr 2020 12:18:15 -0700 (PDT)
Received: from localhost.localdomain ([95.149.164.95])
        by smtp.gmail.com with ESMTPSA id l10sm8622707wrq.95.2020.04.02.12.18.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2020 12:18:14 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Subject: [PATCH 4.4 13/20] scsi: ufs: ufs-qcom: remove broken hci version quirk
Date:   Thu,  2 Apr 2020 20:18:49 +0100
Message-Id: <20200402191856.789622-13-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200402191856.789622-1-lee.jones@linaro.org>
References: <20200402191856.789622-1-lee.jones@linaro.org>
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

