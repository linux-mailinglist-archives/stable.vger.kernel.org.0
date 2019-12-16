Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B231C12049D
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 13:01:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727562AbfLPMAL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 07:00:11 -0500
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:37377 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727491AbfLPMAL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Dec 2019 07:00:11 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 80E4B776;
        Mon, 16 Dec 2019 07:00:10 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Mon, 16 Dec 2019 07:00:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=y5/pu9
        2CqiUOlPQdmsRC9I90dChMQ38LPCL/D+/fcJs=; b=IspBS6bfx1mST/HBp265VW
        3RTIrCUP17AxcKaTd3Y3nG6Xst79rXUWSwY3A3jMypkPlE2GJgyKp2IsI4eCOXig
        kVgio57s2zz7KIpGgmEcsL4RXBdS6oBwJ8IWJ7Qlwqj3ZdigI9oFoDWVSo75hzre
        HYSfsuFl/JSkj9hNdHRiSatzM5rJqzuiLRjeLG+wbZsEhxeFSGVFlqOCBjbDJJ2n
        dgY9t85idIgvyF1itT37bsaIl3/L0WEGZGBlBnMx9vAfD7LnNaXOP9YkeR4/IR29
        qVuh3vshcByDjFkzcybS+9tdvjHgdHR8IzpVpbpW0iIY2P/NYdSAwwqF3YbjRqFg
        ==
X-ME-Sender: <xms:yHH3XbhakXylIO5Tu9pStRKjOGHS4YmhP8GwdBUd4JkfJX-DyfshZw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvddthedgfeehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:yHH3XRqjma6B4kGodB7Fq0TBw9UtpKHSdYqTsosvALOWf7AjAGYdhQ>
    <xmx:yHH3XbHFvfns45WWkcrE3eItELEFU3dDgNvQ7enFWaKCXIBPBVQvVA>
    <xmx:yHH3Xbk6FMdPviqvjF7--sFifrZI6NWGN9SHC1-W1zEwoJC0VfGXrA>
    <xmx:ynH3XWvRmX_CYI5Iip_0Fy9zRS0gqpf2EJEsiazMdXH5xmGLICbkBQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 871368005A;
        Mon, 16 Dec 2019 07:00:08 -0500 (EST)
Subject: FAILED: patch "[PATCH] mfd: rk808: Fix RK818 ID template" failed to apply to 4.19-stable tree
To:     d.schultz@phytec.de, chenjh@rock-chips.com, heiko@sntech.de,
        lee.jones@linaro.org, zhangqing@rock-chips.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 16 Dec 2019 13:00:05 +0100
Message-ID: <1576497605185176@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 37ef8c2c15bdc1322b160e38986c187de2b877b2 Mon Sep 17 00:00:00 2001
From: Daniel Schultz <d.schultz@phytec.de>
Date: Tue, 17 Sep 2019 10:12:53 +0200
Subject: [PATCH] mfd: rk808: Fix RK818 ID template

The Rockchip PMIC driver can automatically detect connected component
versions by reading the ID_MSB and ID_LSB registers. The probe function
will always fail with RK818 PMICs because the ID_MSK is 0xFFF0 and the
RK818 template ID is 0x8181.

This patch changes this value to 0x8180.

Fixes: 9d6105e19f61 ("mfd: rk808: Fix up the chip id get failed")
Cc: stable@vger.kernel.org
Cc: Elaine Zhang <zhangqing@rock-chips.com>
Cc: Joseph Chen <chenjh@rock-chips.com>
Signed-off-by: Daniel Schultz <d.schultz@phytec.de>
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Lee Jones <lee.jones@linaro.org>

diff --git a/include/linux/mfd/rk808.h b/include/linux/mfd/rk808.h
index 7cfd2b0504df..a59bf323f713 100644
--- a/include/linux/mfd/rk808.h
+++ b/include/linux/mfd/rk808.h
@@ -610,7 +610,7 @@ enum {
 	RK808_ID = 0x0000,
 	RK809_ID = 0x8090,
 	RK817_ID = 0x8170,
-	RK818_ID = 0x8181,
+	RK818_ID = 0x8180,
 };
 
 struct rk808 {

