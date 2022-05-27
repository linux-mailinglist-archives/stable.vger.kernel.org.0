Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EAF0535FE2
	for <lists+stable@lfdr.de>; Fri, 27 May 2022 13:43:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347644AbiE0Lmz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 May 2022 07:42:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351730AbiE0Ll7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 May 2022 07:41:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C8C4134E18;
        Fri, 27 May 2022 04:40:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4DB7061CE7;
        Fri, 27 May 2022 11:40:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DBC5C385A9;
        Fri, 27 May 2022 11:40:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653651618;
        bh=vPRTMm+R+ACCNBJFw2ofXGsoF9uzS5IfdoIy6DONyu0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X8hnzXCbgLukVJAkGO7mPwyTSZMC8Ib3QSjzVEne8tLBpX2NO/xLzTslBPwXWiAAD
         rlWzMdGYcoA/l1OUg07RUM7w9SouyLAW7Uv1M6TnQ30PGHV2Ran4zrL049L5DycXSd
         lMxyfyN/4sekuZzQzHuxIUsCqc8QztSOqPKlswrw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Schspa Shi <schspa@gmail.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 5.10 040/163] random: fix typo in comments
Date:   Fri, 27 May 2022 10:48:40 +0200
Message-Id: <20220527084833.652525342@linuxfoundation.org>
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

From: Schspa Shi <schspa@gmail.com>

commit c0a8a61e7abbf66729687ee63659ee25983fbb1e upstream.

s/or/for

Signed-off-by: Schspa Shi <schspa@gmail.com>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -101,7 +101,7 @@
  * ===============================
  *
  * There are four exported interfaces; two for use within the kernel,
- * and two or use from userspace.
+ * and two for use from userspace.
  *
  * Exported interfaces ---- userspace output
  * -----------------------------------------


