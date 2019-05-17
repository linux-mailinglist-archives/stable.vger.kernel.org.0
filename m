Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5FDF7218A7
	for <lists+stable@lfdr.de>; Fri, 17 May 2019 14:57:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728559AbfEQM5H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 May 2019 08:57:07 -0400
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:36655 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728548AbfEQM5H (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 May 2019 08:57:07 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 79C6647A;
        Fri, 17 May 2019 08:57:06 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Fri, 17 May 2019 08:57:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=hjbI8/
        YLzt3kdaW+ufotF09lI3CALgt+i5KT5nzEjY0=; b=R3KB4w2Eh7kpqvZ/hsBSR8
        zBtTZjl2P7ciP2CWqgKLV8nEAWBEHASNxHqcXhOTvfPEv7+RFlqLFiZf9FV6QeOv
        xDSEzbc6zngArHsegQ8KPpmZuAjGwkLKlweYGD/n76d04CkvAwzsqg+nE8rPmjpY
        RiZa9qc/VkdK1YEvFsqWhjJ2fxCuuCeQeMdY7lChRZBzBn/dPTlbyn/4K41hFZqN
        6kTLiGLgmwnOkdunwRifyZotYvzv9At3AHpm2kiTXpLpaVQvnegT/8xa6Pp7TqTt
        JxSNZXUgK49gmG2BWfrscvkPJStjIc+RfouPgHt4dD/9M96M5xRuX1limyEAD8VA
        ==
X-ME-Sender: <xms:oa_eXJ5EarK6kO8xOvt-_OdXZBIqxF8ndV2SVrGDW_uVSqGdDfnX1Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddruddtvddgheelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:oa_eXLIgslePC-8XfqwW9sHBC_qkf87LXXa_cg5nov-vdGFr69oNDQ>
    <xmx:oa_eXLfE-qG3PF5svZyviDKBTqSmkNeddPjdQ8ZqZEQzn_n2b0SKpw>
    <xmx:oa_eXGc1NV5l6yAS5hQPyOGHq9umB41o47sjTcbtNt7zA2dLSSCFfA>
    <xmx:oq_eXFI2nECXDDm3824vkWcEraJ7MyaHNClJ8-PE9XReQ_E-KT3xZQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 3ACA2103CF;
        Fri, 17 May 2019 08:57:05 -0400 (EDT)
Subject: FAILED: patch "[PATCH] dt-bindings: mmc: Add disable-cqe-dcmd property." failed to apply to 5.0-stable tree
To:     christoph.muellner@theobroma-systems.com,
        philipp.tomsich@theobroma-systems.com, ulf.hansson@linaro.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 17 May 2019 14:55:17 +0200
Message-ID: <155809771718747@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.0-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 28f22fb755ecf9f933f045bc0afdb8140641b01c Mon Sep 17 00:00:00 2001
From: Christoph Muellner <christoph.muellner@theobroma-systems.com>
Date: Fri, 22 Mar 2019 12:38:04 +0100
Subject: [PATCH] dt-bindings: mmc: Add disable-cqe-dcmd property.

Add disable-cqe-dcmd as optional property for MMC hosts.
This property allows to disable or not enable the direct command
features of the command queue engine.

Signed-off-by: Christoph Muellner <christoph.muellner@theobroma-systems.com>
Signed-off-by: Philipp Tomsich <philipp.tomsich@theobroma-systems.com>
Fixes: 84362d79f436 ("mmc: sdhci-of-arasan: Add CQHCI support for arasan,sdhci-5.1")
Cc: stable@vger.kernel.org
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>

diff --git a/Documentation/devicetree/bindings/mmc/mmc.txt b/Documentation/devicetree/bindings/mmc/mmc.txt
index cdbcfd3a4ff2..c269dbe384fe 100644
--- a/Documentation/devicetree/bindings/mmc/mmc.txt
+++ b/Documentation/devicetree/bindings/mmc/mmc.txt
@@ -64,6 +64,8 @@ Optional properties:
   whether pwrseq-simple is used. Default to 10ms if no available.
 - supports-cqe : The presence of this property indicates that the corresponding
   MMC host controller supports HW command queue feature.
+- disable-cqe-dcmd: This property indicates that the MMC controller's command
+  queue engine (CQE) does not support direct commands (DCMDs).
 
 *NOTE* on CD and WP polarity. To use common for all SD/MMC host controllers line
 polarity properties, we have to fix the meaning of the "normal" and "inverted"

