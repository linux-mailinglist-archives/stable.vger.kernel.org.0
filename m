Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A620516C51
	for <lists+stable@lfdr.de>; Mon,  2 May 2022 10:46:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243394AbiEBItc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 May 2022 04:49:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349872AbiEBIt0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 May 2022 04:49:26 -0400
Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63D156349;
        Mon,  2 May 2022 01:45:57 -0700 (PDT)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 7EF6D1C0B82; Mon,  2 May 2022 10:45:54 +0200 (CEST)
Date:   Mon, 2 May 2022 10:45:54 +0200
From:   Pavel Machek <pavel@ucw.cz>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Hugh Dickins <hughd@google.com>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yang Shi <shy828301@gmail.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-mm@kvack.org
Subject: Re: [PATCH AUTOSEL 13/14] mm/thp: ClearPageDoubleMap in first
 page_add_file_rmap()
Message-ID: <20220502084554.GA358@ucw.cz>
References: <20220428154222.1230793-1-gregkh@linuxfoundation.org>
 <20220428154222.1230793-13-gregkh@linuxfoundation.org>
 <c2ed1fe1-247e-e644-c367-87d32eb92cf5@google.com>
 <YmrHsVZTEzqIDiKd@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YmrHsVZTEzqIDiKd@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi!

> > I've chosen to answer to this patch of my 3 in your 14 AUTOSELs,
> > because this one is just an improvement, not at all a bugfix needed
> > for stable (maybe AUTOSEL noticed "racy" or "safely" in the comments,
> > and misunderstood).  The "Fixes" was intended to help any humans who
> > wanted to backport into their trees.
> 
> This all was off of the Fixes: tag.  Again, if these commits fix
> something why are they not for stable?  I'm a human asking to backport
> these into the stable trees based on that :)

I see this as a repeated pattern: People add Fixes: tag for trivial
things that should not really go to stable (typo in comment?) and
stable takes it is a serious bug that needs to be fixed in stable.

Best regards,
								Pavel
