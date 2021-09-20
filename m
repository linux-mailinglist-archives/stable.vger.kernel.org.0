Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0C8F41236D
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:23:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348806AbhITSZG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:25:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:44432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1377971AbhITSWV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:22:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DDEFD632BF;
        Mon, 20 Sep 2021 17:24:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632158656;
        bh=DONT+Fc80aZDftDWzaJG+IhkUgb+ZlqTzWSgqVEpfVg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hJaa1BQzsys/f6oAfFF1KG1cmOQQQeUPoPamcLSeElMOcIO1K2B0Nache+xWU99bI
         B0Yu+NFdWI7mqtVRZixbJJlYCz/vUuO3JDzvgaR44i/izMFvKiDN8UROUjbLauwyGJ
         nMHWI7tsRMseTxUCJB9DvrIG5BUZCF7+esZ8F3Cs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Heidelberg <david@ixit.cz>,
        Rob Herring <robh@kernel.org>
Subject: [PATCH 5.4 225/260] dt-bindings: arm: Fix Toradex compatible typo
Date:   Mon, 20 Sep 2021 18:44:03 +0200
Message-Id: <20210920163938.762608956@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163931.123590023@linuxfoundation.org>
References: <20210920163931.123590023@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Heidelberg <david@ixit.cz>

commit 55c21d57eafb7b379bb7b3e93baf9ca2695895b0 upstream.

Fix board compatible typo reported by dtbs_check.

Fixes: f4d1577e9bc6 ("dt-bindings: arm: Convert Tegra board/soc bindings to json-schema")
Signed-off-by: David Heidelberg <david@ixit.cz>
Link: https://lore.kernel.org/r/20210912165120.188490-1-david@ixit.cz
Signed-off-by: Rob Herring <robh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/devicetree/bindings/arm/tegra.yaml |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Documentation/devicetree/bindings/arm/tegra.yaml
+++ b/Documentation/devicetree/bindings/arm/tegra.yaml
@@ -49,7 +49,7 @@ properties:
           - const: toradex,apalis_t30
           - const: nvidia,tegra30
       - items:
-          - const: toradex,apalis_t30-eval-v1.1
+          - const: toradex,apalis_t30-v1.1-eval
           - const: toradex,apalis_t30-eval
           - const: toradex,apalis_t30-v1.1
           - const: toradex,apalis_t30


