Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AB43476B97
	for <lists+stable@lfdr.de>; Thu, 16 Dec 2021 09:13:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234788AbhLPINX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Dec 2021 03:13:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234831AbhLPINU (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Dec 2021 03:13:20 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6D63C061401
        for <stable@vger.kernel.org>; Thu, 16 Dec 2021 00:13:20 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id z6so18851383plk.6
        for <stable@vger.kernel.org>; Thu, 16 Dec 2021 00:13:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vC6zsX1z5vnUW+lKaZ0nR4WtPfovJbiEibZW3cAtkqE=;
        b=qmODtu4fVv7iuTsPNb+bP9PC612zKiobeXGdkynk48IH+EWY/PdpuoHhHEgSGz5uuk
         j26oJHztCG004ALOnTJRS2ECKPpIQpU9b5Cuxf8DPnCot8Va/tzpbt7OFa5WQxX8ugNx
         QfKp/ZxWi5NcUiiKdJp9+Oz/EKbgkLlWTQ2yKm+Dg9czp7OLRMBzZEofKxhcKO/pndr2
         G+62DRD0TiSoTJ4RAcI1Hpx5KR+HHYYLBQamYEHhq2z2xupObGpSXY2/HCCqRBThSB3E
         pjxTuEynC9MgQJxZNCH60DxijLVS2wYhCwFYNugUTN+Ld+aTw7Ii/Qt4e8gsMNcx0LXX
         8kiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vC6zsX1z5vnUW+lKaZ0nR4WtPfovJbiEibZW3cAtkqE=;
        b=jpUPx0zV/PGUn8k7Z7S9jFGrVLYaD/xXsO+6g0JGd5B9y1TmfByEY1R3abTMAAmYrL
         enh9Nh+TF6QysF4yfYRwuNSvV4eviSxxmoiwcwvHvJ48ew9seHBg6V+voWrI410nuxc/
         u+qxiX6irZ+c/5RLL+Sf5WFQ6MShZ0vfvOm22MGpOTqTznDR/zvBJsXYrU+B/CBzbj8+
         yHTQfKOUFUZ7MtAbYjbI12xEVfuUj6Rbn3/gOfLmhph7ZGUFj7EvXCwqeJNZx/UHqExh
         K7nnaLhQ12rdhsu9yaq4jKzEN88uKnGKmOgBzchUuQaKh8v8sOfxDoXj97JEHgfzhLRo
         lAvA==
X-Gm-Message-State: AOAM533HJoJV2/MYfjikMcsvkPhTtAiPgfvVUKA90irdd7EqKKpl0NrQ
        1PMGPGneOzaHYSWa84dVmBit
X-Google-Smtp-Source: ABdhPJwKNizbWzfhG5HbZ69FmunvbcaHaIOazuKTjzkxdGQMdMTcvK0dVXqJAngYfM52YIoh5gm6cw==
X-Received: by 2002:a17:90b:3143:: with SMTP id ip3mr4688553pjb.34.1639642400135;
        Thu, 16 Dec 2021 00:13:20 -0800 (PST)
Received: from localhost.localdomain ([117.193.208.121])
        by smtp.gmail.com with ESMTPSA id u38sm326835pfg.4.2021.12.16.00.13.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Dec 2021 00:13:19 -0800 (PST)
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     gregkh@linuxfoundation.org
Cc:     mhi@lists.linux.dev, hemantk@codeaurora.org, bbhatt@codeaurora.org,
        loic.poulain@linaro.org, thomas.perrot@bootlin.com,
        aleksander@aleksander.es, slark_xiao@163.com,
        christophe.jaillet@wanadoo.fr, keescook@chromium.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Bhaumik Bhatt <quic_bbhatt@quicinc.com>,
        Manivannan Sadhasivam <mani@kernel.org>,
        stable@vger.kernel.org,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Subject: [PATCH 06/10] bus: mhi: core: Fix reading wake_capable channel configuration
Date:   Thu, 16 Dec 2021 13:42:23 +0530
Message-Id: <20211216081227.237749-7-manivannan.sadhasivam@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211216081227.237749-1-manivannan.sadhasivam@linaro.org>
References: <20211216081227.237749-1-manivannan.sadhasivam@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bhaumik Bhatt <quic_bbhatt@quicinc.com>

The 'wake-capable' entry in channel configuration is not set when
parsing the configuration specified by the controller driver. Add
the missing entry to ensure channel is correctly specified as a
'wake-capable' channel.

Fixes: 0cbf260820fa ("bus: mhi: core: Add support for registering MHI controllers")
Signed-off-by: Bhaumik Bhatt <quic_bbhatt@quicinc.com>
Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/1638320491-13382-1-git-send-email-quic_bbhatt@quicinc.com
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
---
 drivers/bus/mhi/core/init.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/bus/mhi/core/init.c b/drivers/bus/mhi/core/init.c
index 5aaca6d0f52b..f1ec34417592 100644
--- a/drivers/bus/mhi/core/init.c
+++ b/drivers/bus/mhi/core/init.c
@@ -788,6 +788,7 @@ static int parse_ch_cfg(struct mhi_controller *mhi_cntrl,
 		mhi_chan->offload_ch = ch_cfg->offload_channel;
 		mhi_chan->db_cfg.reset_req = ch_cfg->doorbell_mode_switch;
 		mhi_chan->pre_alloc = ch_cfg->auto_queue;
+		mhi_chan->wake_capable = ch_cfg->wake_capable;
 
 		/*
 		 * If MHI host allocates buffers, then the channel direction
-- 
2.25.1

