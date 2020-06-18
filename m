Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50B111FE0D9
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 03:51:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729893AbgFRB1B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 21:27:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:34808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730996AbgFRB07 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:26:59 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5589F20776;
        Thu, 18 Jun 2020 01:26:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592443619;
        bh=E8MpjFsnS/fVelmiWWf4CED6UGJ4st/XyfkvcetkX20=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a8DxBWpSzPGPn77wvIC4G6Z7zalEFvIP39TDuTWsIgUlmui+JzJ4KVj51d4E0h4QL
         lUGwJ07aPbQZw8Zl2VBs3Gc6u4wEjvJC2qNtMixreqUgd/R2lZejoGRBMOj/54g79C
         Rwg05LvDLJpabriu2Q2MAS5l8RVcXqZwAtRKNOgc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Matej Dujava <mdujava@kocurkovo.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-fbdev@vger.kernel.org,
        devel@driverdev.osuosl.org
Subject: [PATCH AUTOSEL 4.14 045/108] staging: sm750fb: add missing case while setting FB_VISUAL
Date:   Wed, 17 Jun 2020 21:24:57 -0400
Message-Id: <20200618012600.608744-45-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618012600.608744-1-sashal@kernel.org>
References: <20200618012600.608744-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matej Dujava <mdujava@kocurkovo.cz>

[ Upstream commit fa90133377f4a7f15a937df6ad55133bb57c5665 ]

Switch statement does not contain all cases: 8, 16, 24, 32.
This patch will add missing one (24)

Fixes: 81dee67e215b ("staging: sm750fb: add sm750 to staging")
Signed-off-by: Matej Dujava <mdujava@kocurkovo.cz>
Link: https://lore.kernel.org/r/1588277366-19354-2-git-send-email-mdujava@kocurkovo.cz
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/sm750fb/sm750.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/sm750fb/sm750.c b/drivers/staging/sm750fb/sm750.c
index 67207b0554cd..5d6f3686c0de 100644
--- a/drivers/staging/sm750fb/sm750.c
+++ b/drivers/staging/sm750fb/sm750.c
@@ -899,6 +899,7 @@ static int lynxfb_set_fbinfo(struct fb_info *info, int index)
 		fix->visual = FB_VISUAL_PSEUDOCOLOR;
 		break;
 	case 16:
+	case 24:
 	case 32:
 		fix->visual = FB_VISUAL_TRUECOLOR;
 		break;
-- 
2.25.1

