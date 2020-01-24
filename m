Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 822E1147FA1
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:04:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387714AbgAXLDz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:03:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:37852 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387748AbgAXLDy (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:03:54 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 635E82087E;
        Fri, 24 Jan 2020 11:03:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579863834;
        bh=kurrfoO72gOwU8rihewnC6wFUIcPYjuCa9rlqhuMmzg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ddVKjDj9zGD4mZLbDxLMOzHXhWLTEb/sc0EJ312wrP4bkCHqu37oyqsc31ZBlYheG
         JBOaMKUq15HFXkJE+NQos0G85RYQvAh/xPDFPQN8AjsNGrHWsoWwv3PGrUpaGHB7IO
         Xbs1ZL/KKR0BX4BqW6r426nZSANk293fRvWR4+d4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Simon Horman <horms+renesas@verge.net.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 088/639] pinctrl: sh-pfc: r8a7791: Remove bogus marks from vin1_b_data18 group
Date:   Fri, 24 Jan 2020 10:24:18 +0100
Message-Id: <20200124093058.363771650@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit 0d6256cb880166a4111bebce35790019e56b6e1b ]

The vin1_b_data18_mux[] arrays contains pin marks for the 2 LSB bits of
the color components.  The vin1_b_data18_pins[] array rightfully does
not include the corresponding pin numbers, as RGB18 is subset of RGB24,
containing only the 6 MSB bits of each component.

Fixes: 8e32c9671f84acd8 ("pinctrl: sh-pfc: r8a7791: Add VIN pins")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Simon Horman <horms+renesas@verge.net.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/sh-pfc/pfc-r8a7791.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/pinctrl/sh-pfc/pfc-r8a7791.c b/drivers/pinctrl/sh-pfc/pfc-r8a7791.c
index f5b4255570b28..6236ac55c65d3 100644
--- a/drivers/pinctrl/sh-pfc/pfc-r8a7791.c
+++ b/drivers/pinctrl/sh-pfc/pfc-r8a7791.c
@@ -4374,17 +4374,14 @@ static const unsigned int vin1_b_data18_pins[] = {
 };
 static const unsigned int vin1_b_data18_mux[] = {
 	/* B */
-	VI1_DATA0_B_MARK, VI1_DATA1_B_MARK,
 	VI1_DATA2_B_MARK, VI1_DATA3_B_MARK,
 	VI1_DATA4_B_MARK, VI1_DATA5_B_MARK,
 	VI1_DATA6_B_MARK, VI1_DATA7_B_MARK,
 	/* G */
-	VI1_G0_B_MARK, VI1_G1_B_MARK,
 	VI1_G2_B_MARK, VI1_G3_B_MARK,
 	VI1_G4_B_MARK, VI1_G5_B_MARK,
 	VI1_G6_B_MARK, VI1_G7_B_MARK,
 	/* R */
-	VI1_R0_B_MARK, VI1_R1_B_MARK,
 	VI1_R2_B_MARK, VI1_R3_B_MARK,
 	VI1_R4_B_MARK, VI1_R5_B_MARK,
 	VI1_R6_B_MARK, VI1_R7_B_MARK,
-- 
2.20.1



