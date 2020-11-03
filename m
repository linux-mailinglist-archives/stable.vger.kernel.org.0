Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDDC42A51D6
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 21:45:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730268AbgKCUod (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:44:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:59914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730110AbgKCUoc (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:44:32 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3E25022404;
        Tue,  3 Nov 2020 20:44:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436271;
        bh=b0m26p2jGEbOL+dGxZIDvIWXBhU7AOYu0hoK+2XPRNY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=soMtOoWmMUzko/9HYNGRMa4O8+5Oy5zbAKL6TvAh0Kr3An1eGI+AbBsfGcca6QRQL
         5Wl//W9QIjQ7N1UxS2Y3ByAOO9PZ4PgOcu2HQBXMjyx1PB57VVZOoQRvkryPtyQaYX
         JkIGPPWppgTkhNvUEHyF+kkZoxnftTpQepx25aUo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 176/391] bindings: soc: ti: soc: ringacc: remove ti,dma-ring-reset-quirk
Date:   Tue,  3 Nov 2020 21:33:47 +0100
Message-Id: <20201103203358.749128756@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203348.153465465@linuxfoundation.org>
References: <20201103203348.153465465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Grygorii Strashko <grygorii.strashko@ti.com>

[ Upstream commit aee123f48f387ea62002cddb46c7cb04c96628df ]

Remove "ti,dma-ring-reset-quirk" DT property as proper w/a handling is
implemented now in Ringacc driver using SoC info.

Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
Signed-off-by: Santosh Shilimkar <santosh.shilimkar@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/devicetree/bindings/soc/ti/k3-ringacc.yaml | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/Documentation/devicetree/bindings/soc/ti/k3-ringacc.yaml b/Documentation/devicetree/bindings/soc/ti/k3-ringacc.yaml
index ae33fc957141f..c3c595e235a86 100644
--- a/Documentation/devicetree/bindings/soc/ti/k3-ringacc.yaml
+++ b/Documentation/devicetree/bindings/soc/ti/k3-ringacc.yaml
@@ -62,11 +62,6 @@ properties:
     $ref: /schemas/types.yaml#/definitions/uint32
     description: TI-SCI device id of the ring accelerator
 
-  ti,dma-ring-reset-quirk:
-    $ref: /schemas/types.yaml#definitions/flag
-    description: |
-      enable ringacc/udma ring state interoperability issue software w/a
-
 required:
   - compatible
   - reg
@@ -94,7 +89,6 @@ examples:
             reg-names = "rt", "fifos", "proxy_gcfg", "proxy_target";
             ti,num-rings = <818>;
             ti,sci-rm-range-gp-rings = <0x2>; /* GP ring range */
-            ti,dma-ring-reset-quirk;
             ti,sci = <&dmsc>;
             ti,sci-dev-id = <187>;
             msi-parent = <&inta_main_udmass>;
-- 
2.27.0



