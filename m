Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2CA623A709
	for <lists+stable@lfdr.de>; Mon,  3 Aug 2020 14:58:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727800AbgHCM5M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Aug 2020 08:57:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:44960 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726774AbgHCMVh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Aug 2020 08:21:37 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 10B152076E;
        Mon,  3 Aug 2020 12:21:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596457296;
        bh=gInQwPd+EnPSeAJ4zDWgp2u5GpqqQwc2FKg5EWUzg+c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uRFbUyMNrTC0tdJdNbJZNjV5yLEFX/E6LZlPrBNFXQcMLbrJb+IRODbWqZxSCp3kV
         UQQi7qE6P0P7mYMQAJdCPwL5OrL5QYktAQTkbgaA5aMOL7ODjP4x7VLt0wJACW8pze
         iJ0xZolHCHvoVwVl7TMrfDts8eHoRLItTyojYnao=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fabio Estevam <festevam@gmail.com>,
        Shawn Guo <shawnguo@kernel.org>
Subject: [PATCH 5.7 017/120] ARM: dts: imx6sx-sabreauto: Fix the phy-mode on fec2
Date:   Mon,  3 Aug 2020 14:17:55 +0200
Message-Id: <20200803121903.695847816@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200803121902.860751811@linuxfoundation.org>
References: <20200803121902.860751811@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fabio Estevam <festevam@gmail.com>

commit d36f260718d83928e6012247a7e1b9791cdb12ff upstream.

Commit 0672d22a1924 ("ARM: dts: imx: Fix the AR803X phy-mode") fixed the
phy-mode for fec1, but missed to fix it for the fec2 node.

Fix fec2 to also use "rgmii-id" as the phy-mode.

Cc: <stable@vger.kernel.org>
Fixes: 0672d22a1924 ("ARM: dts: imx: Fix the AR803X phy-mode")
Signed-off-by: Fabio Estevam <festevam@gmail.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/boot/dts/imx6sx-sabreauto.dts |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm/boot/dts/imx6sx-sabreauto.dts
+++ b/arch/arm/boot/dts/imx6sx-sabreauto.dts
@@ -99,7 +99,7 @@
 &fec2 {
 	pinctrl-names = "default";
 	pinctrl-0 = <&pinctrl_enet2>;
-	phy-mode = "rgmii";
+	phy-mode = "rgmii-id";
 	phy-handle = <&ethphy0>;
 	fsl,magic-packet;
 	status = "okay";


