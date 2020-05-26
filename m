Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5ABF1E2E76
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 21:30:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390996AbgEZTBt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 15:01:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:56376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390989AbgEZTBt (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 15:01:49 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7590B20849;
        Tue, 26 May 2020 19:01:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590519708;
        bh=i15o/thoqPs7wyQ8n5+tE4bTwZQkNthqhUdafCYB09U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YQQSY2hyPPM1N/dyDE5k312el1LXvNrnl+fKKK/iEvfpzKGLbvk9ou9G0adJXbtTG
         HXDgUhjsE9puuTdENQTQ+2j+8rNYuhsHET7cX+mUELEZ+rmNv0AvqDc4G8u2iEIed7
         VuUwT04l+A/+C5Fsw54xIW2+p/1yNhHD1b7reJ/E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 46/59] media: fdp1: Fix R-Car M3-N naming in debug message
Date:   Tue, 26 May 2020 20:53:31 +0200
Message-Id: <20200526183921.702235995@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200526183907.123822792@linuxfoundation.org>
References: <20200526183907.123822792@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit c05b9d7b9f3ece2831e4e4829f10e904df296df8 ]

The official name is "R-Car M3-N", not "R-Car M3N".

Fixes: 4e8c120de9268fc2 ("media: fdp1: Support M3N and E3 platforms")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/rcar_fdp1.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/rcar_fdp1.c b/drivers/media/platform/rcar_fdp1.c
index d8d406c79cfa..5965e34e36cc 100644
--- a/drivers/media/platform/rcar_fdp1.c
+++ b/drivers/media/platform/rcar_fdp1.c
@@ -2372,7 +2372,7 @@ static int fdp1_probe(struct platform_device *pdev)
 		dprintk(fdp1, "FDP1 Version R-Car H3\n");
 		break;
 	case FD1_IP_M3N:
-		dprintk(fdp1, "FDP1 Version R-Car M3N\n");
+		dprintk(fdp1, "FDP1 Version R-Car M3-N\n");
 		break;
 	case FD1_IP_E3:
 		dprintk(fdp1, "FDP1 Version R-Car E3\n");
-- 
2.25.1



