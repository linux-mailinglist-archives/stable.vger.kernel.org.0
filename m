Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39BA6593D31
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 22:40:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344531AbiHOUc5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 16:32:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348096AbiHOUcE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 16:32:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 912B2EB8;
        Mon, 15 Aug 2022 12:05:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6793961299;
        Mon, 15 Aug 2022 19:05:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B367C433D7;
        Mon, 15 Aug 2022 19:05:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660590316;
        bh=2pSFY/81R6SrMGfluQH+FRx7TgY2KjA23kBWHzmQv9I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0RUiJqjW2Z4ezP2C4bmc5hSgfQwciCQjL2vPe//S8LMtZUB2qqgDhKr3JJ/ibFEQF
         L3OAqeYgWmeRngzK4UzAZI3CnhV0tj9lk9x3aYpWcH3AJelqEMzizQffhEwFqbrxtj
         QZVcHdW40jVawNyqaAqgIWmUiFvbC6pUmNQbnfzE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Chris Paterson <chris.paterson2@renesas.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0221/1095] arm64: dts: renesas: r9a07g054l2-smarc: Correct SoC name in comment
Date:   Mon, 15 Aug 2022 19:53:40 +0200
Message-Id: <20220815180438.841539077@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Paterson <chris.paterson2@renesas.com>

[ Upstream commit d1273f541ab409242e08da6bb836bb564021274c ]

This dts is for the RZ/V2L SMARC EVK, not RZ/G2L.

Fixes: f91c4c74796a ("arm64: dts: renesas: Add initial device tree for RZ/V2L SMARC EVK")
Signed-off-by: Chris Paterson <chris.paterson2@renesas.com>
Link: https://lore.kernel.org/r/20220623103024.24222-1-chris.paterson2@renesas.com
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/renesas/r9a07g054l2-smarc.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/renesas/r9a07g054l2-smarc.dts b/arch/arm64/boot/dts/renesas/r9a07g054l2-smarc.dts
index fc334b4c2aa4..d2848cbfc6c0 100644
--- a/arch/arm64/boot/dts/renesas/r9a07g054l2-smarc.dts
+++ b/arch/arm64/boot/dts/renesas/r9a07g054l2-smarc.dts
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
 /*
- * Device Tree Source for the RZ/G2L SMARC EVK board
+ * Device Tree Source for the RZ/V2L SMARC EVK board
  *
  * Copyright (C) 2021 Renesas Electronics Corp.
  */
-- 
2.35.1



