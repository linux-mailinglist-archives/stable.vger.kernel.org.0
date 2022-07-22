Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4B0E57DE05
	for <lists+stable@lfdr.de>; Fri, 22 Jul 2022 11:35:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236448AbiGVJ3u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jul 2022 05:29:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236625AbiGVJ3M (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 Jul 2022 05:29:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CE35CE53B;
        Fri, 22 Jul 2022 02:18:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DDEC56200B;
        Fri, 22 Jul 2022 09:18:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF539C341CE;
        Fri, 22 Jul 2022 09:18:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658481503;
        bh=GwFu9Ec6FpKukvQN6VgmC0CCvKNQGXSdJdQwXCpStSc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y5MQiEA3wgOJPD/yMTd0Oc5hz5uRwLgqAMC69w1NAzWm7zSN+ImWbozALFEADZmC2
         GJOOfHipdK0XSXlAgqcshDW/KkRp9aE80Mrw01rgvwI2pDXSwsfJ9MCTKEdulq3zn6
         GARuhFYR8Y1Zr+sSk6TjXI2ORG+XtRzPbTWlgzO8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kim Phillips <kim.phillips@amd.com>,
        Borislav Petkov <bp@suse.de>
Subject: [PATCH 5.15 87/89] x86/bugs: Remove apostrophe typo
Date:   Fri, 22 Jul 2022 11:12:01 +0200
Message-Id: <20220722091138.206004008@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220722091133.320803732@linuxfoundation.org>
References: <20220722091133.320803732@linuxfoundation.org>
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
@@ -1174,7 +1174,7 @@ spectre_v2_user_select_mitigation(void)
 	if (retbleed_mitigation == RETBLEED_MITIGATION_UNRET) {
 		if (mode != SPECTRE_V2_USER_STRICT &&
 		    mode != SPECTRE_V2_USER_STRICT_PREFERRED)
-			pr_info("Selecting STIBP always-on mode to complement retbleed mitigation'\n");
+			pr_info("Selecting STIBP always-on mode to complement retbleed mitigation\n");
 		mode = SPECTRE_V2_USER_STRICT_PREFERRED;
 	}
 


