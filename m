Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86F8956C077
	for <lists+stable@lfdr.de>; Fri,  8 Jul 2022 20:37:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238176AbiGHQjN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Jul 2022 12:39:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238087AbiGHQjN (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 Jul 2022 12:39:13 -0400
Received: from wout4-smtp.messagingengine.com (wout4-smtp.messagingengine.com [64.147.123.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD53822BFB;
        Fri,  8 Jul 2022 09:39:12 -0700 (PDT)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id 6DD903200998;
        Fri,  8 Jul 2022 12:39:11 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Fri, 08 Jul 2022 12:39:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        invisiblethingslab.com; h=cc:cc:content-transfer-encoding:date
        :date:from:from:in-reply-to:in-reply-to:message-id:mime-version
        :references:reply-to:sender:subject:subject:to:to; s=fm2; t=
        1657298350; x=1657384750; bh=U3b/H981CGu0C2wC9Ts2JrTkTC7Oo8KLBZW
        KsNQwvjA=; b=sNlj8utVGC0vIfiqJuCfPiXc7bDpbSIghAa2ibMfR0+3lmre7h/
        bkjqWOnQIq9JERNm8h2aCUPGpo1NBA7Cn+5LNQgOPFPKG2B4vtRLvWwX1feWkyxM
        kMuruV9kZBNSUsuZbyaUMSbzPRYx2GkYTfK8+6bkv530NGqimavpWfa8aSDho2MY
        4m/tLHN+bSxGFLXaNP6sPthDn5A/FI+3Fa5kBzioe7Ejmle3CQb97nhLvZ5qPxQa
        e7QbcHFXFQGBwremK4ujrTCe0NNpxUnEqahDXuBjN0cX6knW9IivvrTmnLDpzuBt
        +WO+BI8Zrs/u7T78QDjQx5Pt26T3v41qJ0w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; t=1657298350; x=1657384750; bh=U3b/H981CGu0C
        2wC9Ts2JrTkTC7Oo8KLBZWKsNQwvjA=; b=zXCBKYLSEAVEPR6sIJRpBCJLDFjZF
        Dzh8pqG/UgiCP9+pB2Yjcc6dtWFTkyMEjmAyZBbr25oSOfhaPQ4tUnDYJoAJ2SZ0
        oML6LbPCU/fGYAB8HIvO8KiR8HJP1S31NrZwBFgfBIkW8OEcPPT49AplrsHDXMVg
        Rnqvse2u//zm/rLCxlpHqUm1q7Y1YwcH3agBeQEdIio7x0Kk2V4S67XJ0GoN8ufU
        n+WZJoPDKD3nkeskhHMJ68BN2W6wRSPelEZMezf/MeD4QOI3zAKFTT8I/jhGSb62
        TrXPDQuKZOl5sRRag0ha9CfVDKAHxs415AaxuS16YPsP6Qt/4LY9XjOvw==
X-ME-Sender: <xms:rl3IYoR2ZJhwXKVuv9Qbkn_oFSlLxexHNp7-6gRJgkEzMX4d1jd_ng>
    <xme:rl3IYlwq5yZCGK2R8CxUb8g7XvTVjUjFvOdcGYEAA_WM51PTKji4ZPrghH0o4bC0-
    UccyMhYrAr-zVY>
X-ME-Received: <xmr:rl3IYl0JrAz4FEgbKT2FWKZ34ySKKmmRqoUm39fGSgs1A-JJ_fEUEYnV_zlDd1Dvmy0K73gVRKsM>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrudeijedguddtfecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpefhvfevufffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpeffvghm
    ihcuofgrrhhivgcuqfgsvghnohhurhcuoeguvghmihesihhnvhhishhisghlvghthhhinh
    hgshhlrggsrdgtohhmqeenucggtffrrghtthgvrhhnpeejffejgffgueegudevvdejkefg
    hefghffhffejteekleeufeffteffhfdtudehteenucevlhhushhtvghrufhiiigvpedtne
    curfgrrhgrmhepmhgrihhlfhhrohhmpeguvghmihesihhnvhhishhisghlvghthhhinhhg
    shhlrggsrdgtohhm
X-ME-Proxy: <xmx:rl3IYsD2SIL3tHUYPHswY1zrNczt1DToLUqP4Petk3JYeKwZh4_CsQ>
    <xmx:rl3IYhhUBTz6dcmT8WIiqqfnS6lksFvJZ4eQRR2NMJm_YUec_5_UKw>
    <xmx:rl3IYor62C5Z0MnAMTgt22P8FuCJJvyovaW9Mu6MFvzEXcW0fWWTyQ>
    <xmx:rl3IYsWErFmDf4COmpVqDg6DutndBpGT0LaMlm3juTfNBQYVJQwPZQ>
Feedback-ID: iac594737:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 8 Jul 2022 12:39:10 -0400 (EDT)
From:   Demi Marie Obenour <demi@invisiblethingslab.com>
To:     Juergen Gross <jgross@suse.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>,
        Demi Marie Obenour <demi@invisiblethingslab.com>
Cc:     Linux kernel regressions <regressions@lists.linux.dev>,
        stable@vger.kernel.org,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Xen developer discussion <xen-devel@lists.xenproject.org>
Subject: [PATCH 5.4] Ignore failure to unmap -1
Date:   Fri,  8 Jul 2022 12:37:47 -0400
Message-Id: <20220708163750.2005-4-demi@invisiblethingslab.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220708163750.2005-1-demi@invisiblethingslab.com>
References: <20220708163750.2005-1-demi@invisiblethingslab.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The error paths of gntdev_mmap() can call unmap_grant_pages() even
though not all of the pages have been successfully mapped.  This will
trigger the WARN_ON()s in __unmap_grant_pages_done().  The number of
warnings can be very large; I have observed thousands of lines of
warnings in the systemd journal.

Avoid this problem by only warning on unmapping failure if the handle
being unmapped is not -1.  The handle field of any page that was not
successfully mapped will be -1, so this catches all cases wherr
unmapping can legitimately fail.

Suggested-by: Juergen Gross <jgross@suse.com>
Cc: stable@vger.kernel.org
Signed-off-by: Demi Marie Obenour <demi@invisiblethingslab.com>
Fixes: ee25841221c1 ("xen/gntdev: Avoid blocking in unmap_grant_pages()")
---
 drivers/xen/gntdev.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/xen/gntdev.c b/drivers/xen/gntdev.c
index f464793477650e631c8928e85c1990c5964c2e94..bba849e5d8a7b4d54925b842fbe3c6792e0f0214 100644
--- a/drivers/xen/gntdev.c
+++ b/drivers/xen/gntdev.c
@@ -413,7 +413,8 @@ static void __unmap_grant_pages_done(int result,
 	unsigned int offset = data->unmap_ops - map->unmap_ops;
 
 	for (i = 0; i < data->count; i++) {
-		WARN_ON(map->unmap_ops[offset+i].status);
+		WARN_ON(map->unmap_ops[offset+i].status &&
+			map->unmap_ops[offset+i].handle != -1);
 		pr_debug("unmap handle=%d st=%d\n",
 			map->unmap_ops[offset+i].handle,
 			map->unmap_ops[offset+i].status);
-- 
Sincerely,
Demi Marie Obenour (she/her/hers)
Invisible Things Lab
