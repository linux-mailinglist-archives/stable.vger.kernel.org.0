Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8186D4522F3
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:15:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378789AbhKPBRE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:17:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:38462 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243381AbhKOTJM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:09:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 03C566340A;
        Mon, 15 Nov 2021 18:18:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637000286;
        bh=q3k5bFoKqFHNCI+fFQWAy2ou5p19PYoWREQn28ru6dY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PvcOMwlbWsv9X1YqlCUu0IWoHZ0cPIt+45ZH0LegawyEQy3EGYhht/6qMEiUhEa92
         T5nIOTTZgiuzbMd4cFZC2L0myM++K8kcXN+oU4lz1mHaD7vanN6QiGl6sjVp05e0Ot
         5VMOWCP8ptDdY/kuD2jgz2oy/UxscsdBt4bi+QmQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Naina Mehta <nainmeht@codeaurora.org>,
        Sai Prakash Ranjan <saiprakash.ranjan@codeaurora.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 572/849] soc: qcom: llcc: Disable MMUHWT retention
Date:   Mon, 15 Nov 2021 18:00:55 +0100
Message-Id: <20211115165439.596813035@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Naina Mehta <nainmeht@codeaurora.org>

[ Upstream commit 3a461009e195c3c17f6af73da310b886991309fd ]

Disable MMUHWT retention for SC7280 as done for other platforms
to avoid more power burn.

Fixes: f6a07be63301 ("soc: qcom: llcc: Add configuration data for SC7280")
Signed-off-by: Naina Mehta <nainmeht@codeaurora.org>
Signed-off-by: Sai Prakash Ranjan <saiprakash.ranjan@codeaurora.org>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20210921055942.30600-1-saiprakash.ranjan@codeaurora.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/qcom/llcc-qcom.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/soc/qcom/llcc-qcom.c b/drivers/soc/qcom/llcc-qcom.c
index 15a36dcab990e..e53109a5c3da9 100644
--- a/drivers/soc/qcom/llcc-qcom.c
+++ b/drivers/soc/qcom/llcc-qcom.c
@@ -115,7 +115,7 @@ static const struct llcc_slice_config sc7280_data[] =  {
 	{ LLCC_CMPT,     10, 768, 1, 1, 0x3f, 0x0, 0, 0, 0, 1, 0, 0},
 	{ LLCC_GPUHTW,   11, 256, 1, 1, 0x3f, 0x0, 0, 0, 0, 1, 0, 0},
 	{ LLCC_GPU,      12, 512, 1, 0, 0x3f, 0x0, 0, 0, 0, 1, 0, 0},
-	{ LLCC_MMUHWT,   13, 256, 1, 1, 0x3f, 0x0, 0, 0, 0, 1, 1, 0},
+	{ LLCC_MMUHWT,   13, 256, 1, 1, 0x3f, 0x0, 0, 0, 0, 0, 1, 0},
 	{ LLCC_MDMPNG,   21, 768, 0, 1, 0x3f, 0x0, 0, 0, 0, 1, 0, 0},
 	{ LLCC_WLHW,     24, 256, 1, 1, 0x3f, 0x0, 0, 0, 0, 1, 0, 0},
 	{ LLCC_MODPE,    29, 64,  1, 1, 0x3f, 0x0, 0, 0, 0, 1, 0, 0},
-- 
2.33.0



