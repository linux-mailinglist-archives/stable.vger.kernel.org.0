Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E9C613EC6F
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 18:57:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388568AbgAPR4o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 12:56:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:34292 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393999AbgAPRnt (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:43:49 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 739352469C;
        Thu, 16 Jan 2020 17:43:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579196629;
        bh=axg2La1u2nSFtXIepKGu76m1vZXNB7WaZ4RvYE2Pifw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QhQtEov0JR1hsrsHCuRfg52j/voO1xwqhz4FGFhDYjbPbj5LLlThriDSDDkSQRDIj
         emcZiVkSVfWoaG5gGuMGJMCjqRXWHs3XzxGRH16zEP3klImtj8iBGjUiWUmm06guL5
         DSgL22Bdg7gQDFrZ38HWxtmy1agl+1orMMLd83AI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Simon Horman <horms+renesas@verge.net.au>,
        Sasha Levin <sashal@kernel.org>,
        linux-renesas-soc@vger.kernel.org, linux-gpio@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 043/174] pinctrl: sh-pfc: r8a7791: Fix scifb2_data_c pin group
Date:   Thu, 16 Jan 2020 12:40:40 -0500
Message-Id: <20200116174251.24326-43-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116174251.24326-1-sashal@kernel.org>
References: <20200116174251.24326-1-sashal@kernel.org>
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
index f94e34e7f0b0..b2f8898ddb2c 100644
--- a/drivers/pinctrl/sh-pfc/pfc-r8a7791.c
+++ b/drivers/pinctrl/sh-pfc/pfc-r8a7791.c
@@ -4967,7 +4967,7 @@ static const char * const scifb2_groups[] = {
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

