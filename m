Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B50732E3FAB
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:44:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502346AbgL1OnC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:43:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:34806 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2502212AbgL1O1O (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:27:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1261320715;
        Mon, 28 Dec 2020 14:26:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165619;
        bh=5n7R45m9rW5RVlCOEO1cNLNQEKMUGMDWBhOMs1a4NHc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HM4DTn2AuCWDlZWDYiSPhOvR24lWuajpKYIymO0LivjlCjv1X8ahsTPe5WeFxcT3J
         QrI3G5HToUQXJNATZqRe02ZuFR4+VUvEuslrNr4gcVodaDGF37PIliCmJv1VjxZnyZ
         s4lR0RBwKD71D3YcInQA8K/gq/MfOSSLVQBcLc1c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Nishanth Menon <nm@ti.com>,
        Nikhil Devshatwar <nikhil.nd@ti.com>
Subject: [PATCH 5.10 595/717] arm64: dts: ti: k3-am65: mark dss as dma-coherent
Date:   Mon, 28 Dec 2020 13:49:53 +0100
Message-Id: <20201228125049.418042163@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tomi Valkeinen <tomi.valkeinen@ti.com>

commit 50301e8815c681bc5de8ca7050c4b426923d4e19 upstream.

DSS is IO coherent on AM65, so we should mark it as such with
'dma-coherent' property in the DT file.

Fixes: fc539b90eda2 ("arm64: dts: ti: am654: Add DSS node")
Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
Signed-off-by: Nishanth Menon <nm@ti.com>
Acked-by: Nikhil Devshatwar <nikhil.nd@ti.com>
Cc: stable@vger.kernel.org # v5.8+
Link: https://lore.kernel.org/r/20201102134650.55321-1-tomi.valkeinen@ti.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/boot/dts/ti/k3-am65-main.dtsi |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/arm64/boot/dts/ti/k3-am65-main.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-am65-main.dtsi
@@ -867,6 +867,8 @@
 
 		status = "disabled";
 
+		dma-coherent;
+
 		dss_ports: ports {
 			#address-cells = <1>;
 			#size-cells = <0>;


