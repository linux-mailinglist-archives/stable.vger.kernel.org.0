Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53BE1550F6C
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 06:33:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231288AbiFTEdI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 00:33:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229998AbiFTEdH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 00:33:07 -0400
Received: from out5-smtp.messagingengine.com (out5-smtp.messagingengine.com [66.111.4.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BEB41133
        for <stable@vger.kernel.org>; Sun, 19 Jun 2022 21:33:06 -0700 (PDT)
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id B76C45C00EA;
        Mon, 20 Jun 2022 00:33:03 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 20 Jun 2022 00:33:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=traverse.com.au;
         h=cc:cc:content-transfer-encoding:date:date:from:from
        :in-reply-to:message-id:mime-version:reply-to:sender:subject
        :subject:to:to; s=fm1; t=1655699583; x=1655785983; bh=+AI340Wird
        kCNj2daU0dhzcNsCD3h4uVmVS2Tv0hb9s=; b=EdEE421SMaNmEO4D/AdwaLjP7Z
        EKz/olBcsjFjGI2bjhKCodGShwOVwIY41js2tkJvkI9SWv65EzDRAVJ6WU5KBakz
        P7ySKKVOsO5QPss5buWI7xeD99fOuayD8KQY3sTfUvY2GHIpuG8bs12JeeJZs141
        ArjvK4yy6TrWUtFPo7I3FDX011kfnMAnSBm/CzrGr0qvoUB27/4WaRjcil1HYfo5
        Q3yXjIlv1wqTujCIjeGkMhLEOx8XfbSjPT5NgHNN3DHlxWEGfP4h7sbweJU9IwSe
        cw0Cg3qntRut2cr0Sb/lg2FFQt0WvlZwIwC/mz9VeI3SIucij22YSgMRylcA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:message-id
        :mime-version:reply-to:sender:subject:subject:to:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
        1655699583; x=1655785983; bh=+AI340WirdkCNj2daU0dhzcNsCD3h4uVmVS
        2Tv0hb9s=; b=oIwDd5g67Mg95NtSVXZHJqX+Pva8w8DRFev5h+f5md5vhjhkztw
        hcWiSLbzwunwxgqDE1xswKunR05WNRM2qhtX20QJwVZFof0cmn+4IyywlcvUFyJQ
        TaDIC0lDp4MTyrFDfPvLmSFZaXzGby2DGivl8Yxnvc9npO9/GWy52SE8yZUNoqRp
        FMB2tXKPRdlMdFpERPRYULFT0l0MCfM7D4sErgPgk/VhNYXU+2qYy/RBqsCKLaYp
        kEOPMdd59TJsTlEDELQ/Mxp4v11hsSmOo4u8iFR7zNPQy8BjH60fQJZ9tPObXuWs
        45/64yFqGhNU+v9dAJB61qnRsUfg4GBaZQQ==
X-ME-Sender: <xms:f_ivYs0BqAkFRmp60tQmWnMVOijMIYzFdGOmzXsjMbmXcux286eFFw>
    <xme:f_ivYnEOGcVXSgpW9h6zWzuq0FGDv3uQ2WcECo0FHTl4Hj3U6yiX1Uc6uoyRfxPUh
    WNMm2UVtzxEwy5Bq3c>
X-ME-Received: <xmr:f_ivYk4EMbSK4yCxrrTk1MIm37UQ8i5eLhR9ejFt88f07qnOgv0GwDmFbYOSdxOUTGAZq8wm5eECE6AxPtR2zop-0N68IH873A9m2g_GJQBHglvF9uDJ_EB5xqD1_j8>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrudeftddgkeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhephffvvefufffkofgggfestdekredtredttdenucfhrhhomhepofgrthhhvgif
    ucfotgeurhhiuggvuceomhgrthhtsehtrhgrvhgvrhhsvgdrtghomhdrrghuqeenucggtf
    frrghtthgvrhhnpefgkeetgedufffgtdevvdejjefftdfghfetfefgueehhfeljeffgfef
    ueeujeelffenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhroh
    hmpehmrghtthesthhrrghvvghrshgvrdgtohhmrdgruh
X-ME-Proxy: <xmx:f_ivYl1ViKNE2eeJ1-e0rkumhvnQE2wAomMuTYom8A7tweImtTCdjw>
    <xmx:f_ivYvGqvbEPWDEx0kGeR_2Z4DgtMlD2mp1LJUiowK-KLBbUdfNLBA>
    <xmx:f_ivYu_qaCpqDDcAaDfw6nDqewJ3ySpfNU3Jidzqd2nFv1sf-kBq6A>
    <xmx:f_ivYnAfpOyBvVJsRtE69sAM_nTI4RMx63pSttWsSYvy_c20aeCzqw>
Feedback-ID: i426947f3:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 20 Jun 2022 00:33:01 -0400 (EDT)
From:   Mathew McBride <matt@traverse.com.au>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>,
        Li Yang <leoyang.li@nxp.com>,
        linux-arm-kernel@lists.infradead.org
Cc:     Mathew McBride <matt@traverse.com.au>, stable@vger.kernel.org
Subject: [PATCH] soc: fsl: select FSL_GUTS driver for DPIO
Date:   Mon, 20 Jun 2022 04:32:43 +0000
Message-Id: <20220620043243.32235-1-matt@traverse.com.au>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The soc/fsl/dpio driver will perform a soc_device_match()
to determine the optimal cache settings for a given CPU core.

If FSL_GUTS is not enabled, this search will fail and
the driver will not configure cache stashing for the given
DPIO, and a string of "unknown SoC" messages will appear:

fsl_mc_dpio dpio.7: unknown SoC version
fsl_mc_dpio dpio.6: unknown SoC version
fsl_mc_dpio dpio.5: unknown SoC version

Signed-off-by: Mathew McBride <matt@traverse.com.au>
Fixes: 51da14e96e9b ("soc: fsl: dpio: configure cache stashing destination")
Cc: stable@vger.kernel.org
---
 drivers/soc/fsl/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/soc/fsl/Kconfig b/drivers/soc/fsl/Kconfig
index 07d52cafbb31..fcec6ed83d5e 100644
--- a/drivers/soc/fsl/Kconfig
+++ b/drivers/soc/fsl/Kconfig
@@ -24,6 +24,7 @@ config FSL_MC_DPIO
         tristate "QorIQ DPAA2 DPIO driver"
         depends on FSL_MC_BUS
         select SOC_BUS
+        select FSL_GUTS
         select DIMLIB
         help
 	  Driver for the DPAA2 DPIO object.  A DPIO provides queue and
-- 
2.30.1

