Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6B826CC273
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 16:45:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233098AbjC1Opg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 10:45:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233181AbjC1Op3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 10:45:29 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D361D50D
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 07:45:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 1B060CE1DA1
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 14:45:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0998EC4339B;
        Tue, 28 Mar 2023 14:45:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680014708;
        bh=H3HbVrrsSKklt+b0wy/NDC/BI8WlqpR5YhBDEmzvUAc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GHaJBsObexGmdpsj3MKkHAWX7PMfvn7flAcqeqYj+1wPQf4dO3lQu/p54D7kHGY6T
         KuKTO9FCnIMKZiFXQv3lMjnqrcCfidY9tDMiaR2WVhp8oaUnx0gWeQ5kp6fgA80jCR
         KWIxYTj+nT2kK9aOY43PZoOVkunCJw7ssE7ctA/I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Peng Fan <peng.fan@nxp.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 023/240] ARM: dts: imx6sll: e60k02: fix usbotg1 pinctrl
Date:   Tue, 28 Mar 2023 16:39:46 +0200
Message-Id: <20230328142620.618000662@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142619.643313678@linuxfoundation.org>
References: <20230328142619.643313678@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peng Fan <peng.fan@nxp.com>

[ Upstream commit 957c04e9784c7c757e8cc293d7fb2a60cdf461b6 ]

usb@2184000: 'pinctrl-0' is a dependency of 'pinctrl-names'

Signed-off-by: Peng Fan <peng.fan@nxp.com>
Fixes: c100ea86e6ab ("ARM: dts: add Netronix E60K02 board common file")
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/e60k02.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/boot/dts/e60k02.dtsi b/arch/arm/boot/dts/e60k02.dtsi
index 94944cc219317..dd03e3860f97f 100644
--- a/arch/arm/boot/dts/e60k02.dtsi
+++ b/arch/arm/boot/dts/e60k02.dtsi
@@ -311,6 +311,7 @@ &usdhc3 {
 
 &usbotg1 {
 	pinctrl-names = "default";
+	pinctrl-0 = <&pinctrl_usbotg1>;
 	disable-over-current;
 	srp-disable;
 	hnp-disable;
-- 
2.39.2



