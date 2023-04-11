Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B4436DD927
	for <lists+stable@lfdr.de>; Tue, 11 Apr 2023 13:15:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229685AbjDKLPI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Apr 2023 07:15:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229904AbjDKLPE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Apr 2023 07:15:04 -0400
Received: from out5-smtp.messagingengine.com (out5-smtp.messagingengine.com [66.111.4.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60004448E;
        Tue, 11 Apr 2023 04:14:47 -0700 (PDT)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 752CE5C01E7;
        Tue, 11 Apr 2023 07:14:31 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Tue, 11 Apr 2023 07:14:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=flygoat.com; h=
        cc:cc:content-transfer-encoding:content-type:date:date:from:from
        :in-reply-to:message-id:mime-version:reply-to:sender:subject
        :subject:to:to; s=fm1; t=1681211671; x=1681298071; bh=U6Fxzg96jC
        MbXos8W2IcNTwOEcFKqCEbDJjjFmLV69Y=; b=cX7LghG5CZ3L4u3+Ecxxfl3AGJ
        FYuHKu3H+sVf1bujXNhIfOoiBeotyCypvK9lpOa9LyJw2S4KFRyDN9Nn1Zbj8EkQ
        rPfSPdJ3R6TgaZcNBpnDqhwkdCqPP4W1Zl8RPnifNtGzq0UZoZLJ+FkmaEf41qmy
        YKU7qsIGM5Al+1T/1tnZBcUQwkJH8wDhMT0Nmy2od+vR/A9eiB2q8uDmRETh95KO
        HObAzkD/rFHIlkJutzcIzjsYGL8qlLyZ1lnUsh4ApX6DS05Wz0alz5al5qNQ76SL
        qdOCSIaj+2uzVvCoUdtfsaWDmdbHKQKj2Ds/YochBOi5AoxcxVK3yIW4rpQA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding
        :content-type:date:date:feedback-id:feedback-id:from:from
        :in-reply-to:message-id:mime-version:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; t=1681211671; x=1681298071; bh=U6Fxzg96jCMbX
        os8W2IcNTwOEcFKqCEbDJjjFmLV69Y=; b=dPcZIN4sjLfCF6Xt5a4CXQKR7WHEX
        1pGS8iXTTKhNbNvHvaz5enOjG+JbA1Wvv5qNhgNJp7XMwMh2T2d1bYiuiBFgOTfe
        5yM1gjBDgov+mQugcnUaERLIgebfIqpXn1YQoeEnTglaj/+PIYkoUWoPhcWIJjsS
        FJeT4sQZQeqh2WLtw2Z1suGSjepk2f/e9LnLWElGUUwlSiFSmZH1OKn0RA4QHXsB
        7SSPm5hu4DPo+Xtpnv2kwPnMGE8bOsYfMyHp+4mAq+vgcIlVNcObkXfvDet3K9ue
        Q9Kr+kSxI/FjYT22tB1AGmhEkZN/TK+2AyjQN+0xAudLLcyXkvcmW6lkg==
X-ME-Sender: <xms:F0E1ZGH1rYcXjTDZmZi6Nc-PwKCmEdi38MauClB_sKEyvptuFDHm6Q>
    <xme:F0E1ZHW86Kplr3WOle_94loV57IXtXdj23YCc8yqxS7yjbCqMwahvh9cQ33n392ID
    zX46jwqnDgGHsCmk7U>
X-ME-Received: <xmr:F0E1ZAK0pQeqPFSH549wghRmx2VI5idTjLupMn7XqsVRVJ5c7NGhIBmCjy7G>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrvdekgedgfeejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvfevufffkffoggfgsedtkeertd
    ertddtnecuhfhrohhmpeflihgrgihunhcujggrnhhguceojhhirgiguhhnrdihrghnghes
    fhhlhihgohgrthdrtghomheqnecuggftrfgrthhtvghrnhepgfdtheehiedvgeduudduvd
    duleegleffgeekjedttdfhhfefleetheevvefftefgnecuffhomhgrihhnpehgihhthhhu
    sgdrtghomhenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhroh
    hmpehjihgrgihunhdrhigrnhhgsehflhihghhorghtrdgtohhm
X-ME-Proxy: <xmx:F0E1ZAHdAhSufrLtdviMj18Oo2T1bFBbVgfMVhX3NDBlwxGSz2EMgw>
    <xmx:F0E1ZMXD9u7Bv76HMYD09NoaJQexq4uFieK6--ePEHXi9qNVwqOrBA>
    <xmx:F0E1ZDP1dkNAIxl8tMuLimX0IIJYr2W-HjgM57WwRdrsWl9FKnCdSQ>
    <xmx:F0E1ZKyDa8EYrneCSRNBAHZZKgR3lIMM7_nn1XOw3eEMj6pDb27Tjw>
Feedback-ID: ifd894703:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 11 Apr 2023 07:14:30 -0400 (EDT)
From:   Jiaxun Yang <jiaxun.yang@flygoat.com>
To:     linux-mips@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, tsbogend@alpha.franken.de,
        and@gmx.com, Jiaxun Yang <jiaxun.yang@flygoat.com>,
        stable@vger.kernel.org
Subject: [PATCH] MIPS: fw: Allow firmware to pass a empty env
Date:   Tue, 11 Apr 2023 12:14:26 +0100
Message-Id: <20230411111426.55889-1-jiaxun.yang@flygoat.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.9 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

fw_getenv will use env entry to determine style of env,
however it is legal for firmware to just pass a empty list.

Check if first entry exist before running strchr to avoid
null pointer dereference.

Cc: stable@vger.kernel.org
Link: https://github.com/clbr/n64bootloader/issues/5
Signed-off-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
---
Note: Fixes tag is intentionally omitted for this patch, although
the booting issue only comes in 6.1, the logic issue is been since very start.
---
 arch/mips/fw/lib/cmdline.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/mips/fw/lib/cmdline.c b/arch/mips/fw/lib/cmdline.c
index f24cbb4a39b5..892765b742bb 100644
--- a/arch/mips/fw/lib/cmdline.c
+++ b/arch/mips/fw/lib/cmdline.c
@@ -53,7 +53,7 @@ char *fw_getenv(char *envname)
 {
 	char *result = NULL;
 
-	if (_fw_envp != NULL) {
+	if (_fw_envp != NULL && fw_envp(0) != NULL) {
 		/*
 		 * Return a pointer to the given environment variable.
 		 * YAMON uses "name", "value" pairs, while U-Boot uses
-- 
2.39.2 (Apple Git-143)

