Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FC246B5D8D
	for <lists+stable@lfdr.de>; Sat, 11 Mar 2023 16:56:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229922AbjCKP4Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Mar 2023 10:56:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230162AbjCKPz7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Mar 2023 10:55:59 -0500
Received: from bedivere.hansenpartnership.com (bedivere.hansenpartnership.com [IPv6:2607:fcd0:100:8a00::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57EF71B54F;
        Sat, 11 Mar 2023 07:54:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1678550078;
        bh=GpBC197sBaTbH4E1KFh6GXZELUaC7Fr36igsqPuf3u0=;
        h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
        b=cJ4+hX4POzm3dJ99eq3ac+jX+rnWLpGYxVN0P72ZUWqQTzwii0ncsWbT33sulhdvX
         h6KtX7MkVw5B2KnzWdDFZVdokjGTyZ9GreAkW+KrsZgmyzR4xFYE+dvyl0D5bRzhG7
         FXqs/xDfe4iDNX2XeeI3o7f7NTJeaUvu1rdlARZQ=
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id 915A51285E75;
        Sat, 11 Mar 2023 10:54:38 -0500 (EST)
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
 by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavis, port 10024)
 with ESMTP id K9fqviWhnVVk; Sat, 11 Mar 2023 10:54:38 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1678550078;
        bh=GpBC197sBaTbH4E1KFh6GXZELUaC7Fr36igsqPuf3u0=;
        h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
        b=cJ4+hX4POzm3dJ99eq3ac+jX+rnWLpGYxVN0P72ZUWqQTzwii0ncsWbT33sulhdvX
         h6KtX7MkVw5B2KnzWdDFZVdokjGTyZ9GreAkW+KrsZgmyzR4xFYE+dvyl0D5bRzhG7
         FXqs/xDfe4iDNX2XeeI3o7f7NTJeaUvu1rdlARZQ=
Received: from lingrow.int.hansenpartnership.com (unknown [IPv6:2601:5c4:4302:c21::a774])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (prime256v1) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id C37E01285DD7;
        Sat, 11 Mar 2023 10:54:37 -0500 (EST)
Message-ID: <734c9a0920f293c88168f38c1245e779d03f4364.camel@HansenPartnership.com>
Subject: Re: AUTOSEL process
From:   James Bottomley <James.Bottomley@HansenPartnership.com>
To:     Sasha Levin <sashal@kernel.org>, Eric Biggers <ebiggers@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org
Date:   Sat, 11 Mar 2023 10:54:36 -0500
In-Reply-To: <ZAyFFtORBosdarMr@sashalap>
References: <Y/y70zJj4kjOVfXa@sashalap> <Y/zswi91axMN8OsA@sol.localdomain>
         <Y/zxKOBTLXFjSVyI@sol.localdomain> <Y/0U8tpNkgePu00M@sashalap>
         <Y/0i5pGYjrVw59Kk@gmail.com> <Y/0wMiOwoeLcFefc@sashalap>
         <Y/1LlA5WogOAPBNv@gmail.com> <Y/1em4ygHgSjIYau@sashalap>
         <Y/136zpJSWx96YEe@sol.localdomain> <ZAu4GE0q4jzRI+F6@sol.localdomain>
         <ZAyFFtORBosdarMr@sashalap>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, 2023-03-11 at 08:41 -0500, Sasha Levin wrote:
> On Fri, Mar 10, 2023 at 03:07:04PM -0800, Eric Biggers wrote:
> > On Mon, Feb 27, 2023 at 07:41:31PM -0800, Eric Biggers wrote:
> > > 
> > > Well, probably more common is that prerequisites are in the same
> > > patchset, and the prerequisites are tagged for stable too. 
> > > Whereas AUTOSEL often just picks patch X of N.  Also, developers
> > > and maintainers who tag patches for stable are probably more
> > > likely to help with the stable process in general and make sure
> > > patches are backported correctly...
> > > 
> > > Anyway, the point is, AUTOSEL needs to be fixed to stop
> > > inappropriately cherry-picking patch X of N so often.
> > > 
> > 
> > ... and AUTOSEL strikes again, with the 6.1 and 6.2 kernels
> > currently crashing whenever a block device is removed, due to
> > patches 1 and 3 of a 3-patch series being AUTOSEL'ed (on the same
> > day I started this discussion, no less):
> > 
> > https://lore.kernel.org/linux-block/CAOCAAm4reGhz400DSVrh0BetYD3Ljr2CZen7_3D4gXYYdB4SKQ@mail.gmail.com/T/#u
> > 
> > Oh sorry, ignore this, it's just an anecdotal example.
> 
> Yes, clearly a problem with AUTOSEL and not with how sad the testing
> story is for stable releases.

Hey, that's a completely circular argument:  if we had perfect testing
then, of course, it would pick up every bad patch before anything got
released; but we don't, and everyone knows it.  Therefore, we have to
be discriminating about what patches we put in.  And we have to
acknowledge that zero bugs in patches isn't feasible in spite of all
the checking we do do.  I also think we have to acknowledge that users
play a role in the testing process because some bugs simply aren't
picked up until they try out a release.  So discouraging users from
running mainline -rc's means we do get bugs in the released kernel that
we might not have had if they did.  Likewise if everyone only runs
stable kernels, the bugs in the released kernel don't get found until
stable.  So this blame game really isn't helping.

I think the one thing everyone on this thread might agree on is that
this bug wouldn't have happened if AUTOSEL could detect and backport
series instead of individual patches.  Sasha says that can't be done
based on in information in Linus' tree[1] which is true but not a
correct statement of the problem.  The correct question is given all
the information available, including lore, could we assist AUTOSEL in
better detecting series and possibly making better decisions generally?

I think that's the challenge for anyone who actually wants to help
rather than complain.  At least the series detection bit sounds like it
could be a reasonable summer of code project.

Regards,

James

[1] https://lore.kernel.org/linux-fsdevel/ZAyK0KM6JmVOvQWy@sashalap/
