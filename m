Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9DBB913EEE9
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 19:12:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393178AbgAPRhS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 12:37:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:52470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393172AbgAPRhS (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:37:18 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1AF4E246CA;
        Thu, 16 Jan 2020 17:37:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579196237;
        bh=7A14jb2PjfoR+fEvkt84buZ8GcXTgrnwQi2RbaAjuos=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ebleJ6G/ZXVb0TdEnN5Tbi0q3oeQEgpLUYkSnI2SqctoXvpGlgJi5nWUu6NYEQGjS
         0260Wz0OWiRoal2VMGDctKr/ZIzJms7qhKqXdJMHRZVTZfuE9l4CTOM3/8gfVI5TPu
         ymYVXZxxeqVDur7Yf2wg21IgrCfOyCM/H2PeqwfQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Simon Horman <horms+renesas@verge.net.au>,
        Sasha Levin <sashal@kernel.org>,
        linux-renesas-soc@vger.kernel.org, linux-gpio@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 068/251] pinctrl: sh-pfc: r8a7792: Fix vin1_data18_b pin group
Date:   Thu, 16 Jan 2020 12:33:37 -0500
Message-Id: <20200116173641.22137-28-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116173641.22137-1-sashal@kernel.org>
References: <20200116173641.22137-1-sashal@kernel.org>
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
index 21badb6166b9..97998929db93 100644
--- a/drivers/pinctrl/sh-pfc/pfc-r8a7792.c
+++ b/drivers/pinctrl/sh-pfc/pfc-r8a7792.c
@@ -1863,6 +1863,7 @@ static const char * const vin1_groups[] = {
 	"vin1_data8",
 	"vin1_data24_b",
 	"vin1_data20_b",
+	"vin1_data18_b",
 	"vin1_data16_b",
 	"vin1_sync",
 	"vin1_field",
-- 
2.20.1

