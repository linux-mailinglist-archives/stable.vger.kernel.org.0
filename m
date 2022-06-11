Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F1A9547322
	for <lists+stable@lfdr.de>; Sat, 11 Jun 2022 11:22:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229616AbiFKJWs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jun 2022 05:22:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229779AbiFKJWr (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Jun 2022 05:22:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CCF6427D1;
        Sat, 11 Jun 2022 02:22:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BD530B80E48;
        Sat, 11 Jun 2022 09:22:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C667C34116;
        Sat, 11 Jun 2022 09:22:42 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="ZCKpis6s"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1654939361;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+VJZNV6229HxkzVhPTFcAaMsHDNyC/F9ZlzY6G3c2Xw=;
        b=ZCKpis6sA9rSlL985IbDrqK6FXPPQgAnpKOPcVHzrfD6u9njc3lC+W1q9lcTBwmMPZm2ff
        wPgxBWItOmLZD0XDk4Ph9Kq3Pv2sqXF4tSuG1ce7h9dfh2ujIUTkJ2eC52nSnnNxn7AKuv
        au5klxC6pRGZ8UNKRf2PNF3/wKIAXbU=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 51139443 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Sat, 11 Jun 2022 09:22:41 +0000 (UTC)
Date:   Sat, 11 Jun 2022 11:22:39 +0200
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     Christophe Leroy <christophe.leroy@csgroup.eu>
Cc:     linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] powerpc/rng: wire up during setup_arch
Message-ID: <YqRe3wHSuM6dcsCU@zx2c4.com>
References: <20220611081114.449165-1-Jason@zx2c4.com>
 <956d2faa-4dae-fc75-2c03-387c77806f2b@csgroup.eu>
 <f6e5a9c4-f39d-749f-d124-884f11a8edfb@csgroup.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <f6e5a9c4-f39d-749f-d124-884f11a8edfb@csgroup.eu>
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Christophe,

On Sat, Jun 11, 2022 at 11:17:23AM +0200, Christophe Leroy wrote:
> Also, you copied stable. Should you add a Fixes: tag so that we know 
> what it fixes ?

I suppose the fixes tag would be whatever introduced those files in the
first place, so not all together useful. But if you want something, feel
free to append these when applying the commit:

Fixes: a4da0d50b2a0 ("powerpc: Implement arch_get_random_long/int() for powernv")
Fixes: a489043f4626 ("powerpc/pseries: Implement arch_get_random_long() based on H_RANDOM")
Fixes: c25769fddaec ("powerpc/microwatt: Add support for hardware random number generator")

Jason
