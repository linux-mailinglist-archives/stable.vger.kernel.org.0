Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B63E377EC1
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 10:56:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230137AbhEJI5g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 04:57:36 -0400
Received: from forward2-smtp.messagingengine.com ([66.111.4.226]:52637 "EHLO
        forward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230050AbhEJI5c (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 May 2021 04:57:32 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailforward.nyi.internal (Postfix) with ESMTP id 230891940904;
        Mon, 10 May 2021 04:56:27 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Mon, 10 May 2021 04:56:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=/L8Jpz
        aWvlVNj5AUgrhUv++FvSrHkPnKQNJuOLrRclo=; b=VVfbNtlFlWf1doLSrWu2J5
        mQz13tn0HzpbI3y9y1VN4K+1GqEtXK0MraQKX/apJmHwkH8Bm88msJfe535/8vhg
        YmDlFawYgm2XRvWBkcFM05TVKcQ7YAuGypwz7sIu1fl+aFh3AhmloSuSVwLeIlt4
        qp8jQXwf1NCFz9WKuX22+7qqFJnN85OtZtYu5SBuxpgWDiHkihug3p5VZKpeZGgH
        jSIek8IllovS78oVz2IYaussU32z7dMkHbz95lMW8ZDrw0UumtqcBBazBkRqd3QU
        cdngeiEGINeqMW6zYSjxVCH0JskPf6Yg7VBJkm68VUYkQ1nCK0pj127esf+0W0Ng
        ==
X-ME-Sender: <xms:OvWYYEZLDEA0QVsdTjg1kgqrB2yp85rlkOI8BT-CktR0nHgLqlnung>
    <xme:OvWYYPYMW7EBgkCB7GiiDbvBFwcZpfE3D21KORPcu41b-y9jlJvrj_DvwydOYeMvx
    BO9dJXjBCuVHg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdegkedgtdelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtjeenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepkeejgffftefgveeggeehudfgleehkedthedtiefhie
    elieetveejvdfgvdeljeelnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:OvWYYO_gkY82bVcKeP6rUHwi3Ps0WgePZA0YOO8dTVPb9dakMemQ6w>
    <xmx:OvWYYOrrahSaRoLF1VpccZHv1H7viYGtXKNVgb0iCqOpZ0_6bOqAOQ>
    <xmx:OvWYYPpydmXNIIujJLmEys9WkMW6lO3XHir5G1DCNK_lv8nFHIumTQ>
    <xmx:O_WYYOXmKYkzNcX9wRd-na6htKyQ1a_uCkYRt8plgiLANSDguVkKpw>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Mon, 10 May 2021 04:56:26 -0400 (EDT)
Subject: FAILED: patch "[PATCH] pinctrl: Ingenic: Add missing pins to the JZ4770 MAC MII" failed to apply to 5.10-stable tree
To:     zhouyanjie@wanyeetech.com, andy.shevchenko@gmail.com,
        linus.walleij@linaro.org, paul@crapouillou.net,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 10 May 2021 10:56:10 +0200
Message-ID: <16206369706565@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 65afd97630a9d6dd9ea83ff182dfdb15bc58c5d1 Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?=E5=91=A8=E7=90=B0=E6=9D=B0=20=28Zhou=20Yanjie=29?=
 <zhouyanjie@wanyeetech.com>
Date: Sun, 18 Apr 2021 22:44:22 +0800
Subject: [PATCH] pinctrl: Ingenic: Add missing pins to the JZ4770 MAC MII
 group.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The MII group of JZ4770's MAC should have 7 pins, add missing
pins to the MII group.

Fixes: 5de1a73e78ed ("Pinctrl: Ingenic: Add missing parts for JZ4770 and JZ4780.")
Cc: <stable@vger.kernel.org>
Signed-off-by: 周琰杰 (Zhou Yanjie) <zhouyanjie@wanyeetech.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Reviewed-by: Paul Cercueil <paul@crapouillou.net>
Link: https://lore.kernel.org/r/1618757073-1724-2-git-send-email-zhouyanjie@wanyeetech.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>

diff --git a/drivers/pinctrl/pinctrl-ingenic.c b/drivers/pinctrl/pinctrl-ingenic.c
index c8ecd014cf19..f15ef814b75a 100644
--- a/drivers/pinctrl/pinctrl-ingenic.c
+++ b/drivers/pinctrl/pinctrl-ingenic.c
@@ -667,7 +667,9 @@ static int jz4770_pwm_pwm7_pins[] = { 0x6b, };
 static int jz4770_mac_rmii_pins[] = {
 	0xa9, 0xab, 0xaa, 0xac, 0xa5, 0xa4, 0xad, 0xae, 0xa6, 0xa8,
 };
-static int jz4770_mac_mii_pins[] = { 0xa7, 0xaf, };
+static int jz4770_mac_mii_pins[] = {
+	0x7b, 0x7a, 0x7d, 0x7c, 0xa7, 0x24, 0xaf,
+};
 
 static const struct group_desc jz4770_groups[] = {
 	INGENIC_PIN_GROUP("uart0-data", jz4770_uart0_data, 0),

