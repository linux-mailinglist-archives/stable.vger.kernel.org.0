Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA357549B82
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 20:29:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245591AbiFMS36 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 14:29:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245288AbiFMS3q (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 14:29:46 -0400
Received: from wout4-smtp.messagingengine.com (wout4-smtp.messagingengine.com [64.147.123.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1118BBF8AD
        for <stable@vger.kernel.org>; Mon, 13 Jun 2022 07:48:10 -0700 (PDT)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.west.internal (Postfix) with ESMTP id 917E33200959;
        Mon, 13 Jun 2022 10:48:07 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Mon, 13 Jun 2022 10:48:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cerno.tech; h=cc
        :cc:content-transfer-encoding:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm1; t=1655131687; x=1655218087; bh=Kj
        6x7vYD4tTzIdr59c0LLJaeSz8Fm4Y7cqHTjoIRr/o=; b=i14NujVyfJ1TAiHNc6
        V64+O6+JILo3XG6cYUDF8nrBLMGqFElt3l7CWJnfkSTwOrBdtbX9LZ+/kruMKe3v
        QTOLFdRg23vkRHuaGDj+JJVeibKf+CbanLSXplyXAAmwlw1dYcl+dGTs9c7PK2Qs
        u2sHfHjtrDgjvW9/6t1K62NMxbYudIAWUy+GX2FV2sXWcjgb1La/dUxvWtwduum4
        +m22d6xxo9wucYoIKna6r4uqA6HF+L8aCi4KT58tVkwTHlQ++yp1CoGCvE1T8VOH
        aOO5wYIkH4L9zUSiJPEseuWGballHJDgFnkfIZqdD/RLSscHqMbRMFa93ee1Eggn
        Ghsw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm2; t=1655131687; x=1655218087; bh=Kj6x7vYD4tTzI
        dr59c0LLJaeSz8Fm4Y7cqHTjoIRr/o=; b=hoOWY+noCY57ZmSi9onKLHksZcwlQ
        oM3PlyS/QSSuEXdJ+PKFsLWDz/g3XdOo3UO4C3/e1wN5IwZZ9+34SHtSRBhCi/Z/
        AUMU+OtRfJu3mXYGsD/0dCY1ZA31QoajaDiLe3arGpZhpSbuB2bSRiBHTRy6n90P
        LV7KCAPUio0h57FQ6rC/FojAeuF+mQR/mMlacB7meL4uzGzRkjepKAoeODt1T7cU
        PCL8MjuxbnDMHUlhufbqxe/3ObzQuXc2UasWRDzW4q57brpldwpVDsszQWKpPwgL
        GTgP2tCwW5mWew2KFkctTkGapza1oTclKaAHLEhgXvdolBS0BBCi8Ev+Q==
X-ME-Sender: <xms:Jk6nYl2HTjM8Y7U1LLgt9aYScSyhHBRNRGjWbaeZGzVmYtI6k7QJnQ>
    <xme:Jk6nYsFMvx2LX6Ci110_QpMjuo24zcysdb6DHOLdCvyDfHcVG1YkAQfTDGWzegsJt
    UJO8lmYBjOQNMWMxbI>
X-ME-Received: <xmr:Jk6nYl5staDNnidVHMWmReoY8cIrx-Ul6ttKXuFmZ_aXE5J2x99Fgt-stYEwaonOMOQ4J-vMZ2wbp-tthWbj55GrV8zFyy7cNpYAL0w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedruddujedgjeelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhephffvvefufffkofgjfhgggfestdekredtredttdenucfhrhhomhepofgrgihi
    mhgvucftihhprghrugcuoehmrgigihhmvgestggvrhhnohdrthgvtghhqeenucggtffrrg
    htthgvrhhnpeelkeefteduhfekjeeihfetudfguedvveekkeetteekhfekhfdtlefgfedu
    vdejhfenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hmrgigihhmvgestggvrhhnohdrthgvtghh
X-ME-Proxy: <xmx:Jk6nYi0EJxyY2j377ySfgkyUeDun8_l4n82DULMqWejFZatbbqt_lg>
    <xmx:Jk6nYoH5HCa81qwdityuJF2o0zStTVqBDeJQwshmTLYOl9UqeaxHbA>
    <xmx:Jk6nYj--UqT3e9P_SjKXniyBV14FaxXDVxstc0OQFmLfDOybPi71NQ>
    <xmx:J06nYt59kIUkzmwqclLvDmMvY4xyKV3vaTGt1hZIGlhYnPBlepZfxg>
Feedback-ID: i8771445c:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 13 Jun 2022 10:48:06 -0400 (EDT)
From:   Maxime Ripard <maxime@cerno.tech>
To:     Daniel Vetter <daniel.vetter@intel.com>,
        David Airlie <airlied@linux.ie>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Maxime Ripard <maxime@cerno.tech>
Cc:     dri-devel@lists.freedesktop.org,
        Dave Stevenson <dave.stevenson@raspberrypi.com>,
        stable@vger.kernel.org
Subject: [PATCH 01/33] drm/vc4: drv: Adopt the dma configuration from the HVS or V3D component
Date:   Mon, 13 Jun 2022 16:47:28 +0200
Message-Id: <20220613144800.326124-2-maxime@cerno.tech>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613144800.326124-1-maxime@cerno.tech>
References: <20220613144800.326124-1-maxime@cerno.tech>
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

From: Dave Stevenson <dave.stevenson@raspberrypi.com>

vc4_drv isn't necessarily under the /soc node in DT as it is a
virtual device, but it is the one that does the allocations.
The DMA addresses are consumed by primarily the HVS or V3D, and
those require VideoCore cache alias address mapping, and so will be
under /soc.

During probe find the a suitable device node for HVS or V3D,
and adopt the DMA configuration of that node.

Cc: <stable@vger.kernel.org>
Signed-off-by: Dave Stevenson <dave.stevenson@raspberrypi.com>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
---
 drivers/gpu/drm/vc4/vc4_drv.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/drivers/gpu/drm/vc4/vc4_drv.c b/drivers/gpu/drm/vc4/vc4_drv.c
index 162bc18e7497..14a7d529144d 100644
--- a/drivers/gpu/drm/vc4/vc4_drv.c
+++ b/drivers/gpu/drm/vc4/vc4_drv.c
@@ -209,6 +209,15 @@ static void vc4_match_add_drivers(struct device *dev,
 	}
 }
 
+const struct of_device_id vc4_dma_range_matches[] = {
+	{ .compatible = "brcm,bcm2711-hvs" },
+	{ .compatible = "brcm,bcm2835-hvs" },
+	{ .compatible = "brcm,bcm2835-v3d" },
+	{ .compatible = "brcm,cygnus-v3d" },
+	{ .compatible = "brcm,vc4-v3d" },
+	{}
+};
+
 static int vc4_drm_bind(struct device *dev)
 {
 	struct platform_device *pdev = to_platform_device(dev);
@@ -227,6 +236,16 @@ static int vc4_drm_bind(struct device *dev)
 		vc4_drm_driver.driver_features &= ~DRIVER_RENDER;
 	of_node_put(node);
 
+	node = of_find_matching_node_and_match(NULL, vc4_dma_range_matches,
+					       NULL);
+	if (node) {
+		ret = of_dma_configure(dev, node, true);
+		of_node_put(node);
+
+		if (ret)
+			return ret;
+	}
+
 	vc4 = devm_drm_dev_alloc(dev, &vc4_drm_driver, struct vc4_dev, base);
 	if (IS_ERR(vc4))
 		return PTR_ERR(vc4);
-- 
2.36.1

