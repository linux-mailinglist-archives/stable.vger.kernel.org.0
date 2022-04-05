Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B62514F36A3
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 16:07:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234207AbiDELGO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:06:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348145AbiDEJrD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:47:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D6A2EA367;
        Tue,  5 Apr 2022 02:33:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 859AF615E5;
        Tue,  5 Apr 2022 09:33:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C7B7C385A3;
        Tue,  5 Apr 2022 09:33:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649151202;
        bh=p3fs+r28lnStow8fQ64ZRjbA9lfbA6oqU9NjoM6wbho=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OoyxHfnNNfau7lsJOpAGUm/FUcv0EJznmEYAEbESaTxNV0JIinmn8ZbamIGo1VJWl
         VgaH7/dNSSfYObyTtzeC9JuisfqIJZ1/1+4yW2NWDM/9F1hUW1P2detMF4jIOkjT2X
         xZzlSCXe7fNd+8MBwCpcoSUPKCRyxIxMZdtP4MdE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zev Weiss <zev@bewilderbeest.net>,
        Lei YU <yulei.sh@bytedance.com>, Joel Stanley <joel@jms.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 293/913] ARM: dts: Fix OpenBMC flash layout label addresses
Date:   Tue,  5 Apr 2022 09:22:35 +0200
Message-Id: <20220405070348.639957216@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
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



