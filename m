Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D246B19C994
	for <lists+stable@lfdr.de>; Thu,  2 Apr 2020 21:13:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389370AbgDBTNP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Apr 2020 15:13:15 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:35244 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389221AbgDBTNP (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Apr 2020 15:13:15 -0400
Received: by mail-wr1-f66.google.com with SMTP id g3so3292898wrx.2
        for <stable@vger.kernel.org>; Thu, 02 Apr 2020 12:13:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=1zvKr4FBn1gNdRzju8qn/rTiI5TQxwfOYmsvPx9Ax2k=;
        b=y/N5NcjM94pid4dLGEuCz390oPMHj/RwL8OoGAuuiX86pI7S3LnJJtDja6aXNEAVQB
         KhNTfm7AZDW/BtL3SaFlNaV+n/wEKRHCZgNtYrvzim9ASmHm6x8Z/dsyAF3U0dhq/Nxx
         7PK9dVnLl1bxPHHCdt+wmrwMYHO4KRoQrsx8SNSq4hQdxTzR0yW869o6ZmMjVQTEHLav
         ZFceFE5OmRLD4aeI4bEpB/7WHyHoTfEKyi+IvTwOuy4BqpYQZoMITJdRCTGJHe97J+Ti
         jDkxLM1KTM9sCSIXSOG7OyHgOB0ZNrpCD3nkU/8br8StVShpXmnyy1AAmqTNrM7n/N0C
         L0tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1zvKr4FBn1gNdRzju8qn/rTiI5TQxwfOYmsvPx9Ax2k=;
        b=XLgOCvVcsJvXRJ+twZRw98X+KOwtrLXHjW/vEWeMxSpCqgcRhitHvH+3Z7DMgoggSO
         +UQDsWacLG988mbamoAVW/sT0tFILnWNS83S5ClGQtnwu+IRvPxPnim2K8KGi2oyPZPI
         HL6CCRcQ7eHvfOGz+l1qeFiBuu1baiSaIKiG+P/sYl/MsEtqvCBV7FxR5XdjdaE0sZDV
         yEXdbFAxvGB9IV7KSROHxbNY6xpNUFQvGtC5fjV46wPsGO72poEIHdf694blxhBdgszC
         mgCrAPETOMMdH0fz2P0zSnVUorMdsDJrVxILoKOWBm1aDtL5loBlOyJibIj2C0piOW9G
         bEHw==
X-Gm-Message-State: AGi0PuZMacT2jq3LwayL8uCPm5m84HdQvXMYsnv3hCtnV17TI+8Glfz/
        GxlwaJzfYCmDYm6LkARC7HadW4mTGZQs0A==
X-Google-Smtp-Source: APiQypKtUcacUN4LKBb23DXU/psP5B8ZKa6Dm6WZDEZmoiZoyPAGEgZW7ZFI+L36PS0F33V/KvI0zg==
X-Received: by 2002:adf:dec3:: with SMTP id i3mr5213660wrn.351.1585854792028;
        Thu, 02 Apr 2020 12:13:12 -0700 (PDT)
Received: from localhost.localdomain ([95.149.164.95])
        by smtp.gmail.com with ESMTPSA id y12sm5511514wrn.55.2020.04.02.12.13.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2020 12:13:11 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Subject: [PATCH 4.14 13/33] wil6210: remove reset file from debugfs
Date:   Thu,  2 Apr 2020 20:13:33 +0100
Message-Id: <20200402191353.787836-13-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200402191353.787836-1-lee.jones@linaro.org>
References: <20200402191353.787836-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Karthick Gopalasubramanian <kargop@codeaurora.org>

[ Upstream commit 32dcfe8316cdbd885542967c0c85f5b9de78874b ]

Reset file is not used and may cause race conditions
with operational driver if used.

Signed-off-by: Karthick Gopalasubramanian <kargop@codeaurora.org>
Signed-off-by: Maya Erez <merez@codeaurora.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/net/wireless/ath/wil6210/debugfs.c | 27 ----------------------
 1 file changed, 27 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/debugfs.c b/drivers/net/wireless/ath/wil6210/debugfs.c
index 6db00c167d2e1..b17ecf796ed83 100644
--- a/drivers/net/wireless/ath/wil6210/debugfs.c
+++ b/drivers/net/wireless/ath/wil6210/debugfs.c
@@ -555,32 +555,6 @@ struct dentry *wil_debugfs_create_ioblob(const char *name,
 	return debugfs_create_file(name, mode, parent, wil_blob, &fops_ioblob);
 }
 
-/*---reset---*/
-static ssize_t wil_write_file_reset(struct file *file, const char __user *buf,
-				    size_t len, loff_t *ppos)
-{
-	struct wil6210_priv *wil = file->private_data;
-	struct net_device *ndev = wil_to_ndev(wil);
-
-	/**
-	 * BUG:
-	 * this code does NOT sync device state with the rest of system
-	 * use with care, debug only!!!
-	 */
-	rtnl_lock();
-	dev_close(ndev);
-	ndev->flags &= ~IFF_UP;
-	rtnl_unlock();
-	wil_reset(wil, true);
-
-	return len;
-}
-
-static const struct file_operations fops_reset = {
-	.write = wil_write_file_reset,
-	.open  = simple_open,
-};
-
 /*---write channel 1..4 to rxon for it, 0 to rxoff---*/
 static ssize_t wil_write_file_rxon(struct file *file, const char __user *buf,
 				   size_t len, loff_t *ppos)
@@ -1697,7 +1671,6 @@ static const struct {
 	{"bf",		0444,		&fops_bf},
 	{"ssid",	0644,		&fops_ssid},
 	{"mem_val",	0644,		&fops_memread},
-	{"reset",	0244,		&fops_reset},
 	{"rxon",	0244,		&fops_rxon},
 	{"tx_mgmt",	0244,		&fops_txmgmt},
 	{"wmi_send", 0244,		&fops_wmi},
-- 
2.25.1

