Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8057013E74C
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 18:25:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403834AbgAPRYx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 12:24:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:60056 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403826AbgAPRYw (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:24:52 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BFDFE246BF;
        Thu, 16 Jan 2020 17:24:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579195491;
        bh=b26Sz2FnOtNNDdBBefrjpx6WRYWcTY/t6YuI1aLeYjI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jST6uzzJQZVhUc204sES0GosujhjGRmnLHwlV5d/QXqypAcpcuR9FWwOak/Acm5Zo
         FajQGTbPoI02NL6+hJtSmSOqXdWi8Z5Dg7OTItUYlwcWZAM7AxhdiAc/Em4d3dpvs0
         5Qn6SLYvqcP8MdubNgrVQNSBh+ytythLAAUWiud4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Simon Horman <horms+renesas@verge.net.au>,
        Sasha Levin <sashal@kernel.org>,
        linux-renesas-soc@vger.kernel.org, linux-gpio@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 094/371] pinctrl: sh-pfc: r8a7791: Fix scifb2_data_c pin group
Date:   Thu, 16 Jan 2020 12:19:26 -0500
Message-Id: <20200116172403.18149-37-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116172403.18149-1-sashal@kernel.org>
References: <20200116172403.18149-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit a4b0350047f1b10207e25e72d7cd3f7826e93769 ]

The entry for "scifb2_data_c" in the SCIFB2 pin group array contains a
typo, thus the group cannot be selected.

Fixes: 5088451962389924 ("pinctrl: sh-pfc: r8a7791 PFC support")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Simon Horman <horms+renesas@verge.net.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/sh-pfc/pfc-r8a7791.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/sh-pfc/pfc-r8a7791.c b/drivers/pinctrl/sh-pfc/pfc-r8a7791.c
index d34982ea66bf..e4774b220040 100644
--- a/drivers/pinctrl/sh-pfc/pfc-r8a7791.c
+++ b/drivers/pinctrl/sh-pfc/pfc-r8a7791.c
@@ -5209,7 +5209,7 @@ static const char * const scifb2_groups[] = {
 	"scifb2_data_b",
 	"scifb2_clk_b",
 	"scifb2_ctrl_b",
-	"scifb0_data_c",
+	"scifb2_data_c",
 	"scifb2_clk_c",
 	"scifb2_data_d",
 };
-- 
2.20.1

