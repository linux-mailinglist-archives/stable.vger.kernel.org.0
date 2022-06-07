Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D56D3540566
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 19:25:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237340AbiFGRZu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 13:25:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346881AbiFGRZd (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 13:25:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8512D106A70;
        Tue,  7 Jun 2022 10:23:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2270060DDE;
        Tue,  7 Jun 2022 17:23:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3344AC34115;
        Tue,  7 Jun 2022 17:23:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654622608;
        bh=XJ50Jb/dd9venn1pdAoNrEN6xPogM9j8x9SREus6Qzo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WDP66qHBTDtGV3NDEdN6nF2TTFmNASSWng0Nv0EMAwxphFhaU8vTSB3IwTfxqnRwE
         ZVx8zsxVFMEsc0vC+NYGckfPdxONE3KB6gXU7tCB7c+8q5agk/Suu99OBw4Johazaz
         wFlHQP+3hWgrFu3IsGkKKIiLjES4L4zcD4SwgwgM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Noralf=20Tr=C3=B8nnes?= <noralf@tronnes.org>,
        Rob Herring <robh@kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        David Lechner <david@lechnology.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 121/452] dt-bindings: display: sitronix, st7735r: Fix backlight in example
Date:   Tue,  7 Jun 2022 18:59:38 +0200
Message-Id: <20220607164912.165107218@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164908.521895282@linuxfoundation.org>
References: <20220607164908.521895282@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Noralf Trønnes <noralf@tronnes.org>

[ Upstream commit 471e201f543559e2cb19b182b680ebf04d80ee31 ]

The backlight property was lost during conversion to yaml in commit
abdd9e3705c8 ("dt-bindings: display: sitronix,st7735r: Convert to DT schema").
Put it back.

Fixes: abdd9e3705c8 ("dt-bindings: display: sitronix,st7735r: Convert to DT schema")
Signed-off-by: Noralf Trønnes <noralf@tronnes.org>
Acked-by: Rob Herring <robh@kernel.org>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Acked-by: David Lechner <david@lechnology.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20211124150757.17929-2-noralf@tronnes.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/devicetree/bindings/display/sitronix,st7735r.yaml | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/display/sitronix,st7735r.yaml b/Documentation/devicetree/bindings/display/sitronix,st7735r.yaml
index 0cebaaefda03..419c3b2ac5a6 100644
--- a/Documentation/devicetree/bindings/display/sitronix,st7735r.yaml
+++ b/Documentation/devicetree/bindings/display/sitronix,st7735r.yaml
@@ -72,6 +72,7 @@ examples:
                     dc-gpios = <&gpio 43 GPIO_ACTIVE_HIGH>;
                     reset-gpios = <&gpio 80 GPIO_ACTIVE_HIGH>;
                     rotation = <270>;
+                    backlight = <&backlight>;
             };
     };
 
-- 
2.35.1



