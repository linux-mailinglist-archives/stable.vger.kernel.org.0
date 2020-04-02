Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82C0B19C97E
	for <lists+stable@lfdr.de>; Thu,  2 Apr 2020 21:11:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389242AbgDBTLk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Apr 2020 15:11:40 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:35052 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389109AbgDBTLk (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Apr 2020 15:11:40 -0400
Received: by mail-wr1-f66.google.com with SMTP id g3so3287601wrx.2
        for <stable@vger.kernel.org>; Thu, 02 Apr 2020 12:11:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=4+1QiWssL4d1wmhT1EIw61xBk51HxKN8ogqOFZ7KYzc=;
        b=yEyklBPRApOA+Fgz8PYDiJ75O24S5Psbh8jmRcB5NG3ZlGPSibFB/kYgE2dlkqvrWz
         r8aOWg5vfPq6iVzwgtx/WRz5vB6kqp2XxWpPqfI0R0jDHQ2TqAYQNegIPpuFHefssNPn
         vWbagSAGDrC7R0vZqk9fufE5pZOJac3Zli6443F6Mb7mRXUohSEzn62TeL+qdb/WmBvm
         cAjxoejGxhTxJjVzr3VLLsM48nZ8CE/9sZByRjL/OQdCzkvJ6yQwcjcSmMBXtld3DZGv
         EzA42fYfgMCe0J9YVKrsozThVNOo0/bn/+U2biFZAXa83ZQyBJxGm5+U6HSb38BdaMpB
         K+zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4+1QiWssL4d1wmhT1EIw61xBk51HxKN8ogqOFZ7KYzc=;
        b=JbQig82ZL6yCFFnUjwORwOuBZ1xm17oE40dx5GG+JB3n4JsCDk6NIq41IGQP4ETkl+
         xX1lnjMGQFFZzWQCVUgiC7c8WD3NEdoDm9NWOMTi1mg4Jz6tfFt0G2nMKuh3flSphvUi
         90gi5ta7SFYDJYZhE71kg42sMrclNyJSvJejxc7BJ7G3WRx+5aNTWM9bxtM2duQ9LFU9
         OMXY2tyGf7xkY0jGL6Atfcjm9t+bPkKFgeGrC1uCmXdseaSGFClIWq+Ber7Zp7N8x8mE
         Zqz7lXUSrD5+IgtJmGayDmCspZp8a9hcV4eL25BV3TzxavcluUgSlo6BqNLehzA7WYgR
         zudQ==
X-Gm-Message-State: AGi0PuYiEVV3YumHlrjLF3kop+zHwmuWLAW7QuRhaO1tPBLSxT2CTOdh
        n8GZP46zkigCK2g6hVO4Gi4VcGyvXUfgTQ==
X-Google-Smtp-Source: APiQypJ3JPkCXm5i1ywiQCcMiNbA6Zpsyg8p3zkSJTeVIMjTky7c6RCejiyrWtjORjSM55UowPkV3g==
X-Received: by 2002:adf:edd2:: with SMTP id v18mr5267207wro.55.1585854698076;
        Thu, 02 Apr 2020 12:11:38 -0700 (PDT)
Received: from localhost.localdomain ([95.149.164.95])
        by smtp.gmail.com with ESMTPSA id s15sm8442164wrt.16.2020.04.02.12.11.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2020 12:11:37 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Subject: [PATCH 4.19 10/14] wil6210: remove reset file from debugfs
Date:   Thu,  2 Apr 2020 20:12:16 +0100
Message-Id: <20200402191220.787381-10-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200402191220.787381-1-lee.jones@linaro.org>
References: <20200402191220.787381-1-lee.jones@linaro.org>
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
index acd95ca0430b9..55a809cb31054 100644
--- a/drivers/net/wireless/ath/wil6210/debugfs.c
+++ b/drivers/net/wireless/ath/wil6210/debugfs.c
@@ -730,32 +730,6 @@ struct dentry *wil_debugfs_create_ioblob(const char *name,
 	return debugfs_create_file(name, mode, parent, wil_blob, &fops_ioblob);
 }
 
-/*---reset---*/
-static ssize_t wil_write_file_reset(struct file *file, const char __user *buf,
-				    size_t len, loff_t *ppos)
-{
-	struct wil6210_priv *wil = file->private_data;
-	struct net_device *ndev = wil->main_ndev;
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
@@ -2461,7 +2435,6 @@ static const struct {
 	{"desc",	0444,		&fops_txdesc},
 	{"bf",		0444,		&fops_bf},
 	{"mem_val",	0644,		&fops_memread},
-	{"reset",	0244,		&fops_reset},
 	{"rxon",	0244,		&fops_rxon},
 	{"tx_mgmt",	0244,		&fops_txmgmt},
 	{"wmi_send", 0244,		&fops_wmi},
-- 
2.25.1

