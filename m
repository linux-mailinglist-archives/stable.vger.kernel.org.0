Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 323A029F3DE
	for <lists+stable@lfdr.de>; Thu, 29 Oct 2020 19:11:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725777AbgJ2SLv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Oct 2020 14:11:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725811AbgJ2SFN (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Oct 2020 14:05:13 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4587C0613CF
        for <stable@vger.kernel.org>; Thu, 29 Oct 2020 11:05:13 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id o3so2978055pgr.11
        for <stable@vger.kernel.org>; Thu, 29 Oct 2020 11:05:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5WJeTYznKfcfB3JkvqNmYT6rbBxdKza91BrDnR1e/Mc=;
        b=B2MvEPzxhqtGcbsSTSem6HuRhzfMyceEkgphM5QZMmFaGTqeV/4eruigN/cPhU2VLW
         SxOW2iOgPETEso1yTeji4s35kUm05eKBZ8XoWj7A7PRHRDZPw8izgH7PQRziCeb0wIDL
         qiJea85TFbcrw8b7fJBgLxTCJVEvhHR8wlmuX3WIlc342FoeoKpTkGcITIfsZTFXqcNA
         JP1uHMxL5lhKhg0+4kxqpaeJ4MgkKYoSi20nDYd/dPCDFP+l6EJnuN4nRMwzYllQT3WV
         O8v7fieYw+xFX5f2XBIqkFwY6exLTXAX4qMzIbB+ubSYrYnJZkPWeeqDCipRvmh+7Kce
         tHkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5WJeTYznKfcfB3JkvqNmYT6rbBxdKza91BrDnR1e/Mc=;
        b=olLCcHE1a9oI74OAaK19tsWzEHCn13KFY/HgOlHNEeslcV8iSvpxTFjHfECRpZavMc
         F1Q/XG0+aKk6alyaMlOCxknsbGBtiObTQZtBkO1IAH5WgQpfbmLBZrltVH1rELUboyjD
         CulcFmzP1jMT1xWlK3FtYfEZ+s3T1v6MWK+9IcxydWuu+eSIQKGXPXz7hQk5KFJz1e+7
         5cqoxPwM0w68hIGMuKPU1MYZ/8xonMqs8SIEYONYs5BKbuzEKO/5A9eOmCt/UEAU1t/8
         LpB4hu/T1tcYImu+q1GTShdod10W2Yj0m7nUQPIqgSJnHaAvDis7o3riZZ5P3RQ5PKPg
         VrZQ==
X-Gm-Message-State: AOAM530Z5+ptbC881/BvmLUyP57x+uxtRbkFXpazTdxOJNXZjgVNBrrR
        PPBrpAJlr3Fdu4UjeF6974h6zTOKVXVuvuVIN/wUqA==
X-Google-Smtp-Source: ABdhPJwuLjDN9Pda/MXaYjpZrnYx/BomxdJUIdOi5NVbjjlGO5NYLp9DAR01l5lvBtkmnem2h34FXqGQkCb9ARdAByM=
X-Received: by 2002:a62:5e06:0:b029:164:a9ca:b07e with SMTP id
 s6-20020a625e060000b0290164a9cab07emr5280171pfb.36.1603994712971; Thu, 29 Oct
 2020 11:05:12 -0700 (PDT)
MIME-Version: 1.0
References: <CA+SOCLLXnxcf=bTazCT1amY7B4_37HTEXL2OwHowVGCb8SLSQQ@mail.gmail.com>
 <20201029110153.GA3840801@kroah.com>
In-Reply-To: <20201029110153.GA3840801@kroah.com>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Thu, 29 Oct 2020 11:05:01 -0700
Message-ID: <CAKwvOdkQ5M+ujYZgg7T80W-uNgsn_mmv8R+-15HJjPoPDpES1Q@mail.gmail.com>
Subject: Re: Backport 44623b2818f4a442726639572f44fd9b6d0ef68c to kernel 5.4
To:     Jian Cai <jiancai@google.com>
Cc:     Sasha Levin <sashal@kernel.org>,
        "# 3.4.x" <stable@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Manoj Gupta <manojgupta@google.com>,
        Luis Lozano <llozano@google.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg KH <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 29, 2020 at 4:01 AM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Mon, Oct 26, 2020 at 06:17:00PM -0700, Jian Cai wrote:
> > Hello,
> >
> > I am working on assembling kernel 5.4 with LLVM's integrated assembler on
> > ChromeOS, and the following patch is required to make it work. Would you
> > please consider backporting it to 5.4?
> >
> >
> > commit 44623b2818f4a442726639572f44fd9b6d0ef68c
> > Author: Arnd Bergmann <arnd@arndb.de>
> > Date:   Wed May 27 16:17:40 2020 +0200
> >
> >     crypto: x86/crc32c - fix building with clang ias
> >
> > Link:
> > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=44623b2818f4a442726639572f44fd9b6d0ef68c
> >
>
> It does not apply cleanly, can you please provide a properly backported
> and tested version?

Hi Jian,
Thanks for proactively identifying and requesting a backport of
44623b2818.  We'll need it for Android as well soon.

One thing I do when requesting backports from stable is I checkout the
branch of the stable tree and see if the patch cherry picks cleanly.

stable is its own tree; you could add it as a remote or check out a
copy of it.  If you go to kernel.org, click any stable branch, go to
summary tab in top left, scroll down for the git url to clone.  Then
you can `git checkout -b linux-5.4.y origin/linux-5.4.y` to setup the
branch.  Fetch/pull so it's up to date, then `git cherry-pick -x
<sha>`. If it applies without conflict, you can simply send an email
as you've done.

If it does not, then you should fix up the conflict, and test it.
Then you add your signed off by tag (`git commit --amend -s`) and
sometime people leave a note like `[<initials>: had to drop a hunk
because a packport of <upstream sha> doesn't exist in this branch]`.
If you `git log` in a stable tree's branch, you should be able to see
examples.

Another thing I like to do is include comments (in the request email,
not the commit message of the patch) on my risk assessment and what
the first version of the mainline tree the patch landed in.  In a
mainline tree (not stable tree), I run this function I've added to my
shell's rc file:
first_tag () {
        tag=$1
        git describe --match 'v*' --contains "$tag" | sed 's/~.*//'
}

$ first_tag <sha>
That information can help the stable maintainers better assess the
risks in accepting the backport.  Though I'm not always great about
sticking to my own advice in this regard; the last request I made I
forgot to include info about the upstream version.  But
https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
doesn't mention that's actually necessary.

Anyways I'm sure you already knew most of the above; I don't mean to
patronize.  My apologies in that regard.  Having it typed out helps me
forward a URL to future travelers.
-- 
Thanks,
~Nick Desaulniers
