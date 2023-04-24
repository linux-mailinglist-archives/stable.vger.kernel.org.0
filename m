Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C67DA6ECA5A
	for <lists+stable@lfdr.de>; Mon, 24 Apr 2023 12:32:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231303AbjDXKcf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Apr 2023 06:32:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231203AbjDXKcZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Apr 2023 06:32:25 -0400
Received: from wout3-smtp.messagingengine.com (wout3-smtp.messagingengine.com [64.147.123.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BD21D8;
        Mon, 24 Apr 2023 03:32:24 -0700 (PDT)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 402C8320092D;
        Mon, 24 Apr 2023 06:32:23 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Mon, 24 Apr 2023 06:32:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=flygoat.com; h=
        cc:cc:content-transfer-encoding:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to; s=fm1; t=1682332342; x=
        1682418742; bh=lLDvZL8csOGSnpmvsIuBINdBPRus+0iDvwakrSAe4s0=; b=R
        G9yQO+veX+ZJzhvVc5RsIsy2dPd4TYACsDA3gVAW1cNEVlBMPkw2j25DScACpnPe
        LZ6pAMP7LwHOHwFWi8ex8PmunC0oZ2WPF6qmqBGlI/Qeu3xeOKMy6HxY6GiYrSMq
        C4bhwFohTdySjgFkrC6ttuKtCnru1If8FAj+PwZNaLEC/WmwWiy27yksj+R9g0k7
        XMiMUEqZjyMJepDa7RxZCqaJrP2JVUqO8r16T9osZHWoohozFchq4wxPsIKZ9ltF
        bNtVs59w5LxQ6OZvaQSYzPqsRIgk+UJO0MwY9k78bwcgGza3WnlY+XoIJeKO9BG5
        dr/mI/fjl3bnsl6XBlddA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding
        :content-type:date:date:feedback-id:feedback-id:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1682332342; x=
        1682418742; bh=lLDvZL8csOGSnpmvsIuBINdBPRus+0iDvwakrSAe4s0=; b=X
        RhrL777BPNP9IsnUlKPzY2GA7wj2i5n3pWJ/SglHFnxb/7iGm1gEJlOkJz5ZXdCR
        TrDaEPF0u/cDxxPGdoyuixKFXA5LzyCJJxlTShp3FeHQPlzyifm6XvbBZ0cwfk0I
        wQeMVjQ8RncEflhsan7QCTNGofISMFrGm9sYmTBAZiKqsoVDij7ajdHP95jUnzce
        wRHD7g8OXI1yclhT6P/R3u3fv2yWxm6f6ntXijPRnGPDSvtGxW323m4UW9x70xZu
        vLdnJk0NQpxfjC1Q+Sc8ODxzuzcir8aWr6HlLjTk4FzuJ5sluNZcp6SS9BpBvjPh
        ip5e5bo2kOdSPeiX+2mTw==
X-ME-Sender: <xms:tlpGZLTXrF6smFeKOPQu5oi6tTfOa1W6mgBVY0FoJ05_h6y0L34G1A>
    <xme:tlpGZMyrSdPcmnVklLwXTfrgW8c_FhoNohhsUlCdqTaokONzE3Zo7vg44sjHjHKAI
    ndHK_N3cRjZXBJIC7Q>
X-ME-Received: <xmr:tlpGZA3GJ2bw6TvXwZ-Fw97ljfeAXfNFiXKS_KFxY6YXX41x5jnrUKy-vepT>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrfedutddgvdelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvfevufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpeflihgrgihunhcujggrnhhguceojhhirgiguhhnrdihrghn
    ghesfhhlhihgohgrthdrtghomheqnecuggftrfgrthhtvghrnhepfeeludefheegvdeuvd
    dvgeekgfdvtdettdelieeihfegtedugeekhfdvhfejfedtnecuvehluhhsthgvrhfuihii
    vgeptdenucfrrghrrghmpehmrghilhhfrhhomhepjhhirgiguhhnrdihrghnghesfhhlhi
    hgohgrthdrtghomh
X-ME-Proxy: <xmx:tlpGZLBtvlm5cSwI1asvqxLHoZy09tBXaIB-bAH6YNJRkyKde8K0Kg>
    <xmx:tlpGZEiYJEf5pNn8KIHFZVU2ZyW2oKIsDpzmXpt58meJZDZltoULlA>
    <xmx:tlpGZPoirH7L1T-QNf75tZ8POIWVU-YusCLsSrH5a3yALTTdADSV2A>
    <xmx:tlpGZPWRj0ySyKFdu51k4WPTrccyefyOMOsjMOPZoc7-qlrGjSgZ5Q>
Feedback-ID: ifd894703:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 24 Apr 2023 06:32:21 -0400 (EDT)
From:   Jiaxun Yang <jiaxun.yang@flygoat.com>
To:     maz@kernel.org
Cc:     tsbogend@alpha.franken.de, fancer.lancer@gmail.com,
        tglx@linutronix.de, linux-mips@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jiaxun Yang <jiaxun.yang@flygoat.com>, stable@vger.kernel.org
Subject: [PATCH 1/2] irqchip/mips-gic: Don't touch vl_map if a local interrupt is not routable
Date:   Mon, 24 Apr 2023 11:31:55 +0100
Message-Id: <20230424103156.66753-2-jiaxun.yang@flygoat.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <20230424103156.66753-1-jiaxun.yang@flygoat.com>
References: <20230424103156.66753-1-jiaxun.yang@flygoat.com>
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

When a GIC local interrupt is not routable, it's vl_map will be used
to control some internal states for core (providing IPTI, IPPCI, IPFDC
input signal for core). Overriding it will interfere core's intetrupt
controller.

Do not touch vl_map if a local interrupt is not routable, we are not
going to remap it.

Before dd098a0e0319 (" irqchip/mips-gic: Get rid of the reliance on
irq_cpu_online()"), if a local interrupt is not routable, then it won't
be requested from GIC Local domain, and thus gic_all_vpes_irq_cpu_online
won't be called for that particular interrupt.

Fixes: dd098a0e0319 (" irqchip/mips-gic: Get rid of the reliance on irq_cpu_online()")
Cc: stable@vger.kernel.org
Signed-off-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
---
 drivers/irqchip/irq-mips-gic.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/irqchip/irq-mips-gic.c b/drivers/irqchip/irq-mips-gic.c
index 046c355e120b..b568d55ef7c5 100644
--- a/drivers/irqchip/irq-mips-gic.c
+++ b/drivers/irqchip/irq-mips-gic.c
@@ -399,6 +399,8 @@ static void gic_all_vpes_irq_cpu_online(void)
 		unsigned int intr = local_intrs[i];
 		struct gic_all_vpes_chip_data *cd;
 
+		if (!gic_local_irq_is_routable(intr))
+			continue;
 		cd = &gic_all_vpes_chip_data[intr];
 		write_gic_vl_map(mips_gic_vx_map_reg(intr), cd->map);
 		if (cd->mask)
-- 
2.34.1

