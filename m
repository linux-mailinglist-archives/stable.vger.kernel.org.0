Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 656FE4D3284
	for <lists+stable@lfdr.de>; Wed,  9 Mar 2022 17:04:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234238AbiCIQET (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Mar 2022 11:04:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234325AbiCIQD5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Mar 2022 11:03:57 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7911D5006C;
        Wed,  9 Mar 2022 08:02:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 096B3B82224;
        Wed,  9 Mar 2022 16:02:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 684CEC36AF5;
        Wed,  9 Mar 2022 16:02:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646841747;
        bh=dBM59trElM9mKdvh5X3TAf3lhidiLDUO/YzmBUoNg2U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dbi5EjQp9XjW9EsOdyCxBA9saCoTdwNU28ZnR7XIHP8XSEaI9LMhiL/wsPQaQd6br
         0c/wsv//hx5sh1Ldqeo9LzxWfxUGQsxWVxfpjBuhv6w/vuQmkRviuO7MYtTnK1kwZY
         hMrvBvCxA8NmCT0N0HXoCw2ckgXrpm/o0NdUBKY4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Emmanuel Gil Peyrot <linkmauve@linkmauve.fr>,
        Nathan Chancellor <nathan@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.14 18/18] ARM: fix build error when BPF_SYSCALL is disabled
Date:   Wed,  9 Mar 2022 16:59:48 +0100
Message-Id: <20220309155856.634676651@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220309155856.090281301@linuxfoundation.org>
References: <20220309155856.090281301@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Emmanuel Gil Peyrot <linkmauve@linkmauve.fr>

commit 330f4c53d3c2d8b11d86ec03a964b86dc81452f5 upstream.

It was missing a semicolon.

Signed-off-by: Emmanuel Gil Peyrot <linkmauve@linkmauve.fr>
Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Fixes: 25875aa71dfe ("ARM: include unprivileged BPF status in Spectre V2 reporting").
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/kernel/spectre.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm/kernel/spectre.c
+++ b/arch/arm/kernel/spectre.c
@@ -10,7 +10,7 @@ static bool _unprivileged_ebpf_enabled(v
 #ifdef CONFIG_BPF_SYSCALL
 	return !sysctl_unprivileged_bpf_disabled;
 #else
-	return false
+	return false;
 #endif
 }
 


