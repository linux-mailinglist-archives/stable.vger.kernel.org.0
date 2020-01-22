Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E952F14569F
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 14:36:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729719AbgAVN2J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 08:28:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:50152 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728779AbgAVN2I (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jan 2020 08:28:08 -0500
Received: from localhost (unknown [84.241.205.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 51BC12467C;
        Wed, 22 Jan 2020 13:28:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579699688;
        bh=dHJkzUZ4U78Tm0wYqG+V6Z0tZxmWxXOg08Ge9skjxNU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x9hg4/8KtgjWSmiMr21I6pG7LDYEDy6nbMvNZxmtgHOFRmFqpyIyw3glU4EeVvlp2
         8jAmSAkVS9NkTk6R59VdXT9RPcSDVNn/+wEd9l/dP8pvwU4N+xf1tz2hTHpVpyxkcu
         nPSigK/1Ij59/CzqNtgYzhpo9/Qqw+EjwHhh3Gj0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anson Huang <Anson.Huang@nxp.com>,
        Fabio Estevam <festevam@gmail.com>,
        Shawn Guo <shawnguo@kernel.org>
Subject: [PATCH 5.4 218/222] clk: imx7ulp: Correct system clock source option #7
Date:   Wed, 22 Jan 2020 10:30:04 +0100
Message-Id: <20200122092849.299408794@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200122092833.339495161@linuxfoundation.org>
References: <20200122092833.339495161@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anson Huang <Anson.Huang@nxp.com>

commit 96ac93a7c4bea4eb4186425795c00937d2dd6085 upstream.

In the latest reference manual Rev.0,06/2019, the SCS's option #7
is no longer from upll, it is reserved, update clock driver accordingly.

Fixes: b1260067ac3d ("clk: imx: add imx7ulp clk driver")
Signed-off-by: Anson Huang <Anson.Huang@nxp.com>
Reviewed-by: Fabio Estevam <festevam@gmail.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/clk/imx/clk-imx7ulp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/clk/imx/clk-imx7ulp.c
+++ b/drivers/clk/imx/clk-imx7ulp.c
@@ -24,7 +24,7 @@ static const char * const spll_pfd_sels[
 static const char * const spll_sels[]		= { "spll", "spll_pfd_sel", };
 static const char * const apll_pfd_sels[]	= { "apll_pfd0", "apll_pfd1", "apll_pfd2", "apll_pfd3", };
 static const char * const apll_sels[]		= { "apll", "apll_pfd_sel", };
-static const char * const scs_sels[]		= { "dummy", "sosc", "sirc", "firc", "dummy", "apll_sel", "spll_sel", "upll", };
+static const char * const scs_sels[]		= { "dummy", "sosc", "sirc", "firc", "dummy", "apll_sel", "spll_sel", "dummy", };
 static const char * const ddr_sels[]		= { "apll_pfd_sel", "upll", };
 static const char * const nic_sels[]		= { "firc", "ddr_clk", };
 static const char * const periph_plat_sels[]	= { "dummy", "nic1_bus_clk", "nic1_clk", "ddr_clk", "apll_pfd2", "apll_pfd1", "apll_pfd0", "upll", };


