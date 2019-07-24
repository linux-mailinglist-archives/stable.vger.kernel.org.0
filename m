Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1BEB3745F2
	for <lists+stable@lfdr.de>; Thu, 25 Jul 2019 07:48:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391501AbfGYFq4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Jul 2019 01:46:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:34798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391500AbfGYFq4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Jul 2019 01:46:56 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 205C021880;
        Thu, 25 Jul 2019 05:46:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564033615;
        bh=ZoxoJX3JIBSKtw7+QATylHzz1N3zv5WldLucO3PBzVM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y2FnXq2Ofl4oSFhaBPyKIkrGTa4mlIkgyzv0fTNT/1MUKejS9kerXhEA1BHWRu8oe
         O9nyxDlMeC2MNWZZZzdHWK2+Mo9eIqCToozol1UHmjvsl/Lxs3QbwS1lU/jfuPEW0g
         TxjGdiyGjLC6I7lzb8aYP4KO28FowKapbpE5YBmQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Josua Mayer <josua@solid-run.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 270/271] dt-bindings: allow up to four clocks for orion-mdio
Date:   Wed, 24 Jul 2019 21:22:19 +0200
Message-Id: <20190724191718.388923343@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191655.268628197@linuxfoundation.org>
References: <20190724191655.268628197@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josua Mayer <josua@solid-run.com>

commit 80785f5a22e9073e2ded5958feb7f220e066d17b upstream.

Armada 8040 needs four clocks to be enabled for MDIO accesses to work.
Update the binding to allow the extra clock to be specified.

Cc: stable@vger.kernel.org
Fixes: 6d6a331f44a1 ("dt-bindings: allow up to three clocks for orion-mdio")
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Josua Mayer <josua@solid-run.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 Documentation/devicetree/bindings/net/marvell-orion-mdio.txt |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Documentation/devicetree/bindings/net/marvell-orion-mdio.txt
+++ b/Documentation/devicetree/bindings/net/marvell-orion-mdio.txt
@@ -16,7 +16,7 @@ Required properties:
 
 Optional properties:
 - interrupts: interrupt line number for the SMI error/done interrupt
-- clocks: phandle for up to three required clocks for the MDIO instance
+- clocks: phandle for up to four required clocks for the MDIO instance
 
 The child nodes of the MDIO driver are the individual PHY devices
 connected to this MDIO bus. They must have a "reg" property given the


