Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC282225E4D
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 14:19:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728654AbgGTMTg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 08:19:36 -0400
Received: from forward5-smtp.messagingengine.com ([66.111.4.239]:42117 "EHLO
        forward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728532AbgGTMTf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jul 2020 08:19:35 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 9F7ED1941124;
        Mon, 20 Jul 2020 08:19:34 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 20 Jul 2020 08:19:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=fDaVp2
        +ti98ARNbfBSrzCYf+b6IAPpgPn5j3RE1FknY=; b=RHDNbL5JONSpNP85ihKFRL
        o8EIilmwvNfR3mKTRWb9QZ11fsG84NH8StTr81PAEartHanO4Q3igszUFee+32kZ
        SoWhOlGXiOQhGU25R8ymHimMIsWbaRqaSarhnBpR4Gxqwve2HD3yVgO+TB/9wkmV
        eq+lgtpaMc18plET63CBt/781pzEXW3atZskEnnJ2WSKPtttW0ZgFl7e5VZ+G0sy
        QikRXwsFK1+bfEFSE3uuu8UbvzdtvJcCtdXl5/lRU7v2BV9naXIiflWil/DIPHzZ
        czGoJO9mEMvqcwqLzSSI+gE/nYvfIpYepTZJaneQqmufQRtx6jIhiYoHE08TLKog
        ==
X-ME-Sender: <xms:1osVX8kvueN8xCH0K-wXu6Kied8oDrs8xRI5GD07SPGQn-oR9m5-DA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrgeeggddvhecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehjedute
    evueevledujeejgfetheenucfkphepkeefrdekiedrkeelrddutdejnecuvehluhhsthgv
    rhfuihiivgepudenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:1osVX70KCvpfUuvE9rTh35my4tvJlX6kjguFHLmQWjfROLZm2fsM9w>
    <xmx:1osVX6q4iD_LQEYKtIRgSYtdykCjKoXBi5N6eKKbe9oTMVDoTfM0gg>
    <xmx:1osVX4nIutDrTYY_cE6qyXXNyH1uDAz0wdHb2rAiLSZxYMhTy1lORg>
    <xmx:1osVX7Bq6qq6utzrZnPfzat4ydxvbJK39jssG1HjMM-FtbopczKuJA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 3D7D530600B2;
        Mon, 20 Jul 2020 08:19:34 -0400 (EDT)
Subject: FAILED: patch "[PATCH] arm64: dts: stratix10: add status to qspi dts node" failed to apply to 4.19-stable tree
To:     dinguyen@kernel.org, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 20 Jul 2020 14:19:37 +0200
Message-ID: <15952475775124@kroah.com>
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

From 263a0269a59c0b4145829462a107fe7f7327105f Mon Sep 17 00:00:00 2001
From: Dinh Nguyen <dinguyen@kernel.org>
Date: Mon, 29 Jun 2020 11:25:43 -0500
Subject: [PATCH] arm64: dts: stratix10: add status to qspi dts node

Add status = "okay" to QSPI node.

Fixes: 0cb140d07fc75 ("arm64: dts: stratix10: Add QSPI support for Stratix10")
Cc: linux-stable <stable@vger.kernel.org> # >= v5.6
Signed-off-by: Dinh Nguyen <dinguyen@kernel.org>

diff --git a/arch/arm64/boot/dts/altera/socfpga_stratix10_socdk.dts b/arch/arm64/boot/dts/altera/socfpga_stratix10_socdk.dts
index f6c4a15079d3..feadd21bc0dc 100644
--- a/arch/arm64/boot/dts/altera/socfpga_stratix10_socdk.dts
+++ b/arch/arm64/boot/dts/altera/socfpga_stratix10_socdk.dts
@@ -155,6 +155,7 @@
 };
 
 &qspi {
+	status = "okay";
 	flash@0 {
 		#address-cells = <1>;
 		#size-cells = <1>;
diff --git a/arch/arm64/boot/dts/altera/socfpga_stratix10_socdk_nand.dts b/arch/arm64/boot/dts/altera/socfpga_stratix10_socdk_nand.dts
index 9946515b8afd..4000c393243d 100644
--- a/arch/arm64/boot/dts/altera/socfpga_stratix10_socdk_nand.dts
+++ b/arch/arm64/boot/dts/altera/socfpga_stratix10_socdk_nand.dts
@@ -188,6 +188,7 @@
 };
 
 &qspi {
+	status = "okay";
 	flash@0 {
 		#address-cells = <1>;
 		#size-cells = <1>;

