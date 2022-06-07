Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76C8B5422B0
	for <lists+stable@lfdr.de>; Wed,  8 Jun 2022 08:47:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385284AbiFHBPY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 21:15:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1836575AbiFGX61 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 19:58:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2268519DE58;
        Tue,  7 Jun 2022 12:26:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D5E87B8220B;
        Tue,  7 Jun 2022 19:26:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B786C385A2;
        Tue,  7 Jun 2022 19:26:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654629976;
        bh=dCeVzC/jF/iTDOn+inmUhCo29O8Nt84UucMF/ifylBA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YLge8xIU3ooZkVZeDb1wuBp252Au881H6zhvFdMkddZnUXSI4ZVzghIuwlbZN2ey2
         zSjtLxAEWP0cafyohdcnbYnIPYn39g76ALzMBU0GycKGQYmo9Tvmh1ut3glEkR1AJZ
         WltDg+RvZfQk68gYEWdq/u6IWafSySQCfu+6J7TI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dinh Nguyen <dinguyen@kernel.org>
Subject: [PATCH 5.18 856/879] dt-bindings: gpio: altera: correct interrupt-cells
Date:   Tue,  7 Jun 2022 19:06:14 +0200
Message-Id: <20220607165027.701355783@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
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

From: Dinh Nguyen <dinguyen@kernel.org>

commit 3a21c3ac93aff7b4522b152399df8f6a041df56d upstream.

update documentation to correctly state the interrupt-cells to be 2.

Cc: stable@vger.kernel.org
Fixes: 4fd9bbc6e071 ("drivers/gpio: Altera soft IP GPIO driver devicetree binding")
Signed-off-by: Dinh Nguyen <dinguyen@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/devicetree/bindings/gpio/gpio-altera.txt |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/Documentation/devicetree/bindings/gpio/gpio-altera.txt
+++ b/Documentation/devicetree/bindings/gpio/gpio-altera.txt
@@ -9,8 +9,9 @@ Required properties:
   - The second cell is reserved and is currently unused.
 - gpio-controller : Marks the device node as a GPIO controller.
 - interrupt-controller: Mark the device node as an interrupt controller
-- #interrupt-cells : Should be 1. The interrupt type is fixed in the hardware.
+- #interrupt-cells : Should be 2. The interrupt type is fixed in the hardware.
   - The first cell is the GPIO offset number within the GPIO controller.
+  - The second cell is the interrupt trigger type and level flags.
 - interrupts: Specify the interrupt.
 - altr,interrupt-type: Specifies the interrupt trigger type the GPIO
   hardware is synthesized. This field is required if the Altera GPIO controller
@@ -38,6 +39,6 @@ gpio_altr: gpio@ff200000 {
 	altr,interrupt-type = <IRQ_TYPE_EDGE_RISING>;
 	#gpio-cells = <2>;
 	gpio-controller;
-	#interrupt-cells = <1>;
+	#interrupt-cells = <2>;
 	interrupt-controller;
 };


