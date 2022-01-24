Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1647C498961
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 19:55:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245560AbiAXSzh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 13:55:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344187AbiAXSxy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 13:53:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB052C06175B;
        Mon, 24 Jan 2022 10:53:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 78049B810BD;
        Mon, 24 Jan 2022 18:53:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83272C340E5;
        Mon, 24 Jan 2022 18:53:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643050383;
        bh=SqqKlmrkJD2ajJiHT7F53gMvsqqsiJfdubXqh3QjyAo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LXHOT118XShLCB1XxGaKuI1ApFICs4MQBvuoFKVgUkti8rDp3d3q8u1miwMElwnrF
         dMLsss3xAYnlfGMlVUvB5zNEUrsoUs57sHXo7X0rmeEzJlTknoB7gVmU0GFJNJ2EM4
         0uTYihnLgT7TigeDT3MWEYFR2U0NGPnVRHTZn1oM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tobias Waldekranz <tobias@waldekranz.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.4 101/114] powerpc/fsl/dts: Enable WA for erratum A-009885 on fman3l MDIO buses
Date:   Mon, 24 Jan 2022 19:43:16 +0100
Message-Id: <20220124183930.228586236@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183927.095545464@linuxfoundation.org>
References: <20220124183927.095545464@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tobias Waldekranz <tobias@waldekranz.com>

commit 0d375d610fa96524e2ee2b46830a46a7bfa92a9f upstream.

This block is used in (at least) T1024 and T1040, including their
variants like T1023 etc.

Fixes: d55ad2967d89 ("powerpc/mpc85xx: Create dts components for the FSL QorIQ DPAA FMan")
Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/boot/dts/fsl/qoriq-fman3l-0.dtsi |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/powerpc/boot/dts/fsl/qoriq-fman3l-0.dtsi
+++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3l-0.dtsi
@@ -78,6 +78,7 @@ fman0: fman@400000 {
 		#size-cells = <0>;
 		compatible = "fsl,fman-memac-mdio", "fsl,fman-xmdio";
 		reg = <0xfc000 0x1000>;
+		fsl,erratum-a009885;
 	};
 
 	xmdio0: mdio@fd000 {
@@ -85,6 +86,7 @@ fman0: fman@400000 {
 		#size-cells = <0>;
 		compatible = "fsl,fman-memac-mdio", "fsl,fman-xmdio";
 		reg = <0xfd000 0x1000>;
+		fsl,erratum-a009885;
 	};
 
 	ptp_timer0: ptp-timer@fe000 {


