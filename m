Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B59AF6708
	for <lists+stable@lfdr.de>; Sun, 10 Nov 2019 04:17:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726702AbfKJCkT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Nov 2019 21:40:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:33182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726622AbfKJCkS (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 9 Nov 2019 21:40:18 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9BAD4214E0;
        Sun, 10 Nov 2019 02:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573353617;
        bh=8SPFOrRoN/mrEuHoV96QktHoNh7jF4I73r9+t65ysAY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ztXHEVJlPBwB7/JIeJANfxr+H39lG42mErRwa2pNa/TZ9Tz4aQjxqtCXGV1VyPrT2
         /Z0iQpS6SqwsUAkP2oRiV+xRwUIaUYltDKB3FDv+IsKCRL2FJh5sw0sILEwNr6S02U
         TFO0vXudeolXvUp7pluv573vmkO4qLV5Phz081ok=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Nobuhiro Iwamatsu <iwamatsu@nigauri.org>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 003/191] media: vsp1: Fix vsp1_regs.h license header
Date:   Sat,  9 Nov 2019 21:37:05 -0500
Message-Id: <20191110024013.29782-3-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191110024013.29782-1-sashal@kernel.org>
References: <20191110024013.29782-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

[ Upstream commit 5eea860a6fec1e60709d19832015ee0991d3e80c ]

All source files of the vsp1 driver are licensed under the GPLv2+ except
for vsp1_regs.h which is licensed under GPLv2. This is caused by a bad
copy&paste that dates back from the initial version of the driver. Fix
it.

Acked-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Acked-by: Sergei Shtylyov<sergei.shtylyov@cogentembedded.com>
Acked-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Acked-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Acked-by: Nobuhiro Iwamatsu <iwamatsu@nigauri.org>
Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/vsp1/vsp1_regs.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/vsp1/vsp1_regs.h b/drivers/media/platform/vsp1/vsp1_regs.h
index 3738ff2f7b850..f6e4157095cc0 100644
--- a/drivers/media/platform/vsp1/vsp1_regs.h
+++ b/drivers/media/platform/vsp1/vsp1_regs.h
@@ -1,4 +1,4 @@
-/* SPDX-License-Identifier: GPL-2.0 */
+/* SPDX-License-Identifier: GPL-2.0+ */
 /*
  * vsp1_regs.h  --  R-Car VSP1 Registers Definitions
  *
-- 
2.20.1

