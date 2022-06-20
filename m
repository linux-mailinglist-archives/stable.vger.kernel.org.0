Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F425551CA5
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 15:50:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347215AbiFTNkW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 09:40:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347570AbiFTNiq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 09:38:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FBEC1EEFE;
        Mon, 20 Jun 2022 06:14:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 50100B81157;
        Mon, 20 Jun 2022 13:13:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84D95C3411B;
        Mon, 20 Jun 2022 13:13:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655730838;
        bh=klpurISaw5pY6ur/w4/peCtz8E3IvcmfK74Gy15f8FA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HBD6X72XCuWFB53HfBLOKQ9oW/r6PD6cZl96HctGpFUDFfBKV9eYWoNlNfGzeppGQ
         7AGjf3/h6diwf6I8SdvySoIBsY34xz8zWwmcpEPPX/xZZHYyKOUOD4JzGeNYdERCUd
         ofxAkYoDaFuP+baa+QskRCBC7eu3GOYK+vEBfrIM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yangtao Li <tiny.windzz@gmail.com>,
        Theodore Tso <tytso@mit.edu>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 5.4 020/240] random: fix typo in add_timer_randomness()
Date:   Mon, 20 Jun 2022 14:48:41 +0200
Message-Id: <20220620124738.396083964@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220620124737.799371052@linuxfoundation.org>
References: <20220620124737.799371052@linuxfoundation.org>
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

From: Yangtao Li <tiny.windzz@gmail.com>

commit 727d499a6f4f29b6abdb635032f5e53e5905aedb upstream.

s/entimate/estimate

Signed-off-by: Yangtao Li <tiny.windzz@gmail.com>
Link: https://lore.kernel.org/r/20190607182517.28266-4-tiny.windzz@gmail.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -1215,7 +1215,7 @@ static void add_timer_randomness(struct
 	/*
 	 * delta is now minimum absolute delta.
 	 * Round down by 1 bit on general principles,
-	 * and limit entropy entimate to 12 bits.
+	 * and limit entropy estimate to 12 bits.
 	 */
 	credit_entropy_bits(r, min_t(int, fls(delta>>1), 11));
 }


