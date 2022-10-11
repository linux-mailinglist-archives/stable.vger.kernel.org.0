Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52CB95FB538
	for <lists+stable@lfdr.de>; Tue, 11 Oct 2022 16:52:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230187AbiJKOwY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Oct 2022 10:52:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230010AbiJKOvN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Oct 2022 10:51:13 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDF1E97EC8;
        Tue, 11 Oct 2022 07:50:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 44A55CE1748;
        Tue, 11 Oct 2022 14:50:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA1A2C433C1;
        Tue, 11 Oct 2022 14:50:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665499849;
        bh=ja63l6fWkyIo6KJfs31Ijpq9Ie4oX6paXQj4eLkITmM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UzrYmL2v1LJVzoCgm/cfC8A3uKCONoNJenue5Yjs1xQTllxmh+L1SccR/0S07MYOT
         lKq+e/4fMzWhpaOBxx4syhYaTbWa4SU50W89nBVCQsBHgyAuIYy4AuoJtUQpUvcE7/
         jty3AUTHfwOXs6kvonpLjmyUlgtBT2QR/vZ729sfeWXGFRqYXcEKXC8ZiL9wCBcqRk
         VIF5JefnP+5mZ1bBMxPMmOcEEIgd/x/RRP/fuoHKOkPXepp5UxnkdHoi0CqmWwITQP
         WCsd/F2PTYbFkMwFmOqolGT/w7JQXZWj2s+tTSFGFTtbcG1e2WQFnKFT+0wuOG82H1
         DhyJwnTqZfTwg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Marcel Ziswiler <marcel.ziswiler@toradex.com>,
        Peng Fan <peng.fan@nxp.com>, Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>, robh+dt@kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 6.0 20/46] arm64: dts: imx8ulp: no executable source file permission
Date:   Tue, 11 Oct 2022 10:49:48 -0400
Message-Id: <20221011145015.1622882-20-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221011145015.1622882-1-sashal@kernel.org>
References: <20221011145015.1622882-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marcel Ziswiler <marcel.ziswiler@toradex.com>

[ Upstream commit 7db9905d48e1b9a97a28224c5a201262ebce7489 ]

This fixes the following error:

arch/arm64/boot/dts/freescale/imx8ulp-pinfunc.h: error: do not set
 execute permissions for source files

Signed-off-by: Marcel Ziswiler <marcel.ziswiler@toradex.com>
Acked-by: Peng Fan <peng.fan@nxp.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8ulp-pinfunc.h | 0
 1 file changed, 0 insertions(+), 0 deletions(-)
 mode change 100755 => 100644 arch/arm64/boot/dts/freescale/imx8ulp-pinfunc.h

diff --git a/arch/arm64/boot/dts/freescale/imx8ulp-pinfunc.h b/arch/arm64/boot/dts/freescale/imx8ulp-pinfunc.h
old mode 100755
new mode 100644
-- 
2.35.1

