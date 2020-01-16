Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50E3413F220
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 19:33:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436722AbgAPSdQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 13:33:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:60092 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403837AbgAPRYx (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:24:53 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 429912468D;
        Thu, 16 Jan 2020 17:24:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579195493;
        bh=qAJVdmPz7SId3e3ffjn7MuWUJTLbtffxPCjvPdE4Zks=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QTRKcdUHlcsKMhuYZ8nvcbnDfxC+JsI4FgJ1OoC0Q08hbWqpiUJlJOCSJPYd7beKh
         hCs18qkhTMbJMrrr5CWWUkixJ7NHHrk5+GP2VcBv6MDgn1ouOhAOC9rAuTy/tlL9It
         gRT1vUhpQpvuiEX7r7xL6TUNyB6YCC48Aaz/Ulxg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Simon Horman <horms+renesas@verge.net.au>,
        Sasha Levin <sashal@kernel.org>,
        linux-renesas-soc@vger.kernel.org, linux-gpio@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 095/371] pinctrl: sh-pfc: r8a7792: Fix vin1_data18_b pin group
Date:   Thu, 16 Jan 2020 12:19:27 -0500
Message-Id: <20200116172403.18149-38-sashal@kernel.org>
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

[ Upstream commit b9fd50488b4939ce5b3a026d29e752e17c2d1800 ]

The vin1_data18_b pin group itself is present, but it is not listed in
the VIN1 pin group array, and thus cannot be selected.

Fixes: 7dd74bb1f058786e ("pinctrl: sh-pfc: r8a7792: Add VIN pin groups")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Simon Horman <horms+renesas@verge.net.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/sh-pfc/pfc-r8a7792.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pinctrl/sh-pfc/pfc-r8a7792.c b/drivers/pinctrl/sh-pfc/pfc-r8a7792.c
index cc3597f66605..46c41ca6ea38 100644
--- a/drivers/pinctrl/sh-pfc/pfc-r8a7792.c
+++ b/drivers/pinctrl/sh-pfc/pfc-r8a7792.c
@@ -1916,6 +1916,7 @@ static const char * const vin1_groups[] = {
 	"vin1_data8",
 	"vin1_data24_b",
 	"vin1_data20_b",
+	"vin1_data18_b",
 	"vin1_data16_b",
 	"vin1_sync",
 	"vin1_field",
-- 
2.20.1

