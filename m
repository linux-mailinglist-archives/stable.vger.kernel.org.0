Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B21C4412402
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:28:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230495AbhITS3y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:29:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:48630 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352389AbhITS12 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:27:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9724A632E3;
        Mon, 20 Sep 2021 17:26:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632158767;
        bh=2aUFvNwSxY7pwqroa4y5YaZd+XWGcKLSJTkujQSxd7Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bai2wYGtWOzwtlrq87RDr8URN+MN830FuNhlkIMxByvCwTNskY1tTKWyIZCvFTyDn
         713/X5JB3wEqhlyqJZD8rQWW/zNE7UAsvLOZuoSURDDe1rlgUMvHEQf6EjF02zJOnk
         jJ+9kM7MD6Hwi1p0lALkFgMg7lXLmp5iVrfHyH7k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Heidelberg <david@ixit.cz>,
        Rob Herring <robh@kernel.org>
Subject: [PATCH 5.10 046/122] dt-bindings: arm: Fix Toradex compatible typo
Date:   Mon, 20 Sep 2021 18:43:38 +0200
Message-Id: <20210920163917.301389865@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163915.757887582@linuxfoundation.org>
References: <20210920163915.757887582@linuxfoundation.org>
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
@@ -54,7 +54,7 @@ properties:
           - const: toradex,apalis_t30
           - const: nvidia,tegra30
       - items:
-          - const: toradex,apalis_t30-eval-v1.1
+          - const: toradex,apalis_t30-v1.1-eval
           - const: toradex,apalis_t30-eval
           - const: toradex,apalis_t30-v1.1
           - const: toradex,apalis_t30


