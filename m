Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C45F5F2AF2
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 09:44:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231797AbiJCHoo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 03:44:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232273AbiJCHoC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 03:44:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47C264B0FA;
        Mon,  3 Oct 2022 00:25:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9FCDB60FC9;
        Mon,  3 Oct 2022 07:23:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2F74C433C1;
        Mon,  3 Oct 2022 07:23:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664781828;
        bh=NDVewY7N+0JeaK4mQ8nR5KJuftCfb9aKfsSmUmzgNyI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xS94i8Ma3YQgcrqsOpXYH0txfE3VEbAWc96Gy9//ndR1L2xRJVDVO9rSEECO2ncF2
         tYoHdhblrvOUr3pbUUoSuBuXp5slSlwiVb7drnTOpjGJXAsL4I9ArZc+1RIpWiTl29
         Ba8yHSRUdRI42WyIy+DrOdhJAOmU/kncyG6LA69o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 5.4 06/30] ARM: dts: integrator: Tag PCI host with device_type
Date:   Mon,  3 Oct 2022 09:11:48 +0200
Message-Id: <20221003070716.458611463@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221003070716.269502440@linuxfoundation.org>
References: <20221003070716.269502440@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

commit 4952aa696a9f221c5e34e5961e02fca41ef67ad6 upstream.

The DT parser is dependent on the PCI device being tagged as
device_type = "pci" in order to parse memory ranges properly.
Fix this up.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20220919092608.813511-1-linus.walleij@linaro.org'
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/boot/dts/integratorap.dts |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/arm/boot/dts/integratorap.dts
+++ b/arch/arm/boot/dts/integratorap.dts
@@ -155,6 +155,7 @@
 
 	pci: pciv3@62000000 {
 		compatible = "arm,integrator-ap-pci", "v3,v360epc-pci";
+		device_type = "pci";
 		#interrupt-cells = <1>;
 		#size-cells = <2>;
 		#address-cells = <3>;


