Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FB3C4FD6DC
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:25:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354403AbiDLHwa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:52:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359276AbiDLHmx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:42:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B35D55778;
        Tue, 12 Apr 2022 00:21:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2AD87B81B62;
        Tue, 12 Apr 2022 07:21:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75BC2C385A6;
        Tue, 12 Apr 2022 07:21:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649748093;
        bh=uBHQLW5+mpdPRS3b2MbTke8aMBxhdOu3bzGGetA00PQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ucQEU+cjfqvXWX/AMgXU4tezp0oeB9wEgwVODD2CnO/E1buQQu1JawAAiGRmqnZRg
         M6+SjvRFYtwc/zV/RQSzxfGxO/E34l/F2m4c1uwYLxItZAXHxVpIxV79REIvXcHLEi
         5oMcIaI4/+v6Z6vSLzakneTHkKT5hLdSiL4HzXZg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.17 316/343] Revert "selftests: net: Add tls config dependency for tls selftests"
Date:   Tue, 12 Apr 2022 08:32:14 +0200
Message-Id: <20220412063000.443238078@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062951.095765152@linuxfoundation.org>
References: <20220412062951.095765152@linuxfoundation.org>
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
@@ -43,6 +43,5 @@ CONFIG_NET_ACT_TUNNEL_KEY=m
 CONFIG_NET_ACT_MIRRED=m
 CONFIG_BAREUDP=m
 CONFIG_IPV6_IOAM6_LWTUNNEL=y
-CONFIG_TLS=m
 CONFIG_CRYPTO_SM4=y
 CONFIG_AMT=m


