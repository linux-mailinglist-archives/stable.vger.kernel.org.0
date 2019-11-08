Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E0E42F56BF
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 21:04:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391159AbfKHTKs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 14:10:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:43102 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388212AbfKHTKr (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 14:10:47 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9877B2087E;
        Fri,  8 Nov 2019 19:10:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573240247;
        bh=YgFdIDx7lKvpMrjO7Ql6gaMp8ykgcdrlVzFdJ08KVT8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jl1a/VGiXXOYZ7IeuD6j+J/yP9L+sPioN6A+n+wpwdTLHbLcC8cqibytIYjM10vJs
         51le0u+8hDc+BZtmTuRUES0DQtM5b2uHa2xclPsoRW6d//WFZ9ZlC9MS25+yWlnire
         dsZwp1gd6iHqcCtoqFXoDrSna2LezD9vmBjKQWE0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Robert Tivy <rtivy@ti.com>,
        Suman Anna <s-anna@ti.com>, Tero Kristo <t-kristo@ti.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>
Subject: [PATCH 5.3 139/140] arm64: dts: ti: k3-am65-main: Fix gic-its node unit-address
Date:   Fri,  8 Nov 2019 19:51:07 +0100
Message-Id: <20191108174913.315199103@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191108174900.189064908@linuxfoundation.org>
References: <20191108174900.189064908@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Suman Anna <s-anna@ti.com>

commit 389ce1a7c5279ebfb682fab220b4021b2bd49c8b upstream.

The gic-its node unit-address has an additional zero compared
to the actual reg value. Fix it.

Fixes: ea47eed33a3f ("arm64: dts: ti: Add Support for AM654 SoC")
Reported-by: Robert Tivy <rtivy@ti.com>
Signed-off-by: Suman Anna <s-anna@ti.com>
Signed-off-by: Tero Kristo <t-kristo@ti.com>
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/boot/dts/ti/k3-am65-main.dtsi |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/boot/dts/ti/k3-am65-main.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-am65-main.dtsi
@@ -42,7 +42,7 @@
 		 */
 		interrupts = <GIC_PPI 9 IRQ_TYPE_LEVEL_HIGH>;
 
-		gic_its: gic-its@18200000 {
+		gic_its: gic-its@1820000 {
 			compatible = "arm,gic-v3-its";
 			reg = <0x00 0x01820000 0x00 0x10000>;
 			socionext,synquacer-pre-its = <0x1000000 0x400000>;


