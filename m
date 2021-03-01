Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8262F3289D0
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:07:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238404AbhCASGS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:06:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:54728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233567AbhCASAS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:00:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 31F5065035;
        Mon,  1 Mar 2021 17:15:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614618934;
        bh=rWMttxqD0R1N6zVlzXIQCCnyd6NX787FomR6lI2B5BU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M1nKVPFGJ4ZzE6SsW3ce8olR7FJwncIjUGHYCw14XVJ3HkVALNpmMARQ9nyVFSuI8
         /J7z8RWWyjuPloxPF9rWoUJ/o2VJUJCMOu42VTIbw7eEqSW9Kurh9a8GCJxrJcA67v
         QsZBlkhJUxd54mZgsCwJVN5lTcmzOUG9L21mmpmw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 272/663] clk: renesas: r8a779a0: Remove non-existent S2 clock
Date:   Mon,  1 Mar 2021 17:08:40 +0100
Message-Id: <20210301161155.275013408@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
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
index 046d79416b7d0..48c260f09b2d7 100644
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



