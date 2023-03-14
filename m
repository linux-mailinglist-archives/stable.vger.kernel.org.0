Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C83C46B9771
	for <lists+stable@lfdr.de>; Tue, 14 Mar 2023 15:13:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230348AbjCNONY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Mar 2023 10:13:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229790AbjCNONW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Mar 2023 10:13:22 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64C26A42EC;
        Tue, 14 Mar 2023 07:12:55 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 4761F21F48;
        Tue, 14 Mar 2023 14:12:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1678803148; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Q0HjvnKbml+YdcLLE7DMO0MaJnPS3khjsSC2B2uEuwo=;
        b=QXdStDC3u29eG6VvG5yUEI1E+896xhnAECIuv+0PhGzoJ3EYSxQ/z6ymoeF6nPvcUjX55k
        9rqLh/hsV5w3Fql1CVkywHbc5UVjuHA0dDKaPJAtU+gyrKtbBQsg8/omdBY1Mef2bJ1cEB
        t3VtiyemZp1lDHZ4T5S4Lnz8QA81h9M=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1678803148;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Q0HjvnKbml+YdcLLE7DMO0MaJnPS3khjsSC2B2uEuwo=;
        b=BHqiCNJyvFqs1LJLRJENn60nI3LRSVNTA6AmP6Xo3wGJxpkXbVD8rnK/0CvWLdLaF85B7j
        qW1wAzcx1JKiwVDQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 3B3E413A26;
        Tue, 14 Mar 2023 14:12:28 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id /zFqDsyAEGTUFAAAMHmgww
        (envelope-from <jack@suse.cz>); Tue, 14 Mar 2023 14:12:28 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
        id C1602A06FD; Tue, 14 Mar 2023 15:12:27 +0100 (CET)
Date:   Tue, 14 Mar 2023 15:12:27 +0100
From:   Jan Kara <jack@suse.cz>
To:     Theodore Ts'o <tytso@mit.edu>
Cc:     Willy Tarreau <w@1wt.eu>, David Laight <David.Laight@aculab.com>,
        'Sasha Levin' <sashal@kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        Eric Biggers <ebiggers@kernel.org>,
        Pavel Machek <pavel@ucw.cz>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: AUTOSEL process
Message-ID: <20230314141227.7x6k2wsveliooclw@quack3>
References: <Y/y70zJj4kjOVfXa@sashalap>
 <Y/zswi91axMN8OsA@sol.localdomain>
 <Y/zxKOBTLXFjSVyI@sol.localdomain>
 <ZATC3djtr9/uPX+P@duo.ucw.cz>
 <ZAewdAql4PBUYOG5@gmail.com>
 <ZAwe95meyCiv6qc4@casper.infradead.org>
 <ZAyK0KM6JmVOvQWy@sashalap>
 <9ff6fe2c13434512b034823112843d4f@AcuMS.aculab.com>
 <ZA1X46ClAJGc/2V7@1wt.eu>
 <20230312050947.GK860405@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230312050947.GK860405@mit.edu>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun 12-03-23 00:09:47, Theodore Ts'o wrote:
> On Sun, Mar 12, 2023 at 05:41:07AM +0100, Willy Tarreau wrote:
> > 
> > I suspect that having an option to keep the message ID in the footer (a
> > bit like the "cherry-picked from" tag but instead "blongs to series")
> > could possibly help. And when no such info is present we could have
> > one ID generated per "git am" execution since usually if you apply an
> > mbox, it constitutes a series (but not always of course, though it's
> > not difficult to arrange series like this).
> 
> As I pointed out earlier, some of us are adding the message ID in the
> footer alrady, using a Link tag.  This is even documented already in
> the Kernel Maintainer's Handbook, so I'm pretty sure it's not just me.  :-)

Yeah, given Linus' rants about links pointing to patch posting, what I'm
currently doing is that I add Message-ID: tag to the patch instead of a
Link: tag. It preserves the information as well and it is obvious to human
reader what are links to reports / discussions and what is just a link to
patch posting.

								Honza

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
