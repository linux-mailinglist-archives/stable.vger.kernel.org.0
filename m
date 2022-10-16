Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2BEC5FFDF9
	for <lists+stable@lfdr.de>; Sun, 16 Oct 2022 09:34:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229575AbiJPHee (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 Oct 2022 03:34:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbiJPHed (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 Oct 2022 03:34:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8896BC38
        for <stable@vger.kernel.org>; Sun, 16 Oct 2022 00:34:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 94EAFB80B72
        for <stable@vger.kernel.org>; Sun, 16 Oct 2022 07:34:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01267C433D6;
        Sun, 16 Oct 2022 07:34:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665905669;
        bh=iHxwDYpbx3zdv+HMmSGKUKIvfQz/A8RjnOJ6RV9bhRI=;
        h=Subject:To:Cc:From:Date:From;
        b=g8dd/3xJKfkc4fPTRuJqPc8i6+bNju6RUyYEXwAQNo4O/H7cd/277KbDmb/CsmenQ
         3dT/vskadZqCwYgNFx7GiNi6DGsx5P4ZPYp0e+pOUCcvT3/hRuM44gtFlrSh/K2wDM
         V4JA7JZi2PIEzpwDXHyIF32GoygM+7fggzxXG9Nk=
Subject: FAILED: patch "[PATCH] ARM: dts: integrator: Tag PCI host with device_type" failed to apply to 6.0-stable tree
To:     linus.walleij@linaro.org, arnd@arndb.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 16 Oct 2022 09:35:15 +0200
Message-ID: <166590571580188@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 6.0-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

9d88bf08e46d ("ARM: dts: integrator: Tag PCI host with device_type")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 9d88bf08e46dc2d2975ef87877445a924a04a0a7 Mon Sep 17 00:00:00 2001
From: Linus Walleij <linus.walleij@linaro.org>
Date: Mon, 19 Sep 2022 11:26:08 +0200
Subject: [PATCH] ARM: dts: integrator: Tag PCI host with device_type

The DT parser is dependent on the PCI device being tagged as
device_type = "pci" in order to parse memory ranges properly.
Fix this up.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20220919092608.813511-1-linus.walleij@linaro.org'
Signed-off-by: Arnd Bergmann <arnd@arndb.de>

diff --git a/arch/arm/boot/dts/integratorap.dts b/arch/arm/boot/dts/integratorap.dts
index 9b652cc27b14..c983435ed492 100644
--- a/arch/arm/boot/dts/integratorap.dts
+++ b/arch/arm/boot/dts/integratorap.dts
@@ -160,6 +160,7 @@ pic: pic@14000000 {
 
 	pci: pciv3@62000000 {
 		compatible = "arm,integrator-ap-pci", "v3,v360epc-pci";
+		device_type = "pci";
 		#interrupt-cells = <1>;
 		#size-cells = <2>;
 		#address-cells = <3>;

