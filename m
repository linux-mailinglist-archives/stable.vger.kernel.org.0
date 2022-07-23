Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0602A57EE92
	for <lists+stable@lfdr.de>; Sat, 23 Jul 2022 12:13:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239383AbiGWKNF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 Jul 2022 06:13:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239386AbiGWKMq (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 23 Jul 2022 06:12:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1738D2C36;
        Sat, 23 Jul 2022 03:03:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D6B55B82B92;
        Sat, 23 Jul 2022 10:03:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2413BC341CA;
        Sat, 23 Jul 2022 10:03:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658570599;
        bh=GiZoy1kPgadu41SsnSu581+QtHXEg34TCVQwA8lX2S8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RwTPoO/scAItgQ7GgkCZH3OHnnKC/0RDhbbzra/16q3WThGHUKr1rJULSCsiQijT2
         vERV47y0ZF5NnCrhoAqyKzxMQWgq+iQRkvDw4mHXco1Z9GYYLXwSWrAjP2lk1AGjSE
         RytcJJiKFyDVMAR5VZ5Gixld61GQu64dkJFOAsmE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Borislav Petkov <bp@suse.de>
Subject: [PATCH 5.10 143/148] um: Add missing apply_returns()
Date:   Sat, 23 Jul 2022 11:55:55 +0200
Message-Id: <20220723095304.427523891@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220723095224.302504400@linuxfoundation.org>
References: <20220723095224.302504400@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

commit 564d998106397394b6aad260f219b882b3347e62 upstream.

Implement apply_returns() stub for UM, just like all the other patching
routines.

Fixes: 15e67227c49a ("x86: Undo return-thunk damage")
Reported-by: Randy Dunlap <rdunlap@infradead.org)
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Link: https://lore.kernel.org/r/Ys%2Ft45l%2FgarIrD0u@worktop.programming.kicks-ass.net
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/um/kernel/um_arch.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/arch/um/kernel/um_arch.c
+++ b/arch/um/kernel/um_arch.c
@@ -362,6 +362,10 @@ void apply_retpolines(s32 *start, s32 *e
 {
 }
 
+void apply_returns(s32 *start, s32 *end)
+{
+}
+
 void apply_alternatives(struct alt_instr *start, struct alt_instr *end)
 {
 }


