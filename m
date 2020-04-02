Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C089019C97C
	for <lists+stable@lfdr.de>; Thu,  2 Apr 2020 21:11:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389224AbgDBTLj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Apr 2020 15:11:39 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:55493 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731689AbgDBTLj (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Apr 2020 15:11:39 -0400
Received: by mail-wm1-f66.google.com with SMTP id r16so4609259wmg.5
        for <stable@vger.kernel.org>; Thu, 02 Apr 2020 12:11:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=rizpshgRSVswJNtjW2UZ/pm8CNXM39+z2QpqQR8eHr8=;
        b=fYhkKqZm/pPmdPk67spI3EjYS3skZCNKAxBDtNoWwknyhXMVs1QLwn6rj7OZNAMeM8
         vdttxOkxxbBZI3XAaazlVKJw6wHKiq1a2bNzROdl1Fg+uNTXb/sJO5kiE2fi+oX0B9Y1
         mQhKkY/v2/YpYMAxeMokI1HOOXaOZyMKHqQlKZvcz0uK1f2ypI0xYJIBA3hQ4GriZNm9
         jlxO0UjCt+DuElLOP4IFzcnWlwn1aHEs1j6iSPpiG7Tk6uQzfKl1DLRlnXUck1OPUJFz
         3h65rmYjcVm5rCCq8rjb4mfHxCh/KE9drl4Wm/+DJZ8mcQFVNnmAdXjW47Gn7uv/9hM7
         8hRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rizpshgRSVswJNtjW2UZ/pm8CNXM39+z2QpqQR8eHr8=;
        b=NRGHH2o0lWnpoDZf8aFLqKT649TDR7vaZP2zOaBYWP5po8In2Kaxr2yeQGSqxbs7Ed
         tTpBE9QUp/wZc0GMhmfNqQZz/1EE+2qLYv1zhMeutbnvMSwysCrgOTAdUwA5fzHyj9tU
         mXoB3v7kMGxregkBHm9CKht+Sl/90RqWGSeEqi4YB57H6F9tSyf5wLKo+mw5Mqdoiq7Y
         nXXRC0K3dVmgG/Vmns189j5GTy4Od05evqiknM45eAeOMrFmHHUPibIfft/kDvakGQFj
         5jOZBzE7+frgTZhYsI2Sw/YfZ99bfsIl0Q4YEi1feuYjab+d0rfXnzMyQ6S0u/MXnam8
         h0gw==
X-Gm-Message-State: AGi0PuZTH/xU3uletRMkXp7FQWL/C2MdC7tGVySX9qizJZm+wABQr0Lh
        juRXSxr9aD47O8TqPgM9TYIkJHvRzIMQiA==
X-Google-Smtp-Source: APiQypJflW9Wbdga//xMAXLUIXGFXs9d4XFyVNilxNCUeuhYZUjnDNQe6rBI27dVKyapvNm9QnBhkg==
X-Received: by 2002:a1c:41d4:: with SMTP id o203mr4652372wma.1.1585854694388;
        Thu, 02 Apr 2020 12:11:34 -0700 (PDT)
Received: from localhost.localdomain ([95.149.164.95])
        by smtp.gmail.com with ESMTPSA id s15sm8442164wrt.16.2020.04.02.12.11.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2020 12:11:33 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Subject: [PATCH 4.19 07/14] wil6210: add general initialization/size checks
Date:   Thu,  2 Apr 2020 20:12:13 +0100
Message-Id: <20200402191220.787381-7-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200402191220.787381-1-lee.jones@linaro.org>
References: <20200402191220.787381-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexei Avshalom Lazar <ailizaro@codeaurora.org>

[ Upstream commit ac0e541ab2f2951845acee784ef487be40fb4c77 ]

Initialize unset variable, and verify that mid is valid.

Signed-off-by: Alexei Avshalom Lazar <ailizaro@codeaurora.org>
Signed-off-by: Maya Erez <merez@codeaurora.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/net/wireless/ath/wil6210/debugfs.c | 2 ++
 drivers/net/wireless/ath/wil6210/wmi.c     | 2 +-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/wil6210/debugfs.c b/drivers/net/wireless/ath/wil6210/debugfs.c
index 44296c0159252..acd95ca0430b9 100644
--- a/drivers/net/wireless/ath/wil6210/debugfs.c
+++ b/drivers/net/wireless/ath/wil6210/debugfs.c
@@ -991,6 +991,8 @@ static ssize_t wil_write_file_txmgmt(struct file *file, const char __user *buf,
 	int rc;
 	void *frame;
 
+	memset(&params, 0, sizeof(params));
+
 	if (!len)
 		return -EINVAL;
 
diff --git a/drivers/net/wireless/ath/wil6210/wmi.c b/drivers/net/wireless/ath/wil6210/wmi.c
index 8a603432f5317..3928b13ae0266 100644
--- a/drivers/net/wireless/ath/wil6210/wmi.c
+++ b/drivers/net/wireless/ath/wil6210/wmi.c
@@ -2802,7 +2802,7 @@ static void wmi_event_handle(struct wil6210_priv *wil,
 
 		if (mid == MID_BROADCAST)
 			mid = 0;
-		if (mid >= wil->max_vifs) {
+		if (mid >= ARRAY_SIZE(wil->vifs) || mid >= wil->max_vifs) {
 			wil_dbg_wmi(wil, "invalid mid %d, event skipped\n",
 				    mid);
 			return;
-- 
2.25.1

