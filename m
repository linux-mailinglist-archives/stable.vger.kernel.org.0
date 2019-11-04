Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44B5EEEBF9
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 22:52:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729730AbfKDVwj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 16:52:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:46234 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730796AbfKDVwj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Nov 2019 16:52:39 -0500
Received: from localhost (6.204-14-84.ripe.coltfrance.com [84.14.204.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BCD252184C;
        Mon,  4 Nov 2019 21:52:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572904358;
        bh=TQNB6+YYrNI4qrmWcNwpXm8lQBVbYfOD1DIc59zaRi0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jiFKqr3C+/wEox/j4vWd3Su1G2hqCjnRR3oMRj1h5pWfLmIUF+sURhN2rYniNQ+zd
         JeYy1/5e95kfAfb+9rpOz6pKNZOHME3Ud2hkVqRP4hPdR1YAAlyKPas4i0dZ/2sctB
         G+8kcOGFFaIS8fT1/7IOkLaFsoVlQ6XS+EzaSYH0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "=?UTF-8?q?Lucas=20A . =20M . =20Magalh=C3=A3es?=" 
        <lucmaga@gmail.com>, Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 20/95] media: vimc: Remove unused but set variables
Date:   Mon,  4 Nov 2019 22:44:18 +0100
Message-Id: <20191104212049.023506026@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191104212038.056365853@linuxfoundation.org>
References: <20191104212038.056365853@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



