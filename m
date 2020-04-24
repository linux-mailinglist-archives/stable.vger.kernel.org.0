Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E7E51B77BE
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 16:02:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726753AbgDXOCX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Apr 2020 10:02:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726717AbgDXOCX (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Apr 2020 10:02:23 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28CECC09B045
        for <stable@vger.kernel.org>; Fri, 24 Apr 2020 07:02:23 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id h12so2668174pjz.1
        for <stable@vger.kernel.org>; Fri, 24 Apr 2020 07:02:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=b9CJVAaQ8Remu0Fc8083hcvt8X3b+MnqQ+pBCtxllPI=;
        b=bKZ3ADa36RH6UM9pB+qL7PEy2mlGEm8dIbR8A4fRwXBY1bFybdbZd0UOj8Uh+xGZ7V
         ALOKGtYvfR3pdqn/6+IvvD2PeXCPwOYxJ/RScHUM5cmhBESpslBN2JgYZGWLzyjJC35c
         mCerIkE66YD9uh/5XVj5RV8iqkfU4O9ih7anq6n0ucs+Doj5/GlyYLkXAB+nSQNZOx7B
         OB9wEi8Hy1mVSJQ7jZ9BsOsvSoJiYTLU2Nz+sKsFrwIQgEv4YWuLf56B3GXPJ8R4gFmu
         MKW8Ney2T7Li+1r/L6MJfcGLENocZIfgnPSupuoWH3gNTqdKfacTHpTpjHe5wKspmEeJ
         WaaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=b9CJVAaQ8Remu0Fc8083hcvt8X3b+MnqQ+pBCtxllPI=;
        b=DlvAddLVdeHNXff15Yd+I4J3ALOFgdfYsuqwX1NolfXH2XBOkWRI9dBp/2vChaXStN
         90dKHfrRGtdMSf0nIR5Yi43a0yehjNMWjZgWVBAGCnMEbA2o7JJ8srBtdjlmuowrVhWj
         ROF0j515/9OQ1YGIQCRoP9mb88hzGGS8udkbVEsapJYRzBX8/d95VxME3BpMKY7PoFUF
         PnsmmhP6yJ7Lwq/7yc6lVZ8bCGXuQUQDmWan/AgjYym4PMgYqsIkvpVpqv6wV2SgMFCG
         YNCC7QflVL/ksMBijs/NgwAXQ7tEgxC8L3yxrXwNfpTYUEu6FV9CsjS6kInVC1MfTWft
         H2Cg==
X-Gm-Message-State: AGi0PuYH4sbD+VfQFeAIR4uaEX7AK5qvczhexghYq+uExQHfCBLo9CGP
        6QKvIJiN/J1P/LL5Aoev9TQJpJJw
X-Google-Smtp-Source: APiQypLz9tqUKpzCh+Aggls5PqKsESmWpKJAsTD4cxgbWqezIWbmbyGWvgFaD/1fmFRwFh97jP5B5g==
X-Received: by 2002:a17:90a:f2c6:: with SMTP id gt6mr6534501pjb.61.1587736942513;
        Fri, 24 Apr 2020 07:02:22 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id s44sm4862083pjc.28.2020.04.24.07.02.19
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 24 Apr 2020 07:02:20 -0700 (PDT)
Date:   Fri, 24 Apr 2020 07:02:18 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, Sasha Levin <sashal@kernel.org>
Subject: Re: List of patches to apply to stable releases
Message-ID: <20200424140218.GA136135@roeck-us.net>
References: <20200422194306.GA103402@roeck-us.net>
 <20200424101118.GC381429@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200424101118.GC381429@kroah.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Apr 24, 2020 at 12:11:18PM +0200, Greg Kroah-Hartman wrote:
> On Wed, Apr 22, 2020 at 12:43:06PM -0700, Guenter Roeck wrote:
> 
[ ... ]
> > 
> > Upstream commit ce4e45842de3 ("crypto: mxs-dcp - make symbols 'sha1_null_hash' and 'sha256_null_hash' static")
> >   upstream: v4.20-rc1
> >     Fixes: c709eebaf5c5 ("crypto: mxs-dcp - Fix SHA null hashes and output length")
> >       in linux-4.4.y: 33378afbd12b
> >       in linux-4.9.y: df1ef6f3c9ad
> >       in linux-4.14.y: c0933fa586b4
> >       in linux-4.19.y: 70ecd0459d03
> >       upstream: v4.20-rc1
> >     Affected branches:
> >       linux-4.4.y
> >       linux-4.9.y
> >       linux-4.14.y
> >       linux-4.19.y
> 
> That's really not a "bug", but I'll take it to keep your scripts happy.
> 
No need to do that - if it happens please let me know and feel free to
drop. The script finds lots of irrelevant patches which are (often
unnecessarily) marked as Fixes: (maybe we should have a rule stating that
comment changes or documentation changes don't count as "fix"). I already
drop a lot of them, and feedback like this helps me decide what to drop
in the future.

In this case I kept the patch in the list not for the happiness of the
script but for the happiness of static analyzers. While it doesn't fix
a bug per se, it reduces the noise produced by those, which I think does
help because less noise improves focus on real bugs.

Thanks,
Guenter
