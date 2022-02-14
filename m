Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CD574B4C56
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 11:44:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243526AbiBNKkJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 05:40:09 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348753AbiBNKic (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 05:38:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E75BCA9949;
        Mon, 14 Feb 2022 02:03:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4E415B80DB7;
        Mon, 14 Feb 2022 10:03:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F0A6C340EF;
        Mon, 14 Feb 2022 10:03:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644833034;
        bh=zSxF394CzzOLorVxrPxYGvkJ2LgkRa2Vc1AgazkaAPA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Oye9LT94VrLqNbYCIJowybnHEcTNw3H8q8Jv3IS0yate0VpMMXC53CSW5A2QDMStJ
         781Jmc5u+daQgBzNVonUfugch8DBSp+comXOO5Feqr/YNxtop6dWwcI3dzflGp7BKp
         S2gDPBVCkG1+ulC+KyBeQ6vLQ20j73LTzU8h1EKY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
        Chia-Wei Wang <chiawei_wang@aspeedtech.com>,
        Joel Stanley <joel@jms.id.au>, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 5.16 202/203] docs/ABI: testing: aspeed-uart-routing: Escape asterisk
Date:   Mon, 14 Feb 2022 10:27:26 +0100
Message-Id: <20220214092517.240687299@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092510.221474733@linuxfoundation.org>
References: <20220214092510.221474733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chia-Wei Wang <chiawei_wang@aspeedtech.com>

commit 088400521e421a1df7d0128dc0f9246db4ef1c7c upstream.

Escape asterisk symbols to fix the following warning:

"WARNING: Inline emphasis start-string without end-string"

Fixes: c6807970c3bc ("soc: aspeed: Add UART routing support")
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Chia-Wei Wang <chiawei_wang@aspeedtech.com>
Signed-off-by: Joel Stanley <joel@jms.id.au>
Link: https://lore.kernel.org/r/20220124014351.9121-1-chiawei_wang@aspeedtech.com
Link: https://lore.kernel.org/r/20220201070027.196314-1-joel@jms.id.au'
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/ABI/testing/sysfs-driver-aspeed-uart-routing |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/Documentation/ABI/testing/sysfs-driver-aspeed-uart-routing
+++ b/Documentation/ABI/testing/sysfs-driver-aspeed-uart-routing
@@ -1,4 +1,4 @@
-What:		/sys/bus/platform/drivers/aspeed-uart-routing/*/uart*
+What:		/sys/bus/platform/drivers/aspeed-uart-routing/\*/uart\*
 Date:		September 2021
 Contact:	Oskar Senft <osk@google.com>
 		Chia-Wei Wang <chiawei_wang@aspeedtech.com>
@@ -9,7 +9,7 @@ Description:	Selects the RX source of th
 		depends on the selected file.
 
 		e.g.
-		cat /sys/bus/platform/drivers/aspeed-uart-routing/*.uart_routing/uart1
+		cat /sys/bus/platform/drivers/aspeed-uart-routing/\*.uart_routing/uart1
 		[io1] io2 io3 io4 uart2 uart3 uart4 io6
 
 		In this case, UART1 gets its input from IO1 (physical serial port 1).
@@ -17,7 +17,7 @@ Description:	Selects the RX source of th
 Users:		OpenBMC.  Proposed changes should be mailed to
 		openbmc@lists.ozlabs.org
 
-What:		/sys/bus/platform/drivers/aspeed-uart-routing/*/io*
+What:		/sys/bus/platform/drivers/aspeed-uart-routing/\*/io\*
 Date:		September 2021
 Contact:	Oskar Senft <osk@google.com>
 		Chia-Wei Wang <chiawei_wang@aspeedtech.com>


