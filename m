Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 048422DEFE9
	for <lists+stable@lfdr.de>; Sat, 19 Dec 2020 14:57:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726484AbgLSN5h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 19 Dec 2020 08:57:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726483AbgLSN5h (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 19 Dec 2020 08:57:37 -0500
Received: from mail-ot1-x330.google.com (mail-ot1-x330.google.com [IPv6:2607:f8b0:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCD5EC0617B0
        for <stable@vger.kernel.org>; Sat, 19 Dec 2020 05:56:56 -0800 (PST)
Received: by mail-ot1-x330.google.com with SMTP id f16so4696284otl.11
        for <stable@vger.kernel.org>; Sat, 19 Dec 2020 05:56:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=muIF0dkPXlcTMoPOXXPeF48ACqKkYxRCfQUqmji15NY=;
        b=UdiL7XvjWlAKiGna+NrVE8MDcL7GDNOqAdhitE8RrVwycwqG1ptspcs0eKZWgpJO5y
         C6/8BRlLvzmgwrhVnjaX18m2XTlbg/b+JOca2XWLCd1X1If9nggnkdhhpClsi1mz2bsV
         8W86PXlBgtKsobKLk89jxescCJURIBEMyE4Oc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=muIF0dkPXlcTMoPOXXPeF48ACqKkYxRCfQUqmji15NY=;
        b=MWuvcnU/ESbgorBoTfH7WschsdIHuV7JGZqgy8LL6jD13CLmNJZfNzu//JX4vpL4up
         en9wvExI8xnxtZEdm/my2VnScfI5mEld4OqFIJOF3/EPBz6tEBvBRm7DHqT8sWrGrFtB
         KR9rsiYmkQo2Q31M+rkzv+Y5VALUExRhNoyiVDAzDYouw1GsXCyaRl+sTRSPoxtQZMqy
         4JTc3y1sFtbkotkOcsJiBp9tugwzl59KU6hhHWCMRVaC23h3iBkF1Kxw7qLk3sGhoyNc
         vVgAzJVO0ZAowaENkeIB279LNjaiC6YQaYgLYUb5Pt13olVNAYgWMYetenl0VaI+E0Lt
         o5kg==
X-Gm-Message-State: AOAM530RgAI8+ChwtNzE50TL1GHlkpKgzsqu3yVDzhg/hhqg1dq5ikjL
        mbHiWbzCyrXNn298QO7Gdori8kQUva205Q6TEjXBXw==
X-Google-Smtp-Source: ABdhPJyFl6c/VePWT2ln5cOf0t4QmHXlg+0pnoY/MVG/U08i/MTfoS11SuN3SOmCQ7Tpcg04QFaBBN5cjJm1R3HsJUw=
X-Received: by 2002:a05:6830:1bef:: with SMTP id k15mr6105528otb.303.1608386216142;
 Sat, 19 Dec 2020 05:56:56 -0800 (PST)
MIME-Version: 1.0
References: <CAKMK7uFUbZ53RCDrYPJpmxYjevSB11NSqRVLNSX+XbzrojxaeQ@mail.gmail.com>
 <X931U4HJVsA5jUx3@kroah.com>
In-Reply-To: <X931U4HJVsA5jUx3@kroah.com>
From:   Daniel Vetter <daniel.vetter@ffwll.ch>
Date:   Sat, 19 Dec 2020 14:56:44 +0100
Message-ID: <CAKMK7uHCcjphZvsaYw3d2fU2BTV2akPBxKHVHNoBUXBnUAKcTg@mail.gmail.com>
Subject: Re: Backport request
To:     Greg KH <greg@kroah.com>
Cc:     stable <stable@vger.kernel.org>,
        "Wilson, Chris" <chris@chris-wilson.co.uk>,
        Lionel Landwerlin <lionel.g.landwerlin@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Dec 19, 2020 at 1:41 PM Greg KH <greg@kroah.com> wrote:
>
> On Tue, Dec 15, 2020 at 05:02:41PM +0100, Daniel Vetter wrote:
> > Dear stable team (aka Greg)
> >
> > Please backport
> >
> > a04ac8273665 ("drm/i915/gt: Fixup tgl mocs for PTE tracking")
> >
> > Note that this needs
> >
> > 4d8a5cfe3b13 ("drm/i915/gt: Initialize reserved and unspecified MOCS indices")
> >
> > but that one has already a cc: stable, unfortunately the bugfix didn't.
>
> Backport to where exactly?
>
> These all seem to be in the 5.9.y tree already, do they need to go
> further back?

The 2nd one has cc: stable, so I worried that it might have escaped to
more kernels, whereas the first one does not have cc: stable. Maybe
the auto-stable picker has figured this out already (first patch does
thave the right Fixes: line), I just wanted to make sure we don't end
up with kernels with the broken in-between state.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
