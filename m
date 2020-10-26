Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CED229A008
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 01:26:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2442557AbgJ0A0x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Oct 2020 20:26:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:57846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2410070AbgJZXx0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Oct 2020 19:53:26 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AF4D420770;
        Mon, 26 Oct 2020 23:53:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603756405;
        bh=ZWgRwuEvYiS7hPKLY3kpwcl1I7Msip/q8JSi+nhLDfc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MNEV4NsvbmpyiwCxVbyAkic4/Q/NMezX+UMOMnXjB499Ubk7trz1aE1HTanEk3enB
         ZETtLookUyX5dmDoyW0WpsbxlE/xOwJzSSFSV7e8TXOyGYv6OhSkz+iizlUYiBzExV
         GfjqVzwwAeCK7KALnUTK5FlXc5pAQIgzivTmd6uw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alain Volmat <avolmat@me.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-pm@vger.kernel.org
Subject: [PATCH AUTOSEL 5.8 064/132] cpufreq: sti-cpufreq: add stih418 support
Date:   Mon, 26 Oct 2020 19:50:56 -0400
Message-Id: <20201026235205.1023962-64-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201026235205.1023962-1-sashal@kernel.org>
References: <20201026235205.1023962-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 8f16bbb164b84..2855b7878a204 100644
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
2.25.1

