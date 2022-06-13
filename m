Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 300BA548A4A
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:07:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381137AbiFMOHz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 10:07:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382027AbiFMOFE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 10:05:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6D3092D24;
        Mon, 13 Jun 2022 04:40:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B997F612E9;
        Mon, 13 Jun 2022 11:40:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDCB8C341C0;
        Mon, 13 Jun 2022 11:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655120410;
        bh=ZbH9pa4GVZl8chzqpxZ9ElpY38vkVGcomBwO80YJbxU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d/CL7FiNJd39RYhzf5mJHIuHJF0AfjJ2ENSi7kkNQtp3gxhRg/E8iSLT9V66jdAX7
         SaYuOD6JBp2yRGFk3FxtpRx2BHW4X/RYcTO+lsyQ2hCr5FOoYhO/Xu0bkTAID1+c10
         3LisdtDf8hkRninsHD8exdtAUM3Pta3R3gJwuuaU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, SeongJae Park <sj@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 023/298] scripts/get_abi: Fix wrong script file name in the help message
Date:   Mon, 13 Jun 2022 12:08:37 +0200
Message-Id: <20220613094925.632616409@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094924.913340374@linuxfoundation.org>
References: <20220613094924.913340374@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: SeongJae Park <sj@kernel.org>

[ Upstream commit 5b5bfecaa333fb6a0cce1bfc4852a622dacfed1d ]

The help message of 'get_abi.pl' is mistakenly saying it's
'abi_book.pl'.  This commit fixes the wrong name in the help message.

Fixes: bbc249f2b859 ("scripts: add an script to parse the ABI files")
Signed-off-by: SeongJae Park <sj@kernel.org>
Link: https://lore.kernel.org/r/20220419121636.290407-1-sj@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/get_abi.pl | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/scripts/get_abi.pl b/scripts/get_abi.pl
index 6212f58b69c6..0cf501285204 100755
--- a/scripts/get_abi.pl
+++ b/scripts/get_abi.pl
@@ -980,11 +980,11 @@ __END__
 
 =head1 NAME
 
-abi_book.pl - parse the Linux ABI files and produce a ReST book.
+get_abi.pl - parse the Linux ABI files and produce a ReST book.
 
 =head1 SYNOPSIS
 
-B<abi_book.pl> [--debug <level>] [--enable-lineno] [--man] [--help]
+B<get_abi.pl> [--debug <level>] [--enable-lineno] [--man] [--help]
 	       [--(no-)rst-source] [--dir=<dir>] [--show-hints]
 	       [--search-string <regex>]
 	       <COMAND> [<ARGUMENT>]
-- 
2.35.1



