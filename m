Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BBA92E3D59
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:15:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440448AbgL1OOg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:14:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:48962 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2440442AbgL1OOf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:14:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2DF1120791;
        Mon, 28 Dec 2020 14:14:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164859;
        bh=vebW2t4L4Bf5BGZ2fToRavMUeapsg1Jl7zxW+l+kXzk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lLbMfoeUFDq/U40WCGep/wnIecoshv7knYWgh3MqB7h0KRZqNO0+Puug1yeSrWH0i
         75L1W8hsWqso+lS3S1he2HubD+4IsuDzaB+SdCPZZ0lqENJVnQwgVzqIQtFjZg/Ygn
         znbJpWuFH8gZYMWwtNvYLO9tsxUaxk3lwNSCa3B0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 325/717] cpufreq: mediatek: Add missing MODULE_DEVICE_TABLE
Date:   Mon, 28 Dec 2020 13:45:23 +0100
Message-Id: <20201228125036.589788302@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pali Rohár <pali@kernel.org>

[ Upstream commit af6eca06501118af3e2ad46eee8edab20624b74e ]

This patch adds missing MODULE_DEVICE_TABLE definition which generates
correct modalias for automatic loading of this cpufreq driver when it is
compiled as an external module.

Signed-off-by: Pali Rohár <pali@kernel.org>
Fixes: 501c574f4e3a5 ("cpufreq: mediatek: Add support of cpufreq to MT2701/MT7623 SoC")
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/mediatek-cpufreq.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/cpufreq/mediatek-cpufreq.c b/drivers/cpufreq/mediatek-cpufreq.c
index 7d1212c9b7c88..a310372dc53e9 100644
--- a/drivers/cpufreq/mediatek-cpufreq.c
+++ b/drivers/cpufreq/mediatek-cpufreq.c
@@ -540,6 +540,7 @@ static const struct of_device_id mtk_cpufreq_machines[] __initconst = {
 
 	{ }
 };
+MODULE_DEVICE_TABLE(of, mtk_cpufreq_machines);
 
 static int __init mtk_cpufreq_driver_init(void)
 {
-- 
2.27.0



