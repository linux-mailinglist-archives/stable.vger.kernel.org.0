Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A90754F2BE7
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 13:21:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239128AbiDEIob (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:44:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241229AbiDEIc4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:32:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE3FFBD8;
        Tue,  5 Apr 2022 01:29:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7A90E60FF5;
        Tue,  5 Apr 2022 08:29:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B168C385A2;
        Tue,  5 Apr 2022 08:29:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649147395;
        bh=t5Kjxi8BKChE7cLLOSmUC5fA8BDDzn2f270Eb+wM/pU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h8yQSIKTicHvInzqS9a1EH+dnG53eKDhAQ3HTxTIJ4dUf2txE1PKc7UILY4TbMkNG
         +EVG7NR4m7MuUIkk1i1BLitmxVz80rNIscRCxUWHnJjPe6FYEXUOuamLOYrgED7BaU
         Mn0/FzhJUKoutxVRRM5reiOKBGOQhbomIiog6SgM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuldeep Singh <singh.kuldeep87k@gmail.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 5.17 1109/1126] ARM: dts: spear13xx: Update SPI dma properties
Date:   Tue,  5 Apr 2022 09:30:56 +0200
Message-Id: <20220405070439.987966369@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
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

commit 31d3687d6017c7ce6061695361598d9cda70807a upstream.

Reorder dmas and dma-names property for spi controller node to make it
compliant with bindings.

Fixes: 6e8887f60f60 ("ARM: SPEAr13xx: Pass generic DW DMAC platform data from DT")
Signed-off-by: Kuldeep Singh <singh.kuldeep87k@gmail.com>
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
Link: https://lore.kernel.org/r/20220326042313.97862-2-singh.kuldeep87k@gmail.com'
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/boot/dts/spear13xx.dtsi |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/arch/arm/boot/dts/spear13xx.dtsi
+++ b/arch/arm/boot/dts/spear13xx.dtsi
@@ -284,9 +284,9 @@
 				#size-cells = <0>;
 				interrupts = <0 31 0x4>;
 				status = "disabled";
-				dmas = <&dwdma0 4 0 0>,
-					<&dwdma0 5 0 0>;
-				dma-names = "tx", "rx";
+				dmas = <&dwdma0 5 0 0>,
+					<&dwdma0 4 0 0>;
+				dma-names = "rx", "tx";
 			};
 
 			rtc@e0580000 {


