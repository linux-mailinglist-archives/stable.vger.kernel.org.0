Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4E4E499B01
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:59:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376776AbiAXVsn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:48:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1457503AbiAXVlo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:41:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B70CC07E32C;
        Mon, 24 Jan 2022 12:29:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 42628B811F9;
        Mon, 24 Jan 2022 20:29:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 704C6C340E7;
        Mon, 24 Jan 2022 20:29:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643056147;
        bh=38atHOSDcEAA8WktNXrsyJ35lYSwBYWTpW+4G2AjEqA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zYCncYXXKPThed0I9oXH2Eql6AtE2I5iWOqRW9RvnUga2aUQ16pe8EIoyQF1w5O9c
         /PI7CP1vA86xK5PnbQA/pNkc2HdPZ30PKN/6OTHGzrB+DxmUhioTlHxWUq9YKaLxoA
         v3c3g4gyj2fYAdHbzzxPNedWLmqNQZCRLkb4epJc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 386/846] ASoC: codecs: wcd938x: add SND_SOC_WCD938_SDW to codec list instead
Date:   Mon, 24 Jan 2022 19:38:23 +0100
Message-Id: <20220124184114.247731149@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lukas Bulwahn <lukas.bulwahn@gmail.com>

[ Upstream commit 2039cc1da4bee1fd0df644e26b28ed769cd32a81 ]

Commit 045442228868 ("ASoC: codecs: wcd938x: add audio routing and
Kconfig") adds SND_SOC_WCD937X, which does not exist, and
SND_SOC_WCD938X, which seems not really to be the intended config to be
selected, but only a supporting config symbol to the actual config
SND_SOC_WCD938X_SDW for the codec.

Add SND_SOC_WCD938_SDW to the list instead of SND_SOC_WCD93{7,8}X.

The issue was identified with ./scripts/checkkconfigsymbols.py.

Fixes: 045442228868 ("ASoC: codecs: wcd938x: add audio routing and Kconfig")
Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Link: https://lore.kernel.org/r/20211125095158.8394-3-lukas.bulwahn@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/Kconfig | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/sound/soc/codecs/Kconfig b/sound/soc/codecs/Kconfig
index 216cea04ad704..f12c9b9426788 100644
--- a/sound/soc/codecs/Kconfig
+++ b/sound/soc/codecs/Kconfig
@@ -235,8 +235,7 @@ config SND_SOC_ALL_CODECS
 	imply SND_SOC_UDA1380
 	imply SND_SOC_WCD9335
 	imply SND_SOC_WCD934X
-	imply SND_SOC_WCD937X
-	imply SND_SOC_WCD938X
+	imply SND_SOC_WCD938X_SDW
 	imply SND_SOC_LPASS_RX_MACRO
 	imply SND_SOC_LPASS_TX_MACRO
 	imply SND_SOC_WL1273
-- 
2.34.1



