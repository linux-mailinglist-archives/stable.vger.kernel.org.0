Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68CE7582239
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 10:34:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230406AbiG0IeZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 04:34:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230393AbiG0IeY (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 04:34:24 -0400
Received: from fornost.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 924DE45988;
        Wed, 27 Jul 2022 01:34:22 -0700 (PDT)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1oGcUd-004w0z-1m; Wed, 27 Jul 2022 18:34:12 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Wed, 27 Jul 2022 16:34:11 +0800
Date:   Wed, 27 Jul 2022 16:34:11 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Kalle Valo <kvalo@kernel.org>
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        linux-wireless@vger.kernel.org, stable@vger.kernel.org,
        Gregory Erwin <gregerwin256@gmail.com>,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@toke.dk>,
        "Eric W . Biederman" <ebiederm@xmission.com>, vschneid@redhat.com
Subject: Re: [PATCH RESEND v11] hwrng: core - let sleep be interrupted when
 unregistering hwrng
Message-ID: <YuD4g+ZPx7uEa999@gondor.apana.org.au>
References: <20220725215536.767961-1-Jason@zx2c4.com>
 <Yt+3ic4YYpAsUHMF@gondor.apana.org.au>
 <Yt+/HvfC+OYRVrr+@zx2c4.com>
 <87zggvoykr.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87zggvoykr.fsf@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 27, 2022 at 09:32:20AM +0300, Kalle Valo wrote:
>
> But just so that I understand correctly, after Herbert's patch no ath9k
> changes is needed anymore? That sounds great.

No a small change is still needed in ath9k to completely fix
the problem, basically a one-liner.  Either I could split that
out and give it to you once the core bits land in mainline, or
we could just do it in one patch with your ack.

The chances of conflicts are remote.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
