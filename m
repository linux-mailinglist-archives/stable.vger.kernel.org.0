Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFCE461517B
	for <lists+stable@lfdr.de>; Tue,  1 Nov 2022 19:23:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229475AbiKASX0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 14:23:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230041AbiKASXW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 14:23:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DA7B1E3DF;
        Tue,  1 Nov 2022 11:23:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3A2CE616F0;
        Tue,  1 Nov 2022 18:23:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C089FC433D6;
        Tue,  1 Nov 2022 18:23:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667326996;
        bh=m7rIazDdIra2h5oKfw3giGnpXbUWWKzDWF/O5OIiEZc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qw+GRGtArbHiRuJvnDVCbT3tEBaX2ne4kg8SygzBtVEuQzYisNMgVFp95K/a4c+pX
         ICTFNtLd6KKilg9P290aEW8FbqIn6FEaEu3yBFBR8pc3MyNHhWpALeIvTY0nLeL63k
         ZxriUyk5u4iQXY2nOKhk86SHKBcWcPrzf2VL+/vU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 5.4.222
Date:   Tue,  1 Nov 2022 19:24:01 +0100
Message-Id: <16673270146959@kroah.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <166732701420252@kroah.com>
References: <166732701420252@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Makefile b/Makefile
index 1f42636e9efa..6eb672843b68 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 5
 PATCHLEVEL = 4
-SUBLEVEL = 221
+SUBLEVEL = 222
 EXTRAVERSION =
 NAME = Kleptomaniac Octopus
 
diff --git a/include/linux/once.h b/include/linux/once.h
index bb58e1c3aa03..3a6671d961b9 100644
--- a/include/linux/once.h
+++ b/include/linux/once.h
@@ -64,7 +64,7 @@ void __do_once_slow_done(bool *done, struct static_key_true *once_key,
 #define DO_ONCE_SLOW(func, ...)						     \
 	({								     \
 		bool ___ret = false;					     \
-		static bool __section(".data.once") ___done = false;	     \
+		static bool __section(.data.once) ___done = false;	     \
 		static DEFINE_STATIC_KEY_TRUE(___once_key);		     \
 		if (static_branch_unlikely(&___once_key)) {		     \
 			___ret = __do_once_slow_start(&___done);	     \
