Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6687535CDA
	for <lists+stable@lfdr.de>; Fri, 27 May 2022 11:09:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350441AbiE0JBp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 May 2022 05:01:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350746AbiE0JAh (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 May 2022 05:00:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 873347A458;
        Fri, 27 May 2022 01:56:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2F7A5B823DD;
        Fri, 27 May 2022 08:56:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 649DCC385B8;
        Fri, 27 May 2022 08:56:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653641816;
        bh=PF5dW0BQ6ZEXPKENREiD+1dZ4MloydHUooaD7N6X/5A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rA+zMPUnb9RqOXFAfx+ZCijb6p32ZxPJlKp1398KoUV7mD4iGRFh8j8lfQMrSrfZl
         1mpYlYPaNV2tYsdpW0Fxw/oGzJufs1gxFlNHVW5NKJjiysya+8tL5RBKka6AwioyXT
         IFyTmceGirvugxM52GpQC3T/irWn2dG0HP6d4Cfc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 5.10 014/163] MAINTAINERS: add git tree for random.c
Date:   Fri, 27 May 2022 10:48:14 +0200
Message-Id: <20220527084830.172550039@linuxfoundation.org>
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

commit 9bafaa9375cbf892033f188d8cb624ae328754b5 upstream.

This is handy not just for humans, but also so that the 0-day bot can
automatically test posted mailing list patches against the right tree.

Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14672,6 +14672,7 @@ F:	arch/mips/generic/board-ranchu.c
 RANDOM NUMBER DRIVER
 M:	"Theodore Ts'o" <tytso@mit.edu>
 M:	Jason A. Donenfeld <Jason@zx2c4.com>
+T:	git https://git.kernel.org/pub/scm/linux/kernel/git/crng/random.git
 S:	Maintained
 F:	drivers/char/random.c
 


