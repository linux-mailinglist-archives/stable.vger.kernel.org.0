Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 662426CC277
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 16:45:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233214AbjC1Opq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 10:45:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233116AbjC1Opb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 10:45:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9892D505
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 07:45:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 604A4B81D70
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 14:45:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1358C433D2;
        Tue, 28 Mar 2023 14:45:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680014711;
        bh=2YS2VZ0iDyNEdZxZPrWmrKjgCcr0xvAgxItJ7ls9vIg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZKIrU4EPdlgv5bRnIYW2q4lLDdlTgiBaOaJPrBM0bRSIl79D8K16Brktl7EViPTR4
         QMcgIvjqVwUuLeZyTu2MW4tYwGt4Kd+WCKrf/ktewulYvLxkeWdtJrTKFCYSj7Grt/
         FpI2pHXfB445UQDlcSrLmzFsxQ3S72wrjsusltgY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Peng Fan <peng.fan@nxp.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 024/240] ARM: dts: imx6sl: tolino-shine2hd: fix usbotg1 pinctrl
Date:   Tue, 28 Mar 2023 16:39:47 +0200
Message-Id: <20230328142620.656066749@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142619.643313678@linuxfoundation.org>
References: <20230328142619.643313678@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peng Fan <peng.fan@nxp.com>

[ Upstream commit 1cd489e1ada1cffa56bd06fd4609f5a60a985d43 ]

usb@2184000: 'pinctrl-0' is a dependency of 'pinctrl-names'

Signed-off-by: Peng Fan <peng.fan@nxp.com>
Fixes: 9c7016f1ca6d ("ARM: dts: imx: add devicetree for Tolino Shine 2 HD")
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/imx6sl-tolino-shine2hd.dts | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/boot/dts/imx6sl-tolino-shine2hd.dts b/arch/arm/boot/dts/imx6sl-tolino-shine2hd.dts
index da1399057634a..815119c12bd48 100644
--- a/arch/arm/boot/dts/imx6sl-tolino-shine2hd.dts
+++ b/arch/arm/boot/dts/imx6sl-tolino-shine2hd.dts
@@ -625,6 +625,7 @@ &usdhc3 {
 
 &usbotg1 {
 	pinctrl-names = "default";
+	pinctrl-0 = <&pinctrl_usbotg1>;
 	disable-over-current;
 	srp-disable;
 	hnp-disable;
-- 
2.39.2



