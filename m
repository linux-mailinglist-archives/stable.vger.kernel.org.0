Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75EBC4F2C0C
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 13:22:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241814AbiDEJPX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:15:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244929AbiDEIws (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:52:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC7A32496E;
        Tue,  5 Apr 2022 01:46:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 89569B81BC5;
        Tue,  5 Apr 2022 08:46:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D49DFC385A0;
        Tue,  5 Apr 2022 08:46:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649148408;
        bh=p3fs+r28lnStow8fQ64ZRjbA9lfbA6oqU9NjoM6wbho=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cEkLrS/vRQLY8Kx3HzvwWFrnrST4xPv6tZ+hXyrSUgUwvASE3MkZNkgScyHuIjhfG
         bwh95WWgUUCVbwvMxApSu/5/ql0mPKWccJOiqckM9gSq1RUJpydAq9+EHVb+vdvZJt
         Oy7rSONG+1upSyCfguFbFGajUTronRRXPgLglk0M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zev Weiss <zev@bewilderbeest.net>,
        Lei YU <yulei.sh@bytedance.com>, Joel Stanley <joel@jms.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0307/1017] ARM: dts: Fix OpenBMC flash layout label addresses
Date:   Tue,  5 Apr 2022 09:20:20 +0200
Message-Id: <20220405070403.389086249@linuxfoundation.org>
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

From: Zev Weiss <zev@bewilderbeest.net>

[ Upstream commit e011df3579ac980d840db8e8c3b9431f88ebddab ]

We've ended up with some inconsistencies between the addresses in the
DT node labels and the actual offsets of the partitions; this brings
them back in sync.

Signed-off-by: Zev Weiss <zev@bewilderbeest.net>
Fixes: 529022738c8e ("ARM: dts: Add OpenBMC flash layout")
Fixes: 8dec60e7b8d0 ("ARM: dts: aspeed: Grow u-boot partition 64MiB OpenBMC flash layout")
Reviewed-by: Lei YU <yulei.sh@bytedance.com>
Link: https://lore.kernel.org/r/20220105003718.19888-1-zev@bewilderbeest.net
Signed-off-by: Joel Stanley <joel@jms.id.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/openbmc-flash-layout-64.dtsi | 2 +-
 arch/arm/boot/dts/openbmc-flash-layout.dtsi    | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/openbmc-flash-layout-64.dtsi b/arch/arm/boot/dts/openbmc-flash-layout-64.dtsi
index 31f59de5190b..7af41361c480 100644
--- a/arch/arm/boot/dts/openbmc-flash-layout-64.dtsi
+++ b/arch/arm/boot/dts/openbmc-flash-layout-64.dtsi
@@ -28,7 +28,7 @@ partitions {
 		label = "rofs";
 	};
 
-	rwfs@6000000 {
+	rwfs@2a00000 {
 		reg = <0x2a00000 0x1600000>; // 22MB
 		label = "rwfs";
 	};
diff --git a/arch/arm/boot/dts/openbmc-flash-layout.dtsi b/arch/arm/boot/dts/openbmc-flash-layout.dtsi
index 6c26524e93e1..b47e14063c38 100644
--- a/arch/arm/boot/dts/openbmc-flash-layout.dtsi
+++ b/arch/arm/boot/dts/openbmc-flash-layout.dtsi
@@ -20,7 +20,7 @@ partitions {
 		label = "kernel";
 	};
 
-	rofs@c0000 {
+	rofs@4c0000 {
 		reg = <0x4c0000 0x1740000>;
 		label = "rofs";
 	};
-- 
2.34.1



