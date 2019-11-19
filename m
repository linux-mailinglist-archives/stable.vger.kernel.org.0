Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5285010147C
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 06:34:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729178AbfKSFeV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:34:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:55066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729636AbfKSFeU (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:34:20 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E549920672;
        Tue, 19 Nov 2019 05:34:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574141659;
        bh=8SPFOrRoN/mrEuHoV96QktHoNh7jF4I73r9+t65ysAY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UPn3OPpVBElJ+5uvVFlRkgx1m3jz0ysuQvTZ6DPST6G0FJ/lAcXcZG27LDBVp8bOt
         CoyNqPmK+QlvJ+hq5tfFt9JqwQs8s3zt4+gWUulNqyWnDw04VcI87DyplkUMU5t3gr
         ioFnLf/vGGTTZ2GC/OJ7Q+IGivSjuFnsz9QaPxVc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Nobuhiro Iwamatsu <iwamatsu@nigauri.org>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 237/422] media: vsp1: Fix vsp1_regs.h license header
Date:   Tue, 19 Nov 2019 06:17:14 +0100
Message-Id: <20191119051414.429195994@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051400.261610025@linuxfoundation.org>
References: <20191119051400.261610025@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



