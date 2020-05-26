Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D7E21E2DAE
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 21:25:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391845AbgEZTXZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 15:23:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:38402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391839AbgEZTJR (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 15:09:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C752020776;
        Tue, 26 May 2020 19:09:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590520157;
        bh=QugstcFABO9RP4budpXl3RxOzu6yYgeWrzluexp1PQc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BJ17AbRkcWsnnPAp9XPa65sSX+xvBz2T/TD+nwb/CRN53pAPJVw4ITzHZ4cgoZI3T
         v6nsXeVp4ih9Jh/9eV56zGk6gbK+/qPC0IrX+O/+nsY/M2r1cEq/XZ49oYFUPxx/17
         JqMzyBil6P4yWJqXqkdq8ZST/4CCY6oPMEOGpWck=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 081/111] media: fdp1: Fix R-Car M3-N naming in debug message
Date:   Tue, 26 May 2020 20:53:39 +0200
Message-Id: <20200526183940.584206407@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200526183932.245016380@linuxfoundation.org>
References: <20200526183932.245016380@linuxfoundation.org>
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
index cb93a13e1777..97bed45360f0 100644
--- a/drivers/media/platform/rcar_fdp1.c
+++ b/drivers/media/platform/rcar_fdp1.c
@@ -2369,7 +2369,7 @@ static int fdp1_probe(struct platform_device *pdev)
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



