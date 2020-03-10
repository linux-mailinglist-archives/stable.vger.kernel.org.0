Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EEB4417F5C0
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 12:09:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726205AbgCJLJg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 07:09:36 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:56719 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725937AbgCJLJg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Mar 2020 07:09:36 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 9ABD922083;
        Tue, 10 Mar 2020 07:09:35 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Tue, 10 Mar 2020 07:09:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=yFwWqi
        mWq6QXUCJ/y4yAyRd2ia05leziit9BTFIAfKY=; b=PP8lBSR/h5z4zdjVuBSs2U
        nlVAHSXmCdMC7aMgIpu8AKyKUrkxx0htm15+HjToDooq37ZgtsZXWRpp5OSjXb9E
        Ue0VCRtrrfssFhv3NAz0UuZp9Z9IGygnHRJeEFTRGHClV9Isc9NmYwQNnBs7SBJS
        Qt9ZiCLyUNES4lsD60AvIiklxMmbSxEl0iiCSki/vUGuhhBP6DjbIdrVUXGLvsr/
        AcA5Ok2qxQjCudW+78QR1rLqp32P5RxmY0MTx34yExMwUuft+G6HEBLmLFVKJ0jG
        O0IjxmnEJrEmvZA/qZeXZo8hSGbW/s8fw746z/d+ADIEr7v0OYPSzzmuNv1R3SJQ
        ==
X-ME-Sender: <xms:b3VnXrwPl6qjd5ckD7cjUDpehCKG1oLkPGB4TnI9dyFt_AK5O_ywhw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedruddvtddgvdegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucevlhhushhtvghrufhiiigvpedtne
    curfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:b3VnXsekdTP7LHcxgoN7fQt6-pVPJU-iIk9dCBd5GXeMYvx-CHG7MQ>
    <xmx:b3VnXvfTQxJkT0EG2npabh1VJaI6yOG08MsfpVz6BTjBk6JOXB4mRQ>
    <xmx:b3VnXmZ9KI58j0XlK3k9pw69HW68xqW2wkOeXk5Ljq2RbGwhqnd17w>
    <xmx:b3VnXr4Lz59ZPy6EeQpOloX10jOzthqUVqvfLdkdq7e8mtEZJJIW8g>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 19946306130A;
        Tue, 10 Mar 2020 07:09:35 -0400 (EDT)
Subject: FAILED: patch "[PATCH] ARM: dts: imx7d: fix opp-supported-hw" failed to apply to 5.4-stable tree
To:     peng.fan@nxp.com, leonard.crestez@nxp.com, shawnguo@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 10 Mar 2020 12:09:33 +0100
Message-ID: <15838385734134@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 54d6477dca3b65b7b77a903fe60a9447bc836e7f Mon Sep 17 00:00:00 2001
From: Peng Fan <peng.fan@nxp.com>
Date: Sun, 19 Jan 2020 10:09:32 +0000
Subject: [PATCH] ARM: dts: imx7d: fix opp-supported-hw

Per i.MX7D Document Number: IMX7DCEC Rev. 6, 03/2019,
there are only consumer/industrial parts, and 1.2GHz
is only support in consumer parts.

So exclude automotive from 792/996MHz/1.2GHz and exclude
industrial from 1.2GHz.

Fixes: d7bfba7296ca ("ARM: dts: imx7d: Update cpufreq OPP table")
Cc: Leonard Crestez <leonard.crestez@nxp.com>
Signed-off-by: Peng Fan <peng.fan@nxp.com>
Reviewed-by: Leonard Crestez <leonard.crestez@nxp.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>

diff --git a/arch/arm/boot/dts/imx7d.dtsi b/arch/arm/boot/dts/imx7d.dtsi
index 92f6d0c2a74f..4c22828df55f 100644
--- a/arch/arm/boot/dts/imx7d.dtsi
+++ b/arch/arm/boot/dts/imx7d.dtsi
@@ -44,7 +44,7 @@ opp-792000000 {
 			opp-hz = /bits/ 64 <792000000>;
 			opp-microvolt = <1000000>;
 			clock-latency-ns = <150000>;
-			opp-supported-hw = <0xd>, <0xf>;
+			opp-supported-hw = <0xd>, <0x7>;
 			opp-suspend;
 		};
 
@@ -52,7 +52,7 @@ opp-996000000 {
 			opp-hz = /bits/ 64 <996000000>;
 			opp-microvolt = <1100000>;
 			clock-latency-ns = <150000>;
-			opp-supported-hw = <0xc>, <0xf>;
+			opp-supported-hw = <0xc>, <0x7>;
 			opp-suspend;
 		};
 
@@ -60,7 +60,7 @@ opp-1200000000 {
 			opp-hz = /bits/ 64 <1200000000>;
 			opp-microvolt = <1225000>;
 			clock-latency-ns = <150000>;
-			opp-supported-hw = <0x8>, <0xf>;
+			opp-supported-hw = <0x8>, <0x3>;
 			opp-suspend;
 		};
 	};

