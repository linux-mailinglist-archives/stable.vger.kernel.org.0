Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B41F1451F21
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:36:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355612AbhKPAig (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:38:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:45126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344412AbhKOTYj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:24:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 58FB063483;
        Mon, 15 Nov 2021 18:57:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637002640;
        bh=KHOXmXGVVdG7386OnbuBldJow+jYs7z9But/PDrCb7o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LQBVAPfv/NssH+1FDIZnIlfxOP0Y6WGDIuskWEK0g9I4ryVKFHzykCnXITdJ/uSVM
         VdElZYKH0hxxTG29skGADXJ0UkPRkgo6Qd5QTJ4bDCrNnw0LN8rUJa5f5DwdpmXZXL
         isWvHitFKJWHLTZno59vJC70ufWIQGpYsWP3BKwk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 644/917] soc: qcom: socinfo: add two missing PMIC IDs
Date:   Mon, 15 Nov 2021 18:02:19 +0100
Message-Id: <20211115165450.693256462@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit 2fae3ecc70405b72ea6c923b216d34547559d6a9 ]

Add IDs for PMK8001 and PMI8996. They also fall in the list of
'duplicated' IDs, where the same index was used for multiple chips.

Fixes: 7fda2b0bfbd9 ("soc: qcom: socinfo: import PMIC IDs from pmic-spmi")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20211016190607.49866-1-dmitry.baryshkov@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/qcom/socinfo.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/soc/qcom/socinfo.c b/drivers/soc/qcom/socinfo.c
index 52e5811671155..5beb452f24013 100644
--- a/drivers/soc/qcom/socinfo.c
+++ b/drivers/soc/qcom/socinfo.c
@@ -87,8 +87,8 @@ static const char *const pmic_models[] = {
 	[15] = "PM8901",
 	[16] = "PM8950/PM8027",
 	[17] = "PMI8950/ISL9519",
-	[18] = "PM8921",
-	[19] = "PM8018",
+	[18] = "PMK8001/PM8921",
+	[19] = "PMI8996/PM8018",
 	[20] = "PM8998/PM8015",
 	[21] = "PMI8998/PM8014",
 	[22] = "PM8821",
-- 
2.33.0



