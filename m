Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D7CF6AF2BE
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:56:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233369AbjCGS4G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:56:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233378AbjCGSzq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:55:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E87B87BA25
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:43:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 10ACF61535
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:43:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1621BC433D2;
        Tue,  7 Mar 2023 18:43:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678214589;
        bh=2JJgs9MSqLa2QW9pGjiGKto7hRoTLiCW0Bm9U7ktLKQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iQpXZaOP5R48Xk00XPiFhH9yMs9BPCVYdr/WLiRr1PM59k86nDQIDskNSa8rImZdX
         GFoqSrwlqTErPuXaiEdfsisWeCuuWG+lGGsJxTS6NbbjOaz3xg82Tn/A9sFlFhNCSJ
         lNadv6DfEYs01mMC9XLmgD9S0QOXl9Xgwy/TD2uA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        "H. Nikolaus Schaller" <hns@goldelico.com>,
        Paul Cercueil <paul@crapouillou.net>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: [PATCH 6.1 863/885] MIPS: DTS: CI20: fix otg power gpio
Date:   Tue,  7 Mar 2023 18:03:17 +0100
Message-Id: <20230307170039.243490490@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: H. Nikolaus Schaller <hns@goldelico.com>

commit 0cb4228f6cc9ed0ca2be0d9ddf29168a8e3a3905 upstream.

According to schematics it is PF15 and not PF14 (MIC_SW_EN).
Seems as if it was hidden and not noticed during testing since
there is no sound DT node.

Fixes: 158c774d3c64 ("MIPS: Ingenic: Add missing nodes for Ingenic SoCs and boards.")
Cc: stable@vger.kernel.org
Signed-off-by: H. Nikolaus Schaller <hns@goldelico.com>
Acked-by: Paul Cercueil <paul@crapouillou.net>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/mips/boot/dts/ingenic/ci20.dts |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/mips/boot/dts/ingenic/ci20.dts
+++ b/arch/mips/boot/dts/ingenic/ci20.dts
@@ -113,7 +113,7 @@
 		regulator-min-microvolt = <5000000>;
 		regulator-max-microvolt = <5000000>;
 
-		gpio = <&gpf 14 GPIO_ACTIVE_LOW>;
+		gpio = <&gpf 15 GPIO_ACTIVE_LOW>;
 		enable-active-high;
 	};
 };


