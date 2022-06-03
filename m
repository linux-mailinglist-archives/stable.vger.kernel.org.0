Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D257653D0A0
	for <lists+stable@lfdr.de>; Fri,  3 Jun 2022 20:11:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346476AbiFCSIW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jun 2022 14:08:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346752AbiFCSFJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jun 2022 14:05:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EFB4220EB;
        Fri,  3 Jun 2022 10:58:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1C19CB82419;
        Fri,  3 Jun 2022 17:57:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78F5AC385A9;
        Fri,  3 Jun 2022 17:57:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654279042;
        bh=MYuJiGbzxHLG00EokNeFrogd4ykMEO+gtN0yNPcLYSs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yrio+d8uWyhJGjb2gWLmScok5oQ1Ss7SEc5//lbdQWjHBPH/aRTc/iT+mIMHbeVLe
         kkzW826TV0P1JIp92rjBaV2YxY6G9zEEfACO0jMBeytyrg/osVgzUrfFLM/KmaGUbg
         bAAAegVkbMO7wHnQSBM2MPXN63d4LebO6ALElTDU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Akira Yokosawa <akiyks@gmail.com>,
        Luc Maranget <luc.maranget@inria.fr>,
        Jade Alglave <j.alglave@ucl.ac.uk>,
        "Paul E. McKenney" <paulmck@kernel.org>
Subject: [PATCH 5.18 33/67] tools/memory-model/README: Update klitmus7 compat table
Date:   Fri,  3 Jun 2022 19:43:34 +0200
Message-Id: <20220603173821.674327165@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220603173820.731531504@linuxfoundation.org>
References: <20220603173820.731531504@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Akira Yokosawa <akiyks@gmail.com>

commit 5b759db44195bb779828a188bad6b745c18dcd55 upstream.

EXPORT_SYMBOL of do_exec() was removed in v5.17.  Unfortunately,
kernel modules from klitmus7 7.56 have do_exec() at the end of
each kthread.

herdtools7 7.56.1 has addressed the issue.

Update the compatibility table accordingly.

Signed-off-by: Akira Yokosawa <akiyks@gmail.com>
Cc: Luc Maranget <luc.maranget@inria.fr>
Cc: Jade Alglave <j.alglave@ucl.ac.uk>
Cc: stable@vger.kernel.org # v5.17+
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/memory-model/README |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/tools/memory-model/README
+++ b/tools/memory-model/README
@@ -54,7 +54,8 @@ klitmus7 Compatibility Table
 	     -- 4.14  7.48 --
 	4.15 -- 4.19  7.49 --
 	4.20 -- 5.5   7.54 --
-	5.6  --       7.56 --
+	5.6  -- 5.16  7.56 --
+	5.17 --       7.56.1 --
 	============  ==========
 
 


