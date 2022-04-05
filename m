Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88D104F2A5A
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 12:55:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356059AbiDEKWu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 06:22:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235377AbiDEJaT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:30:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 147E737BD5;
        Tue,  5 Apr 2022 02:17:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9ECB5615E3;
        Tue,  5 Apr 2022 09:17:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5A81C385A2;
        Tue,  5 Apr 2022 09:17:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649150232;
        bh=K1WOf/srQBJwEG4akzZo1hh0kYmfZ0TLnH6c80+1iE8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k4vkF8/htImPtYmmXY1QL+2AGoUBweFwl2HM5xISBwYoQiTjk3YMSUrCs63jYxgSo
         PChxl8dZj1D5/SLXrASQhrUVj0g5ExGfYg92yGH2ojkPRi1wkFq1SpAGHGEMVyxlF+
         bfFqyjY6pAPTpSvFZQ6KPys3+skaEKWUmjzvk4Yw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sander Vanheule <sander@svanheule.net>,
        =?UTF-8?q?Ar=C4=B1n=C3=A7=20=C3=9CNAL?= <arinc.unal@arinc9.com>
Subject: [PATCH 5.16 0963/1017] staging: mt7621-dts: fix pinctrl-0 items to be size-1 items on ethernet
Date:   Tue,  5 Apr 2022 09:31:16 +0200
Message-Id: <20220405070422.792588791@linuxfoundation.org>
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

From: Arınç ÜNAL <arinc.unal@arinc9.com>

commit 25e4f5220efead592c83200241e098e757d37e1f upstream.

Fix pinctrl-0 items under the ethernet node to be size-1 items.
Current notation would be used on specifications with non-zero cells.

Fixes: 0a93c0d75809 ("staging: mt7621-dts: fix pinctrl properties for ethernet")
Reported-by: Sander Vanheule <sander@svanheule.net>
Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
Link: https://lore.kernel.org/r/20220215081725.3463-1-arinc.unal@arinc9.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/mt7621-dts/mt7621.dtsi |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/staging/mt7621-dts/mt7621.dtsi
+++ b/drivers/staging/mt7621-dts/mt7621.dtsi
@@ -364,7 +364,7 @@
 		mediatek,ethsys = <&sysc>;
 
 		pinctrl-names = "default";
-		pinctrl-0 = <&rgmii1_pins &rgmii2_pins &mdio_pins>;
+		pinctrl-0 = <&mdio_pins>, <&rgmii1_pins>, <&rgmii2_pins>;
 
 		gmac0: mac@0 {
 			compatible = "mediatek,eth-mac";


