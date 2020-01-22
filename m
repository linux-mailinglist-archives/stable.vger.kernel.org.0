Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E10A145659
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 14:36:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731083AbgAVN0P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 08:26:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:46856 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730845AbgAVN0P (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jan 2020 08:26:15 -0500
Received: from localhost (unknown [84.241.205.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1C61A24694;
        Wed, 22 Jan 2020 13:26:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579699574;
        bh=6WTdhUFKHAtR4iBSmnrgFS4gUpJDuX+ld+Dm484dcCo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Oy4HDNQ+w6tb/eqW+oYi1obzDiJpquDGgIeYE0gcK99m/Oeop4XESf4/zJ3EnNOVN
         pZPRrkrZtzn1cV3gV/fdLVD93j9SDNh5WJos+mUt+k8LQhSjsfz7aNoEKrSlkxYU8o
         vsUwYboLxPpLN/3t8OK6p8HXShln4AAKQNknieqE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miquel Raynal <miquel.raynal@bootlin.com>,
        Gregory CLEMENT <gregory.clement@bootlin.com>
Subject: [PATCH 5.4 183/222] arm64: dts: marvell: Fix CP110 NAND controller node multi-line comment alignment
Date:   Wed, 22 Jan 2020 10:29:29 +0100
Message-Id: <20200122092846.791206349@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200122092833.339495161@linuxfoundation.org>
References: <20200122092833.339495161@linuxfoundation.org>
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
@@ -438,10 +438,10 @@
 
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


