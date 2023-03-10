Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 953D16B4B1D
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 16:31:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233115AbjCJPbG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 10:31:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233190AbjCJPam (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 10:30:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E78DA136FEB
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 07:19:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A751CB822C2
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 15:03:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1EFDC433EF;
        Fri, 10 Mar 2023 15:03:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678460608;
        bh=QZ/J5c16T3DlhoxUHH4nItPt0x0tksRPap4dyxd48Xg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R9rssSGsoYb1ZFg6qYWQX9EgOevRG5eeL2AJsYJSIY/HO7Qt63cI/8ZuLmDhc9xvX
         YoIQMNl9O+3mjbX6vPbGHLtEVYiIjd7JmlbHo0OGyOV9y9BtY2DNpPRB1HFSPgHItN
         ixZEsYzHBv77fs/xEbwDJ+TU2nFvL+VucjJOXqec=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [PATCH 5.10 392/529] ARM: dts: exynos: correct TMU phandle in Exynos4
Date:   Fri, 10 Mar 2023 14:38:55 +0100
Message-Id: <20230310133823.180809547@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
References: <20230310133804.978589368@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

commit 8e4505e617a80f601e2f53a917611777f128f925 upstream.

TMU node uses 0 as thermal-sensor-cells, thus thermal zone referencing
it must not have an argument to phandle.

Fixes: 328829a6ad70 ("ARM: dts: define default thermal-zones for exynos4")
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20230209105841.779596-1-krzysztof.kozlowski@linaro.org
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/boot/dts/exynos4-cpu-thermal.dtsi |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm/boot/dts/exynos4-cpu-thermal.dtsi
+++ b/arch/arm/boot/dts/exynos4-cpu-thermal.dtsi
@@ -10,7 +10,7 @@
 / {
 thermal-zones {
 	cpu_thermal: cpu-thermal {
-		thermal-sensors = <&tmu 0>;
+		thermal-sensors = <&tmu>;
 		polling-delay-passive = <0>;
 		polling-delay = <0>;
 		trips {


