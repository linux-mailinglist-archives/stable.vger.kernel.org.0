Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B6555475BB
	for <lists+stable@lfdr.de>; Sat, 11 Jun 2022 16:46:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235772AbiFKOqN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jun 2022 10:46:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234115AbiFKOqM (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Jun 2022 10:46:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF0C42661;
        Sat, 11 Jun 2022 07:46:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 82F32B800C1;
        Sat, 11 Jun 2022 14:46:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B215C34116;
        Sat, 11 Jun 2022 14:46:08 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="GKm4MZzH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1654958766;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=L7Ir9n6o9S7q2H/XyT2arCftkq5gQdq8QjehweP60pg=;
        b=GKm4MZzH1XgmfZFV6ZKOcHwpRZm1Q8uuZDKEepOc0vTe6mVjKaRnpabeQ8mpKTVpFuBYga
        hbJ+LSOIxcIvz6BwOwJbLodhZyXuSLZL1uHrY9Z2W3TiB/GBGRGp2/yr5Bbgzxl8KWETD+
        1dW1XNluYH1P+2OlAeDu0AM2bHerE0Y=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 980785c3 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Sat, 11 Jun 2022 14:46:06 +0000 (UTC)
Date:   Sat, 11 Jun 2022 16:46:02 +0200
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     Christophe Leroy <christophe.leroy@csgroup.eu>
Cc:     "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH v2 1/3] powerpc/microwatt: wire up rng during setup_arch
Message-ID: <YqSqqq0zC7yDOQib@zx2c4.com>
References: <20220611100447.5066-1-Jason@zx2c4.com>
 <20220611100447.5066-2-Jason@zx2c4.com>
 <6432586f-9eb9-ac71-7934-c48da09a928e@csgroup.eu>
 <CAHmME9rBWcdZtJCQ1WZAPOJtnA6u4w0ub4s4M+UW60gMSNgWrQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAHmME9rBWcdZtJCQ1WZAPOJtnA6u4w0ub4s4M+UW60gMSNgWrQ@mail.gmail.com>
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi again,

On Sat, Jun 11, 2022 at 04:41:58PM +0200, Jason A. Donenfeld wrote:
> Hi Christophe,
> 
> On Sat, Jun 11, 2022 at 4:40 PM Christophe Leroy
> <christophe.leroy@csgroup.eu> wrote:
> > >
> > > +__init void microwatt_rng_init(void);
> >
> > This prototype should be declared in a header file, for instance asm/setup.h
> 
> Alright.

Actually, on second thought, I don't think this part is worth doing.
These are per-platform functions, not powerpc-wide.

Jason
