Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42703542BEE
	for <lists+stable@lfdr.de>; Wed,  8 Jun 2022 11:49:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235288AbiFHJs5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jun 2022 05:48:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235351AbiFHJsn (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Jun 2022 05:48:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69C7E1EA84B;
        Wed,  8 Jun 2022 02:16:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C46856194A;
        Wed,  8 Jun 2022 09:16:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59954C34116;
        Wed,  8 Jun 2022 09:16:20 +0000 (UTC)
Date:   Wed, 8 Jun 2022 10:16:16 +0100
From:   Catalin Marinas <catalin.marinas@arm.com>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Phil Elwell <phil@raspberrypi.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Stephen Boyd <swboyd@chromium.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH v2] ARM: initialize jump labels before setup_machine_fdt()
Message-ID: <YqBo4LfSmL7A5eM1@arm.com>
References: <8cc7ebe4-442b-a24b-9bb0-fce6e0425ee6@raspberrypi.com>
 <CAHmME9pL=g7Gz9-QOHnTosLHAL9YSPsW+CnE=9=u3iTQaFzomg@mail.gmail.com>
 <0f6458d7-037a-fa4d-8387-7de833288fb9@raspberrypi.com>
 <CAHmME9rJif3ydZuFJcSjPxkGMofZkbu2PXcHBF23OWVgGQ4c+A@mail.gmail.com>
 <Yp8jQG30OWOG9C4j@arm.com>
 <CAHmME9p+FxQhTQYKWKkxkGiYxErP6NHuvSiFEat7ts1XgsM6YA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHmME9p+FxQhTQYKWKkxkGiYxErP6NHuvSiFEat7ts1XgsM6YA@mail.gmail.com>
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Jason,

On Wed, Jun 08, 2022 at 10:20:21AM +0200, Jason A. Donenfeld wrote:
> On Tue, Jun 7, 2022 at 12:07 PM Catalin Marinas <catalin.marinas@arm.com> wrote:
> > Do you plan to fix the crng_ready() static branch differently? If you
> > do, I'd like to revert the corresponding arm64 commit as well. It seems
> > to be harmless but I'd rather not keep it if no longer needed. So please
> > keep me updated whatever you decide.
> 
> Feel free to revert. I'm aborting this line of inquiry and will just
> fix it downstream in random.c.

Thanks for the update.

-- 
Catalin
