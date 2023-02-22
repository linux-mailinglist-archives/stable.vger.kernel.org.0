Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D47A69F366
	for <lists+stable@lfdr.de>; Wed, 22 Feb 2023 12:23:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231194AbjBVLXo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Feb 2023 06:23:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231883AbjBVLXX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Feb 2023 06:23:23 -0500
Received: from mail-ed1-x54a.google.com (mail-ed1-x54a.google.com [IPv6:2a00:1450:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8C2F2FCEC
        for <stable@vger.kernel.org>; Wed, 22 Feb 2023 03:23:17 -0800 (PST)
Received: by mail-ed1-x54a.google.com with SMTP id c1-20020a0564021f8100b004acbe232c03so10019083edc.9
        for <stable@vger.kernel.org>; Wed, 22 Feb 2023 03:23:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=G8i/WK5WDKl3YN3JBPYbZztdEmPTBn08cMGx5hPood4=;
        b=cZnEB9p9Pz0nSB06JAlWcDXzyA6WyXGkDkRBoviUDXqZ357KJtFGr2jClJdpQe0jAG
         3jF/l5p+WO1yB/Hn9jLPLm8XBSj5MSMZRdHMijcyLHftg0jkHm+kMAgojNm9XvK2uBBW
         qxz+0Vb0J+c8xocZHuAt8Ep27kzRoZ/45k5tHLoAAEnYF6VSRiDhwQ0eLVBrNvA5ZkmV
         ejg/9nP3YuTLIiiGnRcr5CxAdTjgxgJMxIt44vO5XuQO5agwaOhxP2b//PUiWc4//Hwb
         H1OmxFX0m+LENEZ6/xqcV/eN4rMn5RSHwFFyICPvc3YOCuvRXjjNBAIZ/KpUzjx8jsS/
         atRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=G8i/WK5WDKl3YN3JBPYbZztdEmPTBn08cMGx5hPood4=;
        b=6oFLtYK18M5eaPiEet0diuzduqiSvFTVeoxHGDeqt5V/6b16bzEb+mcXVL9+w8Sm75
         jgqX8IughYf5LYvSrrn/sfRUFrEXzBXHYG4heuHMLL5uWNC1f1IZ0XyfVpTJlbfb8WZ+
         /b0VPxJlaMrErwXw0hZ6+ygRGhxJDpPiEGbPoGJBuRz0SJicU5GdjGNEQqrArwKhE3v9
         ASnNSjuc/8D4pFXnzXYci6KIs89XLm4iVANuqNMjf21WPpUqoJVNJVdGoNSETtBogxhU
         DqeSLcMFIz01khtWVH9uTwKLoxDMCvSejOOG8JBRy5BFtG4qQ8unvsGbUQSxOM82zl2T
         MWwA==
X-Gm-Message-State: AO0yUKXGzcl2WSzXQdyOXaLzTjTzABQsBvwDuS+0TVi4+te1uP5iaXE1
        k//WZ/9yR/uKe+bk+wKIbuQo/1rwx8kITw==
X-Google-Smtp-Source: AK7set8ltdrvzD4QI4G2la/6RrmITWIM2bXrDbWr+TR8suA5T1OZxb0XBPUAravS+cfn5N02JT0wV7D84N5w0g==
X-Received: from lux.lon.corp.google.com ([2a00:79e0:d:209:35a9:4800:d90c:e9bc])
 (user=maennich job=sendgmr) by 2002:a17:906:1c4b:b0:878:6488:915f with SMTP
 id l11-20020a1709061c4b00b008786488915fmr7746205ejg.10.1677064996450; Wed, 22
 Feb 2023 03:23:16 -0800 (PST)
Date:   Wed, 22 Feb 2023 11:21:45 +0000
In-Reply-To: <20220201205624.652313-1-nathan@kernel.org>
Message-Id: <20230222112141.278066-5-maennich@google.com>
Mime-Version: 1.0
References: <20220201205624.652313-1-nathan@kernel.org>
X-Mailer: git-send-email 2.39.2.637.g21b0678d19-goog
Subject: [PATCH 4/5] lib/Kconfig.debug: Use CONFIG_PAHOLE_VERSION
From:   maennich@google.com
To:     linux-kernel@vger.kernel.org
Cc:     kernel-team@android.com, maennich@google.com,
        stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Chancellor <nathan@kernel.org>

Now that CONFIG_PAHOLE_VERSION exists, use it in the definition of
CONFIG_PAHOLE_HAS_SPLIT_BTF and CONFIG_PAHOLE_HAS_BTF_TAG to reduce the
amount of duplication across the tree.

Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20220201205624.652313-5-nathan@kernel.org
Signed-off-by: Matthias Maennich <maennich@google.com>
---
 lib/Kconfig.debug | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index f71db0cc3bf1..0743c9567d7e 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -328,7 +328,15 @@ config DEBUG_INFO_BTF
 	  DWARF type info into equivalent deduplicated BTF type info.
 
 config PAHOLE_HAS_SPLIT_BTF
-	def_bool $(success, test `$(PAHOLE) --version | sed -E 's/v([0-9]+)\.([0-9]+)/\1\2/'` -ge "119")
+	def_bool PAHOLE_VERSION >= 119
+
+config PAHOLE_HAS_BTF_TAG
+	def_bool PAHOLE_VERSION >= 123
+	depends on CC_IS_CLANG
+	help
+	  Decide whether pahole emits btf_tag attributes (btf_type_tag and
+	  btf_decl_tag) or not. Currently only clang compiler implements
+	  these attributes, so make the config depend on CC_IS_CLANG.
 
 config DEBUG_INFO_BTF_MODULES
 	def_bool y
-- 
2.39.2.637.g21b0678d19-goog

