Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C0A0E167114
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 08:52:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728419AbgBUHu6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 02:50:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:48050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729654AbgBUHu5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 02:50:57 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 470962465D;
        Fri, 21 Feb 2020 07:50:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582271456;
        bh=EcjME5a/kKnsZfGwBPvbPAcvIOwyEdwgkxBUW8N6TEA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IB3mPmWaagWV6ghQ/eJTB9d6mXiBHHtlbfZy9EI9OO7GW1wA094Vgd6faSMsYT0QN
         c8Nwb8Uw/LKSGHATLb4IvVh2fXCiarHyiJmT7QxbEwimRbVipfZl+3Ax+NG/aqiD4O
         +hipwsoCAlWce7FqyhkQGqWSsYIHjrcTn+mU+r78=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sibi Sankar <sibis@codeaurora.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 173/399] remoteproc: q6v5-mss: Remove mem clk from the active pool
Date:   Fri, 21 Feb 2020 08:38:18 +0100
Message-Id: <20200221072419.469747792@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072402.315346745@linuxfoundation.org>
References: <20200221072402.315346745@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sibi Sankar <sibis@codeaurora.org>

[ Upstream commit 6ba519aa13758dd55248f3a6f939536656df2661 ]

Currently the mem clk is voted upon from both the active and proxy pool on
MSM8998 SoCs where only a proxy vote should suffice. Fix this by removing
mem clk from the active pool.

Fixes: 1665cbd5731fa ("remoteproc: qcom_q6v5_mss: Add support for MSM8998")
Signed-off-by: Sibi Sankar <sibis@codeaurora.org>
Link: https://lore.kernel.org/r/20191218132217.28141-2-sibis@codeaurora.org
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/remoteproc/qcom_q6v5_mss.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/remoteproc/qcom_q6v5_mss.c b/drivers/remoteproc/qcom_q6v5_mss.c
index 471128a2e7239..164fc2a53ef11 100644
--- a/drivers/remoteproc/qcom_q6v5_mss.c
+++ b/drivers/remoteproc/qcom_q6v5_mss.c
@@ -1594,7 +1594,6 @@ static const struct rproc_hexagon_res msm8998_mss = {
 	.active_clk_names = (char*[]){
 			"iface",
 			"bus",
-			"mem",
 			"gpll0_mss",
 			"mnoc_axi",
 			"snoc_axi",
-- 
2.20.1



