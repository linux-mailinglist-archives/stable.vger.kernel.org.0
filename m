Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66EC7535C9B
	for <lists+stable@lfdr.de>; Fri, 27 May 2022 11:08:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234186AbiE0JBl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 May 2022 05:01:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350703AbiE0JAd (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 May 2022 05:00:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 992DC6620D;
        Fri, 27 May 2022 01:56:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ECE7261B59;
        Fri, 27 May 2022 08:56:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 860FEC385B8;
        Fri, 27 May 2022 08:56:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653641805;
        bh=W4CJOHP+AxfGPQ8fWAw7JyuQdvQwzcuxVqloWC8/Yvw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vA4H/0CjZqLpVp22n01p1UCaKrOLGopRPS8+QOUFsVhAAgI9GPK95KQjIi5lKBbzw
         1dldjzSrIRb2IYdCmEXpFdVWYLw6pBXHpq92cpmsH0A0/u/fferKuYRyPbQGJcEUGq
         XNIgObMUCAs1Ri1Ls4ExybvoTvDB9A3kHe/2940c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Theodore Tso <tytso@mit.edu>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.10 013/163] MAINTAINERS: co-maintain random.c
Date:   Fri, 27 May 2022 10:48:13 +0200
Message-Id: <20220527084830.032185082@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220527084828.156494029@linuxfoundation.org>
References: <20220527084828.156494029@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Jason A. Donenfeld" <Jason@zx2c4.com>

commit 58e1100fdc5990b0cc0d4beaf2562a92e621ac7d upstream.

random.c is a bit understaffed, and folks want more prompt reviews. I've
got the crypto background and the interest to do these reviews, and have
authored parts of the file already.

Cc: Theodore Ts'o <tytso@mit.edu>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14671,6 +14671,7 @@ F:	arch/mips/generic/board-ranchu.c
 
 RANDOM NUMBER DRIVER
 M:	"Theodore Ts'o" <tytso@mit.edu>
+M:	Jason A. Donenfeld <Jason@zx2c4.com>
 S:	Maintained
 F:	drivers/char/random.c
 


