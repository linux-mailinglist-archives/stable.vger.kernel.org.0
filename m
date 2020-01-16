Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4DD5A13F6C6
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 20:07:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388137AbgAPTG6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 14:06:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:52416 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730172AbgAPRBY (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:01:24 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9DB752077B;
        Thu, 16 Jan 2020 17:01:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194083;
        bh=4rsPsug2hH4OP9DXtOETkYKx2Y264/RLBnDXf25S6G4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tmz37ShPvrDqcYAM7pSvsQ7q+SzBb+mtL6Gzo13VbCFCbDA/RtcpaZW9OFa9ceb6M
         CbEMznfjxdPa7asf/SkOmlMPFzTMymH5t2USOeTjAMIXQdUFdM450hfHg61cdzFJLT
         SaknxPBEjewa6DnkkKH0pmMyqwJLxMIc5J0E9rgA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-sh@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 188/671] media: sh: migor: Include missing dma-mapping header
Date:   Thu, 16 Jan 2020 11:51:37 -0500
Message-Id: <20200116165940.10720-71-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116165940.10720-1-sashal@kernel.org>
References: <20200116165940.10720-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jacopo Mondi <jacopo+renesas@jmondi.org>

[ Upstream commit 5c88ee02932a964096cbbcc7c9f38b78d230bacb ]

Since the removal of the stale soc_camera headers, Migo-R board fails to
build due to missing dma-mapping include directive.

Include missing dma-mapping.h header in Migo-R board file to fix the build
error.

Fixes: a50c7738e8ae ("media: sh: migor: Remove stale soc_camera include")

Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/sh/boards/mach-migor/setup.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/sh/boards/mach-migor/setup.c b/arch/sh/boards/mach-migor/setup.c
index 254f2c662703..6cd3cd468047 100644
--- a/arch/sh/boards/mach-migor/setup.c
+++ b/arch/sh/boards/mach-migor/setup.c
@@ -5,6 +5,7 @@
  * Copyright (C) 2008 Magnus Damm
  */
 #include <linux/clkdev.h>
+#include <linux/dma-mapping.h>
 #include <linux/init.h>
 #include <linux/platform_device.h>
 #include <linux/interrupt.h>
-- 
2.20.1

