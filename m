Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 121D64D3357
	for <lists+stable@lfdr.de>; Wed,  9 Mar 2022 17:21:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231908AbiCIQM0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Mar 2022 11:12:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236231AbiCIQJn (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Mar 2022 11:09:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 842B913FAC4;
        Wed,  9 Mar 2022 08:08:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2262FB82220;
        Wed,  9 Mar 2022 16:08:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A925C340E8;
        Wed,  9 Mar 2022 16:08:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646842097;
        bh=dBM59trElM9mKdvh5X3TAf3lhidiLDUO/YzmBUoNg2U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=04Wny4uCXKCvKNc/figCzG7Y1dfHHc/TEZkJkZGcR5hnyiKWI+yaqM7AKK9QNyOAo
         hJWdOFF2sJmFns2Q9ZueD8ZKu90RVdq8dh3gZmhUycyI7UXu6rY2mMpK4Ukbj2hRnY
         vuzPfOQzTCk5C+Tl9eA+xyVHjT4kjOg1Ah2QI2R0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Emmanuel Gil Peyrot <linkmauve@linkmauve.fr>,
        Nathan Chancellor <nathan@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.15 41/43] ARM: fix build error when BPF_SYSCALL is disabled
Date:   Wed,  9 Mar 2022 17:00:25 +0100
Message-Id: <20220309155900.918816489@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220309155859.734715884@linuxfoundation.org>
References: <20220309155859.734715884@linuxfoundation.org>
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
 


