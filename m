Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D47214BA40
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:38:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730003AbgA1OT1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:19:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:43802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730385AbgA1OT1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:19:27 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 324EC24681;
        Tue, 28 Jan 2020 14:19:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580221166;
        bh=8DUr0XJniirH8876wu3ciyN2L3R147bhI/RTwJO5dzU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Jycdo+f3XbYvghKJgpDCWxMw7HSyip/GdC9YuCh9hIH+onw7JgGmcu0a0bDENfeHg
         eLRDKiUItCwvUfisVuEOCCjTiLdE9mwAFDSeg4V5g5x47RZCRiNi7+/T7XNSgak6Xq
         WLP96GbmNusPPB3YO3cNA9wy6aG9n+tw9z2tPpGM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Simon Horman <horms+renesas@verge.net.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 068/271] pinctrl: sh-pfc: emev2: Add missing pinmux functions
Date:   Tue, 28 Jan 2020 15:03:37 +0100
Message-Id: <20200128135857.662855646@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135852.449088278@linuxfoundation.org>
References: <20200128135852.449088278@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 1cbbe04d7df65..eafd8edbcbe95 100644
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



