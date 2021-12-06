Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA54E46A6E4
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 21:29:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349714AbhLFUdC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 15:33:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229867AbhLFUdC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 15:33:02 -0500
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E148C061746
        for <stable@vger.kernel.org>; Mon,  6 Dec 2021 12:29:33 -0800 (PST)
Received: by mail-pg1-x533.google.com with SMTP id 137so11596779pgg.3
        for <stable@vger.kernel.org>; Mon, 06 Dec 2021 12:29:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=l75x5eLS9CJucfjqwEQCTrQwbcH/BDoKr03AKZQddrg=;
        b=BTe9lORQxiVkgMiVE4gL+lFZlZo7woLmHizQ5XpYfPOWuJL4CjDabHryxmjME8ZRHB
         5F7BfS4tXkupPKchlv2K9SkcaPxLkB+C9Hf/QTeqxrL9qEWtXMl+7hnwBOaC6I4SdpGv
         LXxiU+FUdlh9jL6tJrbRdJNBQzBSP7aJsX0jE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=l75x5eLS9CJucfjqwEQCTrQwbcH/BDoKr03AKZQddrg=;
        b=RubvQkaxlZ4vl2lgd7PAmJoFFRPaCve68UhJtIWsZzKX3gil23gY4EHoCK5BNjEowt
         dw0ClHI07KHr4612no+tKAQ+n3GXa7DF8CpstKn2QGseScNk3FWYrseocuBby9pxM/hm
         FLpnTH6bMmsRbLEJ+fWWLXvlkT0dkeSijduJFh4u5RzGIbZCRhaRPBvWPVMncG7VDOgK
         603qvMIcWFgXeshsgLEwT6Shj8AwC4YAu5pUNTzQTOmbToBAeW2GlgXaWjTRlezs4Pq9
         QZSshFYFe+NKNVPL1hZMHcjgPqLqM8WddoO0NhZsROZ3lsWQQNexCZWvx9O1pRE68NGn
         Smhw==
X-Gm-Message-State: AOAM533a0iLgYfBWTb2KYZprWgVC4WibiylB3SStFd03fNL5dZvb/MXJ
        GFrXQnFHFaRqBhLbrSe0HlaAjg==
X-Google-Smtp-Source: ABdhPJyV6t921SyeSoPwLxZR3y0kAJCJVSo17yImvSYMe5KFS4+j/oPAEi5uBgPUzkW1O58eMoCY8g==
X-Received: by 2002:a63:8bc7:: with SMTP id j190mr19937234pge.240.1638822572662;
        Mon, 06 Dec 2021 12:29:32 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id p124sm12932109pfg.110.2021.12.06.12.29.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Dec 2021 12:29:32 -0800 (PST)
Date:   Mon, 6 Dec 2021 12:29:31 -0800
From:   Kees Cook <keescook@chromium.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Thomas Lindroth <thomas.lindroth@gmail.com>, stable@vger.kernel.org
Subject: Re: Could the fix for broken gcc-plugins with gcc-11 be backported
 to 5.10?
Message-ID: <202112061220.79D1A6823E@keescook>
References: <a11f5d22-658c-44e9-51ab-d39c5e8776da@gmail.com>
 <Ya4KYD9lpKaQI9G7@kroah.com>
 <dbf6b329-03ae-fc92-80a6-8f80d88e28cf@gmail.com>
 <Ya4PqyRnxqB+5VaV@kroah.com>
 <ba94ea3b-c2df-9ddb-1074-d6b58389a686@gmail.com>
 <Ya4hM4dsWYxw8nJW@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ya4hM4dsWYxw8nJW@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 06, 2021 at 03:41:55PM +0100, Greg KH wrote:
> On Mon, Dec 06, 2021 at 02:59:57PM +0100, Thomas Lindroth wrote:
> > On 12/6/21 14:27, Greg KH wrote:
> > > On Mon, Dec 06, 2021 at 02:24:29PM +0100, Thomas Lindroth wrote:
> > > > On 12/6/21 14:04, Greg KH wrote:
> > > > > On Mon, Dec 06, 2021 at 01:59:31PM +0100, Thomas Lindroth wrote:
> > > > > > Build support for gcc-plugins are not detected with gcc-11 in lts kernels.
> > > > > > Gentoo and Arch apply their own patch to fix the problem in their distribution
> > > > > > kernels but I would prefer if a proper fix was applied upstream.
> > > > > > 
> > > > > > https://bugs.gentoo.org/814200 a gentoo report with the relevant info.
> > > > > > 
> > > > > > I've searched for any upstream discussions about the problem but I've only found
> > > > > > one message saying the backport needs an additional fix. That was almost a year
> > > > > > ago. https://www.spinics.net/lists/stable/msg438000.html
> > > > > 
> > > > > We can not take a patch in a stable kernel release unless it is already
> > > > > in Linus's tree.  Please work to get a patch accepted there first,
> > > > > before worrying about older kernel versions.
> > > > > 
> > > > > thanks,
> > > > > 
> > > > > greg k-h
> > > > > 
> > > > 
> > > > The problem was fixed in Linus tree in commit 67a5a68013056cbcf0a647e36cb6f4622fb6a470
> > > > "gcc-plugins: fix gcc 11 indigestion with plugins..." added in v5.11
> > > > 
> > > > That's the patch that needed some kind of additional fix before it could be backported
> > > > but that fix never materialized.
> > > 
> > > If you have a working version, based on a distro's use, please provide
> > > it and I will be glad to pick it up.
> > > 
> > > thanks,
> > > 
> > > greg k-h
> > > 
> > 
> > https://dev.gentoo.org/~mpagano/genpatches/trunk/5.10/2910_fix-gcc-detection-method.patch
> > 
> > Here is the patch gentoo applies to 5.10. It seems to be a combination of two upstream
> > commits:
> > 67a5a68013056cbcf0a647e36cb6f4622fb6a470 "gcc-plugins: fix gcc 11 indigestion with plugins..."
> > 1e860048c53ee77ee9870dcce94847a28544b753 "gcc-plugins: simplify GCC plugin-dev capability test"
> 
> That's not how I can take a patch, sorry.  Please submit these as
> individual emails so that then could be applied.
> 
> > I can't vouch for the correctness of that fix. I'm just a regular user who stumbled upon this
> > problem and found that gentoo bug report. Check with Kees Cook for that "additional fix". I
> > don't know what fix that is.
> 
> I don't think either of them differ from what is in mainline, so I do
> not know.

Hi!

Yeah, the two fixes that I think are needed for v5.10 are:

1e860048c53ee77ee9870dcce94847a28544b753
67a5a68013056cbcf0a647e36cb6f4622fb6a470

This additionally appears to match the combo patch in gentoo:
https://814200.bugs.gentoo.org/attachment.cgi?id=746715

Local build testing shows the plugins working...

-- 
Kees Cook
