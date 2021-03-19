Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E40B341C06
	for <lists+stable@lfdr.de>; Fri, 19 Mar 2021 13:15:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229766AbhCSMOl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Mar 2021 08:14:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229638AbhCSMOK (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Mar 2021 08:14:10 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EAD2C06174A;
        Fri, 19 Mar 2021 05:14:09 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id r12so9336810ejr.5;
        Fri, 19 Mar 2021 05:14:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ec9f3BV+N0je38Ui7z/DOkmoK3OHWGzE9OojreIovaI=;
        b=eZEdD6VCtvmJVEEVvPtYCYMy4kU4hsCGvKpldDf+K4lslh2Q4iKWu5bH4u1t5oLHEI
         Ei5XAfPQh8S1yCHm/GXvijbzmZxyRkZUV42XcJqT2VbUF8flwm0n8xjLJEKkxdMcjs1e
         3t2sJ8XdaQ1mvGHAlmHI2bJGd+2X7FSZH8ndA63of8PocQ+W3O4C7Ax++BbHDvaJSNXJ
         7zR7eFODBnQsWDdQv3E+dc6cucPndQvnlV+6oaxyDOmHVtYQERxkdqkeguJYptng7yyh
         fKnug2mkzymiuZUDAJx2m5k/Pcr8Htg4xsJbj9eGCNdjUs0eC/lUpMljKtCfTsJRL1IK
         Xv5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ec9f3BV+N0je38Ui7z/DOkmoK3OHWGzE9OojreIovaI=;
        b=lGr8XDmgXM3eJ8hLN8tzTMHEBL4kGxJOrxSKctvzrytXaqav2l2U/0q/wxGRRqGToA
         jV+9SPtLKGEy4S9SMWjIgnFyMiDxIjl1zLLuO0KbUab9NJVM1vSiwsbugxIefxjul21j
         BrIysE9eVoSTz9xGtu1PX/RX8S+1clHHcYlzP1NHVQRJ1hEzhOBDQiH+AAanuF78g5/k
         RDvlihwvKGgBq/wk308eMhmfI9/ybWpZl90ia5gKvAS26SCVoMWJWRTgU28tDDIl2Uw6
         cuaWXeezQ3Wb8nDkTfRI7ZnHYeWdjhPUTt/RkqCRv7B/YEn5kLMrASLZObtcJOpYXxB1
         2f0w==
X-Gm-Message-State: AOAM532yk2k7PCfpDhKBu73PvfgMOUMYddtEH/IdyRMQ5OgQMDoKxcv3
        6RGjrPMya2bZceTeq+86R34=
X-Google-Smtp-Source: ABdhPJxo78ZH7vuHMNbRakvE/limkQ6vR93B+ebU/5w+d297JJ0PaozPxAY4BVaasLt+jN3VxCGgtQ==
X-Received: by 2002:a17:906:7c57:: with SMTP id g23mr3835083ejp.195.1616156048418;
        Fri, 19 Mar 2021 05:14:08 -0700 (PDT)
Received: from localhost.localdomain (ip5f5bec5d.dynamic.kabel-deutschland.de. [95.91.236.93])
        by smtp.gmail.com with ESMTPSA id q2sm919353eje.24.2021.03.19.05.14.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Mar 2021 05:14:08 -0700 (PDT)
From:   Bean Huo <huobean@gmail.com>
To:     rric@kernel.org, ulf.hansson@linaro.org, linus.walleij@linaro.org,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     beanhuo@micron.com, stable@vger.kernel.org
Subject: [PATCH v1 2/2] mmc: cavium: Remove redundant if-statement checkup
Date:   Fri, 19 Mar 2021 13:13:57 +0100
Message-Id: <20210319121357.255176-3-huobean@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210319121357.255176-1-huobean@gmail.com>
References: <20210319121357.255176-1-huobean@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bean Huo <beanhuo@micron.com>

Currently, we have two ways to issue multiple-block read/write the
command to the eMMC. One is by normal IO request path fs->block->mmc.
Another one is that we can issue multiple-block read/write through
MMC ioctl interface. For the first path, mrq->stop, and mrq->stop->opcode
will be initialized in mmc_blk_data_prep(). However, for the second IO
path, mrq->stop is not initialized since it is a pre-defined multiple
blocks read/write.

Meanwhile, if it is open-ended multiple block read/write command,
STOP_TRANSMISSION CMD12 will be issued later in mmc_blk_issue_drv_op(),
since it is MMC_IOC_MULTI_CMD.

So, delete these if-statement checkups, let these kinds of multiple-block
read/write request go.

Fixes 'ba3869ff32e4 ("mmc: cavium: Add core MMC driver for Cavium SOCs")'
Cc: stable@vger.kernel.org
Signed-off-by: Bean Huo <beanhuo@micron.com>
---
 drivers/mmc/host/cavium.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/mmc/host/cavium.c b/drivers/mmc/host/cavium.c
index 95a41983c6c0..8fb7cbcf62ad 100644
--- a/drivers/mmc/host/cavium.c
+++ b/drivers/mmc/host/cavium.c
@@ -654,8 +654,7 @@ static void cvm_mmc_dma_request(struct mmc_host *mmc,
 	struct mmc_data *data;
 	u64 emm_dma, addr;
 
-	if (!mrq->data || !mrq->data->sg || !mrq->data->sg_len ||
-	    !mrq->stop || mrq->stop->opcode != MMC_STOP_TRANSMISSION) {
+	if (!mrq->data || !mrq->data->sg || !mrq->data->sg_len) {
 		dev_err(&mmc->card->dev, "Error: %s no data\n", __func__);
 		goto error;
 	}
-- 
2.25.1

