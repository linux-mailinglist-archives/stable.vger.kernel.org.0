Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F346C147645
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 02:19:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730338AbgAXBTA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jan 2020 20:19:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:32982 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729900AbgAXBRz (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 Jan 2020 20:17:55 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4533722464;
        Fri, 24 Jan 2020 01:17:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579828674;
        bh=8I4N5SI5pfjtzoqByMlS3MkZ2k66b7rxqF1BnrKZr/k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yv0RcOofRqgGLvg1lpWlq53g9eeZm6V3wAKVoWiaPMMeNqkKRAAq7GGlqiQZj1+oK
         RXMVkGkBJPpMQX2/GJlYJhFbD631PRC3Qbwdu7KQKCewmfsd7iamfQN5SBwppJkwW0
         C2febhM4CN6obLWQbV+MlmRrMpIWPBmlxRqouDRM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ben Dooks <ben.dooks@codethink.co.uk>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>, linux-pm@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 06/11] ARM: OMAP2+: SmartReflex: add omap_sr_pdata definition
Date:   Thu, 23 Jan 2020 20:17:42 -0500
Message-Id: <20200124011747.18575-6-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200124011747.18575-1-sashal@kernel.org>
References: <20200124011747.18575-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ben Dooks <ben.dooks@codethink.co.uk>

[ Upstream commit 2079fe6ea8cbd2fb2fbadba911f1eca6c362eb9b ]

The omap_sr_pdata is not declared but is exported, so add a
define for it to fix the following warning:

arch/arm/mach-omap2/pdata-quirks.c:609:36: warning: symbol 'omap_sr_pdata' was not declared. Should it be static?

Signed-off-by: Ben Dooks <ben.dooks@codethink.co.uk>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/power/smartreflex.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/linux/power/smartreflex.h b/include/linux/power/smartreflex.h
index 7b81dad712de8..37d9b70ed8f0a 100644
--- a/include/linux/power/smartreflex.h
+++ b/include/linux/power/smartreflex.h
@@ -296,6 +296,9 @@ struct omap_sr_data {
 	struct voltagedomain		*voltdm;
 };
 
+
+extern struct omap_sr_data omap_sr_pdata[OMAP_SR_NR];
+
 #ifdef CONFIG_POWER_AVS_OMAP
 
 /* Smartreflex module enable/disable interface */
-- 
2.20.1

