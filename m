Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C46B95481C6
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 10:28:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239502AbiFMIGm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 04:06:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235330AbiFMIGQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 04:06:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04BB5193D5
        for <stable@vger.kernel.org>; Mon, 13 Jun 2022 01:06:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AB92FB80D8B
        for <stable@vger.kernel.org>; Mon, 13 Jun 2022 08:06:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2521C34114;
        Mon, 13 Jun 2022 08:06:12 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="iejZB2YK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1655107571;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=Wh2dLy/6R9YrPWI+zhjPk5XSRwil3DxvMu+ExE+R/g8=;
        b=iejZB2YKsKx/wLKzGYgCy9BL9Ugvq6inZY/OjKAoVSPUMr9mEazcW2p5roU3nUdh74euTW
        4tyIclMKH7swdtRsNp/3pTnxXn7HvxaSDEc2D8/NGK8QCZNkPms3pamvMdWtC/YRnbh29i
        dwAR4VJFBrZQxk+IEym2WG8XUA6QtP0=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 2ce24e32 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Mon, 13 Jun 2022 08:06:10 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     stable@vger.kernel.org, gregkh@linuxfoundation.org
Subject: [PATCH stable 5.18 5.17 5.15 5.10 0/3] rng stable patches from 5.19-rc2
Date:   Mon, 13 Jun 2022 10:05:58 +0200
Message-Id: <20220613080601.153153-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

These three patches from 5.19-rc2 failed to automatically apply. The
following series should work okay.

Note that these are already part of the 4.9, 4.14, 4.19, 5.4 backport I
did for later this week.

Jason

Jason A. Donenfeld (3):
  random: avoid checking crng_ready() twice in random_init()
  random: mark bootloader randomness code as __init
  random: account for arch randomness in bits

 drivers/char/random.c  | 15 +++++++--------
 include/linux/random.h |  2 +-
 2 files changed, 8 insertions(+), 9 deletions(-)

-- 
2.35.1

