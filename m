Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CD112E633E
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:41:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405963AbgL1PkC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 10:40:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:50192 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405902AbgL1Nsh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:48:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E9E512078D;
        Mon, 28 Dec 2020 13:47:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609163276;
        bh=Zwks9dkXJlsB70xib3lu+GG87PIEm8VnHExLyAazaWs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UgXMaSJsCoUNFF58CvucDm1+JLQH6BNm+r3cGsVhlnTzmoXdT4RGxYgL9aUUE8sFr
         PfQ2Kl+Et9jABBUJqnXwrt5HLeidJXS0KYl/MxLtdn+5xmY/6oAwp+U21euCnz4jBQ
         SgHiJgsDk3a8L71nzt2AZDedNill1BmFANhJMGVc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 230/453] cpufreq: qcom: Add missing MODULE_DEVICE_TABLE
Date:   Mon, 28 Dec 2020 13:47:46 +0100
Message-Id: <20201228124948.289924509@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124937.240114599@linuxfoundation.org>
References: <20201228124937.240114599@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pali Rohár <pali@kernel.org>

[ Upstream commit a5a6031663bc1dd0a10babd49d1bcb3153a8327f ]

This patch adds missing MODULE_DEVICE_TABLE definition which generates
correct modalias for automatic loading of this cpufreq driver when it is
compiled as an external module.

Signed-off-by: Pali Rohár <pali@kernel.org>
Fixes: 46e2856b8e188 ("cpufreq: Add Kryo CPU scaling driver")
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/qcom-cpufreq-nvmem.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/cpufreq/qcom-cpufreq-nvmem.c b/drivers/cpufreq/qcom-cpufreq-nvmem.c
index f0d2d5035413b..1e77d190f19f9 100644
--- a/drivers/cpufreq/qcom-cpufreq-nvmem.c
+++ b/drivers/cpufreq/qcom-cpufreq-nvmem.c
@@ -305,6 +305,7 @@ static const struct of_device_id qcom_cpufreq_match_list[] __initconst = {
 	{ .compatible = "qcom,qcs404", .data = &match_data_qcs404 },
 	{},
 };
+MODULE_DEVICE_TABLE(of, qcom_cpufreq_match_list);
 
 /*
  * Since the driver depends on smem and nvmem drivers, which may
-- 
2.27.0



