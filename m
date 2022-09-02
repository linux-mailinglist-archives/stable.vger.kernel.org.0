Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 963205AAE54
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 14:21:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236053AbiIBMVh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 08:21:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235509AbiIBMVS (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 08:21:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C2FA5F126;
        Fri,  2 Sep 2022 05:21:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F036F620C5;
        Fri,  2 Sep 2022 12:21:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7231C433C1;
        Fri,  2 Sep 2022 12:21:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662121276;
        bh=1joMZukgXquhe1JldLqq3I638jPaO+RsxpsC/BmR6iE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IIPsjh3BYMekfTaYmaItSjQlUncF7yCz9YMnxs64T4lCVvjY93BQksgGi1i5fK6eq
         u2i21RwGNC1mOl6e/nywG0GbfFOPmZLuM5JdAOhR+dtnmIV9DJ5zvYVXjbc+Byo00i
         Dj7i2IUa9OamtINOaqH86hR3f9fKh/O4iT2aVYmg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>,
        Florian Westphal <fw@strlen.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 29/31] netfilter: conntrack: NF_CONNTRACK_PROCFS should no longer default to y
Date:   Fri,  2 Sep 2022 14:18:55 +0200
Message-Id: <20220902121357.800280384@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220902121356.732130937@linuxfoundation.org>
References: <20220902121356.732130937@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Geert Uytterhoeven <geert@linux-m68k.org>

[ Upstream commit aa5762c34213aba7a72dc58e70601370805fa794 ]

NF_CONNTRACK_PROCFS was marked obsolete in commit 54b07dca68557b09
("netfilter: provide config option to disable ancient procfs parts") in
v3.3.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index dacd2d34a790b..f7cc20641b09f 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -96,7 +96,6 @@ config NF_CONNTRACK_ZONES
 
 config NF_CONNTRACK_PROCFS
 	bool "Supply CT list in procfs (OBSOLETE)"
-	default y
 	depends on PROC_FS
 	---help---
 	This option enables for the list of known conntrack entries
-- 
2.35.1



