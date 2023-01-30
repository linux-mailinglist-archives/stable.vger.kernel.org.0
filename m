Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 724796810F9
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:09:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229526AbjA3OJE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:09:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237144AbjA3OJE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:09:04 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BC113802F
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:09:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C778BB81183
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:09:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22048C433EF;
        Mon, 30 Jan 2023 14:08:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675087740;
        bh=3Lq75sPSoSHWXeFKKS8WfbyvTaALIHw/yo2b2Iv0CbY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pjtOhw8LBoyvUnfEq7hj+SqennFBXmI+LwPPlaTv8H5Y2W25spDMmyeEgaT2OXfMh
         hnLNSYmFZg10d4QXhjrUUTvCZPxut38Msh6Isj0docFwXH/nm90C+29tSv8P1G9wfB
         gtJ/bAAlUTOnaKJuaa+r9BL8uiHUnxYtdIINFgf0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Guo Ren <guoren@kernel.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Palmer Dabbelt <palmer@rivosinc.com>,
        Conor Dooley <conor.dooley@microchip.com>,
        Rob Herring <robh@kernel.org>
Subject: [PATCH 6.1 309/313] dt-bindings: riscv: fix single letter canonical order
Date:   Mon, 30 Jan 2023 14:52:24 +0100
Message-Id: <20230130134351.140875383@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Conor Dooley <conor.dooley@microchip.com>

commit a943385aa80151c6b2611d3a1cf8338af2b257a1 upstream.

I used the wikipedia table for ordering extensions when updating the
pattern here in commit 299824e68bd0 ("dt-bindings: riscv: add new
riscv,isa strings for emulators").

Unfortunately that table did not match canonical order, as defined by
the RISC-V ISA Manual, which defines extension ordering in (what is
currently) Table 41, "Standard ISA extension names". Fix things up by
re-sorting v (vector) and adding p (packed-simd) & j (dynamic
languages). The e (reduced integer) and g (general) extensions are still
intentionally left out.

Link: https://github.com/riscv/riscv-isa-manual/releases/tag/riscv-unpriv-pdf-from-asciidoc-15112022 # Chapter 29.5
Fixes: 299824e68bd0 ("dt-bindings: riscv: add new riscv,isa strings for emulators")
Acked-by: Guo Ren <guoren@kernel.org>
Reviewed-by: Heiko Stuebner <heiko@sntech.de>
Reviewed-by: Palmer Dabbelt <palmer@rivosinc.com>
Acked-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Conor Dooley <conor.dooley@microchip.com>
Acked-by: Rob Herring <robh@kernel.org>
Link: https://lore.kernel.org/r/20221205174459.60195-3-conor@kernel.org
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/devicetree/bindings/riscv/cpus.yaml | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/riscv/cpus.yaml b/Documentation/devicetree/bindings/riscv/cpus.yaml
index 97659bb71811..d4148418350c 100644
--- a/Documentation/devicetree/bindings/riscv/cpus.yaml
+++ b/Documentation/devicetree/bindings/riscv/cpus.yaml
@@ -80,7 +80,7 @@ properties:
       insensitive, letters in the riscv,isa string must be all
       lowercase to simplify parsing.
     $ref: "/schemas/types.yaml#/definitions/string"
-    pattern: ^rv(?:64|32)imaf?d?q?c?b?v?k?h?(?:[hsxz](?:[a-z])+)?(?:_[hsxz](?:[a-z])+)*$
+    pattern: ^rv(?:64|32)imaf?d?q?c?b?k?j?p?v?h?(?:[hsxz](?:[a-z])+)?(?:_[hsxz](?:[a-z])+)*$
 
   # RISC-V requires 'timebase-frequency' in /cpus, so disallow it here
   timebase-frequency: false
-- 
2.39.1



