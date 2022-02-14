Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E4F24B4881
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 10:57:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343556AbiBNJzV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 04:55:21 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343842AbiBNJxz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 04:53:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FF127C7B3;
        Mon, 14 Feb 2022 01:44:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0D63DB80DD1;
        Mon, 14 Feb 2022 09:44:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37487C340E9;
        Mon, 14 Feb 2022 09:44:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644831840;
        bh=olW/14QWy4+vO9J4Qps7sPs/UsCXQNslIeAMkHpsZQA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nnQoMPrS/hRz6QyCBBjZ2bwGqep/CA8A7RPZyYf/TD9IsifjJ5/Hj3NBY6YaddUH3
         gWH1OlXR4hpU+KnPcS9Sb0RsOBw6qacV8EVPF1pptRznRnRW14E1yRlCrBgiON6TZZ
         HW51sQHOFIamV1SnFj9EPMZ6Nu1H5A3dfhINe76k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexander Stein <alexander.stein@ew.tq-group.com>,
        Fabio Estevam <festevam@gmail.com>,
        Shawn Guo <shawnguo@kernel.org>
Subject: [PATCH 5.10 114/116] arm64: dts: imx8mq: fix lcdif port node
Date:   Mon, 14 Feb 2022 10:26:53 +0100
Message-Id: <20220214092502.731812625@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092458.668376521@linuxfoundation.org>
References: <20220214092458.668376521@linuxfoundation.org>
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
@@ -524,7 +524,7 @@
 				assigned-clock-rates = <0>, <0>, <0>, <594000000>;
 				status = "disabled";
 
-				port@0 {
+				port {
 					lcdif_mipi_dsi: endpoint {
 						remote-endpoint = <&mipi_dsi_lcdif_in>;
 					};


