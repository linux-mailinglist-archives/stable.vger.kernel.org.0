Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CA8A4B4BEE
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 11:43:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346217AbiBNKRg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 05:17:36 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347308AbiBNKQ0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 05:16:26 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 924616737E;
        Mon, 14 Feb 2022 01:53:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 86271B80D6D;
        Mon, 14 Feb 2022 09:53:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4F12C340E9;
        Mon, 14 Feb 2022 09:53:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644832407;
        bh=PWC4MiolHqPxzZqlrPZg8QnjhC1NnQ1cEiBb2jdkjgg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZAxzKeJXpI5Ln+GvSV+YC0iM+W1/SpnP/v+JT8rzYftzUYMrYrliDBaVDYQKrxyAd
         pzhUxETNAdeCgtXIsT+XizU4T+3d2i+pcLXsDVN7lvZEUnO2v/zNqCSQVXavF/gatS
         0TyVndTuo/vogkpFUG3H2GgtMj9RXg3WoaswjMLY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexander Stein <alexander.stein@ew.tq-group.com>,
        Fabio Estevam <festevam@gmail.com>,
        Shawn Guo <shawnguo@kernel.org>
Subject: [PATCH 5.15 170/172] arm64: dts: imx8mq: fix lcdif port node
Date:   Mon, 14 Feb 2022 10:27:08 +0100
Message-Id: <20220214092512.261642891@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092506.354292783@linuxfoundation.org>
References: <20220214092506.354292783@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Stein <alexander.stein@ew.tq-group.com>

commit 91f6d5f181f6629dd74ab71759fe92d3f4eff966 upstream.

The port node does not have a unit-address, remove it.
This fixes the warnings:
lcd-controller@30320000: 'port' is a required property
lcd-controller@30320000: 'port@0' does not match any of the regexes:
'pinctrl-[0-9]+'

Fixes: commit d0081bd02a03 ("arm64: dts: imx8mq: Add NWL MIPI DSI controller")
Signed-off-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Reviewed-by: Fabio Estevam <festevam@gmail.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/freescale/imx8mq.dtsi |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/boot/dts/freescale/imx8mq.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mq.dtsi
@@ -526,7 +526,7 @@
 				assigned-clock-rates = <0>, <0>, <0>, <594000000>;
 				status = "disabled";
 
-				port@0 {
+				port {
 					lcdif_mipi_dsi: endpoint {
 						remote-endpoint = <&mipi_dsi_lcdif_in>;
 					};


