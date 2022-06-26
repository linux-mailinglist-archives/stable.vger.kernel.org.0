Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6390055ADCE
	for <lists+stable@lfdr.de>; Sun, 26 Jun 2022 02:41:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233691AbiFZA25 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 Jun 2022 20:28:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233605AbiFZA24 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 25 Jun 2022 20:28:56 -0400
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B28AF13F0B;
        Sat, 25 Jun 2022 17:28:54 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4LVsD22mHNz4xZB;
        Sun, 26 Jun 2022 10:28:50 +1000 (AEST)
From:   Michael Ellerman <patch-notifications@ellerman.id.au>
To:     Christophe Leroy <christophe.leroy@csgroup.eu>,
        stable <stable@vger.kernel.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        linuxppc-dev@lists.ozlabs.org,
        Michael Ellerman <mpe@ellerman.id.au>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20220621140849.127227-1-Jason@zx2c4.com>
References: <20220620124531.78075-1-Jason@zx2c4.com> <20220621140849.127227-1-Jason@zx2c4.com>
Subject: Re: [PATCH v5] powerpc/powernv: wire up rng during setup_arch
Message-Id: <165620330450.1934578.17474382204617879607.b4-ty@ellerman.id.au>
Date:   Sun, 26 Jun 2022 10:28:24 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 21 Jun 2022 16:08:49 +0200, Jason A. Donenfeld wrote:
> The platform's RNG must be available before random_init() in order to be
> useful for initial seeding, which in turn means that it needs to be
> called from setup_arch(), rather than from an init call. Fortunately,
> each platform already has a setup_arch function pointer, which means we
> can wire it up that way. Complicating things, however, is that POWER8
> systems need some per-cpu state and kmalloc, which isn't available at
> this stage. So we split things up into an early phase and a later
> opportunistic phase. This commit also removes some noisy log messages
> that don't add much.
> 
> [...]

Applied to powerpc/fixes.

[1/1] powerpc/powernv: wire up rng during setup_arch
      https://git.kernel.org/powerpc/c/f3eac426657d985b97c92fa5f7ae1d43f04721f3

cheers
