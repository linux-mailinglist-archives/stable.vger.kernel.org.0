Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F9E65406CC
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 19:38:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347258AbiFGRi1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 13:38:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347589AbiFGRf1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 13:35:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C5A5D8C;
        Tue,  7 Jun 2022 10:30:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0E845614B5;
        Tue,  7 Jun 2022 17:30:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15669C385A5;
        Tue,  7 Jun 2022 17:30:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654623055;
        bh=QkOH8aBw7HbsAVaM5zKar+EG2d5a++2v14+Ybugj7nQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qn9GOwKP2nqA+Sk4ZNdsOjwC25vjBtA40hq45zdqmYZaGimMwws+CBYm8rqk5P0jn
         s8b977YjS2G7BtpAcMPh202Yiaw8EVweonWFWpW65Zdk2t51vNhYei2LDQIvL8Cu59
         z0m0Gudhz9bx/arZ1dt5kXk8saMXvpJbTruWbzmc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Phil Elwell <phil@raspberrypi.com>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 278/452] ARM: dts: bcm2835-rpi-b: Fix GPIO line names
Date:   Tue,  7 Jun 2022 19:02:15 +0200
Message-Id: <20220607164916.834300719@linuxfoundation.org>
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

From: Stefan Wahren <stefan.wahren@i2se.com>

[ Upstream commit 97bd8659c1c46c23e4daea7e040befca30939950 ]

Recently this has been fixed in the vendor tree, so upstream this.

Fixes: 731b26a6ac17 ("ARM: bcm2835: Add names for the Raspberry Pi GPIO lines")
Signed-off-by: Phil Elwell <phil@raspberrypi.com>
Signed-off-by: Stefan Wahren <stefan.wahren@i2se.com>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/bcm2835-rpi-b.dts | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/arch/arm/boot/dts/bcm2835-rpi-b.dts b/arch/arm/boot/dts/bcm2835-rpi-b.dts
index 1b63d6b19750..25d87212cefd 100644
--- a/arch/arm/boot/dts/bcm2835-rpi-b.dts
+++ b/arch/arm/boot/dts/bcm2835-rpi-b.dts
@@ -53,18 +53,17 @@
 			  "GPIO18",
 			  "NC", /* GPIO19 */
 			  "NC", /* GPIO20 */
-			  "GPIO21",
+			  "CAM_GPIO0",
 			  "GPIO22",
 			  "GPIO23",
 			  "GPIO24",
 			  "GPIO25",
 			  "NC", /* GPIO26 */
-			  "CAM_GPIO0",
-			  /* Binary number representing build/revision */
-			  "CONFIG0",
-			  "CONFIG1",
-			  "CONFIG2",
-			  "CONFIG3",
+			  "GPIO27",
+			  "GPIO28",
+			  "GPIO29",
+			  "GPIO30",
+			  "GPIO31",
 			  "NC", /* GPIO32 */
 			  "NC", /* GPIO33 */
 			  "NC", /* GPIO34 */
-- 
2.35.1



