Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44774679DA6
	for <lists+stable@lfdr.de>; Tue, 24 Jan 2023 16:37:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234471AbjAXPhV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Jan 2023 10:37:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234172AbjAXPhV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Jan 2023 10:37:21 -0500
Received: from wout5-smtp.messagingengine.com (wout5-smtp.messagingengine.com [64.147.123.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A48E4B4B5;
        Tue, 24 Jan 2023 07:37:17 -0800 (PST)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id 7606032009CA;
        Tue, 24 Jan 2023 10:37:11 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Tue, 24 Jan 2023 10:37:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=squebb.ca; h=cc
        :cc:content-transfer-encoding:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm1; t=1674574631; x=1674661031; bh=Ln
        1VijabIxlGKIfGtw6pw4bgh9TVRm1qkrRmVBkiKpQ=; b=mp4ZXwkB1w5HZeJX1w
        FH/cZ2fcGKpaBIR2vPLNKaH747Y/Il5NtNd1nbfY8CQU/N8m1W4mtCo872PYbm9+
        q0IP5+/2J1wKRUTLGZjHuthl9lJ9slxIvUZzt9Mzd7Ait2wi9J0uyGa1ngIfxptE
        fTAgWbrtRqLqsBUh+lRlZAXvc0bDQZdvaXz7yuh16zldp2NbTTSP4nIiuEiOZQOH
        ciDWXzcLy0/52VMObBQd7B8fPJLpqS2N2H/kdPiiuM+1l3pjfuXMSzgDQeaCKRV3
        m+J5WgxFBHOjVubfmLOnkQt/EIoaktDr8oXv2Yom8sxVApFnyZWwuVRAvH64H7qq
        /igA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; t=1674574631; x=1674661031; bh=Ln1VijabIxlGK
        IfGtw6pw4bgh9TVRm1qkrRmVBkiKpQ=; b=DA/0D+ne8WwskxxcLtDsBzk1qF7Sj
        nuatnV0jh3lUYs0i3ydEt1isFMP+uIDMUMd9aPze+KGHYkArZJke/OrKv8Krc+o2
        bEaQitrjt8mPQkMlIODkXH01WHzM6ElW7+H6G0CO3/dSi4O8Dv/dzAThIbB1DM5x
        mv78zcdRplVsFeLikWbX8cq9KOc0QJSPn2qZe96ix0c3IuhiCEcp+ftsF8XfB3UU
        fFp7f+TjaCfetWXn8fBeZG8xVm3Dvt0Iv+Uy/bfQc2c17Y32a95ZASCVD9LIQkS7
        0Hso08uulLnCB2cF1b24IXJcCualb+IGZA2W9CumSbCXH298V56MtlblA==
X-ME-Sender: <xms:JvvPY2F-6Kln338wfaWtx2Rt-joGGqIkPEpawTfBF6AqK5geXfdaiw>
    <xme:JvvPY3UR6yB3TrPcdwSQra_uIWcDjPcB8WCMDcPDTx1foTWsD96539SEhThCQG956
    poZyE6u1l4wnCKUpoc>
X-ME-Received: <xmr:JvvPYwLlAbtZKuY-NLBM9ujx041pwyu-lfVFzI6AgMAp79HMCwv3TnH6X42GdxXliTV-K6W02mY1JlQDXHPhKElSGjILOZcslWJDE0rkxWEKakLH6FUVUxDioR7kjs21gLSG1IdAuA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedruddvtddgjeehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucgoteeftdduqddtudculdduhedmnecujfgurhephf
    fvvefufffkofgjfhgggfestdekredtredttdenucfhrhhomhepofgrrhhkucfrvggrrhhs
    ohhnuceomhhpvggrrhhsohhnqdhlvghnohhvohesshhquhgvsggsrdgtrgeqnecuggftrf
    grthhtvghrnhepvedtlefggefgjeettddvgfekhfeugfeutdekfeefudeuuddvieeutdel
    jedvhfdvnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiii
    gvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehmphgvrghrshhonhdqlhgvnhhovhho
    sehsqhhuvggssgdrtggr
X-ME-Proxy: <xmx:JvvPYwG6SXLGBV1ILWSMcorPrAGXIMhkIThfQZz-sjf7B2ZYIBV1qg>
    <xmx:JvvPY8XcsHl0fwRADSXHcgmIkDiDwnqzYxxI3E8g9uwu0KtSTKNciQ>
    <xmx:JvvPYzOaKZMVmX_TM0Pru9OpMGQaVabS55G2kciuHsJlhzNc7wUcyg>
    <xmx:J_vPY6zk4LXYebLxR105YGGZULQdiMYs0JyHeCKdgSOhzCRrp26s-g>
Feedback-ID: ibe194615:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 24 Jan 2023 10:37:10 -0500 (EST)
From:   Mark Pearson <mpearson-lenovo@squebb.ca>
To:     mpearson-lenovo@squebb.ca
Cc:     hdegoede@redhat.com, markgross@kernel.org,
        mario.limonciello@amd.com, platform-driver-x86@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH] platform/x86: thinkpad_acpi: Fix profile modes on Intel platforms
Date:   Tue, 24 Jan 2023 10:36:23 -0500
Message-Id: <20230124153623.145188-1-mpearson-lenovo@squebb.ca>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <mpearson-lenovo@squebb.ca>
References: <mpearson-lenovo@squebb.ca>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

My last commit to fix profile mode displays on AMD platforms caused
an issue on Intel platforms - sorry!

In it I was reading the current functional mode (MMC, PSC, AMT) from
the BIOS but didn't account for the fact that on some of our Intel
platforms I use a different API which returns just the profile and not
the functional mode.

This commit fixes it so that on Intel platforms it knows the functional
mode is always MMC.

I also fixed a potential problem that a platform may try to set the mode
for both MMC and PSC - which was incorrect.

Tested on X1 Carbon 9 (Intel) and Z13 (AMD).

Link: https://bugzilla.kernel.org/show_bug.cgi?id=216963
Fixes: fde5f74ccfc7 ("platform/x86: thinkpad_acpi: Fix profile mode display in AMT mode")

Signed-off-by: Mark Pearson <mpearson-lenovo@squebb.ca>
---
 drivers/platform/x86/thinkpad_acpi.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/platform/x86/thinkpad_acpi.c b/drivers/platform/x86/thinkpad_acpi.c
index a95946800ae9..6668d472df39 100644
--- a/drivers/platform/x86/thinkpad_acpi.c
+++ b/drivers/platform/x86/thinkpad_acpi.c
@@ -10496,8 +10496,7 @@ static int dytc_profile_set(struct platform_profile_handler *pprof,
 			if (err)
 				goto unlock;
 		}
-	}
-	if (dytc_capabilities & BIT(DYTC_FC_PSC)) {
+	} else if (dytc_capabilities & BIT(DYTC_FC_PSC)) {
 		err = dytc_command(DYTC_SET_COMMAND(DYTC_FUNCTION_PSC, perfmode, 1), &output);
 		if (err)
 			goto unlock;
@@ -10525,14 +10524,16 @@ static void dytc_profile_refresh(void)
 			err = dytc_command(DYTC_CMD_MMC_GET, &output);
 		else
 			err = dytc_cql_command(DYTC_CMD_GET, &output);
-	} else if (dytc_capabilities & BIT(DYTC_FC_PSC))
+		funcmode = DYTC_FUNCTION_MMC;
+	} else if (dytc_capabilities & BIT(DYTC_FC_PSC)) {
 		err = dytc_command(DYTC_CMD_GET, &output);
-
+		/*Check if we are PSC mode, or have AMT enabled */
+		funcmode = (output >> DYTC_GET_FUNCTION_BIT) & 0xF;
+	}
 	mutex_unlock(&dytc_mutex);
 	if (err)
 		return;
 
-	funcmode = (output >> DYTC_GET_FUNCTION_BIT) & 0xF;
 	perfmode = (output >> DYTC_GET_MODE_BIT) & 0xF;
 	convert_dytc_to_profile(funcmode, perfmode, &profile);
 	if (profile != dytc_current_profile) {
-- 
2.38.1

