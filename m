Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 467A347AD48
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 15:51:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231327AbhLTOvH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 09:51:07 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:40998 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234887AbhLTOsl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 09:48:41 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 15837611AA;
        Mon, 20 Dec 2021 14:48:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAABFC36AE8;
        Mon, 20 Dec 2021 14:48:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640011719;
        bh=ZLn6k+8TFW/56N2AYo1Ww7edeCXV6qbxOxouby7034E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=duOo6cjffYCS20ukjXbUMSCdYFf7DFIhybPW6+pcXc1ZpPjdFwLdgrveWy0TEglun
         zywzHFOdAvztiCgmlblZJcDiOWOOUJj7Nl73JzeJ4bHVUDQ44ic/LeJlBvIqKlkoL5
         oOY+WHWrj1IGNH6ppwGuzTxHbd6MOTz/+KjhXzOM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joakim Zhang <qiangqing.zhang@nxp.com>,
        Fabio Estevam <festevam@gmail.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Subject: [PATCH 5.10 17/99] arm64: dts: imx8mp-evk: Improve the Ethernet PHY description
Date:   Mon, 20 Dec 2021 15:33:50 +0100
Message-Id: <20211220143029.936538403@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143029.352940568@linuxfoundation.org>
References: <20211220143029.352940568@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fabio Estevam <festevam@gmail.com>

commit 798a1807ab13a38e21c6fecd8d22a513d6786e2d upstream.

According to the datasheet RTL8211, it must be asserted low for at least
10ms and at least 72ms "for internal circuits settling time" before
accessing the PHY registers.

Add properties to describe such requirements.

Reported-by: Joakim Zhang <qiangqing.zhang@nxp.com>
Signed-off-by: Fabio Estevam <festevam@gmail.com>
Tested-by: Joakim Zhang <qiangqing.zhang@nxp.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Cc: Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/freescale/imx8mp-evk.dts |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/arm64/boot/dts/freescale/imx8mp-evk.dts
+++ b/arch/arm64/boot/dts/freescale/imx8mp-evk.dts
@@ -62,6 +62,8 @@
 			reg = <1>;
 			eee-broken-1000t;
 			reset-gpios = <&gpio4 2 GPIO_ACTIVE_LOW>;
+			reset-assert-us = <10000>;
+			reset-deassert-us = <80000>;
 		};
 	};
 };


