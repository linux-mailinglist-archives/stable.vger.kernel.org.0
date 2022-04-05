Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 911FD4F2A39
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 12:53:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239151AbiDEIoh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:44:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241245AbiDEIc5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:32:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9575F60E0;
        Tue,  5 Apr 2022 01:30:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 422ABB81BC0;
        Tue,  5 Apr 2022 08:30:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E867C385A1;
        Tue,  5 Apr 2022 08:30:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649147423;
        bh=WZ5lqIiERkhZAxCxhfRzo1GoFdYeuXgZNAeBjIF+Bag=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zkkyx+fyNmsjI9r2GwsSWtY7nujbQB0GG3/4OfavFhCMQqwjxMW92yxEvvwS1VgSf
         8qG1ymuD82kxS2timy1bKp0KHYErqZu+yKwgkS5xN0I9bT6IJczM/+KlO08zxVN5bs
         rAA+2GEOkkpThVHKm5xC5NwIBg1X2AN8crZ5DHtE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Menzel <pmenzel@molgen.mpg.de>,
        "Paul E. McKenney" <paulmck@kernel.org>
Subject: [PATCH 5.17 1118/1126] torture: Make torture.sh help message match reality
Date:   Tue,  5 Apr 2022 09:31:05 +0200
Message-Id: <20220405070440.245635696@linuxfoundation.org>
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


