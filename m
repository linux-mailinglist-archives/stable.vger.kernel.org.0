Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D770D4D337F
	for <lists+stable@lfdr.de>; Wed,  9 Mar 2022 17:22:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234576AbiCIQLH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Mar 2022 11:11:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235818AbiCIQJN (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Mar 2022 11:09:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1147414344D;
        Wed,  9 Mar 2022 08:06:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BEFA96176B;
        Wed,  9 Mar 2022 16:06:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C630FC340E8;
        Wed,  9 Mar 2022 16:06:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646841984;
        bh=dBM59trElM9mKdvh5X3TAf3lhidiLDUO/YzmBUoNg2U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0X5UgBToejyS+Ydrdk52vtEbRlBokluzIkTgOqljyDMKokOCM73rbebOQ82DzNieW
         okiMCdPOZxeX5aJLaI84hIA1pR7byBk7wunAzUp9PdGLpT+zBMpO4aOqjHNFE45Z9k
         oZdQX6uA3avTxzdLYQj0pRXYrxzoOGpXOhRyxz5I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Emmanuel Gil Peyrot <linkmauve@linkmauve.fr>,
        Nathan Chancellor <nathan@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.10 43/43] ARM: fix build error when BPF_SYSCALL is disabled
Date:   Wed,  9 Mar 2022 17:00:16 +0100
Message-Id: <20220309155900.485376999@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220309155859.239810747@linuxfoundation.org>
References: <20220309155859.239810747@linuxfoundation.org>
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
 


