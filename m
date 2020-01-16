Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0534F13EA3C
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 18:43:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405867AbgAPRnK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 12:43:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:33102 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405855AbgAPRnK (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:43:10 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AD82324695;
        Thu, 16 Jan 2020 17:43:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579196589;
        bh=ula/axhpgqbW6VnDC7/ZBD5oh5V4mW5kS71pmEs39M8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E1QL5pvlzdbd+Ucc1pI2r7i9Tz/4VAHjF7oJBXtVQSeYOwFMdGWs/IX+ZU99tRarv
         8vnWBF/sWlqu8OTFVHMi+2i5AUYQTvw9Earw9E31a38h6VSwTxhTcI7vO+xWldnSfg
         n6OXALCaMadEr9RwUL2EfF/LR/4Ecg4H4vOQ9o7k=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Simon Horman <horms+renesas@verge.net.au>,
        Sasha Levin <sashal@kernel.org>,
        linux-renesas-soc@vger.kernel.org, linux-gpio@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 013/174] pinctrl: sh-pfc: sh73a0: Add missing TO pin to tpu4_to3 group
Date:   Thu, 16 Jan 2020 12:40:10 -0500
Message-Id: <20200116174251.24326-13-sashal@kernel.org>
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

[ Upstream commit 124cde98f856b6206b804acbdec3b7c80f8c3427 ]

The tpu4_to3_mux[] array contains the TPU4TO3 pin mark, but the
tpu4_to3_pins[] array lacks the corresponding pin number.

Add the missing pin number, for non-GPIO pin F26.

Fixes: 5da4eb049de803c7 ("sh-pfc: sh73a0: Add TPU pin groups and functions")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Simon Horman <horms+renesas@verge.net.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/sh-pfc/pfc-sh73a0.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pinctrl/sh-pfc/pfc-sh73a0.c b/drivers/pinctrl/sh-pfc/pfc-sh73a0.c
index 6a69c8c5d943..ea5da5dcad2c 100644
--- a/drivers/pinctrl/sh-pfc/pfc-sh73a0.c
+++ b/drivers/pinctrl/sh-pfc/pfc-sh73a0.c
@@ -2672,6 +2672,7 @@ static const unsigned int tpu4_to2_mux[] = {
 };
 static const unsigned int tpu4_to3_pins[] = {
 	/* TO */
+	PIN_NUMBER(6, 26),
 };
 static const unsigned int tpu4_to3_mux[] = {
 	TPU4TO3_MARK,
-- 
2.20.1

