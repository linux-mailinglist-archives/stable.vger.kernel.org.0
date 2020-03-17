Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C5C7187FD9
	for <lists+stable@lfdr.de>; Tue, 17 Mar 2020 12:05:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728370AbgCQLFH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 07:05:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:45758 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727999AbgCQLFG (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Mar 2020 07:05:06 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C16A720714;
        Tue, 17 Mar 2020 11:05:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584443106;
        bh=eQo3vOkdx+gbyH57SiasHpKgrg8xrYXjhCMuRy2WDGY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eU0O/Jdc3Egxd+/RqVMx6yj1v6yrik/afJWD/tYFpNSkclzISyXSIFnNHLYBOYstJ
         Ks+gZxGgeoEzeQ3T2DoVSMlmDeNV8rZZKVnXamTcgKSqTzXSTRgTae6wR1WgrtjliC
         XlM4O3IOvV7xFCuH3voptpHKGlBgs0QbUbUrJGfo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anson Huang <Anson.Huang@nxp.com>,
        Shawn Guo <shawnguo@kernel.org>
Subject: [PATCH 5.4 098/123] clk: imx8mn: Fix incorrect clock defines
Date:   Tue, 17 Mar 2020 11:55:25 +0100
Message-Id: <20200317103317.734391046@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200317103307.343627747@linuxfoundation.org>
References: <20200317103307.343627747@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anson Huang <Anson.Huang@nxp.com>

commit 5eb40257047fb11085d582b7b9ccd0bffe900726 upstream.

IMX8MN_CLK_I2C4 and IMX8MN_CLK_UART1's index definitions are incorrect,
fix them.

Fixes: 1e80936a42e1 ("dt-bindings: imx: Add clock binding doc for i.MX8MN")
Signed-off-by: Anson Huang <Anson.Huang@nxp.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/dt-bindings/clock/imx8mn-clock.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/dt-bindings/clock/imx8mn-clock.h
+++ b/include/dt-bindings/clock/imx8mn-clock.h
@@ -122,8 +122,8 @@
 #define IMX8MN_CLK_I2C1				105
 #define IMX8MN_CLK_I2C2				106
 #define IMX8MN_CLK_I2C3				107
-#define IMX8MN_CLK_I2C4				118
-#define IMX8MN_CLK_UART1			119
+#define IMX8MN_CLK_I2C4				108
+#define IMX8MN_CLK_UART1			109
 #define IMX8MN_CLK_UART2			110
 #define IMX8MN_CLK_UART3			111
 #define IMX8MN_CLK_UART4			112


