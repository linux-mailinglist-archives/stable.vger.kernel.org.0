Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA2FC4F2DF2
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 13:48:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356074AbiDEKWv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 06:22:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235433AbiDEJaT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:30:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 603F53120F;
        Tue,  5 Apr 2022 02:17:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E16BF615E4;
        Tue,  5 Apr 2022 09:17:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED31AC385A2;
        Tue,  5 Apr 2022 09:17:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649150229;
        bh=VyceP8V9963XvE21yMD5O+ylMNMf3kEiRPDdqj8YzSk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UAAE65FLRpEe6ZhCrj7FZwwB9kryEdwEs626OLbN+bUpTkXmSKex7CbbKW1GUd36N
         GMuV2shT5qj3H2IrrBv3xFEAXVlTRyP7jd1hHnBq3gkeM1/Bh9619iVyFOENExCO/D
         6TjvA4TiwVxVWOwbnnN9eIFmsmRWrT2Y7NwB3Ik8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuldeep Singh <singh.kuldeep87k@gmail.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 5.16 0998/1017] ARM: dts: spear1340: Update serial node properties
Date:   Tue,  5 Apr 2022 09:31:51 +0200
Message-Id: <20220405070423.825252786@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
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
@@ -134,9 +134,9 @@
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


