Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D635313F229
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 19:33:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391817AbgAPSdf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 13:33:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:59992 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391816AbgAPRYv (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:24:51 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8E64F246B6;
        Thu, 16 Jan 2020 17:24:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579195490;
        bh=cIPEba41vQU7K3z8IlNqQquXjet5Msndflxao2tfQ4w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DfBRBH4rjV1AfaNZ3Vx8aTIldDCwVkRINIojdGcnu9GuBxnMuFNN6gjn9MUR9rBce
         uojfvj4TWub9G9OaYekzZwj+b71v8Xyl2/2oTge8d5aVIYMOf9Jdvm9wAXK7oAlI03
         kVXo1dqOxAzhKJgh9zgIlIg/Bkhr8V+9DMl7hjPk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Simon Horman <horms+renesas@verge.net.au>,
        Sasha Levin <sashal@kernel.org>,
        linux-renesas-soc@vger.kernel.org, linux-gpio@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 093/371] pinctrl: sh-pfc: emev2: Add missing pinmux functions
Date:   Thu, 16 Jan 2020 12:19:25 -0500
Message-Id: <20200116172403.18149-36-sashal@kernel.org>
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

[ Upstream commit 1ecd8c9cb899ae277e6986ae134635cb1a50f5de ]

The err_rst_reqb, ext_clki, lowpwr, and ref_clko pin groups are present,
but no pinmux functions refer to them, hence they can not be selected.

Fixes: 1e7d5d849cf4f0c5 ("sh-pfc: Add emev2 pinmux support")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Simon Horman <horms+renesas@verge.net.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/sh-pfc/pfc-emev2.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/pinctrl/sh-pfc/pfc-emev2.c b/drivers/pinctrl/sh-pfc/pfc-emev2.c
index 1cbbe04d7df6..eafd8edbcbe9 100644
--- a/drivers/pinctrl/sh-pfc/pfc-emev2.c
+++ b/drivers/pinctrl/sh-pfc/pfc-emev2.c
@@ -1263,6 +1263,14 @@ static const char * const dtv_groups[] = {
 	"dtv_b",
 };
 
+static const char * const err_rst_reqb_groups[] = {
+	"err_rst_reqb",
+};
+
+static const char * const ext_clki_groups[] = {
+	"ext_clki",
+};
+
 static const char * const iic0_groups[] = {
 	"iic0",
 };
@@ -1285,6 +1293,10 @@ static const char * const lcd_groups[] = {
 	"yuv3",
 };
 
+static const char * const lowpwr_groups[] = {
+	"lowpwr",
+};
+
 static const char * const ntsc_groups[] = {
 	"ntsc_clk",
 	"ntsc_data",
@@ -1298,6 +1310,10 @@ static const char * const pwm1_groups[] = {
 	"pwm1",
 };
 
+static const char * const ref_clko_groups[] = {
+	"ref_clko",
+};
+
 static const char * const sd_groups[] = {
 	"sd_cki",
 };
@@ -1391,13 +1407,17 @@ static const struct sh_pfc_function pinmux_functions[] = {
 	SH_PFC_FUNCTION(cam),
 	SH_PFC_FUNCTION(cf),
 	SH_PFC_FUNCTION(dtv),
+	SH_PFC_FUNCTION(err_rst_reqb),
+	SH_PFC_FUNCTION(ext_clki),
 	SH_PFC_FUNCTION(iic0),
 	SH_PFC_FUNCTION(iic1),
 	SH_PFC_FUNCTION(jtag),
 	SH_PFC_FUNCTION(lcd),
+	SH_PFC_FUNCTION(lowpwr),
 	SH_PFC_FUNCTION(ntsc),
 	SH_PFC_FUNCTION(pwm0),
 	SH_PFC_FUNCTION(pwm1),
+	SH_PFC_FUNCTION(ref_clko),
 	SH_PFC_FUNCTION(sd),
 	SH_PFC_FUNCTION(sdi0),
 	SH_PFC_FUNCTION(sdi1),
-- 
2.20.1

