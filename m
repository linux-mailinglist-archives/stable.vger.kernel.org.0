Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25F9F59D637
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 11:11:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243360AbiHWI1X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 04:27:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243715AbiHWIZu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 04:25:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 268D871BFD;
        Tue, 23 Aug 2022 01:13:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D940461324;
        Tue, 23 Aug 2022 08:13:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E62D1C433B5;
        Tue, 23 Aug 2022 08:13:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661242425;
        bh=mWzM5TMrwuksgZqLJpC/Uv/KW7zVtYjKYra4nX9Cxis=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F8dH16AzI4tda/DmR4j2wj2BHkQYqBktDqpb3VXKG2kRza1BZ8HqPI2aVckhSWJ1W
         ldW+P6A1RPwzAbDebf2pHuzXd/sciP+lJscIWpIRACNSPneKqywo7TVFjWNDkvF00T
         oQn58uSynPLxyOcc/XhyRtCEEXSyweT6uoJYtGD4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 5.19 113/365] um: Add missing apply_returns()
Date:   Tue, 23 Aug 2022 10:00:14 +0200
Message-Id: <20220823080122.931986610@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080118.128342613@linuxfoundation.org>
References: <20220823080118.128342613@linuxfoundation.org>
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

From: Peter Zijlstra <peterz@infradead.org>

commit 637285e7f8d6da70a70c64e7895cb0672357a1f7 upstream.

Implement apply_returns() stub for UM, just like all the other patching
routines.

Fixes: 15e67227c49a ("x86: Undo return-thunk damage")
Reported-by: Randy Dunlap <rdunlap@infradead.org)
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/um/kernel/um_arch.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/arch/um/kernel/um_arch.c
+++ b/arch/um/kernel/um_arch.c
@@ -444,6 +444,10 @@ void apply_returns(s32 *start, s32 *end)
 {
 }
 
+void apply_returns(s32 *start, s32 *end)
+{
+}
+
 void apply_alternatives(struct alt_instr *start, struct alt_instr *end)
 {
 }


