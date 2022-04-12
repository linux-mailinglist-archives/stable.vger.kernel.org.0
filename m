Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C981A4FD8F3
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:38:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351566AbiDLHUm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:20:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351779AbiDLHM4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:12:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4C7ABFA;
        Mon, 11 Apr 2022 23:52:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5109961472;
        Tue, 12 Apr 2022 06:52:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68025C385A1;
        Tue, 12 Apr 2022 06:52:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649746347;
        bh=UBKb1sZQqPKobZ0hpdVcRYe0cV7/W6X1LyH5t1+esJc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QL20hE4+USYC86pBYCNqxlMV4AuJqpTTnDlWGVD/XcAR82ogB9kjwjEPJNa9/vPtH
         XIgMcKXbQXbJ6XA8dL4qEm4qfihwGLqCxzrGCVCcqqWM8WDTvrXc5l9FquqneXaeTS
         zwqWTwC4IlhiraD47DgfcgF+vMFVs1E1+CBIVlZY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 250/277] Revert "selftests: net: Add tls config dependency for tls selftests"
Date:   Tue, 12 Apr 2022 08:30:53 +0200
Message-Id: <20220412062949.278284606@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062942.022903016@linuxfoundation.org>
References: <20220412062942.022903016@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>

commit 20695e9a9fd39103d1b0669470ae74030b7aa196 upstream.

This reverts commit d9142e1cf3bbdaf21337767114ecab26fe702d47.

The test is supposed to run cleanly with TLS is disabled,
to test compatibility with TCP behavior. I can't repro
the failure [1], the problem should be debugged rather
than papered over.

Link: https://lore.kernel.org/all/20220325161203.7000698c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com/ [1]
Fixes: d9142e1cf3bb ("selftests: net: Add tls config dependency for tls selftests")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Link: https://lore.kernel.org/r/20220328212904.2685395-1-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/config |    1 -
 1 file changed, 1 deletion(-)

--- a/tools/testing/selftests/net/config
+++ b/tools/testing/selftests/net/config
@@ -43,5 +43,4 @@ CONFIG_NET_ACT_TUNNEL_KEY=m
 CONFIG_NET_ACT_MIRRED=m
 CONFIG_BAREUDP=m
 CONFIG_IPV6_IOAM6_LWTUNNEL=y
-CONFIG_TLS=m
 CONFIG_CRYPTO_SM4=y


