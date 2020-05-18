Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B0141D8411
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 20:11:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733083AbgERSF4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 14:05:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:53754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733030AbgERSFz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 14:05:55 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B58FE20853;
        Mon, 18 May 2020 18:05:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589825155;
        bh=zer0Mc5CO845JMY0f/NI3pFp3JuFH8Aq0s6Pjo72w6w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2VAGBl0nrysYySEWjBwo/OvABpzSfVFeJBb1zbwON6FZZlYylhwPM4LLYpGws0sVn
         9grxFaDiSvq1gqeSvLZ7SS5PoNyqBdAA6g9AszZrnz7s9RnOR+jEpuFhhmVYCNP/Pv
         JVbFRQJpQpktOHwBRosCZgMIK6gvRZFy+aGqWpQM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Michal=20Vok=C3=A1=C4=8D?= <michal.vokac@ysoft.com>,
        Shawn Guo <shawnguo@kernel.org>
Subject: [PATCH 5.6 150/194] ARM: dts: imx6dl-yapp4: Fix Ursa board Ethernet connection
Date:   Mon, 18 May 2020 19:37:20 +0200
Message-Id: <20200518173543.752028151@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173531.455604187@linuxfoundation.org>
References: <20200518173531.455604187@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michal Vokáč <michal.vokac@ysoft.com>

commit cbe63a8358310244e6007398bd2c7c70c7fd51cd upstream.

The Y Soft yapp4 platform supports up to two Ethernet ports.
The Ursa board though has only one Ethernet port populated and that is
the port@2. Since the introduction of this platform into mainline a wrong
port was deleted and the Ethernet could never work. Fix this by deleting
the correct port node.

Fixes: 87489ec3a77f ("ARM: dts: imx: Add Y Soft IOTA Draco, Hydra and Ursa boards")
Cc: stable@vger.kernel.org
Signed-off-by: Michal Vokáč <michal.vokac@ysoft.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/boot/dts/imx6dl-yapp4-ursa.dts |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm/boot/dts/imx6dl-yapp4-ursa.dts
+++ b/arch/arm/boot/dts/imx6dl-yapp4-ursa.dts
@@ -38,7 +38,7 @@
 };
 
 &switch_ports {
-	/delete-node/ port@2;
+	/delete-node/ port@3;
 };
 
 &touchscreen {


