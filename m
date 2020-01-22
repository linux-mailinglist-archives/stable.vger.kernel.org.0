Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E25D814564F
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 14:35:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730682AbgAVNZZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 08:25:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:45138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730667AbgAVNZY (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jan 2020 08:25:24 -0500
Received: from localhost (unknown [84.241.205.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 155F22467B;
        Wed, 22 Jan 2020 13:25:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579699522;
        bh=fCIJuCwbP3GeGUag2GXGI+Y0xJ8Y2Pe80IWo5Xlaxi8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wVkoyk6jfvqldGmYEi07Uw245tO7JB3pgL06bAxdqFwJkyxSCDK+F5y3LHvuuoJ3J
         rX3+bjwZ5Mqbe7Cl+KsGm9/puZDziHwUB/i6nzyFcdQFhV9+G4ZPy2mHZgu73DpM4O
         sIMi3d33kdBRI+dcdOYMUXx8BfZPYoY5eDWj/1LI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Maxime Ripard <mripard@kernel.org>,
        Rob Herring <robh@kernel.org>
Subject: [PATCH 5.4 171/222] dt-bindings: Add missing properties keyword enclosing snps,tso
Date:   Wed, 22 Jan 2020 10:29:17 +0100
Message-Id: <20200122092845.950277758@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200122092833.339495161@linuxfoundation.org>
References: <20200122092833.339495161@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rob Herring <robh@kernel.org>

commit dbce0b65046d1735d7054c54ec2387dba84ba258 upstream.

DT property definitions must be under a 'properties' keyword. This was
missing for 'snps,tso' in an if/then clause. A meta-schema fix will
catch future errors like this.

Fixes: 7db3545aef5f ("dt-bindings: net: stmmac: Convert the binding to a schemas")
Cc: "David S. Miller" <davem@davemloft.net>
Acked-by: Maxime Ripard <mripard@kernel.org>
Signed-off-by: Rob Herring <robh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 Documentation/devicetree/bindings/net/snps,dwmac.yaml |    1 +
 1 file changed, 1 insertion(+)

--- a/Documentation/devicetree/bindings/net/snps,dwmac.yaml
+++ b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
@@ -347,6 +347,7 @@ allOf:
               - st,spear600-gmac
 
     then:
+      properties:
         snps,tso:
           $ref: /schemas/types.yaml#definitions/flag
           description:


