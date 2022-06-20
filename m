Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E25C75519DD
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 15:06:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244210AbiFTNF6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 09:05:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244090AbiFTNEe (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 09:04:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 575AA193E1;
        Mon, 20 Jun 2022 05:59:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3873E6153E;
        Mon, 20 Jun 2022 12:59:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4388DC3411C;
        Mon, 20 Jun 2022 12:59:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655729990;
        bh=aSD1zz0+mNqeznv6haUaGQ071TTWhczN1/kvaqFFRsI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uyxZxVS95C9+kvGt/Jk6ry3g1DxDZLSlZIJOy1F3tiVtHlUTd8vwRO+K2++S0pUIB
         Uc8tC9+KhJpMNkzBO33xI5SdhSkisJH8SIKEJzgkRWiZtrJde2RS0BmmzHe9q9wt0B
         Iwj5WoYO6u+CSJLg0Gg0uOm6iAubNvfrK+HLT3TM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh@kernel.org>
Subject: [PATCH 5.18 139/141] dt-bindings: interrupt-controller: update brcm,l2-intc.yaml reference
Date:   Mon, 20 Jun 2022 14:51:17 +0200
Message-Id: <20220620124733.667779397@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220620124729.509745706@linuxfoundation.org>
References: <20220620124729.509745706@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mauro Carvalho Chehab <mchehab@kernel.org>

commit 7e40381d8a33e41e347cea5bdd000091653000c6 upstream.

Changeset 539d25b21fe8 ("dt-bindings: interrupt-controller: Convert Broadcom STB L2 to YAML")
renamed: Documentation/devicetree/bindings/interrupt-controller/brcm,l2-intc.txt
to: Documentation/devicetree/bindings/interrupt-controller/brcm,l2-intc.yaml.

Update its cross-reference accordingly.

Fixes: 539d25b21fe8 ("dt-bindings: interrupt-controller: Convert Broadcom STB L2 to YAML")
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Rob Herring <robh@kernel.org>
Link: https://lore.kernel.org/r/a40c02a7aaea91ea7b6ce24b6bc574ae5bcf4cf6.1654529011.git.mchehab@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/devicetree/bindings/cpufreq/brcm,stb-avs-cpu-freq.txt |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Documentation/devicetree/bindings/cpufreq/brcm,stb-avs-cpu-freq.txt
+++ b/Documentation/devicetree/bindings/cpufreq/brcm,stb-avs-cpu-freq.txt
@@ -16,7 +16,7 @@ has been processed. See [2] for more inf
 firmware. On some SoCs, this firmware supports DFS and DVFS in addition to
 Adaptive Voltage Scaling.
 
-[2] Documentation/devicetree/bindings/interrupt-controller/brcm,l2-intc.txt
+[2] Documentation/devicetree/bindings/interrupt-controller/brcm,l2-intc.yaml
 
 
 Node brcm,avs-cpu-data-mem


