Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBE22593E18
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 22:44:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346924AbiHOUgx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 16:36:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345658AbiHOUdu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 16:33:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEF3EAA4D7;
        Mon, 15 Aug 2022 12:05:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 284C6612A0;
        Mon, 15 Aug 2022 19:05:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AE66C433C1;
        Mon, 15 Aug 2022 19:05:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660590353;
        bh=/Lpxmh6bFSCDVgKDrnaHp/eYLGjXz40Fzy1gOOKNKF0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0xMzwWRCZyXozqBOo96/t9Wt83FLLPa6YFTjmzWhOHB/aD0cZpp0qigb+pgFBETOJ
         un8whgAkV0WkOnz2mqv7qaxFL1k9CDQe9WNpZBqGbUUAMYMBXm6yhm03gLJh66v6pF
         YoBGxnZKGPfu9Cvbxo6fvhiRA8WiMssxR0evJ9dE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "=?UTF-8?q?N=C3=ADcolas=20F . =20R . =20A . =20Prado?=" 
        <nfraprado@collabora.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0203/1095] arm64: dts: mt8192: Fix idle-states entry-method
Date:   Mon, 15 Aug 2022 19:53:22 +0200
Message-Id: <20220815180438.051533781@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAD_ENC_HEADER,BAYES_00,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nícolas F. R. A. Prado <nfraprado@collabora.com>

[ Upstream commit 2e599740f7e423ee89fb027896cb2635dd43784f ]

The entry-method property of the idle-states node should be "psci" as
described in the idle-states binding, since this is already the value of
enable-method in the CPU nodes. Fix it to get rid of a dtbs_check
warning.

Fixes: 9260918d3a4f ("arm64: dts: mt8192: Add cpu-idle-states")
Signed-off-by: Nícolas F. R. A. Prado <nfraprado@collabora.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://lore.kernel.org/r/20220617233150.2466344-3-nfraprado@collabora.com
Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt8192.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/mediatek/mt8192.dtsi b/arch/arm64/boot/dts/mediatek/mt8192.dtsi
index 12972828832e..96439a4bce09 100644
--- a/arch/arm64/boot/dts/mediatek/mt8192.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8192.dtsi
@@ -170,7 +170,7 @@ l3_0: l3-cache {
 		};
 
 		idle-states {
-			entry-method = "arm,psci";
+			entry-method = "psci";
 			cpu_sleep_l: cpu-sleep-l {
 				compatible = "arm,idle-state";
 				arm,psci-suspend-param = <0x00010001>;
-- 
2.35.1



