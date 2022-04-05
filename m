Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EEAC4F3575
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 15:50:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245510AbiDEI4H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:56:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241132AbiDEIcv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:32:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C74B8B8E;
        Tue,  5 Apr 2022 01:28:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7BFBAB81BCE;
        Tue,  5 Apr 2022 08:28:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0B0DC385A2;
        Tue,  5 Apr 2022 08:28:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649147310;
        bh=vNZad3FPjoAjHReFNNmD0sSgxbCTGXb4aPBNRc7b06Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HYJ7dZC31tYrlYGfJhmdyUKDqDQMMZYnIY2Y8tBYaoxivIs31UAISA0+ObRPjGsL9
         yrWXNBNLw7/2BARoj/V17yapCJkgN18Uvm1gjt60N4tfyz58bDFLXUs4I0tP9HQQC0
         ermsBAh85zcAjG2fOdKdQWVBUlTCoY4X0loKXKqg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nemanja Rakovic <nemanja.rakovic@syrmia.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: [PATCH 5.17 1077/1126] mips: Enable KCSAN - take 2
Date:   Tue,  5 Apr 2022 09:30:24 +0200
Message-Id: <20220405070439.066740821@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
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

From: Nemanja Rakovic <nemanja.rakovic@syrmia.com>

commit d1ca45f93c3f95d1590d60b012cf8fcf6db633ee upstream.

Replaces KASAN_SANITIZE with KCSAN_SANITIZE in
boot/compressed/Makefile.

Fixes: e0a8b93efa23 mips: Enable KCSAN
Signed-off-by: Nemanja Rakovic <nemanja.rakovic@syrmia.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/mips/boot/compressed/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/mips/boot/compressed/Makefile
+++ b/arch/mips/boot/compressed/Makefile
@@ -38,7 +38,7 @@ KBUILD_AFLAGS := $(KBUILD_AFLAGS) -D__AS
 KCOV_INSTRUMENT		:= n
 GCOV_PROFILE := n
 UBSAN_SANITIZE := n
-KASAN_SANITIZE			:= n
+KCSAN_SANITIZE			:= n
 
 # decompressor objects (linked with vmlinuz)
 vmlinuzobjs-y := $(obj)/head.o $(obj)/decompress.o $(obj)/string.o $(obj)/bswapsi.o


