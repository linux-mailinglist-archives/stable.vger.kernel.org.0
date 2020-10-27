Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A64229BE3C
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:56:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1794287AbgJ0PK7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:10:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:46752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1794281AbgJ0PK5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:10:57 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D49AB20657;
        Tue, 27 Oct 2020 15:10:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603811456;
        bh=9RKNUs3kCyxUPrht+/kNzIXVj1O6rTzML6T6akjliXI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iJ1IXhIBr7AVR18Kp1zH1NvSgkVSsWKyn5lcAFeLVsZM86etRVS+pnCTjRV5Ok3ZF
         RwawSi/OzCRcvwhu3tJp01X1Xv9ffZQcCvqGIvbdxTv0jbA9e5RH0hmWBIC8pg6Ge3
         c+Plx2Cib6cg1+LaKw8kILSsPFKc+bbT88xzbzzA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Corentin Labbe <clabbe.montjoie@gmail.com>,
        Maxime Ripard <maxime@cerno.tech>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 499/633] dt-bindings: crypto: Specify that allwinner, sun8i-a33-crypto needs reset
Date:   Tue, 27 Oct 2020 14:54:02 +0100
Message-Id: <20201027135546.136390435@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Corentin Labbe <clabbe.montjoie@gmail.com>

[ Upstream commit 884d1a334ae8130fabede56f59b224619ad6bca4 ]

When adding allwinner,sun8i-a33-crypto, I forgot to add that it needs reset.
Furthermore, there are no need to use items to list only one compatible
in compatible list.

Fixes: f81547ba7a98 ("dt-bindings: crypto: add new compatible for A33 SS")
Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Link: https://lore.kernel.org/r/20200907175437.4464-1-clabbe.montjoie@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../bindings/crypto/allwinner,sun4i-a10-crypto.yaml        | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/Documentation/devicetree/bindings/crypto/allwinner,sun4i-a10-crypto.yaml b/Documentation/devicetree/bindings/crypto/allwinner,sun4i-a10-crypto.yaml
index fc823572bcff2..90c6d039b91b0 100644
--- a/Documentation/devicetree/bindings/crypto/allwinner,sun4i-a10-crypto.yaml
+++ b/Documentation/devicetree/bindings/crypto/allwinner,sun4i-a10-crypto.yaml
@@ -23,8 +23,7 @@ properties:
       - items:
           - const: allwinner,sun7i-a20-crypto
           - const: allwinner,sun4i-a10-crypto
-      - items:
-          - const: allwinner,sun8i-a33-crypto
+      - const: allwinner,sun8i-a33-crypto
 
   reg:
     maxItems: 1
@@ -59,7 +58,9 @@ if:
   properties:
     compatible:
       contains:
-        const: allwinner,sun6i-a31-crypto
+        enum:
+          - allwinner,sun6i-a31-crypto
+          - allwinner,sun8i-a33-crypto
 
 then:
   required:
-- 
2.25.1



