Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 309E52A5941
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 23:06:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730073AbgKCWGC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 17:06:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:53998 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730455AbgKCUmA (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:42:00 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C078C223AB;
        Tue,  3 Nov 2020 20:41:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436119;
        bh=nWUEqFc857IS9ctLcEibWaH87KK/+kCD26kt7n/jqR0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=onqPDt2j1Wd3MfrZUzsbAlG0GnNWMpwJHR11XbCC6cdaN/wEqox7yzRmPti5Y/nDj
         IhnSRM95GBGBdn7Y9EPpQRRFHG78TQ9lPcF88KUdveiLM4CzLNQWP/1tpgZnRtbStf
         Il/mT4DiinUbIZ5D7TaoXwSenhkYYO9MdFfXOVxU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alain Volmat <avolmat@me.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 112/391] cpufreq: sti-cpufreq: add stih418 support
Date:   Tue,  3 Nov 2020 21:32:43 +0100
Message-Id: <20201103203354.379736488@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203348.153465465@linuxfoundation.org>
References: <20201103203348.153465465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alain Volmat <avolmat@me.com>

[ Upstream commit 01a163c52039e9426c7d3d3ab16ca261ad622597 ]

The STiH418 can be controlled the same way as STiH407 &
STiH410 regarding cpufreq.

Signed-off-by: Alain Volmat <avolmat@me.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/sti-cpufreq.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/cpufreq/sti-cpufreq.c b/drivers/cpufreq/sti-cpufreq.c
index a5ad96d29adca..4ac6fb23792a0 100644
--- a/drivers/cpufreq/sti-cpufreq.c
+++ b/drivers/cpufreq/sti-cpufreq.c
@@ -141,7 +141,8 @@ static const struct reg_field sti_stih407_dvfs_regfields[DVFS_MAX_REGFIELDS] = {
 static const struct reg_field *sti_cpufreq_match(void)
 {
 	if (of_machine_is_compatible("st,stih407") ||
-	    of_machine_is_compatible("st,stih410"))
+	    of_machine_is_compatible("st,stih410") ||
+	    of_machine_is_compatible("st,stih418"))
 		return sti_stih407_dvfs_regfields;
 
 	return NULL;
@@ -258,7 +259,8 @@ static int sti_cpufreq_init(void)
 	int ret;
 
 	if ((!of_machine_is_compatible("st,stih407")) &&
-		(!of_machine_is_compatible("st,stih410")))
+		(!of_machine_is_compatible("st,stih410")) &&
+		(!of_machine_is_compatible("st,stih418")))
 		return -ENODEV;
 
 	ddata.cpu = get_cpu_device(0);
-- 
2.27.0



