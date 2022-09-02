Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 552635AB40A
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 16:49:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236952AbiIBOtV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 10:49:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237264AbiIBOst (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 10:48:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D793B4A4;
        Fri,  2 Sep 2022 07:10:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 35743B82AA5;
        Fri,  2 Sep 2022 12:34:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A252BC433B5;
        Fri,  2 Sep 2022 12:34:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662122069;
        bh=ngG15JejDqqcJ9SlXbwYiQ/bNv4YoNx9fC8TWrz6c3Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vmKG1FhpJKcIEeHXo1UP2m8abQwI2tqs0qKXLVuNL5MNY806AZU0ecoZWpIPaW74j
         QJACl700Hmc2vSOhooyu30tUKnon+gnxJp/W79rpeV7CbpXtgnoh4Zg4lliI8GSYuF
         0Kggt4tomIO9VLJIMy1QdQ02qlMie9W1ETrjLz40=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>,
        Florian Westphal <fw@strlen.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 64/73] netfilter: conntrack: NF_CONNTRACK_PROCFS should no longer default to y
Date:   Fri,  2 Sep 2022 14:19:28 +0200
Message-Id: <20220902121406.522493900@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220902121404.435662285@linuxfoundation.org>
References: <20220902121404.435662285@linuxfoundation.org>
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
index 92a747896f808..4f645d51c2573 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -133,7 +133,6 @@ config NF_CONNTRACK_ZONES
 
 config NF_CONNTRACK_PROCFS
 	bool "Supply CT list in procfs (OBSOLETE)"
-	default y
 	depends on PROC_FS
 	help
 	This option enables for the list of known conntrack entries
-- 
2.35.1



