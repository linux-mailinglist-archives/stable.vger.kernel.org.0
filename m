Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD10F57EE8E
	for <lists+stable@lfdr.de>; Sat, 23 Jul 2022 12:12:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239452AbiGWKMw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 Jul 2022 06:12:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238965AbiGWKMg (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 23 Jul 2022 06:12:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3421D2C25;
        Sat, 23 Jul 2022 03:03:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DBB6CB82C1D;
        Sat, 23 Jul 2022 10:03:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 382B9C341C0;
        Sat, 23 Jul 2022 10:03:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658570596;
        bh=l+wIGaEFm0akZXyYx4NKM3m+CvuHaxklMUOikpE88dA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tNIXNqSbu9vFjwBHtCwMAnMuyx1w9DxZCgCAHyx5TJWT3Ps4V8zsyRSMrl/rUcg41
         JEz2jTRQM6xeKV4M5N1EocwqOCOtmyAidH73OkPDNi3KCVbNLeOFJKVfM9xRteTK3J
         aVAAS9nw7NMzHJ3qkMoTf3vrGYd5G9XkELM4Q25k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kim Phillips <kim.phillips@amd.com>,
        Borislav Petkov <bp@suse.de>
Subject: [PATCH 5.10 142/148] x86/bugs: Remove apostrophe typo
Date:   Sat, 23 Jul 2022 11:55:54 +0200
Message-Id: <20220723095304.149027452@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220723095224.302504400@linuxfoundation.org>
References: <20220723095224.302504400@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kim Phillips <kim.phillips@amd.com>

commit bcf163150cd37348a0cb59e95c916a83a9344b0e upstream.

Remove a superfluous ' in the mitigation string.

Fixes: e8ec1b6e08a2 ("x86/bugs: Enable STIBP for JMP2RET")
Signed-off-by: Kim Phillips <kim.phillips@amd.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/bugs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -1137,7 +1137,7 @@ spectre_v2_user_select_mitigation(void)
 	if (retbleed_mitigation == RETBLEED_MITIGATION_UNRET) {
 		if (mode != SPECTRE_V2_USER_STRICT &&
 		    mode != SPECTRE_V2_USER_STRICT_PREFERRED)
-			pr_info("Selecting STIBP always-on mode to complement retbleed mitigation'\n");
+			pr_info("Selecting STIBP always-on mode to complement retbleed mitigation\n");
 		mode = SPECTRE_V2_USER_STRICT_PREFERRED;
 	}
 


