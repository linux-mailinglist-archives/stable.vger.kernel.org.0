Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6842A63581F
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:52:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236932AbiKWJuz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:50:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236292AbiKWJuI (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:50:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04661BCB
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:47:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8E5FE61B7F
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:47:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79971C433C1;
        Wed, 23 Nov 2022 09:47:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669196857;
        bh=r5ny8RYTNd0a7LdNCJJ/gy6kbq18AjXM1dEl0OjjLiE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EyR6KDqoxhzDr9eMYLrWctICvTuZ+xm5tr/2IVM6RvFGyey/hV9ioobXRoFXVog0Z
         qge7sNz9MmWkedxpKyWZqbsWyHgHlw1WQL7WizNItNe3/4MHjBGcw0xBrsMaX1Ov0D
         wqVfjUVLjxxp3/bHHJgRCJdIGrKGyG6ppkXOteUo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Peng Fan <peng.fan@nxp.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 136/314] arm64: dts: imx93-pinfunc: drop execution permission
Date:   Wed, 23 Nov 2022 09:49:41 +0100
Message-Id: <20221123084631.703263834@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peng Fan <peng.fan@nxp.com>

[ Upstream commit 2db1fdb25d209a88112fd82eb493976d66057d10 ]

Drop the header file execution permission

Signed-off-by: Peng Fan <peng.fan@nxp.com>
Fixes: ec8b5b5058ea ("arm64: dts: freescale: Add i.MX93 dtsi support")
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx93-pinfunc.h | 0
 1 file changed, 0 insertions(+), 0 deletions(-)
 mode change 100755 => 100644 arch/arm64/boot/dts/freescale/imx93-pinfunc.h

diff --git a/arch/arm64/boot/dts/freescale/imx93-pinfunc.h b/arch/arm64/boot/dts/freescale/imx93-pinfunc.h
old mode 100755
new mode 100644
-- 
2.35.1



