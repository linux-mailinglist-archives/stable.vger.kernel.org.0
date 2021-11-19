Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 057664572A2
	for <lists+stable@lfdr.de>; Fri, 19 Nov 2021 17:17:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236369AbhKSQUC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Nov 2021 11:20:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236332AbhKSQUC (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Nov 2021 11:20:02 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8564C061574
        for <stable@vger.kernel.org>; Fri, 19 Nov 2021 08:17:00 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id y8so8504584plg.1
        for <stable@vger.kernel.org>; Fri, 19 Nov 2021 08:17:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=usWViYcCzWq+4eFNkCmatkBvFbU3RNEL7+YZbow3+zc=;
        b=MTALUAwzUdnK0Z5b5lVgWJgU6FzCgTzqcFTHahFtZm7OPQApKlWTZNVObBcZdNSRnV
         2Yse8yInV0FVgkF79OZMymK7DwbHqAXAwVQ7+uj+WXY+Z+pGBsUQYIT7JtusZLfJdEpF
         a7OlTvBu+zbNncabs+9IIufXtLeXyIR23TjCc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=usWViYcCzWq+4eFNkCmatkBvFbU3RNEL7+YZbow3+zc=;
        b=SjPvulMzLKEiJalT4pwDmn+oztM8MILoBuaStvmsxPrhNKuU0LPDebr1MI3jmca9II
         S8/j5PnTwJB8OvYe+/lxOn1NZxiF/960LJtY/5yOHEljxBGrOxRHTZkCBmtEuWLHacLl
         b18aRhSLEi/p0qrhe+sng6rOu+sOF7TbX1weesIB6AG8muA3/5/C4EiM2gVeM1jcmwcQ
         wy3LfRXHS4lsnpWKcX4D7/uBvtCx/7CG1XtLe7/LOqonBYeNa7rMxOct3yLNSPS29LF0
         2y/iH9Mj//txEyaPVR0I++tJXS34aimDSel8YubbYBKxvQzqwHeHoZAPfcE/jU4CQ3JB
         jm+Q==
X-Gm-Message-State: AOAM530qbXnTRgY2Beuo1bNrr/3lFgYUQQOKg6CFJwcjHtw9s26tl4fR
        fQbS2dhAXU0w0oGjUPqxvnWSzW8+pPX9zw==
X-Google-Smtp-Source: ABdhPJwDTwOHmvZNvmhYMtZtG/IekoV9obZXM4fOU/Lgx3Ml0lm+gtjzNOd7Y5hKxzPt0un1+dyuUw==
X-Received: by 2002:a17:902:f24a:b0:141:c6fc:2e18 with SMTP id j10-20020a170902f24a00b00141c6fc2e18mr79310972plc.55.1637338620272;
        Fri, 19 Nov 2021 08:17:00 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id j6sm125497pfu.205.2021.11.19.08.16.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Nov 2021 08:16:59 -0800 (PST)
Date:   Fri, 19 Nov 2021 08:16:59 -0800
From:   Kees Cook <keescook@chromium.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Nathan Chancellor <nathan@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        stable@vger.kernel.org, llvm@lists.linux.dev
Subject: Re: Apply a52f8a59aef46b59753e583bf4b28fccb069ce64 to 5.15 through
 4.19
Message-ID: <202111190808.1DA0067@keescook>
References: <YZKpVkYpYfYfHD50@archlinux-ax161>
 <YZeaCndfOGSZLHgX@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YZeaCndfOGSZLHgX@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Nov 19, 2021 at 01:35:22PM +0100, Greg Kroah-Hartman wrote:
> On Mon, Nov 15, 2021 at 11:39:18AM -0700, Nathan Chancellor wrote:
> > Hi Greg and Sasha,
> > 
> > There is a build error with newer versions of clang due to a broken
> > FORTIFY_SOURCE implementation, which has never worked:
> > 
> > https://github.com/ClangBuiltLinux/linux/issues/1496
> > https://github.com/ClangBuiltLinux/continuous-integration2/actions/runs/1457787760
> > 
> > Please apply upstream commit a52f8a59aef4 ("fortify: Explicitly disable
> > Clang support") to 5.15 through 4.19 to resolve this. It should apply
> > cleanly.
> 
> Hah!  Oh the Android people are going to _LOVE_ this one...

They (we) are already aware[1]. Fortify has always been broken under
Clang, so really this doesn't change anything for Android builds. :P

But yes, one of many motivations of the recent memcpy and fortify work
has been to get fortify fixed for Clang. Hopefully this will be all done
by 5.17.

-Kees

[1] https://github.com/KSPP/linux/issues/77

-- 
Kees Cook
