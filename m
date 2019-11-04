Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2CB3EEC9D
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 22:58:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730842AbfKDV6y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 16:58:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:55974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729804AbfKDV6x (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Nov 2019 16:58:53 -0500
Received: from localhost (6.204-14-84.ripe.coltfrance.com [84.14.204.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1EE4D214E0;
        Mon,  4 Nov 2019 21:58:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572904732;
        bh=5lwm5aHSV+vFhzsKNzTGTuGddmHkxCu6wDISBI82sz4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RaLjA9LgM17A9MDJ7alr52p3Q0AtU0LMWZWv6w98r9RKGvvtVGvs7UDakH4WE5Qs6
         nR9l/8QvPqSDVhWBf7U9DSCf2klq9Vvj+lPpV5cQjI+wGshJnp4+sej6DYGWYpQluT
         74mUsi1fnmPSmpc2+J+B6hCmMUIJm/HRChVinGHo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "=?UTF-8?q?Lucas=20A . =20M . =20Magalh=C3=A3es?=" 
        <lucmaga@gmail.com>, Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 051/149] media: vimc: Remove unused but set variables
Date:   Mon,  4 Nov 2019 22:44:04 +0100
Message-Id: <20191104212139.695013724@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191104212126.090054740@linuxfoundation.org>
References: <20191104212126.090054740@linuxfoundation.org>
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
index 9e0d70e9f119c..3f0ffd4915cd2 100644
--- a/drivers/media/platform/vimc/vimc-sensor.c
+++ b/drivers/media/platform/vimc/vimc-sensor.c
@@ -204,13 +204,6 @@ static void *vimc_sen_process_frame(struct vimc_ent_device *ved,
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



