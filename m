Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32263582257
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 10:44:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230366AbiG0IoZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 04:44:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230376AbiG0IoY (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 04:44:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96CFF45F4B;
        Wed, 27 Jul 2022 01:44:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 44731B81F8C;
        Wed, 27 Jul 2022 08:44:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 257FEC433D6;
        Wed, 27 Jul 2022 08:44:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658911460;
        bh=bdJKkYnYepQr7CphvYtd1kZ7MNz1d81VWOVjiEixHyA=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=i0kVXR1VFdHuaPF8XNnVD2HYQ2fFy1336/ZvV0/hlL/jTSkBhQab/z/xdlYK3BP2p
         4nUHURTb00r/b58/hjv4it1xkX3uRGByuT8YLawZynojzJVUi7+s4Ffb0398zGB7Gc
         E4rh4sCzMwXK7NfDRfFFLfaqIfcewRr6LxvXwJ6BX6LV3OQ8aLVye9pHbyhe72sOvu
         st750kYUHrz8RgF39VTb5W9U1aeAhiGUYMiwfwHrCSdDPuVdWKG8jw6Lx/Aje4jK3X
         dOhcXPKKwKHPVzCoe2m8RjnC27c0Pkk8oljHGYMrZoo0akgRBBFujKYBZsyA2QKItZ
         AYl3GOBXQ6I6g==
From:   Kalle Valo <kvalo@kernel.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        linux-wireless@vger.kernel.org, stable@vger.kernel.org,
        Gregory Erwin <gregerwin256@gmail.com>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        "Eric W . Biederman" <ebiederm@xmission.com>, vschneid@redhat.com
Subject: Re: [PATCH RESEND v11] hwrng: core - let sleep be interrupted when unregistering hwrng
References: <20220725215536.767961-1-Jason@zx2c4.com>
        <Yt+3ic4YYpAsUHMF@gondor.apana.org.au> <Yt+/HvfC+OYRVrr+@zx2c4.com>
        <87zggvoykr.fsf@kernel.org> <YuD4g+ZPx7uEa999@gondor.apana.org.au>
Date:   Wed, 27 Jul 2022 11:44:13 +0300
In-Reply-To: <YuD4g+ZPx7uEa999@gondor.apana.org.au> (Herbert Xu's message of
        "Wed, 27 Jul 2022 16:34:11 +0800")
Message-ID: <87sfmnosgy.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Herbert Xu <herbert@gondor.apana.org.au> writes:

> On Wed, Jul 27, 2022 at 09:32:20AM +0300, Kalle Valo wrote:
>>
>> But just so that I understand correctly, after Herbert's patch no ath9k
>> changes is needed anymore? That sounds great.
>
> No a small change is still needed in ath9k to completely fix
> the problem, basically a one-liner.  Either I could split that
> out and give it to you once the core bits land in mainline, or
> we could just do it in one patch with your ack.
>
> The chances of conflicts are remote.

It's a lot easier to handle that in a single patch via your tree. So
please do CC Toke and linux-wireless when you submit your patch so that
we can then ack it.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
