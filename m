Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF30B1D5AF7
	for <lists+stable@lfdr.de>; Fri, 15 May 2020 22:50:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726204AbgEOUuS convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Fri, 15 May 2020 16:50:18 -0400
Received: from lithops.sigma-star.at ([195.201.40.130]:35188 "EHLO
        lithops.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726212AbgEOUuS (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 May 2020 16:50:18 -0400
Received: from localhost (localhost [127.0.0.1])
        by lithops.sigma-star.at (Postfix) with ESMTP id 9190D6224FDF;
        Fri, 15 May 2020 22:50:15 +0200 (CEST)
Received: from lithops.sigma-star.at ([127.0.0.1])
        by localhost (lithops.sigma-star.at [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id AdrSYIIR5X19; Fri, 15 May 2020 22:50:15 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by lithops.sigma-star.at (Postfix) with ESMTP id 2F4F160CEF22;
        Fri, 15 May 2020 22:50:15 +0200 (CEST)
Received: from lithops.sigma-star.at ([127.0.0.1])
        by localhost (lithops.sigma-star.at [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id DHwh6sPgqHHu; Fri, 15 May 2020 22:50:15 +0200 (CEST)
Received: from lithops.sigma-star.at (lithops.sigma-star.at [195.201.40.130])
        by lithops.sigma-star.at (Postfix) with ESMTP id 0B2AC6224FDF;
        Fri, 15 May 2020 22:50:15 +0200 (CEST)
Date:   Fri, 15 May 2020 22:50:14 +0200 (CEST)
From:   Richard Weinberger <richard@nod.at>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Sascha Hauer <s.hauer@pengutronix.de>,
        linux-mtd <linux-mtd@lists.infradead.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Message-ID: <568077266.223149.1589575814867.JavaMail.zimbra@nod.at>
In-Reply-To: <20200515191704.GE1009@sol.localdomain>
References: <20200502055945.1008194-1-ebiggers@kernel.org> <20200504071644.GS5877@pengutronix.de> <20200515191704.GE1009@sol.localdomain>
Subject: Re: [PATCH] ubifs: fix wrong use of crypto_shash_descsize()
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [195.201.40.130]
X-Mailer: Zimbra 8.8.12_GA_3807 (ZimbraWebClient - FF68 (Linux)/8.8.12_GA_3809)
Thread-Topic: ubifs: fix wrong use of crypto_shash_descsize()
Thread-Index: z+OnJhSOitcsTV8I0Jz25cDAthIH9w==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

----- Ursprüngliche Mail -----
> Von: "Eric Biggers" <ebiggers@kernel.org>
> An: "Sascha Hauer" <s.hauer@pengutronix.de>, "richard" <richard@nod.at>
> CC: "linux-mtd" <linux-mtd@lists.infradead.org>, "Linux Crypto Mailing List" <linux-crypto@vger.kernel.org>, "stable"
> <stable@vger.kernel.org>
> Gesendet: Freitag, 15. Mai 2020 21:17:04
> Betreff: Re: [PATCH] ubifs: fix wrong use of crypto_shash_descsize()

> On Mon, May 04, 2020 at 09:16:44AM +0200, Sascha Hauer wrote:
>> On Fri, May 01, 2020 at 10:59:45PM -0700, Eric Biggers wrote:
>> > From: Eric Biggers <ebiggers@google.com>
>> > 
>> > crypto_shash_descsize() returns the size of the shash_desc context
>> > needed to compute the hash, not the size of the hash itself.
>> > 
>> > crypto_shash_digestsize() would be correct, or alternatively using
>> > c->hash_len and c->hmac_desc_len which already store the correct values.
>> > But actually it's simpler to just use stack arrays, so do that instead.
>> > 
>> > Fixes: 49525e5eecca ("ubifs: Add helper functions for authentication support")
>> > Fixes: da8ef65f9573 ("ubifs: Authenticate replayed journal")
>> > Cc: <stable@vger.kernel.org> # v4.20+
>> > Cc: Sascha Hauer <s.hauer@pengutronix.de>
>> > Signed-off-by: Eric Biggers <ebiggers@google.com>
>> 
>> Looks better that way, thanks.
>> 
>> Acked-by: Sascha Hauer <s.hauer@pengutronix.de>
>> 
> 
> Richard, could you take this through the ubifs tree for 5.8?

Sure. I actually will send a PR with various MTD related fixes
for 5.7.

Thanks,
//richard
