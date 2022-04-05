Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9B9D4F325F
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:57:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356356AbiDEKXj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 06:23:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235973AbiDEJbC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:31:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98CF122516;
        Tue,  5 Apr 2022 02:18:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2256E61645;
        Tue,  5 Apr 2022 09:18:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24BA8C385A3;
        Tue,  5 Apr 2022 09:18:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649150295;
        bh=WZ5lqIiERkhZAxCxhfRzo1GoFdYeuXgZNAeBjIF+Bag=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zygDkcHVZXC91C5rT9n10pkr6xnktd45bJR1PCj1BD4e0dbQ2kZN7sRhsp/OpgXl5
         WvqTiyjNnPbJcsjT6RhC/RevWaW6Y2JqldHNhE7thbuqgop//J1fSb0VHsUj+vn+Fy
         F9wm/fhj/itpTxwAiGHaAJdgyTigT5WTtUrWXShU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Menzel <pmenzel@molgen.mpg.de>,
        "Paul E. McKenney" <paulmck@kernel.org>
Subject: [PATCH 5.16 1008/1017] torture: Make torture.sh help message match reality
Date:   Tue,  5 Apr 2022 09:32:01 +0200
Message-Id: <20220405070424.120579418@linuxfoundation.org>
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

From: Paul E. McKenney <paulmck@kernel.org>

commit f233673cd32a048f2eed69e56b61174c33fb740b upstream.

This commit fixes a couple of typos: s/--doall/--do-all/ and
s/--doallmodconfig/--do-allmodconfig/.

[ paulmck: Add Fixes: supplied by Paul Menzel. ]

Fixes: a115a775a8d5 ("torture: Add "make allmodconfig" to torture.sh")
Reported-by: Paul Menzel <pmenzel@molgen.mpg.de>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/rcutorture/bin/torture.sh |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/rcutorture/bin/torture.sh
+++ b/tools/testing/selftests/rcutorture/bin/torture.sh
@@ -71,8 +71,8 @@ usage () {
 	echo "       --configs-rcutorture \"config-file list w/ repeat factor (3*TINY01)\""
 	echo "       --configs-locktorture \"config-file list w/ repeat factor (10*LOCK01)\""
 	echo "       --configs-scftorture \"config-file list w/ repeat factor (2*CFLIST)\""
-	echo "       --doall"
-	echo "       --doallmodconfig / --do-no-allmodconfig"
+	echo "       --do-all"
+	echo "       --do-allmodconfig / --do-no-allmodconfig"
 	echo "       --do-clocksourcewd / --do-no-clocksourcewd"
 	echo "       --do-kasan / --do-no-kasan"
 	echo "       --do-kcsan / --do-no-kcsan"


