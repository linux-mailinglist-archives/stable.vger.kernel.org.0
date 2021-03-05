Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53F3332DF9D
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 03:24:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229526AbhCECYf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Mar 2021 21:24:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbhCECYe (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Mar 2021 21:24:34 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92436C061574
        for <stable@vger.kernel.org>; Thu,  4 Mar 2021 18:24:34 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id fu20so926435pjb.2
        for <stable@vger.kernel.org>; Thu, 04 Mar 2021 18:24:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BJxSLGJT9AMyFILU99BNWVjtK79AeZFLNxiVZ/NksTU=;
        b=hj73MUwbM1qgYu0IAailNLcH4idOJ54uDH278oRlYW0Bv4MnjDic/Dq3tLMEIWx+po
         kMWiF1JLp2CCTS8582x0GAADo/OOZOjTkjrQOl5oYmMvIcH4SsRFfB4+oR/97I5xL+aM
         QJf1ZY8wXVdu1NIjP5q203inFztgCc8Vo3qDw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BJxSLGJT9AMyFILU99BNWVjtK79AeZFLNxiVZ/NksTU=;
        b=q91Au2HTPCFLL/bH7s/0OOlCQYZ7reUrPBnELceBlqSK4CaoCdvR2Ncpsq+ZrlJjhB
         uMmnUKIv+6SrTSsV2Mor3cObfyaQsFv4NuzmlCR78hZfWtPv/0bjDJ3QQ7MHcOTTCJfP
         8mXWnaIVnmDEB22mipkHJghqDx7wvKaRwtAgZq5jWNNfoSFyWMqfPxd5MvXkMumFJXEq
         DJzB/ZqOuQ2oinnHuXYa7YORkiKbjo0JgO+c29ADl07t1dWU17oZUrZvu88be/jm/L+O
         TpE/aa2RzcVt77TrWeK695t8GCA+PBTqDuc74/jbcqeo61KhgXM3eqOGlg44u8NfA0U6
         A61A==
X-Gm-Message-State: AOAM531U5K29wGUfsZrENgsO3mDFPHwk9qjPMJaYsJzDu1d+BB5KGD1B
        EY7KSuWtDQRuQ25IXvcE0WF/pa+AaD/9LA==
X-Google-Smtp-Source: ABdhPJwGYjo/nQieDXvta/8kgvzQlAV2RRZJ1W6900xMH2Jmu1/tufLeQXquCawJu86MC6GEVPxvEg==
X-Received: by 2002:a17:90b:4d12:: with SMTP id mw18mr2819253pjb.196.1614911073665;
        Thu, 04 Mar 2021 18:24:33 -0800 (PST)
Received: from acourbot.tok.corp.google.com ([2401:fa00:8f:203:1418:f713:ec44:b992])
        by smtp.gmail.com with ESMTPSA id j2sm562156pgh.39.2021.03.04.18.24.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Mar 2021 18:24:32 -0800 (PST)
From:   Alexandre Courbot <acourbot@chromium.org>
To:     stable@vger.kernel.org
Cc:     Souptick Joarder <jrdr.linux@gmail.com>,
        kernel test robot <lkp@intel.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Alexandre Courbot <acourbot@chromium.org>
Subject: [PATCH] remoteproc/mediatek: Fix kernel test robot warning
Date:   Fri,  5 Mar 2021 11:22:36 +0900
Message-Id: <20210305022236.4105472-1-acourbot@chromium.org>
X-Mailer: git-send-email 2.30.1.766.gb4fecdf3b7-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Souptick Joarder <jrdr.linux@gmail.com>

Kernel test robot throws below warning ->

>> drivers/remoteproc/mtk_scp.c:755:37: warning: unused variable
>> 'mt8183_of_data' [-Wunused-const-variable]
   static const struct mtk_scp_of_data mt8183_of_data = {
                                       ^
>> drivers/remoteproc/mtk_scp.c:765:37: warning: unused variable
>> 'mt8192_of_data' [-Wunused-const-variable]
   static const struct mtk_scp_of_data mt8192_of_data = {
                                       ^
As suggested by Bjorn, there's no harm in just dropping the
of_match_ptr() wrapping of mtk_scp_of_match in the definition of
mtk_scp_driver and we avoid this whole problem.

Reported-by: kernel test robot <lkp@intel.com>
Suggested-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Souptick Joarder <jrdr.linux@gmail.com>
Link: https://lore.kernel.org/r/1606513855-21130-1-git-send-email-jrdr.linux@gmail.com
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
(cherry picked from commit cca21000261b2364991ecdb0d9e66b26ad9c4b4e)
Cc: stable@vger.kernel.org # v5.10+
Signed-off-by: Alexandre Courbot <acourbot@chromium.org>
---
 drivers/remoteproc/mtk_scp.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/remoteproc/mtk_scp.c b/drivers/remoteproc/mtk_scp.c
index 00a6e57dfa16..63c501a42c44 100644
--- a/drivers/remoteproc/mtk_scp.c
+++ b/drivers/remoteproc/mtk_scp.c
@@ -775,21 +775,19 @@ static const struct mtk_scp_of_data mt8192_of_data = {
 	.host_to_scp_int_bit = MT8192_HOST_IPC_INT_BIT,
 };
 
-#if defined(CONFIG_OF)
 static const struct of_device_id mtk_scp_of_match[] = {
 	{ .compatible = "mediatek,mt8183-scp", .data = &mt8183_of_data },
 	{ .compatible = "mediatek,mt8192-scp", .data = &mt8192_of_data },
 	{},
 };
 MODULE_DEVICE_TABLE(of, mtk_scp_of_match);
-#endif
 
 static struct platform_driver mtk_scp_driver = {
 	.probe = scp_probe,
 	.remove = scp_remove,
 	.driver = {
 		.name = "mtk-scp",
-		.of_match_table = of_match_ptr(mtk_scp_of_match),
+		.of_match_table = mtk_scp_of_match,
 	},
 };
 
-- 
2.30.1.766.gb4fecdf3b7-goog

