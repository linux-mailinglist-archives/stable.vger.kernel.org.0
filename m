Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F12BF4F44B6
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 00:26:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383337AbiDEMZf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 08:25:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349228AbiDEKub (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:50:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5AC29E9F6;
        Tue,  5 Apr 2022 03:27:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 466E46141D;
        Tue,  5 Apr 2022 10:27:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E368C385A6;
        Tue,  5 Apr 2022 10:27:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649154462;
        bh=lQRtMgDTrcSWyqXbZhsMoWU1a+zIBYvvylab8ih+iEw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=07oYFlwcRp3hqPgD3yfDcAG60IN5z327dFE/2lOEOvbwvsgGKbd07D1THcCocyTZz
         GD0qSQvlBFxKM+rNNJCuJWR6B8NXrx+bBlVdSrZAv7wk8R/rihpC7/AbPVVJSx3foJ
         hZmjpHWQof2hYY7XHHM1byCn8e0u80rt2kQzKRbY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuldeep Singh <singh.kuldeep87k@gmail.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 5.10 587/599] ARM: dts: spear1340: Update serial node properties
Date:   Tue,  5 Apr 2022 09:34:41 +0200
Message-Id: <20220405070316.309838749@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070258.802373272@linuxfoundation.org>
References: <20220405070258.802373272@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Kuldeep Singh <singh.kuldeep87k@gmail.com>

commit 583d6b0062640def86f3265aa1042ecb6672516e upstream.

Reorder dma and dma-names property for serial node to make it compliant
with bindings.

Fixes: 6e8887f60f60 ("ARM: SPEAr13xx: Pass generic DW DMAC platform data from DT")
Signed-off-by: Kuldeep Singh <singh.kuldeep87k@gmail.com>
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
Link: https://lore.kernel.org/r/20220326042313.97862-3-singh.kuldeep87k@gmail.com'
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/boot/dts/spear1340.dtsi |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/arch/arm/boot/dts/spear1340.dtsi
+++ b/arch/arm/boot/dts/spear1340.dtsi
@@ -136,9 +136,9 @@
 				reg = <0xb4100000 0x1000>;
 				interrupts = <0 105 0x4>;
 				status = "disabled";
-				dmas = <&dwdma0 12 0 1>,
-					<&dwdma0 13 1 0>;
-				dma-names = "tx", "rx";
+				dmas = <&dwdma0 13 0 1>,
+					<&dwdma0 12 1 0>;
+				dma-names = "rx", "tx";
 			};
 
 			thermal@e07008c4 {


