Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 936DC55C16E
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 14:45:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238882AbiF0Lyf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 07:54:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238802AbiF0Lwj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 07:52:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB12CBE28;
        Mon, 27 Jun 2022 04:45:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 69AEFB80DFB;
        Mon, 27 Jun 2022 11:45:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7B7FC3411D;
        Mon, 27 Jun 2022 11:45:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656330344;
        bh=B2hSXjbr+rHpgwDe32O/tcnJQcZZzJ7ADtnfxO42u40=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ex7EXjzSB5iNzrwl67cE39evtyBuMAOY1bAQLKATaORBaFf0P4mJk++uzCLhudpt4
         1IOQlVFT6SHnOPpfGB72ZHLv9veFS8Yyp7z2ZIXVHyXpRlkMaq6jEyvgI/SvxMn2d1
         5rCPJk4/yPFIB2oQxmyJmnlXIGO8uuNKoiim2138=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aswath Govindraju <a-govindraju@ti.com>,
        Nishanth Menon <nm@ti.com>
Subject: [PATCH 5.18 165/181] arm64: dts: ti: k3-am64-main: Remove support for HS400 speed mode
Date:   Mon, 27 Jun 2022 13:22:18 +0200
Message-Id: <20220627111949.471277410@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627111944.553492442@linuxfoundation.org>
References: <20220627111944.553492442@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aswath Govindraju <a-govindraju@ti.com>

commit 0c0af88f3f318e73237f7fadd02d0bf2b6c996bb upstream.

AM64 SoC, does not support HS400 and HS200 is the maximum supported speed
mode[1]. Therefore, fix the device tree node to reflect the same.

[1] - https://www.ti.com/lit/ds/symlink/am6442.pdf
      (SPRSP56C – JANUARY 2021 – REVISED FEBRUARY 2022)

Fixes: 8abae9389bdb ("arm64: dts: ti: Add support for AM642 SoC")
Signed-off-by: Aswath Govindraju <a-govindraju@ti.com>
Signed-off-by: Nishanth Menon <nm@ti.com>
Link: https://lore.kernel.org/r/20220512064859.32059-1-a-govindraju@ti.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/ti/k3-am64-main.dtsi |    2 --
 1 file changed, 2 deletions(-)

--- a/arch/arm64/boot/dts/ti/k3-am64-main.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-am64-main.dtsi
@@ -456,13 +456,11 @@
 		clock-names = "clk_ahb", "clk_xin";
 		mmc-ddr-1_8v;
 		mmc-hs200-1_8v;
-		mmc-hs400-1_8v;
 		ti,trm-icp = <0x2>;
 		ti,otap-del-sel-legacy = <0x0>;
 		ti,otap-del-sel-mmc-hs = <0x0>;
 		ti,otap-del-sel-ddr52 = <0x6>;
 		ti,otap-del-sel-hs200 = <0x7>;
-		ti,otap-del-sel-hs400 = <0x4>;
 	};
 
 	sdhci1: mmc@fa00000 {


