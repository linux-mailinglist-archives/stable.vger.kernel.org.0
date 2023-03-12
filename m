Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B601F6B6702
	for <lists+stable@lfdr.de>; Sun, 12 Mar 2023 14:56:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229612AbjCLN4F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 12 Mar 2023 09:56:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229552AbjCLN4E (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 12 Mar 2023 09:56:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7039D3B3E1;
        Sun, 12 Mar 2023 06:56:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 07B9FB80B74;
        Sun, 12 Mar 2023 13:56:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36929C433D2;
        Sun, 12 Mar 2023 13:56:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678629360;
        bh=lfa7w+q4IgMeZb8PWT7Pts03wML5wiBGvst0ZZaLWPA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=i54kGKQBKdC12Ylsx/DQZhRKp8pQO64FkShrkJMzpYbBIwNCrW9xkCDrXmN4dZa7e
         2dBieBOqAfdJ6PMPmi5jypEdIS4bjduuer8bAsTjfu+vlRw7DUp4NoENRovQpyYUh6
         LS4Br7Tf/KC3vOaY7wKT8SQh3qy7GrLNhNUUjnaoLLyI3NyZICqFSHX9jo87B8nfso
         LoJQ9bMjF9KL0O8uTqXgFbm501IChQETR7J9R54I5G5kD/ekOt7oQriO0EFz1JGDJz
         ItG2I5TmButXsgUiGpXMGo4Y3Sa4NhAySzjRDGJDjDS2sWerITMyjyroLxBxRMo73z
         tu7JmagWoFFxg==
Date:   Sun, 12 Mar 2023 13:55:56 +0000
From:   Mark Brown <broonie@kernel.org>
To:     Willy Tarreau <w@1wt.eu>
Cc:     Eric Biggers <ebiggers@kernel.org>, Theodore Ts'o <tytso@mit.edu>,
        Sasha Levin <sashal@kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        Pavel Machek <pavel@ucw.cz>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org
Subject: Re: AUTOSEL process
Message-ID: <ZA3Z7Gdigi2cBWQu@sirena.org.uk>
References: <Y/zxKOBTLXFjSVyI@sol.localdomain>
 <ZATC3djtr9/uPX+P@duo.ucw.cz>
 <ZAewdAql4PBUYOG5@gmail.com>
 <ZAwe95meyCiv6qc4@casper.infradead.org>
 <ZAyK0KM6JmVOvQWy@sashalap>
 <20230311161644.GH860405@mit.edu>
 <ZAy+3f1/xfl6dWpI@sol.localdomain>
 <ZAzJltJaydwjCN6E@1wt.eu>
 <ZAzVbzthi8IfptFZ@sol.localdomain>
 <ZAzghyeiac3Zh8Hh@1wt.eu>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="S55OJxiYMz3PrHQ2"
Content-Disposition: inline
In-Reply-To: <ZAzghyeiac3Zh8Hh@1wt.eu>
X-Cookie: Many a family tree needs trimming.
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--S55OJxiYMz3PrHQ2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Mar 11, 2023 at 09:11:51PM +0100, Willy Tarreau wrote:
> On Sat, Mar 11, 2023 at 11:24:31AM -0800, Eric Biggers wrote:

> > As I said in a part of my email which you did not quote, the fallback option is
> > to send the list of issues to the mailing list for others to review.

> Honestly, patches are already being delivered publicly tagged AUTOSEL,
> then published again as part of the stable review process. Have you seen
> the amount of feedback ? Once in a while there are responses, but aside
> Guenter reporting build successes or failures, it's a bit quiet. What
> makes you think that sending more detailed stuff that require even more
> involvement and decision would trigger more participation ?

TBH as someone getting copied on the AUTOSEL mails I think if the
volume of backports is going to say the same what I'd really like
is something that mitigates the volume of mail, or at least makes
the mails that are being sent more readily parseable.  Things
that add more context to what's being sent would probably help a
lot, right now I'm not really able to do much more than scan for
obviously harmful things.

> > But again, this comes back to one of the core issues here which is how does one
> > even build something for the stable maintainers if their requirements are
> > unknown to others?

> Well, the description of the commit message is there for anyone to
> consume in the first place. A commit message is an argument for a
> patch to get adopted and resist any temptations to revert it. So
> it must be descriptive enough and give instructions. Dependencies
> should be clear there. When you seen github-like one-liners there's
> no hope to get much info, and it's not a matter of requirements,
> but of respect for a team development process where some facing your
> patch might miss the skills required to grasp the details. With a
> sufficiently clear commit message, even a bot can find (or suggest)
> dependencies. And this is not specific to -stable: if one of the
> dependencies is found to break stuff, how do you know it must not be
> reverted without reverting the whole series if that's not described
> anywhere ?

I'd say that the most common class of missing dependency I've
seen is on previously applied code which is much less likely to
be apparent in the commit message and probably not noticed unless
it causes a cherry pick or build issue.

> One thing I think that could be within reach and could very slightly
> improve the process would be to indicate in a stable announce the amount
> of patches coming from autosel. I think that it could help either
> refining the selection by making users more conscious about the importance
> of this source, or encourage more developers to Cc stable to reduce that
> ratio. Just an idea.

I'm not sure if it's the ratio that's the issue here, if anything
I'd expect that lowering the ratio would make people more
stressed by AUTOSEL since assuming a similar volume of patches
get picked overall it would increase the percentage of the
AUTOSEL patches that have problems.

--S55OJxiYMz3PrHQ2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmQN2ewACgkQJNaLcl1U
h9Ajzgf/etvpD2AdbeGoKhLQG5PLwE/95pYY/RzhpmG+QRjPA7TbDPJXGmIqqOH5
vIthE5nUw5GhMCJxQMsbRCxf/3ilaOlDs6Aky55WreJstlnGp+a6SnFPTkMgiuCy
wMJVjlb5x7sNzERN/SzamsmagGgvwdG6JgPF/b0TDKijrIDcPZFvGVdkYnw25Bs6
PnXwZQqjzPb/Y2yoLbx3eAteaze+oBGS5XDagtV0iFoLKWBPG5yegvA8LqrbJ0W9
JqvGAvpay8wyY9X2C4MqHdNbhat35OmOvv/mDMfDJILlHqfAZjiEmi0OzyDBBsgz
Xx8tKbzQN8jdgTAggRspmax2xkIHzA==
=3oYh
-----END PGP SIGNATURE-----

--S55OJxiYMz3PrHQ2--
