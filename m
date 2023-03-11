Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5374C6B58EB
	for <lists+stable@lfdr.de>; Sat, 11 Mar 2023 07:26:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229722AbjCKG0I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Mar 2023 01:26:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229589AbjCKG0H (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Mar 2023 01:26:07 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65F5213B961;
        Fri, 10 Mar 2023 22:26:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=I+OnlACID7Vj4QKsE6DLJjjwrblDiFCX+bTgJFHMKmo=; b=oDh4toKy8WZlQSR8TD6vqfC58I
        A3SvzbtBJw3fxhf6TBiLWNmC7n+uuHF1SS5dGqG3TaP3UuKcOzIJJH3MCDHUVqxISAH5oYvpVMRQW
        mwiEinLlgcsWAA8u9ZH9jYjsmntv6Kzf3SJLUaphlYCVhexykzuJQJu7TDqO+3MJxw5Mq4HxtY+7V
        VUeDdAHT5/nJ/U9uE1cXQopZDFmgyZuD+T6UKXHvkPshUeMm5k64nLtJzBLb/kp3NVlrPoCXHV1mr
        NDCMnmQPcVOXGoIUOIMSWlcKJedTJHsDq2rLVuwYH1VzN+49Unt6hn6q9zO1u2bl6Yf7rmTssdIUB
        WcWyLuYQ==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pasg3-00A1DJ-4d; Sat, 11 Mar 2023 06:25:59 +0000
Date:   Sat, 11 Mar 2023 06:25:59 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Pavel Machek <pavel@ucw.cz>, Sasha Levin <sashal@kernel.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org
Subject: Re: AUTOSEL process
Message-ID: <ZAwe95meyCiv6qc4@casper.infradead.org>
References: <20230226034256.771769-1-sashal@kernel.org>
 <20230226034256.771769-12-sashal@kernel.org>
 <Y/rbGxq8oAEsW28j@sol.localdomain>
 <Y/rufenGRpoJVXZr@sol.localdomain>
 <Y/ux9JLHQKDOzWHJ@sol.localdomain>
 <Y/y70zJj4kjOVfXa@sashalap>
 <Y/zswi91axMN8OsA@sol.localdomain>
 <Y/zxKOBTLXFjSVyI@sol.localdomain>
 <ZATC3djtr9/uPX+P@duo.ucw.cz>
 <ZAewdAql4PBUYOG5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZAewdAql4PBUYOG5@gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 07, 2023 at 09:45:24PM +0000, Eric Biggers wrote:
> On Tue, Mar 07, 2023 at 10:18:35PM +0100, Pavel Machek wrote:
> > I believe that -stable would be more useful without AUTOSEL process.
> 
> There has to be a way to ensure that security fixes that weren't properly tagged
> make it to stable anyway.  So, AUTOSEL is necessary, at least in some form.  I
> think that debating *whether it should exist* is a distraction from what's
> actually important, which is that the current AUTOSEL process has some specific
> problems, and these specific problems need to be fixed...

I agree with you, that we need autosel and we also need autosel to
be better.  I actually see Pavel's mail as a datapoint (or "anecdote",
if you will) in support of that; the autosel process currently works
so badly that a long-time contributor thinks it's worse than nothing.

Sasha, what do you need to help you make this better?
