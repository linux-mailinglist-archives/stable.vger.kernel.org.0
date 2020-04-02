Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 549FC19C9B9
	for <lists+stable@lfdr.de>; Thu,  2 Apr 2020 21:17:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388621AbgDBTRH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Apr 2020 15:17:07 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:38005 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388822AbgDBTRH (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Apr 2020 15:17:07 -0400
Received: by mail-wr1-f65.google.com with SMTP id c7so5587144wrx.5
        for <stable@vger.kernel.org>; Thu, 02 Apr 2020 12:17:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=18LyNMnnVluirlbkjrnEF7hu3oLdn7PJzvuy6hjHFWE=;
        b=NMqCYZuz6j8/V8k0htkyaxgcl9ixP/g/gVcoyacLF6pOZHrrb/tN7S8LvPcFlSQELD
         STUFn/PHFgK//jvHjD4TXfunze+tHiuwAHQq54h8qRWjDqOQ6ShrUiJGOn56S/vEFIj6
         8RM2I0CpYgBhtzsflL6M6yd5T+Z6Z73162cqU5OX5VsbjaN9YRoZuf3yBkx4+eeR7oHf
         WuOiv8FhDLuheRJsDFbLFzqSwp2KfpzgK5Hhvt6JG3QMQfUlgrcGF/1o4AMTcEuBJjqF
         xArT7WRuhLI5WR2pCazxYVUQmm3pd9ppvyLpNyKgnlyjIyov9XseZjzJ3FrvUMeGLvIg
         eL1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=18LyNMnnVluirlbkjrnEF7hu3oLdn7PJzvuy6hjHFWE=;
        b=JXTGVskrLbl9ydyAQ4zlK8kPadfjsQVEMKM8jyBjCEkzir9Q+Pf184d1JjJW7YJTHI
         +NxogP/cndJCFEGdyiVM3eJJ/XnY4ePZBDO8lpDQR1Wykr1jW54Psyftvg/IqGMSrwXb
         hKiPEWrvtqXPSXLIw/rkg2je8P0/D3G5bmUrQUbh0GLi4cVpy9+e2+iCKmG7P9XOvird
         AbfXMDC2/41NPFsr/KYcFUBCt5NS3gird2sNoYpB8uPCJ9YnMQm5MOrb3DJ5O5VHXLDK
         XyX61jHgXsPtLOViArg2T5xUzwjsFP4TjMvgL8mv4cRG3M68XkmJYphnJznxitnTXeaE
         XvrQ==
X-Gm-Message-State: AGi0PuaqqEUbJ/E1Tyx2vnTlEuHu17JYsGLNZqNCRjcPfr/5HMaRCTXV
        Pbg327w5R6Cn+4PBP/gAZcOHKeV/pxeJZQ==
X-Google-Smtp-Source: APiQypJrOkTq+pVtGEw4Zk3R9x5o6HoWTwIDBtm9N3lKMxyLNAodZ7SsMaNaLXli1aZf3TKUcJ97uw==
X-Received: by 2002:adf:eed1:: with SMTP id a17mr4784510wrp.287.1585855025084;
        Thu, 02 Apr 2020 12:17:05 -0700 (PDT)
Received: from localhost.localdomain ([95.149.164.95])
        by smtp.gmail.com with ESMTPSA id y1sm879050wmd.14.2020.04.02.12.17.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2020 12:17:04 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Subject: [PATCH 4.9 11/24] wil6210: remove reset file from debugfs
Date:   Thu,  2 Apr 2020 20:17:34 +0100
Message-Id: <20200402191747.789097-11-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200402191747.789097-1-lee.jones@linaro.org>
References: <20200402191747.789097-1-lee.jones@linaro.org>
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
index 5e4058a4037b4..8c9c06fb6d655 100644
--- a/drivers/net/wireless/ath/wil6210/debugfs.c
+++ b/drivers/net/wireless/ath/wil6210/debugfs.c
@@ -554,32 +554,6 @@ struct dentry *wil_debugfs_create_ioblob(const char *name,
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
@@ -1639,7 +1613,6 @@ static const struct {
 	{"bf",		S_IRUGO,		&fops_bf},
 	{"ssid",	S_IRUGO | S_IWUSR,	&fops_ssid},
 	{"mem_val",	S_IRUGO,		&fops_memread},
-	{"reset",		  S_IWUSR,	&fops_reset},
 	{"rxon",		  S_IWUSR,	&fops_rxon},
 	{"tx_mgmt",		  S_IWUSR,	&fops_txmgmt},
 	{"wmi_send",		  S_IWUSR,	&fops_wmi},
-- 
2.25.1

