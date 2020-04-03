Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43B6119D695
	for <lists+stable@lfdr.de>; Fri,  3 Apr 2020 14:18:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403919AbgDCMSh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Apr 2020 08:18:37 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:54116 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403845AbgDCMSg (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Apr 2020 08:18:36 -0400
Received: by mail-wm1-f67.google.com with SMTP id d77so6948973wmd.3
        for <stable@vger.kernel.org>; Fri, 03 Apr 2020 05:18:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4+1QiWssL4d1wmhT1EIw61xBk51HxKN8ogqOFZ7KYzc=;
        b=G4swYPH2v4QLGFr32/9ser3iBiq8zUX2jLc9keZaAMfqT68Ti/KTPNJNQFPSmswnnt
         8+AZ0UO0L5t/ZWMHIXacXoH3+ZpKBfOzrtledatX1OOffQJmGyxGetuKF+G7k0PibrOh
         G1O5E6Q+exAqevIqlXr4i9msCnx2icy6Blzw83fDfKdTzzYfZlUc9Ckwx/iRGWVUCnfO
         AIRQZZ9CdjxvCP7Bg5ctD+oxEW9mO0GJWbmwrBTHylwLXj+owIoTPB1CizdN7z7eShlh
         tfjs3VQkHC3SXZCtXtQcf0BF4ER5iFHnl1iwBIbSS5R+k4bZ4pArCXDAhPwwKfWUBvAr
         mJ+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4+1QiWssL4d1wmhT1EIw61xBk51HxKN8ogqOFZ7KYzc=;
        b=NLwKfvepVODQr9Kq6mxpBjXP2vTiLnGqFfIWU/QX27j3TEn7u/i7n6ikB57kb3zMpu
         9WSfpI2mO/aIkkJfstH++ey86wj8eRLN3yfnvasaF3KvCyPWCuhIb2PBY9RoLZp07UAP
         Y7zdGpcOJbo63rz2suZMZCkQRtIpSUN65Jnq/FrqMc+zSQaqOhA2IXyd+nuC38ZSj5A/
         Fo/5hLOMIj3oSRdHbMgnurJXDflk5wVu/OLdBK+Nu9yC/5XD80l1+8wX/AGp8l8slCMl
         4b67uihs/dg9IUVf2VYvE33rCD932PXegB3hUXonPKddloGLgap2tMcrFhqfe96RnIGS
         rxMQ==
X-Gm-Message-State: AGi0PuYZG7msqxXT03YXKtlAzhXX99HBqLt9usTlruIDHW2tZ4cw76KE
        rnw0V326w3SOOPC0XYV9SjzyPQkG3ms=
X-Google-Smtp-Source: APiQypLSSe5tJpN80OBisz01/HOz4XDM8H3NEe8DrvfVFMAGbWBPaE1xf01UjIh/nq6OXEgGkjdnIw==
X-Received: by 2002:a1c:418b:: with SMTP id o133mr8740983wma.165.1585916314918;
        Fri, 03 Apr 2020 05:18:34 -0700 (PDT)
Received: from localhost.localdomain ([2.27.35.179])
        by smtp.gmail.com with ESMTPSA id l185sm11377712wml.44.2020.04.03.05.18.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Apr 2020 05:18:34 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Cc:     Karthick Gopalasubramanian <kargop@codeaurora.org>,
        Maya Erez <merez@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 4.19 10/13] wil6210: remove reset file from debugfs
Date:   Fri,  3 Apr 2020 13:18:56 +0100
Message-Id: <20200403121859.901838-11-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200403121859.901838-1-lee.jones@linaro.org>
References: <20200403121859.901838-1-lee.jones@linaro.org>
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

