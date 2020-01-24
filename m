Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B55B147C33
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 10:50:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731193AbgAXJt6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 04:49:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:50538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730321AbgAXJt6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 04:49:58 -0500
Received: from localhost (unknown [145.15.244.15])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6FDFE20718;
        Fri, 24 Jan 2020 09:49:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579859398;
        bh=8DUr0XJniirH8876wu3ciyN2L3R147bhI/RTwJO5dzU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=un0eAzvDXJYPlVtgW1uiroEjUzwB2AiKbhJENeFCD4Msp7kOwmPZEkFlVjaKZi9Nk
         2LzpcbFM48GQXs65j6cAIS3vCcZYg8mXTyz6Z80fwgBT8EzPPfQ20e3g5kjK3mOgJq
         fS/W2eU9o3CJATWDRJarOTPDsdcmbmGHjEyUAMCQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Simon Horman <horms+renesas@verge.net.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 100/343] pinctrl: sh-pfc: emev2: Add missing pinmux functions
Date:   Fri, 24 Jan 2020 10:28:38 +0100
Message-Id: <20200124092933.219791616@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124092919.490687572@linuxfoundation.org>
References: <20200124092919.490687572@linuxfoundation.org>
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



