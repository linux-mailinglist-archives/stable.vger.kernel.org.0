Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D02C765797F
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:02:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233510AbiL1PCn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:02:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233520AbiL1PCE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:02:04 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D28513DC9
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:01:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3FE30B81717
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:01:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB059C433D2;
        Wed, 28 Dec 2022 15:01:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672239696;
        bh=omBc3ScJUWtsOWSPluRFNtly+g4OLl7z5Xs4Hj3y6IQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zAwTCxc9UCl75t0cAF9rx5DmxUET2/jaIRySxOa3PmOmBTwXmJ+sod8ly9PKS+MW2
         cHzuslFMVsTb4b9cS06Oh+EC2RMD33r0j1TrgbhD3TnY7a8YLHhmxTtuZKsYoLidxF
         gvzu4dNb0W6+vi2x8gVFjT1c/VX2v26ASQD6ccCY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0065/1073] arm64: dts: mt2712-evb: Fix vproc fixed regulators unit names
Date:   Wed, 28 Dec 2022 15:27:33 +0100
Message-Id: <20221228144329.856631352@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
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

From: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>

[ Upstream commit 377063156893bf6c088309ac799fe5c6dce2822d ]

Update the names to regulator-vproc-buck{0,1} to fix unit_addres_vs_reg
warnings for those.

Fixes: f75dd8bdd344 ("arm64: dts: mediatek: add mt2712 cpufreq related device nodes")
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://lore.kernel.org/r/20221013152212.416661-6-angelogioacchino.delregno@collabora.com
Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt2712-evb.dts | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/mediatek/mt2712-evb.dts b/arch/arm64/boot/dts/mediatek/mt2712-evb.dts
index 9b1af9c80130..638908773706 100644
--- a/arch/arm64/boot/dts/mediatek/mt2712-evb.dts
+++ b/arch/arm64/boot/dts/mediatek/mt2712-evb.dts
@@ -26,14 +26,14 @@ chosen {
 		stdout-path = "serial0:921600n8";
 	};
 
-	cpus_fixed_vproc0: fixedregulator@0 {
+	cpus_fixed_vproc0: regulator-vproc-buck0 {
 		compatible = "regulator-fixed";
 		regulator-name = "vproc_buck0";
 		regulator-min-microvolt = <1000000>;
 		regulator-max-microvolt = <1000000>;
 	};
 
-	cpus_fixed_vproc1: fixedregulator@1 {
+	cpus_fixed_vproc1: regulator-vproc-buck1 {
 		compatible = "regulator-fixed";
 		regulator-name = "vproc_buck1";
 		regulator-min-microvolt = <1000000>;
-- 
2.35.1



