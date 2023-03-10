Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 531426B4698
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:44:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232956AbjCJOog (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:44:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232957AbjCJOoL (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:44:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A3441070C5
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:44:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2BE60B822AD
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:44:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 801B4C433D2;
        Fri, 10 Mar 2023 14:44:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678459446;
        bh=Q3Ccn6+avdyZUjRwNngl/J8lBc5dVmMZBvEgw2ByqrM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Hzh5Xqx/Q3qYIpZOtl/qASD8phhB92K/5rJX5rpdK9qihOlUGPl9jzPVre4TONJdC
         ymh/eqsrF2RnPDooD/oxOXKnMqJNthlt+pJZKLzTwHxD25HodKVILS0xwCzcqVTLmg
         GOsezFHZwdyzpPFXb4tj/azFir0FquFzEqHS173s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Maxime Ripard <maxime@cerno.tech>,
        Jernej Skrabec <jernej.skrabec@siol.net>,
        Chen-Yu Tsai <wens@csie.org>
Subject: [PATCH 5.4 357/357] dt-bindings: rtc: sun6i-a31-rtc: Loosen the requirements on the clocks
Date:   Fri, 10 Mar 2023 14:40:46 +0100
Message-Id: <20230310133750.431080818@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133733.973883071@linuxfoundation.org>
References: <20230310133733.973883071@linuxfoundation.org>
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

From: Maxime Ripard <maxime@cerno.tech>

commit 48b47749e334b3891f33b9425b470a3c92be8dae upstream.

The commit ec98a87509f4 ("rtc: sun6i: Make external 32k oscillator
optional") loosened the requirement of the clocks property, making it
optional. However, the binding still required it to be present.

Cc: Alexandre Belloni <alexandre.belloni@bootlin.com>
Fixes: ec98a87509f4 ("rtc: sun6i: Make external 32k oscillator optional")
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Acked-by: Jernej Skrabec <jernej.skrabec@siol.net>
Acked-by: Chen-Yu Tsai <wens@csie.org>
Link: https://lore.kernel.org/r/20210114113538.1233933-3-maxime@cerno.tech
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/devicetree/bindings/rtc/allwinner,sun6i-a31-rtc.yaml |    1 -
 1 file changed, 1 deletion(-)

--- a/Documentation/devicetree/bindings/rtc/allwinner,sun6i-a31-rtc.yaml
+++ b/Documentation/devicetree/bindings/rtc/allwinner,sun6i-a31-rtc.yaml
@@ -128,7 +128,6 @@ required:
   - compatible
   - reg
   - interrupts
-  - clocks
   - clock-output-names
 
 additionalProperties: false


