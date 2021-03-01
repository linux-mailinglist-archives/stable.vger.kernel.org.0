Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0350D328D7A
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:13:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238219AbhCATMB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:12:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:37270 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240870AbhCATGe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:06:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 68E5264E51;
        Mon,  1 Mar 2021 17:48:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614620899;
        bh=mh/PkrWc3G3eb91YTKXcYaPCzUpGXX+T7sOAjuonuog=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EiY8ZeRWk1lfPQVY2Wm8ME2NFCrFSxdr9De1lvb7fp8iBSyzwFAFrz44mLin+W8Y6
         vtac0FCyZd4zd8pLhquBGLIIu8IN0WacyL+u79I8v4t38VGhEkIBvLIYAHYfhiIO+Z
         SK0qR58erM8eor+NhEFnYkt/mGBUNNUA/x8XiA6Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 320/775] clk: renesas: r8a779a0: Remove non-existent S2 clock
Date:   Mon,  1 Mar 2021 17:08:08 +0100
Message-Id: <20210301161217.428538668@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit 5b30be15ca262d9cb2c36b173bb488e8d1952ea0 ]

The S2 internal core clock does not exist on R-Car V3U. Remove it.

Fixes: 17bcc8035d2d19fc ("clk: renesas: cpg-mssr: Add support for R-Car V3U")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Tested-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Link: https://lore.kernel.org/r/20201019120614.22149-2-geert+renesas@glider.be
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/renesas/r8a779a0-cpg-mssr.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/clk/renesas/r8a779a0-cpg-mssr.c b/drivers/clk/renesas/r8a779a0-cpg-mssr.c
index aa5389b04d742..9ccefc36b7ca8 100644
--- a/drivers/clk/renesas/r8a779a0-cpg-mssr.c
+++ b/drivers/clk/renesas/r8a779a0-cpg-mssr.c
@@ -69,7 +69,6 @@ enum clk_ids {
 	CLK_PLL5_DIV2,
 	CLK_PLL5_DIV4,
 	CLK_S1,
-	CLK_S2,
 	CLK_S3,
 	CLK_SDSRC,
 	CLK_RPCSRC,
-- 
2.27.0



