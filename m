Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 250334F2B2A
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 13:09:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355576AbiDEKUh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 06:20:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346499AbiDEJXy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:23:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 560AADAFEF;
        Tue,  5 Apr 2022 02:13:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AB611B81C19;
        Tue,  5 Apr 2022 09:13:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05EBBC385A3;
        Tue,  5 Apr 2022 09:13:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649150022;
        bh=ordbT1ol/NytMCy2eDm57yDhNZz58uR1lbLYcHMG7BA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Aw4VdKdnC7VhVF5uBurfFp6MOliTWsq2Arw7lmDzI5EJIrVpck4e7q+CNroYc/0Dz
         AfvhfLV4XdJ23KQ9uZ3DDqghWFdCpL1aRGoiLI4ZApIkAk1y00kqIUKkXctvltWg3A
         vyxOFEk3Q2nnIJ7YTkpZOPdef0ZwInW1fdvzhfjM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Masahiro Yamada <masahiroy@kernel.org>,
        Mark Brown <broonie@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>
Subject: [PATCH 5.16 0927/1017] modpost: restore the warning message for missing symbol versions
Date:   Tue,  5 Apr 2022 09:30:40 +0200
Message-Id: <20220405070421.732807647@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
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

From: Masahiro Yamada <masahiroy@kernel.org>

commit bf5c0c2231bcab677e5cdfb7f73e6c79f6d8c2d4 upstream.

This log message was accidentally chopped off.

I was wondering why this happened, but checking the ML log, Mark
precisely followed my suggestion [1].

I just used "..." because I was too lazy to type the sentence fully.
Sorry for the confusion.

[1]: https://lore.kernel.org/all/CAK7LNAR6bXXk9-ZzZYpTqzFqdYbQsZHmiWspu27rtsFxvfRuVA@mail.gmail.com/

Fixes: 4a6795933a89 ("kbuild: modpost: Explicitly warn about unprototyped symbols")
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Acked-by: Mark Brown <broonie@kernel.org>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 scripts/mod/modpost.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -669,7 +669,7 @@ static void handle_modversion(const stru
 	unsigned int crc;
 
 	if (sym->st_shndx == SHN_UNDEF) {
-		warn("EXPORT symbol \"%s\" [%s%s] version ...\n"
+		warn("EXPORT symbol \"%s\" [%s%s] version generation failed, symbol will not be versioned.\n"
 		     "Is \"%s\" prototyped in <asm/asm-prototypes.h>?\n",
 		     symname, mod->name, mod->is_vmlinux ? "" : ".ko",
 		     symname);


