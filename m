Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E63E1801E7
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 16:33:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726315AbgCJPdu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 11:33:50 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:42145 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726380AbgCJPdu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Mar 2020 11:33:50 -0400
Received: by mail-lj1-f195.google.com with SMTP id q19so14618918ljp.9
        for <stable@vger.kernel.org>; Tue, 10 Mar 2020 08:33:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0AS4iD/EqLgDWiA/Em9kdqcmCXIvsjkX4pJSBWor6Nk=;
        b=d3gT/cV7yOBnJzdr1xBBXMnSAnWAFLDvl7xcHlspC0LOGFpsE72iS1YE9y9y1hng/8
         sVSc2dRPuFLTwq5AA5GAA4NjVCYrvI4spfy6YFz9qV6Bkufx+syjQ/YfV09B0Hw8grLz
         scrjQBrAxtPZsDpMoTyYsktdNQ9Dw5JtGWltX2b05iZX01gTZ84NVjkd0NQd5efjTm5D
         0jg3uvhnLV4DfctHeY6npC1Klk3gdFU5zG+79f9ngEBV4TGe8vvilXAi7NKk1XBCnUDA
         ASRWW/gH6EKTbIsc9nX+RY5S3+YDYQPBYp9pk307/CS9FDalkm0EFzDtt65dofgKd3TV
         eQqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0AS4iD/EqLgDWiA/Em9kdqcmCXIvsjkX4pJSBWor6Nk=;
        b=AIPXUbL9PjzeYOaS57pEpId5P5gm8LocJAElXXwIXiy3/0KwEV+CNLHYy+s4MKa0IG
         LOvy0amj6UYl9SJcG8Y6O2O1Jelqf/CMoaQ6SkgBtWTwq8lT8ABG8bPmX85DAaO+EQIy
         4vhpQcSEtoB80vbWIjxDr7IwQgZlQYyjEqxTzMhjhcxp9fFzgxGKMSlun1VnRCt3exSB
         cVHlYJLw/jViDNTV0gYn30mS4ubPsdwqDjEVofC7nxYYs06XjBd8WZM6fui2zBPSXgp7
         Vd4FPpe/bDMJ93zB315c9yf8DcSr51fuxarMAN2v+JWBD/vJkUWllei0m/Hnfm17NfN3
         M6PQ==
X-Gm-Message-State: ANhLgQ23dswwRxjf+nHnwMU9iVDV+UjFBDxa4q4qr31Scp/ljcj9orxw
        BzXR+2rtxFiZeTY5LUc1DUL6uw==
X-Google-Smtp-Source: ADFU+vvDpOfAMYNpRyOb2/6Q/jBOsY7V3AOt4HZMfeH3/3M38eXJsrZFEEpUT+38SSIr+2kEgT0qCg==
X-Received: by 2002:a05:651c:414:: with SMTP id 20mr12234008lja.165.1583854427939;
        Tue, 10 Mar 2020 08:33:47 -0700 (PDT)
Received: from localhost.localdomain (h-158-174-22-210.NA.cust.bahnhof.se. [158.174.22.210])
        by smtp.gmail.com with ESMTPSA id c22sm17283776lfi.41.2020.03.10.08.33.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Mar 2020 08:33:46 -0700 (PDT)
From:   Ulf Hansson <ulf.hansson@linaro.org>
To:     linux-mmc@vger.kernel.org, Ulf Hansson <ulf.hansson@linaro.org>
Cc:     Adrian Hunter <adrian.hunter@intel.com>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Ludovic Barre <ludovic.barre@st.com>,
        Baolin Wang <baolin.wang7@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Chaotian Jing <chaotian.jing@mediatek.com>,
        Shawn Lin <shawn.lin@rock-chips.com>, mirq-linux@rere.qmqm.pl,
        Bitan Biswas <bbiswas@nvidia.com>,
        Peter Geis <pgwipeout@gmail.com>,
        Sowjanya Komatineni <skomatineni@nvidia.com>,
        Faiz Abbas <faiz_abbas@ti.com>,
        Anders Roxell <anders.roxell@linaro.org>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        Jon Hunter <jonathanh@nvidia.com>, stable@vger.kernel.org
Subject: [PATCH 1/4] mmc: core: Allow host controllers to require R1B for CMD6
Date:   Tue, 10 Mar 2020 16:33:37 +0100
Message-Id: <20200310153340.5593-2-ulf.hansson@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200310153340.5593-1-ulf.hansson@linaro.org>
References: <20200310153340.5593-1-ulf.hansson@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

It has turned out that some host controllers can't use R1B for CMD6 and
other commands that have R1B associated with them. Therefore invent a new
host cap, MMC_CAP_NEED_RSP_BUSY to let them specify this.

In __mmc_switch(), let's check the flag and use it to prevent R1B responses
from being converted into R1. Note that, this also means that the host are
on its own, when it comes to manage the busy timeout.

Suggested-by: Sowjanya Komatineni <skomatineni@nvidia.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
---
 drivers/mmc/core/mmc_ops.c | 6 ++++--
 include/linux/mmc/host.h   | 1 +
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/mmc/core/mmc_ops.c b/drivers/mmc/core/mmc_ops.c
index da425ee2d9bf..e025604e17d4 100644
--- a/drivers/mmc/core/mmc_ops.c
+++ b/drivers/mmc/core/mmc_ops.c
@@ -542,9 +542,11 @@ int __mmc_switch(struct mmc_card *card, u8 set, u8 index, u8 value,
 	 * If the max_busy_timeout of the host is specified, make sure it's
 	 * enough to fit the used timeout_ms. In case it's not, let's instruct
 	 * the host to avoid HW busy detection, by converting to a R1 response
-	 * instead of a R1B.
+	 * instead of a R1B. Note, some hosts requires R1B, which also means
+	 * they are on their own when it comes to deal with the busy timeout.
 	 */
-	if (host->max_busy_timeout && (timeout_ms > host->max_busy_timeout))
+	if (!(host->caps & MMC_CAP_NEED_RSP_BUSY) && host->max_busy_timeout &&
+	    (timeout_ms > host->max_busy_timeout))
 		use_r1b_resp = false;
 
 	cmd.opcode = MMC_SWITCH;
diff --git a/include/linux/mmc/host.h b/include/linux/mmc/host.h
index ba703384bea0..4c5eb3aa8e72 100644
--- a/include/linux/mmc/host.h
+++ b/include/linux/mmc/host.h
@@ -333,6 +333,7 @@ struct mmc_host {
 				 MMC_CAP_UHS_SDR50 | MMC_CAP_UHS_SDR104 | \
 				 MMC_CAP_UHS_DDR50)
 #define MMC_CAP_SYNC_RUNTIME_PM	(1 << 21)	/* Synced runtime PM suspends. */
+#define MMC_CAP_NEED_RSP_BUSY	(1 << 22)	/* Commands with R1B can't use R1. */
 #define MMC_CAP_DRIVER_TYPE_A	(1 << 23)	/* Host supports Driver Type A */
 #define MMC_CAP_DRIVER_TYPE_C	(1 << 24)	/* Host supports Driver Type C */
 #define MMC_CAP_DRIVER_TYPE_D	(1 << 25)	/* Host supports Driver Type D */
-- 
2.20.1

