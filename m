Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A30D187B91
	for <lists+stable@lfdr.de>; Tue, 17 Mar 2020 09:53:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725794AbgCQIxR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 04:53:17 -0400
Received: from uho.ysoft.cz ([81.19.3.130]:59552 "EHLO uho.ysoft.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725730AbgCQIxR (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Mar 2020 04:53:17 -0400
X-Greylist: delayed 392 seconds by postgrey-1.27 at vger.kernel.org; Tue, 17 Mar 2020 04:53:17 EDT
Received: from vokac-latitude.ysoft.local (unknown [10.0.26.30])
        by uho.ysoft.cz (Postfix) with ESMTP id 48A87A2044;
        Tue, 17 Mar 2020 09:46:43 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ysoft.com;
        s=20160406-ysoft-com; t=1584434803;
        bh=Lzv/MaQ3ezj7/bou68x1jUB/oddxfUF/I2otelqDcvY=;
        h=From:To:Cc:Subject:Date:From;
        b=ISUvT2miFxD9Y7MZNshO0PCE64qJ6CQz06V9vT25Zy50ZUfk5VD1LWxcDFaYoWs2p
         wH88hIQQSlzb7w5QCQYt47EV2vRDXUK8MF6wLcJ0X95G9p6DptSLGw1dry1EGCdrUF
         WfmEt7vlia0Os8O2OfV+KNLIsFqrawk7eCuBswOs=
From:   =?UTF-8?q?Michal=20Vok=C3=A1=C4=8D?= <michal.vokac@ysoft.com>
To:     Rob Herring <robh+dt@kernel.org>, Shawn Guo <shawnguo@kernel.org>
Cc:     Mark Rutland <mark.rutland@arm.com>,
        Fabio Estevam <festevam@gmail.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        =?UTF-8?q?Michal=20Vok=C3=A1=C4=8D?= <michal.vokac@ysoft.com>,
        stable@vger.kernel.org
Subject: [PATCH] ARM: dts: imx6dl-yapp4: Fix Ursa board Ethernet connection
Date:   Tue, 17 Mar 2020 09:46:28 +0100
Message-Id: <1584434788-11945-1-git-send-email-michal.vokac@ysoft.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The Y Soft yapp4 platform supports up to two Ethernet ports.
The Ursa board though has only one Ethernet port populated and that is
the port@2. Since the introduction of this platform into mainline a wrong
port was deleted and the Ethernet could never work. Fix this by deleting
the correct port node.

Fixes: 87489ec3a77f ("ARM: dts: imx: Add Y Soft IOTA Draco, Hydra and Ursa boards")
Cc: stable@vger.kernel.org
Signed-off-by: Michal Vokáč <michal.vokac@ysoft.com>
---
 arch/arm/boot/dts/imx6dl-yapp4-ursa.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/imx6dl-yapp4-ursa.dts b/arch/arm/boot/dts/imx6dl-yapp4-ursa.dts
index 0d594e4bd559..a1173bf5bff5 100644
--- a/arch/arm/boot/dts/imx6dl-yapp4-ursa.dts
+++ b/arch/arm/boot/dts/imx6dl-yapp4-ursa.dts
@@ -38,7 +38,7 @@
 };
 
 &switch_ports {
-	/delete-node/ port@2;
+	/delete-node/ port@3;
 };
 
 &touchscreen {
-- 
2.7.4

