Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A0FC521B2E
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 16:05:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244576AbiEJOJB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 10:09:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344174AbiEJOHk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 10:07:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2020B1FE1C6;
        Tue, 10 May 2022 06:41:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EE81D615C8;
        Tue, 10 May 2022 13:41:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E11A9C385C2;
        Tue, 10 May 2022 13:41:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652190113;
        bh=9CSoLroFbSTvPx0vay7I1wRnNOPAKHtc8NonX8gn7hQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pGOWAS1RvGwMy7rYvCztDhV+4zkQCgjPyXkdrVUE/m96C0E2Vod9sNrk7l+HE6Thi
         G/lCamInBdgmrlNW2T69UOab/G1ZzblDLiVS5D0cKot6pHehriwe8P3gxMWzT103Em
         PYi3zic45Opp1M6b7GQlMOv5l9RcD+tTPoushoa8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Carlos Llamas <cmllamas@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 5.17 092/140] selftests/net: so_txtime: usage(): fix documentation of default clock
Date:   Tue, 10 May 2022 15:08:02 +0200
Message-Id: <20220510130744.239554837@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510130741.600270947@linuxfoundation.org>
References: <20220510130741.600270947@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Kleine-Budde <mkl@pengutronix.de>

commit f5c2174a3775491e890ce285df52f5715fbef875 upstream.

The program uses CLOCK_TAI as default clock since it was added to the
Linux repo. In commit:
| 040806343bb4 ("selftests/net: so_txtime multi-host support")
a help text stating the wrong default clock was added.

This patch fixes the help text.

Fixes: 040806343bb4 ("selftests/net: so_txtime multi-host support")
Cc: Carlos Llamas <cmllamas@google.com>
Cc: Willem de Bruijn <willemb@google.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Acked-by: Willem de Bruijn <willemb@google.com>
Reviewed-by: Carlos Llamas <cmllamas@google.com>
Link: https://lore.kernel.org/r/20220502094638.1921702-3-mkl@pengutronix.de
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/so_txtime.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/net/so_txtime.c
+++ b/tools/testing/selftests/net/so_txtime.c
@@ -421,7 +421,7 @@ static void usage(const char *progname)
 			"Options:\n"
 			"  -4            only IPv4\n"
 			"  -6            only IPv6\n"
-			"  -c <clock>    monotonic (default) or tai\n"
+			"  -c <clock>    monotonic or tai (default)\n"
 			"  -D <addr>     destination IP address (server)\n"
 			"  -S <addr>     source IP address (client)\n"
 			"  -r            run rx mode\n"


