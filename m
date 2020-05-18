Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72B791D84E1
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 20:15:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732152AbgERR75 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 13:59:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:40952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731651AbgERR75 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 13:59:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5DFBD208B8;
        Mon, 18 May 2020 17:59:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589824796;
        bh=zer0Mc5CO845JMY0f/NI3pFp3JuFH8Aq0s6Pjo72w6w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ks8mTZ5f0LDD4lgcvoNHlpjuEDxH3kQtlEQ2vkgG2mj0OUylPwa9cRzUrU/N70s9d
         IbIchis86Xb4ftj2/OWHxdzOq/TeJCIFj2xrQxHa6QzGlMvaKIA+IweW8xxF+gq0Yq
         QHnqkqEAVKg1m9+kJZVKUpqWuIzZ8Y9NwgROPL2c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Michal=20Vok=C3=A1=C4=8D?= <michal.vokac@ysoft.com>,
        Shawn Guo <shawnguo@kernel.org>
Subject: [PATCH 5.4 117/147] ARM: dts: imx6dl-yapp4: Fix Ursa board Ethernet connection
Date:   Mon, 18 May 2020 19:37:20 +0200
Message-Id: <20200518173527.613356694@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173513.009514388@linuxfoundation.org>
References: <20200518173513.009514388@linuxfoundation.org>
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


