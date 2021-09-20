Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 556A64125AC
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:45:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354520AbhITSqy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:46:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:56450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1383261AbhITSoT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:44:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 84FF56137C;
        Mon, 20 Sep 2021 17:32:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632159153;
        bh=2aUFvNwSxY7pwqroa4y5YaZd+XWGcKLSJTkujQSxd7Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oQ9St3Uq/XLCZI3iBholyhaDBc94EnMLSv4mdu/NtahiBjnraLWtn4rgTDgkSvIM5
         AuD7E75/rmlqrOpTSyBrWaJtKfXQYoWUKvLJDgRYQps1iMClxi4fMz7QMccs8YZgrm
         Pj6uUOIvEikitFcUrKDt5DkB1Vn3281t/FwFwF/0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Heidelberg <david@ixit.cz>,
        Rob Herring <robh@kernel.org>
Subject: [PATCH 5.14 068/168] dt-bindings: arm: Fix Toradex compatible typo
Date:   Mon, 20 Sep 2021 18:43:26 +0200
Message-Id: <20210920163923.881012073@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163921.633181900@linuxfoundation.org>
References: <20210920163921.633181900@linuxfoundation.org>
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


