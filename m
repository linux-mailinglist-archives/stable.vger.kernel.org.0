Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A9C55FDD45
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 17:37:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229665AbiJMPhI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Oct 2022 11:37:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229583AbiJMPhH (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Oct 2022 11:37:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5F05C06AE
        for <stable@vger.kernel.org>; Thu, 13 Oct 2022 08:37:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5393EB80DFB
        for <stable@vger.kernel.org>; Thu, 13 Oct 2022 15:37:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC309C433C1;
        Thu, 13 Oct 2022 15:37:03 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="Xfbh5Byz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1665675422;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=FVirAjK2n+DHDhYn4YJj/h/eOL2TZ4ZFj/eW4BEknSU=;
        b=Xfbh5Byz3MTTwcgoCIXF1WXQQYtLCJgjZZ4+5LNAOicmzAqCIVV/Rj+KT/hEHUMUAFnn8X
        sp6Mgt9LNPgJF2LQz2/mEeoB4ZhTsoL0u78gtZuclZsZslRc3CUST8YwK0CnvKlgq6N5ag
        X5J776zQ85r2dO7x8Zu1DCRjw3H8RhE=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 2059b608 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Thu, 13 Oct 2022 15:37:02 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     stable@vger.kernel.org, gregkh@linuxfoundation.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH stable 0/3] recent failed backports for the rng
Date:   Thu, 13 Oct 2022 09:36:51 -0600
Message-Id: <20221013153654.1397691-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

You just sent me an automated email about these failing, so here they
are backported. 

Jason

Jason A. Donenfeld (3):
  random: restore O_NONBLOCK support
  random: avoid reading two cache lines on irq randomness
  random: use expired timer rather than wq for mixing fast pool

 drivers/char/mem.c    |  4 ++--
 drivers/char/random.c | 23 ++++++++++++++++-------
 2 files changed, 18 insertions(+), 9 deletions(-)

-- 
2.37.3

