Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62FCB5F2B8C
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 10:18:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229480AbiJCISi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 04:18:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229618AbiJCISP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 04:18:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5921786E1;
        Mon,  3 Oct 2022 00:53:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A916FB80E74;
        Mon,  3 Oct 2022 07:17:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1672FC433B5;
        Mon,  3 Oct 2022 07:17:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664781429;
        bh=EXjK73KHdYpm2V0MmgjH12NZLEWMdxNT6n4uqcYvUtc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K6YBqMUrAI1mMSLctzDqTILB9lbYuoelpvk+hdZ3aw6fZhiqW8VXGpMxhpxL8L5iG
         abzSDduFVuBd4M7A6Ve6Ktuu/CDsHRz9L694gyBpDPAfbJSxzg5O32AE5anDYj/n3M
         W4/iEk25ZEMbvsnX8kQqkcprjkmVEUYk+Tiqubfc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 5.15 17/83] ARM: dts: integrator: Tag PCI host with device_type
Date:   Mon,  3 Oct 2022 09:10:42 +0200
Message-Id: <20221003070722.415685981@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221003070721.971297651@linuxfoundation.org>
References: <20221003070721.971297651@linuxfoundation.org>
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
@@ -153,6 +153,7 @@
 
 	pci: pciv3@62000000 {
 		compatible = "arm,integrator-ap-pci", "v3,v360epc-pci";
+		device_type = "pci";
 		#interrupt-cells = <1>;
 		#size-cells = <2>;
 		#address-cells = <3>;


