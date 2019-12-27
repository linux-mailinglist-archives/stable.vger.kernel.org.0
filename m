Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC19B12B836
	for <lists+stable@lfdr.de>; Fri, 27 Dec 2019 18:54:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727322AbfL0RyW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Dec 2019 12:54:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:39624 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727905AbfL0Rmh (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 27 Dec 2019 12:42:37 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6F680218AC;
        Fri, 27 Dec 2019 17:42:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577468557;
        bh=Cj40zb+AUa3NBq6HJj8kQ+SYKunwgnUJaZ+Ud1eZDWc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I6Rc3aw9y80fLXCeFHRzJUDEyXj8DVs8hJbzqyVL5O17kgbQi7O8KBw/LT50B76fN
         bX1XPmB1hg96yvlCsQrAsEY2CCn8+APDth/CQ5jEAAu36MMvPiI4SSZcJydT2zcrmC
         sPqek1OOAQo898IgPUvSBU6+B4DdadzoS7ifIsck=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Leonard Crestez <leonard.crestez@nxp.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 083/187] ARM: imx_v6_v7_defconfig: Explicitly restore CONFIG_DEBUG_FS
Date:   Fri, 27 Dec 2019 12:39:11 -0500
Message-Id: <20191227174055.4923-83-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191227174055.4923-1-sashal@kernel.org>
References: <20191227174055.4923-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Leonard Crestez <leonard.crestez@nxp.com>

[ Upstream commit 46db63abb79524209c15c683feccfba116746757 ]

This is currently off and that's not desirable: default imx config is
meant to be generally useful for development and debugging.

Running git bisect between v5.4 and v5.5-rc1 finds this started from
commit 0e4a459f56c3 ("tracing: Remove unnecessary DEBUG_FS dependency")

Explicit CONFIG_DEBUG_FS=y was earlier removed by
commit c29d541f590c ("ARM: imx_v6_v7_defconfig: Remove unneeded options")

A very similar fix was required before:
commit 7e9eb6268809 ("ARM: imx_v6_v7_defconfig: Explicitly restore CONFIG_DEBUG_FS")

Signed-off-by: Leonard Crestez <leonard.crestez@nxp.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/configs/imx_v6_v7_defconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/configs/imx_v6_v7_defconfig b/arch/arm/configs/imx_v6_v7_defconfig
index 0f7381ee0c37..dabb80453249 100644
--- a/arch/arm/configs/imx_v6_v7_defconfig
+++ b/arch/arm/configs/imx_v6_v7_defconfig
@@ -460,6 +460,7 @@ CONFIG_FONT_8x8=y
 CONFIG_FONT_8x16=y
 CONFIG_PRINTK_TIME=y
 CONFIG_MAGIC_SYSRQ=y
+CONFIG_DEBUG_FS=y
 # CONFIG_SCHED_DEBUG is not set
 CONFIG_PROVE_LOCKING=y
 # CONFIG_DEBUG_BUGVERBOSE is not set
-- 
2.20.1

