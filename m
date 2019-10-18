Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1C4BDD2D9
	for <lists+stable@lfdr.de>; Sat, 19 Oct 2019 00:16:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387743AbfJRWIZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Oct 2019 18:08:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:40788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387718AbfJRWIX (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 18 Oct 2019 18:08:23 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CC1F0222D4;
        Fri, 18 Oct 2019 22:08:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571436502;
        bh=TQNB6+YYrNI4qrmWcNwpXm8lQBVbYfOD1DIc59zaRi0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qcm9p+6O+cTlCKzCvuuDWTvZS2eegtvWDZHF3qsBmeJ0KOLRHnsIssnDpoKiIxdKt
         t027WLcR48+fDg2VjcL+qI80YE7RZdD6/0/LNwxnwD1kDCmX1Cszz7922NeqzA8QmN
         WnEPQV8b7it581uD6tlOc4de5njYdaRAI4n3f18Y=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Lucas=20A=2E=20M=2E=20Magalh=C3=A3es?= 
        <lucmaga@gmail.com>, Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 15/56] media: vimc: Remove unused but set variables
Date:   Fri, 18 Oct 2019 18:07:12 -0400
Message-Id: <20191018220753.10002-15-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191018220753.10002-1-sashal@kernel.org>
References: <20191018220753.10002-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lucas A. M. Magalhães <lucmaga@gmail.com>

[ Upstream commit 5515e414f42bf2769caae15b634004d456658284 ]

Remove unused but set variables to clean up the code and avoid
warning.

Signed-off-by: Lucas A. M. Magalhães <lucmaga@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/vimc/vimc-sensor.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/media/platform/vimc/vimc-sensor.c b/drivers/media/platform/vimc/vimc-sensor.c
index 70cee5c0c89a5..29a16f8a4123c 100644
--- a/drivers/media/platform/vimc/vimc-sensor.c
+++ b/drivers/media/platform/vimc/vimc-sensor.c
@@ -200,13 +200,6 @@ static void *vimc_sen_process_frame(struct vimc_ent_device *ved,
 {
 	struct vimc_sen_device *vsen = container_of(ved, struct vimc_sen_device,
 						    ved);
-	const struct vimc_pix_map *vpix;
-	unsigned int frame_size;
-
-	/* Calculate the frame size */
-	vpix = vimc_pix_map_by_code(vsen->mbus_format.code);
-	frame_size = vsen->mbus_format.width * vpix->bpp *
-		     vsen->mbus_format.height;
 
 	tpg_fill_plane_buffer(&vsen->tpg, 0, 0, vsen->frame);
 	return vsen->frame;
-- 
2.20.1

