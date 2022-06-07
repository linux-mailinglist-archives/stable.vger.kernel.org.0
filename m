Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3672541C49
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:59:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382908AbiFGV6i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:58:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383263AbiFGVw7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:52:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FAC5192C65;
        Tue,  7 Jun 2022 12:10:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 283ADB823B0;
        Tue,  7 Jun 2022 19:10:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80CE3C385A5;
        Tue,  7 Jun 2022 19:10:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654629055;
        bh=wodYFo2wMvMhHO445BgZXawuZ6EgFLtnwJ9b77J/wkg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VPH0LqT2e1l4pSqImACUNRmeD3QtsD0JZAYWYzuAjr8eTn2w6mEZiJbAuu2q+pokM
         ai2O4//nowwWuN033sj8ufs+sdfnjY65e76YEBDh1bGYrGYKjm7iyV3P8Hjz34BUeC
         4F/261vbDZH0jGROUsV5XyCzA6WuNWc4u3DZlFyw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Robin Murphy <robin.murphy@arm.com>,
        Mike Leach <Mike.Leach@arm.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 554/879] arm64: dts: juno: Fix SCMI power domain IDs for ETF and CS funnel
Date:   Tue,  7 Jun 2022 19:01:12 +0200
Message-Id: <20220607165018.947400262@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sudeep Holla <sudeep.holla@arm.com>

[ Upstream commit 8dd3cdeaf3032728e30a7ec5e79ca780fc86cf7a ]

The SCMI power domain ID for all the coresight components is 8 while
the previous/older SCPI domain was 0. When adding SCMI variant, couple
of instances retained SCPI domain ID by mistake.

Fix the same by using the correct SCMI power domain ID of 8.

Link: https://lore.kernel.org/r/20220413093547.1699535-1-sudeep.holla@arm.com
Fixes: 96bb0954860a ("arm64: dts: juno: Add separate SCMI variants")
Cc: Robin Murphy <robin.murphy@arm.com>
Reported-by: Mike Leach <Mike.Leach@arm.com>
Acked-by: Robin Murphy <robin.murphy@arm.com>
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/arm/juno-r1-scmi.dts | 4 ++--
 arch/arm64/boot/dts/arm/juno-r2-scmi.dts | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/boot/dts/arm/juno-r1-scmi.dts b/arch/arm64/boot/dts/arm/juno-r1-scmi.dts
index 190a0fba4ad6..fd1f0d26d751 100644
--- a/arch/arm64/boot/dts/arm/juno-r1-scmi.dts
+++ b/arch/arm64/boot/dts/arm/juno-r1-scmi.dts
@@ -7,11 +7,11 @@
 	};
 
 	etf@20140000 {
-		power-domains = <&scmi_devpd 0>;
+		power-domains = <&scmi_devpd 8>;
 	};
 
 	funnel@20150000 {
-		power-domains = <&scmi_devpd 0>;
+		power-domains = <&scmi_devpd 8>;
 	};
 };
 
diff --git a/arch/arm64/boot/dts/arm/juno-r2-scmi.dts b/arch/arm64/boot/dts/arm/juno-r2-scmi.dts
index dbf13770084f..35e6d4762c46 100644
--- a/arch/arm64/boot/dts/arm/juno-r2-scmi.dts
+++ b/arch/arm64/boot/dts/arm/juno-r2-scmi.dts
@@ -7,11 +7,11 @@
 	};
 
 	etf@20140000 {
-		power-domains = <&scmi_devpd 0>;
+		power-domains = <&scmi_devpd 8>;
 	};
 
 	funnel@20150000 {
-		power-domains = <&scmi_devpd 0>;
+		power-domains = <&scmi_devpd 8>;
 	};
 };
 
-- 
2.35.1



