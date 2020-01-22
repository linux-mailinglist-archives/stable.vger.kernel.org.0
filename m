Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E2F614507E
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 10:47:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729151AbgAVJqe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 04:46:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:35926 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387550AbgAVJnY (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jan 2020 04:43:24 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ECB8924680;
        Wed, 22 Jan 2020 09:43:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579686204;
        bh=wJbCfVL/L9iEhgT/n93DQFDK3asUD9TbLyvmlRS8c/w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0IfOe3mN24fjXFYHnZLqS3h7MLN8nc4Dnsz3N+7kiqww2R1rdaQ/I+QLpMgSV/Oe1
         3U0npGKDdm5NJ1M2wewld/NijFtTU0k4ubYT6wpiEJ+vdI12sosBHW4q7C2jShw4iO
         rcMspRu8rKcE+k11ZnmdU+mPPnsNVAi5qY0s9a8o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miquel Raynal <miquel.raynal@bootlin.com>,
        Gregory CLEMENT <gregory.clement@bootlin.com>
Subject: [PATCH 4.19 086/103] arm64: dts: marvell: Fix CP110 NAND controller node multi-line comment alignment
Date:   Wed, 22 Jan 2020 10:29:42 +0100
Message-Id: <20200122092815.353107475@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200122092803.587683021@linuxfoundation.org>
References: <20200122092803.587683021@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miquel Raynal <miquel.raynal@bootlin.com>

commit 2bc26088ba37d4f2a4b8bd813ee757992522d082 upstream.

Fix this tiny typo before renaming/changing this file.

Fixes: 72a3713fadfd ("arm64: dts: marvell: de-duplicate CP110 description")
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Gregory CLEMENT <gregory.clement@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/boot/dts/marvell/armada-cp110.dtsi |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/arch/arm64/boot/dts/marvell/armada-cp110.dtsi
+++ b/arch/arm64/boot/dts/marvell/armada-cp110.dtsi
@@ -359,10 +359,10 @@
 
 		CP110_LABEL(nand_controller): nand@720000 {
 			/*
-			* Due to the limitation of the pins available
-			* this controller is only usable on the CPM
-			* for A7K and on the CPS for A8K.
-			*/
+			 * Due to the limitation of the pins available
+			 * this controller is only usable on the CPM
+			 * for A7K and on the CPS for A8K.
+			 */
 			compatible = "marvell,armada-8k-nand-controller",
 				"marvell,armada370-nand-controller";
 			reg = <0x720000 0x54>;


