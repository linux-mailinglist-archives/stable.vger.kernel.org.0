Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF6B35B8178
	for <lists+stable@lfdr.de>; Wed, 14 Sep 2022 08:20:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229785AbiINGUW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Sep 2022 02:20:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229758AbiINGUV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Sep 2022 02:20:21 -0400
Received: from out2-smtp.messagingengine.com (out2-smtp.messagingengine.com [66.111.4.26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6094F4623E
        for <stable@vger.kernel.org>; Tue, 13 Sep 2022 23:20:20 -0700 (PDT)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id C337A5C0140;
        Wed, 14 Sep 2022 02:20:19 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Wed, 14 Sep 2022 02:20:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=traverse.com.au;
         h=cc:cc:content-transfer-encoding:date:date:from:from
        :in-reply-to:message-id:mime-version:reply-to:sender:subject
        :subject:to:to; s=fm1; t=1663136419; x=1663222819; bh=Dg/FImDqCS
        5uIytdTva32c2VOfp5On5p+vOP3w6QEpA=; b=Sgr2GMlNr5p6jLAPjuUbG55h16
        +TpN/JHCrqAJkRmbmplIuTnuDTkqLZ25czxNpZjHG7Rk/R0le1Ovc4pXuNW6zdzx
        RcSnzs09RYj9SZ+/TW4n86RviujDTys9o58bHb6Gc0evFMsyJfgEaoBUfMdfUCN7
        gY/YPSYTDk/mB9ypx8jV8xM3HawNtiLH6oHuA59TVhV/5piywOLqYjMGt6PyO4yZ
        GhbR5fitvVgG68X2Hq+WlDhHVLonLHHRKp7cSJVMWxNepiHtFeF470Xl87WSPvQt
        yt/LvsF3kvSyFCb9EYGYP0TdESZ6G2oLqBxFXd9Ib3WSleJG+y5OlNfP386Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:message-id
        :mime-version:reply-to:sender:subject:subject:to:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
        1663136419; x=1663222819; bh=Dg/FImDqCS5uIytdTva32c2VOfp5On5p+vO
        P3w6QEpA=; b=SMim3XMSe9pkWLll1WE1qESWeXSn6zfBwkhcHSwDnwlVQCiz6uC
        HMW1AaDxSlroeZi/g/z6HO6hPMKuGMeXBgE7kr/t0bi92VRSob28mLLTXvt/B617
        4Zq8P4kU3fkluOujDOCAlRey1mGNPT+6wZnvJRDd558DXfUYD5c5h3m3F9HyKQSD
        R1ITP57H5l2ewFCGD7rTZtT7IAprbNv3boNC+pwEYkgWd+nTn4e3AVaIZa/qouEM
        vUrq4G6EzsJ57KBDGBJij3VZBjXF7srGjJQvdZWFKA4OtVYc0DGyMCRwbwQErNDE
        2ICmcnyd2UDRf2LnbAe/8ZkpyI5GbTGoEDA==
X-ME-Sender: <xms:o3IhY_gcgDW5U-iUqN3f4TjBgmW0C0qS3pQ0bGdU3JmePhcecyWv2Q>
    <xme:o3IhY8BBKe4pMTn1ROiL85RnXAgru1iF6nXHGHelhkbKvtCCYu1MVXnoTSMV0W-IZ
    nUPsNX0x8Wd8G0qrn4>
X-ME-Received: <xmr:o3IhY_HWA42qXSNFlO4jeAZ4ntZwKIqY4t6ONyNyDtW11d2YdDzDP8UXsUm2vU9MglaK-TWp-ztN0B-siEKZ4yEAPfmSyH44wjBfFYG00nUgcMJwr-WsVecx4ehQNhw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrfeduhedguddtjecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpefhvfevufffkffoggfgsedtkeertdertddtnecuhfhrohhmpeforghthhgv
    ficuofgtuehrihguvgcuoehmrghtthesthhrrghvvghrshgvrdgtohhmrdgruheqnecugg
    ftrfgrthhtvghrnhepffffkeetgfdvgfdugefggfekkeetgedugeejgfdttdejteegtdeh
    heduudehgedunecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucevlhhushhtvghruf
    hiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehmrghtthesthhrrghvvghrshgv
    rdgtohhmrdgruh
X-ME-Proxy: <xmx:o3IhY8R2zuYNWyb1Jejl352k82K7oQ2MUAT4lq2i3YnJ1rv7eBLpXQ>
    <xmx:o3IhY8xtkHUmDw3CsAW32tn7rdsk24pQw1h9oycH8qqdlRwz62QNzA>
    <xmx:o3IhYy6kGnIUQEiLaZ65QLzxFF46z3V0ozNHjtirR7diJ_HQGpKIYQ>
    <xmx:o3IhY3_oFit4Uy5GwNB0bU2E3DSd0IXKMDt-CJQmZClSsL992a3oKw>
Feedback-ID: i426947f3:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 14 Sep 2022 02:20:18 -0400 (EDT)
From:   Mathew McBride <matt@traverse.com.au>
To:     stable@vger.kernel.org
Cc:     Mathew McBride <matt@traverse.com.au>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 5.15] soc: fsl: select FSL_GUTS driver for DPIO
Date:   Wed, 14 Sep 2022 06:19:57 +0000
Message-Id: <20220914061957.11886-1-matt@traverse.com.au>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 9a472613f5bccf1b36837423495ae592a9c5182f upstream

The soc/fsl/dpio driver will perform a soc_device_match()
to determine the optimal cache settings for a given CPU core.

If FSL_GUTS is not enabled, this search will fail and
the driver will not configure cache stashing for the given
DPIO, and a string of "unknown SoC" messages will appear:

fsl_mc_dpio dpio.7: unknown SoC version
fsl_mc_dpio dpio.6: unknown SoC version
fsl_mc_dpio dpio.5: unknown SoC version

Fixes: 51da14e96e9b ("soc: fsl: dpio: configure cache stashing destination")
Signed-off-by: Mathew McBride <matt@traverse.com.au>
Reviewed-by: Ioana Ciornei <ioana.ciornei@nxp.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20220901052149.23873-2-matt@traverse.com.au
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/soc/fsl/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/soc/fsl/Kconfig b/drivers/soc/fsl/Kconfig
index 4df32bc4c7a6..c5d46152d468 100644
--- a/drivers/soc/fsl/Kconfig
+++ b/drivers/soc/fsl/Kconfig
@@ -24,6 +24,7 @@ config FSL_MC_DPIO
         tristate "QorIQ DPAA2 DPIO driver"
         depends on FSL_MC_BUS
         select SOC_BUS
+        select FSL_GUTS
         help
 	  Driver for the DPAA2 DPIO object.  A DPIO provides queue and
 	  buffer management facilities for software to interact with
-- 
2.30.1

