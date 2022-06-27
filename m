Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA66755C742
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 14:53:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237299AbiF0Lnl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 07:43:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237416AbiF0Lmt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 07:42:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39C07F30;
        Mon, 27 Jun 2022 04:37:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BF004B81117;
        Mon, 27 Jun 2022 11:37:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 118D9C3411D;
        Mon, 27 Jun 2022 11:37:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656329850;
        bh=B2hSXjbr+rHpgwDe32O/tcnJQcZZzJ7ADtnfxO42u40=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bedk/Vm+MrRX3kyJ511Nh3TY3As1ONjGamOHaNasC/7W7KD+tu2gxCfUqtQ3HaMgP
         QmVYhVriPCOXuZ7T3SM6ENCVQR0n1Kj5fTFF7UhCvn8U7mJ5xezt/QXTbSuXgK7EMs
         cFepkgER8ecspNXNg+bFwBZGxldrplXDFJDQWRWI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aswath Govindraju <a-govindraju@ti.com>,
        Nishanth Menon <nm@ti.com>
Subject: [PATCH 5.15 123/135] arm64: dts: ti: k3-am64-main: Remove support for HS400 speed mode
Date:   Mon, 27 Jun 2022 13:22:10 +0200
Message-Id: <20220627111941.724118150@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627111938.151743692@linuxfoundation.org>
References: <20220627111938.151743692@linuxfoundation.org>
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


