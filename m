Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E518C30CB72
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 20:24:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239218AbhBBTYV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 14:24:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:46494 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233580AbhBBOAA (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 09:00:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8F56764FF7;
        Tue,  2 Feb 2021 13:46:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612273593;
        bh=13Mq9jBZtoiYRCXaUNVCMwg5EhLDpj325PgSTLTEQ2U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N6LqnvU0QqAKCjoXwzb3DW2ND5E1Gr1KQASYdVvJ2cNx9V+GiDqf7AytqwEcRmpYw
         hxOECt+VQcuYweky6+UNj9r/oxgRcbNGu/kG9ncTc6HBV9jjRkX/EspbNhbuJPIKPb
         KDfL2ArExbl1t6Njx4FroG4EdnRcwP+GXI4Rlpsc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tim Harvey <tharvey@gateworks.com>,
        Koen Vandeputte <koen.vandeputte@ncentric.com>,
        Shawn Guo <shawnguo@kernel.org>
Subject: [PATCH 5.4 09/61] ARM: dts: imx6qdl-gw52xx: fix duplicate regulator naming
Date:   Tue,  2 Feb 2021 14:37:47 +0100
Message-Id: <20210202132946.871818410@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210202132946.480479453@linuxfoundation.org>
References: <20210202132946.480479453@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Koen Vandeputte <koen.vandeputte@citymesh.com>

commit 5a22747b76ca2384057d8e783265404439d31d7f upstream.

2 regulator descriptions carry identical naming.

This leads to following boot warning:
[    0.173138] debugfs: Directory 'vdd1p8' with parent 'regulator' already present!

Fix this by renaming the one used for audio.

Fixes: 5051bff33102 ("ARM: dts: imx: ventana: add LTC3676 PMIC support")
Signed-off-by: Tim Harvey <tharvey@gateworks.com>
Signed-off-by: Koen Vandeputte <koen.vandeputte@ncentric.com>
Cc: stable@vger.kernel.org # v4.11
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/boot/dts/imx6qdl-gw52xx.dtsi |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm/boot/dts/imx6qdl-gw52xx.dtsi
+++ b/arch/arm/boot/dts/imx6qdl-gw52xx.dtsi
@@ -273,7 +273,7 @@
 
 			/* VDD_AUD_1P8: Audio codec */
 			reg_aud_1p8v: ldo3 {
-				regulator-name = "vdd1p8";
+				regulator-name = "vdd1p8a";
 				regulator-min-microvolt = <1800000>;
 				regulator-max-microvolt = <1800000>;
 				regulator-boot-on;


