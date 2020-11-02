Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EEAA2A2BE8
	for <lists+stable@lfdr.de>; Mon,  2 Nov 2020 14:47:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725830AbgKBNrF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Nov 2020 08:47:05 -0500
Received: from fllv0016.ext.ti.com ([198.47.19.142]:56216 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725616AbgKBNrF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Nov 2020 08:47:05 -0500
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 0A2DkwdD080502;
        Mon, 2 Nov 2020 07:46:58 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1604324818;
        bh=4ipgS24hf5CxBzJXQLQIF0BRRZBtiHHna0qv3Hfs7QE=;
        h=From:To:CC:Subject:Date;
        b=TGu4sISWlL+Jm8X17YsEZRyZOsk9aoHBAvOZCQyiQDPwGTeWiQ+CYb3JkOO9+2tAf
         +IbUzQNqi6H1+31feSk2sgzM1kWSKYxDI7NMsZB1u7jGu4abhPKHLW4/kHKhEzIE+C
         8gGnTeZhlmKAcg69ivBzb9wDmXlYvkKBmukPYmPc=
Received: from DFLE107.ent.ti.com (dfle107.ent.ti.com [10.64.6.28])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 0A2DkwRG103189
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 2 Nov 2020 07:46:58 -0600
Received: from DFLE107.ent.ti.com (10.64.6.28) by DFLE107.ent.ti.com
 (10.64.6.28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Mon, 2 Nov
 2020 07:46:58 -0600
Received: from fllv0039.itg.ti.com (10.64.41.19) by DFLE107.ent.ti.com
 (10.64.6.28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Mon, 2 Nov 2020 07:46:58 -0600
Received: from deskari.ti.com (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 0A2DkthZ114063;
        Mon, 2 Nov 2020 07:46:56 -0600
From:   Tomi Valkeinen <tomi.valkeinen@ti.com>
To:     Tero Kristo <t-kristo@ti.com>, Nishanth Menon <nm@ti.com>
CC:     <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Nikhil Devshatwar <nikhil.nd@ti.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        <stable@vger.kernel.org>
Subject: [PATCH v2] arm64: dts: ti: k3-am65: mark dss as dma-coherent
Date:   Mon, 2 Nov 2020 15:46:50 +0200
Message-ID: <20201102134650.55321-1-tomi.valkeinen@ti.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

DSS is IO coherent on AM65, so we should mark it as such with
'dma-coherent' property in the DT file.

Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
Fixes: fc539b90eda2 ("arm64: dts: ti: am654: Add DSS node")
Cc: stable@vger.kernel.org # v5.8+
Acked-by: Nikhil Devshatwar <nikhil.nd@ti.com>
---

v2: Added fixes, stable and Nikhil's ack.

 arch/arm64/boot/dts/ti/k3-am65-main.dtsi | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/boot/dts/ti/k3-am65-main.dtsi b/arch/arm64/boot/dts/ti/k3-am65-main.dtsi
index 533525229a8d..a0b4a421026f 100644
--- a/arch/arm64/boot/dts/ti/k3-am65-main.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-am65-main.dtsi
@@ -867,6 +867,8 @@ dss: dss@04a00000 {
 
 		status = "disabled";
 
+		dma-coherent;
+
 		dss_ports: ports {
 			#address-cells = <1>;
 			#size-cells = <0>;
-- 
Texas Instruments Finland Oy, Porkkalankatu 22, 00180 Helsinki.
Y-tunnus/Business ID: 0615521-4. Kotipaikka/Domicile: Helsinki

