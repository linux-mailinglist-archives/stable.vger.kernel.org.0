Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46A453C3C30
	for <lists+stable@lfdr.de>; Sun, 11 Jul 2021 14:17:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232710AbhGKMUT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Jul 2021 08:20:19 -0400
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:50247 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232071AbhGKMUT (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 11 Jul 2021 08:20:19 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 6FDDD1AC0D1D;
        Sun, 11 Jul 2021 08:17:32 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Sun, 11 Jul 2021 08:17:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=lucLBf
        he6706n6vthm7S/IbA2dZMkl9NANEEYVgboAo=; b=JywXRU7W3uzh5J+BWmUB7w
        BUbUIVexwB1ErQkaHSDPDN5mNnRK7iO74LsHyITY4VDdjLCYNwOG1BwOqDe73oCU
        jHVHys4LZhTokQkl0R3n4AQ4WVGk7t41uI8QrDZmhZ7MCwWKV1HxBe5AKEPT7RAD
        clg8FEPdKCQPMMpG7tBvCoLhSmxbqv64LlkZojD7//4FdA/Rh3QBtGa+2qtRxzTC
        Ze2+rfr/8nyvCy2mBUD1Fv+GLq1JLpcq7doeowasO7zjKlvOi+mqLoofOygJnjMv
        iXt8bAN0VAPY+z1nDdhCoPHSG2MLyVD+Gga4XpSYpR/oAr2G7EXmzmlTHfY8YrTQ
        ==
X-ME-Sender: <xms:WuHqYO_mMNvmrgt1MIm-nB276AQccYrNKOzovefpP7Z7ICmZsec4rA>
    <xme:WuHqYOspl7F19fmJdIsY_U_rHS1louN7tjbwyqDf3_wR_PtsOnlowMU_jIgYptLDb
    fpTg8B21Yk9gw>
X-ME-Received: <xmr:WuHqYEBTCtOjz4laZpsna0AiGKZCqvUkDwQMqU1-H7d-S9upQQM2MU7SMZoXq6XmKuoH5p-BLbRuj0X29hGb18TYMQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddruddtgdehtdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehjedute
    evueevledujeejgfetheenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgr
    ihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:WuHqYGdeFKat1ff9-4OujQ_Vm0Ebz34WAKmBZhhmV_TbQT8guQ_GkQ>
    <xmx:WuHqYDOAtJgz9KcKhr4FewOSz4o5U84GenIzksgENY63eDeM4upsYg>
    <xmx:WuHqYAkE8xl3mLfAIwtT_LF37tYmWuwxicz4QsfN_f_0-dbKJcxGpQ>
    <xmx:XOHqYMZADrzJC1OV9C0FLZHvkQ1yEcl1AwBS0Nh0A6qv6GQrgrUW6t0T1nc>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 11 Jul 2021 08:17:30 -0400 (EDT)
Subject: FAILED: patch "[PATCH] crypto: ccp - Annotate SEV Firmware file names" failed to apply to 5.4-stable tree
To:     jroedel@suse.de, herbert@gondor.apana.org.au,
        thomas.lendacky@amd.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 11 Jul 2021 14:17:29 +0200
Message-ID: <1626005849185115@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
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

From c8671c7dc7d51125ab9f651697866bf4a9132277 Mon Sep 17 00:00:00 2001
From: Joerg Roedel <jroedel@suse.de>
Date: Mon, 26 Apr 2021 10:17:48 +0200
Subject: [PATCH] crypto: ccp - Annotate SEV Firmware file names

Annotate the firmware files CCP might need using MODULE_FIRMWARE().
This will get them included into an initrd when CCP is also included
there. Otherwise the CCP module will not find its firmware when loaded
before the root-fs is mounted.
This can cause problems when the pre-loaded SEV firmware is too old to
support current SEV and SEV-ES virtualization features.

Fixes: e93720606efd ("crypto: ccp - Allow SEV firmware to be chosen based on Family and Model")
Cc: stable@vger.kernel.org # v4.20+
Acked-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 3506b2050fb8..91808402e0bf 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -43,6 +43,10 @@ static int psp_probe_timeout = 5;
 module_param(psp_probe_timeout, int, 0644);
 MODULE_PARM_DESC(psp_probe_timeout, " default timeout value, in seconds, during PSP device probe");
 
+MODULE_FIRMWARE("amd/amd_sev_fam17h_model0xh.sbin"); /* 1st gen EPYC */
+MODULE_FIRMWARE("amd/amd_sev_fam17h_model3xh.sbin"); /* 2nd gen EPYC */
+MODULE_FIRMWARE("amd/amd_sev_fam19h_model0xh.sbin"); /* 3rd gen EPYC */
+
 static bool psp_dead;
 static int psp_timeout;
 

