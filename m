Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE6886B5BA8
	for <lists+stable@lfdr.de>; Sat, 11 Mar 2023 13:29:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230221AbjCKM3V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Mar 2023 07:29:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230252AbjCKM3S (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Mar 2023 07:29:18 -0500
Received: from out2-smtp.messagingengine.com (out2-smtp.messagingengine.com [66.111.4.26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 064A69773;
        Sat, 11 Mar 2023 04:29:16 -0800 (PST)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id 9D17E5C00CB;
        Sat, 11 Mar 2023 07:29:14 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Sat, 11 Mar 2023 07:29:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-type:content-type:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm2; t=1678537754; x=1678624154; bh=3V
        Ft5BMnEtWgoE8DS8x4T8lvT+blcOP9/nPDYdGkPEc=; b=tf3QBQC0mJoKN4sjKF
        rcPDF+oIHtNR0FQtXg9UxvUFJJrlBp2HQGtvKeZmyDPm7D/IgEPBaBM5Idvnoizr
        0AE2OOrE5tT0qRBL83qG3YU126UkG/US3eaITsoTjs/Ha/oTY/eSXo6Ds/eL8vWM
        JQEvTQSOWSY/kbnBesgBwdPf2bDrxBYBsMZFBFCKE3AwlePVozgsukmcniqArw2G
        k38f7EmV2r4VAK4QF3XgbsAgTbAlwY+Yz6dHTnqLiECP3Zwnk24bJhTehDIBZmTy
        bCiGIuJy7GVOz7z5cNdgt33yUc+wxQO0/UeKkEzn5ybLxYgGgYs0VUDJS0b0RivL
        Pp1A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:content-type:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm2; t=1678537754; x=1678624154; bh=3VFt5BMnEtWgo
        E8DS8x4T8lvT+blcOP9/nPDYdGkPEc=; b=royGhZwmRZEK0Eak4+92aNzUsq9QL
        SMEo9IHmqUg+JvnMB61UJZlua66P7kCcJc9ewCd07VedFMDp0UzGzLL/41oyBo7F
        NqjhhL7lYllMIJMBt8ZOmROrgg/IjfIgLEqhnjrzfN7LWcj/ZHmNFrs5PQoBi9Zi
        OBKsRN4mdYt65pjsPvxhszhcf5WtcU1GIZkz7E5kDBLgqi487dYWeL5Az58wS/bq
        OeUuPAs9lFyhzRnb7LB13NbgQwHk5e5FAhxleH4bbx8TP7oRbXST3d+CkO7yJiXW
        KKGm5u7YKLlMSaSXnQaghxCEp45BKK6p/2wAAAtQ/4O5NWsTzMeV20C1A==
X-ME-Sender: <xms:GnQMZFbjXXkUTwdd4ykH1eXU0k9Fq-F-OqmOHyc2qcQ04DUWVlEq9Q>
    <xme:GnQMZMYrd3ZW4nRxHh-zkwAFJJb1FyBnn7q3kPoD0K-XnMekQH_XcJEjXcWRtvG-h
    r7uZzW-_XcFzA>
X-ME-Received: <xmr:GnQMZH_f-Yd8W3ZiAMSLkunUqZjMYafwKvE9AchbIBOC5BK6Vmf_y7Rh9EvoyedJj--QC08hCwusD2rntB0ksOoTEtDEcVzSa-XG1Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrvddvtddgudeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepheegvd
    evvdeljeeugfdtudduhfekledtiefhveejkeejuefhtdeufefhgfehkeetnecuvehluhhs
    thgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorg
    hhrdgtohhm
X-ME-Proxy: <xmx:GnQMZDqvJ9SYtZq4m_--v9LC0jDjrr5DS5g5miEu0uS3nKaVqSbM0Q>
    <xmx:GnQMZAp8Dw7U-g5fhuBhM4zDN9DTVAcWTvI6wiSJltSNfmFgbl_mlQ>
    <xmx:GnQMZJRoJ2yNTCU9hBG4am2JU4cKGtxiFwO8IQrBYMAFPckFhFr4lQ>
    <xmx:GnQMZOZhQFEGuS620XbfqBr4ObG9RervYHVjGCkyBX4WvvY52RqYLw>
Feedback-ID: i787e41f1:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sat,
 11 Mar 2023 07:29:13 -0500 (EST)
Date:   Sat, 11 Mar 2023 13:29:10 +0100
From:   Greg KH <greg@kroah.com>
To:     Pavel Machek <pavel@ucw.cz>
Cc:     Willy Tarreau <w@1wt.eu>, Matthew Wilcox <willy@infradead.org>,
        Eric Biggers <ebiggers@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org
Subject: Re: AUTOSEL process
Message-ID: <ZAx0Fhih9Ckbk07M@kroah.com>
References: <Y/rufenGRpoJVXZr@sol.localdomain>
 <Y/ux9JLHQKDOzWHJ@sol.localdomain>
 <Y/y70zJj4kjOVfXa@sashalap>
 <Y/zswi91axMN8OsA@sol.localdomain>
 <Y/zxKOBTLXFjSVyI@sol.localdomain>
 <ZATC3djtr9/uPX+P@duo.ucw.cz>
 <ZAewdAql4PBUYOG5@gmail.com>
 <ZAwe95meyCiv6qc4@casper.infradead.org>
 <ZAw3tt9xISOdb5sS@1wt.eu>
 <ZAxp0KaKq7x7ZKlz@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZAxp0KaKq7x7ZKlz@duo.ucw.cz>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Mar 11, 2023 at 12:45:20PM +0100, Pavel Machek wrote:
> Hi!
> 
> > > > > I believe that -stable would be more useful without AUTOSEL process.
> > > > 
> > > > There has to be a way to ensure that security fixes that weren't properly tagged
> > > > make it to stable anyway.  So, AUTOSEL is necessary, at least in some form.  I
> > > > think that debating *whether it should exist* is a distraction from what's
> > > > actually important, which is that the current AUTOSEL process has some specific
> > > > problems, and these specific problems need to be fixed...
> > > 
> > > I agree with you, that we need autosel and we also need autosel to
> > > be better.  I actually see Pavel's mail as a datapoint (or "anecdote",
> > > if you will) in support of that; the autosel process currently works
> > > so badly that a long-time contributor thinks it's worse than nothing.
> > > 
> > > Sasha, what do you need to help you make this better?
> > 
> > One would probably need to define "better" and "so badly". As a user
> > of -stable kernels, I consider that they've got much better over the
> 
> Well, we have Documentation/process/stable-kernel-rules.rst . If we
> wanted to define "better", we should start documenting what the real
> rules are for the patches in the stable tree.
> 
> I agree that -stable works quite well, but the real rules are far away
> from what is documented.
> 
> I don't think AUTOSEL works well. I believe we should require positive
> reply from patch author on relevant maintainer before merging such
> patch to -stable.

Again, for the people in the back so that everyone can hear it, that
does not work as some subsystems refuse to tag ANY patches for stable
commits, nor do they want to have anything to do with stable kernels at
all.  And that's fine, that's their option, but because of that, we have
to have a way to actually get the real fixes in those subsystems to the
users who use these stable kernels.  Hence, the AUTOSEL work.

So no, forcing a maintainer/author to ack a patch to get it into stable
is not going to work UNLESS a maintainer/author explicitly asks for
that, which some have, and that's wonderful.

thanks,

greg k-h
