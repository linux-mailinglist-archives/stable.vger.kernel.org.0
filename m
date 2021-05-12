Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B452137C17F
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 16:59:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232745AbhELPAa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:00:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:45520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232392AbhELO6t (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 10:58:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A977361428;
        Wed, 12 May 2021 14:56:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620831386;
        bh=hB8834CskBelJMSiRGcdXM6fqJppP3UrNwyif2u7mAQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KiAvOyiRMnt7sQFVK1fUK3ELTZuWvupEy73irBNw+XUcbvr9fyuEZ0U7bYfUOzW0Y
         pPJHg/mKtRdIRg0p8hAXL7w7SQP+RJSoal+h6U6py5H/JMpTOA/makTGQfXuoGAKAf
         0K4TC2aDrK36Uoz27aMkWQ8vOLt7yKjEAyz4nrXc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vladimir Barinov <vladimir.barinov@cogentembedded.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 082/244] arm64: dts: renesas: r8a77980: Fix vin4-7 endpoint binding
Date:   Wed, 12 May 2021 16:47:33 +0200
Message-Id: <20210512144745.656832582@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144743.039977287@linuxfoundation.org>
References: <20210512144743.039977287@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Barinov <vladimir.barinov@cogentembedded.com>

[ Upstream commit c8aebc1346522d3569690867ce3996642ad52e01 ]

This fixes the bindings in media framework:
The CSI40 is endpoint number 2
The CSI41 is endpoint number 3

Signed-off-by: Vladimir Barinov <vladimir.barinov@cogentembedded.com>
Reviewed-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Link: https://lore.kernel.org/r/20210312174735.2118212-1-niklas.soderlund+renesas@ragnatech.se
Fixes: 3182aa4e0bf4d0ee ("arm64: dts: renesas: r8a77980: add CSI2/VIN support")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/renesas/r8a77980.dtsi | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/boot/dts/renesas/r8a77980.dtsi b/arch/arm64/boot/dts/renesas/r8a77980.dtsi
index e81cd83b138b..4b9d4f1bbe01 100644
--- a/arch/arm64/boot/dts/renesas/r8a77980.dtsi
+++ b/arch/arm64/boot/dts/renesas/r8a77980.dtsi
@@ -990,8 +990,8 @@
 
 					reg = <1>;
 
-					vin4csi41: endpoint@2 {
-						reg = <2>;
+					vin4csi41: endpoint@3 {
+						reg = <3>;
 						remote-endpoint = <&csi41vin4>;
 					};
 				};
@@ -1018,8 +1018,8 @@
 
 					reg = <1>;
 
-					vin5csi41: endpoint@2 {
-						reg = <2>;
+					vin5csi41: endpoint@3 {
+						reg = <3>;
 						remote-endpoint = <&csi41vin5>;
 					};
 				};
@@ -1046,8 +1046,8 @@
 
 					reg = <1>;
 
-					vin6csi41: endpoint@2 {
-						reg = <2>;
+					vin6csi41: endpoint@3 {
+						reg = <3>;
 						remote-endpoint = <&csi41vin6>;
 					};
 				};
@@ -1074,8 +1074,8 @@
 
 					reg = <1>;
 
-					vin7csi41: endpoint@2 {
-						reg = <2>;
+					vin7csi41: endpoint@3 {
+						reg = <3>;
 						remote-endpoint = <&csi41vin7>;
 					};
 				};
-- 
2.30.2



