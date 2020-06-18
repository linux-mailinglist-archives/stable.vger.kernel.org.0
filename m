Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D98AD1FDDE0
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 03:29:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731591AbgFRB3G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 21:29:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:38186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732231AbgFRB3F (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:29:05 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4C5702222B;
        Thu, 18 Jun 2020 01:29:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592443745;
        bh=elXTXmYGJokeCCdeFSr5Bv7sOMGdOofxUAzIdj/ov38=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iuiBIm2DtpIT+23Knf1bfMEGHMR7sY5OOdYfS6Ukx1XfUCXlC9Nt0v5E1ao/WWm4Y
         yNFsqyd3dY8VyTzAbo/8gUDldeOSuYrEmUwSTgtjl2pXGoC1PI/bzAyupfasfm2ylv
         VnnkXDOuUbVyVbsTLtmocQadsFuTa2+rN32Rg6Ys=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Matej Dujava <mdujava@kocurkovo.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-fbdev@vger.kernel.org,
        devel@driverdev.osuosl.org
Subject: [PATCH AUTOSEL 4.9 34/80] staging: sm750fb: add missing case while setting FB_VISUAL
Date:   Wed, 17 Jun 2020 21:27:33 -0400
Message-Id: <20200618012819.609778-34-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618012819.609778-1-sashal@kernel.org>
References: <20200618012819.609778-1-sashal@kernel.org>
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
index 86ace1449309..ee54711cf8e8 100644
--- a/drivers/staging/sm750fb/sm750.c
+++ b/drivers/staging/sm750fb/sm750.c
@@ -897,6 +897,7 @@ static int lynxfb_set_fbinfo(struct fb_info *info, int index)
 		fix->visual = FB_VISUAL_PSEUDOCOLOR;
 		break;
 	case 16:
+	case 24:
 	case 32:
 		fix->visual = FB_VISUAL_TRUECOLOR;
 		break;
-- 
2.25.1

